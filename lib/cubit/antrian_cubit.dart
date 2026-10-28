// State dan Cubit logika antrian: ambil, panggil, batal, dan reset.

import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/konfigurasi.dart';

enum JenisPesan { sukses, info, galat }

/// Pesan singkat untuk pengguna. [id] dipakai agar pesan yang sama
/// tetap dianggap baru dan bisa ditampilkan ulang.
class Pesan {
  const Pesan(this.id, this.teks, this.jenis);

  final int id;
  final String teks;
  final JenisPesan jenis;
}

/// Catatan satu pembeli yang sudah dipanggil. Menjadi dasar halaman
/// Riwayat dan Statistik.
class CatatanLayanan {
  const CatatanLayanan({
    required this.nomor,
    required this.waktuAmbil,
    required this.waktuPanggil,
    this.waktuSelesai,
  });

  final int nomor;
  final DateTime waktuAmbil;
  final DateTime waktuPanggil;
  final DateTime? waktuSelesai;

  bool get sudahSelesai => waktuSelesai != null;

  /// Selisih antara jam ambil nomor dan jam dipanggil.
  Duration get lamaTunggu => waktuPanggil.difference(waktuAmbil);

  /// Selisih antara jam dipanggil dan jam selesai (kosong jika belum selesai).
  Duration? get lamaLayanan {
    final selesai = waktuSelesai;
    return selesai == null ? null : selesai.difference(waktuPanggil);
  }

  CatatanLayanan ditutupPada(DateTime waktu) => CatatanLayanan(
    nomor: nomor,
    waktuAmbil: waktuAmbil,
    waktuPanggil: waktuPanggil,
    waktuSelesai: waktu,
  );
}

/// Data grafik pengambilan nomor. Nomor dikelompokkan per [menitPerBatang]
/// menit. Kunci [jumlah] adalah menit sejak tengah malam pada awal batang.
class GrafikAmbil {
  const GrafikAmbil({required this.menitPerBatang, required this.jumlah});

  final int menitPerBatang;
  final Map<int, int> jumlah;

  bool get kosong => jumlah.isEmpty;
  bool get perJam => menitPerBatang >= 60;

  int get total {
    var hasil = 0;
    for (final nilai in jumlah.values) {
      hasil += nilai;
    }
    return hasil;
  }

  int get awalPertama => jumlah.keys.reduce((a, b) => a < b ? a : b);
  int get awalTerakhir => jumlah.keys.reduce((a, b) => a > b ? a : b);
  int get nilaiMaks => jumlah.values.reduce((a, b) => a > b ? a : b);

  /// Banyak batang dari batang pertama sampai terakhir, termasuk yang kosong.
  int get jumlahBatang => (awalTerakhir - awalPertama) ~/ menitPerBatang + 1;

  /// Awal batang tersibuk. Kosong bila hanya ada satu batang atau bila
  /// seluruh batang sama tinggi, karena tidak ada yang perlu disorot.
  int? get awalTersibuk {
    if (jumlah.length < 2) return null;
    final maks = nilaiMaks;
    final semuaSama =
        jumlah.length == jumlahBatang && jumlah.values.every((n) => n == maks);
    if (semuaSama) return null;
    final urut = jumlah.keys.toList()..sort();
    for (final awal in urut) {
      if (jumlah[awal] == maks) return awal;
    }
    return null;
  }
}

/// State antrian. Seluruh list diperlakukan sebagai data yang tidak diubah langsung.
class AntrianState {
  const AntrianState({
    this.nomorTerakhir = 0,
    this.sedangDilayani,
    this.menunggu = const [],
    this.selesai = const [],
    this.riwayat = const [],
    this.waktuAmbil = const {},
    this.jumlahBatal = 0,
    this.pesan,
  });

  final int nomorTerakhir;
  final int? sedangDilayani;
  final List<int> menunggu;
  final List<int> selesai;

  /// Seluruh nomor yang pernah dipanggil, urut dari yang paling awal.
  final List<CatatanLayanan> riwayat;

  /// Jam pengambilan nomor untuk pembeli yang masih menunggu.
  final Map<int, DateTime> waktuAmbil;

  final int jumlahBatal;
  final Pesan? pesan;

  int get jumlahMenunggu => menunggu.length;
  int get estimasiMenit => menunggu.length * Konfigurasi.menitPerPembeli;

  bool get kosong =>
      nomorTerakhir == 0 &&
          sedangDilayani == null &&
          menunggu.isEmpty &&
          selesai.isEmpty &&
          jumlahBatal == 0;

  /// Jumlah seluruh pembeli yang masih tercatat pada antrian hari ini.
  int get totalTercatat =>
      menunggu.length + selesai.length + (sedangDilayani == null ? 0 : 1);

  /// Rata-rata lama menunggu (kosong jika belum ada yang dipanggil).
  Duration? get rataTunggu {
    if (riwayat.isEmpty) return null;
    var total = 0;
    for (final catatan in riwayat) {
      total += catatan.lamaTunggu.inSeconds;
    }
    return Duration(seconds: total ~/ riwayat.length);
  }

  /// Rata-rata lama pelayanan (hanya dari pembeli yang sudah selesai).
  Duration? get rataLayanan {
    var total = 0;
    var jumlah = 0;
    for (final catatan in riwayat) {
      final lama = catatan.lamaLayanan;
      if (lama != null) {
        total += lama.inSeconds;
        jumlah++;
      }
    }
    return jumlah == 0 ? null : Duration(seconds: total ~/ jumlah);
  }

  /// Jumlah nomor yang diambil, dikelompokkan mengikuti rentang datanya:
  /// per beberapa menit bila seluruh nomor diambil dalam waktu singkat,
  /// atau per jam bila lebih lama.
  GrafikAmbil get grafikAmbil {
    final menit = <int>[];
    for (final catatan in riwayat) {
      menit.add(catatan.waktuAmbil.hour * 60 + catatan.waktuAmbil.minute);
    }
    for (final nomor in menunggu) {
      final waktu = waktuAmbil[nomor];
      if (waktu != null) menit.add(waktu.hour * 60 + waktu.minute);
    }
    if (menit.isEmpty) {
      return const GrafikAmbil(menitPerBatang: 60, jumlah: {});
    }

    var terkecil = menit.first;
    var terbesar = menit.first;
    for (final nilai in menit) {
      if (nilai < terkecil) terkecil = nilai;
      if (nilai > terbesar) terbesar = nilai;
    }
    final langkah = (terbesar - terkecil) <= Konfigurasi.batasRentangGrafik
        ? Konfigurasi.menitBatangGrafik
        : 60;

    final hasil = <int, int>{};
    for (final nilai in menit) {
      final awal = (nilai ~/ langkah) * langkah;
      hasil[awal] = (hasil[awal] ?? 0) + 1;
    }
    return GrafikAmbil(menitPerBatang: langkah, jumlah: hasil);
  }

  AntrianState copyWith({
    int? nomorTerakhir,
    int? sedangDilayani,
    bool kosongkanDilayani = false,
    List<int>? menunggu,
    List<int>? selesai,
    List<CatatanLayanan>? riwayat,
    Map<int, DateTime>? waktuAmbil,
    int? jumlahBatal,
    Pesan? pesan,
  }) {
    return AntrianState(
      nomorTerakhir: nomorTerakhir ?? this.nomorTerakhir,
      sedangDilayani:
      kosongkanDilayani ? null : (sedangDilayani ?? this.sedangDilayani),
      menunggu: menunggu ?? this.menunggu,
      selesai: selesai ?? this.selesai,
      riwayat: riwayat ?? this.riwayat,
      waktuAmbil: waktuAmbil ?? this.waktuAmbil,
      jumlahBatal: jumlahBatal ?? this.jumlahBatal,
      pesan: pesan ?? this.pesan,
    );
  }
}

/// Logika antrian. Setiap method dibungkus try-catch dan memeriksa
/// kondisi terlebih dahulu sehingga aplikasi tidak mudah gagal.
class AntrianCubit extends Cubit<AntrianState> {
  AntrianCubit() : super(const AntrianState());

  int _penghitungPesan = 0;

  Pesan _buatPesan(String teks, JenisPesan jenis) =>
      Pesan(++_penghitungPesan, teks, jenis);

  /// Mengirim state baru dengan aman (tidak emit jika Cubit sudah ditutup).
  void _kirim(AntrianState baru, String teks, JenisPesan jenis) {
    if (isClosed) return;
    emit(baru.copyWith(pesan: _buatPesan(teks, jenis)));
  }

  void _kirimGalatUmum() {
    _kirim(state, 'Terjadi kendala. Silakan coba lagi.', JenisPesan.galat);
  }

  /// Mengisi jam selesai pada catatan milik [nomor] yang belum selesai.
  List<CatatanLayanan> _tutupCatatan(int nomor, DateTime waktu) {
    return [
      for (final catatan in state.riwayat)
        if (catatan.nomor == nomor && !catatan.sudahSelesai)
          catatan.ditutupPada(waktu)
        else
          catatan,
    ];
  }

  /// Mengambil nomor baru dan memasukkannya ke daftar menunggu.
  void ambilNomor() {
    try {
      if (state.nomorTerakhir >= Konfigurasi.nomorMaksimal) {
        _kirim(
          state,
          'Nomor sudah mencapai batas ${Konfigurasi.nomorMaksimal}. '
              'Silakan reset antrian.',
          JenisPesan.galat,
        );
        return;
      }
      final nomorBaru = state.nomorTerakhir + 1;
      _kirim(
        state.copyWith(
          nomorTerakhir: nomorBaru,
          menunggu: [...state.menunggu, nomorBaru],
          waktuAmbil: {...state.waktuAmbil, nomorBaru: DateTime.now()},
        ),
        'Nomor ${formatNomor(nomorBaru)} berhasil diambil.',
        JenisPesan.sukses,
      );
    } catch (_) {
      _kirimGalatUmum();
    }
  }

  /// Memanggil pembeli berikutnya. Nomor yang sebelumnya dilayani
  /// dipindahkan ke daftar selesai dan jam selesainya dicatat.
  void panggilBerikutnya() {
    try {
      final sekarang = DateTime.now();
      final lama = state.sedangDilayani;

      if (state.menunggu.isEmpty) {
        if (lama == null) {
          _kirim(state, 'Belum ada pembeli yang menunggu.', JenisPesan.galat);
          return;
        }
        // Tidak ada antrian lagi, layanan terakhir ditandai selesai.
        _kirim(
          state.copyWith(
            kosongkanDilayani: true,
            selesai: [...state.selesai, lama],
            riwayat: _tutupCatatan(lama, sekarang),
          ),
          'Layanan ${formatNomor(lama)} selesai. Antrian sudah kosong.',
          JenisPesan.info,
        );
        return;
      }

      final berikutnya = state.menunggu.first;
      final sisa = state.menunggu.sublist(1);
      final selesaiBaru = lama == null ? state.selesai : [...state.selesai, lama];
      final riwayatLama =
      lama == null ? state.riwayat : _tutupCatatan(lama, sekarang);
      final waktuNomor = state.waktuAmbil[berikutnya] ?? sekarang;
      final petaBaru = Map<int, DateTime>.from(state.waktuAmbil)
        ..remove(berikutnya);

      _kirim(
        state.copyWith(
          sedangDilayani: berikutnya,
          menunggu: sisa,
          selesai: selesaiBaru,
          waktuAmbil: petaBaru,
          riwayat: [
            ...riwayatLama,
            CatatanLayanan(
              nomor: berikutnya,
              waktuAmbil: waktuNomor,
              waktuPanggil: sekarang,
            ),
          ],
        ),
        'Memanggil nomor ${formatNomor(berikutnya)}.',
        JenisPesan.info,
      );
    } catch (_) {
      _kirimGalatUmum();
    }
  }

  /// Membatalkan nomor terakhir yang masih menunggu.
  void batalkanTerakhir() {
    try {
      if (state.menunggu.isEmpty) {
        _kirim(
          state,
          'Tidak ada nomor menunggu yang bisa dibatalkan.',
          JenisPesan.galat,
        );
        return;
      }
      final dibatalkan = state.menunggu.last;
      final sisa = state.menunggu.sublist(0, state.menunggu.length - 1);
      // Jika yang dibatalkan adalah nomor paling baru, nomornya dipakai ulang.
      final terakhirBaru = dibatalkan == state.nomorTerakhir
          ? state.nomorTerakhir - 1
          : state.nomorTerakhir;
      final petaBaru = Map<int, DateTime>.from(state.waktuAmbil)
        ..remove(dibatalkan);

      _kirim(
        state.copyWith(
          nomorTerakhir: terakhirBaru,
          menunggu: sisa,
          waktuAmbil: petaBaru,
          jumlahBatal: state.jumlahBatal + 1,
        ),
        'Nomor ${formatNomor(dibatalkan)} dibatalkan.',
        JenisPesan.info,
      );
    } catch (_) {
      _kirimGalatUmum();
    }
  }

  /// Mengosongkan seluruh antrian beserta riwayat dan statistiknya.
  void reset() {
    try {
      if (state.kosong) {
        _kirim(state, 'Antrian masih kosong.', JenisPesan.info);
        return;
      }
      _kirim(const AntrianState(), 'Antrian berhasil direset.', JenisPesan.sukses);
    } catch (_) {
      _kirimGalatUmum();
    }
  }
}
