// Token desain Soft Neo-Brutalism dan ThemeData aplikasi.

import 'package:flutter/material.dart';

/// Mengatur transparansi warna tanpa memakai API yang berbeda antar versi Flutter.
Color alfa(Color warna, double nilai) => warna.withAlpha((nilai * 255).round());

/// Warna "tinta": dipakai untuk outline, bayangan keras, dan teks tegas.
Color tinta(ColorScheme skema) => skema.brightness == Brightness.light
    ? const Color(0xFF141414)
    : const Color(0xFFF4EFE6);

/// Memilih teks hitam atau putih agar kontras di atas [latar].
Color teksDi(Color latar) =>
    latar.computeLuminance() > 0.4 ? const Color(0xFF141414) : Colors.white;

/// Ketebalan garis tepi semua komponen.
const double tebalGaris = 2.0;

/// Warna aksen kuning tetap (dipakai untuk tombol sekunder yang mencolok).
const Color warnaKuning = Color(0xFFFFD23F);

/// Bayangan keras: solid, tanpa blur, bergeser ke kanan-bawah.
List<BoxShadow> bayanganKeras(ColorScheme skema, [double jarak = 4]) => [
  BoxShadow(
    color: tinta(skema),
    offset: Offset(jarak, jarak),
    blurRadius: 0,
    spreadRadius: 0,
  ),
];

/// Dekorasi dasar komponen: warna flat + outline + hard shadow.
BoxDecoration dekorasiNeo(
    ColorScheme skema, {
      required Color warna,
      double radius = 20,
      double jarak = 4,
    }) {
  return BoxDecoration(
    color: warna,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: tinta(skema), width: tebalGaris),
    boxShadow: jarak <= 0 ? null : bayanganKeras(skema, jarak),
  );
}

/// Warna latar kartu: putih hangat (terang) atau abu gelap (gelap), dengan
/// sedikit rona warna utama bila [kekuatan] dinaikkan.
Color warnaKartu(ColorScheme skema, [double kekuatan = 0.07]) {
  final dasar = skema.brightness == Brightness.light
      ? const Color(0xFFFFFFFF)
      : const Color(0xFF1F1F1F);
  return Color.alphaBlend(alfa(skema.primary, kekuatan * 0.6), dasar);
}

/// Membuat ThemeData dari satu warna dasar. Dipakai untuk tema terang dan gelap.
/// Gaya Neo-Brutalism: latar krem/gelap pekat, outline tinta, tanpa elevasi.
ThemeData bangunTema(Color benih, Brightness kecerahan) {
  final terang = kecerahan == Brightness.light;
  final tintaTema = terang ? const Color(0xFF141414) : const Color(0xFFF4EFE6);
  final skema = ColorScheme.fromSeed(
    seedColor: benih,
    brightness: kecerahan,
  ).copyWith(
    surface: terang ? const Color(0xFFFBF6EA) : const Color(0xFF121212),
    onSurface: tintaTema,
    outline: tintaTema,
    outlineVariant: tintaTema,
    shadow: tintaTema,
  );
  final sisiTinta = BorderSide(color: tintaTema, width: tebalGaris);
  return ThemeData(
    useMaterial3: true,
    colorScheme: skema,
    scaffoldBackgroundColor: skema.surface,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: skema.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w900,
        color: skema.onSurface,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: skema.primary,
        foregroundColor: teksDi(skema.primary),
        side: sisiTinta,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: skema.onSurface,
        side: sisiTinta,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: sisiTinta,
      ),
    ),
  );
}
