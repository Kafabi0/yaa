import 'package:flutter/material.dart';
import 'package:inocare/screens/qr_scanner.dart';
import 'package:intl/intl.dart';

class MedicalEquipmentScreen extends StatefulWidget {
  const MedicalEquipmentScreen({super.key});

  @override
  State<MedicalEquipmentScreen> createState() => _MedicalEquipmentScreenState();
}

class _MedicalEquipmentScreenState extends State<MedicalEquipmentScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  String searchQuery = '';
  String selectedCategory = 'All';
  String selectedStatus = 'All';

  final List<String> categories = [
    'All',
    'Diagnostic',
    'Therapeutic',
    'Life Support',
    'Monitoring',
    'Surgical',
    'Laboratory',
  ];

  final List<String> statusList = [
    'All',
    'Available',
    'In Use',
    'Maintenance',
    'Out of Order',
  ];

  final List<Map<String, dynamic>> equipment = [
    {
      'id': 'EQ001',
      'name': 'Ventilator Drager V500',
      'category': 'Life Support',
      'location': 'ICU Room 301',
      'status': 'In Use',
      'lastMaintenance': DateTime.now().subtract(const Duration(days: 15)),
      'nextMaintenance': DateTime.now().add(const Duration(days: 75)),
      'serialNumber': 'DRG-V500-2024-001',
      'condition': 'Excellent',
      'batteryLevel': 85,
      'operatingHours': 1247,
    },
    {
      'id': 'EQ002',
      'name': 'ECG Monitor Philips IntelliVue',
      'category': 'Monitoring',
      'location': 'Ward A Room 205',
      'status': 'Available',
      'lastMaintenance': DateTime.now().subtract(const Duration(days: 30)),
      'nextMaintenance': DateTime.now().add(const Duration(days: 60)),
      'serialNumber': 'PHI-IV-2024-002',
      'condition': 'Good',
      'batteryLevel': 92,
      'operatingHours': 3421,
    },
    {
      'id': 'EQ003',
      'name': 'Ultrasound GE Logiq E10',
      'category': 'Diagnostic',
      'location': 'Radiology Dept.',
      'status': 'Maintenance',
      'lastMaintenance': DateTime.now().subtract(const Duration(days: 2)),
      'nextMaintenance': DateTime.now().add(const Duration(days: 88)),
      'serialNumber': 'GE-LE10-2024-003',
      'condition': 'Fair',
      'batteryLevel': null,
      'operatingHours': 2156,
    },
    {
      'id': 'EQ004',
      'name': 'Defibrillator Zoll X Series',
      'category': 'Therapeutic',
      'location': 'Emergency Room',
      'status': 'Available',
      'lastMaintenance': DateTime.now().subtract(const Duration(days: 10)),
      'nextMaintenance': DateTime.now().add(const Duration(days: 80)),
      'serialNumber': 'ZOL-XS-2024-004',
      'condition': 'Excellent',
      'batteryLevel': 78,
      'operatingHours': 856,
    },
    {
      'id': 'EQ005',
      'name': 'Infusion Pump Baxter Sigma',
      'category': 'Therapeutic',
      'location': 'Ward B Room 312',
      'status': 'In Use',
      'lastMaintenance': DateTime.now().subtract(const Duration(days: 45)),
      'nextMaintenance': DateTime.now().add(const Duration(days: 45)),
      'serialNumber': 'BAX-SG-2024-005',
      'condition': 'Good',
      'batteryLevel': 65,
      'operatingHours': 4523,
    },
    {
      'id': 'EQ006',
      'name': 'X-Ray Machine Siemens Ysio',
      'category': 'Diagnostic',
      'location': 'Radiology Room 1',
      'status': 'Out of Order',
      'lastMaintenance': DateTime.now().subtract(const Duration(days: 5)),
      'nextMaintenance': DateTime.now().add(const Duration(days: 85)),
      'serialNumber': 'SIE-YS-2024-006',
      'condition': 'Needs Repair',
      'batteryLevel': null,
      'operatingHours': 6742,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return const Color(0xFF10B981);
      case 'in use':
        return const Color(0xFF3B82F6);
      case 'maintenance':
        return const Color(0xFFF59E0B);
      case 'out of order':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'diagnostic':
        return Icons.biotech_rounded;
      case 'therapeutic':
        return Icons.healing_rounded;
      case 'life support':
        return Icons.favorite_rounded;
      case 'monitoring':
        return Icons.monitor_heart_rounded;
      case 'surgical':
        return Icons.medical_services_rounded;
      case 'laboratory':
        return Icons.science_rounded;
      default:
        return Icons.medical_information_rounded;
    }
  }

  List<Map<String, dynamic>> get filteredEquipment {
    return equipment.where((item) {
      final matchesSearch =
          searchQuery.isEmpty ||
          item['name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          item['id'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          item['location'].toLowerCase().contains(searchQuery.toLowerCase());

      final matchesCategory =
          selectedCategory == 'All' || item['category'] == selectedCategory;

      final matchesStatus =
          selectedStatus == 'All' || item['status'] == selectedStatus;

      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();
  }

  void _showEquipmentDetails(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EquipmentDetailSheet(equipment: item),
    );
  }

  Widget _buildSearchAndFilters() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.grey[900] : Colors.white;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blueAccent.withOpacity(0.1),
                  Colors.blueAccent.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.withOpacity(0.15)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.search_rounded,
                      color: Colors.blueAccent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => searchQuery = v),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search equipment, ID, or location...',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Filter Row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey.shade200),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      icon: Icon(Icons.tune_rounded, size: 20, color: isDark ? Colors.white : Colors.black87),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => selectedCategory = value!),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey.shade200),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedStatus,
                      icon: Icon(Icons.filter_alt_rounded, size: 20, color: isDark ? Colors.white : Colors.black87),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      items: statusList.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => selectedStatus = value!),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentCard(Map<String, dynamic> item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.grey[900] : Colors.white;
    final borderColor = isDark ? Colors.grey[700]! : Colors.grey.shade200;

    final bool isUrgent =
        item['status'] == 'Out of Order' ||
        (item['nextMaintenance'] as DateTime).difference(DateTime.now()).inDays < 7;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUrgent ? Colors.red.withOpacity(0.3) : borderColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isUrgent
                ? Colors.red.withOpacity(0.08)
                : (isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.04)),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showEquipmentDetails(item),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: _getStatusColor(item['status']).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _getStatusColor(item['status']).withOpacity(0.3),
                        ),
                      ),
                      child: Icon(
                        _getCategoryIcon(item['category']),
                        color: _getStatusColor(item['status']),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(item['status']).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _getStatusColor(item['status']).withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  item['status'],
                                  style: TextStyle(
                                    color: _getStatusColor(item['status']),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ID: ${item['id']}',
                            style: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.grey.shade600,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: isDark ? Colors.grey[500] : Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item['location'],
                                style: TextStyle(
                                  color: isDark ? Colors.grey[400] : Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Condition',
                              style: TextStyle(
                                color: isDark ? Colors.grey[400] : Colors.grey.shade600,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['condition'],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: isDark ? Colors.grey[700] : Colors.grey.shade300,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Battery',
                              style: TextStyle(
                                color: isDark ? Colors.grey[400] : Colors.grey.shade600,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['batteryLevel'] != null
                                  ? '${item['batteryLevel']}%'
                                  : 'N/A',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: item['batteryLevel'] != null && item['batteryLevel'] < 20
                                    ? Colors.red
                                    : (isDark ? Colors.white : Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: isDark ? Colors.grey[700] : Colors.grey.shade300,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Hours',
                              style: TextStyle(
                                color: isDark ? Colors.grey[400] : Colors.grey.shade600,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${NumberFormat('#,###').format(item['operatingHours'])}h',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isUrgent)
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red.shade700,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item['status'] == 'Out of Order'
                                ? 'Equipment needs immediate attention'
                                : 'Maintenance due soon',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
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

  @override
  Widget build(BuildContext context) {
    final filteredData = filteredEquipment;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: isDark ? Colors.grey[900] : Colors.white,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                  ),
                ),
              ),
              title: const Text(
                'Medical Equipment',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.qr_code_scanner_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QRScannerScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(child: _buildSearchAndFilters()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                children: [
                  Text(
                    '${filteredData.length} Equipment Found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Text(
                      'Total: ${equipment.length}',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0.0, 0.1 * (index + 1)),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _fadeController,
                      curve: Interval(
                        0.1 * index,
                        0.5 + (0.1 * index),
                        curve: Curves.easeOut,
                      ),
                    ),
                  ),
                  child: _buildEquipmentCard(filteredData[index]),
                ),
              );
            }, childCount: filteredData.length),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

// -------------------- Equipment Detail Sheet --------------------

class _EquipmentDetailSheet extends StatelessWidget {
  final Map<String, dynamic> equipment;

  const _EquipmentDetailSheet({required this.equipment});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return const Color(0xFF10B981);
      case 'in use':
        return const Color(0xFF3B82F6);
      case 'maintenance':
        return const Color(0xFFF59E0B);
      case 'out of order':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.grey[900] : Colors.white;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[700] : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: _getStatusColor(equipment['status']).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getStatusColor(equipment['status']).withOpacity(0.3),
                          ),
                        ),
                        child: Icon(
                          Icons.medical_information_rounded,
                          color: _getStatusColor(equipment['status']),
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              equipment['name'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID: ${equipment['id']}',
                              style: TextStyle(
                                color: isDark ? Colors.grey[400] : Colors.grey.shade600,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(equipment['status']).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getStatusColor(equipment['status']).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          equipment['status'],
                          style: TextStyle(
                            color: _getStatusColor(equipment['status']),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _DetailSection(
                    title: 'Equipment Information',
                    children: [
                      _DetailRow('Category', equipment['category'], isDark: isDark),
                      _DetailRow('Location', equipment['location'], isDark: isDark),
                      _DetailRow('Serial Number', equipment['serialNumber'], isDark: isDark),
                      _DetailRow('Condition', equipment['condition'], isDark: isDark),
                      _DetailRow(
                        'Operating Hours',
                        '${NumberFormat('#,###').format(equipment['operatingHours'])} hours',
                        isDark: isDark,
                      ),
                      if (equipment['batteryLevel'] != null)
                        _DetailRow(
                          'Battery Level',
                          '${equipment['batteryLevel']}%',
                          isDark: isDark,
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _DetailSection(
                    title: 'Maintenance Schedule',
                    children: [
                      _DetailRow(
                        'Last Maintenance',
                        DateFormat('MMM dd, yyyy').format(equipment['lastMaintenance']),
                        isDark: isDark,
                      ),
                      _DetailRow(
                        'Next Maintenance',
                        DateFormat('MMM dd, yyyy').format(equipment['nextMaintenance']),
                        isDark: isDark,
                      ),
                      _DetailRow(
                        'Days Until Next',
                        '${equipment['nextMaintenance'].difference(DateTime.now()).inDays} days',
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.report_problem_rounded),
                          label: const Text('Report Issue'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.schedule_rounded),
                          label: const Text('Schedule'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
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

class _DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _DetailSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _DetailRow(this.label, this.value, {this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF1F2937),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
