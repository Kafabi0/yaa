// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'home_screen.dart';

// class SplashIntroScreen extends StatefulWidget {
//   const SplashIntroScreen({super.key});

//   @override
//   State<SplashIntroScreen> createState() => _SplashIntroScreenState();
// }

// class _SplashIntroScreenState extends State<SplashIntroScreen>
//     with TickerProviderStateMixin {
//   final PageController _pageController = PageController();
//   int currentIndex = 0;

//   final List<Map<String, String>> introData = [
//     {
//       "title": "Premium Healthcare\nExperience",
//       "description":
//           "Discover a new era of personalized healthcare with cutting-edge technology and premium service excellence.",
//       "image": "assets/images/inotal.png",
//       "accent": "0xFF667EEA",
//     },
//     {
//       "title": "Secure Health\nRecords Vault",
//       "description":
//           "Your medical data protected with bank-level security. Access your complete health history anytime, anywhere.",
//       "image": "assets/images/healthh.png",
//       "accent": "0xFF764BA2",
//     },
//     {
//       "title": "Effortless\nAppointments",
//       "description":
//           "Book appointments with world-class specialists instantly. Your time is precious, we make it count.",
//       "image": "assets/images/medic.png",
//       "accent": "0xFF667EEA",
//     },
//   ];

//   late AnimationController _animController;
//   late AnimationController _backgroundController;
//   late AnimationController _particleController;
  
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _backgroundAnimation;

//   @override
//   void initState() {
//     super.initState();
    
//     // Haptic feedback premium
//     HapticFeedback.lightImpact();
    
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );

//     _backgroundController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 20),
//     )..repeat();

//     _particleController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );

//     _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _animController, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
//     );

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(parent: _animController, curve: const Interval(0.2, 0.8, curve: Curves.elasticOut)),
//     );

//     _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
//       CurvedAnimation(parent: _animController, curve: const Interval(0.4, 1.0, curve: Curves.elasticOut)),
//     );

//     _backgroundAnimation = Tween<double>(begin: 0, end: 1).animate(_backgroundController);

//     _animController.forward();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _animController.dispose();
//     _backgroundController.dispose();
//     _particleController.dispose();
//     super.dispose();
//   }

//   void _nextPage() {
//     HapticFeedback.mediumImpact();
    
//     if (currentIndex == introData.length - 1) {
//       _particleController.forward().then((_) {
//         Navigator.pushReplacement(
//           context,
//           PageRouteBuilder(
//             pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
//             transitionsBuilder: (context, animation, secondaryAnimation, child) {
//               return SlideTransition(
//                 position: Tween<Offset>(
//                   begin: const Offset(1.0, 0.0),
//                   end: Offset.zero,
//                 ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
//                 child: child,
//               );
//             },
//             transitionDuration: const Duration(milliseconds: 600),
//           ),
//         );
//       });
//     } else {
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 600),
//         curve: Curves.easeOutCubic,
//       );
//     }
//   }

//   void _skipToEnd() {
//     HapticFeedback.lightImpact();
//     _pageController.animateToPage(
//       introData.length - 1,
//       duration: const Duration(milliseconds: 800),
//       curve: Curves.easeOutCubic,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
    
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFF),
//       body: Stack(
//         children: [
//           // Premium animated background
//           _buildAnimatedBackground(),
          
//           // Floating particles
//           _buildFloatingParticles(),
          
//           // Main content
//           Column(
//             children: [
//               // Skip button
//               _buildTopSection(),
              
//               // Main PageView
//               Expanded(child: _buildPageView(size)),
              
//               // Bottom navigation
//               _buildBottomSection(),
//             ],
//           ),
          
//           // Success animation overlay
//           _buildSuccessOverlay(),
//         ],
//       ),
//     );
//   }

//   Widget _buildAnimatedBackground() {
//     return AnimatedBuilder(
//       animation: _backgroundAnimation,
//       builder: (context, child) {
//         return Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               transform: GradientRotation(_backgroundAnimation.value * 0.1),
//               colors: [
//                 const Color(0xFFF8FAFF),
//                 Color(int.parse(introData[currentIndex]["accent"]!)).withOpacity(0.08),
//                 const Color(0xFFE8F2FF),
//                 const Color(0xFFF8FAFF),
//               ],
//             ),
//           ),
//           child: Stack(
//             children: List.generate(6, (index) {
//               return Positioned(
//                 top: (index * 100.0) + (_backgroundAnimation.value * 50) % 400,
//                 left: (index * 60.0) + (_backgroundAnimation.value * 30) % 300,
//                 child: Container(
//                   width: 2 + (index % 3),
//                   height: 2 + (index % 3),
//                   decoration: BoxDecoration(
//                     color: Color(int.parse(introData[currentIndex]["accent"]!)).withOpacity(0.2 + (index % 3) * 0.1),
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               );
//             }),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildFloatingParticles() {
//     return AnimatedBuilder(
//       animation: _particleController,
//       builder: (context, child) {
//         if (_particleController.value == 0) return const SizedBox();
        
//         return Stack(
//           children: List.generate(20, (index) {
//             final delay = index * 0.1;
//             final animationValue = (_particleController.value - delay).clamp(0.0, 1.0);
            
//             return Positioned(
//               left: MediaQuery.of(context).size.width * (index % 5) / 5,
//               top: MediaQuery.of(context).size.height * animationValue,
//               child: Transform.scale(
//                 scale: animationValue,
//                 child: Container(
//                   width: 4 + (index % 3) * 2,
//                   height: 4 + (index % 3) * 2,
//                   decoration: BoxDecoration(
//                     color: Color(int.parse(introData[currentIndex]["accent"]!)).withOpacity(0.6),
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ),
//             );
//           }),
//         );
//       },
//     );
//   }

//   Widget _buildTopSection() {
//     return SafeArea(
//       child: Container(
//         height: 80,
//         padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Flexible(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: Color(int.parse(introData[currentIndex]["accent"]!)).withOpacity(0.2)),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Color(int.parse(introData[currentIndex]["accent"]!)).withOpacity(0.1),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Text(
//                   'InoCare',
//                   style: GoogleFonts.montserrat(
//                     color: Color(int.parse(introData[currentIndex]["accent"]!)),
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
            
//             if (currentIndex < introData.length - 1)
//               Flexible(
//                 child: GestureDetector(
//                   onTap: _skipToEnd,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF0F4FF),
//                       borderRadius: BorderRadius.circular(25),
//                       border: Border.all(color: const Color(0xFFE0E8FF)),
//                     ),
//                     child: Text(
//                       'Skip',
//                       style: GoogleFonts.inter(
//                         color: const Color(0xFF6B7280),
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPageView(Size size) {
//     return PageView.builder(
//       controller: _pageController,
//       onPageChanged: (index) {
//         setState(() {
//           currentIndex = index;
//           _animController.reset();
//           _animController.forward();
//         });
//         HapticFeedback.selectionClick();
//       },
//       itemCount: introData.length,
//       itemBuilder: (_, index) {
//         return FadeTransition(
//           opacity: _fadeAnimation,
//           child: SlideTransition(
//             position: _slideAnimation,
//             child: ScaleTransition(
//               scale: _scaleAnimation,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                 child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     // Responsive calculations
//                     final isSmallDevice = size.height < 700;
//                     final isMediumDevice = size.height >= 700 && size.height < 850;
//                     final isLargeDevice = size.height >= 850;
                    
//                     final imageSize = isSmallDevice ? 120.0 : isMediumDevice ? 150.0 : 180.0;
//                     final glowSize = imageSize + 40;
//                     final titleFontSize = isSmallDevice ? 24.0 : isMediumDevice ? 28.0 : 32.0;
//                     final descriptionFontSize = isSmallDevice ? 14.0 : 16.0;
//                     final verticalSpacing = isSmallDevice ? 16.0 : isMediumDevice ? 24.0 : 32.0;
                    
//                     return Column(
//                       children: [
//                         SizedBox(height: isSmallDevice ? 20 : 40),
                        
//                         Flexible(
//                           flex: isSmallDevice ? 4 : 5,
//                           child: Container(
//                             width: constraints.maxWidth * 0.8,
//                             constraints: BoxConstraints(
//                               maxHeight: constraints.maxHeight * 0.5,
//                               minHeight: imageSize + 60,
//                             ),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(32),
//                               gradient: RadialGradient(
//                                 colors: [
//                                   Color(int.parse(introData[index]["accent"]!)).withOpacity(0.2),
//                                   Colors.transparent,
//                                 ],
//                               ),
//                             ),
//                             child: Center(
//                               child: Stack(
//                                 alignment: Alignment.center,
//                                 children: [
//                                   Container(
//                                     width: glowSize,
//                                     height: glowSize,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       gradient: RadialGradient(
//                                         colors: [
//                                           Color(int.parse(introData[index]["accent"]!)).withOpacity(0.15),
//                                           Colors.transparent,
//                                         ],
//                                       ),
//                                     ),
//                                   ),
                                  
//                                   // Image container
//                                   Container(
//                                     width: imageSize,
//                                     height: imageSize,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Colors.white,
//                                       border: Border.all(
//                                         color: Color(int.parse(introData[index]["accent"]!)).withOpacity(0.3),
//                                         width: 2,
//                                       ),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Color(int.parse(introData[index]["accent"]!)).withOpacity(0.2),
//                                           blurRadius: 20,
//                                           offset: const Offset(0, 8),
//                                         ),
//                                       ],
//                                     ),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(imageSize / 2),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(16.0),
//                                         child: Image.asset(
//                                           introData[index]["image"]!,
//                                           fit: BoxFit.contain,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
                        
//                         SizedBox(height: verticalSpacing),
                        
//                         // Content with responsive sizing
//                         Flexible(
//                           flex: isSmallDevice ? 3 : 2,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 introData[index]["title"]!,
//                                 textAlign: TextAlign.center,
//                                 style: GoogleFonts.inter(
//                                   fontSize: titleFontSize,
//                                   fontWeight: FontWeight.w800,
//                                   color: const Color(0xFF1F2937),
//                                   height: 1.2,
//                                   letterSpacing: -0.5,
//                                 ),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               SizedBox(height: isSmallDevice ? 12 : 24),
//                               Flexible(
//                                 child: Text(
//                                   introData[index]["description"]!,
//                                   textAlign: TextAlign.center,
//                                   style: GoogleFonts.inter(
//                                     fontSize: descriptionFontSize,
//                                     color: const Color(0xFF6B7280),
//                                     height: 1.6,
//                                     letterSpacing: 0.1,
//                                   ),
//                                   maxLines: 3,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
                        
//                         SizedBox(height: isSmallDevice ? 16 : 24),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildBottomSection() {
//     return Padding(
//       padding: const EdgeInsets.all(24.0),
//       child: Column(
//         children: [
//           // Premium dot indicator
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(
//               introData.length,
//               (index) => AnimatedContainer(
//                 duration: const Duration(milliseconds: 400),
//                 curve: Curves.easeOutCubic,
//                 margin: const EdgeInsets.symmetric(horizontal: 4),
//                 height: 4,
//                 width: currentIndex == index ? 32 : 4,
//                 decoration: BoxDecoration(
//                   color: currentIndex == index 
//                     ? Color(int.parse(introData[currentIndex]["accent"]!))
//                     : const Color(0xFFE5E7EB),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ),
//           ),
          
//           const SizedBox(height: 40),
          
//           // Premium action button
//           Container(
//             width: double.infinity,
//             height: 60,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(30),
//               gradient: LinearGradient(
//                 colors: [
//                   Color(int.parse(introData[currentIndex]["accent"]!)),
//                   Color(int.parse(introData[currentIndex]["accent"]!)).withOpacity(0.8),
//                 ],
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Color(int.parse(introData[currentIndex]["accent"]!)).withOpacity(0.4),
//                   blurRadius: 20,
//                   offset: const Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(30),
//                 onTap: _nextPage,
//                 child: Center(
//                   child: Text(
//                     currentIndex == introData.length - 1 ? "Get Started" : "Continue",
//                     style: GoogleFonts.inter(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
          
//           const SizedBox(height: 8),
//         ],
//       ),
//     );
//   }

//   Widget _buildSuccessOverlay() {
//     return AnimatedBuilder(
//       animation: _particleController,
//       builder: (context, child) {
//         if (_particleController.value == 0) return const SizedBox();
        
//         return Container(
//           color: Colors.white.withOpacity(_particleController.value * 0.95),
//           child: Center(
//             child: Transform.scale(
//               scale: _particleController.value,
//               child: Container(
//                 padding: const EdgeInsets.all(32),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(24),
//                   border: Border.all(color: Color(int.parse(introData[currentIndex]["accent"]!)).withOpacity(0.2)),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Color(int.parse(introData[currentIndex]["accent"]!)).withOpacity(0.1),
//                       blurRadius: 20,
//                       offset: const Offset(0, 10),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       Icons.check_circle_outline,
//                       size: 64,
//                       color: Color(int.parse(introData[currentIndex]["accent"]!)),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Welcome to InoCare',
//                       style: GoogleFonts.inter(
//                         fontSize: 24,
//                         fontWeight: FontWeight.w600,
//                         color: const Color(0xFF1F2937),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }