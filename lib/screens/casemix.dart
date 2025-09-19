import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CasemixPage extends StatelessWidget {
  const CasemixPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Casemix'),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column( // Menggunakan Column untuk menumpuk baris menu secara vertikal
          children: [
            Row( // Baris pertama
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMenuItem(context, MdiIcons.accountMultipleCheck, 'Koding RM'),
                _buildMenuItem(context, MdiIcons.cubeSend, 'Eclaim BPJS'),
              ],
            ),
            const SizedBox(height: 40), // Jarak antar baris
            Row( // Baris kedua
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMenuItem(context, MdiIcons.cubeSend, 'Eclaim Jamkesda'),
                _buildMenuItem(context, MdiIcons.contentSaveCheckOutline, 'Umbal BPJS'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String label) {
    return InkWell(
      onTap: () {
        // Logika untuk navigasi ke halaman lain
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anda menekan $label')),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.grey[600]),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}