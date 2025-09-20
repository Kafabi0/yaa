import 'package:flutter/material.dart';
import 'package:inocare/screens/home_page_member.dart';
import 'package:inocare/screens/login.dart';
import 'package:inocare/services/user_prefs.dart';
import 'package:inocare/screens/home_screen.dart';


class SettingsScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const SettingsScreen({
    super.key,
    required this.onLogout, // Tambahkan parameter ini
  });

  Future<void> _logout(BuildContext context) async {
    await UserPrefs.clearUser();
    onLogout(); // Panggil fungsi yang disuntikkan dari MainPage
    
    // Navigasi ke halaman login dan hapus semua rute sebelumnya
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HealthAppHomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // ... (kode yang sudah ada)

    return Scaffold(
      body: Container(
        // ... (kode yang sudah ada)
        child: CustomScrollView(
          slivers: [
            // ... (kode SliverAppBar)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => _logout(context),
                    // ... (kode style ElevatedButton)
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}