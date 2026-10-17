import 'package:flutter/material.dart';

import '../navigation/app_routes.dart';
import '../tema_nusantara.dart';

const _favorit = [
  ('Izin Usaha Mikro Kecil', 'Dinas Penanaman Modal dan PTSP', Icons.storefront_outlined),
  ('Izin Mendirikan Bangunan', 'Dinas Pekerjaan Umum dan Penataan Ruang', Icons.home_work_outlined),
  ('Izin Keramaian dan Acara', 'Satuan Polisi Pamong Praja', Icons.celebration_outlined),
];

/// Halaman profil warga dengan FAB pengajuan baru (StatelessWidget).
class WargaPage extends StatelessWidget {
  const WargaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        title: const Text.rich(
          TextSpan(
            text: 'NUSANTARA ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              color: WarnaNusantara.teksUtama,
            ),
            children: [
              TextSpan(
                text: 'CERDAS',
                style: TextStyle(color: WarnaNusantara.amber),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        // Named route, bukan Navigator.push langsung ke kelas halaman.
        onPressed: () => Navigator.pushNamed(context, AppRoutes.pengajuanBaru),
        backgroundColor: WarnaNusantara.hijauTua,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_task),
        label: const Text('Ajukan Layanan'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 90),
        children: [
          const _LabelSeksi('PROFIL'),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: WarnaNusantara.hijauTua, width: 1.6),
                ),
                child: const Text(
                  'MS',
                  style: TextStyle(
                    color: WarnaNusantara.hijauTua,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mimkayel Sempu',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'NIK 1116052001',
                      style: TextStyle(
                        fontSize: 13,
                        color: WarnaNusantara.teksPendamping,
                      ),
                    ),
                    Text(
                      'Kelurahan Sukabirus',
                      style: TextStyle(
                        fontSize: 13,
                        color: WarnaNusantara.teksPendamping,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _LabelSeksi('AKTIVITAS'),
          const SizedBox(height: 10),
          _KartuAktivitas(
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.riwayatLaporan),
          ),
          const SizedBox(height: 24),
          const _LabelSeksi('LAYANAN FAVORIT'),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: WarnaNusantara.garis),
            ),
            clipBehavior: Clip.antiAlias,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: _favorit
                    .map(
                      (f) => ListTile(
                        leading: Icon(
                          f.$3,
                          color: WarnaNusantara.hijauTua,
                        ),
                        title: Text(
                          f.$1,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          f.$2,
                          style: const TextStyle(
                            fontSize: 12,
                            color: WarnaNusantara.teksPendamping,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.star,
                          color: WarnaNusantara.amber,
                        ),
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.rincianLayanan,
                          arguments: null,
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabelSeksi extends StatelessWidget {
  const _LabelSeksi(this.teks);

  final String teks;

  @override
  Widget build(BuildContext context) {
    return Text(
      teks,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.6,
        color: WarnaNusantara.teksPendamping,
      ),
    );
  }
}

class _KartuAktivitas extends StatelessWidget {
  const _KartuAktivitas({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: WarnaNusantara.garis),
        ),
        child: const Row(
          children: [
            Icon(Icons.history, color: WarnaNusantara.hijauTua, size: 26),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Riwayat Laporan',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Lihat status laporan yang pernah diajukan',
                    style: TextStyle(
                      fontSize: 12,
                      color: WarnaNusantara.teksPendamping,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: WarnaNusantara.teksPendamping),
          ],
        ),
      ),
    );
  }
}
