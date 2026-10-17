import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../halaman/widget_desain.dart';
import '../model/form_input_model.dart';
import '../navigation/app_routes.dart';

/// Halaman materi **Form dan Input**.
///
/// Mengimplementasikan komponen:
/// * [TextField] untuk masukan teks (nama, telepon, catatan pesanan).
/// * [Checkbox] / [CheckboxListTile] untuk opsi checklist layanan tambahan.
/// * [RadioButton] / [RadioListTile] untuk pilihan tunggal kurir dan pembayaran.
///
/// Seluruh state dikelola dan disimpan di [FormInputModel] ([ChangeNotifier]),
/// disediakan di akar aplikasi dan dapat dibaca di minimal dua halaman berbeda
/// (halaman ini dan Halaman Profil / Bayar).
class HalamanFormInput extends StatefulWidget {
  const HalamanFormInput({super.key});

  @override
  State<HalamanFormInput> createState() => _HalamanFormInputState();
}

class _HalamanFormInputState extends State<HalamanFormInput> {
  late TextEditingController _namaController;
  late TextEditingController _teleponController;
  late TextEditingController _catatanController;

  @override
  void initState() {
    super.initState();
    final model = context.read<FormInputModel>();
    _namaController = TextEditingController(text: model.namaPemesan);
    _teleponController = TextEditingController(text: model.nomorTelepon);
    _catatanController = TextEditingController(text: model.catatanKebutuhan);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _teleponController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  void _simpanKeProvider() {
    final model = context.read<FormInputModel>();
    model.simpanForm(
      nama: _namaController.text,
      telepon: _teleponController.text,
      catatan: _catatanController.text,
      pengiriman: model.metodePengiriman,
      pembayaran: model.metodePembayaran,
      bungkus: model.bungkusRamahLingkungan,
      bersihkan: model.bersihkanBahan,
      pagi: model.kirimPagi,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text(
            'Preferensi berhasil disimpan ke FormInputModel (Provider)!',
          ),
          backgroundColor: Warna.tealTua,
          action: SnackBarAction(
            label: 'Lihat di Profil',
            textColor: Colors.amberAccent,
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.beranda);
            },
          ),
        ),
      );
  }

  void _resetKeDefault() {
    final model = context.read<FormInputModel>();
    model.resetForm();
    _namaController.text = model.namaPemesan;
    _teleponController.text = model.nomorTelepon;
    _catatanController.text = model.catatanKebutuhan;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Formulir direset ke pengaturan bawaan peukan.'),
          backgroundColor: Warna.tealTua,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final formState = context.watch<FormInputModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form & Input Peukan'),
        actions: [
          IconButton(
            tooltip: 'Reset Formulir',
            icon: const Icon(Icons.refresh),
            onPressed: _resetKeDefault,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Penjelasan Materi
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Warna.teal.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Warna.teal.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.fact_check_outlined, color: Warna.tealTua, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Materi: Form & Input (Provider)',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Warna.tealTua,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Menggunakan TextField, Checkbox, dan RadioButton. Data disimpan di FormInputModel dan tersinkronisasi ke Halaman Profil.',
                          style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Bagian 1: TextField
            const Text(
              '1. Data Pemesan (TextField)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: 'Nama Lengkap Pemesan',
                hintText: 'Contoh: Cut Nyak Meurah',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (val) => formState.updateNama(val),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _teleponController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Nomor WhatsApp / Kontak',
                hintText: 'Contoh: 081234567890',
                prefixIcon: const Icon(Icons.phone_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (val) => formState.updateTelepon(val),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _catatanController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Catatan Kebutuhan Khusus',
                hintText: 'Misal: Sayur kangkung dipotong, ikan tongkol bersihkan insang.',
                prefixIcon: const Icon(Icons.note_alt_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (val) => formState.updateCatatan(val),
            ),
            const SizedBox(height: 20),

            // Bagian 2: Checkbox
            const Text(
              '2. Opsi Kemasan & Layanan (Checkbox)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
              ),
              child: Column(
                children: [
                  CheckboxListTile(
                    value: formState.bungkusRamahLingkungan,
                    activeColor: Warna.teal,
                    title: const Text('Bungkus Ramah Lingkungan'),
                    subtitle: const Text('Gunakan daun pisang & besek bambu khas Aceh (+Rp 2.000)'),
                    secondary: const Icon(Icons.eco, color: Warna.teal),
                    onChanged: (v) => formState.toggleBungkusRamahLingkungan(v),
                  ),
                  const Divider(height: 1),
                  CheckboxListTile(
                    value: formState.bersihkanBahan,
                    activeColor: Warna.teal,
                    title: const Text('Bersihkan & Potong Bahan'),
                    subtitle: const Text('Sayur disiangi dan ikan dibersihkan siap masak (+Rp 3.000)'),
                    secondary: const Icon(Icons.restaurant_outlined, color: Warna.teal),
                    onChanged: (v) => formState.toggleBersihkanBahan(v),
                  ),
                  const Divider(height: 1),
                  CheckboxListTile(
                    value: formState.kirimPagi,
                    activeColor: Warna.teal,
                    title: const Text('Pengiriman Pagi Subuh'),
                    subtitle: const Text('Dikirim pukul 06.00 - 07.00 WIB pagi hari (+Rp 5.000)'),
                    secondary: const Icon(Icons.wb_sunny_outlined, color: Warna.teal),
                    onChanged: (v) => formState.toggleKirimPagi(v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Bagian 3: RadioButton
            const Text(
              '3. Pilihan Kurir Pengantaran (RadioButton)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
              ),
              child: RadioGroup<String>(
                groupValue: formState.metodePengiriman,
                onChanged: (v) {
                  if (v != null) formState.setMetodePengiriman(v);
                },
                child: const Column(
                  children: [
                    RadioListTile<String>(
                      value: 'Kurir Peukan Ekspres',
                      activeColor: Warna.teal,
                      title: Text('Kurir Peukan Ekspres'),
                      subtitle: Text('Langsung antar setelah pasar subuh selesai (30-60 menit)'),
                    ),
                    Divider(height: 1),
                    RadioListTile<String>(
                      value: 'Kurir Peukan Hemat',
                      activeColor: Warna.teal,
                      title: Text('Kurir Peukan Hemat'),
                      subtitle: Text('Jadwal antar siang jam 11.00 - 13.00 WIB'),
                    ),
                    Divider(height: 1),
                    RadioListTile<String>(
                      value: 'Ambil Sendiri di Pasar (Pickup)',
                      activeColor: Warna.teal,
                      title: Text('Ambil Sendiri di Pasar (Pickup)'),
                      subtitle: Text('Ambil pesanan langsung di gerai kios Peukan Rumoh'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Bagian 4: RadioButton Pembayaran
            const Text(
              '4. Pilihan Metode Pembayaran (RadioButton)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
              ),
              child: RadioGroup<String>(
                groupValue: formState.metodePembayaran,
                onChanged: (v) {
                  if (v != null) formState.setMetodePembayaran(v);
                },
                child: const Column(
                  children: [
                    RadioListTile<String>(
                      value: 'QRIS Peukan',
                      activeColor: Warna.teal,
                      title: Text('QRIS Peukan (Instan)'),
                      subtitle: Text('Scan otomatis tanpa biaya admin perbankan'),
                    ),
                    Divider(height: 1),
                    RadioListTile<String>(
                      value: 'Bayar Tunai di Tempat (COD)',
                      activeColor: Warna.teal,
                      title: Text('Bayar Tunai di Tempat (COD)'),
                      subtitle: Text('Bayar langsung ke kurir saat barang tiba'),
                    ),
                    Divider(height: 1),
                    RadioListTile<String>(
                      value: 'Transfer Bank Aceh / BSI',
                      activeColor: Warna.teal,
                      title: Text('Transfer Bank Aceh / BSI'),
                      subtitle: Text('Verifikasi instan via Virtual Account'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Bagian 5: Ringkasan Live dari Provider (Bukan Nilai Tetap!)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Warna.tealMuda,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Warna.teal.withValues(alpha: 0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Ringkasan Form (Dari Provider)',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: Warna.tealTua,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Warna.teal,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Live State',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _barisInfo('Nama Pemesan', formState.namaPemesan),
                  _barisInfo('Nomor Telepon', formState.nomorTelepon),
                  _barisInfo('Kurir Pilihan', formState.metodePengiriman),
                  _barisInfo('Pembayaran', formState.metodePembayaran),
                  _barisInfo(
                    'Layanan Tambahan',
                    [
                      if (formState.bungkusRamahLingkungan) 'Daun Pisang',
                      if (formState.bersihkanBahan) 'Siangi Bahan',
                      if (formState.kirimPagi) 'Kirim Subuh',
                      if (!formState.bungkusRamahLingkungan &&
                          !formState.bersihkanBahan &&
                          !formState.kirimPagi)
                        'Standar',
                    ].join(', '),
                  ),
                  _barisInfo('Biaya Layanan Tambahan', 'Rp ${formState.totalLayananTambahan}'),
                  _barisInfo('Catatan Khusus', formState.catatanKebutuhan),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Aksi Simpan & Reset
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Warna.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _simpanKeProvider,
                    icon: const Icon(Icons.save),
                    label: const Text(
                      'Simpan ke Provider',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _resetKeDefault,
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _barisInfo(String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          const Text(': ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          Expanded(
            child: Text(
              nilai.isEmpty ? '-' : nilai,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Warna.tealTua),
            ),
          ),
        ],
      ),
    );
  }
}
