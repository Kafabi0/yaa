import 'package:flutter/material.dart';
import 'package:inocare/screens/tiketantrian.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationItem> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();

    List<NotificationItem> tempNotifications = [];

    // Ambil nomor antrian dari registrasi
    final igd = prefs.getString('nomorAntrian_IGD');
    final rajal = prefs.getString('nomorAntrian_RAJAL');
    final mcu = prefs.getString('nomorAntrian_MCU');
    final ranap = prefs.getString('nomorAntrian_RANAP');

    if (igd != null) {
      tempNotifications.add(
        NotificationItem(
          title: 'Registrasi IGD berhasil',
          message: 'Nomor antrian Anda: $igd',
          time: DateTime.now(),
        ),
      );
    }
    if (rajal != null) {
      tempNotifications.add(
        NotificationItem(
          title: 'Registrasi Rajal berhasil',
          message: 'Nomor antrian Anda: $rajal',
          time: DateTime.now(),
        ),
      );
    }
    if (mcu != null) {
      tempNotifications.add(
        NotificationItem(
          title: 'Registrasi MCU berhasil',
          message: 'Nomor antrian Anda: $mcu',
          time: DateTime.now(),
        ),
      );
    }
    if (ranap != null) {
      tempNotifications.add(
        NotificationItem(
          title: 'Registrasi Ranap berhasil',
          message: 'Nomor antrian Anda: $ranap',
          time: DateTime.now(),
        ),
      );
    }

    // 🔥 Tambahkan notifikasi dari OrderPage
    List<String> orderNotifs = prefs.getStringList('order_notifications') ?? [];
    for (String raw in orderNotifs) {
      final parts = raw.split('|');
      if (parts.length == 3) {
        tempNotifications.add(
          NotificationItem(
            title: "${parts[0]} berhasil",
            message: parts[1],
            time: DateTime.tryParse(parts[2]) ?? DateTime.now(),
          ),
        );
      }
    }

    setState(() {
      // urutkan biar terbaru di atas
      _notifications = tempNotifications.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: Color(0xFFFF6B35),
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Text(
                'Belum ada notifikasi',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notif = _notifications[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(
                      Icons.notifications,
                      color: Color(0xFFFF6B35),
                    ),
                    title: Text(
                      notif.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(notif.message),
                    trailing: Text(
                      '${notif.time.hour.toString().padLeft(2, '0')}:${notif.time.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    onTap: () {
                      // Tentukan jenis layanan dari title
                      String jenis = '';
                      if (notif.title.contains('IGD')) jenis = 'IGD';
                      if (notif.title.contains('Rajal')) jenis = 'Rajal';
                      if (notif.title.contains('MCU')) jenis = 'MCU';
                      if (notif.title.contains('Ranap')) jenis = 'Ranap';
                      if (notif.title.contains('Ambulance')) jenis = 'Ambulance';
                      if (notif.title.contains('Farmasi')) jenis = 'Farmasi';
                      if (notif.title.contains('Lab')) jenis = 'Lab';
                      if (notif.title.contains('Radiologi')) jenis = 'Radiologi';
                      if (notif.title.contains('Forensik')) jenis = 'Forensik';
                      if (notif.title.contains('UTDRS')) jenis = 'UTDRS';

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QueueTicketPage(
                            jenis: jenis,
                            nomorAntrian: notif.message.replaceAll(
                              'Nomor antrian Anda: ', '',
                            ).replaceAll('Nomor order Anda: ', ''),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class NotificationItem {
  final String title;
  final String message;
  final DateTime time;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
  });
}
