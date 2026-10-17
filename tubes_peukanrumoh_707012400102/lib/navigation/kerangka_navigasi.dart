import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../halaman/halaman_keranjang.dart';
import '../halaman/halaman_pesanan.dart';
import '../halaman/halaman_profil.dart';
import '../halaman/halaman_utama.dart';
import '../halaman/widget_desain.dart';
import '../model/chat_model.dart';
import '../model/keranjang_belanja.dart';
import '../model/penilaian_produk.dart';
import '../pages/chat_pesan.dart';
import 'app_routes.dart';

class KerangkaUtama extends StatefulWidget {
  const KerangkaUtama({super.key});

  @override
  State<KerangkaUtama> createState() => _KerangkaUtamaState();
}

class _KerangkaUtamaState extends State<KerangkaUtama> {
  int _indeks = 0;
  final bool _railDiperluas = false;

  static const List<String> _labelTab = [
    'Beranda',
    'Keranjang',
    'Pesanan',
    'Profil',
    'Chat',
  ];

  void _pilihTab(int indeks) => setState(() => _indeks = indeks);

  @override
  Widget build(BuildContext context) {
    final layarLebar = MediaQuery.of(context).size.width >= 900;

    final halaman = [
      const HalamanBeranda(denganScaffold: false),
      HalamanKeranjang(onLihatProduk: () => _pilihTab(0)),
      const HalamanPesanan(),
      const HalamanProfil(),
      const HalamanChatPesan(),
    ];

    // context.watch dipakai di tombol yang membutuhkan nilai keranjang.
    return Scaffold(
      drawer: DrawerNavigasi(indeksAktif: _indeks, onPilihTab: _pilihTab),
      appBar: AppBar(
        title: Text(_labelTab[_indeks]),
        actions: [
          _TombolChart(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.chartPenilaian),
          ),
          _TombolKeranjang(
            onPressed: () {
              setState(() => _indeks = 1);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Row(
          children: [
            if (layarLebar) _bangunRail(),
            Expanded(
              child: IndexedStack(index: _indeks, children: halaman),
            ),
          ],
        ),
      ),
      bottomNavigationBar: layarLebar
          ? null
          : NavigationBar(
              selectedIndex: _indeks,
              onDestinationSelected: _pilihTab,
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.storefront_outlined),
                  selectedIcon: Icon(Icons.storefront),
                  label: 'Beranda',
                ),
                NavigationDestination(
                  icon: const _IkonKeranjangBadge(),
                  selectedIcon: const Icon(Icons.shopping_cart),
                  label: 'Keranjang',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long),
                  label: 'Pesanan',
                ),
                const                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profil',
                ),
                const NavigationDestination(
                  icon: _IkonChatBadge(),
                  selectedIcon: Icon(Icons.chat),
                  label: 'Chat',
                ),
              ],
            ),
    );
  }

  Widget _bangunRail() {
    return NavigationRail(
      selectedIndex: _indeks,
      onDestinationSelected: _pilihTab,
      extended: _railDiperluas,
      labelType: _railDiperluas
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.all,
      leading: _TombolChart(
        onPressed: () =>
            Navigator.of(context).pushNamed(AppRoutes.chartPenilaian),
      ),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.storefront_outlined),
          selectedIcon: Icon(Icons.storefront),
          label: Text('Beranda'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.shopping_cart_outlined),
          selectedIcon: Icon(Icons.shopping_cart),
          label: Text('Keranjang'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: Text('Pesanan'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Profil'),
        ),
      ],
    );
  }
}

class _TombolKeranjang extends StatelessWidget {
  const _TombolKeranjang({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final totalBarang = context.select<KeranjangBelanja, int>(
      (keranjang) => keranjang.totalBarang,
    );

    return IconButton(
      tooltip: 'Keranjang',
      icon: Badge(
        isLabelVisible: totalBarang > 0,
        label: BadgeKeranjang(jumlah: totalBarang),
        child: const Icon(Icons.shopping_cart_outlined),
      ),
      onPressed: onPressed,
    );
  }
}

class _TombolChart extends StatelessWidget {
  const _TombolChart({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final totalBarang = context.select<KeranjangBelanja, int>(
      (keranjang) => keranjang.totalBarang,
    );
    final sudahAdaData = context.select<PenilaianProduk, bool>(
      (p) => p.jumlahTerhitung > 0,
    );

    Widget child = Badge(
      isLabelVisible: totalBarang > 0,
      label: BadgeKeranjang(jumlah: totalBarang),
      child: const Icon(Icons.shopping_cart_outlined),
    );

    if (onPressed != null) {
      child = InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onPressed,
        child: child,
      );
    }

    return IconButton(
      tooltip: 'Tampilan chart penilaian',
      icon: Badge(
        isLabelVisible: sudahAdaData,
        label: const Text('1'),
        child: Icon(
          sudahAdaData ? Icons.show_chart_outlined : Icons.show_chart,
          color: sudahAdaData
              ? Warna.tealTua
              : Warna.teal.withValues(alpha: 0.5),
        ),
      ),
      onPressed: onPressed ?? () {},
    );
  }
}

/// Tombol keranjang pada NavigationBar; memakai context.select sehingga
/// hanya ikon ini yang build ulang saat jumlah barang berubah.
class _IkonKeranjangBadge extends StatelessWidget {
  const _IkonKeranjangBadge();

  @override
  Widget build(BuildContext context) {
    final totalBarang = context.select<KeranjangBelanja, int>(
      (keranjang) => keranjang.totalBarang,
    );

    return Badge(
      isLabelVisible: totalBarang > 0,
      label: BadgeKeranjang(jumlah: totalBarang),
      child: const Icon(Icons.shopping_cart_outlined),
    );
  }
}

/// Ikon chat dengan badge jumlah pesan dari ChatModel
class _IkonChatBadge extends StatelessWidget {
  const _IkonChatBadge();

  @override
  Widget build(BuildContext context) {
    final totalPesan = context.select<ChatModel, int>(
      (chat) => chat.jumlah,
    );

    return Badge(
      isLabelVisible: totalPesan > 0,
      label: Text('$totalPesan'),
      child: const Icon(Icons.chat_outlined),
    );
  }
}

class DrawerNavigasi extends StatelessWidget {
  const DrawerNavigasi({
    super.key,
    required this.indeksAktif,
    required this.onPilihTab,
  });

  final int indeksAktif;
  final ValueChanged<int> onPilihTab;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: indeksAktif,
      onDestinationSelected: (indeks) {
        Navigator.of(context).pop();
        onPilihTab(indeks);
      },
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Warna.teal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.storefront, color: Warna.teal),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Peukan Rumoh',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Warna.tealTua,
                      ),
                    ),
                    Text(
                      'Pasar Tradisional Digital',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        const NavigationDrawerDestination(
          icon: Icon(Icons.storefront_outlined),
          label: Text('Beranda'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.shopping_cart_outlined),
          label: Text('Keranjang'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.receipt_long_outlined),
          label: Text('Pesanan'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.person_outline),
          label: Text('Profil'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.chat_outlined),
          label: Text('Chat'),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.edit_note, color: Warna.teal),
          title: const Text('Form & Input'),
          subtitle: const Text('TextField, Checkbox, RadioButton'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(AppRoutes.formInput);
          },
        ),
        ListTile(
          leading: const Icon(Icons.ads_click, color: Warna.teal),
          title: const Text('Tombol & Interaksi'),
          subtitle: const Text('ElevatedButton, FAB, GestureDetector'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(AppRoutes.tombolInteraksi);
          },
        ),
        ListTile(
          leading: const Icon(Icons.show_chart, color: Warna.teal),
          title: const Text('Chart Penilaian'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(AppRoutes.chartPenilaian);
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Tentang Aplikasi'),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(AppRoutes.tentang);
          },
        ),
      ],
    );
  }
}
