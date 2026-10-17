import 'package:flutter/foundation.dart';

/// Model perubahan (ChangeNotifier) untuk materi **Form dan Input**.
///
/// Menyimpan state formulir pemesanan dan preferensi belanja peukan,
/// termasuk teks input ([TextField]), pilihan checklist ([Checkbox]),
/// serta opsi radio ([RadioButton]).
///
/// Disediakan di akar aplikasi melalui [MultiProvider] dan dibaca
/// di minimal dua halaman berbeda ([HalamanFormInput], [HalamanProfil], dsb.).
class FormInputModel extends ChangeNotifier {
  String _namaPemesan = 'Cut Nyak Meurah';
  String _nomorTelepon = '081234567890';
  String _catatanKebutuhan = 'Mohon pilih sayuran yang paling segar dari peukan pagi ini.';
  
  // Checkbox pilihan layanan
  bool _bungkusRamahLingkungan = true;
  bool _bersihkanBahan = true;
  bool _kirimPagi = false;

  // Radio button pilihan kurir dan metode pembayaran
  String _metodePengiriman = 'Kurir Peukan Ekspres';
  String _metodePembayaran = 'QRIS Peukan';

  bool _sudahDisimpan = true;
  DateTime _waktuPembaruan = DateTime.now();

  // Getters
  String get namaPemesan => _namaPemesan;
  String get nomorTelepon => _nomorTelepon;
  String get catatanKebutuhan => _catatanKebutuhan;
  bool get bungkusRamahLingkungan => _bungkusRamahLingkungan;
  bool get bersihkanBahan => _bersihkanBahan;
  bool get kirimPagi => _kirimPagi;
  String get metodePengiriman => _metodePengiriman;
  String get metodePembayaran => _metodePembayaran;
  bool get sudahDisimpan => _sudahDisimpan;
  DateTime get waktuPembaruan => _waktuPembaruan;

  int get totalLayananTambahan {
    int total = 0;
    if (_bungkusRamahLingkungan) total += 2000;
    if (_bersihkanBahan) total += 3000;
    if (_kirimPagi) total += 5000;
    return total;
  }

  void updateNama(String nilai) {
    _namaPemesan = nilai;
    _sudahDisimpan = false;
    notifyListeners();
  }

  void updateTelepon(String nilai) {
    _nomorTelepon = nilai;
    _sudahDisimpan = false;
    notifyListeners();
  }

  void updateCatatan(String nilai) {
    _catatanKebutuhan = nilai;
    _sudahDisimpan = false;
    notifyListeners();
  }

  void toggleBungkusRamahLingkungan(bool? nilai) {
    _bungkusRamahLingkungan = nilai ?? false;
    _sudahDisimpan = false;
    notifyListeners();
  }

  void toggleBersihkanBahan(bool? nilai) {
    _bersihkanBahan = nilai ?? false;
    _sudahDisimpan = false;
    notifyListeners();
  }

  void toggleKirimPagi(bool? nilai) {
    _kirimPagi = nilai ?? false;
    _sudahDisimpan = false;
    notifyListeners();
  }

  void setMetodePengiriman(String nilai) {
    _metodePengiriman = nilai;
    _sudahDisimpan = false;
    notifyListeners();
  }

  void setMetodePembayaran(String nilai) {
    _metodePembayaran = nilai;
    _sudahDisimpan = false;
    notifyListeners();
  }

  void simpanForm({
    required String nama,
    required String telepon,
    required String catatan,
    required String pengiriman,
    required String pembayaran,
    required bool bungkus,
    required bool bersihkan,
    required bool pagi,
  }) {
    _namaPemesan = nama.trim().isEmpty ? 'Pelanggan Peukan' : nama.trim();
    _nomorTelepon = telepon.trim();
    _catatanKebutuhan = catatan.trim();
    _metodePengiriman = pengiriman;
    _metodePembayaran = pembayaran;
    _bungkusRamahLingkungan = bungkus;
    _bersihkanBahan = bersihkan;
    _kirimPagi = pagi;
    _sudahDisimpan = true;
    _waktuPembaruan = DateTime.now();
    notifyListeners();
  }

  void resetForm() {
    _namaPemesan = 'Cut Nyak Meurah';
    _nomorTelepon = '081234567890';
    _catatanKebutuhan = 'Sayuran segar peukan pagi.';
    _bungkusRamahLingkungan = true;
    _bersihkanBahan = false;
    _kirimPagi = false;
    _metodePengiriman = 'Kurir Peukan Ekspres';
    _metodePembayaran = 'QRIS Peukan';
    _sudahDisimpan = true;
    _waktuPembaruan = DateTime.now();
    notifyListeners();
  }
}
