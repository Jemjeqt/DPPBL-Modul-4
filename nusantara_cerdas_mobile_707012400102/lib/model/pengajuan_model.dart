import 'package:flutter/foundation.dart';

/// Status penanganan sebuah pengajuan layanan.
enum StatusPengajuan { diajukan, diproses, selesai }

/// Data satu pengajuan layanan.
class Pengajuan {
  Pengajuan({
    required this.namaLayanan,
    required this.instansi,
    required this.bidang,
    required this.namaPemohon,
    required this.email,
    required this.sesi,
    DateTime? tanggal,
    this.status = StatusPengajuan.diajukan,
  }) : tanggal = tanggal ?? DateTime.now();

  final String namaLayanan;
  final String instansi;
  final String bidang; // Perizinan | Kesehatan | Transportasi | ...
  final String namaPemohon;
  final String email;
  final String sesi;
  final DateTime tanggal;
  StatusPengajuan status;

  String get tanggalTampil {
    const namaBulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${tanggal.day} ${namaBulan[tanggal.month - 1]} ${tanggal.year}';
  }
}

/// State bersama: seluruh data pengajuan layanan warga.
class PengajuanModel extends ChangeNotifier {
  final List<Pengajuan> _daftar = [
    Pengajuan(
      namaLayanan: 'Izin Usaha Mikro Kecil',
      instansi: 'Dinas Penanaman Modal dan PTSP',
      bidang: 'Perizinan',
      namaPemohon: 'Mimkayel Sempu',
      email: 'mimkayel@mail.id',
      sesi: 'Pagi (08.00 – 11.00)',
      tanggal: DateTime(2026, 10, 8),
      status: StatusPengajuan.diproses,
    ),
    Pengajuan(
      namaLayanan: 'Pemeriksaan Kesehatan Gratis',
      instansi: 'Dinas Kesehatan Kota',
      bidang: 'Kesehatan',
      namaPemohon: 'Mimkayel Sempu',
      email: 'mimkayel@mail.id',
      sesi: 'Siang (11.00 – 14.00)',
      tanggal: DateTime(2026, 9, 28),
      status: StatusPengajuan.selesai,
    ),
    Pengajuan(
      namaLayanan: 'Keringanan Tarif Transportasi',
      instansi: 'Dinas Perhubungan',
      bidang: 'Transportasi',
      namaPemohon: 'Mimkayel Sempu',
      email: 'mimkayel@mail.id',
      sesi: 'Sore (14.00 – 17.00)',
      tanggal: DateTime(2026, 9, 15),
      status: StatusPengajuan.selesai,
    ),
  ];

  List<Pengajuan> get daftar => List.unmodifiable(_daftar);

  /// Pengurutan terbaru di atas.
  List<Pengajuan> get daftarTerbaru {
    final urut = List<Pengajuan>.from(_daftar);
    urut.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    return urut;
  }

  int get jumlah => _daftar.length;

  int jumlahBidang(String bidang) =>
      _daftar.where((p) => p.bidang == bidang).length;

  int jumlahStatus(StatusPengajuan s) =>
      _daftar.where((p) => p.status == s).length;

  void tambahPengajuan(Pengajuan pengajuan) {
    _daftar.add(pengajuan);
    notifyListeners();
  }

  /// Long-press pada kartu riwayat: tandai selesai ditindaklanjuti.
  void tandaiSelesai(Pengajuan pengajuan) {
    pengajuan.status = StatusPengajuan.selesai;
    notifyListeners();
  }

  void ubahStatus(Pengajuan pengajuan, StatusPengajuan status) {
    pengajuan.status = status;
    notifyListeners();
  }
}
