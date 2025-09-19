import 'package:flutter/material.dart';
import 'package:inocare/screens/stok_barang.dart';
import '../screens/farmasi_screen.dart';

class RajalScreen extends StatefulWidget {
  const RajalScreen({super.key});

  @override
  State<RajalScreen> createState() => _RajalScreenState();
}

class _RajalScreenState extends State<RajalScreen> {
  String selectedTab = "transaction";
  String? selectedRuangan;
  bool isCardView = true;
  String? expandedMenu;
  String? selectedOrderType;
  DateTime? selectedDate;
  
  final Map<String, Widget> pageMap = {
    "Proses Order": const FarmasiScreen(),
    "Proses Amprah": const FarmasiScreen(),
    "Proses Order Obat": const RajalScreen(),
    "Master Barang": const FarmasiScreen(),
    "Stok Barang Farmasi": const StokBarangScreen(),
    "Penerimaan Barang": const FarmasiScreen(),
    "Pengeluaran Barang": const FarmasiScreen(),
    "Stok Opname": const FarmasiScreen(),
    "Laporan": const FarmasiScreen(),
    "Barang Produksi": const FarmasiScreen(),
  };
  
  final List<Map<String, dynamic>> menuItems = [
    {
      "title": "Proses Order",
      "icon": Icons.shopping_cart,
      "color": Colors.orange,
      "children": ["Proses Amprah", "Proses Order Obat"],
    },
    {"title": "Master Barang", "icon": Icons.inventory_2, "color": Colors.teal},
    {
      "title": "Stok Barang Farmasi",
      "icon": Icons.medical_services,
      "color": Colors.purple,
    },
    {
      "title": "Penerimaan Barang",
      "icon": Icons.download,
      "color": Colors.blue,
    },
    {"title": "Pengeluaran Barang", "icon": Icons.upload, "color": Colors.red},
    {"title": "Stok Opname", "icon": Icons.fact_check, "color": Colors.brown},
    {"title": "Laporan", "icon": Icons.bar_chart, "color": Colors.deepOrange},
    {
      "title": "Barang Produksi",
      "icon": Icons.production_quantity_limits,
      "color": Colors.cyan,
    },
  ];
  
  final List<String> ruanganOptions = [
    "Pilih Ruangan",
    "Poli Umum",
    "Poli Gigi",
    "Poli Anak",
  ];

  // Data untuk tab transaction (aktif)
  final List<Map<String, dynamic>> transactionData = [
    {
      'nama': 'HJ ROHANI',
      'noRM': '00729536',
      'noAntrian': 'RF1-005',
      'noAntrianAPM': null,
      'noResep': '20250904085234348360',
      'namaDPJP': 'dr. Misar Ersanto, Sp.B(K)Onk',
      'tanggal': '2025-09-04',
      'waktuOrder': '08:52:25',
      'status': 'BUAT',
      'statusColor': Color(0xFF2196F3),
      'nomor': 1,
      'prioritas': true,
      'keterangan': 'Pasien sudah datang',
      'isBPJS': true,
    },
    {
      'nama': 'DESY SYAFLITA',
      'noRM': '00616549',
      'noAntrian': 'GI7-012',
      'noAntrianAPM': '8055',
      'noResep': '20250904085612565520',
      'namaDPJP': 'dr. Misar Ersanto, Sp.B(K)Onk',
      'tanggal': '2025-09-04',
      'waktuOrder': '08:47:32',
      'status': 'PROSES',
      'statusColor': Color(0xFFFF9800),
      'nomor': 2,
      'prioritas': false,
      'keterangan': 'Sedang diproses',
      'isBPJS': true,
    },
    {
      'nama': 'SULISTIANA',
      'noRM': '00876890',
      'noAntrian': 'PU2-007',
      'noAntrianAPM': '1012',
      'noResep': '20250904084729277767',
      'namaDPJP': 'dr. Misar Ersanto, Sp.B(K)Onk',
      'tanggal': '2025-09-04',
      'waktuOrder': '08:47:29',
      'status': 'BUAT',
      'statusColor': Color(0xFF2196F3),
      'nomor': 3,
      'prioritas': true,
      'keterangan': 'Pasien sudah datang',
      'isBPJS': true,
    },
    {
      'nama': 'BUDI SANTOSO',
      'noRM': '00543210',
      'noAntrian': 'PG3-015',
      'noAntrianAPM': null,
      'noResep': '20250904082345678901',
      'namaDPJP': 'drg. Wulan Sari, Sp.KG',
      'tanggal': '2025-09-04',
      'waktuOrder': '08:30:15',
      'status': 'PROSES',
      'statusColor': Color(0xFFFF9800),
      'nomor': 4,
      'prioritas': false,
      'keterangan': 'Sedang diproses',
      'isBPJS': false,
    },
  ];

  // Data untuk tab history (selesai)
  final List<Map<String, dynamic>> historyData = [
    {
      'nama': 'SITI NURHALIZA',
      'noRM': '00445678',
      'noAntrian': 'RF1-001',
      'noAntrianAPM': '2001',
      'noResep': '20250903094523456789',
      'namaDPJP': 'dr. Ahmad Subandi, Sp.PD',
      'tanggal': '2025-09-03',
      'waktuOrder': '09:45:23',
      'status': 'SELESAI',
      'statusColor': Color(0xFF4CAF50),
      'nomor': 1,
      'prioritas': false,
      'keterangan': 'Obat sudah diserahkan',
      'isBPJS': true,
      'waktuSelesai': '10:30:15',
    },
    {
      'nama': 'RAHMAN HIDAYAT',
      'noRM': '00567890',
      'noAntrian': 'GI7-008',
      'noAntrianAPM': null,
      'noResep': '20250903083456789012',
      'namaDPJP': 'drg. Melati Putri, Sp.KG',
      'tanggal': '2025-09-03',
      'waktuOrder': '08:34:56',
      'status': 'SELESAI',
      'statusColor': Color(0xFF4CAF50),
      'nomor': 2,
      'prioritas': true,
      'keterangan': 'Obat sudah diserahkan',
      'isBPJS': true,
      'waktuSelesai': '09:15:30',
    },
    {
      'nama': 'MARIA GONZALES',
      'noRM': '00234567',
      'noAntrian': 'PU2-003',
      'noAntrianAPM': '5678',
      'noResep': '20250902101234567890',
      'namaDPJP': 'dr. Bambang Sutrisno, Sp.OG',
      'tanggal': '2025-09-02',
      'waktuOrder': '10:12:34',
      'status': 'SELESAI',
      'statusColor': Color(0xFF4CAF50),
      'nomor': 3,
      'prioritas': false,
      'keterangan': 'Obat sudah diserahkan',
      'isBPJS': false,
      'waktuSelesai': '11:05:45',
    },
    {
      'nama': 'ANDI WIJAYA',
      'noRM': '00987654',
      'noAntrian': 'PA1-012',
      'noAntrianAPM': null,
      'noResep': '20250902084567890123',
      'namaDPJP': 'dr. Indra Wijaya, Sp.A',
      'tanggal': '2025-09-02',
      'waktuOrder': '08:45:67',
      'status': 'SELESAI',
      'statusColor': Color(0xFF4CAF50),
      'nomor': 4,
      'prioritas': false,
      'keterangan': 'Obat sudah diserahkan',
      'isBPJS': true,
      'waktuSelesai': '09:30:20',
    },
  ];

  // Data untuk tab pending transaction (tertunda)
  final List<Map<String, dynamic>> pendingData = [
    {
      'nama': 'KARTINI SARI',
      'noRM': '00112233',
      'noAntrian': 'RF1-020',
      'noAntrianAPM': '9988',
      'noResep': '20250903151234567890',
      'namaDPJP': 'dr. Surya Pratama, Sp.JP',
      'tanggal': '2025-09-03',
      'waktuOrder': '15:12:34',
      'status': 'PENDING',
      'statusColor': Color(0xFFF44336),
      'nomor': 1,
      'prioritas': true,
      'keterangan': 'Menunggu konfirmasi dokter',
      'isBPJS': true,
      'alasanPending': 'Dosis obat perlu konfirmasi ulang',
    },
    {
      'nama': 'JOKO WIDODO',
      'noRM': '00445566',
      'noAntrian': 'PU2-025',
      'noAntrianAPM': null,
      'noResep': '20250903142345678901',
      'namaDPJP': 'dr. Ratna Dewi, Sp.S',
      'tanggal': '2025-09-03',
      'waktuOrder': '14:23:45',
      'status': 'PENDING',
      'statusColor': Color(0xFFF44336),
      'nomor': 2,
      'prioritas': false,
      'keterangan': 'Stok obat tidak tersedia',
      'isBPJS': false,
      'alasanPending': 'Obat habis, menunggu restock',
    },
    {
      'nama': 'LINDA MARLINA',
      'noRM': '00778899',
      'noAntrian': 'GI7-030',
      'noAntrianAPM': '7766',
      'noResep': '20250902163456789012',
      'namaDPJP': 'drg. Anton Setiawan, Sp.BM',
      'tanggal': '2025-09-02',
      'waktuOrder': '16:34:56',
      'status': 'PENDING',
      'statusColor': Color(0xFFF44336),
      'nomor': 3,
      'prioritas': true,
      'keterangan': 'Menunggu persetujuan asuransi',
      'isBPJS': true,
      'alasanPending': 'Verifikasi BPJS diperlukan',
    },
  ];

  // Fungsi untuk mendapatkan data berdasarkan tab yang dipilih
  List<Map<String, dynamic>> get currentData {
    switch (selectedTab) {
      case "transaction":
        return transactionData;
      case "history":
        return historyData;
      case "pending":
        return pendingData;
      default:
        return transactionData;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
              surface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')} - ${date.month.toString().padLeft(2, '0')} - ${date.year}";
  }

  void _clearDate() {
    setState(() {
      selectedDate = null;
    });
  }

  // Fungsi untuk mendapatkan tanggal hari ini dalam format yang sesuai
  String _getTodayDate() {
    final today = DateTime.now();
    return _formatDate(today);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          _getAppBarTitle(),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.black87,
            ),
            onPressed: () {},
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.black87),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: Center(
                child: Text(
                  'Menu Farmasi',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: menuItems.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  thickness: 0.5,
                  color: Color(0xFFE0E0E0),
                ),
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  bool hasChildren = item.containsKey('children') && item['children'] != null;
                  bool isExpanded = expandedMenu == item['title'];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          item['title'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: selectedOrderType == item['title'] ? FontWeight.w600 : FontWeight.normal,
                            color: Colors.black87,
                          ),
                        ),
                        trailing: hasChildren
                            ? Icon(
                                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            if (hasChildren) {
                              expandedMenu = isExpanded ? null : item['title'];
                            } else {
                              navigateToPage(item['title']);
                            }
                          });
                        },
                      ),
                      // Submenu
                      if (hasChildren && isExpanded)
                        Column(
                          children: (item['children'] as List<String>).map((sub) {
                            return ListTile(
                              contentPadding: const EdgeInsets.only(left: 48, right: 16),
                              title: Text(
                                sub,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: selectedOrderType == sub ? FontWeight.w600 : FontWeight.normal,
                                  color: Colors.black87,
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  selectedOrderType = sub;
                                });
                                navigateToPage(sub);
                              },
                            );
                          }).toList(),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Breadcrumb
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Home',
                          style: TextStyle(
                            color: Colors.blue.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: Colors.grey,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Proses Order Obat',
                          style: TextStyle(
                            color: Colors.blue.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: Colors.grey,
                      ),
                      Text(
                        'Rajal',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Tab Buttons
                Row(
                  children: [
                    _buildTabButton("transaction", "transaction"),
                    const SizedBox(width: 8),
                    _buildTabButton("history", "history"),
                    const SizedBox(width: 8),
                    _buildTabButton("pending", "pending transaction"),
                  ],
                ),
                const SizedBox(height: 16),
                // Filter Section
                _buildFilterSection(screenWidth),
                const SizedBox(height: 16),
                // Tombol Tambah Order (hanya untuk tab transaction)
                if (selectedTab == "transaction")
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 16),
                          SizedBox(width: 8),
                          Text('Tambah Order', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Content Area
          Expanded(
            child: Container(
              color: Colors.grey.shade50,
              child: isCardView ? _buildCardView(screenWidth) : _buildTableView(),
            ),
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (selectedTab) {
      case "history":
        return "History Order Obat Rajal";
      case "pending":
        return "Pending Order Obat Rajal";
      default:
        return "Daftar Order Obat Rajal";
    }
  }

  Widget _buildDatePickerWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _selectDate(context),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 16,
              color: Colors.blue.shade600,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                selectedDate != null 
                    ? _formatDate(selectedDate!)
                    : _getTodayDate(), // Menggunakan tanggal hari ini secara real-time
                style: TextStyle(
                  fontSize: 13,
                  color: selectedDate != null 
                      ? Colors.blue.shade800
                      : Colors.grey.shade600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (selectedDate != null)
              GestureDetector(
                onTap: _clearDate,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.blue.shade400,
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFilterSection(double screenWidth) {
    if (screenWidth < 600) {
      // Mobile layout
      return Column(
        children: [
          // Search field
          Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari Berdasarkan Nama, No RM, No Order',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Date and Room filter
          Row(
            children: [
              Expanded(
                child: _buildDatePickerWidget(),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedRuangan ?? 'Pilih Ruangan',
                      items: ruanganOptions.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedRuangan = val;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Search button and View Toggle
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // View Toggle
              Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.shade600),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isCardView = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isCardView ? Colors.blue.shade600 : Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            bottomLeft: Radius.circular(6),
                          ),
                        ),
                        child: Icon(
                          Icons.grid_view,
                          size: 16,
                          color: isCardView ? Colors.white : Colors.blue.shade600,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isCardView = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: !isCardView ? Colors.blue.shade600 : Colors.white,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(6),
                            bottomRight: Radius.circular(6),
                          ),
                        ),
                        child: Icon(
                          Icons.table_rows,
                          size: 16,
                          color: !isCardView ? Colors.white : Colors.blue.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      // Desktop layout
      return Column(
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SizedBox(
                width: 300,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Cari Berdasarkan Nama, No RM, No Order',
                            hintStyle: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 120,
                child: _buildDatePickerWidget(),
              ),
              SizedBox(
                width: 140,
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedRuangan ?? 'Pilih Ruangan',
                      items: ruanganOptions.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: const TextStyle(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedRuangan = val;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // View Toggle
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isCardView = true;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isCardView ? Colors.blue.shade600 : Colors.white,
                    border: Border.all(color: Colors.blue.shade600),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.grid_view,
                        size: 16,
                        color: isCardView ? Colors.white : Colors.blue.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Card',
                        style: TextStyle(
                          fontSize: 12,
                          color: isCardView ? Colors.white : Colors.blue.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  setState(() {
                    isCardView = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: !isCardView ? Colors.blue.shade600 : Colors.white,
                    border: Border.all(color: Colors.blue.shade600),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.table_rows,
                        size: 16,
                        color: !isCardView ? Colors.white : Colors.blue.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Table',
                        style: TextStyle(
                          fontSize: 12,
                          color: !isCardView ? Colors.white : Colors.blue.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
  
  Widget _buildTabButton(String key, String label) {
    bool active = selectedTab == key;
    return GestureDetector(
      onTap: () {
        setState(() => selectedTab = key);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.blue.shade600 : Colors.white,
          border: Border.all(color: Colors.blue.shade600),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.blue.shade600,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
  
  Widget _buildCardView(double screenWidth) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: currentData.length,
      itemBuilder: (context, index) {
        return _buildPatientCard(currentData[index], screenWidth);
      },
    );
  }
  
  Widget _buildTableView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: _getTableColumns(),
            rows: currentData.map((patient) {
              return DataRow(
                cells: _getTableCells(patient),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _getTableColumns() {
    List<DataColumn> baseColumns = [
      const DataColumn(
        label: Text(
          'No',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
      const DataColumn(
        label: Text(
          'Nama Pasien',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
      const DataColumn(
        label: Text(
          'No RM',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
      const DataColumn(
        label: Text(
          'No Antrian',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
      const DataColumn(
        label: Text(
          'No Antrian APM',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
      const DataColumn(
        label: Text(
          'No Resep',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
      const DataColumn(
        label: Text(
          'Nama DPJP',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
      const DataColumn(
        label: Text(
          'Tanggal',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
      const DataColumn(
        label: Text(
          'Waktu Order',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    ];

    // Tambah kolom khusus berdasarkan tab
    if (selectedTab == "history") {
      baseColumns.add(const DataColumn(
        label: Text(
          'Waktu Selesai',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ));
    } else if (selectedTab == "pending") {
      baseColumns.add(const DataColumn(
        label: Text(
          'Alasan Pending',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ));
    }

    baseColumns.add(const DataColumn(
      label: Text(
        'Status',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
    ));

    return baseColumns;
  }

  List<DataCell> _getTableCells(Map<String, dynamic> patient) {
    List<DataCell> baseCells = [
      DataCell(
        Text(
          '${patient['nomor']}',
          style: const TextStyle(fontSize: 11),
        ),
      ),
      DataCell(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              patient['nama'],
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            if (patient['prioritas'] ?? false)
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Prioritas',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
      DataCell(Text(patient['noRM'], style: const TextStyle(fontSize: 11))),
      DataCell(Text(patient['noAntrian'], style: const TextStyle(fontSize: 11))),
      DataCell(Text(patient['noAntrianAPM'] ?? '-', style: const TextStyle(fontSize: 11))),
      DataCell(Text(patient['noResep'], style: const TextStyle(fontSize: 11))),
      DataCell(Text(patient['namaDPJP'], style: const TextStyle(fontSize: 11))),
      DataCell(Text(patient['tanggal'], style: const TextStyle(fontSize: 11))),
      DataCell(Text(patient['waktuOrder'], style: const TextStyle(fontSize: 11))),
    ];

    // Tambah cell khusus berdasarkan tab
    if (selectedTab == "history") {
      baseCells.add(DataCell(
        Text(
          patient['waktuSelesai'] ?? '-',
          style: const TextStyle(fontSize: 11),
        ),
      ));
    } else if (selectedTab == "pending") {
      baseCells.add(DataCell(
        Text(
          patient['alasanPending'] ?? '-',
          style: const TextStyle(fontSize: 11),
        ),
      ));
    }

    baseCells.add(DataCell(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: patient['statusColor'],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          patient['status'],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ));

    return baseCells;
  }
  
  void navigateToPage(String pageTitle) {
    if (pageMap.containsKey(pageTitle)) {
      if (ModalRoute.of(context)?.settings.name == pageTitle) {
        return;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => pageMap[pageTitle]!),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Halaman "$pageTitle" belum tersedia'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
  
  Widget _buildPatientAvatar(int patientNumber) {
    double avatarSize = 70.0;
    
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.person,
        color: Colors.grey,
        size: avatarSize * 0.6,
      ),
    );
  }
  
  Widget _buildPatientCard(Map<String, dynamic> patient, double screenWidth) {
    bool isPrioritas = patient['prioritas'] ?? false;
    bool isBPJS = patient['isBPJS'] ?? false;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar pasien dengan border
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.grey.shade500,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Kolom informasi detail
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient['nama'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'No RM : ${patient['noRM']}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'No Antrian : ${patient['noAntrian']}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  if (patient['noAntrianAPM'] != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'No Antrian APM: ${patient['noAntrianAPM']}',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                  const SizedBox(height: 2),
                  Text(
                    'No Resep : ${patient['noResep']}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Nama DPJP : ${patient['namaDPJP']}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tanggal : ${patient['tanggal']}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Waktu Order : ${patient['waktuOrder']}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  // Tambah informasi khusus berdasarkan tab
                  if (selectedTab == "history" && patient['waktuSelesai'] != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Waktu Selesai : ${patient['waktuSelesai']}',
                      style: TextStyle(fontSize: 11, color: Colors.green.shade600),
                    ),
                  ],
                  if (selectedTab == "pending" && patient['alasanPending'] != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        'Alasan: ${patient['alasanPending']}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.red.shade700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 20),
            // Badge dan status di kolom kanan
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Badge BPJS di atas
                if (isBPJS)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isPrioritas ? Colors.orange : Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isPrioritas ? 'BPJS Prioritas' : 'BPJS',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 20), // Placeholder untuk spacing konsisten
                    // Bagian bawah: nomor antrian dan status
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Nomor antrian
                        Text(
                          '${patient['nomor']}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 22),
                        // Status badge di bawah nomor
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: patient['statusColor'],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            patient['status'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}