import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/hospital_model.dart';
import '../services/hospital_service.dart';

class NearestHospitalSection extends StatefulWidget {
  final Position? currentPosition;
  final VoidCallback onSeeAllPressed;
  final VoidCallback? onLocationRefresh;

  const NearestHospitalSection({
    Key? key,
    this.currentPosition,
    required this.onSeeAllPressed,
    this.onLocationRefresh,
  }) : super(key: key);

  @override
  State<NearestHospitalSection> createState() => _NearestHospitalSectionState();
}

class _NearestHospitalSectionState extends State<NearestHospitalSection> {
  final PageController _hospitalPageController = PageController();
  int _currentHospitalIndex = 0;
  List<Hospital> _nearbyHospitals = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNearbyHospitals();
    
    // Delay auto-slide start untuk memastikan widget sudah ter-render
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        _startHospitalAutoSlide();
      }
    });
  }

  @override
  void didUpdateWidget(NearestHospitalSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPosition != widget.currentPosition) {
      _loadNearbyHospitals();
    }
  }

  Future<void> _loadNearbyHospitals() async {
    if (widget.currentPosition == null) {
      // Lokasi tidak tersedia - clear data rumah sakit
      setState(() {
        _nearbyHospitals = [];
        _currentHospitalIndex = 0;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      List<Hospital> hospitals = await HospitalService.getNearbyHospitals(
        latitude: widget.currentPosition!.latitude,
        longitude: widget.currentPosition!.longitude,
        radiusInKm: 50.0,
      );

      setState(() {
        _nearbyHospitals = hospitals.take(5).toList(); // Ambil 5 terdekat
        _currentHospitalIndex = 0;
        _isLoading = false;
      });

      // Reset page controller - dengan safety check
      if (_nearbyHospitals.isNotEmpty && _hospitalPageController.hasClients) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _hospitalPageController.hasClients) {
            _hospitalPageController.animateToPage(
              0,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    } catch (e) {
      setState(() {
        _nearbyHospitals = [];
        _currentHospitalIndex = 0;
        _isLoading = false;
      });
      print('Error loading nearby hospitals: $e');
    }
  }

  void _startHospitalAutoSlide() {
    Future.delayed(Duration(seconds: 4), () {
      if (mounted && _nearbyHospitals.isNotEmpty && _hospitalPageController.hasClients) {
        setState(() {
          _currentHospitalIndex = 
              (_currentHospitalIndex + 1) % _nearbyHospitals.length;
        });
        
        _hospitalPageController.animateToPage(
          _currentHospitalIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        
        _startHospitalAutoSlide();
      } else if (mounted) {
        // Coba lagi setelah 2 detik jika belum ready
        Future.delayed(Duration(seconds: 2), _startHospitalAutoSlide);
      }
    });
  }

  @override
  void dispose() {
    _hospitalPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rumah Sakit Terdekat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: widget.onSeeAllPressed,
                child: Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: Color(0xFFFF6B35),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          if (_isLoading)
            _buildLoadingWidget()
          else if (_nearbyHospitals.isEmpty)
            _buildNoHospitalWidget()
          else
            _buildHospitalSlider(),
          
          if (_nearbyHospitals.length > 1) ...[
            const SizedBox(height: 12),
            _buildHospitalIndicator(),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[100],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFFF6B35)),
            SizedBox(height: 16),
            Text(
              'Mencari rumah sakit terdekat...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoHospitalWidget() {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[100],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 60, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              widget.currentPosition == null 
                ? 'Lokasi tidak tersedia'
                : 'Tidak ada rumah sakit terdekat',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.currentPosition == null
                ? 'Aktifkan lokasi untuk melihat rumah sakit terdekat'
                : 'Coba perluas area pencarian',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            if (widget.currentPosition == null) ...[
  SizedBox(height: 16),
  ElevatedButton.icon(
    onPressed: widget.onLocationRefresh, // Gunakan callback
    icon: Icon(Icons.refresh, size: 16),
    label: Text('Refresh Lokasi'),
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFFFF6B35),
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
  ),
],
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalSlider() {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: PageView.builder(
          controller: _hospitalPageController,
          onPageChanged: (index) {
            setState(() {
              _currentHospitalIndex = index;
            });
          },
          itemCount: _nearbyHospitals.length,
          itemBuilder: (context, index) {
            final hospital = _nearbyHospitals[index];
            return _buildHospitalCard(hospital);
          },
        ),
      ),
    );
  }

  Widget _buildHospitalCard(Hospital hospital) {
    return Stack(
      children: [
        // Background Image - Pakai Image.asset untuk gambar lokal
        Positioned.fill(
          child: Image.asset(
            hospital.imageUrl, // Path ke assets lokal
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.local_hospital,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              );
            },
          ),
        ),
        
        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
        ),

        // Hospital Info
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      hospital.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(1, 1),
                            blurRadius: 3,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (hospital.distance != null)
                    _buildDistanceBadge(hospital.distance!),
                ],
              ),
              SizedBox(height: 8),
              Text(
                hospital.address,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (hospital.services.isNotEmpty) ...[
                SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  children: hospital.services.take(3).map((service) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        service,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDistanceBadge(double distance) {
    String distanceText;
    if (distance < 1) {
      distanceText = '${(distance * 1000).toInt()} m';
    } else {
      distanceText = '${distance.toStringAsFixed(1)} km';
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        distanceText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHospitalIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_nearbyHospitals.length, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: _currentHospitalIndex == index ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentHospitalIndex == index
                ? Color(0xFFFF6B35)
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}