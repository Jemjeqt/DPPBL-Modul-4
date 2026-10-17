import 'package:flutter/foundation.dart';

/// Riwayat aksi interaksi tombol dan gestur.
class RiwayatAksi {
  RiwayatAksi({
    required this.komponen,
    required this.aksi,
    required this.poinDidapat,
    required this.waktu,
  });

  final String komponen;
  final String aksi;
  final int poinDidapat;
  final DateTime waktu;
}

/// Model perubahan (ChangeNotifier) untuk materi **Tombol dan Interaksi**.
///
/// Mengelola respons terhadap:
/// * [ElevatedButton] (Aksi utama, klaim kupon, aktifkan diskon)
/// * [FloatingActionButton] (Aksi cepat melayang)
/// * [GestureDetector] (Tap tunggal, double tap, long press, swipe/drag)
///
/// Data ini dapat dibaca dan dimanipulasi secara reaktif dari
/// [HalamanTombolInteraksi], [HalamanProfil], dan [HalamanBeranda].
class InteraksiModel extends ChangeNotifier {
  int _totalInteraksi = 0;
  int _poinPeukan = 100;
  String _aksiTerakhir = 'Belum ada interaksi terbaru';
  String _tipeKomponenTerakhir = 'Siap Berinteraksi';
  bool _diskonKilatAktif = false;
  final List<RiwayatAksi> _riwayat = [];

  int get totalInteraksi => _totalInteraksi;
  int get poinPeukan => _poinPeukan;
  String get aksiTerakhir => _aksiTerakhir;
  String get tipeKomponenTerakhir => _tipeKomponenTerakhir;
  bool get diskonKilatAktif => _diskonKilatAktif;
  List<RiwayatAksi> get riwayat => List.unmodifiable(_riwayat);

  void catatAksi({
    required String komponen,
    required String aksi,
    int bonusPoin = 5,
  }) {
    _totalInteraksi++;
    _poinPeukan += bonusPoin;
    _aksiTerakhir = aksi;
    _tipeKomponenTerakhir = komponen;

    _riwayat.insert(
      0,
      RiwayatAksi(
        komponen: komponen,
        aksi: aksi,
        poinDidapat: bonusPoin,
        waktu: DateTime.now(),
      ),
    );

    // Batasi riwayat maksimal 20 aksi terakhir
    if (_riwayat.length > 20) {
      _riwayat.removeLast();
    }

    notifyListeners();
  }

  void toggleDiskonKilat() {
    _diskonKilatAktif = !_diskonKilatAktif;
    catatAksi(
      komponen: 'ElevatedButton',
      aksi: _diskonKilatAktif
          ? 'Mengaktifkan Diskon Kilat 20% Peukan'
          : 'Menonaktifkan Diskon Kilat',
      bonusPoin: 15,
    );
  }

  void resetInteraksi() {
    _totalInteraksi = 0;
    _poinPeukan = 100;
    _aksiTerakhir = 'Statistik interaksi telah direset';
    _tipeKomponenTerakhir = 'Reset';
    _diskonKilatAktif = false;
    _riwayat.clear();
    notifyListeners();
  }
}
