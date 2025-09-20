import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrasiRajalPage extends StatefulWidget {
  const RegistrasiRajalPage({Key? key}) : super(key: key);

  @override
  State<RegistrasiRajalPage> createState() => _RegistrasiRajalPageState();
}

class _RegistrasiRajalPageState extends State<RegistrasiRajalPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  Future<void> _simpanData(String name, String nik, String alamat, String nomor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('registeredName', name);
    await prefs.setString('registeredNIK', nik);
    await prefs.setString('registeredAlamat', alamat);
    await prefs.setString('nomorAntrian_RAJAL', nomor);
  }

  void _submit() async {
    String name = _nameController.text.trim();
    String nik = _nikController.text.trim();
    String alamat = _alamatController.text.trim();

    if (name.isEmpty || nik.isEmpty || alamat.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap isi semua data")),
      );
      return;
    }

    // generate nomor antrian (sementara random)
    String nomor = "B${DateTime.now().millisecondsSinceEpoch % 100}";

    // simpan semua ke SharedPreferences
    await _simpanData(name, nik, alamat, nomor);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Registrasi berhasil! Nomor antrian Anda: $nomor")),
    );

    Navigator.pop(context); // kembali ke HomePage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrasi Rajal")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Nama")),
            TextField(controller: _nikController, decoration: const InputDecoration(labelText: "NIK")),
            TextField(controller: _alamatController, decoration: const InputDecoration(labelText: "Alamat")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _submit, child: const Text("Registrasi"))
          ],
        ),
      ),
    );
  }
}
