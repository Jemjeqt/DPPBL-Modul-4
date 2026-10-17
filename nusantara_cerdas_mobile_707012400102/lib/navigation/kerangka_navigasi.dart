import 'package:flutter/material.dart';

import '../pages/beranda_page.dart';
import '../pages/daftar_layanan_page.dart';
import '../pages/form_pengajuan_page.dart';
import '../pages/lokasi_kantor_page.dart';
import '../pages/rincian_layanan_page.dart';
import '../pages/riwayat_laporan_page.dart';
import '../pages/statistik_layanan_page.dart';
import '../pages/tanya_petugas_page.dart';
import '../pages/warga_page.dart';
import '../tema_nusantara.dart';
import 'app_routes.dart';

/// Kerangka navigasi utama: bottom navigation Beranda / Layanan / Warga.
class KerangkaNavigasi extends StatefulWidget {
  const KerangkaNavigasi({super.key});

  static Map<String, WidgetBuilder> daftarTujuan() => {
        AppRoutes.beranda: (_) => const KerangkaNavigasi(),
        AppRoutes.rincianLayanan: (_) => const RincianLayananPage(),
        AppRoutes.pengajuanBaru: (_) => const FormPengajuanPage(),
        AppRoutes.warga: (_) => const WargaPage(),
        AppRoutes.riwayatLaporan: (_) => const RiwayatLaporanPage(),
        AppRoutes.tanyaPetugas: (_) => const TanyaPetugasPage(),
        AppRoutes.lokasiKantor: (_) => const LokasiKantorPage(),
        AppRoutes.statistikLayanan: (_) => const StatistikLayananPage(),
      };

  @override
  State<KerangkaNavigasi> createState() => _KerangkaNavigasiState();
}

class _KerangkaNavigasiState extends State<KerangkaNavigasi> {
  int _indeksAktif = 0;

  static const _halaman = [
    BerandaPage(),
    DaftarLayananPage(),
    WargaPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _indeksAktif, children: _halaman),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indeksAktif,
        onDestinationSelected: (i) => setState(() => _indeksAktif = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: WarnaNusantara.hijauTua),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon:
                Icon(Icons.grid_view_rounded, color: WarnaNusantara.hijauTua),
            label: 'Layanan',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon:
                Icon(Icons.person, color: WarnaNusantara.hijauTua),
            label: 'Warga',
          ),
        ],
      ),
    );
  }
}
