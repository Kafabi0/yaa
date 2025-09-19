import 'package:flutter/material.dart';
import 'package:inocare/screens/adminlayanan_screen.dart';
import 'package:inocare/screens/billingpayment_screen.dart';
import 'package:inocare/screens/chart.dart';
import 'package:inocare/screens/dashboard.dart';
import 'package:inocare/screens/diklat_penelitian.dart';
import 'package:inocare/screens/emergency_protocols_screen.dart';
import 'package:inocare/screens/ermbedah_sentral_screen.dart';
import 'package:inocare/screens/ermperawat_screen.dart';
import 'package:inocare/screens/ermdoctor_screen.dart';
import 'package:inocare/screens/farmasi_screen.dart';
import 'package:inocare/screens/feedback_screen.dart';
import 'package:inocare/screens/healthanalytics_screen.dart';
import 'package:inocare/screens/healthfacilities_screen.dart';
import 'package:inocare/screens/input_transaksi_page.dart';
import 'package:inocare/screens/inputpasien.dart';
import 'package:inocare/screens/kasir_screen.dart';
import 'package:inocare/screens/manajemen_bed.dart';
import 'package:inocare/screens/medical_equipment.dart';
import 'package:inocare/screens/pasien_profile_page.dart';
import 'package:inocare/screens/patient_records_screen.dart';
import 'package:inocare/screens/patientmonitoring_screen.dart';
import 'package:inocare/screens/pegawai_screen.dart';
import 'package:inocare/screens/rekam_medik_screen.dart';
import 'package:inocare/screens/shift_screen.dart';
import 'package:inocare/screens/staff_screen.dart';
import '../data/app_data.dart';
import '../widgets/top_header_section.dart';
import '../widgets/quick_access_card.dart';
import '../screens/doctor_list.dart';
import '../screens/appointment_screen.dart';
import '../screens/prescription_screen.dart';
import '../data/appointment_data.dart';
import '../screens/casemix.dart';
import 'pilihpasien.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _showAllQuickAccess = false;
  late ScrollController _scrollController;
  late AnimationController _fadeController;

  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  int? selectedPasienId;

  @override
  void initState() {
    super.initState();
    _scrollController =
        ScrollController()..addListener(() {
          if (_scrollController.offset >= 300) {
            if (!_fadeController.isAnimating &&
                _fadeController.status != AnimationStatus.forward) {
              _fadeController.forward();
            }
          } else {
            if (!_fadeController.isAnimating &&
                _fadeController.status != AnimationStatus.reverse) {
              _fadeController.reverse();
            }
          }
        });
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    selectedPasienId = 1;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    _searchController.dispose();

    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF1E1E2C) : const Color(0xFFF3F4F6);
    final cardColor = isDark ? const Color(0xFF2D2D44) : Colors.white;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            const MedicalTopHeaderSection(),
            Transform.translate(
              offset: const Offset(0, -50),
              child: _buildQuickAccessGrid(cardColor, primaryColor),
            ),
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
        ),
        child: FadeTransition(
          opacity: _fadeController,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, primaryColor.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: _scrollToTop,
              backgroundColor: Colors.transparent,
              elevation: 0,
              highlightElevation: 0,
              shape: const CircleBorder(),
              splashColor: Colors.white.withOpacity(0.3),
              child: const Icon(
                Icons.arrow_upward_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessGrid(Color cardColor, Color primaryColor) {
    final filteredItems =
        quickAccessItems.where((item) {
          final label = (item['label'] as String).toLowerCase();
          return label.contains(_searchQuery.toLowerCase());
        }).toList();

    // tampilkan semua hasil pencarian, atau kalau kosong pakai default showAll
    final displayedItems =
        _showAllQuickAccess ? filteredItems : filteredItems.take(9).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: cardColor,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _searchController, // ✅ hubungkan controller
                decoration: InputDecoration(
                  hintText: "Search menu...",
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  suffixIcon:
                      _searchQuery.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _searchQuery = "";
                                _searchController.clear();
                              });
                              FocusScope.of(context).unfocus();
                            },
                          )
                          : null,

                  filled: true,
                  fillColor: Colors.blue.shade600,
                  hintStyle: const TextStyle(color: Colors.white70),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.lightBlueAccent,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),

                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),

              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayedItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final item = displayedItems[index];
                  return Align(
                    alignment: Alignment.topCenter,
                    child: QuickAccessCard(
                      icon: item['icon'],
                      color: item['color'],
                      label: item['label'],
                      onTap: () {
                        switch (item['label']) {
                          case 'Doctor':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DoctorListScreen(),
                              ),
                            );
                            break;
                          case 'Appointments':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => const AppointmentCalendarScreen(),
                              ),
                            );
                            break;
                          case 'Prescription Management':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => const PrescriptionManagementScreen(),
                              ),
                            );
                            break;
                          case 'Emergency Protocols':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => const EmergencyProtocolsScreen(),
                              ),
                            );
                            break;
                          case 'Medical Equipment':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MedicalEquipmentScreen(),
                              ),
                            );
                            break;
                          case 'Health Facilities':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HealthFacilitiesScreen(),
                              ),
                            );
                            break;
                          case 'Patient Records':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => PatientRecordsScreen(
                                      appointments: appointmentsData,
                                    ),
                              ),
                            );
                            break;
                          case 'Billing & Payments':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BillingPaymentsScreen(),
                              ),
                            );
                            break;
                          case 'Health Analytics':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HealthAnalyticsScreen(),
                              ),
                            );
                            break;
                          case 'Patient Monitoring':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PatientMonitoring(),
                              ),
                            );
                            break;
                          case 'Feedback & Reviews':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FeedbackList(),
                              ),
                            );
                            break;
                          case 'Shift Schedule':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ShiftSchedule(),
                              ),
                            );
                            break;
                          case 'Staff Directory':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const StaffDirectory(),
                              ),
                            );
                            break;
                          case 'Tugas Transaksi':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const InputTransaksiPage(),
                              ),
                            );
                            break;
                          case 'Tugas Chart':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TransPage(),
                              ),
                            );
                            break;
                          case 'Tugas Pendaftaran':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const InputPasienPage(),
                              ),
                            );
                            break;
                          case 'ERM Doctor':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ErmDoctorPage(),
                              ),
                            );
                            break;
                          case 'Pengguna Pasien':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PasienSelectionPage(),
                              ),
                            );
                            break;

                          case 'ERM Perawat':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ErmPerawatScreen(),
                              ),
                            );
                            break;
                          case 'Dashboard & Reporting':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DashboardReporting(),
                              ),
                            );
                            break;
                          case 'Kepegawaian':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PegawaiScreen(),
                              ),
                            );
                            break;
                          case 'Manajemen Bed':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ManajemenBed(),
                              ),
                            );
                            break;
                          case 'Rekam Medik':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RekamMedisPage(),
                              ),
                            );
                            break;
                          case 'Administrasi Layanan':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AdminLayanan(),
                              ),
                            );
                          case 'ERM Bedah Sentral':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ErmBedahSentralPage(),
                              ),
                            );
                            break;
                          case 'Casemix':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CasemixPage(),
                              ),
                            );
                            break;
                          case 'Kasir':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const KasirPage(),
                              ),
                            );
                            break;
                          default:
                            print('Clicked: ${item['label']}');
                        }
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  setState(() {
                    _showAllQuickAccess = !_showAllQuickAccess;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _showAllQuickAccess ? 'See Less' : 'See All',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 300),
                      turns: _showAllQuickAccess ? 0.5 : 0,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
