import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:inocare/screens/billing1.dart';
import 'package:inocare/screens/hasilforensik.dart';
import 'package:inocare/screens/hasillab.dart';
import 'package:inocare/screens/hasilpemeriksaan.dart';
import 'package:inocare/screens/hasilradiologi.dart';
import 'package:inocare/screens/hasilutdrs.dart';
import 'package:inocare/screens/infobed.dart';
import 'package:inocare/screens/infolabu.dart';
import 'package:inocare/screens/infomobil.dart';
import 'package:inocare/screens/jadwaloperasi.dart';
import 'package:inocare/screens/kesehatansaya.dart';
import 'package:inocare/screens/liveantrian.dart';
import 'package:inocare/screens/menumakanan.dart';
import 'package:inocare/screens/billing_page.dart';
import 'package:inocare/screens/order.dart';
import 'package:inocare/screens/riwayat_registrasi_page.dart';
import 'package:inocare/services/user_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'rumahsakitmember.dart';
import 'profilepagepasien.dart'; // Import halaman profile yang baru dibuat
import 'registrasi_igd.dart';
import 'registrasi_rajal.dart';
import 'registrasi_mcu.dart';
import 'registrasi_ranap.dart';
import 'notifikasi.dart';
import 'package:url_launcher/url_launcher.dart';
import 'webview_page.dart';
import 'settings_screen.dart';

class HomePagePasien extends StatefulWidget {
  final Hospital selectedHospital;

  const HomePagePasien({Key? key, required this.selectedHospital})
    : super(key: key);

  @override
  State<HomePagePasien> createState() => _HomePagePasienState();
}

class _HomePagePasienState extends State<HomePagePasien> {
  int _currentIndex = 0;
  String _patientName = 'Loading...';
  String? _userName;

  final PageController _promoPageController = PageController();
  int _currentPromoIndex = 0;

  String? _antrianIGD;
  String? _antrianRajal;
  String? _antrianMCU;
  String? _antrianRanap;

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
    _promoPageController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentNik = prefs.getString('current_nik'); // user aktif

      if (currentNik == null) {
        setState(() {
          _patientName = 'Guest';
          _antrianIGD = null;
          _antrianRajal = null;
          _antrianMCU = null;
          _antrianRanap = null;
        });
        return;
      }

      final name = prefs.getString('user_${currentNik}_name');
      final igd = prefs.getString('user_${currentNik}_nomorAntrian_IGD');
      final rajal = prefs.getString('user_${currentNik}_nomorAntrian_RAJAL');
      final mcu = prefs.getString('user_${currentNik}_nomorAntrian_MCU');
      final ranap = prefs.getString('user_${currentNik}_nomorAntrian_RANAP');

      setState(() {
        _patientName = (name != null && name.isNotEmpty) ? name : 'Guest';

        _antrianIGD = igd;
        _antrianRajal = rajal;
        _antrianMCU = mcu;
        _antrianRanap = ranap;
      });
    } catch (e) {
      setState(() {
        _patientName = 'Guest';
      });
    }
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

  // Tambahkan metode untuk refresh data
  Future<void> _refreshData() async {
    await _loadUserData();
  }

  void _openArticle(String url, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => HybridWebView(url: url)),
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
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildHospitalCard(),
          _buildQuickActions(),
          _buildTodaySchedule(),
          _buildLiveQueue(),
          _buildRegistrationNumbers(),
          // _buildPatientServicesMenu(),
          _buildPromoSection(),
          _buildHealthArticlesSection(),
          SizedBox(height: 100),
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
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              // Buat bagian avatar dan info user menjadi clickable
              GestureDetector(
                onTap: () {
                  // Navigasi ke halaman profile
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePagePasien(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _patientName.isNotEmpty
                              ? _patientName[0].toUpperCase()
                              : 'P',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _patientName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Laki-Laki',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          widget.selectedHospital.name,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                          ),
                        ),
                        // Tambahkan indikator bahwa area ini clickable
                        SizedBox(height: 2),
                        // Text(
                        //   'Ketuk untuk lihat profil',
                        //   style: TextStyle(
                        //     color: Colors.white.withOpacity(0.7),
                        //     fontSize: 10,
                        //     fontStyle: FontStyle.italic,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsPage(),
                    ),
                  );
                },
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationNumbers() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nomor Registrasi Anda',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),

          if (_antrianIGD != null)
            _buildRegistrationItem(
              "IGD",
              _antrianIGD!,
              "Menunggu",
              Colors.orange,
            ),
          if (_antrianRajal != null)
            _buildRegistrationItem(
              "Rajal",
              _antrianRajal!,
              "Menunggu",
              Colors.blue,
            ),
          if (_antrianMCU != null)
            _buildRegistrationItem(
              "MCU",
              _antrianMCU!,
              "Menunggu",
              Colors.purple,
            ),
          if (_antrianRanap != null)
            _buildRegistrationItem(
              "Ranap",
              _antrianRanap!,
              "Menunggu",
              Colors.teal,
            ),

          if (_antrianIGD == null &&
              _antrianRajal == null &&
              _antrianMCU == null &&
              _antrianRanap == null)
            Text(
              "Belum ada registrasi.",
              style: TextStyle(color: Colors.grey[600]),
            ),
        ],
      ),
    );
  }

  Widget _buildRegistrationItem(
    String title,
    String number,
    String status,
    Color statusColor,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.person, color: statusColor, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$title - Nomor Antrian: $number",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Status: $status",
                    style: TextStyle(color: statusColor, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(color: Colors.grey[300], thickness: 1, height: 16),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari Aja Dulu ...',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildHospitalCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🏥 Nama Rumah Sakit
          Text(
            widget.selectedHospital.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          // 🖼️ Gambar Rumah Sakit (lebih besar)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              widget.selectedHospital.imagePath,
              height: 200, // ✅ diperbesar
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 8),

          // 🔘 Tombol Lihat Semua (Rata Kanan)
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () => _showAllQuickActions(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: const Text(
                "Lihat Semua",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // ✅ Tampilkan hanya 4 item utama di baris pertama
          _buildQuickActionItem(Icons.add_box, 'Registrasi IGD', Colors.red),
          _buildQuickActionItem(
            FontAwesomeIcons.userDoctor,
            'Registrasi Rajal',
            Colors.blue,
          ),
          _buildQuickActionItem(
            Icons.assignment,
            'Registrasi MCU',
            Color(0xFFFF6B35),
          ),
          _buildQuickActionItem(Icons.hotel, 'Registrasi Ranap', Colors.teal),
        ],
      ),
    );
  }

  /// ✅ Tombol "Lihat Semua" kamu taruh di bawah _buildHospitalCard()
  Widget _buildSeeAllButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _showAllQuickActions(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF6B35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: const Text(
          "Lihat Semua",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }

  /// ✅ Function untuk modal bottom sheet
  void _showAllQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Semua Menu",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    // Registrasi
                    _buildQuickActionItem(
                      Icons.add_box,
                      'Registrasi IGD',
                      Colors.red,
                    ),
                    _buildQuickActionItem(
                      FontAwesomeIcons.userDoctor,
                      'Registrasi Rajal',
                      Colors.blue,
                    ),
                    _buildQuickActionItem(
                      Icons.assignment,
                      'Registrasi MCU',
                      Color(0xFFFF6B35),
                    ),
                    _buildQuickActionItem(
                      Icons.hotel,
                      'Registrasi Ranap',
                      Colors.teal,
                    ),
                    if (_antrianIGD != null ||
                        _antrianRajal != null ||
                        _antrianRanap != null)
                      _buildQuickActionItem(
                        Icons.receipt_long,
                        'Tagihan',
                        Colors.purple,
                      ),
                    // _buildQuickActionItem(
                    //   Icons.monitor_heart_outlined,
                    //   'Kesehatan Saya',
                    //   Colors.yellow,
                    // ),

                    // Layanan pasien tambahan
                    if (_antrianIGD != null ||
                        _antrianRajal != null ||
                        _antrianMCU != null ||
                        _antrianRanap != null)
                      _buildQuickActionItem(
                        Icons.assignment_outlined,
                        'Hasil Pemeriksaan',
                        Colors.blue,
                      ),
                    if (_antrianIGD != null ||
                        _antrianRajal != null ||
                        _antrianMCU != null ||
                        _antrianRanap != null)
                      _buildQuickActionItem(
                        Icons.science_outlined,
                        'Hasil Lab',
                        Colors.purple,
                      ),
                    if (_antrianIGD != null ||
                        _antrianRajal != null ||
                        _antrianRanap != null)
                      _buildQuickActionItem(
                        Icons.camera_alt_outlined,
                        'Hasil Radiologi',
                        Colors.orange,
                      ),
                    if (_antrianIGD != null ||
                        _antrianRajal != null ||
                        _antrianRanap != null)
                      _buildQuickActionItem(
                        Icons.monitor_heart_outlined,
                        'Hasil UTDRS',
                        Colors.red,
                      ),
                    if (_antrianIGD != null)
                      _buildQuickActionItem(
                        Icons.gavel_outlined,
                        'Hasil Forensik',
                        Colors.brown,
                      ),
                    if (_antrianRanap != null)
                      _buildQuickActionItem(
                        Icons.restaurant_menu_outlined,
                        'Menu Makanan',
                        Colors.teal,
                      ),
                    if (_antrianRanap != null || _antrianIGD != null)
                      _buildQuickActionItem(
                        Icons.medical_services_outlined,
                        'Jadwal Operasi',
                        Color(0xFFFF6B35),
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

  Widget _buildQuickActionItem(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () async {
        switch (label) {
          case 'Registrasi IGD':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegistrasiIGDPage()),
            ).then((_) => _refreshData());
            break;

          case 'Registrasi Rajal':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegistrasiRajalPage()),
            ).then((_) => _refreshData());
            break;

          case 'Registrasi MCU':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegistrasiMCUPage()),
            ).then((_) => _refreshData());
            break;

          case 'Registrasi Ranap':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegistrasiRanapPage()),
            ).then((_) => _refreshData());
            break;

          case 'Tagihan':
            _openBillingPage();
            break;

          // case 'Kesehatan Saya':
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (_) => const KesehatanSayaSensorPage(),
          //     ),
          //   );
          //   break;

          case 'Hasil Pemeriksaan':
            _openHasilPemeriksaan();
            break;

          case 'Hasil Lab':
            _openHasilLab();
            break;

          case 'Hasil Radiologi':
            _openHasilRadiologi();
            break;

          case 'Hasil UTDRS':
            _openHasilUTDRS();
            break;

          case 'Hasil Forensik':
            _openHasilForensik();
            break;

          case 'Menu Makanan':
            _openMenuMakanan();
            break;

          case 'Jadwal Operasi':
            _openJadwalOperasi();
            break;
        }
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildPatientServicesMenu() {
  //   bool hasAnyRegistration =
  //       _antrianIGD != null ||
  //       _antrianRajal != null ||
  //       _antrianMCU != null ||
  //       _antrianRanap != null;

  //   if (!hasAnyRegistration) {
  //     return Container(); // Return empty if no registration
  //   }

  //   return Container(
  //     margin: EdgeInsets.all(16),
  //     padding: EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.1),
  //           spreadRadius: 1,
  //           blurRadius: 4,
  //           offset: Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Icon(Icons.medical_services, color: Color(0xFFFF6B35), size: 20),
  //             SizedBox(width: 8),
  //             Text(
  //               'Layanan Pasien',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black87,
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 16),

  //         // Menu Grid
  //         GridView.count(
  //           crossAxisCount: 3,
  //           shrinkWrap: true,
  //           physics: NeverScrollableScrollPhysics(),
  //           childAspectRatio: 0.9,
  //           crossAxisSpacing: 12,
  //           mainAxisSpacing: 12,
  //           children: [
  //             // Billing/Tagihan - Available for all
  //             _buildServiceMenuItem(
  //               icon: Icons.receipt_long,
  //               label: 'Billing\nTagihan',
  //               color: Colors.green,
  //               onTap: () => _openBillingPage(),
  //             ),

  //             // Hasil Pemeriksaan - Available for all
  //             _buildServiceMenuItem(
  //               icon: Icons.assignment_outlined,
  //               label: 'Hasil\nPemeriksaan',
  //               color: Colors.blue,
  //               onTap: () => _openHasilPemeriksaan(),
  //             ),

  //             // Hasil Lab - Available for IGD, Rajal, MCU, Ranap
  //             if (_antrianIGD != null ||
  //                 _antrianRajal != null ||
  //                 _antrianMCU != null ||
  //                 _antrianRanap != null)
  //               _buildServiceMenuItem(
  //                 icon: Icons.science_outlined,
  //                 label: 'Hasil\nLab',
  //                 color: Colors.purple,
  //                 onTap: () => _openHasilLab(),
  //               ),

  //             // Hasil Radiologi - Available for IGD, Rajal, Ranap
  //             if (_antrianIGD != null ||
  //                 _antrianRajal != null ||
  //                 _antrianRanap != null)
  //               _buildServiceMenuItem(
  //                 icon: Icons.camera_alt_outlined,
  //                 label: 'Hasil\nRadiologi',
  //                 color: Colors.orange,
  //                 onTap: () => _openHasilRadiologi(),
  //               ),
  //             // if (_antrianRanap != null)
  //             //   _buildServiceMenuItem(
  //             //     icon: Icons.restaurant_menu,
  //             //     label: 'Menu\nMakanan',
  //             //     color: Colors.green,
  //             //     onTap: () {
  //             //       Navigator.push(
  //             //         context,
  //             //         MaterialPageRoute(
  //             //           builder:
  //             //               (context) => MenuMakananPage(
  //             //                 patientName:
  //             //                     "Budi Santoso", // ambil dari data pasien
  //             //                 ranapNumber:
  //             //                     _antrianRanap ?? "-", // nomor rawat inap
  //             //               ),
  //             //         ),
  //             //       );
  //             //     },
  //             //   ),

  //             // Hasil UTDRS - Available for all
  //             _buildServiceMenuItem(
  //               icon: Icons.monitor_heart_outlined,
  //               label: 'Hasil\nUTDRS',
  //               color: Colors.red,
  //               onTap: () => _openHasilUTDRS(),
  //             ),

  //             // Hasil Forensik - Available for IGD only
  //             if (_antrianIGD != null)
  //               _buildServiceMenuItem(
  //                 icon: Icons.gavel_outlined,
  //                 label: 'Hasil\nForensik',
  //                 color: Colors.brown,
  //                 onTap: () => _openHasilForensik(),
  //               ),

  //             // Menu Makanan - Available for Ranap only
  //             if (_antrianRanap != null)
  //               _buildServiceMenuItem(
  //                 icon: Icons.restaurant_menu_outlined,
  //                 label: 'Menu\nMakanan',
  //                 color: Colors.teal,
  //                 onTap: () => _openMenuMakanan(),
  //               ),

  //             // Jadwal Operasi - Available for Ranap and IGD (emergency surgery)
  //             if (_antrianRanap != null || _antrianIGD != null)
  //               _buildServiceMenuItem(
  //                 icon: Icons.medical_services_outlined,
  //                 label: 'Jadwal\nOperasi',
  //                 color: Color(0xFFFF6B35),
  //                 onTap: () => _openJadwalOperasi(),
  //               ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildServiceMenuItem({
  //   required IconData icon,
  //   required String label,
  //   required Color color,
  //   required VoidCallback onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: color.withOpacity(0.1),
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(color: color.withOpacity(0.3)),
  //       ),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Container(
  //             padding: EdgeInsets.all(12),
  //             decoration: BoxDecoration(
  //               color: color.withOpacity(0.2),
  //               shape: BoxShape.circle,
  //             ),
  //             child: Icon(icon, color: color, size: 24),
  //           ),
  //           SizedBox(height: 8),
  //           Text(
  //             label,
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //               fontSize: 11,
  //               fontWeight: FontWeight.w600,
  //               color: Colors.black87,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Method handlers untuk setiap menu
  void _openBillingPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BillingPage1(
              patientName: _patientName,
              registrations: {
                if (_antrianIGD != null) 'IGD': _antrianIGD!,
                if (_antrianRajal != null) 'RAJAL': _antrianRajal!,
                if (_antrianMCU != null) 'MCU': _antrianMCU!,
                if (_antrianRanap != null) 'RANAP': _antrianRanap!,
              },
            ),
      ),
    );
  }

  void _openHasilPemeriksaan() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => HasilPemeriksaanPage(
              patientName: _patientName,
              registrations: {
                if (_antrianIGD != null) 'IGD': _antrianIGD!,
                if (_antrianRajal != null) 'RAJAL': _antrianRajal!,
                if (_antrianMCU != null) 'MCU': _antrianMCU!,
                if (_antrianRanap != null) 'RANAP': _antrianRanap!,
              },
            ),
      ),
    );
  }

  void _openHasilLab() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => HasilLabPage(
              patientName: _patientName,
              registrations: {
                if (_antrianIGD != null) 'IGD': _antrianIGD!,
                if (_antrianRajal != null) 'RAJAL': _antrianRajal!,
                if (_antrianMCU != null) 'MCU': _antrianMCU!,
                if (_antrianRanap != null) 'RANAP': _antrianRanap!,
              },
            ),
      ),
    );
  }

  void _openHasilRadiologi() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => HasilRadiologiPage(
              patientName: _patientName,
              registrations: {
                if (_antrianIGD != null) 'IGD': _antrianIGD!,
                if (_antrianRajal != null) 'RAJAL': _antrianRajal!,
                if (_antrianRanap != null) 'RANAP': _antrianRanap!,
              },
            ),
      ),
    );
  }

  void _openHasilUTDRS() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => HasilUTDRSPage(
              patientName: _patientName,
              registrations: {
                if (_antrianIGD != null) 'IGD': _antrianIGD!,
                if (_antrianRajal != null) 'RAJAL': _antrianRajal!,
                if (_antrianMCU != null) 'MCU': _antrianMCU!,
                if (_antrianRanap != null) 'RANAP': _antrianRanap!,
              },
            ),
      ),
    );
  }

  void _openHasilForensik() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => HasilForensikPage(
              patientName: _patientName,
              igdNumber: _antrianIGD!,
            ),
      ),
    );
  }

  void _openMenuMakanan() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MenuMakananPage(
              patientName: _patientName,
              ranapNumber: _antrianRanap!,
            ),
      ),
    );
  }

  void _openJadwalOperasi() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => JadwalOperasiPage(
              namaPasien: _patientName,
              nik: '', // Ambil dari SharedPreferences jika perlu
              umur: '', // Ambil dari SharedPreferences jika perlu
              noRM: 'RM${DateTime.now().millisecondsSinceEpoch % 100000}',
              unitPoli: _antrianRanap != null ? 'RANAP' : 'IGD',
              dokter: 'Dr. Bedah, Sp.B',
              nomorAntrian: _antrianRanap ?? _antrianIGD ?? '',
            ),
      ),
    );
  }

  // Fungsi untuk menampilkan notifikasi realtime

  Widget _buildTodaySchedule() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ganti bagian Row ini dengan desain baru
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
                      widget
                          .selectedHospital
                          .name, // Gunakan nama rumah sakit yang dipilih
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
          SizedBox(height: 12),
          _buildScheduleItem(
            'Ketersediaan Labu Darah',
            'Sabtu 12 Sep 2025 - 07:00',
            'A-12  B-8  O-20  AB-5',
            Colors.red,
            Icons.bloodtype,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) =>
                          const BloodAvailabilityPage(), // 👈 halaman labu darah
                ),
              );
            },
          ),
          SizedBox(height: 8),
          _buildScheduleItem(
            'Ketersediaan Bed',
            'Update 12 Sep 2025 - 07:00',
            'VIP: 2  Kls I: 5  Kls II: 7  Kls III: 12',
            Colors.grey[700]!,
            Icons.hotel,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BedAvailabilityPage()),
              );
            },
          ),
          SizedBox(height: 8),
          _buildScheduleItem(
            'Ketersediaan Mobil',
            'Update 12 Sep 2025 - 07:00',
            'Ambulance : 12, Mobil Jenazah : 6',
            Colors.red[700]!,
            FontAwesomeIcons.truckMedical,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MobilAvailabilityPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(
    String title,
    String time,
    String details,
    Color color,
    IconData icon,
    VoidCallback onTap, // 👈 tambahkan callback
  ) {
    return InkWell(
      onTap: onTap, // 👈 panggil callback ketika diklik
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                  Text(
                    details,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.chevron_right, color: Colors.white, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveQueue() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Antrian Live Saat Ini',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildQueueItem('IGD', 'RJ37', Colors.brown, _antrianIGD),
                SizedBox(width: 12),
                _buildQueueItem('RAJAL', 'B40', Colors.blue, _antrianRajal),
                SizedBox(width: 12),
                _buildQueueItem('MCU', 'M10', Colors.grey[700]!, _antrianMCU),
                SizedBox(width: 12),
                _buildQueueItem('RANAP', 'R05', Colors.teal, _antrianRanap),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueItem(
    String title,
    String current,
    Color color,
    String? user,
  ) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Now: $current",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          if (user != null)
            Text(
              "Anda: $user",
              style: TextStyle(
                color: Colors.yellow[200],
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  //  Widget _buildRegistrationItem(String title, String number, String status, Color statusColor) {
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 8),
  //     padding: EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[50],
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: Row(
  //       children: [
  //         Expanded(child: Text("$title\nNomor: $number")),
  //         Container(
  //           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //           decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(12)),
  //           child: Text('Status: $status', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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

  // Tambahkan metode _buildPromoCard
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
    required String url, // 🔥 tambahkan parameter URL
  }) {
    return GestureDetector(
      onTap: () => _openArticle(url, title), // buka link artikel
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

  Widget _buildOtherPages() {
    switch (_currentIndex) {
      case 1: // Order
        return const OrderPage();
      case 2: // Live
        return const LiveAntrianPage(
          nomorAntrian: "RJ40",
          antrianSaatIni: "RJ37",
          estimasiMenit: 20,
        );
      case 3: // Riwayat
        return RiwayatRegistrasiPage();
      // case 4: // Kesehatan Saya
      //   return KesehatanSayaSensorPage();
      case 4: // Setting
        return SettingsScreen(onLogout: _handleLogout);
      default:
        return _buildHomePage();
    }
  }

  // Widget _buildLivePage() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Icon(Icons.satellite_alt, size: 80, color: Colors.grey[400]),
  //         SizedBox(height: 16),
  //         Text(
  //           'Live Tracking',
  //           style: TextStyle(
  //             fontSize: 16,
  //             color: Colors.grey[600],
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //         SizedBox(height: 8),
  //         Text(
  //           'Halaman dalam pengembangan',
  //           style: TextStyle(fontSize: 14, color: Colors.grey[500]),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildRiwayatPage() {
    return Center(
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
    );
  }

  Widget _buildSettingPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'Pengaturan',
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
}
