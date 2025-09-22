import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderAmbulancePage extends StatefulWidget {
  const OrderAmbulancePage({Key? key}) : super(key: key);

  @override
  State<OrderAmbulancePage> createState() => _OrderAmbulancePageState();
}

class _OrderAmbulancePageState extends State<OrderAmbulancePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emergencyContactController =
      TextEditingController();
  final TextEditingController _medicalConditionController =
      TextEditingController();

  String? _selectedAmbulanceType;
  String? _selectedPriority;
  bool _needMedicalEquipment = false;
  bool _needMedicalPersonnel = false;

  final List<Map<String, dynamic>> ambulanceTypes = [
    {
      'type': 'Basic Life Support (BLS)',
      'description': 'Ambulance standar dengan peralatan dasar',
      'price': 500000,
      'icon': Icons.local_hospital,
      'color': Colors.blue,
    },
    {
      'type': 'Advanced Life Support (ALS)',
      'description': 'Ambulance dengan peralatan dan tenaga medis lengkap',
      'price': 1000000,
      'icon': Icons.medical_services,
      'color': Colors.red,
    },
    {
      'type': 'Neonatal Ambulance',
      'description': 'Khusus untuk transportasi bayi dan anak',
      'price': 1500000,
      'icon': Icons.child_care,
      'color': Colors.pink,
    },
    {
      'type': 'Ambulance Jenazah',
      'description': 'Khusus untuk transportasi jenazah',
      'price': 750000,
      'icon': Icons.local_florist,
      'color': Colors.grey,
    },
  ];

  final List<Map<String, dynamic>> priorityLevels = [
    {
      'level': 'Emergency (Gawat Darurat)',
      'description': 'Kondisi mengancam nyawa, respon < 15 menit',
      'color': Colors.red,
      'icon': Icons.warning,
    },
    {
      'level': 'Urgent (Mendesak)',
      'description': 'Kondisi serius, respon < 30 menit',
      'color': Colors.orange,
      'icon': Icons.priority_high,
    },
    {
      'level': 'Scheduled (Terjadwal)',
      'description': 'Transport terencana, respon fleksibel',
      'color': Colors.green,
      'icon': Icons.schedule,
    },
  ];

  int availableAmbulances = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Order Ambulance",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [_buildHeaderInfo(), _buildFormContent()]),
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red[700]!, Colors.red[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_hospital,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Layanan Ambulance 24/7",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "$availableAmbulances Unit tersedia sekarang",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.phone, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  "Hotline Darurat: 119 atau (021) 119-119",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContent() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPrioritySection(),
            SizedBox(height: 24),
            _buildAmbulanceTypeSection(),
            SizedBox(height: 24),
            _buildPatientInfoSection(),
            SizedBox(height: 24),
            _buildLocationSection(),
            SizedBox(height: 24),
            _buildAdditionalServicesSection(),
            SizedBox(height: 32),
            _buildOrderButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrioritySection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.priority_high, color: Colors.red[700]),
                SizedBox(width: 8),
                Text(
                  "Tingkat Prioritas",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            ...priorityLevels
                .map((priority) => _buildPriorityOption(priority))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityOption(Map<String, dynamic> priority) {
    bool isSelected = _selectedPriority == priority['level'];

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPriority = priority['level'];
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? priority['color'].withOpacity(0.1)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? priority['color'] : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(priority['icon'], color: priority['color'], size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      priority['level'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? priority['color'] : Colors.black87,
                      ),
                    ),
                    Text(
                      priority['description'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: priority['color']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmbulanceTypeSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_hospital, color: Colors.blue[700]),
                SizedBox(width: 8),
                Text(
                  "Jenis Ambulance",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            ...ambulanceTypes
                .map((type) => _buildAmbulanceTypeOption(type))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAmbulanceTypeOption(Map<String, dynamic> type) {
    bool isSelected = _selectedAmbulanceType == type['type'];

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedAmbulanceType = type['type'];
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? type['color'].withOpacity(0.1)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? type['color'] : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(type['icon'], color: type['color'], size: 32),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type['type'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? type['color'] : Colors.black87,
                      ),
                    ),
                    Text(
                      type['description'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      "Rp ${_formatPrice(type['price'])}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected) Icon(Icons.check_circle, color: type['color']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientInfoSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.green[700]),
                SizedBox(width: 8),
                Text(
                  "Informasi Pasien",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _patientNameController,
              label: "Nama Pasien",
              icon: Icons.person_outline,
              validator:
                  (val) =>
                      val?.isEmpty ?? true ? "Nama pasien wajib diisi" : null,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _phoneController,
              label: "Nomor Telepon",
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator:
                  (val) =>
                      val?.isEmpty ?? true ? "Nomor telepon wajib diisi" : null,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _emergencyContactController,
              label: "Kontak Darurat (Keluarga)",
              icon: Icons.contact_phone,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _medicalConditionController,
              label: "Kondisi Medis/Keluhan",
              icon: Icons.medical_information,
              maxLines: 3,
              validator:
                  (val) =>
                      val?.isEmpty ?? true ? "Kondisi medis wajib diisi" : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.orange[700]),
                SizedBox(width: 8),
                Text(
                  "Lokasi",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _pickupController,
              label: "Lokasi Penjemputan",
              icon: Icons.my_location,
              validator:
                  (val) =>
                      val?.isEmpty ?? true
                          ? "Lokasi penjemputan wajib diisi"
                          : null,
              suffixIcon: IconButton(
                icon: Icon(Icons.gps_fixed),
                onPressed: () => _getCurrentLocation(),
              ),
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _destinationController,
              label: "Lokasi Tujuan",
              icon: Icons.local_hospital,
              validator:
                  (val) =>
                      val?.isEmpty ?? true ? "Lokasi tujuan wajib diisi" : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalServicesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.add_circle_outline, color: Colors.purple[700]),
                SizedBox(width: 8),
                Text(
                  "Layanan Tambahan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text("Peralatan Medis Khusus"),
              subtitle: Text("Ventilator, monitor jantung, dll (+Rp 200.000)"),
              value: _needMedicalEquipment,
              onChanged: (value) {
                setState(() {
                  _needMedicalEquipment = value ?? false;
                });
              },
              activeColor: Colors.purple[700],
            ),
            CheckboxListTile(
              title: Text("Tenaga Medis Pendamping"),
              subtitle: Text("Dokter atau perawat pendamping (+Rp 500.000)"),
              value: _needMedicalPersonnel,
              onChanged: (value) {
                setState(() {
                  _needMedicalPersonnel = value ?? false;
                });
              },
              activeColor: Colors.purple[700],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red[700]!, width: 2),
        ),
      ),
    );
  }

  Widget _buildOrderButton() {
    int totalPrice = _calculateTotalPrice();

    return Column(
      children: [
        if (_selectedAmbulanceType != null) ...[
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Estimasi Biaya:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Rp ${_formatPrice(totalPrice)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {
              if (_formKey.currentState!.validate() &&
                  _selectedPriority != null &&
                  _selectedAmbulanceType != null) {
                _confirmOrder();
              } else {
                _showValidationError();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: Icon(Icons.emergency, size: 24),
            label: Text(
              "Konfirmasi Order Ambulance",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          "Dengan menekan tombol konfirmasi, Anda menyetujui syarat dan ketentuan layanan ambulance",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  int _calculateTotalPrice() {
    int basePrice = 0;

    for (var type in ambulanceTypes) {
      if (type['type'] == _selectedAmbulanceType) {
        basePrice = type['price'];
        break;
      }
    }

    if (_needMedicalEquipment) basePrice += 200000;
    if (_needMedicalPersonnel) basePrice += 500000;

    return basePrice;
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]}.',
    );
  }

  void _getCurrentLocation() {
    // Implementasi GPS location
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Mendapatkan lokasi saat ini..."),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showValidationError() {
    String message = "Mohon lengkapi:";
    if (_selectedPriority == null) message += "\n• Tingkat prioritas";
    if (_selectedAmbulanceType == null) message += "\n• Jenis ambulance";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _confirmOrder() async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.warning, color: Colors.orange),
                SizedBox(width: 8),
                Text("Konfirmasi Order"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Detail Order:"),
                SizedBox(height: 8),
                Text("• Prioritas: $_selectedPriority"),
                Text("• Jenis: $_selectedAmbulanceType"),
                Text("• Pasien: ${_patientNameController.text}"),
                Text("• Dari: ${_pickupController.text}"),
                Text("• Ke: ${_destinationController.text}"),
                Text("• Total: Rp ${_formatPrice(_calculateTotalPrice())}"),
                SizedBox(height: 16),
                Text(
                  "Tim medis akan segera dikirim ke lokasi Anda.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);

                  final prefs = await SharedPreferences.getInstance();
                  String orderCode =
                      "AMB${Random().nextInt(99999).toString().padLeft(5, '0')}";
                  await prefs.setString('orderAmbulance', orderCode);

                  Navigator.pop(context); // keluar dari form
                  _showSuccessMessage();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                ),
                child: Text(
                  "Konfirmasi",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Order Berhasil!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Ambulance akan tiba dalam 15-30 menit"),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text("Bantuan Order Ambulance"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Tingkat Prioritas:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("• Emergency: Kondisi mengancam nyawa"),
                  Text("• Urgent: Kondisi serius tapi stabil"),
                  Text("• Scheduled: Transport terencana"),
                  SizedBox(height: 12),
                  Text(
                    "Jenis Ambulance:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("• BLS: Peralatan dasar"),
                  Text("• ALS: Peralatan dan tenaga medis lengkap"),
                  Text("• Neonatal: Khusus bayi/anak"),
                  Text("• Jenazah: Transport jenazah"),
                  SizedBox(height: 12),
                  Text(
                    "Untuk kondisi darurat, hubungi 119",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Mengerti"),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _destinationController.dispose();
    _patientNameController.dispose();
    _phoneController.dispose();
    _emergencyContactController.dispose();
    _medicalConditionController.dispose();
    super.dispose();
  }
}
