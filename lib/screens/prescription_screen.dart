import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PrescriptionManagementScreen extends StatelessWidget {
  const PrescriptionManagementScreen({super.key});

  final List<Map<String, dynamic>> prescriptions = const [
    {
      'name': 'Paracetamol',
      'dosage': '500mg',
      'frequency': '3x sehari',
      'duration': 5,
      'icon': FontAwesomeIcons.pills,
      'color': Color(0xFF4F46E5),
      'prescriptionDate': '25 Aug 2025',
      'createdDate': '24 Aug 2025',
      'prescriptionNo': 'RX001',
    },
    {
      'name': 'Amoxicillin',
      'dosage': '250mg',
      'frequency': '2x sehari',
      'duration': 7,
      'icon': FontAwesomeIcons.capsules,
      'color': Color(0xFF0EA5E9),
      'prescriptionDate': '24 Aug 2025',
      'createdDate': '23 Aug 2025',
      'prescriptionNo': 'RX002',
    },
    {
      'name': 'Vitamin C',
      'dosage': '1000mg',
      'frequency': '1x sehari',
      'duration': 30,
      'icon': FontAwesomeIcons.tablets,
      'color': Color(0xFFF59E0B),
      'prescriptionDate': '20 Aug 2025',
      'createdDate': '19 Aug 2025',
      'prescriptionNo': 'RX003',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardBackgroundColor = isDark ? const Color(0xFF2D3748) : Colors.white;
    final Color textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final Color secondaryTextColor = isDark ? Colors.white70 : const Color(0xFF64748B);
    final Color tertiaryTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8);
    final Color cardShadowColor = isDark ? Colors.transparent : Colors.black26;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF2D3748), const Color(0xFF1A202C)]
                      : [const Color(0xFF4F46E5), const Color(0xFF6366F1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                title: Text(
                  "Prescription Management",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: isDark ? Colors.white : Colors.white,
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTotalCard(context),
                  const SizedBox(height: 28),
                  Text(
                    'Active Prescriptions',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final p = prescriptions[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Card(
                      elevation: isDark ? 0 : 8,
                      shadowColor: cardShadowColor,
                      color: cardBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PrescriptionDetailScreen(
                              prescription: p,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: p['color'].withValues(alpha: isDark ? 0.3 : 0.15), 
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  p['icon'],
                                  color: p['color'],
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p['name'],
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${p['dosage']} • ${p['frequency']}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: secondaryTextColor,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "${p['duration']} hari",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: p['color'],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: tertiaryTextColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }, childCount: prescriptions.length),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            label: const Text(
              "Add Prescription",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  Widget _buildTotalCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<Color> gradientColors = isDark
        ? [const Color(0xFF2D3748), const Color(0xFF1A202C)]
        : [const Color(0xFF4F46E5), const Color(0xFF6366F1)];
    
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.transparent : Colors.black26,
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25), // FIXED
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              FontAwesomeIcons.prescription,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Prescriptions',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 6),
                Text(
                  '3 Active',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PrescriptionDetailScreen extends StatelessWidget {
  final Map<String, dynamic> prescription;
  const PrescriptionDetailScreen({super.key, required this.prescription});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color appBarColor = isDark ? const Color(0xFF2D3748) : Colors.white;
    final Color textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final Color secondaryTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final Color cardBackgroundColor = isDark ? const Color(0xFF2D3748) : Colors.white;
    final Color cardShadowColor = isDark ? Colors.transparent : Colors.black12;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appBarColor,
        foregroundColor: textColor,
        title: Text(
          prescription['name'],
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      prescription['color'].withValues(alpha: isDark ? 0.7 : 0.9), // FIXED
                      prescription['color'],
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.transparent : prescription['color'].withValues(alpha: 0.3), // FIXED
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15), // FIXED
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        prescription['icon'],
                        size: 44,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      prescription['name'],
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "No. Resep: ${prescription['prescriptionNo']}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      "Tanggal Resep: ${prescription['prescriptionDate']}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildDetailRow(
                Icons.medical_services,
                "Dosage",
                prescription['dosage'],
                context,
              ),
              _buildDetailRow(
                Icons.schedule,
                "Frequency",
                prescription['frequency'],
                context,
              ),
              _buildDetailRow(
                Icons.calendar_today,
                "Duration",
                "${prescription['duration']} hari",
                context,
              ),
              _buildDetailRow(
                Icons.date_range,
                "Created Date",
                prescription['createdDate'],
                context,
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final Color secondaryTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final Color cardBackgroundColor = isDark ? const Color(0xFF2D3748) : Colors.white;
    final Color cardShadowColor = isDark ? Colors.transparent : Colors.black12;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: cardShadowColor,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4F46E5)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: secondaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
