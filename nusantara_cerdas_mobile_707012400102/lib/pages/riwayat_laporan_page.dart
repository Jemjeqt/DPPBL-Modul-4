import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/pengajuan_model.dart';
import '../tema_nusantara.dart';

/// Riwayat pengajuan: onTap = rincian, onLongPress = tandai selesai.
class RiwayatLaporanPage extends StatelessWidget {
  const RiwayatLaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<PengajuanModel>();
    final daftar = model.daftarTerbaru;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('RIWAYAT LAPORAN'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text(
            'PENGAJUAN LAYANAN (${daftar.length})',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: WarnaNusantara.teksPendamping,
            ),
          ),
          const SizedBox(height: 8),
          if (daftar.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: WarnaNusantara.garis),
              ),
              child: const Row(
                children: [
                  Icon(Icons.assignment_outlined,
                      color: WarnaNusantara.teksPendamping),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Belum ada pengajuan layanan. Ajukan lewat halaman '
                      'rincian layanan, pengajuanmu akan muncul di sini.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ...daftar.asMap().entries.map(
                (e) => _KartuRiwayat(
                  nomor: (e.key + 1).toString().padLeft(2, '0'),
                  pengajuan: e.value,
                ),
              ),
        ],
      ),
    );
  }
}

class _KartuRiwayat extends StatelessWidget {
  const _KartuRiwayat({required this.nomor, required this.pengajuan});

  final String nomor;
  final Pengajuan pengajuan;

  void _tampilkanRincian(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: WarnaNusantara.garis,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              pengajuan.namaLayanan,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            _BarisRincian(label: 'Instansi', nilai: pengajuan.instansi),
            _BarisRincian(label: 'Bidang', nilai: pengajuan.bidang),
            _BarisRincian(label: 'Pemohon', nilai: pengajuan.namaPemohon),
            _BarisRincian(label: 'Email', nilai: pengajuan.email),
            _BarisRincian(label: 'Sesi kunjungan', nilai: pengajuan.sesi),
            _BarisRincian(label: 'Tanggal', nilai: pengajuan.tanggalTampil),
            _BarisRincian(
              label: 'Status',
              nilai: pengajuan.status.name.toUpperCase(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _tampilkanRincian(context),
      onLongPress: () {
        context.read<PengajuanModel>().tandaiSelesai(pengajuan);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '"${pengajuan.namaLayanan}" ditandai selesai ditindaklanjuti.',
            ),
            backgroundColor: WarnaNusantara.hijauTua,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
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
                    pengajuan.namaLayanan,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${pengajuan.tanggalTampil} • ${pengajuan.sesi}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: WarnaNusantara.teksPendamping,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _PilStatus(status: pengajuan.status),
          ],
        ),
      ),
    );
  }
}

class _BarisRincian extends StatelessWidget {
  const _BarisRincian({required this.label, required this.nilai});

  final String label;
  final String nilai;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: WarnaNusantara.teksPendamping,
              ),
            ),
          ),
          Expanded(
            child: Text(
              nilai,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _PilStatus extends StatelessWidget {
  const _PilStatus({required this.status});

  final StatusPengajuan status;

  @override
  Widget build(BuildContext context) {
    final (label, warna) = switch (status) {
      StatusPengajuan.diajukan => ('Diajukan', WarnaNusantara.amberGelap),
      StatusPengajuan.diproses => ('Diproses', WarnaNusantara.hijauKartu),
      StatusPengajuan.selesai => ('Selesai', WarnaNusantara.hijauTua),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: warna),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: warna, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: warna,
            ),
          ),
        ],
      ),
    );
  }
}
