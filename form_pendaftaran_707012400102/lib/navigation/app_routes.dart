import 'package:flutter/material.dart';
import '../pages/detail_kegiatan_page.dart';
import 'kerangka_navigasi.dart';

class AppRoutes {
  static const String beranda = '/';
  static const String detailKegiatan = '/detail-kegiatan';

  // Route tanpa argumen didaftarkan di sini.
  static Map<String, WidgetBuilder> daftarRoute() {
    return {
      beranda: (context) => const KerangkaNavigasi(),
      detailKegiatan: (context) => const DetailKegiatanPage(),
    };
  }

  // Disediakan untuk route yang memerlukan argumen di kemudian hari.
  static Route<dynamic>? bentukRoute(RouteSettings settings) {
    return null;
  }

  // Dipakai ketika nama route tidak terdaftar.
  static Route<dynamic> routeTidakDikenal(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Route Tidak Ditemukan')),
        body: Center(child: Text('Route ${settings.name} belum terdaftar.')),
      ),
    );
  }
}