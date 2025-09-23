import 'package:flutter/material.dart';

class BloodAvailabilityPage extends StatefulWidget {
  const BloodAvailabilityPage({super.key});

  @override
  State<BloodAvailabilityPage> createState() => _BloodAvailabilityPageState();
}

class _BloodAvailabilityPageState extends State<BloodAvailabilityPage>
    with TickerProviderStateMixin {
  bool _onlyAvailable = false;
  String _selectedFilter = "Semua Tipe";
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  final List<String> _filterOptions = [
    "Semua Tipe",
    "Rhesus Positif",
    "Rhesus Negatif",
    "Golongan A",
    "Golongan B",
    "Golongan AB",
    "Golongan O"
  ];

  final List<BloodInfo> _bloods = [
    BloodInfo("A+", 5, "Tersedia", Colors.green, "Stok Baik", 150),
    BloodInfo("A-", 2, "Terbatas", Colors.orange, "Stok Terbatas", 80),
    BloodInfo("B+", 8, "Tersedia", Colors.green, "Stok Baik", 250),
    BloodInfo("B-", 1, "Kritis", Colors.red, "Stok Kritis", 30),
    BloodInfo("AB+", 3, "Tersedia", Colors.green, "Stok Cukup", 120),
    BloodInfo("AB-", 0, "Kosong", Colors.red, "Stok Habis", 0),
    BloodInfo("O+", 12, "Tersedia", Colors.green, "Stok Melimpah", 450),
    BloodInfo("O-", 4, "Tersedia", Colors.green, "Stok Cukup", 180),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 650),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<BloodInfo> get filteredBloods {
    var filtered = _bloods.where((blood) {
      if (_onlyAvailable && blood.count == 0) return false;

      switch (_selectedFilter) {
        case "Rhesus Positif":
          return blood.title.contains("+");
        case "Rhesus Negatif":
          return blood.title.contains("-");
        case "Golongan A":
          return blood.title.startsWith("A");
        case "Golongan B":
          return blood.title.startsWith("B");
        case "Golongan AB":
          return blood.title.startsWith("AB");
        case "Golongan O":
          return blood.title.startsWith("O");
        default:
          return true;
      }
    }).toList();

    filtered.sort((a, b) {
      if (a.status == "Kritis" && b.status != "Kritis") return -1;
      if (b.status == "Kritis" && a.status != "Kritis") return 1;
      if (a.status == "Kosong" && b.status != "Kosong") return 1;
      if (b.status == "Kosong" && a.status != "Kosong") return -1;
      return b.count.compareTo(a.count);
    });

    return filtered;
  }

  double _getResponsiveValue(BuildContext context,
      {required double mobile, required double tablet, required double desktop}) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return mobile;
    if (width < 1200) return tablet;
    return desktop;
  }

  int _getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 350) {
      return 1; // layar sangat kecil → 1 kolom
    } else if (width < 600) {
      return 2; // layar sedang → 2 kolom
    } else {
      return 3; // layar lebar → 3 kolom
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardPadding =
        _getResponsiveValue(context, mobile: 10, tablet: 14, desktop: 18);
    final headerHeight =
        _getResponsiveValue(context, mobile: 260, tablet: 300, desktop: 340);
    final titleFont =
        _getResponsiveValue(context, mobile: 20, tablet: 22, desktop: 24);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: LayoutBuilder(
        builder: (context, constraints) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                expandedHeight: headerHeight,
                flexibleSpace: FlexibleSpaceBar(
                  background:
                      _buildHeader(context, headerHeight, cardPadding, titleFont),
                ),
              ),

              // Filter & pencarian
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: cardPadding, vertical: cardPadding * 0.8),
                  child: _buildFilterCard(cardPadding),
                ),
              ),

              // Grid of blood cards (responsif)
              SliverPadding(
                padding: EdgeInsets.symmetric(
                    horizontal: cardPadding, vertical: cardPadding * 0.3),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final blood = filteredBloods[index];
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildBloodCard(blood, cardPadding),
                      );
                    },
                    childCount: filteredBloods.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _getCrossAxisCount(context),
                    mainAxisSpacing: cardPadding,
                    crossAxisSpacing: cardPadding,
                    childAspectRatio:
                        constraints.maxWidth < 350 ? 0.95 : 1.02, // biar proporsional
                  ),
                ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEmergencyDialog(context),
        backgroundColor: Colors.red,
        icon: const Icon(Icons.emergency),
        label: const Text("Darurat"),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, double headerHeight, double padding, double titleFont) {
    final totalAvailable = _bloods.where((b) => b.count > 0).length;
    final totalCritical =
        _bloods.where((b) => b.status == "Kritis" || b.status == "Kosong").length;
    final totalUnits =
        _bloods.fold<int>(0, (sum, b) => sum + b.totalUnits);

    return Container(
      height: headerHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE53E3E), Color(0xFFFC8181)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Text("Bank Darah",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: titleFont,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text("Ketersediaan Labu Darah",
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: _getResponsiveValue(context,
                          mobile: 12, tablet: 13, desktop: 14))),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _headerStatItem("Tersedia", "$totalAvailable/8", Colors.white),
                    _dividerVertical(),
                    _headerStatItem("Kritis", "$totalCritical", Colors.white),
                    _dividerVertical(),
                    _headerStatItem("Total Unit (ml)", "$totalUnits", Colors.white),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roundedIconButton({
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor),
        ),
      ),
    );
  }

  Widget _dividerVertical() {
    return Container(
      height: 36,
      width: 1,
      color: Colors.white.withOpacity(0.12),
    );
  }

  Widget _headerStatItem(String label, String value, Color textColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value,
            style: TextStyle(
                color: textColor, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                color: textColor.withOpacity(0.9), fontSize: 11)),
      ],
    );
  }

  Widget _buildFilterCard(double padding) {
    final fontSize =
        _getResponsiveValue(context, mobile: 14, tablet: 15, desktop: 16);
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text("Filter & Pencarian",
                    style:
                        TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedFilter = "Semua Tipe";
                    _onlyAvailable = false;
                  });
                },
                icon: const Icon(Icons.refresh, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filterOptions.map((opt) {
                final sel = opt == _selectedFilter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(opt, style: TextStyle(fontSize: 12)),
                    selected: sel,
                    onSelected: (_) {
                      setState(() => _selectedFilter = opt);
                    },
                    selectedColor: Colors.red.shade100,
                    backgroundColor: Colors.grey.shade100,
                    labelStyle:
                        TextStyle(color: sel ? Colors.red : Colors.black87),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: Text("Tampilkan Hanya yang Tersedia",
                      style: TextStyle(fontSize: 13))),
              Switch(
                value: _onlyAvailable,
                activeColor: Colors.red,
                onChanged: (v) => setState(() => _onlyAvailable = v),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBloodCard(BloodInfo blood, double padding) {
    final double progress =
        blood.count == 0 ? 0.0 : (blood.count / 15).clamp(0.0, 1.0);
    final color = blood.color;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showBloodDetailDialog(context, blood),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(blood.title,
                          style: TextStyle(
                              color: color, fontWeight: FontWeight.bold)),
                    ),
                    Icon(
                        blood.count == 0
                            ? Icons.warning_amber_rounded
                            : Icons.water_drop,
                        color: color),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(blood.count.toString(),
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: color)),
                        const SizedBox(height: 4),
                        Text("Labu",
                            style: TextStyle(color: Colors.grey[700])),
                        const SizedBox(height: 8),
                        Text(blood.description,
                            style: TextStyle(
                                color: color.withOpacity(0.9),
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Stok",
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 12)),
                    Text("${(progress * 100).toInt()}%",
                        style: TextStyle(
                            color: color, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBloodDetailDialog(BuildContext context, BloodInfo blood) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(children: [
          Icon(Icons.water_drop, color: blood.color),
          const SizedBox(width: 8),
          Text("Golongan ${blood.title}")
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow("Status", blood.status, blood.color),
            _buildDetailRow("Jumlah Labu", "${blood.count}", Colors.black87),
            _buildDetailRow("Total Unit", "${blood.totalUnits} ml", Colors.black87),
            const SizedBox(height: 12),
            if (blood.count > 0)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Permintaan ${blood.title} sedang diproses"),
                        backgroundColor: blood.color));
                  },
                  icon: const Icon(Icons.send),
                  label: const Text("Ajukan Permintaan"),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup"))
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700])),
          Text(value,
              style: TextStyle(color: valueColor, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permintaan Darurat"),
        content: const Text(
            "Apakah Anda memerlukan darah untuk keperluan darurat? Tim medis akan segera menghubungi Anda."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Permintaan darurat telah dikirim."),
                  backgroundColor: Colors.red));
            },
            child: const Text("Kirim Permintaan"),
          ),
        ],
      ),
    );
  }
}

class BloodInfo {
  final String title;
  final int count;
  final String status;
  final Color color;
  final String description;
  final int totalUnits;

  BloodInfo(
      this.title, this.count, this.status, this.color, this.description, this.totalUnits);
}
