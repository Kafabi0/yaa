import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inocare/screens/order_farmasi.dart';
import 'package:inocare/screens/order_forensik.dart';
import 'package:inocare/screens/order_lab.dart';
import 'package:inocare/screens/order_radiologi.dart';
import 'package:inocare/screens/order_utdrs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'order_ambulance.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

/// Simpan notifikasi order
Future<void> _saveOrderNotification(
  String serviceType,
  String nomorOrder,
) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> notifs = prefs.getStringList('order_notifications') ?? [];

  String newNotif =
      "$serviceType|Nomor order Anda: $nomorOrder|${DateTime.now().toIso8601String()}";
  notifs.add(newNotif);

  await prefs.setStringList('order_notifications', notifs);
}

/// Generate nomor order unik per layanan
Future<String> _generateOrderNumber(String serviceType) async {
  final prefs = await SharedPreferences.getInstance();

  final Map<String, String> prefixMap = {
    'Ambulance': 'A',
    'Farmasi': 'F',
    'Lab': 'L',
    'Radiologi': 'R',
    'Forensik': 'FRS',
    'UTDRS': 'U',
  };

  final prefix = prefixMap[serviceType] ?? 'X';

  int current = prefs.getInt('counter_$serviceType') ?? 0;
  current++;

  await prefs.setInt('counter_$serviceType', current);

  return "$prefix-${current.toString().padLeft(3, '0')}";
}

class _OrderPageState extends State<OrderPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;

    double fontScale = screenWidth / 400;
    fontScale = fontScale.clamp(0.8, 1.2);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(fontScale),
            _buildSearchBar(fontScale),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildOrderCard(
                      title: 'Order Ambulance',
                      subtitle: '3 Ambulance Tersedia',
                      buttonText: 'Order Sekarang',
                      colors: [Colors.red[600]!, Colors.red[800]!],
                      icon: FontAwesomeIcons.truckMedical,
                      fontScale: fontScale,
                      onTap: () => _showOrderDialog('Ambulance'),
                    ),
                    const SizedBox(height: 16),
                    _buildOrderCard(
                      title: 'Order Farmasi',
                      subtitle: '',
                      buttonText: 'Order Sekarang',
                      colors: [Colors.green[600]!, Colors.green[800]!],
                      icon: FontAwesomeIcons.pills,
                      fontScale: fontScale,
                      onTap: () => _showOrderDialog('Farmasi'),
                    ),
                    const SizedBox(height: 16),
                    _buildOrderCard(
                      title: 'Order Lab',
                      subtitle: '',
                      buttonText: 'Cek Ketersediaan Lab',
                      colors: [Colors.blue[500]!, Colors.blue[700]!],
                      icon: Icons.biotech,
                      fontScale: fontScale,
                      onTap: () => _showOrderDialog('Lab'),
                    ),
                    const SizedBox(height: 16),
                    _buildOrderCard(
                      title: 'Order Radiologi',
                      subtitle: '',
                      buttonText: 'Cek Ketersediaan Radiologi',
                      colors: [Colors.grey[600]!, Colors.grey[800]!],
                      icon: FontAwesomeIcons.xRay,
                      fontScale: fontScale,
                      onTap: () => _showOrderDialog('Radiologi'),
                    ),
                    const SizedBox(height: 16),
                    _buildOrderCard(
                      title: 'Order Forensik',
                      subtitle: '',
                      buttonText: 'Cek Ketersediaan Forensik',
                      colors: [Colors.indigo[600]!, Colors.indigo[800]!],
                      icon: FontAwesomeIcons.magnifyingGlass,
                      fontScale: fontScale,
                      onTap: () => _showOrderDialog('Forensik'),
                    ),
                    const SizedBox(height: 16),
                    _buildOrderCard(
                      title: 'Order UTDRS',
                      subtitle: '',
                      buttonText: 'Cek Ketersediaan UTDRS',
                      colors: [Colors.red[700]!, Colors.red[900]!],
                      icon: FontAwesomeIcons.droplet,
                      fontScale: fontScale,
                      onTap: () => _showOrderDialog('UTDRS'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double fontScale) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40 * fontScale,
              height: 40 * fontScale,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20 * fontScale,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Order Services',
            style: TextStyle(
              fontSize: 24 * fontScale,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(double fontScale) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _searchController,
        style: TextStyle(fontSize: 14 * fontScale),
        decoration: InputDecoration(
          hintText: 'Cari Aja Dulu ...',
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 14 * fontScale,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[500],
            size: 20 * fontScale,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20 * fontScale,
            vertical: 12 * fontScale,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard({
    required String title,
    required String subtitle,
    required String buttonText,
    required List<Color> colors,
    required IconData icon,
    required double fontScale,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20 * fontScale),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors[0].withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20 * fontScale,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14 * fontScale,
                ),
              ),
            ],
            SizedBox(height: 16 * fontScale),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16 * fontScale,
                    vertical: 8 * fontScale,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        buttonText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12 * fontScale,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 16 * fontScale,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 60 * fontScale,
                  height: 60 * fontScale,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(icon, color: Colors.white, size: 30 * fontScale),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDialog(String serviceType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.medical_services,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  serviceType,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Apakah Anda ingin melanjutkan order untuk layanan $serviceType?',
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();

                String nomorOrder = await _generateOrderNumber(serviceType);
                await _saveOrderNotification(serviceType, nomorOrder);

                _showSuccessSnackbar(serviceType);

                // 🔥 Navigasi sesuai servicenya
                Widget page;
                switch (serviceType) {
                  case 'Ambulance':
                    page = const OrderAmbulancePage();
                    break;
                  case 'Farmasi':
                    page = const OrderFarmasiPage();
                    break;
                  case 'Lab':
                    page = const OrderLabPage();
                    break;
                  case 'Radiologi':
                    page = const OrderRadiologiPage();
                    break;
                  case 'Forensik':
                    page = const OrderForensikPage();
                    break;
                  case 'UTDRS':
                    page = const OrderUTDRSPage();
                    break;
                  default:
                    return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => page),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Lanjutkan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessSnackbar(String serviceType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('Order $serviceType berhasil dibuat!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
