import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/hospital_model.dart';
import '../services/hospital_service.dart';
import '../services/location_service.dart';
import '../services/map_service.dart';

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

  // Data provinsi, kota, dan koordinat
  Map<String, Map<String, Map<String, double>>> _provinceCitiesWithCoords = {
    'Jawa Barat': {
      'Bandung': {'lat': -6.9175, 'lng': 107.6191},
      'Bekasi': {'lat': -6.2383, 'lng': 106.9756},
      'Bogor': {'lat': -6.5971, 'lng': 106.8060},
    },
    'Jakarta': {
      'Jakarta Pusat': {'lat': -6.1751, 'lng': 106.8650},
      'Jakarta Selatan': {'lat': -6.2615, 'lng': 106.7955},
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
            ) /
            1000; // km

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
          position.longitude,
        );

        setState(() {
          _currentPosition = position;
          _currentAddress =
              address.length > 50 ? '${address.substring(0, 50)}...' : address;
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
        var cityCoords =
            _provinceCitiesWithCoords[_selectedProvince]?[_selectedCity];
        targetLat = cityCoords?['lat'] ?? -6.9175;
        targetLng = cityCoords?['lng'] ?? 107.6191;
      }

      List<Hospital> hospitals = await HospitalService.getNearbyHospitals(
        latitude: targetLat,
        longitude: targetLng,
        radiusInKm: 50.0,
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
        bool matchesSearch = hospital.name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            hospital.address
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());

        bool matchesFilter = true;

        switch (_selectedFilter) {
          case 'Semua':
            matchesFilter = true;
            break;
          case 'Buka 24 Jam':
            matchesFilter = hospital.isOpen24Hours;
            break;
          case 'UTDRS':
            matchesFilter =
                hospital.services.contains('UTDRS') || hospital.hasBloodStock;
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

      // Sorting
      if (_selectedSort == 'Terdekat' && _currentPosition != null) {
        _filteredHospitals.sort(
          (a, b) =>
              _parseDistance(a.distance).compareTo(_parseDistance(b.distance)),
        );
      } else if (_selectedSort == 'Rating Tertinggi') {
        _filteredHospitals.sort(
          (a, b) => b.rating.compareTo(a.rating),
        );
      } else if (_selectedSort == 'Nama A-Z') {
        _filteredHospitals.sort(
          (a, b) => a.name.compareTo(b.name),
        );
      }
    });
  }

  double _parseDistance(dynamic value) {
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  List<String> get _availableCities {
    return _provinceCitiesWithCoords[_selectedProvince]?.keys.toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildTopSection(context),
          _buildFilterSection(),
          _buildResultsHeader(),
          Expanded(child: _buildHospitalList()),
        ],
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
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
                      _showSearchDialog(context);
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
                _buildFilterChip('UTDRS', Icons.bloodtype, Colors.red),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.local_hospital, color: Color(0xFFFF6B35), size: 20),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  '${_filteredHospitals.length} RS di $_selectedCity, $_selectedProvince',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 8),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(minWidth: 80, minHeight: 28),
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
        return _buildHospitalCard(_filteredHospitals[index], context);
      },
    );
  }

  Widget _buildHospitalCard(Hospital hospital, BuildContext context) {
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
                  // Distance badge
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Row(
                      children: [
                        if (hospital.distance != null)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              hospital.distance != null
                                  ? "${hospital.distance!.toStringAsFixed(2)} km"
                                  : "0 km",
                              style: const TextStyle(
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
                // Rating, jam operasional, dan feature badges dalam satu area
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Jam operasional
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: hospital.isOpen24Hours
                            ? Colors.green.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
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
                    SizedBox(width: 8),

                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        if (hospital.hasIGD)
                          _buildTextBadge('IGD', Colors.red),
                        if (hospital.acceptsBPJS)
                          _buildTextBadge('BPJS', Colors.green),
                        if (hospital.services.contains('UTDRS') || hospital.hasBloodStock)
                          _buildTextBadge('UTDRS', Colors.red[700]!),
                        if (hospital.services.contains('Spesialis'))
                          _buildTextBadge('Spesialis', Colors.blue),
                        if (hospital.services.contains('Rujukan'))
                          _buildTextBadge('Rujukan', Colors.pink),
                      ],
                    ),
                  )
                ],
              ), 
                SizedBox(height: 16),
                
                // Nama Rumah Sakit
                Text(
                  hospital.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                SizedBox(height: 8),
                
                // Alamat Lengkap
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, size: 16, color: Color(0xFFFF6B35)),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        hospital.address,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 8),
                
                // Nomor Telepon
                Row(
                  children: [
                    Icon(Icons.phone, size: 16, color: Color(0xFFFF6B35)),
                    SizedBox(width: 6),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Menghubungi ${hospital.phone ?? "Nomor tidak tersedia"}'),
                              backgroundColor: Color(0xFFFF6B35),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Text(
                          hospital.phone ?? 'Nomor telepon tidak tersedia',
                          style: TextStyle(
                            fontSize: 13,
                            color: hospital.phone != null ? Colors.blue : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            decoration: hospital.phone != null ? TextDecoration.underline : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 12),
                
                // Services yang tersisa (selain yang sudah ditampilkan di atas)
                Text(
                  'Layanan Instalasi:',
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
                  children: hospital.services.where((service) {
                    // Filter out services yang sudah ditampilkan sebagai feature badge
                    return !['IGD', 'BPJS', 'UTDRS', 'Spesialis', 'Rujukan'].contains(service);
                  }).map((service) {
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
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
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
                
                // Additional Maps Options
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () {
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
                          _copyCoordinates(hospital, context);
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

  Widget _buildTextBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
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

  void _copyCoordinates(Hospital hospital, BuildContext context) {
    String coordinates = MapsService.getCoordinatesString(hospital);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Koordinat ${hospital.name} disalin: $coordinates'),
        backgroundColor: Color(0xFFFF6B35),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Color _getServiceColor(String service) {
    switch (service) {
      case 'BPJS':
        return const Color.fromARGB(255, 2, 119, 51);
      case 'IGD 24 Jam':
        return Colors.red;
      case 'MCU':
        return Colors.purple;
      case 'Spesialis':
        return Colors.blue;
      case 'Rujukan':
        return Colors.green;
      case 'UTDRS':
        return const Color.fromARGB(255, 254, 17, 0);
      case 'Rawat Jalan':
        return Colors.teal;
      case 'Rawat Inap':
        return Colors.indigo;
      case 'Persalinan':
        return Colors.pink;
      case 'Kandungan':
        return Colors.purple[300]!;
      default:
        return Color.fromARGB(255, 248, 151, 5);
    }
  }

  void _showSearchDialog(BuildContext context) {
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