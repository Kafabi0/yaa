import 'package:flutter/material.dart';

class HasilRadiologiPage extends StatelessWidget {
  final String patientName;
  final Map<String, String> registrations;

  const HasilRadiologiPage({
    Key? key,
    required this.patientName,
    required this.registrations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Radiologi"),
        backgroundColor: Colors.blue[700],
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientInfo(),
            const SizedBox(height: 20),
            _buildRegistrations(),
            const SizedBox(height: 20),
            _buildRadiologyResults(context),
            const SizedBox(height: 20),
            _buildDoctorConclusion(),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blue[100],
              child: const Icon(Icons.person, color: Colors.blue, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                patientName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrations() {
    if (registrations.isEmpty) {
      return const Center(
        child: Text(
          "Tidak ada data antrian radiologi",
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: registrations.entries.map((entry) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: ListTile(
            leading: Icon(Icons.local_hospital, color: Colors.blue[700]),
            title: Text(
              entry.key,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Nomor Antrian: ${entry.value}"),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRadiologyResults(BuildContext context) {
    final results = [
      {
        "type": "X-Ray Dada",
        "finding": "Tidak ditemukan kelainan signifikan",
        "image":
            "https://upload.wikimedia.org/wikipedia/commons/0/09/Chest_Xray_PA_3-8-2010.png"
      },
      {
        "type": "CT-Scan Kepala",
        "finding": "Tidak ada perdarahan intrakranial",
        "image":
            "https://upload.wikimedia.org/wikipedia/commons/0/07/CT_of_head_showing_cerebral_infarction.png"
      },
      {
        "type": "MRI Lutut",
        "finding": "Ligamen anterior tampak normal",
        "image":
            "https://upload.wikimedia.org/wikipedia/commons/6/60/MRI_knee.jpg"
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Hasil Pemeriksaan",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...results.map((res) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.image, color: Colors.deepPurple),
              title: Text(res["type"]!),
              subtitle: Text(res["finding"]!),
              trailing: const Icon(Icons.zoom_in, color: Colors.grey),
              onTap: () {
                _showImagePreview(context, res["type"]!, res["image"]!);
              },
            ),
          );
        }).toList(),
      ],
    );
  }

  void _showImagePreview(BuildContext context, String title, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              InteractiveViewer(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDoctorConclusion() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Kesimpulan Dokter",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Tidak ditemukan kelainan mayor pada hasil radiologi pasien. "
              "Pasien disarankan untuk kontrol rutin dan melanjutkan terapi sesuai anjuran dokter.",
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
