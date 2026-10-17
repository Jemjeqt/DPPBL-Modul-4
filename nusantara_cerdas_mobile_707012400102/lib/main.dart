import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/chat_model.dart';
import 'model/pengajuan_model.dart';
import 'navigation/kerangka_navigasi.dart';
import 'tema_nusantara.dart';

void main() {
  runApp(const NusantaraCerdasApp());
}

/// Aplikasi Nusantara Cerdas Mobile — 707012400102.
class NusantaraCerdasApp extends StatelessWidget {
  const NusantaraCerdasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // State bersama seluruh pengajuan layanan.
        ChangeNotifierProvider(create: (_) => PengajuanModel()),
        // State bersama percakapan Tanya Petugas.
        ChangeNotifierProvider(create: (_) => ChatModel()),
      ],
      child: MaterialApp(
        title: 'Nusantara Cerdas Mobile',
        debugShowCheckedModeBanner: false,
        theme: temaNusantara(),
        // Tanpa initialRoute eksplisit: rute awal mengikuti URL (deep link
        // web) atau '/' pada perangkat, sehingga rute bernama tetap berfungsi.
        routes: KerangkaNavigasi.daftarTujuan(),
      ),
    );
  }
}
