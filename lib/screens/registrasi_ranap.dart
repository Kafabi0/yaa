import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inocare/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class RegistrasiRanapPage extends StatefulWidget {
  const RegistrasiRanapPage({Key? key}) : super(key: key);

  @override
  State<RegistrasiRanapPage> createState() => _RegistrasiRanapPageState();
}

class _RegistrasiRanapPageState extends State<RegistrasiRanapPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _noKKController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _nohpController = TextEditingController();
  final TextEditingController _pekerjaanController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _keluhanController = TextEditingController();
  final TextEditingController _riwayatPenyakitController =
      TextEditingController();
  final TextEditingController _obatDikonsumsiController =
      TextEditingController();
  final TextEditingController _namaKeluargaController = TextEditingController();
  final TextEditingController _nohpKeluargaController = TextEditingController();
  final TextEditingController _alamatKeluargaController =
      TextEditingController();
  final TextEditingController _namaWaliController = TextEditingController();
  final TextEditingController _nohpWaliController = TextEditingController();
  final TextEditingController _penanggungJawabController =
      TextEditingController();

  String? _selectedGender;
  String? _selectedAgama;
  String? _selectedStatusPerkawinan;
  String? _selectedGolonganDarah;
  String? _selectedKelasPerawatan;
  String? _selectedTipeKamar;
  String? _selectedJenisAsuransi;
  String? _selectedDokterPenanggungJawab;
  String? _selectedRuangan;
  String? _selectedCaraMasuk;
  String? _selectedHubunganKeluarga;
  String? _selectedHubunganWali;
  bool _riwayatAlergi = false;
  bool _riwayatOperasi = false;
  String? _jenisAlergi;
  String? _jenisOperasi;

  // Tambahkan fungsi ini di dalam class _RegistrasiRanapPageState
  Future<void> showRegistrationSuccessNotification(
    String nomorAntrian,
    String kelas,
    String ruangan,
  ) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'registrasi_ranap_channel',
          'Registrasi Rawat Inap',
          channelDescription: 'Notifikasi konfirmasi pendaftaran rawat inap',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformChannelDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      2, // ID unik berbeda dari rajal
      'Registrasi Rawat Inap Berhasil! 🏥',
      'Nomor registrasi Anda: $nomorAntrian\nKelas: $kelas\nRuangan: $ruangan',
      platformChannelDetails,
    );
  }

  final List<String> _genderOptions = ['Laki-laki', 'Perempuan'];
  final List<String> _agamaOptions = [
    'Islam',
    'Kristen',
    'Katolik',
    'Hindu',
    'Buddha',
    'Konghucu',
  ];
  final List<String> _statusPerkawinanOptions = [
    'Belum Menikah',
    'Menikah',
    'Cerai Hidup',
    'Cerai Mati',
  ];
  final List<String> _golonganDarahOptions = ['A', 'B', 'AB', 'O'];

  final Map<String, Map<String, dynamic>> _kelasPerawatanOptions = {
    'VIP Suite': {
      'harga': 'Rp 2.500.000/hari',
      'fasilitas': [
        'Kamar pribadi dengan AC',
        'Kamar mandi dalam',
        'TV LED 43 inch',
        'Kulkas mini',
        'Sofa untuk keluarga',
        'WiFi gratis',
        'Makan 3x sehari',
        'Laundry gratis',
      ],
      'color': Colors.purple,
    },
    'VIP': {
      'harga': 'Rp 1.800.000/hari',
      'fasilitas': [
        'Kamar pribadi dengan AC',
        'Kamar mandi dalam',
        'TV LED 32 inch',
        'Tempat tidur untuk keluarga',
        'WiFi gratis',
        'Makan 3x sehari',
      ],
      'color': Colors.indigo,
    },
    'Kelas I': {
      'harga': 'Rp 800.000/hari',
      'fasilitas': [
        'Kamar untuk 2 pasien',
        'AC',
        'Kamar mandi dalam',
        'TV bersama',
        'Makan 3x sehari',
      ],
      'color': Colors.blue,
    },
    'Kelas II': {
      'harga': 'Rp 500.000/hari',
      'fasilitas': [
        'Kamar untuk 4 pasien',
        'Kipas angin',
        'Kamar mandi bersama',
        'Makan 3x sehari',
      ],
      'color': Colors.green,
    },
    'Kelas III': {
      'harga': 'Rp 300.000/hari',
      'fasilitas': [
        'Kamar untuk 6 pasien',
        'Ventilasi alami',
        'Kamar mandi bersama',
        'Makan 3x sehari',
      ],
      'color': Colors.orange,
    },
  };

  final List<String> _tipeKamarOptions = [
    'Standar',
    'Superior',
    'Deluxe',
    'Suite',
    'Isolasi',
    'ICU',
    'ICCU',
    'NICU',
  ];

  final List<String> _jenisAsuransiOptions = [
    'BPJS Kesehatan',
    'Asuransi Swasta',
    'Perusahaan',
    'Jamkesmas',
    'Umum/Tunai',
    'Asuransi Jiwa',
    'Lainnya',
  ];

  final List<String> _dokterOptions = [
    'dr. Ahmad Fauzi, Sp.PD (Penyakit Dalam)',
    'dr. Sarah Putri, Sp.JP (Jantung)',
    'dr. Budi Santoso, Sp.B (Bedah)',
    'dr. Lisa Andini, Sp.OG (Kandungan)',
    'dr. Rahman Ali, Sp.A (Anak)',
    'dr. Maya Sari, Sp.S (Saraf)',
    'dr. Dedi Kurnia, Sp.THT (THT)',
    'dr. Nina Kartika, Sp.M (Mata)',
    'dr. Agus Wijaya, Sp.U (Urologi)',
    'dr. Rina Dewi, Sp.KK (Kulit)',
  ];

  final List<String> _ruanganOptions = [
    'Ruang Mawar (VIP)',
    'Ruang Melati (Kelas I)',
    'Ruang Anggrek (Kelas II)',
    'Ruang Dahlia (Kelas III)',
    'Ruang ICU',
    'Ruang ICCU',
    'Ruang Isolasi',
    'Ruang Bersalin',
    'Ruang Anak',
    'Ruang Bedah',
  ];

  final List<String> _caraMasukOptions = [
    'Rujukan IGD',
    'Rujukan Poli',
    'Rujukan RS Lain',
    'Rujukan Puskesmas',
    'Datang Sendiri',
    'Transfer dari ICU',
    'Post Operasi',
  ];

  final List<String> _hubunganOptions = [
    'Suami',
    'Istri',
    'Anak',
    'Orang Tua',
    'Saudara Kandung',
    'Saudara',
    'Teman',
    'Lainnya',
  ];

  bool _isLoading = false;

  Future<void> _simpanData() async {
    final prefs = await SharedPreferences.getInstance();
    final nik = prefs.getString('current_nik'); // user aktif bener
    // user aktif

    if (nik == null) {
      throw Exception("User belum login, NIK tidak ditemukan.");
    }
    String nomor = "RNP${DateTime.now().millisecondsSinceEpoch % 10000}";

    await prefs.setString('user_${nik}_ranapName', _namaController.text.trim());
    await prefs.setString('user_${nik}_ranapNIK', _nikController.text.trim());
    await prefs.setString('user_${nik}_ranapNoKK', _noKKController.text.trim());
    await prefs.setString(
      'user_${nik}_ranapTempatLahir',
      _tempatLahirController.text.trim(),
    );
    await prefs.setString(
      'user_${nik}_ranapTanggalLahir',
      _tanggalLahirController.text.trim(),
    );
    await prefs.setString('user_${nik}_ranapGender', _selectedGender ?? '');
    await prefs.setString('user_${nik}_ranapAgama', _selectedAgama ?? '');
    await prefs.setString(
      'user_${nik}_ranapStatus',
      _selectedStatusPerkawinan ?? '',
    );
    await prefs.setString(
      'user_${nik}_ranapGolDarah',
      _selectedGolonganDarah ?? '',
    );
    await prefs.setString(
      'user_${nik}_ranapAlamat',
      _alamatController.text.trim(),
    );
    await prefs.setString('user_${nik}_ranapNoHP', _nohpController.text.trim());
    await prefs.setString(
      'user_${nik}_ranapPekerjaan',
      _pekerjaanController.text.trim(),
    );
    await prefs.setString(
      'user_${nik}_ranapKelas',
      _selectedKelasPerawatan ?? '',
    );
    await prefs.setString(
      'user_${nik}_ranapTipeKamar',
      _selectedTipeKamar ?? '',
    );
    await prefs.setString(
      'user_${nik}_ranapAsuransi',
      _selectedJenisAsuransi ?? '',
    );
    await prefs.setString(
      'user_${nik}_ranapDokter',
      _selectedDokterPenanggungJawab ?? '',
    );
    await prefs.setString('user_${nik}_ranapRuangan', _selectedRuangan ?? '');
    await prefs.setString(
      'user_${nik}_ranapCaraMasuk',
      _selectedCaraMasuk ?? '',
    );
    await prefs.setString(
      'user_${nik}_ranapDiagnosis',
      _diagnosisController.text.trim(),
    );
    await prefs.setString(
      'user_${nik}_ranapKeluhan',
      _keluhanController.text.trim(),
    );
    await prefs.setString(
      'user_${nik}_ranapRiwayatPenyakit',
      _riwayatPenyakitController.text.trim(),
    );
    await prefs.setString(
      'user_${nik}_ranapObatDikonsumsi',
      _obatDikonsumsiController.text.trim(),
    );
    await prefs.setBool('user_${nik}_ranapRiwayatAlergi', _riwayatAlergi);
    await prefs.setBool('user_${nik}_ranapRiwayatOperasi', _riwayatOperasi);
    await prefs.setString('user_${nik}_ranapJenisAlergi', _jenisAlergi ?? '');
    await prefs.setString('user_${nik}_ranapJenisOperasi', _jenisOperasi ?? '');
    await prefs.setString(
      'user_${nik}_ranapNamaKeluarga',
      _namaKeluargaController.text.trim(),
    );
    await prefs.setString(
      'user_${nik}_ranapNoHPKeluarga',
      _nohpKeluargaController.text.trim(),
    );
    await prefs.setString(
      'user_${nik}_ranapAlamatKeluarga',
      _alamatKeluargaController.text.trim(),
    );
    await prefs.setString(
      'user_${nik}_ranapHubunganKeluarga',
      _selectedHubunganKeluarga ?? '',
    );
    await prefs.setString(
      'user_${nik}_ranapNamaWali',
      _namaWaliController.text.trim(),
    );
    await prefs.setString(
      'user_${nik}_ranapNoHPWali',
      _nohpWaliController.text.trim(),
    );
    await prefs.setString(
      'user_${nik}_ranapHubunganWali',
      _selectedHubunganWali ?? '',
    );
    await prefs.setString(
      'user_${nik}_ranapPenanggungJawab',
      _penanggungJawabController.text.trim(),
    );
    await prefs.setString('user_${nik}_nomorAntrian_RANAP', nomor);
    await prefs.setString(
      'ranapWaktuRegistrasi',
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
        final prefs = await SharedPreferences.getInstance();
        final nik = prefs.getString('current_nik');
        if (nik == null) {
          throw Exception("User belum login, NIK tidak ditemukan.");
        }

        final nomorAntrian =
            prefs.getString('user_${nik}_nomorAntrian_RANAP') ?? 'Tidak Ada';
        final kelasInfo =
            _selectedKelasPerawatan != null
                ? "${_selectedKelasPerawatan} - ${_kelasPerawatanOptions[_selectedKelasPerawatan!]!['harga']}"
                : "";
        final ruangan = _selectedRuangan ?? 'Belum dipilih';

        // ✅ Panggil notifikasi
        await showRegistrationSuccessNotification(
          nomorAntrian,
          kelasInfo,
          ruangan,
        );

        // Snackbar opsional, bisa tetap dipakai
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Row(
        //       children: [
        //         const Icon(Icons.hotel, color: Colors.white),
        //         const SizedBox(width: 8),
        //         Expanded(
        //           child: Text(
        //             "Registrasi Rawat Inap berhasil!\nNomor: $nomorAntrian\nKelas: $kelasInfo",
        //           ),
        //         ),
        //       ],
        //     ),
        //     backgroundColor: Colors.teal,
        //     duration: const Duration(seconds: 4),
        //   ),
        // );

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
                  style: TextStyle(color: Colors.teal),
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
              borderSide: const BorderSide(color: Colors.teal, width: 2),
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
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.teal),
                ),
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
              borderSide: const BorderSide(color: Colors.teal, width: 2),
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
                  child: Text(item, style: const TextStyle(fontSize: 13)),
                );
              }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildKelasPerawatanCard(
    String kelasName,
    Map<String, dynamic> kelasData,
  ) {
    final bool isSelected = _selectedKelasPerawatan == kelasName;

    return GestureDetector(
      onTap: () => setState(() => _selectedKelasPerawatan = kelasName),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? kelasData['color'] : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color:
              isSelected ? kelasData['color'].withOpacity(0.05) : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Radio<String>(
                  value: kelasName,
                  groupValue: _selectedKelasPerawatan,
                  onChanged:
                      (value) =>
                          setState(() => _selectedKelasPerawatan = value),
                  activeColor: kelasData['color'],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kelasName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kelasData['color'],
                        ),
                      ),
                      Text(
                        kelasData['harga'],
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
              "Fasilitas:",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            ...kelasData['fasilitas']
                .map<Widget>(
                  (item) => Padding(
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
                  ),
                )
                .toList(),
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
        color: (color ?? Colors.teal[50]),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: (color ?? Colors.teal[200])!),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color ?? Colors.teal,
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
          "Registrasi Rawat Inap",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.teal[600],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.teal[800],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.hotel, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  "RANAP",
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
              // Info Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.teal[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.teal[700]),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Pastikan data yang dimasukkan lengkap dan benar untuk proses rawat inap yang optimal",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
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
              _buildTextField(
                controller: _noKKController,
                label: "Nomor Kartu Keluarga",
                hint: "16 digit nomor KK",
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Nomor KK harus diisi";
                  }
                  if (value.length != 16) {
                    return "Nomor KK harus 16 digit";
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
                      onChanged:
                          (value) => setState(() => _selectedGender = value),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDropdownField(
                      label: "Golongan Darah",
                      hint: "Pilih golongan darah",
                      value: _selectedGolonganDarah,
                      items: _golonganDarahOptions,
                      onChanged:
                          (value) =>
                              setState(() => _selectedGolonganDarah = value),
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
                onChanged:
                    (value) =>
                        setState(() => _selectedStatusPerkawinan = value),
              ),

              // Data Kontak
              _buildSectionTitle("📞 Data Kontak & Pekerjaan"),
              _buildTextField(
                controller: _alamatController,
                label: "Alamat Lengkap",
                hint: "Jalan, RT/RW, Kelurahan, Kecamatan, Kota",
                maxLines: 3,
              ),
              _buildTextField(
                controller: _nohpController,
                label: "Nomor HP/Telepon",
                hint: "08xxxxxxxxxx",
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                controller: _pekerjaanController,
                label: "Pekerjaan",
                hint: "Profesi atau pekerjaan saat ini",
              ),

              // Kelas Perawatan
              _buildSectionTitle("🏨 Pilih Kelas Perawatan"),
              Column(
                children:
                    _kelasPerawatanOptions.entries.map((entry) {
                      return _buildKelasPerawatanCard(entry.key, entry.value);
                    }).toList(),
              ),
              if (_selectedKelasPerawatan == null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: const Text(
                    "Silakan pilih kelas perawatan yang diinginkan",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 16),

              // Detail Perawatan
              _buildSectionTitle("🏥 Detail Perawatan"),
              _buildDropdownField(
                label: "Tipe Kamar",
                hint: "Pilih tipe kamar",
                value: _selectedTipeKamar,
                items: _tipeKamarOptions,
                onChanged:
                    (value) => setState(() => _selectedTipeKamar = value),
              ),
              _buildDropdownField(
                label: "Ruangan",
                hint: "Pilih ruangan perawatan",
                value: _selectedRuangan,
                items: _ruanganOptions,
                onChanged: (value) => setState(() => _selectedRuangan = value),
              ),
              _buildDropdownField(
                label: "Dokter Penanggung Jawab",
                hint: "Pilih dokter yang akan merawat",
                value: _selectedDokterPenanggungJawab,
                items: _dokterOptions,
                onChanged:
                    (value) =>
                        setState(() => _selectedDokterPenanggungJawab = value),
              ),
              _buildDropdownField(
                label: "Cara Masuk Rawat Inap",
                hint: "Pilih cara masuk",
                value: _selectedCaraMasuk,
                items: _caraMasukOptions,
                onChanged:
                    (value) => setState(() => _selectedCaraMasuk = value),
              ),
              _buildDropdownField(
                label: "Jenis Pembayaran/Asuransi",
                hint: "Pilih jenis pembayaran",
                value: _selectedJenisAsuransi,
                items: _jenisAsuransiOptions,
                onChanged:
                    (value) => setState(() => _selectedJenisAsuransi = value),
              ),

              // Kondisi Medis
              _buildSectionTitle("🩺 Kondisi Medis"),
              _buildTextField(
                controller: _diagnosisController,
                label: "Diagnosis Awal",
                hint: "Diagnosis atau dugaan penyakit",
                maxLines: 2,
              ),
              _buildTextField(
                controller: _keluhanController,
                label: "Keluhan Utama",
                hint: "Keluhan yang menyebabkan rawat inap",
                maxLines: 3,
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
                hint: "Nama obat dan dosis",
                maxLines: 2,
                isRequired: false,
              ),

              // Riwayat Medis
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
                      "Riwayat Medis",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      value: _riwayatAlergi,
                      onChanged:
                          (value) => setState(() {
                            _riwayatAlergi = value ?? false;
                            if (!_riwayatAlergi) _jenisAlergi = null;
                          }),
                      title: const Text(
                        "Memiliki riwayat alergi",
                        style: TextStyle(fontSize: 13),
                      ),
                      activeColor: Colors.teal,
                      contentPadding: EdgeInsets.zero,
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
                    CheckboxListTile(
                      value: _riwayatOperasi,
                      onChanged:
                          (value) => setState(() {
                            _riwayatOperasi = value ?? false;
                            if (!_riwayatOperasi) _jenisOperasi = null;
                          }),
                      title: const Text(
                        "Pernah menjalani operasi",
                        style: TextStyle(fontSize: 13),
                      ),
                      activeColor: Colors.teal,
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (_riwayatOperasi) ...[
                      const SizedBox(height: 8),
                      TextFormField(
                        onChanged: (value) => _jenisOperasi = value,
                        decoration: InputDecoration(
                          hintText: "Jenis operasi dan tahun",
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

              // Kontak Keluarga
              _buildSectionTitle("👨‍👩‍👧‍👦 Data Keluarga Terdekat"),
              _buildTextField(
                controller: _namaKeluargaController,
                label: "Nama Keluarga Terdekat",
                hint: "Yang akan menemani selama rawat inap",
              ),
              _buildTextField(
                controller: _nohpKeluargaController,
                label: "Nomor HP Keluarga",
                hint: "08xxxxxxxxxx",
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                controller: _alamatKeluargaController,
                label: "Alamat Keluarga",
                hint: "Alamat tempat tinggal keluarga",
                maxLines: 2,
              ),
              _buildDropdownField(
                label: "Hubungan dengan Pasien",
                hint: "Pilih hubungan",
                value: _selectedHubunganKeluarga,
                items: _hubunganOptions,
                onChanged:
                    (value) =>
                        setState(() => _selectedHubunganKeluarga = value),
              ),

              // Data Wali (untuk pasien di bawah umur)
              _buildSectionTitle("👤 Data Wali (Khusus Pasien Di Bawah Umur)"),
              _buildTextField(
                controller: _namaWaliController,
                label: "Nama Wali",
                hint: "Kosongkan jika pasien sudah dewasa",
                isRequired: false,
              ),
              _buildTextField(
                controller: _nohpWaliController,
                label: "Nomor HP Wali",
                hint: "08xxxxxxxxxx",
                keyboardType: TextInputType.phone,
                isRequired: false,
              ),
              _buildDropdownField(
                label: "Hubungan Wali dengan Pasien",
                hint: "Pilih hubungan",
                value: _selectedHubunganWali,
                items: _hubunganOptions,
                onChanged:
                    (value) => setState(() => _selectedHubunganWali = value),
                isRequired: false,
              ),

              // Penanggung Jawab
              _buildSectionTitle("💳 Penanggung Jawab Pembayaran"),
              _buildTextField(
                controller: _penanggungJawabController,
                label: "Nama Penanggung Jawab",
                hint: "Yang bertanggung jawab atas biaya perawatan",
              ),

              const SizedBox(height: 24),

              // Submit Button
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Colors.teal[600]!, Colors.teal[700]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed:
                      _isLoading
                          ? null
                          : () {
                            if (_selectedKelasPerawatan == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Silakan pilih kelas perawatan terlebih dahulu",
                                  ),
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
                              Icon(Icons.hotel, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "DAFTAR RAWAT INAP",
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
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.teal[200]!),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.teal[700]),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "PERSIAPAN RAWAT INAP:",
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("• ", style: TextStyle(fontSize: 11)),
                            Expanded(
                              child: Text(
                                "Siapkan dokumen: KTP, KK, Kartu BPJS/Asuransi",
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
                                "Bawa pakaian ganti, perlengkapan mandi, dan obat pribadi",
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
                                "Keluarga maksimal 2 orang untuk kelas VIP, 1 orang untuk kelas lainnya",
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
                                "Siapkan uang muka sesuai kelas perawatan yang dipilih",
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

              // Jam Besuk
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
                        Icon(Icons.schedule, color: Colors.blue[700]),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "JAM BESUK:",
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
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Pagi: 10:00 - 12:00 WIB",
                              style: TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Sore: 16:00 - 20:00 WIB",
                              style: TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.info, size: 16, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              "ICU/ICCU: 11:00-12:00 & 17:00-18:00",
                              style: TextStyle(fontSize: 11),
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
                    colors: [Colors.green[50]!, Colors.green[100]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.green[700]),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "INFORMASI RAWAT INAP:",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(Icons.call, size: 16, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          "Telepon: (021) 555-0124",
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Icon(Icons.extension, size: 16, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          "Ext. Admisi: 101 | Perawat: 201",
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Icon(Icons.email, size: 16, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          "Email: ranap@rumahsakit.com",
                          style: TextStyle(fontSize: 11),
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
    _noKKController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _alamatController.dispose();
    _nohpController.dispose();
    _pekerjaanController.dispose();
    _diagnosisController.dispose();
    _keluhanController.dispose();
    _riwayatPenyakitController.dispose();
    _obatDikonsumsiController.dispose();
    _namaKeluargaController.dispose();
    _nohpKeluargaController.dispose();
    _alamatKeluargaController.dispose();
    _namaWaliController.dispose();
    _nohpWaliController.dispose();
    _penanggungJawabController.dispose();
    super.dispose();
  }
}
