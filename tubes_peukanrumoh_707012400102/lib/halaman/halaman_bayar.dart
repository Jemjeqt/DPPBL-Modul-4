import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/form_input_model.dart';
import '../navigation/app_routes.dart';
import 'data/data_contoh.dart';
import 'widget_desain.dart';

/// Halaman checkout / bayar.
///
/// Materi terintegrasi:
/// * **Form & Input** — Catatan pesanan ([TextField]), opsi kemasan ([Checkbox]),
///   dan pilihan kurir ([RadioButton]) langsung di alur checkout.
///   Semua membaca & menulis ke [FormInputModel] (Provider), sehingga
///   perubahan terlihat pula di Halaman Profil.
/// * **Tombol & Interaksi** — [ElevatedButton] konfirmasi bayar,
///   [GestureDetector] pada tiap kartu metode pembayaran.
class HalamanBayar extends StatefulWidget {
  const HalamanBayar({super.key, required this.argumen});

  final ArgumenBayar argumen;

  @override
  State<HalamanBayar> createState() => _HalamanBayarState();
}

class _HalamanBayarState extends State<HalamanBayar> {
  // Controller lokal hanya untuk TextField catatan (tidak perlu cross-page).
  late TextEditingController _catatanController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan catatan yang sudah tersimpan di Provider.
    final model = context.read<FormInputModel>();
    _catatanController = TextEditingController(text: model.catatanKebutuhan);
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  // ── Daftar pilihan kurir (RadioButton) ─────────────────────────────────────
  static const _kurirList = [
    (
      nilai: 'Kurir Peukan Ekspres',
      ikon: Icons.electric_bike_outlined,
      ket: 'Antar 30–60 menit setelah pasar subuh',
    ),
    (
      nilai: 'Kurir Peukan Hemat',
      ikon: Icons.directions_bike_outlined,
      ket: 'Jadwal antar siang 11.00–13.00 WIB',
    ),
    (
      nilai: 'Ambil Sendiri di Pasar (Pickup)',
      ikon: Icons.store_outlined,
      ket: 'Ambil langsung di gerai kios Peukan Rumoh',
    ),
  ];

  // ── Daftar pilihan metode pembayaran (kartu GestureDetector) ───────────────
  static const _metodeList = [
    (
      nilai: 'QRIS Peukan',
      ikon: Icons.qr_code_outlined,
      ket: 'Scan QR • Instan tanpa biaya admin',
    ),
    (
      nilai: 'Bayar Tunai di Tempat (COD)',
      ikon: Icons.local_shipping_outlined,
      ket: 'Bayar ke kurir saat barang tiba',
    ),
    (
      nilai: 'Transfer Bank Aceh / BSI',
      ikon: Icons.account_balance_outlined,
      ket: 'Virtual Account BCA, BSI, Mandiri',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final argumen = widget.argumen;
    // context.watch: build ulang saat FormInputModel berubah
    final formInput = context.watch<FormInputModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Bayar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Ringkasan Item ────────────────────────────────────────────────
          Text(
            'Ringkasan pesanan',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final item in argumen.item) KartuItemPesanan(item: item),
          if (argumen.item.isEmpty)
            const Text('Tidak ada item untuk dibayar.'),
          const SizedBox(height: 20),

          // ── Catatan Pesanan (TextField — Form & Input) ────────────────────
          Text(
            'Catatan pesanan',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _catatanController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText:
                  'Misal: sayur dipotong, ikan bersihkan insang…',
              prefixIcon: const Icon(Icons.note_alt_outlined),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            // Setiap perubahan langsung disimpan ke FormInputModel (Provider)
            onChanged: (val) =>
                context.read<FormInputModel>().updateCatatan(val),
          ),
          const SizedBox(height: 20),

          // ── Opsi Kemasan & Layanan (Checkbox — Form & Input) ─────────────
          Text(
            'Layanan tambahan',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              children: [
                CheckboxListTile(
                  value: formInput.bungkusRamahLingkungan,
                  activeColor: Warna.teal,
                  title: const Text('Bungkus Ramah Lingkungan'),
                  subtitle:
                      const Text('Daun pisang & besek bambu (+Rp 2.000)'),
                  secondary: const Icon(Icons.eco, color: Warna.teal),
                  onChanged: (v) =>
                      context
                          .read<FormInputModel>()
                          .toggleBungkusRamahLingkungan(v),
                ),
                const Divider(height: 1),
                CheckboxListTile(
                  value: formInput.bersihkanBahan,
                  activeColor: Warna.teal,
                  title: const Text('Bersihkan & Potong Bahan'),
                  subtitle:
                      const Text('Sayur disiangi, ikan bersih siap masak (+Rp 3.000)'),
                  secondary:
                      const Icon(Icons.restaurant_outlined, color: Warna.teal),
                  onChanged: (v) =>
                      context.read<FormInputModel>().toggleBersihkanBahan(v),
                ),
                const Divider(height: 1),
                CheckboxListTile(
                  value: formInput.kirimPagi,
                  activeColor: Warna.teal,
                  title: const Text('Pengiriman Subuh'),
                  subtitle:
                      const Text('Dikirim pukul 06.00–07.00 WIB (+Rp 5.000)'),
                  secondary:
                      const Icon(Icons.wb_sunny_outlined, color: Warna.teal),
                  onChanged: (v) =>
                      context.read<FormInputModel>().toggleKirimPagi(v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Pilihan Kurir (RadioButton — Form & Input) ────────────────────
          Text(
            'Pilihan kurir',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
              ),
            ),
            child: RadioGroup<String>(
              groupValue: formInput.metodePengiriman,
              onChanged: (v) {
                if (v != null) {
                  context.read<FormInputModel>().setMetodePengiriman(v);
                }
              },
              child: Column(
                children: [
                  for (int i = 0; i < _kurirList.length; i++) ...[
                    if (i > 0) const Divider(height: 1),
                    RadioListTile<String>(
                      value: _kurirList[i].nilai,
                      activeColor: Warna.teal,
                      title: Text(_kurirList[i].nilai),
                      subtitle: Text(_kurirList[i].ket),
                      secondary: Icon(
                        _kurirList[i].ikon,
                        color: formInput.metodePengiriman ==
                                _kurirList[i].nilai
                            ? Warna.teal
                            : Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Metode Pembayaran (GestureDetector — Tombol & Interaksi) ─────
          Text(
            'Metode pembayaran',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final metode in _metodeList)
            // GestureDetector membungkus setiap kartu pembayaran:
            // tap biasa pilih metode, long press tampil info singkat.
            GestureDetector(
              onTap: () {
                context
                    .read<FormInputModel>()
                    .setMetodePembayaran(metode.nilai);
              },
              onLongPress: () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text('${metode.nilai}: ${metode.ket}'),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Warna.tealTua,
                    ),
                  );
              },
              child: _KartuMetode(
                nama: metode.nilai,
                keterangan: metode.ket,
                ikon: metode.ikon,
                dipilih: formInput.metodePembayaran == metode.nilai,
              ),
            ),
          const SizedBox(height: 16),

          // ── Ringkasan Biaya ───────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              children: [
                _baris(context, 'Pemesan', formInput.namaPemesan),
                _baris(context, 'Alamat', profilContoh.alamat),
                _baris(context, 'Kurir', formInput.metodePengiriman),
                _baris(context, 'Pembayaran', formInput.metodePembayaran),
                if (formInput.bungkusRamahLingkungan ||
                    formInput.bersihkanBahan ||
                    formInput.kirimPagi)
                  _baris(
                    context,
                    'Layanan Tambahan',
                    [
                      if (formInput.bungkusRamahLingkungan) 'Daun Pisang',
                      if (formInput.bersihkanBahan) 'Siangi Bahan',
                      if (formInput.kirimPagi) 'Kirim Subuh',
                    ].join(', '),
                  ),
                if (formInput.catatanKebutuhan.trim().isNotEmpty)
                  _baris(context, 'Catatan', formInput.catatanKebutuhan),
                _baris(context, 'Subtotal', rupiah(argumen.totalHarga)),
                _baris(context, 'Ongkir', rupiah(argumen.ongkir)),
                if (formInput.totalLayananTambahan > 0)
                  _baris(
                    context,
                    'Layanan',
                    rupiah(formInput.totalLayananTambahan),
                  ),
                const Divider(height: 16),
                Row(
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    Text(
                      rupiah(argumen.total +
                          formInput.totalLayananTambahan),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                        color: Warna.teal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),

      // ── Tombol Bayar (ElevatedButton — Tombol & Interaksi) ───────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Warna.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: argumen.item.isEmpty
                ? null
                : () {
                    _konfirmasi(
                      context,
                      argumen.total + formInput.totalLayananTambahan,
                      formInput.metodePembayaran,
                    );
                  },
            icon: const Icon(Icons.lock_outline),
            label: Text(
              'Bayar ${rupiah(argumen.total + formInput.totalLayananTambahan)}',
            ),
          ),
        ),
      ),
    );
  }

  Widget _baris(BuildContext context, String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Theme.of(context).hintColor)),
          const Spacer(),
          Flexible(
            child: Text(
              nilai,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _konfirmasi(BuildContext context, int total, String metode) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pembayaran'),
        content: Text('Bayar ${rupiah(total)} via $metode?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Warna.teal),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
            child: const Text('Ya, Bayar'),
          ),
        ],
      ),
    );
  }
}

/// Kartu metode pembayaran — dipakai bersama [GestureDetector] di atasnya.
class _KartuMetode extends StatelessWidget {
  const _KartuMetode({
    required this.nama,
    required this.keterangan,
    required this.ikon,
    required this.dipilih,
  });

  final String nama;
  final String keterangan;
  final IconData ikon;
  final bool dipilih;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: dipilih
              ? Warna.tealMuda
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: dipilih
                ? Warna.teal
                : Theme.of(context).dividerColor.withValues(alpha: 0.4),
            width: dipilih ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              ikon,
              color: dipilih ? Warna.tealTua : Theme.of(context).hintColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    keterangan,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              dipilih ? Icons.check_circle : Icons.radio_button_off,
              color: dipilih ? Warna.teal : Theme.of(context).hintColor,
            ),
          ],
        ),
      ),
    );
  }
}
