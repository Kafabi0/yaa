import 'package:flutter/material.dart';

class Patient {
  final int id;
  final String name;
  final String patientId;
  final String condition;
  final String room;
  final String roomNumber;
  final List<StatusItem> status;
  final String priority;
  final String lastCheck;
  
  Patient({
    required this.id,
    required this.name,
    required this.patientId,
    required this.condition,
    required this.room,
    required this.roomNumber,
    required this.status,
    required this.priority,
    required this.lastCheck,
  });
}

class StatusItem {
  final String label;
  final String value;
  final String type;
  
  StatusItem({required this.label, required this.value, required this.type});
}

class ErmPerawatScreen extends StatefulWidget {
  const ErmPerawatScreen({super.key});
  
  @override
  _ErmPerawatScreenState createState() => _ErmPerawatScreenState();
}

class _ErmPerawatScreenState extends State<ErmPerawatScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  String searchQuery = '';
  String? selectedDate;
  String? selectedUnit;
  int currentPage = 1;
  int patientsPerPage = 5;
  bool isRefreshing = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
  }
  
  // Extended patient data to 10 patients
  final List<Patient> patients = [
    Patient(
      id: 1,
      name: "Jasmin Testi",
      patientId: "RSUD-240801",
      condition: "stabil",
      room: "VIP",
      roomNumber: "201",
      status: [
        StatusItem(label: "Tekanan Darah", value: "Normal", type: "green"),
        StatusItem(label: "Suhu Tubuh", value: "36.5°C", type: "green"),
        StatusItem(label: "Saturasi O2", value: "98%", type: "green"),
      ],
      priority: "low",
      lastCheck: "2 jam lalu",
    ),
    Patient(
      id: 2,
      name: "NYIMAS SOFIYATI",
      patientId: "RSUD-240802",
      condition: "pemulihan",
      room: "Kelas 1",
      roomNumber: "105",
      status: [
        StatusItem(label: "Post Operasi", value: "Hari ke-2", type: "blue"),
        StatusItem(label: "Nyeri", value: "Skala 3/10", type: "yellow"),
        StatusItem(label: "Mobilisasi", value: "Terbatas", type: "yellow"),
      ],
      priority: "medium",
      lastCheck: "1 jam lalu",
    ),
    Patient(
      id: 3,
      name: "RUDI HARTONO",
      patientId: "RSUD-240803",
      condition: "stabil",
      room: "Kelas 2",
      roomNumber: "312",
      status: [
        StatusItem(label: "Kondisi Umum", value: "Baik", type: "green"),
        StatusItem(label: "Nafsu Makan", value: "Normal", type: "green"),
      ],
      priority: "low",
      lastCheck: "30 menit lalu",
    ),
    Patient(
      id: 4,
      name: "SITI AMINAH",
      patientId: "RSUD-240804",
      condition: "kritis",
      room: "ICU",
      roomNumber: "ICU-01",
      status: [
        StatusItem(label: "Ventilator", value: "Aktif", type: "red"),
        StatusItem(label: "Tekanan Darah", value: "Tinggi", type: "red"),
        StatusItem(label: "Kesadaran", value: "Menurun", type: "red"),
      ],
      priority: "high",
      lastCheck: "15 menit lalu",
    ),
    Patient(
      id: 5,
      name: "BUDI SANTOSO",
      patientId: "RSUD-240805",
      condition: "pemulihan",
      room: "Kelas 1",
      roomNumber: "208",
      status: [
        StatusItem(label: "Luka Operasi", value: "Sembuh", type: "green"),
        StatusItem(label: "Aktivitas", value: "Mandiri", type: "green"),
      ],
      priority: "low",
      lastCheck: "3 jam lalu",
    ),
    Patient(
      id: 6,
      name: "YEYE",
      patientId: "RSUD-240806",
      condition: "stabil",
      room: "VIP",
      roomNumber: "301",
      status: [
        StatusItem(label: "Kondisi Umum", value: "Stabil", type: "green"),
        StatusItem(label: "Obat-obatan", value: "Sesuai jadwal", type: "blue"),
      ],
      priority: "low",
      lastCheck: "45 menit lalu",
    ),
    Patient(
      id: 7,
      name: "DEWI SARTIKA",
      patientId: "RSUD-240807",
      condition: "pemulihan",
      room: "Kelas 3",
      roomNumber: "415",
      status: [
        StatusItem(label: "Observasi", value: "Ketat", type: "yellow"),
        StatusItem(label: "Cairan", value: "Seimbang", type: "green"),
      ],
      priority: "medium",
      lastCheck: "20 menit lalu",
    ),
    Patient(
      id: 8,
      name: "AGUS WIJAYA",
      patientId: "RSUD-240808",
      condition: "stabil",
      room: "Kelas 2",
      roomNumber: "220",
      status: [
        StatusItem(label: "Vital Sign", value: "Normal", type: "green"),
        StatusItem(label: "Mobilitas", value: "Baik", type: "green"),
      ],
      priority: "low",
      lastCheck: "1 jam lalu",
    ),
    Patient(
      id: 9,
      name: "MARIA GONZALES",
      patientId: "RSUD-240809",
      condition: "kritis",
      room: "ICU",
      roomNumber: "ICU-02",
      status: [
        StatusItem(label: "Infus", value: "Berjalan", type: "blue"),
        StatusItem(label: "Monitoring", value: "24 jam", type: "red"),
      ],
      priority: "high",
      lastCheck: "10 menit lalu",
    ),
    Patient(
      id: 10,
      name: "ANDI SETIAWAN",
      patientId: "RSUD-240810",
      condition: "stabil",
      room: "VIP",
      roomNumber: "102",
      status: [
        StatusItem(label: "Terapi", value: "Selesai", type: "green"),
        StatusItem(label: "Recovery", value: "95%", type: "green"),
      ],
      priority: "low",
      lastCheck: "2 jam lalu",
    ),
  ];
  
  void _refreshData() async {
    setState(() {
      isRefreshing = true;
    });
    
    // Scroll to top when refreshing
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
    
    // Simulate refresh delay
    await Future.delayed(Duration(seconds: 2));
    
    setState(() {
      isRefreshing = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data berhasil diperbarui'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
  
  List<Patient> get filteredPatients {
    return patients.where((patient) {
      bool matchesSearch = patient.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          patient.patientId.toLowerCase().contains(searchQuery.toLowerCase());
      
      return matchesSearch;
    }).toList();
  }
  
  List<Patient> get paginatedPatients {
    final filtered = filteredPatients;
    final startIndex = (currentPage - 1) * patientsPerPage;
    final endIndex = startIndex + patientsPerPage;
    
    if (startIndex >= filtered.length) return [];
    return filtered.sublist(startIndex, endIndex > filtered.length ? filtered.length : endIndex);
  }
  
  int get totalPages => (filteredPatients.length / patientsPerPage).ceil();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
          },
          icon: Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: Text(
          'Pasien Aktif',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: isRefreshing ? null : _refreshData,
            icon: isRefreshing
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(Icons.refresh, color: const Color.fromARGB(255, 1, 49, 162)),
            color: Colors.black,
          ),

          SizedBox(width: 16),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_hospital, size: 16),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Rawat Jalan',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hotel, size: 16),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Rawat Inap',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
          labelColor: Color(0xFF1E40AF),
          unselectedLabelColor: Colors.grey[600],
          indicatorColor:Color(0xFF1E40AF),
          indicatorWeight: 3,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabContent(),
          _buildTabContent(),
        ],
      ),
    );
  }
  
  Widget _buildTabContent() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSearchSection(),
          SizedBox(height: 20),
          _buildStatsCards(),
          SizedBox(height: 20),
          _buildPatientsGrid(),
          SizedBox(height: 20),
          _buildPagination(),
        ],
      ),
    );
  }
  
  Widget _buildSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search Data',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        // Search field - full width on mobile
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
                currentPage = 1;
              });
            },
            decoration: InputDecoration(
              hintText: 'Cari Nama/No.RM/No.Reg Pasien',
              hintStyle: TextStyle(color: Colors.grey[500]),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
            ),
          ),
        ),
        SizedBox(height: 12),
        // Filter fields - responsive layout
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              // Mobile layout - stacked vertically
              return Column(
                children: [
                  _buildDateDropdown(),
                  SizedBox(height: 12),
                  _buildUnitDropdown(),
                ],
              );
            } else {
              // Desktop layout - side by side
              return Row(
                children: [
                  Expanded(child: _buildDateDropdown()),
                  SizedBox(width: 12),
                  Expanded(child: _buildUnitDropdown()),
                ],
              );
            }
          },
        ),
      ],
    );
  }
  
  Widget _buildDateDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedDate,
        hint: Text('Tgl. Registrasi', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        items: [
          DropdownMenuItem(value: 'all', child: Text('Semua Tanggal')),
          DropdownMenuItem(value: 'today', child: Text('Hari Ini')),
          DropdownMenuItem(value: 'week', child: Text('Minggu Ini')),
        ],
        onChanged: (value) {
          setState(() {
            selectedDate = value;
            currentPage = 1;
          });
        },
      ),
    );
  }
  
  Widget _buildUnitDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedUnit,
        hint: Text('Pilih Unit Layanan', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        items: [
          DropdownMenuItem(value: 'all', child: Text('Semua Unit')),
          DropdownMenuItem(value: 'icu', child: Text('ICU')),
          DropdownMenuItem(value: 'vip', child: Text('VIP')),
          DropdownMenuItem(value: 'kelas', child: Text('Kelas')),
        ],
        onChanged: (value) {
          setState(() {
            selectedUnit = value;
            currentPage = 1;
          });
        },
      ),
    );
  }
  
  Widget _buildStatsCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile layout - 2x2 grid
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Pasien Seleksi',
                      '54',
                      Color(0xFF81C784),
                      Icons.people_outline,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Proses',
                      '42',
                      Color(0xFF4DB6AC),
                      Icons.schedule,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Belum Konfirmasi',
                      '340',
                      Color(0xFF90A4AE),
                      Icons.pending_actions,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Pasien Hari Ini',
                      '0',
                      Color(0xFF757575),
                      Icons.today,
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          // Desktop layout - single row
          return Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Pasien Seleksi',
                  '54',
                  Color(0xFF81C784),
                  Icons.people_outline,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Proses',
                  '42',
                  Color(0xFF4DB6AC),
                  Icons.schedule,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Belum Konfirmasi',
                  '340',
                  Color(0xFF90A4AE),
                  Icons.pending_actions,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Pasien Hari Ini',
                  '0',
                  Color(0xFF757575),
                  Icons.today,
                ),
              ),
            ],
          );
        }
      },
    );
  }
  
  Widget _buildStatCard(String title, String number, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Text(
            number,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPatientsGrid() {
    final displayedPatients = paginatedPatients;
    
    return Column(
      children: displayedPatients.map((patient) => _buildPatientCard(patient)).toList(),
    );
  }
  
  Widget _buildPatientCard(Patient patient) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            _buildPatientAvatar(patient.name),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '10544578000088055',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '00000089',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'undefined - undefined - /',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'NoN',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: Colors.red),
                      SizedBox(width: 6),
                      Text(
                        'Pasien belum datang',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildPatientNumber(patient),
          ],
        ),
      ),
    );
  }
  
 Widget _buildPatientAvatar(String name) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Icon(
        Icons.person,
        color: Colors.grey[500],
        size: 50,
      ),
    );
  }
  
  Widget _buildPatientNumber(Patient patient) {
    return Text(
      '${patient.id}',
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 58, // Font sangat besar
        fontWeight: FontWeight.w300, // Font weight lebih tipis seperti di gambar
        height: 1.0, // Line height untuk memastikan tidak ada spacing berlebih
      ),
    );
  }
  
  Widget _buildRoomInfo(Patient patient) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '${patient.room} - ${patient.roomNumber}',
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
  
  Widget _buildStatusList(List<StatusItem> statusItems) {
    return Column(
      children: statusItems.take(2).map((status) => _buildStatusItem(status)).toList(),
    );
  }
  
  Widget _buildStatusItem(StatusItem status) {
    Color dotColor;
    switch (status.type) {
      case 'green':
        dotColor = Color(0xFF27AE60);
        break;
      case 'yellow':
        dotColor = Color(0xFFF39C12);
        break;
      case 'red':
        dotColor = Color(0xFFE74C3C);
        break;
      case 'blue':
        dotColor = Color(0xFF3498DB);
        break;
      default:
        dotColor = Colors.grey;
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: dotColor,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              '${status.label}: ${status.value}',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF2C3E50),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildConditionChip(String condition) {
    Color color;
    String label;
    
    switch (condition) {
      case 'kritis':
        color = Color(0xFFE74C3C);
        label = 'Kritis';
        break;
      case 'pemulihan':
        color = Color(0xFFF39C12);
        label = 'Pemulihan';
        break;
      default:
        color = Color(0xFF27AE60);
        label = 'Stabil';
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            child: Text('Detail', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E40AF),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 0,
            ),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            child: Text('Edit', style: TextStyle(fontSize: 12)),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              padding: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              side: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildPagination() {
    if (totalPages <= 1) return SizedBox.shrink();
    
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lihat:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                    ),
                    child: DropdownButton<int>(
                      value: patientsPerPage,
                      underline: SizedBox.shrink(),
                      items: [5, 10, 15, 20].map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value', style: TextStyle(fontSize: 12)),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        setState(() {
                          patientsPerPage = newValue!;
                          currentPage = 1;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'data per halaman',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: currentPage > 1 ? () => setState(() => currentPage = 1) : null,
                    icon: Icon(Icons.first_page),
                    iconSize: 20,
                  ),
                  IconButton(
                    onPressed: currentPage > 1 ? () => setState(() => currentPage--) : null,
                    icon: Icon(Icons.chevron_left),
                    iconSize: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFF1E40AF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Hal $currentPage dari $totalPages',
                      style: TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.w500, 
                        fontSize: 12
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: currentPage < totalPages ? () => setState(() => currentPage++) : null,
                    icon: Icon(Icons.chevron_right),
                    iconSize: 20,
                  ),
                  IconButton(
                    onPressed: currentPage < totalPages ? () => setState(() => currentPage = totalPages) : null,
                    icon: Icon(Icons.last_page),
                    iconSize: 20,
                  ),
                ],
              ),
            ],
          );
        } else {
          // Desktop pagination - full layout
          return Row(
            children: [
              Text(
                'Lihat:',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
                child: DropdownButton<int>(
                  value: patientsPerPage,
                  underline: SizedBox.shrink(),
                  items: [5, 10, 15, 20].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value', style: TextStyle(fontSize: 12)),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      patientsPerPage = newValue!;
                      currentPage = 1;
                    });
                  },
                ),
              ),
              SizedBox(width: 8),
              Text(
                'data per halaman',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
              Spacer(),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: currentPage > 1 ? () => setState(() => currentPage = 1) : null,
                    child: Text('Awal', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size(0, 0),
                    ),
                  ),
                  SizedBox(width: 4),
                  OutlinedButton(
                    onPressed: currentPage > 1 ? () => setState(() => currentPage--) : null,
                    child: Text('<', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      minimumSize: Size(0, 0),
                    ),
                  ),
                  SizedBox(width: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF1E40AF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Halaman $currentPage dari $totalPages',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 11),
                    ),
                  ),
                  SizedBox(width: 4),
                  OutlinedButton(
                    onPressed: currentPage < totalPages ? () => setState(() => currentPage++) : null,
                    child: Text('>', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      minimumSize: Size(0, 0),
                    ),
                  ),
                  SizedBox(width: 4),
                  OutlinedButton(
                    onPressed: currentPage < totalPages ? () => setState(() => currentPage = totalPages) : null,
                    child: Text('Akhir', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size(0, 0),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}