import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'rumahsakitmember.dart';
import 'profilepagepasien.dart'; // Import halaman profile yang baru dibuat
import 'registrasi_igd.dart';
import 'registrasi_rajal.dart';
import 'registrasi_mcu.dart';
import 'registrasi_ranap.dart';
import 'notifikasi.dart';

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

  String? _antrianIGD;
  String? _antrianRajal;
  String? _antrianMCU;
  String? _antrianRanap;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('registeredName');

      // ⬅️ tambahan: ambil antrian yang sudah disimpan saat registrasi
      final igd = prefs.getString('nomorAntrian_IGD');
      final rajal = prefs.getString('nomorAntrian_RAJAL');
      final mcu = prefs.getString('nomorAntrian_MCU');
      final ranap = prefs.getString('nomorAntrian_RANAP');

      setState(() {
        _patientName = (name != null && name.isNotEmpty) ? name : 'Iskandar';

        _antrianIGD = igd;
        _antrianRajal = rajal;
        _antrianMCU = mcu;
        _antrianRanap = ranap;
      });
    } catch (e) {
      setState(() {
        _patientName = 'Iskandar';
      });
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
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildHospitalCard(),
          _buildQuickActions(),
          _buildTodaySchedule(),
          _buildLiveQueue(),
          _buildRegistrationNumbers(),
          _buildPromotion(),
          _buildHealthArticles(),
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
                    "$title - Nomor: $number",
                    style: TextStyle(fontWeight: FontWeight.w600),
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
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.selectedHospital.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(widget.selectedHospital.imagePath),
                fit: BoxFit.cover,
                onError: (error, stackTrace) {},
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [Colors.blue.withOpacity(0.3), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Lihat Semua',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
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

  Widget _buildQuickActionItem(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () async {
        String? nomorAntrian;

        if (label == 'Registrasi IGD') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegistrasiIGDPage()),
          ).then((value) async {
            // Ambil nomor antrian dari SharedPreferences setelah registrasi
            final prefs = await SharedPreferences.getInstance();
            nomorAntrian = prefs.getString('nomorAntrian_IGD');
            if (nomorAntrian != null) {
              _showRealtimeDialog('IGD', nomorAntrian!);
            }
          });
        } else if (label == 'Registrasi Rajal') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegistrasiRajalPage()),
          ).then((value) async {
            final prefs = await SharedPreferences.getInstance();
            nomorAntrian = prefs.getString('nomorAntrian_RAJAL');
            if (nomorAntrian != null) {
              _showRealtimeDialog('RAJAL', nomorAntrian!);
            }
          });
        } else if (label == 'Registrasi MCU') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegistrasiMCUPage()),
          ).then((value) async {
            final prefs = await SharedPreferences.getInstance();
            nomorAntrian = prefs.getString('nomorAntrian_MCU');
            if (nomorAntrian != null) {
              _showRealtimeDialog('MCU', nomorAntrian!);
            }
          });
        } else if (label == 'Registrasi Ranap') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegistrasiRanapPage()),
          ).then((value) async {
            final prefs = await SharedPreferences.getInstance();
            nomorAntrian = prefs.getString('nomorAntrian_RANAP');
            if (nomorAntrian != null) {
              _showRealtimeDialog('RANAP', nomorAntrian!);
            }
          });
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

  // Fungsi untuk menampilkan notifikasi realtime
  void _showRealtimeDialog(String jenis, String nomor) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Notifikasi",
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.notifications_active,
                  size: 40,
                  color: Color(0xFFFF6B35),
                ),
                SizedBox(height: 12),
                Text(
                  'Registrasi $jenis Berhasil!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Nomor antrian Anda: $nomor',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF6B35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Lihat Semua Notifikasi'),
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 1),
            end: Offset(0, 0),
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOut)),
          child: child,
        );
      },
    );
  }

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
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Hari Ini',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Rumah Sakit Abdul Moeloek',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildScheduleItem(
            'Ketersediaan Lalu Darah',
            'Sabtu 12 Sep 2025 - 07:00',
            'A-12  B-8  O-20  AB-5',
            Colors.red,
            Icons.bloodtype,
          ),
          SizedBox(height: 8),
          _buildScheduleItem(
            'Ketersediaan Bed',
            'Update 12 Sep 2025 - 07:00',
            'VIP: 2  Kls I: 5  Kls II: 7  Kls III: 12',
            Colors.grey[700]!,
            Icons.hotel,
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
  ) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQueueItem('IGD', 'RJ37', Colors.brown, _antrianIGD),
              _buildQueueItem('RAJAL', 'B40', Colors.blue, _antrianRajal),
              _buildQueueItem('MCU', 'M10', Colors.grey[700]!, _antrianMCU),
              _buildQueueItem('RANAP', 'R05', Colors.teal, _antrianRanap),
            ],
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

  Widget _buildPromotion() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Hot Promo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
            ],
          ),
          SizedBox(height: 12),
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Colors.pink[100]!, Colors.pink[50]!],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 16,
                  top: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Mayapada Royal Hospital',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'WOMAN\'S HEALTH',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[600],
                        ),
                      ),
                      Text(
                        'CHECK UP',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'PAPSMEAR + KONSULTASI',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'RP',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            '788.',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            '000',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthArticles() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Baca 100+ Artikel Kesehatan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFFFF6B35),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.teal[100],
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Kesehatan Giga',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '5 Cara Merawat Ginjal agar Sehat',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '3 Cegah Penyakit Ginjal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Nutrisi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '5 manfaat kolang kaling yang',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'perlu kamu ketahui',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherPages() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'Halaman dalam pengembangan',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
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
      height: 60,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      items: [
        Icon(FontAwesomeIcons.house, color: Colors.white, size: 24),
        Icon(FontAwesomeIcons.calendarDay, color: Colors.white, size: 24),
        Icon(FontAwesomeIcons.solidHeart, color: Colors.white, size: 24),
        Icon(FontAwesomeIcons.solidCommentDots, color: Colors.white, size: 24),
        Icon(FontAwesomeIcons.user, color: Colors.white, size: 24),
      ],
    );
  }
}
