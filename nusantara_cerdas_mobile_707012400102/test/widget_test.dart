import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nusantara_cerdas_mobile_707012400102/main.dart';

void main() {
  testWidgets('Beranda tampil dan navigasi berfungsi', (tester) async {
    await tester.pumpWidget(const NusantaraCerdasApp());
    await tester.pumpAndSettle();

    // Wordmark & kartu utama beranda.
    expect(find.textContaining('NUSANTARA'), findsWidgets);
    expect(find.text('Buat Laporan Baru'), findsOneWidget);

    // Gulir ke bawah untuk bagian pilar kota.
    await tester.drag(find.byType(ListView).first, const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('ENAM PILAR KOTA'), findsOneWidget);

    // Navigasi bottom bar ke tab Layanan.
    await tester.tap(find.text('Layanan'));
    await tester.pumpAndSettle();
    expect(find.text('3 LAYANAN TERSEDIA'), findsOneWidget);
    expect(find.text('Izin Usaha Mikro Kecil'), findsOneWidget);

    // Pindah tab ke Kesehatan.
    await tester.tap(find.text('Kesehatan'));
    await tester.pumpAndSettle();
    expect(find.text('Pemeriksaan Kesehatan Gratis'), findsOneWidget);

    // Buka rincian layanan pertama → formulir tampil.
    await tester.tap(find.text('Pemeriksaan Kesehatan Gratis').first);
    await tester.pumpAndSettle();
    expect(find.text('FORMULIR PENGAJUAN'), findsOneWidget);
    expect(find.text('Kirim Pengajuan'), findsOneWidget);

    // Kembali ke shell utama, lalu pindah ke tab Warga.
    await tester.tap(find.byIcon(Icons.arrow_back).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Warga'));
    await tester.pumpAndSettle();
    expect(find.text('Mimkayel Sempu'), findsOneWidget);

    await tester.tap(find.text('Ajukan Layanan'));
    await tester.pumpAndSettle();
    expect(find.text('PENGAJUAN BARU'), findsOneWidget);
  });
}
