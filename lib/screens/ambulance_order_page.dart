import 'package:flutter/material.dart';
import 'ambulance_tracking_page.dart';
class AmbulanceOrderPage extends StatelessWidget {
  final String orderCode;

  const AmbulanceOrderPage({super.key, required this.orderCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Order Ambulance"),
        backgroundColor: const Color(0xFFFF6B35),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.local_hospital,
                  size: 50,
                  color: Color(0xFFFF6B35),
                ),
                const SizedBox(height: 16),
                Text(
                  "Order Ambulance",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Kode Pemesanan: $orderCode",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                const Text(
                  "Detail Pemesanan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text("📍 Lokasi Jemput: Belum tersedia"),
                const Text("🏥 Tujuan: Belum tersedia"),
                const Text("🕒 Waktu: Belum tersedia"),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => AmbulanceTrackingPage(orderCode: orderCode),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  icon: const Icon(Icons.map),
                  label: const Text(
                    "Lacak Ambulance",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
