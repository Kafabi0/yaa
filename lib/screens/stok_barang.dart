import 'package:flutter/material.dart';
import '../screens/farmasi_screen.dart';
import '../screens/order_rajal_screen.dart';

class StokBarangScreen extends StatefulWidget {
  const StokBarangScreen({super.key});

  @override
  State<StokBarangScreen> createState() => _StokBarangScreenState();
}

class _StokBarangScreenState extends State<StokBarangScreen> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  String? expandedMenu;
  String? selectedOrderType;
  int _rowsPerPage = 10;
  int _currentPage = 1;
  String _sortColumn = '';
  bool _sortAscending = true;

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

  final List<Map<String, dynamic>> data = [
    {
      "no": 1,
      "kode": "1.FR.BRG.5992",
      "nama": "Test Programmer Barang Farmasi",
      "kelompok": "BHP",
      "golongan": "BHP",
      "satuan": "BOX",
      "hpp": "Rp 10.000",
      "ppn": "0.11",
      "faktor": "0.28",
      "hargaSebelum": "Rp 14.208",
      "hargaJual": "Rp 14.208",
      "hargaUmum": "Rp 14.208",
      "stok": "7",
      "kadaluarsa": "16-05-2025",
    },
    {
      "no": 2,
      "kode": "1.AH.15.462",
      "nama": "LC DISTAL HUMERUS PLATE 05H (LEFT)",
      "kelompok": "AMHP Orthopedi Non E-Katalog",
      "golongan": "AMHP",
      "satuan": "PCS",
      "hpp": "Rp 5.378.351",
      "ppn": "0.11",
      "faktor": "0.1",
      "hargaSebelum": "Rp 6.566.966,571",
      "hargaJual": "Rp 6.566.967",
      "hargaUmum": "Rp 6.566.967",
      "stok": "200",
      "kadaluarsa": "-",
    },
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth >= 768;
    bool isDesktop = screenWidth >= 1024;
    bool isMobile = screenWidth < 768;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context, isMobile),
      endDrawer: _buildDrawer(context),
      body: _buildBody(context, isMobile, isTablet, isDesktop),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isMobile) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.3),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daftar Stok Barang',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: isMobile ? 16 : 18,
                  ),
                ),
                if (!isMobile)
                  Text(
                    'Manajemen Stok Farmasi',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        if (!isMobile) ...[
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.blue[700]),
            onPressed: () {},
            tooltip: 'Refresh Data',
          ),
          IconButton(
            icon: Icon(Icons.file_download, color: Colors.green[700]),
            onPressed: () {},
            tooltip: 'Export Data',
          ),
        ],
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
              onPressed: () {},
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: MediaQuery.of(context).size.width > 768 ? 300 : 280,
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue[700]!, Colors.blue[500]!],
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.medical_services, color: Colors.white, size: 32),
                  SizedBox(height: 8),
                  Text(
                    'Menu Farmasi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                bool hasChildren = item.containsKey('children') && item['children'] != null;
                bool isExpanded = expandedMenu == item['title'];
                bool isSelected = selectedOrderType == item['title'];

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected ? Colors.blue[50] : Colors.transparent,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (item['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            item['icon'],
                            color: item['color'],
                            size: 20,
                          ),
                        ),
                        title: Text(
                          item['title'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? Colors.blue[700] : Colors.black87,
                          ),
                        ),
                        trailing: hasChildren
                            ? Icon(
                                isExpanded ? Icons.expand_less : Icons.expand_more,
                                color: Colors.grey[600],
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            if (hasChildren) {
                              expandedMenu = isExpanded ? null : item['title'];
                            } else {
                              selectedOrderType = item['title'];
                              navigateToPage(item['title']);
                            }
                          });
                        },
                      ),
                      if (hasChildren && isExpanded)
                        Container(
                          margin: const EdgeInsets.only(left: 16),
                          child: Column(
                            children: (item['children'] as List<String>).map((sub) {
                              bool isSubSelected = selectedOrderType == sub;
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: isSubSelected ? Colors.blue[100] : Colors.transparent,
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.only(left: 32, right: 16),
                                  title: Text(
                                    sub,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSubSelected ? FontWeight.w600 : FontWeight.normal,
                                      color: isSubSelected ? Colors.blue[700] : Colors.grey[700],
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedOrderType = sub;
                                    });
                                    navigateToPage(sub);
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, bool isMobile, bool isTablet, bool isDesktop) {
    return Column(
      children: [
        _buildHeader(isMobile, isTablet),
        _buildSearchAndFilter(isMobile, isTablet),
        Expanded(
          child: _buildDataSection(context, isMobile, isTablet, isDesktop),
        ),
        _buildPagination(isMobile),
      ],
    );
  }

  Widget _buildHeader(bool isMobile, bool isTablet) {
    if (isMobile) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dashboard Stok Barang",
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Pantau dan kelola inventori farmasi secara real-time",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildStatsCard("Total Item", "${data.length}", Icons.inventory_2, Colors.blue),
              const SizedBox(width: 16),
              _buildStatsCard("Stok Rendah", "2", Icons.warning, Colors.orange),
              const SizedBox(width: 16),
              _buildStatsCard("Akan Expire", "1", Icons.schedule, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(bool isMobile, bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: isMobile ? _buildMobileSearch() : _buildDesktopSearch(),
    );
  }

  Widget _buildMobileSearch() {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: "Cari kode, nama, atau kategori...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue[600]!),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showFilterBottomSheet(),
                icon: const Icon(Icons.filter_list),
                label: const Text("Filter"),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.search),
                label: const Text("Cari"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopSearch() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Cari kode, nama, atau kategori...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue[600]!),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        PopupMenuButton<String>(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.filter_list),
                const SizedBox(width: 8),
                const Text("Filter"),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          itemBuilder: (context) => [
            const PopupMenuItem(value: "stok_rendah", child: Text("Stok Rendah")),
            const PopupMenuItem(value: "akan_expire", child: Text("Akan Expire")),
            const PopupMenuItem(value: "golongan", child: Text("Filter Golongan")),
          ],
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.search),
          label: const Text("Cari"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDataSection(BuildContext context, bool isMobile, bool isTablet, bool isDesktop) {
    if (isMobile) {
      return _buildMobileList();
    } else {
      return _buildDataTable(isTablet, isDesktop);
    }
  }

  Widget _buildMobileList() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: data.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final item = data[index];
          bool isLowStock = int.tryParse(item["stok"]) != null && int.parse(item["stok"]) < 10;
          
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isLowStock ? Colors.red[50] : Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isLowStock ? Colors.red[200]! : Colors.grey[200]!,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item["kode"],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (isLowStock)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.warning, size: 12, color: Colors.red[700]),
                            const SizedBox(width: 4),
                            Text(
                              "Stok Rendah",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.red[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item["nama"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoRow("Golongan", item["golongan"]),
                    ),
                    Expanded(
                      child: _buildInfoRow("Satuan", item["satuan"]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoRow("Stok", item["stok"]),
                    ),
                    Expanded(
                      child: _buildInfoRow("HPP", item["hpp"]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                _buildInfoRow("Expire", item["kadaluarsa"]),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text("Detail & Edit"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              "$label:",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(bool isTablet, bool isDesktop) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width - 32,
            ),
            child: DataTable(
              headingRowHeight: 56,
              dataRowHeight: 64,
              headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
              columnSpacing: isTablet ? 16 : 24,
              horizontalMargin: 24,
              columns: _buildTableColumns(isTablet),
              rows: _buildTableRows(isTablet),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildTableColumns(bool isTablet) {
    final columns = [
      DataColumn(label: _buildHeaderCell("No", "no")),
      DataColumn(label: _buildHeaderCell("Kode", "kode")),
      DataColumn(label: _buildHeaderCell("Nama Barang", "nama")),
      DataColumn(label: _buildHeaderCell("Kelompok", "kelompok")),
      DataColumn(label: _buildHeaderCell("Golongan", "golongan")),
      DataColumn(label: _buildHeaderCell("Satuan", "satuan")),
      DataColumn(label: _buildHeaderCell("HPP", "hpp"), numeric: true),
      DataColumn(label: _buildHeaderCell("Stok", "stok"), numeric: true),
      DataColumn(label: _buildHeaderCell("Expire", "kadaluarsa")),
      const DataColumn(label: Text("Aksi")),
    ];

    if (!isTablet) {
      // Tambahkan kolom tambahan untuk desktop
      columns.insertAll(7, [
        DataColumn(label: _buildHeaderCell("PPN", "ppn")),
        DataColumn(label: _buildHeaderCell("Faktor", "faktor")),
        DataColumn(label: _buildHeaderCell("Harga Jual", "hargaJual"), numeric: true),
      ]);
    }

    return columns;
  }

  List<DataRow> _buildTableRows(bool isTablet) {
    return data.map((item) {
      bool isLowStock = int.tryParse(item["stok"]) != null && int.parse(item["stok"]) < 10;
      
      final cells = [
        DataCell(Text(item["no"].toString())),
        DataCell(_buildCodeCell(item["kode"])),
        DataCell(_buildNameCell(item["nama"])),
        DataCell(_buildDataCell(item["kelompok"], maxWidth: 150)),
        DataCell(_buildChipCell(item["golongan"])),
        DataCell(_buildDataCell(item["satuan"])),
        DataCell(_buildPriceCell(item["hpp"])),
        DataCell(_buildStockCell(item["stok"])),
        DataCell(_buildDateCell(item["kadaluarsa"])),
        DataCell(_buildActionButton()),
      ];

      if (!isTablet) {
        // Tambahkan cell tambahan untuk desktop
        cells.insertAll(7, [
          DataCell(_buildDataCell(item["ppn"])),
          DataCell(_buildDataCell(item["faktor"])),
          DataCell(_buildPriceCell(item["hargaJual"])),
        ]);
      }

      return DataRow(
        color: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (isLowStock) return Colors.red[50];
            return null;
          },
        ),
        cells: cells,
      );
    }).toList();
  }

  Widget _buildHeaderCell(String text, String sortKey) {
    return InkWell(
      onTap: () {
        setState(() {
          if (_sortColumn == sortKey) {
            _sortAscending = !_sortAscending;
          } else {
            _sortColumn = sortKey;
            _sortAscending = true;
          }
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          if (_sortColumn == sortKey)
            Icon(
              _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
              size: 16,
              color: Colors.blue[600],
            ),
        ],
      ),
    );
  }

  Widget _buildDataCell(String text, {double? maxWidth}) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildCodeCell(String code) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Text(
        code,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Colors.blue[700],
          fontFamily: 'monospace',
        ),
      ),
    );
  }

  Widget _buildNameCell(String name) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }

  Widget _buildChipCell(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.green[700],
        ),
      ),
    );
  }

  Widget _buildPriceCell(String price) {
    return Text(
      price,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.green[700],
      ),
    );
  }

  Widget _buildStockCell(String stock) {
    int stockValue = int.tryParse(stock) ?? 0;
    bool isLowStock = stockValue < 10;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isLowStock ? Colors.red[50] : Colors.green[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isLowStock ? Colors.red[200]! : Colors.green[200]!,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLowStock)
            Icon(Icons.warning, size: 14, color: Colors.red[600]),
          if (isLowStock) const SizedBox(width: 4),
          Text(
            stock,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isLowStock ? Colors.red[700] : Colors.green[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateCell(String date) {
    if (date == "-") {
      return Text(
        "-",
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[500],
        ),
      );
    }
    
    return Text(
      date,
      style: const TextStyle(
        fontSize: 13,
        fontFamily: 'monospace',
      ),
    );
  }

  Widget _buildActionButton() {
    return PopupMenuButton<String>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue[600],
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.more_vert, color: Colors.white, size: 16),
            SizedBox(width: 4),
            Text(
              "Aksi",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: "edit",
          child: Row(
            children: [
              Icon(Icons.edit, size: 16),
              SizedBox(width: 8),
              Text("Edit"),
            ],
          ),
        ),
        const PopupMenuItem(
          value: "history",
          child: Row(
            children: [
              Icon(Icons.history, size: 16),
              SizedBox(width: 8),
              Text("Riwayat"),
            ],
          ),
        ),
        const PopupMenuItem(
          value: "hpp_stock",
          child: Row(
            children: [
              Icon(Icons.data_usage, size: 16),
              SizedBox(width: 8),
              Text("Data HPP & Stok"),
            ],
          ),
        ),
        const PopupMenuItem(
          value: "delete",
          child: Row(
            children: [
              Icon(Icons.delete, size: 16, color: Colors.red),
              SizedBox(width: 8),
              Text("Hapus", style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPagination(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: isMobile ? _buildMobilePagination() : _buildDesktopPagination(),
    );
  }

  Widget _buildMobilePagination() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Halaman $_currentPage dari 502",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: _currentPage > 1 ? () {
                    setState(() {
                      _currentPage--;
                    });
                  } : null,
                  icon: const Icon(Icons.chevron_left),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentPage++;
                    });
                  },
                  icon: const Icon(Icons.chevron_right),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              "Tampilkan:",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButton<int>(
                  value: _rowsPerPage,
                  underline: const SizedBox(),
                  isExpanded: true,
                  items: [10, 25, 50, 100].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text("$value item per halaman"),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _rowsPerPage = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              "Menampilkan:",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(6),
              ),
              child: DropdownButton<int>(
                value: _rowsPerPage,
                underline: const SizedBox(),
                items: [10, 25, 50, 100].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _rowsPerPage = newValue;
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "dari 502 item",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "Halaman $_currentPage dari 502",
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 16),
            Row(
              children: [
                IconButton(
                  onPressed: _currentPage > 1 ? () {
                    setState(() {
                      _currentPage--;
                    });
                  } : null,
                  icon: const Icon(Icons.chevron_left),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentPage++;
                    });
                  },
                  icon: const Icon(Icons.chevron_right),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    "Filter & Pengurutan",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Filter berdasarkan:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: Icon(Icons.warning, color: Colors.orange[600]),
                      title: const Text("Stok Rendah"),
                      subtitle: const Text("Tampilkan item dengan stok < 10"),
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {},
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.schedule, color: Colors.red[600]),
                      title: const Text("Akan Expire"),
                      subtitle: const Text("Expire dalam 30 hari"),
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {},
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.category, color: Colors.blue[600]),
                      title: const Text("Filter Golongan"),
                      subtitle: const Text("BHP, AMHP, dll"),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Urutkan berdasarkan:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text("Nama Barang"),
                      trailing: Radio<String>(
                        value: "nama",
                        groupValue: _sortColumn,
                        onChanged: (value) {
                          setState(() {
                            _sortColumn = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text("Jumlah Stok"),
                      trailing: Radio<String>(
                        value: "stok",
                        groupValue: _sortColumn,
                        onChanged: (value) {
                          setState(() {
                            _sortColumn = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text("Tanggal Expire"),
                      trailing: Radio<String>(
                        value: "kadaluarsa",
                        groupValue: _sortColumn,
                        onChanged: (value) {
                          setState(() {
                            _sortColumn = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Reset filter
                        Navigator.pop(context);
                      },
                      child: const Text("Reset"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        // Apply filter
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Terapkan Filter"),
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

  void navigateToPage(String pageTitle) {
    Navigator.pop(context); // Tutup drawer
    
    if (pageMap.containsKey(pageTitle)) {
      if (ModalRoute.of(context)?.settings.name == pageTitle) {
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => pageMap[pageTitle]!,
          settings: RouteSettings(name: pageTitle),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Halaman "$pageTitle" belum tersedia'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.orange[600],
        ),
      );
    }
  }
}