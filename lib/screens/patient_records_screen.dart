import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PatientRecordsScreen extends StatefulWidget {
  final Map<String, List<Map<String, String>>> appointments;

  const PatientRecordsScreen({super.key, required this.appointments});

  @override
  State<PatientRecordsScreen> createState() => _PatientRecordsScreenState();
}

class _PatientRecordsScreenState extends State<PatientRecordsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  String query = "";
  String selectedFilter = 'All';
  String sortBy = 'Name';

  final List<String> filterOptions = ['All', 'Recent', 'Frequent', 'VIP'];
  final List<String> sortOptions = ['Name', 'Last Visit', 'Doctor'];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  List<Map<String, String>> _extractPatients() {
    final Set<String> seen = {};
    final List<Map<String, String>> patients = [];

    widget.appointments.forEach((date, apptList) {
      for (var appt in apptList) {
        final patientName = appt['patient'] ?? 'Unknown';
        if (!seen.contains(patientName)) {
          seen.add(patientName);
          patients.add({
            'name': patientName,
            'id':
                patientName.substring(0, 2).toUpperCase() +
                patientName.hashCode.toString().substring(0, 4),
            'doctor': appt['doctor'] ?? '-',
            'lastVisit': date,
            'avatar': appt['avatar'] ?? '',
            'hospital': appt['hospital'] ?? 'General Hospital',
            'doctorRating': appt['doctorRating'] ?? '4',
            'hospitalRating': appt['hospitalRating'] ?? '5',
            'review': appt['review'] ?? 'Good service.',
            'age': appt['age'] ?? '35',
            'gender': appt['gender'] ?? 'Male',
            'bloodType': appt['bloodType'] ?? 'O+',
            'phone': appt['phone'] ?? '+1234567890',
            'condition': appt['condition'] ?? 'Stable',
          });
        }
      }
    });

    // Apply search filter
    var filteredPatients = patients;
    if (query.isNotEmpty) {
      filteredPatients =
          patients
              .where(
                (p) =>
                    p['name']!.toLowerCase().contains(query.toLowerCase()) ||
                    p['id']!.toLowerCase().contains(query.toLowerCase()) ||
                    p['doctor']!.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }

    // Apply category filter
    switch (selectedFilter) {
      case 'Recent':
        filteredPatients =
            filteredPatients
                .where((p) => _isRecentVisit(p['lastVisit'] ?? ''))
                .toList();
        break;
      case 'Frequent':
        // Simulate frequent patients logic
        filteredPatients = filteredPatients.take(5).toList();
        break;
      case 'VIP':
        // Simulate VIP patients logic
        filteredPatients = filteredPatients.take(3).toList();
        break;
    }

    // Sort patients
    switch (sortBy) {
      case 'Name':
        filteredPatients.sort((a, b) => a['name']!.compareTo(b['name']!));
        break;
      case 'Last Visit':
        filteredPatients.sort(
          (a, b) => b['lastVisit']!.compareTo(a['lastVisit']!),
        );
        break;
      case 'Doctor':
        filteredPatients.sort((a, b) => a['doctor']!.compareTo(b['doctor']!));
        break;
    }

    return filteredPatients;
  }

  bool _isRecentVisit(String date) {
    try {
      final visitDate = DateTime.tryParse(date);
      if (visitDate != null) {
        final daysDiff = DateTime.now().difference(visitDate).inDays;
        return daysDiff <= 7;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  String _formatLastVisit(String date) {
    try {
      final visitDate = DateTime.tryParse(date);
      if (visitDate != null) {
        final daysDiff = DateTime.now().difference(visitDate).inDays;
        if (daysDiff == 0) return 'Today';
        if (daysDiff == 1) return 'Yesterday';
        if (daysDiff < 7) return '$daysDiff days ago';
        return DateFormat('MMM dd, yyyy').format(visitDate);
      }
    } catch (e) {
      return date;
    }
    return date;
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface, // Perbaikan di sini
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
        ),
    ),
    child: Row(
        children: [
            Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 20,
                ),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: TextField(
                    onChanged: (v) => setState(() => query = v),
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                        color: Theme.of(context).colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search patients, ID, or doctor...',
                        hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            fontWeight: FontWeight.w400,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                ),
            ),
            if (query.isNotEmpty)
                GestureDetector(
                    onTap: () => setState(() => query = ''),
                    child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                            Icons.close_rounded,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            size: 18,
                        ),
                    ),
                ),
        ],
    ),
),
          const SizedBox(height: 16),

          // Filter and Sort Row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedFilter,
                      icon: Icon(
                        Icons.filter_list_rounded,
                        size: 20,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      items:
                          filterOptions.map((filter) {
                            return DropdownMenuItem(
                              value: filter,
                              child: Text(filter),
                            );
                          }).toList(),
                      onChanged:
                          (value) => setState(() => selectedFilter = value!),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: sortBy,
                      icon: Icon(
                        Icons.sort_rounded,
                        size: 20,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      items:
                          sortOptions.map((sort) {
                            return DropdownMenuItem(
                              value: sort,
                              child: Text('Sort by $sort'),
                            );
                          }).toList(),
                      onChanged: (value) => setState(() => sortBy = value!),
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

  Widget _buildPatientCard(Map<String, String> patient, int index) {
    final isVIP = index < 3; // Simulate VIP status
    final isRecentVisit = _isRecentVisit(patient['lastVisit'] ?? '');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isVIP
              ? Colors.amber.withOpacity(0.3)
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          width: isVIP ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isVIP
                ? Colors.amber.withOpacity(0.1)
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.04),
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PatientDetailScreen(patient: patient),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: patient['id']!,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child:
                              patient['avatar']!.isNotEmpty
                                  ? Image.network(
                                    patient['avatar']!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                        child: Icon(
                                          Icons.person_rounded,
                                          size: 30,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                      );
                                    },
                                  )
                                  : Container(
                                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                    child: Icon(
                                      Icons.person_rounded,
                                      size: 30,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                        ),
                      ),
                    ),
                    if (isVIP)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    if (isRecentVisit)
                      Positioned(
                        left: -2,
                        bottom: -2,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.schedule_rounded,
                            color: Colors.white,
                            size: 10,
                          ),
                        ),
                      ),
                  ],
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
                              patient["name"]!,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (isVIP)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'VIP',
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${patient["id"]}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.medical_services_rounded,
                            size: 14,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Dr. ${patient["doctor"]}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatLastVisit(patient["lastVisit"]!),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 16,
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
    final patients = _extractPatients();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.surface,
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
                'Patient Records',
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
                  icon: const Icon(Icons.add_rounded, color: Colors.white),
                  onPressed: () {
                    // Add new patient functionality
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
                    '${patients.length} Patients Found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      'Active: ${patients.where((p) => _isRecentVisit(p['lastVisit'] ?? '')).length}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          patients.isEmpty
              ? SliverToBoxAdapter(
                child: SizedBox(
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No patient records found",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Try adjusting your search or filters",
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : SliverList(
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
                      child: _buildPatientCard(patients[index], index),
                    ),
                  );
                }, childCount: patients.length),
              ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

// Premium Patient Detail Screen
class PatientDetailScreen extends StatefulWidget {
  final Map<String, String> patient;

  const PatientDetailScreen({super.key, required this.patient});

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Widget _buildStarRating(int rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
            color: i < rating
                ? const Color(0xFFFFA726)
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            size: 22,
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required Widget content,
    IconData? icon,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (iconColor ?? Colors.blue).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor ?? Colors.blue, size: 20),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 18,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctorRating =
        int.tryParse(widget.patient['doctorRating'] ?? '0') ?? 0;
    final hospitalRating =
        int.tryParse(widget.patient['hospitalRating'] ?? '0') ?? 0;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.surface,
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
                'Patient Details',
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
                  icon: const Icon(Icons.share_rounded, color: Colors.white),
                  onPressed: () {
                    // Share patient info functionality
                  },
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Patient Header Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Hero(
                            tag: widget.patient['id']!,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.secondary,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child:
                                    widget.patient['avatar']!.isNotEmpty
                                        ? Image.network(
                                          widget.patient['avatar']!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                              child: Icon(
                                                Icons.person_rounded,
                                                size: 50,
                                                color: Theme.of(context).colorScheme.secondary,
                                              ),
                                            );
                                          },
                                        )
                                        : Container(
                                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                          child: Icon(
                                            Icons.person_rounded,
                                            size: 50,
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                        ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            widget.patient["name"] ?? 'Unknown Patient',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              'ID: ${widget.patient["id"]}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Patient Information Card
                    _buildInfoCard(
                      title: 'Patient Information',
                      icon: Icons.person_outline_rounded,
                      iconColor: Colors.blue,
                      content: Column(
                        children: [
                          _buildInfoRow(
                            'Age',
                            widget.patient['age'] ?? '35',
                            icon: Icons.cake_rounded,
                          ),
                          _buildInfoRow(
                            'Gender',
                            widget.patient['gender'] ?? 'Male',
                            icon: Icons.accessibility_rounded,
                          ),
                          _buildInfoRow(
                            'Blood Type',
                            widget.patient['bloodType'] ?? 'O+',
                            icon: Icons.bloodtype_rounded,
                          ),
                          _buildInfoRow(
                            'Phone',
                            widget.patient['phone'] ?? '+1234567890',
                            icon: Icons.phone_rounded,
                          ),
                          _buildInfoRow(
                            'Condition',
                            widget.patient['condition'] ?? 'Stable',
                            icon: Icons.health_and_safety_rounded,
                          ),
                        ],
                      ),
                    ),

                    // Medical Team Card
                    _buildInfoCard(
                      title: 'Medical Team',
                      icon: Icons.medical_services_rounded,
                      iconColor: Colors.green,
                      content: Column(
                        children: [
                          _buildInfoRow(
                            'Doctor',
                            'Dr. ${widget.patient['doctor'] ?? 'Not assigned'}',
                            icon: Icons.local_hospital_rounded,
                          ),
                          _buildInfoRow(
                            'Hospital',
                            widget.patient['hospital'] ?? 'Not specified',
                            icon: Icons.business_rounded,
                          ),
                          _buildInfoRow(
                            'Last Visit',
                            widget.patient['lastVisit'] ?? 'N/A',
                            icon: Icons.schedule_rounded,
                          ),
                        ],
                      ),
                    ),

                    // Ratings & Reviews Card
                    _buildInfoCard(
                      title: 'Experience Rating',
                      icon: Icons.star_rounded,
                      iconColor: Colors.amber,
                      content: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.amber.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Doctor Rating',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                      ),
                                    ),
                                    Text(
                                      '$doctorRating/5',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                _buildStarRating(doctorRating),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Hospital Rating',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                      ),
                                    ),
                                    Text(
                                      '$hospitalRating/5',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                _buildStarRating(hospitalRating),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Review Card
                    _buildInfoCard(
                      title: 'Patient Review',
                      icon: Icons.reviews_rounded,
                      iconColor: Colors.purple,
                      content: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          widget.patient['review'] ??
                              'No review available from this patient.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.onSurface,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Call patient functionality
                            },
                            icon: const Icon(Icons.phone_rounded),
                            label: const Text('Call Patient'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                            },
                            icon: const Icon(Icons.calendar_today_rounded),
                            label: const Text('Schedule'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // View medical history functionality
                        },
                        icon: const Icon(Icons.history_rounded),
                        label: const Text('View Medical History'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                          foregroundColor: Theme.of(context).colorScheme.onSurface,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}