import 'dart:convert';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import '../models/hospital_model.dart';

class HospitalService {
  // Data rumah sakit dengan gambar lokal
  static List<Map<String, dynamic>> _localHospitals = [
    // Rumah Sakit di Bandung
    {
      'id': '1',
      'name': 'RSUP Dr. Hasan Sadikin',
      'address': 'Jl. Pasteur No.38, Pasteur, Kec. Sukajadi, Kota Bandung',
      'latitude': -6.898274,
      'longitude': 107.610161,
      'imageUrl': 'assets/images/hasansadikin.png', // Gambar lokal
      'phone': '(022) 2038285',
      'services': ['IGD', 'Rawat Jalan', 'Rawat Inap', 'MCU']
    },
    {
      'id': '2',
      'name': 'Edelweiss Hospital',
      'address': 'Jl. Cihampelas No.161, Cipaganti, Kec. Coblong, Kota Bandung',
      'latitude': -6.899497,
      'longitude': 107.616318,
      'imageUrl': 'assets/images/edelweiss.jpg',
      'phone': '(022) 2552000',
      'services': ['IGD', 'Rawat Jalan', 'Rawat Inap', 'MCU', 'Persalinan']
    },
    {
      'id': '3',
      'name': 'RS Advent Bandung',
      'address': 'Jl. Cihampelas No.161, Cipaganti, Kec. Coblong, Kota Bandung',
      'latitude': -6.893483,
      'longitude': 107.605247,
      'imageUrl': 'assets/images/rsadvent.jpg',
      'phone': '(022) 2034386',
      'services': ['IGD', 'Rawat Jalan', 'Rawat Inap', 'MCU']
    },
    {
      'id': '4',
      'name': 'RS Hermina Arcamanik',
      'address': 'Jl. A.H. Nasution No.50, Antapani Wetan, Kec. Antapani, Kota Bandung',
      'latitude': -6.914684,
      'longitude': 107.665428,
      'imageUrl': 'assets/images/hermina1.jpg',
      'phone': '(022) 87242525',
      'services': ['IGD', 'Rawat Jalan', 'Rawat Inap', 'MCU']
    },
    // {
    //   'id': '5',
    //   'name': 'RSUD Ujung Berung',
    //   'address': 'Jl. A.H. Nasution, Ujung Berung, Kota Bandung',
    //   'latitude': -6.914257,
    //   'longitude': 107.707710,
    //   'imageUrl': 'assets/images/rsud_ujung_berung.jpg',
    //   'phone': '(022) 7801013',
    //   'services': ['IGD', 'Rawat Jalan', 'Rawat Inap']
    // },
    // Rumah Sakit di Jakarta
    {
      'id': '6',
      'name': 'RSUP Fatmawati',
      'address': 'Jl. RS Fatmawati Raya No.4, Cilandak Barat, Cilandak, Jakarta Selatan',
      'latitude': -6.289764,
      'longitude': 106.800003,
      'imageUrl': 'assets/images/rsupfatmawati.jpg',
      'phone': '(021) 7501524',
      'services': ['IGD', 'Rawat Jalan', 'Rawat Inap', 'MCU']
    },
    {
      'id': '7',
      'name': 'RS Pondok Indah',
      'address': 'Jl. Metro Duta Kav. UE, Pd. Pinang, Jakarta Selatan',
      'latitude': -6.266206,
      'longitude': 106.784058,
      'imageUrl': 'assets/images/pondokindah.png',
      'phone': '(021) 7657525',
      'services': ['IGD', 'Rawat Jalan', 'Rawat Inap', 'MCU']
    },
    // Rumah Sakit di Lampung
    {
      'id': '8',
      'name': 'RSUD Dr. H. Abdul Moeloek',
      'address': 'Jl. Dr. Rivai No.6, Penengahan, Bandar Lampung',
      'latitude': -5.428384,
      'longitude': 105.266792,
      'imageUrl': 'assets/images/abdulmuluk.png', // Pakai yang sudah ada
      'phone': '(0721) 703312',
      'services': ['IGD', 'Rawat Jalan', 'Rawat Inap', 'MCU']
    }
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