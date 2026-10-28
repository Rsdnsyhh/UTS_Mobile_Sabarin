// State dan Cubit pengaturan tema (mode dan warna).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/konfigurasi.dart';

/// Satu pilihan warna tema beserta namanya.
class PilihanWarna {
  const PilihanWarna(this.nama, this.warna);

  final String nama;
  final Color warna;
}

/// Delapan warna tema (syarat minimal lima).
const List<PilihanWarna> daftarWarna = [
  PilihanWarna('Biru Laut', Color(0xFF1E88E5)),
  PilihanWarna('Hijau Daun', Color(0xFF2E9E5B)),
  PilihanWarna('Merah Saga', Color(0xFFE53935)),
  PilihanWarna('Ungu Senja', Color(0xFF7E57C2)),
  PilihanWarna('Jingga Mentari', Color(0xFFFB8C00)),
  PilihanWarna('Tosca Lagun', Color(0xFF00A79D)),
  PilihanWarna('Merah Muda', Color(0xFFEC407A)),
  PilihanWarna('Indigo Malam', Color(0xFF3949AB)),
];

/// State tema: mode (terang/gelap/sistem) dan indeks warna yang dipilih.
class TemaState {
  const TemaState({this.mode = ThemeMode.system, this.indeksWarna = 5});

  final ThemeMode mode;
  final int indeksWarna;

  /// Warna dasar (seed) yang aman: indeks di luar jangkauan dikoreksi otomatis.
  Color get warnaBenih =>
      daftarWarna[batasi(indeksWarna, 0, daftarWarna.length - 1)].warna;

  String get namaWarna =>
      daftarWarna[batasi(indeksWarna, 0, daftarWarna.length - 1)].nama;

  TemaState copyWith({ThemeMode? mode, int? indeksWarna}) => TemaState(
    mode: mode ?? this.mode,
    indeksWarna: indeksWarna ?? this.indeksWarna,
  );

  @override
  bool operator ==(Object other) =>
      other is TemaState &&
          other.mode == mode &&
          other.indeksWarna == indeksWarna;

  @override
  int get hashCode => Object.hash(mode, indeksWarna);
}

/// Mengelola pengaturan tema. UI hanya memanggil method, Cubit yang memancarkan state.
class TemaCubit extends Cubit<TemaState> {
  TemaCubit() : super(const TemaState());

  void ubahMode(ThemeMode mode) {
    if (isClosed || mode == state.mode) return;
    emit(state.copyWith(mode: mode));
  }

  void ubahWarna(int indeks) {
    if (isClosed) return;
    if (indeks < 0 || indeks >= daftarWarna.length) return;
    if (indeks == state.indeksWarna) return;
    emit(state.copyWith(indeksWarna: indeks));
  }
}
