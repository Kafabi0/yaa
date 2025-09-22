import 'package:flutter/material.dart';
import 'package:inocare/main.dart';
import 'package:inocare/screens/detailrsmember.dart';
import 'package:inocare/screens/home_page_member.dart';

class RumahSakitMemberPage extends StatefulWidget {
  const RumahSakitMemberPage({Key? key}) : super(key: key);

  @override
  State<RumahSakitMemberPage> createState() => _RumahSakitMemberPageState();
}

Hospital? _selectedHospital;

class _RumahSakitMemberPageState extends State<RumahSakitMemberPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedProvince = 'Jawa Barat';
  String _selectedCity = 'Bandung';
  String _selectedFilter = 'Semua';
  String _selectedSort = 'Terdekat';

  // Indonesian provinces and cities data
  Map<String, List<String>> _provinceCities = {
    'Aceh': ['Banda Aceh', 'Langsa', 'Lhokseumawe', 'Meulaboh', 'Sabang'],
    'Sumatera Utara': [
      'Medan',
      'Binjai',
      'Pematangsiantar',
      'Sibolga',
      'Tanjungbalai',
      'Tebing Tinggi',
    ],
    'Sumatera Barat': [
      'Padang',
      'Bukittinggi',
      'Padang Panjang',
      'Payakumbuh',
      'Sawahlunto',
      'Solok',
    ],
    'Riau': ['Pekanbaru', 'Dumai'],
    'Kepulauan Riau': ['Tanjungpinang', 'Batam'],
    'Jambi': ['Jambi', 'Sungai Penuh'],
    'Sumatera Selatan': [
      'Palembang',
      'Lubuklinggau',
      'Pagar Alam',
      'Prabumulih',
    ],
    'Bangka Belitung': ['Pangkalpinang'],
    'Bengkulu': ['Bengkulu'],
    'Lampung': ['Bandar Lampung', 'Metro'],
    'DKI Jakarta': [
      'Jakarta Pusat',
      'Jakarta Utara',
      'Jakarta Barat',
      'Jakarta Selatan',
      'Jakarta Timur',
    ],
    'Jawa Barat': [
      'Bandung',
      'Bekasi',
      'Bogor',
      'Cimahi',
      'Cirebon',
      'Depok',
      'Sukabumi',
      'Tasikmalaya',
      'Banjar',
      'Kuningan',
      'Majalengka',
      'Indramayu',
      'Subang',
      'Purwakarta',
      'Karawang',
      'Garut',
    ],
    'Jawa Tengah': [
      'Semarang',
      'Magelang',
      'Pekalongan',
      'Purwokerto',
      'Salatiga',
      'Solo',
      'Tegal',
      'Yogyakarta',
    ],
    'DI Yogyakarta': ['Yogyakarta'],
    'Jawa Timur': [
      'Surabaya',
      'Batu',
      'Blitar',
      'Kediri',
      'Madiun',
      'Malang',
      'Mojokerto',
      'Pasuruan',
      'Probolinggo',
    ],
    'Banten': ['Serang', 'Cilegon', 'Tangerang', 'Tangerang Selatan'],
    'Bali': ['Denpasar'],
    'Nusa Tenggara Barat': ['Mataram', 'Bima'],
    'Nusa Tenggara Timur': ['Kupang'],
    'Kalimantan Barat': ['Pontianak', 'Singkawang'],
    'Kalimantan Tengah': ['Palangka Raya'],
    'Kalimantan Selatan': ['Banjarmasin', 'Banjarbaru'],
    'Kalimantan Timur': ['Samarinda', 'Balikpapan', 'Bontang'],
    'Kalimantan Utara': ['Tarakan'],
    'Sulawesi Utara': ['Manado', 'Bitung', 'Kotamobagu', 'Tomohon'],
    'Sulawesi Tengah': ['Palu'],
    'Sulawesi Selatan': ['Makassar', 'Palopo', 'Parepare'],
    'Sulawesi Tenggara': ['Kendari', 'Baubau'],
    'Gorontalo': ['Gorontalo'],
    'Sulawesi Barat': ['Mamuju'],
    'Maluku': ['Ambon', 'Tual'],
    'Maluku Utara': ['Ternate', 'Tidore Kepulauan'],
    'Papua': ['Jayapura'],
    'Papua Barat': ['Manokwari', 'Sorong'],
  };

  List<String> _sortOptions = [
    'Terdekat',
    'Rating Tertinggi',
    'Nama A-Z',
    'Paling Populer',
    'Harga Termurah',
  ];

  // Sample hospital data with detailed information
  List<Hospital> _hospitals = [
    Hospital(
      name: 'Edelweiss Hospital',
      address:
          'Jl. Soekarno-Hatta No.550, Sekejati, Kec. Buahbatu, Kota Bandung, Jawa Barat 40286, Indonesia',
      phone: '(022) 2034953',
      distance: '1.2 km',
      rating: 4.4,
      reviewCount: 2051,
      isOpen: true,
      services: ['BPJS', 'IGD 24 Jam', 'MCU', 'Spesialis', 'Rujukan'],
      imagePath: 'assets/images/edelweiss.jpg',
      operatingHours: 'Buka 24 Jam',
      type: 'RS Swasta',
      bloodStock: {
        'A+': BloodStock(type: 'A+', available: true, count: 12),
        'A-': BloodStock(type: 'A-', available: true, count: 3),
        'B+': BloodStock(type: 'B+', available: true, count: 8),
        'B-': BloodStock(type: 'B-', available: false, count: 0),
        'AB+': BloodStock(type: 'AB+', available: false, count: 0),
        'AB-': BloodStock(type: 'AB-', available: true, count: 2),
        'O+': BloodStock(type: 'O+', available: true, count: 15),
        'O-': BloodStock(type: 'O-', available: true, count: 5),
      },
      facilities: {'kamarVip': 12, 'igd': 5, 'dokter': 30, 'antrian': 'Pendek'},
      specialties: ['Kardiologi', 'Neurologi', 'Orthopedi', 'Pediatri'],
    ),
    Hospital(
      name: 'RSUD Dr. H. Abdul Moeloek',
      address:
          'Jl. Dr. Rivai No.6, Penengahan, Kec. Tj. Karang Pusat, Kota Bandar Lampung, Lampung 35112',
      phone: '(0721) 703312',
      distance: '2.1 km',
      rating: 4.2,
      reviewCount: 1567,
      isOpen: true,
      services: ['BPJS', 'IGD 24 Jam', 'Spesialis', 'Rujukan'],
      imagePath: 'assets/images/abdulmuluk.png',
      operatingHours: 'Buka 24 Jam',
      type: 'RS Pemerintah',
      bloodStock: {
        'A+': BloodStock(type: 'A+', available: true, count: 8),
        'A-': BloodStock(type: 'A-', available: false, count: 0),
        'B+': BloodStock(type: 'B+', available: true, count: 6),
        'B-': BloodStock(type: 'B-', available: true, count: 2),
        'AB+': BloodStock(type: 'AB+', available: true, count: 3),
        'AB-': BloodStock(type: 'AB-', available: false, count: 0),
        'O+': BloodStock(type: 'O+', available: true, count: 10),
        'O-': BloodStock(type: 'O-', available: true, count: 4),
      },
      facilities: {'kamarVip': 8, 'igd': 3, 'dokter': 25, 'antrian': 'Sedang'},
      specialties: ['Penyakit Dalam', 'Bedah', 'Anak', 'Kandungan'],
    ),
    Hospital(
      name: 'RS Advent Bandung',
      address:
          'Jl. Cihampelas No.161, Cipaganti, Kec. Coblong, Kota Bandung, Jawa Barat 40131',
      phone: '(022) 2032001',
      distance: '3.5 km',
      rating: 4.3,
      reviewCount: 892,
      isOpen: true,
      services: ['BPJS', 'IGD 24 Jam', 'MCU', 'Spesialis'],
      imagePath: 'assets/images/rsadvent.jpg',
      operatingHours: 'Buka 24 Jam',
      type: 'RS Swasta',
      bloodStock: {
        'A+': BloodStock(type: 'A+', available: true, count: 5),
        'A-': BloodStock(type: 'A-', available: true, count: 1),
        'B+': BloodStock(type: 'B+', available: false, count: 0),
        'B-': BloodStock(type: 'B-', available: true, count: 2),
        'AB+': BloodStock(type: 'AB+', available: true, count: 2),
        'AB-': BloodStock(type: 'AB-', available: false, count: 0),
        'O+': BloodStock(type: 'O+', available: true, count: 7),
        'O-': BloodStock(type: 'O-', available: true, count: 3),
      },
      facilities: {'kamarVip': 15, 'igd': 4, 'dokter': 28, 'antrian': 'Pendek'},
      specialties: ['Kardiologi', 'Pulmonologi', 'Gastroenterologi'],
    ),
    Hospital(
      name: 'RS Hermina Arcamanik',
      address:
          'Jl. A.H. Nasution No.50, Antapani Kidul, Kec. Antapani, Kota Bandung, Jawa Barat 40291',
      phone: '(022) 7562525',
      distance: '5.1 km',
      rating: 4.4,
      reviewCount: 2013,
      isOpen: true,
      services: ['BPJS', 'IGD 24 Jam', 'MCU', 'Spesialis', 'Rujukan'],
      imagePath: 'assets/images/hermina1.jpg',
      operatingHours: 'Buka 24 Jam',
      type: 'RS Swasta',
      bloodStock: {
        'A+': BloodStock(type: 'A+', available: true, count: 18),
        'A-': BloodStock(type: 'A-', available: true, count: 4),
        'B+': BloodStock(type: 'B+', available: true, count: 9),
        'B-': BloodStock(type: 'B-', available: true, count: 2),
        'AB+': BloodStock(type: 'AB+', available: true, count: 4),
        'AB-': BloodStock(type: 'AB-', available: false, count: 0),
        'O+': BloodStock(type: 'O+', available: true, count: 20),
        'O-': BloodStock(type: 'O-', available: true, count: 6),
      },
      facilities: {'kamarVip': 20, 'igd': 6, 'dokter': 35, 'antrian': 'Sedang'},
      specialties: ['Kandungan', 'Anak', 'Jantung', 'Saraf'],
    ),
  ];

  List<Hospital> _filteredHospitals = [];

  @override
  void initState() {
    super.initState();
    _filteredHospitals = _hospitals;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterHospitals() {
    setState(() {
      _filteredHospitals =
          _hospitals.where((hospital) {
            bool matchesSearch =
                hospital.name.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ||
                hospital.address.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                );

            bool matchesFilter =
                _selectedFilter == 'Semua' ||
                (_selectedFilter == 'Buka 24 Jam' &&
                    hospital.services.contains('IGD 24 Jam')) ||
                (_selectedFilter == 'Stok Darah' && hospital.hasBloodStock()) ||
                (_selectedFilter == 'BPJS' &&
                    hospital.services.contains('BPJS')) ||
                (_selectedFilter == 'IGD' &&
                    hospital.services.contains('IGD 24 Jam')) ||
                (_selectedFilter == 'MCU' && hospital.services.contains('MCU'));

            return matchesSearch && matchesFilter;
          }).toList();

      // Sort hospitals
      if (_selectedSort == 'Terdekat') {
        _filteredHospitals.sort(
          (a, b) => double.parse(
            a.distance.split(' ')[0],
          ).compareTo(double.parse(b.distance.split(' ')[0])),
        );
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
                  Icon(Icons.location_on, color: Colors.red, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Lokasi Anda: ',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'Bandung, Jawa Barat',
                    style: TextStyle(
                      color: Color(0xFFFF6B35),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      // TODO: Change location
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Ubah',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
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
                              _selectedCity =
                                  _provinceCities[_selectedProvince]![0];
                            });
                            _filterHospitals();
                          },
                          items:
                              _provinceCities.keys
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
                            });
                            _filterHospitals();
                          },
                          items:
                              _provinceCities[_selectedProvince]!
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
          // Hospital Image with overlay info
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
                  // Hospital name
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
                // Rating and Distance
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
                        hospital.distance,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                // Address and Phone
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
                      color: hospital.isOpen ? Colors.green : Colors.red,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      hospital.operatingHours,
                      style: TextStyle(
                        fontSize: 11,
                        color: hospital.isOpen ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                // Blood Stock Section
                Text(
                  'Stok Darah:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Column(
                  children: [
                    // First row: A+, A-, B+, B-
                    Row(
                      children:
                          ['A+', 'A-', 'B+', 'B-'].map((bloodType) {
                            BloodStock stock = hospital.bloodStock[bloodType]!;
                            return Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 4),
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color:
                                      stock.available
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color:
                                        stock.available
                                            ? Colors.green
                                            : Colors.red,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      stock.type,
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            stock.available
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                    Text(
                                      stock.available ? '${stock.count}' : '0',
                                      style: TextStyle(
                                        fontSize: 7,
                                        color:
                                            stock.available
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                    Icon(
                                      stock.available
                                          ? Icons.check
                                          : Icons.close,
                                      color:
                                          stock.available
                                              ? Colors.green
                                              : Colors.red,
                                      size: 10,
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
                      children:
                          ['AB+', 'AB-', 'O+', 'O-'].map((bloodType) {
                            BloodStock stock = hospital.bloodStock[bloodType]!;
                            return Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 4),
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color:
                                      stock.available
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color:
                                        stock.available
                                            ? Colors.green
                                            : Colors.red,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      stock.type,
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            stock.available
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                    Text(
                                      stock.available ? '${stock.count}' : '0',
                                      style: TextStyle(
                                        fontSize: 7,
                                        color:
                                            stock.available
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                    Icon(
                                      stock.available
                                          ? Icons.check
                                          : Icons.close,
                                      color:
                                          stock.available
                                              ? Colors.green
                                              : Colors.red,
                                      size: 10,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                // Facilities Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildFacilityInfo(
                      '${hospital.facilities['kamarVip']}',
                      'Kamar VIP',
                      Icons.hotel,
                    ),
                    _buildFacilityInfo(
                      '${hospital.facilities['igd']}',
                      'IGD',
                      Icons.local_hospital,
                    ),
                    _buildFacilityInfo(
                      '${hospital.facilities['dokter']}',
                      'Dokter',
                      Icons.person,
                    ),
                    _buildFacilityInfo(
                      '${hospital.facilities['antrian']}',
                      'Antrian',
                      Icons.queue,
                    ),
                  ],
                ),

                SizedBox(height: 12),

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
                  children:
                      hospital.services.map((service) {
                        Color serviceColor = _getServiceColor(service);
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
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

                // Maps Button
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      HospitalDetailPage(hospital: hospital),
                            ),
                          );
                        },
                        icon: Icon(Icons.info_outline, size: 16),
                        label: Text(
                          'Info Detail',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
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
                    SizedBox(width: 12), // Jarak antara tombol dan detail
                    Expanded(
                      flex: 3,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Open maps
                        },
                        icon: Icon(Icons.map, size: 16),
                        label: Text(
                          'Maps',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
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
}

// Hospital model class with detailed information
class Hospital {
  final String name;
  final String address;
  final String phone;
  final String distance;
  final double rating;
  final int reviewCount;
  final bool isOpen;
  final List<String> services;
  final String imagePath;
  final String operatingHours;
  final String type;
  final Map<String, BloodStock> bloodStock;
  final Map<String, dynamic> facilities;
  final List<String> specialties;

  Hospital({
    required this.name,
    required this.address,
    required this.phone,
    required this.distance,
    required this.rating,
    required this.reviewCount,
    required this.isOpen,
    required this.services,
    required this.imagePath,
    required this.operatingHours,
    required this.type,
    required this.bloodStock,
    required this.facilities,
    required this.specialties,
  });

  bool hasBloodStock() {
    return bloodStock.values.any((stock) => stock.available && stock.count > 0);
  }
}

// Blood stock model
class BloodStock {
  final String type;
  final bool available;
  final int count;

  BloodStock({
    required this.type,
    required this.available,
    required this.count,
  });
}
