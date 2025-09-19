import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ShiftSchedule extends StatefulWidget {
  const ShiftSchedule({super.key});

  @override
  State<ShiftSchedule> createState() => _ShiftScheduleState();
}

class _ShiftScheduleState extends State<ShiftSchedule> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, String>> _shifts = [
    {
      "day": "Senin",
      "shift": "08:00 - 16:00",
      "name": "Dr. Andi Pratama",
      "role": "Dokter Umum",
      "department": "IGD",
      "status": "active"
    },
    {
      "day": "Senin",
      "shift": "16:00 - 00:00",
      "name": "Ns. Budi Santoso",
      "role": "Perawat Senior",
      "department": "ICU",
      "status": "active"
    },
    {
      "day": "Selasa",
      "shift": "08:00 - 16:00",
      "name": "Dr. Clara Wijaya",
      "role": "Dokter Spesialis",
      "department": "Poli Dalam",
      "status": "active"
    },
    {
      "day": "Rabu",
      "shift": "16:00 - 00:00",
      "name": "Ns. Deni Kurniawan",
      "role": "Perawat",
      "department": "Rawat Inap",
      "status": "inactive"
    },
  ];

  String _selectedDay = "Semua";
  String _selectedDepartment = "Semua";

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _addShift(Map<String, String> newShift) {
    setState(() {
      _shifts.add(newShift);
    });
  }

  void _editShift(int index, Map<String, String> updatedShift) {
    setState(() {
      _shifts[index] = updatedShift;
    });
  }

  void _deleteShift(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(FontAwesomeIcons.triangleExclamation,
                  color: Colors.red, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              'Konfirmasi Hapus',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus jadwal shift ini?',
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: GoogleFonts.inter(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _shifts.removeAt(index);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Hapus',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> get _filteredShifts {
    return _shifts.where((shift) {
      final dayMatch = _selectedDay == "Semua" || shift['day'] == _selectedDay;
      final deptMatch = _selectedDepartment == "Semua" ||
          shift['department'] == _selectedDepartment;
      return dayMatch && deptMatch;
    }).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return const Color(0xFF4CAF50);
      case 'inactive':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getRoleIcon(String role) {
    if (role.toLowerCase().contains('dokter')) {
      return FontAwesomeIcons.userDoctor;
    } else if (role.toLowerCase().contains('perawat') || role.toLowerCase().contains('ns.')) {
      return FontAwesomeIcons.userNurse;
    }
    return FontAwesomeIcons.userTie;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = isDarkMode ? const Color(0xFF64B5F6) : const Color(0xFF1976D2);
    final Color backgroundColor = isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF8FAFB);
    final Color cardColor = isDarkMode ? const Color(0xFF2D3748) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF1E293B);
    final Color subtitleColor = isDarkMode ? const Color(0xFFCBD5E1) : Colors.grey[600]!;
    final Color filterIconBg = isDarkMode ? const Color(0xFF3B5678) : primaryColor.withOpacity(0.1);
    final Color filterIconColor = isDarkMode ? const Color(0xFF90CAF9) : primaryColor;

    final days = ["Semua", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"];
    final departments = ["Semua", "IGD", "ICU", "Poli Dalam", "Rawat Inap", "Bedah", "Radiologi"];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1976D2), Color(0xFF2196F3), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medical Shift Schedule',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now()),
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  FontAwesomeIcons.calendarDays,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildFilterSection(days, departments, isDarkMode, primaryColor, cardColor, subtitleColor, filterIconBg, filterIconColor),
            _buildStatsSection(isDarkMode),
            Expanded(child: _buildShiftList(isDarkMode, cardColor, textColor, subtitleColor, primaryColor)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const AddShiftPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 400),
            ),
          );
          if (result != null &&
              result is Map<String, dynamic> &&
              result['action'] == 'add') {
            _addShift(result['data'] as Map<String, String>);
          }
        },
        icon: const Icon(FontAwesomeIcons.plus),
        label: Text(
          'Tambah Shift',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildFilterSection(List<String> days, List<String> departments, bool isDarkMode, Color primaryColor, Color cardColor, Color subtitleColor, Color filterIconBg, Color filterIconColor) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: filterIconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  FontAwesomeIcons.filter,
                  color: filterIconColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Filter Jadwal',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: filterIconColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedDay,
                  items: days.map((day) => DropdownMenuItem(
                    value: day,
                    child: Text(day, style: GoogleFonts.inter(fontSize: 14)),
                  )).toList(),
                  onChanged: (val) => setState(() => _selectedDay = val!),
                  dropdownColor: cardColor,
                  style: TextStyle(color: subtitleColor),
                  decoration: InputDecoration(
                    labelText: "Hari",
                    labelStyle: TextStyle(color: subtitleColor),
                    prefixIcon: Icon(FontAwesomeIcons.calendar, size: 16, color: subtitleColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedDepartment,
                  items: departments.map((dept) => DropdownMenuItem(
                    value: dept,
                    child: Text(dept, style: GoogleFonts.inter(fontSize: 14)),
                  )).toList(),
                  onChanged: (val) => setState(() => _selectedDepartment = val!),
                  dropdownColor: cardColor,
                  style: TextStyle(color: subtitleColor),
                  decoration: InputDecoration(
                    labelText: "Departemen",
                    labelStyle: TextStyle(color: subtitleColor),
                    prefixIcon: Icon(FontAwesomeIcons.building, size: 16, color: subtitleColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(bool isDarkMode) {
    final activeShifts = _filteredShifts.where((s) => s['status'] == 'active').length;
    final totalShifts = _filteredShifts.length;
    final Color textColor = isDarkMode ? Colors.white : Colors.white;
    final Color subtitleColor = isDarkMode ? Colors.white.withOpacity(0.8) : Colors.white.withOpacity(0.9);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(FontAwesomeIcons.userCheck, color: Colors.white, size: 20),
                  const SizedBox(height: 8),
                  Text(
                    '$activeShifts',
                    style: GoogleFonts.inter(
                      color: textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Shift Aktif',
                    style: GoogleFonts.inter(
                      color: subtitleColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(FontAwesomeIcons.calendar, color: Colors.white, size: 20),
                  const SizedBox(height: 8),
                  Text(
                    '$totalShifts',
                    style: GoogleFonts.inter(
                      color: textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Total Shift',
                    style: GoogleFonts.inter(
                      color: subtitleColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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

  Widget _buildShiftList(bool isDarkMode, Color cardColor, Color textColor, Color subtitleColor, Color primaryColor) {
    if (_filteredShifts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                FontAwesomeIcons.calendarXmark,
                color: isDarkMode ? Colors.grey[500] : Colors.grey,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada jadwal shift',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Belum ada jadwal untuk filter yang dipilih',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: subtitleColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredShifts.length,
      itemBuilder: (context, index) {
        final shift = _filteredShifts[index];
        final originalIndex = _shifts.indexOf(shift);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1976D2), Color(0xFF2196F3)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getRoleIcon(shift['role'] ?? ''),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  shift['name'] ?? '',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(shift['status'] ?? 'inactive'),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  shift['status'] == 'active' ? 'Aktif' : 'Non-aktif',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            shift['role'] ?? '',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: subtitleColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.calendar,
                                  size: 12, color: subtitleColor.withOpacity(0.7)),
                              const SizedBox(width: 6),
                              Text(
                                '${shift['day']} • ${shift['shift']}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: subtitleColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.building,
                                  size: 12, color: subtitleColor.withOpacity(0.7)),
                              const SizedBox(width: 6),
                              Text(
                                shift['department'] ?? '',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: subtitleColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == "edit") {
                          final result = await Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  AddShiftPage(shift: shift, index: originalIndex),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(1.0, 0.0),
                                    end: Offset.zero,
                                  ).animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOutCubic,
                                  )),
                                  child: child,
                                );
                              },
                              transitionDuration: const Duration(milliseconds: 400),
                            ),
                          );
                          if (result != null &&
                              result is Map<String, dynamic> &&
                              result['action'] == 'edit') {
                            _editShift(originalIndex, result['data'] as Map<String, String>);
                          }
                        } else if (value == "delete") {
                          _deleteShift(originalIndex);
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: "edit",
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.penToSquare,
                                  color: primaryColor, size: 16),
                              const SizedBox(width: 12),
                              Text(
                                "Edit Shift",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: "delete",
                          child: Row(
                            children: [
                              const Icon(FontAwesomeIcons.trash,
                                  color: Colors.red, size: 16),
                              const SizedBox(width: 12),
                              Text(
                                "Hapus Shift",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          FontAwesomeIcons.ellipsisVertical,
                          size: 16,
                          color: subtitleColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AddShiftPage extends StatefulWidget {
  final Map<String, String>? shift;
  final int? index;

  const AddShiftPage({super.key, this.shift, this.index});

  @override
  State<AddShiftPage> createState() => _AddShiftPageState();
}

class _AddShiftPageState extends State<AddShiftPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  String _selectedDay = "Senin";
  String _selectedDepartment = "IGD";
  String _selectedStatus = "active";
  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 16, minute: 0);

  final List<String> _days = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu", "Minggu"];
  final List<String> _departments = ["IGD", "ICU", "Poli Dalam", "Rawat Inap", "Bedah", "Radiologi"];
  final List<Map<String, String>> _statuses = [
    {"value": "active", "label": "Aktif"},
    {"value": "inactive", "label": "Non-aktif"},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();

    if (widget.shift != null) {
      _nameController.text = widget.shift!['name'] ?? '';
      _roleController.text = widget.shift!['role'] ?? '';
      _selectedDay = widget.shift!['day'] ?? 'Senin';
      _selectedDepartment = widget.shift!['department'] ?? 'IGD';
      _selectedStatus = widget.shift!['status'] ?? 'active';

      // Parse time
      final timeStr = widget.shift!['shift'] ?? '08:00 - 16:00';
      final times = timeStr.split(' - ');
      if (times.length == 2) {
        _startTime = _parseTime(times[0]);
        _endTime = _parseTime(times[1]);
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final data = {
        "day": _selectedDay,
        "shift": "${_formatTime(_startTime)} - ${_formatTime(_endTime)}",
        "name": _nameController.text.trim(),
        "role": _roleController.text.trim(),
        "department": _selectedDepartment,
        "status": _selectedStatus,
      };

      Navigator.pop(context, {
        "action": widget.shift == null ? "add" : "edit",
        "data": data,
        "index": widget.index
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = isDarkMode ? const Color(0xFF64B5F6) : const Color(0xFF1976D2);
    final Color backgroundColor = isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF8FAFB);
    final Color cardColor = isDarkMode ? const Color(0xFF2D3748) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF1E293B);
    final Color subtitleColor = isDarkMode ? const Color(0xFFCBD5E1) : Colors.grey[600]!;
    final Color borderColor = isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1976D2), Color(0xFF2196F3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              widget.shift == null ? "Tambah Shift Baru" : "Edit Shift",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  widget.shift == null ? FontAwesomeIcons.plus : FontAwesomeIcons.penToSquare,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 0.1),
          end: Offset.zero,
        ).animate(_slideAnimation),
        child: FadeTransition(
          opacity: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Informasi Petugas", primaryColor),
                  const SizedBox(height: 16),
                  _buildPersonalInfoCard(primaryColor, cardColor, subtitleColor, borderColor),
                  const SizedBox(height: 24),
                  _buildSectionHeader("Jadwal & Departemen", primaryColor),
                  const SizedBox(height: 16),
                  _buildScheduleCard(primaryColor, cardColor, subtitleColor, borderColor),
                  const SizedBox(height: 24),
                  _buildSectionHeader("Waktu Shift", primaryColor),
                  const SizedBox(height: 16),
                  _buildTimeCard(context, primaryColor, cardColor, subtitleColor, borderColor),
                  const SizedBox(height: 32),
                  _buildSubmitButton(primaryColor),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color primaryColor) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoCard(Color primaryColor, Color cardColor, Color subtitleColor, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            style: GoogleFonts.inter(color: subtitleColor),
            decoration: InputDecoration(
              labelText: "Nama Lengkap",
              hintText: "Contoh: Dr. John Doe",
              labelStyle: TextStyle(color: subtitleColor),
              hintStyle: TextStyle(color: subtitleColor.withOpacity(0.6)),
              prefixIcon: Icon(FontAwesomeIcons.user, size: 16, color: subtitleColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            validator: (val) => val == null || val.trim().isEmpty ? "Nama harus diisi" : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _roleController,
            style: GoogleFonts.inter(color: subtitleColor),
            decoration: InputDecoration(
              labelText: "Jabatan/Posisi",
              hintText: "Contoh: Dokter Spesialis, Perawat Senior",
              labelStyle: TextStyle(color: subtitleColor),
              hintStyle: TextStyle(color: subtitleColor.withOpacity(0.6)),
              prefixIcon: Icon(FontAwesomeIcons.userTie, size: 16, color: subtitleColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            validator: (val) => val == null || val.trim().isEmpty ? "Jabatan harus diisi" : null,
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(Color primaryColor, Color cardColor, Color subtitleColor, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedDay,
                  items: _days.map((day) => DropdownMenuItem(
                    value: day,
                    child: Text(day, style: GoogleFonts.inter(color: subtitleColor, fontSize: 14)),
                  )).toList(),
                  onChanged: (val) => setState(() => _selectedDay = val!),
                  dropdownColor: cardColor,
                  style: GoogleFonts.inter(color: subtitleColor),
                  decoration: InputDecoration(
                    labelText: "Hari",
                    labelStyle: TextStyle(color: subtitleColor),
                    prefixIcon: Icon(FontAwesomeIcons.calendar, size: 16, color: subtitleColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedDepartment,
                  items: _departments.map((dept) => DropdownMenuItem(
                    value: dept,
                    child: Text(dept, style: GoogleFonts.inter(color: subtitleColor, fontSize: 14)),
                  )).toList(),
                  onChanged: (val) => setState(() => _selectedDepartment = val!),
                  dropdownColor: cardColor,
                  style: GoogleFonts.inter(color: subtitleColor),
                  decoration: InputDecoration(
                    labelText: "Departemen",
                    labelStyle: TextStyle(color: subtitleColor),
                    prefixIcon: Icon(FontAwesomeIcons.building, size: 16, color: subtitleColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedStatus,
            items: _statuses.map((status) => DropdownMenuItem(
              value: status['value'],
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: status['value'] == 'active'
                          ? const Color(0xFF4CAF50)
                          : Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(status['label']!, style: GoogleFonts.inter(color: subtitleColor, fontSize: 14)),
                ],
              ),
            )).toList(),
            onChanged: (val) => setState(() => _selectedStatus = val!),
            dropdownColor: cardColor,
            style: GoogleFonts.inter(color: subtitleColor),
            decoration: InputDecoration(
              labelText: "Status Shift",
              labelStyle: TextStyle(color: subtitleColor),
              prefixIcon: Icon(FontAwesomeIcons.toggleOn, size: 16, color: subtitleColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryColor, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCard(BuildContext context, Color primaryColor, Color cardColor, Color subtitleColor, Color borderColor) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color infoColor = isDarkMode ? const Color(0xFF90CAF9) : primaryColor;
    final Color infoBg = isDarkMode ? const Color(0xFF2B3A4F) : primaryColor.withOpacity(0.1);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: _startTime,
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: primaryColor,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (time != null) {
                      setState(() => _startTime = time);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.clock,
                            size: 16, color: primaryColor),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Jam Mulai",
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: subtitleColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatTime(_startTime),
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 2,
                height: 30,
                color: borderColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: _endTime,
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: primaryColor,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (time != null) {
                      setState(() => _endTime = time);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.clock,
                            size: 16, color: primaryColor),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Jam Selesai",
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: subtitleColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatTime(_endTime),
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: infoBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(FontAwesomeIcons.info,
                    size: 14, color: infoColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Tap pada waktu untuk mengubah jam shift",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: infoColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(Color primaryColor) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: primaryColor.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.shift == null ? FontAwesomeIcons.plus : FontAwesomeIcons.floppyDisk,
              size: 16,
            ),
            const SizedBox(width: 12),
            Text(
              widget.shift == null ? "Tambah Shift" : "Update Shift",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
