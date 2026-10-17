/// Katalog layanan statis untuk halaman daftar & rincian layanan.
class Layanan {
  const Layanan({
    required this.nama,
    required this.instansi,
    required this.bidang,
    required this.deskripsi,
  });

  final String nama;
  final String instansi;

  /// Perizinan | Kesehatan | Transportasi
  final String bidang;
  final String deskripsi;
}

class KatalogLayanan {
  static const daftar = <Layanan>[
    // Perizinan
    Layanan(
      nama: 'Izin Usaha Mikro Kecil',
      instansi: 'Dinas Penanaman Modal dan PTSP',
      bidang: 'Perizinan',
      deskripsi:
          'Pendirian dan perizinan usaha mikro, kecil, dan menengah '
          'secara daring dengan estimasi selesai 3 hari kerja.',
    ),
    Layanan(
      nama: 'Izin Mendirikan Bangunan',
      instansi: 'Dinas Pekerjaan Umum dan Penataan Ruang',
      bidang: 'Perizinan',
      deskripsi:
          'Persetujuan bangunan gedung untuk rumah tinggal, ruko, '
          'dan bangunan non-domestik sesuai tata ruang kota.',
    ),
    Layanan(
      nama: 'Izin Keramaian dan Acara',
      instansi: 'Satuan Polisi Pamong Praja',
      bidang: 'Perizinan',
      deskripsi:
          'Penerbitan izin penyelenggaraan keramaian, pesta, dan acara '
          'masyarakat di ruang publik.',
    ),
    // Kesehatan
    Layanan(
      nama: 'Pemeriksaan Kesehatan Gratis',
      instansi: 'Dinas Kesehatan Kota',
      bidang: 'Kesehatan',
      deskripsi:
          'Pemeriksaan kesehatan berkala di puskesmas mitra tanpa '
          'biaya bagi warga terdaftar.',
    ),
    Layanan(
      nama: 'Imunisasi dan Vaksinasi Anak',
      instansi: 'Dinas Kesehatan Kota',
      bidang: 'Kesehatan',
      deskripsi:
          'Jadwal imunisasi rutin dan vaksinasi tambahan untuk anak '
          'usia 0–12 tahun.',
    ),
    Layanan(
      nama: 'Administrasi BPJS Kesehatan',
      instansi: 'Dinas Kesehatan Kota',
      bidang: 'Kesehatan',
      deskripsi:
          'Pendaftaran, perubahan data, dan penambahan anggota keluarga '
          'BPJS Kesehatan.',
    ),
    // Transportasi
    Layanan(
      nama: 'Keringanan Tarif Transportasi',
      instansi: 'Dinas Perhubungan',
      bidang: 'Transportasi',
      deskripsi:
          'Pengajuan keringanan tarif transportasi umum bagi lansia, '
          'pelajar, dan penyandang disabilitas.',
    ),
    Layanan(
      nama: 'Uji Kelaikalan Kendaraan',
      instansi: 'Dinas Perhubungan',
      bidang: 'Transportasi',
      deskripsi:
          'Penjadwalan uji KIR kendaraan niaga dan angkutan umum '
          'di unit uji terdekat.',
    ),
    Layanan(
      nama: 'Perizinan Parkir dan Badan Usaha',
      instansi: 'Dinas Perhubungan',
      bidang: 'Transportasi',
      deskripsi:
          'Penerbitan izin penyelenggaraan parkir serta izin badan '
          'usaha angkutan barang dan penumpang.',
    ),
  ];

  static List<Layanan> perBidang(String bidang) =>
      daftar.where((l) => l.bidang == bidang).toList();

  static const bidangTersedia = ['Perizinan', 'Kesehatan', 'Transportasi'];
}
