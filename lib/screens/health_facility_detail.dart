import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/health_facility_model.dart';

class HealthFacilityDetail extends StatefulWidget {
  final HealthFacility facility;
  final Color primaryColor;

  const HealthFacilityDetail({
    super.key,
    required this.facility,
    required this.primaryColor,
  });

  @override
  State<HealthFacilityDetail> createState() => _HealthFacilityDetailState();
}

class _HealthFacilityDetailState extends State<HealthFacilityDetail> {
  late final PageController _pageController;
  late final List<String> galleryImages;
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    galleryImages = widget.facility.gallery;

    // Auto-scroll gallery
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (galleryImages.isEmpty) return;
      _currentIndex = (_currentIndex + 1) % galleryImages.length;
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = widget.primaryColor;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.grey[300] : Colors.grey[700];
    final cardBackground = isDark ? Colors.grey[900] : Colors.white;

    Widget sectionTitle(String title) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // SliverAppBar with main image
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Hero(
                        tag: 'facility_image_${widget.facility.name}',
                        child: Image.asset(
                          widget.facility.image,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.1),
                                Colors.black.withOpacity(0.7),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.facility.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    widget.facility.type,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.facility.location} | ${widget.facility.province}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: textColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // Detail content
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: cardBackground,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // About
                        sectionTitle('About'),
                        Text(
                          widget.facility.description,
                          style: TextStyle(
                            color: subtitleColor,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Gallery
                        if (galleryImages.isNotEmpty) ...[
                          sectionTitle('Gallery'),
                          SizedBox(
                            height: 200,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: galleryImages.length,
                              onPageChanged: (index) =>
                                  setState(() => _currentIndex = index),
                              itemBuilder: (_, i) {
                                double page = _pageController.hasClients
                                    ? (_pageController.page ??
                                        _currentIndex.toDouble())
                                    : _currentIndex.toDouble();
                                double diff = (page - i).abs();
                                double scale = (1 - diff * 0.2).clamp(0.8, 1.0);

                                return Transform.scale(
                                  scale: scale,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      image: DecorationImage(
                                        image: AssetImage(galleryImages[i]),
                                        fit: BoxFit.cover,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(
                                            0.2 * scale,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: SmoothPageIndicator(
                              controller: _pageController,
                              count: galleryImages.length,
                              effect: ExpandingDotsEffect(
                                activeDotColor: primaryColor,
                                dotHeight: 8,
                                dotWidth: 8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Services
                        sectionTitle('Services'),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.facility.services.length,
                            itemBuilder: (_, i) {
                              final service = widget.facility.services[i];
                              return Container(
                                width: 120,
                                margin: const EdgeInsets.only(right: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: primaryColor.withOpacity(0.1),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      service.icon,
                                      color: primaryColor,
                                      size: 32,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      service.label,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: textColor),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Working Hours
                        sectionTitle('Working Hours'),
                        ...widget.facility.hours.entries.map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  e.key,
                                  style: TextStyle(color: textColor),
                                ),
                                Text(
                                  e.value,
                                  style: TextStyle(
                                    color: e.value.toLowerCase() == 'closed'
                                        ? Colors.red
                                        : subtitleColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Contact
                        sectionTitle('Contact Information'),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.phone, color: primaryColor),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Phone Number',
                                  style: TextStyle(color: subtitleColor),
                                ),
                                Text(
                                  widget.facility.contact,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Reviews
                        if (widget.facility.reviews.isNotEmpty) ...[
                          sectionTitle('Reviews'),
                          ...widget.facility.reviews.map(
                            (r) => Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.grey[800] : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (i) => Icon(
                                        i < r.rating
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    r.comment,
                                    style: TextStyle(color: subtitleColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 100),
                      ],
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
}
