import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C0A),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          OnboardingScreen1(onNext: _nextPage),
          OnboardingScreen2(onFinish: _navigateToHome),
        ],
      ),
    );
  }
}

class OnboardingScreen1 extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingScreen1({Key? key, required this.onNext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF0D0C0A),
        // Radial glow at bottom-left for variation
        gradient: RadialGradient(
          center: Alignment(-0.3, 0.9),
          radius: 1.3,
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
        child: Stack(
          children: [
            // Main Text Content with overflow protection
            Positioned(
              left: 32,
              top: screenHeight * 0.25,
              right: 32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with responsive sizing and overflow protection
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Upload Documents',
                      style: GoogleFonts.poppins(
                        fontSize: (screenWidth * 0.11).clamp(32.0, 44.0),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -1.0,
                        height: 1.0,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'in Seconds',
                      style: GoogleFonts.poppins(
                        fontSize: (screenWidth * 0.11).clamp(32.0, 44.0),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFFFC876), // Golden accent
                        letterSpacing: -1.0,
                        height: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Subtitle with overflow protection
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: screenWidth - 64,
                    ),
                    child: Text(
                      'Scan IDs, certificates, or PDFs and Fillora will extract details for you.',
                      style: GoogleFonts.poppins(
                        fontSize: (screenWidth * 0.045).clamp(16.0, 18.0),
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.8),
                        letterSpacing: 0.2,
                        height: 1.5,
                      ),
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),

            // Next Button
            Positioned(
              bottom: 100,
              left: 32,
              right: 32,
              child: WarmButton(
                text: 'Next',
                onPressed: onNext,
              ),
            ),

            // Bottom swipe indicator
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Page indicator
                  Container(
                    width: 36,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC876),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 12,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen2 extends StatelessWidget {
  final VoidCallback onFinish;

  const OnboardingScreen2({Key? key, required this.onFinish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF0D0C0A),
        // Radial glow at top-right for variation
        gradient: RadialGradient(
          center: Alignment(0.3, -0.9),
          radius: 1.3,
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
        child: Stack(
          children: [
            // Main Text Content with overflow protection
            Positioned(
              left: 32,
              top: screenHeight * 0.25,
              right: 32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with responsive sizing and overflow protection
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Smart Form',
                      style: GoogleFonts.poppins(
                        fontSize: (screenWidth * 0.11).clamp(32.0, 44.0),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -1.0,
                        height: 1.0,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Auto-Fill',
                      style: GoogleFonts.poppins(
                        fontSize: (screenWidth * 0.11).clamp(32.0, 44.0),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFFFC876), // Golden accent
                        letterSpacing: -1.0,
                        height: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Subtitle with overflow protection
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: screenWidth - 64,
                    ),
                    child: Text(
                      'AI-powered intelligence fills out forms instantly using your uploaded documents.',
                      style: GoogleFonts.poppins(
                        fontSize: (screenWidth * 0.045).clamp(16.0, 18.0),
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.8),
                        letterSpacing: 0.2,
                        height: 1.5,
                      ),
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),

            // Finish Button
            Positioned(
              bottom: 100,
              left: 32,
              right: 32,
              child: WarmButton(
                text: 'Get Started',
                onPressed: onFinish,
              ),
            ),

            // Bottom swipe indicator
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Page indicator
                  Container(
                    width: 12,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 36,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC876),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
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