// pasienselesai_screen.dart

import 'package:flutter/material.dart';

// 1. Model data untuk Pasien Selesai
class PasienSelesai {
  final String noRegistrasi;
  final String noTriase;
  final String tglRegistrasi;
  final String noRM;
  final String namaPasien;
  final String jenisKelamin;
  final String tanggalLahir;
  final String unitLayanan;
  final String dpjp;
  final String tipePasien;
  final String waktuSelesaiLayanan;

  PasienSelesai({
    required this.noRegistrasi,
    required this.noTriase,
    required this.tglRegistrasi,
    required this.noRM,
    required this.namaPasien,
    required this.jenisKelamin,
    required this.tanggalLahir,
    required this.unitLayanan,
    required this.dpjp,
    required this.tipePasien,
    required this.waktuSelesaiLayanan,
  });
}

// 2. Halaman Pasien Selesai Layanan
class PasienSelesaiPage extends StatefulWidget {
  const PasienSelesaiPage({super.key});

  @override
  State<PasienSelesaiPage> createState() => _PasienSelesaiPageState();
}

class _PasienSelesaiPageState extends State<PasienSelesaiPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';
  bool _isTabView = true; // true untuk Tab, false untuk Card
  List<PasienSelesai> _allPasien = [];
  List<PasienSelesai> _filteredPasien = [];

  @override
  void initState() {
    super.initState();
    _loadPasienSelesai();
  }

  void _loadPasienSelesai() {
    // Data dummy sesuai dengan gambar
    _allPasien = [
      PasienSelesai(
        noRegistrasi: '00035053003000301',
        noTriase: 'TR-20250301020-057',
        tglRegistrasi: '08-03-2025',
        noRM: '',
        namaPasien: 'John Doe Testee',
        jenisKelamin: 'Laki-laki',
        tanggalLahir: '01-01-1990\n35 Tahun / 7 Bulan / 4 Hari',
        unitLayanan: 'IGD',
        dpjp: 'Dr. Emiluth',
        tipePasien: 'BPJS',
        waktuSelesaiLayanan: '2025-03-28\n18:30:26',
      ),
      PasienSelesai(
        noRegistrasi: '8635-000000000003',
        noTriase: 'TR-20250306103TC-248',
        tglRegistrasi: '',
        noRM: '',
        namaPasien: '',
        jenisKelamin: 'Laki-laki',
        tanggalLahir: '',
        unitLayanan: 'IGD',
        dpjp: '',
        tipePasien: '',
        waktuSelesaiLayanan: '2025-03-19\n14:40:18',
      ),
      PasienSelesai(
        noRegistrasi: '11042055030001200019',
        noTriase: 'TR-04-2025',
        tglRegistrasi: '',
        noRM: '350359865',
        namaPasien: 'MUHAMMAD DZAKWAN',
        jenisKelamin: 'Laki-laki',
        tanggalLahir: '2016-09-02\n8 Tahun / 8 Bulan / 24 Hari',
        unitLayanan: 'IGD',
        dpjp: 'Tenaga Medis 434896',
        tipePasien: 'BPJS',
        waktuSelesaiLayanan: '2025-04-03\n17:26:19',
      ),
      PasienSelesai(
        noRegistrasi: '11042055033000002',
        noTriase: 'TR-20250407010H-472',
        tglRegistrasi: '',
        noRM: '',
        namaPasien: '',
        jenisKelamin: '',
        tanggalLahir: '',
        unitLayanan: 'IGD',
        dpjp: '',
        tipePasien: '',
        waktuSelesaiLayanan: '2025-04-17\n21:21:48',
      ),
      PasienSelesai(
        noRegistrasi: '11042055033000008',
        noTriase: 'TR-20250407250H-378',
        tglRegistrasi: '',
        noRM: '',
        namaPasien: '',
        jenisKelamin: '',
        tanggalLahir: '',
        unitLayanan: 'IGD',
        dpjp: '',
        tipePasien: '',
        waktuSelesaiLayanan: '2025-04-17\n17:30:48',
      ),
      PasienSelesai(
        noRegistrasi: '18042055032002007',
        noTriase: '18-04-2025',
        tglRegistrasi: '',
        noRM: '00008019',
        namaPasien: 'SYAIFUL BAHRI',
        jenisKelamin: 'Laki-laki',
        tanggalLahir: '14-09-1957\n68 Tahun / 2 Bulan / 4 Hari',
        unitLayanan: 'IGD',
        dpjp: 'Tenaga Medis 33041',
        tipePasien: 'BPJS',
        waktuSelesaiLayanan: '2025-04-19\n14:14:40',
      ),
      PasienSelesai(
        noRegistrasi: '20042055033062001',
        noTriase: '20-04-2025',
        tglRegistrasi: '',
        noRM: '40209694',
        namaPasien: 'KURNIAWAN MESA',
        jenisKelamin: 'Laki-laki',
        tanggalLahir: '02-02-1981\n44 Tahun / 2 Bulan / 27 Hari',
        unitLayanan: 'IGD',
        dpjp: 'Zamiyatun Hardy Marpaung',
        tipePasien: 'BPJS',
        waktuSelesaiLayanan: '2025-04-20\n16:56:24',
      ),
      PasienSelesai(
        noRegistrasi: '20042055033002002',
        noTriase: '20-04-2025',
        tglRegistrasi: '',
        noRM: '00008017',
        namaPasien: 'MASYTAMAH SEHAH UDALLU',
        jenisKelamin: 'Perempuan',
        tanggalLahir: '04-10-1950\n74 Tahun / 6 Bulan / 20 Hari',
        unitLayanan: 'IGD',
        dpjp: 'Tenaga Medis 162631',
        tipePasien: 'BPJS',
        waktuSelesaiLayanan: '2025-04-23\n14:39:25',
      ),
      PasienSelesai(
        noRegistrasi: '24042055030992002',
        noTriase: '24-04-2025',
        tglRegistrasi: '',
        noRM: '35026904',
        namaPasien: 'HENRI SEPTIANI',
        jenisKelamin: 'Perempuan',
        tanggalLahir: '08-02-1962\n63 Tahun / 2 Bulan / 16 Hari',
        unitLayanan: 'IGD',
        dpjp: 'Tenaga Medis 57811',
        tipePasien: 'BPJS',
        waktuSelesaiLayanan: '2025-04-25\n09:39:27',
      ),
      PasienSelesai(
        noRegistrasi: '02052055032003001',
        noTriase: '02-05-2025',
        tglRegistrasi: '',
        noRM: '3002393',
        namaPasien: 'Pasien Testing',
        jenisKelamin: 'Laki-laki',
        tanggalLahir: '05-05-1955\n69 Tahun / 2 Bulan / 26 Hari',
        unitLayanan: 'IGD',
        dpjp: 'Liza Novianti',
        tipePasien: 'UMUM',
        waktuSelesaiLayanan: '2025-05-02\n14:09:42',
      ),
    ];
    _filteredPasien = List.from(_allPasien);
  }

  void _filterPasien() {
    setState(() {
      _filteredPasien = _allPasien.where((pasien) {
        final searchTerm = _searchController.text.toLowerCase();
        final matchesSearch = pasien.namaPasien.toLowerCase().contains(searchTerm) ||
            pasien.noRM.toLowerCase().contains(searchTerm) ||
            pasien.noRegistrasi.toLowerCase().contains(searchTerm);

        final matchesFilter = _selectedFilter == 'Semua' ||
            (_selectedFilter == 'BPJS' && pasien.tipePasien == 'BPJS') ||
            (_selectedFilter == 'UMUM' && pasien.tipePasien == 'UMUM');

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pasien Selesai Layanan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF7C3AED),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header dengan filter dan pencarian
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Column(
              children: [
                // Baris pertama: Search dan filter
                Row(
                  children: [
                    // Search field
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari Nama / No. RM',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        onChanged: (value) => _filterPasien(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Filter dropdown
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedFilter,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: ['Semua', 'BPJS', 'UMUM']
                            .map((filter) => DropdownMenuItem(
                                  value: filter,
                                  child: Text(filter),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedFilter = value!;
                          });
                          _filterPasien();
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Date picker
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () {
                          // Implementasi date picker
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Baris kedua: Toggle view dan info
                Row(
                  children: [
                    // Toggle Tab/Card view
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isTabView = true;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: _isTabView ? Colors.blue : Colors.transparent,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(7),
                                  bottomLeft: Radius.circular(7),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.table_chart,
                                    size: 16,
                                    color: _isTabView ? Colors.white : Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Tabel',
                                    style: TextStyle(
                                      color: _isTabView ? Colors.white : Colors.grey[600],
                                      fontWeight: _isTabView ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isTabView = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: !_isTabView ? Colors.blue : Colors.transparent,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(7),
                                  bottomRight: Radius.circular(7),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.view_agenda,
                                    size: 16,
                                    color: !_isTabView ? Colors.white : Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Card',
                                    style: TextStyle(
                                      color: !_isTabView ? Colors.white : Colors.grey[600],
                                      fontWeight: !_isTabView ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Info jumlah data
                    Text(
                      'Total: ${_filteredPasien.length} pasien',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Content area
          Expanded(
            child: _isTabView ? _buildTableView() : _buildCardView(),
          ),
        ],
      ),
    );
  }

  Widget _buildTableView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 20,
          headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
          border: TableBorder.all(color: Colors.grey[300]!),
          columns: const [
            DataColumn(
              label: Text(
                'No',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            DataColumn(
              label: Text(
                'No. Registrasi',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            DataColumn(
              label: Text(
                'No. Triase',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            DataColumn(
              label: Text(
                'Tgl. Registrasi',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            DataColumn(
              label: Text(
                'No. RM',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            DataColumn(
              label: Text(
                'Nama Pasien',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            DataColumn(
              label: Text(
                'Jenis Kelamin',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            DataColumn(
              label: Text(
                'Tanggal Lahir',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            DataColumn(
              label: Text(
                'Unit Layanan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            DataColumn(
              label: Text(
                'DPJP',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            DataColumn(
              label: Text(
                'Tipe Pasien',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            DataColumn(
              label: Text(
                'Waktu Selesai Layanan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            DataColumn(
              label: Text(
                'Aksi',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
          rows: _filteredPasien.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final pasien = entry.value;
            return DataRow(
              cells: [
                DataCell(Text(index.toString())),
                DataCell(
                  SizedBox(
                    width: 120,
                    child: Text(
                      pasien.noRegistrasi,
                      style: const TextStyle(fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 120,
                    child: Text(
                      pasien.noTriase,
                      style: const TextStyle(fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    pasien.tglRegistrasi,
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
                DataCell(
                  Text(
                    pasien.noRM,
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 120,
                    child: Text(
                      pasien.namaPasien,
                      style: const TextStyle(fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    pasien.jenisKelamin,
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 100,
                    child: Text(
                      pasien.tanggalLahir,
                      style: const TextStyle(fontSize: 10),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    pasien.unitLayanan,
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 120,
                    child: Text(
                      pasien.dpjp,
                      style: const TextStyle(fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: pasien.tipePasien == 'BPJS' 
                          ? Colors.green[100] 
                          : pasien.tipePasien == 'UMUM'
                              ? Colors.blue[100]
                              : Colors.grey[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      pasien.tipePasien,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: pasien.tipePasien == 'BPJS' 
                            ? Colors.green[700] 
                            : pasien.tipePasien == 'UMUM'
                                ? Colors.blue[700]
                                : Colors.grey[700],
                      ),
                    ),
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 100,
                    child: Text(
                      pasien.waktuSelesaiLayanan,
                      style: const TextStyle(fontSize: 10),
                      maxLines: 2,
                    ),
                  ),
                ),
                DataCell(
                  ElevatedButton(
                    onPressed: () {
                      _showDetailDialog(pasien);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: const Size(60, 30),
                    ),
                    child: const Text(
                      'Detail',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCardView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredPasien.length,
      itemBuilder: (context, index) {
        final pasien = _filteredPasien[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        pasien.namaPasien.isNotEmpty 
                            ? pasien.namaPasien 
                            : 'Pasien ${index + 1}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (pasien.tipePasien.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: pasien.tipePasien == 'BPJS' 
                              ? Colors.green[100] 
                              : pasien.tipePasien == 'UMUM'
                                  ? Colors.blue[100]
                                  : Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          pasien.tipePasien,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: pasien.tipePasien == 'BPJS' 
                                ? Colors.green[700] 
                                : pasien.tipePasien == 'UMUM'
                                    ? Colors.blue[700]
                                    : Colors.grey[700],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('No. Registrasi', pasien.noRegistrasi),
                          _buildInfoRow('No. RM', pasien.noRM),
                          _buildInfoRow('Jenis Kelamin', pasien.jenisKelamin),
                          _buildInfoRow('Unit Layanan', pasien.unitLayanan),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('No. Triase', pasien.noTriase),
                          _buildInfoRow('DPJP', pasien.dpjp),
                          _buildInfoRow('Tanggal Lahir', pasien.tanggalLahir.split('\n')[0]),
                          _buildInfoRow('Selesai', pasien.waktuSelesaiLayanan.split('\n')[0]),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _showDetailDialog(pasien);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Detail'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '-',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(PasienSelesai pasien) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black54,
        pageBuilder: (BuildContext context, _, __) {
          return PasienDetailModal(pasien: pasien);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, -1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

}

// 4. Modal Detail Pasien yang muncul dari atas
class PasienDetailModal extends StatefulWidget {
  final PasienSelesai pasien;

  const PasienDetailModal({super.key, required this.pasien});

  @override
  State<PasienDetailModal> createState() => _PasienDetailModalState();
}

class _PasienDetailModalState extends State<PasienDetailModal> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 12, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header dengan info pasien
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Data Registrasi Pasien',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _buildInfoItem('No. Registrasi', widget.pasien.noRegistrasi),
                            _buildInfoItem('No. RM', widget.pasien.noRM),
                            _buildInfoItem('Nama', widget.pasien.namaPasien),
                            _buildInfoItem('Tanggal Registrasi', widget.pasien.tglRegistrasi),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          children: [
                            _buildInfoItem('Jenis Kelamin', widget.pasien.jenisKelamin,),
                            _buildInfoItem('Tanggal Lahir', widget.pasien.tanggalLahir.split('\n')[0]),
                            _buildInfoItem('Tipe Pasien', widget.pasien.tipePasien),
                            _buildInfoItem('Tanggal Selesai Layanan', widget.pasien.waktuSelesaiLayanan.split('\n')[0]),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Info tambahan
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Text(
                              'Instalasi',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                widget.pasien.unitLayanan,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const Text(
                              'DPJP: ',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                widget.pasien.dpjp.isNotEmpty ? widget.pasien.dpjp : 'Dr. Emiluth',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Tab Navigation
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: Colors.teal,
                indicatorWeight: 3,
                labelColor: Colors.teal,
                unselectedLabelColor: Colors.grey[600],
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.assessment, size: 16),
                    text: 'Triase',
                  ),
                  Tab(
                    icon: Icon(Icons.assignment, size: 16),
                    text: 'Asesmen',
                  ),
                  Tab(
                    icon: Icon(Icons.note_alt, size: 16),
                    text: 'CPPT',
                  ),
                  Tab(
                    icon: Icon(Icons.medical_services, size: 16),
                    text: 'Diagnosa & Tindakan',
                  ),
                  Tab(
                    icon: Icon(Icons.build, size: 16),
                    text: 'Jasa Tindakan',
                  ),
                  Tab(
                    icon: Icon(Icons.medication, size: 16),
                    text: 'Farmasi',
                  ),
                  Tab(
                    icon: Icon(Icons.receipt, size: 16),
                    text: 'TDRS',
                  ),
                  Tab(
                    icon: Icon(Icons.radio_button_checked, size: 16),
                    text: 'Radiologi',
                  ),
                  Tab(
                    icon: Icon(Icons.science, size: 16),
                    text: 'Lab',
                  ),
                  Tab(
                    icon: Icon(Icons.chat, size: 16),
                    text: 'Konsul',
                  ),
                  Tab(
                    icon: Icon(Icons.local_hospital, size: 16),
                    text: 'Operasi',
                  ),
                  Tab(
                    icon: Icon(Icons.folder, size: 16),
                    text: 'Resume Medis',
                  ),
                ],
              ),
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTriaseContent(),
                  _buildAsesmenContent(),
                  _buildCPPTContent(),
                  _buildDiagnosaContent(),
                  _buildJasaTindakanContent(),
                  _buildFarmasiContent(),
                  _buildTDRSContent(),
                  _buildRadiologiContent(),
                  _buildLabContent(),
                  _buildKonsulContent(),
                  _buildOperasiContent(),
                  _buildResumeMedisContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '-',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Content untuk tab Triase
  Widget _buildTriaseContent() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red[200]!),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline,
                size: 30,
                color: Colors.red[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Data Triase belum diinput',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Silahkan hubungi perawat untuk melengkapi data triase',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Content untuk tab lainnya
  Widget _buildAsesmenContent() {
    return _buildEmptyTabContent('Asesmen', Icons.assignment);
  }

  Widget _buildCPPTContent() {
    return _buildEmptyTabContent('CPPT', Icons.note_alt);
  }

  Widget _buildDiagnosaContent() {
    return _buildEmptyTabContent('Diagnosa & Tindakan', Icons.medical_services);
  }

  Widget _buildJasaTindakanContent() {
    return _buildEmptyTabContent('Jasa Tindakan', Icons.build);
  }

  Widget _buildFarmasiContent() {
    return _buildEmptyTabContent('Farmasi', Icons.medication);
  }

  Widget _buildTDRSContent() {
    return _buildEmptyTabContent('TDRS', Icons.receipt);
  }

  Widget _buildRadiologiContent() {
    return _buildEmptyTabContent('Radiologi', Icons.radio_button_checked);
  }

  Widget _buildLabContent() {
    return _buildEmptyTabContent('Lab', Icons.science);
  }

  Widget _buildKonsulContent() {
    return _buildEmptyTabContent('Konsul', Icons.chat);
  }

  Widget _buildOperasiContent() {
    return _buildEmptyTabContent('Operasi', Icons.local_hospital);
  }

  Widget _buildResumeMedisContent() {
    return _buildEmptyTabContent('Resume Medis', Icons.folder);
  }

  Widget _buildEmptyTabContent(String tabName, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Data $tabName',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Belum ada data tersedia',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

