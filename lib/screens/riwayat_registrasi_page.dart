import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RiwayatRegistrasiPage extends StatefulWidget {
  const RiwayatRegistrasiPage({super.key});

  @override
  State<RiwayatRegistrasiPage> createState() => _RiwayatRegistrasiPageState();
}

class _RiwayatRegistrasiPageState extends State<RiwayatRegistrasiPage> {
  Map<String, Map<String, String>> _allData = {};

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _allData = {
        "MCU": {
          "Nomor Antrian": prefs.getString('nomorAntrian_MCU') ?? "-",
          "Nama": prefs.getString('mcuName') ?? "-",
          "Paket": prefs.getString('mcuPaket') ?? "-",
          "Tujuan": prefs.getString('mcuTujuan') ?? "-",
          "Waktu Registrasi": prefs.getString('mcuWaktuRegistrasi') ?? "-",
        },
        "IGD": {
          "Nomor Antrian": prefs.getString('nomorAntrian_IGD') ?? "-",
          "Nama": prefs.getString('igdName') ?? "-",
          "Keluhan": prefs.getString('igdKeluhan') ?? "-",
          "Triase": prefs.getString('igdTriase') ?? "-",
          "Waktu Registrasi": prefs.getString('igdWaktuRegistrasi') ?? "-",
        },
        "Rawat Jalan": {
          "Nomor Antrian": prefs.getString('nomorAntrian_RAJAL') ?? "-",
          "Nama": prefs.getString('registeredName') ?? "-",
          "Poli": prefs.getString('registeredPoli') ?? "-",
          "Jadwal": prefs.getString('registeredJadwal') ?? "-",
          "Keluhan": prefs.getString('registeredKeluhan') ?? "-",
        },
        "Rawat Inap": {
          "Nomor Antrian": prefs.getString('nomorAntrian_RANAP') ?? "-",
          "Nama": prefs.getString('ranapName') ?? "-",
          "Kelas": prefs.getString('ranapKelas') ?? "-",
          "Ruangan": prefs.getString('ranapRuangan') ?? "-",
          "Waktu Registrasi": prefs.getString('ranapWaktuRegistrasi') ?? "-",
        },
      };
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "Riwayat Registrasi",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          _allData.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                padding: const EdgeInsets.all(16),
                children:
                    _allData.entries
                        .where((entry) {
                          // cek kalau masih ada data yang bukan "-"
                          return entry.value.values.any((v) => v != "-");
                        })
                        .map((entry) {
                          String kategori = entry.key;
                          Map<String, String> data = entry.value;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    kategori,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ...data.entries
                                      .where(
                                        (e) => e.value != "-",
                                      ) // hanya tampilkan field yang ada isinya
                                      .map(
                                        (e) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 2,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Text(
                                                  e.key,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Text(e.value),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                            ),
                          );
                        })
                        .toList(),
              ),
    );
  }
}
