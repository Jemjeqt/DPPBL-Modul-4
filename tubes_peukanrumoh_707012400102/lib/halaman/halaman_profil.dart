import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/chat_model.dart';
import '../model/form_input_model.dart';
import '../model/interaksi_model.dart';
import '../model/keranjang_belanja.dart';
import '../navigation/app_routes.dart';
import '../theme/theme_controller.dart';
import 'data/data_contoh.dart';
import 'widget_desain.dart';

class HalamanProfil extends StatelessWidget {
  const HalamanProfil({super.key});

  int get _totalPesanan => daftarPesananContoh.length;

  int get _totalBelanja =>
      daftarPesananContoh.fold(0, (total, p) => total + p.total);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Warna.tealTua, Warna.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white24,
                child: Text(
                  'BA',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profilContoh.nama,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      profilContoh.email,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Statistik belanja',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Warna.tealTua,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _StatistikBox(label: 'Pesanan', nilai: '$_totalPesanan'),
            const SizedBox(width: 12),
            _StatistikBox(label: 'Total belanja', nilai: rupiah(_totalBelanja)),
          ],
        ),
        const SizedBox(height: 20),
        // Kartu ringkasan keranjang: membaca Provider yang sama dengan
        // Beranda & Halaman Keranjang lewat context.watch, sehingga angka di
        // sini ikut berubah saat pengguna menambah/kurangi barang di halaman
        // lain.
        const _KartuRingkasanKeranjang(),
        const SizedBox(height: 12),
        const _KartuModeGelap(),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Warna.teal),
                  const SizedBox(width: 10),
                  const Text(
                    'Alamat pengiriman',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(profilContoh.alamat),
              const SizedBox(height: 4),
              Text(
                profilContoh.telepon,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: ListTile(
              leading: const Icon(Icons.info_outline, color: Warna.teal),
              title: const Text('Tentang aplikasi'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.tentang);
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        const _KartuPreferensiForm(),
        const _KartuPusatInteraksi(),
        const _KartuAktivitasChat(),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _KartuRingkasanKeranjang extends StatelessWidget {
  const _KartuRingkasanKeranjang();

  @override
  Widget build(BuildContext context) {
    // watch: kartu ini ikut membangun ulang tiap kali keranjang berubah.
    final keranjang = context.watch<KeranjangBelanja>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Warna.tealMuda,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.shopping_basket_outlined,
              color: Warna.tealTua,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Keranjang aktif',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  keranjang.kosong
                      ? 'Belum ada barang dipilih'
                      : '${keranjang.totalBarang} barang • ${keranjang.jumlahJenis} jenis',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            rupiah(keranjang.totalBayar),
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Warna.teal,
            ),
          ),
        ],
      ),
    );
  }
}

class _KartuModeGelap extends StatelessWidget {
  const _KartuModeGelap();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeController.instance,
      builder: (context, _) {
        final gelap = ThemeController.instance.isDark;

        return Container(
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: Icon(
                gelap ? Icons.dark_mode : Icons.light_mode,
                color: gelap ? Warna.aksen : Warna.teal,
              ),
              title: const Text(
                'Mode gelap',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                gelap
                    ? 'Nyaman dipakai malam hari'
                    : 'Tampilan cerah siang hari',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).hintColor,
                ),
              ),
              value: gelap,
              onChanged: ThemeController.instance.setDark,
            ),
          ),
        );
      },
    );
  }
}

class _StatistikBox extends StatelessWidget {
  const _StatistikBox({required this.label, required this.nilai});

  final String label;
  final String nilai;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Warna.tealMuda.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Warna.tealTua),
            ),
            const SizedBox(height: 2),
            Text(
              nilai,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: Warna.tealTua,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _KartuPreferensiForm extends StatelessWidget {
  const _KartuPreferensiForm();

  @override
  Widget build(BuildContext context) {
    final form = context.watch<FormInputModel>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Warna.tealMuda,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.edit_note, color: Warna.tealTua),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preferensi Form & Input',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                    Text(
                      'Tersinkron dari FormInputModel',
                      style: TextStyle(fontSize: 11, color: Warna.teal),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.formInput);
                },
                child: const Text('Ubah'),
              ),
            ],
          ),
          const Divider(height: 18),
          _itemText('Pemesan', form.namaPemesan),
          _itemText('Pengiriman', form.metodePengiriman),
          _itemText('Pembayaran', form.metodePembayaran),
          _itemText(
            'Layanan',
            [
              if (form.bungkusRamahLingkungan) 'Daun Pisang',
              if (form.bersihkanBahan) 'Siangi Bahan',
              if (form.kirimPagi) 'Kirim Subuh',
              if (!form.bungkusRamahLingkungan &&
                  !form.bersihkanBahan &&
                  !form.kirimPagi)
                'Standar',
            ].join(', '),
          ),
          if (form.catatanKebutuhan.isNotEmpty)
            _itemText('Catatan', form.catatanKebutuhan),
        ],
      ),
    );
  }

  Widget _itemText(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 84,
            child: Text(k, style: const TextStyle(fontSize: 12)),
          ),
          const Text(': ', style: TextStyle(fontSize: 12)),
          Expanded(
            child: Text(
              v,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Warna.tealTua),
            ),
          ),
        ],
      ),
    );
  }
}

class _KartuPusatInteraksi extends StatelessWidget {
  const _KartuPusatInteraksi();

  @override
  Widget build(BuildContext context) {
    final interaksi = context.watch<InteraksiModel>();

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Warna.tealMuda,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.ads_click, color: Warna.tealTua),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Poin & Interaksi Tombol',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                    Text(
                      '${interaksi.totalInteraksi} interaksi tercatat di Provider',
                      style: const TextStyle(fontSize: 11, color: Warna.teal),
                    ),
                  ],
                ),
              ),
              Text(
                '${interaksi.poinPeukan} Poin',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  color: Warna.tealTua,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Aksi Terakhir: ${interaksi.aksiTerakhir}',
            style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              minimumSize: const Size.fromHeight(36),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.tombolInteraksi);
            },
            child: const Text('Buka Halaman Tombol & Interaksi'),
          ),
        ],
      ),
    );
  }
}

class _KartuAktivitasChat extends StatelessWidget {
  const _KartuAktivitasChat();

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatModel>();

    return Container(
      margin: const EdgeInsets.only(top: 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Warna.tealMuda,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.chat_bubble_outline, color: Warna.tealTua),
          ),
          title: const Text('Chat Penjual Peukan', style: TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text('${chat.jumlah} pesan dalam percakapan aktif'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Badge(
                isLabelVisible: chat.jumlah > 0,
                label: Text('${chat.jumlah}'),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right),
            ],
          ),
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.chatPesan);
          },
        ),
      ),
    );
  }
}

