import 'package:flutter/material.dart';

class RegistrasiRanapPage extends StatefulWidget {
  const RegistrasiRanapPage({Key? key}) : super(key: key);

  @override
  State<RegistrasiRanapPage> createState() => _RegistrasiRanapPageState();
}

class _RegistrasiRanapPageState extends State<RegistrasiRanapPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  String? _selectedKelas;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrasi Ranap"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Nama Pasien", _namaController),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Pilih Kelas",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: "VIP", child: Text("VIP")),
                  DropdownMenuItem(value: "Kelas I", child: Text("Kelas I")),
                  DropdownMenuItem(value: "Kelas II", child: Text("Kelas II")),
                  DropdownMenuItem(value: "Kelas III", child: Text("Kelas III")),
                ],
                value: _selectedKelas,
                onChanged: (val) {
                  setState(() {
                    _selectedKelas = val;
                  });
                },
                validator: (value) => value == null ? "Wajib pilih kelas" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Registrasi Ranap ($_selectedKelas) berhasil")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text("Daftar"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) => value == null || value.isEmpty ? "Wajib diisi" : null,
    );
  }
}
