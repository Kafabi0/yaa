import 'package:flutter/material.dart';
import 'package:inocare/screens/detail_pasien_layanan.dart';

class AdminLayanan extends StatefulWidget {
  const AdminLayanan({super.key});

  @override
  State<AdminLayanan> createState() => _AdminLayananState();
}

class _AdminLayananState extends State<AdminLayanan> {
  String _searchQuery = "";
  String? _statusBillingFilter;

  final TextEditingController _searchController = TextEditingController();

  // Dummy data pasien
  final List<Map<String, dynamic>> _patients = [
    {
      "no": "1",
      "registrasi": "0702250202010011234",
      "spri": "REF12345",
      "tgl": "07-02-2025",
      "rm": "RM123456",
      "nama": "John Doe Test",
      "dpjp": "dr. John Smith",
      "kelas": "VIP",
      "bed": "Gedung Utama / R.301 / Kamar 8 / Bed 1",
      "status": "Sudah datang",
      "statusLayanan": "Selesai",
      "statusBilling": "Lengkap",
    },
    {
      "no": "2",
      "registrasi": "0702250203800791073",
      "spri": "0810010125K000003",
      "tgl": "07-02-2025",
      "rm": "0000000",
      "nama": "PROGRAMMER (TESTING)",
      "dpjp": "dr. Ahmad Angga Lutfi, Sp.An",
      "kelas": "Kelas 3",
      "bed": "Instalasi Rawat Inap Bedah Lt 1 / Bed 29",
      "status": "Sudah datang",
      "statusLayanan": "Proses",
      "statusBilling": "Belum Lengkap",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final pasienList = _patients.where((p) {
      final query = _searchQuery.toLowerCase();
      final billingMatch =
          _statusBillingFilter == null ||
          p["statusBilling"] == _statusBillingFilter;
      return p["nama"].toLowerCase().contains(query) && billingMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Administrasi Layanan"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // 🔍 Search + Filter + Reset
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // 🔍 Search field
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Cari pasien...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),

                // ⬇️ Dropdown filter
                DropdownButton<String>(
                  hint: const Text("Status Billing"),
                  value: _statusBillingFilter,
                  items: ["Lengkap", "Belum Lengkap"]
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _statusBillingFilter = val;
                    });
                  },
                ),
                const SizedBox(width: 8),

                // // 🔄 Reset button
                // IconButton(
                //   icon: const Icon(Icons.refresh, color: Colors.red),
                //   tooltip: "Reset Filter",
                //   onPressed: () {
                //     setState(() {
                //       _searchQuery = "";
                //       _statusBillingFilter = null;
                //       _searchController.clear(); // kosongkan TextField
                //     });
                //   },
                // ),
              ],
            ),
          ),

          // 🏷️ Filter chips
          if (_searchQuery.isNotEmpty || _statusBillingFilter != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 8,
                children: [
                  if (_searchQuery.isNotEmpty)
                    Chip(
                      label: Text('Cari: $_searchQuery'),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () {
                        setState(() {
                          _searchQuery = "";
                          _searchController.clear();
                        });
                      },
                    ),
                  if (_statusBillingFilter != null)
                    Chip(
                      label: Text('Billing: $_statusBillingFilter'),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () {
                        setState(() {
                          _statusBillingFilter = null;
                        });
                      },
                    ),
                ],
              ),
            ),

          // 📋 List pasien
          Expanded(
            child: ListView.builder(
              itemCount: pasienList.length,
              itemBuilder: (context, index) {
                final pasien = pasienList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama & No RM
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              pasien["nama"],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "RM: ${pasien["rm"]}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        Text("No Registrasi: ${pasien["registrasi"]}"),
                        Text("SPRI: ${pasien["spri"]}"),
                        Text("Tanggal: ${pasien["tgl"]}"),
                        Text("DPJP: ${pasien["dpjp"]}"),
                        Text("Kelas: ${pasien["kelas"]}"),
                        Text("Bed: ${pasien["bed"]}"),

                        const Divider(),

                        // Status baris bawah
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatusChip(pasien["status"], Colors.blue),
                            _buildStatusChip(
                              pasien["statusLayanan"],
                              pasien["statusLayanan"] == "Selesai"
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                            _buildStatusChip(
                              pasien["statusBilling"],
                              pasien["statusBilling"] == "Lengkap"
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DetailPasienPage(pasien: pasien),
                                  ),
                                );
                              },
                              child: const Text("Detail"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
