import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ResepDokterPage extends StatelessWidget {
  const ResepDokterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.orange),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Resep Dokter",
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // QR Code
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.orange,
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                "assets/qr.png", // ganti dengan asset qr Anda
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Tunjukan QR ini diLoket",
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),

            const SizedBox(height: 16),

            // Informasi Pasien
            _buildCard(
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Informasi Pasien",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 8),
                  Text("nama pasien"),
                  Text("nik"),
                  Text("umur"),
                  Text("no. rm"),
                  Text("unit / poli"),
                  Text("dokter"),
                  Text("tanggal resep"),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Detail Resep
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Detail Resep",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            _buildCard(
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nama Obat",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text("500mg"),
                  SizedBox(height: 4),
                  Text("Aturan : 3x sehari, sesudah makan"),
                  Text("Lama : 5 hari"),
                  Text("Catatan : Jangan lupa diminum ya, Lekas Membaik"),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _buildCard(
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nama Obat",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text("500mg"),
                  SizedBox(height: 4),
                  Text("Aturan : 2x sehari, sesudah makan"),
                  Text("Lama : 7 hari"),
                  Text("Catatan : Jangan lupa diminum ya, Lekas Membaik"),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Status Resep
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Status Resep",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  LinearPercentIndicator(
                    lineHeight: 12,
                    percent: 0.75,
                    progressColor: Colors.orange,
                    backgroundColor: Colors.grey[300],
                    barRadius: const Radius.circular(8),
                  ),
                  const SizedBox(height: 4),
                  const Center(
                    child: Text(
                      "Resep Sedang diproses oleh farmasi",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Total Obat & Estimasi
            _buildCard(
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total Obat"),
                        Text("2"),
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Estimasi Biaya"),
                        Text("Rp.20,000"),
                      ]),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tombol Cetak
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.orange),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              onPressed: () {
                // Aksi cetak
              },
              child: const Text(
                "Cetak",
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
