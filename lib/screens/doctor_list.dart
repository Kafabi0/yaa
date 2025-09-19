import 'package:flutter/material.dart';
import '../screens/doctor_detail.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final List<Map<String, String>> doctors = const [
    {
      'name': 'Dr. Adi Januar Akbar',
      'specialty': 'Dokter Umum',
      'hospital': 'RS Medika Utama',
      'experience': '10 tahun',
      'availability': 'Online',
      'distance': '52.2 km',
      'gender': 'Male',
      'image': 'assets/dokter/doctor1.png',
    },
    {
      'name': 'Dr. Rasawa',
      'specialty': 'Dokter Anak',
      'hospital': 'RS Sehat Sentosa',
      'experience': '12 tahun',
      'availability': 'Offline',
      'distance': '12.7 km',
      'gender': 'Female',
      'image': 'assets/dokter/doctor33.png',
    },
    {
      'name': 'Dr. Anggi Suryati',
      'specialty': 'Dokter Gigi',
      'hospital': 'Klinik Pergigian Adda',
      'experience': '5 tahun',
      'availability': 'Online',
      'distance': '27.5 km',
      'gender': 'Female',
      'image': 'assets/dokter/doctor4.png',
    },
    {
      'name': 'Dr. Astarini',
      'specialty': 'Dokter Umum',
      'hospital': 'Rs Medika Utama',
      'experience': '5 tahun',
      'availability': 'Offline',
      'distance': '9.9 km',
      'gender': 'Female',
      'image': 'assets/dokter/doctor55.png',
    },
  ];

  final List<String> specialties = [
    'Semua',
    'Dokter Umum',
    'Dokter Anak',
    'Dokter Gigi',
  ];

  String selectedFilter = 'Semua';
  String searchQuery = ''; // untuk menyimpan input search
  final Color primaryColor = const Color(0xFF0D6EFD);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBackgroundColor =
        isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
    final appBarColor = isDark ? const Color(0xFF1E1E1E) : primaryColor;
    final appBarTextColor = Colors.white;
    final filterContainerColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtextColor = isDark ? Colors.grey[400] : Colors.grey[700];
    final hospitalColor = isDark ? Colors.grey[500] : Colors.grey[600];

    // Filter dokter berdasarkan specialty
    List<Map<String, String>> filteredDoctors = selectedFilter == 'Semua'
        ? doctors
        : doctors.where((doc) => doc['specialty'] == selectedFilter).toList();

    // Filter dokter berdasarkan search query
    if (searchQuery.isNotEmpty) {
      filteredDoctors = filteredDoctors
          .where((doc) =>
              doc['name']!.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Daftar Dokter'),
        backgroundColor: appBarColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari dokter...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: filterContainerColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: primaryColor,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          // Filter berdasarkan specialty
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: filterContainerColor,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: specialties.map((spec) {
                  final bool isSelected = selectedFilter == spec;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          selectedFilter = spec;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isSelected
                            ? primaryColor
                            : (isDark ? Colors.black26 : Colors.white),
                        foregroundColor: isSelected ? Colors.white : textColor,
                        side: BorderSide(
                          color: isSelected
                              ? primaryColor
                              : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(spec, overflow: TextOverflow.ellipsis),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // List Dokter
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                final doctor = filteredDoctors[index];
                return Card(
                  color: cardColor,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: Colors.black26,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DoctorDetailScreen(doctor: doctor),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundImage: AssetImage(doctor['image']!),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctor['name']!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: textColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  doctor['specialty']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: subtextColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  doctor['hospital']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: hospitalColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.work_outline,
                                      size: 14,
                                      color: hospitalColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      doctor['experience']!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: hospitalColor,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(
                                      Icons.circle,
                                      size: 10,
                                      color:
                                          doctor['availability'] == 'Online'
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      doctor['availability']!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            doctor['availability'] == 'Online'
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 90,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DoctorDetailScreen(doctor: doctor),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Detail',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
