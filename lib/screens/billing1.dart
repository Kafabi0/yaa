import 'package:flutter/material.dart';
import 'package:inocare/screens/BillingDetailPage.dart';

class BillingPage1 extends StatefulWidget {
  final String patientName;
  final Map registrations;

  const BillingPage1({
    super.key,
    required this.patientName,
    required this.registrations,
  });

  @override
  State<BillingPage1> createState() => _BillingPage1State();
}

class _BillingPage1State extends State<BillingPage1> {
  int _selectedTab = 0; // 0 = semua, 1 = belum lunas, 2 = lunas, 3 = terlambat

  void _markAsPaid(String invoice) {
    setState(() {
      final index = _allBills.indexWhere((bill) => bill["invoice"] == invoice);
      if (index != -1) {
        _allBills[index]["isPaid"] = true;
        _allBills[index]["isLate"] =
            false; // kalau bayar, otomatis tidak terlambat
      }
    });
  }

  // Data billing untuk pasien
  final List<Map<String, dynamic>> _allBills = [
    {
      "invoice": "INV-2025-001234",
      "service": "Registrasi IGD",
      "date": "22 Sep 2025",
      "amount": "Rp. 150.000",
      "isPaid": false,
      "isLate": false,
      "description": "Biaya pendaftaran pasien IGD",
      "time": "08:30",
    },
    {
      "invoice": "INV-2025-001235",
      "service": "Pemeriksaan Dokter",
      "date": "22 Sep 2025",
      "amount": "Rp. 200.000",
      "isPaid": true,
      "isLate": false,
      "description": "Konsultasi dokter spesialis",
      "time": "09:15",
    },
    {
      "invoice": "INV-2025-001236",
      "service": "Obat-obatan",
      "date": "22 Sep 2025",
      "amount": "Rp. 350.000",
      "isPaid": false,
      "isLate": false,
      "description": "Paracetamol, Amoxicillin, Vitamin",
      "time": "10:00",
    },
    {
      "invoice": "INV-2025-001237",
      "service": "Laboratorium",
      "date": "22 Sep 2025",
      "amount": "Rp. 250.000",
      "isPaid": false,
      "isLate": true,
      "description": "Tes darah lengkap, Urine",
      "time": "10:30",
    },
    {
      "invoice": "INV-2025-001238",
      "service": "Radiologi",
      "date": "22 Sep 2025",
      "amount": "Rp. 400.000",
      "isPaid": false,
      "isLate": false,
      "description": "Rontgen dada, CT-Scan",
      "time": "11:00",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter data sesuai tab
    List<Map<String, dynamic>> filteredBills =
        _allBills.where((bill) {
          if (_selectedTab == 1)
            return bill["isPaid"] == false &&
                bill["isLate"] == false; // Belum Lunas
          if (_selectedTab == 2) return bill["isPaid"] == true; // Lunas
          if (_selectedTab == 3) return bill["isLate"] == true; // Terlambat
          return true; // Semua
        }).toList();

    // Hitung summary
    int totalAmount = 0;
    int paidAmount = 0;
    int unpaidCount = 0;
    int lateCount = 0;

    for (var bill in _allBills) {
      int amount = int.parse(bill["amount"].replaceAll(RegExp(r'[^\d]'), ''));
      totalAmount += amount;

      if (bill["isPaid"]) {
        paidAmount += amount;
      } else {
        unpaidCount++;
        if (bill["isLate"]) {
          lateCount++;
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF1976D2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Tagihan Pasien",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.patientName,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Ringkasan
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      "Total Tagihan",
                      "Rp. ${_formatCurrency(totalAmount)}",
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSummaryCard(
                      "Sudah Dibayar",
                      "Rp. ${_formatCurrency(paidAmount)}",
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      "Menunggu",
                      "$unpaidCount Tagihan",
                      isOrange: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSummaryCard(
                      "Terlambat",
                      "$lateCount Tagihan",
                      isRed: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tabs (Chip)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildChipTab("Semua", 0),
                  _buildChipTab("Belum Lunas", 1),
                  _buildChipTab("Lunas", 2),
                  _buildChipTab("Terlambat", 3),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Daftar Tagihan (sudah di-filter)
            Expanded(
              child:
                  filteredBills.isEmpty
                      ? const Center(child: Text("Tidak ada data"))
                      : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredBills.length,
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final bill = filteredBills[index];
                          return _buildBillCard(
                            bill["invoice"],
                            bill["service"],
                            bill["date"],
                            bill["amount"],
                            bill["isPaid"],
                            bill["isLate"],
                            bill["description"],
                            bill["time"],
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Ringkasan
  Widget _buildSummaryCard(
    String title,
    String value, {
    bool isOrange = false,
    bool isRed = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color:
                  isRed
                      ? Colors.red
                      : isOrange
                      ? const Color(0xFF1976D2)
                      : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Widget Chip Tab
  Widget _buildChipTab(String text, int index) {
    final bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1976D2) : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Widget Kartu Tagihan
  Widget _buildBillCard(
    String invoice,
    String service,
    String date,
    String amount,
    bool isPaid,
    bool isLate,
    String description,
    String time,
  ) {
    final bill = {
      "invoice": invoice,
      "service": service,
      "date": date,
      "amount": amount,
      "isPaid": isPaid,
      "isLate": isLate,
      "description": description,
      "time": time,
    };

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BillingDetailPage(bill: bill)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // No Invoice + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "No Invoice: $invoice",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isPaid
                            ? Colors.green
                            : isLate
                            ? Colors.red
                            : const Color(0xFF1976D2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isPaid
                        ? "Lunas"
                        : isLate
                        ? "Terlambat"
                        : "Belum Lunas",
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Text(
              "Jenis Layanan: $service",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),

            const SizedBox(height: 4),
            Text(
              "Deskripsi: $description",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),

            const SizedBox(height: 4),
            Text(
              "Tanggal: $date • $time",
              style: TextStyle(color: Colors.grey[700], fontSize: 12),
            ),

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: $amount",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (!isPaid)
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF1976D2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      _showPaymentDialog(invoice, service, amount);
                    },
                    child: const Text(
                      "Bayar Sekarang",
                      style: TextStyle(color: Color(0xFF1976D2)),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentDialog(String invoice, String service, String amount) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Konfirmasi Pembayaran"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Invoice: $invoice"),
                Text("Layanan: $service"),
                Text("Total: $amount"),
                const SizedBox(height: 8),
                const Text("Apakah Anda yakin ingin melakukan pembayaran?"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _markAsPaid(invoice);

                  final paidBill = _allBills.firstWhere(
                    (bill) => bill["invoice"] == invoice,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BillingDetailPage(bill: paidBill),
                    ),
                  );
                },
                child: const Text(
                  "Bayar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
