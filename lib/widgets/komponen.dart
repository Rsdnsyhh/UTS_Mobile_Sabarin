// Komponen bersama: kartu, tombol, bar progres, label, tata letak, pesan, logo, dan latar.

import 'package:flutter/material.dart';
import '../core/konfigurasi.dart';
import '../core/tema.dart';
import '../cubit/antrian_cubit.dart';

/// Kartu: warna flat, outline tinta tebal, dan hard shadow.
class Kartu extends StatelessWidget {
  const Kartu({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.warna,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? warna;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: dekorasiNeo(skema, warna: warna ?? warnaKartu(skema)),
      child: child,
    );
  }
}

/// Tombol Neo-Brutalism: pill beroutline dengan hard shadow yang "ditekan"
/// saat disentuh.
class TombolNeo extends StatefulWidget {
  const TombolNeo({
    super.key,
    required this.label,
    required this.onPressed,
    this.ikon,
    this.warna,
    this.tinggi = 52,
    this.ukuranTeks = 15,
    this.penuh = true,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? ikon;
  final Color? warna;
  final double tinggi;
  final double ukuranTeks;

  /// Jika false, lebar tombol mengikuti isinya.
  final bool penuh;

  @override
  State<TombolNeo> createState() => _TombolNeoState();
}

class _TombolNeoState extends State<TombolNeo> {
  bool _tekan = false;

  void _atur(bool nilai) {
    if (_tekan != nilai && mounted) setState(() => _tekan = nilai);
  }

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    final latar = widget.warna ?? skema.primary;
    final isi = teksDi(latar);
    final garis = tinta(skema);
    final geser = _tekan ? 3.0 : 0.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _atur(true),
        onTapUp: (_) => _atur(false),
        onTapCancel: () => _atur(false),
        onTap: widget.onPressed,
        child: Padding(
          // Ruang untuk bayangan keras agar tidak terpotong.
          padding: const EdgeInsets.only(right: 4, bottom: 4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            transform: Matrix4.translationValues(geser, geser, 0),
            height: widget.tinggi,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: widget.penuh ? Alignment.center : null,
            decoration: BoxDecoration(
              color: latar,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: garis, width: tebalGaris),
              boxShadow: [
                BoxShadow(
                  color: garis,
                  offset: Offset(4 - geser, 4 - geser),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: widget.penuh ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.ikon != null) ...[
                  Icon(widget.ikon, color: isi, size: 22),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: widget.ukuranTeks,
                      fontWeight: FontWeight.w800,
                      color: isi,
                    ),
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

/// Bar progres beroutline (dipakai di Beranda dan Statistik).
class BatangProgres extends StatelessWidget {
  const BatangProgres({
    super.key,
    required this.nilai,
    required this.warna,
    this.tinggi = 16,
  });

  final double nilai;
  final Color warna;
  final double tinggi;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return Container(
      height: tinggi,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: warnaKartu(skema, 0),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: tinta(skema), width: tebalGaris),
      ),
      child: LayoutBuilder(
        builder: (context, kendala) {
          final lebar = kendala.maxWidth.isFinite ? kendala.maxWidth : 0.0;
          final isi = lebar * nilai.clamp(0.0, 1.0);
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(width: isi, color: warna),
          );
        },
      ),
    );
  }
}

class KartuStat extends StatelessWidget {
  const KartuStat({
    required this.ikon,
    required this.nilai,
    required this.label,
  });

  final IconData ikon;
  final String nilai;
  final String label;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return Kartu(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: dekorasiNeo(
              skema,
              warna: skema.primaryContainer,
              radius: 12,
              jarak: 0,
            ),
            child: Icon(ikon, size: 20, color: skema.onPrimaryContainer),
          ),
          const SizedBox(height: 14),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              nilai,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: skema.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: alfa(skema.onSurface, 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

/// Kartu besar yang menampilkan nomor yang sedang dilayani.
class KartuDilayani extends StatelessWidget {
  const KartuDilayani({
    required this.nomor,
    this.judul = 'SEDANG DILAYANI',
    this.ukuranNomor = 68,
    this.vertikal = 28,
  });

  final int? nomor;
  final String judul;
  final double ukuranNomor;
  final double vertikal;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    final warnaTeks = teksDi(skema.primary);
    final teksNomor = nomor == null ? '—' : formatNomor(nomor!);
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: vertikal),
      decoration: dekorasiNeo(
        skema,
        warna: skema.primary,
        radius: 28,
        jarak: 6,
      ),
      child: Column(
        children: [
          Text(
            judul,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.2,
              color: alfa(warnaTeks, 0.95),
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (anak, animasi) => FadeTransition(
              opacity: animasi,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.85, end: 1).animate(animasi),
                child: anak,
              ),
            ),
            child: FittedBox(
              key: ValueKey<String>(teksNomor),
              fit: BoxFit.scaleDown,
              child: Text(
                teksNomor,
                style: TextStyle(
                  fontSize: ukuranNomor,
                  height: 1.1,
                  fontWeight: FontWeight.w900,
                  color: warnaTeks,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            nomor == null
                ? 'Belum ada pembeli yang dipanggil'
                : 'Silakan menuju kasir',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: alfa(warnaTeks, 0.92),
            ),
          ),
        ],
      ),
    );
  }
}

/// Label nomor berbentuk kapsul beroutline dengan hard shadow kecil.
class LencanaNomor extends StatelessWidget {
  const LencanaNomor({
    required this.teks,
    required this.ikon,
    required this.latar,
    required this.isi,
    required this.garis,
  });

  final String teks;
  final IconData ikon;
  final Color latar;
  final Color isi;
  final Color garis;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: latar,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: garis, width: tebalGaris),
        boxShadow: latar == Colors.transparent ? null : bayanganKeras(skema, 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 16, color: isi),
          const SizedBox(width: 6),
          Text(
            teks,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: isi,
            ),
          ),
        ],
      ),
    );
  }
}

class InfoKosong extends StatelessWidget {
  const InfoKosong({required this.ikon, required this.teks});

  final IconData ikon;
  final String teks;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(ikon, size: 20, color: alfa(skema.onSurface, 0.6)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            teks,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: alfa(skema.onSurface, 0.7),
            ),
          ),
        ),
      ],
    );
  }
}

/// Memusatkan konten dan membatasi lebarnya agar tetap nyaman di layar lebar.
class PusatKonten extends StatelessWidget {
  const PusatKonten({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960),
        child: child,
      ),
    );
  }
}

/// Menyusun anak ke dalam beberapa kolom sesuai lebar yang tersedia.
class SusunanKolom extends StatelessWidget {
  const SusunanKolom({
    super.key,
    required this.anak,
    required this.kolomLebar,
    required this.kolomSempit,
    this.jarak = 16,
    this.batasBeralih = 640,
  });

  final List<Widget> anak;
  final int kolomLebar;
  final int kolomSempit;
  final double jarak;
  final double batasBeralih;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, kendala) {
        final lebarTotal = kendala.maxWidth.isFinite ? kendala.maxWidth : 600.0;
        final kolom = lebarTotal >= batasBeralih ? kolomLebar : kolomSempit;
        // Dikurangi 4 agar hard shadow di sisi kanan tidak terpotong.
        final lebarItem = (lebarTotal - 4 - jarak * (kolom - 1)) / kolom;
        return Wrap(
          spacing: jarak,
          runSpacing: jarak,
          children: [
            for (final item in anak) SizedBox(width: lebarItem, child: item),
          ],
        );
      },
    );
  }
}

/// Menampilkan pesan dari Cubit sebagai SnackBar.
void tampilkanPesan(BuildContext context, Pesan? pesan) {
  if (pesan == null) return;
  final pengelola = ScaffoldMessenger.maybeOf(context);
  if (pengelola == null) return;

  final skema = Theme.of(context).colorScheme;
  final galat = pesan.jenis == JenisPesan.galat;
  final warnaLatar = galat ? skema.errorContainer : skema.primaryContainer;
  final warnaIsi = galat ? skema.onErrorContainer : skema.onPrimaryContainer;
  final ikon = switch (pesan.jenis) {
    JenisPesan.sukses => Icons.check_circle_rounded,
    JenisPesan.info => Icons.info_rounded,
    JenisPesan.galat => Icons.error_rounded,
  };

  pengelola
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: warnaLatar,
        duration: const Duration(milliseconds: 2200),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        content: Row(
          children: [
            Icon(ikon, color: warnaIsi),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                pesan.teks,
                style: TextStyle(color: warnaIsi, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
}

/// Logo Sabarin: jam pasir di dalam kotak membulat beroutline. Digambar dengan
/// kode sehingga tidak membutuhkan file gambar tambahan.
class LogoSabarin extends StatelessWidget {
  const LogoSabarin({super.key, this.ukuran = 48, this.terbalik = false});

  final double ukuran;

  /// Jika true, latar logo putih (dipakai di atas latar berwarna).
  final bool terbalik;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return SizedBox(
      width: ukuran,
      height: ukuran,
      child: CustomPaint(
        painter: _PelukisLogo(
          latar: terbalik ? Colors.white : skema.primary,
          gambar: terbalik ? const Color(0xFF141414) : teksDi(skema.primary),
          pasir: skema.primary,
          garis: tinta(skema),
        ),
      ),
    );
  }
}

class _PelukisLogo extends CustomPainter {
  _PelukisLogo({
    required this.latar,
    required this.gambar,
    required this.pasir,
    required this.garis,
  });

  final Color latar;
  final Color gambar;
  final Color pasir;
  final Color garis;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final tebal = (s * 0.05).clamp(1.5, 4.0);
    final area = (Offset.zero & size).deflate(tebal / 2);
    final kotak = RRect.fromRectAndRadius(area, Radius.circular(s * 0.30));

    // Latar kotak membulat: warna flat + outline tebal.
    canvas.drawRRect(kotak, Paint()..color = latar);
    canvas.drawRRect(
      kotak,
      Paint()
        ..color = garis
        ..style = PaintingStyle.stroke
        ..strokeWidth = tebal,
    );

    // Badan jam pasir.
    final kuasGambar = Paint()..color = gambar;
    final badan = Path()
      ..moveTo(0.32 * s, 0.30 * s)
      ..lineTo(0.68 * s, 0.30 * s)
      ..lineTo(0.54 * s, 0.50 * s)
      ..lineTo(0.68 * s, 0.70 * s)
      ..lineTo(0.32 * s, 0.70 * s)
      ..lineTo(0.46 * s, 0.50 * s)
      ..close();
    canvas.drawPath(badan, kuasGambar);

    // Penutup atas dan bawah.
    final jari = Radius.circular(0.035 * s);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(0.26 * s, 0.22 * s, 0.74 * s, 0.29 * s),
        jari,
      ),
      kuasGambar,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(0.26 * s, 0.71 * s, 0.74 * s, 0.78 * s),
        jari,
      ),
      kuasGambar,
    );

    // Pasir di bagian atas, aliran, dan tumpukan di bagian bawah.
    final kuasPasir = Paint()..color = pasir;
    final pasirAtas = Path()
      ..moveTo(0.40 * s, 0.31 * s)
      ..lineTo(0.60 * s, 0.31 * s)
      ..lineTo(0.50 * s, 0.42 * s)
      ..close();
    final pasirBawah = Path()
      ..moveTo(0.38 * s, 0.70 * s)
      ..lineTo(0.62 * s, 0.70 * s)
      ..lineTo(0.50 * s, 0.58 * s)
      ..close();
    canvas.drawPath(pasirAtas, kuasPasir);
    canvas.drawPath(pasirBawah, kuasPasir);
    canvas.drawLine(
      Offset(0.50 * s, 0.46 * s),
      Offset(0.50 * s, 0.58 * s),
      Paint()
        ..color = pasir
        ..strokeWidth = 0.02 * s
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _PelukisLogo lama) =>
      lama.latar != latar ||
          lama.gambar != gambar ||
          lama.pasir != pasir ||
          lama.garis != garis;
}

/// Latar belakang aplikasi: warna flat, pola polkadot, dan dua lingkaran
/// flat sebagai hiasan (tanpa gradasi).
class LatarHias extends StatelessWidget {
  const LatarHias({super.key});

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return ColoredBox(
      color: skema.surface,
      child: CustomPaint(
        size: Size.infinite,
        painter: _PelukisLatar(skema.primary, skema.tertiary, tinta(skema)),
      ),
    );
  }
}

class _PelukisLatar extends CustomPainter {
  _PelukisLatar(this.utama, this.pendamping, this.tintaWarna);

  final Color utama;
  final Color pendamping;
  final Color tintaWarna;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || !size.width.isFinite || !size.height.isFinite) return;
    final sisiPendek = size.shortestSide;

    // Dua lingkaran flat di pojok.
    canvas.drawCircle(
      Offset(size.width * 0.95, size.height * 0.04),
      sisiPendek * 0.32,
      Paint()..color = alfa(utama, 0.16),
    );
    canvas.drawCircle(
      Offset(size.width * 0.02, size.height * 0.98),
      sisiPendek * 0.28,
      Paint()..color = alfa(pendamping, 0.16),
    );

    // Polkadot tipis di seluruh latar.
    const jarak = 28.0;
    final titik = Paint()..color = alfa(tintaWarna, 0.08);
    for (var y = jarak / 2; y < size.height; y += jarak) {
      final geser = ((y / jarak).floor() % 2 == 0) ? 0.0 : jarak / 2;
      for (var x = jarak / 2 + geser; x < size.width; x += jarak) {
        canvas.drawCircle(Offset(x, y), 1.6, titik);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PelukisLatar lama) =>
      lama.utama != utama ||
          lama.pendamping != pendamping ||
          lama.tintaWarna != tintaWarna;
}
