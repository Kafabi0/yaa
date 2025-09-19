import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class BillingPaymentsScreen extends StatefulWidget {
  const BillingPaymentsScreen({super.key});

  @override
  State<BillingPaymentsScreen> createState() => _BillingPaymentsScreenState();
}

class _BillingPaymentsScreenState extends State<BillingPaymentsScreen> with TickerProviderStateMixin {
  // Colors that adapt to theme
  Color get primaryColor => Theme.of(context).brightness == Brightness.dark 
      ? const Color(0xFF64B5F6) 
      : const Color(0xFF1565C0);
  
  Color get accentColor => Theme.of(context).brightness == Brightness.dark 
      ? const Color(0xFF81C784) 
      : const Color(0xFF42A5F5);
  
  Color get dangerColor => Theme.of(context).brightness == Brightness.dark 
      ? const Color(0xFFE57373) 
      : const Color(0xFFD32F2F);
  
  Color get paidColor => Theme.of(context).brightness == Brightness.dark 
      ? Colors.green.shade400 
      : Colors.green.shade600;

  Color get cardColor => Theme.of(context).brightness == Brightness.dark 
      ? const Color(0xFF2D2D2D) 
      : Colors.white;

  Color get backgroundColor => Theme.of(context).brightness == Brightness.dark 
      ? const Color(0xFF121212) 
      : Colors.white;

  Color get surfaceColor => Theme.of(context).brightness == Brightness.dark 
      ? const Color(0xFF1E1E1E) 
      : Colors.white;

  late AnimationController _animationController;
  String selectedFilter = 'Semua';

  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> bills = [
    {
      'id': 'INV-2025-001',
      'patient': 'Budi Santoso',
      'patientId': 'P001234',
      'service': 'Konsultasi Penyakit Dalam',
      'doctor': 'Dr. Sarah Wijaya, Sp.PD',
      'amount': 350000,
      'isPaid': false,
    },
    {
      'id': 'INV-2025-002',
      'patient': 'Siti Aminah',
      'patientId': 'P005678',
      'service': 'Pemeriksaan Laboratorium',
      'doctor': 'Laboratorium Inocare',
      'amount': 250000,
      'isPaid': false,
    },
    {
      'id': 'INV-2025-003',
      'patient': 'Joko Susilo',
      'patientId': 'P009012',
      'service': 'Rawat Inap 3 Hari',
      'doctor': 'Dr. Bayu Wicaksono, Sp.P',
      'amount': 2500000,
      'isPaid': true,
    },
    {
      'id': 'INV-2025-004',
      'patient': 'Wulan Sari',
      'patientId': 'P007788',
      'service': 'Vaksinasi Influenza',
      'doctor': 'Dr. Budi Pratama, Sp.A',
      'amount': 150000,
      'isPaid': false,
    },
  ];

  List<Map<String, dynamic>> filteredBills = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    filteredBills = bills;
    _searchController.addListener(_filterBills);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterBills() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      filteredBills = bills.where((bill) {
        final patientName = bill['patient'].toLowerCase();
        final isMatchingSearch = patientName.contains(query);
        final isMatchingFilter = selectedFilter == 'Semua' ||
            (selectedFilter == 'Lunas' && bill['isPaid']) ||
            (selectedFilter == 'Belum Bayar' && !bill['isPaid']);

        return isMatchingSearch && isMatchingFilter;
      }).toList();
    });
  }

  void _showReceiptDialog(Map<String, dynamic> bill) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: surfaceColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            "Kuitansi Pembayaran", 
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            )
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildReceiptDetail("Nomor Kuitansi:", bill['id']),
                _buildReceiptDetail("Nama Pasien:", bill['patient']),
                _buildReceiptDetail("ID Pasien:", bill['patientId']),
                Divider(color: isDarkMode ? Colors.grey[600] : Colors.grey[300]),
                _buildReceiptDetail("Layanan:", bill['service']),
                _buildReceiptDetail("Dokter:", bill['doctor']),
                _buildReceiptDetail("Jumlah Pembayaran:", "Rp ${bill['amount']}"),
                _buildReceiptDetail("Status:", "LUNAS"),
                _buildReceiptDetail("Tanggal Pembayaran:", "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Tutup',
                style: TextStyle(color: primaryColor),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final pdfFile = await _generateFormalReceiptPdf(bill);
                await _saveAndOpenPdf(pdfFile, "Kuitansi_${bill['id']}.pdf");
              },
              icon: const Icon(Icons.download),
              label: const Text('Unduh PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: isDarkMode ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReceiptDetail(String title, String value) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title, 
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500, 
              color: isDarkMode ? Colors.grey[400] : Colors.black54
            )
          ),
          Text(
            value, 
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            )
          ),
        ],
      ),
    );
  }

  Future<Uint8List> _generateFormalReceiptPdf(Map<String, dynamic> bill) async {
    final pdf = pw.Document();

    // Load custom fonts
    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);
    final fontBoldData = await rootBundle.load("assets/fonts/Roboto-Bold.ttf");
    final ttfBold = pw.Font.ttf(fontBoldData);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // HEADER FORMAL
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "RUMAH SAKIT INOCARE",
                        style: pw.TextStyle(
                          font: ttfBold,
                          fontSize: 22,
                          color: PdfColor.fromInt(0xFF1565C0),
                          letterSpacing: 1.5,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text("Jl. Pratista No. 12, Bandung, Jawa Barat",
                          style: pw.TextStyle(font: ttf, fontSize: 10)),
                      pw.Text("Telp: +62-21-12345678",
                          style: pw.TextStyle(font: ttf, fontSize: 10)),
                    ],
                  ),
                  pw.Text(
                    "KUITANSI PEMBAYARAN",
                    style: pw.TextStyle(
                        font: ttfBold, fontSize: 18, color: PdfColors.grey800),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Divider(color: PdfColors.grey600, thickness: 1),
              pw.SizedBox(height: 16),

              // DETAIL PASIEN & TAGIHAN
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Nama Pasien:", style: pw.TextStyle(font: ttf, fontSize: 10, color: PdfColors.grey600)),
                      pw.Text(bill['patient'], style: pw.TextStyle(font: ttfBold, fontSize: 12)),
                      pw.SizedBox(height: 4),
                      pw.Text("ID Pasien:", style: pw.TextStyle(font: ttf, fontSize: 10, color: PdfColors.grey600)),
                      pw.Text(bill['patientId'], style: pw.TextStyle(font: ttfBold, fontSize: 12)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text("No. Kuitansi:", style: pw.TextStyle(font: ttf, fontSize: 10, color: PdfColors.grey600)),
                      pw.Text(bill['id'], style: pw.TextStyle(font: ttfBold, fontSize: 12)),
                      pw.SizedBox(height: 4),
                      pw.Text("Tanggal:", style: pw.TextStyle(font: ttf, fontSize: 10, color: PdfColors.grey600)),
                      pw.Text(
                          "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                          style: pw.TextStyle(font: ttfBold, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 24),

              // TABEL LAYANAN
              pw.Table.fromTextArray(
                headers: ['Deskripsi Layanan', 'Dokter', 'Jumlah'],
                data: [
                  [bill['service'], bill['doctor'], "Rp ${bill['amount']}"],
                ],
                border: pw.TableBorder.all(color: PdfColors.grey400),
                headerStyle: pw.TextStyle(font: ttfBold, fontSize: 12, color: PdfColors.white),
                headerDecoration: pw.BoxDecoration(color: PdfColor.fromInt(0xFF1565C0)),
                cellStyle: pw.TextStyle(font: ttf, fontSize: 11),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(1.5),
                },
              ),
              pw.SizedBox(height: 16),

              // TOTAL BAYAR
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromInt(0xFF1565C0),
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Text(
                    "Total: Rp ${bill['amount']}",
                    style: pw.TextStyle(font: ttfBold, fontSize: 14, color: PdfColors.white),
                  ),
                ),
              ),
              pw.SizedBox(height: 24),

              // METODE PEMBAYARAN & TANDA TANGAN
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Metode Pembayaran", style: pw.TextStyle(font: ttf, fontSize: 10, color: PdfColors.grey600)),
                      pw.Text("Transfer Bank", style: pw.TextStyle(font: ttfBold, fontSize: 12)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text("Bandung, ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                          style: pw.TextStyle(font: ttf, fontSize: 10, color: PdfColors.grey600)),
                      pw.SizedBox(height: 40),
                      pw.Text("Petugas Kasir", style: pw.TextStyle(font: ttfBold, fontSize: 12)),
                    ],
                  ),
                ],
              ),

              pw.Spacer(),

              // CATATAN FORMAL
              pw.Text(
                "Catatan: Kuitansi ini sah dan berlaku sebagai bukti pembayaran resmi.",
                style: pw.TextStyle(font: ttf, fontSize: 9, color: PdfColors.grey600),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> _saveAndOpenPdf(Uint8List pdfBytes, String fileName) async {
    try {
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/$fileName');
      await file.writeAsBytes(pdfBytes);

      await OpenFilex.open(file.path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan atau membuka file PDF: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Header section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              color: surfaceColor,
              boxShadow: [
                BoxShadow(
                  color: (isDarkMode ? Colors.black : Colors.grey).withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back, 
                        color: isDarkMode ? Colors.white : Colors.black87
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'Billing & Payment',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    Row(
                      children: [
                        
                        IconButton(
                          icon: Icon(
                            Icons.notifications, 
                            color: isDarkMode ? Colors.white : Colors.black
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ]
                ),
              
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: primaryColor.withOpacity(0.2),
                          child: Icon(Icons.person, color: primaryColor, size: 28),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PEMBAYARAN',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.grey[300] : Colors.black54,
                              ),
                            ),
                            Text(
                              'Petugas Kasir',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  style: GoogleFonts.inter(
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Cari Pasien...',
                    hintStyle: GoogleFonts.inter(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey
                    ),
                    prefixIcon: Icon(
                      Icons.search, 
                      color: isDarkMode ? Colors.grey[400] : Colors.grey
                    ),
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
          
          // Filter section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['Semua', 'Belum Bayar', 'Lunas'].map((filter) {
                bool isSelected = selectedFilter == filter;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilter = filter;
                      _filterBills();
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? primaryColor 
                          : (isDarkMode ? Colors.grey[700] : Colors.grey[100]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      filter,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: isSelected 
                            ? (isDarkMode ? Colors.black : Colors.white)
                            : (isDarkMode ? Colors.white : Colors.black87),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Bill list section
          Expanded(
            child: filteredBills.isEmpty
                ? Center(
                    child: Text(
                      "Tidak ada tagihan ditemukan.",
                      style: GoogleFonts.inter(
                        fontSize: 16, 
                        color: isDarkMode ? Colors.grey[400] : Colors.grey
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredBills.length,
                    itemBuilder: (context, index) {
                      final bill = filteredBills[index];
                      bool isPaid = bill['isPaid'];
                      final billCardColor = isPaid 
                          ? (isDarkMode ? Colors.green.shade900.withOpacity(0.3) : Colors.green.shade50)
                          : cardColor;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: isDarkMode ? 2 : 4,
                        color: billCardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Left side content
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bill['patient'],
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: isDarkMode ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    bill['service'],
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: isDarkMode ? Colors.grey[300] : Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Rp ${bill['amount']}',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              // Right side content
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isPaid ? paidColor : dangerColor,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      isPaid ? 'LUNAS' : 'BELUM BAYAR',
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  if (!isPaid)
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          bill['isPaid'] = true;
                                        });
                                        _filterBills();
                                        _showReceiptDialog(bill);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        foregroundColor: isDarkMode ? Colors.black : Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        elevation: 2,
                                      ),
                                      child: Text(
                                        'BAYAR', 
                                        style: GoogleFonts.inter(fontWeight: FontWeight.w600)
                                      ),
                                    )
                                  else
                                    ElevatedButton(
                                      onPressed: () {
                                        _showReceiptDialog(bill);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                                        foregroundColor: primaryColor,
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        elevation: 2,
                                      ),
                                      child: Text(
                                        'LIHAT', 
                                        style: GoogleFonts.inter(fontWeight: FontWeight.w600)
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Dummy page untuk navigasi
class DummyPage extends StatelessWidget {
  final String title;
  const DummyPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          "Ini halaman $title",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}