import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../screens/ManageAppointmentScreen.dart';

class AppointmentCalendarScreen extends StatefulWidget {
  const AppointmentCalendarScreen({super.key});

  @override
  State<AppointmentCalendarScreen> createState() =>
      _AppointmentCalendarScreenState();
}

class _AppointmentCalendarScreenState extends State<AppointmentCalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedMonth = DateTime.now();
  final Color primaryColor = const Color(0xFF0D6EFD);

  final Map<String, List<Map<String, String>>> appointments = {
    '2025-08-27': [
      {
        'patient': 'Alice Johnson',
        'time': '10:00 AM',
        'avatar': 'https://i.pravatar.cc/150?img=5',
        'doctor': 'Dr. Adi Januar Akbar',
      },
      {
        'patient': 'Bob Smith',
        'time': '11:30 AM',
        'avatar': 'https://i.pravatar.cc/150?img=6',
        'doctor': 'Dr. Rasawa',
      },
    ],
    '2025-08-28': [
      {
        'patient': 'Charlie Lee',
        'time': '02:00 PM',
        'avatar': 'https://i.pravatar.cc/150?img=7',
        'doctor': 'Dr. Anggi Suryati',
      },
    ],
    '2025-08-29': [
      {
        'patient': 'Diana Prince',
        'time': '09:00 AM',
        'avatar': 'https://i.pravatar.cc/150?img=8',
        'doctor': 'Dr. Astarini',
      },
      {
        'patient': 'Edward King',
        'time': '01:00 PM',
        'avatar': 'https://i.pravatar.cc/150?img=9',
        'doctor': 'Dr. Adi Januar Akbar',
      },
    ],
    '2025-09-02': [
      {
        'patient': 'Charlie Puth',
        'time': '12:00 PM',
        'avatar': 'https://i.pravatar.cc/150?img=11',
        'doctor': 'Dr. Rasawa',
      },
      {
        'patient': 'Rachel Green',
        'time': '01:00 PM',
        'avatar': 'https://i.pravatar.cc/150?img=10',
        'doctor': 'Dr. Anggi Suryati',
      },
    ],
  };

  late Map<String, List<Map<String, String>>> _appointmentsDisplay;
  late CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _appointmentsDisplay = Map<String, List<Map<String, String>>>.from(
      appointments,
    );
    _calendarController = CalendarController();
    _calendarController.displayDate = _focusedMonth;
  }

  List<Map<String, String>> _getAppointmentsForDay(DateTime day) {
    final key =
        '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
    return _appointmentsDisplay[key] ?? [];
  }

  void _addAppointment() {
    final formKey = GlobalKey<FormState>();
    final patientController = TextEditingController();
    final timeController = TextEditingController();
    final doctorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final dialogBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
        final textColor = isDark ? Colors.white : Colors.black87;

        return AlertDialog(
          backgroundColor: dialogBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Add Appointment",
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: patientController,
                  decoration: const InputDecoration(
                    labelText: "Patient Name",
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator:
                      (val) => val == null || val.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: timeController,
                  decoration: const InputDecoration(
                    labelText: "Time (e.g. 10:00 AM)",
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  validator:
                      (val) => val == null || val.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: doctorController,
                  decoration: const InputDecoration(
                    labelText: "Doctor",
                    prefixIcon: Icon(Icons.local_hospital),
                  ),
                  validator:
                      (val) => val == null || val.isEmpty ? "Required" : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.red.shade400),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final key =
                      '${_selectedDay.year}-${_selectedDay.month.toString().padLeft(2, '0')}-${_selectedDay.day.toString().padLeft(2, '0')}';

                  setState(() {
                    _appointmentsDisplay.putIfAbsent(key, () => []);
                    _appointmentsDisplay[key]!.add({
                      'patient': patientController.text,
                      'time': timeController.text,
                      'doctor': doctorController.text,
                      'avatar':
                          'https://i.pravatar.cc/150?u=${DateTime.now().millisecondsSinceEpoch}',
                    });
                  });

                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _confirmCancelAppointment(DateTime day, Map<String, String> appt) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Cancellation"),
        content: Text(
          "Are you sure you want to cancel the appointment with ${appt['patient']}?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Yes, Cancel"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final key =
          '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      setState(() {
        _appointmentsDisplay[key]?.remove(appt);
      });
    }
  }

  Widget _buildAppointmentCard(Map<String, String> appt, bool isDark) {
    final cardBackgroundColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(appt['avatar']!),
                radius: 24,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appt['patient']!,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    appt['time']!,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              const Spacer(),
              Icon(Icons.local_hospital, color: primaryColor),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Doctor: ${appt['doctor']}",
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _confirmCancelAppointment(_selectedDay, appt),
                  icon: const Icon(Icons.cancel, size: 18),
                  label: const Text("Cancel"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ManageAppointmentScreen(
                          patient: appt['patient']!,
                          time: appt['time']!,
                          avatar: appt['avatar']!,
                          doctor: appt['doctor']!,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text("Manage"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appointmentsToday = _getAppointmentsForDay(_selectedDay);

    final months = List.generate(12, (i) => i + 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointments"),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          // Dropdown pilih bulan & tahun
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<int>(
                    value: _focusedMonth.month,
                    isExpanded: true,
                    items: months
                        .map(
                          (m) => DropdownMenuItem<int>(
                            value: m,
                            child: Text(
                              "${m.toString().padLeft(2, '0')} - ${_focusedMonth.year}",
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (m) {
                      if (m != null) {
                        setState(() {
                          _focusedMonth = DateTime(_focusedMonth.year, m, 1);
                          _calendarController.displayDate = _focusedMonth;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _focusedMonth = DateTime(
                        _focusedMonth.year,
                        _focusedMonth.month - 1,
                      );
                      _calendarController.displayDate = _focusedMonth;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      _focusedMonth = DateTime(
                        _focusedMonth.year,
                        _focusedMonth.month + 1,
                      );
                      _calendarController.displayDate = _focusedMonth;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: SfCalendar(
              controller: _calendarController,
              view: CalendarView.month,
              initialSelectedDate: _selectedDay,
              onTap: (calendarTapDetails) {
                if (calendarTapDetails.date != null) {
                  setState(() {
                    _selectedDay = calendarTapDetails.date!;
                  });
                }
              },
              monthViewSettings: const MonthViewSettings(
                showAgenda: false,
              ),
            ),
          ),
          Expanded(
            child: appointmentsToday.isEmpty
                ? const Center(child: Text("No appointments today"))
                : ListView.builder(
                    itemCount: appointmentsToday.length,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (_, i) =>
                        _buildAppointmentCard(appointmentsToday[i], isDark),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAppointment,
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
