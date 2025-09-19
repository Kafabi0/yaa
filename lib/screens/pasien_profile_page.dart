import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inocare/screens/pasien_edit_page.dart';
import '../models/pasien_transaksi.dart';
import '../widgets/pasien_service.dart';
import '../widgets/transaksi_service.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';

class PasienProfilePage extends StatefulWidget {
  final int pasienId;

  const PasienProfilePage({Key? key, required this.pasienId}) : super(key: key);

  @override
  _PasienProfilePageState createState() => _PasienProfilePageState();
}

class _PasienProfilePageState extends State<PasienProfilePage> {
  Pasien? pasienData;
  List<Transaksi> transaksiList = [];
  bool isLoading = true;
  bool isLoadingTransaksi = true;
  bool isPrinting = false; // Status untuk loading cetak PDF

  @override
  void initState() {
    super.initState();
    _loadPasien();
    _loadTransaksi();
  }

  Future<void> _loadPasien() async {
    try {
      final data = await PasienService.getPasienById(widget.pasienId);
      setState(() {
        pasienData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memuat data pasien: $e")));
    }
  }

  Future<void> _loadTransaksi() async {
    try {
      // Ambil semua transaksi dan filter berdasarkan pasienId
      final allTransaksi = await TransaksiService.getTransaksi();
      final filteredTransaksi =
          allTransaksi
              .where((transaksi) => transaksi.pasienId == widget.pasienId)
              .toList();

      // Urutkan berdasarkan tanggal terbaru
      filteredTransaksi.sort(
        (a, b) => DateTime.parse(
          b.tanggalTransaksi,
        ).compareTo(DateTime.parse(a.tanggalTransaksi)),
      );

      setState(() {
        transaksiList = filteredTransaksi;
        isLoadingTransaksi = false;
      });
    } catch (e) {
      setState(() {
        isLoadingTransaksi = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat data transaksi: $e")),
      );
    }
  }

  String _formatCurrency(int amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return dateString;
    }
  }

  int _getTotalTransaksi() {
    return transaksiList.fold(0, (sum, transaksi) => sum + transaksi.total);
  }

  Future<Uint8List> networkImageBytes(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Gagal memuat gambar dari $url');
    }
  }



Future<void> _printProfile() async {
  if (pasienData == null) return;

  setState(() {
    isPrinting = true;
  });

  try {
    final pdf = pw.Document();

    // Load logo
    final logoBytes =
        (await rootBundle.load('assets/images/inotal.png')).buffer.asUint8List();

    // Load profile image jika ada
    Uint8List? profileImageBytes;
    if (pasienData!.foto.isNotEmpty) {
      final fotoUrl =
          pasienData!.foto.startsWith("http")
              ? pasienData!.foto
              : "http://192.168.1.38:8080/${pasienData!.foto.replaceAll("\\", "/")}";
      profileImageBytes = await networkImageBytes(fotoUrl);
    }

    // Tambahkan halaman PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Profil Pasien",
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Image(pw.MemoryImage(logoBytes), width: 80, height: 80),
                ],
              ),
              pw.SizedBox(height: 20),

              // Foto profil
              if (profileImageBytes != null)
                pw.Center(
                  child: pw.Container(
                    width: 100,
                    height: 100,
                    decoration: pw.BoxDecoration(
                      shape: pw.BoxShape.circle,
                      image: pw.DecorationImage(
                        image: pw.MemoryImage(profileImageBytes),
                        fit: pw.BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              pw.SizedBox(height: 16),

              // Nama & NIK
              pw.Text(
                "Nama: ${pasienData!.name}",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                "NIK: ${pasienData!.nik}",
                style: pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 20),

              // Info detail
              pw.Text(
                "Informasi Pasien",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text("Jenis Kelamin: ${pasienData!.jenisKelamin}"),
              pw.Text("Tanggal Lahir: ${pasienData!.tanggalLahir}"),
              pw.Text("Alamat: ${pasienData!.alamat}"),
              pw.Text("No. Telepon: ${pasienData!.noTelp}"),
              pw.Text("Email: ${pasienData!.email}"),
              pw.SizedBox(height: 20),

              // Riwayat Transaksi
              pw.Text(
                "Riwayat Transaksi",
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              if (transaksiList.isNotEmpty) ...[
                pw.Text(
                  "Total: ${_formatCurrency(_getTotalTransaksi())} (${transaksiList.length} transaksi)",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 8),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: transaksiList.map((t) {
                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 4),
                      child: pw.Text(
                        "${_formatDate(t.tanggalTransaksi)} - ${_formatCurrency(t.total)}",
                      ),
                    );
                  }).toList(),
                ),
              ] else
                pw.Text("Belum ada transaksi"),
            ],
          );
        },
      ),
    );

    // Simpan PDF ke temporary folder
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/profil_pasien_${pasienData!.id}.pdf');
    await file.writeAsBytes(await pdf.save());

    // Buka PDF secara langsung
    await OpenFilex.open(file.path);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("PDF berhasil dibuat dan dibuka"),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Gagal membuat PDF: $e"),
        backgroundColor: Colors.red,
      ),
    );
  } finally {
    setState(() {
      isPrinting = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Profil Pasien"),
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
          actions: [
            IconButton(icon: const Icon(Icons.edit), onPressed: null),
            IconButton(icon: const Icon(Icons.print), onPressed: null),
          ],
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (pasienData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Profil Pasien"),
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                "Data pasien tidak ditemukan",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Profil Pasien"),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed:
                isPrinting
                    ? null
                    : () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => PasienEditPage(pasienId: pasienData!.id),
                        ),
                      );

                      if (updated == true) {
                        _loadPasien();
                      }
                    },
            tooltip: "Edit Profil",
          ),
          IconButton(
            icon:
                isPrinting
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : const Icon(Icons.print),
            onPressed: isPrinting ? null : _printProfile,
            tooltip: isPrinting ? "Mencetak..." : "Cetak PDF",
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header dengan foto profil
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.only(bottom: 40, top: 20),
              child: Column(
                children: [
                  // Foto profil dengan border
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          pasienData!.foto.isNotEmpty
                              ? NetworkImage(
                                pasienData!.foto.startsWith("http")
                                    ? pasienData!.foto
                                    : "http://192.168.1.38:8080/${pasienData!.foto.replaceAll("\\", "/")}",
                              )
                              : const AssetImage("assets/nailong.png")
                                  as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    pasienData!.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),

                  // NIK sebagai subtitle
                  Text(
                    "NIK: ${pasienData!.nik}",
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Informasi detail
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Informasi Pasien",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildInfoCard(
                    "Jenis Kelamin",
                    pasienData!.jenisKelamin,
                    Icons.people,
                  ),
                  _buildInfoCard(
                    "Tanggal Lahir",
                    pasienData!.tanggalLahir,
                    Icons.cake,
                  ),
                  _buildInfoCard(
                    "Alamat",
                    pasienData!.alamat,
                    Icons.location_on,
                  ),
                  _buildInfoCard(
                    "No. Telepon",
                    pasienData!.noTelp,
                    Icons.phone,
                  ),
                  _buildInfoCard("Email", pasienData!.email, Icons.email),

                  const SizedBox(height: 32),

                  // Section Transaksi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Riwayat Transaksi",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (!isLoadingTransaksi && transaksiList.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${transaksiList.length} transaksi",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Summary Card
                  if (!isLoadingTransaksi && transaksiList.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green[600]!, Colors.green[400]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.trending_up,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Total Transaksi",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _formatCurrency(_getTotalTransaksi()),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "dari ${transaksiList.length} transaksi",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Loading atau List Transaksi
                  if (isLoadingTransaksi)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (transaksiList.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Belum ada transaksi",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Transaksi akan muncul di sini setelah ditambahkan",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    Column(
                      children:
                          transaksiList
                              .map(
                                (transaksi) => Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.blue[50],
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.receipt,
                                            color: Colors.blue[600],
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    _formatCurrency(
                                                      transaksi.total,
                                                    ),
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.calendar_today,
                                                    size: 16,
                                                    color: Colors.grey[600],
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    _formatDate(
                                                      transaksi
                                                          .tanggalTransaksi,
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[600],
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
                                ),
                              )
                              .toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.blue[600], size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value.isNotEmpty ? value : "-",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
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
}
