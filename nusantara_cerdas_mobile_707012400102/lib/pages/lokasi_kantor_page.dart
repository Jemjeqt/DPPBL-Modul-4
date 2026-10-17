import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../tema_nusantara.dart';

/// Posisi kantor layanan warga.
const _kantor = [
  (LatLng(-6.2088, 106.8456), 'Kantor Walikota Nusantara', 'Jl. Merdeka No. 1'),
  (LatLng(-6.2147, 106.8272), 'Kantor PTSP', 'Jl. Gajah Mada No. 21'),
  (LatLng(-6.1951, 106.8230), 'Dinas Kesehatan Kota', 'Jl. Sudirman No. 45'),
];

/// Halaman lokasi kantor dengan google_maps_flutter + InfoWindow.
class LokasiKantorPage extends StatefulWidget {
  const LokasiKantorPage({super.key});

  @override
  State<LokasiKantorPage> createState() => _LokasiKantorPageState();
}

class _LokasiKantorPageState extends State<LokasiKantorPage> {
  GoogleMapController? _kontroler;

  late final Set<Marker> _penanda = _kantor
      .asMap()
      .entries
      .map(
        (e) => Marker(
          markerId: MarkerId('kantor-${e.key}'),
          position: e.value.$1,
          infoWindow: InfoWindow(
            title: e.value.$2,
            snippet: e.value.$3,
          ),
        ),
      )
      .toSet();

  @override
  void dispose() {
    _kontroler?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('LOKASI KANTOR'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(-6.2065, 106.8340),
                  zoom: 13.2,
                ),
                markers: _penanda,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                onMapCreated: (controller) => _kontroler = controller,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              children: [
                const Text(
                  'KANTOR LAYANAN TERDEKAT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                    color: WarnaNusantara.teksPendamping,
                  ),
                ),
                const SizedBox(height: 8),
                ..._kantor.map(
                  (k) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: WarnaNusantara.garis),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: WarnaNusantara.hijauTua,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                k.$2,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                k.$3,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: WarnaNusantara.teksPendamping,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
