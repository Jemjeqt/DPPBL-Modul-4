import 'package:flutter/foundation.dart';

/// Pengirim pesan pada halaman Tanya Petugas.
enum PengirimPesan { warga, petugas }

/// Data satu pesan percakapan.
class Pesan {
  Pesan({required this.teks, required this.pengirim, DateTime? waktu})
      : waktu = waktu ?? DateTime.now();

  final String teks;
  final PengirimPesan pengirim;
  final DateTime waktu;
}

/// State bersama percakapan warga dengan petugas.
class ChatModel extends ChangeNotifier {
  final List<Pesan> _pesan = [
    Pesan(
      teks: 'Selamat pagi, saya ingin menanyakan prosedur izin usaha mikro.',
      pengirim: PengirimPesan.warga,
      waktu: DateTime(2026, 10, 17, 9, 5),
    ),
    Pesan(
      teks: 'Selamat pagi Bapak/Ibu. Siap membantu. Cukup bawa KTP, '
          'kartu keluarga, dan surat keterangan domisili ke kantor PTSP.',
      pengirim: PengirimPesan.petugas,
      waktu: DateTime(2026, 10, 17, 9, 6),
    ),
  ];

  List<Pesan> get daftar => List.unmodifiable(_pesan);

  /// Kirim pesan warga, lalu balasan simulasi dari petugas.
  void kirimPesan(String teks) {
    _pesan.add(Pesan(teks: teks, pengirim: PengirimPesan.warga));
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      _pesan.add(
        Pesan(
          teks: _balasanOtomatis(teks),
          pengirim: PengirimPesan.petugas,
        ),
      );
      notifyListeners();
    });
  }

  String _balasanOtomatis(String masukan) {
    final t = masukan.toLowerCase();
    if (t.contains('jam') || t.contains('layanan')) {
      return 'Jam layanan kami Senin–Jumat pukul 08.00–17.00 WIB, '
          'Bapak/Ibu dapat memilih sesi kunjungan pada formulir pengajuan.';
    }
    if (t.contains('biaya') || t.contains('tarif')) {
      return 'Seluruh layanan di portal ini gratis, tidak ada biaya resmi '
          'kecuali retribusi yang tercantum pada lembar persetujuan.';
    }
    if (t.contains('dokumen') || t.contains('berkas')) {
      return 'Dokumen umum yang dibutuhkan: KTP, KK, NPWP, dan surat '
          'keterangan domisili. Nanti kami kirimkan daftar lengkapnya ya.';
    }
    return 'Terima kasih atas pesannya. Petugas kami akan menindaklanjuti '
          'secepatnya, mohon tunggu konfirmasi melalui email terdaftar.';
  }
}
