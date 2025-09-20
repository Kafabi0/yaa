import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';

class SplashOnboarding extends StatelessWidget {
  final VoidCallback onCompleted;

  const SplashOnboarding({super.key, required this.onCompleted});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final pages = [
      const PageData(
        icon: Icons.local_hospital,
        title: "Selamat datang di InoCare",
        bgColor: Colors.orange,
        textColor: Colors.white,
      ),
      const PageData(
        icon: Icons.health_and_safety,
        title: "Akses cepat layanan kesehatan",
        bgColor: Colors.white,
        textColor: Colors.orange,
      ),
      const PageData(
        icon: Icons.people,
        title: "Dokter & Rumah Sakit terpercaya",
        bgColor: Colors.orange,
        textColor: Colors.white,
      ),
    ];

    return Scaffold(
      body: ConcentricPageView(
        colors: pages.map((p) => p.bgColor).toList(),
        radius: screenWidth * 0.1,
        nextButtonBuilder: (context) => Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Icon(Icons.navigate_next, size: screenWidth * 0.08),
        ),
        itemCount: pages.length,
        itemBuilder: (index) {
          final page = pages[index];
          final isLastPage = index == pages.length - 1;

          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Page(page: page),
                const SizedBox(height: 40),
                if (isLastPage)
                  ElevatedButton(
                    onPressed: onCompleted,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: page.textColor,
                      foregroundColor: page.bgColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Mulai",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PageData {
  final String title;
  final IconData icon;
  final Color bgColor;
  final Color textColor;

  const PageData({
    required this.title,
    required this.icon,
    required this.bgColor,
    required this.textColor,
  });
}

class _Page extends StatelessWidget {
  final PageData page;

  const _Page({required this.page});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: page.textColor,
          ),
          child: Icon(page.icon, size: screenHeight * 0.1, color: page.bgColor),
        ),
        const SizedBox(height: 20),
        Text(
          page.title,
          style: TextStyle(
            color: page.textColor,
            fontSize: screenHeight * 0.035,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
