import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/pendaftar_model.dart';

class FormulirPage extends StatefulWidget {
  const FormulirPage({super.key});
  @override
  State<FormulirPage> createState() => _FormulirPageState();
}

class _FormulirPageState extends State<FormulirPage> {
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  bool setujuSyarat = false;
  String? sesiTerpilih;
  bool sedangMengirim = false;

  bool get formLengkap =>
      namaController.text.isNotEmpty &&
      emailController.text.isNotEmpty &&
      setujuSyarat &&
      sesiTerpilih != null;

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> kirimFormulir() async {
    setState(() => sedangMengirim = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    context.read<PendaftarModel>().tambah(
      Pendaftar(
        nama: namaController.text,
        email: emailController.text,
        sesi: sesiTerpilih!,
      ),
    );
    setState(() => sedangMengirim = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pendaftaran berhasil dikirim')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulir Pendaftaran')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            namaController.clear();
            emailController.clear();
            setujuSyarat = false;
            sesiTerpilih = null;
          });
        },
        tooltip: 'Bersihkan formulir',
        child: const Icon(Icons.refresh),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/detail-kegiatan'),
              onLongPress: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kegiatan: Seminar Teknologi Mobile')),
                );
              },
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.event),
                  title: const Text('Seminar Teknologi Mobile'),
                  subtitle: const Text('Ketuk untuk detail, tahan untuk info singkat'),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            CheckboxListTile(
              value: setujuSyarat,
              title: const Text('Saya menyetujui syarat dan ketentuan kegiatan'),
              onChanged: (nilai) {
                setState(() {
                  setujuSyarat = nilai ?? false;
                });
              },
            ),
            Column(
              children: ['Pagi', 'Siang', 'Sore'].map((sesi) {
                return RadioListTile<String>(
                  title: Text('Sesi $sesi'),
                  value: sesi,
                  groupValue: sesiTerpilih,
                  onChanged: (nilai) {
                    setState(() {
                      sesiTerpilih = nilai;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: (formLengkap && !sedangMengirim) ? kirimFormulir : null,
              child: sedangMengirim
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Kirim Pendaftaran'),
            ),
          ],
        ),
      ),
    );
  }
}