// Halaman 5: Statistik antrian.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/konfigurasi.dart';
import '../core/tema.dart';
import '../cubit/antrian_cubit.dart';
import '../widgets/kerangka_halaman.dart';
import '../widgets/komponen.dart';

/// Ringkasan angka dan grafik sederhana dari antrian hari ini.
class HalamanStatistik extends StatelessWidget {
  const HalamanStatistik({super.key});

  @override
  Widget build(BuildContext context) {
    return const KerangkaHalaman(
      judul: 'Statistik',
      rute: Konfigurasi.ruteStatistik,
      isi: _IsiStatistik(),
    );
  }
}

class _IsiStatistik extends StatelessWidget {
  const _IsiStatistik();

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return BlocBuilder<AntrianCubit, AntrianState>(
      builder: (context, s) {
        final tunggu = s.rataTunggu;
        final layanan = s.rataLayanan;
        final dasar = s.totalTercatat + s.jumlahBatal;
        final grafik = s.grafikAmbil;

        return PusatKonten(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 20, 32),
            children: [
              SusunanKolom(
                kolomLebar: 4,
                kolomSempit: 2,
                anak: [
                  KartuStat(
                    ikon: Icons.groups_rounded,
                    nilai: '${s.totalTercatat}',
                    label: 'Total Pembeli',
                  ),
                  KartuStat(
                    ikon: Icons.timer_outlined,
                    nilai: tunggu == null ? '-' : formatDurasi(tunggu),
                    label: 'Rata-rata Menunggu',
                  ),
                  KartuStat(
                    ikon: Icons.support_agent_rounded,
                    nilai: layanan == null ? '-' : formatDurasi(layanan),
                    label: 'Rata-rata Layanan',
                  ),
                  KartuStat(
                    ikon: Icons.cancel_outlined,
                    nilai: '${s.jumlahBatal}',
                    label: 'Dibatalkan',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Kartu(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Komposisi Antrian',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: skema.onSurface,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _BarisKomposisi(
                      label: 'Selesai',
                      jumlah: s.selesai.length,
                      total: dasar,
                      warna: skema.primary,
                    ),
                    _BarisKomposisi(
                      label: 'Sedang dilayani',
                      jumlah: s.sedangDilayani == null ? 0 : 1,
                      total: dasar,
                      warna: skema.tertiary,
                    ),
                    _BarisKomposisi(
                      label: 'Menunggu',
                      jumlah: s.jumlahMenunggu,
                      total: dasar,
                      warna: warnaKuning,
                    ),
                    _BarisKomposisi(
                      label: 'Dibatalkan',
                      jumlah: s.jumlahBatal,
                      total: dasar,
                      warna: skema.error,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Kartu(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      grafik.kosong
                          ? 'Nomor Diambil'
                          : 'Nomor Diambil per ${grafik.perJam ? 'Jam' : '${grafik.menitPerBatang} Menit'}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: skema.onSurface,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _GrafikAmbil(grafik: grafik),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BarisKomposisi extends StatelessWidget {
  const _BarisKomposisi({
    required this.label,
    required this.jumlah,
    required this.total,
    required this.warna,
  });

  final String label;
  final int jumlah;
  final int total;
  final Color warna;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    final nilai = total == 0 ? 0.0 : jumlah / total;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 118,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: skema.onSurface,
              ),
            ),
          ),
          Expanded(child: BatangProgres(nilai: nilai, warna: warna)),
          SizedBox(
            width: 38,
            child: Text(
              '$jumlah',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w900,
                color: skema.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Mengubah menit sejak tengah malam menjadi teks jam, misalnya "08:05".
String _jamMenit(int menit) =>
    '${duaDigit((menit ~/ 60) % 24)}:${duaDigit(menit % 60)}';

/// Grafik batang jumlah nomor yang diambil, tanpa paket tambahan. Batang
/// tersibuk disorot kuning, dan di bawah grafik ada ringkasan totalnya.
class _GrafikAmbil extends StatelessWidget {
  const _GrafikAmbil({required this.grafik});

  final GrafikAmbil grafik;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    if (grafik.kosong) {
      return const InfoKosong(
        ikon: Icons.bar_chart_rounded,
        teks: 'Grafik akan muncul setelah ada nomor yang diambil.',
      );
    }

    final langkah = grafik.menitPerBatang;
    final awal = grafik.awalPertama;
    final jumlahBatang = grafik.jumlahBatang;
    final nilaiMaks = grafik.nilaiMaks;
    final tersibuk = grafik.awalTersibuk;
    // Label waktu ditampilkan berselang agar tidak berdesakan.
    final selang = (jumlahBatang / 8).ceil();
    final satuan = grafik.perJam ? '1 jam' : '$langkah menit';
    String rentang(int mulai) =>
        '${_jamMenit(mulai)}-${_jamMenit(mulai + langkah)}';
    final gayaKecil = TextStyle(
      fontSize: 12.5,
      fontWeight: FontWeight.w600,
      color: alfa(skema.onSurface, 0.8),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tiap batang menunjukkan jumlah nomor yang diambil dalam $satuan.',
          style: gayaKecil,
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 150,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < jumlahBatang; i++)
                Expanded(
                  child: _BatangAmbil(
                    nilai: grafik.jumlah[awal + i * langkah] ?? 0,
                    nilaiMaks: nilaiMaks,
                    menonjol: awal + i * langkah == tersibuk,
                    keterangan:
                    '${rentang(awal + i * langkah)}: '
                        '${grafik.jumlah[awal + i * langkah] ?? 0} nomor',
                    label: i % selang != 0
                        ? ''
                        : grafik.perJam
                        ? duaDigit(((awal + i * langkah) ~/ 60) % 24)
                        : _jamMenit(awal + i * langkah),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 18,
          runSpacing: 8,
          children: [
            Text('Total ${grafik.total} nomor diambil', style: gayaKecil),
            if (tersibuk != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: warnaKuning,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: tinta(skema),
                        width: tebalGaris,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tersibuk: ${rentang(tersibuk)} '
                        '(${grafik.jumlah[tersibuk]} nomor)',
                    style: gayaKecil,
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class _BatangAmbil extends StatelessWidget {
  const _BatangAmbil({
    required this.nilai,
    required this.nilaiMaks,
    required this.menonjol,
    required this.keterangan,
    required this.label,
  });

  final int nilai;
  final int nilaiMaks;
  final bool menonjol;
  final String keterangan;
  final String label;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    final proporsi = nilaiMaks == 0 ? 0.0 : 100.0 * nilai / nilaiMaks;
    final tinggi = nilai == 0 ? 4.0 : (proporsi < 10.0 ? 10.0 : proporsi);
    final warna = nilai == 0
        ? tinta(skema)
        : (menonjol ? warnaKuning : skema.primary);

    return Tooltip(
      message: keterangan,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (nilai > 0)
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '$nilai',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: skema.onSurface,
                ),
              ),
            ),
          const SizedBox(height: 4),
          // Lebar batang dibatasi agar satu batang tunggal tidak melebar penuh.
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 56),
            child: Container(
              height: tinggi,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: warna,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: tinta(skema), width: tebalGaris),
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 14,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: alfa(skema.onSurface, 0.8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
