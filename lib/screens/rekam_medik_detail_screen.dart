import 'package:flutter/material.dart';

class RekamDetailPage extends StatefulWidget {
  final Map<String, dynamic> pasienData;
  const RekamDetailPage({Key? key, required this.pasienData}) : super(key: key);

  @override
  _RekamDetailPageState createState() => _RekamDetailPageState();
}

class _RekamDetailPageState extends State<RekamDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _pesertaController = TextEditingController();

  // Data dummy untuk riwayat kunjungan
  final List<Map<String, dynamic>> _riwayatKunjungan = [
    {
      'tanggal': '06-08-2025',
      'jam': '16:06:02',
      'keterangan': 'IGD',
      'diagnosa': 'ICD'
    },
    {
      'tanggal': '04-08-2025',
      'jam': '16:02:54',
      'keterangan': 'RAWAT JALAN',
      'diagnosa': 'RAWAT JALAN'
    },
    {
      'tanggal': '28-07-2025',
      'jam': '08:27:40',
      'keterangan': 'IGD => RAWAT INAP',
      'diagnosa': 'IGD => RAWAT INAP',
      'periode': 'v1/l 2025-08-12',
      'additional': '12:27:58'
    },
    {
      'tanggal': '15-07-2025',
      'jam': '09:39:20',
      'keterangan': 'RAWAT JALAN',
      'diagnosa': 'RAWAT JALAN'
    },
    {
      'tanggal': '10-07-2025',
      'jam': '14:30:15',
      'keterangan': 'RAWAT JALAN',
      'diagnosa': 'RAWAT JALAN'
    },
    {
      'tanggal': '08-07-2025',
      'jam': '10:29:04',
      'keterangan': 'RAWAT JALAN',
      'diagnosa': 'RAWAT JALAN'
    },
    {
      'tanggal': '20-06-2025',
      'jam': '15:03:54',
      'keterangan': 'RAWAT JALAN',
      'diagnosa': 'RAWAT JALAN'
    },
    {
      'tanggal': '10-06-2025',
      'jam': '13:43:48',
      'keterangan': 'RAWAT JALAN',
      'diagnosa': 'RAWAT JALAN'
    },
    {
      'tanggal': '22-05-2025',
      'jam': '09:16:53',
      'keterangan': 'RAWAT JALAN',
      'diagnosa': 'RAWAT JALAN'
    },
    {
      'tanggal': '15-05-2025',
      'jam': '15:06:01',
      'keterangan': 'RAWAT JALAN',
      'diagnosa': 'RAWAT JALAN'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _pesertaController.text = "000346429444872";
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pesertaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text(
          widget.pasienData['namaLengkap'] ?? 'Detail Pasien',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Info Section
          Container(
            color: Colors.blue[800],
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child:
                      widget.pasienData['hasPhoto'] == true
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/pasien1.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          )
                          : Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.grey[600],
                            ),
                          ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('No. RM', widget.pasienData['noRM'] ?? ''),
                      SizedBox(height: 6),
                      _buildInfoRow(
                        'Nama',
                        widget.pasienData['namaLengkap'] ?? '',
                      ),
                      SizedBox(height: 6),
                      _buildInfoRow(
                        'Jenis Kelamin',
                        widget.pasienData['jenisKelamin'] ?? '',
                      ),
                      SizedBox(height: 6),
                      _buildInfoRow(
                        'Tanggal Lahir',
                        '${widget.pasienData['tanggalLahir'] ?? ''} (${widget.pasienData['umur'] ?? ''})',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab Section
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.blue[800],
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Colors.blue[800],
              tabs: [
                Tab(icon: Icon(Icons.edit_note, size: 20), text: 'Rekam Medik'),
                Tab(icon: Icon(Icons.biotech, size: 20), text: 'Bio Data'),
                Tab(
                  icon: Icon(Icons.history, size: 20),
                  text: 'Riwayat Kunjungan',
                ),
                Tab(
                  icon: Icon(Icons.qr_code, size: 20),
                  text: 'Berkas Digital',
                ),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Rekam Medik Tab - Empty for now
                _buildEmptyTab('Rekam Medik'),

                // Bio Data Tab - Complete content
                _buildBioDataTab(),

                // Riwayat Kunjungan Tab - NEW IMPLEMENTATION
                _buildRiwayatKunjunganTab(),

                // Berkas Digital Tab - Empty for now
                _buildEmptyTab('Berkas Digital'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // NEW: Riwayat Kunjungan Tab Implementation
  Widget _buildRiwayatKunjunganTab() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Header dengan judul "Episode"
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.indigo[600],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              'Episode',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // List Riwayat Kunjungan
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _riwayatKunjungan.length,
              itemBuilder: (context, index) {
                final item = _riwayatKunjungan[index];
                return _buildRiwayatKunjunganItem(item, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatKunjunganItem(Map<String, dynamic> item, int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!, width: 0.5),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tanggal dan Jam
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['tanggal'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    item['jam'],
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                  // Tampilkan periode jika ada (untuk rawat inap)
                  if (item['periode'] != null) ...[
                    SizedBox(height: 2),
                    Text(
                      item['periode'],
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.blue[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  // Tampilkan additional time jika ada
                  if (item['additional'] != null) ...[
                    SizedBox(height: 2),
                    Text(
                      item['additional'],
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            SizedBox(width: 16),
            
            // Keterangan/Diagnosa
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getKeteranganColor(item['keterangan']),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item['keterangan'],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _getKeteranganTextColor(item['keterangan']),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getKeteranganColor(String keterangan) {
    if (keterangan.contains('IGD')) {
      return Colors.red[100]!;
    } else if (keterangan.contains('RAWAT INAP')) {
      return Colors.orange[100]!;
    } else if (keterangan.contains('RAWAT JALAN')) {
      return Colors.blue[100]!;
    }
    return Colors.grey[100]!;
  }

  Color _getKeteranganTextColor(String keterangan) {
    if (keterangan.contains('IGD')) {
      return Colors.red[800]!;
    } else if (keterangan.contains('RAWAT INAP')) {
      return Colors.orange[800]!;
    } else if (keterangan.contains('RAWAT JALAN')) {
      return Colors.blue[800]!;
    }
    return Colors.grey[800]!;
  }

  // Empty tab placeholder
  Widget _buildEmptyTab(String tabName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            '$tabName',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Sedang dalam pengembangan',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildBioDataTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // 1. Foto Section
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Foto',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[400],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Lengkapi Foto',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Foto Identitas
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Foto Identitas',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: 120,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child:
                                  widget.pasienData['hasPhoto'] == true
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          'assets/images/ktp.png',
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              color: Colors.grey[200],
                                              child: Icon(
                                                Icons.person,
                                                size: 40,
                                                color: Colors.grey[400],
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                      : Container(
                                        color: Colors.grey[200],
                                        child: Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      // Foto Pasien
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Foto Pasien',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child:
                                  widget.pasienData['hasPhoto'] == true
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          'assets/images/pasien1.jpg',
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              color: Colors.grey[200],
                                              child: Icon(
                                                Icons.person,
                                                size: 50,
                                                color: Colors.grey[400],
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                      : Container(
                                        color: Colors.grey[200],
                                        child: Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Data Pasien Section
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Data Pasien',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[400],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Lengkapi Data',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildFormField(
                        'Nama Pasien',
                        widget.pasienData['namaLengkap'] ?? '',
                      ),
                      _buildFormField('Tempat Lahir', 'PALEMBANG'),
                      _buildFormField(
                        'Tanggal Lahir',
                        widget.pasienData['tanggalLahir'] ?? '',
                      ),
                      _buildFormFieldDropdown(
                        'Jenis Kelamin',
                        widget.pasienData['jenisKelamin'] ?? '',
                      ),
                      _buildFormFieldDropdown(
                        'Golongan Darah',
                        'A',
                        options: ['A', 'B', 'AB', 'O'],
                      ),
                      _buildFormFieldRadio('Kewarganegaraan', 'WNI'),
                      _buildFormFieldDropdown('Negara', 'Indonesia'),
                      _buildFormFieldRadio('Jenis Identitas', 'KTP/KK'),
                      _buildFormField(
                        'Nomor Identitas',
                        widget.pasienData['noIdentitas']?.split(' ')[0] ?? '',
                      ),
                      _buildFormFieldDropdown('Suku', 'Aceh'),
                      _buildFormFieldDropdown('Bahasa', 'INDONESIA'),
                      _buildFormFieldDropdown('Status Pernikahan', 'Kawin'),
                      _buildFormFieldDropdown('Agama', 'Islam'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. Jaminan (BPJS) Section
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Jaminan (BPJS)',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red[400],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Edit Data',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text(
                                'No. Peserta',
                                style: TextStyle(fontSize: 12),
                              ),
                              value: 'peserta',
                              groupValue: 'peserta',
                              onChanged: (value) {},
                              dense: true,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text(
                                'Nomor KTP',
                                style: TextStyle(fontSize: 12),
                              ),
                              value: 'ktp',
                              groupValue: 'peserta',
                              onChanged: (value) {},
                              dense: true,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextField(
                              controller: _pesertaController,
                              decoration: InputDecoration(
                                hintText: 'No. Peserta',
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            child: Text('Check'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Hijau (hanya teks utama)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFF00A693), // Hijau BPJS
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Kartu Peserta BPJS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                // Isi Data abu-abu
                Container(
                  width: double.infinity,
                  color: Color(0xFFF8F9FA),
                  padding: EdgeInsets.fromLTRB(
                    16,
                    8,
                    16,
                    16,
                  ), // atas lebih kecil
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "KELAS III",
                            style: TextStyle(
                              color: Colors.blue[900],
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Image.asset(
                            'assets/images/bpjs3.png',
                            height: 80, 
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Column(
                                children: [
                                  Text(
                                    'BPJS',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'Kesehatan',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: 8),

                      _buildBPJSInfoRow("Nomor Kartu", "0002456794872"),

                      SizedBox(height: 8),
                      _buildBPJSInfoRow("NIK", "3273270870000001"),
                      _buildBPJSInfoRow("NAMA", "MUHAMMAD FARIS FAKHRULLAH"),
                      _buildBPJSInfoRow("TANGGAL LAHIR", "2000-07-09"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method untuk membuat form field
  Widget _buildFormField(
    String label,
    String value, {
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 4),
          TextFormField(
            controller: controller ?? TextEditingController(text: value),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method untuk membuat form field dropdown
  Widget _buildFormFieldDropdown(
    String label,
    String value, {
    List<String>? options,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: value.isNotEmpty ? value : null,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            items:
                options?.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                // Handle dropdown change
              });
            },
          ),
        ],
      ),
    );
  }

  // Helper method untuk membuat form field radio
  Widget _buildFormFieldRadio(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('WNI'),
                  value: 'WNI',
                  groupValue: value,
                  onChanged: (String? newValue) {
                    setState(() {
                      // Handle radio change
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('WNA'),
                  value: 'WNA',
                  groupValue: value,
                  onChanged: (String? newValue) {
                    setState(() {
                      // Handle radio change
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method untuk membuat BPJS info row
  Widget _buildBPJSInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 10,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method untuk membuat info row di header
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100,
          child: Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ),
        Text(': ', style: TextStyle(color: Colors.white70, fontSize: 12)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
