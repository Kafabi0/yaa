import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'jadwaloperasi.dart';

class RegistrasiIGDPage extends StatefulWidget {
  const RegistrasiIGDPage({Key? key}) : super(key: key);

  @override
  State<RegistrasiIGDPage> createState() => _RegistrasiIGDPageState();
}

class _RegistrasiIGDPageState extends State<RegistrasiIGDPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _umurController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _nohpController = TextEditingController();
  final TextEditingController _keluhanController = TextEditingController();
  final TextEditingController _riwayatPenyakitController =
      TextEditingController();
  final TextEditingController _obatDikonsumsiController =
      TextEditingController();
  final TextEditingController _namaKeluargaController = TextEditingController();
  final TextEditingController _nohpKeluargaController = TextEditingController();
  final TextEditingController _hubunganKeluargaController =
      TextEditingController();

  String? _selectedGender;
  String? _selectedTriase;
  String? _selectedCaraDatang;
  String? _selectedJenisAsuransi;
  String? _selectedKesadaran;
  bool _riwayatAlergi = false;
  String? _jenisAlergi;

  final List<String> _genderOptions = ['Laki-laki', 'Perempuan'];
  final List<String> _triaseOptions = [
    'Merah (Emergensi) - Butuh penanganan segera',
    'Kuning (Urgensi) - Dapat ditunda 30 menit',
    'Hijau (Semi Urgensi) - Dapat ditunda 2 jam',
    'Biru (Non Urgensi) - Tidak darurat',
  ];
  final List<String> _caraDatangOptions = [
    'Jalan Kaki',
    'Kendaraan Pribadi',
    'Ambulans',
    'Diantar Keluarga',
    'Dirujuk dari Puskesmas',
    'Dirujuk dari RS Lain',
  ];
  final List<String> _jenisAsuransiOptions = [
    'BPJS Kesehatan',
    'Asuransi Swasta',
    'Umum/Tunai',
    'Jamkesmas',
    'Perusahaan',
  ];
  final List<String> _kesadaranOptions = [
    'Sadar Penuh',
    'Mengantuk',
    'Bingung',
    'Tidak Sadar',
  ];

  bool _isLoading = false;

  Future<void> _simpanData() async {
    final prefs = await SharedPreferences.getInstance();
    String nomor = "IGD${DateTime.now().millisecondsSinceEpoch % 10000}";

    await prefs.setString('igdName', _namaController.text.trim());
    await prefs.setString('igdNIK', _nikController.text.trim());
    await prefs.setString('igdUmur', _umurController.text.trim());
    await prefs.setString('igdGender', _selectedGender ?? '');
    await prefs.setString('igdAlamat', _alamatController.text.trim());
    await prefs.setString('igdNoHP', _nohpController.text.trim());
    await prefs.setString('igdKeluhan', _keluhanController.text.trim());
    await prefs.setString('igdTriase', _selectedTriase ?? '');
    await prefs.setString('igdCaraDatang', _selectedCaraDatang ?? '');
    await prefs.setString('igdAsuransi', _selectedJenisAsuransi ?? '');
    await prefs.setString('igdKesadaran', _selectedKesadaran ?? '');
    await prefs.setString(
      'igdRiwayatPenyakit',
      _riwayatPenyakitController.text.trim(),
    );
    await prefs.setString(
      'igdObatDikonsumsi',
      _obatDikonsumsiController.text.trim(),
    );
    await prefs.setBool('igdRiwayatAlergi', _riwayatAlergi);
    await prefs.setString('igdJenisAlergi', _jenisAlergi ?? '');
    await prefs.setString(
      'igdNamaKeluarga',
      _namaKeluargaController.text.trim(),
    );
    await prefs.setString(
      'igdNoHPKeluarga',
      _nohpKeluargaController.text.trim(),
    );
    await prefs.setString(
      'igdHubunganKeluarga',
      _hubunganKeluargaController.text.trim(),
    );
    await prefs.setString('nomorAntrian_IGD', nomor);
    await prefs.setString(
      'igdWaktuRegistrasi',
      DateTime.now().toIso8601String(),
    );
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
        String triaseLevel = _getTriaseLevel(_selectedTriase);
        String nomorAntrian =
            "IGD${DateTime.now().millisecondsSinceEpoch % 10000}";

        // Generate nomor RM (Rekam Medis) dummy
        String noRM = "RM${DateTime.now().millisecondsSinceEpoch % 100000}";

        // Tampilkan snackbar sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.local_hospital, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Registrasi IGD berhasil!\nNomor: $nomorAntrian\nTriase: $triaseLevel",
                  ),
                ),
              ],
            ),
            backgroundColor: _getTriaseColor(_selectedTriase),
            duration: const Duration(seconds: 3),
          ),
        );

        // Tunda sebentar sebelum navigasi untuk memberikan waktu user melihat notifikasi
        await Future.delayed(const Duration(seconds: 1));

        // Navigasi ke halaman jadwal operasi
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => JadwalOperasiPage(
                    namaPasien: _namaController.text.trim(),
                    nik: _nikController.text.trim(),
                    umur: _umurController.text.trim(),
                    noRM: noRM,
                    unitPoli: "IGD (Instalasi Gawat Darurat)",
                    dokter: _getDokterByTriase(_selectedTriase),
                    nomorAntrian: nomorAntrian,
                  ),
            ),
          );
        }
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

  String _getDokterByTriase(String? triase) {
    if (triase == null) return "Dr. Umum, Sp.PD";

    if (triase.contains('Merah')) {
      return "Dr. Emergency, Sp.EM"; // Spesialis Emergency
    } else if (triase.contains('Kuning')) {
      return "Dr. Bedah, Sp.B"; // Spesialis Bedah
    } else if (triase.contains('Hijau')) {
      return "Dr. Penyakit Dalam, Sp.PD"; // Spesialis Penyakit Dalam
    } else if (triase.contains('Biru')) {
      return "Dr. Umum, Sp.PD"; // Dokter Umum
    }
    return "Dr. Umum, Sp.PD";
  }

  String _getTriaseLevel(String? triase) {
    if (triase == null) return "Belum ditentukan";
    if (triase.contains('Merah')) return "MERAH (EMERGENSI)";
    if (triase.contains('Kuning')) return "KUNING (URGENSI)";
    if (triase.contains('Hijau')) return "HIJAU (SEMI URGENSI)";
    if (triase.contains('Biru')) return "BIRU (NON URGENSI)";
    return "Belum ditentukan";
  }

  Color _getTriaseColor(String? triase) {
    if (triase == null) return Colors.grey;
    if (triase.contains('Merah')) return Colors.red;
    if (triase.contains('Kuning')) return Colors.orange;
    if (triase.contains('Hijau')) return Colors.green;
    if (triase.contains('Biru')) return Colors.blue;
    return Colors.grey;
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
                const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          validator:
              validator ??
              (isRequired
                  ? (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "$label harus diisi";
                    }
                    return null;
                  }
                  : null),
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
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
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
                const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          validator:
              validator ??
              (isRequired
                  ? (value) {
                    if (value == null || value.isEmpty) {
                      return "$label harus dipilih";
                    }
                    return null;
                  }
                  : null),
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
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          items:
              items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          item.contains('Merah')
                              ? Colors.red
                              : item.contains('Kuning')
                              ? Colors.orange
                              : item.contains('Hijau')
                              ? Colors.green
                              : item.contains('Biru')
                              ? Colors.blue
                              : Colors.black,
                    ),
                  ),
                );
              }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSectionTitle(String title, {Color? color}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: (color ?? Colors.red[50]),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: (color ?? Colors.red[200])!),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color ?? Colors.red,
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
          "Registrasi IGD",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.red[600],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red[800],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emergency, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  "DARURAT",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
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
              // Alert Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red[700]),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "UNTUK KASUS DARURAT: Segera hubungi petugas IGD atau tekan tombol panic button!",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Data Pasien
              _buildSectionTitle("🆔 Data Pasien"),
              _buildTextField(
                controller: _namaController,
                label: "Nama Lengkap Pasien",
                hint: "Masukkan nama sesuai identitas",
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
                      controller: _umurController,
                      label: "Umur",
                      hint: "Contoh: 25 tahun",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDropdownField(
                      label: "Jenis Kelamin",
                      hint: "Pilih jenis kelamin",
                      value: _selectedGender,
                      items: _genderOptions,
                      onChanged:
                          (value) => setState(() => _selectedGender = value),
                    ),
                  ),
                ],
              ),

              // Data Kontak
              _buildSectionTitle("📞 Data Kontak"),
              _buildTextField(
                controller: _alamatController,
                label: "Alamat",
                hint: "Alamat lengkap saat ini",
                maxLines: 2,
              ),
              _buildTextField(
                controller: _nohpController,
                label: "Nomor HP/Telepon",
                hint: "08xxxxxxxxxx",
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Nomor HP harus diisi";
                  }
                  return null;
                },
              ),

              // Kondisi Medis
              _buildSectionTitle("🏥 Kondisi Medis & Triase"),
              _buildTextField(
                controller: _keluhanController,
                label: "Keluhan Utama",
                hint: "Deskripsikan keluhan atau gejala yang dialami",
                maxLines: 3,
              ),
              _buildDropdownField(
                label: "Tingkat Kesadaran",
                hint: "Pilih tingkat kesadaran pasien",
                value: _selectedKesadaran,
                items: _kesadaranOptions,
                onChanged:
                    (value) => setState(() => _selectedKesadaran = value),
              ),
              _buildDropdownField(
                label: "Level Triase (Tingkat Kegawatan)",
                hint: "Pilih berdasarkan kondisi pasien",
                value: _selectedTriase,
                items: _triaseOptions,
                onChanged: (value) => setState(() => _selectedTriase = value),
              ),
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
                hint: "Nama obat dan dosis jika ada",
                maxLines: 2,
                isRequired: false,
              ),

              // Riwayat Alergi
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
                      "Riwayat Alergi",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Checkbox(
                          value: _riwayatAlergi,
                          onChanged:
                              (value) => setState(() {
                                _riwayatAlergi = value ?? false;
                                if (!_riwayatAlergi) _jenisAlergi = null;
                              }),
                          activeColor: Colors.red,
                        ),
                        const Text("Memiliki riwayat alergi"),
                      ],
                    ),
                    if (_riwayatAlergi) ...[
                      const SizedBox(height: 8),
                      TextFormField(
                        onChanged: (value) => _jenisAlergi = value,
                        decoration: InputDecoration(
                          hintText: "Jenis alergi (makanan, obat, dll)",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Data Kedatangan
              _buildSectionTitle("🚨 Data Kedatangan"),
              _buildDropdownField(
                label: "Cara Datang ke IGD",
                hint: "Pilih cara kedatangan",
                value: _selectedCaraDatang,
                items: _caraDatangOptions,
                onChanged:
                    (value) => setState(() => _selectedCaraDatang = value),
              ),
              _buildDropdownField(
                label: "Jenis Pembayaran",
                hint: "Pilih jenis pembayaran",
                value: _selectedJenisAsuransi,
                items: _jenisAsuransiOptions,
                onChanged:
                    (value) => setState(() => _selectedJenisAsuransi = value),
              ),

              // Kontak Keluarga
              _buildSectionTitle("👨‍👩‍👧‍👦 Kontak Keluarga/Wali"),
              _buildTextField(
                controller: _namaKeluargaController,
                label: "Nama Keluarga/Wali",
                hint: "Nama yang dapat dihubungi",
              ),
              _buildTextField(
                controller: _nohpKeluargaController,
                label: "Nomor HP Keluarga/Wali",
                hint: "08xxxxxxxxxx",
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                controller: _hubunganKeluargaController,
                label: "Hubungan dengan Pasien",
                hint: "Suami/Istri/Anak/Orang Tua/Saudara",
              ),

              const SizedBox(height: 24),

              // Submit Button
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Colors.red[600]!, Colors.red[700]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
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
                              Icon(Icons.local_hospital, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "DAFTAR IGD SEKARANG",
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

              // Emergency Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.emergency, color: Colors.red[700]),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "KETERANGAN TRIASE:",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.circle, color: Colors.red, size: 12),
                            SizedBox(width: 8),
                            Text(
                              "MERAH: Kondisi mengancam jiwa, butuh penanganan segera",
                              style: TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.circle, color: Colors.orange, size: 12),
                            SizedBox(width: 8),
                            Text(
                              "KUNING: Urgensi tinggi, dapat ditunda maksimal 30 menit",
                              style: TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.circle, color: Colors.green, size: 12),
                            SizedBox(width: 8),
                            Text(
                              "HIJAU: Semi urgensi, dapat ditunda maksimal 2 jam",
                              style: TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.circle, color: Colors.blue, size: 12),
                            SizedBox(width: 8),
                            Text(
                              "BIRU: Non urgensi, kondisi tidak darurat",
                              style: TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
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
    _umurController.dispose();
    _alamatController.dispose();
    _nohpController.dispose();
    _keluhanController.dispose();
    _riwayatPenyakitController.dispose();
    _obatDikonsumsiController.dispose();
    _namaKeluargaController.dispose();
    _nohpKeluargaController.dispose();
    _hubunganKeluargaController.dispose();
    super.dispose();
  }
}
