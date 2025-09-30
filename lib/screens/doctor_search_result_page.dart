import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inocare/screens/detailjadwaldokter.dart';
import 'package:inocare/screens/detailrsmember.dart';
import '../services/hospital_service.dart';
import '../models/hospital_model.dart';
import '../models/doctor_model.dart';

class DoctorSearchResultPage extends StatefulWidget {
  final String doctorName;
  
  const DoctorSearchResultPage({Key? key, required this.doctorName}) : super(key: key);

  @override
  State<DoctorSearchResultPage> createState() => _DoctorSearchResultPageState();
}

class _DoctorSearchResultPageState extends State<DoctorSearchResultPage> {
  List<Doctor> _searchResults = [];
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

  void _searchDoctors() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration(milliseconds: 800), () {
      List<Doctor> allDoctors = HospitalService.searchDoctors(widget.doctorName);

      setState(() {
        _searchResults = allDoctors;
        _isLoading = false;
      });
    });
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

  // doctor_search_result_page.dart
Widget _buildDoctorCard(Doctor doctor) {
  // Cek apakah dokter tersedia hari ini
  bool isAvailableNow = false;
  DoctorSchedule? todaySchedule;
  
  // Cari jadwal untuk hari ini
  for (var schedule in doctor.schedule) {
    if (schedule.day == _currentDay) {
      todaySchedule = schedule;
      
      // Cek apakah jam sekarang masuk dalam jadwal praktek
      if (schedule.time == '24 Jam') {
        isAvailableNow = true;
      } else {
        final now = TimeOfDay.now();
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
            isAvailableNow = true;
          }
        }
      }
      break;
    }
  }
  
  Color statusColor = isAvailableNow ? Colors.green : Colors.orange;
  String statusText = isAvailableNow ? 'Praktek Sekarang' : 'Tidak Praktek';

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
                            doctor.hospitalName,
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
                  doctor.location,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Tampilkan jadwal hari ini jika ada
          if (todaySchedule != null) ...[
            Container(
              padding: EdgeInsets.all(12),
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
                  Expanded(
                    child: Text(
                      'Jadwal hari ini ($_currentDay): ${todaySchedule.time}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isAvailableNow ? Colors.green[900] : Colors.orange[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
          ],
          
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${schedule.day}: ',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFFFF6B35),
                            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                        Text(
                          schedule.time,
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFFFF6B35),
                            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ],
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
                          hospital: _getHospitalById(doctor.hospitalId),
                          doctorName: doctor.name,
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
                        builder: (context) => HospitalDetailPage(
                          hospital: _getHospitalById(doctor.hospitalId),
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.local_hospital, size: 16),
                  label: Text('Pilih Rumah Sakit'),
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

  Hospital _getHospitalById(String hospitalId) {
    List<Map<String, dynamic>> hospitals = HospitalService.getLocalHospitals();
    
    Map<String, dynamic>? hospitalData = hospitals.firstWhere(
      (hospital) => hospital['id'] == hospitalId,
      orElse: () => hospitals.first,
    );
    
    return Hospital.fromJson(hospitalData);
  }
}