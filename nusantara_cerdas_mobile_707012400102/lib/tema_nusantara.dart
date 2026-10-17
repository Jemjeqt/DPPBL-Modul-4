import 'package:flutter/material.dart';

/// Palet warna Nusantara Cerdas mengikuti referensi UI.
class WarnaNusantara {
  static const hijauTua = Color(0xFF0F4C3A);
  static const hijauKartu = Color(0xFF1A6B57);
  static const hijauMuda = Color(0xFF2E8B6F);
  static const amber = Color(0xFFE9A13B);
  static const amberGelap = Color(0xFFC9821F);
  static const latar = Color(0xFFF5F5F2);
  static const kartuPutih = Colors.white;
  static const gelap = Color(0xFF1E2320);
  static const teksUtama = Color(0xFF1B1F1D);
  static const teksPendamping = Color(0xFF6B7370);
  static const garis = Color(0xFFE4E4DE);
}

ThemeData temaNusantara() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: WarnaNusantara.hijauTua,
      primary: WarnaNusantara.hijauTua,
      secondary: WarnaNusantara.amber,
      surface: WarnaNusantara.kartuPutih,
    ),
    scaffoldBackgroundColor: WarnaNusantara.latar,
  );

  return base.copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: WarnaNusantara.latar,
      foregroundColor: WarnaNusantara.teksUtama,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: WarnaNusantara.teksUtama,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: WarnaNusantara.garis),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: WarnaNusantara.garis),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: WarnaNusantara.hijauTua, width: 1.6),
      ),
      labelStyle: const TextStyle(color: WarnaNusantara.teksPendamping),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: WarnaNusantara.hijauTua,
        foregroundColor: Colors.white,
        disabledBackgroundColor: WarnaNusantara.garis,
        disabledForegroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: WarnaNusantara.hijauTua.withValues(alpha: 0.10),
      height: 68,
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
