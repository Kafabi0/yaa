import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QueueTicketPage extends StatelessWidget {
  final String jenis;
  final String nomorAntrian;

  const QueueTicketPage({super.key, required this.jenis, required this.nomorAntrian});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tiket Antrian $jenis'),
        backgroundColor: Color(0xFFFF6B35),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Nomor Antrian Anda',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              nomorAntrian,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 40),
            // QrImage versi terbaru
            QrImageView(
              data: '$jenis-$nomorAntrian', // wajib positional / named sesuai versi terbaru
              size: 200,
            ),
            const SizedBox(height: 40),
            const Text(
              'Tunjukkan QR ini saat verifikasi di rumah sakit.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
