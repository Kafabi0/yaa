import 'package:flutter/material.dart';
import 'package:inocare/screens/order_rajal_screen.dart';
import 'package:inocare/screens/stok_barang.dart';
import 'package:inocare/screens/order_detail_screen.dart';

class FarmasiScreen extends StatefulWidget {
  const FarmasiScreen({super.key});
  @override
  _FarmasiScreenState createState() => _FarmasiScreenState();
}

class _FarmasiScreenState extends State<FarmasiScreen> {
  String selectedOrderType = 'Proses Order Amprah';
  String selectedTipeAmprah = 'Dapo Executive';
  String selectedTujuan = 'Gudang';
  DateTime selectedDate = DateTime.now();
  bool isFilterExpanded = false;
  String? expandedMenu;

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
      "page": const FarmasiScreen(),
      "children": ["Proses Amprah", "Proses Order Obat"],
    },
    {
      "title": "Master Barang",
      "icon": Icons.inventory_2,
      "color": Colors.teal,
      "page": const FarmasiScreen(),
    },
    {
      "title": "Stok Barang Farmasi",
      "icon": Icons.medical_services,
      "color": Colors.purple,
      "page": const StokBarangScreen(),
    },
    {
      "title": "Penerimaan Barang",
      "icon": Icons.download,
      "color": Colors.blue,
      "page": const FarmasiScreen(),
    },
    {
      "title": "Pengeluaran Barang",
      "icon": Icons.upload,
      "color": Colors.red,
      "page": const FarmasiScreen(),
    },
    {
      "title": "Stok Opname",
      "icon": Icons.fact_check,
      "color": Colors.brown,
      "page": const FarmasiScreen(),
    },
    {
      "title": "Laporan",
      "icon": Icons.bar_chart,
      "color": Colors.deepOrange,
      "page": const FarmasiScreen(),
    },
    {
      "title": "Barang Produksi",
      "icon": Icons.production_quantity_limits,
      "color": Colors.cyan,
      "page": const FarmasiScreen(),
    },
  ];

  final List<String> tipeAmprahOptions = [
    'Dapo Executive',
    'Ruang Internal Terpadu Non Infeksi',
  ];

  final List<Map<String, dynamic>> orderData = [
    {
      'no': 1,
      'noOrder': '2020820088481800',
      'tanggalOrder': '20-08-2025',
      'pihasOrder': 'Dapo Executive',
      'tujuanOrder': 'Gudang',
      'tipeAmprah': 'Ship',
      'statusOrder': 'Dikirim',
      'aksi': 'Detail',
    },
    {
      'no': 2,
      'noOrder': '2020820088455400',
      'tanggalOrder': '20-08-2025',
      'pihasOrder': 'Ruang Internal Terpadu Non Infeksi',
      'tujuanOrder': 'Gudang',
      'tipeAmprah': 'Ship',
      'statusOrder': 'Dikirim',
      'aksi': 'Detail',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black87),
      onPressed: () => Navigator.pop(context),
    ),
    title: const Text(
      'Farmasi',
      style: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
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
  //       actions: [
  //         IconButton(
  //           icon: const Icon(
  //             Icons.notifications_outlined,
  //             color: Colors.black87,
  //           ),
  //           onPressed: () {},
  //         ),
  //       ],
  //     ),
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
                separatorBuilder:
                    (_, __) => const Divider(
                      height: 1,
                      thickness: 0.5,
                      color: Color(0xFFE0E0E0),
                    ),
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  bool hasChildren =
                      item.containsKey('children') && item['children'] != null;
                  bool isExpanded = expandedMenu == item['title'];

                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          item['title'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                selectedOrderType == item['title']
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                            color: Colors.black87,
                          ),
                        ),
                        trailing:
                            hasChildren
                                ? Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: Colors.grey,
                                )
                                : null,
                        onTap: () {
                          setState(() {
                            if (hasChildren) {
                              expandedMenu = isExpanded ? null : item['title'];
                            } else {
                              // Navigasi ke halaman baru
                              navigateToPage(item['title']);
                            }
                          });
                        },
                      ),
                      // Submenu
                      if (hasChildren && isExpanded)
                        Column(
                          children:
                              (item['children'] as List<String>).map((sub) {
                                return ListTile(
                                  contentPadding: const EdgeInsets.only(
                                    left: 48,
                                    right: 16,
                                  ),
                                  title: Text(
                                    sub,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight:
                                          selectedOrderType == sub
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedOrderType = sub;
                                    });
                                    // Navigasi ke halaman submenu
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
                          'Proses Order Amprah',
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
                        'Gudang',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Search Bar (always visible)
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Cari order...',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade600,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Filter Toggle Button
                InkWell(
                  onTap: () {
                    setState(() {
                      isFilterExpanded = !isFilterExpanded;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.filter_list,
                              size: 20,
                              color: Colors.blue.shade600,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Filter Pencarian',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue.shade600,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          isFilterExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.blue.shade600,
                        ),
                      ],
                    ),
                  ),
                ),
                // Expandable Filter Section
                if (isFilterExpanded) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        // Date Field
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: TextField(
                            readOnly: true,
                            controller: TextEditingController(
                              text: "${selectedDate.toLocal()}".split(' ')[0],
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Tanggal',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              border: InputBorder.none,
                              suffixIcon: Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ),
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      primaryColor: Colors.blue,
                                      colorScheme: const ColorScheme.light(
                                        primary: Colors.blue,
                                        onPrimary: Colors.white,
                                        surface: Colors.white,
                                        onSurface: Colors.black,
                                      ),
                                      dialogBackgroundColor: Colors.white,
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
                            },
                          ),
                        ),
                        // Tipe Amprah Dropdown
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: DropdownButtonFormField<String>(
                            value: selectedTipeAmprah,
                            decoration: const InputDecoration(
                              labelText: 'Tipe Amprah',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              border: InputBorder.none,
                            ),
                            dropdownColor: Colors.white,
                            items:
                                tipeAmprahOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedTipeAmprah = newValue!;
                              });
                            },
                          ),
                        ),
                        // Status Dropdown
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Status',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              border: InputBorder.none,
                            ),
                            dropdownColor: Colors.white,
                            value: 'Dikirim',
                            items:
                                ['Dikirim', 'Diproses', 'Selesai', 'Batal']
                                    .map(
                                      (status) => DropdownMenuItem(
                                        value: status,
                                        child: Text(
                                          status,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                // simpan status yang dipilih
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Data Cards (Mobile Responsive)
          Expanded(
            child: Container(
              color: Colors.grey.shade50,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orderData.length,
                itemBuilder: (context, index) {
                  final order = orderData[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Header dengan nomor urut dan nomor order
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade600,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    '${order['no']}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Order #${order['noOrder']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    Text(
                                      order['tanggalOrder'],
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  order['statusOrder'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.green.shade800,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Detail Information
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildMobileDetailRow(
                                Icons.business,
                                'Pihak Order',
                                order['pihasOrder'],
                                Colors.orange,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildMobileDetailRow(
                                      Icons.location_on,
                                      'Tujuan',
                                      order['tujuanOrder'],
                                      Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildMobileDetailRow(
                                      Icons.local_shipping,
                                      'Tipe',
                                      order['tipeAmprah'],
                                      Colors.purple,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const OrderDetailScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.visibility, size: 16),
                                  label: const Text('Lihat Detail'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade600,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          // Pagination Footer (Mobile Optimized)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Menampilkan ${orderData.length} data',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: null,
                          icon: const Icon(Icons.chevron_left, size: 20),
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade600,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '1',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        IconButton(
                          onPressed: null,
                          icon: const Icon(Icons.chevron_right, size: 20),
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
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
    );
  }

  // Fungsi untuk navigasi ke halaman
  void navigateToPage(String pageTitle) {
    // Cek apakah halaman ada dalam map
    if (pageMap.containsKey(pageTitle)) {
      // Jika sedang di halaman yang sama, tidak perlu navigasi
      if (ModalRoute.of(context)?.settings.name == pageTitle) {
        return;
      }

      // Navigasi ke halaman baru
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => pageMap[pageTitle]!),
      );
    } else {
      // Jika halaman tidak ditemukan, tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Halaman "$pageTitle" belum tersedia'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildMobileDetailRow(
    IconData icon,
    String label,
    String value,
    MaterialColor color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.shade50,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: color.shade600),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
