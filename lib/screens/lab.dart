import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:excel/excel.dart' as excel;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';

class LabPage extends StatefulWidget {
  const LabPage({super.key});

  @override
  State createState() => _LabPageState();
}

class _LabPageState extends State<LabPage> {
  int selectedYear = 2025;
  int selectedMonth = 7;
  bool isLoading = false;


  final List<Map<String, dynamic>> data = [
    {
      "no": 1,
      "jenis":
          "Jaringan Biopsi Kecil Khusus - Esofagus, Gastrem Colon, Kulit",
      "umum": 12,
      "jknNonPbi": 8,
      "jknPbi": 5,
      "jamkesda": 3,
      "pemda": 7,
      "asuransi": 10,
      "covid": 0,
      "dinsos": 2,
    },
    {
      "no": 2,
      "jenis": "Jaringan Biopsi Kecil Khusus - Hati, Sum-Sum Tulang, Ginjal",
      "umum": 7,
      "jknNonPbi": 6,
      "jknPbi": 4,
      "jamkesda": 1,
      "pemda": 5,
      "asuransi": 8,
      "covid": 0,
      "dinsos": 1,
    },
    {
      "no": 3,
      "jenis": "Jaringan Biopsi Kecil - Ukuran jaringan < 3 cm",
      "umum": 15,
      "jknNonPbi": 12,
      "jknPbi": 8,
      "jamkesda": 4,
      "pemda": 6,
      "asuransi": 9,
      "covid": 0,
      "dinsos": 3,
    },
    {
      "no": 4,
      "jenis": "Sediaan Pap Smear",
      "umum": 20,
      "jknNonPbi": 15,
      "jknPbi": 10,
      "jamkesda": 5,
      "pemda": 8,
      "asuransi": 12,
      "covid": 0,
      "dinsos": 4,
    },
    {
      "no": 5,
      "jenis": "Pemeriksaan sitologi cairan tubuh",
      "umum": 18,
      "jknNonPbi": 14,
      "jknPbi": 7,
      "jamkesda": 3,
      "pemda": 6,
      "asuransi": 11,
      "covid": 0,
      "dinsos": 2,
    },
    {
      "no": 6,
      "jenis": "Imunohistokimia",
      "umum": 5,
      "jknNonPbi": 3,
      "jknPbi": 2,
      "jamkesda": 1,
      "pemda": 2,
      "asuransi": 4,
      "covid": 0,
      "dinsos": 1,
    },
    {
      "no": 7,
      "jenis": "Pemeriksaan jaringan besar",
      "umum": 10,
      "jknNonPbi": 8,
      "jknPbi": 5,
      "jamkesda": 2,
      "pemda": 4,
      "asuransi": 7,
      "covid": 0,
      "dinsos": 2,
    },
    {
      "no": 8,
      "jenis": "Pemeriksaan jaringan sedang",
      "umum": 14,
      "jknNonPbi": 10,
      "jknPbi": 6,
      "jamkesda": 3,
      "pemda": 5,
      "asuransi": 9,
      "covid": 0,
      "dinsos": 3,
    },
    {
      "no": 9,
      "jenis": "Pemeriksaan jaringan kecil",
      "umum": 22,
      "jknNonPbi": 18,
      "jknPbi": 12,
      "jamkesda": 6,
      "pemda": 9,
      "asuransi": 15,
      "covid": 0,
      "dinsos": 5,
    },
    {
      "no": 10,
      "jenis": "Jaringan Biopsi Khusus",
      "umum": 8,
      "jknNonPbi": 6,
      "jknPbi": 4,
      "jamkesda": 2,
      "pemda": 3,
      "asuransi": 5,
      "covid": 0,
      "dinsos": 1,
    },
  ];

  int _rowsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    final dataSource = _LabDataSource(data);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPageHeader(isSmallScreen),
                  const SizedBox(height: 24),
                  _buildFilterSection(isSmallScreen),
                  const SizedBox(height: 24),
                  _buildSummaryCards(isSmallScreen),
                  const SizedBox(height: 24),
                  _buildDataTableContainer(constraints, dataSource, screenWidth),
                  const SizedBox(height: 24),
                  _buildBottomActions(isSmallScreen),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDataTableContainer(
      BoxConstraints constraints, DataTableSource dataSource, double screenWidth) {
    return Container(
      height: constraints.maxHeight > 600 ? 500 : 350,
      width: constraints.maxWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: isLoading ? _buildLoadingState() : _buildDataTable(dataSource, screenWidth),
      ),
    );
  }

  Widget _buildDataTable(DataTableSource dataSource, double screenWidth) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: screenWidth < 1000 ? 1000 : screenWidth,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Theme(
            data: Theme.of(context).copyWith(
              cardTheme: CardThemeData(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              dividerTheme: const DividerThemeData(
                thickness: 1,
                space: 0,
              ),
            ),
            child: PaginatedDataTable(
              header: null, 
              rowsPerPage: _rowsPerPage,
              onRowsPerPageChanged: (value) {
                if (value != null) {
                  setState(() {
                    _rowsPerPage = value;
                  });
                }
              },
              availableRowsPerPage: const [5, 10, 20],
              columnSpacing: 24,
              horizontalMargin: 20,
              showCheckboxColumn: false,
              headingRowHeight: 56,
              // dataRowHeight deprecated → use min & max:
              dataRowMinHeight: 64,
              dataRowMaxHeight: 64,
              columns: _buildColumns(),
              source: dataSource,
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    final TextStyle headerStyle = GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF334155),
    );
    return [
      DataColumn(
        label: Text("No", style: headerStyle),
      ),
      DataColumn(
        label: SizedBox(
          width: 300, // Fixed width for the examination type column
          child: Text("Jenis Pemeriksaan", style: headerStyle),
        ),
      ),
      DataColumn(
        label: Text("Umum", style: headerStyle),
        numeric: true,
      ),
      DataColumn(
        label: Text("JKN Non PBI", style: headerStyle),
        numeric: true,
      ),
      DataColumn(
        label: Text("JKN PBI", style: headerStyle),
        numeric: true,
      ),
      DataColumn(
        label: Text("Jamkesda", style: headerStyle),
        numeric: true,
      ),
      DataColumn(
        label: Text("Pemda", style: headerStyle),
        numeric: true,
      ),
      DataColumn(
        label: Text("Asuransi", style: headerStyle),
        numeric: true,
      ),
      DataColumn(
        label: Text("Covid", style: headerStyle),
        numeric: true,
      ),
      DataColumn(
        label: Text("Dinsos", style: headerStyle),
        numeric: true,
      ),
    ];
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            color: Color(0xFF0369A1),
          ),
          SizedBox(height: 16),
          Text(
            "Memuat data...",
            style: TextStyle(
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0369A1),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Laboratorium Patologi Anatomi',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline, color: Colors.white),
          onPressed: () {
            // Show help dialog
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {
            // Show notifications
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildPageHeader(bool isSmallScreen) {
    if (isSmallScreen) {
      // Stacked layout for small screens
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0369A1).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.science_outlined,
                  color: Color(0xFF0369A1),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Laporan Pemeriksaan Lab PA',
                      style: GoogleFonts.poppins(
                        fontSize: 18, // Slightly smaller for small screens
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Data pemeriksaan laboratorium patologi anatomi',
                      style: GoogleFonts.inter(
                        fontSize: 12, // Smaller for small screens
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDateDisplay(), // Date below on small screens
        ],
      );
    } else {
      // Side-by-side layout for larger screens
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0369A1).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.science_outlined,
              color: Color(0xFF0369A1),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Laporan Pemeriksaan Lab PA',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),
              Text(
                'Data pemeriksaan laboratorium patologi anatomi',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const Spacer(),
          _buildDateDisplay(),
        ],
      );
    }
  }

  Widget _buildDateDisplay() {
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('dd MMMM yyyy').format(currentDate);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Prevent overflow
        children: [
          const Icon(
            Icons.calendar_today,
            size: 16,
            color: Color(0xFF0369A1),
          ),
          const SizedBox(width: 8),
          Text(
            formattedDate,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(bool isSmallScreen) {
    final monthNames = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Data',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Pilih periode waktu untuk melihat data',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 20),

          // Responsive filter layout
          if (isSmallScreen)
            // Stacked layout for small screens
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Year filter
                Text(
                  'Tahun',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 8),
                _buildDropdown(
                  value: selectedYear,
                  items: List.generate(6, (index) => 2020 + index),
                  itemBuilder: (year) => year.toString(),
                  onChanged: (val) => setState(() => selectedYear = val!),
                ),
                const SizedBox(height: 16),

                // Month filter
                Text(
                  'Bulan',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 8),
                _buildDropdown(
                  value: selectedMonth,
                  items: List.generate(12, (index) => index + 1),
                  itemBuilder: (month) => monthNames[month - 1],
                  onChanged: (val) => setState(() => selectedMonth = val!),
                ),
                const SizedBox(height: 16),

                // Search button (full width on small screens)
                SizedBox(
                  width: double.infinity,
                  child: _buildSearchButton(),
                ),
              ],
            )
          else
            // Row layout for larger screens
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tahun',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDropdown(
                        value: selectedYear,
                        items: List.generate(6, (index) => 2020 + index),
                        itemBuilder: (year) => year.toString(),
                        onChanged: (val) => setState(() => selectedYear = val!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bulan',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDropdown(
                        value: selectedMonth,
                        items: List.generate(12, (index) => index + 1),
                        itemBuilder: (month) => monthNames[month - 1],
                        onChanged: (val) => setState(() => selectedMonth = val!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 21),// Align with dropdowns
                      _buildSearchButton(),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

    Widget _buildSummaryCards(bool isSmallScreen) {
    int totalExaminations = data.fold(
        0,
        (sum, item) =>
            sum +
            (item['umum'] as int) +
            (item['jknNonPbi'] as int) +
            (item['jknPbi'] as int) +
            (item['jamkesda'] as int) +
            (item['pemda'] as int) +
            (item['asuransi'] as int) +
            (item['covid'] as int) +
            (item['dinsos'] as int));
    int totalJKN =
        data.fold(0, (sum, item) => sum + (item['jknNonPbi'] as int) + (item['jknPbi'] as int));
    int totalAsuransi = data.fold(0, (sum, item) => sum + (item['asuransi'] as int));

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.science,
            title: 'Total Pemeriksaan',
            value: totalExaminations.toString(),
            color: const Color(0xFF0369A1),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.health_and_safety,
            title: 'Total JKN',
            value: totalJKN.toString(),
            color: const Color(0xFF0891B2),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            icon: Icons.shield,
            title: 'Total Asuransi',
            value: totalAsuransi.toString(),
            color: const Color(0xFF059669),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required String Function(T) itemBuilder,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true, // Prevent text overflow
      items: items.map<DropdownMenuItem<T>>((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            itemBuilder(item),
            style: GoogleFonts.inter(
              color: const Color(0xFF334155),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis, // Handle overflow gracefully
          ),
        );
      }).toList(),
      onChanged: onChanged,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Color(0xFF64748B),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFCBD5E1),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFCBD5E1),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF0369A1),
            width: 1.5,
          ),
        ),
      ),
      dropdownColor: Colors.white,
    );
  }

  Widget _buildSearchButton() {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          isLoading = true;
        });
        // Simulate loading
        Future.delayed(const Duration(milliseconds: 800), () {
          if (!mounted) return;
          setState(() {
            isLoading = false;
          });
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0369A1),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      icon: const Icon(Icons.search, size: 18),
      label: Text(
        "Cari Data",
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBottomActions(bool isSmallScreen) {
    if (isSmallScreen) {
      // Stacked buttons for small screens
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton.icon(
            onPressed: _exportToExcel,
            icon: const Icon(Icons.table_chart, size: 18),
            label: Text(
              "Export Excel",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0369A1),
              side: const BorderSide(color: Color(0xFF0369A1), width: 1.5),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _downloadPdfReport,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0369A1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.print, size: 18),
            label: Text(
              "Cetak Laporan",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    } else {
      // Row layout for larger screens
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton.icon(
            onPressed: _exportToExcel,
            icon: const Icon(Icons.table_chart, size: 18),
            label: Text(
              "Export Excel",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0369A1),
              side: const BorderSide(color: Color(0xFF0369A1), width: 1.5),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: _downloadPdfReport,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0369A1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.print, size: 18),
            label: Text(
              "Cetak Laporan",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    }
  }

  // Helper: konversi dynamic ke CellValue untuk paket excel v4
  excel.CellValue _toCellValue(dynamic v) {
    if (v == null) return excel.TextCellValue('');
    if (v is int) return excel.IntCellValue(v);
    if (v is double) return excel.DoubleCellValue(v);
    return excel.TextCellValue(v.toString());
  }

  Future<void> _exportToExcel() async {
    try {
      final ex = excel.Excel.createExcel();
      final defaultSheetName = ex.getDefaultSheet();
      if (defaultSheetName == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membuat sheet default')),
        );
        return;
      }
      final sheet = ex.sheets[defaultSheetName];
      if (sheet == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sheet tidak ditemukan')),
        );
        return;
      }

      // Header
      final headers = [
        "No",
        "Jenis Pemeriksaan",
        "Umum",
        "JKN Non PBI",
        "JKN PBI",
        "Jamkesda",
        "Pemda",
        "Asuransi",
        "Covid",
        "Dinsos"
      ].map<excel.CellValue>((h) => excel.TextCellValue(h)).toList();
      sheet.appendRow(headers);

      // Data rows
      for (var rowData in data) {
        sheet.appendRow([
          _toCellValue(rowData['no']),
          _toCellValue(rowData['jenis']),
          _toCellValue(rowData['umum']),
          _toCellValue(rowData['jknNonPbi']),
          _toCellValue(rowData['jknPbi']),
          _toCellValue(rowData['jamkesda']),
          _toCellValue(rowData['pemda']),
          _toCellValue(rowData['asuransi']),
          _toCellValue(rowData['covid']),
          _toCellValue(rowData['dinsos']),
        ]);
      }

      // Save Excel
      final bytes = ex.save();
      if (bytes == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan Excel')),
        );
        return;
      }

      final String timestamp =
          DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
      final String fileName = 'Laporan_Lab_PA_$timestamp.xlsx';

      final Directory tempDir = await getTemporaryDirectory();
      final File file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(bytes);

      // Coba buka file
      final uri = Uri.file(file.path);
      final canOpen = await canLaunchUrl(uri);
      if (canOpen) {
        await launchUrl(uri);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File tersimpan di: ${file.path}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal export Excel: $e')),
      );
    }
  }

Future<void> _downloadPdfReport() async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Center(
          child: pw.Text(
            "LAPORAN PEMERIKSAAN LAB PATOLOGI ANATOMI",
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Table.fromTextArray(
          headers: ["No","Jenis Pemeriksaan","Umum","JKN Non PBI","JKN PBI","Jamkesda","Pemda","Asuransi","Covid","Dinsos"],
          data: data.map((row) => [
            row["no"].toString(),
            row["jenis"],
            row["umum"].toString(),
            row["jknNonPbi"].toString(),
            row["jknPbi"].toString(),
            row["jamkesda"].toString(),
            row["pemda"].toString(),
            row["asuransi"].toString(),
            row["covid"].toString(),
            row["dinsos"].toString(),
          ]).toList(),
          border: pw.TableBorder.all(),
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
          cellAlignment: pw.Alignment.center,
        ),
      ],
    ),
  );

  try {
    // ✅ Minta izin akses full storage (Android 11+)
    var status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Izin penyimpanan ditolak")),
      );
      return;
    }

    // ✅ Simpan ke folder Download
    final downloadPath = "/storage/emulated/0/Download";
    final filePath = "$downloadPath/laporan_lab.pdf";
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF berhasil disimpan di: $filePath")),
    );
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Gagal membuat PDF: $e")),
    );
  }
}
}

/// Data Source untuk PaginatedDataTable
class _LabDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  _LabDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final row = data[index];
    final textStyle = GoogleFonts.inter(
      fontSize: 14,
      color: const Color(0xFF334155),
    );

    final numberStyle = GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF334155),
    );

    return DataRow(
      cells: [
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF0369A1).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              row["no"].toString(),
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0369A1),
              ),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 300, // Fixed width to prevent overflow
            child: Text(
              row["jenis"],
              style: textStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
        DataCell(Text(row["umum"].toString(), style: numberStyle),
            showEditIcon: false),
        DataCell(Text(row["jknNonPbi"].toString(), style: numberStyle)),
        DataCell(Text(row["jknPbi"].toString(), style: numberStyle)),
        DataCell(Text(row["jamkesda"].toString(), style: numberStyle)),
        DataCell(Text(row["pemda"].toString(), style: numberStyle)),
        DataCell(Text(row["asuransi"].toString(), style: numberStyle)),
        DataCell(Text(row["covid"].toString(), style: numberStyle)),
        DataCell(Text(row["dinsos"].toString(), style: numberStyle)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
