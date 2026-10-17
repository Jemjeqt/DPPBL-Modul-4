import 'package:flutter/material.dart';

import '../model/layanan_data.dart';
import '../tema_nusantara.dart';
import 'formulir_pengajuan.dart';

/// Halaman rincian layanan: deskripsi + formulir pengajuan.
class RincianLayananPage extends StatelessWidget {
  const RincianLayananPage({super.key});

  @override
  Widget build(BuildContext context) {
    final layanan = (ModalRoute.of(context)?.settings.arguments as Layanan?) ??
        KatalogLayanan.daftar.first;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('RINCIAN LAYANAN'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: WarnaNusantara.garis),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7EFEA),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    layanan.bidang.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: WarnaNusantara.hijauTua,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  layanan.nama,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.account_balance_outlined,
                      size: 15,
                      color: WarnaNusantara.teksPendamping,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        layanan.instansi,
                        style: const TextStyle(
                          fontSize: 13,
                          color: WarnaNusantara.teksPendamping,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  layanan.deskripsi,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FormulirPengajuan(layanan: layanan),
        ],
      ),
    );
  }
}
