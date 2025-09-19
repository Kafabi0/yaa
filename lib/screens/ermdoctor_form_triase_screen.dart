import 'package:flutter/material.dart';

class ErmDoctorFormTriaseScreen extends StatefulWidget {
  const ErmDoctorFormTriaseScreen({super.key});

  @override
  State<ErmDoctorFormTriaseScreen> createState() => _ErmDoctorFormTriaseScreenState();
}

class _ErmDoctorFormTriaseScreenState extends State<ErmDoctorFormTriaseScreen> {
  // Form controllers - Informasi Pasien
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController tanggalMasukController = TextEditingController();
  final TextEditingController jamMasukController = TextEditingController();
  final TextEditingController dokterController = TextEditingController();
  final TextEditingController dikirimOlehController = TextEditingController();
  
  // Dropdown controllers
  String selectedJenisKelamin = "-- Pilih --";
  String selectedKondisiPasien = "-- Pilih --";
  
  // Pain scale
  int painLevel = 0;
  
  // Kategori Triase
  String selectedTriase = "";
  
  // Level Kesadaran
  final TextEditingController levelEController = TextEditingController();
  final TextEditingController levelVController = TextEditingController();
  final TextEditingController levelMController = TextEditingController();
  
  // Form controllers tambahan
  final TextEditingController anamnesisController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();
  String selectedJenisKasus = "-- Pilih --";
  String selectedJenisLayanan = "-- Pilih --";

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    nameController.dispose();
    nikController.dispose();
    alamatController.dispose();
    tanggalMasukController.dispose();
    jamMasukController.dispose();
    dokterController.dispose();
    dikirimOlehController.dispose();
    levelEController.dispose();
    levelVController.dispose();
    levelMController.dispose();
    anamnesisController.dispose();
    diagnosisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Form Triase',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Color(0xFF1E40AF),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Informasi Pasien Section
            _buildSection("Informasi Pasien", _buildPatientInfoContent()),
            
            // Triase Section
            _buildSection("Triase", _buildTriaseContent()),
            
            // Bottom form sections
            _buildBottomSections(),
            
            // Action Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildActionButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      children: [
        // Section header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Color(0xFF1E40AF),
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Section content
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: content,
        ),
      ],
    );
  }

  Widget _buildPatientInfoContent() {
    return Column(
      children: [
        // Patient photo at the top center
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD1D5DB)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person, size: 40, color: Color(0xFF6B7280)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    // Handle capture photo
                    _showCaptureOptions(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "Capture",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Form fields in rows
        Row(
          children: [
            Expanded(
              child: _buildInfoField("Jenis Kelamin*", isDropdown: true, 
                dropdownValue: selectedJenisKelamin,
                dropdownItems: ["-- Pilih --", "Laki-laki", "Perempuan"],
                onDropdownChanged: (value) {
                  setState(() {
                    selectedJenisKelamin = value!;
                  });
                }
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoField("Nama Alias*", controller: nameController),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoField("Nik Alias", controller: nikController),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInfoField("Alamat Alias", controller: alamatController),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoField("Tanggal Masuk*", 
                controller: tanggalMasukController,
                isDateField: true
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoField("Jam Masuk*", 
                controller: jamMasukController,
                isTimeField: true
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInfoField("Kondisi Pasien Datang*", isDropdown: true,
                dropdownValue: selectedKondisiPasien,
                dropdownItems: ["-- Pilih --", "Sadar", "Tidak Sadar", "Gelisah"],
                onDropdownChanged: (value) {
                  setState(() {
                    selectedKondisiPasien = value!;
                  });
                }
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoField("Diantar Oleh*", controller: dokterController),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoField("Dikirim Oleh*", controller: dikirimOlehController),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTriaseContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Skala Nyeri *",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 16),
        
        // Pain scale faces - 3 rows dalam bentuk segitiga terbalik
        Column(
          children: [
            // First row (0-4) - 5 items
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return _buildPainScaleItem(index);
              }),
            ),
            const SizedBox(height: 12),
            // Second row (5-8) - 4 items
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return _buildPainScaleItem(index + 5);
              }),
            ),
            const SizedBox(height: 12),
            // Third row (9-10) - 2 items, centered closer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPainScaleItem(9),
                const SizedBox(width: 20), // Jarak lebih dekat antara 9 dan 10
                _buildPainScaleItem(10),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPainScaleItem(int level) {
    bool isSelected = painLevel == level;
    Color faceColor;
    Color backgroundColor;

    // Tentukan warna emoji dan background berdasarkan level
    if (level <= 3) {
      faceColor = const Color(0xFF10B981); // Hijau
      backgroundColor = isSelected ? const Color(0xFF10B981) : Colors.white;
    } else if (level <= 6) {
      faceColor = const Color(0xFFEAB308); // Kuning
      backgroundColor = isSelected ? const Color(0xFFEAB308) : Colors.white;
    } else if (level <= 8) {
      faceColor = const Color(0xFFF97316); // Oranye
      backgroundColor = isSelected ? const Color(0xFFF97316) : Colors.white;
    } else {
      faceColor = const Color(0xFFEF4444); // Merah
      backgroundColor = isSelected ? const Color(0xFFEF4444) : Colors.white;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          painLevel = level;
        });
      },
      child: Container(
        width: 60,
        height: 60,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color.fromARGB(255, 253, 254, 255) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.05),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getPainIcon(level),
              color: isSelected ? Colors.white : faceColor, // Icon putih saat selected
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              level.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : const Color(0xFF374151), // Text putih saat selected
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPainIcon(int level) {
    if (level <= 3) return Icons.sentiment_very_satisfied;
    if (level <= 6) return Icons.sentiment_neutral;
    if (level <= 8) return Icons.sentiment_dissatisfied;
    return Icons.sentiment_very_dissatisfied;
  }


  Widget _buildBottomSections() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Kategori Triase dan Level Kesadaran
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Kategori Triase
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Kategori Triase*",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTriaseTable(),
                  ],
                ),
              ),
              
              const SizedBox(width: 24),
              
              // Level Kesadaran
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Level Kesadaran*",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildLevelKesadaran(),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // ANAMNESIS dan Diagnosa
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildInfoField("ANAMNESIS/Keluhan Utama*", 
                  controller: anamnesisController, 
                  maxLines: 4
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoField("Diagnosa*", 
                  controller: diagnosisController, 
                  maxLines: 4
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Jenis Kasus dan Jenis Layanan
          Row(
            children: [
              Expanded(
                child: _buildInfoField("Jenis Kasus*", isDropdown: true,
                  dropdownValue: selectedJenisKasus,
                  dropdownItems: ["-- Pilih --", "Emergensi", "Urgensi", "Non-Urgensi"],
                  onDropdownChanged: (value) {
                    setState(() {
                      selectedJenisKasus = value!;
                    });
                  }
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoField("Jenis Layanan*", isDropdown: true,
                  dropdownValue: selectedJenisLayanan,
                  dropdownItems: ["-- Pilih --", "Rawat Jalan", "Rawat Inap", "ICU"],
                  onDropdownChanged: (value) {
                    setState(() {
                      selectedJenisLayanan = value!;
                    });
                  }
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTriaseTable() {
    List<Map<String, dynamic>> triaseData = [
      {"code": "ATS 1", "desc": "Resusitasi", "time": "Segera", "color": const Color(0xFFDC2626)},
      {"code": "ATS 2", "desc": "Emergency / Gawat Darurat", "time": "10 Menit", "color": const Color(0xFFF97316)},
      {"code": "ATS 3", "desc": "Urgent / Darurat", "time": "30 Menit", "color": const Color(0xFFEAB308)},
      {"code": "ATS 4", "desc": "Semi Darurat", "time": "60 Menit", "color": const Color(0xFF10B981)},
      {"code": "ATS 5", "desc": "Tidak Darurat", "time": "120 Menit", "color": const Color(0xFF3B82F6)},
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
            child: const Row(
              children: [
                SizedBox(width: 40),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Skala Triase",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Keterangan",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Respon Time",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Data rows
          ...triaseData.map((data) {
            return Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB), width: 0.5)),
              ),
              child: Row(
                children: [
                  // Radio button
                  SizedBox(
                    width: 40,
                    height: 36,
                    child: Radio<String>(
                      value: data["code"]!,
                      groupValue: selectedTriase,
                      onChanged: (value) {
                        setState(() {
                          selectedTriase = value!;
                        });
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        data["code"]!,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        data["desc"]!,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        data["time"]!,
                        style: const TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildLevelKesadaran() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextField(
            controller: levelEController,
            decoration: const InputDecoration(
              labelText: "E",
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
              labelStyle: TextStyle(fontSize: 12),
            ),
            style: const TextStyle(fontSize: 12),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextField(
            controller: levelVController,
            decoration: const InputDecoration(
              labelText: "V",
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
              labelStyle: TextStyle(fontSize: 12),
            ),
            style: const TextStyle(fontSize: 12),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextField(
            controller: levelMController,
            decoration: const InputDecoration(
              labelText: "M",
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
              labelStyle: TextStyle(fontSize: 12),
            ),
            style: const TextStyle(fontSize: 12),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoField(String label, {
    TextEditingController? controller,
    bool isDropdown = false,
    String? dropdownValue,
    List<String>? dropdownItems,
    Function(String?)? onDropdownChanged,
    int maxLines = 1,
    bool isDateField = false,
    bool isTimeField = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 4),
        if (isDropdown)
          DropdownButtonFormField<String>(
            value: dropdownValue,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
              ),
            ),
            style: const TextStyle(fontSize: 12, color: Color(0xFF374151)),
            items: dropdownItems!.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 12)),
              );
            }).toList(),
            onChanged: onDropdownChanged,
          )
        else
          TextField(
            controller: controller,
            maxLines: maxLines,
            readOnly: isDateField || isTimeField,
            onTap: () async {
              if (isDateField) {
                await _selectDate(context, controller!);
              } else if (isTimeField) {
                await _selectTime(context, controller!);
              }
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
              ),
              suffixIcon: isDateField 
                ? const Icon(Icons.calendar_today, size: 16, color: Color(0xFF6B7280))
                : isTimeField 
                  ? const Icon(Icons.access_time, size: 16, color: Color(0xFF6B7280))
                  : null,
            ),
            style: const TextStyle(fontSize: 12),
          ),
      ],
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_validateForm()) {
            _showConfirmationDialog();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF1E40AF),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
        child: const Text(
          "Simpan",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  bool _validateForm() {
    List<String> errors = [];
    
    if (selectedJenisKelamin == "-- Pilih --") errors.add("Jenis kelamin harus dipilih");
    if (nameController.text.isEmpty) errors.add("Nama alias harus diisi");
    if (tanggalMasukController.text.isEmpty) errors.add("Tanggal masuk harus diisi");
    if (jamMasukController.text.isEmpty) errors.add("Jam masuk harus diisi");
    if (selectedKondisiPasien == "-- Pilih --") errors.add("Kondisi pasien harus dipilih");
    if (dokterController.text.isEmpty) errors.add("Diantar oleh harus diisi");
    if (dikirimOlehController.text.isEmpty) errors.add("Dikirim oleh harus diisi");
    if (selectedTriase.isEmpty) errors.add("Kategori triase harus dipilih");
    if (levelEController.text.isEmpty) errors.add("Level kesadaran E harus diisi");
    if (levelVController.text.isEmpty) errors.add("Level kesadaran V harus diisi");
    if (levelMController.text.isEmpty) errors.add("Level kesadaran M harus diisi");
    if (anamnesisController.text.isEmpty) errors.add("Anamnesis harus diisi");
    if (diagnosisController.text.isEmpty) errors.add("Diagnosa harus diisi");
    if (selectedJenisKasus == "-- Pilih --") errors.add("Jenis kasus harus dipilih");
    if (selectedJenisLayanan == "-- Pilih --") errors.add("Jenis layanan harus dipilih");
    
    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errors.first),
          backgroundColor: const Color(0xFFDC2626),
          duration: const Duration(seconds: 3),
        ),
      );
      return false;
    }
    
    return true;
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Konfirmasi Simpan",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: const Text("Apakah Anda yakin ingin menyimpan form triase ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Batal",
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _saveForm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
              ),
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  void _saveForm() {
    // Simulate saving form data
    Map<String, dynamic> formData = {
      'jenisKelamin': selectedJenisKelamin,
      'namaAlias': nameController.text,
      'nikAlias': nikController.text,
      'alamatAlias': alamatController.text,
      'tanggalMasuk': tanggalMasukController.text,
      'jamMasuk': jamMasukController.text,
      'kondisiPasien': selectedKondisiPasien,
      'diantarOleh': dokterController.text,
      'dikirimOleh': dikirimOlehController.text,
      'skalaNyeri': painLevel,
      'kategoriTriase': selectedTriase,
      'levelKesadaranE': levelEController.text,
      'levelKesadaranV': levelVController.text,
      'levelKesadaranM': levelMController.text,
      'anamnesis': anamnesisController.text,
      'diagnosa': diagnosisController.text,
      'jenisKasus': selectedJenisKasus,
      'jenisLayanan': selectedJenisLayanan,
    };

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Form triase berhasil disimpan"),
        backgroundColor: Color(0xFF059669),
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate back with result
    Navigator.pop(context, formData);
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4F46E5),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
    }
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4F46E5),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
    }
  }

  void _showCaptureOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Ambil Foto Pasien",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCaptureOption(
                    icon: Icons.camera_alt,
                    label: "Kamera",
                    onTap: () {
                      Navigator.pop(context);
                      _captureFromCamera();
                    },
                  ),
                  _buildCaptureOption(
                    icon: Icons.photo_library,
                    label: "Galeri",
                    onTap: () {
                      Navigator.pop(context);
                      _captureFromGallery();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCaptureOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: const Color(0xFF4F46E5),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _captureFromCamera() {
    // Implement camera capture functionality
    // You'll need to add image_picker package to pubspec.yaml
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Fitur kamera akan diimplementasikan"),
        backgroundColor: Color(0xFF3B82F6),
      ),
    );
  }

  void _captureFromGallery() {
    // Implement gallery selection functionality
    // You'll need to add image_picker package to pubspec.yaml
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Fitur galeri akan diimplementasikan"),
        backgroundColor: Color(0xFF3B82F6),
      ),
    );
  }

  String _getTriaseDescription(String code) {
    switch (code) {
      case "ATS 1":
        return "Pasien dalam kondisi kritis yang membutuhkan resusitasi segera";
      case "ATS 2":
        return "Pasien dalam kondisi gawat darurat yang membutuhkan penanganan dalam 10 menit";
      case "ATS 3":
        return "Pasien dalam kondisi darurat yang membutuhkan penanganan dalam 30 menit";
      case "ATS 4":
        return "Pasien dalam kondisi semi darurat yang dapat menunggu hingga 60 menit";
      case "ATS 5":
        return "Pasien dalam kondisi tidak darurat yang dapat menunggu hingga 120 menit";
      default:
        return "";
    }
  }

  void _resetForm() {
    setState(() {
      nameController.clear();
      nikController.clear();
      alamatController.clear();
      tanggalMasukController.clear();
      jamMasukController.clear();
      dokterController.clear();
      dikirimOlehController.clear();
      selectedJenisKelamin = "-- Pilih --";
      selectedKondisiPasien = "-- Pilih --";
      painLevel = 0;
      selectedTriase = "";
      levelEController.clear();
      levelVController.clear();
      levelMController.clear();
      anamnesisController.clear();
      diagnosisController.clear();
      selectedJenisKasus = "-- Pilih --";
      selectedJenisLayanan = "-- Pilih --";
    });
  }
}