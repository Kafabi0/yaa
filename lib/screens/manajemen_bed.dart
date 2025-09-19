import 'package:flutter/material.dart';

class ManajemenBed extends StatefulWidget {
  const ManajemenBed({super.key});

  @override
  State<ManajemenBed> createState() => _ManajemenBedState();
}

class _ManajemenBedState extends State<ManajemenBed> {
  final List<Map<String, dynamic>> _allBeds = List.generate(
    40,
    (i) => {
      "no": i + 1,
      "gedung": "Instalasi Rawat Inap Bedah, Mata, THT",
      "ruangan":
          i % 3 == 0 ? "Ruang Bedah Lt 1" : "Ruang Bedah Lt 2 (Mata, THT)",
      "nama": ["I", "II", "III"][i % 3],
      "kategori": "Dewasa",
      "kelasKRIS": "Rawat Jalan Eksekutif - Pemeriksaan/Konsultasi",
      "kelasNonKRIS": "Biaya Rawat Inap - Konsultasi Dr. Spesialis",
      "gender": "Netral (dengan catatan)",
      "status":
          i == 4 ? "Terisi" : "Tersedia", // beberapa bed terisi untuk demo
    },
  );

  // Filter & search
  String _searchQuery = "";
  String? _selectedGedung;
  String? _selectedRuangan;
  final TextEditingController _searchController = TextEditingController();

  // Pagination
  int _rowsPerPage = 5;
  int _currentPage = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Helper method to get screen size info
  bool get _isMobile => MediaQuery.of(context).size.width < 600;
  bool get _isTablet =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;
  bool get _isDesktop => MediaQuery.of(context).size.width >= 1024;

  // Fungsi helper untuk detail info
  Widget _buildInfo(
    String label,
    String value, {
    bool highlight = false,
    bool boldAll = false,
  }) {
    if (boldAll) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          "$label : $value",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _isMobile ? 11 : 12,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: _isMobile ? 11 : 12, color: Colors.black),
          children: [
            TextSpan(
              text: "$label : ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
                color: highlight ? Colors.blue : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk mendapatkan warna status
  Color _getStatusColor(String status) {
    switch (status) {
      case "Terisi":
        return Colors.red;
      case "Rusak":
        return Colors.orange;
      case "Dibersihkan":
        return Colors.yellow;
      default:
        return Colors.green;
    }
  }

  // Widget untuk filter card yang responsif
  Widget _buildFilterCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(_isMobile ? 12 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.filter_list, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Filter & Pencarian",
                    style: TextStyle(
                      fontSize: _isMobile ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: _isMobile ? 12 : 20),

            // Search Field
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Cari berdasarkan nama kamar...",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: _isMobile ? 14 : 16,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                  suffixIcon:
                      _searchQuery.isNotEmpty
                          ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey.shade600,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = "";
                                _currentPage = 0;
                              });
                            },
                          )
                          : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: _isMobile ? 12 : 14,
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                    _currentPage = 0;
                  });
                },
              ),
            ),

            SizedBox(height: _isMobile ? 12 : 16),

            // Filter Dropdowns yang responsif
            _buildResponsiveFilters(),

            // Filter summary
            if (_selectedGedung != null ||
                _selectedRuangan != null ||
                _searchQuery.isNotEmpty) ...[
              SizedBox(height: _isMobile ? 12 : 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                "Filter Aktif:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                  fontSize: _isMobile ? 12 : 14,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (_searchQuery.isNotEmpty)
                    _buildFilterChip("Pencarian: '$_searchQuery'", () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = "";
                        _currentPage = 0;
                      });
                    }),
                  if (_selectedGedung != null)
                    _buildFilterChip(
                      "Gedung: ${_selectedGedung!.split(',')[0]}...",
                      () {
                        setState(() {
                          _selectedGedung = null;
                          _currentPage = 0;
                        });
                      },
                    ),
                  if (_selectedRuangan != null)
                    _buildFilterChip("Ruangan: $_selectedRuangan", () {
                      setState(() {
                        _selectedRuangan = null;
                        _currentPage = 0;
                      });
                    }),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveFilters() {
    if (_isMobile) {
      // Mobile: Stack vertikal dengan tombol full width
      return Column(
        children: [
          _buildGedungDropdown(),
          const SizedBox(height: 12),
          _buildRuanganDropdown(),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: _buildResetButton()),
        ],
      );
    } else if (_isTablet) {
      // Tablet: 2 dropdown di atas, tombol di bawah
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildGedungDropdown()),
              const SizedBox(width: 12),
              Expanded(child: _buildRuanganDropdown()),
            ],
          ),
          const SizedBox(height: 12),
          Align(alignment: Alignment.centerRight, child: _buildResetButton()),
        ],
      );
    } else {
      // Desktop: Semua dalam 1 baris
      return Row(
        children: [
          Expanded(child: _buildGedungDropdown()),
          const SizedBox(width: 12),
          Expanded(child: _buildRuanganDropdown()),
          const SizedBox(width: 12),
          _buildResetButton(),
        ],
      );
    }
  }

  Widget _buildGedungDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "Gedung",
          labelStyle: TextStyle(fontSize: _isMobile ? 14 : 16),
          prefixIcon: const Icon(Icons.business),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: _isMobile ? 12 : 14,
          ),
        ),
        value: _selectedGedung,
        isExpanded: true,
        style: TextStyle(fontSize: _isMobile ? 14 : 16, color: Colors.black),
        items: const [
          DropdownMenuItem(
            value: "Instalasi Rawat Inap Bedah, Mata, THT",
            child: Text(
              "Instalasi Rawat Inap Bedah, Mata, THT",
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _selectedGedung = value;
            _currentPage = 0;
          });
        },
      ),
    );
  }

  Widget _buildRuanganDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "Ruangan",
          labelStyle: TextStyle(fontSize: _isMobile ? 14 : 16),
          prefixIcon: const Icon(Icons.room),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: _isMobile ? 12 : 14,
          ),
        ),
        value: _selectedRuangan,
        isExpanded: true,
        style: TextStyle(fontSize: _isMobile ? 14 : 16, color: Colors.black),
        items: const [
          DropdownMenuItem(
            value: "Ruang Bedah Lt 1",
            child: Text("Ruang Bedah Lt 1"),
          ),
          DropdownMenuItem(
            value: "Ruang Bedah Lt 2 (Mata, THT)",
            child: Text("Ruang Bedah Lt 2 (Mata, THT)"),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _selectedRuangan = value;
            _currentPage = 0;
          });
        },
      ),
    );
  }

  Widget _buildResetButton() {
    return ElevatedButton.icon(
      onPressed: () {
        _searchController.clear();
        setState(() {
          _selectedGedung = null;
          _selectedRuangan = null;
          _searchQuery = "";
          _currentPage = 0;
        });
      },
      icon: const Icon(Icons.refresh),
      label: const Text("Reset Filter"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: _isMobile ? 16 : 20,
          vertical: _isMobile ? 10 : 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onDeleted) {
    return Chip(
      label: Text(label, style: TextStyle(fontSize: _isMobile ? 10 : 12)),
      onDeleted: onDeleted,
      deleteIcon: const Icon(Icons.close, size: 16),
      backgroundColor: Colors.blue.shade50,
      deleteIconColor: Colors.blue.shade600,
      side: BorderSide(color: Colors.blue.shade200),
    );
  }

  // Dialog responsif
  void _showDetailDialog(Map<String, dynamic> selectedBed) {
    String selectedStatus = selectedBed["status"];
    int selectedBedNo = selectedBed["no"];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width:
                    _isMobile
                        ? MediaQuery.of(context).size.width * 0.95
                        : MediaQuery.of(context).size.width * 0.9,
                height:
                    _isMobile
                        ? MediaQuery.of(context).size.height * 0.85
                        : MediaQuery.of(context).size.height * 0.8,
                padding: EdgeInsets.all(_isMobile ? 12 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header responsif
                    _buildDialogHeader(selectedBed, setStateDialog),
                    SizedBox(height: _isMobile ? 12 : 16),

                    // Grid bed responsif
                    Expanded(
                      flex: 3,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _isMobile ? 2 : (_isTablet ? 3 : 4),
                          childAspectRatio: _isMobile ? 0.9 : 0.8,
                          crossAxisSpacing: _isMobile ? 4 : 8,
                          mainAxisSpacing: _isMobile ? 4 : 8,
                        ),
                        itemCount: _allBeds.length,
                        itemBuilder: (context, index) {
                          final bed = _allBeds[index];
                          final isSelected = bed["no"] == selectedBedNo;

                          return _buildBedGridItem(bed, isSelected, () {
                            setStateDialog(() {
                              selectedBedNo = bed["no"];
                              selectedStatus = bed["status"];
                            });
                          });
                        },
                      ),
                    ),

                    SizedBox(height: _isMobile ? 12 : 16),
                    const Divider(),
                    SizedBox(height: _isMobile ? 8 : 8),

                    // Form update status responsif
                    _buildUpdateStatusForm(
                      selectedBedNo,
                      selectedStatus,
                      setStateDialog,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDialogHeader(
    Map<String, dynamic> selectedBed,
    StateSetter setStateDialog,
  ) {
    if (_isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${selectedBed["gedung"]}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(selectedBed["ruangan"], style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setStateDialog(() {
                  for (var bed in _allBeds) {
                    bed["status"] = "Tersedia";
                  }
                });
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Reset All Bed"),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "${selectedBed["gedung"]} => ${selectedBed["ruangan"]}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  setStateDialog(() {
                    for (var bed in _allBeds) {
                      bed["status"] = "Tersedia";
                    }
                  });
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Reset All Bed"),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildBedGridItem(
    Map<String, dynamic> bed,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(_isMobile ? 4 : 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : _getStatusColor(bed["status"]),
            width: isSelected ? 3 : 2,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.blue.shade50 : Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bed,
              size: _isMobile ? 20 : 24,
              color:
                  bed["status"] == "Terisi" ? Colors.red : Colors.grey.shade600,
            ),
            SizedBox(height: _isMobile ? 2 : 4),
            Text(
              "Bed ${bed["no"]}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: _isMobile ? 10 : 12,
              ),
            ),
            SizedBox(height: _isMobile ? 1 : 2),
            Text(
              bed["status"] == "Terisi" ? "Terisi" : "Siap Digunakan/Kosong",
              style: TextStyle(
                fontSize: _isMobile ? 8 : 10,
                color: bed["status"] == "Terisi" ? Colors.red : Colors.green,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: _isMobile ? 2 : 4),
            if (!_isMobile)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "Status",
                      style: TextStyle(color: Colors.white, fontSize: 8),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text("Riwayat", style: TextStyle(fontSize: 8)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateStatusForm(
    int selectedBedNo,
    String selectedStatus,
    StateSetter setStateDialog,
  ) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Update Status Bed $selectedBedNo",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _isMobile ? 12 : 14,
            ),
          ),
          SizedBox(height: _isMobile ? 6 : 8),

          // Selalu sebelahan kanan-kiri (Row)
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedStatus,
                  items:
                      ["Tersedia", "Terisi", "Rusak", "Dibersihkan"]
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setStateDialog(() {
                        selectedStatus = value;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    final bedToUpdate = _allBeds.firstWhere(
                      (bed) => bed["no"] == selectedBedNo,
                    );
                    bedToUpdate["status"] = selectedStatus;
                  });
                  Navigator.pop(context);
                },
                child: const Text("Update"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveDataView(List<Map<String, dynamic>> pageItems) {
    if (_isMobile) {
      return _buildMobileCardView(pageItems);
    } else {
      return _buildDesktopTableView(pageItems);
    }
  }

  Widget _buildMobileCardView(List<Map<String, dynamic>> pageItems) {
    return Column(
      children:
          pageItems.map((bed) {
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Bed ${bed["no"]}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(bed["status"]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            bed["status"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildInfo("Gedung", bed["gedung"]),
                    _buildInfo("Ruangan", bed["ruangan"]),
                    _buildInfo("Nama", bed["nama"], highlight: true),
                    _buildInfo("Kategori", bed["kategori"]),
                    _buildInfo("Kelas KRIS", bed["kelasKRIS"], boldAll: true),
                    _buildInfo("Kelas NON-KRIS", bed["kelasNonKRIS"]),
                    _buildInfo("Gender", bed["gender"]),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _showDetailDialog(bed),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text("Detail"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildDesktopTableView(List<Map<String, dynamic>> pageItems) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width - 32,
            ),
            child: Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              columnWidths: const {
                0: FixedColumnWidth(60),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(3),
                4: FixedColumnWidth(100),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.blue.shade50),
                  children:
                      ["No", "Gedung", "Ruangan", "Kamar", "Aksi"]
                          .map(
                            (header) => Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                header,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
                ...pageItems.map(
                  (bed) => TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(bed["no"].toString()),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(bed["gedung"]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(bed["ruangan"]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfo("Nama", bed["nama"], highlight: true),
                              _buildInfo("Kategori", bed["kategori"]),
                              _buildInfo(
                                "Kelas KRIS",
                                bed["kelasKRIS"],
                                boldAll: true,
                              ),
                              _buildInfo("Kelas NON-KRIS", bed["kelasNonKRIS"]),
                              _buildInfo("Gender", bed["gender"]),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => _showDetailDialog(bed),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Detail"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget pagination responsif
  Widget _buildResponsivePagination(int totalPages) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(_isMobile ? 12 : 16),
        child: Column(
          children: [
            // Rows per page
            if (!_isMobile) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Baris per halaman: "),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: DropdownButton<int>(
                      value: _rowsPerPage,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 5, child: Text("5")),
                        DropdownMenuItem(value: 10, child: Text("10")),
                        DropdownMenuItem(value: 20, child: Text("20")),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _rowsPerPage = value;
                            _currentPage = 0;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Navigation buttons
            if (_isMobile) ...[
              // Mobile: Simplified navigation
              Column(
                children: [
                  Text(
                    "Halaman ${_currentPage + 1} dari $totalPages",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed:
                            _currentPage > 0
                                ? () => setState(() => _currentPage = 0)
                                : null,
                        icon: const Icon(Icons.first_page, size: 16),
                        label: const Text("Awal"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed:
                            _currentPage > 0
                                ? () => setState(() => _currentPage--)
                                : null,
                        icon: const Icon(Icons.chevron_left, size: 16),
                        label: const Text("Prev"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed:
                            _currentPage < totalPages - 1
                                ? () => setState(() => _currentPage++)
                                : null,
                        icon: const Icon(Icons.chevron_right, size: 16),
                        label: const Text("Next"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed:
                            _currentPage < totalPages - 1
                                ? () => setState(
                                  () => _currentPage = totalPages - 1,
                                )
                                : null,
                        icon: const Icon(Icons.last_page, size: 16),
                        label: const Text("Akhir"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Rows per page for mobile
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Baris: "),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: DropdownButton<int>(
                          value: _rowsPerPage,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: 5, child: Text("5")),
                            DropdownMenuItem(value: 10, child: Text("10")),
                            DropdownMenuItem(value: 20, child: Text("20")),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _rowsPerPage = value;
                                _currentPage = 0;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ] else ...[
              // Desktop/Tablet: Full navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.first_page),
                    onPressed:
                        _currentPage > 0
                            ? () => setState(() => _currentPage = 0)
                            : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed:
                        _currentPage > 0
                            ? () => setState(() => _currentPage--)
                            : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Halaman ${_currentPage + 1} dari $totalPages",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed:
                        _currentPage < totalPages - 1
                            ? () => setState(() => _currentPage++)
                            : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.last_page),
                    onPressed:
                        _currentPage < totalPages - 1
                            ? () =>
                                setState(() => _currentPage = totalPages - 1)
                            : null,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Apply filter
    List<Map<String, dynamic>> filteredBeds =
        _allBeds.where((bed) {
          final matchSearch = bed["nama"].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
          final matchGedung =
              _selectedGedung == null || bed["gedung"] == _selectedGedung;
          final matchRuangan =
              _selectedRuangan == null || bed["ruangan"] == _selectedRuangan;
          return matchSearch && matchGedung && matchRuangan;
        }).toList();

    // Pagination
    final totalPages = (filteredBeds.length / _rowsPerPage).ceil();
    if (_currentPage >= totalPages && totalPages > 0) {
      _currentPage = totalPages - 1;
    }
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex =
        (_currentPage + 1) * _rowsPerPage > filteredBeds.length
            ? filteredBeds.length
            : (_currentPage + 1) * _rowsPerPage;
    final pageItems = filteredBeds.sublist(startIndex, endIndex);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          "Manajemen Bed",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _isMobile ? 18 : 20,
          ),
        ),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(_isMobile ? 8 : 16),
        child: Column(
          children: [
            // Filter Card
            _buildFilterCard(),

            SizedBox(height: _isMobile ? 12 : 20),

            // Results summary
            Card(
              child: Padding(
                padding: EdgeInsets.all(_isMobile ? 12 : 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade600,
                      size: _isMobile ? 20 : 24,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Menampilkan ${pageItems.length} dari ${filteredBeds.length} bed",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                          fontSize: _isMobile ? 12 : 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: _isMobile ? 12 : 16),

            // Data view (responsive)
            _buildResponsiveDataView(pageItems),

            SizedBox(height: _isMobile ? 16 : 24),

            // Pagination (responsive)
            _buildResponsivePagination(totalPages),
          ],
        ),
      ),
    );
  }
}
