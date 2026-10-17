import 'package:flutter/material.dart';

import '../model/layanan_data.dart';
import '../navigation/app_routes.dart';
import '../tema_nusantara.dart';

/// Daftar layanan per bidang dengan tab (StatefulWidget).
class DaftarLayananPage extends StatefulWidget {
  const DaftarLayananPage({super.key, this.tampilkanKembali = false});

  /// True bila dibuka lewat named route (push), bukan sebagai tab.
  final bool tampilkanKembali;

  @override
  State<DaftarLayananPage> createState() => _DaftarLayananPageState();
}

class _DaftarLayananPageState extends State<DaftarLayananPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: KatalogLayanan.bidangTersedia.length, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.tampilkanKembali
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text('LAYANAN'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: WarnaNusantara.teksUtama,
          unselectedLabelColor: WarnaNusantara.teksPendamping,
          indicatorColor: WarnaNusantara.hijauTua,
          indicatorWeight: 3,
          tabs: KatalogLayanan.bidangTersedia
              .map((b) => Tab(text: b))
              .toList(growable: false),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: KatalogLayanan.bidangTersedia.map((bidang) {
          final layanan = KatalogLayanan.perBidang(bidang);
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
            children: [
              Text(
                '${layanan.length} LAYANAN TERSEDIA',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                  color: WarnaNusantara.teksPendamping,
                ),
              ),
              const SizedBox(height: 4),
              ...layanan.asMap().entries.map(
                    (e) => _BarisLayanan(
                      nomor: (e.key + 1).toString().padLeft(2, '0'),
                      layanan: e.value,
                    ),
                  ),
            ],
          );
        }).toList(growable: false),
      ),
    );
  }
}

class _BarisLayanan extends StatelessWidget {
  const _BarisLayanan({required this.nomor, required this.layanan});

  final String nomor;
  final Layanan layanan;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.rincianLayanan,
        arguments: layanan,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: WarnaNusantara.garis)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 36,
              child: Text(
                nomor,
                style: const TextStyle(
                  color: WarnaNusantara.amber,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    layanan.nama,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    layanan.instansi,
                    style: const TextStyle(
                      fontSize: 13,
                      color: WarnaNusantara.teksPendamping,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.star, color: WarnaNusantara.amber, size: 20),
            const SizedBox(width: 12),
            const Icon(
              Icons.arrow_forward,
              size: 18,
              color: WarnaNusantara.teksUtama,
            ),
          ],
        ),
      ),
    );
  }
}
