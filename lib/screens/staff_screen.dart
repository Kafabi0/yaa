import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import Font Awesome Icons

// -- Define common colors for consistency --
const Color primaryBlue = Color(0xFF1976D2);
const Color accentBlue = Color(0xFF2196F3);
const Color darkBg = Color(0xFF1E293B);
const Color darkCard = Color(0xFF2D3748);
const Color lightBg = Color(0xFFF1F5F9); // Light gray for light mode background
const Color lightCard = Colors.white;

class StaffDirectory extends StatefulWidget {
  const StaffDirectory({super.key});

  @override
  State<StaffDirectory> createState() => _StaffDirectoryState();
}

class _StaffDirectoryState extends State<StaffDirectory> {
  final List<Map<String, String>> _staffList = [
    {"name": "Dr. Andi", "role": "Dokter Umum", "phone": "081234567890", "email": "andi@example.com", "avatar": "https://i.pravatar.cc/150?img=6"},
    {"name": "Ns. Budi", "role": "Perawat", "phone": "081298765432", "email": "budi@example.com", "avatar": "https://i.pravatar.cc/150?img=1"},
    {"name": "Dr. Clara", "role": "Spesialis Anak", "phone": "081212345678", "email": "clara@example.com", "avatar": "https://i.pravatar.cc/150?img=2"},
    {"name": "Admin Dina", "role": "Admin", "phone": "081309876543", "email": "dina@example.com", "avatar": "https://i.pravatar.cc/150?img=3"},
    {"name": "Dr. Eko", "role": "Dokter Umum", "phone": "081122334455", "email": "eko@example.com", "avatar": "https://i.pravatar.cc/150?img=4"},
  ];

  String _selectedRole = "Semua";

  // Filter staff based on selected role
  List<Map<String, String>> get _filteredStaff {
    if (_selectedRole == "Semua") return _staffList;
    return _staffList.where((staff) => staff['role'] == _selectedRole).toList();
  }

  // Add new staff to the list
  void _addStaff(Map<String, String> newStaff) {
    setState(() {
      _staffList.add(newStaff);
    });
  }

  // Edit existing staff in the list
  void _editStaff(int index, Map<String, String> updatedStaff) {
    setState(() {
      _staffList[index] = updatedStaff;
    });
  }

  // Delete staff from the list with a confirmation dialog
  void _deleteStaff(int index) {
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
          'Apakah Anda yakin ingin menghapus staf ini?',
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
                _staffList.removeAt(index);
              });
              Navigator.pop(context); // Close dialog
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

  IconData _getRoleIcon(String role) {
    if (role.toLowerCase().contains('dokter')) {
      return FontAwesomeIcons.userDoctor;
    } else if (role.toLowerCase().contains('perawat')) {
      return FontAwesomeIcons.userNurse;
    } else if (role.toLowerCase().contains('admin')) {
      return FontAwesomeIcons.userTie;
    }
    return FontAwesomeIcons.user;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color currentBg = isDarkMode ? darkBg : lightBg;
    final Color currentCardColor = isDarkMode ? darkCard : lightCard;
    final Color currentTextColor = isDarkMode ? Colors.white : Colors.black87;
    final Color currentSubtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    final Color currentBorderColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;

    final roles = ["Semua", "Dokter Umum", "Spesialis Anak", "Perawat", "Admin"];

    return Scaffold(
      backgroundColor: currentBg,
      appBar: AppBar(
        title: Text(
          "Staff Directory",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: primaryBlue,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryBlue, accentBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter role section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: currentCardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode ? Colors.transparent : Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedRole,
                items: roles.map((role) => DropdownMenuItem(
                  value: role,
                  child: Text(
                    role,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: currentTextColor,
                    ),
                  ),
                )).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedRole = val!;
                  });
                },
                dropdownColor: currentCardColor,
                style: GoogleFonts.inter(color: currentTextColor),
                decoration: InputDecoration(
                  labelText: "Filter Jabatan",
                  labelStyle: GoogleFonts.inter(color: currentSubtitleColor),
                  prefixIcon: Icon(FontAwesomeIcons.filter, size: 16, color: currentSubtitleColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: currentBorderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: currentBorderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryBlue, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
          // Staff list
          Expanded(
            child: _filteredStaff.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.usersSlash,
                          size: 60,
                          color: currentSubtitleColor.withOpacity(0.6),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Tidak ada staf ditemukan",
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: currentTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Coba filter yang berbeda atau tambahkan staf baru.",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: currentSubtitleColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _filteredStaff.length,
                    itemBuilder: (context, index) {
                      final staff = _filteredStaff[index];
                      final originalIndex = _staffList.indexOf(staff);

                      return StaffCard(
                        staff: staff,
                        isDarkMode: isDarkMode,
                        onEdit: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddEditStaffPage(staff: staff, index: originalIndex),
                            ),
                          );
                          if (result != null &&
                              result is Map<String, dynamic> &&
                              result['action'] == 'edit') {
                            _editStaff(originalIndex, result['data'] as Map<String, String>);
                          }
                        },
                        onDelete: () => _deleteStaff(originalIndex),
                        getRoleIcon: _getRoleIcon,
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditStaffPage()),
          );
          if (result != null &&
              result is Map<String, dynamic> &&
              result['action'] == 'add') {
            _addStaff(result['data'] as Map<String, String>);
          }
        },
        icon: const Icon(FontAwesomeIcons.plus, color: Colors.white),
        label: Text(
          "Tambah Staf",
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// =================== Staff Card Widget ===================
class StaffCard extends StatelessWidget {
  final Map<String, String> staff;
  final bool isDarkMode;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(String) getRoleIcon;

  const StaffCard({
    super.key,
    required this.staff,
    required this.isDarkMode,
    required this.onEdit,
    required this.onDelete,
    required this.getRoleIcon,
  });

  @override
  Widget build(BuildContext context) {
    final Color currentCardColor = isDarkMode ? darkCard : lightCard;
    final Color currentTextColor = isDarkMode ? Colors.white : Colors.black87;
    final Color currentSubtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: currentCardColor,
      elevation: isDarkMode ? 0 : 4,
      shadowColor: isDarkMode ? Colors.transparent : Colors.black.withOpacity(0.08),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onEdit, // Tap card to edit
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: primaryBlue.withOpacity(0.1),
                backgroundImage: staff['avatar'] != null ? NetworkImage(staff['avatar']!) : null,
                child: staff['avatar'] == null
                    ? Icon(
                        getRoleIcon(staff['role'] ?? ''),
                        color: primaryBlue,
                        size: 24,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      staff['name'] ?? 'N/A',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: currentTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      staff['role'] ?? 'N/A',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: currentSubtitleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.phone, size: 12, color: currentSubtitleColor),
                        const SizedBox(width: 8),
                        Text(
                          staff['phone'] ?? 'N/A',
                          style: GoogleFonts.inter(fontSize: 13, color: currentSubtitleColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.envelope, size: 12, color: currentSubtitleColor),
                        const SizedBox(width: 8),
                        Text(
                          staff['email'] ?? 'N/A',
                          style: GoogleFonts.inter(fontSize: 13, color: currentSubtitleColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == "edit") {
                    onEdit();
                  } else if (value == "delete") {
                    onDelete();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: "edit",
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.penToSquare, color: primaryBlue, size: 16),
                        const SizedBox(width: 10),
                        Text("Edit", style: GoogleFonts.inter(color: primaryBlue)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: "delete",
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.trash, color: Colors.red, size: 16),
                        const SizedBox(width: 10),
                        Text("Hapus", style: GoogleFonts.inter(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                icon: Icon(FontAwesomeIcons.ellipsisVertical, color: currentSubtitleColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =================== Add/Edit Staff Page ===================
class AddEditStaffPage extends StatefulWidget {
  final Map<String, String>? staff;
  final int? index;

  const AddEditStaffPage({super.key, this.staff, this.index});

  @override
  State<AddEditStaffPage> createState() => _AddEditStaffPageState();
}

class _AddEditStaffPageState extends State<AddEditStaffPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final List<String> _roles = ["Dokter Umum", "Spesialis Anak", "Perawat", "Admin"];
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    if (widget.staff != null) {
      _nameController.text = widget.staff!['name'] ?? '';
      _roleController.text = widget.staff!['role'] ?? '';
      _phoneController.text = widget.staff!['phone'] ?? '';
      _emailController.text = widget.staff!['email'] ?? '';
      _selectedRole = widget.staff!['role']; // Set selected role for dropdown
    } else {
      _selectedRole = _roles.first; // Default for new staff
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final data = {
        "name": _nameController.text.trim(),
        "role": _selectedRole!, // Use selected role from dropdown
        "phone": _phoneController.text.trim(),
        "email": _emailController.text.trim(),
        "avatar": "https://i.pravatar.cc/150?img=${DateTime.now().millisecond % 10 + 1}", // Random avatar for new staff
      };
      Navigator.pop(context, {
        "action": widget.staff == null ? "add" : "edit",
        "data": data,
        "index": widget.index,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color currentBg = isDarkMode ? darkBg : lightBg;
    final Color currentCardColor = isDarkMode ? darkCard : lightCard;
    final Color currentTextColor = isDarkMode ? Colors.white : Colors.black87;
    final Color currentSubtitleColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    final Color currentBorderColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;

    return Scaffold(
      backgroundColor: currentBg,
      appBar: AppBar(
        title: Text(
          widget.staff == null ? "Tambah Staf Baru" : "Edit Staf",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        backgroundColor: primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryBlue, accentBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _nameController,
                labelText: "Nama Staf",
                hintText: "Masukkan nama lengkap staf",
                icon: FontAwesomeIcons.user,
                isDarkMode: isDarkMode,
                textColor: currentTextColor,
                subtitleColor: currentSubtitleColor,
                borderColor: currentBorderColor,
              ),
              const SizedBox(height: 16),
              _buildRoleDropdown(
                isDarkMode: isDarkMode,
                textColor: currentTextColor,
                subtitleColor: currentSubtitleColor,
                borderColor: currentBorderColor,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneController,
                labelText: "Telepon",
                hintText: "Masukkan nomor telepon",
                icon: FontAwesomeIcons.phone,
                keyboardType: TextInputType.phone,
                isDarkMode: isDarkMode,
                textColor: currentTextColor,
                subtitleColor: currentSubtitleColor,
                borderColor: currentBorderColor,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                labelText: "Email",
                hintText: "Masukkan alamat email",
                icon: FontAwesomeIcons.envelope,
                keyboardType: TextInputType.emailAddress,
                isDarkMode: isDarkMode,
                textColor: currentTextColor,
                subtitleColor: currentSubtitleColor,
                borderColor: currentBorderColor,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: Icon(widget.staff == null ? FontAwesomeIcons.save : FontAwesomeIcons.floppyDisk, color: Colors.white),
                  label: Text(
                    widget.staff == null ? "Simpan Staf" : "Update Staf",
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for premium TextFields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required bool isDarkMode,
    required Color textColor,
    required Color subtitleColor,
    required Color borderColor,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.inter(color: textColor),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: GoogleFonts.inter(color: subtitleColor),
        hintStyle: GoogleFonts.inter(color: subtitleColor.withOpacity(0.6)),
        prefixIcon: Icon(icon, size: 16, color: subtitleColor),
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
          borderSide: BorderSide(color: primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return "$labelText harus diisi";
        }
        if (labelText == "Email" && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val.trim())) {
          return "Masukkan alamat email yang valid";
        }
        return null;
      },
    );
  }

  // Helper widget for premium Role Dropdown
  Widget _buildRoleDropdown({
    required bool isDarkMode,
    required Color textColor,
    required Color subtitleColor,
    required Color borderColor,
  }) {
    return DropdownButtonFormField<String>(
      value: _selectedRole,
      items: _roles.map((role) => DropdownMenuItem(
        value: role,
        child: Text(
          role,
          style: GoogleFonts.inter(fontSize: 14, color: textColor),
        ),
      )).toList(),
      onChanged: (val) => setState(() => _selectedRole = val!),
      dropdownColor: isDarkMode ? darkCard : lightCard,
      style: GoogleFonts.inter(color: textColor),
      decoration: InputDecoration(
        labelText: "Jabatan",
        labelStyle: GoogleFonts.inter(color: subtitleColor),
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
          borderSide: BorderSide(color: primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (val) => val == null || val.isEmpty ? "Jabatan harus dipilih" : null,
    );
  }
}