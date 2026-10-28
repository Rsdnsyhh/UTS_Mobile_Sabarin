// Konfigurasi aplikasi, fungsi pemformat, dan daftar menu navigasi.

import 'package:flutter/material.dart';

/// Nilai-nilai tetap aplikasi dikumpulkan di satu tempat agar mudah diubah.
class Konfigurasi {
  static const String namaAplikasi = 'Sabarin';
  static const String tagline = 'Hitung antrian pembeli';
  static const String versi = 'Versi 1.1.0';

  static const String awalanNomor = 'A';
  static const int nomorMaksimal = 999;
  static const int menitPerPembeli = 3;
  static const int batasTampilSelesai = 30;

  /// Grafik pengambilan nomor: bila seluruh nomor diambil dalam rentang
  /// [batasRentangGrafik] menit, batang dibuat per [menitBatangGrafik] menit;
  /// bila lebih lama, batang dibuat per jam.
  static const int menitBatangGrafik = 5;
  static const int batasRentangGrafik = 90;

  static const String ruteBeranda = '/';
  static const String ruteAntrian = '/antrian';
  static const String ruteLayar = '/layar';
  static const String ruteRiwayat = '/riwayat';
  static const String ruteStatistik = '/statistik';
  static const String ruteTentang = '/tentang';

  /// Lebar layar (dp) mulai dari mana menu samping dipasang permanen.
  static const double batasLebar = 900;
}

/// Mengubah angka 7 menjadi format nomor antrian "A-007".
String formatNomor(int nomor) =>
    '${Konfigurasi.awalanNomor}-${nomor.toString().padLeft(3, '0')}';

/// Membatasi sebuah bilangan agar tetap berada di antara [bawah] dan [atas].
int batasi(int nilai, int bawah, int atas) {
  if (nilai < bawah) return bawah;
  if (nilai > atas) return atas;
  return nilai;
}

/// Dua digit dengan nol di depan, misalnya 7 menjadi "07".
String duaDigit(int nilai) => nilai.toString().padLeft(2, '0');

/// Format jam "09:05:30".
String formatJam(DateTime waktu) =>
    '${duaDigit(waktu.hour)}:${duaDigit(waktu.minute)}:${duaDigit(waktu.second)}';

/// Format lama waktu yang mudah dibaca, misalnya "2 mnt 15 dtk".
String formatDurasi(Duration durasi) {
  final total = durasi.inSeconds < 0 ? 0 : durasi.inSeconds;
  final menit = total ~/ 60;
  final detik = total % 60;
  if (menit == 0) return '$detik dtk';
  if (detik == 0) return '$menit mnt';
  return '$menit mnt $detik dtk';
}

/// Satu entri menu pada Drawer.
class ItemNavigasi {
  const ItemNavigasi(this.rute, this.label, this.ikon, this.ikonAktif);

  final String rute;
  final String label;
  final IconData ikon;
  final IconData ikonAktif;
}

/// Daftar halaman. Menambah halaman baru cukup menambah satu baris di sini
/// dan satu case pada fungsi bangunHalaman.
const List<ItemNavigasi> daftarMenu = [
  ItemNavigasi(Konfigurasi.ruteBeranda, 'Beranda', Icons.home_outlined,
      Icons.home_rounded),
  ItemNavigasi(Konfigurasi.ruteAntrian, 'Hitung Antrian',
      Icons.groups_outlined, Icons.groups_rounded),
  ItemNavigasi(Konfigurasi.ruteLayar, 'Layar Pelanggan', Icons.tv_outlined,
      Icons.tv_rounded),
  ItemNavigasi(Konfigurasi.ruteRiwayat, 'Riwayat', Icons.history,
      Icons.history_rounded),
  ItemNavigasi(Konfigurasi.ruteStatistik, 'Statistik', Icons.bar_chart,
      Icons.bar_chart_rounded),
  ItemNavigasi(Konfigurasi.ruteTentang, 'Tentang', Icons.info_outline_rounded,
      Icons.info_rounded),
];

/// Pindah ke halaman lain tanpa menumpuk rute.
void bukaHalaman(BuildContext context, String rute) {
  Navigator.of(context).pushNamedAndRemoveUntil(rute, (_) => false);
}
