import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isLoggedIn;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isLoggedIn = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CurvedNavigationBar(
      index: currentIndex,
      onTap: (index) {
        // Kalau belum login dan klik selain Home/Login → kasih warning
        if (!isLoggedIn && index > 1) {
          _showLoginPrompt(context, index);
          return;
        }
        onTap(index);
      },
      color: isDark ? const Color(0xFF1E1E2C) : Colors.orange,
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: isDark ? const Color(0xFF1E1E2C) : Colors.orange,
      height: 60,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      items: _getNavigationItems(isDark),
    );
  }

  List<Widget> _getNavigationItems(bool isDark) {
    if (!isLoggedIn) {
      return [
        Icon(FontAwesomeIcons.house, color: Colors.white), // 0 = Home
        Icon(FontAwesomeIcons.rightToBracket, color: Colors.white), // 1 = Login
        Icon(FontAwesomeIcons.solidHeart, color: Colors.white.withOpacity(0.5)), // 2
        Icon(FontAwesomeIcons.solidBell, color: Colors.white.withOpacity(0.5)),  // 3
        Icon(FontAwesomeIcons.user, color: Colors.white.withOpacity(0.5)),       // 4
      ];
    }

    return [
      Icon(FontAwesomeIcons.house, color: Colors.white),           // 0 = Home
      Icon(FontAwesomeIcons.magnifyingGlass, color: Colors.white), // 1 = Search
      Icon(FontAwesomeIcons.solidHeart, color: Colors.white),      // 2 = Rekam Medis
      Icon(FontAwesomeIcons.solidBell, color: Colors.white),       // 3 = Notifikasi
      Icon(FontAwesomeIcons.user, color: Colors.white),            // 4 = Profil
    ];
  }

  void _showLoginPrompt(BuildContext context, int index) {
    String feature = _getFeatureName(index);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login diperlukan untuk mengakses $feature'),
        action: SnackBarAction(
          label: 'Login',
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
        ),
      ),
    );
  }

  String _getFeatureName(int index) {
    switch (index) {
      case 2:
        return 'Rekam Medis';
      case 3:
        return 'Notifikasi';
      case 4:
        return 'Profil';
      default:
        return 'fitur ini';
    }
  }


  void _navigateToLogin(BuildContext context) {
    Navigator.pushNamed(context, '/login');
    // atau jika menggunakan direct navigation:
    // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}

// ALTERNATIF: Custom Bottom Navigation yang completely different untuk public user
class CustomBottomNavigationBarAlternative extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isLoggedIn;

  const CustomBottomNavigationBarAlternative({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isLoggedIn = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!isLoggedIn) {
      // Simple bottom navigation untuk public user
      return _buildPublicBottomNav(isDark);
    }

    // Full curved navigation untuk logged in user
    return _buildMemberBottomNav(isDark);
  }

  Widget _buildPublicBottomNav(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 70,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2C) : Colors.orange,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSimpleNavItem(
            icon: FontAwesomeIcons.house,
            label: 'Beranda',
            isActive: currentIndex == 0,
            isDark: isDark,
            onTap: () => onTap(0),
          ),
          _buildSimpleNavItem(
            icon: FontAwesomeIcons.rightToBracket,
            label: 'Login',
            isActive: false,
            isDark: isDark,
            onTap: () => _navigateToLogin(),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberBottomNav(bool isDark) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 80,
          color: Colors.transparent,
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CurvedNavigationBar(
              index: currentIndex,
              onTap: onTap,
              color: isDark ? const Color(0xFF1E1E2C) : const Color.fromARGB(255, 255, 102, 0),
              backgroundColor: Colors.transparent,
              buttonBackgroundColor: isDark ? const Color(0xFF1E1E2C) : const Color.fromARGB(255, 255, 119, 0),
              height: 60,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 300),
              items: [
                _buildBarItem(FontAwesomeIcons.house, 0, isDark),
                _buildBarItem(FontAwesomeIcons.magnifyingGlass, 1, isDark),
                _buildBarItem(FontAwesomeIcons.solidHeart, 2, isDark),
                _buildBarItem(FontAwesomeIcons.solidBell, 3, isDark),
                _buildBarItem(FontAwesomeIcons.user, 4, isDark),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: Colors.white,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarItem(IconData icon, int index, bool isDark) {
    return Icon(
      icon,
      size: 24,
      color: currentIndex == index
          ? Colors.white
          : Colors.white.withOpacity(0.7),
    );
  }

  void _navigateToLogin() {
    // Implement navigation to login
  }
}