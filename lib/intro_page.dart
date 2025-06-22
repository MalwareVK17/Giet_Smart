//import 'il.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'user_login_page.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  final List<String> imageList = [
    'assets/images/gietacc.jpg',
    'assets/images/gietm.jpg',
    'assets/images/gietMca.jpg',
    'assets/images/gietdc.png',
    'assets/images/gietm2.jpg',
  ];
  int _currentIndex = 0;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F0F7),
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: CustomPaint(
              painter: GradientBackgroundPainter(
                colors: [
                  const Color(0xFF4A2D8B).withOpacity(0.1),
                  const Color(0xFF6B45B2).withOpacity(0.05),
                  Colors.white,
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4A2D8B).withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Expanded(
                          child: CarouselSlider(
                            options: CarouselOptions(
                              height: MediaQuery.of(context).size.height * 0.65,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 4),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 1000),
                              autoPlayCurve: Curves.easeInOutCubic,
                              enlargeCenterPage: true,
                              viewportFraction: 0.9,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                            ),
                            items: imageList.map((imagePath) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF4A2D8B)
                                              .withOpacity(0.2),
                                          blurRadius: 15,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.asset(
                                        imagePath,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          print(
                                              'Error loading image: $imagePath');
                                          print('Error details: $error');
                                          return Container(
                                            color: Colors.grey[200],
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.error_outline,
                                                  size: 50,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Failed to load: ${imagePath.split('/').last}',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: imageList.asMap().entries.map((entry) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: _currentIndex == entry.key ? 20.0 : 8.0,
                              height: 8.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: const Color(0xFF4A2D8B).withOpacity(
                                  _currentIndex == entry.key ? 0.9 : 0.4,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: const Text(
                              'GIET Engineering College',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4A2D8B),
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const UserLoginPage(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4A2D8B),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                ),
                                child: const Text(
                                  'Get Started',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GradientBackgroundPainter extends CustomPainter {
  final List<Color> colors;

  GradientBackgroundPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
