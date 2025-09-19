import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderAmbulancePage extends StatefulWidget {
  const OrderAmbulancePage({super.key});

  @override
  State<OrderAmbulancePage> createState() => _OrderAmbulancePageState();
}

class _OrderAmbulancePageState extends State<OrderAmbulancePage> {
  DateTime? _tanggalAntar;
  TimeOfDay? _jamAntar;
  String _tipeMobil = "Ambulans";
  String _jasaPendamping = "Ya";
  final TextEditingController _alamatCtrl = TextEditingController();
  final TextEditingController _titikCtrl = TextEditingController();

  final List<Map<String, String>> _items = [
    {
      "nama": "Penggunaan Ambulance - Dalam Kota Bandar Lampung - Ambulans",
      "kategori": "Dalam Kota Bandar Lampung",
    },
    {
      "nama": "Penggunaan Ambulance - Kabupaten Pesawaran - Jasa Dokter",
      "kategori": "Kabupaten Pesawaran",
    },
    {
      "nama": "Penggunaan Ambulance - Kabupaten Pesawaran - Jasa Perawat",
      "kategori": "Kabupaten Pesawaran",
    },
  ];

  final List<Map<String, String>> _pendamping = [
    {"nama": "Ersa Junika Yenty", "tipe": "Perawat"},
    {"nama": "dr. Zandika Hardy Harahap", "tipe": "Dokter"},
  ];

  String get _nomorOrder {
    final now = DateTime.now();
    return DateFormat("yyyyMMddHHmmss").format(now);
  }

  @override
  void initState() {
    super.initState();
    _tanggalAntar = DateTime.now();
    _jamAntar = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double baseFontSize = screenWidth < 400 ? 13 : 15;
    final double titleFontSize = screenWidth < 400 ? 15 : 18;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Ambulance"),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Form Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildForm(baseFontSize),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Nomor Order
            Card(
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nomor Order Ambulance:",
                        style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(_nomorOrder,
                        style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Daftar Item
            Text("Daftar Item",
                style: TextStyle(
                    fontSize: titleFontSize, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildItemsTable(baseFontSize),

            const SizedBox(height: 20),

            // 🔹 Daftar Pendamping
            Text("Daftar Pendamping",
                style: TextStyle(
                    fontSize: titleFontSize, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildPendampingTable(baseFontSize),

            const SizedBox(height: 30),

            // 🔹 Tombol Submit
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton.icon(
            //     icon: const Icon(Icons.check_circle_outline),
            //     label: const Text("Kirim Order"),
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.blue.shade700,
            //       foregroundColor: Colors.white,
            //       padding: const EdgeInsets.symmetric(vertical: 14),
            //       textStyle: const TextStyle(
            //           fontSize: 16, fontWeight: FontWeight.bold),
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(12)),
            //     ),
            //     onPressed: () {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         const SnackBar(content: Text("Order berhasil dikirim!")),
            //       );
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  // 🔹 Form
  Widget _buildForm(double fontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormRow(
          "Tanggal Antar",
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tanggal dapat dipilih",
                  style: TextStyle(fontSize: 11, color: Colors.grey)),
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  DateFormat("yyyy-MM-dd").format(_tanggalAntar!),
                  style: TextStyle(fontSize: fontSize),
                ),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _tanggalAntar!,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _tanggalAntar = picked);
                },
              ),
            ],
          ),
        ),

        _buildFormRow(
          "Jam",
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Jam dapat dipilih",
                  style: TextStyle(fontSize: 11, color: Colors.grey)),
              OutlinedButton.icon(
                icon: const Icon(Icons.access_time),
                label: Text(
                  _jamAntar!.format(context),
                  style: TextStyle(fontSize: fontSize),
                ),
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _jamAntar!,
                  );
                  if (picked != null) {
                    final now = TimeOfDay.now();
                    if (DateUtils.isSameDay(_tanggalAntar, DateTime.now())) {
                      if (picked.hour < now.hour ||
                          (picked.hour == now.hour &&
                              picked.minute < now.minute)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Jam tidak boleh mundur")),
                        );
                        return;
                      }
                    }
                    setState(() => _jamAntar = picked);
                  }
                },
              ),
            ],
          ),
        ),

        _buildFormRow(
          "Tipe Mobil*",
          Wrap(
            spacing: 12,
            children: ["Ambulans", "Jenazah"].map((tipe) {
              return ChoiceChip(
                label: Text(tipe),
                selected: _tipeMobil == tipe,
                onSelected: (_) => setState(() => _tipeMobil = tipe),
                selectedColor: Colors.blue.shade100,
              );
            }).toList(),
          ),
        ),

        _buildFormRow(
          "Jasa Pendamping*",
          Wrap(
            spacing: 12,
            children: ["Ya", "Tidak"].map((opt) {
              return ChoiceChip(
                label: Text(opt),
                selected: _jasaPendamping == opt,
                onSelected: (_) => setState(() => _jasaPendamping = opt),
                selectedColor: Colors.blue.shade100,
              );
            }).toList(),
          ),
        ),

        _buildFormRow(
          "Alamat Antar",
          TextField(
            controller: _alamatCtrl,
            decoration: const InputDecoration(
              hintText: "Masukkan alamat",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
        ),

        _buildFormRow(
          "Titik Penjemputan",
          TextField(
            controller: _titikCtrl,
            decoration: const InputDecoration(
              hintText: "Masukkan titik penjemputan",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.place),
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 FormRow (Responsive)
  Widget _buildFormRow(String label, Widget field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 6),
          field,
        ],
      ),
    );
  }

  Widget _buildItemsTable(double fontSize) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 16,
          headingRowColor:
              MaterialStateColor.resolveWith((states) => Colors.blue.shade50),
          columns: [
            DataColumn(label: Text("No", style: TextStyle(fontSize: fontSize))),
            DataColumn(
                label: Text("Nama Item", style: TextStyle(fontSize: fontSize))),
            DataColumn(
                label:
                    Text("Kategori", style: TextStyle(fontSize: fontSize))),
          ],
          rows: _items.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final item = entry.value;
            return DataRow(
              cells: [
                DataCell(Text(index.toString(),
                    style: TextStyle(fontSize: fontSize))),
                DataCell(Text(item["nama"]!, style: TextStyle(fontSize: fontSize))),
                DataCell(Text(item["kategori"]!,
                    style: TextStyle(fontSize: fontSize))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPendampingTable(double fontSize) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 16,
          headingRowColor:
              MaterialStateColor.resolveWith((states) => Colors.blue.shade50),
          columns: [
            DataColumn(label: Text("No", style: TextStyle(fontSize: fontSize))),
            DataColumn(
                label: Text("Nama Pendamping",
                    style: TextStyle(fontSize: fontSize))),
            DataColumn(
                label: Text("Tipe Pendamping",
                    style: TextStyle(fontSize: fontSize))),
          ],
          rows: _pendamping.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final p = entry.value;
            return DataRow(
              cells: [
                DataCell(Text(index.toString(),
                    style: TextStyle(fontSize: fontSize))),
                DataCell(Text(p["nama"]!, style: TextStyle(fontSize: fontSize))),
                DataCell(Text(p["tipe"]!, style: TextStyle(fontSize: fontSize))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
