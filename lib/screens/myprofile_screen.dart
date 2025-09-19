import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

// Premium Medical Photo Viewer
class MyProfileScreen extends StatelessWidget {
  final String imagePath;
  final String name;
  final String position;

  const MyProfileScreen({
    super.key,
    required this.imagePath,
    required this.name,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBackgroundColor = isDark ? Colors.black : const Color(0xFF0D1421);
    final containerBackground = isDark ? const Color(0xFF1A1A2A) : const Color(0xFF1A2332);
    final containerBorder = isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.2);
    final cardColor = isDark ? const Color(0xFF24243A) : Colors.white.withOpacity(0.1);

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Premium gradient background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          Colors.black,
                          const Color(0xFF0D1421),
                          Colors.black,
                        ]
                      : [
                          const Color(0xFF0D1421),
                          const Color(0xFF1A2332),
                          const Color(0xFF0D1421),
                        ],
                ),
              ),
            ),
          ),

          // Blurred background image
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.8),
                      BlendMode.darken,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Premium AppBar
          SafeArea(
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: containerBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: containerBorder,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: isDark ? Colors.white70 : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.inter(
                            color: isDark ? Colors.white70 : Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          position,
                          style: GoogleFonts.inter(
                            color: Colors.white54,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showPhotoOptions(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: containerBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: containerBorder,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.more_horiz,
                        color: isDark ? Colors.white70 : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Premium profile photo with medical theme
          Center(
            child: Hero(
              tag: 'profile_photo',
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF2196F3).withOpacity(isDark ? 0.1 : 0.3),
                      const Color(0xFF1976D2).withOpacity(isDark ? 0.1 : 0.3),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2196F3).withOpacity(isDark ? 0.1 : 0.3),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.6 : 0.4),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(isDark ? 0.1 : 0.3),
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 120,
                    backgroundColor: const Color(0xFF1E3A8A).withOpacity(isDark ? 0.8 : 1.0),
                    child: ClipOval(
                      child: Image.asset(
                        imagePath,
                        width: 240,
                        height: 240,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 240,
                            height: 240,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E3A8A).withOpacity(isDark ? 0.8 : 1.0),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.medical_services,
                              size: 120,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Medical badge indicator
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5 + 60,
            left: MediaQuery.of(context).size.width * 0.5 + 60,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                shape: BoxShape.circle,
                border: Border.all(color: isDark ? Colors.black : Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.medical_services,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          // Professional info section
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: containerBorder,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    name,
                    style: GoogleFonts.inter(
                      color: isDark ? Colors.white : Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3).withOpacity(isDark ? 0.1 : 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF2196F3).withOpacity(isDark ? 0.3 : 0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      position,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF64B5F6),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPhotoOptions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E2E) : const Color(0xFF1A2332),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(isDark ? 0.05 : 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 6,
              margin: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            _buildOptionTile(Icons.download_rounded, 'Save to Gallery', context, isDark),
            _buildOptionTile(Icons.share_rounded, 'Share Photo', context, isDark),
            _buildOptionTile(Icons.edit_rounded, 'Update Photo', context, isDark),
            _buildOptionTile(Icons.security_rounded, 'Privacy Settings', context, isDark),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(IconData icon, String title, BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.05),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3).withOpacity(isDark ? 0.1 : 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF64B5F6), size: 22),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            color: isDark ? Colors.white : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.white54,
          size: 16,
        ),
        onTap: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title selected'),
              backgroundColor: const Color(0xFF2196F3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Premium Medical Profile Screen
class MedicalProfileScreen extends StatelessWidget {
  const MedicalProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final scaffoldBackgroundColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final secondaryTextColor = isDark ? Colors.grey.shade400 : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Premium app bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: cardColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Medical Profile',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: isDark
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF1E1E2E),
                            Color(0xFF2C2C40),
                          ],
                        )
                      : const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            Color(0xFFF1F5F9),
                          ],
                        ),
                ),
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Premium profile header
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(isDark ? 0.05 : 0.08),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.1 : 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) =>
                                    const MyProfileScreen(
                                  imagePath:'assets/dokter/doctor55.png',
                                  name: 'Dokter',
                                  position: 'Senior Medical Officer',
                                ),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: ScaleTransition(
                                      scale: Tween<double>(
                                        begin: 0.9,
                                        end: 1.0,
                                      ).animate(CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutCubic,
                                      )),
                                      child: child,
                                    ),
                                  );
                                },
                                transitionDuration: const Duration(milliseconds: 400),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF2196F3).withOpacity(isDark ? 0.05 : 0.1),
                                      const Color(0xFF1976D2).withOpacity(isDark ? 0.05 : 0.1),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF2196F3).withOpacity(isDark ? 0.1 : 0.2),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(6),
                                child: Hero(
                                  tag: 'profile_photo',
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF2196F3).withOpacity(isDark ? 0.2 : 0.3),
                                        width: 3,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundColor: const Color(0xFF1E3A8A).withOpacity(isDark ? 0.8 : 1.0),
                                      child: ClipOval(
                                        child: Image.asset(
                                          'assets/dokter/doctor55.png',
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.medical_services,
                                              size: 60,
                                              color: Colors.white,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4CAF50),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: cardColor, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF4CAF50).withOpacity(0.5),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.medical_services,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Dokter ',
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2196F3).withOpacity(isDark ? 0.1 : 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF2196F3).withOpacity(isDark ? 0.2 : 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'Senior Medical Officer • FI 04',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: const Color(0xFF1976D2),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildQuickStat('Years Experience', '8+', isDark),
                            Container(
                              width: 1,
                              height: 40,
                              color: isDark ? Colors.grey.shade700 : const Color(0xFFE2E8F0),
                            ),
                            _buildQuickStat('Specialization', 'Internal Medicine', isDark),
                            Container(
                              width: 1,
                              height: 40,
                              color: isDark ? Colors.grey.shade700 : const Color(0xFFE2E8F0),
                            ),
                            _buildQuickStat('Status', 'Active', isDark),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Professional Information Section
                  _buildSection(
                    'Professional Information',
                    [
                      _buildDetailCard(
                        context,
                        'Medical License',
                        'Active & Verified',
                        icon: Icons.verified_user,
                        iconColor: const Color(0xFF4CAF50),
                        valueStyle: GoogleFonts.inter(
                          fontSize: 16,
                          color: const Color(0xFF4CAF50),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      _buildDetailCard(
                        context,
                        'Department',
                        'Internal Medicine',
                        icon: Icons.local_hospital,
                        iconColor: const Color(0xFF2196F3),
                      ),
                      _buildDetailCard(
                        context,
                        'Employee ID',
                        'MED-2024-0847',
                        icon: Icons.badge,
                        iconColor: const Color(0xFF9C27B0),
                      ),
                      _buildDetailCard(
                        context,
                        'Medical Registration',
                        'MMC: 45789',
                        icon: Icons.assignment_ind,
                        iconColor: const Color(0xFF795548),
                        isLink: true,
                      ),
                    ],
                    isDark,
                  ),

                  const SizedBox(height: 24),

                  // Personal Information Section
                  _buildSection(
                    'Personal Information',
                    [
                      _buildDetailCard(
                        context,
                        'Full Name',
                        ' Dokter',
                        icon: Icons.person,
                        iconColor: const Color(0xFF607D8B),
                      ),
                      _buildDetailCard(
                        context,
                        'NRIC Number',
                        '930208-03-9118',
                        icon: Icons.credit_card,
                        iconColor: const Color(0xFFFF5722),
                      ),
                      _buildDetailCard(
                        context,
                        'Nationality',
                        'Indonesian',
                        icon: Icons.flag,
                        iconColor: const Color(0xFFE91E63),
                      ),
                      _buildDetailCard(
                        context,
                        'Gender',
                        'Female',
                        icon: Icons.female,
                        iconColor: const Color(0xFFE91E63),
                      ),
                      _buildDetailCard(
                        context,
                        'Date of Birth',
                        '25 January 2005',
                        icon: Icons.cake,
                        iconColor: const Color(0xFFFF9800),
                      ),
                    ],
                    isDark,
                  ),

                  const SizedBox(height: 24),

                  // Contact Information Section
                  _buildSection(
                    'Contact Information',
                    [
                      _buildDetailCard(
                        context,
                        'Hospital Address',
                        'Hospital Kuala Lumpur\nJalan Pahang, 50586 Kuala Lumpur',
                        icon: Icons.local_hospital,
                        iconColor: const Color(0xFF2196F3),
                        isLink: true,
                      ),
                      _buildDetailCard(
                        context,
                        'Emergency Contact',
                        '+603-2615-5555',
                        icon: Icons.emergency,
                        iconColor: const Color(0xFFD32F2F),
                        isLink: true,
                      ),
                      _buildDetailCard(
                        context,
                        'Email Address',
                        'dokter@hkl.gov.my',
                        icon: Icons.email,
                        iconColor: const Color(0xFF1976D2),
                        isLink: true,
                      ),
                    ],
                    isDark,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, bool isDark) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2196F3),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: isDark ? Colors.grey.shade400 : const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children, bool isDark) {
    final cardColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.1 : 0.04),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildDetailCard(
    BuildContext context,
    String label,
    String value, {
    IconData? icon,
    Color? iconColor,
    bool isLink = false,
    TextStyle? valueStyle,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? Colors.grey.shade800 : const Color(0xFFE2E8F0);
    final labelColor = isDark ? Colors.grey.shade400 : const Color(0xFF64748B);
    final valueColor = isDark ? Colors.white : const Color(0xFF1E293B);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          if (icon != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (iconColor ?? const Color(0xFF2196F3)).withOpacity(isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor ?? const Color(0xFF2196F3),
                size: 24,
              ),
            ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: labelColor,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: isLink ? () {} : null,
                  child: Text(
                    value,
                    style: valueStyle ??
                        GoogleFonts.inter(
                          fontSize: 16,
                          color: isLink
                              ? const Color(0xFF2196F3)
                              : valueColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                  ),
                ),
              ],
            ),
          ),
          if (isLink)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withOpacity(isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFF2196F3),
                size: 16,
              ),
            ),
        ],
      ),
    );
  }
}