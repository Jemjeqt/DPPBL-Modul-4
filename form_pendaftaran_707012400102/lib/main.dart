import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/pendaftar_model.dart';
import 'navigation/app_routes.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PendaftarModel(),
      child: MaterialApp(
        title: 'Pendaftaran Kegiatan Kampus',
        initialRoute: AppRoutes.beranda,
        routes: AppRoutes.daftarRoute(),
        onGenerateRoute: AppRoutes.bentukRoute,
        onUnknownRoute: AppRoutes.routeTidakDikenal,
      ),
    ),
  );
}
