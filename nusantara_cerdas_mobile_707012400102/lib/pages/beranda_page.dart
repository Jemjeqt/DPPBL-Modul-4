import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/pengajuan_model.dart';
import '../navigation/app_routes.dart';
import '../tema_nusantara.dart';

const _pilarKota = [
  ('01', 'Smart Governance', 'TATA KELOLA', 'Pemerintahan transparan dan responsif.'),
  ('02', 'Smart Branding', 'IDENTITAS', 'Promosi wisata, budaya, dan ekonomi kota.'),
  ('03', 'Smart Economy', 'EKONOMI', 'Dukungan UMKM dan ekonomi digital.'),
  ('04', 'Smart Living', 'KEHIDUPAN', 'Kesehatan, pendidikan, dan hunian layak.'),
  ('05', 'Smart Society', 'MASYARAKAT', 'Warga aman, inklusif, dan partisipatif.'),
  ('06', 'Smart Environment', 'LINGKUNGAN', 'Kota hijau, bersih, dan berkelanjutan.'),
];

/// Halaman beranda (StatelessWidget) — dashboard layanan kota.
class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  String get _sapaan {
    final jam = DateTime.now().hour;
    if (jam < 11) return 'Selamat pagi';
    if (jam < 15) return 'Selamat siang';
    if (jam < 19) return 'Selamat sore';
    return 'Selamat malam';
  }

  String get _tanggal {
    const hari = [
      'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu',
    ];
    const bulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    final now = DateTime.now();
    return '${hari[now.weekday - 1]}, ${now.day} ${bulan[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final jumlahPengajuan = context.watch<PengajuanModel>().jumlah;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: const _Wordmark(),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text(
            '${_sapaan.toUpperCase()}, WARGA',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
              color: WarnaNusantara.teksPendamping,
            ),
          ),
          const SizedBox(height: 6),
          const Text.rich(
            TextSpan(
              text: 'Kota yang melayani, ',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              children: [
                TextSpan(
                  text: 'setiap hari',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: WarnaNusantara.amber,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _tanggal,
            style: const TextStyle(
              fontSize: 13,
              color: WarnaNusantara.teksPendamping,
            ),
          ),
          const SizedBox(height: 20),

          // Kartu ajakan utama.
          _KartuAjakan(
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.pengajuanBaru),
          ),
          const SizedBox(height: 14),

          // Pintasan.
          Row(
            children: [
              Expanded(
                child: _KartuPintasan(
                  icon: Icons.dashboard_outlined,
                  label: 'Semua Layanan',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.daftarLayanan),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _KartuPintasan(
                  icon: Icons.history,
                  label: 'Laporan Saya',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.riwayatLaporan),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Akses cepat fitur.
          Row(
            children: [
              Expanded(
                child: _KartuPintasan(
                  icon: Icons.forum_outlined,
                  label: 'Tanya Petugas',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.tanyaPetugas),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _KartuPintasan(
                  icon: Icons.map_outlined,
                  label: 'Lokasi Kantor',
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.lokasiKantor),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _KartuPintasan(
                  icon: Icons.bar_chart,
                  label: 'Statistik',
                  onTap: () => Navigator.pushNamed(
                      context, AppRoutes.statistikLayanan),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Kartu status gelap.
          const _KartuStatus(),
          const SizedBox(height: 24),

          const Text(
            'ENAM PILAR KOTA',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
              color: WarnaNusantara.teksPendamping,
            ),
          ),
          const SizedBox(height: 4),
          ..._pilarKota.map(
            (p) => _BarisPilar(
              nomor: p.$1,
              judul: p.$2,
              tag: p.$3,
              deskripsi: p.$4,
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.daftarLayanan),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$jumlahPengajuan pengajuan tercatat pada akunmu.',
            style: const TextStyle(
              fontSize: 12,
              color: WarnaNusantara.teksPendamping,
            ),
          ),
        ],
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) {
    return const Text.rich(
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
    );
  }
}

class _KartuAjakan extends StatelessWidget {
  const _KartuAjakan({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: WarnaNusantara.hijauKartu,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: WarnaNusantara.amber.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.edit_note, color: Colors.white),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Buat Laporan Baru',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Laporkan masalah di sekitarmu ke pemerintah kota',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_outward, color: WarnaNusantara.amber),
          ],
        ),
      ),
    );
  }
}

class _KartuPintasan extends StatelessWidget {
  const _KartuPintasan({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: WarnaNusantara.garis),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: WarnaNusantara.hijauTua),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KartuStatus extends StatelessWidget {
  const _KartuStatus();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WarnaNusantara.gelap,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STATUS LAYANAN',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '24/7',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Akses layanan publik',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              _StatistikMini(nilai: '6', label: 'Pilar kota'),
              SizedBox(width: 18),
              _StatistikMini(nilai: '9', label: 'Layanan aktif'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatistikMini extends StatelessWidget {
  const _StatistikMini({required this.nilai, required this.label});

  final String nilai;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.white24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nilai,
            style: const TextStyle(
              color: WarnaNusantara.amber,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _BarisPilar extends StatelessWidget {
  const _BarisPilar({
    required this.nomor,
    required this.judul,
    required this.tag,
    required this.deskripsi,
    required this.onTap,
  });

  final String nomor;
  final String judul;
  final String tag;
  final String deskripsi;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 36,
              child: Text(
                nomor,
                style: const TextStyle(
                  color: WarnaNusantara.amber,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          judul,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7EFEA),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: WarnaNusantara.hijauTua,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deskripsi,
                    style: const TextStyle(
                      fontSize: 13,
                      color: WarnaNusantara.teksPendamping,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_outward,
              size: 18,
              color: WarnaNusantara.teksPendamping,
            ),
          ],
        ),
      ),
    );
  }
}
