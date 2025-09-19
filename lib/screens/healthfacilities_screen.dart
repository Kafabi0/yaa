import 'package:flutter/material.dart';
import '../data/health_facilities_data.dart';
import '../models/health_facility_model.dart';
import 'health_facility_detail.dart';

class HealthFacilitiesScreen extends StatefulWidget {
  const HealthFacilitiesScreen({super.key});

  @override
  State<HealthFacilitiesScreen> createState() => _HealthFacilitiesScreenState();
}

class _HealthFacilitiesScreenState extends State<HealthFacilitiesScreen> {
  final List<HealthFacility> facilities = healthFacilities;

  String searchQuery = '';
  String selectedProvince = 'All';
  String selectedType = 'All';
  final Color primaryColor = const Color(0xFF0A6CFF);
  final Color secondaryColor = const Color(0xFF00CCFF);

  final List<String> provinces = [
    'All',
    'DKI Jakarta',
    'Jawa Barat',
    'Banten',
    'Jawa Timur',
  ];

  final List<String> types = ['All', 'Hospital', 'Puskesmas', 'Clinic'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white70 : Colors.white70;
    final searchBgColor = isDark ? const Color(0xFF2D2D2D) : Colors.white;
    final hintColor = isDark ? Colors.white54 : Colors.black54;

    final filtered =
        facilities.where((f) {
          final matchName = f.name.toLowerCase().contains(
            searchQuery.toLowerCase(),
          );
          final matchProvince =
              selectedProvince == 'All' || f.province == selectedProvince;
          final matchType = selectedType == 'All' || f.type == selectedType;
          return matchName && matchProvince && matchType;
        }).toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(isDark, subtitleColor),
          SliverToBoxAdapter(
            child: _buildSearchAndFilters(
              isDark,
              searchBgColor,
              hintColor,
              textColor,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = filtered[index];
                return AnimatedOpacityTranslate(
                  child: HealthFacilityCard(
                    facility: item,
                    primaryColor: primaryColor,
                    isDark: isDark,
                    cardColor: cardColor,
                    textColor: textColor,
                    onTap:
                        () => Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (_, __, ___) => HealthFacilityDetail(
                                  facility: item,
                                  primaryColor: primaryColor,
                                ),
                            transitionsBuilder:
                                (_, anim, __, child) =>
                                    FadeTransition(opacity: anim, child: child),
                            transitionDuration: const Duration(
                              milliseconds: 600,
                            ),
                          ),
                        ),
                  ),
                );
              }, childCount: filtered.length),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(bool isDark, Color subtitleColor) {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [primaryColor, secondaryColor]),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: isDark ? 0.05 : 0.1,
                  child: Image.asset(
                    'assets/rumahsakit/rsbg.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Health Facilities',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Find the best medical services near you',
                      style: TextStyle(fontSize: 16, color: subtitleColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters(
    bool isDark,
    Color searchBgColor,
    Color hintColor,
    Color textColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Search Box =====
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: searchBgColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.black : Colors.black).withOpacity(
                    isDark ? 0.3 : 0.05,
                  ),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              style: TextStyle(color: textColor),
              onChanged: (v) => setState(() => searchQuery = v),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Cari Fasilitas Kesehatan...',
                hintStyle: TextStyle(color: hintColor),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: isDark ? Colors.blueAccent[200] : Colors.blueAccent,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ===== Label Provinsi =====
          Text(
            'Filter by Province',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  provinces.map((p) {
                    final isSelected = selectedProvince == p;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(p),
                        selected: isSelected,
                        selectedColor: primaryColor,
                        backgroundColor:
                            isDark ? const Color(0xFF2D2D2D) : Colors.grey[200],
                        labelStyle: TextStyle(
                          color:
                              isSelected
                                  ? Colors.white
                                  : (isDark ? Colors.white70 : Colors.black87),
                          fontWeight: FontWeight.w500,
                        ),
                        onSelected: (_) => setState(() => selectedProvince = p),
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // ===== Label Tipe =====
          Text(
            'Filter by Type',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  types.map((t) {
                    final isSelected = selectedType == t;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(t),
                        selected: isSelected,
                        selectedColor: Colors.green,
                        backgroundColor:
                            isDark ? const Color(0xFF2D2D2D) : Colors.grey[200],
                        labelStyle: TextStyle(
                          color:
                              isSelected
                                  ? Colors.white
                                  : (isDark ? Colors.white70 : Colors.black87),
                          fontWeight: FontWeight.w500,
                        ),
                        onSelected: (_) => setState(() => selectedType = t),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================
// Kode AnimatedOpacityTranslate dan HealthFacilityCard
// ==========================
class AnimatedOpacityTranslate extends StatelessWidget {
  final Widget child;
  const AnimatedOpacityTranslate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutQuint,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class HealthFacilityCard extends StatelessWidget {
  final HealthFacility facility;
  final VoidCallback onTap;
  final Color primaryColor;
  final bool isDark;
  final Color cardColor;
  final Color textColor;

  const HealthFacilityCard({
    super.key,
    required this.facility,
    required this.onTap,
    required this.primaryColor,
    required this.isDark,
    required this.cardColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final subtextColor = isDark ? Colors.white60 : Colors.grey[700];
    final reviewColor = isDark ? Colors.white54 : Colors.grey[600];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.black).withOpacity(
              isDark ? 0.4 : 0.08,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: 'facility_image_${facility.name}',
                    child: Image.asset(
                      facility.image,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.black : Colors.white)
                            .withOpacity(0.9),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${facility.rating}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            facility.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  facility.type,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                facility.location,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      facility.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: subtextColor, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              size: 16,
                              color: isDark ? Colors.white54 : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${facility.reviewCount} reviews',
                              style: TextStyle(
                                color: reviewColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'View Details',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
