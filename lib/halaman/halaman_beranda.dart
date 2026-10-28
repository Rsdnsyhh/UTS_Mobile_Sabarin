// Halaman 1: Beranda.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/konfigurasi.dart';
import '../core/tema.dart';
import '../cubit/antrian_cubit.dart';
import '../widgets/kerangka_halaman.dart';
import '../widgets/komponen.dart';

class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({super.key});

  @override
  Widget build(BuildContext context) {
    return const KerangkaHalaman(
      judul: 'Beranda',
      rute: Konfigurasi.ruteBeranda,
      isi: _IsiBeranda(),
    );
  }
}

/// Salam sesuai waktu setempat.
String salamWaktu(DateTime sekarang) {
  final jam = sekarang.hour;
  if (jam < 11) return 'Selamat pagi';
  if (jam < 15) return 'Selamat siang';
  if (jam < 18) return 'Selamat sore';
  return 'Selamat malam';
}

class _IsiBeranda extends StatelessWidget {
  const _IsiBeranda();

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return PusatKonten(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 20, 32),
        children: [
          const _KartuSambutan(),
          const SizedBox(height: 20),
          BlocBuilder<AntrianCubit, AntrianState>(
            builder: (context, s) {
              return SusunanKolom(
                kolomLebar: 4,
                kolomSempit: 2,
                anak: [
                  KartuStat(
                    ikon: Icons.confirmation_number_rounded,
                    nilai: '${s.nomorTerakhir}',
                    label: 'Nomor Diambil',
                  ),
                  KartuStat(
                    ikon: Icons.record_voice_over_rounded,
                    nilai: s.sedangDilayani == null
                        ? '-'
                        : formatNomor(s.sedangDilayani!),
                    label: 'Sedang Dilayani',
                  ),
                  KartuStat(
                    ikon: Icons.hourglass_bottom_rounded,
                    nilai: '${s.jumlahMenunggu}',
                    label: 'Menunggu',
                  ),
                  KartuStat(
                    ikon: Icons.task_alt_rounded,
                    nilai: '${s.selesai.length}',
                    label: 'Selesai Dilayani',
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          const _KartuProgres(),
          const SizedBox(height: 28),
          Text(
            'Menu Pintas',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: skema.onSurface,
            ),
          ),
          const SizedBox(height: 14),
          const SusunanKolom(
            kolomLebar: 3,
            kolomSempit: 1,
            anak: [
              _KartuPintas(
                ikon: Icons.tv_rounded,
                judul: 'Layar Pelanggan',
                isi: 'Nomor besar untuk dilihat pembeli.',
                rute: Konfigurasi.ruteLayar,
              ),
              _KartuPintas(
                ikon: Icons.history_rounded,
                judul: 'Riwayat',
                isi: 'Jam dan lama layanan tiap nomor.',
                rute: Konfigurasi.ruteRiwayat,
              ),
              _KartuPintas(
                ikon: Icons.bar_chart_rounded,
                judul: 'Statistik',
                isi: 'Rata-rata waktu dan grafik pengambilan nomor.',
                rute: Konfigurasi.ruteStatistik,
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            'Cara Menggunakan',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: skema.onSurface,
            ),
          ),
          const SizedBox(height: 14),
          const SusunanKolom(
            kolomLebar: 3,
            kolomSempit: 1,
            anak: [
              _LangkahPakai(
                nomor: '1',
                judul: 'Ambil nomor',
                isi: 'Tekan Ambil Nomor setiap ada pembeli baru yang datang.',
              ),
              _LangkahPakai(
                nomor: '2',
                judul: 'Panggil pembeli',
                isi: 'Tekan Panggil Berikutnya untuk melayani nomor terdepan.',
              ),
              _LangkahPakai(
                nomor: '3',
                judul: 'Pantau antrian',
                isi: 'Lihat daftar menunggu dan yang sudah dilayani secara langsung.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KartuSambutan extends StatelessWidget {
  const _KartuSambutan();

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    final warnaTeks = teksDi(skema.primary);
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: dekorasiNeo(
        skema,
        warna: skema.primary,
        radius: 28,
        jarak: 6,
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: alfa(warnaTeks, 0.12),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -50,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: alfa(warnaKuning, 0.9),
                border: Border.all(color: tinta(skema), width: tebalGaris),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const LogoSabarin(ukuran: 54, terbalik: true),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${salamWaktu(DateTime.now())},',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: alfa(warnaTeks, 0.95),
                            ),
                          ),
                          Text(
                            'Selamat datang di ${Konfigurasi.namaAplikasi}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: warnaTeks,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Catat, panggil, dan pantau antrian pembeli dengan rapi. '
                      'Tidak ada nomor yang terlewat, tidak ada pembeli yang '
                      'menunggu tanpa kepastian.',
                  style: TextStyle(
                    fontSize: 14.5,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                    color: alfa(warnaTeks, 0.95),
                  ),
                ),
                const SizedBox(height: 18),
                TombolNeo(
                  penuh: false,
                  warna: warnaKartu(skema, 0),
                  ikon: Icons.arrow_forward_rounded,
                  label: 'Mulai Hitung Antrian',
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil(
                    Konfigurasi.ruteAntrian,
                        (_) => false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KartuProgres extends StatelessWidget {
  const _KartuProgres();

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return BlocBuilder<AntrianCubit, AntrianState>(
      builder: (context, s) {
        final total = s.totalTercatat;
        final nilai = total == 0 ? 0.0 : s.selesai.length / total;
        final persen = (nilai * 100).round();
        return Kartu(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Progres Pelayanan',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: skema.onSurface,
                      ),
                    ),
                  ),
                  Text(
                    '$persen%',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: skema.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              BatangProgres(nilai: nilai, warna: skema.primary, tinggi: 18),
              const SizedBox(height: 10),
              Text(
                total == 0
                    ? 'Belum ada antrian hari ini.'
                    : '${s.selesai.length} dari $total pembeli sudah selesai dilayani.',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: alfa(skema.onSurface, 0.75),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _KartuPintas extends StatelessWidget {
  const _KartuPintas({
    required this.ikon,
    required this.judul,
    required this.isi,
    required this.rute,
  });

  final IconData ikon;
  final String judul;
  final String isi;
  final String rute;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => bukaHalaman(context, rute),
        child: Kartu(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: dekorasiNeo(
                  skema,
                  warna: skema.primaryContainer,
                  radius: 14,
                  jarak: 0,
                ),
                child: Icon(ikon, color: skema.onPrimaryContainer),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      judul,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: skema.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isi,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: alfa(skema.onSurface, 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: skema.onSurface,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LangkahPakai extends StatelessWidget {
  const _LangkahPakai({
    required this.nomor,
    required this.judul,
    required this.isi,
  });

  final String nomor;
  final String judul;
  final String isi;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return Kartu(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: skema.primary,
              shape: BoxShape.circle,
              border: Border.all(color: tinta(skema), width: tebalGaris),
            ),
            child: Text(
              nomor,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: teksDi(skema.primary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: skema.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isi,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: alfa(skema.onSurface, 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
