import 'package:flutter/material.dart';

class RegistrasiIGDPage extends StatefulWidget {
  const RegistrasiIGDPage({Key? key}) : super(key: key);

  @override
  State<RegistrasiIGDPage> createState() => _RegistrasiIGDPageState();
}

class _RegistrasiIGDPageState extends State<RegistrasiIGDPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _keluhanController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrasi IGD"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Nama Pasien", _namaController),
              const SizedBox(height: 12),
              _buildTextField("NIK", _nikController, keyboard: TextInputType.number),
              const SizedBox(height: 12),
              _buildTextField("Keluhan Utama", _keluhanController, maxLines: 3),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Registrasi IGD berhasil")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Daftar"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) => value == null || value.isEmpty ? "Wajib diisi" : null,
    );
  }
}
