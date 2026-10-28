// Halaman 2: Hitung Antrian.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/konfigurasi.dart';
import '../core/tema.dart';
import '../cubit/antrian_cubit.dart';
import '../widgets/kerangka_halaman.dart';
import '../widgets/komponen.dart';

class HalamanAntrian extends StatelessWidget {
  const HalamanAntrian({super.key});

  /// Meminta konfirmasi sebelum antrian dihapus agar tidak terhapus tidak sengaja.
  Future<void> _konfirmasiReset(BuildContext context) async {
    final cubit = context.read<AntrianCubit>();
    final skema = Theme.of(context).colorScheme;
    if (cubit.state.kosong) {
      cubit.reset();
      return;
    }
    final setuju = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        backgroundColor: warnaKartu(skema, 0),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: tinta(skema), width: tebalGaris),
        ),
        icon: Icon(Icons.restart_alt_rounded, color: skema.onSurface),
        title: const Text(
          'Reset antrian?',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        content: const Text(
          'Seluruh nomor yang menunggu, sedang dilayani, dan sudah selesai '
              'akan dihapus. Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialog).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialog).pop(true),
            child: const Text('Ya, reset'),
          ),
        ],
      ),
    );
    if (setuju == true) cubit.reset();
  }

  @override
  Widget build(BuildContext context) {
    return KerangkaHalaman(
      judul: 'Hitung Antrian',
      rute: Konfigurasi.ruteAntrian,
      aksi: [
        IconButton(
          tooltip: 'Reset antrian',
          icon: const Icon(Icons.restart_alt_rounded),
          onPressed: () => _konfirmasiReset(context),
        ),
        const SizedBox(width: 4),
      ],
      isi: const _IsiAntrian(),
    );
  }
}

class _IsiAntrian extends StatelessWidget {
  const _IsiAntrian();

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    final cubit = context.read<AntrianCubit>();

    return BlocBuilder<AntrianCubit, AntrianState>(
      builder: (context, s) {
        // Daftar selesai ditampilkan dari yang terbaru dan dibatasi jumlahnya.
        final selesaiTerbaru = s.selesai.reversed.toList();
        final selesaiTampil =
        selesaiTerbaru.take(Konfigurasi.batasTampilSelesai).toList();
        final sisaSelesai = selesaiTerbaru.length - selesaiTampil.length;

        return PusatKonten(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 20, 32),
            children: [
              KartuDilayani(nomor: s.sedangDilayani),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _KartuMini(
                      ikon: Icons.hourglass_bottom_rounded,
                      judul: 'Menunggu',
                      nilai: '${s.jumlahMenunggu} orang',
                      keterangan: s.jumlahMenunggu == 0
                          ? 'Tidak ada antrian'
                          : 'Estimasi ±${s.estimasiMenit} menit',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _KartuMini(
                      ikon: Icons.confirmation_number_rounded,
                      judul: 'Nomor Terakhir',
                      nilai: s.nomorTerakhir == 0
                          ? '-'
                          : formatNomor(s.nomorTerakhir),
                      keterangan: 'Batas ${Konfigurasi.nomorMaksimal}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TombolNeo(
                tinggi: 58,
                ukuranTeks: 16,
                onPressed: cubit.panggilBerikutnya,
                ikon: Icons.campaign_rounded,
                label: 'Panggil Berikutnya',
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TombolNeo(
                      warna: warnaKartu(skema, 0),
                      onPressed: cubit.batalkanTerakhir,
                      ikon: Icons.remove_rounded,
                      label: 'Batal',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: TombolNeo(
                      warna: warnaKuning,
                      onPressed: cubit.ambilNomor,
                      ikon: Icons.add_rounded,
                      label: 'Ambil Nomor',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              _JudulBagian(teks: 'Daftar Menunggu', jumlah: s.jumlahMenunggu),
              const SizedBox(height: 12),
              if (s.menunggu.isEmpty)
                const InfoKosong(
                  ikon: Icons.event_seat_outlined,
                  teks: 'Belum ada antrian. Tekan Ambil Nomor untuk memulai.',
                )
              else
                Wrap(
                  spacing: 10,
                  runSpacing: 12,
                  children: [
                    for (var i = 0; i < s.menunggu.length; i++)
                      LencanaNomor(
                        teks: formatNomor(s.menunggu[i]),
                        ikon: i == 0
                            ? Icons.bolt_rounded
                            : Icons.person_rounded,
                        // Nomor terdepan diberi warna berbeda sebagai penanda.
                        latar: i == 0 ? skema.primary : warnaKartu(skema, 0.06),
                        isi: i == 0 ? teksDi(skema.primary) : skema.onSurface,
                        garis: tinta(skema),
                      ),
                  ],
                ),
              const SizedBox(height: 26),
              _JudulBagian(teks: 'Sudah Dilayani', jumlah: s.selesai.length),
              const SizedBox(height: 12),
              if (s.selesai.isEmpty)
                const InfoKosong(
                  ikon: Icons.inbox_outlined,
                  teks: 'Belum ada.',
                )
              else
                Wrap(
                  spacing: 10,
                  runSpacing: 12,
                  children: [
                    for (final nomor in selesaiTampil)
                      LencanaNomor(
                        teks: formatNomor(nomor),
                        ikon: Icons.check_circle_rounded,
                        latar: skema.secondaryContainer,
                        isi: skema.onSecondaryContainer,
                        garis: tinta(skema),
                      ),
                    if (sisaSelesai > 0)
                      LencanaNomor(
                        teks: '+$sisaSelesai lainnya',
                        ikon: Icons.more_horiz_rounded,
                        latar: Colors.transparent,
                        isi: skema.onSurface,
                        garis: tinta(skema),
                      ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class _KartuMini extends StatelessWidget {
  const _KartuMini({
    required this.ikon,
    required this.judul,
    required this.nilai,
    required this.keterangan,
  });

  final IconData ikon;
  final String judul;
  final String nilai;
  final String keterangan;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return Kartu(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ikon, color: skema.onSurface),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: alfa(skema.onSurface, 0.75),
                  ),
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    nilai,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: skema.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  keterangan,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: alfa(skema.onSurface, 0.65),
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

class _JudulBagian extends StatelessWidget {
  const _JudulBagian({required this.teks, required this.jumlah});

  final String teks;
  final int jumlah;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(
          teks,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: skema.onSurface,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: dekorasiNeo(
            skema,
            warna: warnaKuning,
            radius: 20,
            jarak: 0,
          ),
          child: Text(
            '$jumlah',
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
              color: Color(0xFF141414),
            ),
          ),
        ),
      ],
    );
  }
}
