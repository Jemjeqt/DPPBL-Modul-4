import 'package:flutter/material.dart';

class DetailKegiatanPage extends StatelessWidget {
  const DetailKegiatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Kegiatan')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Seminar Teknologi Mobile dilaksanakan di Gedung Seminar Kampus, pukul 09.00 hingga selesai.',
        ),
      ),
    );
  }
}
