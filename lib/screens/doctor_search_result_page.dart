import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'rumahsakitmember.dart';
import 'package:inocare/screens/detailjadwaldokter.dart';
import '../services/hospital_service.dart';

class DoctorSearchResultPage extends StatefulWidget {
  final String doctorName;
  
  const DoctorSearchResultPage({Key? key, required this.doctorName}) : super(key: key);

  @override
  State<DoctorSearchResultPage> createState() => _DoctorSearchResultPageState();
}

class _DoctorSearchResultPageState extends State<DoctorSearchResultPage> {
  List<DoctorSearchResult> _searchResults = [];
  bool _isLoading = true;
  DateTime _currentDateTime = DateTime.now();
  String _currentDay = '';

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _searchDoctors();
  }

  void _updateDateTime() {
    _currentDateTime = DateTime.now();
    _currentDay = _getDayName(_currentDateTime.weekday);
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Senin';
      case 2: return 'Selasa';
      case 3: return 'Rabu';
      case 4: return 'Kamis';
      case 5: return 'Jumat';
      case 6: return 'Sabtu';
      case 7: return 'Minggu';
      default: return '';
    }
  }

  String _getFormattedDate() {
    return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(_currentDateTime);
  }

  String _getFormattedTime() {
    return DateFormat('HH:mm').format(_currentDateTime);
  }

  bool _isDoctorAvailableNow(DoctorSearchResult doctor) {
    final now = TimeOfDay.now();
    final currentDay = _currentDay;
    
    for (var schedule in doctor.schedule) {
      if (schedule.day == currentDay) {
        if (schedule.time == '24 Jam') {
          return true;
        }
        
        // Parse jam praktek
        final timeParts = schedule.time.split(' - ');
        if (timeParts.length == 2) {
          final startParts = timeParts[0].split(':');
          final endParts = timeParts[1].split(':');
          
          final startTime = TimeOfDay(
            hour: int.parse(startParts[0]),
            minute: int.parse(startParts[1]),
          );
          final endTime = TimeOfDay(
            hour: int.parse(endParts[0]),
            minute: int.parse(endParts[1]),
          );
          
          final nowMinutes = now.hour * 60 + now.minute;
          final startMinutes = startTime.hour * 60 + startTime.minute;
          final endMinutes = endTime.hour * 60 + endTime.minute;
          
          if (nowMinutes >= startMinutes && nowMinutes <= endMinutes) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void _searchDoctors() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration(milliseconds: 800), () {
      List<DoctorSearchResult> allDoctors = _getAllDoctors();
      
      List<DoctorSearchResult> filteredDoctors = allDoctors.where((doctor) {
        return doctor.name.toLowerCase().contains(widget.doctorName.toLowerCase());
      }).toList();

      setState(() {
        _searchResults = filteredDoctors;
        _isLoading = false;
      });
    });
  }

  List<DoctorSearchResult> _getAllDoctors() {
    return [
      // RSUP Dr. Hasan Sadikin
      DoctorSearchResult(
        name: 'Dr. Ahmad Rizki, Sp.EM',
        specialty: 'Instalasi Gawat Darurat',
        hospital: 'RSUP Dr. Hasan Sadikin',
        hospitalAddress: 'Jl. Pasteur No.38, Pasteur, Kec. Sukajadi, Kota Bandung',
        schedule: [
          DoctorSchedule(day: 'Senin', time: '24 Jam'),
          DoctorSchedule(day: 'Selasa', time: '24 Jam'),
          DoctorSchedule(day: 'Rabu', time: '24 Jam'),
          DoctorSchedule(day: 'Kamis', time: '24 Jam'),
          DoctorSchedule(day: 'Jumat', time: '24 Jam'),
          DoctorSchedule(day: 'Sabtu', time: '24 Jam'),
          DoctorSchedule(day: 'Minggu', time: '24 Jam'),
        ],
        photo: 'assets/images/dr_ahmad_rizki.jpg',
        status: 'Tersedia',
      ),
      DoctorSearchResult(
        name: 'Dr. Sri Handayani, Sp.PD',
        specialty: 'Penyakit Dalam',
        hospital: 'RSUP Dr. Hasan Sadikin',
        hospitalAddress: 'Jl. Pasteur No.38, Pasteur, Kec. Sukajadi, Kota Bandung',
        schedule: [
          DoctorSchedule(day: 'Senin', time: '08:00 - 16:00'),
          DoctorSchedule(day: 'Rabu', time: '08:00 - 16:00'),
          DoctorSchedule(day: 'Jumat', time: '08:00 - 16:00'),
        ],
        photo: 'assets/images/dr_sri_handayani.jpg',
        status: 'Tersedia',
      ),
      DoctorSearchResult(
        name: 'Dr. Budi Santoso, Sp.A',
        specialty: 'Anak',
        hospital: 'RSUP Dr. Hasan Sadikin',
        hospitalAddress: 'Jl. Pasteur No.38, Pasteur, Kec. Sukajadi, Kota Bandung',
        schedule: [
          DoctorSchedule(day: 'Selasa', time: '09:00 - 15:00'),
          DoctorSchedule(day: 'Kamis', time: '09:00 - 15:00'),
        ],
        photo: 'assets/images/dr_budi_santoso.jpg',
        status: 'Sibuk',
      ),
      
      // Edelweiss Hospital
      DoctorSearchResult(
        name: 'Dr. Maya Sari, Sp.JP',
        specialty: 'Jantung',
        hospital: 'Edelweiss Hospital',
        hospitalAddress: 'Jl. Soekarno-Hatta No.550, Sekejati, Kec. Buahbatu, Kota Bandung',
        schedule: [
          DoctorSchedule(day: 'Senin', time: '08:00 - 16:00'),
          DoctorSchedule(day: 'Selasa', time: '08:00 - 16:00'),
          DoctorSchedule(day: 'Jumat', time: '08:00 - 16:00'),
        ],
        photo: 'assets/images/dr_maya_sari.jpg',
        status: 'Tersedia',
      ),
      DoctorSearchResult(
        name: 'Dr. Andi Wijaya, Sp.S',
        specialty: 'Saraf',
        hospital: 'Edelweiss Hospital',
        hospitalAddress: 'Jl. Soekarno-Hatta No.550, Sekejati, Kec. Buahbatu, Kota Bandung',
        schedule: [
          DoctorSchedule(day: 'Selasa', time: '10:00 - 14:00'),
          DoctorSchedule(day: 'Kamis', time: '10:00 - 14:00'),
        ],
        photo: 'assets/images/dr_andi_wijaya.jpg',
        status: 'Tersedia',
      ),
      DoctorSearchResult(
        name: 'Dr. Lisa Permata, Sp.OG',
        specialty: 'Kandungan',
        hospital: 'Edelweiss Hospital',
        hospitalAddress: 'Jl. Soekarno-Hatta No.550, Sekejati, Kec. Buahbatu, Kota Bandung',
        schedule: [
          DoctorSchedule(day: 'Rabu', time: '14:00 - 18:00'),
          DoctorSchedule(day: 'Jumat', time: '14:00 - 18:00'),
        ],
        photo: 'assets/images/dr_lisa_permata.jpg',
        status: 'Tersedia',
      ),
      
      // RS Advent Bandung
      DoctorSearchResult(
        name: 'Dr. Robert Chen, Sp.PD',
        specialty: 'Penyakit Dalam',
        hospital: 'RS Advent Bandung',
        hospitalAddress: 'Jl. Cihampelas No.161, Cipaganti, Kecamatan Coblong, Kota Bandung',
        schedule: [
          DoctorSchedule(day: 'Senin', time: '07:00 - 12:00'),
          DoctorSchedule(day: 'Kamis', time: '07:00 - 12:00'),
        ],
        photo: 'assets/images/dr_robert_chen.jpg',
        status: 'Tersedia',
      ),
      DoctorSearchResult(
        name: 'Dr. Sarah Johnson, Sp.A',
        specialty: 'Anak',
        hospital: 'RS Advent Bandung',
        hospitalAddress: 'Jl. Cihampelas No.161, Cipaganti, Kecamatan Coblong, Kota Bandung',
        schedule: [
          DoctorSchedule(day: 'Selasa', time: '13:00 - 17:00'),
        ],
        photo: 'assets/images/dr_sarah_johnson.jpg',
        status: 'Sibuk',
      ),
      DoctorSearchResult(
        name: 'Dr. Michael Tan, Sp.THT',
        specialty: 'THT',
        hospital: 'RS Advent Bandung',
        hospitalAddress: 'Jl. Cihampelas No.161, Cipaganti, Kecamatan Coblong, Kota Bandung',
        schedule: [
          DoctorSchedule(day: 'Rabu', time: '10:00 - 14:00'),
        ],
        photo: 'assets/images/dr_michael_tan.jpg',
        status: 'Tersedia',
      ),
      
      // RS Hermina Arcamanik
      DoctorSearchResult(
        name: 'Dr. Indra Gunawan, Sp.OG',
        specialty: 'Kandungan',
        hospital: 'RS Hermina Arcamanik',
        hospitalAddress: 'Jl. A.H. Nasution No.50, Antapani Wetan, Kec. Antapani, Kota Bandung',
        schedule: [
          DoctorSchedule(day: 'Senin', time: '08:00 - 15:00'),
          DoctorSchedule(day: 'Kamis', time: '08:00 - 15:00'),
        ],
        photo: 'assets/images/dr_indra_gunawan.jpg',
        status: 'Tersedia',
      ),
      DoctorSearchResult(
        name: 'Dr. Ratna Dewi, Sp.A',
        specialty: 'Anak',
        hospital: 'RS Hermina Arcamanik',
        hospitalAddress: 'Jl. A.H. Nasution No.50, Antapani Wetan, Kec. Antapani, Kota Bandung',
        schedule: [
          DoctorSchedule(day: 'Selasa', time: '16:00 - 20:00'),
          DoctorSchedule(day: 'Jumat', time: '16:00 - 20:00'),
        ],
        photo: 'assets/images/dr_ratna_dewi.jpg',
        status: 'Sibuk',
      ),
      DoctorSearchResult(
        name: 'Dr. Hendra Kusuma, Sp.JP',
        specialty: 'Jantung',
        hospital: 'RS Hermina Arcamanik',
        hospitalAddress: 'Jl. A.H. Nasution No.50, Antapani Wetan, Kec. Antapani, Kota Bandung',
        schedule: [
          DoctorSchedule(day: 'Rabu', time: '09:00 - 13:00'),
        ],
        photo: 'assets/images/dr_hendra_kusuma.jpg',
        status: 'Tersedia',
      ),
      
      // RSUP Fatmawati
      DoctorSearchResult(
        name: 'Dr. Budi Santoso, Sp.PD',
        specialty: 'Penyakit Dalam',
        hospital: 'RSUP Fatmawati',
        hospitalAddress: 'Jl. RS Fatmawati Raya No.4, Cilandak Barat, Cilandak, Jakarta Selatan',
        schedule: [
          DoctorSchedule(day: 'Senin', time: '08:00 - 14:00'),
          DoctorSchedule(day: 'Kamis', time: '08:00 - 14:00'),
        ],
        photo: 'assets/images/dr_budi_santoso2.jpg',
        status: 'Sibuk',
      ),
      DoctorSearchResult(
        name: 'Dr. Siti Nurhaliza, Sp.JP',
        specialty: 'Jantung',
        hospital: 'RSUP Fatmawati',
        hospitalAddress: 'Jl. RS Fatmawati Raya No.4, Cilandak Barat, Cilandak, Jakarta Selatan',
        schedule: [
          DoctorSchedule(day: 'Selasa', time: '09:00 - 15:00'),
        ],
        photo: 'assets/images/dr_siti_nurhaliza.jpg',
        status: 'Tersedia',
      ),
      
      // RS Pondok Indah
      DoctorSearchResult(
        name: 'Dr. Maya Sari Winata, Sp.OG',
        specialty: 'Kandungan',
        hospital: 'RS Pondok Indah',
        hospitalAddress: 'Jl. Metro Duta Kav. UE, Pd. Pinang, Jakarta Selatan',
        schedule: [
          DoctorSchedule(day: 'Senin', time: '09:00 - 15:00'),
        ],
        photo: 'assets/images/dr_maya_sari2.jpg',
        status: 'Tersedia',
      ),
      DoctorSearchResult(
        name: 'Dr. Jessica Wong, Sp.JP',
        specialty: 'Jantung',
        hospital: 'RS Pondok Indah',
        hospitalAddress: 'Jl. Metro Duta Kav. UE, Pd. Pinang, Jakarta Selatan',
        schedule: [
          DoctorSchedule(day: 'Rabu', time: '08:00 - 16:00'),
        ],
        photo: 'assets/images/dr_jessica_wong.jpg',
        status: 'Tersedia',
      ),
      
      // Klinik Husada Jakarta
      DoctorSearchResult(
        name: 'Dr. Lisa Permata, Sp.PD',
        specialty: 'Penyakit Dalam',
        hospital: 'Klinik Husada Jakarta',
        hospitalAddress: 'Jl. Gatot Subroto No.45, Jakarta Pusat',
        schedule: [
          DoctorSchedule(day: 'Senin', time: '08:00 - 16:00'),
          DoctorSchedule(day: 'Selasa', time: '08:00 - 16:00'),
        ],
        photo: 'assets/images/dr_lisa_permata2.jpg',
        status: 'Tersedia',
      ),
      DoctorSearchResult(
        name: 'Dr. Rizki Pratama, Sp.PD',
        specialty: 'Penyakit Dalam',
        hospital: 'Klinik Husada Jakarta',
        hospitalAddress: 'Jl. Gatot Subroto No.45, Jakarta Pusat',
        schedule: [
          DoctorSchedule(day: 'Rabu', time: '08:00 - 16:00'),
          DoctorSchedule(day: 'Jumat', time: '08:00 - 16:00'),
        ],
        photo: 'assets/images/dr_rizki_pratama.jpg',
        status: 'Tersedia',
      ),
      
      // RSUD Dr. H. Abdul Moeloek
      DoctorSearchResult(
        name: 'Dr. Ahmad Rizki, Sp.EM',
        specialty: 'Instalasi Gawat Darurat',
        hospital: 'RSUD Dr. H. Abdul Moeloek',
        hospitalAddress: 'Jl. Dr. Rivai No.6, Penengahan, Bandar Lampung',
        schedule: [
          DoctorSchedule(day: 'Senin', time: '24 Jam'),
          DoctorSchedule(day: 'Selasa', time: '24 Jam'),
          DoctorSchedule(day: 'Rabu', time: '24 Jam'),
          DoctorSchedule(day: 'Kamis', time: '24 Jam'),
          DoctorSchedule(day: 'Jumat', time: '24 Jam'),
          DoctorSchedule(day: 'Sabtu', time: '24 Jam'),
          DoctorSchedule(day: 'Minggu', time: '24 Jam'),
        ],
        photo: 'assets/images/dr_ahmad_rizki2.jpg',
        status: 'Tersedia',
      ),
      DoctorSearchResult(
        name: 'Dr. Maria Sari, Sp.JP',
        specialty: 'Jantung',
        hospital: 'RSUD Dr. H. Abdul Moeloek',
        hospitalAddress: 'Jl. Dr. Rivai No.6, Penengahan, Bandar Lampung',
        schedule: [
          DoctorSchedule(day: 'Selasa', time: '10:00 - 18:00'),
        ],
        photo: 'assets/images/dr_maria_sari.jpg',
        status: 'Sibuk',
      ),
    ];
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Color(0xFFFF6B35),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hasil Pencarian: "${widget.doctorName}"',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${_getFormattedDate()} • ${_getFormattedTime()} WIB',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFFFF6B35)),
                  SizedBox(height: 16),
                  Text('Mencari dokter...'),
                ],
              ),
            )
          : _searchResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        'Tidak ditemukan dokter dengan nama "${widget.doctorName}"',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Coba gunakan kata kunci lain',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.blue[50],
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Menampilkan hasil untuk hari ini: $_currentDay, ${DateFormat('dd MMM yyyy', 'id_ID').format(_currentDateTime)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[900],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Ditemukan ${_searchResults.length} dokter dengan nama "${widget.doctorName}"',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return _buildDoctorCard(_searchResults[index]);
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildDoctorCard(DoctorSearchResult doctor) {
    bool isAvailableNow = _isDoctorAvailableNow(doctor);
    Color statusColor = isAvailableNow ? Colors.green : Colors.orange;
    String statusText = isAvailableNow ? 'Praktek Sekarang' : 'Tidak Praktek';

    // Cek jadwal hari ini
    DoctorSchedule? todaySchedule = doctor.schedule.firstWhere(
      (s) => s.day == _currentDay,
      orElse: () => DoctorSchedule(day: '', time: ''),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      doctor.photo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.person, size: 30, color: Colors.grey[600]),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
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
                      const SizedBox(height: 4),
                      Text(
                        doctor.specialty,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFFF6B35),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.local_hospital, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              doctor.hospital,
                              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    doctor.hospitalAddress,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
            
            if (todaySchedule.day.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isAvailableNow ? Colors.green[50] : Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isAvailableNow ? Colors.green[200]! : Colors.orange[200]!,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: isAvailableNow ? Colors.green[700] : Colors.orange[700],
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Jadwal hari ini ($_currentDay): ${todaySchedule.time}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isAvailableNow ? Colors.green[900] : Colors.orange[900],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 12),
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jadwal Praktek Lengkap:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: doctor.schedule.map((schedule) {
                    bool isToday = schedule.day == _currentDay;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isToday 
                            ? Color(0xFFFF6B35).withOpacity(0.2)
                            : Color(0xFFFF6B35).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isToday 
                              ? Color(0xFFFF6B35)
                              : Color(0xFFFF6B35).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        '${schedule.day}: ${schedule.time}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFFFF6B35),
                          fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorSchedulePage(
                            hospital: _getHospitalByName(doctor.hospital),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.calendar_today, size: 16),
                    label: Text('Lihat Jadwal'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF4A90E2),
                      side: BorderSide(color: Color(0xFF4A90E2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RumahSakitMemberPage(),
                        ),
                      );
                    },
                    icon: Icon(Icons.local_hospital, size: 16),
                    label: Text('Kunjungi RS'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF6B35),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
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

  Hospital _getHospitalByName(String name) {
    List<Map<String, dynamic>> hospitals = HospitalService.getLocalHospitals();
    
    Map<String, dynamic>? hospitalData = hospitals.firstWhere(
      (hospital) => hospital['name'] == name,
      orElse: () => hospitals.first,
    );
    
    return Hospital(
      name: hospitalData['name'],
      address: hospitalData['address'],
      phone: hospitalData['phone'] ?? 'Tidak tersedia',
      distance: '0 km',
      rating: hospitalData['rating']?.toDouble() ?? 0.0,
      reviewCount: 0,
      isOpen: hospitalData['isOpen24Hours'] ?? false,
      services: List<String>.from(hospitalData['services'] ?? []),
      imagePath: hospitalData['imageUrl'] ?? '',
      operatingHours: hospitalData['operatingHours'] ?? '',
      type: hospitalData['acceptsBPJS'] == true ? 'RS Pemerintah' : 'RS Swasta',
      bloodStock: {},
      facilities: {},
      specialties: [],
      bedAvailability: hospitalData['bedAvailability'],
    );
  }
}

class DoctorSearchResult {
  final String name;
  final String specialty;
  final String hospital;
  final String hospitalAddress;
  final List<DoctorSchedule> schedule;
  final String photo;
  final String status;

  DoctorSearchResult({
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.hospitalAddress,
    required this.schedule,
    required this.photo,
    required this.status,
  });
}

class DoctorSchedule {
  final String day;
  final String time;

  DoctorSchedule({required this.day, required this.time});
}