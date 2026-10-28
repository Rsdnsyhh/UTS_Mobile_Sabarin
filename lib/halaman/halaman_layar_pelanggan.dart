// Halaman 3: Layar Pelanggan (tanpa AppBar dan Drawer).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/konfigurasi.dart';
import '../core/tema.dart';
import '../cubit/antrian_cubit.dart';
import '../widgets/komponen.dart';

/// Tampilan khusus pembeli. Halaman ini sengaja tidak memiliki AppBar maupun
/// Drawer agar pembeli tidak dapat membuka menu penjual. Penjual kembali
/// dengan menekan tombol panah kembali di pojok kanan atas.
class HalamanLayarPelanggan extends StatelessWidget {
  const HalamanLayarPelanggan({super.key});

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: LatarHias()),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 12, 0),
                  child: Row(
                    children: [
                      const LogoSabarin(ukuran: 36),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          Konfigurasi.namaAplikasi,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: skema.onSurface,
                          ),
                        ),
                      ),
                      const _TombolKembaliPenjual(),
                    ],
                  ),
                ),
                const Expanded(child: _IsiLayarPelanggan()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tombol kembali untuk penjual: cukup sekali ketuk.
class _TombolKembaliPenjual extends StatelessWidget {
  const _TombolKembaliPenjual();

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return Tooltip(
      message: 'Kembali',
      child: Container(
        margin: const EdgeInsets.only(right: 4, bottom: 4),
        decoration: dekorasiNeo(
          skema,
          warna: warnaKartu(skema, 0),
          radius: 14,
          jarak: 3,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => bukaHalaman(context, Konfigurasi.ruteAntrian),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 22,
                color: skema.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IsiLayarPelanggan extends StatelessWidget {
  const _IsiLayarPelanggan();

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return BlocBuilder<AntrianCubit, AntrianState>(
      builder: (context, s) {
        final berikutnya = s.menunggu.take(6).toList();
        final sisa = s.menunggu.length - berikutnya.length;

        return PusatKonten(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 20, 32),
            children: [
              KartuDilayani(
                nomor: s.sedangDilayani,
                judul: 'NOMOR ANTRIAN SAAT INI',
                ukuranNomor: 112,
                vertikal: 44,
              ),
              const SizedBox(height: 20),
              Kartu(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Antrian Berikutnya',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: skema.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (berikutnya.isEmpty)
                      const InfoKosong(
                        ikon: Icons.event_seat_outlined,
                        teks: 'Tidak ada antrian saat ini.',
                      )
                    else
                      Wrap(
                        spacing: 10,
                        runSpacing: 12,
                        children: [
                          for (var i = 0; i < berikutnya.length; i++)
                            LencanaNomor(
                              teks: formatNomor(berikutnya[i]),
                              ikon: i == 0
                                  ? Icons.bolt_rounded
                                  : Icons.person_rounded,
                              latar: i == 0
                                  ? skema.primary
                                  : warnaKartu(skema, 0.06),
                              isi: i == 0
                                  ? teksDi(skema.primary)
                                  : skema.onSurface,
                              garis: tinta(skema),
                            ),
                        ],
                      ),
                    if (sisa > 0) ...[
                      const SizedBox(height: 12),
                      Text(
                        '+$sisa pembeli lainnya sedang menunggu',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: alfa(skema.onSurface, 0.75),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Kartu(
                padding: const EdgeInsets.all(16),
                warna: warnaKuning,
                child: Row(
                  children: [
                    const Icon(
                      Icons.hourglass_bottom_rounded,
                      color: Color(0xFF141414),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        s.jumlahMenunggu == 0
                            ? 'Silakan langsung menuju kasir.'
                            : '${s.jumlahMenunggu} orang menunggu, estimasi '
                            'sekitar ${s.estimasiMenit} menit.',
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF141414),
                        ),
                      ),
                    ),
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
