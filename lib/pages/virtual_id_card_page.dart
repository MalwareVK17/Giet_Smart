import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class VirtualIdCardPage extends StatefulWidget {
  const VirtualIdCardPage({Key? key}) : super(key: key);

  @override
  State<VirtualIdCardPage> createState() => _VirtualIdCardPageState();
}

class _VirtualIdCardPageState extends State<VirtualIdCardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    setState(() {
      _isFlipped = !_isFlipped;
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final primaryColor =
        isDarkMode ? const Color(0xFF9D84E3) : const Color(0xFF4A2D8B);
    final backgroundColor =
        isDarkMode ? const Color(0xFF121212) : const Color(0xFFF3F0F7);
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Virtual ID Card',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: GestureDetector(
              onTap: _flipCard,
              behavior: HitTestBehavior.opaque,
              child: TweenAnimationBuilder(
                tween: Tween<double>(
                  begin: 0,
                  end: _isFlipped ? 180 : 0,
                ),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                builder: (context, double value, child) {
                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(value * 3.14159 / 180),
                    alignment: Alignment.center,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.height * 0.6,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            primaryColor.withOpacity(0.9),
                            primaryColor.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Stack(
                          children: [
                            // Front of Card
                            if (!_isFlipped)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  image: DecorationImage(
                                    image: const AssetImage(
                                        'assets/images/virtual-idcardf.jpg'),
                                    fit: BoxFit.contain,
                                    onError: (_, __) {
                                      print('Error loading front image');
                                      return;
                                    },
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white.withOpacity(0.1),
                                        Colors.white.withOpacity(0.05),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            // Back of Card
                            if (_isFlipped)
                              Transform(
                                transform: Matrix4.identity()..rotateY(3.14159),
                                alignment: Alignment.center,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    image: DecorationImage(
                                      image: const AssetImage(
                                          'assets/images/virtual-idcardb.jpg'),
                                      fit: BoxFit.contain,
                                      onError: (_, __) {
                                        print('Error loading back image');
                                        return;
                                      },
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.white.withOpacity(0.1),
                                          Colors.white.withOpacity(0.05),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            // Tap Indicator
                            Positioned(
                              bottom: 20,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.touch_app,
                                        color: Colors.white.withOpacity(0.8),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Tap to flip',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
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
          ),
        ),
      ),
    );
  }
}
