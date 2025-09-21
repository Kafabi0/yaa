import 'package:flutter/material.dart';

class BillingPage extends StatelessWidget {
  final String patientName;
  final Map<String, String> registrations;

  const BillingPage({
    super.key, // pakai super.key biar lebih singkat
    required this.patientName,
    required this.registrations,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> bills = [
      {"item": "Registrasi IGD", "price": 150000},
      {"item": "Pemeriksaan Dokter", "price": 200000},
      {"item": "Obat-obatan", "price": 350000},
      {"item": "Laboratorium", "price": 250000},
      {"item": "Radiologi", "price": 400000},
    ];

    // amanin tipe data int
    final int total = bills.fold<int>(
      0,
      (sum, item) => sum + ((item["price"] as int?) ?? 0),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tagihan Pasien"),
        backgroundColor: Colors.blue[700],
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pasien: $patientName",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: bills.length,
                itemBuilder: (context, index) {
                  final bill = bills[index];
                  final String itemName = bill["item"].toString();
                  final int price = (bill["price"] as int?) ?? 0;

                  return Card(
                    child: ListTile(
                      title: Text(itemName),
                      trailing: Text("Rp $price"),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Total: Rp $total",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
