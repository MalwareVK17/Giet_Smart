import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'intro_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    Timer(
      const Duration(seconds: 3),
      () {
        _controller.reverse().then((_) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const IntroPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        });
      },
    );
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
          // Animated background gradient
          Positioned.fill(
            child: CustomPaint(
              painter: GradientBackgroundPainter(
                colors: const [
                  Color(0xFF4A2D8B),
                  Color(0xFF6B45B2),
                  Color(0xFF8860D0),
                ],
              ),
            ),
          ),

          // Decorative patterns
          Positioned.fill(
            child: CustomPaint(
              painter: PatternPainter(),
            ),
          ),

          // Animated particles
          Positioned.fill(
            child: CustomPaint(
              painter: ParticlesPainter(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),

          // Main content
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4A2D8B).withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/gietlogo2.png',
                            width: 298,
                            height: 208,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'GIET SMART',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A2D8B),
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF4A2D8B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Gradient background painter
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

// Pattern painter for decorative elements
class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw hexagonal pattern
    final hexSize = size.width / 10;
    for (double i = 0; i < size.width; i += hexSize * 1.5) {
      for (double j = 0; j < size.height; j += hexSize * 1.7) {
        final path = Path();
        for (var k = 0; k < 6; k++) {
          final angle = (k * 60) * 3.14159 / 180;
          final x = i + hexSize * cos(angle);
          final y = j + hexSize * sin(angle);
          if (k == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Particles painter for animated dots
class ParticlesPainter extends CustomPainter {
  final Color color;

  ParticlesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw scattered dots
    final random = DateTime.now().millisecondsSinceEpoch;
    for (var i = 0; i < 50; i++) {
      final x = (random + i * 7919) % size.width;
      final y = (random + i * 6037) % size.height;
      final radius = ((random + i * 3671) % 4) + 1.0;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
