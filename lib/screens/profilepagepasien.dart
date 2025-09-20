import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePagePasien extends StatefulWidget {
  const ProfilePagePasien({Key? key}) : super(key: key);

  @override
  State<ProfilePagePasien> createState() => _ProfilePagePasienState();
}

class _ProfilePagePasienState extends State<ProfilePagePasien> {
  Map<String, String> userData = {};
  Map<String, String> additionalData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load basic user data
      userData = {
        'name': prefs.getString('registeredName') ?? 'Iskandar',
        'nik': prefs.getString('registeredNik') ?? '',
        'email': prefs.getString('registeredEmail') ?? '',
      };
      
      // Load additional profile data
      additionalData = {
        'phone': prefs.getString('phone') ?? '081234567890',
        'bpjs': prefs.getString('bpjs') ?? '0001234567890',
        'address': prefs.getString('address') ?? 'Jl. Contoh Alamat No. 123, RT/RW 01/02',
        'province': prefs.getString('province') ?? 'Lampung',
        'district': prefs.getString('district') ?? 'Tanjung Karang Pusat',
        'regency': prefs.getString('regency') ?? 'Bandar Lampung',
        'village': prefs.getString('village') ?? 'Penengahan',
        'rt': prefs.getString('rt') ?? '01',
        'rw': prefs.getString('rw') ?? '02',
        'birthDate': prefs.getString('birthDate') ?? '01 Januari 1990',
        'familyCardNumber': prefs.getString('familyCardNumber') ?? '1234567890123456',
        'gender': prefs.getString('gender') ?? 'Laki-laki',
      };
      
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          userData = {
            'name': 'Iskandar',
            'nik': '',
            'email': '',
          };
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isTablet = screenWidth >= 600;
    final isLandscape = screenSize.width > screenSize.height;

    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFF6B35),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(screenWidth, screenHeight, isTablet),
            _buildProfileForm(screenWidth, isTablet, isLandscape),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth, double screenHeight, bool isTablet) {
    // Responsive header height
    double headerHeight = isTablet ? 250 : 
                         screenHeight < 600 ? 160 : 200;
    
    // Responsive avatar size
    double avatarSize = isTablet ? 100 : 
                       screenWidth < 360 ? 60 : 80;
    
    // Responsive font sizes
    double nameFontSize = isTablet ? 24 : 
                         screenWidth < 360 ? 16 : 18;
    
    // Responsive padding
    double horizontalPadding = screenWidth < 360 ? 16 : 20;

    return Container(
      height: headerHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFFF6B35),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Back button and edit icon
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, 
                vertical: screenWidth < 360 ? 8 : 10
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(isTablet ? 12 : 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: isTablet ? 28 : 24,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: Implement edit functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Fitur edit profil akan segera hadir'),
                          backgroundColor: Color(0xFFFF6B35),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(isTablet ? 12 : 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: isTablet ? 24 : 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: isTablet ? 30 : 20),
            
            // Profile avatar and name
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: avatarSize,
                    height: avatarSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        userData['name']?.isNotEmpty == true 
                            ? userData['name']![0].toUpperCase()
                            : 'P',
                        style: TextStyle(
                          fontSize: isTablet ? 40 : 
                                  screenWidth < 360 ? 24 : 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6B35),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isTablet ? 16 : 12),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              userData['name'] ?? 'Nama Pasien',
                              style: TextStyle(
                                fontSize: nameFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.edit,
                            size: isTablet ? 20 : 16,
                            color: Colors.white70,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileForm(double screenWidth, bool isTablet, bool isLandscape) {
    // Responsive padding
    double horizontalPadding = isTablet ? 40 : 
                              screenWidth < 360 ? 16 : 20;
    
    // For tablets and landscape, use constraint to limit width
    Widget formContent = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileField(
            label: 'NIK',
            value: userData['nik'] ?? '',
            isReadOnly: true,
            screenWidth: screenWidth,
            isTablet: isTablet,
          ),
          SizedBox(height: isTablet ? 24 : 20),
          _buildProfileField(
            label: 'Email',
            value: userData['email'] ?? '',
            isReadOnly: true,
            screenWidth: screenWidth,
            isTablet: isTablet,
          ),
          SizedBox(height: isTablet ? 24 : 20),
          _buildProfileField(
            label: 'No Telepon',
            value: additionalData['phone'] ?? '',
            isReadOnly: true,
            screenWidth: screenWidth,
            isTablet: isTablet,
          ),
          SizedBox(height: isTablet ? 24 : 20),
          _buildProfileField(
            label: 'No BPJS',
            value: additionalData['bpjs'] ?? '',
            isReadOnly: true,
            screenWidth: screenWidth,
            isTablet: isTablet,
          ),
          SizedBox(height: isTablet ? 24 : 20),
          _buildProfileField(
            label: 'Alamat',
            value: additionalData['address'] ?? '',
            isReadOnly: true,
            maxLines: 2,
            screenWidth: screenWidth,
            isTablet: isTablet,
          ),
          SizedBox(height: isTablet ? 24 : 20),
          
          // For tablets and landscape, show location fields in grid
          if (isTablet || isLandscape) ...[
            _buildLocationGrid(screenWidth, isTablet),
          ] else ...[
            _buildLocationFields(screenWidth, isTablet),
          ],
          
          SizedBox(height: isTablet ? 24 : 20),
          _buildProfileField(
            label: 'Tanggal Lahir',
            value: additionalData['birthDate'] ?? '',
            isReadOnly: true,
            screenWidth: screenWidth,
            isTablet: isTablet,
          ),
          SizedBox(height: isTablet ? 24 : 20),
          _buildProfileField(
            label: 'No KK',
            value: additionalData['familyCardNumber'] ?? '',
            isReadOnly: true,
            screenWidth: screenWidth,
            isTablet: isTablet,
          ),
          SizedBox(height: isTablet ? 24 : 20),
          _buildProfileField(
            label: 'Jenis Kelamin',
            value: additionalData['gender'] ?? '',
            isReadOnly: true,
            screenWidth: screenWidth,
            isTablet: isTablet,
          ),
          SizedBox(height: isTablet ? 60 : 40),
        ],
      ),
    );

    // For tablets, add maximum width constraint
    if (isTablet) {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: formContent,
        ),
      );
    }

    return formContent;
  }

  Widget _buildLocationGrid(double screenWidth, bool isTablet) {
    return Column(
      children: [
        // Province and District
        Row(
          children: [
            Expanded(
              child: _buildProfileField(
                label: 'Provinsi',
                value: additionalData['province'] ?? '',
                isReadOnly: true,
                screenWidth: screenWidth,
                isTablet: isTablet,
              ),
            ),
            SizedBox(width: isTablet ? 24 : 20),
            Expanded(
              child: _buildProfileField(
                label: 'Kecamatan',
                value: additionalData['district'] ?? '',
                isReadOnly: true,
                screenWidth: screenWidth,
                isTablet: isTablet,
              ),
            ),
          ],
        ),
        SizedBox(height: isTablet ? 24 : 20),
        
        // Regency and Village
        Row(
          children: [
            Expanded(
              child: _buildProfileField(
                label: 'Kabupaten',
                value: additionalData['regency'] ?? '',
                isReadOnly: true,
                screenWidth: screenWidth,
                isTablet: isTablet,
              ),
            ),
            SizedBox(width: isTablet ? 24 : 20),
            Expanded(
              child: _buildProfileField(
                label: 'Desa',
                value: additionalData['village'] ?? '',
                isReadOnly: true,
                screenWidth: screenWidth,
                isTablet: isTablet,
              ),
            ),
          ],
        ),
        SizedBox(height: isTablet ? 24 : 20),
        
        // RT and RW
        Row(
          children: [
            Expanded(
              child: _buildProfileField(
                label: 'RT',
                value: additionalData['rt'] ?? '',
                isReadOnly: true,
                screenWidth: screenWidth,
                isTablet: isTablet,
              ),
            ),
            SizedBox(width: isTablet ? 24 : 20),
            Expanded(
              child: _buildProfileField(
                label: 'RW',
                value: additionalData['rw'] ?? '',
                isReadOnly: true,
                screenWidth: screenWidth,
                isTablet: isTablet,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationFields(double screenWidth, bool isTablet) {
    return Column(
      children: [
        _buildProfileField(
          label: 'Provinsi',
          value: additionalData['province'] ?? '',
          isReadOnly: true,
          screenWidth: screenWidth,
          isTablet: isTablet,
        ),
        SizedBox(height: isTablet ? 24 : 20),
        _buildProfileField(
          label: 'Kecamatan',
          value: additionalData['district'] ?? '',
          isReadOnly: true,
          screenWidth: screenWidth,
          isTablet: isTablet,
        ),
        SizedBox(height: isTablet ? 24 : 20),
        _buildProfileField(
          label: 'Kabupaten',
          value: additionalData['regency'] ?? '',
          isReadOnly: true,
          screenWidth: screenWidth,
          isTablet: isTablet,
        ),
        SizedBox(height: isTablet ? 24 : 20),
        _buildProfileField(
          label: 'Desa',
          value: additionalData['village'] ?? '',
          isReadOnly: true,
          screenWidth: screenWidth,
          isTablet: isTablet,
        ),
        SizedBox(height: isTablet ? 24 : 20),
        Row(
          children: [
            Expanded(
              child: _buildProfileField(
                label: 'RT',
                value: additionalData['rt'] ?? '',
                isReadOnly: true,
                screenWidth: screenWidth,
                isTablet: isTablet,
              ),
            ),
            SizedBox(width: isTablet ? 24 : 20),
            Expanded(
              child: _buildProfileField(
                label: 'RW',
                value: additionalData['rw'] ?? '',
                isReadOnly: true,
                screenWidth: screenWidth,
                isTablet: isTablet,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileField({
    required String label,
    required String value,
    required double screenWidth,
    required bool isTablet,
    bool isReadOnly = false,
    int maxLines = 1,
  }) {
    // Responsive font sizes
    double labelFontSize = isTablet ? 16 : 
                          screenWidth < 360 ? 12 : 14;
    double valueFontSize = isTablet ? 18 : 
                          screenWidth < 360 ? 14 : 16;
    
    // Responsive padding
    double horizontalPadding = isTablet ? 20 : 
                              screenWidth < 360 ? 12 : 16;
    double verticalPadding = isTablet ? 16 : 
                            screenWidth < 360 ? 10 : 12;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: labelFontSize,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: isTablet ? 12 : 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          ),
          child: Text(
            value.isEmpty ? '-' : value,
            style: TextStyle(
              fontSize: valueFontSize,
              color: value.isEmpty ? Colors.grey[500] : Colors.black87,
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}