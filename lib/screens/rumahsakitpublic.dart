import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/hospital_model.dart';
import '../services/hospital_service.dart';
import '../services/location_service.dart';

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

  // Indonesian provinces and cities data
  Map<String, List<String>> _provinceCities = {
    'Jawa Barat': ['Bandung', 'Bekasi', 'Bogor', 'Cimahi', 'Cirebon', 'Depok', 'Sukabumi', 'Tasikmalaya'],
    'DKI Jakarta': ['Jakarta Pusat', 'Jakarta Utara', 'Jakarta Barat', 'Jakarta Selatan', 'Jakarta Timur'],
    'Jawa Tengah': ['Semarang', 'Magelang', 'Pekalongan', 'Purwokerto', 'Salatiga', 'Solo', 'Tegal'],
    'Jawa Timur': ['Surabaya', 'Batu', 'Blitar', 'Kediri', 'Madiun', 'Malang', 'Mojokerto', 'Pasuruan'],
    'Lampung': ['Bandar Lampung', 'Metro'],
    'Banten': ['Serang', 'Cilegon', 'Tangerang', 'Tangerang Selatan'],
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
    // Simple location detection based on coordinates
    if (position.latitude >= -6.0 && position.latitude <= -5.0) {
      // Lampung area
      setState(() {
        _selectedProvince = 'Lampung';
        _selectedCity = 'Bandar Lampung';
      });
    } else if (position.latitude >= -7.5 && position.latitude <= -6.0) {
      // Jawa Barat area  
      setState(() {
        _selectedProvince = 'Jawa Barat';
        _selectedCity = 'Bandung';
      });
    } else if (position.latitude >= -6.5 && position.latitude <= -6.0) {
      // Jakarta area
      setState(() {
        _selectedProvince = 'DKI Jakarta';
        _selectedCity = 'Jakarta Pusat';
      });
    }
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
      if (_useCurrentLocation && _currentPosition != null) {
        // Load berdasarkan lokasi user
        List<Hospital> hospitals = await HospitalService.getNearbyHospitals(
          latitude: _currentPosition!.latitude,
          longitude: _currentPosition!.longitude,
          radiusInKm: 100.0, // radius lebih luas untuk "Lihat Semua"
        );
        setState(() {
          _allHospitals = hospitals;
        });
      } else {
        // Load semua data dummy untuk manual selection
        List<Hospital> hospitals = await HospitalService.getNearbyHospitals(
          latitude: -6.914684, // Default Bandung
          longitude: 107.665428,
          radiusInKm: 1000.0, // radius sangat luas untuk semua data
        );
        setState(() {
          _allHospitals = hospitals;
        });
      }
      
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

  bool _hasBloodStock(Hospital hospital) {
    // Simple check untuk blood stock - nanti bisa disesuaikan dengan model
    return hospital.services.contains('IGD 24 Jam'); // temporary logic
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
                              _selectedCity = _provinceCities[_selectedProvince]![0];
                              _useCurrentLocation = false;
                            });
                            _loadHospitals();
                          },
                          items: _provinceCities.keys.map<DropdownMenuItem<String>>((String value) {
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
                          items: _provinceCities[_selectedProvince]!.map<DropdownMenuItem<String>>((String value) {
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
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Open maps
                        },
                        icon: Icon(Icons.map, size: 16),
                        label: Text('Maps'),
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
              ],
            ),
          ),
        ],
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