import 'package:flutter/material.dart';
import '../screens/rekam_medik_detail_screen.dart';

class RekamMedisPage extends StatefulWidget {
  const RekamMedisPage({super.key});

  @override
  _RekamMedisPageState createState() => _RekamMedisPageState();
}

class _RekamMedisPageState extends State<RekamMedisPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  
  DateTime? _selectedDate;

  List<Map<String, dynamic>> rekamMedisData = [
    {
      'no': 1,
      'foto': 'assets/images/pasien1.jpg',
      'noRM': '00000000',
      'namaLengkap': 'M NUR HARUN TEST',
      'jenisKelamin': 'Laki-laki',
      'tanggalLahir': '1992-06-04',
      'umur': '33 Tahun / 2 Bulan / 9 Hari',
      'noIdentitas': '3201023456540970 (KTP)',
      'noKartuBPJS': '0002456789001',
      'noTelpHP': '082145678901',
      'tglTerbitRM': '21-10-2008',
      'hasPhoto': true,
    },
    {
      'no': 2,
      'foto': null,
      'noRM': '00000001',
      'namaLengkap': 'SLAMET PRIYANTO ORI',
      'jenisKelamin': 'Laki-laki',
      'tanggalLahir': '1967-07-20',
      'umur': '72 Tahun / 9 Bulan / 18 Hari',
      'noIdentitas': '8902843487963935 (KTP)',
      'noKartuBPJS': '0002293022100',
      'noTelpHP': '',
      'tglTerbitRM': '2009-10-24',
      'hasPhoto': true,
    },
    {
      'no': 3,
      'foto': null,
      'noRM': '00000002',
      'namaLengkap': 'RITRISIA NUR PHARESTAWATI',
      'jenisKelamin': 'Perempuan',
      'tanggalLahir': '1984-07-01',
      'umur': '41 Tahun / 1 Bulan / 24 Hari',
      'noIdentitas': '4543880 (KTP)',
      'noKartuBPJS': '0002000393',
      'noTelpHP': '',
      'tglTerbitRM': '2009-10-24',
      'hasPhoto': true,
    },
    {
      'no': 4,
      'foto': null,
      'noRM': '00000003',
      'namaLengkap': 'YUSUF SYARAWANESE',
      'jenisKelamin': 'Laki-laki',
      'tanggalLahir': '1960-06-24',
      'umur': '75 Tahun / 4 Bulan / 1 Hari',
      'noIdentitas': 'tidak ada',
      'noKartuBPJS': '300002466200805',
      'noTelpHP': '08953020245',
      'tglTerbitRM': '2009-10-24',
      'hasPhoto': true,
    },
    {
      'no': 5,
      'foto': null,
      'noRM': '00000004',
      'namaLengkap': 'M ISNU',
      'jenisKelamin': 'Laki-laki',
      'tanggalLahir': '1965-05-27',
      'umur': '59 Tahun / 9 Bulan / 29 Hari',
      'noIdentitas': 'tidak ada',
      'noKartuBPJS': '08006600000',
      'noTelpHP': '',
      'tglTerbitRM': '2009-10-24',
      'hasPhoto': true,
    },
    {
      'no': 6,
      'foto': null,
      'noRM': '00000005',
      'namaLengkap': 'MEGAWANI PUSIL S SOS',
      'jenisKelamin': 'Perempuan',
      'tanggalLahir': '1950-06-06',
      'umur': '75 Tahun / 2 Bulan / 18 Hari',
      'noIdentitas': '0800514668500017',
      'noKartuBPJS': '',
      'noTelpHP': '',
      'tglTerbitRM': '2009-10-24',
      'hasPhoto': true,
    },
  ];

  List<Map<String, dynamic>> filteredData = [];

  @override
  void initState() {
    super.initState();
    filteredData = List.from(rekamMedisData);
  }

  void _filterData() {
    setState(() {
      filteredData = rekamMedisData.where((item) {
        // Filter berdasarkan pencarian nama/no RM
        bool matchesSearch = _searchController.text.isEmpty ||
            item['namaLengkap']
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            item['noRM'].contains(_searchController.text);
        
        // Filter berdasarkan tanggal lahir
        bool matchesDate = true;
        if (_selectedDate != null) {
          // Parse tanggal lahir dari format yyyy-mm-dd
          try {
            DateTime birthDate = DateTime.parse(item['tanggalLahir']);
            // Bandingkan hanya tanggal, bulan, dan tahun
            matchesDate = birthDate.year == _selectedDate!.year &&
                         birthDate.month == _selectedDate!.month &&
                         birthDate.day == _selectedDate!.day;
          } catch (e) {
            matchesDate = false;
          }
        }
        
        return matchesSearch && matchesDate;
      }).toList();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,
              headerBackgroundColor: Colors.blue[600],
              headerForegroundColor: Colors.white,
              dayForegroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return Colors.black87;
              }),
              dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.blue[600];
                }
                return Colors.transparent;
              }),
              yearForegroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return Colors.black87;
              }),
              yearBackgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.blue[600];
                }
                return Colors.transparent;
              }),
              todayForegroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return Colors.blue[600];
              }),
              todayBackgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.blue[600];
                }
                return Colors.transparent;
              }),
              todayBorder: BorderSide(color: Colors.blue[600]!, width: 1),
              surfaceTintColor: Colors.white,
              shadowColor: Colors.black26,
              elevation: 4,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue[600],
              ),
            ),
          ),
          child: DatePickerDialog(
            initialDate: _selectedDate ?? DateTime(1980),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            helpText: 'Pilih Tanggal Lahir',
            cancelText: 'Batal',
            confirmText: 'OK',
          ),
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.day.toString().padLeft(2, '0')}-"
                              "${picked.month.toString().padLeft(2, '0')}-"
                              "${picked.year}";
      });
      _filterData();
    }
  }

  void _clearDateFilter() {
    setState(() {
      _selectedDate = null;
      _dateController.clear();
    });
    _filterData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.withOpacity(0.3),
        title: Row(
          children: [
            SizedBox(width: 8),
            Text(
              'RM Pasien',
              style: TextStyle(
                color: Colors.blue[600],
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.blue[600]),
      ),
      body: Column(
        children: [
          // Info Card
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.teal[100]!),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.people, color: Colors.white),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${filteredData.length}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[800],
                      ),
                    ),
                    Text('Total RM',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  ],
                ),
                if (filteredData.length != rekamMedisData.length) ...[
                  SizedBox(width: 16),
                  Text(
                    'dari ${rekamMedisData.length} total',
                    style: TextStyle(
                      color: Colors.grey[600], 
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Search and Date Filter
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari No. RM / Nama Pasien',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) => _filterData(),
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  width: 160,
                  child: TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      hintText: 'Tanggal lahir',
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_dateController.text.isNotEmpty)
                            IconButton(
                              icon: Icon(Icons.clear, size: 18),
                              onPressed: _clearDateFilter,
                              constraints: BoxConstraints(
                                minWidth: 24,
                                minHeight: 24,
                              ),
                            ),
                          IconButton(
                            icon: Icon(Icons.calendar_today, size: 18),
                            onPressed: () => _selectDate(context),
                            constraints: BoxConstraints(
                              minWidth: 24,
                              minHeight: 24,
                            ),
                          ),
                        ],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                  ),
                ),
              ],
            ),
          ),

          // Filter Status (if any filter applied)
          if (_selectedDate != null || _searchController.text.isNotEmpty) ...[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.filter_alt, color: Colors.blue[600], size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Filter aktif: ${filteredData.length} dari ${rekamMedisData.length} data',
                      style: TextStyle(color: Colors.blue[800], fontSize: 13),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _dateController.clear();
                        _selectedDate = null;
                        filteredData = List.from(rekamMedisData);
                      });
                    },
                    child: Text(
                      'Reset',
                      style: TextStyle(color: Colors.blue[600], fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 8),

          // DataTable with scroll both axis
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2))
                ],
              ),
              child: filteredData.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                          SizedBox(height: 16),
                          Text(
                            'Tidak ada data yang sesuai',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Coba ubah kata kunci atau filter pencarian',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 32,
                          horizontalMargin: 24,
                          dataRowHeight: 140,
                          headingRowHeight: 56,
                          columns: [
                            DataColumn(label: Center(child: Text('No'))),
                            DataColumn(label: Center(child: Text('Foto'))),
                            DataColumn(label: Center(child: Text('No. RM'))),
                            DataColumn(label: Center(child: Text('Nama Lengkap'))),
                            DataColumn(label: Center(child: Text('Jenis Kelamin'))),
                            DataColumn(label: Center(child: Text('Tanggal Lahir'))),
                            DataColumn(label: Center(child: Text('No. Identitas'))),
                            DataColumn(label: Center(child: Text('No. Kartu BPJS'))),
                            DataColumn(label: Center(child: Text('No. Telp/HP'))),
                            DataColumn(label: Center(child: Text('Tgl. Terbit RM'))),
                            DataColumn(label: Center(child: Text('Aksi'))),
                          ],
                          rows: filteredData.map((item) {
                            return DataRow(cells: [
                              DataCell(Center(child: Text(item['no'].toString()))),
                              DataCell(
                                Center(
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey[400]!),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: item['foto'] != null
                                        ? Image.asset(
                                            item['foto'],
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(Icons.person,
                                            size: 50, color: Colors.grey[400]),
                                  ),
                                ),
                              ),
                              DataCell(Center(
                                child: Text(item['noRM'],
                                    style: TextStyle(
                                        color: Colors.blue[600],
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center),
                              )),
                              DataCell(Center(
                                child: Container(
                                    width: 180,
                                    child: Text(item['namaLengkap'],
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center)),
                              )),
                              DataCell(Center(
                                  child: Text(item['jenisKelamin'],
                                      textAlign: TextAlign.center))),
                              DataCell(Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(item['tanggalLahir'],
                                        textAlign: TextAlign.center),
                                    Text(item['umur'],
                                        style: TextStyle(
                                            fontSize: 11, color: Colors.blue[600]),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              )),
                              DataCell(Center(
                                child: Container(
                                    width: 140,
                                    child: Text(item['noIdentitas'],
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center)),
                              )),
                              DataCell(Center(
                                child: Container(
                                    width: 120,
                                    child: Text(item['noKartuBPJS'],
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center)),
                              )),
                              DataCell(Center(
                                child: Container(
                                    width: 120,
                                    child: Text(item['noTelpHP'],
                                        textAlign: TextAlign.center)),
                              )),
                              DataCell(Center(
                                  child: Text(item['tglTerbitRM'],
                                      textAlign: TextAlign.center))),
                              DataCell(
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RekamDetailPage(pasienData: item)),
                                      );
                                    },
                                    child: Text('Detail'),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue[600],
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8)),
                                  ),
                                ),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}