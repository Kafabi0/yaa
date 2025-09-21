import 'package:flutter/material.dart';

class HasilLabPage extends StatelessWidget {
  final String patientName;
  final Map<String, String> registrations;

  const HasilLabPage({
    Key? key,
    required this.patientName,
    required this.registrations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final labResults = [
      {"test": "Hemoglobin", "result": "13.5 g/dL", "normal": "13 - 17 g/dL"},
      {"test": "Leukosit", "result": "7500 /µL", "normal": "4000 - 11000 /µL"},
      {"test": "Trombosit", "result": "250000 /µL", "normal": "150000 - 400000 /µL"},
      {"test": "Glukosa Darah", "result": "95 mg/dL", "normal": "70 - 110 mg/dL"},
      {"test": "Kolesterol Total", "result": "180 mg/dL", "normal": "< 200 mg/dL"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Laboratorium"),
        backgroundColor: Colors.blue[700],
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: labResults.map((res) {
            return Card(
              child: ListTile(
                leading: const Icon(Icons.biotech, color: Colors.purple),
                title: Text(res["test"]!),
                subtitle: Text("Hasil: ${res["result"]}\nNormal: ${res["normal"]}"),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
