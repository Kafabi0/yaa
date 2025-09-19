import 'package:flutter/material.dart';
import 'package:inocare/screens/ermdoctor_form_triase_screen.dart';
// import 'package:inocare/models/pasien_selesai.dart';
import 'package:inocare/screens/pasienselesai_screen.dart';

class ErmDoctorPage extends StatefulWidget {
  const ErmDoctorPage({super.key});

  @override
  State<ErmDoctorPage> createState() => _ErmDoctorPageState();
}

class _ErmDoctorPageState extends State<ErmDoctorPage> {
  bool showMenuSelection = true;
  String selectedDoctor = "Pilih Dokter Operator";
  String searchQuery = "";
  String selectedFilter = "Operasi";
  DateTime? selectedDate;
  TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> patients = [
    {
      "name": "M NUR HARUN",
      "nik": "1704055202002915064",
      "reg": "00040000",
      "dob": "1992-04-02",
      "age": 33,
      "queue": 1,
      "status": "umum",
      "operation": "Proses Operasi",
      "doctor": "DR IMAM GHOZALI SP. AN, M.KES",
      "tag": "Operasi",
      "category": "Operasi",
      "registrationDate": "2024-08-29",
    },
    {
      "name": "M NUR HARUN",
      "nik": "1704055202002915064",
      "reg": "00040000",
      "dob": "1992-04-02",
      "age": 33,
      "queue": 2,
      "status": "umum",
      "operation": "Proses Operasi",
      "doctor": "DR IMAM GHOZALI SP. AN, M.KES",
      "tag": "Operasi",
      "category": "Operasi",
      "registrationDate": "2024-08-29",
    },
    {
      "name": "M NUR HARUN",
      "nik": "1704055202002915064",
      "reg": "00040000",
      "dob": "1992-04-02",
      "age": 33,
      "queue": 3,
      "status": "umum",
      "operation": "Proses Operasi",
      "doctor": "DR IMAM GHOZALI SP. AN, M.KES",
      "tag": "Operasi",
      "category": "Operasi",
      "registrationDate": "2024-08-28",
    },
    {
      "name": "M NUR HARUN",
      "nik": "1704055202002915064",
      "reg": "00040000",
      "dob": "1992-04-02",
      "age": 33,
      "queue": 4,
      "status": "umum",
      "operation": "Proses Operasi",
      "doctor": "DR IMAM GHOZALI SP. AN, M.KES",
      "tag": "Operasi",
      "category": "Rawat Jalan",
      "registrationDate": "2024-08-27",
    },
    {
      "name": "ABDUL GAFAR",
      "nik": "1542054063032521052",
      "reg": "00040006",
      "dob": "1963-11-22",
      "age": 61,
      "queue": 5,
      "status": "bpjs",
      "operation": "Selesai Operasi",
      "doctor": "dr. Canggih Dian Hidayah",
      "tag": "Post",
      "category": "Operasi",
      "registrationDate": "2024-08-29",
    },
    {
      "name": "M NUR HARUN",
      "nik": "1704055202002915064",
      "reg": "00040000",
      "dob": "1992-04-02",
      "age": 33,
      "queue": 6,
      "status": "umum",
      "operation": "Proses Operasi",
      "doctor": "DR ABDUL FATAH",
      "tag": "Operasi",
      "category": "Rawat Inap",
      "registrationDate": "2024-08-26",
    },
    {
      "name": "Budi Santoso",
      "nik": "3204030808040848",
      "reg": "00040007",
      "dob": "1980-08-08",
      "age": 45,
      "queue": 7,
      "status": "bpjs",
      "operation": "Selesai Operasi",
      "doctor": "dr. Nurul Yulianti",
      "tag": "Post",
      "category": "Unit Penunjang",
      "registrationDate": "2024-08-25",
    },
    {
      "name": "SEBASTIAN SEWA",
      "nik": "5101076502900004",
      "reg": "00040008",
      "dob": "1965-02-25",
      "age": 59,
      "queue": 8,
      "status": "bpjs",
      "operation": "Selesai Operasi",
      "doctor": "dr. Nurul Yulianti",
      "tag": "Post",
      "category": "Rawat Jalan",
      "registrationDate": "2024-08-24",
    },
    {
      "name": "dimas pratama",
      "nik": "3204348",
      "reg": "00040009",
      "dob": "1990-10-10",
      "age": 35,
      "queue": 9,
      "status": "umum",
      "operation": "Selesai Operasi",
      "doctor": "dr. FITRI SUHARNA",
      "tag": "Post",
      "category": "Rawat Inap",
      "registrationDate": "2024-08-23",
    },
    {
      "name": "M NUR HARUN",
      "nik": "3646308044324485763",
      "reg": "00040000",
      "dob": "1992-04-02",
      "age": 33,
      "queue": 10,
      "status": "umum",
      "operation": "Selesai Operasi",
      "doctor": "DR IMAM GHOZALI SP. AN, M.KES",
      "tag": "Post",
      "category": "Operasi",
      "registrationDate": "2024-08-22",
    },
  ];

  // Method untuk menampilkan alert dialog
  void _showPatientDialog(Map<String, dynamic> patientData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: 220, //harusnya 320
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.warning_amber,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Pasien dengan nomor registrasi",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        patientData["reg"],
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Akan dikenakan billing atas nama user :",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white,
                          ),
                        ),
                        child: const Text(
                          "Super Admin",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Lanjutkan proses ?",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                // Action buttons
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // TODO: Implement lanjutkan logic
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Melanjutkan proses untuk ${patientData["name"]}",
                                ),
                                backgroundColor: const Color(0xFF059669),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Lanjutkan",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDC2626),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Tidak",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> get filteredPatients {
    return patients.where((patient) {
      final nameMatch = patient["name"].toString().toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      final nikMatch = patient["nik"].toString().contains(searchQuery);
      final regMatch = patient["reg"].toString().contains(searchQuery);
      final searchMatch =
          searchQuery.isEmpty || nameMatch || nikMatch || regMatch;

      final doctorMatch =
          selectedDoctor == "Pilih Dokter Operator" ||
          patient["doctor"] == selectedDoctor;
      final categoryMatch = patient["category"] == selectedFilter;

      bool dateMatch = true;
      if (selectedDate != null) {
        final regDate = DateTime.parse(patient["registrationDate"]);
        dateMatch =
            regDate.year == selectedDate!.year &&
            regDate.month == selectedDate!.month &&
            regDate.day == selectedDate!.day;
      }

      return searchMatch && doctorMatch && categoryMatch && dateMatch;
    }).toList();
  }

  int getCrossAxisCount(double width) {
    if (width > 1400) return 4;
    if (width > 900) return 3;
    if (width > 600) return 2;
    return 1;
  }

  double getChildAspectRatio(double width) {
    if (width > 1200) return 1.1;
    if (width > 800) return 1.05;
    if (width > 600) return 1.2;
    return 1.99;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E40AF),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _clearDateFilter() {
    setState(() {
      selectedDate = null;
    });
  }

  Widget _buildMenuSelection() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E40AF).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.local_hospital,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Pilih Menu",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Silakan pilih kategori yang ingin Anda kelola",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: _buildMenuOption(
                    icon: Icons.shield,
                    title: "Form Triase",
                    subtitle: "Form Triase Baru",
                    color: const Color(0xFF1E40AF),
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => const ErmDoctorFormTriaseScreen())
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMenuOption(
                    icon: Icons.person,
                    title: "Pasien Aktif",
                    subtitle: "Layanan Pasien",
                    color: const Color(0xFF059669),
                    onTap: () {
                      setState(() {
                        showMenuSelection = false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMenuOption(
                    icon: Icons.history,
                    title: "Selesai",
                    subtitle: "Pasien Selesai Layanan",
                    color: const Color(0xFF0D6EFD),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PasienSelesaiPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "ERM Doctor",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
        centerTitle: true,
        leading:
            showMenuSelection
                ? null
                : IconButton(
                  onPressed: () {
                    setState(() {
                      showMenuSelection = true;
                    });
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
      ),
      body:
          showMenuSelection
              ? _buildMenuSelection()
              : LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: "Pilih Dokter Operator",
                                      labelStyle: TextStyle(
                                        color: Colors.grey[700],
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF1E40AF),
                                          width: 2,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                      prefixIcon: Icon(
                                        Icons.person_pin,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    value: selectedDoctor,
                                    isExpanded: true,
                                    items:
                                        [
                                              "Pilih Dokter Operator",
                                              "DR IMAM GHOZALI SP. AN, M.KES",
                                              "dr. Canggih Dian Hidayah",
                                              "DR ABDUL FATAH",
                                              "dr. Nurul Yulianti",
                                              "dr. FITRI SUHARNA",
                                            ]
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e,
                                                child: Text(
                                                  e,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDoctor = value!;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: TextField(
                                          controller: searchController,
                                          decoration: InputDecoration(
                                            hintText:
                                                "Cari Nama/No RM/No Reg Pasien",
                                            hintStyle: TextStyle(
                                              color: Colors.grey[500],
                                            ),
                                            prefixIcon: Icon(
                                              Icons.search,
                                              color: Colors.grey[600],
                                            ),
                                            suffixIcon:
                                                searchQuery.isNotEmpty
                                                    ? IconButton(
                                                      icon: const Icon(
                                                        Icons.clear,
                                                        color: Colors.grey,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          searchController
                                                              .clear();
                                                          searchQuery = "";
                                                        });
                                                      },
                                                    )
                                                    : null,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: Colors.grey[300]!,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: Colors.grey[300]!,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                color: Color(0xFF1E40AF),
                                                width: 2,
                                              ),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 12,
                                                ),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              searchQuery = value;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      ElevatedButton.icon(
                                        onPressed: () => _selectDate(context),
                                        icon: const Icon(
                                          Icons.calendar_today,
                                          size: 18,
                                        ),
                                        label: Text(
                                          selectedDate != null
                                              ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                                              : "Tanggal",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              selectedDate != null
                                                  ? const Color(0xFFEA580C)
                                                  : const Color(0xFF1E40AF),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          elevation: 2,
                                        ),
                                      ),
                                      if (selectedDate != null) ...[
                                        const SizedBox(width: 8),
                                        IconButton(
                                          onPressed: _clearDateFilter,
                                          icon: const Icon(Icons.clear),
                                          iconSize: 20,
                                          color: const Color(0xFFDC2626),
                                          tooltip: "Hapus filter tanggal",
                                          style: IconButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFFFEE2E2,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Pasien Aktif",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF1E40AF),
                                      Color(0xFF3B82F6),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF1E40AF,
                                      ).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  "${filteredPatients.length} Pasien",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildFilterChip(
                                    "Rawat Jalan",
                                    Icons.local_hospital,
                                  ),
                                  const SizedBox(width: 12),
                                  _buildFilterChip("Rawat Inap", Icons.hotel),
                                  const SizedBox(width: 12),
                                  _buildFilterChip(
                                    "Unit Penunjang",
                                    Icons.support,
                                  ),
                                  const SizedBox(width: 12),
                                  _buildFilterChip(
                                    "Operasi",
                                    Icons.medical_services,
                                  ),
                                  const SizedBox(width: 16),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedFilter = "Operasi";
                                        selectedDoctor =
                                            "Pilih Dokter Operator";
                                        searchController.clear();
                                        searchQuery = "";
                                        selectedDate = null;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFFE2E8F0),
                                        ),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.refresh,
                                            size: 16,
                                            color: Color(0xFF64748B),
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            "Reset",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          if (selectedDoctor != "Pilih Dokter Operator" ||
                              searchQuery.isNotEmpty ||
                              selectedDate != null)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFFBBF24),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.filter_alt,
                                        size: 16,
                                        color: Color(0xFFB45309),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "Filter Aktif:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Color(0xFFB45309),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 6,
                                    children: [
                                      if (selectedDoctor !=
                                          "Pilih Dokter Operator")
                                        _buildActiveFilterChip(
                                          "Dokter: ${selectedDoctor}",
                                          () {
                                            setState(() {
                                              selectedDoctor =
                                                  "Pilih Dokter Operator";
                                            });
                                          },
                                        ),
                                      if (searchQuery.isNotEmpty)
                                        _buildActiveFilterChip(
                                          "Pencarian: $searchQuery",
                                          () {
                                            setState(() {
                                              searchController.clear();
                                              searchQuery = "";
                                            });
                                          },
                                        ),
                                      if (selectedDate != null)
                                        _buildActiveFilterChip(
                                          "Tanggal: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                                          _clearDateFilter,
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          if (selectedDoctor != "Pilih Dokter Operator" ||
                              searchQuery.isNotEmpty ||
                              selectedDate != null)
                            const SizedBox(height: 20),

                          if (filteredPatients.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(48),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Icon(
                                      Icons.search_off,
                                      size: 48,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    "Tidak ada data pasien",
                                    style: TextStyle(
                                      color: Color(0xFF475569),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Coba ubah filter atau kata kunci pencarian",
                                    style: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),

                          if (filteredPatients.isNotEmpty)
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final crossAxisCount = getCrossAxisCount(
                                  constraints.maxWidth,
                                );
                                final childAspectRatio = getChildAspectRatio(
                                  constraints.maxWidth,
                                );

                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: filteredPatients.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                        childAspectRatio: childAspectRatio,
                                      ),
                                  itemBuilder: (context, index) {
                                    final p = filteredPatients[index];
                                    return EnhancedPatientCard(
                                      data: p,
                                      isCompact: constraints.maxWidth < 700,
                                      onTap: () => _showPatientDialog(p), // Add this line
                                    );
                                  },
                                );
                              },
                            ),

                          if (filteredPatients.isNotEmpty)
                            const SizedBox(height: 24),

                          if (filteredPatients.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "Tampilkan ",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xFFE2E8F0),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<int>(
                                            value: 10,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFF1E293B),
                                            ),
                                            items:
                                                [5, 10, 20, 50]
                                                    .map(
                                                      (e) => DropdownMenuItem(
                                                        value: e,
                                                        child: Text(
                                                          e.toString(),
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                            onChanged: (value) {},
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        " data",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.chevron_left,
                                          color: Color(0xFF64748B),
                                        ),
                                        iconSize: 20,
                                        style: IconButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFFF8FAFC,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "Hal. 1 dari 3",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.chevron_right,
                                          color: Color(0xFF64748B),
                                        ),
                                        iconSize: 20,
                                        style: IconButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFFF8FAFC,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
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
                  );
                },
              ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    final isSelected = selectedFilter == label;
    return InkWell(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E40AF) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF1E40AF) : const Color(0xFFE2E8F0),
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: const Color(0xFF1E40AF).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilterChip(String label, VoidCallback onDelete) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFBBF24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFFB45309),
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: onDelete,
            child: const Icon(Icons.close, size: 14, color: Color(0xFFB45309)),
          ),
        ],
      ),
    );
  }
}

class EnhancedPatientCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isCompact;
  final VoidCallback? onTap; // Add this parameter

  const EnhancedPatientCard({
    super.key,
    required this.data,
    this.isCompact = false,
    this.onTap, // Add this parameter
  });

  @override
   Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFE3F2FD),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.grey),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data["name"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${data["nik"]}",
                          style: const TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                        Text(
                          "RM: ${data["reg"]}",
                          style: const TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                        Text(
                          "${data["dob"]} / ${data["age"]}",
                          style: const TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "UMUM",
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${data["queue"]}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // STATUS OPERASI
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              color: Colors.orange.shade200,
              alignment: Alignment.center,
              child: Text(
                data["operation"],
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ),

            // MENU ICONS
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildMiniMenu("CPPT", Icons.description, Colors.red),
                  _buildMiniMenu("Diagnosa", Icons.medical_information, Colors.purple),
                  _buildMiniMenu("Lab", Icons.biotech, Colors.blue),
                  _buildMiniMenu("Radiologi", Icons.waves, Colors.indigo),
                  _buildMiniMenu("Obat", Icons.medication, Colors.green),
                ],
              ),
            ),

            // DOCTOR INFO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Text(
                data["doctor"],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

//   Widget _buildActionButton(String label, IconData icon, Color color) {
//     return InkWell(
//       onTap: () {},
//       borderRadius: BorderRadius.circular(8),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 6),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: color.withOpacity(0.3)),
//         ),
//         child: Column(
//           children: [
//             Icon(icon, size: 16, color: color),
//             const SizedBox(height: 2),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 9,
//                 fontWeight: FontWeight.w500,
//                 color: color,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
 Widget _buildMiniMenu(String text, IconData icon, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}