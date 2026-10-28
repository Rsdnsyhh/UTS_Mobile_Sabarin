// Kerangka halaman (latar, AppBar, Drawer) beserta isi menu samping dan pengaturan tema.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/konfigurasi.dart';
import '../core/tema.dart';
import '../cubit/antrian_cubit.dart';
import '../cubit/tema_cubit.dart';
import 'komponen.dart';

/// Kerangka yang dipakai semua halaman: latar hias, AppBar, Drawer, dan
/// pendengar pesan. Pada layar lebar, menu samping dipasang permanen.
class KerangkaHalaman extends StatelessWidget {
  const KerangkaHalaman({
    super.key,
    required this.judul,
    required this.rute,
    required this.isi,
    this.aksi = const [],
  });

  final String judul;
  final String rute;
  final Widget isi;
  final List<Widget> aksi;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return BlocListener<AntrianCubit, AntrianState>(
      listenWhen: (lama, baru) =>
      baru.pesan != null && lama.pesan?.id != baru.pesan!.id,
      listener: (context, state) => tampilkanPesan(context, state.pesan),
      child: LayoutBuilder(
        builder: (context, kendala) {
          final layarLebar = kendala.maxWidth >= Konfigurasi.batasLebar;

          final halaman = Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(judul),
              automaticallyImplyLeading: !layarLebar,
              actions: aksi,
            ),
            drawer: layarLebar
                ? null
                : Drawer(
              backgroundColor: skema.surface,
              surfaceTintColor: Colors.transparent,
              shape: const RoundedRectangleBorder(),
              child: PanelSamping(rute: rute, permanen: false),
            ),
            body: SafeArea(top: false, child: isi),
          );

          return Stack(
            children: [
              const Positioned.fill(child: LatarHias()),
              Positioned.fill(
                child: layarLebar
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 300,
                      decoration: BoxDecoration(
                        color: skema.surface,
                        border: Border(
                          right: BorderSide(
                            color: tinta(skema),
                            width: tebalGaris,
                          ),
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: PanelSamping(rute: rute, permanen: true),
                      ),
                    ),
                    Expanded(child: halaman),
                  ],
                )
                    : halaman,
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Isi menu samping: identitas aplikasi, daftar halaman, dan pengaturan tema.
class PanelSamping extends StatelessWidget {
  const PanelSamping({super.key, required this.rute, required this.permanen});

  final String rute;
  final bool permanen;

  void _buka(BuildContext context, String tujuan) {
    final navigator = Navigator.of(context);
    // Drawer ditutup lebih dulu bila sedang tampil sebagai laci.
    if (!permanen) navigator.pop();
    if (tujuan == rute) return;
    navigator.pushNamedAndRemoveUntil(tujuan, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const _KepalaPanel(),
        const SizedBox(height: 12),
        for (final menu in daftarMenu)
          _ItemMenu(
            ikon: menu.ikon,
            ikonAktif: menu.ikonAktif,
            label: menu.label,
            aktif: rute == menu.rute,
            onTap: () => _buka(context, menu.rute),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Divider(color: tinta(skema), thickness: tebalGaris, height: 2),
        ),
        const PengaturanTema(),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Text(
            Konfigurasi.versi,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: alfa(skema.onSurface, 0.6),
            ),
          ),
        ),
      ],
    );
  }
}

class _KepalaPanel extends StatelessWidget {
  const _KepalaPanel();

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    final tinggiStatus = MediaQuery.paddingOf(context).top;
    final warnaTeks = teksDi(skema.primary);
    return Container(
      padding: EdgeInsets.fromLTRB(20, tinggiStatus + 24, 20, 22),
      decoration: BoxDecoration(
        color: skema.primary,
        border: Border(
          bottom: BorderSide(color: tinta(skema), width: tebalGaris),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LogoSabarin(ukuran: 60, terbalik: true),
          const SizedBox(height: 16),
          Text(
            Konfigurasi.namaAplikasi,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              color: warnaTeks,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            Konfigurasi.tagline,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: alfa(warnaTeks, 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemMenu extends StatelessWidget {
  const _ItemMenu({
    required this.ikon,
    required this.ikonAktif,
    required this.label,
    required this.aktif,
    required this.onTap,
  });

  final IconData ikon;
  final IconData ikonAktif;
  final String label;
  final bool aktif;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    final warnaIsi = aktif ? teksDi(skema.primary) : skema.onSurface;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 4, 18, 4),
      child: Container(
        decoration: aktif
            ? dekorasiNeo(skema, warna: skema.primary, radius: 18, jarak: 4)
            : BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.transparent, width: tebalGaris),
        ),
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            leading: Icon(aktif ? ikonAktif : ikon, color: warnaIsi),
            title: Text(
              label,
              style: TextStyle(
                fontWeight: aktif ? FontWeight.w900 : FontWeight.w600,
                color: warnaIsi,
              ),
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}

class PengaturanTema extends StatelessWidget {
  const PengaturanTema();

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    final gelapSistem =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    return BlocBuilder<TemaCubit, TemaState>(
      builder: (context, tema) {
        final cubit = context.read<TemaCubit>();
        // Saklar mengikuti tema yang benar-benar tampil, termasuk saat mode "Sistem".
        final gelap = tema.mode == ThemeMode.dark ||
            (tema.mode == ThemeMode.system && gelapSistem);

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pengaturan Tema',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: skema.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    gelap ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    color: skema.onSurface,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Mode Gelap',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Switch(
                    value: gelap,
                    activeColor: tinta(skema),
                    activeTrackColor: skema.primary,
                    inactiveThumbColor: tinta(skema),
                    inactiveTrackColor: warnaKartu(skema, 0),
                    onChanged: (nilai) => cubit.ubahMode(
                      nilai ? ThemeMode.dark : ThemeMode.light,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _PilihanMode(aktif: tema.mode, onPilih: cubit.ubahMode),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Warna Tema',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: alfa(skema.onSurface, 0.8),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      tema.namaWarna,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: skema.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (var i = 0; i < daftarWarna.length; i++)
                    _TitikWarna(
                      pilihan: daftarWarna[i],
                      terpilih: i == tema.indeksWarna,
                      onTap: () => cubit.ubahWarna(i),
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

/// Pilihan Terang / Gelap / Sistem berupa tiga segmen yang lebarnya sama.
class _PilihanMode extends StatelessWidget {
  const _PilihanMode({required this.aktif, required this.onPilih});

  final ThemeMode aktif;
  final ValueChanged<ThemeMode> onPilih;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: dekorasiNeo(
        skema,
        warna: warnaKartu(skema, 0.10),
        radius: 16,
        jarak: 3,
      ),
      child: Row(
        children: [
          _Segmen(
            ikon: Icons.light_mode_rounded,
            label: 'Terang',
            terpilih: aktif == ThemeMode.light,
            onTap: () => onPilih(ThemeMode.light),
          ),
          _Segmen(
            ikon: Icons.dark_mode_rounded,
            label: 'Gelap',
            terpilih: aktif == ThemeMode.dark,
            onTap: () => onPilih(ThemeMode.dark),
          ),
          _Segmen(
            ikon: Icons.smartphone_rounded,
            label: 'Sistem',
            terpilih: aktif == ThemeMode.system,
            onTap: () => onPilih(ThemeMode.system),
          ),
        ],
      ),
    );
  }
}

class _Segmen extends StatelessWidget {
  const _Segmen({
    required this.ikon,
    required this.label,
    required this.terpilih,
    required this.onTap,
  });

  final IconData ikon;
  final String label;
  final bool terpilih;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    final warnaIsi = terpilih ? teksDi(skema.primary) : skema.onSurface;
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 7),
            decoration: BoxDecoration(
              color: terpilih ? skema.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: terpilih ? tinta(skema) : Colors.transparent,
                width: tebalGaris,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(ikon, size: 18, color: warnaIsi),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: warnaIsi,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TitikWarna extends StatelessWidget {
  const _TitikWarna({
    required this.pilihan,
    required this.terpilih,
    required this.onTap,
  });

  final PilihanWarna pilihan;
  final bool terpilih;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return Tooltip(
      message: pilihan.nama,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: pilihan.warna,
              shape: BoxShape.circle,
              border: Border.all(color: tinta(skema), width: tebalGaris),
              boxShadow: terpilih ? bayanganKeras(skema, 3) : null,
            ),
            child: terpilih
                ? Icon(
              Icons.check_rounded,
              color: teksDi(pilihan.warna),
              size: 22,
            )
                : null,
          ),
        ),
      ),
    );
  }
}
