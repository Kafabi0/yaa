import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

// Definisi warna yang lebih profesional
const Color primaryBlue = Color(0xFF3B82F6);
const Color secondaryRed = Color(0xFFEF4444);
const Color darkBg = Color(0xFF0F172A);
const Color darkCard = Color(0xFF1E293B);

class PatientMonitoring extends StatefulWidget {
  const PatientMonitoring({super.key});

  @override
  State<PatientMonitoring> createState() => _PatientMonitoringState();
}

class _PatientMonitoringState extends State<PatientMonitoring> {
  final List<Map<String, dynamic>> patients = const [
    {
      "name": "Budi Santoso",
      "hospital": "RS Citra Medika",
      "status": "Stabil",
      "heartRate": 78,
      "bloodPressure": "120/80",
      "oxygen": 98
    },
    {
      "name": "Siti Aminah",
      "hospital": "RS Sehat Sentosa",
      "status": "Perlu Perhatian",
      "heartRate": 105,
      "bloodPressure": "140/95",
      "oxygen": 92
    },
    {
      "name": "Andi Wijaya",
      "hospital": "RS Banten Sejahtera",
      "status": "Stabil",
      "heartRate": 82,
      "bloodPressure": "118/79",
      "oxygen": 97
    },
    {
      "name": "Dewi Kusuma",
      "hospital": "RS Citra Medika",
      "status": "Stabil",
      "heartRate": 75,
      "bloodPressure": "115/75",
      "oxygen": 99
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Patient Monitoring",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryBlue,
        elevation: 0,
      ),
      backgroundColor: isDark ? darkBg : const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Grafik Tren Detak Jantung
            _buildChartCard(isDark),
            const SizedBox(height: 24),

            /// Bagian Daftar Pasien
            Text(
              "Daftar Pasien",
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            /// Daftar Kartu Pasien
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildPatientCard(patient, isDark),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.transparent : Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tren Detak Jantung (bpm)",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChartSample(isDark: isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(Map<String, dynamic> patient, bool isDark) {
    final statusColor = patient["status"] == "Stabil" ? Colors.green : secondaryRed;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? darkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isDark ? null : Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.transparent : Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: primaryBlue.withOpacity(0.1),
            child: Icon(Icons.person, color: primaryBlue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient["name"],
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  patient["hospital"],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "HR: ${patient["heartRate"]} bpm | BP: ${patient["bloodPressure"]} | O₂: ${patient["oxygen"]}%",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              patient["status"],
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LineChartSample extends StatelessWidget {
  final bool isDark;
  const LineChartSample({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final gridColor = isDark ? Colors.white12 : Colors.grey.shade200;
    final textColor = isDark ? Colors.white60 : Colors.black54;

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 6,
        minY: 60,
        maxY: 120,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                const titles = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    titles[value.toInt()],
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: textColor,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                if (value == 70 || value == 90 || value == 110) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: textColor,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: gridColor,
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 72),
              FlSpot(1, 75),
              FlSpot(2, 80),
              FlSpot(3, 76),
              FlSpot(4, 85),
              FlSpot(5, 78),
              FlSpot(6, 82),
            ],
            isCurved: true,
            color: primaryBlue,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  primaryBlue.withOpacity(0.5),
                  primaryBlue.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}