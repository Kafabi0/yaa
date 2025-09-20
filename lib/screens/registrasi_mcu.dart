import 'package:flutter/material.dart';

class RegistrasiMCUPage extends StatefulWidget {
  const RegistrasiMCUPage({Key? key}) : super(key: key);

  @override
  State<RegistrasiMCUPage> createState() => _RegistrasiMCUPageState();
}

class _RegistrasiMCUPageState extends State<RegistrasiMCUPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  String? _selectedPaket;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrasi MCU"),
        backgroundColor: const Color(0xFFFF6B35),
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
                  labelText: "Pilih Paket MCU",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: const [
                  DropdownMenuItem(value: "Basic", child: Text("MCU Basic")),
                  DropdownMenuItem(value: "Lengkap", child: Text("MCU Lengkap")),
                  DropdownMenuItem(value: "Premium", child: Text("MCU Premium")),
                ],
                value: _selectedPaket,
                onChanged: (val) {
                  setState(() {
                    _selectedPaket = val;
                  });
                },
                validator: (value) => value == null ? "Wajib pilih paket" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Registrasi MCU ($_selectedPaket) berhasil")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B35)),
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
