import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tubes_peukanrumoh_707012400102/halaman/data/data_contoh.dart';
import 'package:tubes_peukanrumoh_707012400102/halaman/halaman_utama.dart';
import 'package:tubes_peukanrumoh_707012400102/main.dart';
import 'package:tubes_peukanrumoh_707012400102/navigation/app_routes.dart';
import 'package:tubes_peukanrumoh_707012400102/navigation/kerangka_navigasi.dart';
import 'package:tubes_peukanrumoh_707012400102/pages/form_input_page.dart';
import 'package:tubes_peukanrumoh_707012400102/pages/tombol_interaksi_page.dart';
import 'package:tubes_peukanrumoh_707012400102/theme/theme_controller.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester, {Size size = const Size(400, 900)}) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = size;
    addTearDown(tester.view.reset);
    addTearDown(() {
      ThemeController.instance.setDark(false);
    });

    await tester.pumpWidget(const PeukanRumohApp());
    await tester.pumpAndSettle();
  }

  testWidgets('route salah tulis jatuh ke halaman tidak ditemukan', (tester) async {
    await pumpApp(tester);

    final context = tester.element(find.byType(KerangkaUtama));
    Navigator.of(context).pushNamed('/prodak');
    await tester.pumpAndSettle();

    expect(find.text('Halaman tidak ditemukan'), findsOneWidget);
    expect(find.textContaining('/prodak'), findsOneWidget);
  });

  testWidgets('Navigation Bar tampil di layar sempit', (tester) async {
    await pumpApp(tester);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('Navigation Rail menggantikan Navigation Bar di layar lebar', (tester) async {
    await pumpApp(tester, size: const Size(1200, 800));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('drawer berisi Tentang Aplikasi dan bisa dibuka', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    expect(find.text('Tentang Aplikasi'), findsOneWidget);

    await tester.tap(find.text('Tentang Aplikasi'));
    await tester.pumpAndSettle();

    expect(find.text('Materi navigasi yang diterapkan'), findsOneWidget);
  });

  testWidgets('item drawer selain Tentang memindahkan tab', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();

    expect(find.text('Alamat pengiriman'), findsOneWidget);
    expect(find.text(profilContoh.email), findsOneWidget);

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Beranda').last);
    await tester.pumpAndSettle();

    expect(find.text('Cari sayur, buah, atau bumbu...'), findsOneWidget);
  });

  testWidgets('alur beli langsung: push dengan data lalu pop dengan data', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text(daftarProdukContoh.first.nama).first);
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Beli Langsung'));
    await tester.pumpAndSettle();
    expect(find.text('Ringkasan pesanan'), findsOneWidget);
    expect(find.text('Metode pembayaran'), findsOneWidget);

    await tester.tap(find.textContaining('Bayar Rp').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ya, Bayar'));
    await tester.pumpAndSettle();

    expect(find.text(daftarProdukContoh.first.nama), findsOneWidget);
  });

  testWidgets('tambah ke keranjang lalu bayar dari keranjang', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text(daftarProdukContoh.first.nama).first);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlinedButton, 'Tambah ke Keranjang'));
    await tester.pumpAndSettle();
    expect(find.textContaining('masuk keranjang'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Keranjang'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Total Bayar'), findsOneWidget);
    expect(find.textContaining('Bayar Rp'), findsNothing);

    await tester.tap(find.text('Bayar'));
    await tester.pumpAndSettle();
    expect(find.text('Ringkasan pesanan'), findsOneWidget);
    expect(find.textContaining('Bayar Rp'), findsOneWidget);
  });

  testWidgets('tab pesanan berpindah kategori', (tester) async {
    await pumpApp(tester);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Pesanan'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Pesanan #'), findsWidgets);

    final tabDiproses = find.descendant(
      of: find.byType(TabBar),
      matching: find.text('Diproses'),
    );
    await tester.ensureVisible(tabDiproses);
    await tester.pumpAndSettle();
    await tester.tap(tabDiproses);
    await tester.pumpAndSettle();
    expect(find.text('Pesanan #2401'), findsOneWidget);

    final tabSelesai = find.descendant(
      of: find.byType(TabBar),
      matching: find.text('Selesai'),
    );
    await tester.ensureVisible(tabSelesai);
    await tester.pumpAndSettle();
    await tester.tap(tabSelesai);
    await tester.pumpAndSettle();
    expect(find.text('Pesanan #2310'), findsOneWidget);
  });

  testWidgets('detail pesanan dibuka dari daftar', (tester) async {
    await pumpApp(tester);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Pesanan'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pesanan #2401'));
    await tester.pumpAndSettle();

    expect(find.textContaining('PR-2401'), findsOneWidget);
    expect(find.text('Produk dipesan'), findsOneWidget);
  });

  testWidgets('tambah barang di beranda: badge navigasi + profil ikut berubah',
      (tester) async {
    await pumpApp(tester);

    // Badge navigasi masih 0, tidak terlihat.
    expect(find.byType(NavigationBar), findsOneWidget);

    // Tambah produk pertama dari kartu beranda (tombol + di kartu).
    final tombolTambah = find.byTooltip('Tambah ke keranjang').first;
    await tester.tap(tombolTambah);
    await tester.pumpAndSettle();

    // Badge pada tombol keranjang di AppBar muncul (badge BottomNav pun ikut
    // ter-update, dua-duanya dari Provider yang sama, jadi findsWidgets).
    final badgeJumlah1 = find.descendant(
      of: find.byTooltip('Keranjang'),
      matching: find.text('1'),
    );
    expect(badgeJumlah1, findsWidgets);

    // Pindah ke profil: kartu Keranjang aktif menampilkan data dari Provider.
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Profil'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Keranjang aktif'), findsOneWidget);
    expect(find.text('1 barang • 1 jenis'), findsOneWidget);

    // Kembali ke beranda, tambah lagi, jumlah di profil ikut naik.
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Beranda'),
      ),
    );
    await tester.pumpAndSettle();

    // Tambah produk BERBEDA (kartu kedua), supaya 2 barang dari 2 jenis.
    await tester.tap(find.byTooltip('Tambah ke keranjang').at(1));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Profil'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('2 barang • 2 jenis'), findsOneWidget);
  });

  testWidgets('kurangi di halaman keranjang sampai kosong memperbarui UI',
      (tester) async {
    await pumpApp(tester);

    await tester.tap(find.byTooltip('Tambah ke keranjang').first);
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Keranjang'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Keranjang masih kosong'), findsNothing);
    expect(find.text('Total Bayar'), findsOneWidget);

    // Kurangi sampai item hilang (jumlah 1 -> dihapus).
    final tombolKurang = find.byTooltip('Kurangi jumlah');
    expect(tombolKurang, findsOneWidget);
    await tester.tap(tombolKurang);
    await tester.pumpAndSettle();

    expect(find.text('Keranjangmu masih kosong'), findsOneWidget);
    expect(find.text('Total Bayar'), findsNothing);
  });

  testWidgets('setState lokal: toggle tampilan grid <-> daftar', (tester) async {
    await pumpApp(tester);

    await tester.pumpAndSettle(); // tunggu 0.7s status memuat selesai

    // Mode awal grid: GridView tampil, ListView daftar tidak.
    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(KartuProdukBaris), findsNothing);

    // Pindah ke mode daftar.
    await tester.tap(find.text('Daftar'));
    await tester.pumpAndSettle();

    expect(find.byType(KartuProdukBaris), findsWidgets);
    expect(find.byType(GridView), findsNothing);

    // Kembali ke grid.
    await tester.tap(find.text('Grid'));
    await tester.pumpAndSettle();
    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('semua halaman mengakses Provider tanpa ProviderNotFoundException',
      (tester) async {
    await pumpApp(tester);

    for (final namaTab in ['Keranjang', 'Pesanan', 'Profil']) {
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(namaTab),
        ),
      );
      await tester.pumpAndSettle();
      // Tidak ada exception yang terlempar -> pumpAndSettle di atas sudah
      // gagal bila ProviderNotFoundException dilempar saat build.
    }

    // Juga halaman terpisah: keranjang sebagai route, detail produk, dan bayar.
    final context = tester.element(find.byType(KerangkaUtama));
    Navigator.of(context).pushNamed(AppRoutes.cekRouteKeranjang);
    await tester.pumpAndSettle();
    expect(find.text('Keranjangmu masih kosong'), findsOneWidget);
  });

  testWidgets('tombol mode gelap mengubah tema aplikasi', (tester) async {
    await pumpApp(tester);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Profil'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mode gelap'), findsOneWidget);
    expect(ThemeController.instance.isDark, isFalse);

    await tester.tap(find.text('Mode gelap'));
    await tester.pumpAndSettle();

    expect(ThemeController.instance.isDark, isTrue);
    expect(find.text('Nyaman dipakai malam hari'), findsOneWidget);

    await tester.tap(find.text('Mode gelap'));
    await tester.pumpAndSettle();

    expect(ThemeController.instance.isDark, isFalse);
    expect(find.text('Tampilan cerah siang hari'), findsOneWidget);
  });

  testWidgets('materi 1: Form & Input (TextField, Checkbox, RadioButton) mengupdate Provider dan terbaca di Profil', (tester) async {
    await pumpApp(tester);

    // Buka Halaman Form & Input via navigasi route
    final context = tester.element(find.byType(KerangkaUtama));
    Navigator.of(context).pushNamed(AppRoutes.formInput);
    await tester.pumpAndSettle();

    expect(find.text('Form & Input Peukan'), findsOneWidget);
    expect(find.text('1. Data Pemesan (TextField)'), findsOneWidget);
    expect(find.text('2. Opsi Kemasan & Layanan (Checkbox)'), findsOneWidget);
    expect(find.text('3. Pilihan Kurir Pengantaran (RadioButton)'), findsOneWidget);
    expect(find.text('4. Pilihan Metode Pembayaran (RadioButton)'), findsOneWidget);

    // Ubah nama pemesan di TextField
    final namaField = find.widgetWithText(TextField, 'Nama Lengkap Pemesan');
    await tester.enterText(namaField, 'Teuku Umar');
    await tester.pumpAndSettle();

    // Toggle Checkbox
    final checkboxBersihkan = find.widgetWithText(CheckboxListTile, 'Bersihkan & Potong Bahan');
    await tester.ensureVisible(checkboxBersihkan);
    await tester.tap(checkboxBersihkan);
    await tester.pumpAndSettle();

    // Pilih RadioButton Pengiriman
    final radioKurirHemat = find.widgetWithText(RadioListTile<String>, 'Kurir Peukan Hemat');
    await tester.ensureVisible(radioKurirHemat);
    await tester.tap(radioKurirHemat);
    await tester.pumpAndSettle();

    // Simpan ke Provider dengan ElevatedButton
    final tombolSimpan = find.widgetWithText(ElevatedButton, 'Simpan ke Provider');
    await tester.ensureVisible(tombolSimpan);
    await tester.tap(tombolSimpan);
    await tester.pumpAndSettle();

    // Kembali ke beranda lalu buka Profil untuk memeriksa sinkronisasi data multi-page
    Navigator.of(tester.element(find.byType(HalamanFormInput))).pop();
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Profil'),
      ),
    );
    await tester.pumpAndSettle();

    // Gulir ke bawah di Profil untuk melihat kartu sinkronisasi Form
    final kartuForm = find.text('Preferensi Form & Input');
    await tester.scrollUntilVisible(kartuForm, 300);
    await tester.pumpAndSettle();

    expect(find.text('Preferensi Form & Input'), findsOneWidget);
    expect(find.text('Teuku Umar'), findsOneWidget);
    expect(find.text('Kurir Peukan Hemat'), findsOneWidget);
  });

  testWidgets('materi 2: Tombol & Interaksi (ElevatedButton, FAB, GestureDetector) mengupdate Provider', (tester) async {
    await pumpApp(tester);

    // Buka Halaman Tombol & Interaksi
    final context = tester.element(find.byType(KerangkaUtama));
    Navigator.of(context).pushNamed(AppRoutes.tombolInteraksi);
    await tester.pumpAndSettle();

    expect(find.text('Tombol & Interaksi Peukan'), findsOneWidget);
    expect(find.text('100 Poin'), findsOneWidget);
    expect(find.text('0 Kali'), findsOneWidget);

    // Uji 1: ElevatedButton Klaim Kupon
    final tombolKupon = find.widgetWithText(ElevatedButton, 'Klaim Kupon Belanja (+15 Poin)');
    await tester.tap(tombolKupon);
    await tester.pumpAndSettle();

    expect(find.text('115 Poin'), findsOneWidget);
    expect(find.text('1 Kali'), findsOneWidget);
    expect(find.textContaining('Klaim Kupon'), findsWidgets);

    // Uji 2: FloatingActionButton ditekan
    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget);
    await tester.tap(fab);
    await tester.pumpAndSettle();

    expect(find.text('135 Poin'), findsOneWidget);
    expect(find.text('2 Kali'), findsOneWidget);

    // Uji 3: GestureDetector (Tap tunggal dan Double Tap)
    final gestureBox = find.textContaining('Ketuk 1x | Ketuk 2x');
    await tester.ensureVisible(gestureBox);
    await tester.tap(gestureBox);
    await tester.pumpAndSettle();

    expect(find.text('140 Poin'), findsOneWidget);
    expect(find.text('3 Kali'), findsOneWidget);

    // Double tap pada GestureDetector
    await tester.tap(gestureBox);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(gestureBox);
    await tester.pumpAndSettle();

    expect(find.text('150 Poin'), findsOneWidget);
    expect(find.text('4 Kali'), findsOneWidget);

    // Periksa bahwa data interaksi terbaca di halaman lain (Halaman Profil)
    Navigator.of(tester.element(find.byType(HalamanTombolInteraksi))).pop();
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Profil'),
      ),
    );
    await tester.pumpAndSettle();

    final kartuInteraksi = find.text('Poin & Interaksi Tombol');
    await tester.scrollUntilVisible(kartuInteraksi, 300);
    await tester.pumpAndSettle();

    expect(find.text('Poin & Interaksi Tombol'), findsOneWidget);
    expect(find.text('150 Poin'), findsOneWidget);
    expect(find.textContaining('4 interaksi tercatat'), findsOneWidget);
  });

  testWidgets('materi 3: Pustaka Chat menampilkan daftar pesan dan mengirim pesan baru', (tester) async {
    await pumpApp(tester);

    // Buka tab Chat dari Bottom Navigation Bar
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Chat'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Penjual Peukan Rumoh'), findsOneWidget);
    expect(find.text('Pustaka Chat Pasar Tradisional'), findsOneWidget);

    // Ketik pesan baru di TextField
    final chatField = find.widgetWithText(TextField, 'Tulis pesan kebutuhan pasar...');
    await tester.enterText(chatField, 'Bisa minta daun kari segar?');
    await tester.pumpAndSettle();

    // Kirim pesan dengan tombol kirim
    final tombolKirim = find.widgetWithIcon(ElevatedButton, Icons.send);
    await tester.tap(tombolKirim);
    await tester.pumpAndSettle();

    expect(find.text('Bisa minta daun kari segar?'), findsOneWidget);

    // Tunggu simulasi balasan otomatis penjual
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();

    expect(find.textContaining('pesan telah diterima oleh penjual kios peukan'), findsOneWidget);
  });
}

