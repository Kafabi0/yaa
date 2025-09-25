import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inocare/services/user_prefs.dart';
import 'home_screen.dart';
class SettingsScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const SettingsScreen({super.key, required this.onLogout});

  Future<void> _logout(BuildContext context) async {
    await UserPrefs.clearAllData();
    onLogout();

    // if (context.mounted) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Logout berhasil')),
    //   );
    // }

    // ✅ Kembali ke halaman awal (SplashOnboarding)
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => HealthAppHomePage(
          ),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => _logout(context),
          icon: const Icon(Icons.logout),
          label: const Text(
            'Logout',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  // Widget _buildBottomNavigation(BuildContext context) {
  //   final isDark = Theme.of(context).brightness == Brightness.dark;

  //   return CurvedNavigationBar(
  //     index: 4, // Settings tab
  //     onTap: (index) {
  //       if (index != 4) {
  //         Navigator.pop(context, index); // balik ke MainPage dengan index tertentu
  //       }
  //     },
  //     color: isDark ? const Color(0xFF1E1E2C) : Colors.orange,
  //     backgroundColor: Colors.transparent,
  //     buttonBackgroundColor: isDark ? const Color(0xFF1E1E2C) : Colors.orange,
  //     height: 60,
  //     animationCurve: Curves.easeInOut,
  //     animationDuration: const Duration(milliseconds: 300),
  //     items: const [
  //       Icon(FontAwesomeIcons.house, color: Colors.white, size: 24),
  //       Icon(FontAwesomeIcons.calendarDay, color: Colors.white, size: 24),
  //       Icon(FontAwesomeIcons.solidHeart, color: Colors.white, size: 24),
  //       Icon(FontAwesomeIcons.solidCommentDots, color: Colors.white, size: 24),
  //       Icon(FontAwesomeIcons.user, color: Colors.white, size: 24),
  //     ],
  //   );
  // }
}
