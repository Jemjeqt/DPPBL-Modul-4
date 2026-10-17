import 'package:flutter/foundation.dart';

import '../halaman/data/data_contoh.dart';

/// State bersama untuk menampung dan menampilkan statistik penilaian produk.
///
/// ChangeNotifier ini:
/// * menyimpan nilai rata-rata per produk secara bersama (bukan sekadar
///   lokal setState),
/// * disediakan melalui MultiProvider di Main, dan
/// * bisa dibaca dari minimal dua halaman (mis. halaman statistik dan
///   halaman produk).
class PenilaianProduk extends ChangeNotifier {
  final Map<int, double> _nilai = {};

  /// Nilai rata-rata untuk produk tertentu (default 0.0 bila belum ada).
  double nilaiUntuk(ProdukContoh produk) => _nilai[produk.id] ?? 0.0;

  /// Minta penilaian numerik (1-5). Nilai lama digabungkan rata-rata.
  void tambahPenilaian(ProdukContoh produk, double nilaiBaru) {
    assert(nilaiBaru >= 1 && nilaiBaru <= 5, 'Nilai harus antara 1-5');
    final sudahAda = _nilai.containsKey(produk.id);
    final lama = sudahAda ? _nilai[produk.id]! : produk.penilaian;
    final hitungLama = sudahAda ? 1 : 0;
    final campuran = (hitungLama * lama + nilaiBaru) / (hitungLama + 1);
    _nilai[produk.id] = campuran;
    notifyListeners();
  }

  int get jumlahTerhitung => _nilai.length;

  /// Tambahkan nilai dari banyak produk sekaligus (mis. inisialisasi demo).
  void masukkanNilai(ProdukContoh produk, double nilai) {
    _nilai[produk.id] = nilai;
    notifyListeners();
  }
}
