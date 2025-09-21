import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrasiMCUPage extends StatefulWidget {
  const RegistrasiMCUPage({Key? key}) : super(key: key);

  @override
  State<RegistrasiMCUPage> createState() => _RegistrasiMCUPageState();
}

class _RegistrasiMCUPageState extends State<RegistrasiMCUPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _nohpController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pekerjaanController = TextEditingController();
  final TextEditingController _namaPerusahaanController = TextEditingController();
  final TextEditingController _alamatPerusahaanController = TextEditingController();
  final TextEditingController _riwayatPenyakitController = TextEditingController();
  final TextEditingController _obatDikonsumsiController = TextEditingController();
  final TextEditingController _keluhanController = TextEditingController();
  final TextEditingController _kontakDaruratController = TextEditingController();
  final TextEditingController _nohpKontakDaruratController = TextEditingController();

  String? _selectedGender;
  String? _selectedAgama;
  String? _selectedStatusPerkawinan;
  String? _selectedGolonganDarah;
  String? _selectedPaketMCU;
  String? _selectedTujuanMCU;
  String? _selectedWaktuPemeriksaan;
  String? _selectedJenisPembayaran;
  bool _isPuasa = false;
  bool _riwayatOperasi = false;
  bool _riwayatAlergi = false;
  bool _merokok = false;
  bool _alkohol = false;
  String? _jenisAlergi;
  String? _jenisOperasi;

  final List<String> _genderOptions = ['Laki-laki', 'Perempuan'];
  final List<String> _agamaOptions = ['Islam', 'Kristen', 'Katolik', 'Hindu', 'Buddha', 'Konghucu'];
  final List<String> _statusPerkawinanOptions = ['Belum Menikah', 'Menikah', 'Cerai Hidup', 'Cerai Mati'];
  final List<String> _golonganDarahOptions = ['A', 'B', 'AB', 'O'];
  
  final Map<String, Map<String, dynamic>> _paketMCUOptions = {
    'MCU Basic': {
      'harga': 'Rp 500.000',
      'pemeriksaan': [
        'Pemeriksaan Fisik',
        'Tes Darah Rutin',
        'Tes Urine',
        'EKG',
        'Rontgen Dada',
      ],
      'color': Colors.green,
    },
    'MCU Lengkap': {
      'harga': 'Rp 1.200.000',
      'pemeriksaan': [
        'Semua pemeriksaan Basic',
        'Tes Fungsi Hati',
        'Tes Fungsi Ginjal',
        'Tes Kolesterol',
        'Tes Gula Darah',
        'USG Abdomen',
        'Konsultasi Dokter Spesialis',
      ],
      'color': Colors.blue,
    },
    'MCU Premium': {
      'harga': 'Rp 2.500.000',
      'pemeriksaan': [
        'Semua pemeriksaan Lengkap',
        'CT Scan',
        'Tes Jantung Lengkap',
        'Tes Tumor Marker',
        'Tes Hormon',
        'Endoskopi',
        'Konsultasi Multi Spesialis',
        'Hasil dalam 1 hari',
      ],
      'color': Colors.orange,
    },
    'MCU Executive': {
      'harga': 'Rp 5.000.000',
      'pemeriksaan': [
        'Semua pemeriksaan Premium',
        'MRI',
        'PET Scan',
        'Genetic Testing',
        'Konsultasi Personal Doctor',
        'Health Coaching',
        'VIP Treatment',
        'Home Service Available',
      ],
      'color': Colors.purple,
    },
  };

  final List<String> _tujuanMCUOptions = [
    'Pemeriksaan Rutin Pribadi',
    'Persyaratan Kerja',
    'Persyaratan Visa/Travel',
    'Persyaratan Asuransi',
    'Pre-Employment',
    'Annual Check-up',
    'Follow-up Penyakit',
    'Lainnya'
  ];

  final List<String> _waktuPemeriksaanOptions = [
    'Pagi (07:00 - 10:00)',
    'Siang (10:00 - 13:00)',
    'Sore (13:00 - 16:00)',
  ];

  final List<String> _jenisPembayaranOptions = [
    'Tunai',
    'Transfer Bank',
    'Kartu Kredit',
    'Debit Card',
    'Asuransi Kesehatan',
    'Perusahaan',
    'BPJS (jika tersedia)',
  ];

  bool _isLoading = false;

  Future<void> _simpanData() async {
    final prefs = await SharedPreferences.getInstance();
    String nomor = "MCU${DateTime.now().millisecondsSinceEpoch % 10000}";
    
    await prefs.setString('mcuName', _namaController.text.trim());
    await prefs.setString('mcuNIK', _nikController.text.trim());
    await prefs.setString('mcuTempatLahir', _tempatLahirController.text.trim());
    await prefs.setString('mcuTanggalLahir', _tanggalLahirController.text.trim());
    await prefs.setString('mcuGender', _selectedGender ?? '');
    await prefs.setString('mcuAgama', _selectedAgama ?? '');
    await prefs.setString('mcuStatus', _selectedStatusPerkawinan ?? '');
    await prefs.setString('mcuGolDarah', _selectedGolonganDarah ?? '');
    await prefs.setString('mcuAlamat', _alamatController.text.trim());
    await prefs.setString('mcuNoHP', _nohpController.text.trim());
    await prefs.setString('mcuEmail', _emailController.text.trim());
    await prefs.setString('mcuPekerjaan', _pekerjaanController.text.trim());
    await prefs.setString('mcuNamaPerusahaan', _namaPerusahaanController.text.trim());
    await prefs.setString('mcuAlamatPerusahaan', _alamatPerusahaanController.text.trim());
    await prefs.setString('mcuPaket', _selectedPaketMCU ?? '');
    await prefs.setString('mcuTujuan', _selectedTujuanMCU ?? '');
    await prefs.setString('mcuWaktu', _selectedWaktuPemeriksaan ?? '');
    await prefs.setString('mcuPembayaran', _selectedJenisPembayaran ?? '');
    await prefs.setString('mcuRiwayatPenyakit', _riwayatPenyakitController.text.trim());
    await prefs.setString('mcuObatDikonsumsi', _obatDikonsumsiController.text.trim());
    await prefs.setString('mcuKeluhan', _keluhanController.text.trim());
    await prefs.setBool('mcuPuasa', _isPuasa);
    await prefs.setBool('mcuRiwayatOperasi', _riwayatOperasi);
    await prefs.setBool('mcuRiwayatAlergi', _riwayatAlergi);
    await prefs.setBool('mcuMerokok', _merokok);
    await prefs.setBool('mcuAlkohol', _alkohol);
    await prefs.setString('mcuJenisAlergi', _jenisAlergi ?? '');
    await prefs.setString('mcuJenisOperasi', _jenisOperasi ?? '');
    await prefs.setString('mcuKontakDarurat', _kontakDaruratController.text.trim());
    await prefs.setString('mcuNoHPKontakDarurat', _nohpKontakDaruratController.text.trim());
    await prefs.setString('nomorAntrian_MCU', nomor);
    await prefs.setString('mcuWaktuRegistrasi', DateTime.now().toIso8601String());
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _simpanData();
      
      if (mounted) {
        String paketInfo = _selectedPaketMCU != null 
            ? "${_selectedPaketMCU} - ${_paketMCUOptions[_selectedPaketMCU!]!['harga']}" 
            : "";
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.health_and_safety, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text("Registrasi MCU berhasil!\nNomor: MCU${DateTime.now().millisecondsSinceEpoch % 10000}\nPaket: $paketInfo"),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFFF6B35),
            duration: const Duration(seconds: 4),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Terjadi kesalahan saat menyimpan data"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    String? Function(String?)? validator,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Color(0xFFFF6B35)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          validator: validator ?? (isRequired ? (value) {
            if (value == null || value.trim().isEmpty) {
              return "$label harus diisi";
            }
            return null;
          } : null),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Color(0xFFFF6B35)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          validator: validator ?? (isRequired ? (value) {
            if (value == null || value.isEmpty) {
              return "$label harus dipilih";
            }
            return null;
          } : null),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPaketMCUCard(String paketName, Map<String, dynamic> paketData) {
    final bool isSelected = _selectedPaketMCU == paketName;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedPaketMCU = paketName),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? paketData['color'] : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? paketData['color'].withOpacity(0.05) : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Radio<String>(
                  value: paketName,
                  groupValue: _selectedPaketMCU,
                  onChanged: (value) => setState(() => _selectedPaketMCU = value),
                  activeColor: paketData['color'],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        paketName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: paketData['color'],
                        ),
                      ),
                      Text(
                        paketData['harga'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Pemeriksaan yang termasuk:",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            ...paketData['pemeriksaan'].map<Widget>((item) => Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• ", style: TextStyle(fontSize: 12)),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {Color? color}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: (color ?? const Color(0xFFFF6B35)),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: (color ?? const Color(0xFFFF6B35))!),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color ?? const Color(0xFFFF6B35),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Registrasi Medical Check-Up",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFFFF6B35),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange[800],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.health_and_safety, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text("MCU", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange[700]),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Untuk pemeriksaan lab, pastikan puasa minimal 10-12 jam sebelum datang",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Data Pribadi
              _buildSectionTitle("📋 Data Pribadi"),
              _buildTextField(
                controller: _namaController,
                label: "Nama Lengkap",
                hint: "Masukkan nama sesuai KTP",
              ),
              _buildTextField(
                controller: _nikController,
                label: "NIK (Nomor Induk Kependudukan)",
                hint: "16 digit NIK",
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "NIK harus diisi";
                  }
                  if (value.length != 16) {
                    return "NIK harus 16 digit";
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _tempatLahirController,
                      label: "Tempat Lahir",
                      hint: "Kota kelahiran",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _tanggalLahirController,
                      label: "Tanggal Lahir",
                      hint: "DD/MM/YYYY",
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      label: "Jenis Kelamin",
                      hint: "Pilih jenis kelamin",
                      value: _selectedGender,
                      items: _genderOptions,
                      onChanged: (value) => setState(() => _selectedGender = value),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDropdownField(
                      label: "Golongan Darah",
                      hint: "Pilih golongan darah",
                      value: _selectedGolonganDarah,
                      items: _golonganDarahOptions,
                      onChanged: (value) => setState(() => _selectedGolonganDarah = value),
                      isRequired: false,
                    ),
                  ),
                ],
              ),
              _buildDropdownField(
                label: "Agama",
                hint: "Pilih agama",
                value: _selectedAgama,
                items: _agamaOptions,
                onChanged: (value) => setState(() => _selectedAgama = value),
              ),
              _buildDropdownField(
                label: "Status Perkawinan",
                hint: "Pilih status perkawinan",
                value: _selectedStatusPerkawinan,
                items: _statusPerkawinanOptions,
                onChanged: (value) => setState(() => _selectedStatusPerkawinan = value),
              ),

              // Data Kontak
              _buildSectionTitle("📞 Data Kontak"),
              _buildTextField(
                controller: _alamatController,
                label: "Alamat Lengkap",
                hint: "Jalan, RT/RW, Kelurahan, Kecamatan, Kota",
                maxLines: 3,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _nohpController,
                      label: "Nomor HP",
                      hint: "08xxxxxxxxxx",
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _emailController,
                      label: "Email",
                      hint: "nama@email.com",
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Email harus diisi";
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return "Format email tidak valid";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              // Data Pekerjaan
              _buildSectionTitle("💼 Data Pekerjaan"),
              _buildTextField(
                controller: _pekerjaanController,
                label: "Pekerjaan",
                hint: "Jabatan/Profesi saat ini",
              ),
              _buildTextField(
                controller: _namaPerusahaanController,
                label: "Nama Perusahaan",
                hint: "Tempat bekerja",
                isRequired: false,
              ),
              _buildTextField(
                controller: _alamatPerusahaanController,
                label: "Alamat Perusahaan",
                hint: "Alamat kantor/tempat kerja",
                maxLines: 2,
                isRequired: false,
              ),

              // Paket MCU
              _buildSectionTitle("🏥 Pilih Paket Medical Check-Up"),
              Column(
                children: _paketMCUOptions.entries.map((entry) {
                  return _buildPaketMCUCard(entry.key, entry.value);
                }).toList(),
              ),
              if (_selectedPaketMCU == null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: const Text(
                    "Silakan pilih paket MCU yang diinginkan",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 16),

              // Detail MCU
              _buildSectionTitle("📅 Detail Kunjungan MCU"),
              _buildDropdownField(
                label: "Tujuan MCU",
                hint: "Pilih tujuan pemeriksaan",
                value: _selectedTujuanMCU,
                items: _tujuanMCUOptions,
                onChanged: (value) => setState(() => _selectedTujuanMCU = value),
              ),
              _buildDropdownField(
                label: "Waktu Pemeriksaan",
                hint: "Pilih waktu yang diinginkan",
                value: _selectedWaktuPemeriksaan,
                items: _waktuPemeriksaanOptions,
                onChanged: (value) => setState(() => _selectedWaktuPemeriksaan = value),
              ),
              _buildDropdownField(
                label: "Jenis Pembayaran",
                hint: "Pilih metode pembayaran",
                value: _selectedJenisPembayaran,
                items: _jenisPembayaranOptions,
                onChanged: (value) => setState(() => _selectedJenisPembayaran = value),
              ),

              // Riwayat Kesehatan
              _buildSectionTitle("🩺 Riwayat Kesehatan"),
              _buildTextField(
                controller: _riwayatPenyakitController,
                label: "Riwayat Penyakit",
                hint: "Diabetes, Hipertensi, Jantung, dll",
                maxLines: 2,
                isRequired: false,
              ),
              _buildTextField(
                controller: _obatDikonsumsiController,
                label: "Obat yang Sedang Dikonsumsi",
                hint: "Nama obat dan dosis",
                maxLines: 2,
                isRequired: false,
              ),
              _buildTextField(
                controller: _keluhanController,
                label: "Keluhan Saat Ini",
                hint: "Jika ada keluhan kesehatan tertentu",
                maxLines: 2,
                isRequired: false,
              ),

              // Gaya Hidup
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Gaya Hidup & Kebiasaan",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      value: _isPuasa,
                      onChanged: (value) => setState(() => _isPuasa = value ?? false),
                      title: const Text("Saya akan datang dalam kondisi puasa", style: TextStyle(fontSize: 13)),
                      activeColor: const Color(0xFFFF6B35),
                      contentPadding: EdgeInsets.zero,
                    ),
                    CheckboxListTile(
                      value: _merokok,
                      onChanged: (value) => setState(() => _merokok = value ?? false),
                      title: const Text("Merokok", style: TextStyle(fontSize: 13)),
                      activeColor: const Color(0xFFFF6B35),
                      contentPadding: EdgeInsets.zero,
                    ),
                    CheckboxListTile(
                      value: _alkohol,
                      onChanged: (value) => setState(() => _alkohol = value ?? false),
                      title: const Text("Konsumsi alkohol", style: TextStyle(fontSize: 13)),
                      activeColor: const Color(0xFFFF6B35),
                      contentPadding: EdgeInsets.zero,
                    ),
                    CheckboxListTile(
                      value: _riwayatOperasi,
                      onChanged: (value) => setState(() {
                        _riwayatOperasi = value ?? false;
                        if (!_riwayatOperasi) _jenisOperasi = null;
                      }),
                      title: const Text("Pernah menjalani operasi", style: TextStyle(fontSize: 13)),
                      activeColor: const Color(0xFFFF6B35),
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (_riwayatOperasi) ...[
                      const SizedBox(height: 8),
                      TextFormField(
                        onChanged: (value) => _jenisOperasi = value,
                        decoration: InputDecoration(
                          hintText: "Jenis operasi yang pernah dijalani",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                    CheckboxListTile(
                      value: _riwayatAlergi,
                      onChanged: (value) => setState(() {
                        _riwayatAlergi = value ?? false;
                        if (!_riwayatAlergi) _jenisAlergi = null;
                      }),
                      title: const Text("Memiliki riwayat alergi", style: TextStyle(fontSize: 13)),
                      activeColor: const Color(0xFFFF6B35),
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (_riwayatAlergi) ...[
                      const SizedBox(height: 8),
                      TextFormField(
                        onChanged: (value) => _jenisAlergi = value,
                        decoration: InputDecoration(
                          hintText: "Jenis alergi (makanan, obat, dll)",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Kontak Darurat
              _buildSectionTitle("🆘 Kontak Darurat"),
              _buildTextField(
                controller: _kontakDaruratController,
                label: "Nama Kontak Darurat",
                hint: "Nama keluarga yang dapat dihubungi",
              ),
              _buildTextField(
                controller: _nohpKontakDaruratController,
                label: "Nomor HP Kontak Darurat",
                hint: "08xxxxxxxxxx",
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 24),
              
              // Submit Button
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [const Color(0xFFFF6B35), Colors.orange[700]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B35).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () {
                    if (_selectedPaketMCU == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Silakan pilih paket MCU terlebih dahulu"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    _submit();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Memproses...",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.health_and_safety, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              "DAFTAR MCU SEKARANG",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Info Panel
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange[700]),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "PERSIAPAN SEBELUM MCU:",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("• ", style: TextStyle(fontSize: 11)),
                            Expanded(
                              child: Text(
                                "Puasa 10-12 jam sebelum pemeriksaan (untuk tes lab)",
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("• ", style: TextStyle(fontSize: 11)),
                            Expanded(
                              child: Text(
                                "Bawa dokumen identitas (KTP/SIM/Paspor)",
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("• ", style: TextStyle(fontSize: 11)),
                            Expanded(
                              child: Text(
                                "Gunakan pakaian yang mudah dilepas untuk pemeriksaan",
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("• ", style: TextStyle(fontSize: 11)),
                            Expanded(
                              child: Text(
                                "Istirahat cukup malam sebelumnya",
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("• ", style: TextStyle(fontSize: 11)),
                            Expanded(
                              child: Text(
                                "Hindari aktivitas berat 24 jam sebelum pemeriksaan",
                                style: TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Contact Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[50]!, Colors.blue[100]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.blue[700]),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "INFORMASI LEBIH LANJUT:",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(Icons.call, size: 16, color: Colors.blue),
                        SizedBox(width: 8),
                        Text("Telepon: (021) 555-0123", style: TextStyle(fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Icon(Icons.message, size: 16, color: Colors.blue),
                        SizedBox(width: 8),
                        Text("WhatsApp: +62 812-3456-7890", style: TextStyle(fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Icon(Icons.email, size: 16, color: Colors.blue),
                        SizedBox(width: 8),
                        Text("Email: mcu@rumahsakit.com", style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _alamatController.dispose();
    _nohpController.dispose();
    _emailController.dispose();
    _pekerjaanController.dispose();
    _namaPerusahaanController.dispose();
    _alamatPerusahaanController.dispose();
    _riwayatPenyakitController.dispose();
    _obatDikonsumsiController.dispose();
    _keluhanController.dispose();
    _kontakDaruratController.dispose();
    _nohpKontakDaruratController.dispose();
    super.dispose();
  }
}