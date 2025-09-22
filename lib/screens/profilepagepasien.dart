import 'package:flutter/material.dart';
import 'package:inocare/services/user_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePagePasien extends StatefulWidget {
  const ProfilePagePasien({Key? key}) : super(key: key);

  @override
  State<ProfilePagePasien> createState() => _ProfilePagePasienState();
}

class _ProfilePagePasienState extends State<ProfilePagePasien> {
  Map<String, String?>? userData;
  Map<String, String> additionalData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await UserPrefs.getUser();
    final profileData = await UserPrefs.getProfileData();

    if (mounted) {
      setState(() {
        userData = user;
        additionalData = {
          'phone': profileData['phone'] ?? '081234567890',
          'bpjs': profileData['bpjs'] ?? '0001234567890',
          'address':
              profileData['address'] ?? 'Jl. Contoh Alamat No. 123, RT/RW 01/02',
          'province': profileData['province'] ?? 'Lampung',
          'district': profileData['district'] ?? 'Tanjung Karang Pusat',
          'regency': profileData['regency'] ?? 'Bandar Lampung',
          'village': profileData['village'] ?? 'Penengahan',
          'rt': profileData['rt'] ?? '01',
          'rw': profileData['rw'] ?? '02',
          'birthDate': profileData['birthDate'] ?? '01 Januari 1990',
          'familyCardNumber':
              profileData['familyCardNumber'] ?? '1234567890123456',
          'gender': profileData['gender'] ?? 'Laki-laki',
        };
        isLoading = false;
      });
    }
  }

  Future<void> _saveAdditionalData() async {
    final prefs = await SharedPreferences.getInstance();
    for (String key in additionalData.keys) {
      await prefs.setString(key, additionalData[key]!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFF6B35),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: _buildProfileForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFF8A50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Back button and edit icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // TODO: Implement edit functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fitur edit profil akan segera hadir'),
                        backgroundColor: Color(0xFFFF6B35),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Profile avatar and name
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    userData?['name']?.isNotEmpty == true
                        ? userData!['name']![0].toUpperCase()
                        : 'P',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B35),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userData?['name'] ?? 'Nama Pasien',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.edit,
                    size: 16,
                    color: Colors.white70,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileField(
          label: 'NIK',
          value: userData?['nik'] ?? '',
          isReadOnly: true,
        ),
        const SizedBox(height: 20),
        _buildProfileField(
          label: 'Email',
          value: userData?['email'] ?? '',
          isReadOnly: true,
        ),
        const SizedBox(height: 20),
        _buildProfileField(
          label: 'No Telepon',
          value: additionalData['phone'] ?? '',
          isReadOnly: true,
        ),
        const SizedBox(height: 20),
        _buildProfileField(
          label: 'No BPJS',
          value: additionalData['bpjs'] ?? '',
          isReadOnly: true,
        ),
        const SizedBox(height: 20),
        _buildProfileField(
          label: 'Alamat',
          value: additionalData['address'] ?? '',
          isReadOnly: true,
          maxLines: 2,
        ),
        const SizedBox(height: 20),
        _buildProfileField(
          label: 'Provinsi',
          value: additionalData['province'] ?? '',
          isReadOnly: true,
        ),
        const SizedBox(height: 20),
        _buildProfileField(
          label: 'Kecamatan',
          value: additionalData['district'] ?? '',
          isReadOnly: true,
        ),
        const SizedBox(height: 20),
        _buildProfileField(
          label: 'Kabupaten',
          value: additionalData['regency'] ?? '',
          isReadOnly: true,
        ),
        const SizedBox(height: 20),
        _buildProfileField(
          label: 'Desa',
          value: additionalData['village'] ?? '',
          isReadOnly: true,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildProfileField(
                label: 'RT',
                value: additionalData['rt'] ?? '',
                isReadOnly: true,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildProfileField(
                label: 'RW',
                value: additionalData['rw'] ?? '',
                isReadOnly: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildProfileField(
          label: 'Tanggal Lahir',
          value: additionalData['birthDate'] ?? '',
          isReadOnly: true,
        ),
        const SizedBox(height: 20),
        _buildProfileField(
          label: 'No KK',
          value: additionalData['familyCardNumber'] ?? '',
          isReadOnly: true,
        ),
        const SizedBox(height: 20),
        _buildProfileField(
          label: 'Jenis Kelamin',
          value: additionalData['gender'] ?? '',
          isReadOnly: true,
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildProfileField({
    required String label,
    required String value,
    bool isReadOnly = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value.isEmpty ? '-' : value,
            style: TextStyle(
              fontSize: 16,
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
