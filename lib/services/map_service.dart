import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:map_launcher/map_launcher.dart';
import '../models/hospital_model.dart';

class MapsService {
  /// Membuka maps dengan berbagai opsi aplikasi yang tersedia
  static Future<void> openMapsWithOptions(Hospital hospital) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;

      if (availableMaps.isNotEmpty) {
        // Tampilkan marker di aplikasi maps pertama yang ditemukan
        await MapLauncher.showMarker(
          mapType: availableMaps.first.mapType,
          coords: Coords(hospital.latitude, hospital.longitude),
          title: hospital.name,
          description: hospital.address,
        );
      } else {
        // Fallback ke browser jika tidak ada aplikasi maps
        await _openInBrowser(hospital);
      }
    } catch (e) {
      print('Error opening maps: $e');
      // Fallback ke browser
      await _openInBrowser(hospital);
    }
  }

  /// Membuka Google Maps langsung
  static Future<void> openGoogleMaps(Hospital hospital) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;
      
      AvailableMap? googleMaps;
      try {
        googleMaps = availableMaps.firstWhere(
          (map) => map.mapType == MapType.google,
        );
      } catch (e) {
        googleMaps = availableMaps.isNotEmpty ? availableMaps.first : null;
      }

      if (googleMaps != null) {
        await googleMaps.showMarker(
          coords: Coords(hospital.latitude, hospital.longitude),
          title: hospital.name,
          description: hospital.address,
        );
      } else {
        await _openInBrowser(hospital);
      }
    } catch (e) {
      await _openInBrowser(hospital);
    }
  }

  /// Membuka Apple Maps (untuk iOS)
  static Future<void> openAppleMaps(Hospital hospital) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;
      
      AvailableMap? appleMaps;
      try {
        appleMaps = availableMaps.firstWhere(
          (map) => map.mapType == MapType.apple,
        );
      } catch (e) {
        appleMaps = availableMaps.isNotEmpty ? availableMaps.first : null;
      }

      if (appleMaps != null) {
        await appleMaps.showMarker(
          coords: Coords(hospital.latitude, hospital.longitude),
          title: hospital.name,
          description: hospital.address,
        );
      } else {
        await _openInBrowser(hospital);
      }
    } catch (e) {
      await _openInBrowser(hospital);
    }
  }

  /// Menampilkan dialog untuk memilih aplikasi maps
  static Future<void> showMapsSelectionDialog(BuildContext context, Hospital hospital) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;

      if (availableMaps.length == 1) {
        // Langsung buka jika hanya ada satu aplikasi
        await availableMaps.first.showMarker(
          coords: Coords(hospital.latitude, hospital.longitude),
          title: hospital.name,
          description: hospital.address,
        );
      } else if (availableMaps.length > 1) {
        // Tampilkan dialog pilihan
        await showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (BuildContext context) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.map, color: Color(0xFFFF6B35)),
                        SizedBox(width: 8),
                        Text(
                          'Pilih Aplikasi Maps',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1),
                  ...availableMaps.map((map) {
                    return ListTile(
                      leading: Icon(
                        _getMapIcon(map.mapType),
                        color: _getMapColor(map.mapType),
                      ),
                      title: Text(map.mapName),
                      subtitle: Text('Buka lokasi ${hospital.name}'),
                      onTap: () async {
                        Navigator.pop(context);
                        await map.showMarker(
                          coords: Coords(hospital.latitude, hospital.longitude),
                          title: hospital.name,
                          description: hospital.address,
                        );
                      },
                    );
                  }).toList(),
                  ListTile(
                    leading: Icon(Icons.web, color: Colors.blue),
                    title: Text('Buka di Browser'),
                    subtitle: Text('Google Maps di browser web'),
                    onTap: () async {
                      Navigator.pop(context);
                      await _openInBrowser(hospital);
                    },
                  ),
                  SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      } else {
        // Tidak ada aplikasi maps, buka di browser
        await _openInBrowser(hospital);
      }
    } catch (e) {
      print('Error showing maps selection: $e');
      await _openInBrowser(hospital);
    }
  }

  /// Membuka rute/navigasi ke rumah sakit
  static Future<void> openNavigation(Hospital hospital, {double? userLat, double? userLng}) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;
      
      if (availableMaps.isNotEmpty) {
        if (userLat != null && userLng != null) {
          // Buka dengan navigasi dari lokasi user
          await availableMaps.first.showDirections(
            destination: Coords(hospital.latitude, hospital.longitude),
            origin: Coords(userLat, userLng),
            destinationTitle: hospital.name,
            directionsMode: DirectionsMode.driving,
          );
        } else {
          // Hanya tampilkan marker
          await availableMaps.first.showMarker(
            coords: Coords(hospital.latitude, hospital.longitude),
            title: hospital.name,
            description: hospital.address,
          );
        }
      } else {
        await _openNavigationInBrowser(hospital, userLat, userLng);
      }
    } catch (e) {
      print('Error opening navigation: $e');
      await _openNavigationInBrowser(hospital, userLat, userLng);
    }
  }

  /// Helper method untuk membuka di browser sebagai fallback
  static Future<void> _openInBrowser(Hospital hospital) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=${hospital.latitude},${hospital.longitude}';
    final uri = Uri.parse(url);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  /// Helper method untuk membuka navigasi di browser
  static Future<void> _openNavigationInBrowser(Hospital hospital, double? userLat, double? userLng) async {
    String url;
    
    if (userLat != null && userLng != null) {
      // URL dengan navigasi dari lokasi user
      url = 'https://www.google.com/maps/dir/$userLat,$userLng/${hospital.latitude},${hospital.longitude}';
    } else {
      // URL hanya ke lokasi rumah sakit
      url = 'https://www.google.com/maps/search/?api=1&query=${hospital.latitude},${hospital.longitude}';
    }
    
    final uri = Uri.parse(url);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print('Could not launch $url');
      }
    } catch (e) {
      print('Error launching navigation URL: $e');
    }
  }

  /// Helper method untuk mendapatkan icon berdasarkan tipe map
  static IconData _getMapIcon(MapType mapType) {
    switch (mapType) {
      case MapType.google:
        return Icons.map;
      case MapType.apple:
        return Icons.map_outlined;
      case MapType.waze:
        return Icons.navigation;
      case MapType.here:
        return Icons.location_on;
      default:
        return Icons.map;
    }
  }

  /// Helper method untuk mendapatkan warna berdasarkan tipe map
  static Color _getMapColor(MapType mapType) {
    switch (mapType) {
      case MapType.google:
        return Colors.blue;
      case MapType.apple:
        return Colors.grey[700]!;
      case MapType.waze:
        return Colors.cyan;
      case MapType.here:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  /// Membuka aplikasi Waze khusus untuk navigasi
  static Future<void> openWaze(Hospital hospital) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;
      
      AvailableMap? waze;
      try {
        waze = availableMaps.firstWhere(
          (map) => map.mapType == MapType.waze,
        );
      } catch (e) {
        waze = null;
      }

      if (waze != null) {
        await waze.showMarker(
          coords: Coords(hospital.latitude, hospital.longitude),
          title: hospital.name,
          description: hospital.address,
        );
      } else {
        // Fallback ke URL scheme Waze
        await _openWazeByUrl(hospital);
      }
    } catch (e) {
      print('Error opening Waze: $e');
      await _openWazeByUrl(hospital);
    }
  }

  /// Helper method untuk membuka Waze via URL scheme
  static Future<void> _openWazeByUrl(Hospital hospital) async {
    try {
      final wazeUrl = 'waze://?ll=${hospital.latitude},${hospital.longitude}&navigate=yes&z=17';
      final uri = Uri.parse(wazeUrl);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback ke web version
        final webUrl = 'https://waze.com/ul?ll=${hospital.latitude},${hospital.longitude}&navigate=yes';
        final webUri = Uri.parse(webUrl);
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('Error opening Waze by URL: $e');
      await _openInBrowser(hospital);
    }
  }

  /// Method untuk mendapatkan daftar aplikasi maps yang terinstall
  static Future<List<AvailableMap>> getInstalledMapsApps() async {
    try {
      return await MapLauncher.installedMaps;
    } catch (e) {
      print('Error getting installed maps: $e');
      return [];
    }
  }

  /// Method untuk mengecek apakah ada aplikasi maps yang terinstall
  static Future<bool> isAnyMapAppInstalled() async {
    try {
      final maps = await MapLauncher.installedMaps;
      return maps.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Method untuk mendapatkan URL koordinat untuk copy-paste
  static String getCoordinatesString(Hospital hospital) {
    return '${hospital.latitude}, ${hospital.longitude}';
  }

  /// Method untuk mendapatkan Google Maps URL
  static String getGoogleMapsUrl(Hospital hospital) {
    return 'https://www.google.com/maps/search/?api=1&query=${hospital.latitude},${hospital.longitude}';
  }

  /// Method untuk mendapatkan URL navigasi dari posisi tertentu
  static String getNavigationUrl(Hospital hospital, double fromLat, double fromLng) {
    return 'https://www.google.com/maps/dir/$fromLat,$fromLng/${hospital.latitude},${hospital.longitude}';
  }
}