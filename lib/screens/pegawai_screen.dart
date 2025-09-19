import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class PegawaiScreen extends StatefulWidget {
  const PegawaiScreen({super.key});
  
  @override
  State<PegawaiScreen> createState() => _PegawaiScreenState();
}

class _PegawaiScreenState extends State<PegawaiScreen> {
  late CalendarController _medicalCalendarController;
  late CalendarController _nonMedicalCalendarController;
  
  // Filter states
  String selectedMedicalFilter = 'All';
  String selectedNonMedicalFilter = 'All';
  
  // Calendar view states
  CalendarView _medicalCalendarView = CalendarView.month;
  CalendarView _nonMedicalCalendarView = CalendarView.month;
  
  // Data statistik pegawai
  final Map<String, int> employeeStats = {
    'Dokter Spesialis': 9,
    'Dokter Umum': 5,
    'Perawat': 5,
    'Bidan': 5,
    'Apoteker': 5,
    'Staff': 5,
  };
  
  // Warna untuk setiap kategori
  final Map<String, Color> categoryColors = {
    'Dokter Spesialis': Color(0xFF1E40AF), // Biru tua
    'Dokter Umum': Color(0xFF3B82F6),      // Biru
    'Perawat': Color(0xFF10B981),          // Hijau
    'Bidan': Color(0xFF8B5CF6),           // Ungu
    'Apoteker': Color(0xFFF59E0B),        // Orange
    'Staff': Color(0xFFEC4899),           // Pink
  };
  
  // Data lengkap jadwal petugas medis berdasarkan kategori
  final Map<String, Map<DateTime, List<DoctorSchedule>>> medicalScheduleByCategory = {
    'Dokter Spesialis': {
      DateTime(2025, 9, 1): [
        DoctorSchedule(name: 'dr. MUHAMMAD SATRIA, Sp.B', specialty: 'BEDAH DIGESTIF', startTime: '07:30', endTime: '14:00', photoAsset: 'assets/dokter/doctor1.png'),
        DoctorSchedule(name: 'dr. Alfita Hilranti, Sp.KJ, M.MR', specialty: 'JIWA', startTime: '07:30', endTime: '12:00', photoAsset: 'assets/dokter/doctor7.jpg'),
      ],
      DateTime(2025, 9, 3): [
        DoctorSchedule(name: 'dr. YULISMA, Sp.OVG, FINSDV, FAADV', specialty: 'KULIT KELAMIN', startTime: '07:30', endTime: '12:00', photoAsset: 'assets/dokter/doctor3.png'),
        DoctorSchedule(name: 'dr. Mizar Erlanto, Sp.B(K)Onk', specialty: 'BEDAH ONKOLOGI', startTime: '07:30', endTime: '15:00', photoAsset: 'assets/dokter/dokterlaki.png'),
      ],
      DateTime(2025, 9, 5): [
        DoctorSchedule(name: 'dr. Ahmad Rahman, Sp.JP', specialty: 'JANTUNG', startTime: '08:00', endTime: '15:00', photoAsset: 'assets/dokter/dokterlaki1.jpg'),
        DoctorSchedule(name: 'dr. Siti Aminah, Sp.M', specialty: 'MATA', startTime: '08:00', endTime: '13:00', photoAsset: 'assets/dokter/dokterwanita.jpg'),
      ],
      DateTime(2025, 9, 9): [
        DoctorSchedule(name: 'dr. Fitri Handayani, Sp.Rad', specialty: 'RADIOLOGI', startTime: '08:00', endTime: '15:00', photoAsset: 'assets/dokter/doctor4.png'),
      ],
      DateTime(2025, 9, 15): [
        DoctorSchedule(name: 'dr. Hendra Wijaya, Sp.PD', specialty: 'DALAM', startTime: '07:30', endTime: '12:00', photoAsset: 'assets/dokter/doctor6.jpg'),
        DoctorSchedule(name: 'dr. Maya Indira, Sp.S', specialty: 'SARAF', startTime: '08:00', endTime: '14:00', photoAsset: 'assets/dokter/doctor5.png'),
      ],
    },
    'Dokter Umum': {
      DateTime(2025, 9, 2): [
        DoctorSchedule(name: 'dr. Budi Santoso', specialty: 'UMUM', startTime: '08:00', endTime: '16:00', photoAsset: ''),
        DoctorSchedule(name: 'dr. Lisa Permata', specialty: 'UMUM', startTime: '07:30', endTime: '15:30', photoAsset: ''),
      ],
      DateTime(2025, 9, 4): [
        DoctorSchedule(name: 'dr. Eko Purnomo', specialty: 'UMUM', startTime: '08:00', endTime: '16:00', photoAsset: ''),
      ],
      DateTime(2025, 9, 6): [
        DoctorSchedule(name: 'dr. Ratna Dewi', specialty: 'UMUM', startTime: '07:30', endTime: '15:30', photoAsset: ''),
        DoctorSchedule(name: 'dr. Agus Santoso', specialty: 'UMUM', startTime: '08:00', endTime: '16:00', photoAsset: ''),
      ],
      DateTime(2025, 9, 10): [
        DoctorSchedule(name: 'dr. Nanda Pratama', specialty: 'UMUM', startTime: '08:00', endTime: '16:00', photoAsset: ''),
      ],
      DateTime(2025, 9, 18): [
        DoctorSchedule(name: 'dr. Indah Sari', specialty: 'UMUM', startTime: '07:30', endTime: '15:30', photoAsset: ''),
        DoctorSchedule(name: 'dr. Yudi Pranata', specialty: 'UMUM', startTime: '08:00', endTime: '16:00', photoAsset: ''),
      ],
    },
    'Perawat': {
      DateTime(2025, 9, 1): [
        DoctorSchedule(name: 'Ns. Maria Gonzales', specialty: 'PERAWAT IGD', startTime: '07:00', endTime: '19:00', photoAsset: ''),
        DoctorSchedule(name: 'Ns. Siti Nurhaliza', specialty: 'PERAWAT RAWAT INAP', startTime: '19:00', endTime: '07:00', photoAsset: ''),
      ],
      DateTime(2025, 9, 7): [
        DoctorSchedule(name: 'Ns. Dewi Lestari', specialty: 'PERAWAT ICU', startTime: '07:00', endTime: '19:00', photoAsset: ''),
        DoctorSchedule(name: 'Ns. Rudi Hermawan', specialty: 'PERAWAT OK', startTime: '08:00', endTime: '16:00', photoAsset: ''),
      ],
      DateTime(2025, 9, 12): [
        DoctorSchedule(name: 'Ns. Fitri Handayani', specialty: 'PERAWAT ANAK', startTime: '07:00', endTime: '19:00', photoAsset: ''),
        DoctorSchedule(name: 'Ns. Bambang Susilo', specialty: 'PERAWAT JIWA', startTime: '19:00', endTime: '07:00', photoAsset: ''),
      ],
      DateTime(2025, 9, 20): [
        DoctorSchedule(name: 'Ns. Rina Marlina', specialty: 'PERAWAT BEDAH', startTime: '07:00', endTime: '19:00', photoAsset: ''),
        DoctorSchedule(name: 'Ns. Hendra Kusuma', specialty: 'PERAWAT POLI', startTime: '08:00', endTime: '16:00', photoAsset: ''),
      ],
    },
    'Bidan': {
      DateTime(2025, 9, 4): [
        DoctorSchedule(name: 'Bd. Lina Kartini', specialty: 'BIDAN VK', startTime: '07:00', endTime: '19:00', photoAsset: ''),
      ],
      DateTime(2025, 9, 6): [
        DoctorSchedule(name: 'Bd. Maya Sari', specialty: 'BIDAN POLI KIA', startTime: '08:00', endTime: '16:00', photoAsset: ''),
        DoctorSchedule(name: 'Bd. Dian Permata', specialty: 'BIDAN NIFAS', startTime: '19:00', endTime: '07:00', photoAsset: ''),
      ],
      DateTime(2025, 9, 10): [
        DoctorSchedule(name: 'Bd. Agung Nugroho', specialty: 'BIDAN KB', startTime: '08:00', endTime: '16:00', photoAsset: ''),
      ],
      DateTime(2025, 9, 15): [
        DoctorSchedule(name: 'Bd. Yanto Pratama', specialty: 'BIDAN PERSALINAN', startTime: '07:00', endTime: '19:00', photoAsset: ''),
      ],
    },
  };
  
  // Data jadwal petugas non medis berdasarkan kategori
  final Map<String, Map<DateTime, List<StaffSchedule>>> nonMedicalScheduleByCategory = {
    'Apoteker': {
      DateTime(2025, 9, 1): [
        StaffSchedule(name: 'Ahmad Suryadi', position: 'Apoteker', startTime: '08:00', endTime: '16:00', photoAsset: ''),
      ],
      DateTime(2025, 9, 3): [
        StaffSchedule(name: 'Maria Gonzales', position: 'Apoteker', startTime: '08:00', endTime: '16:00', photoAsset: ''),
        StaffSchedule(name: 'Dewi Lestari', position: 'Apoteker', startTime: '16:00', endTime: '24:00', photoAsset: ''),
      ],
      DateTime(2025, 9, 7): [
        StaffSchedule(name: 'Rina Marlina', position: 'Apoteker', startTime: '08:00', endTime: '16:00', photoAsset: ''),
      ],
      DateTime(2025, 9, 12): [
        StaffSchedule(name: 'Agung Nugroho', position: 'Apoteker', startTime: '08:00', endTime: '16:00', photoAsset: ''),
        StaffSchedule(name: 'Fitri Handayani', position: 'Apoteker', startTime: '16:00', endTime: '24:00', photoAsset: ''),
      ],
      DateTime(2025, 9, 18): [
        StaffSchedule(name: 'Hendra Kusuma', position: 'Apoteker', startTime: '08:00', endTime: '16:00', photoAsset: ''),
      ],
    },
    'Staff': {
      DateTime(2025, 9, 2): [
        StaffSchedule(name: 'Siti Nurhaliza', position: 'Admin', startTime: '07:30', endTime: '15:30', photoAsset: ''),
        StaffSchedule(name: 'Indra Wijaya', position: 'Teknisi', startTime: '08:00', endTime: '16:00', photoAsset: ''),
      ],
      DateTime(2025, 9, 5): [
        StaffSchedule(name: 'Budi Santoso', position: 'Security', startTime: '06:00', endTime: '18:00', photoAsset: ''),
        StaffSchedule(name: 'Anita Sari', position: 'Cleaning Service', startTime: '06:00', endTime: '14:00', photoAsset: ''),
      ],
      DateTime(2025, 9, 10): [
        StaffSchedule(name: 'Yanto Pratama', position: 'IT Support', startTime: '08:00', endTime: '17:00', photoAsset: ''),
        StaffSchedule(name: 'Lina Kartini', position: 'Admin', startTime: '07:30', endTime: '15:30', photoAsset: ''),
      ],
      DateTime(2025, 9, 15): [
        StaffSchedule(name: 'Maya Sari', position: 'Nutritionist', startTime: '08:00', endTime: '15:00', photoAsset: ''),
        StaffSchedule(name: 'Dian Permata', position: 'Admin', startTime: '07:30', endTime: '15:30', photoAsset: ''),
      ],
      DateTime(2025, 9, 20): [
        StaffSchedule(name: 'Bambang Susilo', position: 'Maintenance', startTime: '08:00', endTime: '16:00', photoAsset: ''),
        StaffSchedule(name: 'Rudi Hermawan', position: 'Driver', startTime: '07:00', endTime: '15:00', photoAsset: ''),
      ],
    },
  };
  
  @override
  void initState() {
    super.initState();
    _medicalCalendarController = CalendarController();
    _nonMedicalCalendarController = CalendarController();
    _medicalCalendarController.displayDate = DateTime(2025, 9);
    _nonMedicalCalendarController.displayDate = DateTime(2025, 9);
  }
  
  // Generate appointments berdasarkan filter
  List<Meeting> _generateFilteredAppointments(Map<String, Map<DateTime, List<dynamic>>> scheduleByCategory, String selectedFilter) {
    List<Meeting> appointments = [];
    
    if (selectedFilter == 'All') {
      // Gabungkan semua kategori
      scheduleByCategory.forEach((category, scheduleMap) {
        scheduleMap.forEach((date, schedules) {
          appointments.add(Meeting(
            eventName: '${schedules.length} Jadwal',
            from: date,
            to: date,
            background: categoryColors[category]!,
            category: category,
          ));
        });
      });
    } else {
      // Hanya kategori yang dipilih
      if (scheduleByCategory.containsKey(selectedFilter)) {
        scheduleByCategory[selectedFilter]!.forEach((date, schedules) {
          appointments.add(Meeting(
            eventName: '${schedules.length} Jadwal',
            from: date,
            to: date,
            background: categoryColors[selectedFilter]!,
            category: selectedFilter,
          ));
        });
      }
    }
    
    return appointments;
  }
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text(
            'Kepegawaian Homepage',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          backgroundColor: const Color(0xFF1E40AF),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Kepegawaian Homepage'),
              Tab(text: 'Rekap Absensi'),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontSize: 12),
          ),
        ),
        body: TabBarView(
          children: [
            _buildKepegawaianTab(),
            _buildRekapAbsensiTab(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildKepegawaianTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Employee Stats Grid
          const Text(
            'Statistik Pegawai',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.1,
            ),
            itemCount: employeeStats.length,
            itemBuilder: (context, index) {
              final role = employeeStats.keys.elementAt(index);
              final count = employeeStats.values.elementAt(index);
              return _buildEmployeeCard(role, count);
            },
          ),
          
          const SizedBox(height: 16),
          
          // Medical Staff Schedule
          const Text(
            'Jadwal Petugas Medis',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          
          _buildScheduleCard(
            title: 'Jadwal Petugas Medis',
            appointments: _generateFilteredAppointments(medicalScheduleByCategory, selectedMedicalFilter),
            accentColor: const Color(0xFF1E40AF),
            staffTypes: const ['Dokter Spesialis', 'Dokter Umum', 'Perawat', 'Bidan'],
            controller: _medicalCalendarController,
            scheduleDetails: _getFilteredScheduleDetails(medicalScheduleByCategory, selectedMedicalFilter),
            isMedical: true,
            selectedFilter: selectedMedicalFilter,
            onFilterChanged: (filter) {
              setState(() {
                selectedMedicalFilter = filter;
              });
            },
            calendarView: _medicalCalendarView,
            onViewChanged: (view) {
              setState(() {
                _medicalCalendarView = view;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          // Non-Medical Staff Schedule
          const Text(
            'Jadwal Petugas Non Medis',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          
          _buildScheduleCard(
            title: 'Jadwal Petugas Non Medis',
            appointments: _generateFilteredAppointments(nonMedicalScheduleByCategory, selectedNonMedicalFilter),
            accentColor: const Color(0xFF059669), // Tetap hijau untuk non-medis secara umum
            staffTypes: const ['Apoteker', 'Staff'],
            controller: _nonMedicalCalendarController,
            scheduleDetails: _getFilteredScheduleDetails(nonMedicalScheduleByCategory, selectedNonMedicalFilter),
            isMedical: false,
            selectedFilter: selectedNonMedicalFilter,
            onFilterChanged: (filter) {
              setState(() {
                selectedNonMedicalFilter = filter;
              });
            },
            calendarView: _nonMedicalCalendarView,
            onViewChanged: (view) {
              setState(() {
                _nonMedicalCalendarView = view;
              });
            },
          ),
        ],
      ),
    );
  }
  
  Map<DateTime, List<dynamic>> _getFilteredScheduleDetails(Map<String, Map<DateTime, List<dynamic>>> scheduleByCategory, String selectedFilter) {
    Map<DateTime, List<dynamic>> filteredDetails = {};
    
    if (selectedFilter == 'All') {
      scheduleByCategory.forEach((category, scheduleMap) {
        scheduleMap.forEach((date, schedules) {
          if (filteredDetails.containsKey(date)) {
            // Tambahkan informasi kategori ke setiap item jadwal
            List<dynamic> categorizedSchedules = schedules.map((schedule) {
              if (schedule is DoctorSchedule) {
                return CategorizedDoctorSchedule(
                  name: schedule.name,
                  specialty: schedule.specialty,
                  startTime: schedule.startTime,
                  endTime: schedule.endTime,
                  category: category,
                  photoAsset: schedule.photoAsset,
                );
              } else if (schedule is StaffSchedule) {
                return CategorizedStaffSchedule(
                  name: schedule.name,
                  position: schedule.position,
                  startTime: schedule.startTime,
                  endTime: schedule.endTime,
                  category: category,
                  photoAsset: schedule.photoAsset,
                );
              }
              return schedule;
            }).toList();
            
            filteredDetails[date]!.addAll(categorizedSchedules);
          } else {
            // Tambahkan informasi kategori ke setiap item jadwal
            List<dynamic> categorizedSchedules = schedules.map((schedule) {
              if (schedule is DoctorSchedule) {
                return CategorizedDoctorSchedule(
                  name: schedule.name,
                  specialty: schedule.specialty,
                  startTime: schedule.startTime,
                  endTime: schedule.endTime,
                  category: category,
                  photoAsset: schedule.photoAsset,
                );
              } else if (schedule is StaffSchedule) {
                return CategorizedStaffSchedule(
                  name: schedule.name,
                  position: schedule.position,
                  startTime: schedule.startTime,
                  endTime: schedule.endTime,
                  category: category,
                  photoAsset: schedule.photoAsset,
                );
              }
              return schedule;
            }).toList();
            
            filteredDetails[date] = categorizedSchedules;
          }
        });
      });
    } else {
      if (scheduleByCategory.containsKey(selectedFilter)) {
        // Tambahkan informasi kategori ke setiap item jadwal
        Map<DateTime, List<dynamic>> categorizedMap = {};
        scheduleByCategory[selectedFilter]!.forEach((date, schedules) {
          List<dynamic> categorizedSchedules = schedules.map((schedule) {
            if (schedule is DoctorSchedule) {
              return CategorizedDoctorSchedule(
                name: schedule.name,
                specialty: schedule.specialty,
                startTime: schedule.startTime,
                endTime: schedule.endTime,
                category: selectedFilter,
                photoAsset: schedule.photoAsset,
              );
            } else if (schedule is StaffSchedule) {
              return CategorizedStaffSchedule(
                name: schedule.name,
                position: schedule.position,
                startTime: schedule.startTime,
                endTime: schedule.endTime,
                category: selectedFilter,
                photoAsset: schedule.photoAsset,
              );
            }
            return schedule;
          }).toList();
          
          categorizedMap[date] = categorizedSchedules;
        });
        
        filteredDetails = categorizedMap;
      }
    }
    
    return filteredDetails;
  }
  
  void _showScheduleDetail(DateTime date, List<dynamic> schedules, bool isMedical) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Enhanced Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      isMedical ? const Color(0xFF1E40AF) : const Color(0xFF059669),
                      isMedical ? const Color(0xFF2563EB) : const Color(0xFF10B981),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isMedical ? Icons.medical_services : Icons.work,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isMedical ? 'Jadwal Petugas Medis' : 'Jadwal Petugas Non-Medis',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.white.withOpacity(0.8),
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${schedules.length} Jadwal',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Responsive Content Area
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Determine if we need horizontal scroll based on screen width
                    bool needsHorizontalScroll = constraints.maxWidth < 800;
                    double tableWidth = needsHorizontalScroll ? 900 : constraints.maxWidth;
                    
                    return Column(
                      children: [
                        // Mobile-friendly header with scroll hint
                        if (needsHorizontalScroll)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.orange[50],
                              border: Border(
                                bottom: BorderSide(color: Colors.orange[200]!),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.swipe,
                                  size: 18,
                                  color: Colors.orange[600],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Geser ke samping untuk melihat detail lengkap',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.orange[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        
                        // Enhanced Table Header
                        Container(
                          width: double.infinity,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              width: tableWidth,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.grey[100]!, Colors.grey[50]!],
                                ),
                              ),
                              child: Row(
                                children: [
                                  _buildHeaderCell('No', 60, true),
                                  _buildHeaderCell('Status', 70, true),
                                  _buildHeaderCell('Foto', 100, true),
                                  _buildHeaderCell(
                                    isMedical ? 'Nama Dokter/Perawat' : 'Nama Staff',
                                    needsHorizontalScroll ? 200 : (tableWidth - 530) * 0.4,
                                    false,
                                  ),
                                  _buildHeaderCell(
                                    isMedical ? 'Spesialisasi/Unit' : 'Posisi/Departemen',
                                    needsHorizontalScroll ? 180 : (tableWidth - 530) * 0.35,
                                    false,
                                  ),
                                  _buildHeaderCell('Jam Mulai', 100, true),
                                  _buildHeaderCell('Jam Selesai', 100, true),
                                  _buildHeaderCell('Aksi', 80, true),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        // Enhanced Table Content
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              width: tableWidth,
                              child: ListView.separated(
                                itemCount: schedules.length,
                                separatorBuilder: (context, index) => Divider(
                                  height: 1,
                                  color: Colors.grey[200],
                                ),
                                itemBuilder: (context, index) {
                                  dynamic schedule = schedules[index];
                                  
                                  // Get category info
                                  String category = '';
                                  Color categoryColor = Colors.grey;
                                  String photoAsset = '';
                                  
                                  if (schedule is CategorizedDoctorSchedule) {
                                    category = schedule.category;
                                    categoryColor = _getCategoryColor(category);
                                    photoAsset = schedule.photoAsset;
                                  } else if (schedule is CategorizedStaffSchedule) {
                                    category = schedule.category;
                                    categoryColor = _getCategoryColor(category);
                                    photoAsset = schedule.photoAsset;
                                  }
                                  
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: index.isEven ? Colors.white : Colors.grey[25],
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey[100]!,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                        _navigateToDetail(schedule, category, isMedical, photoAsset);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                                        child: Row(
                                          children: [
                                            // Number
                                            _buildDataCell(
                                              '${index + 1}',
                                              60,
                                              true,
                                              const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                              ),
                                            ),
                                            
                                            // Status indicator
                                            _buildDataCell(
                                              '',
                                              70,
                                              true,
                                              null,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 12,
                                                    height: 12,
                                                    decoration: BoxDecoration(
                                                      color: categoryColor,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.green[500],
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: const Text(
                                                      'Aktif',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 8,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            
                                            // Photo
                                            _buildDataCell(
                                              '',
                                              100,
                                              true,
                                              null,
                                              child: _buildPhotoWidget(photoAsset, schedule.name, categoryColor),
                                            ),
                                            
                                            // Name
                                            _buildDataCell(
                                              schedule.name,
                                              needsHorizontalScroll ? 200 : (tableWidth - 530) * 0.4,
                                              false,
                                              const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: Color(0xFF111827),
                                              ),
                                            ),
                                            
                                            // Specialty/Position
                                            _buildDataCell(
                                              isMedical 
                                                ? (schedule as CategorizedDoctorSchedule).specialty 
                                                : (schedule as CategorizedStaffSchedule).position,
                                              needsHorizontalScroll ? 180 : (tableWidth - 530) * 0.35,
                                              false,
                                              TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            
                                            // Start time
                                            _buildDataCell(
                                              schedule.startTime,
                                              100,
                                              true,
                                              const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF059669),
                                                fontSize: 13,
                                              ),
                                            ),
                                            
                                            // End time
                                            _buildDataCell(
                                              schedule.endTime,
                                              100,
                                              true,
                                              const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFFDC2626),
                                                fontSize: 13,
                                              ),
                                            ),
                                            
                                            // Action button
                                            _buildDataCell(
                                              '',
                                              80,
                                              true,
                                              null,
                                              child: Material(
                                                color: categoryColor,
                                                borderRadius: BorderRadius.circular(8),
                                                child: InkWell(
                                                  borderRadius: BorderRadius.circular(8),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    _navigateToDetail(schedule, category, isMedical, photoAsset);
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                    child: const Text(
                                                      'Detail',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        
                        // Enhanced Footer
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              if (needsHorizontalScroll)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.touch_app,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Tap pada baris untuk melihat detail lengkap',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              if (needsHorizontalScroll) const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isMedical 
                                        ? const Color(0xFF1E40AF).withOpacity(0.1)
                                        : const Color(0xFF059669).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Total: ${schedules.length} jadwal hari ini',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isMedical 
                                          ? const Color(0xFF1E40AF)
                                          : const Color(0xFF059669),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
  
  Widget _buildHeaderCell(String title, double width, bool isCenter) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Color(0xFF374151),
        ),
        textAlign: isCenter ? TextAlign.center : TextAlign.left,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
  
  // Helper method untuk membuat data cell
  Widget _buildDataCell(
    String text,
    double width,
    bool isCenter,
    TextStyle? style, {
    Widget? child,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: child ?? Text(
        text,
        style: style ?? const TextStyle(fontSize: 13),
        textAlign: isCenter ? TextAlign.center : TextAlign.left,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
  
  // Helper method untuk membuat photo widget
  Widget _buildPhotoWidget(String photoAsset, String name, Color categoryColor) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: categoryColor.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: photoAsset.isNotEmpty
            ? Image.asset(
                photoAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildInitialsWidget(name, categoryColor);
                },
              )
            : _buildInitialsWidget(name, categoryColor),
      ),
    );
  }
  
  // Helper method untuk membuat initials widget
  Widget _buildInitialsWidget(String name, Color categoryColor) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            categoryColor.withOpacity(0.1),
            categoryColor.withOpacity(0.05),
          ],
        ),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: TextStyle(
            color: categoryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
  
  // Helper method untuk mendapatkan warna kategori
  Color _getCategoryColor(String category) {
    const Map<String, Color> categoryColors = {
      'Dokter Spesialis': Color(0xFF2563EB),
      'Dokter Umum': Color(0xFF3B82F6),
      'Perawat': Color(0xFF10B981),
      'Bidan': Color(0xFF8B5CF6),
      'Apoteker': Color(0xFFF59E0B),
      'Staff': Color(0xFFEC4899),
    };
    return categoryColors[category] ?? const Color(0xFF64748B);
  }
  
  // Helper method untuk navigasi ke detail
  void _navigateToDetail(dynamic schedule, String category, bool isMedical, String photoAsset) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorDetailScreen(
          name: schedule.name,
          specialty: isMedical 
            ? (schedule as CategorizedDoctorSchedule).specialty 
            : (schedule as CategorizedStaffSchedule).position,
          category: category,
          isMedical: isMedical,
          photoAsset: photoAsset,
        ),
      ),
    );
  }
  
  Widget _buildEmployeeCard(String role, int count) {
    Color cardColor = categoryColors[role] ?? const Color(0xFF64748B);
    IconData icon;
    
    switch (role) {
      case 'Dokter Spesialis':
        icon = Icons.medical_services;
        break;
      case 'Dokter Umum':
        icon = Icons.person;
        break;
      case 'Perawat':
        icon = Icons.health_and_safety;
        break;
      case 'Bidan':
        icon = Icons.pregnant_woman;
        break;
      case 'Apoteker':
        icon = Icons.medication;
        break;
      default:
        icon = Icons.groups;
    }
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PegawaiDoctorScreen(
              category: role,
              color: cardColor,
              icon: icon,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: cardColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: cardColor,
                size: 20,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              role,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              '$count Orang',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: cardColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildScheduleCard({
    required String title,
    required List<Meeting> appointments,
    required Color accentColor,
    required List<String> staffTypes,
    required CalendarController controller,
    required Map<DateTime, List<dynamic>> scheduleDetails,
    required bool isMedical,
    required String selectedFilter,
    required Function(String) onFilterChanged,
    required CalendarView calendarView,
    required Function(CalendarView) onViewChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                GestureDetector(
                  onTap: () => onFilterChanged('All'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: selectedFilter == 'All' ? accentColor : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'All',
                      style: TextStyle(
                        color: selectedFilter == 'All' ? Colors.white : Colors.grey[700],
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                ...staffTypes.map((type) {
                  Color chipColor = categoryColors[type]!;
                  bool isSelected = selectedFilter == type;
                  
                  return GestureDetector(
                    onTap: () => onFilterChanged(type),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? chipColor : chipColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected ? null : Border.all(color: chipColor, width: 1),
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                          color: isSelected ? Colors.white : chipColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ].toList(),
            ),
          ),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      controller.backward!();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.chevron_left,
                      color: accentColor,
                      size: 18,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      controller.displayDate = DateTime.now();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Today',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => onViewChanged(CalendarView.month),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: calendarView == CalendarView.month ? accentColor : Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Month',
                          style: TextStyle(
                            color: calendarView == CalendarView.month ? Colors.white : Colors.grey[600],
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => onViewChanged(CalendarView.week),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: calendarView == CalendarView.week ? accentColor : Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Week',
                          style: TextStyle(
                            color: calendarView == CalendarView.week ? Colors.white : Colors.grey[600],
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      controller.forward!();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.chevron_right,
                      color: accentColor,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(
            height: 550,
            child: SfCalendar(
              controller: controller,
              view: calendarView,
              initialDisplayDate: DateTime(2025, 9),
              dataSource: MeetingDataSource(appointments),
              showNavigationArrow: false,
              showDatePickerButton: false,
              onTap: (CalendarTapDetails details) {
                if (details.targetElement == CalendarElement.calendarCell) {
                  final DateTime selectedDate = details.date!;
                  
                  if (scheduleDetails.containsKey(selectedDate)) {
                    _showScheduleDetail(selectedDate, scheduleDetails[selectedDate]!, isMedical);
                  }
                }
              },
              monthViewSettings: MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                showAgenda: false,
                dayFormat: 'EEE',
                appointmentDisplayCount: 4,
                monthCellStyle: MonthCellStyle(
                  backgroundColor: Colors.transparent,
                  todayBackgroundColor: Colors.transparent,
                  todayTextStyle: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textStyle: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                  trailingDatesTextStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                  leadingDatesTextStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                ),
              ),
              timeSlotViewSettings: TimeSlotViewSettings(
                startHour: 6,
                endHour: 20,
                timeInterval: Duration(minutes: 30),
                timeFormat: 'HH:mm',
                timeTextStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
              headerStyle: const CalendarHeaderStyle(
                textAlign: TextAlign.center,
                backgroundColor: Colors.transparent,
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              viewHeaderStyle: ViewHeaderStyle(
                backgroundColor: Colors.grey[100],
                dayTextStyle: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                dateTextStyle: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              appointmentBuilder: (context, calendarAppointmentDetails) {
                final Meeting meeting = calendarAppointmentDetails.appointments.first;
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: meeting.background,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    meeting.eventName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                );
              },
              cellBorderColor: Colors.grey[300],
              todayHighlightColor: accentColor.withOpacity(0.2),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
  
  Widget _buildRekapAbsensiTab() {
    return const Center(
      child: Text(
        'Rekap Absensi',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Doctor List Screen
class PegawaiDoctorScreen extends StatelessWidget {
  final String category;
  final Color color;
  final IconData icon;
  
  const PegawaiDoctorScreen({
    Key? key,
    required this.category,
    required this.color,
    required this.icon,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Sample doctor data based on category
    List<Map<String, dynamic>> doctorList = [];
    if (category == 'Dokter Spesialis') {
      doctorList = [
        {'name': 'dr. MUHAMMAD SATRIA, Sp.B', 'specialty': 'BEDAH DIGESTIF', 'nik': '1234567890', 'gender': 'Laki-laki', 'title': 'Sp.B', 'email': 'satria@hospital.com', 'phone': '081234567890', 'photoAsset': 'assets/dokter/doctor1.png'},
        {'name': 'dr. Alfita Hilranti, Sp.KJ, M.MR', 'specialty': 'JIWA', 'nik': '1234567891', 'gender': 'Laki-laki', 'title': 'Sp.KJ', 'email': 'alfita@hospital.com', 'phone': '081234567891', 'photoAsset': 'assets/dokter/doctor7.jpg'},
        {'name': 'dr. YULISMA, Sp.OVG, FINSDV, FAADV', 'specialty': 'KULIT KELAMIN', 'nik': '1234567892', 'gender': 'Laki-laki', 'title': 'Sp.OVG', 'email': 'yulisma@hospital.com', 'phone': '081234567892', 'photoAsset': 'assets/dokter/doctor3.png'},
        {'name': 'dr. Mizar Erlanto, Sp.B(K)Onk', 'specialty': 'BEDAH ONKOLOGI', 'nik': '1234567893', 'gender': 'Laki-laki', 'title': 'Sp.B(K)Onk', 'email': 'mizar@hospital.com', 'phone': '081234567893', 'photoAsset': 'assets/dokter/dokterlaki.png'},
        {'name': 'dr. Ahmad Rahman, Sp.JP', 'specialty': 'JANTUNG', 'nik': '1234567894', 'gender': 'Laki-laki', 'title': 'Sp.JP', 'email': 'ahmad@hospital.com', 'phone': '081234567894', 'photoAsset': 'assets/dokter/dokterlaki1.jpg'},
        {'name': 'dr. Siti Aminah, Sp.M', 'specialty': 'MATA', 'nik': '1234567895', 'gender': 'Perempuan', 'title': 'Sp.M', 'email': 'siti@hospital.com', 'phone': '081234567895', 'photoAsset': 'assets/dokter/dokterwanita.jpg'},
        {'name': 'dr. Fitri Handayani, Sp.Rad', 'specialty': 'RADIOLOGI', 'nik': '1234567896', 'gender': 'Perempuan', 'title': 'Sp.Rad', 'email': 'fitri@hospital.com', 'phone': '081234567896', 'photoAsset': 'assets/dokter/doctor4.png'},
        {'name': 'dr. Hendra Wijaya, Sp.PD', 'specialty': 'DALAM', 'nik': '1234567897', 'gender': 'Laki-laki', 'title': 'Sp.PD', 'email': 'hendra@hospital.com', 'phone': '081234567897', 'photoAsset': 'assets/dokter/doctor6.jpg'},
        {'name': 'dr. Maya Indira, Sp.S', 'specialty': 'SARAF', 'nik': '1234567898', 'gender': 'Perempuan', 'title': 'Sp.S', 'email': 'maya@hospital.com', 'phone': '081234567898', 'photoAsset': 'assets/dokter/doctor5.png'},
      ];
    } else if (category == 'Dokter Umum') {
      doctorList = [
        {'name': 'dr. Budi Santoso', 'specialty': 'UMUM', 'nik': '2234567890', 'gender': 'Laki-laki', 'title': 'dr.', 'email': 'budi@hospital.com', 'phone': '082234567890', 'photoAsset': ''},
        {'name': 'dr. Lisa Permata', 'specialty': 'UMUM', 'nik': '2234567891', 'gender': 'Perempuan', 'title': 'dr.', 'email': 'lisa@hospital.com', 'phone': '082234567891', 'photoAsset': ''},
        {'name': 'dr. Eko Purnomo', 'specialty': 'UMUM', 'nik': '2234567892', 'gender': 'Laki-laki', 'title': 'dr.', 'email': 'eko@hospital.com', 'phone': '082234567892', 'photoAsset': ''},
        {'name': 'dr. Ratna Dewi', 'specialty': 'UMUM', 'nik': '2234567893', 'gender': 'Perempuan', 'title': 'dr.', 'email': 'ratna@hospital.com', 'phone': '082234567893', 'photoAsset': ''},
        {'name': 'dr. Agus Santoso', 'specialty': 'UMUM', 'nik': '2234567894', 'gender': 'Laki-laki', 'title': 'dr.', 'email': 'agus@hospital.com', 'phone': '082234567894', 'photoAsset': ''},
      ];
    } else if (category == 'Perawat') {
      doctorList = [
        {'name': 'Ns. Maria Gonzales', 'specialty': 'PERAWAT IGD', 'nik': '3234567890', 'gender': 'Perempuan', 'title': 'Ns.', 'email': 'maria@hospital.com', 'phone': '083234567890', 'photoAsset': ''},
        {'name': 'Ns. Siti Nurhaliza', 'specialty': 'PERAWAT RAWAT INAP', 'nik': '3234567891', 'gender': 'Perempuan', 'title': 'Ns.', 'email': 'siti@hospital.com', 'phone': '083234567891', 'photoAsset': ''},
        {'name': 'Ns. Dewi Lestari', 'specialty': 'PERAWAT ICU', 'nik': '3234567892', 'gender': 'Perempuan', 'title': 'Ns.', 'email': 'dewi@hospital.com', 'phone': '083234567892', 'photoAsset': ''},
        {'name': 'Ns. Rudi Hermawan', 'specialty': 'PERAWAT OK', 'nik': '3234567893', 'gender': 'Laki-laki', 'title': 'Ns.', 'email': 'rudi@hospital.com', 'phone': '083234567893', 'photoAsset': ''},
        {'name': 'Ns. Fitri Handayani', 'specialty': 'PERAWAT ANAK', 'nik': '3234567894', 'gender': 'Perempuan', 'title': 'Ns.', 'email': 'fitri@hospital.com', 'phone': '083234567894', 'photoAsset': ''},
      ];
    } else if (category == 'Bidan') {
      doctorList = [
        {'name': 'Bd. Lina Kartini', 'specialty': 'BIDAN VK', 'nik': '4234567890', 'gender': 'Perempuan', 'title': 'Bd.', 'email': 'lina@hospital.com', 'phone': '084234567890', 'photoAsset': ''},
        {'name': 'Bd. Maya Sari', 'specialty': 'BIDAN POLI KIA', 'nik': '4234567891', 'gender': 'Perempuan', 'title': 'Bd.', 'email': 'maya@hospital.com', 'phone': '084234567891', 'photoAsset': ''},
        {'name': 'Bd. Dian Permata', 'specialty': 'BIDAN NIFAS', 'nik': '4234567892', 'gender': 'Perempuan', 'title': 'Bd.', 'email': 'dian@hospital.com', 'phone': '084234567892', 'photoAsset': ''},
        {'name': 'Bd. Agung Nugroho', 'specialty': 'BIDAN KB', 'nik': '4234567893', 'gender': 'Laki-laki', 'title': 'Bd.', 'email': 'agung@hospital.com', 'phone': '084234567893', 'photoAsset': ''},
        {'name': 'Bd. Yanto Pratama', 'specialty': 'BIDAN PERSALINAN', 'nik': '4234567894', 'gender': 'Laki-laki', 'title': 'Bd.', 'email': 'yanto@hospital.com', 'phone': '084234567894', 'photoAsset': ''},
      ];
    } else if (category == 'Apoteker') {
      doctorList = [
        {'name': 'Ahmad Suryadi', 'specialty': 'Apoteker', 'nik': '5234567890', 'gender': 'Laki-laki', 'title': 'Apt.', 'email': 'ahmad@hospital.com', 'phone': '085234567890', 'photoAsset': ''},
        {'name': 'Maria Gonzales', 'specialty': 'Apoteker', 'nik': '5234567891', 'gender': 'Perempuan', 'title': 'Apt.', 'email': 'maria@hospital.com', 'phone': '085234567891', 'photoAsset': ''},
        {'name': 'Dewi Lestari', 'specialty': 'Apoteker', 'nik': '5234567892', 'gender': 'Perempuan', 'title': 'Apt.', 'email': 'dewi@hospital.com', 'phone': '085234567892', 'photoAsset': ''},
        {'name': 'Agung Nugroho', 'specialty': 'Apoteker', 'nik': '5234567893', 'gender': 'Laki-laki', 'title': 'Apt.', 'email': 'agung@hospital.com', 'phone': '085234567893', 'photoAsset': ''},
        {'name': 'Hendra Kusuma', 'specialty': 'Apoteker', 'nik': '5234567894', 'gender': 'Laki-laki', 'title': 'Apt.', 'email': 'hendra@hospital.com', 'phone': '085234567894', 'photoAsset': ''},
      ];
    } else if (category == 'Staff') {
      doctorList = [
        {'name': 'Siti Nurhaliza', 'specialty': 'Admin', 'nik': '6234567890', 'gender': 'Perempuan', 'title': '', 'email': 'siti@hospital.com', 'phone': '086234567890', 'photoAsset': ''},
        {'name': 'Indra Wijaya', 'specialty': 'Teknisi', 'nik': '6234567891', 'gender': 'Laki-laki', 'title': '', 'email': 'indra@hospital.com', 'phone': '086234567891', 'photoAsset': ''},
        {'name': 'Budi Santoso', 'specialty': 'Security', 'nik': '6234567892', 'gender': 'Laki-laki', 'title': '', 'email': 'budi@hospital.com', 'phone': '086234567892', 'photoAsset': ''},
        {'name': 'Anita Sari', 'specialty': 'Cleaning Service', 'nik': '6234567893', 'gender': 'Perempuan', 'title': '', 'email': 'anita@hospital.com', 'phone': '086234567893', 'photoAsset': ''},
        {'name': 'Yanto Pratama', 'specialty': 'IT Support', 'nik': '6234567894', 'gender': 'Laki-laki', 'title': '', 'email': 'yanto@hospital.com', 'phone': '086234567894', 'photoAsset': ''},
      ];
    }
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Daftar $category',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        backgroundColor: color,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total: ${doctorList.length} orang',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Klik pada nama untuk melihat detail',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Tambahkan tombol "Tambah" di sini
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: color,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEmployeeScreen(
                        category: category,
                        categoryColor: color,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tambah $category',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: doctorList.length,
              itemBuilder: (context, index) {
                final doctor = doctorList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorDetailScreen(
                            name: doctor['name'],
                            specialty: doctor['specialty'],
                            category: category,
                            isMedical: category != 'Staff' && category != 'Apoteker',
                            nik: doctor['nik'],
                            gender: doctor['gender'],
                            title: doctor['title'],
                            email: doctor['email'],
                            phone: doctor['phone'],
                            photoAsset: doctor['photoAsset'] ?? '',
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: color, width: 1),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: doctor['photoAsset'] != null && doctor['photoAsset'].isNotEmpty
                                  ? Image.asset(
                                      doctor['photoAsset'],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: color.withOpacity(0.1),
                                          child: Center(
                                            child: Text(
                                              doctor['name'].toString().isNotEmpty 
                                                  ? doctor['name'].toString()[0].toUpperCase() 
                                                  : '?',
                                              style: TextStyle(
                                                color: color,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      color: color.withOpacity(0.1),
                                      child: Center(
                                        child: Text(
                                          doctor['name'].toString().isNotEmpty 
                                              ? doctor['name'].toString()[0].toUpperCase() 
                                              : '?',
                                          style: TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctor['name'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  doctor['specialty'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
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
}

// Doctor Detail Screen
class DoctorDetailScreen extends StatefulWidget {
  final String name;
  final String specialty;
  final String category;
  final bool isMedical;
  final String? nik;
  final String? gender;
  final String? title;
  final String? email;
  final String? phone;
  final String? photoAsset;
  
  const DoctorDetailScreen({
    Key? key,
    required this.name,
    required this.specialty,
    required this.category,
    required this.isMedical,
    this.nik,
    this.gender,
    this.title,
    this.email,
    this.phone,
    this.photoAsset,
  }) : super(key: key);
  
  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  late TextEditingController _nameController;
  late TextEditingController _specialtyController;
  late TextEditingController _nikController;
  late TextEditingController _genderController;
  late TextEditingController _titleController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isEditing = false;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _specialtyController = TextEditingController(text: widget.specialty);
    _nikController = TextEditingController(text: widget.nik ?? '');
    _genderController = TextEditingController(text: widget.gender ?? '');
    _titleController = TextEditingController(text: widget.title ?? '');
    _emailController = TextEditingController(text: widget.email ?? '');
    _phoneController = TextEditingController(text: widget.phone ?? '');
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _nikController.dispose();
    _genderController.dispose();
    _titleController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    Color categoryColor = const {
      'Dokter Spesialis': Color(0xFF2563EB),
      'Dokter Umum': Color(0xFF3B82F6),
      'Perawat': Color(0xFF10B981),
      'Bidan': Color(0xFF8B5CF6),
      'Apoteker': Color(0xFFF59E0B),
      'Staff': Color(0xFFEC4899),
    }[widget.category] ?? const Color(0xFF64748B);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text(
          'Detail ${widget.category}',
          style: const TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF6B7280), size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: Material(
              color: _isEditing ? categoryColor : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                  
                  if (!_isEditing) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Data berhasil disimpan'),
                        backgroundColor: Colors.green[600],
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isEditing ? Icons.check : Icons.edit_outlined,
                        color: _isEditing ? Colors.white : Color(0xFF6B7280),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _isEditing ? 'Simpan' : 'Edit',
                        style: TextStyle(
                          color: _isEditing ? Colors.white : Color(0xFF6B7280),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    // Profile Picture with Status
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: categoryColor.withOpacity(0.2),
                              width: 4,
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[50],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: widget.photoAsset != null && widget.photoAsset!.isNotEmpty
                                  ? Image.asset(
                                      widget.photoAsset!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return _buildInitialsAvatar(categoryColor);
                                      },
                                    )
                                  : _buildInitialsAvatar(categoryColor),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green[500],
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Text(
                              'Aktif',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Name Field
                    _isEditing
                        ? _buildEditableField(
                            controller: _nameController,
                            hint: 'Nama Lengkap',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          )
                        : Text(
                            _nameController.text,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                    
                    const SizedBox(height: 8),
                    
                    // Specialty/Position Field
                    _isEditing
                        ? _buildEditableField(
                            controller: _specialtyController,
                            hint: widget.isMedical ? 'Spesialisasi' : 'Posisi',
                            fontSize: 14,
                          )
                        : Text(
                            _specialtyController.text,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                    
                    const SizedBox(height: 20),
                    
                    // Category Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: categoryColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getCategoryIcon(widget.category),
                            color: categoryColor,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.category,
                            style: TextStyle(
                              color: categoryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Personal Information Card
            _buildInfoCard(
              title: 'Informasi Personal',
              icon: Icons.person_outline,
              categoryColor: categoryColor,
              child: Column(
                children: [
                  _buildInfoRow(
                    label: 'NIK',
                    controller: _nikController,
                    icon: Icons.badge_outlined,
                    isEditing: _isEditing,
                  ),
                  _buildInfoRow(
                    label: 'Jenis Kelamin',
                    controller: _genderController,
                    icon: Icons.wc_outlined,
                    isEditing: _isEditing,
                  ),
                  _buildInfoRow(
                    label: 'Gelar',
                    controller: _titleController,
                    icon: Icons.school_outlined,
                    isEditing: _isEditing,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Contact Information Card
            _buildInfoCard(
              title: 'Informasi Kontak',
              icon: Icons.contact_phone_outlined,
              categoryColor: categoryColor,
              child: Column(
                children: [
                  _buildInfoRow(
                    label: 'Email',
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    isEditing: _isEditing,
                    isEmail: true,
                  ),
                  _buildInfoRow(
                    label: 'Telp/No.HP',
                    controller: _phoneController,
                    icon: Icons.phone_outlined,
                    isEditing: _isEditing,
                    isPhone: true,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Schedule Card
            _buildScheduleCard(categoryColor),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInitialsAvatar(Color categoryColor) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            categoryColor.withOpacity(0.1),
            categoryColor.withOpacity(0.05),
          ],
        ),
      ),
      child: Center(
        child: Text(
          widget.name.isNotEmpty ? widget.name[0].toUpperCase() : '?',
          style: TextStyle(
            color: categoryColor,
            fontWeight: FontWeight.w600,
            fontSize: 36,
          ),
        ),
      ),
    );
  }
  
  Widget _buildEditableField({
    required TextEditingController controller,
    required String hint,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: const Color(0xFF111827),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
  
  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Color categoryColor,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: categoryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            child,
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool isEditing,
    bool isEmail = false,
    bool isPhone = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.grey[600],
              size: 18,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                isEditing
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: TextField(
                          controller: controller,
                          keyboardType: isEmail
                              ? TextInputType.emailAddress
                              : isPhone
                                  ? TextInputType.phone
                                  : TextInputType.text,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF111827),
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      )
                    : Text(
                        controller.text.isEmpty ? '-' : controller.text,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF111827),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildScheduleCard(Color categoryColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.schedule_outlined,
                    color: categoryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Jadwal Praktek',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Schedule List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.today_outlined,
                          color: categoryColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Senin, ${index + 10} September 2025',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '08:00 - 16:00 WIB',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[400],
                        size: 16,
                      ),
                    ],
                  ),
                );
              },
            ),
            
            const SizedBox(height: 20),
            
            // Add Schedule Button
            SizedBox(
              width: double.infinity,
              child: Material(
                color: categoryColor,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    // Add schedule logic
                    _showAddScheduleDialog(categoryColor);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Tambah Jadwal',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showAddScheduleDialog(Color categoryColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String day = 'Senin';
        String startTime = '08:00';
        String endTime = '16:00';
        
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.schedule,
                            color: categoryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Tambah Jadwal Kerja',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: categoryColor,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Day Selector
                    Text(
                      'Hari',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: day,
                        onChanged: (value) {
                          setState(() {
                            day = value!;
                          });
                        },
                        items: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu']
                            .map((day) => DropdownMenuItem(
                                  value: day,
                                  child: Text(day),
                                ))
                            .toList(),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Time Range
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jam Mulai',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: TextFormField(
                                  initialValue: startTime,
                                  onChanged: (value) {
                                    startTime = value;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    hintText: '08:00',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jam Selesai',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: TextFormField(
                                  initialValue: endTime,
                                  onChanged: (value) {
                                    endTime = value;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    hintText: '16:00',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: Material(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  'Batal',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Material(
                            color: categoryColor,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Jadwal kerja hari $day ($startTime - $endTime) berhasil ditambahkan'),
                                    backgroundColor: categoryColor,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: const Text(
                                  'Simpan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  
  // Helper method untuk mendapatkan icon kategori
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Dokter Spesialis':
        return Icons.local_hospital;
      case 'Dokter Umum':
        return Icons.medical_services;
      case 'Perawat':
        return Icons.favorite;
      case 'Bidan':
        return Icons.child_care;
      case 'Apoteker':
        return Icons.medication;
      case 'Staff':
        return Icons.work;
      default:
        return Icons.person;
    }
  }
  
  Widget _buildInfoField({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    bool isEmail = false,
    bool isPhone = false,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.grey[600],
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        isEditing
            ? TextField(
                controller: controller,
                keyboardType: isEmail
                    ? TextInputType.emailAddress
                    : isPhone
                        ? TextInputType.phone
                        : TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                style: const TextStyle(fontSize: 14),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  controller.text.isNotEmpty ? controller.text : '-',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
      ],
    );
  }
}

// Add Employee Screen
class AddEmployeeScreen extends StatefulWidget {
  final String category;
  final Color categoryColor;
  
  const AddEmployeeScreen({
    Key? key,
    required this.category,
    required this.categoryColor,
  }) : super(key: key);
  
  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  late TextEditingController _nameController;
  late TextEditingController _specialtyController;
  late TextEditingController _nikController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? _selectedGender;
  List<Map<String, String>> _workSchedules = [];
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _specialtyController = TextEditingController();
    _nikController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _nikController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Tambah ${widget.category}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        backgroundColor: widget.categoryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: widget.categoryColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: widget.categoryColor.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      _getCategoryIcon(widget.category),
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tambah ${widget.category} Baru',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Silakan isi data ${widget.category.toLowerCase()} dengan lengkap',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Form Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Field
                  _buildFormField(
                    label: 'Nama Lengkap',
                    controller: _nameController,
                    icon: Icons.person_outline,
                    isRequired: true,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Specialty/Position Field
                  _buildFormField(
                    label: _isMedicalStaff(widget.category) ? 'Spesialisasi' : 'Posisi',
                    controller: _specialtyController,
                    icon: _isMedicalStaff(widget.category) ? Icons.medical_services_outlined : Icons.work_outline,
                    isRequired: true,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // NIK Field
                  _buildFormField(
                    label: 'NIK',
                    controller: _nikController,
                    icon: Icons.badge_outlined,
                    isRequired: true,
                    keyboardType: TextInputType.number,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Gender Field
                  _buildGenderField(),
                  
                  const SizedBox(height: 20),
                  
                  // Email Field
                  _buildFormField(
                    label: 'Email',
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Phone Field
                  _buildFormField(
                    label: 'No. Telepon',
                    controller: _phoneController,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Tambah Jadwal Button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: widget.categoryColor, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: _addWorkSchedule,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: widget.categoryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Tambah Jadwal Kerja',
                                style: TextStyle(
                                  color: widget.categoryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Display work schedules
                  _buildWorkSchedules(),
                  
                  const SizedBox(height: 32),
                  
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: Material(
                      color: widget.categoryColor,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: _submitForm,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.save,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Simpan Data',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
  
  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[400],
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF1E293B),
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: Colors.grey[500],
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              hintText: 'Masukkan $label',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              'Jenis Kelamin',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            Text(
              ' *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedGender = 'Laki-laki';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _selectedGender == 'Laki-laki' 
                          ? widget.categoryColor.withOpacity(0.1) 
                          : Colors.transparent,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.male,
                          color: _selectedGender == 'Laki-laki' 
                              ? widget.categoryColor 
                              : Colors.grey[500],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Laki-laki',
                          style: TextStyle(
                            color: _selectedGender == 'Laki-laki' 
                                ? widget.categoryColor 
                                : Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.grey[200],
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedGender = 'Perempuan';
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: _selectedGender == 'Perempuan' 
                          ? widget.categoryColor.withOpacity(0.1) 
                          : Colors.transparent,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.female,
                          color: _selectedGender == 'Perempuan' 
                              ? widget.categoryColor 
                              : Colors.grey[500],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Perempuan',
                          style: TextStyle(
                            color: _selectedGender == 'Perempuan' 
                                ? widget.categoryColor 
                                : Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  void _addWorkSchedule() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String day = 'Senin';
        String startTime = '08:00';
        String endTime = '16:00';
        
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: widget.categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.schedule,
                            color: widget.categoryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Tambah Jadwal Kerja',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: widget.categoryColor,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Day Selector
                    Text(
                      'Hari',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: day,
                        onChanged: (value) {
                          setState(() {
                            day = value!;
                          });
                        },
                        items: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu']
                            .map((day) => DropdownMenuItem(
                                  value: day,
                                  child: Text(day),
                                ))
                            .toList(),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Time Range
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jam Mulai',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: TextFormField(
                                  initialValue: startTime,
                                  onChanged: (value) {
                                    startTime = value;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    hintText: '08:00',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jam Selesai',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: TextFormField(
                                  initialValue: endTime,
                                  onChanged: (value) {
                                    endTime = value;
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    hintText: '16:00',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: Material(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  'Batal',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Material(
                            color: widget.categoryColor,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                this.setState(() {
                                  _workSchedules.add({
                                    'day': day,
                                    'startTime': startTime,
                                    'endTime': endTime,
                                  });
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: const Text(
                                  'Simpan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  
  Widget _buildWorkSchedules() {
    if (_workSchedules.isEmpty) {
      return Container();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Icon(
              Icons.schedule,
              color: widget.categoryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Jadwal Kerja',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _workSchedules.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.grey[200],
                ),
                itemBuilder: (context, index) {
                  final schedule = _workSchedules[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: widget.categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.today,
                            color: widget.categoryColor,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                schedule['day']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${schedule['startTime']} - ${schedule['endTime']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red[400],
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _workSchedules.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  void _submitForm() {
    // Validasi form
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Nama lengkap harus diisi'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }
    
    if (_specialtyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isMedicalStaff(widget.category) 
              ? 'Spesialisasi harus diisi' 
              : 'Posisi harus diisi'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }
    
    if (_nikController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('NIK harus diisi'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }
    
    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Jenis kelamin harus dipilih'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }
    
    // Simpan data (di sini biasanya akan ada proses penyimpanan ke database)
    final newEmployee = {
      'name': _nameController.text,
      'specialty': _specialtyController.text,
      'nik': _nikController.text,
      'gender': _selectedGender,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'category': widget.category,
      'schedules': _workSchedules,
    };
    
    print('Data pegawai baru: $newEmployee'); // Untuk debugging
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.category} berhasil ditambahkan dengan ${_workSchedules.length} jadwal kerja'),
        backgroundColor: widget.categoryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
    
    // Kembali ke halaman sebelumnya
    Navigator.pop(context);
  }
  
  bool _isMedicalStaff(String category) {
    return category == 'Dokter Spesialis' || 
           category == 'Dokter Umum' || 
           category == 'Perawat' || 
           category == 'Bidan';
  }
  
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Dokter Spesialis':
        return Icons.local_hospital;
      case 'Dokter Umum':
        return Icons.medical_services;
      case 'Perawat':
        return Icons.favorite;
      case 'Bidan':
        return Icons.child_care;
      case 'Apoteker':
        return Icons.medication;
      case 'Staff':
        return Icons.work;
      default:
        return Icons.person;
    }
  }
}

// Doctor Schedule class
class DoctorSchedule {
  final String name;
  final String specialty;
  final String startTime;
  final String endTime;
  final String photoAsset;
  
  DoctorSchedule({
    required this.name,
    required this.specialty,
    required this.startTime,
    required this.endTime,
    this.photoAsset = '',
  });
}

// Staff Schedule class
class StaffSchedule {
  final String name;
  final String position;
  final String startTime;
  final String endTime;
  final String photoAsset;
  
  StaffSchedule({
    required this.name,
    required this.position,
    required this.startTime,
    required this.endTime,
    this.photoAsset = '',
  });
}

// Categorized Doctor Schedule class
class CategorizedDoctorSchedule extends DoctorSchedule {
  final String category;
  
  CategorizedDoctorSchedule({
    required String name,
    required String specialty,
    required String startTime,
    required String endTime,
    required this.category,
    String photoAsset = '',
  }) : super(
    name: name,
    specialty: specialty,
    startTime: startTime,
    endTime: endTime,
    photoAsset: photoAsset,
  );
}

// Categorized Staff Schedule class
class CategorizedStaffSchedule extends StaffSchedule {
  final String category;
  
  CategorizedStaffSchedule({
    required String name,
    required String position,
    required String startTime,
    required String endTime,
    required this.category,
    String photoAsset = ''
  }) : super(
    name: name,
    position: position,
    startTime: startTime,
    endTime: endTime,
    photoAsset: photoAsset,
  );
}

// Meeting class for appointments
class Meeting {
  Meeting({
    required this.eventName,
    required this.from,
    required this.to,
    required this.background,
    this.category = '',
  });
  
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  String category;
}

// Data source for Syncfusion Calendar
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> meetings) {
    appointments = meetings;
  }
  
  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }
  
  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }
  
  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }
  
  @override
  Color getColor(int index) {
    return appointments![index].background;
  }
}