import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/pendaftar_model.dart';

class StatistikPage extends StatelessWidget {
  const StatistikPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<PendaftarModel>();

    final jumlahPagi = model.jumlahSesi('Pagi');
    final jumlahSiang = model.jumlahSesi('Siang');
    final jumlahSore = model.jumlahSesi('Sore');

    return Scaffold(
      appBar: AppBar(title: const Text('Statistik Pendaftar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BarChart(
          BarChartData(
            barGroups: [
              BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: jumlahPagi.toDouble())]),
              BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: jumlahSiang.toDouble())]),
              BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: jumlahSore.toDouble())]),
            ],
          ),
        ),
      ),
    );
  }
}