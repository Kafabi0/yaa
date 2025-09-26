import 'package:flutter/material.dart';
import 'package:inocare/screens/login.dart';
import 'rumahsakitpublic.dart';
import 'webview_page.dart';
import 'package:inocare/screens/order.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inocare/services/location_service.dart';
import 'package:inocare/models/hospital_model.dart';
import 'package:inocare/services/hospital_service.dart'; 
import 'package:inocare/widgets/nearest_hospital_widget.dart';
import 'package:inocare/screens/artikel_semua_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HealthAppHomePage extends StatefulWidget {
  final VoidCallback? onLoginSuccess;
  final bool isLoggedIn;

  const HealthAppHomePage({
    Key? key,
    this.onLoginSuccess,
    this.isLoggedIn = false,
  }) : super(key: key);

  @override
  State<HealthAppHomePage> createState() => _HealthAppHomePageState();
}

class _HealthAppHomePageState extends State<HealthAppHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _promoPageController = PageController();
  int _currentPromoIndex = 0;
  int _currentIndex = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  Position? _currentPosition;
  String _currentAddress = 'Mendapatkan lokasi...';
  String _fullAddress = 'Mendapatkan lokasi...';
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _startPromoAutoSlide();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
  try {
    setState(() {
      _isLoadingLocation = true;
      _currentAddress = 'Mendapatkan lokasi...';
      _fullAddress = 'Mendapatkan lokasi...'; 
    });

    Position? position = await LocationService.getCurrentPosition();
    
    if (position != null) {
      setState(() {
        _currentPosition = position;
      });

      // Dapatkan alamat dari koordinat
      String address = await LocationService.getAddressFromCoordinates(
        position.latitude, 
        position.longitude
      );

      setState(() {
        _fullAddress = address; 
        _currentAddress = _truncateAddress(address);
        _isLoadingLocation = false;
      });
    } else {
      setState(() {
        _currentAddress = 'Lokasi tidak tersedia';
        _fullAddress = 'Lokasi tidak tersedia';
        _isLoadingLocation = false;
      });
      
      _showLocationPermissionDialog();
    }
  } catch (e) {
    setState(() {
      _currentAddress = 'Gagal mendapatkan lokasi';
      _fullAddress = 'Gagal mendapatkan lokasi';
      _isLoadingLocation = false;
    });
  }
}

  String _truncateAddress(String address) {
    if (address.length > 35) {
      return '${address.substring(0, 35)}...';
    }
    return address;
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.location_on, color: Color(0xFFFF6B35)),
              SizedBox(width: 8),
              Text('Izin Lokasi'),
            ],
          ),
          content: Text(
            'Aplikasi memerlukan izin lokasi untuk menampilkan rumah sakit terdekat. Mohon aktifkan lokasi pada pengaturan.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _currentAddress = 'Lokasi dinonaktifkan';
                });
              },
              child: Text('Nanti',
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                bool opened = await LocationService.openLocationSettings();
                if (!opened) {
                  await LocationService.openAppSettings();
                }
                // Coba ambil lokasi lagi setelah 2 detik
                Future.delayed(Duration(seconds: 2), () {
                  _getCurrentLocation();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF6B35),
              ),
              child: Text('Buka Pengaturan',
              style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // Tambahkan method ini di dalam class _HealthAppHomePageState
void _showFullLocationDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 16,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.white, Color(0xFFFFF5F5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF6B35), Color(0xFFFF8A50)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Lokasi Saat Ini',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Text(
                  _fullAddress,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xFFFF6B35),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size(60, 30),
                    ),
                    child: Text(
                      'Tutup',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _getCurrentLocation();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF6B35),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Perbarui Lokasi',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
}

Widget _buildLocationWidget() {
  return GestureDetector(
    onTap: () {
      if (!_isLoadingLocation) {
        _getCurrentLocation();
      }
    },
    onLongPress: _showFullLocationDialog, // Tambah ini
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _isLoadingLocation
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Icon(Icons.location_on, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _currentAddress,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (!_isLoadingLocation) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.refresh,
              color: Colors.white.withOpacity(0.8),
              size: 16,
            ),
          ],
        ],
      ),
    ),
  );
}

  void _openArticle(String url, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => HybridWebView(url: url)),
    );
  }

  void _startPromoAutoSlide() {
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _currentPromoIndex = (_currentPromoIndex + 1) % 3;
        });
        _promoPageController.animateToPage(
          _currentPromoIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _startPromoAutoSlide();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _promoPageController.dispose();
    super.dispose();
  }

  void _navigateToLogin() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _showLoginRequired(String feature) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 16,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.white, Color(0xFFFFF5F5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFFFF8A50)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Login Diperlukan',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Untuk mengakses $feature, Anda perlu masuk ke akun terlebih dahulu.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HealthAppHomePage(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFFFF6B35),
                          side: BorderSide(color: Color(0xFFFF6B35)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Batal',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _navigateToLogin();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF6B35),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
  }

  // Method untuk handle navigation dengan login check
  void _onNavTap(int index) {
    // Jika user belum login dan mencoba akses selain Home (index 0)
    if (!widget.isLoggedIn && index != 0) {
      // Tampilkan popup login required dengan nama fitur yang sesuai
      String featureName = _getFeatureName(index);
      _showLoginRequired(featureName);

      // Reset navigation bar ke posisi home setelah delay singkat
      Future.delayed(Duration(milliseconds: 100), () {
        if (mounted && _bottomNavigationKey.currentState != null) {
          _bottomNavigationKey.currentState!.setPage(0);
        }
      });
      return;
    }

    // Jika sudah login atau mengakses Home, lanjutkan navigasi normal
    setState(() {
      _currentIndex = index;
    });
  }

  // Method untuk mendapatkan nama fitur berdasarkan index
  String _getFeatureName(int index) {
    switch (index) {
      case 1:
        return 'fitur Order';
      case 2:
        return 'fitur Live Tracking';
      case 3:
        return 'fitur Riwayat';
      case 4:
        return 'fitur Settings';
      default:
        return 'fitur ini';
    }
  }

  Widget _buildBottomNavigation() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: _currentIndex,
      onTap: _onNavTap, // Gunakan method yang sudah dimodifikasi
      color: isDark ? const Color(0xFF1E1E2C) : Colors.orange,
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: isDark ? const Color(0xFF1E1E2C) : Colors.orange,
      height: 70,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      items: [
        _buildNavItemWithLabel(FontAwesomeIcons.house, 'Home'),
        _buildNavItemWithLabel(FontAwesomeIcons.clipboardList, 'Order'),
        _buildNavItemWithLabel(FontAwesomeIcons.satellite, 'Live'),
        _buildNavItemWithLabel(FontAwesomeIcons.clockRotateLeft, 'Riwayat'),
        _buildNavItemWithLabel(FontAwesomeIcons.gear, 'Setting'),
      ],
    );
  }

  Widget _buildNavItemWithLabel(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildOtherPages() {
    // Hanya tampilkan halaman lain jika user sudah login
    if (!widget.isLoggedIn) {
      return _buildHomePage();
    }

    switch (_currentIndex) {
      case 1: // Order
        return const OrderPage();
      case 2: // Live
        return _buildLivePage();
      case 3: // Riwayat
        return _buildRiwayatPage();
      case 4: // Setting
        return _buildSettingPage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildLivePage() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Live Tracking'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.satellite_alt, size: 80, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'Live Tracking',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Halaman dalam pengembangan',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiwayatPage() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Riwayat'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'Riwayat',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Halaman dalam pengembangan',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingPage() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 80, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Halaman dalam pengembangan',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _currentIndex == 0 ? _buildHomePage() : _buildOtherPages(),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildSearchSection(),
          _buildNearestHospitalSection(),
          _buildQuickAccessSection(),
          _buildTodaySection(),
          _buildPromoSection(),
          _buildHealthArticlesSection(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader() {
  return SafeArea(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFF8A50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Row(
        children: [
          // Kiri - Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Selamat Datang',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => _navigateToLogin(),
                  child: Text(
                    'Login / Register',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Kanan - Notifikasi + Lokasi (Stacked)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Notifikasi + Lokasi dalam satu baris
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Widget lokasi mini dengan long press
                  GestureDetector(
                    onTap: () {
                      if (!_isLoadingLocation) {
                        _getCurrentLocation();
                      }
                    },
                    onLongPress: _showFullLocationDialog, // Tambah ini
                    child: _buildMiniLocationWidget(),
                  ),
                  SizedBox(width: 8),
                  // Notifikasi
                  GestureDetector(
                    onTap: () => _showLoginRequired('Notifikasi'),
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildMiniLocationWidget() {
  return GestureDetector(
    onTap: () {
      if (!_isLoadingLocation) {
        _getCurrentLocation();
      }
    },
    child: Container(
      constraints: BoxConstraints(maxWidth: 120), 
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _isLoadingLocation
              ? SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Icon(Icons.location_on, color: Colors.white, size: 12),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              _getShortAddress(_currentAddress),
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}

String _getShortAddress(String address) {
  if (address.contains('Mendapatkan') || address.contains('Gagal')) {
    return address.length > 25 ? '${address.substring(0, 25)}...' : address;
  }
  
  // Ambil bagian penting dari alamat (kota/kecamatan)
  List<String> parts = address.split(', ');
  if (parts.length >= 2) {
    String result = parts.length >= 3 ? parts[2] : parts[1];
    return result.length > 25 ? '${result.substring(0, 25)}...' : result; 
  }
  
  return address.length > 25 ? '${address.substring(0, 25)}...' : address; 
}

  double? _calculateDistance(double hospitalLat, double hospitalLng) {
    if (_currentPosition == null) return null;
    
    return Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      hospitalLat,
      hospitalLng,
    );
  }

  Widget _buildDistanceWidget(double? distance) {
    if (distance == null) return SizedBox.shrink();
    
    String distanceText;
    if (distance < 1000) {
      distanceText = '${distance.toInt()} m';
    } else {
      distanceText = '${(distance / 1000).toStringAsFixed(1)} km';
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        distanceText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Login untuk mencari layanan...',
            prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          readOnly: true,
          onTap: () => _showLoginRequired('Pencarian'),
        ),
      ),
    );
  }

  Widget _buildNearestHospitalSection() {
  return NearestHospitalSection(
    currentPosition: _currentPosition,
    onSeeAllPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RumahSakitPublicPage(),
        ),
      );
    },
    onLocationRefresh: () { // Tambah ini
      _getCurrentLocation();
    }
  );
}

  Widget _buildQuickAccessSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuickAccessItem(
            icon: Icons.book,
            label: 'Panduan\nSingkat',
            onTap: () => _showPanduanSingkat(),
          ),
          _buildQuickAccessItem(
            icon: Icons.how_to_reg,
            label: 'Cara\nMendaftar',
            onTap: () => _showCaraMendaftar(),
          ),
          _buildQuickAccessItem(
            icon: Icons.headset_mic,
            label: 'FAQ\n',
            onTap: () => _showFAQ(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Color(0xFFFF6B35),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _showPanduanSingkat() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PanduanSingkatWidget(),
        fullscreenDialog: true,
      ),
    );
  }

  void _showCaraMendaftar() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CaraMendaftarWidget(),
        fullscreenDialog: true,
      ),
    );
  }

  void _showFAQ() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FAQWidget(),
        fullscreenDialog: true,
      ),
    );
  }

  Widget _buildTodaySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Color(0xFFFF6B35)),
                    const SizedBox(width: 8),
                    Text(
                      'Hari Ini',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFFFF6B35)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on, color: Colors.red, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '                     ',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTodayItem(
              icon: Icons.bloodtype,
              iconColor: const Color.fromARGB(255, 151, 11, 1),
              title: 'Ketersediaan Labu Darah',
              onTap: () => _showLoginRequired('Cek Labu Darah'),
              iconSize: 30,
            ),
            const SizedBox(height: 12),
            _buildTodayItem(
              icon: Icons.hotel,
              iconColor: Colors.blue,
              title: 'Ketersediaan Bed',
              onTap: () => _showLoginRequired('Cek Bed'),
              iconSize: 30,
            ),
            const SizedBox(height: 12),
            _buildTodayItem(
              icon: MdiIcons.ambulance,
              iconColor: const Color.fromARGB(255, 244, 19, 19),
              title: 'Ketersediaan Mobil Ambulance / Jenazah',
              onTap: () => _showLoginRequired('Cek Mobil Ambulance / Jenazah'),
              iconSize: 30,
            ),
            const SizedBox(height: 12),
            _buildTodayItem(
              icon: MdiIcons.doctor,
              iconColor: const Color.fromARGB(255, 128, 19, 244),
              title: 'Ketersediaan Dokter',
              onTap: () => _showLoginRequired('Cek Jadwal Dokter'),
              iconSize: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
    double iconSize = 28,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            IconButton(
              onPressed: onTap,
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Hot Promo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Icon(Icons.local_fire_department, color: Color(0xFFFF6B35)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: PageView(
              controller: _promoPageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPromoIndex = index;
                });
              },
              children: [
                _buildPromoCard(imagePath: 'assets/images/promo1.png'),
                _buildPromoCard(imagePath: 'assets/images/promo3.jpg'),
                _buildPromoCard(imagePath: 'assets/images/promo4.jpg'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: _currentPromoIndex == index ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color:
                      _currentPromoIndex == index
                          ? Color(0xFFFF6B35)
                          : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCard({required String imagePath}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFB6C1), Color(0xFFDDA0DD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Icon(Icons.local_offer, color: Colors.white, size: 60),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHealthArticlesSection() {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Baca 100+ Artikel\nKesehatan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navigator dengan custom slide transition
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => AllHealthArticlesPage(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOutCubic;

                      var tween = Tween(begin: begin, end: end).chain(
                        CurveTween(curve: curve),
                      );
                      var offsetAnimation = animation.drive(tween);

                      // Tambahkan fade effect untuk transisi yang lebih smooth
                      var fadeAnimation = Tween<double>(
                        begin: 0.0,
                        end: 1.0,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeIn,
                      ));

                      return SlideTransition(
                        position: offsetAnimation,
                        child: FadeTransition(
                          opacity: fadeAnimation,
                          child: child,
                        ),
                      );
                    },
                    transitionDuration: Duration(milliseconds: 350),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFFF6B35),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFFF6B35).withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Lihat Semua',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildArticleCard(
          category: 'Kesehatan Ginjal',
          title: '5 Cara Merawat Ginjal agar Sehat & Cegah Penyakit Ginjal',
          date: 'Rabu, 3 September 2025',
          imagePath: 'assets/images/ginjal.jpg',
          url: 'https://www.biofarma.co.id/id/announcement/detail/5-cara-merawat-ginjal-agar-sehat-cegah-penyakit-ginjal',
          gradient: [Color(0xFF87CEEB), Color(0xFFB0E0E6)],
        ),
        const SizedBox(height: 12),
        _buildArticleCard(
          category: 'Nutrisi',
          title: '9 manfaat kolang kaling yang perlu kamu ketahui',
          date: 'Senin, 30 Juni 2025',
          imagePath: 'assets/images/olang.jpg',
          gradient: [Color(0xFF98FB98), Color(0xFF90EE90)],
          url: 'https://www.biofarma.co.id/id/announcement/detail/9-manfaat-kolang-kaling-yang-perlu-kamu-ketahui',
        ),
        const SizedBox(height: 12),
        _buildArticleCard(
          category: 'Pencernaan',
          title: 'Kenali Jenis Makanan Penyebab GERD',
          date: 'Jumat, 12 Juni 2025',
          imagePath: 'assets/images/gerd.png',
          gradient: [Color(0xFFFFA07A), Color(0xFFFF7F50)],
          url: 'https://www.biofarma.co.id/id/announcement/detail/kenali-jenis-makanan-penyebab-gerd',
        ),
      ],
    ),
  );
}

  Widget _buildArticleCard({
    required String category,
    required String title,
    required String date,
    required String imagePath,
    required List<Color> gradient,
    required String url,
  }) {
    return GestureDetector(
      onTap: () => _openArticle(url, title),
      child: Container(
        height: 200,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 12,
                right: 80,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 3,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: Text(
                  date,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 10,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 3,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
              const Positioned(
                bottom: 12,
                right: 12,
                child: Text(
                  'Baca Selengkapnya →',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PanduanSingkatWidget extends StatefulWidget {
  @override
  _PanduanSingkatWidgetState createState() => _PanduanSingkatWidgetState();
}

class _PanduanSingkatWidgetState extends State<PanduanSingkatWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, color: Color(0xFFFF6B35)),
                  ),
                  Text(
                    'Panduan Singkat',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, color: Color(0xFFFF6B35)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildPage1(),
                  _buildPage2(),
                  _buildPage3(),
                  _buildPage4(),
                  _buildPage5(),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color:
                              _currentPage == index
                                  ? Color(0xFFFF6B35)
                                  : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  if (_currentPage < 4)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentPage > 0)
                          TextButton(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Text(
                              'Sebelumnya',
                              style: TextStyle(color: Color(0xFFFF6B35)),
                            ),
                          )
                        else
                          SizedBox(width: 80),
                        Text(
                          '${_currentPage + 1} dari 5',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFF6B35),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text('Selanjutnya'),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFF6B35),
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text('Mulai Sekarang!'),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Color(0xFFFF6B35),
                                  side: BorderSide(color: Color(0xFFFF6B35)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: Text('Login'),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFF6B35),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: Text('Registrasi'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage1() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/panduan1.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone_android,
                              size: 60,
                              color: Color(0xFFFF6B35),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Gambar tidak tersedia',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Selamat datang di aplikasi Rumah Sakit Digital Hospital',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'Aplikasi ini membantu Anda mencari rumah sakit, daftar berobat, cek antrian, dan banyak lagi!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/panduan2.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.map, size: 60, color: Color(0xFFFF6B35)),
                            SizedBox(height: 10),
                            Text(
                              'Gambar tidak tersedia',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Cari Rumah Sakit Terdekat',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'Lihat daftar rumah sakit terdekat sesuai lokasi Anda. Dapatkan informasi alamat, nomor telepon, dan layanan yang tersedia.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPage3() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/panduan3.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.medical_services,
                              size: 60,
                              color: Color(0xFFFF6B35),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Gambar tidak tersedia',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Lihat Layanan & Info Kesehatan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'Cek layanan yang tersedia seperti rawat jalan, IGD, MCU. Pantau info penting seperti ketersediaan labu darah dan promo kesehatan.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPage4() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFF5F5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/panduan44.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.app_registration,
                                  size: 60,
                                  color: Color(0xFFFF6B35),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Gambar tidak tersedia',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Daftar & Pantau Antrian',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'Setelah login dan memilih rumah sakit terdekat, Anda dapat mendaftar berobat langsung melalui aplikasi. Status antrian dapat dipantau secara real-time tanpa perlu menunggu lama di lokasi.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPage5() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 100, color: Color(0xFFFF6B35)),
                  SizedBox(height: 15),
                  Text(
                    'Siap Digunakan!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Mulai Sekarang!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'Anda siap menggunakan aplikasi. Silakan login atau daftar untuk mulai menggunakan layanan kami.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class CaraMendaftarWidget extends StatefulWidget {
  @override
  _CaraMendaftarWidgetState createState() => _CaraMendaftarWidgetState();
}

class _CaraMendaftarWidgetState extends State<CaraMendaftarWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<Color> _pageColors = [
    Color(0xFFF83707),
    Color(0xFF2196F3),
    Color(0xFF4CAF50),
    Color(0xFFFF6B35),
    Color(0xFF9C27B0),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: _pageColors[_currentPage],
                    ),
                  ),
                  Text(
                    'Cara Mendaftar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, color: _pageColors[_currentPage]),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildRegisterPage1(),
                  _buildRegisterPage2(),
                  _buildRegisterPage3(),
                  _buildRegisterPage4(),
                  _buildRegisterPage5(),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color:
                              _currentPage == index
                                  ? _pageColors[_currentPage]
                                  : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  if (_currentPage < 4)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentPage > 0)
                          TextButton(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Text(
                              'Sebelumnya',
                              style: TextStyle(
                                color: _pageColors[_currentPage],
                              ),
                            ),
                          )
                        else
                          SizedBox(width: 80),
                        Text(
                          '${_currentPage + 1} dari 5',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _pageColors[_currentPage],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text('Selanjutnya'),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Mulai Sekarang!'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterPage1() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/daftar1.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.app_registration,
                              size: 60,
                              color: Color(0xFFF83707),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Gambar tidak tersedia',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Langkah 1: Isi Data Diri & Buat Akun',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF83707),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'Buka aplikasi dan pilih "Registrasi". Isi formulir dengan data diri yang valid, lalu buat username dan kata sandi untuk akun Anda.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterPage2() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/daftar2.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.verified_user,
                              size: 60,
                              color: Color(0xFF2196F3),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Gambar tidak tersedia',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Langkah 2: Verifikasi Akun & Login',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2196F3),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'Setelah mengisi data, sistem akan mengirimkan kode verifikasi ke email atau nomor telepon Anda. Masukkan kode tersebut untuk memverifikasi akun dan login ke aplikasi.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterPage3() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/daftar3.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_hospital,
                              size: 60,
                              color: Color(0xFF4CAF50),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Gambar tidak tersedia',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Langkah 3: Cari & Pilih Rumah Sakit',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'Setelah berhasil login, gunakan fitur pencarian untuk menemukan rumah sakit terdekat atau rumah sakit pilihan Anda. Pilih rumah sakit untuk melihat detail layanan dan membuat janji.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterPage4() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/daftar4.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_month,
                              size: 60,
                              color: Color(0xFFFF6B35),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Gambar tidak tersedia',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Langkah 4: Buat Jadwal Konsultasi',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF6B35),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'Pilih layanan, dokter, dan jadwal yang tersedia. Konfirmasi janji temu Anda dan dapatkan nomor antrian digital secara otomatis.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterPage5() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/daftar5.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 60,
                              color: Color(0xFF9C27B0),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Gambar tidak tersedia',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Langkah 5: Pantau Antrian Secara Real-Time',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9C27B0),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'Anda dapat memantau status antrian Anda langsung dari aplikasi. Notifikasi akan dikirim saat giliran Anda mendekat, jadi tidak perlu lagi menunggu lama di rumah sakit.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class FAQWidget extends StatefulWidget {
  @override
  _FAQWidgetState createState() => _FAQWidgetState();
}

class _FAQWidgetState extends State<FAQWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back, color: Color(0xFFFF6B35)),
                    ),
                    Text(
                      'FAQ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 40),
                  ],
                ),
              ),
              _buildFAQItem(
                question: 'Apa itu aplikasi Digital Hospital?',
                answer:
                    'Aplikasi Digital Hospital adalah platform yang memudahkan Anda mencari rumah sakit, mendaftar berobat secara online, melihat layanan, dan memantau antrian dari mana saja.',
              ),
              _buildFAQItem(
                question: 'Bagaimana cara mendaftar akun?',
                answer:
                    'Anda dapat mendaftar dengan mengisi formulir registrasi di aplikasi dan memverifikasi email/nomor telepon Anda. Ikuti panduan "Cara Mendaftar" di beranda aplikasi.',
              ),
              _buildFAQItem(
                question: 'Apakah layanan ini gratis?',
                answer:
                    'Menggunakan aplikasi untuk mencari rumah sakit dan informasi kesehatan adalah gratis. Namun, biaya konsultasi dan layanan medis akan sesuai dengan tarif yang berlaku di rumah sakit.',
              ),
              _buildFAQItem(
                question: 'Apakah saya bisa mendaftar untuk orang lain?',
                answer:
                    'Ya, Anda dapat mendaftarkan anggota keluarga atau orang lain dengan menggunakan data diri mereka saat membuat janji temu.',
              ),
              _buildFAQItem(
                question: 'Bagaimana cara melihat nomor antrian?',
                answer:
                    'Setelah membuat janji temu, nomor antrian digital Anda akan muncul di bagian "Jadwal Saya" di aplikasi. Status antrian akan diperbarui secara real-time.',
              ),
              _buildFAQItem(
                question: 'Bagaimana jika saya terlambat?',
                answer:
                    'Jika Anda terlambat, harap hubungi customer service atau pihak rumah sakit terkait. Terkadang, janji temu mungkin perlu dijadwal ulang.',
              ),
              _buildFAQItem(
                question: 'Bagaimana cara menghubungi CS?',
                answer:
                    'Anda dapat menghubungi customer service kami melalui fitur chat di aplikasi, email di support@inocare.id, atau telepon di 1500-123.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF6B35),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
