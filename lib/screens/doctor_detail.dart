import 'package:flutter/material.dart';

final Map<String, List<Map<String, String>>> appointments = {
  '2025-08-27': [
    {
      'patient': 'Alice Johnson',
      'time': '03:30 PM',
      'avatar': 'https://i.pravatar.cc/150?img=5',
      'doctor': 'Dr. Adi Januar Akbar',
    },
    {
      'patient': 'Bob Smith',
      'time': '11:30 AM',
      'avatar': 'https://i.pravatar.cc/150?img=6',
      'doctor': 'Dr. Ana Verawaty',
    },
  ],
  '2025-08-28': [
    {
      'patient': 'Charlie Lee',
      'time': '02:00 PM',
      'avatar': 'https://i.pravatar.cc/150?img=7',
      'doctor': 'Dr. Anggi Suryati',
    },
  ],
  '2025-08-29': [
    {
      'patient': 'Diana Prince',
      'time': '09:00 AM',
      'avatar': 'https://i.pravatar.cc/150?img=8',
      'doctor': 'Dr. Astarini',
    },
    {
      'patient': 'Edward King',
      'time': '01:00 PM',
      'avatar': 'https://i.pravatar.cc/150?img=9',
      'doctor': 'Dr. Adi Januar Akbar',
    },
  ],
  '2025-08-30': [
    {
      'patient': 'Charlie Puth',
      'time': '12:00 PM',
      'avatar': 'https://i.pravatar.cc/150?img=11',
      'doctor': 'Dr. Ana Verawaty',
    },
    {
      'patient': 'Rachel Green',
      'time': '01:00 PM',
      'avatar': 'https://i.pravatar.cc/150?img=10',
      'doctor': 'Dr. Anggi Suryati',
    },
  ],
};

final Map<String, Map<String, dynamic>> doctorExtraData = {
  'Dr. Adi Januar Akbar': {
    'rating': 4.9,
    'reviewCount': 120,
    'patientsCount': 300,
    'workingHours': {
      'Monday': '09:00 - 17:00',
      'Tuesday': '09:00 - 17:00',
      'Wednesday': '10:00 - 18:00',
      'Thursday': '09:00 - 17:00',
      'Friday': '09:00 - 15:00',
    },
    'reviews': [
      {
        'patient': 'Alice Johnson',
        'comment': 'Dokter sangat ramah dan profesional!',
      },
      {
        'patient': 'Edward King',
        'comment': 'Sangat membantu dan penjelasannya jelas.',
      },
      {'patient': 'John Doe', 'comment': 'Praktik nyaman, dokter tepat waktu.'},
    ],
  },
  'Dr. Rasawa': {
    'rating': 4.7,
    'reviewCount': 98,
    'patientsCount': 210,
    'workingHours': {
      'Monday': '10:00 - 18:00',
      'Tuesday': '10:00 - 18:00',
      'Wednesday': '09:00 - 17:00',
      'Thursday': '10:00 - 18:00',
      'Friday': '09:00 - 16:00',
    },
    'reviews': [
      {
        'patient': 'Bob Smith',
        'comment': 'Sangat sabar dan detail dalam menjelaskan penyakit.',
      },
      {
        'patient': 'Charlie Puth',
        'comment': 'Tempat praktik nyaman dan dokter ramah.',
      },
    ],
  },
  'Dr. Anggi Suryati': {
    'rating': 4.5,
    'reviewCount': 75,
    'patientsCount': 180,
    'workingHours': {
      'Monday': '08:00 - 16:00',
      'Tuesday': '09:00 - 17:00',
      'Wednesday': '08:00 - 16:00',
      'Thursday': '09:00 - 17:00',
      'Friday': '08:00 - 15:00',
    },
    'reviews': [
      {
        'patient': 'Charlie Lee',
        'comment': 'Dokter profesional, tepat waktu, dan sabar.',
      },
      {'patient': 'Rachel Green', 'comment': 'Pelayanan sangat memuaskan.'},
    ],
  },
  'Dr. Astarini': {
    'rating': 4.6,
    'reviewCount': 60,
    'patientsCount': 150,
    'workingHours': {
      'Monday': '09:00 - 17:00',
      'Tuesday': '10:00 - 18:00',
      'Wednesday': '09:00 - 17:00',
      'Thursday': '10:00 - 18:00',
      'Friday': '09:00 - 16:00',
    },
    'reviews': [
      {
        'patient': 'Diana Prince',
        'comment': 'Dokter sangat komunikatif dan profesional.',
      },
      {
        'patient': 'John Doe',
        'comment': 'Memberikan solusi yang sangat jelas dan mudah dimengerti.',
      },
    ],
  },
};

class DoctorDetailScreen extends StatelessWidget {
  final Map<String, String> doctor;

  const DoctorDetailScreen({super.key, required this.doctor});

  List<Map<String, String>> _getDoctorSchedule(String doctorName) {
    List<Map<String, String>> schedule = [];
    appointments.forEach((date, appts) {
      for (var appt in appts) {
        if (appt['doctor'] == doctorName) {
          schedule.add({
            'patient': appt['patient']!,
            'time': appt['time']!,
            'date': date,
          });
        }
      }
    });
    schedule.sort((a, b) => a['date']!.compareTo(b['date']!));
    return schedule;
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final bool isDarkMode = brightness == Brightness.dark;
    
    final Color backgroundColor = isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
    final Color cardColor = isDarkMode ? const Color(0xFF2D3748) : Colors.white;
    final Color darkTextColor = isDarkMode ? Colors.white : const Color(0xFF1F2937);
    final Color lightTextColor = isDarkMode ? const Color(0xFFE2E8F0) : const Color(0xFF6B7280);
    final Color borderColor = isDarkMode ? const Color(0xFF4A5568) : const Color(0xFFE5E7EB);
    final Color secondaryCardColor = isDarkMode ? const Color(0xFF1A202C) : const Color(0xFFF8FAFC);
    final Color secondaryBorderColor = isDarkMode ? const Color(0xFF2D3748) : const Color(0xFFE5E7EB);
    final Color secondaryTextColor = isDarkMode ? const Color(0xFFCBD5E0) : const Color(0xFF374151);


    final String availability = doctor['availability'] ?? "Offline";
    final doctorSchedule = _getDoctorSchedule(doctor['name']!);

    // Ambil data ekstra dokter
    final extra = doctorExtraData[doctor['name']] ?? {};
    final double rating = extra['rating'] ?? 0.0;
    final int reviewCount = extra['reviewCount'] ?? 0;
    final int patientsCount = extra['patientsCount'] ?? 0;
    final Map<String, String> workingHours = Map<String, String>.from(
      extra['workingHours'] ?? {},
    );
    final List<Map<String, String>> reviews = List<Map<String, String>>.from(
      extra['reviews'] ?? [],
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          // Premium App Bar with gradient
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
              ),
              child: FlexibleSpaceBar(
                title: Text(
                  doctor['name']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                centerTitle: true,
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Premium Profile Section
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Enhanced profile picture
                        Hero(
                          tag: 'doctor-${doctor['name']}',
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF667EEA,
                                  ).withOpacity(isDarkMode ? 0.4 : 0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                                child: CircleAvatar(
                                  radius: 56,
                                  backgroundImage: AssetImage(
                                    doctor['image'] ??
                                        'assets/dokter/doctor1.png',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Text(
                          doctor['name']!,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: darkTextColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            doctor['specialty']!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: secondaryCardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: borderColor,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatItem(
                                Icons.star_rounded,
                                rating.toString(),
                                '$reviewCount reviews',
                                const Color(0xFFFBBF24),
                                isDarkMode: isDarkMode,
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: borderColor,
                              ),
                              _buildStatItem(
                                Icons.people_rounded,
                                patientsCount.toString(),
                                'patients',
                                const Color(0xFF667EEA),
                                isDarkMode: isDarkMode,
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: borderColor,
                              ),
                              _buildStatItem(
                                Icons.circle,
                                availability,
                                'status',
                                availability == "Online"
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFEF4444),
                                isDarkMode: isDarkMode,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Information Cards Grid
                  _buildPremiumInfoCard(
                    'Professional Information',
                    [
                      _buildInfoItem(
                        Icons.person_rounded,
                        'Gender',
                        doctor['gender'],
                        isDarkMode: isDarkMode,
                      ),
                      _buildInfoItem(
                        Icons.school_rounded,
                        'Education',
                        doctor['education'],
                        isDarkMode: isDarkMode,
                      ),
                      _buildInfoItem(
                        Icons.local_hospital_rounded,
                        'Hospital',
                        doctor['hospital'],
                        isDarkMode: isDarkMode,
                      ),
                      _buildInfoItem(
                        Icons.email_rounded,
                        'Email',
                        doctor['email'],
                        isDarkMode: isDarkMode,
                      ),
                      _buildInfoItem(
                        Icons.phone_rounded,
                        'Phone',
                        doctor['phone'],
                        isDarkMode: isDarkMode,
                      ),
                      _buildInfoItem(
                        Icons.schedule_rounded,
                        'Experience',
                        doctor['experience'],
                        isDarkMode: isDarkMode,
                      ),
                    ],
                    cardColor: cardColor,
                    isDarkMode: isDarkMode,
                  ),

                  const SizedBox(height: 20),

                  // Working Hours Card
                  _buildPremiumWorkingHours(workingHours, cardColor: cardColor, isDarkMode: isDarkMode),

                  const SizedBox(height: 20),

                  // Biography Card
                  _buildPremiumBiography(doctor['bio'], cardColor: cardColor, isDarkMode: isDarkMode),

                  const SizedBox(height: 20),

                  // Schedule Card
                  _buildPremiumSchedule(doctorSchedule, cardColor: cardColor, isDarkMode: isDarkMode),

                  const SizedBox(height: 20),

                  // Reviews Card
                  _buildPremiumReviews(reviews, rating, cardColor: cardColor, isDarkMode: isDarkMode),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String value,
    String label,
    Color color, {
    required bool isDarkMode,
  }) {
    final Color darkTextColor = isDarkMode ? Colors.white : const Color(0xFF1F2937);
    final Color lightTextColor = isDarkMode ? const Color(0xFFE2E8F0) : const Color(0xFF6B7280);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkTextColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: lightTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumInfoCard(String title, List<Widget> children, {
    required Color cardColor,
    required bool isDarkMode,
  }) {
    final Color darkTextColor = isDarkMode ? Colors.white : const Color(0xFF1F2937);
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: darkTextColor,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 20),
            ...children
                .map(
                  (child) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: child,
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String? value, {
    required bool isDarkMode,
  }) {
    final Color darkTextColor = isDarkMode ? Colors.white : const Color(0xFF1F2937);
    final Color lightTextColor = isDarkMode ? const Color(0xFFE2E8F0) : const Color(0xFF6B7280);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF667EEA).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF667EEA), size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: lightTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value ?? "Not provided",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: darkTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumWorkingHours(Map<String, String> workingHours, {
    required Color cardColor,
    required bool isDarkMode,
  }) {
    final Color darkTextColor = isDarkMode ? Colors.white : const Color(0xFF1F2937);
    final Color secondaryCardColor = isDarkMode ? const Color(0xFF1A202C) : const Color(0xFFF8FAFC);
    final Color secondaryBorderColor = isDarkMode ? const Color(0xFF4A5568) : const Color(0xFFE5E7EB);
    final Color secondaryTextColor = isDarkMode ? const Color(0xFFCBD5E0) : const Color(0xFF374151);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.schedule_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Working Hours',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: darkTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...workingHours.entries.map((e) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: secondaryCardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: secondaryBorderColor, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      e.key,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: secondaryTextColor,
                      ),
                    ),
                    Text(
                      e.value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF667EEA),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumBiography(String? bio, {
    required Color cardColor,
    required bool isDarkMode,
  }) {
    final Color darkTextColor = isDarkMode ? Colors.white : const Color(0xFF1F2937);
    final Color secondaryCardColor = isDarkMode ? const Color(0xFF1A202C) : const Color(0xFFF8FAFC);
    final Color secondaryBorderColor = isDarkMode ? const Color(0xFF4A5568) : const Color(0xFFE5E7EB);
    final Color secondaryTextColor = isDarkMode ? const Color(0xFFCBD5E0) : const Color(0xFF374151);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.info_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'About Doctor',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: darkTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: secondaryCardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: secondaryBorderColor, width: 1),
              ),
              child: Text(
                bio ??
                    'Doctor has vast experience and is highly recommended in their specialty. Useful for quick reference by medical staff.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: secondaryTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumSchedule(List<Map<String, String>> schedule, {
    required Color cardColor,
    required bool isDarkMode,
  }) {
    final Color darkTextColor = isDarkMode ? Colors.white : const Color(0xFF1F2937);
    final Color secondaryCardColor = isDarkMode ? const Color(0xFF1A202C) : const Color(0xFFF8FAFC);
    final Color secondaryBorderColor = isDarkMode ? const Color(0xFF4A5568) : const Color(0xFFE5E7EB);
    final Color secondaryTextColor = isDarkMode ? const Color(0xFFCBD5E0) : const Color(0xFF6B7280);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.event_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Upcoming Appointments',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: darkTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            schedule.isEmpty
                ? Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: secondaryCardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: secondaryBorderColor,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'No appointments scheduled',
                      style: TextStyle(fontSize: 16, color: secondaryTextColor),
                    ),
                  ),
                )
                : Column(
                  children:
                      schedule.map((appt) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF667EEA).withOpacity(isDarkMode ? 0.2 : 0.1),
                                const Color(0xFF764BA2).withOpacity(isDarkMode ? 0.2 : 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF667EEA).withOpacity(isDarkMode ? 0.4 : 0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF667EEA),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      appt['patient']!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: darkTextColor,
                                      ),
                                    ),
                                    Text(
                                      '${appt['date']} • ${appt['time']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumReviews(
    List<Map<String, String>> reviews,
    double rating, {
    required Color cardColor,
    required bool isDarkMode,
  }) {
    final Color darkTextColor = isDarkMode ? Colors.white : const Color(0xFF1F2937);
    final Color secondaryTextColor = isDarkMode ? const Color(0xFFCBD5E0) : const Color(0xFF374151);
    final Color borderColor = isDarkMode ? const Color(0xFF4A5568) : const Color(0xFFE5E7EB);
    
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.reviews_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Patient Reviews',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: darkTextColor,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBBF24).withOpacity(isDarkMode ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFBBF24),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: darkTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Container(
                    width: 280,
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF667EEA).withOpacity(isDarkMode ? 0.1 : 0.05),
                          const Color(0xFF764BA2).withOpacity(isDarkMode ? 0.1 : 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: borderColor,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                'https://i.pravatar.cc/150?img=${5 + index}',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review['patient']!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: darkTextColor,
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (starIndex) => Icon(
                                        Icons.star,
                                        color:
                                            starIndex < 4
                                                ? const Color(0xFFFBBF24)
                                                : const Color(0xFFE5E7EB),
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Text(
                            review['comment']!,
                            style: TextStyle(
                              fontSize: 14,
                              color: secondaryTextColor,
                              height: 1.5,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}