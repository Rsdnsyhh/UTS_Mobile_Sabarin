// Halaman 4: Riwayat pelayanan.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/konfigurasi.dart';
import '../core/tema.dart';
import '../cubit/antrian_cubit.dart';
import '../widgets/kerangka_halaman.dart';
import '../widgets/komponen.dart';

/// Daftar seluruh pembeli yang sudah dipanggil beserta jam dan lama layanannya.
class HalamanRiwayat extends StatelessWidget {
  const HalamanRiwayat({super.key});

  @override
  Widget build(BuildContext context) {
    return const KerangkaHalaman(
      judul: 'Riwayat',
      rute: Konfigurasi.ruteRiwayat,
      isi: _IsiRiwayat(),
    );
  }
}

class _IsiRiwayat extends StatelessWidget {
  const _IsiRiwayat();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AntrianCubit, AntrianState>(
      builder: (context, s) {
        final jumlah = s.riwayat.length;
        return PusatKonten(
          // Item pertama adalah ringkasan, sisanya riwayat dari yang terbaru.
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 20, 32),
            itemCount: jumlah + 1,
            itemBuilder: (context, indeks) {
              if (indeks == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _RingkasanRiwayat(state: s),
                );
              }
              final catatan = s.riwayat[jumlah - indeks];
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _BarisRiwayat(catatan: catatan),
              );
            },
          ),
        );
      },
    );
  }
}

class _RingkasanRiwayat extends StatelessWidget {
  const _RingkasanRiwayat({required this.state});

  final AntrianState state;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    final kosong = state.riwayat.isEmpty;
    return Kartu(
      padding: const EdgeInsets.all(16),
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
            child: Icon(Icons.history_rounded, color: skema.onPrimaryContainer),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Riwayat Pelayanan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: skema.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  kosong
                      ? 'Belum ada pembeli yang dipanggil. Riwayat akan muncul '
                      'setelah Panggil Berikutnya ditekan.'
                      : '${state.riwayat.length} pembeli dipanggil, '
                      '${state.selesai.length} sudah selesai.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                    color: alfa(skema.onSurface, 0.78),
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

class _BarisRiwayat extends StatelessWidget {
  const _BarisRiwayat({required this.catatan});

  final CatatanLayanan catatan;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    final selesai = catatan.sudahSelesai;
    final lamaLayanan = catatan.lamaLayanan;
    final gayaKecil = TextStyle(
      fontSize: 12.5,
      height: 1.4,
      fontWeight: FontWeight.w500,
      color: alfa(skema.onSurface, 0.78),
    );
    final latarNomor = selesai ? skema.secondaryContainer : skema.primary;

    return Kartu(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            decoration: dekorasiNeo(
              skema,
              warna: latarNomor,
              radius: 14,
              jarak: 0,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                formatNomor(catatan.nomor),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: selesai
                      ? skema.onSecondaryContainer
                      : teksDi(skema.primary),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selesai ? 'Selesai dilayani' : 'Sedang dilayani',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w900,
                    color: skema.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Diambil ${formatJam(catatan.waktuAmbil)}  ·  '
                      'Dipanggil ${formatJam(catatan.waktuPanggil)}',
                  style: gayaKecil,
                ),
                Text(
                  'Lama menunggu: ${formatDurasi(catatan.lamaTunggu)}',
                  style: gayaKecil,
                ),
                if (lamaLayanan != null)
                  Text(
                    'Lama layanan: ${formatDurasi(lamaLayanan)}',
                    style: gayaKecil,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            selesai
                ? Icons.check_circle_rounded
                : Icons.record_voice_over_rounded,
            color: skema.onSurface,
          ),
        ],
      ),
    );
  }
}
