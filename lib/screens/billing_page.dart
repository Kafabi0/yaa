import 'package:flutter/material.dart';

class BillingPage extends StatefulWidget {
  final int initialTabIndex;

  const BillingPage({Key? key, this.initialTabIndex = 0}) : super(key: key);

  @override
  State<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  int _selectedTab = 0; // 0 = semua, 1 = belum lunas, 2 = lunas, 3 = terlambat

  // ✅ Data dummy untuk testing
  final List<Map<String, dynamic>> _allBills = [
    {
      "invoice": "INV-2023-001",
      "service": "Rawat Jalan",
      "date": "15 Sep 2023",
      "amount": "Rp. 350.000",
      "isPaid": false,
      "isLate": false,
    },
    {
      "invoice": "INV-2023-002",
      "service": "Rawat Inap",
      "date": "10 Sep 2023",
      "amount": "Rp. 350.000",
      "isPaid": true,
      "isLate": false,
    },
    {
      "invoice": "INV-2023-003",
      "service": "MCU",
      "date": "5 Sep 2023",
      "amount": "Rp. 350.000",
      "isPaid": false,
      "isLate": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // 🔥 Filter data sesuai tab
    List<Map<String, dynamic>> filteredBills = _allBills.where((bill) {
      if (_selectedTab == 1) return bill["isPaid"] == false && bill["isLate"] == false; // Belum Lunas
      if (_selectedTab == 2) return bill["isPaid"] == true; // Lunas
      if (_selectedTab == 3) return bill["isLate"] == true; // Terlambat
      return true; // Semua
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔶 Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFFF6B35),
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
                  const Text(
                    "Tagihan / Billing",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // 📊 Ringkasan
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard("Total Tagihan", "Rp.1.500.000"),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSummaryCard("Sudah Dibayar", "Rp.350.000"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard("Menunggu", "2 Tagihan", isOrange: true),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSummaryCard("Terlambat", "0 Tagihan", isRed: true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 🔖 Tabs (Chip)
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

            // 📑 Daftar Tagihan (sudah di-filter)
            Expanded(
              child: filteredBills.isEmpty
                  ? const Center(child: Text("Tidak ada data"))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredBills.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final bill = filteredBills[index];
                        return _buildBillCard(
                          bill["invoice"],
                          bill["service"],
                          bill["date"],
                          bill["amount"],
                          bill["isPaid"],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Widget Ringkasan
  Widget _buildSummaryCard(String title, String value,
      {bool isOrange = false, bool isRed = false}) {
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
          Text(title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isRed
                  ? Colors.red
                  : isOrange
                      ? const Color(0xFFFF6B35)
                      : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Widget Chip Tab
  Widget _buildChipTab(String text, int index) {
    final bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF6B35) : Colors.grey[300],
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

  // 🔹 Widget Kartu Tagihan
  Widget _buildBillCard(String invoice, String service, String date, String amount, bool isPaid) {
    return Container(
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
              Text("No Invoice: $invoice",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPaid ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isPaid ? "Lunas" : "Belum Lunas",
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text("Jenis Layanan: $service",
              style: TextStyle(color: Colors.grey[700], fontSize: 12)),
          const SizedBox(height: 4),
          Text("Tanggal: $date",
              style: TextStyle(color: Colors.grey[700], fontSize: 12)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total: $amount",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              if (!isPaid)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFF6B35)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Pembayaran diproses")),
                    );
                  },
                  child: const Text("Bayar Sekarang",
                      style: TextStyle(color: Color(0xFFFF6B35))),
                ),
            ],
          )
        ],
      ),
    );
  }
}
