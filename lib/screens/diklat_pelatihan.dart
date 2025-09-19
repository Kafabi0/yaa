import 'package:flutter/material.dart';

class DiklatPelatihanPage extends StatefulWidget {
  const DiklatPelatihanPage({super.key});

  @override
  State<DiklatPelatihanPage> createState() => _DiklatPelatihanPageState();
}

class _DiklatPelatihanPageState extends State<DiklatPelatihanPage> {
  // 🔹 Data asli
  final List<Map<String, String>> kegiatanAll = [
    {
      "noSurat": "000.9.2/234/VII.01/II/2025",
      "perihal": "Praklinik Keperawatan",
      "tgl": "2025-08-14",
    },
    {
      "noSurat": "001.9.2/235/VII.01/II/2025",
      "perihal": "Pelatihan BTCLS",
      "tgl": "2025-08-20",
    },
    {
      "noSurat": "002.9.2/236/VII.01/II/2025",
      "perihal": "Workshop Manajemen ICU",
      "tgl": "2025-09-01",
    },
    {
      "noSurat": "003.9.2/237/VII.01/II/2025",
      "perihal": "Simulasi Kebencanaan",
      "tgl": "2025-09-10",
    },
  ];

  final List<Map<String, String>> petugasAll = [
    {"nama": "Dr. Iskandar Muda, Sp.M"},
    {"nama": "Ns. Siti Aminah, M.Kep"},
    {"nama": "drg. Rudi Hartono"},
    {"nama": "Prof. Bambang Setiawan"},
    {"nama": "Dr. Lestari Wulandari, Sp.An"},
  ];

  // 🔹 Data yang ditampilkan (hasil filter)
  List<Map<String, String>> kegiatanFiltered = [];
  List<Map<String, String>> petugasFiltered = [];

  @override
  void initState() {
    super.initState();
    kegiatanFiltered = List.from(kegiatanAll);
    petugasFiltered = List.from(petugasAll);
  }

  void _searchKegiatan(String query) {
    setState(() {
      kegiatanFiltered = kegiatanAll
          .where((item) =>
              item["noSurat"]!.toLowerCase().contains(query.toLowerCase()) ||
              item["perihal"]!.toLowerCase().contains(query.toLowerCase()) ||
              item["tgl"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _searchPetugas(String query) {
    setState(() {
      petugasFiltered = petugasAll
          .where((item) =>
              item["nama"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(title: const Text("Kegiatan Pelatihan"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Detail Header
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoRow(
                      label: "No. Registrasi",
                      value: "2508161224502890",
                    ),
                    InfoRow(label: "Tipe Pelatihan", value: "Kerjasama"),
                    InfoRow(
                      label: "Pihak Kerjasama",
                      value: "Universitas Indonesia",
                    ),
                    InfoRow(
                      label: "Tempat Pelatihan",
                      value: "Gedung Diklat",
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 Judul
            const Row(
              children: [
                Icon(Icons.people, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  "Kegiatan Pelatihan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 🔹 Layout responsif
            isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: _buildKegiatanCard(
                              kegiatanFiltered, _searchKegiatan)),
                      const SizedBox(width: 16),
                      Expanded(
                          child:
                              _buildPetugasCard(petugasFiltered, _searchPetugas)),
                    ],
                  )
                : Column(
                    children: [
                      _buildKegiatanCard(kegiatanFiltered, _searchKegiatan),
                      const SizedBox(height: 16),
                      _buildPetugasCard(petugasFiltered, _searchPetugas),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  // 🔹 Card Kegiatan
  Widget _buildKegiatanCard(
      List<Map<String, String>> kegiatan, Function(String) onSearch) {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          _buildHeader("Kegiatan", onAdd: () {}, onRefresh: () {}),
          _buildSearchField(onSearch),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
              columns: const [
                DataColumn(label: Text("No")),
                DataColumn(label: Text("No. Surat")),
                DataColumn(label: Text("Perihal")),
                DataColumn(label: Text("Tgl. Pelaksanaan")),
                DataColumn(label: Text("Aksi")),
              ],
              rows: List.generate(kegiatan.length, (index) {
                final item = kegiatan[index];
                return DataRow(
                  cells: [
                    DataCell(Text((index + 1).toString())),
                    DataCell(Text(item["noSurat"]!)),
                    DataCell(Text(item["perihal"]!)),
                    DataCell(Text(item["tgl"]!)),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.picture_as_pdf,
                                color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.people, color: Colors.indigo),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.edit, color: Colors.green),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Card Petugas
  Widget _buildPetugasCard(
      List<Map<String, String>> petugas, Function(String) onSearch) {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          _buildHeader("Daftar Petugas", onAdd: () {}, onRefresh: () {}),
          _buildSearchField(onSearch),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
              columns: const [
                DataColumn(label: Text("No")),
                DataColumn(label: Text("Petugas")),
                DataColumn(label: Text("Aksi")),
              ],
              rows: List.generate(petugas.length, (index) {
                final item = petugas[index];
                return DataRow(
                  cells: [
                    DataCell(Text((index + 1).toString())),
                    DataCell(Text(item["nama"]!)),
                    DataCell(
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Hapus"),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Header Reusable
  Widget _buildHeader(
    String title, {
    required VoidCallback onAdd,
    required VoidCallback onRefresh,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  textStyle: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
                child: const Text("+"),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 Search Field Reusable
  Widget _buildSearchField(Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: "Cari...",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          isDense: true,
          contentPadding: const EdgeInsets.all(8),
        ),
      ),
    );
  }
}

// 🔹 Widget Reusable untuk header info
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 150, child: Text("$label :")),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
