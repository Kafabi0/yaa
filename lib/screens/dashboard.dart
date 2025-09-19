import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:inocare/screens/diklat_screen.dart';
import 'package:inocare/screens/farmasi_screen.dart';
import 'package:inocare/screens/pegawai_screen.dart';
import 'package:inocare/screens/rekam_medik_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../screens/lab.dart';

class DashboardReporting extends StatelessWidget {
  const DashboardReporting({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    final isDesktop = screenWidth >= 1200;

    final List<Map<String, dynamic>> menuItems = [
      {
        "title": "Diklat",
        "icon": MdiIcons.school,
        // "color": Colors.indigo,
        "page": const DiklatScreen(),
      },
      {
        "title": "Kepegawaian",
        "icon": MdiIcons.accountStar,
        // "color": Colors.blueGrey,
        "page": const PegawaiScreen(),
      },
      {
        "title": "Rekam Medis",
        "icon": MdiIcons.folderAccount,
        // "color": Colors.deepPurple,
        "page": const RekamMedisPage(),
      },
      {
        "title": "Lab",
        "icon": MdiIcons.waterOutline,
        // "color": Colors.redAccent,
        "page": const LabPage(),
      },
      {
        "title": "Farmasi",
        "icon": MdiIcons.pillMultiple,
        // "color": Colors.redAccent,
        "page": const FarmasiScreen(),
      },
      {
        "title": "JKN",
        "icon": MdiIcons.zipBoxOutline,
        // "color": Colors.redAccent,
        "page": const DummyPage(title: "JKN"),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard Rumah Sakit",
          style: TextStyle(
            fontSize:
                isDesktop
                    ? 24
                    : isTablet
                    ? 20
                    : 18,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer(); // buka drawer kanan
                },
              );
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Center(
                child: Text(
                  "Menu Utama",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ...menuItems.map((item) {
              return ListTile(
                leading: Icon(item["icon"]
                , color: Colors.grey[600]),
                title: Text(item["title"]),
                onTap: () {
                  Navigator.pop(context); // tutup drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => item["page"]),
                  );
                },
              );
            }).toList(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          isDesktop
              ? 24
              : isTablet
              ? 20
              : 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Statistics Cards
            Text(
              "Statistik Hari Ini",
              style: TextStyle(
                fontSize:
                    isDesktop
                        ? 24
                        : isTablet
                        ? 22
                        : 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: isDesktop ? 20 : 16),

            // Statistics Cards - Responsive Grid
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount;
                double childAspectRatio;

                if (constraints.maxWidth >= 1200) {
                  crossAxisCount = 6; // Desktop: 6 cards in one row
                  childAspectRatio = 1.1;
                } else if (constraints.maxWidth >= 800) {
                  crossAxisCount = 3; // Tablet: 3 cards in one row
                  childAspectRatio = 1.0;
                } else {
                  crossAxisCount = 2; // Mobile: 2 cards in one row
                  childAspectRatio = 1.2;
                }

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: isTablet ? 16 : 12,
                  mainAxisSpacing: isTablet ? 16 : 12,
                  childAspectRatio: childAspectRatio,
                  children: [
                    _buildStatCard(
                      "Pasien Aktif",
                      "142",
                      Icons.person,
                      Colors.green,
                      isDesktop,
                      isTablet,
                    ),
                    _buildStatCard(
                      "Pasien Baru",
                      "28",
                      Icons.person_add,
                      Colors.blue,
                      isDesktop,
                      isTablet,
                    ),
                    _buildStatCard(
                      "Lab Test",
                      "67",
                      Icons.science,
                      Colors.orange,
                      isDesktop,
                      isTablet,
                    ),
                    _buildStatCard(
                      "Bed Tersedia",
                      "18/50",
                      Icons.bed,
                      Colors.purple,
                      isDesktop,
                      isTablet,
                    ),
                    _buildStatCard(
                      "Dokter On Duty",
                      "12",
                      Icons.medical_services,
                      Colors.teal,
                      isDesktop,
                      isTablet,
                    ),
                    _buildStatCard(
                      "Emergency",
                      "5",
                      Icons.local_hospital,
                      Colors.red,
                      isDesktop,
                      isTablet,
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: isDesktop ? 32 : 24),

            // Charts Section
            Text(
              "Grafik & Analisis",
              style: TextStyle(
                fontSize:
                    isDesktop
                        ? 24
                        : isTablet
                        ? 22
                        : 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: isDesktop ? 20 : 16),

            // Charts Layout - Responsive
            if (isDesktop) ...[
              // Desktop: Two charts side by side
              Row(
                children: [
                  Expanded(
                    child: _buildPatientAdmissionChart(isDesktop, isTablet),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _buildOnlineQueueChart(isDesktop, isTablet)),
                ],
              ),
              const SizedBox(height: 16),
              _buildMonthlyVisitChart(isDesktop, isTablet),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildDepartmentPieChart(isDesktop, isTablet),
                  ),
                  const SizedBox(width: 16),
                  // Expanded(child: _buildMenuGrid(menuItems, isDesktop, isTablet)),
                ],
              ),
            ] else ...[
              // Mobile/Tablet: Stacked layout
              _buildPatientAdmissionChart(isDesktop, isTablet),
              const SizedBox(height: 16),
              _buildOnlineQueueChart(isDesktop, isTablet),
              const SizedBox(height: 16),
              _buildMonthlyVisitChart(isDesktop, isTablet),
              const SizedBox(height: 16),
              _buildDepartmentPieChart(isDesktop, isTablet),
              const SizedBox(height: 24),

              // Menu Navigation Section
              // Text(
              //   "Menu Utama",
              //   style: TextStyle(
              //     fontSize:
              //         isDesktop
              //             ? 24
              //             : isTablet
              //             ? 22
              //             : 20,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.black87,
              //   ),
              // ),
              // const SizedBox(height: 16),
              // _buildMenuGrid(menuItems, isDesktop, isTablet),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isDesktop,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(
        isDesktop
            ? 20
            : isTablet
            ? 16
            : 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isDesktop ? 16 : 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size:
                isDesktop
                    ? 36
                    : isTablet
                    ? 32
                    : 28,
          ),
          SizedBox(height: isDesktop ? 12 : 8),
          Text(
            value,
            style: TextStyle(
              fontSize:
                  isDesktop
                      ? 24
                      : isTablet
                      ? 20
                      : 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: isDesktop ? 8 : 4),
          Text(
            title,
            style: TextStyle(
              fontSize:
                  isDesktop
                      ? 14
                      : isTablet
                      ? 13
                      : 12,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPatientAdmissionChart(bool isDesktop, bool isTablet) {
    return Container(
      height:
          isDesktop
              ? 300
              : isTablet
              ? 280
              : 250,
      padding: EdgeInsets.all(isDesktop ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Admisi Pasien (7 Hari Terakhir)",
            style: TextStyle(
              fontSize: isDesktop ? 18 : 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = [
                          'Sen',
                          'Sel',
                          'Rab',
                          'Kam',
                          'Jum',
                          'Sab',
                          'Min',
                        ];
                        return Text(
                          days[value.toInt()],
                          style: TextStyle(fontSize: isTablet ? 12 : 10),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 20),
                      FlSpot(1, 35),
                      FlSpot(2, 28),
                      FlSpot(3, 42),
                      FlSpot(4, 38),
                      FlSpot(5, 25),
                      FlSpot(6, 30),
                    ],
                    isCurved: true,
                    color: Colors.blueAccent,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blueAccent.withOpacity(0.1),
                    ),
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnlineQueueChart(bool isDesktop, bool isTablet) {
    return Container(
      height:
          isDesktop
              ? 400
              : isTablet
              ? 380
              : 350,
      padding: EdgeInsets.all(isDesktop ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Antrian Online",
            style: TextStyle(
              fontSize: isDesktop ? 20 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          // Legend with responsive layout
          Wrap(
            spacing: isTablet ? 16 : 8,
            runSpacing: 8,
            children: [
              _buildLegendDot(Colors.green, "Sistem Registrasi", isTablet),
              _buildLegendDot(Colors.red, "Billing Portal", isTablet),
              _buildLegendDot(Colors.yellow, "Antrian Internal", isTablet),
              _buildLegendDot(Colors.blue, "General", isTablet),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 250,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = ['Jan', 'Feb', 'Mar', 'Apr'];
                        if (value.toInt() < months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              months[value.toInt()],
                              style: TextStyle(
                                fontSize: isTablet ? 12 : 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(fontSize: isTablet ? 10 : 8),
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
                borderData: FlBorderData(show: false),
                barGroups: [
                  _buildBarGroup(0, 180, 45, 92, 78),
                  _buildBarGroup(1, 165, 52, 84, 116),
                  _buildBarGroup(2, 92, 38, 72, 118),
                  _buildBarGroup(3, 140, 85, 95, 142),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyVisitChart(bool isDesktop, bool isTablet) {
    return Container(
      height:
          isDesktop
              ? 400
              : isTablet
              ? 380
              : 350,
      padding: EdgeInsets.all(isDesktop ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Responsive header
          isDesktop || isTablet
              ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Kunjungan Pasien Per Bulan",
                    style: TextStyle(
                      fontSize: isDesktop ? 18 : 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  _buildControlsRow(isDesktop, isTablet),
                ],
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Kunjungan Pasien Per Bulan",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildControlsRow(isDesktop, isTablet),
                ],
              ),
          const SizedBox(height: 20),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 1200,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const dates = [
                          '01',
                          '03',
                          '05',
                          '07',
                          '09',
                          '11',
                          '13',
                          '15',
                          '17',
                          '19',
                          '21',
                          '23',
                          '25',
                          '27',
                          '29',
                          '31',
                        ];
                        if (value.toInt() < dates.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              dates[value.toInt()],
                              style: TextStyle(
                                fontSize: isTablet ? 10 : 8,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(fontSize: isTablet ? 10 : 8),
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
                borderData: FlBorderData(show: false),
                barGroups: [
                  _buildSingleBar(0, 650),
                  _buildSingleBar(1, 473),
                  _buildSingleBar(2, 136),
                  _buildSingleBar(3, 914),
                  _buildSingleBar(4, 852),
                  _buildSingleBar(5, 823),
                  _buildSingleBar(6, 1024),
                  _buildSingleBar(7, 734),
                  _buildSingleBar(8, 425),
                  _buildSingleBar(9, 1037),
                  _buildSingleBar(10, 891),
                  _buildSingleBar(11, 1014),
                  _buildSingleBar(12, 1018),
                  _buildSingleBar(13, 673),
                  _buildSingleBar(14, 204),
                  _buildSingleBar(15, 136),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlsRow(bool isDesktop, bool isTablet) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 12 : 8,
            vertical: isTablet ? 6 : 4,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text("2025", style: TextStyle(fontSize: isTablet ? 12 : 10)),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 12 : 8,
            vertical: isTablet ? 6 : 4,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            "Agustus",
            style: TextStyle(fontSize: isTablet ? 12 : 10),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 12 : 8,
              vertical: isTablet ? 6 : 4,
            ),
            minimumSize: Size(0, isTablet ? 32 : 28),
          ),
          child: Text(
            "Refresh Data",
            style: TextStyle(fontSize: isTablet ? 12 : 10, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildDepartmentPieChart(bool isDesktop, bool isTablet) {
    return Container(
      height:
          isDesktop
              ? 350
              : isTablet
              ? 320
              : 300,
      padding: EdgeInsets.all(isDesktop ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Distribusi Pasien per Departemen",
            style: TextStyle(
              fontSize: isDesktop ? 18 : 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child:
                isTablet
                    ? Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: isDesktop ? 60 : 50,
                              sections: _getPieChartSections(
                                isDesktop,
                                isTablet,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLegendItem(
                                "Penyakit Dalam",
                                Colors.blue,
                                isTablet,
                              ),
                              _buildLegendItem("Bedah", Colors.green, isTablet),
                              _buildLegendItem("Anak", Colors.orange, isTablet),
                              _buildLegendItem(
                                "Kandungan",
                                Colors.purple,
                                isTablet,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                    :
                    // Mobile: Stacked layout
                    Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                              sections: _getPieChartSections(
                                isDesktop,
                                isTablet,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildLegendItem(
                              "Penyakit Dalam",
                              Colors.blue,
                              isTablet,
                            ),
                            _buildLegendItem("Bedah", Colors.green, isTablet),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildLegendItem("Anak", Colors.orange, isTablet),
                            _buildLegendItem(
                              "Kandungan",
                              Colors.purple,
                              isTablet,
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

  List<PieChartSectionData> _getPieChartSections(
    bool isDesktop,
    bool isTablet,
  ) {
    double radius =
        isDesktop
            ? 70
            : isTablet
            ? 60
            : 50;
    double fontSize =
        isDesktop
            ? 14
            : isTablet
            ? 12
            : 10;

    return [
      PieChartSectionData(
        value: 35,
        title: '35%',
        color: Colors.blue,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: 25,
        title: '25%',
        color: Colors.green,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: 20,
        title: '20%',
        color: Colors.orange,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: 20,
        title: '20%',
        color: Colors.purple,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }
  Widget _buildLegendItem(String label, Color color, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isTablet ? 6 : 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isTablet ? 16 : 12,
            height: isTablet ? 16 : 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: isTablet ? 8 : 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isTablet ? 12 : 10,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label, bool isTablet) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isTablet ? 12 : 10,
          height: isTablet ? 12 : 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: isTablet ? 6 : 4),
        Text(
          label,
          style: TextStyle(fontSize: isTablet ? 10 : 9, color: Colors.black87),
        ),
      ],
    );
  }

  BarChartGroupData _buildBarGroup(
    int x,
    double sistem,
    double billing,
    double antrian,
    double general,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: sistem,
          color: Colors.green,
          width: 12,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2),
            topRight: Radius.circular(2),
          ),
        ),
        BarChartRodData(
          toY: billing,
          color: Colors.red,
          width: 12,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2),
            topRight: Radius.circular(2),
          ),
        ),
        BarChartRodData(
          toY: antrian,
          color: Colors.yellow[700]!,
          width: 12,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2),
            topRight: Radius.circular(2),
          ),
        ),
        BarChartRodData(
          toY: general,
          color: Colors.blue,
          width: 12,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2),
            topRight: Radius.circular(2),
          ),
        ),
      ],
    );
  }

  BarChartGroupData _buildSingleBar(int x, double value) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: Colors.blue,
          width: 16,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    );
  }
}

/// Halaman dummy untuk contoh navigasi
class DummyPage extends StatelessWidget {
  final String title;
  const DummyPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text("Ini halaman $title", style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
