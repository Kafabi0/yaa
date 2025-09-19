import 'package:flutter/material.dart';
import 'package:inocare/screens/orderambulance.dart';
import 'package:intl/intl.dart';

// ==========================
// Halaman Detail Pasien
// ==========================
class DetailPasienPage extends StatefulWidget {
  final Map<String, dynamic> pasien;
  const DetailPasienPage({super.key, required this.pasien});

  @override
  State<DetailPasienPage> createState() => _DetailPasienPageState();
}

class _DetailPasienPageState extends State<DetailPasienPage> {
  String _standarPelayanan = "KRIS";
  String _kelas = "Eksekutif";
  String _caraBayar = "Umum";

  final TextEditingController _unitLayananCtrl = TextEditingController();
  final TextEditingController _dpjpCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pasien"),
        backgroundColor: Colors.blue,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),

      // 👉 Drawer kanan
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menu Admin",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            _buildDrawerItem(Icons.info, "Info Registrasi", () {
              Navigator.pop(context);
            }),
            _buildDrawerItem(Icons.bed, "Update Bed", () {}),
            _buildDrawerItem(Icons.meeting_room, "Mutasi Ruangan", () {}),
            _buildDrawerItem(Icons.receipt_long, "Billing", () {}),
            _buildDrawerItem(Icons.assignment_turned_in, "Status Layanan", () {}),
            _buildDrawerItem(Icons.local_hospital, "Order Ambulance", () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const OrderAmbulancePage(),
                ),
              );
            }),
            _buildDrawerItem(Icons.done_all, "Selesai Layanan", () {}),
          ],
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 800;

          return isWide
              ? Row(
                  children: [
                    Expanded(child: _buildDataPasienCard()),
                    Expanded(child: _buildUpdateForm()),
                  ],
                )
              : ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    _buildDataPasienCard(),
                    const SizedBox(height: 16),
                    _buildUpdateForm(),
                  ],
                );
        },
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDataPasienCard() {
    final pasien = widget.pasien;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow("Instalasi", "Rawat Inap"),
            _buildInfoRow("Unit Layanan", pasien["unitLayanan"] ?? "-"),
            _buildInfoRow("No. Registrasi", pasien["registrasi"] ?? "-"),
            _buildInfoRow("Tgl. Registrasi", pasien["tgl"] ?? "-"),
            _buildInfoRow("No. SPRI", pasien["spri"] ?? "-"),
            _buildInfoRow("No. RM", pasien["rm"] ?? "-"),
            _buildInfoRow("Nama Pasien", pasien["nama"] ?? "-"),
            _buildInfoRow("Jenis Kelamin", pasien["gender"] ?? "-"),
            _buildInfoRow("Tanggal Lahir", pasien["dob"] ?? "-"),
            _buildInfoRow("Umur", pasien["umur"] ?? "-"),
            _buildInfoRow("Alamat Identitas", pasien["alamat"] ?? "-"),
            _buildInfoRow("No. Telp", pasien["telp"] ?? "-"),
            _buildInfoRow("Standar Pelayanan", _standarPelayanan),
            _buildInfoRow("Kelas", _kelas),
            _buildInfoRow("Cara Bayar", _caraBayar),
            _buildInfoRow("Dokter DPJP", pasien["dpjp"] ?? "-"),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateForm() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Memperbaharui Data Registrasi",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue)),
            const SizedBox(height: 16),

            // Standar Pelayanan
            const Text("Standar Pelayanan *"),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    value: "KRIS",
                    groupValue: _standarPelayanan,
                    title: const Text("KRIS"),
                    onChanged: (val) =>
                        setState(() => _standarPelayanan = val!),
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    value: "NON-KRIS",
                    groupValue: _standarPelayanan,
                    title: const Text("NON-KRIS"),
                    onChanged: (val) =>
                        setState(() => _standarPelayanan = val!),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Kelas
            const Text("Kelas *"),
            Wrap(
              spacing: 8,
              children: ["Eksekutif", "Non Standar", "Standar", "Kelas 2 & 3"]
                  .map((kelas) => ChoiceChip(
                        label: Text(kelas),
                        selected: _kelas == kelas,
                        onSelected: (_) => setState(() => _kelas = kelas),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 16),

            // Cara Bayar
            const Text("Cara Bayar *"),
            Wrap(
              spacing: 8,
              children: ["Umum", "BPJS", "Jaminan Lainnya"]
                  .map((bayar) => ChoiceChip(
                        label: Text(bayar),
                        selected: _caraBayar == bayar,
                        onSelected: (_) => setState(() => _caraBayar = bayar),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 16),

            // Unit Layanan
            TextField(
              controller: _unitLayananCtrl,
              decoration: const InputDecoration(
                labelText: "Unit Layanan",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Dokter DPJP
            TextField(
              controller: _dpjpCtrl,
              decoration: const InputDecoration(
                labelText: "Dokter DPJP",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Simpan Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Data berhasil disimpan")),
                  );
                },
                child: const Text("Simpan"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: Text(label)),
          const Text(" : "),
          Expanded(
            flex: 5,
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ==========================
// Halaman Order Ambulance
// ==========================
// class OrderAmbulancePage extends StatefulWidget {
//   const OrderAmbulancePage({super.key});

//   @override
//   State<OrderAmbulancePage> createState() => _OrderAmbulancePageState();
// }

// class _OrderAmbulancePageState extends State<OrderAmbulancePage> {
//   DateTime? _tanggalAntar;
//   TimeOfDay? _jamAntar;
//   String _tipeMobil = "Ambulans";
//   String _jasaPendamping = "Ya";
//   final TextEditingController _alamatCtrl = TextEditingController();
//   final TextEditingController _titikCtrl = TextEditingController();

//   // Contoh data tabel item
//   final List<Map<String, String>> _items = [
//     {
//       "nama": "Penggunaan Ambulance - Dalam Kota Bandar Lampung - Ambulans",
//       "kategori": "Dalam Kota Bandar Lampung"
//     },
//     {
//       "nama": "Penggunaan Ambulance - Kabupaten Pesawaran - Jasa Dokter",
//       "kategori": "Kabupaten Pesawaran"
//     },
//     {
//       "nama": "Penggunaan Ambulance - Kabupaten Pesawaran - Jasa Perawat",
//       "kategori": "Kabupaten Pesawaran"
//     },
//   ];

//   // Contoh data tabel pendamping
//   final List<Map<String, String>> _pendamping = [
//     {"nama": "Ersa Junika Yenty", "tipe": "Perawat"},
//     {"nama": "dr. Zandika Hardy Harahap", "tipe": "Dokter"},
//   ];

//   String get _nomorOrder {
//     final now = DateTime.now();
//     return DateFormat("yyyyMMddHHmmss").format(now);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Order Ambulance"),
//         backgroundColor: Colors.blue,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildForm(),
//             const SizedBox(height: 20),
//             Text("Nomor Order Ambulance:",
//                 style: Theme.of(context).textTheme.titleMedium),
//             Text(_nomorOrder,
//                 style: const TextStyle(
//                     fontWeight: FontWeight.bold, color: Colors.blue)),
//             const SizedBox(height: 20),
//             Text("Daftar Item", style: Theme.of(context).textTheme.titleMedium),
//             _buildItemsTable(),
//             const SizedBox(height: 20),
//             Text("Daftar Pendamping",
//                 style: Theme.of(context).textTheme.titleMedium),
//             _buildPendampingTable(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildForm() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildFormRow(
//           "Tanggal Antar*",
//           TextButton(
//             onPressed: () async {
//               final picked = await showDatePicker(
//                 context: context,
//                 initialDate: DateTime.now(),
//                 firstDate: DateTime(2020),
//                 lastDate: DateTime(2100),
//               );
//               if (picked != null) {
//                 setState(() => _tanggalAntar = picked);
//               }
//             },
//             child: Text(_tanggalAntar == null
//                 ? "Pilih Tanggal"
//                 : DateFormat("yyyy-MM-dd").format(_tanggalAntar!)),
//           ),
//         ),
//         _buildFormRow(
//           "Jam*",
//           TextButton(
//             onPressed: () async {
//               final picked =
//                   await showTimePicker(context: context, initialTime: TimeOfDay.now());
//               if (picked != null) {
//                 setState(() => _jamAntar = picked);
//               }
//             },
//             child: Text(_jamAntar == null
//                 ? "Pilih Jam"
//                 : _jamAntar!.format(context)),
//           ),
//         ),
//         _buildFormRow(
//           "Tipe Mobil*",
//           Row(
//             children: [
//               Radio(
//                 value: "Ambulans",
//                 groupValue: _tipeMobil,
//                 onChanged: (val) => setState(() => _tipeMobil = val!),
//               ),
//               const Text("Ambulans"),
//               Radio(
//                 value: "Jenazah",
//                 groupValue: _tipeMobil,
//                 onChanged: (val) => setState(() => _tipeMobil = val!),
//               ),
//               const Text("Jenazah"),
//             ],
//           ),
//         ),
//         _buildFormRow(
//           "Jasa Pendamping*",
//           Row(
//             children: [
//               Radio(
//                 value: "Ya",
//                 groupValue: _jasaPendamping,
//                 onChanged: (val) => setState(() => _jasaPendamping = val!),
//               ),
//               const Text("Ya"),
//               Radio(
//                 value: "Tidak",
//                 groupValue: _jasaPendamping,
//                 onChanged: (val) => setState(() => _jasaPendamping = val!),
//               ),
//               const Text("Tidak"),
//             ],
//           ),
//         ),
//         _buildFormRow(
//           "Alamat Antar",
//           TextField(
//             controller: _alamatCtrl,
//             decoration: const InputDecoration(
//               hintText: "Masukkan alamat",
//               border: OutlineInputBorder(),
//             ),
//           ),
//         ),
//         _buildFormRow(
//           "Titik Penjemputan",
//           TextField(
//             controller: _titikCtrl,
//             decoration: const InputDecoration(
//               hintText: "Masukkan titik penjemputan",
//               border: OutlineInputBorder(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildFormRow(String label, Widget field) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(width: 180, child: Text(label)),
//           const Text(": "),
//           Expanded(child: field),
//         ],
//       ),
//     );
//   }

//   Widget _buildItemsTable() {
//     return DataTable(
//       columns: const [
//         DataColumn(label: Text("No")),
//         DataColumn(label: Text("Nama Item")),
//         DataColumn(label: Text("Kategori")),
//       ],
//       rows: _items.asMap().entries.map((entry) {
//         final index = entry.key + 1;
//         final item = entry.value;
//         return DataRow(
//           cells: [
//             DataCell(Text(index.toString())),
//             DataCell(Text(item["nama"]!)),
//             DataCell(Text(item["kategori"]!)),
//           ],
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildPendampingTable() {
//     return DataTable(
//       columns: const [
//         DataColumn(label: Text("No")),
//         DataColumn(label: Text("Nama Pendamping")),
//         DataColumn(label: Text("Tipe Pendamping")),
//       ],
//       rows: _pendamping.asMap().entries.map((entry) {
//         final index = entry.key + 1;
//         final p = entry.value;
//         return DataRow(
//           cells: [
//             DataCell(Text(index.toString())),
//             DataCell(Text(p["nama"]!)),
//             DataCell(Text(p["tipe"]!)),
//           ],
//         );
//       }).toList(),
//     );
//   }
// }
