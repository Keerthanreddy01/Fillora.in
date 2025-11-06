import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

class HeroIntroScreen extends StatelessWidget {
  const HeroIntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive font sizing based on screen size
    final responsiveFontSize = (screenWidth * 0.12).clamp(32.0, 48.0);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0C0A),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF0D0C0A),
          // Soft radial glow at bottom center
          gradient: RadialGradient(
            center: Alignment(0, 1.0),
            radius: 1.2,
            colors: [
              Color(0x4DFF8A00), // Orange with 30% opacity
              Color(0x4DFFC876), // Golden with 30% opacity
              Color(0x00FFC876), // Fade to transparent
              Color(0x00000000), // Complete transparent
            ],
            stops: [0.0, 0.4, 0.8, 1.0],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Stack(
                    children: [
                      // Main Content Container
                      SizedBox(
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        child: Stack(
                          children: [
                            // Curved Arrow flowing from text to button
                            Positioned(
                              left: 32,
                              top: constraints.maxHeight * 0.48,
                              child: CustomPaint(
                                size: Size(
                                  (constraints.maxWidth * 0.5).clamp(150.0, 300.0),
                                  (constraints.maxHeight * 0.28).clamp(100.0, 200.0),
                                ),
                                painter: FlowingArrowPainter(),
                              ),
                            ),

                            // Main Text Block positioned ~22% from top, slightly left
                            Positioned(
                              left: 32,
                              top: constraints.maxHeight * 0.22,
                              right: 32,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // "Fastest" text
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Fastest',
                                      style: GoogleFonts.poppins(
                                        fontSize: responsiveFontSize,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: -1.2,
                                        height: 0.95,
                                      ),
                                    ),
                                  ),
                                  // "Easiest" text (highlighted)
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Easiest',
                                      style: GoogleFonts.poppins(
                                        fontSize: responsiveFontSize,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFFFC876), // Golden accent
                                        letterSpacing: -1.2,
                                        height: 0.95,
                                      ),
                                    ),
                                  ),
                                  // "Form Filling Experience" text
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Form Filling',
                                      style: GoogleFonts.poppins(
                                        fontSize: responsiveFontSize,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: -1.2,
                                        height: 0.95,
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Experience',
                                      style: GoogleFonts.poppins(
                                        fontSize: responsiveFontSize,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: -1.2,
                                        height: 0.95,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Get Started Button
                            Positioned(
                              bottom: 100,
                              left: 32,
                              right: 32,
                              child: WarmButton(
                                text: 'Get Started',
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) =>
                                          const MainNavigationScreen(),
                                      transitionDuration: const Duration(milliseconds: 800),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        const begin = Offset(0.0, 1.0);
                                        const end = Offset.zero;
                                        const curve = Curves.easeInOutCubic;

                                        var tween = Tween(begin: begin, end: end).chain(
                                          CurveTween(curve: curve),
                                        );

                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Bottom swipe indicator
                            Positioned(
                              bottom: 40,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  width: 36,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(2.5),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class FlowingArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFC876).withOpacity(0.6) // Golden color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    
    // Start point (near the text)
    final startX = size.width * 0.05;
    final startY = size.height * 0.08;
    
    // Control points for elegant S-curve flowing downward
    final controlX1 = size.width * 0.25;
    final controlY1 = size.height * 0.25;
    final controlX2 = size.width * 0.4;
    final controlY2 = size.height * 0.55;
    
    // End point (pointing down toward button area)
    final endX = size.width * 0.45;
    final endY = size.height * 0.85;

    // Create smooth flowing curve
    path.moveTo(startX, startY);
    path.cubicTo(controlX1, controlY1, controlX2, controlY2, endX, endY);
    
    // Draw the curved line
    canvas.drawPath(path, paint);
    
    // Draw larger, more visible arrowhead
    final arrowSize = 10.0;
    final arrowPath = Path();
    
    // Calculate arrow direction (pointing downward-right)
    final arrowX1 = endX - arrowSize * 0.5;
    final arrowY1 = endY - arrowSize * 0.9;
    final arrowX2 = endX + arrowSize * 0.5;
    final arrowY2 = endY - arrowSize * 0.9;
    
    arrowPath.moveTo(endX, endY);
    arrowPath.lineTo(arrowX1, arrowY1);
    arrowPath.moveTo(endX, endY);
    arrowPath.lineTo(arrowX2, arrowY2);
    
    canvas.drawPath(arrowPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class WarmButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;

  const WarmButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 56,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFFF8A00), // Warm orange
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF8A00).withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0D0C0A), // Black text
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}