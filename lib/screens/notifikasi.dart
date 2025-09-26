import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'suratkonsul.dart';
import 'suratrujukan.dart';
import 'ambulance_order_page.dart';
import 'tiketantrian.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationItem> _notifications = [];
  String? _rajalNumber;
  String? _ambulanceOrder;
  String? _labOrderNumber;
  String? _forensikOrderNumber;
  String? _radiologiOrderNumber;
  String? _utdrsOrderNumber;
  String? _farmasiOrderNumber;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final nik = prefs.getString('current_nik'); // user aktif bener
    // user aktif

    if (nik == null) {
      throw Exception("User belum login, NIK tidak ditemukan.");
    }

    // Load existing services
    final igd = prefs.getString('user_${nik}_nomorAntrian_IGD');
    final rajal = prefs.getString('user_${nik}_nomorAntrian_RAJAL');
    final mcu = prefs.getString('user_${nik}_nomorAntrian_MCU');
    final ranap = prefs.getString('user_${nik}_nomorAntrian_RANAP');
    final ambulance = prefs.getString('user_${nik}_orderAmbulance');

    // Load new order services
    final lab = prefs.getString('user_${nik}_nomorAntrian_LAB');
    final forensik = prefs.getString('user_${nik}_nomorAntrian_FORENSIK');
    final radiologi = prefs.getString('user_${nik}_nomorAntrian_RADIOLOGI');
    final utdrs = prefs.getString('user_${nik}_nomorAntrian_UTDRS');
    final farmasi = prefs.getString('user_${nik}_nomorAntrian_FARMASI');

    List<NotificationItem> tempNotifications = [];

    // Existing notifications
    if (igd != null) {
      tempNotifications.add(
        NotificationItem(
          title: 'Registrasi IGD berhasil',
          message: 'Nomor antrian Anda: $igd',
          time: DateTime.now(),
          type: NotificationType.registration,
        ),
      );
    }

    if (rajal != null) {
      _rajalNumber = rajal;
      tempNotifications.addAll([
        NotificationItem(
          title: 'Registrasi Rajal berhasil',
          message: 'Nomor antrian Anda: $rajal',
          time: DateTime.now(),
          type: NotificationType.registration,
        ),
        NotificationItem(
          title: 'Surat Konsultasi tersedia',
          message: 'Klik untuk melihat Surat Konsultasi',
          time: DateTime.now(),
          type: NotificationType.document,
        ),
        NotificationItem(
          title: 'Surat Rujukan tersedia',
          message: 'Klik untuk melihat Surat Rujukan',
          time: DateTime.now(),
          type: NotificationType.document,
        ),
      ]);
    }

    if (mcu != null) {
      tempNotifications.add(
        NotificationItem(
          title: 'Registrasi MCU berhasil',
          message: 'Nomor antrian Anda: $mcu',
          time: DateTime.now(),
          type: NotificationType.registration,
        ),
      );
    }

    if (ranap != null) {
      tempNotifications.add(
        NotificationItem(
          title: 'Registrasi Ranap berhasil',
          message: 'Nomor antrian Anda: $ranap',
          time: DateTime.now(),
          type: NotificationType.registration,
        ),
      );
    }

    if (ambulance != null) {
      _ambulanceOrder = ambulance;
      tempNotifications.add(
        NotificationItem(
          title: 'Order Ambulance berhasil',
          message: 'Kode pemesanan: $ambulance',
          time: DateTime.now(),
          type: NotificationType.service,
        ),
      );
    }

    // New order service notifications
    if (lab != null) {
      _labOrderNumber = lab;
      tempNotifications.add(
        NotificationItem(
          title: 'Pemesanan Lab berhasil',
          message: 'Nomor antrian lab: $lab',
          time: DateTime.now(),
          type: NotificationType.lab,
        ),
      );
    }

    if (forensik != null) {
      _forensikOrderNumber = forensik;
      tempNotifications.add(
        NotificationItem(
          title: 'Pemesanan Forensik berhasil',
          message: 'Nomor antrian forensik: $forensik',
          time: DateTime.now(),
          type: NotificationType.forensik,
        ),
      );
    }

    if (radiologi != null) {
      _radiologiOrderNumber = radiologi;
      tempNotifications.add(
        NotificationItem(
          title: 'Pemesanan Radiologi berhasil',
          message: 'Nomor antrian radiologi: $radiologi',
          time: DateTime.now(),
          type: NotificationType.radiologi,
        ),
      );
    }

    if (utdrs != null) {
      _utdrsOrderNumber = utdrs;
      tempNotifications.add(
        NotificationItem(
          title: 'Pemesanan UTDRS berhasil',
          message: 'Nomor antrian UTDRS: $utdrs',
          time: DateTime.now(),
          type: NotificationType.utdrs,
        ),
      );
    }

    if (farmasi != null) {
      _farmasiOrderNumber = farmasi;
      tempNotifications.add(
        NotificationItem(
          title: 'Pemesanan Farmasi berhasil',
          message: 'Nomor pesanan farmasi: $farmasi',
          time: DateTime.now(),
          type: NotificationType.farmasi,
        ),
      );
    }

    setState(() {
      _notifications = tempNotifications.reversed.toList(); // Show latest first
    });
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.registration:
        return Icons.assignment_turned_in;
      case NotificationType.document:
        return Icons.description;
      case NotificationType.service:
        return Icons.local_hospital;
      case NotificationType.lab:
        return Icons.science;
      case NotificationType.forensik:
        return Icons.search;
      case NotificationType.radiologi:
        return Icons.medical_services;
      case NotificationType.utdrs:
        return Icons.healing;
      case NotificationType.farmasi:
        return Icons.medication;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.registration:
        return Colors.green;
      case NotificationType.document:
        return Colors.blue;
      case NotificationType.service:
        return const Color(0xFFFF6B35);
      case NotificationType.lab:
        return Colors.purple;
      case NotificationType.forensik:
        return Colors.indigo;
      case NotificationType.radiologi:
        return Colors.grey;
      case NotificationType.utdrs:
        return Colors.red;
      case NotificationType.farmasi:
        return Colors.orange;
    }
  }

  String _getServiceName(NotificationType type) {
    switch (type) {
      case NotificationType.lab:
        return 'Lab';
      case NotificationType.forensik:
        return 'Forensik';
      case NotificationType.radiologi:
        return 'Radiologi';
      case NotificationType.utdrs:
        return 'UTDRS';
      case NotificationType.farmasi:
        return 'Farmasi';
      default:
        return 'Service';
    }
  }

  void _handleNotificationTap(NotificationItem notif) {
    if (notif.title.contains('Surat Konsultasi')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => ConsultationLetterPage(nomorAntrian: _rajalNumber ?? ''),
        ),
      );
    } else if (notif.title.contains('Surat Rujukan')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ReferralLetterPage(nomorAntrian: _rajalNumber ?? ''),
        ),
      );
    } else if (notif.title.contains('Order Ambulance')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AmbulanceOrderPage(orderCode: _ambulanceOrder ?? ''),
        ),
      );
    } else if (notif.title.contains('Pemesanan Lab')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => QueueTicketPage(
                jenis: 'Lab',
                nomorAntrian: _labOrderNumber ?? '',
              ),
        ),
      );
    } else if (notif.title.contains('Pemesanan Forensik')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => QueueTicketPage(
                jenis: 'Forensik',
                nomorAntrian: _forensikOrderNumber ?? '',
              ),
        ),
      );
    } else if (notif.title.contains('Pemesanan Radiologi')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => QueueTicketPage(
                jenis: 'Radiologi',
                nomorAntrian: _radiologiOrderNumber ?? '',
              ),
        ),
      );
    } else if (notif.title.contains('Pemesanan UTDRS')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => QueueTicketPage(
                jenis: 'UTDRS',
                nomorAntrian: _utdrsOrderNumber ?? '',
              ),
        ),
      );
    } else if (notif.title.contains('Pemesanan Farmasi')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => QueueTicketPage(
                jenis: 'Farmasi',
                nomorAntrian: _farmasiOrderNumber ?? '',
              ),
        ),
      );
    } else {
      // Handle other registration notifications
      String jenis = '';
      String nomorAntrian = '';

      if (notif.title.contains('IGD')) {
        jenis = 'IGD';
      } else if (notif.title.contains('Rajal')) {
        jenis = 'Rajal';
      } else if (notif.title.contains('MCU')) {
        jenis = 'MCU';
      } else if (notif.title.contains('Ranap')) {
        jenis = 'Ranap';
      }

      nomorAntrian = notif.message.replaceAll('Nomor antrian Anda: ', '');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => QueueTicketPage(jenis: jenis, nomorAntrian: nomorAntrian),
        ),
      );
    }
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Hapus Semua Notifikasi'),
            content: const Text('Yakin ingin menghapus semua notifikasi?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final nik = prefs.getString(
                    'current_nik',
                  ); // user aktif bener
                  // user aktif

                  if (nik == null) {
                    throw Exception("User belum login, NIK tidak ditemukan.");
                  }

                  await prefs.remove('user_${nik}_nomorAntrian_IGD');
                  await prefs.remove('user_${nik}_nomorAntrian_RAJAL');
                  await prefs.remove('user_${nik}_nomorAntrian_MCU');
                  await prefs.remove('user_${nik}_nomorAntrian_RANAP');
                  await prefs.remove('user_${nik}_orderAmbulance');
                  await prefs.remove('user_${nik}_nomorAntrian_LAB');
                  await prefs.remove('user_${nik}_nomorAntrian_FORENSIK');
                  await prefs.remove('user_${nik}_nomorAntrian_RADIOLOGI');
                  await prefs.remove('user_${nik}_nomorAntrian_UTDRS');
                  await prefs.remove('user_${nik}_nomorAntrian_FARMASI');
                  Navigator.pop(context);
                  _loadNotifications();
                },
                child: const Text('Hapus'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_notifications.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'clear') {
                  _showClearConfirmation();
                }
              },
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(
                      value: 'clear',
                      child: Row(
                        children: [
                          Icon(Icons.clear_all, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Hapus Semua'),
                        ],
                      ),
                    ),
                  ],
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Icon(Icons.more_vert, color: Colors.black87),
              ),
            ),
        ],
      ),
      body:
          _notifications.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications_none,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Belum ada notifikasi',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Notifikasi akan muncul setelah Anda\nmelakukan registrasi atau pemesanan layanan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notif = _notifications[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => _handleNotificationTap(notif),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: _getNotificationColor(
                                    notif.type,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _getNotificationIcon(notif.type),
                                  color: _getNotificationColor(notif.type),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notif.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      notif.message,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 14,
                                          color: Colors.grey[400],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${notif.time.hour.toString().padLeft(2, '0')}:${notif.time.minute.toString().padLeft(2, '0')}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.grey[400],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}

enum NotificationType {
  registration,
  document,
  service,
  lab,
  forensik,
  radiologi,
  utdrs,
  farmasi,
}

class NotificationItem {
  final String title;
  final String message;
  final DateTime time;
  final NotificationType type;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
  });
}
