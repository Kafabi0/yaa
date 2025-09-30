import 'package:flutter/material.dart';
import '../services/hospital_service.dart';
import '../models/hospital_model.dart';
import '../models/doctor_model.dart';

class DoctorSchedulePage extends StatefulWidget {
  final Hospital hospital;
  final String? doctorName;

  const DoctorSchedulePage({Key? key, required this.hospital, this.doctorName})
    : super(key: key);

  @override
  State<DoctorSchedulePage> createState() => _DoctorSchedulePageState();
}

class _DoctorSchedulePageState extends State<DoctorSchedulePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Filter variables
  String selectedSpecialty = 'Semua Spesialisasi';
  String selectedTime = 'Semua Waktu';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Data dokter berdasarkan rumah sakit
  List<Doctor> _doctors = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);

    // Ambil data dokter dari service
    _doctors = HospitalService.getDoctorsByHospital(widget.hospital.id);

    // Jika ada nama dokter yang diberikan, set sebagai query pencarian
    if (widget.doctorName != null && widget.doctorName!.isNotEmpty) {
      _searchController.text = widget.doctorName!;
      _searchQuery = widget.doctorName!;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<String> days = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  List<String> specialties = [
    'Semua Spesialisasi',
    'Penyakit Dalam',
    'Jantung',
    'Anak',
    'Bedah',
    'Kandungan',
    'Saraf',
    'Mata',
    'THT',
    'Kulit',
    'Jiwa',
    'Instalasi Gawat Darurat',
  ];

  List<String> timeSlots = [
    'Semua Waktu',
    'Pagi (07:00-12:00)',
    'Siang (12:00-17:00)',
    'Malam (17:00-22:00)',
  ];

  // Filter doctors based on selected criteria
  List<Doctor> getFilteredDoctors(String day) {
    return _doctors.where((doctor) {
      // Ambil jadwal hanya untuk hari yang dipilih
      final daySchedules = doctor.schedule.where((s) => s.day == day).toList();

      // Kalau tidak ada jadwal di hari tsb → langsung false
      if (daySchedules.isEmpty) return false;

      // Search by name
      bool matchesSearch =
          _searchQuery.isEmpty ||
          doctor.name.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesSpecialty =
          selectedSpecialty == 'Semua Spesialisasi' ||
          doctor.specialty.toLowerCase().contains(
            selectedSpecialty.toLowerCase(),
          );

      // Filter by time tapi hanya di jadwal hari yang dipilih
      bool matchesTime =
          selectedTime == 'Semua Waktu' ||
          (selectedTime == 'Pagi (07:00-12:00)' &&
              daySchedules.any(
                (s) =>
                    s.time.contains('07:') ||
                    s.time.contains('08:') ||
                    s.time.contains('09:') ||
                    s.time.contains('10:') ||
                    s.time.contains('11:'),
              )) ||
          (selectedTime == 'Siang (12:00-17:00)' &&
              daySchedules.any(
                (s) =>
                    s.time.contains('12:') ||
                    s.time.contains('13:') ||
                    s.time.contains('14:') ||
                    s.time.contains('15:') ||
                    s.time.contains('16:'),
              )) ||
          (selectedTime == 'Malam (17:00-22:00)' &&
              daySchedules.any(
                (s) =>
                    s.time.contains('17:') ||
                    s.time.contains('18:') ||
                    s.time.contains('19:') ||
                    s.time.contains('20:') ||
                    s.time.contains('21:'),
              )) ||
          daySchedules.any((s) => s.time.contains('24 Jam'));

      return matchesSearch && matchesSpecialty && matchesTime;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Color(0xFFFF6B35),
            elevation: 0,
            pinned: true,
            expandedHeight: 350,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Jadwal Lengkap Dokter Spesialis',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(background: _buildHospitalHeader()),
          ),

          // Tab Bar for Days
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: Color(0xFFFF6B35),
                labelColor: Color(0xFFFF6B35),
                unselectedLabelColor: Colors.grey,
                tabs: days.map((day) => Tab(text: day)).toList(),
              ),
            ),
          ),

          // Tab Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children:
                  days.map((day) {
                    List<Doctor> filteredDoctors = getFilteredDoctors(day);

                    return ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        // Status indicators
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              // Tersedia
                              Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Tersedia',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 16),
                              // Sibuk
                              Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Sibuk',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 16),
                              // Tidak Tersedia
                              Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Tidak Tersedia',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Filter Section
                        _buildFilterSection(),

                        // Results count
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16),
                          color: Colors.white,
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Color(0xFFFF6B35),
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Ditemukan ${filteredDoctors.length} dokter',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Doctor List
                        if (filteredDoctors.isEmpty)
                          Container(
                            height: 250,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 60,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Tidak ada dokter ditemukan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Coba ubah filter pencarian',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ...filteredDoctors.map(
                            (doctor) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: _buildDoctorCard(doctor, day),
                            ),
                          ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalHeader() {
    return Container(
      color: Color(0xFFFF6B35),
      padding: EdgeInsets.fromLTRB(16, 80, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hospital Image
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Image.asset(
                    widget.hospital.imagePath,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_hospital,
                                color: Colors.white,
                                size: 48,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Hospital Image',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.hospital.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 4,
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            SizedBox(width: 4),
                            Text(
                              '${widget.hospital.rating} (${widget.hospital.reviewCount} ulasan)',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Text(
                                widget.hospital.distance != null
                                    ? "${widget.hospital.distance!.toStringAsFixed(2)} km"
                                    : "0 km",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Jadwal Lengkap Dokter Spesialis',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Pencarian',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Pilih Spesialisasi',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedSpecialty,
                isExpanded: true,
                style: TextStyle(color: Colors.black87, fontSize: 14),
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSpecialty = newValue!;
                  });
                },
                items:
                    specialties.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Waktu Praktek',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedTime,
                isExpanded: true,
                style: TextStyle(color: Colors.black87, fontSize: 14),
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedTime = newValue!;
                  });
                },
                items:
                    timeSlots.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Cari Nama Dokter',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 6),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Masukkan nama dokter...',
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFFF6B35)),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doctor, String currentDay) {
    Color statusColor;
    if (doctor.status == 'Tersedia') {
      statusColor = Colors.green;
    } else if (doctor.status == 'Sibuk') {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.red;
    }

    // Filter jadwal hanya untuk hari yang sedang aktif
    final todaySchedules = doctor.schedule
        .where((s) => s.day == currentDay)
        .toList();

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        doctor.specialty,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFFF6B35),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    doctor.status,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.local_hospital, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    doctor.location,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    todaySchedules.isNotEmpty
                        ? todaySchedules
                            .map((s) => s.time)
                            .join(", ")
                        : "Tidak ada jadwal",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}