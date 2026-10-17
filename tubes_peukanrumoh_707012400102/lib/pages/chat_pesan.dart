import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../halaman/widget_desain.dart';
import '../model/chat_model.dart';

/// Halaman materi **Pustaka Chat**.
///
/// Menyediakan antarmuka chat interaktif antara pembeli dan penjual kios
/// Peukan Rumoh. Memuat:
/// * Daftar pesan gelembung (bubble chat) yang dibaca dari [ChatModel].
/// * Input [TextField] untuk mengetik pesan baru.
/// * Tombol [ElevatedButton] / [IconButton] untuk mengirim pesan.
/// * Saran balasan cepat (Quick Reply Chips) untuk kemudahan transaksi.
/// * Balasan interaktif otomatis dari penjual untuk memperlihatkan pembaruan
///   state secara langsung (bukan data statis).
class HalamanChatPesan extends StatefulWidget {
  const HalamanChatPesan({super.key});

  @override
  State<HalamanChatPesan> createState() => _HalamanChatPesanState();
}

class _HalamanChatPesanState extends State<HalamanChatPesan> {
  final TextEditingController _pesanController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _saranPesan = [
    'Ikan tongkolnya masih segar Kak?',
    'Bisa diantar pagi jam 06.30 WIB?',
    'Ada cabai rawit merah dan bawang aceh?',
    'Minta tolong bersihkan ikannya ya!',
  ];

  @override
  void dispose() {
    _pesanController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _kirimPesan([String? teksLangsung]) {
    final teks = (teksLangsung ?? _pesanController.text).trim();
    if (teks.isEmpty) return;

    context.read<ChatModel>().tambahPesan(
          nama: 'Anda',
          isi: teks,
          isMe: true,
        );

    _pesanController.clear();

    // Gulir otomatis ke pesan terbawah
    Future.delayed(const Duration(milliseconds: 200), () {
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
    final chatModel = context.watch<ChatModel>();
    final pesanList = chatModel.pesan;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Warna.teal.withValues(alpha: 0.15),
              child: const Icon(Icons.storefront, color: Warna.teal, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Penjual Peukan Rumoh',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Online • ${chatModel.jumlah} pesan',
                        style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Hapus Pesan Terakhir',
            icon: const Icon(Icons.undo),
            onPressed: () {
              context.read<ChatModel>().hapusPesanTerakhir();
            },
          ),
          IconButton(
            tooltip: 'Reset Riwayat Chat',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ChatModel>().resetChat();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner Ringkasan Provider
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Warna.tealMuda,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Pustaka Chat Pasar Tradisional',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Warna.tealTua),
                  ),
                ),
                Text(
                  'Total: ${chatModel.jumlah} pesan',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Warna.tealTua),
                ),
              ],
            ),
          ),

          // Daftar Gelembung Pesan (ListView)
          Expanded(
            child: pesanList.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 48, color: Warna.teal),
                        SizedBox(height: 10),
                        Text('Belum ada pesan. Mulai obrolan dengan penjual!'),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    itemCount: pesanList.length,
                    itemBuilder: (ctx, idx) {
                      final pesan = pesanList[idx];
                      return _GelembungChat(pesan: pesan);
                    },
                  ),
          ),

          // Saran Balasan Cepat (Quick Replies)
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _saranPesan.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                final saran = _saranPesan[i];
                return ActionChip(
                  label: Text(saran, style: const TextStyle(fontSize: 11)),
                  backgroundColor: Warna.teal.withValues(alpha: 0.1),
                  side: BorderSide(color: Warna.teal.withValues(alpha: 0.3)),
                  onPressed: () => _kirimPesan(saran),
                );
              },
            ),
          ),
          const SizedBox(height: 6),

          // Kotak Input Pesan
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _pesanController,
                      decoration: InputDecoration(
                        hintText: 'Tulis pesan kebutuhan pasar...',
                        hintStyle: TextStyle(fontSize: 13, color: Theme.of(context).hintColor),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(color: Theme.of(context).dividerColor),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      onSubmitted: (_) => _kirimPesan(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Warna.teal,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(14),
                    ),
                    onPressed: _kirimPesan,
                    child: const Icon(Icons.send, size: 20),
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

class _GelembungChat extends StatelessWidget {
  const _GelembungChat({required this.pesan});

  final PesanChat pesan;

  @override
  Widget build(BuildContext context) {
    final isMe = pesan.isMe;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: Warna.teal.withValues(alpha: 0.15),
              child: const Text('P', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Warna.tealTua)),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMe
                    ? Warna.teal
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                border: isMe
                    ? null
                    : Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (!isMe)
                    Text(
                      pesan.nama,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Warna.tealTua,
                      ),
                    ),
                  Text(
                    pesan.isi,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: isMe ? Colors.white : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    pesan.labelWaktu,
                    style: TextStyle(
                      fontSize: 9,
                      color: isMe ? Colors.white70 : Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 6),
            CircleAvatar(
              radius: 14,
              backgroundColor: Warna.tealTua,
              child: const Icon(Icons.person, size: 16, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
}
