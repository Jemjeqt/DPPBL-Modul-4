import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../models/penilaian_produk.dart';
import '../navigation/app_routes.dart';
import '../halaman/data/data_contoh.dart';
import '../halaman/widget_desain.dart';

class HalamanChartPenilaian extends StatefulWidget {
  const HalamanChartPenilaian({super.key});

  @override
  State<HalamanChartPenilaian> createState() => _HalamanChartPenilaianState();
}

class _HalamanChartPenilaianState extends State<HalamanChartPenilaian> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Inisialisasi demo hanya sekali per sesi agar diagram tidak kosong.
    _inisialisasiIfNeeded();
  }

  void _inisialisasiIfNeeded() {
    final penilaian = context.read<PenilaianProduk>();
    if (penilaian.jumlahTerhitung > 0) return;

    for (final produk in daftarProdukContoh) {
      penilaian.masukkanNilai(produk, produk.penilaian);
    }
  }

  List<_BarDatum> get _data => daftarProdukContoh.map((produk) {
    return _BarDatum(
      produk: produk,
      label: produk.nama.split(' ').first,
      nilai: context.read<PenilaianProduk>().nilaiUntuk(produk),
      warna: Warna.latarKategori(produk.kategori),
    );
  }).toList();

  double get _maksNilai =>
      _data
          .map((d) => d.nilai)
          .reduce((a, b) => a > b ? a : b)
          .clamp(0.0, 5.0) +
      0.5;

  @override
  Widget build(BuildContext context) {
    final judul = 'Chart Penilaian Produk';

    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _JudulSeksi('Rata-rata penilaian per produk'),
            const SizedBox(height: 12),
            AspectRatio(
              aspectRatio: 1.35,
              child: _BangunDiagram(data: _data, maksNilai: _maksNilai),
            ),
            const SizedBox(height: 28),
            _JudulSeksi('Daftar produk'),
            const SizedBox(height: 8),
            _BangunDaftarBar(data: _data),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Warna.teal,
                  foregroundColor: Colors.white,
                ),
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.beranda),
                icon: const Icon(Icons.home_outlined),
                label: const Text('Kembali ke beranda'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarDatum {
  _BarDatum({
    required this.produk,
    required this.label,
    required this.nilai,
    required this.warna,
  });

  final ProdukContoh produk;
  final String label;
  final double nilai;
  final Color warna;
}

class _BangunDiagram extends StatelessWidget {
  const _BangunDiagram({required this.data, required this.maksNilai});

  final List<_BarDatum> data;
  final double maksNilai;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('Tidak ada data penilaian'));
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maksNilai,
        minY: 0,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => Warna.tealTua,
            tooltipMargin: 4,
            getTooltipItem: (d, _, _, _) {
              final idx = d.x.toInt();
              final barData = data[idx];
              return BarTooltipItem(
                '${barData.label}\n${barData.nilai.toStringAsFixed(2)} / 5',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              );
            },
          ),
          touchCallback: (event, _) {
            final idxInt = 0;
            if (idxInt >= 0 && idxInt < data.length) {
              _tampilkanModeNilai(context, data[idxInt], () {
                final nilaiBaru = _bacaNilaiDialog(context);
                if (nilaiBaru == null) return;
                context.read<PenilaianProduk>().tambahPenilaian(
                  data[idxInt].produk,
                  nilaiBaru,
                );
              });
            }
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              getTitlesWidget: (nilai, meta) {
                final idx = nilai.toInt();
                if (idx >= 0 && idx < data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      data[idx].label,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Warna.tealTua,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              getTitlesWidget: (nilai, _) {
                if (nilai.round() >= 0) {
                  return Text(
                    nilai.toInt().toString(),
                    style: const TextStyle(fontSize: 12, color: Warna.tealTua),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (nilai) {
            return FlLine(
              color: Warna.teal.withValues(alpha: 0.18),
              strokeWidth: 1,
            );
          },
        ),
        barGroups: List.generate(data.length, (idx) {
          return BarChartGroupData(
            x: idx,
            barRods: [
              BarChartRodData(
                toY: data[idx].nilai,
                color: data[idx].warna,
                width: 18,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(6),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  double? _bacaNilaiDialog(BuildContext context) {
    final controller = TextEditingController();
    double? pilihan;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nilai produk ini'),
        content: SizedBox(
          width: 280,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Nilai (1-5)'),
                onChanged: (v) {
                  final parsed = double.tryParse(v);
                  if (parsed != null && parsed >= 1 && parsed <= 5) {
                    pilihan = parsed;
                  } else {
                    pilihan = null;
                  }
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Nilai saat ini: ${data.first.nilai.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Warna.teal),
            onPressed: pilihan == null
                ? null
                : () {
                    Navigator.pop(ctx, pilihan);
                  },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    return pilihan;
  }

  void _tampilkanModeNilai(
    BuildContext context,
    _BarDatum bar,
    VoidCallback onSimpan,
  ) {
    final controller = TextEditingController();
    double? nilaiBaru;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Nilai ulang: ${bar.label}'),
        content: SizedBox(
          width: 280,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Nilai (1-5)'),
            onChanged: (v) {
              final parsed = double.tryParse(v);
              if (parsed != null && parsed >= 1 && parsed <= 5) {
                nilaiBaru = parsed;
              } else {
                nilaiBaru = null;
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Warna.teal),
            onPressed: nilaiBaru == null
                ? null
                : () {
                    Navigator.pop(ctx);
                    onSimpan();
                  },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}

class _BangunDaftarBar extends StatelessWidget {
  const _BangunDaftarBar({required this.data});

  final List<_BarDatum> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    return Column(
      children: data.map((d) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 150,
                child: Text(
                  d.label,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 18,
                      decoration: BoxDecoration(
                        color: Warna.teal.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: (d.nilai / 5).clamp(0.0, 1.0),
                      child: Container(
                        height: 18,
                        decoration: BoxDecoration(
                          color: d.warna,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                d.nilai.toStringAsFixed(2),
                style: const TextStyle(
                  color: Warna.teal,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _JudulSeksi extends StatelessWidget {
  const _JudulSeksi(this.judul);

  final String judul;

  @override
  Widget build(BuildContext context) {
    return Text(
      judul,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
    );
  }
}
