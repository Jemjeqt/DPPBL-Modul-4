import 'package:flutter/foundation.dart';

import '../halaman/data/data_contoh.dart';

/// Model data bersama (shared state) yang dipakai lebih dari satu halaman:
/// Beranda (badge + tombol tambah), Detail Produk, Halaman Keranjang,
/// dan badge pada kerangka navigasi.
///
/// Meng-extend [ChangeNotifier] agar bisa disediakan lewat ChangeNotifierProvider
/// dan dibaca dari widget mana pun dengan context.watch / context.read /
/// context.select.
class KeranjangBelanja extends ChangeNotifier {
  final Map<int, ItemKeranjang> _item = {};

  /// Item yang ada di keranjang saat ini (urutan penyisipan).
  List<ItemKeranjang> get item => List.unmodifiable(_item.values);

  int get jumlahJenis => _item.length;

  int get totalBarang =>
      _item.values.fold(0, (total, item) => total + item.jumlah);

  int get totalHarga =>
      _item.values.fold(0, (total, item) => total + item.subtotal);

  int get ongkir => _item.isEmpty ? 0 : 12000;

  int get totalBayar => totalHarga + ongkir;

  bool get kosong => _item.isEmpty;

  int jumlahUntuk(ProdukContoh produk) => _item[produk.id]?.jumlah ?? 0;

  void tambah(ProdukContoh produk) {
    final sekarang = jumlahUntuk(produk);
    _item[produk.id] = ItemKeranjang(produk: produk, jumlah: sekarang + 1);
    notifyListeners();
  }

  void kurangi(ProdukContoh produk) {
    final sekarang = jumlahUntuk(produk);
    if (sekarang <= 1) {
      _item.remove(produk.id);
    } else {
      _item[produk.id] = ItemKeranjang(produk: produk, jumlah: sekarang - 1);
    }
    notifyListeners();
  }

  void kosongkan() {
    if (_item.isEmpty) return;
    _item.clear();
    notifyListeners();
  }
}
