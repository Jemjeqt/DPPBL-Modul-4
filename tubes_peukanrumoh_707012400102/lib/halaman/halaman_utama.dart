import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/interaksi_model.dart';
import '../model/keranjang_belanja.dart';
import '../navigation/app_routes.dart';
import 'data/data_contoh.dart';
import 'widget_desain.dart';

class HalamanBeranda extends StatefulWidget {
  const HalamanBeranda({super.key, this.denganScaffold = true});

  final bool denganScaffold;

  @override
  State<HalamanBeranda> createState() => _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda> {
  String _kataKunci = '';
  String _kategoriDipilih = 'Semua';

  // ===== Data lokal halaman ini saja (dikelola setState) =====
  // Status memuat grid produk; hanya relevan untuk Beranda.
  bool _memuatProduk = true;

  // Tampilan daftar produk: true = mode daftar (baris), false = mode grid.
  // Data lokal halaman Beranda saja, dikelola dengan setState.
  bool _tampilanDaftar = false;

  @override
  void initState() {
    super.initState();
    _muatUlangProduk();
  }

  Future<void> _muatUlangProduk() async {
    setState(() => _memuatProduk = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _memuatProduk = false);
  }

  List<ProdukContoh> get _hasilFilter {
    return daftarProdukContoh.where((produk) {
      if (_kategoriDipilih != 'Semua' && produk.kategori != _kategoriDipilih) {
        return false;
      }
      if (_kataKunci.isNotEmpty &&
          !produk.nama.toLowerCase().contains(_kataKunci.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();
  }

  Widget _heroBand() {
    final jam = DateTime.now().hour;
    // context.select: build ulang hanya ketika totalBarang berubah,
    // bukan pada perubahan data keranjang lain.
    final totalBarang = context.select<KeranjangBelanja, int>(
      (keranjang) => keranjang.totalBarang,
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jam < 11
                      ? 'Selamat pagi'
                      : jam < 15
                      ? 'Selamat siang'
                      : 'Selamat sore',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Mau belanja kebutuhan dapur\ndari peukan Aceh?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.tombolInteraksi),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.stars, color: Colors.amberAccent, size: 14),
                        const SizedBox(width: 5),
                        Text(
                          '${context.watch<InteraksiModel>().poinPeukan} Poin • Voucher Peukan',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.keranjang),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Badge(
                isLabelVisible: totalBarang > 0,
                label: BadgeKeranjang(jumlah: totalBarang),
                child: const Icon(
                  Icons.shopping_basket_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isi = Column(
      children: [
        _heroBand(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari sayur, buah, atau bumbu...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (nilai) => setState(() => _kataKunci = nilai),
          ),
        ),
        SizedBox(
          height: 86,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            children: [
              for (final kategori in daftarKategori)
                _KategoriBulat(
                  kategori: kategori,
                  dipilih: _kategoriDipilih == kategori,
                  onTap: () => setState(() => _kategoriDipilih = kategori),
                ),
            ],
          ),
        ),
        _tombolGantiTampilan(),
        Expanded(
          child: _memuatProduk
              ? const _StatusMemuatGrid()
              : _hasilFilter.isEmpty
              ? _KondisiKosongPencarian(
                  onReset: () => setState(() {
                    _kataKunci = '';
                    _kategoriDipilih = 'Semua';
                  }),
                )
              : _tampilanDaftar
              ? _bangunDaftar()
              : _bangunGrid(),
        ),
      ],
    );

    if (!widget.denganScaffold) return isi;

    return Scaffold(
      appBar: AppBar(title: const Text('Peukan Rumoh')),
      body: isi,
    );
  }

  /// Grid produk: dipakai saat mode tampilan "grid".
  Widget _bangunGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final lebar = constraints.maxWidth;
        final kolom = lebar >= 900
            ? 4
            : lebar >= 600
            ? 3
            : 2;
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: kolom,
            childAspectRatio: 0.68,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _hasilFilter.length,
          itemBuilder: (context, indeks) {
            return KartuProdukBaru(produk: _hasilFilter[indeks]);
          },
        );
      },
    );
  }

  /// Daftar produk: dipakai saat mode tampilan "daftar".
  Widget _bangunDaftar() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: _hasilFilter.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, indeks) {
        final produk = _hasilFilter[indeks];
        return KartuProdukBaris(produk: produk);
      },
    );
  }

  Widget _tombolGantiTampilan() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        children: [
          Text(
            '${_hasilFilter.length} produk',
            style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
          ),
          const Spacer(),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: false,
                icon: Icon(Icons.grid_view_outlined, size: 18),
                label: Text('Grid', style: TextStyle(fontSize: 12)),
              ),
              ButtonSegment(
                value: true,
                icon: Icon(Icons.view_list_outlined, size: 18),
                label: Text('Daftar', style: TextStyle(fontSize: 12)),
              ),
            ],
            selected: {_tampilanDaftar},
            showSelectedIcon: false,
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onSelectionChanged: (pilihan) =>
                setState(() => _tampilanDaftar = pilihan.first),
          ),
        ],
      ),
    );
  }
}

class _StatusMemuatGrid extends StatelessWidget {
  const _StatusMemuatGrid();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: Warna.teal),
          const SizedBox(height: 12),
          Text(
            'Mengambil produk peukan...',
            style: TextStyle(color: Theme.of(context).hintColor, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _KategoriBulat extends StatelessWidget {
  const _KategoriBulat({
    required this.kategori,
    required this.dipilih,
    required this.onTap,
  });

  final String kategori;
  final bool dipilih;
  final VoidCallback onTap;

  IconData get _ikon {
    switch (kategori) {
      case 'Sayuran':
        return Icons.eco_outlined;
      case 'Buah':
        return Icons.emoji_nature;
      case 'Daging':
        return Icons.kebab_dining_outlined;
      case 'Ikan':
        return Icons.set_meal_outlined;
      case 'Bumbu':
        return Icons.local_fire_department_outlined;
      case 'Sembako':
        return Icons.grain;
      default:
        return Icons.apps;
    }
  }

  @override
  Widget build(BuildContext context) {
    final warna = kategori == 'Semua'
        ? Warna.teal
        : Warna.latarKategori(kategori);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: dipilih ? warna : warna.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: dipilih ? Border.all(color: warna, width: 2) : null,
              ),
              child: Icon(_ikon, color: dipilih ? Colors.white : warna),
            ),
            const SizedBox(height: 4),
            Text(
              kategori,
              style: TextStyle(
                fontSize: 11,
                fontWeight: dipilih ? FontWeight.w700 : FontWeight.w500,
                color: dipilih ? warna : Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KartuProdukBaru extends StatelessWidget {
  const KartuProdukBaru({super.key, required this.produk});

  final ProdukContoh produk;

  @override
  Widget build(BuildContext context) {
    final warna = Warna.latarKategori(produk.kategori);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.produk,
            arguments: ArgumenProduk(produk: produk),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    color: warna.withValues(alpha: 0.10),
                    child: Center(
                      child: Text(
                        produk.emoji,
                        style: const TextStyle(fontSize: 46),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: warna,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        produk.kategori,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.nama,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'per ${produk.satuan}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          produk.labelHarga,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Warna.teal,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 34,
                        height: 34,
                        child: IconButton(
                          tooltip: 'Tambah ke keranjang',
                          style: IconButton.styleFrom(
                            backgroundColor: Warna.teal,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: () {
                            context.read<KeranjangBelanja>().tambah(produk);
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${produk.nama} masuk keranjang',
                                  ),
                                  backgroundColor: Warna.tealTua,
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KondisiKosongPencarian extends StatelessWidget {
  const _KondisiKosongPencarian({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 64, color: Theme.of(context).hintColor),
          const SizedBox(height: 12),
          const Text('Produk tidak ditemukan'),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onReset,
            child: const Text('Reset pencarian'),
          ),
        ],
      ),
    );
  }
}

/// Kartu produk mode DAFTAR (satu baris per produk).
class KartuProdukBaris extends StatelessWidget {
  const KartuProdukBaris({super.key, required this.produk});

  final ProdukContoh produk;

  @override
  Widget build(BuildContext context) {
    final keranjang = context.read<KeranjangBelanja>();
    final warna = Warna.latarKategori(produk.kategori);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.produk,
            arguments: ArgumenProduk(produk: produk),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: warna.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    produk.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      produk.nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${produk.kategori} • per ${produk.satuan}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      produk.labelHarga,
                      style: const TextStyle(
                        color: Warna.teal,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 36,
                height: 36,
                child: IconButton(
                  tooltip: 'Tambah ke keranjang',
                  style: IconButton.styleFrom(
                    backgroundColor: Warna.teal,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  onPressed: () {
                    keranjang.tambah(produk);
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text('${produk.nama} masuk keranjang'),
                          backgroundColor: Warna.tealTua,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
