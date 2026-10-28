// Halaman 6: Tentang aplikasi.

import 'package:flutter/material.dart';
import '../core/konfigurasi.dart';
import '../core/tema.dart';
import '../widgets/kerangka_halaman.dart';
import '../widgets/komponen.dart';

class HalamanTentang extends StatelessWidget {
  const HalamanTentang({super.key});

  @override
  Widget build(BuildContext context) {
    return const KerangkaHalaman(
      judul: 'Tentang',
      rute: Konfigurasi.ruteTentang,
      isi: _IsiTentang(),
    );
  }
}

class _IsiTentang extends StatelessWidget {
  const _IsiTentang();

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    const fitur = [
      'Ambil, panggil, dan batalkan nomor antrian',
      'Layar pelanggan berukuran besar',
      'Riwayat dan statistik pelayanan',
      'Mode gelap dan delapan warna tema',
    ];
    const teknologi = ['Flutter', 'Material 3', 'Cubit (flutter_bloc)', 'CustomPainter'];

    return PusatKonten(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 20, 32),
        children: [
          Kartu(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const LogoSabarin(ukuran: 88),
                const SizedBox(height: 16),
                Text(
                  Konfigurasi.namaAplikasi,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: skema.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  Konfigurasi.versi,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: alfa(skema.onSurface, 0.7),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Aplikasi untuk mencatat dan memanggil antrian pembeli '
                      'dengan tertib, sehingga penjual dan pembeli dapat '
                      'menjalani antrian dengan tenang.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.5,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                    color: alfa(skema.onSurface, 0.85),
                  ),
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
                  'Fitur Utama',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: skema.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                for (final butir in fitur)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 20,
                          color: skema.onSurface,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            butir,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
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
                  'Teknologi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: skema.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 12,
                  children: [
                    for (final nama in teknologi)
                      LencanaNomor(
                        teks: nama,
                        ikon: Icons.code_rounded,
                        latar: skema.secondaryContainer,
                        isi: skema.onSecondaryContainer,
                        garis: tinta(skema),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
