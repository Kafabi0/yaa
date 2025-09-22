import 'package:flutter/material.dart';

class BillingDetailPage extends StatelessWidget {
  final Map<String, dynamic> bill;

  const BillingDetailPage({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Tagihan"),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Invoice: ${bill["invoice"]}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Layanan: ${bill["service"]}"),
                Text("Tanggal: ${bill["date"]} • ${bill["time"]}"),
                const SizedBox(height: 8),
                Text("Deskripsi: ${bill["description"]}"),
                const SizedBox(height: 8),
                Text("Jumlah Tagihan: ${bill["amount"]}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text("Status: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: bill["isPaid"]
                            ? Colors.green
                            : bill["isLate"]
                                ? Colors.red
                                : const Color(0xFF1976D2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        bill["isPaid"]
                            ? "Lunas"
                            : bill["isLate"]
                                ? "Terlambat"
                                : "Belum Lunas",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
