import 'package:flutter/material.dart';
// import 'package:inocare/screens/kajietik_screen.dart';
// import 'package:inocare/screens/kajiproposal_screen.dart';
// import 'package:inocare/screens/preparat_screen.dart';
import 'package:inocare/widgets/routediklat.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PreSurveyListScreen extends StatefulWidget {
  const PreSurveyListScreen({super.key});

  @override
  State<PreSurveyListScreen> createState() => _PreSurveyListScreenState();
}

class _PreSurveyListScreenState extends State<PreSurveyListScreen> {
  String _selectedMenu = "Pre Survey"; // default menu aktif

  final Map<String, dynamic> _peserta = {
    'ktp_npm': '1212121212121212 / WwhGBzyiUiFblJp',
    'nama': 'VHgGhqi6Om4HsNK',
    'instansi': 'STIKes Panca Bakti',
    'strata': 'D4',
    'prodi': 'qXhw4NoqtG7PDTG',
    'kontak': 'xrvAtkJb2IypiL',
    'kode_reg': '8rbTgr3fXq9KjsE',
    'no_reg': '250625125848388',
  };

  final List<Map<String, dynamic>> _data = [
    {
      'no': 1,
      'nomor_permohonan': 'testrerer',
      'tanggal_permohonan': '2025-08-05',
      'surat_balasan': 'teasdd322232ew',
      'perihal': 'Perpanjangan',
      'ruangan': ['Diklat', 'Diklat'],
      'tanggal': '2025-08-05 s/d 2025-08-07',
      'status_bayar': 'Belum Lunas',
      'is_lunas': false,
    },
    {
      'no': 2,
      'nomor_permohonan': 'F508VWhFUCPk',
      'tanggal_permohonan': '2025-07-01',
      'surat_balasan': 'EtVgercegvDb',
      'perihal': 'Perpanjangan',
      'ruangan': ['Diklat', 'Taman Depan'],
      'tanggal': '2025-07-15 s/d 2025-07-30',
      'status_bayar': 'Belum Lunas',
      'is_lunas': false,
    },
    {
      'no': 3,
      'nomor_permohonan': 'DOlRdDGLFsVA',
      'tanggal_permohonan': '2025-07-06',
      'surat_balasan': 'mXZkhw6brTg3',
      'perihal': 'Perpanjangan',
      'ruangan': ['Diklat', 'Taman Depan'],
      'tanggal': '2025-07-24 s/d 2025-07-30',
      'status_bayar': 'Belum Lunas',
      'is_lunas': false,
    },
    {
      'no': 4,
      'nomor_permohonan': 'yaAnICUSLb6c',
      'tanggal_permohonan': '2025-07-01',
      'surat_balasan': 'NvloZckyvvhh',
      'perihal': 'Perpanjangan',
      'ruangan': ['Diklat', 'Xcfghjkl;'],
      'tanggal': '2025-07-10 s/d 2025-07-30',
      'status_bayar': 'Belum Lunas',
      'is_lunas': false,
    },
    {
      'no': 5,
      'nomor_permohonan': 'vqdR8VAl7Zzt',
      'tanggal_permohonan': '2025-07-08',
      'surat_balasan': 'foVt6taL3b8f',
      'perihal': 'Perpanjangan',
      'ruangan': ['Diklat', 'Ruang Overview'],
      'tanggal': '2025-07-09 s/d 2025-07-17',
      'status_bayar': 'Lunas',
      'is_lunas': true,
    },
  ];

  // === POPUP DETAIL ===
  void _showDetailDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "Detail Pre-Survey",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow("Nomor Permohonan", item['nomor_permohonan']),
                _buildDetailRow(
                  "Tanggal Permohonan",
                  item['tanggal_permohonan'],
                ),
                _buildDetailRow("Surat Balasan", item['surat_balasan']),
                _buildDetailRow("Perihal", item['perihal']),
                _buildDetailRow("Tanggal", item['tanggal']),
                _buildDetailRow(
                  "Ruangan",
                  (item['ruangan'] as List).join(", "),
                ),
                _buildDetailRow("Status Bayar", item['status_bayar']),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Tutup"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // === MENU DRAWER ===
  void _onMenuSelect(String menu) {
  setState(() {
    _selectedMenu = menu;
  });
  Navigator.pop(context); // tutup drawer
  AppRoutes.navigate(context, menu); // pindah halaman sesuai menu
}

  Widget _buildMenuItem(IconData icon, String title) {
    final bool isSelected = _selectedMenu == title;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.black54),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.blue.withOpacity(0.1),
      onTap: () => _onMenuSelect(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Kegiatan Penelitian',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1565C0),
        actions: [
          Builder(
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    Scaffold.of(
                      context,
                    ).openEndDrawer(); // buka drawer di kanan
                  },
                ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF1565C0)),

              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
            _buildMenuItem(MdiIcons.featureSearchOutline, "Pre Survey"),
            _buildMenuItem(MdiIcons.bookEditOutline, "Kaji Etik"),
            _buildMenuItem(MdiIcons.fileDocumentEditOutline, "Kaji Proposal"),
            _buildMenuItem(MdiIcons.deskLampOn, "Penelitian"),
            _buildMenuItem(MdiIcons.cashMultiple, "Preparat"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // === Bagian Info Peserta ===
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Kode Registrasi di kanan atas
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Informasi Peserta",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _peserta['kode_reg'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1565C0),
                              ),
                            ),
                            Text(
                              "No. REG : ${_peserta['no_reg']}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildInfoRow("No. KTP / NPM", _peserta['ktp_npm']),
                    _buildInfoRow("Nama", _peserta['nama']),
                    _buildInfoRow(
                      "Instansi / Strata / Prodi",
                      "${_peserta['instansi']} / ${_peserta['strata']} / ${_peserta['prodi']}",
                    ),
                    _buildInfoRow("Kontak", _peserta['kontak']),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // === Header List Pre-Survey ===
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  "List Pre-Survey",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Tombol + Tambah di luar container biru
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  // aksi tambah data
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text("+ Tambah"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  textStyle: const TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // === Bagian Tabel Pre-Survey ===
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 16,
                  headingRowHeight: 56,
                  dataRowHeight: 72,
                  headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  columns: const [
                    DataColumn(label: Text('No')),
                    DataColumn(label: Text('Surat Permohonan')),
                    DataColumn(label: Text('Surat Balasan')),
                    DataColumn(label: Text('Perihal')),
                    DataColumn(label: Text('Ruangan')),
                    DataColumn(label: Text('Tanggal')),
                    DataColumn(label: Text('Status Bayar')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows:
                      _data.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(Text(item['no'].toString())),
                            DataCell(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Nomor: ${item['nomor_permohonan']}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Tanggal: ${item['tanggal_permohonan']}",
                                  ),
                                ],
                              ),
                            ),
                            DataCell(Text(item['surat_balasan'])),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item['perihal'],
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  (item['ruangan'] as List).length,
                                  (index) => Text(
                                    "${index + 1}. ${item['ruangan'][index]}",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Text(item['tanggal'])),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      item['is_lunas']
                                          ? Colors.green[100]
                                          : Colors.red[100],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item['status_bayar'],
                                  style: TextStyle(
                                    color:
                                        item['is_lunas']
                                            ? Colors.green[800]
                                            : Colors.red[800],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () {
                                      // aksi edit
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      _showDetailDialog(item);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(value ?? '-', style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
