import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/hospital_model.dart';
import '../services/hospital_service.dart';
import '../services/location_service.dart';
import '../services/map_service.dart'; // Import yang benar

class RumahSakitPublicPage extends StatefulWidget {
  final Position? userPosition;
  final String? userAddress;

  const RumahSakitPublicPage({
    Key? key,
    this.userPosition,
    this.userAddress,
  }) : super(key: key);

  @override
  State<RumahSakitPublicPage> createState() => _RumahSakitPublicPageState();
}

class _RumahSakitPublicPageState extends State<RumahSakitPublicPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedProvince = 'Jawa Barat';
  String _selectedCity = 'Bandung';
  String _selectedFilter = 'Semua';
  String _selectedSort = 'Terdekat';
  
  Position? _currentPosition;
  String _currentAddress = 'Mendapatkan lokasi...';
  bool _isLoading = true;
  bool _useCurrentLocation = true;

  // Indonesian provinces and cities data with coordinates for filtering
  Map<String, Map<String, Map<String, double>>> _provinceCitiesWithCoords = {
    'Jawa Barat': {
      'Bandung': {'lat': -6.9175, 'lng': 107.6191},
      'Bekasi': {'lat': -6.2383, 'lng': 106.9756},
      'Bogor': {'lat': -6.5971, 'lng': 106.8060},
      'Cimahi': {'lat': -6.8721, 'lng': 107.5420},
      'Cirebon': {'lat': -6.7063, 'lng': 108.5570},
      'Depok': {'lat': -6.4025, 'lng': 106.7942},
      'Sukabumi': {'lat': -6.9278, 'lng': 106.9561},
      'Tasikmalaya': {'lat': -7.3506, 'lng': 108.2070},
    },
    'Jakarta': {
      'Jakarta Pusat': {'lat': -6.1751, 'lng': 106.8650},
      'Jakarta Utara': {'lat': -6.1384, 'lng': 106.8759},
      'Jakarta Barat': {'lat': -6.1352, 'lng': 106.7624},
      'Jakarta Selatan': {'lat': -6.2615, 'lng': 106.7955},
      'Jakarta Timur': {'lat': -6.2250, 'lng': 106.9004},
    },
    'Jawa Tengah': {
      'Semarang': {'lat': -6.9665, 'lng': 110.4203},
      'Magelang': {'lat': -7.4797, 'lng': 110.2172},
      'Pekalongan': {'lat': -6.8886, 'lng': 109.6753},
      'Purwokerto': {'lat': -7.4197, 'lng': 109.2494},
      'Salatiga': {'lat': -7.3318, 'lng': 110.5084},
      'Solo': {'lat': -7.5755, 'lng': 110.8243},
      'Tegal': {'lat': -6.8694, 'lng': 109.1402},
    },
    'Jawa Timur': {
      'Surabaya': {'lat': -7.2575, 'lng': 112.7521},
      'Batu': {'lat': -7.8737, 'lng': 112.5289},
      'Blitar': {'lat': -8.0956, 'lng': 112.1609},
      'Kediri': {'lat': -7.8481, 'lng': 112.0178},
      'Madiun': {'lat': -7.6298, 'lng': 111.5239},
      'Malang': {'lat': -7.9666, 'lng': 112.6326},
      'Mojokerto': {'lat': -7.4642, 'lng': 112.4338},
      'Pasuruan': {'lat': -7.6447, 'lng': 112.9079},
    },
    'Lampung': {
      'Bandar Lampung': {'lat': -5.3971, 'lng': 105.2946},
      'Metro': {'lat': -5.1130, 'lng': 105.3067},
    },
    'Banten': {
      'Serang': {'lat': -6.1200, 'lng': 106.1500},
      'Cilegon': {'lat': -6.0025, 'lng': 106.0640},
      'Tangerang': {'lat': -6.1783, 'lng': 106.6319},
      'Tangerang Selatan': {'lat': -6.2877, 'lng': 106.7290},
    },
  };

  List<String> _sortOptions = [
    'Terdekat',
    'Rating Tertinggi', 
    'Nama A-Z',
  ];

  List<Hospital> _allHospitals = [];
  List<Hospital> _filteredHospitals = [];

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _loadHospitals();
  }

  void _initializeLocation() {
    if (widget.userPosition != null && widget.userAddress != null) {
      setState(() {
        _currentPosition = widget.userPosition;
        _currentAddress = widget.userAddress!;
        _isLoading = false;
      });
      _setLocationFromPosition(widget.userPosition!);
    } else {
      _getCurrentLocation();
    }
  }

  void _setLocationFromPosition(Position position) {
    // More accurate location detection based on coordinates
    double minDistance = double.infinity;
    String nearestProvince = 'Jawa Barat';
    String nearestCity = 'Bandung';

    _provinceCitiesWithCoords.forEach((province, cities) {
      cities.forEach((city, coords) {
        double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          coords['lat']!,
          coords['lng']!,
        ) / 1000; // Convert to km

        if (distance < minDistance) {
          minDistance = distance;
          nearestProvince = province;
          nearestCity = city;
        }
      });
    });

    setState(() {
      _selectedProvince = nearestProvince;
      _selectedCity = nearestCity;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() {
        _isLoading = true;
      });

      Position? position = await LocationService.getCurrentPosition();
      
      if (position != null) {
        String address = await LocationService.getAddressFromCoordinates(
          position.latitude, 
          position.longitude
        );

        setState(() {
          _currentPosition = position;
          _currentAddress = address.length > 50 ? '${address.substring(0, 50)}...' : address;
          _isLoading = false;
        });

        _setLocationFromPosition(position);
      } else {
        setState(() {
          _currentAddress = 'Lokasi tidak tersedia';
          _isLoading = false;
          _useCurrentLocation = false;
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = 'Gagal mendapatkan lokasi';
        _isLoading = false;
        _useCurrentLocation = false;
      });
    }
  }

  Future<void> _loadHospitals() async {
    try {
      double targetLat, targetLng;
      
      if (_useCurrentLocation && _currentPosition != null) {
        targetLat = _currentPosition!.latitude;
        targetLng = _currentPosition!.longitude;
      } else {
        // Use selected city coordinates
        var cityCoords = _provinceCitiesWithCoords[_selectedProvince]?[_selectedCity];
        targetLat = cityCoords?['lat'] ?? -6.9175;
        targetLng = cityCoords?['lng'] ?? 107.6191;
      }

      List<Hospital> hospitals = await HospitalService.getNearbyHospitals(
        latitude: targetLat,
        longitude: targetLng,
        radiusInKm: 50.0, // Radius yang reasonable untuk satu kota
      );
      
      setState(() {
        _allHospitals = hospitals;
      });
      
      _filterHospitals();
    } catch (e) {
      print('Error loading hospitals: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterHospitals() {
    setState(() {
      _filteredHospitals = _allHospitals.where((hospital) {
        bool matchesSearch = hospital.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                           hospital.address.toLowerCase().contains(_searchController.text.toLowerCase());
        
        bool matchesFilter = true;
        
        switch (_selectedFilter) {
          case 'Semua':
            matchesFilter = true;
            break;
          case 'Buka 24 Jam':
            matchesFilter = hospital.isOpen24Hours;
            break;
          case 'Stok Darah':
            matchesFilter = hospital.hasBloodStock;
            break;
          case 'BPJS':
            matchesFilter = hospital.acceptsBPJS;
            break;
          case 'IGD':
            matchesFilter = hospital.hasIGD;
            break;
          case 'MCU':
            matchesFilter = hospital.hasMCU;
            break;
        }
        
        return matchesSearch && matchesFilter;
      }).toList();

      // Sort hospitals
      if (_selectedSort == 'Terdekat' && _currentPosition != null) {
        _filteredHospitals.sort((a, b) => (a.distance ?? 999).compareTo(b.distance ?? 999));
      } else if (_selectedSort == 'Rating Tertinggi') {
        _filteredHospitals.sort((a, b) => b.rating.compareTo(a.rating));
      } else if (_selectedSort == 'Nama A-Z') {
        _filteredHospitals.sort((a, b) => a.name.compareTo(b.name));
      }
    });
  }

  // Get available cities for selected province
  List<String> get _availableCities {
    return _provinceCitiesWithCoords[_selectedProvince]?.keys.toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildTopSection(),
          _buildFilterSection(),
          _buildResultsHeader(),
          Expanded(
            child: _buildHospitalList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFF6B35),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Rumah Sakit Terdekat',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Show search dialog
                      _showSearchDialog();
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.search, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            
            // Location Info
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    _isLoading ? Icons.location_searching : Icons.location_on, 
                    color: Colors.red, 
                    size: 16
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Lokasi: ',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _currentAddress,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: _getCurrentLocation,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.refresh, color: Colors.white, size: 12),
                          SizedBox(width: 4),
                          Text(
                            'Refresh',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 16),
            
            // Location Selectors
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedProvince,
                          isExpanded: true,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 20),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedProvince = newValue!;
                              _selectedCity = _availableCities.first;
                              _useCurrentLocation = false;
                            });
                            _loadHospitals();
                          },
                          items: _provinceCitiesWithCoords.keys.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCity,
                          isExpanded: true,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 20),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCity = newValue!;
                              _useCurrentLocation = false;
                            });
                            _loadHospitals();
                          },
                          items: _availableCities.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 12),
          Container(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterChip('Buka 24 Jam', Icons.access_time, Color(0xFFFF6B35)),
                _buildFilterChip('Stok Darah', Icons.bloodtype, Colors.red),
                _buildFilterChip('BPJS', Icons.favorite, Colors.pink),
                _buildFilterChip('IGD', Icons.local_hospital, Colors.grey[700]!),
                _buildFilterChip('MCU', Icons.health_and_safety, Colors.purple),
              ],
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon, Color color) {
    bool isSelected = _selectedFilter == label;
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = isSelected ? 'Semua' : label;
          });
          _filterHospitals();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : color,
              ),
              SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.local_hospital, color: Color(0xFFFF6B35), size: 20),
          SizedBox(width: 8),
          Text(
            '${_filteredHospitals.length} RS di $_selectedCity, $_selectedProvince',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Spacer(),
          Container(
            constraints: BoxConstraints(minHeight: 28),
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFFF6B35), width: 0.8),
              borderRadius: BorderRadius.circular(6),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isDense: true,
                value: _selectedSort,
                style: TextStyle(fontSize: 11, color: Colors.black),
                icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFFFF6B35), size: 16),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSort = newValue!;
                  });
                  _filterHospitals();
                },
                items: _sortOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 11)),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalList() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFFF6B35)),
            SizedBox(height: 16),
            Text('Memuat rumah sakit...'),
          ],
        ),
      );
    }

    if (_filteredHospitals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_hospital, size: 60, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'Tidak ada rumah sakit ditemukan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Coba ubah filter atau lokasi pencarian',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _filteredHospitals.length,
      itemBuilder: (context, index) {
        return _buildHospitalCard(_filteredHospitals[index]);
      },
    );
  }

  Widget _buildHospitalCard(Hospital hospital) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Column(
        children: [
          // Hospital Image
          Container(
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      hospital.imageUrl,
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
                              size: 40,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Gradient overlay
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
                  // Hospital name and distance
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Row(
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (hospital.distance != null)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${hospital.distance!.toStringAsFixed(1)} km',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
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
          
          // Hospital Details
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hospital status badges
                Row(
                  children: [
                    // Rating
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '${hospital.rating}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12),
                    // Operating hours
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: hospital.isOpen24Hours ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: hospital.isOpen24Hours ? Colors.green : Colors.orange,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        hospital.operatingHours,
                        style: TextStyle(
                          color: hospital.isOpen24Hours ? Colors.green : Colors.orange,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 12),
                
                // Feature badges row
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    if (hospital.acceptsBPJS) _buildFeatureBadge('BPJS', Colors.pink, Icons.favorite),
                    if (hospital.hasIGD) _buildFeatureBadge('IGD', Colors.red, Icons.local_hospital),
                    if (hospital.hasMCU) _buildFeatureBadge('MCU', Colors.purple, Icons.health_and_safety),
                    if (hospital.hasBloodStock) _buildFeatureBadge('Stok Darah', Colors.red[700]!, Icons.bloodtype),
                    if (hospital.isOpen24Hours) _buildFeatureBadge('24 Jam', Colors.green, Icons.access_time),
                  ],
                ),
                
                // Blood stock detail (if available)
                if (hospital.hasBloodStock && hospital.bloodStock != null) ...[
                  SizedBox(height: 12),
                  Text(
                    'Stok Darah Tersedia:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildBloodStockDisplay(hospital.bloodStock!),
                ],
                
                // Services
                Text(
                  'Layanan:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: hospital.services.map((service) {
                    Color serviceColor = _getServiceColor(service);
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: serviceColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: serviceColor.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        service,
                        style: TextStyle(
                          fontSize: 9,
                          color: serviceColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                
                SizedBox(height: 16),
                
                // Updated Action Buttons with Maps Integration
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Buka navigasi ke rumah sakit
                          MapsService.openNavigation(
                            hospital,
                            userLat: _currentPosition?.latitude,
                            userLng: _currentPosition?.longitude,
                          );
                        },
                        icon: Icon(Icons.navigation, size: 16),
                        label: Text('Navigasi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF6B35),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Tampilkan pilihan aplikasi maps
                          MapsService.showMapsSelectionDialog(context, hospital);
                        },
                        icon: Icon(Icons.map, size: 16),
                        label: Text('Lokasi'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFFFF6B35),
                          side: BorderSide(color: Color(0xFFFF6B35)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Additional Maps Options (Optional)
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () {
                          // Buka Google Maps langsung
                          MapsService.openGoogleMaps(hospital);
                        },
                        icon: Icon(Icons.map, size: 14, color: Colors.blue),
                        label: Text(
                          'Google Maps',
                          style: TextStyle(fontSize: 11, color: Colors.blue),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () {
                          // Buka Waze untuk navigasi
                          MapsService.openWaze(hospital);
                        },
                        icon: Icon(Icons.navigation, size: 14, color: Colors.cyan),
                        label: Text(
                          'Waze',
                          style: TextStyle(fontSize: 11, color: Colors.cyan),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () {
                          // Copy coordinates ke clipboard
                          _copyCoordinates(hospital);
                        },
                        icon: Icon(Icons.copy, size: 14, color: Colors.grey[600]),
                        label: Text(
                          'Salin Koordinat',
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        ),
                      ),
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

  void _copyCoordinates(Hospital hospital) {
    // Copy koordinat ke clipboard
    String coordinates = MapsService.getCoordinatesString(hospital);
    // TODO: Implement clipboard copy dengan flutter/services.dart
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Koordinat ${hospital.name} disalin: $coordinates'),
        backgroundColor: Color(0xFFFF6B35),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildFeatureBadge(String label, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBloodStockDisplay(Map<String, int> bloodStock) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          // First row: A+, A-, B+, B-
          Row(
            children: ['A+', 'A-', 'B+', 'B-'].map((type) {
              int count = bloodStock[type] ?? 0;
              bool available = count > 0;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 4),
                  padding: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: available ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    children: [
                      Text(
                        type,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: available ? Colors.green[700] : Colors.grey[600],
                        ),
                      ),
                      Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 8,
                          color: available ? Colors.green[700] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 4),
          // Second row: AB+, AB-, O+, O-
          Row(
            children: ['AB+', 'AB-', 'O+', 'O-'].map((type) {
              int count = bloodStock[type] ?? 0;
              bool available = count > 0;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 4),
                  padding: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: available ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    children: [
                      Text(
                        type,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: available ? Colors.green[700] : Colors.red,
                        ),
                      ),
                      Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 8,
                          color: available ? Colors.green[700] : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getServiceColor(String service) {
    switch (service) {
      case 'BPJS':
        return Colors.pink;
      case 'IGD 24 Jam':
        return Colors.red;
      case 'MCU':
        return Colors.purple;
      case 'Spesialis':
        return Colors.blue;
      case 'Rujukan':
        return Colors.green;
      default:
        return Color(0xFFFF6B35);
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cari Rumah Sakit'),
          content: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Nama rumah sakit atau alamat...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              _filterHospitals();
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                _searchController.clear();
                _filterHospitals();
                Navigator.pop(context);
              },
              child: Text('Clear'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _filterHospitals();
              },
              child: Text('Search'),
            ),
          ],
        );
      },
    );
  }
}