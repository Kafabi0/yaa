import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/pasien_transaksi.dart';
import '../widgets/pasien_service.dart';
import '../widgets/transaksi_service.dart';

class TransPage extends StatefulWidget {
  const TransPage({super.key});

  @override
  State<TransPage> createState() => _TransPageState();
}

class _TransPageState extends State<TransPage> with TickerProviderStateMixin {
  List<Pasien> pasienList = [];
  List<ChartData> allBarChartData = [];
  List<ChartData> barChartData = [];
  List<ChartData> pieChartData = [];
  bool loading = true;
  int? selectedPasienId;
  String selectedMonth = 'Semua';
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  
  final List<String> monthList = [
    'Semua', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];
  
  final List<Color> monthColors = [
    const Color(0xFF6366F1), // Indigo
    const Color(0xFF10B981), // Emerald
    const Color(0xFFF59E0B), // Amber
    const Color(0xFF8B5CF6), // Violet
    const Color(0xFFEF4444), // Red
    const Color(0xFF14B8A6), // Teal
    const Color(0xFFF97316), // Orange
    const Color(0xFF3B82F6), // Blue
    const Color(0xFFEC4899), // Pink
    const Color(0xFF06B6D4), // Cyan
    const Color(0xFF84CC16), // Lime
    const Color(0xFFA855F7), // Purple
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    fetchData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    setState(() => loading = true);
    try {
      pasienList = await PasienService.getAllPasien();
      if (pasienList.isNotEmpty) selectedPasienId = pasienList.first.id;
      if (selectedPasienId != null) await loadChart(selectedPasienId!);
    } catch (e) {
      debugPrint("Error: $e");
    }
    setState(() => loading = false);
    _animationController.forward();
  }

  Future<void> loadChart(int pasienId) async {
    allBarChartData = await TransaksiService.getBarChart(pasienId);
    pieChartData = await TransaksiService.getPieChart(pasienId);
    filterBarChart();
  }

  void filterBarChart() {
    barChartData = selectedMonth == 'Semua'
        ? allBarChartData
        : allBarChartData
            .where((e) => formatMonth(e.bulan).startsWith(selectedMonth))
            .toList();
  }

  void changePasien(int pasienId) async {
    setState(() {
      selectedPasienId = pasienId;
      loading = true;
      barChartData = [];
      pieChartData = [];
      allBarChartData = [];
    });
    await loadChart(pasienId);
    setState(() => loading = false);
    _animationController.reset();
    _animationController.forward();
  }

  void changeMonth(String? month) {
    if (month == null) return;
    setState(() {
      selectedMonth = month;
      filterBarChart();
    });
    _animationController.reset();
    _animationController.forward();
  }

  String formatMonth(String ym) {
    final parts = ym.split('-');
    if (parts.length != 2) return ym;
    const monthNames = {
      "01": "Januari", "02": "Februari", "03": "Maret", "04": "April",
      "05": "Mei", "06": "Juni", "07": "Juli", "08": "Agustus",
      "09": "September", "10": "Oktober", "11": "November", "12": "Desember",
    };
    return "${monthNames[parts[1]] ?? ym} ${parts[0]}";
  }

  Color getMonthColor(String ym) {
    final parts = ym.split('-');
    if (parts.length != 2) return monthColors[0];
    int index = int.tryParse(parts[1]) ?? 1;
    return monthColors[(index - 1) % monthColors.length];
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required dynamic value,
    required List<DropdownMenuItem> items,
    required ValueChanged onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          DropdownButton(
            value: value,
            onChanged: onChanged,
            items: items,
            isExpanded: true,
            underline: const SizedBox(),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalTransaksi = barChartData.fold<int>(
      0,
      (sum, item) => sum + item.total,
    );
    final rataRata = barChartData.isNotEmpty
        ? (totalTransaksi / barChartData.length).round()
        : 0;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Dashboard Transaksi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey.shade200),
        ),
      ),
      body: loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(monthColors[0]),
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Memuat data...",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : pasienList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_off_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Tidak ada data pasien",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollStartNotification) {
                      _animationController.stop();
                    } else if (notification is ScrollEndNotification) {
                      _animationController.forward();
                    }
                    return false;
                  },
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Filter Section
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Filter Data",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildDropdown(
                                          label: "Pilih Pasien",
                                          value: selectedPasienId,
                                          items: pasienList
                                              .map<DropdownMenuItem<int>>(
                                            (p) {
                                              return DropdownMenuItem<int>(
                                                value: p.id,
                                                child: Text(p.name),
                                              );
                                            },
                                          ).toList(),
                                          onChanged: (v) {
                                            if (v != null) changePasien(v);
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _buildDropdown(
                                          label: "Filter Bulan",
                                          value: selectedMonth,
                                          items: monthList
                                              .map<DropdownMenuItem<String>>(
                                            (m) {
                                              return DropdownMenuItem<String>(
                                                value: m,
                                                child: Text(m),
                                              );
                                            },
                                          ).toList(),
                                          onChanged: (v) {
                                            if (v != null) changeMonth(v);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Statistics Cards
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    title: "Total Transaksi",
                                    value: totalTransaksi.toString(),
                                    icon: Icons.receipt_long,
                                    color: monthColors[0],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildStatCard(
                                    title: "Rata-rata",
                                    value: rataRata.toString(),
                                    icon: Icons.trending_up,
                                    color: monthColors[1],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Chart Section
                            const Text(
                              "Analisis Data",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Bar Chart
                            BarChartWidget(
                              data: barChartData,
                              getColor: getMonthColor,
                              formatMonth: formatMonth,
                            ),
                            const SizedBox(height: 24),
                            // Pie Chart
                            PieChartWidget(
                              data: pieChartData,
                              monthColors: monthColors,
                              formatMonth: formatMonth,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}

// ================= BAR CHART WIDGET =================
class BarChartWidget extends StatelessWidget {
  final List<ChartData> data;
  final Color Function(String) getColor;
  final String Function(String) formatMonth;

  const BarChartWidget({
    required this.data,
    required this.getColor,
    required this.formatMonth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart, color: Colors.grey.shade600, size: 24),
              const SizedBox(width: 8),
              const Text(
                "Grafik Transaksi per Bulan",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 280,
            child: RepaintBoundary(
              child: data.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.insert_chart_outlined,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Tidak ada data untuk ditampilkan",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : BarChart(
                      BarChartData(
                        maxY: data
                                .map((e) => e.total)
                                .reduce((a, b) => a > b ? a : b)
                                .toDouble() +
                            10,
                        barGroups: data.asMap().map((i, e) => MapEntry(
                              i,
                              BarChartGroupData(
                                x: i,
                                barRods: [
                                  BarChartRodData(
                                    toY: e.total.toDouble(),
                                    color: getColor(e.bulan),
                                    width: 22,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(6),
                                    ),
                                  ),
                                ],
                              ),
                            )).values.toList(),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >= data.length) return const SizedBox();
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    formatMonth(data[value.toInt()].bulan),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 10,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.shade200,
                              strokeWidth: 1,
                            );
                          },
                        ),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= PIE CHART WIDGET =================
class PieChartWidget extends StatelessWidget {
  final List<ChartData> data;
  final List<Color> monthColors;
  final String Function(String) formatMonth;

  const PieChartWidget({
    required this.data,
    required this.monthColors,
    required this.formatMonth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pie_chart, color: Colors.grey.shade600, size: 24),
              const SizedBox(width: 8),
              const Text(
                "Distribusi Transaksi",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 280,
            child: RepaintBoundary(
              child: data.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.pie_chart_outline,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Tidak ada data untuk ditampilkan",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: RepaintBoundary(
                            child: PieChart(
                              PieChartData(
                                sections: data.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final e = entry.value;
                                  return PieChartSectionData(
                                    value: e.total.toDouble(),
                                    color: monthColors[index % monthColors.length],
                                    title: "${e.total}",
                                    radius: 50, // Diperkecil dari 70
                                    titleStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10, // Font lebih kecil
                                    ),
                                  );
                                }).toList(),
                                centerSpaceRadius: 30, // Diperkecil dari 50
                                sectionsSpace: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16), // Diperkecil dari 20
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: data.asMap().entries.map((entry) {
                              final index = entry.key;
                              final e = entry.value;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2), // Diperkecil dari 4
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10, // Diperkecil dari 12
                                      height: 10, // Diperkecil dari 12
                                      decoration: BoxDecoration(
                                        color: monthColors[index % monthColors.length],
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 6), // Diperkecil dari 8
                                    Expanded(
                                      child: Text(
                                        formatMonth(e.bulan),
                                        style: const TextStyle(
                                          fontSize: 9, // Font lebih kecil
                                          color: Colors.black87,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}