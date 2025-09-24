import 'dart:convert';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import '../models/hospital_model.dart';

class HospitalService {
  // Data rumah sakit dengan informasi lengkap dan akurat
  static List<Map<String, dynamic>> _localHospitals = [
    // Rumah Sakit di Bandung
    {
      'id': '1',
      'name': 'RSUP Dr. Hasan Sadikin',
      'address': 'Jl. Pasteur No.38, Pasteur, Kec. Sukajadi, Kota Bandung',
      'latitude': -6.898274,
      'longitude': 107.610161,
      'imageUrl': 'assets/images/hasansadikin.png',
      'phone': '(022) 2038285',
      'services': ['IGD 24 Jam', 'Rawat Jalan', 'Rawat Inap', 'MCU', 'Spesialis', 'Rujukan'],
      'isOpen24Hours': true,
      'hasBloodStock': true,
      'acceptsBPJS': true,
      'hasIGD': true,
      'hasMCU': true,
      'bloodStock': {
        'A+': 15, 'A-': 3, 'B+': 8, 'B-': 2, 
        'AB+': 4, 'AB-': 1, 'O+': 20, 'O-': 6
      },
      'rating': 4.5,
      'operatingHours': 'Buka 24 Jam'
    },
    {
      'id': '2',
      'name': 'Edelweiss Hospital',
      'address': 'Jl. Cihampelas No.161, Cipaganti, Kec. Coblong, Kota Bandung',
      'latitude': -6.899497,
      'longitude': 107.616318,
      'imageUrl': 'assets/images/edelweiss.jpg',
      'phone': '(022) 2552000',
      'services': ['IGD 24 Jam', 'Rawat Jalan', 'Rawat Inap', 'MCU', 'Persalinan'],
      'isOpen24Hours': true,
      'hasBloodStock': true,
      'acceptsBPJS': true,
      'hasIGD': true,
      'hasMCU': true,
      'bloodStock': {
        'A+': 12, 'A-': 4, 'B+': 6, 'B-': 1, 
        'AB+': 3, 'AB-': 0, 'O+': 18, 'O-': 5
      },
      'rating': 4.3,
      'operatingHours': 'Buka 24 Jam'
    },
    {
      'id': '3',
      'name': 'RS Advent Bandung',
      'address': 'Jl. Cihampelas No.161, Cipaganti, Kec. Coblong, Kota Bandung',
      'latitude': -6.893483,
      'longitude': 107.605247,
      'imageUrl': 'assets/images/rsadvent.jpg',
      'phone': '(022) 2034386',
      'services': ['IGD 24 Jam', 'Rawat Jalan', 'Rawat Inap', 'MCU'],
      'isOpen24Hours': true,
      'hasBloodStock': false, // RS swasta premium, stok darah terbatas
      'acceptsBPJS': false, // RS premium, tidak terima BPJS
      'hasIGD': true,
      'hasMCU': true,
      'bloodStock': null,
      'rating': 4.4,
      'operatingHours': 'Buka 24 Jam'
    },
    {
      'id': '4',
      'name': 'RS Hermina Arcamanik',
      'address': 'Jl. A.H. Nasution No.50, Antapani Wetan, Kec. Antapani, Kota Bandung',
      'latitude': -6.914684,
      'longitude': 107.665428,
      'imageUrl': 'assets/images/hermina1.jpg',
      'phone': '(022) 87242525',
      'services': ['IGD 24 Jam', 'Rawat Jalan', 'Rawat Inap', 'MCU', 'Kandungan'],
      'isOpen24Hours': true,
      'hasBloodStock': true,
      'acceptsBPJS': true,
      'hasIGD': true,
      'hasMCU': true,
      'bloodStock': {
        'A+': 10, 'A-': 2, 'B+': 7, 'B-': 1, 
        'AB+': 2, 'AB-': 1, 'O+': 15, 'O-': 4
      },
      'rating': 4.2,
      'operatingHours': 'Buka 24 Jam'
    },
    // Rumah Sakit di Jakarta
    {
      'id': '5',
      'name': 'RSUP Fatmawati',
      'address': 'Jl. RS Fatmawati Raya No.4, Cilandak Barat, Cilandak, Jakarta Selatan',
      'latitude': -6.289764,
      'longitude': 106.800003,
      'imageUrl': 'assets/images/rsupfatmawati.jpg',
      'phone': '(021) 7501524',
      'services': ['IGD 24 Jam', 'Rawat Jalan', 'Rawat Inap', 'MCU', 'Rujukan'],
      'isOpen24Hours': true,
      'hasBloodStock': true,
      'acceptsBPJS': true,
      'hasIGD': true,
      'hasMCU': true,
      'bloodStock': {
        'A+': 20, 'A-': 6, 'B+': 12, 'B-': 4, 
        'AB+': 5, 'AB-': 2, 'O+': 25, 'O-': 8
      },
      'rating': 4.3,
      'operatingHours': 'Buka 24 Jam'
    },
    {
      'id': '6',
      'name': 'RS Pondok Indah',
      'address': 'Jl. Metro Duta Kav. UE, Pd. Pinang, Jakarta Selatan',
      'latitude': -6.266206,
      'longitude': 106.784058,
      'imageUrl': 'assets/images/pondokindah.png',
      'phone': '(021) 7657525',
      'services': ['IGD 24 Jam', 'Rawat Jalan', 'Rawat Inap', 'MCU'],
      'isOpen24Hours': true,
      'hasBloodStock': true,
      'acceptsBPJS': false, // RS premium swasta
      'hasIGD': true,
      'hasMCU': true,
      'bloodStock': {
        'A+': 8, 'A-': 2, 'B+': 5, 'B-': 1, 
        'AB+': 2, 'AB-': 0, 'O+': 12, 'O-': 3
      },
      'rating': 4.6,
      'operatingHours': 'Buka 24 Jam'
    },
    {
      'id': '7',
      'name': 'Klinik Husada Jakarta',
      'address': 'Jl. Gatot Subroto No.45, Jakarta Pusat',
      'latitude': -6.210000,
      'longitude': 106.820000,
      'imageUrl': 'assets/images/husada.jpg',
      'phone': '(021) 5555678',
      'services': ['Rawat Jalan'], // Klinik kecil
      'isOpen24Hours': false,
      'hasBloodStock': false,
      'acceptsBPJS': true,
      'hasIGD': false,
      'hasMCU': false,
      'bloodStock': null,
      'rating': 3.8,
      'operatingHours': '07:00 - 21:00'
    },
    // Rumah Sakit di Lampung
    {
      'id': '8',
      'name': 'RSUD Dr. H. Abdul Moeloek',
      'address': 'Jl. Dr. Rivai No.6, Penengahan, Bandar Lampung',
      'latitude': -5.428384,
      'longitude': 105.266792,
      'imageUrl': 'assets/images/abdulmuluk.png',
      'phone': '(0721) 703312',
      'services': ['IGD 24 Jam', 'Rawat Jalan', 'Rawat Inap', 'MCU'],
      'isOpen24Hours': true,
      'hasBloodStock': true,
      'acceptsBPJS': true,
      'hasIGD': true,
      'hasMCU': true,
      'bloodStock': {
        'A+': 8, 'A-': 2, 'B+': 5, 'B-': 1, 
        'AB+': 2, 'AB-': 0, 'O+': 12, 'O-': 3
      },
      'rating': 4.1,
      'operatingHours': 'Buka 24 Jam'
    },
  ];

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
          nearbyHospitals.add(hospital.copyWith(distance: distance));
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