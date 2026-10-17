import 'package:flutter/foundation.dart';

/// Model perubahan (ChangeNotifier) untuk materi **Pustaka Chat**.
///
/// Mengelola percakapan interaktif antara pelanggan dan penjual Peukan Rumoh.
/// Setiap pesan baru memicu [notifyListeners] agar UI yang mengamati
/// [context.watch<ChatModel>()] atau [context.select] otomatis diperbarui.
class ChatModel extends ChangeNotifier {
  ChatModel() {
    _inisialisasiPesanAwal();
  }

  final List<PesanChat> _pesan = [];

  List<PesanChat> get pesan => List.unmodifiable(_pesan);

  int get jumlah => _pesan.length;

  int get pesanDariSaya => _pesan.where((p) => p.isMe).length;

  void _inisialisasiPesanAwal() {
    _pesan.addAll([
      PesanChat(
        nama: 'CS Peukan Rumoh',
        isi: 'Halo Kak! Selamat datang di layanan chat Peukan Rumoh Aceh. Ada kebutuhan pasar yang bisa kami bantu?',
        isMe: false,
        waktu: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      PesanChat(
        nama: 'Anda',
        isi: 'Halo, apakah ikan dencis dan kangkung aceh masih segar untuk pengantaran pagi ini?',
        isMe: true,
        waktu: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      PesanChat(
        nama: 'CS Peukan Rumoh',
        isi: 'Alhamdulillah segar sekali Kak! Baru tiba dari TPI Lampulo pagi subuh tadi. Silakan dipesan ya!',
        isMe: false,
        waktu: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
    ]);
  }

  /// Tambahkan pesan baru ke akhir daftar.
  void tambahPesan({
    required String nama,
    required String isi,
    bool isMe = true,
    bool terlambat = false,
  }) {
    if (isi.trim().isEmpty) return;
    _pesan.add(
      PesanChat(
        nama: nama,
        isi: isi.trim(),
        isMe: isMe,
        terlambat: terlambat,
        waktu: DateTime.now(),
      ),
    );
    notifyListeners();

    // Simulasi balasan otomatis dari Penjual jika pesan dikirim oleh user
    if (isMe) {
      _simulasiBalasanOtomatis(isi);
    }
  }

  void _simulasiBalasanOtomatis(String pesanUser) {
    Future.delayed(const Duration(milliseconds: 700), () {
      String balasan;
      final lower = pesanUser.toLowerCase();
      if (lower.contains('harga') || lower.contains('diskon')) {
        balasan = 'Harga di Peukan Rumoh dijamin harga pasar tradisional asli dan ada diskon kilat peukan!';
      } else if (lower.contains('kirim') || lower.contains('antar') || lower.contains('jam')) {
        balasan = 'Pengiriman kami mulai pukul 06.00 WIB pagi dengan kurir ekspres peukan.';
      } else if (lower.contains('terima kasih') || lower.contains('makasih')) {
        balasan = 'Sama-sama Kak! Semoga belanjanya berkah dan menyenangkan.';
      } else {
        balasan = 'Baik Kak, pesan telah diterima oleh penjual kios peukan. Kami siapkan segera!';
      }

      _pesan.add(
        PesanChat(
          nama: 'Penjual Peukan Rumoh',
          isi: balasan,
          isMe: false,
          waktu: DateTime.now(),
        ),
      );
      notifyListeners();
    });
  }

  /// Hapus pesan terakhir (contoh aksi sederhana).
  void hapusPesanTerakhir() {
    if (_pesan.isEmpty) return;
    _pesan.removeLast();
    notifyListeners();
  }

  /// Bersihkan riwayat chat
  void resetChat() {
    _pesan.clear();
    _inisialisasiPesanAwal();
    notifyListeners();
  }
}

/// Representasi satu pesan chat.
class PesanChat {
  PesanChat({
    required this.nama,
    required this.isi,
    this.isMe = false,
    this.terlambat = false,
    DateTime? waktu,
  }) : waktu = waktu ?? DateTime.now();

  final String nama;
  final String isi;
  final bool isMe;
  final bool terlambat;
  final DateTime waktu;

  String get labelWaktu {
    final m = waktu.minute.toString().padLeft(2, '0');
    final h = waktu.hour.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get horison {
    final jam = waktu.hour;
    if (jam < 12) return 'Pagi';
    if (jam < 15) return 'Siang';
    if (jam < 18) return 'Sore';
    return 'Malam';
  }
}
