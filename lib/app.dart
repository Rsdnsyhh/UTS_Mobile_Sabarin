// Widget akar (provider Cubit dan MaterialApp) serta pemetaan rute ke halaman.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/konfigurasi.dart';
import 'core/tema.dart';
import 'cubit/antrian_cubit.dart';
import 'cubit/tema_cubit.dart';
import 'halaman/halaman_antrian.dart';
import 'halaman/halaman_beranda.dart';
import 'halaman/halaman_layar_pelanggan.dart';
import 'halaman/halaman_riwayat.dart';
import 'halaman/halaman_statistik.dart';
import 'halaman/halaman_tentang.dart';

class SabarinApp extends StatelessWidget {
  const SabarinApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Kedua Cubit diletakkan di atas MaterialApp agar bisa dipakai semua halaman.
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TemaCubit()),
        BlocProvider(create: (_) => AntrianCubit()),
      ],
      child: BlocBuilder<TemaCubit, TemaState>(
        builder: (context, tema) {
          return MaterialApp(
            title: Konfigurasi.namaAplikasi,
            debugShowCheckedModeBanner: false,
            theme: bangunTema(tema.warnaBenih, Brightness.light),
            darkTheme: bangunTema(tema.warnaBenih, Brightness.dark),
            themeMode: tema.mode,
            onGenerateInitialRoutes: (String rute) => [
              bangunRute(RouteSettings(name: rute)),
            ],
            onGenerateRoute: bangunRute,
            onUnknownRoute: bangunRute,
          );
        },
      ),
    );
  }
}

/// Memilih widget halaman berdasarkan nama rute.
Widget bangunHalaman(String rute) {
  switch (rute) {
    case Konfigurasi.ruteAntrian:
      return const HalamanAntrian();
    case Konfigurasi.ruteLayar:
      return const HalamanLayarPelanggan();
    case Konfigurasi.ruteRiwayat:
      return const HalamanRiwayat();
    case Konfigurasi.ruteStatistik:
      return const HalamanStatistik();
    case Konfigurasi.ruteTentang:
      return const HalamanTentang();
    default:
      return const HalamanBeranda();
  }
}

/// Membuat rute dengan transisi halus. Nama rute yang tidak dikenal
/// otomatis diarahkan ke Beranda sehingga tidak pernah muncul layar kosong.
Route<dynamic> bangunRute(RouteSettings pengaturan) {
  final asal = pengaturan.name;
  final nama = (asal != null && daftarMenu.any((menu) => menu.rute == asal))
      ? asal
      : Konfigurasi.ruteBeranda;
  final Widget halaman = bangunHalaman(nama);

  return PageRouteBuilder<void>(
    settings: RouteSettings(name: nama),
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (context, animasi, animasiLain) => halaman,
    transitionsBuilder: (context, animasi, animasiLain, anak) {
      return FadeTransition(
        opacity: animasi.drive(CurveTween(curve: Curves.easeOut)),
        child: anak,
      );
    },
  );
}
