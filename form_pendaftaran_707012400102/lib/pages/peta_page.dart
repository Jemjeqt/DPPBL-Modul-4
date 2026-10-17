import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PetaPage extends StatefulWidget {
  const PetaPage({super.key});
  @override
  State<PetaPage> createState() => _PetaPageState();
}

class _PetaPageState extends State<PetaPage> {
  static const LatLng lokasiKampus = LatLng(-6.914744, 107.609810);

  final Set<Marker> markers = {
    const Marker(
      markerId: MarkerId('gedung_kegiatan'),
      position: lokasiKampus,
      infoWindow: InfoWindow(title: 'Gedung Seminar Kampus'),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lokasi Kegiatan')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: lokasiKampus,
          zoom: 16,
        ),
        markers: markers,
      ),
    );
  }
}
