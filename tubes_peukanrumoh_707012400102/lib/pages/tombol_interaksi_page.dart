import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../halaman/widget_desain.dart';
import '../model/interaksi_model.dart';
import '../navigation/app_routes.dart';

/// Halaman materi **Tombol dan Interaksi**.
///
/// Mengimplementasikan komponen:
/// * [ElevatedButton] untuk aksi utama dan klaim kupon.
/// * [FloatingActionButton] untuk aksi cepat mengambang.
/// * [GestureDetector] untuk menangkap gestur: ketuk tunggal, ketuk ganda,
///   tekan lama, dan geser (swipe).
///
/// Seluruh state tersimpan di [InteraksiModel] ([ChangeNotifier]),
/// disediakan di akar aplikasi dan dapat dibaca di minimal dua halaman
/// berbeda (halaman ini dan Halaman Profil / Beranda).
class HalamanTombolInteraksi extends StatefulWidget {
  const HalamanTombolInteraksi({super.key});

  @override
  State<HalamanTombolInteraksi> createState() => _HalamanTombolInteraksiState();
}

class _HalamanTombolInteraksiState extends State<HalamanTombolInteraksi> {
  String _statusGesturLokal = 'Belum ada gestur pada area kotak di bawah';
  Color _warnaKotakGestur = Warna.teal;

  void _ubahWarnaGestur(Color warna, String namaGestur) {
    setState(() {
      _statusGesturLokal = namaGestur;
      _warnaKotakGestur = warna;
    });
  }

  @override
  Widget build(BuildContext context) {
    final interaksi = context.watch<InteraksiModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tombol & Interaksi Peukan'),
        actions: [
          IconButton(
            tooltip: 'Reset Data Interaksi',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<InteraksiModel>().resetInteraksi();
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Statistik interaksi berhasil direset.'),
                    backgroundColor: Warna.tealTua,
                  ),
                );
            },
          ),
        ],
      ),
      // Komponen FloatingActionButton (sesuai materi tugas)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<InteraksiModel>().catatAksi(
                komponen: 'FloatingActionButton',
                aksi: 'Menekan Tombol Mengambang (FAB) Peukan',
                bonusPoin: 20,
              );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('FloatingActionButton ditekan! +20 Poin Peukan didapat.'),
                backgroundColor: Warna.tealTua,
                duration: Duration(seconds: 1),
              ),
            );
        },
        backgroundColor: Warna.teal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.touch_app),
        label: const Text('Aksi Cepat FAB'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Penjelasan Materi
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Warna.teal.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Warna.teal.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.ads_click, color: Warna.tealTua, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Materi: Tombol & Interaksi (Provider)',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Warna.tealTua,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Menerapkan ElevatedButton, FloatingActionButton, dan GestureDetector dengan state bersama di InteraksiModel.',
                          style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Kartu Ringkasan State Provider (Dibaca juga dari Profil & Beranda)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Warna.tealTua, Warna.teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Warna.teal.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Statistik State Interaksi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          interaksi.diskonKilatAktif ? 'Diskon 20% AKTIF' : 'Diskon Standar',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Poin Peukan',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            Text(
                              '${interaksi.poinPeukan} Poin',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Interaksi',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            Text(
                              '${interaksi.totalInteraksi} Kali',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Aksi Terakhir: ${interaksi.aksiTerakhir} (${interaksi.tipeKomponenTerakhir})',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // 1. ElevatedButton Section
            const Text(
              '1. Komponen ElevatedButton',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Warna.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        context.read<InteraksiModel>().catatAksi(
                              komponen: 'ElevatedButton',
                              aksi: 'Klaim Kupon Belanja Peukan Rp 15.000',
                              bonusPoin: 15,
                            );
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text('Kupon Rp 15.000 berhasil diklaim (+15 Poin)!'),
                              backgroundColor: Warna.tealTua,
                              duration: Duration(seconds: 1),
                            ),
                          );
                      },
                      icon: const Icon(Icons.card_giftcard),
                      label: const Text(
                        'Klaim Kupon Belanja (+15 Poin)',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: interaksi.diskonKilatAktif
                            ? Colors.deepOrange
                            : Colors.blueGrey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        context.read<InteraksiModel>().toggleDiskonKilat();
                      },
                      icon: Icon(
                        interaksi.diskonKilatAktif
                            ? Icons.flash_on
                            : Icons.flash_off,
                      ),
                      label: Text(
                        interaksi.diskonKilatAktif
                            ? 'Nonaktifkan Diskon Kilat Peukan'
                            : 'Aktifkan Diskon Kilat Peukan (+15 Poin)',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),

            // 2. GestureDetector Section
            const Text(
              '2. Komponen GestureDetector',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              'Uji sentuhan pada kanvas di bawah: Tap, Double Tap, Long Press, atau Geser Kanan/Kiri.',
              style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                _ubahWarnaGestur(Warna.teal, 'Single Tap terdeteksi (+5 Poin)');
                context.read<InteraksiModel>().catatAksi(
                      komponen: 'GestureDetector',
                      aksi: 'Ketukan Tunggal (Single Tap) pada Kanvas',
                      bonusPoin: 5,
                    );
              },
              onDoubleTap: () {
                _ubahWarnaGestur(Colors.amber.shade800, 'Double Tap terdeteksi (+10 Poin Bonus)');
                context.read<InteraksiModel>().catatAksi(
                      komponen: 'GestureDetector',
                      aksi: 'Ketukan Ganda (Double Tap) pada Kanvas',
                      bonusPoin: 10,
                    );
              },
              onLongPress: () {
                _ubahWarnaGestur(Colors.purple, 'Long Press (Tekan Lama) terdeteksi (+15 Poin)');
                context.read<InteraksiModel>().catatAksi(
                      komponen: 'GestureDetector',
                      aksi: 'Tekan Lama (Long Press) pada Kanvas',
                      bonusPoin: 15,
                    );
              },
              onHorizontalDragEnd: (details) {
                _ubahWarnaGestur(Colors.indigo, 'Swipe Horisontal terdeteksi (+10 Poin)');
                context.read<InteraksiModel>().catatAksi(
                      komponen: 'GestureDetector',
                      aksi: 'Geser Horisontal (Swipe) pada Kanvas',
                      bonusPoin: 10,
                    );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _warnaKotakGestur.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: _warnaKotakGestur, width: 2),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.touch_app, size: 36, color: _warnaKotakGestur),
                      const SizedBox(height: 8),
                      Text(
                        _statusGesturLokal,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _warnaKotakGestur,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ketuk 1x | Ketuk 2x | Tahan Lama | Geser Layar',
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),

            // 3. FloatingActionButton Explanation
            const Text(
              '3. Komponen FloatingActionButton (FAB)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Warna.teal.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.touch_app, color: Warna.teal),
                ),
                title: const Text('Tombol Mengambang Aktif di Kanan Bawah'),
                subtitle: const Text(
                  'Klik tombol FAB di kanan bawah untuk mencatat aksi instan dan menambah poin ke Provider.',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Warna.teal),
                  onPressed: () {
                    context.read<InteraksiModel>().catatAksi(
                          komponen: 'FloatingActionButton',
                          aksi: 'Menekan Tombol FAB Alternatif',
                          bonusPoin: 20,
                        );
                  },
                  child: const Text('Uji FAB', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
            ),
            const SizedBox(height: 22),

            // Riwayat Log Interaksi Terakhir
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Log Riwayat Interaksi (Live)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
                Text(
                  '${interaksi.riwayat.length} catatan',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (interaksi.riwayat.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
                ),
                child: const Text(
                  'Belum ada interaksi. Silakan coba tekan tombol, FAB, atau gestur di atas!',
                  style: TextStyle(fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: interaksi.riwayat.take(5).length,
                separatorBuilder: (_, _) => const SizedBox(height: 6),
                itemBuilder: (ctx, idx) {
                  final log = interaksi.riwayat[idx];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Warna.teal.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            log.komponen.contains('Elevated')
                                ? Icons.smart_button
                                : log.komponen.contains('Floating')
                                    ? Icons.touch_app
                                    : Icons.gesture,
                            size: 18,
                            color: Warna.tealTua,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                log.aksi,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                              Text(
                                '${log.komponen} • ${log.waktu.hour}:${log.waktu.minute.toString().padLeft(2, '0')}:${log.waktu.second.toString().padLeft(2, '0')}',
                                style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '+${log.poinDidapat}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(height: 20),

            // Tombol Navigasi ke Profil untuk Pembuktian Multi-Page
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.beranda);
              },
              icon: const Icon(Icons.person_outline),
              label: const Text('Buka Profil (Cek Sinkronisasi Poin & Interaksi)'),
            ),
            const SizedBox(height: 80), // Padding untuk FloatingActionButton
          ],
        ),
      ),
    );
  }
}
