import 'package:flutter/material.dart';

class ManageAppointmentScreen extends StatefulWidget {
  final String patient;
  final String doctor;
  final String time;
  final String avatar;

  const ManageAppointmentScreen({
    super.key,
    required this.patient,
    required this.doctor,
    required this.time,
    required this.avatar,
  });

  @override
  State<ManageAppointmentScreen> createState() =>
      _ManageAppointmentScreenState();
}

class _ManageAppointmentScreenState extends State<ManageAppointmentScreen> {
  final Color primaryColor = const Color(0xFF0D6EFD);

  String _status = "Scheduled";

  void _showConfirmDialog(String action, VoidCallback onConfirm) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBackgroundColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final buttonTextColor = isDark ? primaryColor : Colors.white;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: dialogBackgroundColor,
        title: Text(
          "Confirm $action",
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to $action for ${widget.patient}?",
          style: TextStyle(color: textColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: isDark ? Colors.grey[400] : primaryColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Yes",
              style: TextStyle(color: buttonTextColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(String step, bool active, bool completed, bool isDark) {
    final Color activeColor = completed ? Colors.green : (active ? primaryColor : Colors.grey.shade300);
    final Color inactiveColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;
    final Color stepColor = completed ? Colors.green : (active ? primaryColor : (isDark ? Colors.white70 : Colors.black54));

    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: completed ? Colors.green : (active ? primaryColor : inactiveColor),
          child: Icon(
            completed
                ? Icons.check
                : (active ? Icons.radio_button_checked : Icons.circle),
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          step,
          style: TextStyle(
            fontSize: 13,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            color: stepColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBackgroundColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    final appBarColor = isDark ? const Color(0xFF1E1E1E) : primaryColor;
    final appBarTextColor = isDark ? Colors.white : Colors.white;
    final cardBackgroundColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtextColor = isDark ? Colors.white70 : Colors.white70;
    final noteTextColor = isDark ? Colors.white70 : Colors.black87;
    final dividerColor = isDark ? Colors.grey.shade700 : Colors.grey.shade400;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Manage Appointment",
          style: TextStyle(color: appBarTextColor),
        ),
        backgroundColor: appBarColor,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor.withOpacity(0.85), primaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(widget.avatar),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.patient,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Doctor: ${widget.doctor}",
                          style: TextStyle(
                            color: subtextColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Appointment: ${widget.time}",
                          style: TextStyle(
                            color: subtextColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimelineStep("Scheduled", _status == "Scheduled", _status != "Scheduled", isDark),
                Expanded(
                  child: Divider(color: dividerColor, thickness: 1),
                ),
                _buildTimelineStep("In Progress", _status == "In Progress", _status == "Completed", isDark),
                Expanded(
                  child: Divider(color: dividerColor, thickness: 1),
                ),
                _buildTimelineStep("Completed", _status == "Completed", _status == "Completed", isDark),
              ],
            ),
            const SizedBox(height: 30),
            Card(
              color: cardBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Patient Notes",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "• Patient has mild fever\n"
                      "• Allergic to penicillin\n"
                      "• Requested online consultation",
                      style: TextStyle(
                        fontSize: 15,
                        color: noteTextColor,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                _showConfirmDialog("Reschedule", () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Rescheduled for ${widget.patient}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: primaryColor,
                    ),
                  );
                });
              },
              icon: const Icon(Icons.calendar_month, color: Colors.white),
              label: const Text(
                "Reschedule",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                setState(() => _status = "In Progress");
                _showConfirmDialog("Start Consultation", () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Consultation started for ${widget.patient}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );
                });
              },
              icon: const Icon(Icons.play_circle_fill, color: Colors.white),
              label: const Text(
                "Start Consultation",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                setState(() => _status = "Completed");
                _showConfirmDialog("Complete Appointment", () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Appointment completed for ${widget.patient}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                });
              },
              icon: const Icon(Icons.check_circle, color: Colors.white),
              label: const Text(
                "Complete Appointment",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}