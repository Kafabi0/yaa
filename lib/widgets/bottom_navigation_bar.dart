import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: isDark ? const Color(0xFF1E1E2C) : Colors.white,
      selectedItemColor: const Color(0xFF0D6EFD),
      unselectedItemColor: isDark ? Colors.grey[400] : Colors.grey[600],
      items: [
        _buildBarItem(FontAwesomeIcons.house, 'Home', 0, isDark),
        _buildBarItem(
          FontAwesomeIcons.notesMedical,
          'Health Records',
          1,
          isDark,
        ),
        _buildBarItem(FontAwesomeIcons.solidBell, 'Notifications', 2, isDark),
        _buildBarItem(FontAwesomeIcons.gear, 'Settings', 3, isDark),
      ],
    );
  }

  BottomNavigationBarItem _buildBarItem(
    IconData icon,
    String label,
    int index,
    bool isDark,
  ) {
    return BottomNavigationBarItem(
      label: label,
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            height: 4,
            width: currentIndex == index ? 24 : 0,
            decoration: BoxDecoration(
              color: const Color(0xFF0D6EFD),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 4),
          FaIcon(
            icon,
            size: 20,
            color:
                currentIndex == index
                    ? const Color(0xFF0D6EFD)
                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
