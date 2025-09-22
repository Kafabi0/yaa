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

    final igd = prefs.getString('nomorAntrian_IGD');
    final rajal = prefs.getString('nomorAntrian_RAJAL');
    final mcu = prefs.getString('nomorAntrian_MCU');
    final ranap = prefs.getString('nomorAntrian_RANAP');

    List<NotificationItem> tempNotifications = [];

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

    setState(() {
      _notifications = tempNotifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: Color(0xFFFF6B35),
      ),
      body:
          _notifications.isEmpty
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
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: Icon(
                        Icons.notifications,
                        color: Color(0xFFFF6B35),
                      ),
                      title: Text(
                        notif.title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(notif.message),
                      trailing: Text(
                        '${notif.time.hour.toString().padLeft(2, '0')}:${notif.time.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      onTap: () {
                        String jenis = '';
                        if (notif.title.contains('IGD')) jenis = 'IGD';
                        if (notif.title.contains('Rajal')) jenis = 'Rajal';
                        if (notif.title.contains('MCU')) jenis = 'MCU';
                        if (notif.title.contains('Ranap')) jenis = 'Ranap';

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => QueueTicketPage(
                                  jenis: jenis,
                                  nomorAntrian: notif.message.replaceAll(
                                    'Nomor antrian Anda: ',
                                    '',
                                  ),
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
