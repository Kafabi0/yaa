import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Latar belakang transparan untuk memberi ruang bagi navigasi
        Container(
          height: 80,
          color: Colors.transparent,
        ),
        // Navigasi melayang dengan bayangan
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 5),
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

  Widget _buildBarItem(IconData icon, int index, bool isDark) {
    return Icon(
      icon,
      size: 24,
      color: currentIndex == index
          ? Colors.white
          : Colors.white.withOpacity(0.7),
    );
  }
}