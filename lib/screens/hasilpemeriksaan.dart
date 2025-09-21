import 'package:flutter/material.dart';

class HasilPemeriksaanPage extends StatelessWidget {
  final String patientName;
  final Map<String, String> registrations;

  const HasilPemeriksaanPage({
    Key? key,
    required this.patientName,
    required this.registrations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pemeriksaan = [
      {"type": "Tekanan Darah", "result": "120/80 mmHg"},
      {"type": "Denyut Nadi", "result": "78 bpm"},
      {"type": "Suhu Tubuh", "result": "36.8 °C"},
      {"type": "Diagnosa", "result": "Gastritis ringan"},
      {"type": "Terapi", "result": "Obat antasida + pola makan sehat"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Pemeriksaan"),
        backgroundColor: Colors.blue[700],
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: pemeriksaan.map((item) {
            return Card(
              child: ListTile(
                leading: const Icon(Icons.health_and_safety, color: Colors.green),
                title: Text(item["type"]!),
                subtitle: Text(item["result"]!),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
