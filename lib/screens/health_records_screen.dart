import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HealthRecordsScreen extends StatelessWidget {
  const HealthRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Records"),
        backgroundColor: const Color(0xFF0D6EFD),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/dokter/doctor55.png'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Dokter",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Female, aged 20",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Health Reports Section
            const Text(
              "Health Reports",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            const Text(
              "Access your readily available health reports from your recent health consultation",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Column(
                children: [
                  _buildListItem(Icons.home_outlined, "Clinic Visits"),
                  _buildDivider(),
                  _buildListItem(Icons.local_hospital_outlined, "Hospital Visits"),
                  _buildDivider(),
                  _buildListItem(Icons.medical_services_outlined, "Dental Visits"),
                  _buildDivider(),
                  _buildListItem(Icons.favorite_border, "Health Screening"),
                  _buildDivider(),
                  _buildListItem(Icons.biotech_outlined, "Lab"),
                  _buildDivider(),
                  _buildListItem(Icons.radar_outlined, "Radiology"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Health Records Section
            const Text(
              "Health Records",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            const Text(
              "View your health data collected from your clinical consultation",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Column(
                children: [
                  _buildListItem(Icons.handshake_outlined, "Allergies and Intolerances"),
                  _buildDivider(),
                  _buildListItem(FontAwesomeIcons.syringe, "Vaccination Records"),
                  _buildDivider(),
                  _buildListItem(Icons.history_outlined, "Past Medical History"),
                  _buildDivider(),
                  _buildListItem(Icons.notes_outlined, "Medications"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildListItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF0D6EFD)),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        // navigasi ke halaman detail
      },
    );
  }

  static Widget _buildDivider() {
    return const Divider(height: 1, indent: 16, endIndent: 16);
  }
}
