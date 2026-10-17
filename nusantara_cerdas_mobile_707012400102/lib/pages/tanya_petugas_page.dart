import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/chat_model.dart';
import '../tema_nusantara.dart';

/// Tanya Petugas: daftar pesan, gelembung warga/petugas, kolom input.
class TanyaPetugasPage extends StatefulWidget {
  const TanyaPetugasPage({super.key});

  @override
  State<TanyaPetugasPage> createState() => _TanyaPetugasPageState();
}

class _TanyaPetugasPageState extends State<TanyaPetugasPage> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _kirim() {
    final teks = _inputController.text.trim();
    if (teks.isEmpty) return;
    context.read<ChatModel>().kirimPesan(teks);
    _inputController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final daftar = context.watch<ChatModel>().daftar;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('TANYA PETUGAS'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              itemCount: daftar.length,
              itemBuilder: (context, i) => _GelembungPesan(pesan: daftar[i]),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: WarnaNusantara.garis)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _kirim(),
                      decoration: const InputDecoration(
                        hintText: 'Tulis pesan untuk petugas…',
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    color: WarnaNusantara.hijauTua,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: _kirim,
                      borderRadius: BorderRadius.circular(12),
                      child: const SizedBox(
                        width: 46,
                        height: 46,
                        child: Icon(Icons.send, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GelembungPesan extends StatelessWidget {
  const _GelembungPesan({required this.pesan});

  final Pesan pesan;

  @override
  Widget build(BuildContext context) {
    final adalahWarga = pesan.pengirim == PengirimPesan.warga;
    return Align(
      alignment: adalahWarga ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        decoration: BoxDecoration(
          color: adalahWarga
              ? WarnaNusantara.hijauTua
              : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(adalahWarga ? 16 : 4),
            bottomRight: Radius.circular(adalahWarga ? 4 : 16),
          ),
          border: adalahWarga
              ? null
              : Border.all(color: WarnaNusantara.garis),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pesan.teks,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: adalahWarga ? Colors.white : WarnaNusantara.teksUtama,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${pesan.waktu.hour.toString().padLeft(2, '0')}:'
              '${pesan.waktu.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 10,
                color: adalahWarga ? Colors.white60 : WarnaNusantara.teksPendamping,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
