import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/layanan_data.dart';
import '../model/pengajuan_model.dart';
import '../tema_nusantara.dart';
import 'formulir_pengajuan.dart';

/// Halaman pengajuan baru dibuka lewat named route (dari FAB Warga).
class FormPengajuanPage extends StatefulWidget {
  const FormPengajuanPage({super.key});

  @override
  State<FormPengajuanPage> createState() => _FormPengajuanPageState();
}

class _FormPengajuanPageState extends State<FormPengajuanPage> {
  Layanan _layananTerpilih = KatalogLayanan.daftar.first;

  @override
  Widget build(BuildContext context) {
    final jumlah = context.watch<PengajuanModel>().jumlah;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('PENGAJUAN BARU'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text(
            'TOTAL PENGAJUAN: $jumlah',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: WarnaNusantara.teksPendamping,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<Layanan>(
            initialValue: _layananTerpilih,
            decoration: const InputDecoration(
              labelText: 'Jenis layanan',
              prefixIcon: Icon(Icons.list_alt_outlined),
            ),
            items: KatalogLayanan.daftar
                .map(
                  (l) => DropdownMenuItem(
                    value: l,
                    child: Text(l.nama, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(growable: false),
            onChanged: (l) => setState(() => _layananTerpilih =
                l ?? KatalogLayanan.daftar.first),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2EE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_layananTerpilih.instansi}\n${_layananTerpilih.deskripsi}',
              style: const TextStyle(fontSize: 13, height: 1.5),
            ),
          ),
          const SizedBox(height: 24),
          FormulirPengajuan(layanan: _layananTerpilih, key: ValueKey(_layananTerpilih.nama)),
        ],
      ),
    );
  }
}
