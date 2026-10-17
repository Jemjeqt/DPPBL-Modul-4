import 'package:flutter/foundation.dart';

class Pendaftar {
  final String nama;
  final String email;
  final String sesi;
  Pendaftar({required this.nama, required this.email, required this.sesi});
}

class PendaftarModel extends ChangeNotifier {
  final List<Pendaftar> _daftar = [];
  List<Pendaftar> get daftar => List.unmodifiable(_daftar);

  void tambah(Pendaftar pendaftar) {
    _daftar.add(pendaftar);
    notifyListeners();
  }

  int jumlahSesi(String sesi) => _daftar.where((p) => p.sesi == sesi).length;
}