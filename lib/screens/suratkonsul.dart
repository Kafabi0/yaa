import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ConsultationLetterPage extends StatelessWidget {
  final String nomorAntrian;

  const ConsultationLetterPage({super.key, required this.nomorAntrian});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Surat Konsultasi",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF047857),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header rumah sakit
              Center(
                child: Column(
                  children: const [
                    Icon(Icons.local_hospital, color: Colors.teal, size: 40),
                    SizedBox(height: 8),
                    Text(
                      "RUMAH SAKIT SEHAT SELALU",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Jl. Contoh Sehat No. 123, Jakarta",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Divider(height: 32, thickness: 1),

              // Judul surat
              Center(
                child: Text(
                  "SURAT KONSULTASI",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[700],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Isi surat
              Text(
                "Nomor Antrian: $nomorAntrian",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Dengan ini kami menyatakan bahwa pasien dengan nomor antrian di atas "
                "dapat melakukan konsultasi medis dengan dokter yang telah ditentukan. "
                "Surat ini berlaku hanya pada hari kunjungan sesuai jadwal yang telah diberikan.",
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 16),
              const Text(
                "Harap membawa surat ini dan menunjukkan QR code validasi kepada petugas rumah sakit.",
                style: TextStyle(fontSize: 14, height: 1.5),
              ),

              const SizedBox(height: 32),

              // Tanda tangan dokter
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text("Jakarta, 22 September 2025"),
                    SizedBox(height: 48),
                    Text(
                      "Dr. Andi Wijaya",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("Dokter Konsultan"),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // QR Code validasi
              Center(
                child: Column(
                  children: [
                    const Text(
                      "QR Validasi Surat",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    QrImageView(
                      data: "KONSULTASI-$nomorAntrian",
                      size: 180,
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF047857),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
