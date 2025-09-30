import 'dart:convert';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import '../models/hospital_model.dart';
import '../models/doctor_model.dart';

class HospitalService {
  // Data rumah sakit dengan informasi lengkap dan akurat
  static List<Map<String, dynamic>> _localHospitals = [
    // Rumah Sakit di Bandung
    {
      'id': '1',
      'name': 'RSUP Dr. Hasan Sadikin',
      'address': 'Jl. Pasteur No.38, Pasteur, Kec. Sukajadi, Kota Bandung',
      'latitude': double.parse ("-6.89816942648441"),
      'longitude': double.parse ("107.59840609589006"),
      'imageUrl': 'assets/images/hasansadikin.png',
      'phone': '(022) 2038285',
      'services': ['IGD', 'Rawat Jalan', 'Rawat Inap', 'MCU', 'Spesialis', 'Rujukan', 'UTDRS'],
      'isOpen24Hours': true,
      'hasBloodStock': true,
      'acceptsBPJS': true,
      'hasIGD': true,
      'hasMCU': true,
      'bloodStock': {
        'A+': 15, 'A-': 3, 'B+': 8, 'B-': 2, 
        'AB+': 4, 'AB-': 1, 'O+': 20, 'O-': 6
      },
      // Tambahkan data bed
      'bedAvailability': {
        'igd': {'total': 10, 'available': 8},
        'vip': {'total': 15, 'available': 3},
        'kelas1': {'total': 30, 'available': 8},
        'kelas2': {'total': 50, 'available': 15},
        'kelas3': {'total': 80, 'available': 0},
        'icu': {'total': 12, 'available': 6},
      },

      'mobilAvailability': {
        'ambulance': {'total': 5, 'available': 2},
        'jenazah': {'total': 2, 'available': 0},
      },
      'rating': 4.5,
      'operatingHours': 'Buka 24 Jam'
    },
    {
      'id': '2',
      'name': 'Edelweiss Hospital',
      'address': 'Jl. Soekarno-Hatta No.550, Sekejati, Kec. Buahbatu, Kota Bandung, Jawa Barat 40286',
      'latitude': double.parse ("-6.94354"),
      'longitude': double.parse ("107.64966"),
      'imageUrl': 'assets/images/edelweiss.jpg',
      'phone': '(022) 2552000',
      'services': ['IGD', 'Rawat Jalan', 'Rawat Inap', 'MCU', 'Persalinan', 'BPJS', 'UTDRS'],
      'isOpen24Hours': true,
      'hasBloodStock': true,
      'acceptsBPJS': true,
      'hasIGD': true,
      'hasMCU': true,
      'bloodStock': {
        'A+': 12, 'A-': 4, 'B+': 6, 'B-': 1, 
        'AB+': 3, 'AB-': 0, 'O+': 18, 'O-': 5
      },
      // Tambahkan data bed
      'bedAvailability': {
        'igd': {'total': 8, 'available': 5},
        'vip': {'total': 12, 'available': 2},
        'kelas1': {'total': 25, 'available': 10},
        'kelas2': {'total': 45, 'available': 20},
        'kelas3': {'total': 70, 'available': 5},
        'icu': {'total': 10, 'available': 4},
      },
      'mobilAvailability': {
        'ambulance': {'total': 5, 'available': 2},
        'jenazah': {'total': 2, 'available': 1},
      },
      'rating': 4.3,
      'reviewCount' : 2.0,
      'operatingHours': 'Buka 24 Jam'
    },
    {
      'id': '3',
      'name': 'RS Advent Bandung',
      'address': 'Jl. Cihampelas No.161, Cipaganti, Kecamatan Coblong, Kota Bandung, Jawa Barat 40131',
      'latitude': double.parse ("-6.89201"),
      'longitude': double.parse ("107.60327"),
      'imageUrl': 'assets/images/rsadvent.jpg',
      'phone': '(022) 2034386',
      'services': ['IGD', 'Rawat Jalan', 'Rawat Inap', 'MCU'],
      'isOpen24Hours': false,
      'hasBloodStock': false, // RS swasta premium, stok darah terbatas
      'acceptsBPJS': false, // RS premium, tidak terima BPJS
      'hasIGD': true,
      'hasMCU': true,
      'bloodStock': null,
      // Tambahkan data bed
      'bedAvailability': {
        'igd': {'total': 6, 'available': 3},
        'vip': {'total': 10, 'available': 1},
        'kelas1': {'total': 20, 'available': 5},
        'kelas2': {'total': 40, 'available': 15},
        'kelas3': {'total': 60, 'available': 10},
        'icu': {'total': 8, 'available': 2},
      },
      'mobilAvailability': {
        'ambulance': {'total': 9, 'available': 7},
        'jenazah': {'total': 2, 'available': 1},
      },
      'rating': 4.4,
      'operatingHours': 'Buka 24 Jam'
    },
    {
      'id': '4',
      'name': 'RS Hermina Arcamanik',
      'address': 'Jl. A.H. Nasution No.50, Antapani Wetan, Kec. Antapani, Kota Bandung',
      'latitude': double.parse ("-6.914684"),
      'longitude': double.parse ("107.665428"),
      'imageUrl': 'assets/images/hermina1.jpg',
      'phone': '(022) 87242525',
      'services': ['IGD', 'Rawat Jalan', 'Rawat Inap', 'MCU', 'Kandungan'],
      'isOpen24Hours': true,
      'hasBloodStock': true,
      'acceptsBPJS': true,
      'hasIGD': true,
      'hasMCU': true,
      'bloodStock': {
        'A+': 10, 'A-': 2, 'B+': 7, 'B-': 1, 
        'AB+': 2, 'AB-': 1, 'O+': 15, 'O-': 4
      },
      // Tambahkan data bed
      'bedAvailability': {
        'igd': {'total': 8, 'available': 6},
        'vip': {'total': 10, 'available': 3},
        'kelas1': {'total': 22, 'available': 7},
        'kelas2': {'total': 42, 'available': 12},
        'kelas3': {'total': 65, 'available': 8},
        'icu': {'total': 9, 'available': 3},
      },
      'mobilAvailability': {
        'ambulance': {'total': 5, 'available': 2},
        'jenazah': {'total': 2, 'available': 1},
      },
      'rating': 4.2,
      'operatingHours': 'Buka 24 Jam'
    },
    // Rumah Sakit di Jakarta
    {
      'id': '5',
      'name': 'RSUP Fatmawati',
      'address': 'Jl. RS Fatmawati Raya No.4, Cilandak Barat, Cilandak, Jakarta Selatan',
      'latitude': double.parse ("-6.295097893693976"),
      'longitude': double.parse ("106.79649152453"),
      'imageUrl': 'assets/images/rsupfatmawati.jpg',
      'phone': '(021) 7501524',
      'services': ['IGD', 'Rawat Jalan', 'Rawat Inap', 'MCU', 'Rujukan'],
      'isOpen24Hours': true,
      'hasBloodStock': true,
      'acceptsBPJS': true,
      'hasIGD': true,
      'hasMCU': true,
      'bloodStock': {
        'A+': 20, 'A-': 6, 'B+': 12, 'B-': 4, 
        'AB+': 5, 'AB-': 2, 'O+': 25, 'O-': 8
      },
      // Tambahkan data bed
      'bedAvailability': {
        'igd': {'total': 12, 'available': 8},
        'vip': {'total': 18, 'available': 4},
        'kelas1': {'total': 35, 'available': 10},
        'kelas2': {'total': 55, 'available': 18},
        'kelas3': {'total': 85, 'available': 20},
        'icu': {'total': 15, 'available': 7},
      },
      'mobilAvailability': {
        'ambulance': {'total': 5, 'available': 2},
        'jenazah': {'total': 2, 'available': 1},
      },
      'rating': 4.3,
      'operatingHours': 'Buka 24 Jam'
    },
    {
      'id': '6',
      'name': 'RS Pondok Indah',
      'address': 'Jl. Metro Duta Kav. UE, Pd. Pinang, Jakarta Selatan',
      'latitude': double.parse ("-6.266206"),
      'longitude': double.parse ("106.784058"),
      'imageUrl': 'assets/images/pondokindah.png',
      'phone': '(021) 7657525',
      'services': ['IGD', 'Rawat Jalan', 'Rawat Inap', 'MCU'],
      'isOpen24Hours': true,
      'hasBloodStock': true,
      'acceptsBPJS': false, // RS premium swasta
      'hasIGD': true,
      'hasMCU': true,
      'bloodStock': {
        'A+': 8, 'A-': 2, 'B+': 5, 'B-': 1, 
        'AB+': 2, 'AB-': 0, 'O+': 12, 'O-': 3
      },
      // Tambahkan data bed
      'bedAvailability': {
        'igd': {'total': 10, 'available': 7},
        'vip': {'total': 20, 'available': 8},
        'kelas1': {'total': 30, 'available': 12},
        'kelas2': {'total': 50, 'available': 20},
        'kelas3': {'total': 75, 'available': 25},
        'icu': {'total': 12, 'available': 5},
      },
      'mobilAvailability': {
        'ambulance': {'total': 5, 'available': 2},
        'jenazah': {'total': 2, 'available': 0},
      },
      'rating': 4.6,
      'operatingHours': 'Buka 24 Jam'
    },
    {
      'id': '7',
      'name': 'Klinik Husada Jakarta',
      'address': 'Jl. Gatot Subroto No.45, Jakarta Pusat',
      'latitude': double.parse ("-6.210000"),
      'longitude': double.parse ("106.820000"),
      'imageUrl': 'assets/images/husada.jpg',
      'phone': '(021) 5555678',
      'services': ['Rawat Jalan'], // Klinik kecil
      'isOpen24Hours': false,
      'hasBloodStock': false,
      'acceptsBPJS': true,
      'hasIGD': false,
      'hasMCU': false,
      'bloodStock': null,
      // Tambahkan data bed
      'bedAvailability': {
        'igd': {'total': 0, 'available': 0},
        'vip': {'total': 5, 'available': 2},
        'kelas1': {'total': 10, 'available': 3},
        'kelas2': {'total': 20, 'available': 8},
        'kelas3': {'total': 30, 'available': 10},
        'icu': {'total': 0, 'available': 0},
      },
      'rating': 3.8,
      'operatingHours': '07:00 - 21:00'
    },
    // Rumah Sakit di Lampung
    {
      'id': '8',
      'name': 'RSUD Dr. H. Abdul Moeloek',
      'address': 'Jl. Dr. Rivai No.6, Penengahan, Bandar Lampung',
      'latitude': double.parse ('-5.428384'),
      'longitude': double.parse ("105.266792"),
      'imageUrl': 'assets/images/abdulmuluk.png',
      'phone': '(0721) 703312',
      'services': ['IGD', 'Rawat Jalan', 'Rawat Inap', 'MCU'],
      'isOpen24Hours': true,
      'hasBloodStock': true,
      'acceptsBPJS': true,
      'hasIGD': true,
      'hasMCU': true,
      'bloodStock': {
        'A+': 8, 'A-': 2, 'B+': 5, 'B-': 1, 
        'AB+': 2, 'AB-': 0, 'O+': 12, 'O-': 3
      },
      // Tambahkan data bed
      'bedAvailability': {
        'igd': {'total': 8, 'available': 6},
        'vip': {'total': 10, 'available': 2},
        'kelas1': {'total': 20, 'available': 5},
        'kelas2': {'total': 40, 'available': 10},
        'kelas3': {'total': 60, 'available': 15},
        'icu': {'total': 8, 'available': 3},
      },
      'rating': 4.1,
      'operatingHours': 'Buka 24 Jam'
    },
  ];

  static List<Map<String, dynamic>> _localDoctors = [
    {
      'id': 'doc-001',
      'name': 'Dr. Ahmad Rizki, Sp.EM',
      'specialty': 'INSTALASI GAWAT DARURAT',
      'hospitalId': '1',
      'hospitalName': 'RSUP Dr. Hasan Sadikin',
      'location': 'Gawat Darurat',
      'photo': 'assets/images/dr_ahmad_rizki.jpg',
      'status': 'Tersedia',
      'isAvailable': true,
      'schedule': [
        {'day': 'Senin', 'time': '24 Jam'},
        {'day': 'Selasa', 'time': '24 Jam'},
        {'day': 'Rabu', 'time': '24 Jam'},
        {'day': 'Kamis', 'time': '24 Jam'},
        {'day': 'Jumat', 'time': '24 Jam'},
        {'day': 'Sabtu', 'time': '24 Jam'},
        {'day': 'Minggu', 'time': '24 Jam'},
      ],
    },
    {
      'id': 'doc-002',
      'name': 'Dr. Sri Handayani, Sp.PD',
      'specialty': 'PENYAKIT DALAM',
      'hospitalId': '1',
      'hospitalName': 'RSUP Dr. Hasan Sadikin',
      'location': 'Poliklinik Penyakit Dalam - Ruang 3A',
      'photo': 'assets/images/dr_sri_handayani.jpg',
      'status': 'Tersedia',
      'isAvailable': true,
      'schedule': [
        {'day': 'Senin', 'time': '08:00 - 16:00'},
        {'day': 'Rabu', 'time': '08:00 - 16:00'},
        {'day': 'Jumat', 'time': '08:00 - 16:00'},
      ],
    },
    {
      'id': 'doc-003',
      'name': 'Dr. Budi Santoso, Sp.A',
      'specialty': 'ANAK',
      'hospitalId': '1',
      'hospitalName': 'RSUP Dr. Hasan Sadikin',
      'location': 'Poliklinik Anak - Ruang 2B',
      'photo': 'assets/images/dr_budi_santoso.jpg',
      'status': 'Sibuk',
      'isAvailable': false,
      'schedule': [
        {'day': 'Selasa', 'time': '09:00 - 15:00'},
        {'day': 'Kamis', 'time': '09:00 - 15:00'},
      ],
    },
    {
      'id': 'doc-004',
      'name': 'Dr. Maya Sari, Sp.JP',
      'specialty': 'JANTUNG',
      'hospitalId': '2',
      'hospitalName': 'Edelweiss Hospital',
      'location': 'Poliklinik Jantung',
      'photo': 'assets/images/dr_maya_sari.jpg',
      'status': 'Tersedia',
      'isAvailable': true,
      'schedule': [
        {'day': 'Senin', 'time': '08:00 - 16:00'},
        {'day': 'Selasa', 'time': '08:00 - 16:00'},
        {'day': 'Jumat', 'time': '08:00 - 16:00'},
      ],
    },
    {
      'id': 'doc-005',
      'name': 'Dr. Andi Wijaya, Sp.S',
      'specialty': 'SARAF',
      'hospitalId': '2',
      'hospitalName': 'Edelweiss Hospital',
      'location': 'Poliklinik Saraf',
      'photo': 'assets/images/dr_andi_wijaya.jpg',
      'status': 'Tersedia',
      'isAvailable': true,
      'schedule': [
        {'day': 'Selasa', 'time': '10:00 - 14:00'},
        {'day': 'Kamis', 'time': '10:00 - 14:00'},
      ],
    },
    {
      'id': 'doc-006',
      'name': 'Dr. Lisa Permata, Sp.OG',
      'specialty': 'KANDUNGAN',
      'hospitalId': '2',
      'hospitalName': 'Edelweiss Hospital',
      'location': 'Poliklinik Kandungan',
      'photo': 'assets/images/dr_lisa_permata.jpg',
      'status': 'Tersedia',
      'isAvailable': true,
      'schedule': [
        {'day': 'Rabu', 'time': '14:00 - 18:00'},
        {'day': 'Jumat', 'time': '14:00 - 18:00'},
      ],
    },
    // Tambahkan data dokter lainnya...
  ];

  // Metode untuk mendapatkan data dokter
  static List<Map<String, dynamic>> getLocalDoctors() {
    return _localDoctors;
  }

  // Metode untuk mendapatkan dokter berdasarkan rumah sakit
  static List<Doctor> getDoctorsByHospital(String hospitalId) {
    return _localDoctors
        .where((doc) => doc['hospitalId'] == hospitalId)
        .map((doc) => Doctor.fromJson(doc))
        .toList();
  }

  // Metode untuk mencari dokter berdasarkan nama
  static List<Doctor> searchDoctors(String query) {
    query = query.toLowerCase();
    return _localDoctors
        .where((doc) => 
            doc['name'].toString().toLowerCase().contains(query) ||
            doc['specialty'].toString().toLowerCase().contains(query))
        .map((doc) => Doctor.fromJson(doc))
        .toList();
  }
  
  // Metode untuk mendapatkan jadwal dokter per hari
  static List<Doctor> getDoctorsByHospitalAndDay(String hospitalId, String day) {
    return _localDoctors
        .where((doc) => 
            doc['hospitalId'] == hospitalId &&
            (doc['schedule'] as List).any((schedule) => 
                schedule['day'] == day))
        .map((doc) => Doctor.fromJson(doc))
        .toList();
  }


  // Tambahkan metode ini di dalam kelas HospitalService
static List<Map<String, dynamic>> getLocalHospitals() {
  return _localHospitals;
}

  static Future<List<Hospital>> getNearbyHospitals({
    required double latitude,
    required double longitude,
    double radiusInKm = 50.0,
  }) async {
    try {
      // Simulasi loading
      await Future.delayed(Duration(milliseconds: 800));

      List<Hospital> hospitals = _localHospitals
          .map((data) => Hospital.fromJson(data))
          .toList();

      // Calculate distance dan filter berdasarkan radius
      List<Hospital> nearbyHospitals = [];
      for (Hospital hospital in hospitals) {
        double distance = calculateDistance(
          latitude,
          longitude,
          hospital.latitude,
          hospital.longitude,
        );

        if (distance <= radiusInKm) {
          nearbyHospitals.add(hospital.copyWith(
            distance: distance,
          ));
        }
      }

      // Sort berdasarkan jarak terdekat
      nearbyHospitals.sort((a, b) => a.distance!.compareTo(b.distance!));

      return nearbyHospitals;
    } catch (e) {
      print('Error fetching hospitals: $e');
      return [];
    }
  }

  // Fungsi untuk menghitung jarak
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000; // dalam km
  }
}