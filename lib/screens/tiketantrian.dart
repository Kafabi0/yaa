import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QueueTicketPage extends StatelessWidget {
  final String jenis;
  final String nomorAntrian;

  const QueueTicketPage({
    super.key,
    required this.jenis,
    required this.nomorAntrian,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Tiket Antrian',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF2C5282),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Ticket Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2C5282),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.local_hospital_outlined,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'RUMAH SAKIT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          jenis.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Ticket Content
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        // Queue Number Section
                        const Text(
                          'NOMOR ANTRIAN',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            nomorAntrian,
                            style: const TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C5282),
                              height: 1,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // QR Code Section
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 2,
                            ),
                          ),
                          child: QrImageView(
                            data: '$jenis-$nomorAntrian',
                            size: 180,
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF1A202C),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Instructions
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFFBBF24),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: Color(0xFFD97706),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Tunjukkan QR code ini saat verifikasi di rumah sakit',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF92400E),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Additional Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.schedule_outlined,
                        color: Color(0xFF64748B),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Informasi Penting',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  _buildInfoItem(
                    Icons.access_time,
                    'Datang 15 menit sebelum jadwal',
                  ),
                  _buildInfoItem(
                    Icons.credit_card_outlined,
                    'Siapkan kartu identitas',
                  ),
                  _buildInfoItem(
                    Icons.phone_outlined,
                    'Pastikan ponsel Anda terisi daya',
                  ),

                  const SizedBox(height: 20),

                  // 🔘 Tombol Batalkan
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        // Aksi ketika batalkan ditekan
                        _showCancelConfirmation(context);
                      },
                      child: const Text(
                        "Batalkan",
                        style: TextStyle(color: Colors.white, fontSize: 16),
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
  }

  Future<void> _hapusDataRegistrasiByJenis(String nik, String jenis) async {
    final prefs = await SharedPreferences.getInstance();

    switch (jenis) {
      case 'RAJAL':
        await prefs.remove('user_${nik}_rajalName');
        await prefs.remove('user_${nik}_familyCardNumber');
        await prefs.remove('user_${nik}_birthPlace');
        await prefs.remove('user_${nik}_birthDate');
        await prefs.remove('user_${nik}_gender');
        await prefs.remove('user_${nik}_registeredAgama');
        await prefs.remove('user_${nik}_registeredStatus');
        await prefs.remove('user_${nik}_registeredGolDarah');
        await prefs.remove('user_${nik}_address');
        await prefs.remove('user_${nik}_phone');
        await prefs.remove('user_${nik}_registeredPekerjaan');
        await prefs.remove('user_${nik}_registeredNamaKeluarga');
        await prefs.remove('user_${nik}_registeredNoHPKeluarga');
        await prefs.remove('user_${nik}_registeredAsuransi');
        await prefs.remove('user_${nik}_registeredPoli');
        await prefs.remove('user_${nik}_registeredJadwal');
        await prefs.remove('user_${nik}_registeredKeluhan');
        await prefs.remove('user_${nik}_nomorAntrian_RAJAL');
        await prefs.remove('rajalWaktuRegistrasi');
        break;

      case 'RANAP':
        await prefs.remove('user_${nik}_ranapName');
        await prefs.remove('user_${nik}_ranapNIK');
        await prefs.remove('user_${nik}_ranapNoKK');
        await prefs.remove('user_${nik}_ranapTempatLahir');
        await prefs.remove('user_${nik}_ranapTanggalLahir');
        await prefs.remove('user_${nik}_ranapGender');
        await prefs.remove('user_${nik}_ranapAgama');
        await prefs.remove('user_${nik}_ranapStatus');
        await prefs.remove('user_${nik}_ranapGolDarah');
        await prefs.remove('user_${nik}_ranapAlamat');
        await prefs.remove('user_${nik}_ranapNoHP');
        await prefs.remove('user_${nik}_ranapPekerjaan');
        await prefs.remove('user_${nik}_ranapKelas');
        await prefs.remove('user_${nik}_ranapTipeKamar');
        await prefs.remove('user_${nik}_ranapAsuransi');
        await prefs.remove('user_${nik}_ranapDokter');
        await prefs.remove('user_${nik}_ranapRuangan');
        await prefs.remove('user_${nik}_ranapCaraMasuk');
        await prefs.remove('user_${nik}_ranapDiagnosis');
        await prefs.remove('user_${nik}_ranapKeluhan');
        await prefs.remove('user_${nik}_ranapRiwayatPenyakit');
        await prefs.remove('user_${nik}_ranapObatDikonsumsi');
        await prefs.remove('user_${nik}_ranapRiwayatAlergi');
        await prefs.remove('user_${nik}_ranapRiwayatOperasi');
        await prefs.remove('user_${nik}_ranapJenisAlergi');
        await prefs.remove('user_${nik}_ranapJenisOperasi');
        await prefs.remove('user_${nik}_ranapNamaKeluarga');
        await prefs.remove('user_${nik}_ranapNoHPKeluarga');
        await prefs.remove('user_${nik}_ranapAlamatKeluarga');
        await prefs.remove('user_${nik}_ranapHubunganKeluarga');
        await prefs.remove('user_${nik}_ranapNamaWali');
        await prefs.remove('user_${nik}_ranapNoHPWali');
        await prefs.remove('user_${nik}_ranapHubunganWali');
        await prefs.remove('user_${nik}_ranapPenanggungJawab');
        await prefs.remove('user_${nik}_nomorAntrian_RANAP');
        await prefs.remove('ranapWaktuRegistrasi');
        break;

      case 'MCU':
        await prefs.remove('user_${nik}_mcuName');
        await prefs.remove('user_${nik}_mcuNIK');
        await prefs.remove('user_${nik}_mcuTempatLahir');
        await prefs.remove('user_${nik}_mcuTanggalLahir');
        await prefs.remove('user_${nik}_mcuGender');
        await prefs.remove('user_${nik}_mcuAgama');
        await prefs.remove('user_${nik}_mcuStatus');
        await prefs.remove('user_${nik}_mcuGolDarah');
        await prefs.remove('user_${nik}_mcuAlamat');
        await prefs.remove('user_${nik}_mcuNoHP');
        await prefs.remove('user_${nik}_mcuEmail');
        await prefs.remove('user_${nik}_mcuPekerjaan');
        await prefs.remove('user_${nik}_mcuNamaPerusahaan');
        await prefs.remove('user_${nik}_mcuAlamatPerusahaan');
        await prefs.remove('user_${nik}_mcuPaket');
        await prefs.remove('user_${nik}_mcuTujuan');
        await prefs.remove('user_${nik}_mcuWaktu');
        await prefs.remove('user_${nik}_mcuPembayaran');
        await prefs.remove('user_${nik}_mcuRiwayatPenyakit');
        await prefs.remove('user_${nik}_mcuObatDikonsumsi');
        await prefs.remove('user_${nik}_mcuKeluhan');
        await prefs.remove('user_${nik}_mcuPuasa');
        await prefs.remove('user_${nik}_mcuRiwayatOperasi');
        await prefs.remove('user_${nik}_mcuRiwayatAlergi');
        await prefs.remove('user_${nik}_mcuMerokok');
        await prefs.remove('user_${nik}_mcuAlkohol');
        await prefs.remove('user_${nik}_mcuJenisAlergi');
        await prefs.remove('user_${nik}_mcuJenisOperasi');
        await prefs.remove('user_${nik}_mcuKontakDarurat');
        await prefs.remove('user_${nik}_mcuNoHPKontakDarurat');
        await prefs.remove('user_${nik}_nomorAntrian_MCU');
        await prefs.remove('mcuWaktuRegistrasi');
        break;

      case 'IGD':
        await prefs.remove('user_${nik}_igdName');
        await prefs.remove('user_${nik}_igdNIK');
        await prefs.remove('user_${nik}_igdUmur');
        await prefs.remove('user_${nik}_igdGender');
        await prefs.remove('user_${nik}_igdAlamat');
        await prefs.remove('user_${nik}_igdNoHP');
        await prefs.remove('user_${nik}_igdKeluhan');
        await prefs.remove('user_${nik}_igdTriase');
        await prefs.remove('user_${nik}_igdCaraDatang');
        await prefs.remove('user_${nik}_igdAsuransi');
        await prefs.remove('user_${nik}_igdKesadaran');
        await prefs.remove('user_${nik}_igdRiwayatPenyakit');
        await prefs.remove('user_${nik}_igdObatDikonsumsi');
        await prefs.remove('user_${nik}_igdRiwayatAlergi');
        await prefs.remove('user_${nik}_igdJenisAlergi');
        await prefs.remove('user_${nik}_igdNamaKeluarga');
        await prefs.remove('user_${nik}_igdNoHPKeluarga');
        await prefs.remove('user_${nik}_igdHubunganKeluarga');
        await prefs.remove('user_${nik}_nomorAntrian_IGD');
        await prefs.remove('igdWaktuRegistrasi');
        break;
    }
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Batalkan Janji?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Apakah Anda yakin ingin membatalkan janji ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Tidak",
                style: TextStyle(color: Colors.black87),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () async {
                Navigator.pop(context); // Tutup modal

                final prefs = await SharedPreferences.getInstance();
                final nik = prefs.getString('current_nik');

                if (nik != null) {
                  await _hapusDataRegistrasiByJenis(nik, jenis);
                }

                // ✅ Info ke user
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Registrasi $jenis berhasil dibatalkan dan data dihapus",
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                );

                // ✅ Arahkan ke Home setelah batal
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home', // ganti dengan route Home kamu
                  (route) => false,
                );
              },
              child: const Text(
                "Ya, Batalkan",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF64748B)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            ),
          ),
        ],
      ),
    );
  }
}
