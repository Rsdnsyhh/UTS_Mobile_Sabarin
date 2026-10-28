# Sabarin - Aplikasi Hitung Antrian Pembeli

Sabarin adalah aplikasi mobile sederhana untuk mencatat dan memanggil antrian pembeli di usaha kecil, seperti warung, kedai, atau toko. Aplikasi ini dibuat dengan Flutter sebagai tugas Ujian Tengah Semester mata kuliah Pemrograman Piranti Bergerak.

Nama "Sabarin" diambil dari kata "sabar". Aplikasi ini dimaksudkan agar penjual dan pembeli dapat menjalani antrian dengan tertib dan tenang.

Versi saat ini: **1.1.0**

## Daftar Isi

1. [Gambaran Umum](#gambaran-umum)
2. [Fitur Aplikasi](#fitur-aplikasi)
3. [Teknologi yang Digunakan](#teknologi-yang-digunakan)
4. [Persiapan dan Cara Menjalankan](#persiapan-dan-cara-menjalankan)
5. [Panduan Penggunaan](#panduan-penggunaan)
6. [Pengaturan Tema](#pengaturan-tema)
7. [Gaya Desain](#gaya-desain)
8. [Struktur Kode](#struktur-kode)
9. [Menambah Halaman Baru](#menambah-halaman-baru)
10. [Penanganan Kesalahan](#penanganan-kesalahan)
11. [Mengubah Konfigurasi](#mengubah-konfigurasi)
12. [Pemecahan Masalah](#pemecahan-masalah)
13. [Keterbatasan](#keterbatasan)

## Gambaran Umum

Program disusun ke dalam beberapa berkas di folder `lib/` (lihat [Struktur Kode](#struktur-kode)) agar mudah dibaca dan dipelihara. Aplikasi memiliki enam halaman:

| Halaman | Fungsi |
| --- | --- |
| Beranda | Ringkasan kondisi antrian, progres pelayanan, menu pintas, dan petunjuk singkat penggunaan. |
| Hitung Antrian | Tempat penjual mengambil nomor, memanggil pembeli berikutnya, dan membatalkan nomor. |
| Layar Pelanggan | Tampilan besar nomor yang sedang dipanggil, khusus untuk dilihat pembeli. Halaman ini tanpa menu. |
| Riwayat | Daftar pembeli yang sudah dipanggil beserta jam dan lama pelayanannya. |
| Statistik | Rata-rata waktu, komposisi antrian, dan grafik pengambilan nomor. |
| Tentang | Identitas aplikasi, fitur utama, dan teknologi yang dipakai. |

Perpindahan antarhalaman dilakukan melalui menu samping (Drawer). Menu yang sama juga memuat pengaturan tema aplikasi. Tampilan memakai gaya **Soft Neo-Brutalism** (lihat bagian [Gaya Desain](#gaya-desain)).

## Fitur Aplikasi

### Pengelolaan antrian (halaman Hitung Antrian)

- **Ambil Nomor.** Menambahkan pembeli baru ke daftar menunggu. Nomor tampil dengan format `A-001`, `A-002`, dan seterusnya. Jam pengambilan nomor dicatat.
- **Panggil Berikutnya.** Memanggil nomor terdepan. Nomor yang sebelumnya sedang dilayani otomatis dipindahkan ke daftar "Sudah Dilayani" dan jam selesainya dicatat. Apabila tidak ada lagi pembeli yang menunggu, tombol ini menandai pembeli terakhir sebagai selesai.
- **Batal.** Membatalkan nomor menunggu yang paling akhir diambil. Jika yang dibatalkan adalah nomor terbaru, nomor tersebut dapat dipakai kembali. Jumlah pembatalan ikut dihitung pada halaman Statistik.
- **Reset.** Tombol di pojok kanan atas halaman Hitung Antrian. Sebelum data dihapus, aplikasi meminta konfirmasi terlebih dahulu. Reset menghapus antrian, riwayat, dan statistik.
- **Estimasi waktu tunggu.** Dihitung dari jumlah pembeli yang menunggu dikalikan 3 menit per pembeli.
- **Daftar menunggu dan daftar selesai.** Nomor terdepan diberi warna berbeda agar mudah dikenali. Daftar selesai menampilkan nomor terbaru lebih dahulu, dibatasi 30 nomor, dan sisanya diringkas menjadi keterangan "+N lainnya".
- **Notifikasi singkat.** Setiap aksi, baik berhasil maupun ditolak, ditampilkan sebagai pesan di bagian bawah layar pada halaman mana pun.

### Halaman Beranda

- Kartu sambutan dengan salam yang menyesuaikan waktu (pagi, siang, sore, atau malam).
- Empat kartu statistik: Nomor Diambil, Sedang Dilayani, Menunggu, dan Selesai Dilayani.
- Bilah progres yang menunjukkan persentase pembeli yang sudah selesai dilayani.
- Menu pintas ke Layar Pelanggan, Riwayat, dan Statistik.
- Tiga langkah singkat cara menggunakan aplikasi.

### Halaman Layar Pelanggan

Halaman ini ditujukan untuk pembeli, sehingga sengaja dibuat bersih: tidak ada AppBar dan tidak ada Drawer. Menu samping, Riwayat, dan Statistik tidak tersedia dari halaman ini.

- Kartu besar berisi nomor yang sedang dilayani, dengan animasi saat nomor berganti.
- Daftar enam nomor berikutnya, ditambah keterangan jumlah pembeli lainnya yang masih menunggu.
- Estimasi lama menunggu untuk pembeli.
- Tombol panah kembali di pojok kanan atas, khusus penjual. Cukup sekali ketuk untuk kembali ke halaman Hitung Antrian.

### Halaman Riwayat

- Setiap pembeli yang dipanggil muncul sebagai satu baris, dengan yang terbaru di atas.
- Informasi yang ditampilkan: nomor, status (sedang dilayani atau selesai), jam diambil, jam dipanggil, lama menunggu, dan lama layanan.

### Halaman Statistik

- Total pembeli, rata-rata lama menunggu, rata-rata lama layanan, dan jumlah pembatalan.
- Komposisi antrian: selesai, sedang dilayani, menunggu, dan dibatalkan, ditampilkan sebagai bilah perbandingan.
- Grafik batang jumlah nomor yang diambil. Pengelompokannya menyesuaikan data: per 5 menit bila seluruh nomor diambil dalam rentang 90 menit, dan per jam bila lebih lama. Batang tersibuk disorot kuning, dan di bawah grafik tertera total serta rentang waktu tersibuk.
- Rata-rata lama layanan hanya dihitung dari pembeli yang sudah selesai dilayani.

### Tampilan dan tema

- Mode gelap, dengan pilihan Terang, Gelap, atau Sistem (mengikuti pengaturan perangkat).
- Dynamic theme: warna aplikasi dapat diganti saat aplikasi berjalan tanpa perlu memulai ulang. Tersedia 8 pilihan warna.
- Gaya **Soft Neo-Brutalism**: outline tinta tebal, bayangan keras tanpa blur, warna flat, dan tombol berbentuk pill. Warna utama tetap mengikuti pilihan warna tema.
- Logo jam pasir beroutline dan latar belakang berpola polkadot yang digambar langsung dengan kode, sehingga tidak memerlukan berkas gambar.
- Tampilan responsif. Pada layar lebar (900 dp atau lebih), menu samping tampil permanen di sisi kiri. Pada layar sempit, menu dibuka melalui ikon tiga garis.

## Teknologi yang Digunakan

| Komponen | Keterangan |
| --- | --- |
| Flutter dengan Material 3 | Kerangka kerja tampilan. |
| Dart 3 | Bahasa pemrograman. |
| `flutter_bloc` | Pengelolaan state menggunakan Cubit. |
| Material App Drawer | Menu samping untuk navigasi dan pengaturan tema. |
| `CustomPainter` | Menggambar logo dan latar belakang (pola polkadot dan lingkaran hias). |
| Soft Neo-Brutalism | Gaya antarmuka buatan sendiri dari `BoxDecoration` (border dan `BoxShadow` tanpa blur) dan widget `TombolNeo`, tanpa paket tambahan. |

Aplikasi ini hanya membutuhkan satu paket tambahan, yaitu `flutter_bloc`. Grafik pada halaman Statistik dibuat dengan widget bawaan Flutter, tanpa paket grafik.

## Persiapan dan Cara Menjalankan

### Kebutuhan

- Flutter SDK. Disarankan versi 3.22 atau yang lebih baru (Dart 3).
- Editor kode, misalnya Visual Studio Code dengan ekstensi Flutter dan Dart.
- Salah satu tujuan menjalankan aplikasi: Google Chrome, Microsoft Edge, emulator Android, atau ponsel Android.

Untuk memeriksa kesiapan lingkungan, jalankan perintah berikut dan pastikan tidak ada masalah yang tertera:

```
flutter doctor
```

### Langkah-langkah

**1. Buat proyek baru**

```
flutter create sabarin
cd sabarin
```

Jika proyek sudah ada (misalnya `uts_mobile`), langkah ini dilewati dan perintah berikutnya dijalankan di folder proyek tersebut.

**2. Tambahkan paket `flutter_bloc`**

```
flutter pub add flutter_bloc
```

Perintah ini otomatis menuliskan paket tersebut pada `pubspec.yaml`. Jika ingin menuliskannya secara manual, tambahkan baris berikut pada bagian `dependencies`, lalu jalankan `flutter pub get`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.6
```

Indentasi harus tepat dua spasi dan tidak boleh memakai tab.

**3. Salin folder `lib`**

Hapus seluruh isi folder `lib/` pada proyek, kemudian salin seluruh isi folder `lib/` dari Sabarin (berkas `main.dart` dan `app.dart`, serta folder `core`, `cubit`, `widgets`, dan `halaman`) beserta struktur foldernya. Jangan memindahkan berkas ke folder lain karena setiap berkas saling mengimpor dengan alamat relatif.

Jika terdapat berkas `test/widget_test.dart` bawaan, hapus berkas tersebut atau abaikan, karena isinya merujuk pada aplikasi contoh bawaan Flutter.

**4. Jalankan aplikasi**

Pilih salah satu perintah sesuai tujuan:

```
flutter run -d chrome        # di peramban Chrome
flutter run -d edge          # di peramban Edge
flutter run                  # di emulator atau ponsel yang terhubung
```

Untuk melihat daftar perangkat yang tersedia, gunakan:

```
flutter devices
```

Jika menggunakan Visual Studio Code, aplikasi juga dapat dijalankan dengan menekan tombol Run pada berkas `main.dart`, atau tombol F5.

## Panduan Penggunaan

### Alur penggunaan harian

1. Buka aplikasi, lalu pilih menu **Hitung Antrian**.
2. Setiap ada pembeli baru, tekan **Ambil Nomor**. Nomor muncul pada daftar menunggu.
3. Saat penjual siap melayani, tekan **Panggil Berikutnya**. Nomor terdepan tampil pada kartu besar "Sedang Dilayani".
4. Ulangi langkah 2 dan 3 sesuai kebutuhan. Nomor yang telah dilayani berpindah ke daftar "Sudah Dilayani".
5. Jika ada pembeli yang batal menunggu, tekan **Batal** untuk menghapus nomor terakhir.
6. Buka **Layar Pelanggan** lewat menu samping atau menu pintas di Beranda, lalu arahkan layar ke pembeli. Untuk kembali ke menu penjual, ketuk tombol panah kembali di pojok kanan atas.
7. Buka **Riwayat** dan **Statistik** untuk melihat rincian pelayanan.
8. Pada akhir hari, tekan ikon reset di pojok kanan atas halaman Hitung Antrian, lalu pilih **Ya, reset** untuk memulai antrian dari awal.

### Contoh

Misalkan tiga pembeli datang berturut-turut. Setelah menekan **Ambil Nomor** tiga kali, daftar menunggu berisi `A-001`, `A-002`, dan `A-003`. Ketika **Panggil Berikutnya** ditekan, `A-001` tampil pada kartu "Sedang Dilayani", sedangkan daftar menunggu tersisa `A-002` dan `A-003`. Pada penekanan berikutnya, `A-001` pindah ke daftar selesai dan `A-002` mulai dilayani. Setelah itu, halaman Riwayat memuat dua baris (`A-002` dan `A-001`), dan halaman Statistik menampilkan rata-rata lama menunggu dan lama layanan.

### Pesan yang mungkin muncul

| Situasi | Pesan |
| --- | --- |
| Nomor sudah mencapai 999 | Meminta pengguna melakukan reset antrian. |
| Menekan Panggil Berikutnya saat tidak ada antrian dan tidak ada yang dilayani | Memberi tahu bahwa belum ada pembeli yang menunggu. |
| Menekan Batal saat daftar menunggu kosong | Memberi tahu bahwa tidak ada nomor yang dapat dibatalkan. |
| Menekan reset saat antrian masih kosong | Memberi tahu bahwa antrian masih kosong. |

## Pengaturan Tema

Seluruh pengaturan tema berada pada bagian bawah menu samping.

- **Mode Gelap.** Saklar untuk berpindah antara tema terang dan gelap. Saat pilihan "Sistem" aktif, posisi saklar mengikuti tema perangkat.
- **Terang / Gelap / Sistem.** Tiga pilihan mode. "Sistem" mengikuti pengaturan perangkat secara otomatis.
- **Warna Tema.** Delapan lingkaran warna. Warna yang aktif ditandai dengan tanda centang, dan namanya tertera di sebelah tulisan "Warna Tema".

Daftar warna yang tersedia:

| No. | Nama | Kode warna |
| --- | --- | --- |
| 1 | Biru Laut | `#1E88E5` |
| 2 | Hijau Daun | `#2E9E5B` |
| 3 | Merah Saga | `#E53935` |
| 4 | Ungu Senja | `#7E57C2` |
| 5 | Jingga Mentari | `#FB8C00` |
| 6 | Tosca Lagun | `#00A79D` |
| 7 | Merah Muda | `#EC407A` |
| 8 | Indigo Malam | `#3949AB` |

Cara kerjanya: satu warna dipakai sebagai warna dasar (seed), lalu `ColorScheme.fromSeed` membentuk seluruh palet untuk tema terang maupun gelap. Latar halaman, warna teks, dan warna outline tidak berasal dari seed, tetapi disetel tetap oleh `bangunTema` agar gaya Neo-Brutalism konsisten (krem dengan tinta hitam pada mode terang, hitam pekat dengan tinta krem pada mode gelap). Karena warna disimpan dalam state, perubahan langsung berlaku pada semua halaman. Warna bawaan saat aplikasi pertama kali dibuka adalah Tosca Lagun dengan mode Sistem.

## Gaya Desain

Antarmuka memakai **Soft Neo-Brutalism**: tegas dan mudah dibaca dari jauh, tetapi tetap ramah karena bentuknya membulat dan warnanya hanya satu aksen. Gaya ini dipilih karena Sabarin dipakai berulang kali oleh penjual dan nomor antrian harus terlihat jelas oleh pembeli.

| Unsur | Penerapan |
| --- | --- |
| Outline | Semua kartu, tombol, badge, dan bar progres memakai garis tinta setebal 2 px (`tebalGaris`). |
| Hard shadow | Bayangan solid tanpa blur yang bergeser ke kanan-bawah (`bayanganKeras`). Kartu besar memakai jarak 6 px, kartu biasa 4 px, badge kecil 2 px. |
| Warna | Latar krem (mode terang) atau hitam pekat (mode gelap), kartu putih atau abu gelap, satu aksen dari warna tema, dan kuning tetap (`warnaKuning`) untuk tombol Ambil Nomor, badge jumlah, serta kartu estimasi di Layar Pelanggan. |
| Bentuk | Kartu bersudut membulat; tombol berbentuk pill; titik warna tema berbentuk lingkaran. |
| Teks | Judul dan angka memakai bobot sangat tebal. Warna teks di atas warna aksen otomatis hitam atau putih lewat `teksDi`, sehingga tetap terbaca pada kedelapan warna tema. |
| Latar | Warna flat dengan pola polkadot tipis dan dua lingkaran hias, tanpa gradasi. |
| Interaksi | `TombolNeo` bergeser ke arah bayangannya saat ditekan sehingga terasa seperti tombol fisik. |

Seluruh gaya dipusatkan pada beberapa fungsi bantu di `lib/core/tema.dart`:

| Nama | Fungsi |
| --- | --- |
| `tinta(skema)` | Warna outline, bayangan, dan teks tegas (hitam pada mode terang, krem pada mode gelap). |
| `teksDi(latar)` | Memilih teks hitam atau putih agar kontras di atas warna `latar`. |
| `bayanganKeras(skema, jarak)` | Membuat bayangan solid tanpa blur. |
| `dekorasiNeo(skema, warna:, radius:, jarak:)` | `BoxDecoration` lengkap: warna flat, outline, dan hard shadow. |
| `warnaKartu(skema)` | Warna latar kartu (putih atau abu gelap, dengan sedikit rona warna utama). |

Dua widget melengkapinya: `TombolNeo` (`lib/widgets/komponen.dart`, tombol pill beroutline dengan efek tertekan) dan `BatangProgres` (`lib/widgets/komponen.dart`, bar progres beroutline untuk Beranda dan Statistik). Fungsi dan logika Cubit tidak berubah akibat pergantian gaya ini.

## Struktur Kode

Kode dipisah per tanggung jawab. Pembagian foldernya sebagai berikut:

```
lib/
├── main.dart                       Titik masuk, penanganan error global, layar galat
├── app.dart                        SabarinApp (provider, MaterialApp) dan pemetaan rute
├── core/
│   ├── konfigurasi.dart            Konfigurasi, fungsi format, dan daftar menu navigasi
│   └── tema.dart                   Token desain Neo-Brutalism dan bangunTema
├── cubit/
│   ├── tema_cubit.dart             TemaState dan TemaCubit
│   └── antrian_cubit.dart          AntrianState dan AntrianCubit
├── widgets/
│   ├── komponen.dart               Kartu, TombolNeo, BatangProgres, KartuStat, KartuDilayani,
│   │                               LencanaNomor, InfoKosong, tata letak, tampilkanPesan,
│   │                               LogoSabarin, dan LatarHias
│   └── kerangka_halaman.dart       KerangkaHalaman, PanelSamping, dan PengaturanTema
└── halaman/
    ├── halaman_beranda.dart
    ├── halaman_antrian.dart
    ├── halaman_layar_pelanggan.dart
    ├── halaman_riwayat.dart
    ├── halaman_statistik.dart
    └── halaman_tentang.dart
```

Aturan umumnya: `core` tidak bergantung pada folder lain, `cubit` hanya bergantung pada `core`, `widgets` boleh memakai `core` dan `cubit`, dan `halaman` memakai ketiganya. Widget yang hanya dipakai satu halaman (misalnya `_KartuSambutan`) tetap berada di berkas halaman tersebut dan bersifat privat. Komponen yang dipakai banyak halaman dikumpulkan di `widgets/komponen.dart`. Lima halaman memakai `KerangkaHalaman`; `HalamanLayarPelanggan` berdiri sendiri tanpa menu.

### Alur state management

Aplikasi memakai pola Cubit: widget memanggil method, Cubit memancarkan state baru dengan `emit()`, lalu `BlocBuilder` menggambar ulang bagian tampilan yang terkait.

```
Widget (tombol ditekan)
   -> memanggil method pada Cubit
   -> Cubit memancarkan state baru (emit)
   -> BlocBuilder membangun ulang tampilan
```

Kedua Cubit (`TemaCubit` dan `AntrianCubit`) dipasang di atas `MaterialApp` pada `app.dart` menggunakan `MultiBlocProvider`, sehingga dapat diakses oleh semua halaman. Pesan notifikasi diteruskan lewat state dan ditampilkan oleh `BlocListener` pada `KerangkaHalaman`.

### Data riwayat dan statistik

Setiap kali sebuah nomor dipanggil, `AntrianCubit` menambahkan satu `CatatanLayanan` yang berisi nomor, jam diambil, dan jam dipanggil. Jam selesai diisi ketika nomor berikutnya dipanggil atau ketika antrian sudah kosong. Halaman Riwayat menampilkan catatan tersebut, sedangkan halaman Statistik menghitung rata-ratanya. Karena keduanya membaca state yang sama, angka pada kedua halaman selalu sejalan.

## Menambah Halaman Baru

Karena kerangkanya sudah dipisahkan, halaman baru cukup melalui empat langkah:

1. Tambahkan nama rute pada kelas `Konfigurasi` di `lib/core/konfigurasi.dart`, misalnya `static const String ruteContoh = '/contoh';`.
2. Tambahkan satu baris pada daftar `daftarMenu` di `lib/core/konfigurasi.dart` agar menu muncul di Drawer.
3. Buat berkas halaman baru, misalnya `lib/halaman/halaman_contoh.dart`, yang membungkus isinya dengan `KerangkaHalaman` sehingga AppBar, Drawer, latar, notifikasi, dan tema otomatis tersedia.
4. Tambahkan `import` halaman baru di bagian atas `lib/app.dart`, lalu satu `case` pada fungsi `bangunHalaman` di berkas yang sama yang mengembalikan widget halaman tersebut.

## Penanganan Kesalahan

Beberapa lapis pengaman disiapkan agar aplikasi tetap berjalan:

1. **Penangkap kesalahan global.** `FlutterError.onError` dan `PlatformDispatcher.onError` mencatat kesalahan tak terduga tanpa menghentikan aplikasi. Pada mode rilis, `ErrorWidget.builder` menampilkan pesan yang ramah sebagai pengganti layar error bawaan.
2. **`try-catch` pada Cubit.** Setiap method antrian dibungkus `try-catch`. Cubit juga memeriksa `isClosed` sebelum memancarkan state.
3. **Validasi aksi.** Batas nomor, antrian kosong, dan pembatalan saat kosong ditolak disertai pesan yang jelas.
4. **Rute aman.** Nama rute yang tidak dikenal diarahkan ke Beranda sehingga tidak muncul layar kosong.
5. **Konfirmasi reset.** Data antrian tidak terhapus tanpa persetujuan pengguna.
6. **Tampilan yang aman.** `FittedBox`, pemotongan teks (`ellipsis`), `Wrap`, dan pembatasan lebar konten mencegah teks meluber pada layar kecil. Indeks warna tema juga dibatasi agar selalu berada dalam rentang yang valid.
7. **Data kosong.** Halaman Riwayat dan Statistik menampilkan keterangan yang jelas ketika belum ada data, dan perhitungan rata-rata tidak dilakukan bila datanya belum ada.

## Mengubah Konfigurasi

Nilai-nilai utama dikumpulkan pada kelas `Konfigurasi` di `lib/core/konfigurasi.dart`:

| Konstanta | Fungsi | Nilai awal |
| --- | --- | --- |
| `namaAplikasi` | Nama yang tampil pada drawer, beranda, dan judul aplikasi | `Sabarin` |
| `tagline` | Keterangan di bawah nama aplikasi | `Hitung antrian pembeli` |
| `versi` | Teks versi pada drawer dan halaman Tentang | `Versi 1.1.0` |
| `awalanNomor` | Huruf awal nomor antrian | `A` |
| `nomorMaksimal` | Batas nomor dalam satu periode | `999` |
| `menitPerPembeli` | Dasar perhitungan estimasi waktu tunggu | `3` |
| `batasTampilSelesai` | Jumlah nomor selesai yang ditampilkan di halaman Hitung Antrian | `30` |
| `batasLebar` | Lebar layar (dp) untuk menu samping permanen | `900` |
| `menitBatangGrafik` | Lebar satu batang pada grafik Statistik bila data berada dalam rentang singkat | `5` |
| `batasRentangGrafik` | Rentang waktu (menit) tertinggi agar grafik dibuat per `menitBatangGrafik`; bila lebih lama, grafik per jam | `90` |

Untuk mengubah karakter gaya desain, sesuaikan nilai berikut di `lib/core/tema.dart`:

| Nilai | Fungsi |
| --- | --- |
| `tebalGaris` | Ketebalan outline semua komponen (awal: `2.0`). |
| `warnaKuning` | Warna kuning untuk tombol dan badge sekunder. |
| Parameter `jarak` pada `dekorasiNeo` | Jarak hard shadow. Nilai `0` menghilangkan bayangan. |
| Parameter `radius` pada `dekorasiNeo` | Kebulatan sudut kartu (awal: `20`). |

Untuk menambah atau mengganti warna tema, ubah daftar `daftarWarna` di `lib/cubit/tema_cubit.dart`. Setiap entri berisi nama dan kode warna, dan tampilan pilihan warna di drawer menyesuaikan jumlah entri secara otomatis.

## Pemecahan Masalah

**Muncul pesan `Couldn't resolve the package 'flutter_bloc'` atau `Target of URI doesn't exist: 'package:flutter_bloc/flutter_bloc.dart'`.**
Paket belum terpasang. Jalankan `flutter pub add flutter_bloc`, kemudian `flutter pub get`, lalu jalankan ulang aplikasi dari awal (bukan hot reload).

**Muncul pesan galat pada `surface`, `withAlpha`, atau properti `ColorScheme` lain.**
Versi Flutter kemungkinan terlalu lama. Perbarui dengan `flutter upgrade`, lalu periksa kembali dengan `flutter --version`.

**Muncul galat pada `sealed`, `switch` berbentuk ekspresi, atau sintaks Dart lain yang tidak dikenali.**
Versi Dart yang digunakan di bawah 3.0. Perbarui Flutter agar Dart ikut diperbarui.

**Muncul peringatan `activeColor` is deprecated pada `Switch`.**
Ini hanya peringatan pada Flutter versi terbaru dan tidak menghentikan aplikasi. Bila ingin menghilangkannya, ganti `activeColor` menjadi `activeThumbColor` pada `Switch` di `lib/widgets/kerangka_halaman.dart`.

**Muncul galat nama seperti `The getter ... isn't defined` setelah menyalin kode.**
Biasanya ada berkas yang belum tersalin atau salah folder. Pastikan seluruh isi folder `lib/` tersalin lengkap dengan struktur foldernya, lalu jalankan ulang aplikasi dari awal (bukan hot reload).

**Aplikasi tidak muncul di Chrome atau Edge.**
Pastikan peramban terpasang dan terdeteksi pada `flutter devices`. Bila belum, jalankan `flutter config --enable-web`.

**Emulator tidak terdeteksi.**
Buka Android Studio, nyalakan emulator melalui Device Manager, lalu periksa kembali dengan `flutter devices`.

**Tampilan tidak berubah setelah kode diedit.**
Tekan `r` pada terminal untuk hot reload, atau `R` untuk hot restart. Perubahan pada state awal atau daftar menu biasanya memerlukan hot restart.

**Tidak bisa keluar dari Layar Pelanggan.**
Halaman ini tidak memiliki menu. Ketuk tombol panah kembali di pojok kanan atas, maka aplikasi kembali ke halaman Hitung Antrian.

**Riwayat dan Statistik kosong.**
Kedua halaman baru terisi setelah tombol **Panggil Berikutnya** ditekan setidaknya sekali pada halaman Hitung Antrian.

## Keterbatasan

- Data antrian, riwayat, dan pengaturan tema disimpan di memori saja. Ketika aplikasi ditutup atau dimulai ulang, semuanya kembali ke kondisi awal.
- Aplikasi hanya memiliki satu peran, yaitu penjual. Belum ada PIN atau pemisahan akun; perlindungan untuk pembeli hanya berupa halaman Layar Pelanggan yang tanpa menu.
- Aplikasi dirancang untuk satu perangkat kasir. Halaman Layar Pelanggan hanya menampilkan data dari aplikasi yang sama dan belum tersinkron antarperangkat.
- Pemanggilan nomor ditampilkan secara visual dan belum disertai suara.
- Warna kuning pada gaya desain bersifat tetap dan tidak ikut berubah saat warna tema diganti.
- Statistik hanya mencakup satu periode antrian, yaitu sejak aplikasi dibuka atau sejak reset terakhir.

Pengembangan lanjutan yang dapat dipertimbangkan adalah penyimpanan data dengan `shared_preferences`, sinkronisasi layar pelanggan antarperangkat, notifikasi suara saat nomor dipanggil, dan ekspor riwayat harian.
