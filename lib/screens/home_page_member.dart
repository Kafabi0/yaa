import 'package:flutter/material.dart';
import 'package:inocare/screens/order.dart';
import 'package:inocare/screens/pilihrumahsakit.dart';
import 'package:inocare/screens/rumahsakitmember.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:inocare/services/user_prefs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'settings_screen.dart';
import 'profile_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'webview_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inocare/services/location_service.dart';
import 'package:inocare/models/hospital_model.dart';
import 'package:inocare/services/hospital_service.dart'; 
import 'package:inocare/widgets/nearest_hospital_widget.dart';

class HomePageMember extends StatefulWidget {
  final VoidCallback? onHospitalSelected;
  final Position? currentPosition; // Terima posisi dari login
  final String? currentAddress; // Terima alamat dari login

  const HomePageMember({
    Key? key, 
    this.onHospitalSelected,
    this.currentPosition,
    this.currentAddress,
  }) : super(key: key);

  @override
  State<HomePageMember> createState() => _HomePageMemberState();
}

class _HomePageMemberState extends State<HomePageMember> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _doctorSearchController = TextEditingController(); // Controller untuk pencarian dokter
  final PageController _promoPageController = PageController();
  int _currentPromoIndex = 0;
  int _currentIndex = 0;
  String? _userName;
  
  // Location variables
  Position? _currentPosition;
  String _currentAddress = 'Mendapatkan lokasi...';
  String _fullAddress = 'Mendapatkan lokasi...';
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _initializeLocation();
  }

  void _initializeLocation() {
    // Jika ada posisi yang diteruskan dari login, gunakan itu
    if (widget.currentPosition != null && widget.currentAddress != null) {
      setState(() {
        _currentPosition = widget.currentPosition;
        _currentAddress = _truncateAddress(widget.currentAddress!);
        _fullAddress = widget.currentAddress!;
        _isLoadingLocation = false;
      });
    } else {
      // Jika tidak ada, ambil lokasi baru
      _getCurrentLocation();
    }
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
              child: Text(
                'Nanti',
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
              child: Text(
                'Buka Pengaturan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

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

  Widget _buildMiniLocationWidget() {
    return GestureDetector(
      onTap: () {
        if (!_isLoadingLocation) {
          _getCurrentLocation();
        }
      },
      onLongPress: _showFullLocationDialog,
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

  void _openArticle(String url, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => HybridWebView(url: url)),
    );
  }

  Future<void> _loadUserData() async {
    final user = await UserPrefs.getCurrentUser();
    if (mounted && user != null) {
      setState(() {
        _userName = user['name'];
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _doctorSearchController.dispose(); // Dispose controller dokter
    _promoPageController.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    await UserPrefs.logout();
    setState(() {
      _currentIndex = 0;
      _userName = null;
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logout berhasil')));
    }
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
          _buildDoctorSearchSection(),
          const SizedBox(height: 20),
          _buildTodaySection(),
          _buildPromoSection(),
          _buildHealthArticlesSection(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFF6B35),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bagian nama user yang clickable
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, ${_userName ?? "Member"} 👋',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Semoga sehat selalu!',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
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
                      _buildMiniLocationWidget(),
                      SizedBox(width: 8),
                      // Notifikasi
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Fitur notifikasi akan segera hadir'),
                              backgroundColor: Color(0xFFFF6B35),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: 24,
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
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CurvedNavigationBar(
      index: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
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
    switch (_currentIndex) {
      case 1: // Order
        Future.microtask(() => _navigateToHospitalAndGo(const OrderPage()));
        return const SizedBox();

      case 2: // Live
        Future.microtask(() => _navigateToHospitalAndGo(_buildLivePage()));
        return const SizedBox();

      case 3: // Riwayat
        Future.microtask(() => _navigateToHospitalAndGo(_buildRiwayatPage()));
        return const SizedBox();

      case 4:
        return SettingsScreen(onLogout: _handleLogout);

      default:
        return _buildHomePage();
    }
  }

  Future<void> _navigateToHospitalAndGo(Widget nextPage) async {
    final selectedHospital = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PilihRumahSakitPage()),
    );

    if (selectedHospital != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => nextPage),
      );
    }
  }

  Widget _buildLivePage() {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Tracking")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.satellite_alt, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Live Tracking',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
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
      appBar: AppBar(title: const Text("Riwayat")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Riwayat',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Halaman dalam pengembangan',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
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
            hintText: 'Cari layanan kesehatan...',
            prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
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
            builder: (context) => RumahSakitMemberPage(),
          ),
        );
      },
      onLocationRefresh: () {
        _getCurrentLocation();
      }
    );
  }

  Widget _buildQuickAccessSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuickAccessItem(
            icon: Icons.book,
            label: 'Panduan\nSingkat',
            onTap: () => _showPanduanSingkat(),
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
                        '                   ',
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RumahSakitMemberPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildTodayItem(
              icon: Icons.hotel,
              iconColor: Colors.blue,
              title: 'Ketersediaan Bed',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RumahSakitMemberPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildTodayItem(
              icon: MdiIcons.ambulance,
              iconColor: const Color.fromARGB(255, 244, 19, 19),
              title: 'Ketersediaan Mobil Ambulance / Jenazah',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RumahSakitMemberPage(),
                  ),
                );
              },
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

  // Tambahkan metode baru untuk card pencarian dokter
  Widget _buildDoctorSearchSection() {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person_search, color: Color(0xFFFF6B35)),
                const SizedBox(width: 8),
                Text(
                  'Cari Dokter',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _doctorSearchController,
              decoration: InputDecoration(
                hintText: 'Masukkan nama dokter...',
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFFF6B35)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman rumah sakit dengan parameter pencarian dokter
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RumahSakitMemberPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF6B35),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Cari Dokter',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
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
      padding: const EdgeInsets.all(16),
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
            height: 180,
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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFFF6B35),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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
            gradient: [Color(0xFF87CEEB), Color(0xFFB0E0E6)],
            url:
                'https://www.biofarma.co.id/id/announcement/detail/5-cara-merawat-ginjal-agar-sehat-cegah-penyakit-ginjal',
          ),
          const SizedBox(height: 12),
          _buildArticleCard(
            category: 'Nutrisi',
            title: '9 manfaat kolang kaling yang perlu kamu ketahui',
            date: 'Senin, 30 Juni 2025',
            imagePath: 'assets/images/olang.jpg',
            gradient: [Color(0xFF98FB98), Color(0xFF90EE90)],
            url:
                'https://www.biofarma.co.id/id/announcement/detail/9-manfaat-kolang-kaling-yang-perlu-kamu-ketahui',
          ),
          const SizedBox(height: 12),
          _buildArticleCard(
            category: 'Pencernaan',
            title: 'Kenali Jenis Makanan Penyebab GERD',
            date: 'Jumat, 12 Juni 2025',
            imagePath: 'assets/images/gerd.png',
            gradient: [Color(0xFFFFA07A), Color(0xFF7F50)],
            url:
                'https://www.biofarma.co.id/id/announcement/detail/kenali-jenis-makanan-penyebab-gerd',
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
        height: 180,
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
                    style: TextStyle(
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 3,
                        color: Colors.black.withOpacity(0.5),
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
              Positioned(
                bottom: 12,
                right: 12,
                child: Text(
                  'Baca Selengkapnya →',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
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
            ],
          ),
        ),
      ),
    );
  }

  void _showFAQ() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FAQWidget(),
        fullscreenDialog: true,
      ),
    );
  }

  void _showPanduanSingkat() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PanduanSingkatWidget(),
        fullscreenDialog: true,
      ),
    );
  }
}

class PanduanSingkatWidget extends StatefulWidget {
  const PanduanSingkatWidget({Key? key}) : super(key: key);

  @override
  _PanduanSingkatWidgetState createState() => _PanduanSingkatWidgetState();
}

class _PanduanSingkatWidgetState extends State<PanduanSingkatWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Color> _pageColors = [
    Color(0xFF2196F3),
    Color(0xFF03A9F4),
    Color(0xFF00BCD4),
    Color(0xFF009688),
    Color(0xFF4CAF50),
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
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF03A9F4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Text(
                    'Panduan Singkat',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, color: Colors.white),
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
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
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

                  const SizedBox(height: 16),

                  if (_currentPage < 4)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentPage > 0)
                          TextButton(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
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
                          const SizedBox(width: 80),

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
                              duration: const Duration(milliseconds: 300),
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
                          child: const Text('Selanjutnya'),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RumahSakitMemberPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text('Temukan Rumah Sakit Terdekat'),
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

  // Add all the page builder methods from the original code...
  Widget _buildPage1() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 200,
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
                padding: const EdgeInsets.all(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/memberpanduan1.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.phone_android,
                                size: 50,
                                color: Color(0xFF2196F3),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Gambar tidak tersedia',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
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
            const SizedBox(height: 16),
            Text(
              'Panduan Siagat',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2196F3),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Selamat Datang! Ikuti langkah ini agar pengalaman kamu lebih mudah.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Langkah-langkah:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildStepItem('1. Pilih Rumah Sakit Terdekat'),
                  _buildStepItem('2. Aktifkan lokasi pada ponsel Anda'),
                  _buildStepItem('3. Klik tombol pilih rumah sakit'),
                  _buildStepItem('4. Pilih rumah sakit yang diinginkan'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Color(0xFF2196F3), size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  // Add the remaining page methods (_buildPage2, _buildPage3, etc.) from original code
  Widget _buildPage2() {
    return Container(
      child: Center(
        child: Text('Page 2 - Add remaining implementation'),
      ),
    );
  }

  Widget _buildPage3() {
    return Container(
      child: Center(
        child: Text('Page 3 - Add remaining implementation'),
      ),
    );
  }

  Widget _buildPage4() {
    return Container(
      child: Center(
        child: Text('Page 4 - Add remaining implementation'),
      ),
    );
  }

  Widget _buildPage5() {
    return Container(
      child: Center(
        child: Text('Page 5 - Add remaining implementation'),
      ),
    );
  }
}

class FAQWidget extends StatelessWidget {
  const FAQWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFFFF6B35),
                      ),
                    ),
                    const Text(
                      'FAQ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 40),
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
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