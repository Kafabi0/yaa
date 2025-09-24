import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';
import 'package:inocare/services/user_prefs.dart';

class RegistrasiRajalPage extends StatefulWidget {
  const RegistrasiRajalPage({Key? key}) : super(key: key);

  @override
  State<RegistrasiRajalPage> createState() => _RegistrasiRajalPageState();
}

class _RegistrasiRajalPageState extends State<RegistrasiRajalPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _noKKController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _nohpController = TextEditingController();
  final TextEditingController _pekerjaanController = TextEditingController();
  final TextEditingController _namaKeluargaController = TextEditingController();
  final TextEditingController _nohpKeluargaController = TextEditingController();
  final TextEditingController _keluhanController = TextEditingController();

  String? _selectedGender;
  String? _selectedAgama;
  String? _selectedStatusPerkawinan;
  String? _selectedGolonganDarah;
  String? _selectedJenisAsuransi;
  String? _selectedPoli;
  String? _selectedJadwalKunjungan;
  bool _isLoading = false;

  // Tambahkan fungsi ini di dalam class _RegistrasiRajalPageState
  Future<void> showRegistrationSuccessNotification(
    String poli,
    String nomorAntrian,
  ) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'registrasi_rajal_channel',
          'Registrasi Rawat Jalan',
          channelDescription: 'Notifikasi konfirmasi pendaftaran rawat jalan',
          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails platformChannelDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      1, // ID unik notifikasi (pastikan berbeda jika ada notif lain)
      'Registrasi Rajal Berhasil! 🎉',
      'Pendaftaran Anda di $poli berhasil. Nomor antrian Anda adalah: $nomorAntrian.',
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
  final List<String> _jenisAsuransiOptions = [
    'BPJS Kesehatan',
    'BPJS Ketenagakerjaan',
    'Asuransi Swasta',
    'Umum',
  ];
  final List<String> _poliOptions = [
    'Poli Umum',
    'Poli Anak',
    'Poli Kandungan',
    'Poli Mata',
    'Poli THT',
    'Poli Gigi',
    'Poli Jantung',
    'Poli Paru',
    'Poli Saraf',
    'Poli Kulit',
  ];
  final List<String> _jadwalOptions = [
    'Pagi (08:00-12:00)',
    'Siang (13:00-16:00)',
    'Sore (16:00-19:00)',
  ];

  Future<void> _simpanData() async {
    final prefs = await SharedPreferences.getInstance();
    String nomor = "RJ${DateTime.now().millisecondsSinceEpoch % 10000}";

    await prefs.setString('name', _nameController.text.trim());
    await prefs.setString('nik', _nikController.text.trim());
    await prefs.setString('familyCardNumber', _noKKController.text.trim());
    await prefs.setString('birthPlace', _tempatLahirController.text.trim());
    await prefs.setString('birthDate', _tanggalLahirController.text.trim());
    await prefs.setString('gender', _selectedGender ?? '');
    await prefs.setString('registeredAgama', _selectedAgama ?? '');
    await prefs.setString('registeredStatus', _selectedStatusPerkawinan ?? '');
    await prefs.setString('registeredGolDarah', _selectedGolonganDarah ?? '');
    await prefs.setString('address', _alamatController.text.trim());
    await prefs.setString('phone', _nohpController.text.trim());
    await prefs.setString(
      'registeredPekerjaan',
      _pekerjaanController.text.trim(),
    );
    await prefs.setString(
      'registeredNamaKeluarga',
      _namaKeluargaController.text.trim(),
    );
    await prefs.setString(
      'registeredNoHPKeluarga',
      _nohpKeluargaController.text.trim(),
    );
    await prefs.setString('registeredAsuransi', _selectedJenisAsuransi ?? '');
    await prefs.setString('registeredPoli', _selectedPoli ?? '');
    await prefs.setString('registeredJadwal', _selectedJadwalKunjungan ?? '');
    await prefs.setString('registeredKeluhan', _keluhanController.text.trim());
    await prefs.setString('nomorAntrian_RAJAL', nomor);
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Panggil _simpanData() yang menyimpan data ke SharedPreferences
      await _simpanData();

      if (mounted) {
        // 2. Ambil nomor antrian dan poli yang baru disimpan dari SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final nomorAntrian = prefs.getString('nomorAntrian_RAJAL');
        await prefs.setString(
          'rajalWaktuRegistrasi',
          DateTime.now().toIso8601String(),
        );

        final poli = _selectedPoli ?? '';

        // 3. PANGGIL FUNGSI NOTIFIKASI DI SINI
        // Pastikan Anda sudah mengimpor file main.dart
        await showRegistrationSuccessNotification(
          poli,
          nomorAntrian ?? 'Tidak Ada',
        );

        // 4. Tampilkan Snackbar dan navigasi
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Row(
        //       children: [
        //         const Icon(Icons.check_circle, color: Colors.white),
        //         const SizedBox(width: 8),
        //         Expanded(
        //           child: Text(
        //             "Registrasi berhasil! Nomor antrian: $nomorAntrian",
        //           ),
        //         ),
        //       ],
        //     ),
        //     backgroundColor: Colors.green,
        //     duration: const Duration(seconds: 3),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          validator: validator,
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
              borderSide: const BorderSide(color: Colors.blue, width: 2),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          validator: validator,
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
              borderSide: const BorderSide(color: Colors.blue, width: 2),
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
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
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
          "Registrasi Rawat Jalan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey[200]),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Data Pribadi
              _buildSectionTitle("📋 Data Pribadi"),
              _buildTextField(
                controller: _nameController,
                label: "Nama Lengkap *",
                hint: "Masukkan nama sesuai KTP",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Nama lengkap harus diisi";
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _nikController,
                label: "NIK (Nomor Induk Kependudukan) *",
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
                label: "Nomor Kartu Keluarga *",
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
                      label: "Tempat Lahir *",
                      hint: "Kota kelahiran",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Tempat lahir harus diisi";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _tanggalLahirController,
                      label: "Tanggal Lahir *",
                      hint: "DD/MM/YYYY",
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Tanggal lahir harus diisi";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      label: "Jenis Kelamin *",
                      hint: "Pilih jenis kelamin",
                      value: _selectedGender,
                      items: _genderOptions,
                      onChanged:
                          (value) => setState(() => _selectedGender = value),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Jenis kelamin harus dipilih";
                        }
                        return null;
                      },
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
                label: "Agama *",
                hint: "Pilih agama",
                value: _selectedAgama,
                items: _agamaOptions,
                onChanged: (value) => setState(() => _selectedAgama = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Agama harus dipilih";
                  }
                  return null;
                },
              ),
              _buildDropdownField(
                label: "Status Perkawinan *",
                hint: "Pilih status perkawinan",
                value: _selectedStatusPerkawinan,
                items: _statusPerkawinanOptions,
                onChanged:
                    (value) =>
                        setState(() => _selectedStatusPerkawinan = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Status perkawinan harus dipilih";
                  }
                  return null;
                },
              ),

              // Data Kontak & Alamat
              _buildSectionTitle("📍 Data Kontak & Alamat"),
              _buildTextField(
                controller: _alamatController,
                label: "Alamat Lengkap *",
                hint: "Jalan, RT/RW, Kelurahan, Kecamatan, Kota",
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Alamat harus diisi";
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _nohpController,
                label: "Nomor HP/WhatsApp *",
                hint: "08xxxxxxxxxx",
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Nomor HP harus diisi";
                  }
                  if (!RegExp(r'^[0-9+]+$').hasMatch(value)) {
                    return "Format nomor HP tidak valid";
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _pekerjaanController,
                label: "Pekerjaan *",
                hint: "Contoh: Karyawan Swasta, PNS, Wiraswasta, dll",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Pekerjaan harus diisi";
                  }
                  return null;
                },
              ),

              // Data Kontak Keluarga
              _buildSectionTitle("👨‍👩‍👧‍👦 Kontak Keluarga/Wali"),
              _buildTextField(
                controller: _namaKeluargaController,
                label: "Nama Keluarga/Wali Terdekat *",
                hint: "Nama lengkap keluarga yang dapat dihubungi",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Nama keluarga harus diisi";
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _nohpKeluargaController,
                label: "Nomor HP Keluarga/Wali *",
                hint: "08xxxxxxxxxx",
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Nomor HP keluarga harus diisi";
                  }
                  return null;
                },
              ),

              // Data Asuransi & Kunjungan
              _buildSectionTitle("🏥 Data Asuransi & Kunjungan"),
              _buildDropdownField(
                label: "Jenis Asuransi/Pembayaran *",
                hint: "Pilih jenis pembayaran",
                value: _selectedJenisAsuransi,
                items: _jenisAsuransiOptions,
                onChanged:
                    (value) => setState(() => _selectedJenisAsuransi = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Jenis pembayaran harus dipilih";
                  }
                  return null;
                },
              ),
              _buildDropdownField(
                label: "Tujuan Poli *",
                hint: "Pilih poli yang dituju",
                value: _selectedPoli,
                items: _poliOptions,
                onChanged: (value) => setState(() => _selectedPoli = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Tujuan poli harus dipilih";
                  }
                  return null;
                },
              ),
              _buildDropdownField(
                label: "Jadwal Kunjungan *",
                hint: "Pilih waktu kunjungan",
                value: _selectedJadwalKunjungan,
                items: _jadwalOptions,
                onChanged:
                    (value) => setState(() => _selectedJadwalKunjungan = value),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Jadwal kunjungan harus dipilih";
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _keluhanController,
                label: "Keluhan Utama",
                hint: "Deskripsikan keluhan atau gejala yang dirasakan",
                maxLines: 3,
              ),

              const SizedBox(height: 24),

              // Submit Button
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
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
                                "Menyimpan...",
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
                              Icon(Icons.app_registration, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "Daftar Rawat Jalan",
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

              // Info Text
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber[700]),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Pastikan semua data yang dimasukkan sudah benar. Nomor antrian akan diberikan setelah registrasi berhasil.",
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
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
    _nameController.dispose();
    _nikController.dispose();
    _noKKController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _alamatController.dispose();
    _nohpController.dispose();
    _pekerjaanController.dispose();
    _namaKeluargaController.dispose();
    _nohpKeluargaController.dispose();
    _keluhanController.dispose();
    super.dispose();
  }
}
