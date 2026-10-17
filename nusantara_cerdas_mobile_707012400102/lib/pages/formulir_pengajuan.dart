import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/layanan_data.dart';
import '../model/pengajuan_model.dart';
import '../tema_nusantara.dart';

const _daftarSesi = [
  'Pagi (08.00 – 11.00)',
  'Siang (11.00 – 14.00)',
  'Sore (14.00 – 17.00)',
];

/// Formulir pengajuan: TextField + controller, validasi email "@",
/// Checkbox persetujuan, RadioListTile sesi, tombol kirim dengan loading.
class FormulirPengajuan extends StatefulWidget {
  const FormulirPengajuan({super.key, required this.layanan});

  final Layanan layanan;

  @override
  State<FormulirPengajuan> createState() => _FormulirPengajuanState();
}

class _FormulirPengajuanState extends State<FormulirPengajuan> {
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// State lokal persetujuan & sesi (dikelola lewat setState()).
  bool _setuju = false;
  String? _sesi = _daftarSesi.first;

  /// Status pengiriman simulasi.
  bool _sedangMengirim = false;

  @override
  void initState() {
    super.initState();
    _namaController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Tombol hanya aktif ketika seluruh kolom terisi dan checkbox tercentang.
  bool get _siapKirim =>
      _namaController.text.trim().isNotEmpty &&
      _emailController.text.trim().isNotEmpty &&
      _setuju &&
      !_sedangMengirim;

  Future<void> _kirim() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _sedangMengirim = true);

    // Simulasi proses pengiriman ke server.
    await Future.delayed(const Duration(seconds: 2));

    final pengajuan = Pengajuan(
      namaLayanan: widget.layanan.nama,
      instansi: widget.layanan.instansi,
      bidang: widget.layanan.bidang,
      namaPemohon: _namaController.text.trim(),
      email: _emailController.text.trim(),
      sesi: _sesi ?? _daftarSesi.first,
    );
    if (!mounted) return;
    context.read<PengajuanModel>().tambahPengajuan(pengajuan);

    setState(() {
      _sedangMengirim = false;
      _setuju = false;
      _namaController.clear();
      _emailController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pengajuan "${widget.layanan.nama}" berhasil dikirim. '
          'Sesi $_sesi.',
        ),
        backgroundColor: WarnaNusantara.hijauTua,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FORMULIR PENGAJUAN',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: WarnaNusantara.teksPendamping,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _namaController,
            enabled: !_sedangMengirim,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Nama lengkap',
              hintText: 'Contoh: Mimkayel Sempu',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Nama lengkap wajib diisi';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _emailController,
            enabled: !_sedangMengirim,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'nama@email.com',
              prefixIcon: Icon(Icons.mail_outline),
            ),
            validator: (v) {
              final nilai = v?.trim() ?? '';
              if (nilai.isEmpty) return 'Email wajib diisi';
              if (!nilai.contains('@')) {
                return 'Email harus mengandung karakter “@”';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'SESI KUNJUNGAN',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: WarnaNusantara.teksPendamping,
            ),
          ),
          const SizedBox(height: 4),
          // RadioListTile: nilai kelompok disimpan sebagai state lokal
          // melalui setState().
          RadioGroup<String>(
            groupValue: _sesi,
            onChanged: (nilai) {
              if (_sedangMengirim) return;
              setState(() => _sesi = nilai);
            },
            child: Column(
              children: _daftarSesi
                  .map(
                    (sesi) => RadioListTile<String>(
                      value: sesi,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      activeColor: WarnaNusantara.hijauTua,
                      title: Text(sesi),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
          CheckboxListTile(
            value: _setuju,
            dense: true,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: WarnaNusantara.hijauTua,
            title: const Text(
              'Saya menyetujui pemakaian data pribadi untuk keperluan '
              'penanganan pengajuan ini.',
              style: TextStyle(fontSize: 13),
            ),
            onChanged: _sedangMengirim
                ? null
                : (nilai) => setState(() => _setuju = nilai ?? false),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _siapKirim ? _kirim : null,
              child: _sedangMengirim
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Kirim Pengajuan'),
            ),
          ),
          if (!_siapKirim && !_sedangMengirim)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _setuju
                    ? 'Lengkapi nama dan email untuk mengaktifkan tombol.'
                    : 'Centang persetujuan data pribadi untuk mengaktifkan tombol.',
                style: const TextStyle(
                  fontSize: 12,
                  color: WarnaNusantara.teksPendamping,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
