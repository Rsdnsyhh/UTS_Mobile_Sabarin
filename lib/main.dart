// Titik masuk aplikasi Sabarin, penanganan kesalahan global, dan layar galat.

import 'dart:ui' show PlatformDispatcher;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Kesalahan pada framework tetap dicatat, tetapi tidak membuat aplikasi berhenti.
  FlutterError.onError = (FlutterErrorDetails detail) {
    FlutterError.presentError(detail);
  };

  // Kesalahan asinkron yang tidak tertangkap dicatat agar aplikasi tetap berjalan.
  PlatformDispatcher.instance.onError = (Object galat, StackTrace jejak) {
    debugPrint('Kesalahan tidak tertangani: $galat');
    return true;
  };

  // Jika ada widget yang gagal dibangun, tampilkan pesan yang ramah
  // (layar merah bawaan hanya ditampilkan saat mode debug).
  ErrorWidget.builder = (FlutterErrorDetails detail) {
    if (kDebugMode) return ErrorWidget(detail.exception);
    return const TampilanGalat();
  };

  runApp(const SabarinApp());
}

/// Pengganti layar error bawaan Flutter pada mode rilis.
class TampilanGalat extends StatelessWidget {
  const TampilanGalat({super.key});

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: Color(0xFFF5F5F5),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Terjadi kendala saat menampilkan bagian ini.\n'
                  'Silakan kembali atau muat ulang aplikasi.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF424242),
                fontSize: 14,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
