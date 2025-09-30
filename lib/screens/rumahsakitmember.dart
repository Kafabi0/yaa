import 'package:flutter/material.dart';
import 'package:inocare/main.dart';
import 'package:inocare/screens/detailrsmember.dart';
import 'package:inocare/screens/home_page_member.dart';
import 'package:geolocator/geolocator.dart';
import '../services/hospital_service.dart';
import '../services/location_service.dart';
import '../models/hospital_model.dart';

class RumahSakitMemberPage extends StatefulWidget {
  const RumahSakitMemberPage({Key? key}) : super(key: key);

  @override
  State<RumahSakitMemberPage> createState() => _RumahSakitMemberPageState();
}

class _RumahSakitMemberPageState extends State<RumahSakitMemberPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedProvince = 'Jawa Barat';
  String _selectedCity = 'Bandung';
  String _selectedFilter = 'Semua';
  String _selectedSort = 'Terdekat';
  
  Position? _currentPosition;
  String _currentAddress = 'Mendapatkan lokasi...';
  bool _isLoading = true;
  bool _useCurrentLocation = true;

  // Indonesian provinces and cities data with coordinates
  Map<String, Map<String, Map<String, double>>> _provinceCitiesWithCoords = {
    'Aceh': {
      'Banda Aceh': {'lat': 5.5483, 'lng': 95.3238},
      'Langsa': {'lat': 4.4755, 'lng': 97.9913},
      'Lhokseumawe': {'lat': 5.1845, 'lng': 97.1446},
      'Meulaboh': {'lat': 4.1480, 'lng': 96.1774},
      'Sabang': {'lat': 5.9092, 'lng': 95.3100},
    },
    'Sumatera Utara': {
      'Medan': {'lat': 3.5952, 'lng': 98.6722},
      'Binjai': {'lat': 3.5855, 'lng': 98.4893},
      'Pematangsiantar': {'lat': 2.9635, 'lng': 99.1396},
      'Sibolga': {'lat': 1.7385, 'lng': 98.7802},
      'Tanjungbalai': {'lat': 2.9701, 'lng': 99.8029},
      'Tebing Tinggi': {'lat': 3.3278, 'lng': 99.1634},
    },
    'Sumatera Barat': {
      'Padang': {'lat': -0.9471, 'lng': 100.4172},
      'Bukittinggi': {'lat': -0.3046, 'lng': 100.3688},
      'Padang Panjang': {'lat': -0.4591, 'lng': 100.4124},
      'Payakumbuh': {'lat': -0.2290, 'lng': 100.6333},
      'Sawahlunto': {'lat': -0.6689, 'lng': 100.7738},
      'Solok': {'lat': -0.7965, 'lng': 100.6546},
    },
    'Riau': {
      'Pekanbaru': {'lat': 0.5068, 'lng': 101.4478},
      'Dumai': {'lat': 1.6849, 'lng': 101.4425},
    },
    'Kepulauan Riau': {
      'Tanjungpinang': {'lat': 1.0424, 'lng': 104.4716},
      'Batam': {'lat': 1.0457, 'lng': 104.0329},
    },
    'Jambi': {
      'Jambi': {'lat': -1.5904, 'lng': 103.6138},
      'Sungai Penuh': {'lat': -2.1420, 'lng': 101.3670},
    },
    'Sumatera Selatan': {
      'Palembang': {'lat': -2.9911, 'lng': 104.7567},
      'Lubuklinggau': {'lat': -3.2967, 'lng': 102.8619},
      'Pagar Alam': {'lat': -4.0174, 'lng': 103.2418},
      'Prabumulih': {'lat': -3.4391, 'lng': 104.2356},
    },
    'Bangka Belitung': {
      'Pangkalpinang': {'lat': -2.1333, 'lng': 106.1167},
    },
    'Bengkulu': {
      'Bengkulu': {'lat': -3.7928, 'lng': 102.2608},
    },
    'Lampung': {
      'Bandar Lampung': {'lat': -5.3971, 'lng': 105.2946},
      'Metro': {'lat': -5.1130, 'lng': 105.3067},
    },
    'DKI Jakarta': {
      'Jakarta Pusat': {'lat': -6.1751, 'lng': 106.8650},
      'Jakarta Utara': {'lat': -6.1384, 'lng': 106.8759},
      'Jakarta Barat': {'lat': -6.1352, 'lng': 106.7624},
      'Jakarta Selatan': {'lat': -6.2615, 'lng': 106.7955},
      'Jakarta Timur': {'lat': -6.2250, 'lng': 106.9004},
    },
    'Jawa Barat': {
      'Bandung': {'lat': -6.9175, 'lng': 107.6191},
      'Bekasi': {'lat': -6.2383, 'lng': 106.9756},
      'Bogor': {'lat': -6.5971, 'lng': 106.8060},
      'Cimahi': {'lat': -6.8721, 'lng': 107.5420},
      'Cirebon': {'lat': -6.7063, 'lng': 108.5570},
      'Depok': {'lat': -6.4025, 'lng': 106.7942},
      'Sukabumi': {'lat': -6.9278, 'lng': 106.9561},
      'Tasikmalaya': {'lat': -7.3506, 'lng': 108.2070},
      'Banjar': {'lat': -7.3732, 'lng': 108.5419},
      'Kuningan': {'lat': -6.7576, 'lng': 108.4876},
      'Majalengka': {'lat': -6.8333, 'lng': 108.2292},
      'Indramayu': {'lat': -6.3289, 'lng': 108.3231},
      'Subang': {'lat': -6.5719, 'lng': 107.7609},
      'Purwakarta': {'lat': -6.5410, 'lng': 107.4486},
      'Karawang': {'lat': -6.3147, 'lng': 107.3412},
      'Garut': {'lat': -7.2149, 'lng': 107.9076},
    },
    'Jawa Tengah': {
      'Semarang': {'lat': -6.9665, 'lng': 110.4203},
      'Magelang': {'lat': -7.4797, 'lng': 110.2172},
      'Pekalongan': {'lat': -6.8886, 'lng': 109.6753},
      'Purwokerto': {'lat': -7.4197, 'lng': 109.2494},
      'Salatiga': {'lat': -7.3318, 'lng': 110.5084},
      'Solo': {'lat': -7.5755, 'lng': 110.8243},
      'Tegal': {'lat': -6.8694, 'lng': 109.1402},
      'Yogyakarta': {'lat': -7.7956, 'lng': 110.3695},
    },
    'DI Yogyakarta': {
      'Yogyakarta': {'lat': -7.7956, 'lng': 110.3695},
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
      'Probolinggo': {'lat': -7.7592, 'lng': 113.2209},
    },
    'Banten': {
      'Serang': {'lat': -6.1200, 'lng': 106.1500},
      'Cilegon': {'lat': -6.0025, 'lng': 106.0640},
      'Tangerang': {'lat': -6.1783, 'lng': 106.6319},
      'Tangerang Selatan': {'lat': -6.2877, 'lng': 106.7290},
    },
    'Bali': {
      'Denpasar': {'lat': -8.6705, 'lng': 115.2126},
    },
    'Nusa Tenggara Barat': {
      'Mataram': {'lat': -0.9033, 'lng': 116.0703},
      'Bima': {'lat': -8.4586, 'lng': 118.7324},
    },
    'Nusa Tenggara Timur': {
      'Kupang': {'lat': -10.1781, 'lng': 123.6049},
    },
    'Kalimantan Barat': {
      'Pontianak': {'lat': -0.0263, 'lng': 109.3425},
      'Singkawang': {'lat': 0.9042, 'lng': 108.9867},
    },
    'Kalimantan Tengah': {
      'Palangka Raya': {'lat': -2.2139, 'lng': 113.9103},
    },
    'Kalimantan Selatan': {
      'Banjarmasin': {'lat': -3.3194, 'lng': 114.5936},
      'Banjarbaru': {'lat': -3.4639, 'lng': 114.7878},
    },
    'Kalimantan Timur': {
      'Samarinda': {'lat': -0.5022, 'lng': 117.1536},
      'Balikpapan': {'lat': -1.2635, 'lng': 116.8252},
      'Bontang': {'lat': 0.2386, 'lng': 117.5069},
    },
    'Kalimantan Utara': {
      'Tarakan': {'lat': 3.2952, 'lng': 117.5883},
    },
    'Sulawesi Utara': {
      'Manado': {'lat': 1.4748, 'lng': 124.8429},
      'Bitung': {'lat': 1.4386, 'lng': 125.1886},
      'Kotamobagu': {'lat': 0.7136, 'lng': 124.3261},
      'Tomohon': {'lat': 1.3256, 'lng': 124.8239},
    },
    'Sulawesi Tengah': {
      'Palu': {'lat': -0.8952, 'lng': 119.8707},
    },
    'Sulawesi Selatan': {
      'Makassar': {'lat': -5.1477, 'lng': 119.4327},
      'Palopo': {'lat': -2.9928, 'lng': 120.2028},
      'Parepare': {'lat': -4.0139, 'lng': 119.6397},
    },
    'Sulawesi Tenggara': {
      'Kendari': {'lat': -3.9778, 'lng': 122.5151},
      'Baubau': {'lat': -5.4652, 'lng': 122.6211},
    },
    'Gorontalo': {
      'Gorontalo': {'lat': 0.5435, 'lng': 123.0585},
    },
    'Sulawesi Barat': {
      'Mamuju': {'lat': -2.6767, 'lng': 118.8867},
    },
    'Maluku': {
      'Ambon': {'lat': -3.6953, 'lng': 128.1814},
      'Tual': {'lat': -5.6172, 'lng': 132.7514},
    },
    'Maluku Utara': {
      'Ternate': {'lat': 0.7883, 'lng': 127.3542},
      'Tidore Kepulauan': {'lat': 0.8986, 'lng': 127.4022},
    },
    'Papua': {
      'Jayapura': {'lat': -2.5337, 'lng': 140.7181},
    },
    'Papua Barat': {
      'Manokwari': {'lat': -0.8633, 'lng': 134.0622},
      'Sorong': {'lat': -0.8769, 'lng': 131.2559},
    },
  };

  List<String> _sortOptions = [
    'Terdekat',
    'Rating Tertinggi',
    'Nama A-Z',
    'Paling Populer',
    'Harga Termurah',
  ];

  List<Hospital> _hospitals = [];
  List<Hospital> _filteredHospitals = [];

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _searchController.addListener(_filterHospitals);
  }

  void _initializeLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get current location
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

        // Set province and city based on current location
        _setLocationFromPosition(position);
        
        // Load hospitals based on current location
        _loadHospitals();
      } else {
        // Fallback to default location
        setState(() {
          _currentAddress = 'Lokasi tidak tersedia';
          _isLoading = false;
          _useCurrentLocation = false;
        });
        _loadHospitals();
      }
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        _currentAddress = 'Gagal mendapatkan lokasi';
        _isLoading = false;
        _useCurrentLocation = false;
      });
      _loadHospitals();
    }
  }

  void _setLocationFromPosition(Position position) {
    // Find the nearest province and city based on coordinates
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
      _useCurrentLocation = true;
    });
  }

  Future<void> _loadHospitals() async {
  setState(() {
    _isLoading = true;
  });

  try {
    double targetLat, targetLng;
    
    if (_useCurrentLocation && _currentPosition != null) {
      targetLat = _currentPosition!.latitude;
      targetLng = _currentPosition!.longitude;
    } else {
      Map<String, double>? cityCoords = _provinceCitiesWithCoords[_selectedProvince]?[_selectedCity];
      targetLat = cityCoords?['lat'] ?? -6.9175;
      targetLng = cityCoords?['lng'] ?? 107.6191;
    }

    List<Hospital> hospitals = await HospitalService.getNearbyHospitals(
      latitude: targetLat,
      longitude: targetLng,
      radiusInKm: 50.0,
    );

    setState(() {
      _hospitals = hospitals;
      _filteredHospitals = List.from(_hospitals);
      _isLoading = false;
    });
  } catch (e) {
    print('Error loading hospitals: $e');
    setState(() {
      _isLoading = false;
    });
  }
}

  @override
  void dispose() {
    _searchController.removeListener(_filterHospitals);
    _searchController.dispose();
    super.dispose();
  }

  void _filterHospitals() {
    setState(() {
      _filteredHospitals = _hospitals.where((hospital) {
        bool matchesSearch = hospital.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            hospital.address.toLowerCase().contains(_searchController.text.toLowerCase());

        bool matchesFilter = _selectedFilter == 'Semua' ||
            (_selectedFilter == 'Buka 24 Jam' && hospital.isOpen) || // Perbaikan: gunakan properti isOpen
            (_selectedFilter == 'Stok Darah' && hospital.hasBloodStock) || // Perbaikan: gunakan getter hasBloodStock
            (_selectedFilter == 'BPJS' && hospital.services.contains('BPJS')) ||
            (_selectedFilter == 'IGD' && hospital.services.contains('IGD')) || // Perbaikan: gunakan 'IGD' bukan 'IGD 24 Jam'
            (_selectedFilter == 'MCU' && hospital.services.contains('MCU'));

        return matchesSearch && matchesFilter;
      }).toList();

      // Sort hospitals
      if (_selectedSort == 'Terdekat') {
        _filteredHospitals.sort((a, b) {
          double distA = a.distance ?? double.infinity;
          double distB = b.distance ?? double.infinity;
          return distA.compareTo(distB);
        });
      }

      if (_selectedSort == 'Paling Populer') {
            // Use rating as popularity indicator
            _filteredHospitals.sort((a, b) => b.rating.compareTo(a.rating));
          }
        });
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
          Expanded(child: _buildHospitalList()),
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
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePageMember()),
                        (route) => false,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
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
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.search, color: Colors.white, size: 20),
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
                    onTap: () {
                      _initializeLocation();
                    },
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
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedProvince = newValue!;
                              // Reset city to first city in new province
                              _selectedCity = _provinceCitiesWithCoords[_selectedProvince]!.keys.first;
                              _useCurrentLocation = false;
                            });
                            _loadHospitals();
                          },
                          items:
                              _provinceCitiesWithCoords.keys
                                  .map<DropdownMenuItem<String>>((
                                    String value,
                                  ) {
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
                                  })
                                  .toList(),
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
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCity = newValue!;
                              _useCurrentLocation = false;
                            });
                            _loadHospitals();
                          },
                          items:
                              _provinceCitiesWithCoords[_selectedProvince]!
                                  .keys
                                  .map<DropdownMenuItem<String>>((
                                    String value,
                                  ) {
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
                                  })
                                  .toList(),
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
                _buildFilterChip(
                  'Buka 24 Jam',
                  Icons.access_time,
                  Color(0xFFFF6B35),
                ),
                _buildFilterChip('Stok Darah', Icons.bloodtype, Colors.red),
                _buildFilterChip('BPJS', Icons.favorite, Colors.pink),
                _buildFilterChip(
                  'IGD',
                  Icons.local_hospital,
                  Colors.grey[700]!,
                ),
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
              Icon(icon, size: 14, color: isSelected ? Colors.white : color),
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
            constraints: BoxConstraints(
              minHeight: 28, // bikin lebih kecil
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ), // kurangi padding
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFFF6B35), width: 0.8),
              borderRadius: BorderRadius.circular(6),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isDense: true, // <-- penting! bikin dropdown lebih kecil
                value: _selectedSort,
                style: TextStyle(
                  fontSize: 11,
                  color: Color.fromARGB(255, 2, 2, 2),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFFFF6B35),
                  size: 16,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSort = newValue!;
                  });
                  _filterHospitals();
                },
                items:
                    _sortOptions.map<DropdownMenuItem<String>>((String value) {
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
                      hospital.imagePath,
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
                            child: Icon(Icons.local_hospital,
                                color: Colors.white, size: 40),
                          ),
                        );
                      },
                    ),
                  ),
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
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
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
                // Rating + Distance
                Row(
                  children: [
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
                        SizedBox(width: 4),
                        Text(
                          '(${hospital.reviewCount} ulasan)',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        hospital.distance != null
                            ? "${hospital.distance!.toStringAsFixed(2)} km"
                            : "0 km", // kalau null kasih default
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8),

                // Layanan Penting di Atas
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: hospital.services
                      .where((service) =>
                          service == 'IGD' ||
                          service == 'BPJS' ||
                          service == 'UTDRS' ||
                          service == 'Rujukan' ||
                          service == 'Spesialis')
                      .map((service) {
                    Color serviceColor = _getServiceColor(service);
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: serviceColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: serviceColor.withOpacity(0.3)),
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

                SizedBox(height: 12),

                // Address + Phone
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, color: Colors.red, size: 14),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        hospital.address,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                // Di dalam method _buildHospitalCard, cari bagian Row yang menampilkan jam operasional
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.green, size: 14),
                  SizedBox(width: 4),
                  Text(
                    hospital.phone,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                  Spacer(),
                  Icon(
                    Icons.access_time,
                    color: hospital.isOpen ? Colors.green : Colors.grey[500],
                    size: 14,
                  ),
                  SizedBox(width: 4),
                  Text(
                    // Ganti teks jam operasional berdasarkan status buka 24 jam
                    hospital.isOpen ? hospital.operatingHours : 'Tidak 24 jam',
                    style: TextStyle(
                      fontSize: 11,
                      color: hospital.isOpen ? Colors.green : Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

                SizedBox(height: 12),

                // Bed Availability
                Text('Ketersediaan Bed:',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87)),
                SizedBox(height: 8),
                Row(
                  children: [
                    _buildBedStatus('IGD',
                        (hospital.bedAvailability?['igd']?['available'] ?? 0) > 0),
                    SizedBox(width: 8),
                    _buildBedStatus('VIP',
                        (hospital.bedAvailability?['vip']?['available'] ?? 0) > 0),
                    SizedBox(width: 8),
                    _buildBedStatus(
                        'Kelas 1',
                        (hospital.bedAvailability?['kelas1']?['available'] ?? 0) >
                            0),
                    SizedBox(width: 8),
                    _buildBedStatus(
                        'Kelas 2',
                        (hospital.bedAvailability?['kelas2']?['available'] ?? 0) >
                            0),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _buildBedStatus(
                        'Kelas 3',
                        (hospital.bedAvailability?['kelas3']?['available'] ?? 0) >
                            0),
                    SizedBox(width: 8),
                    _buildBedStatus('ICU',
                        (hospital.bedAvailability?['icu']?['available'] ?? 0) > 0),
                  ],
                ),

                SizedBox(height: 12),

                // Stok Darah
                Text('Stok Darah:',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87)),
                SizedBox(height: 8),
                Row(
                  children: [
                    _buildBloodStockStatus(
                        'A+', hospital.bloodStockInfo['A+']?.available ?? false),
                    SizedBox(width: 8),
                    _buildBloodStockStatus(
                        'A-', hospital.bloodStockInfo['A-']?.available ?? false),
                    SizedBox(width: 8),
                    _buildBloodStockStatus(
                        'B+', hospital.bloodStockInfo['B+']?.available ?? false),
                    SizedBox(width: 8),
                    _buildBloodStockStatus(
                        'B-', hospital.bloodStockInfo['B-']?.available ?? false),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _buildBloodStockStatus(
                        'AB+', hospital.bloodStockInfo['AB+']?.available ?? false),
                    SizedBox(width: 8),
                    _buildBloodStockStatus(
                        'AB-', hospital.bloodStockInfo['AB-']?.available ?? false),
                    SizedBox(width: 8),
                    _buildBloodStockStatus(
                        'O+', hospital.bloodStockInfo['O+']?.available ?? false),
                    SizedBox(width: 8),
                    _buildBloodStockStatus(
                        'O-', hospital.bloodStockInfo['O-']?.available ?? false),
                  ],
                ),

                SizedBox(height: 12),
                Text('Ketersediaan Ambulans:',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87)),
                SizedBox(height: 8),
                Row(
                  children: [
                    _buildMobilStockStatus('Ambulance',
                        (hospital.mobilAvailability?['ambulance']?['available'] ?? 0) > 0),
                    SizedBox(width: 8),
                    _buildMobilStockStatus('Jenazah',
                        (hospital.mobilAvailability?['jenazah']?['available'] ?? 0) > 0),
                    SizedBox(width: 8),
                  ],
                ),
                SizedBox(height: 12),

                // Layanan Instalasi (tetap di bawah)
                Text('Layanan Instalasi:',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87)),
                SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: hospital.services
                      .where((service) =>
                          service != 'IGD' &&
                          service != 'BPJS' &&
                          service != 'UTDRS' &&
                          service != 'Rujukan' &&
                          service != 'Spesialis')
                      .map((service) {
                    Color serviceColor = _getServiceColor(service);
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: serviceColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: serviceColor.withOpacity(0.3)),
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

                // Tombol Info Detail + Maps (TETAP ADA)
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HospitalDetailPage(hospital: hospital),
                            ),
                          );
                        },
                        icon: Icon(Icons.info_outline, size: 16),
                        label: Text('Info Detail',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFFFF6B35),
                          side: BorderSide(color: Color(0xFFFF6B35)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Open Maps
                        },
                        icon: Icon(Icons.map, size: 16),
                        label: Text('Maps',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFFFF6B35),
                          side: BorderSide(color: Color(0xFFFF6B35)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildBedStatus(String label, bool isAvailable) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isAvailable
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isAvailable ? Colors.green : Colors.red,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isAvailable ? Colors.green : Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildBloodStockStatus(String type, bool isAvailable) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isAvailable
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isAvailable ? Colors.green : Colors.red,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            type,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12, // sedikit lebih besar biar jelas
              fontWeight: FontWeight.w600,
              color: isAvailable ? Colors.green : Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobilStockStatus(String label, bool isAvailable) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isAvailable
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isAvailable ? Colors.green : Colors.red,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isAvailable ? Colors.green : Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildFacilityInfo(String count, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(height: 4),
        Text(
          count,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 9, color: Colors.grey[600])),
      ],
    );
  }

  Color _getServiceColor(String service) {
    switch (service) {
      case 'BPJS':
        return Colors.pink;
      case 'IGD':
        return const Color.fromARGB(255, 148, 12, 2);
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
}