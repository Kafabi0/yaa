import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';

class SplashOnboarding extends StatelessWidget {
  final VoidCallback onCompleted;

  const SplashOnboarding({super.key, required this.onCompleted});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final pages = [
      PageData(
        icon: Image.asset("assets/dgl.png", width: 120, height: 120),
        title: "Selamat datang di \nDigital Hospital", 
        bgColor: Colors.orange,
        textColor: Colors.white,
        useCustomFont: true,
      ),

      PageData(
        icon: const Icon(Icons.health_and_safety, size: 80,color: Colors.white),
        title: "Akses cepat layanan kesehatan",
        bgColor: Colors.white,
        textColor: Colors.orange,
      ),
      PageData(
        icon: const Icon(Icons.people, size: 80,color:Colors.amber),
        title: "Dokter & Rumah Sakit \npilihan anda",
        bgColor: Colors.orange,
        textColor: Colors.white,
      ),
    ];

    return Scaffold(
      body: ConcentricPageView(
        colors: pages.map((p) => p.bgColor).toList(),
        radius: screenWidth * 0.1,
        nextButtonBuilder:
            (context) => Padding(
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
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("Mulai", style: TextStyle(fontSize: 18)),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 🔹 PageData sekarang pakai `Widget` biar lebih fleksibel
class PageData {
  final String title;
  final Widget icon;
  final Color bgColor;
  final Color textColor;
  final bool useCustomFont;

  const PageData({
    required this.title,
    required this.icon,
    required this.bgColor,
    required this.textColor,
    this.useCustomFont = false,
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
          child: page.icon,
        ),
        const SizedBox(height: 20),

        if (page.useCustomFont && page.title.contains("Digital Hospital"))
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: page.title.replaceAll("Digital Hospital", ""),
                  style: TextStyle(
                    color: page.textColor,
                    fontSize: screenHeight * 0.035,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: "Digital Hospital",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenHeight * 0.080,
                    fontWeight: FontWeight.bold,
                    fontFamily: "KolkerBrush", 
                  ),
                ),
              ],
            ),
          )
        else
          Text(
            page.title,
            style: TextStyle(
              color: page.textColor,
              fontSize: screenHeight * 0.035,
              fontWeight: FontWeight.bold,
              fontFamily: page.useCustomFont ? "Poppins" : null,
            ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
