import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HealthAnalyticsScreen extends StatefulWidget {
  const HealthAnalyticsScreen({super.key});

  @override
  State<HealthAnalyticsScreen> createState() => _HealthAnalyticsScreenState();
}

class _HealthAnalyticsScreenState extends State<HealthAnalyticsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final Color primaryBlue = const Color(0xFF0052CC);
  final Color secondaryBlue = const Color(0xFF2684FF);
  final Color accentTeal = const Color(0xFF00B8D4);
  final Color warningAmber = const Color(0xFFFF8F00);
  final Color successGreen = const Color(0xFF00C853);
  final Color errorRed = const Color(0xFFD32F2F);

  final List<Map<String, dynamic>> monthlyPatients = [
    {'month': 'Jan', 'outpatient': 42, 'inpatient': 18, 'emergency': 8},
    {'month': 'Feb', 'outpatient': 58, 'inpatient': 22, 'emergency': 12},
    {'month': 'Mar', 'outpatient': 74, 'inpatient': 28, 'emergency': 15},
    {'month': 'Apr', 'outpatient': 35, 'inpatient': 15, 'emergency': 9},
    {'month': 'May', 'outpatient': 92, 'inpatient': 35, 'emergency': 18},
    {'month': 'Jun', 'outpatient': 68, 'inpatient': 25, 'emergency': 14},
  ];

  /// Statistik departemen medis, menggunakan nama departemen sebagai kunci.
  /// Setiap nilai adalah Map yang berisi jumlah pasien, tingkat kepuasan, dan waktu tunggu.
  final Map<String, Map<String, dynamic>> departmentStats = {
    'Cardiology': {'patients': 156, 'satisfaction': 4.8, 'waitTime': 12},
    'Neurology': {'patients': 89, 'satisfaction': 4.6, 'waitTime': 18},
    'Pediatrics': {'patients': 234, 'satisfaction': 4.9, 'waitTime': 8},
    'Orthopedics': {'patients': 123, 'satisfaction': 4.5, 'waitTime': 22},
    'Emergency': {'patients': 76, 'satisfaction': 4.3, 'waitTime': 5},
  };

  final Map<String, double> ageDistribution = {
    '0-18': 18.5,
    '19-35': 32.8,
    '36-50': 28.4,
    '51-65': 15.7,
    '65+': 4.6,
  };

  final List<Map<String, dynamic>> recentTrends = [
    {
      'metric': 'Patient Satisfaction',
      'value': 4.7,
      'change': '+0.3',
      'trend': 'up',
    }, //kepuasan
    {
      'metric': 'Avg Wait Time',
      'value': 13.2,
      'change': '-2.1 min',
      'trend': 'down',
    }, //waktu tunggu
    {
      'metric': 'Bed Occupancy',
      'value': 87.5,
      'change': '+5.2%',
      'trend': 'up',
    }, // hunian tempat tidur
    {
      'metric': 'Staff Efficiency',
      'value': 92.8,
      'change': '+1.8%',
      'trend': 'up',
    }, //efisiensi staf
  ];

  @override
  void initState() {
    super.initState();
    // Inisialisasi TabController dengan 3 tab
    _tabController = TabController(length: 3, vsync: this);
    // Inisialisasi AnimationController dengan durasi 800ms
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    // Mendefinisikan animasi fade-in dari 0.0 (transparan) ke 1.0 (penuh)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Deteksi tema saat ini (terang atau gelap) untuk penyesuaian warna
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Tentukan warna latar belakang Scaffold
    final scaffoldBg =
        isDark ? const Color(0xFF0F1419) : const Color(0xFFF8FAFB);
    // Tentukan warna latar belakang card
    final cardColor = isDark ? const Color(0xFF1A1F29) : Colors.white;
    // Tentukan warna teks
    final textColor = isDark ? Colors.white : const Color(0xFF1A1F29);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: _buildAppBar(context),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildHeaderStats(cardColor, textColor),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(cardColor, textColor),
                  _buildDepartmentsTab(cardColor, textColor),
                  _buildTrendsTab(cardColor, textColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      title: const Text(
        'Health Analytics Dashboard',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
        IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {}),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Membangun baris kartu statistik utama di bagian atas layar.
  /// Menampilkan statistik penting seperti Total Pasien, Janji Temu, dan Kapasitas Tempat Tidur.
  Widget _buildHeaderStats(Color cardColor, Color textColor) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Patients',
              '1,247',
              '+12.5%',
              Icons.people_outline,
              successGreen,
              cardColor,
              textColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Appointments',
              '89',
              'Today',
              Icons.calendar_today_outlined,
              accentTeal,
              cardColor,
              textColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Bed Capacity',
              '87.5%',
              '+5.2%',
              Icons.local_hotel_outlined,
              warningAmber,
              cardColor,
              textColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Widget yang dapat digunakan kembali untuk membuat kartu statistik.
  /// Menerima parameter untuk judul, nilai, subjudul, ikon, dan warna.
  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color accentColor,
    Color cardColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: accentColor, size: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: textColor.withOpacity(0.7),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Membangun TabBar untuk navigasi di dalam dashboard.
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, primaryBlue.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: primaryBlue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        splashFactory: NoSplash.splashFactory,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        tabs: [
          _buildTab('Overview', Icons.dashboard_outlined),
          _buildTab('Departments', Icons.business_outlined),
          _buildTab('Trends', Icons.trending_up_outlined),
        ],
      ),
    );
  }

  Widget _buildTab(String text, IconData icon) {
    return Tab(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(icon, size: 18), const SizedBox(width: 6), Text(text)],
      ),
    );
  }

  Widget _buildOverviewTab(Color cardColor, Color textColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Patient Volume by Type', textColor),
          const SizedBox(height: 12),
          _buildPatientVolumeChart(cardColor, textColor),
          const SizedBox(height: 24),
          _buildSectionTitle('Age Demographics', textColor),
          const SizedBox(height: 12),
          _buildAgeDemographicsChart(cardColor, textColor),
        ],
      ),
    );
  }

  Widget _buildDepartmentsTab(Color cardColor, Color textColor) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: departmentStats.length,
      itemBuilder: (context, index) {
        final department = departmentStats.keys.elementAt(index);
        final stats = departmentStats[department]!;
        return _buildDepartmentCard(department, stats, cardColor, textColor);
      },
    );
  }

  Widget _buildTrendsTab(Color cardColor, Color textColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Key Performance Indicators', textColor),
          const SizedBox(height: 16),
          ...recentTrends.map(
            (trend) => _buildTrendCard(trend, cardColor, textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildPatientVolumeChart(Color cardColor, Color textColor) {
    return Container(
      height: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine:
                (value) =>
                    FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
          ),
          // Konfigurasi judul sumbu X dan Y
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 &&
                      value.toInt() < monthlyPatients.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        monthlyPatients[value.toInt()]['month'],
                        style: TextStyle(
                          color: textColor.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                  return const Text('');
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
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 11,
                    ),
                  );
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          // Mengonversi data bulanan menjadi grup bar chart
          barGroups:
              monthlyPatients
                  .asMap()
                  .entries
                  .map(
                    (e) => BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value['outpatient'].toDouble(),
                          color: warningAmber,
                          width: 14,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                        BarChartRodData(
                          toY: e.value['inpatient'].toDouble(),
                          color: accentTeal,
                          width: 14,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                        BarChartRodData(
                          toY: e.value['emergency'].toDouble(),
                          color: errorRed,
                          width: 14,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  /// Membangun Pie Chart untuk menunjukkan distribusi demografi usia.
  /// Chart ini menggunakan data dari [ageDistribution] dan menampilkan legenda
  /// untuk setiap kelompok usia.
  Widget _buildAgeDemographicsChart(Color cardColor, Color textColor) {
    return Container(
      height: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: PieChart(
              PieChartData(
                sections:
                    ageDistribution.entries.map((entry) {
                      final colors = [
                        primaryBlue,
                        accentTeal,
                        successGreen,
                        warningAmber,
                        errorRed,
                      ];
                      final index = ageDistribution.keys.toList().indexOf(
                        entry.key,
                      );
                      return PieChartSectionData(
                        value: entry.value,
                        title: '${entry.value.toStringAsFixed(1)}%',
                        radius: 60,
                        color: colors[index % colors.length],
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 35,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  ageDistribution.entries.map((entry) {
                    final colors = [
                      primaryBlue,
                      accentTeal,
                      successGreen,
                      warningAmber,
                      errorRed,
                    ];
                    final index = ageDistribution.keys.toList().indexOf(
                      entry.key,
                    );
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: colors[index % colors.length],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            entry.key,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
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
    );
  }

  /// Widget yang dapat digunakan kembali untuk membuat kartu departemen.
  /// Menampilkan statistik departemen seperti jumlah pasien, rating, dan waktu tunggu.
  Widget _buildDepartmentCard(
    String department,
    Map<String, dynamic> stats,
    Color cardColor,
    Color textColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                department,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: successGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Active',
                  style: TextStyle(
                    color: successGreen,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  'Patients',
                  stats['patients'].toString(),
                  Icons.people_outline,
                  primaryBlue,
                  textColor,
                ),
              ),
              Expanded(
                child: _buildMetricItem(
                  'Rating',
                  '${stats['satisfaction']}/5.0',
                  Icons.star_outline,
                  warningAmber,
                  textColor,
                ),
              ),
              Expanded(
                child: _buildMetricItem(
                  'Wait Time',
                  '${stats['waitTime']} min',
                  Icons.access_time,
                  accentTeal,
                  textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Widget pembantu untuk membuat item metrik dengan ikon dan label yang konsisten.
  Widget _buildMetricItem(
    String label,
    String value,
    IconData icon,
    Color color,
    Color textColor,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: textColor.withOpacity(0.7)),
        ),
      ],
    );
  }

  /// Widget yang dapat digunakan kembali untuk membuat kartu tren.
  /// Menampilkan metrik, nilai, dan perubahan tren.
  Widget _buildTrendCard(
    Map<String, dynamic> trend,
    Color cardColor,
    Color textColor,
  ) {
    final bool isPositive = trend['trend'] == 'up';
    final Color trendColor = isPositive ? successGreen : errorRed;
    final IconData trendIcon =
        isPositive ? Icons.trending_up : Icons.trending_down;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: trendColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(trendIcon, color: trendColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trend['metric'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                Text(
                  trend['value'].toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: trendColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              trend['change'],
              style: TextStyle(
                color: trendColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
