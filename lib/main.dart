import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/language_provider.dart';
import 'views/hero_intro_screen.dart';
import 'views/home_screen.dart';
import 'views/profile_screen.dart';
import 'views/document_scanner_screen.dart';
import 'views/ai_assistant_screen.dart';
import 'views/document_upload_screen.dart';
import 'views/services_screen.dart';
import 'views/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0F1419),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: const FilloraApp(),
    ),
  );
}

class FilloraApp extends StatelessWidget {
  const FilloraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          title: 'Fillora.in - AI Form Assistant',
          debugShowCheckedModeBanner: false,
          
          // Localization support
          locale: languageProvider.currentLocale,
          supportedLocales: const [
            Locale('en', 'US'), // English
            Locale('hi', 'IN'), // Hindi
            Locale('te', 'IN'), // Telugu
            Locale('fr', 'FR'), // French
            Locale('es', 'ES'), // Spanish
            Locale('de', 'DE'), // German
            Locale('pt', 'PT'), // Portuguese
            Locale('ar', 'SA'), // Arabic
            Locale('zh', 'CN'), // Chinese
            Locale('ja', 'JP'), // Japanese
          ],
          
          initialRoute: '/',
          onGenerateRoute: (settings) {
            Widget page;
            switch (settings.name) {
              case '/':
                page = const HeroIntroScreen();
                break;
              case '/home':
                page = const MainNavigationScreen();
                break;
              case '/profile':
                page = const ProfileScreen();
                break;
              case '/document-scanner':
                page = const DocumentScannerScreen();
                break;
              case '/ai-assistant':
                page = const AIAssistantScreen();
                break;
              case '/upload':
                page = const DocumentUploadScreen();
                break;
              case '/progress':
                page = const ServicesScreen();
                break;
              case '/settings':
                page = const SettingsScreen();
                break;
              default:
                page = const HeroIntroScreen();
            }

            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (context, animation, secondaryAnimation) => page,
              transitionDuration: const Duration(milliseconds: 400),
              reverseTransitionDuration: const Duration(milliseconds: 300),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
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
            );
          },
          theme: _buildTheme(languageProvider),
        );
      },
    );
  }
  
  ThemeData _buildTheme(LanguageProvider languageProvider) {
    // Get the appropriate font family for the current language
    final fontFamily = languageProvider.getFontFamily();
    final textScaleFactor = languageProvider.getTextScaleFactor();
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color Scheme - Dark navy and black with electric blue
      colorScheme: const ColorScheme.dark(
        background: Color(0xFF0F1419),
        surface: Color(0xFF1A1D29),
        primary: Color(0xFF4B73FF), // Electric Blue
        secondary: Color(0xFF2A2D3A),
        tertiary: Color(0xFF363A47),
        onBackground: Colors.white,
        onSurface: Colors.white,
        onPrimary: Colors.white,
        error: Color(0xFFFF4757),
      ),
      
      // Scaffold Theme
      scaffoldBackgroundColor: const Color(0xFF0F1419),
      
      // App Bar Theme with language-aware font
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: _getTextStyle(
          fontFamily: fontFamily,
          fontSize: 26 * textScaleFactor,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      
      // Text Theme with language-aware fonts
      textTheme: _buildTextTheme(fontFamily, textScaleFactor),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF4B73FF),
        foregroundColor: Colors.white,
        elevation: 8,
        shape: CircleBorder(),
      ),
    );
  }
  
  TextTheme _buildTextTheme(String fontFamily, double textScaleFactor) {
    return TextTheme(
      displayLarge: _getTextStyle(
        fontFamily: fontFamily,
        fontSize: 32 * textScaleFactor,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      displayMedium: _getTextStyle(
        fontFamily: fontFamily,
        fontSize: 28 * textScaleFactor,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      displaySmall: _getTextStyle(
        fontFamily: fontFamily,
        fontSize: 26 * textScaleFactor,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      headlineLarge: _getTextStyle(
        fontFamily: fontFamily,
        fontSize: 26 * textScaleFactor,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      headlineMedium: _getTextStyle(
        fontFamily: fontFamily,
        fontSize: 24 * textScaleFactor,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      headlineSmall: _getTextStyle(
        fontFamily: fontFamily,
        fontSize: 22 * textScaleFactor,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleLarge: _getTextStyle(
        fontFamily: fontFamily,
        fontSize: 20 * textScaleFactor,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleMedium: _getTextStyle(
        fontFamily: fontFamily,
        fontSize: 16 * textScaleFactor,
        fontWeight: FontWeight.w500,
        color: const Color(0xFFA8AEC5),
      ),
      titleSmall: _getTextStyle(
        fontFamily: fontFamily,
        fontSize: 14 * textScaleFactor,
        fontWeight: FontWeight.w500,
        color: const Color(0xFFA8AEC5),
      ),
      bodyLarge: _getTextStyle(
        fontFamily: fontFamily,
        fontSize: 16 * textScaleFactor,
        fontWeight: FontWeight.normal,
        color: const Color(0xFFBFC3D9),
      ),
      bodyMedium: _getTextStyle(
        fontFamily: fontFamily,
        fontSize: 14 * textScaleFactor,
        fontWeight: FontWeight.normal,
        color: const Color(0xFFBFC3D9),
      ),
      bodySmall: _getTextStyle(
        fontFamily: fontFamily,
        fontSize: 12 * textScaleFactor,
        fontWeight: FontWeight.normal,
        color: const Color(0xFFA8AEC5),
      ),
      labelLarge: _getTextStyle(
        fontFamily: fontFamily,
        fontSize: 14 * textScaleFactor,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      labelMedium: _getTextStyle(
        fontFamily: fontFamily,
        fontSize: 12 * textScaleFactor,
        fontWeight: FontWeight.w500,
        color: const Color(0xFFBFC3D9),
      ),
      labelSmall: _getTextStyle(
        fontFamily: fontFamily,
        fontSize: 11 * textScaleFactor,
        fontWeight: FontWeight.w500,
        color: const Color(0xFFA8AEC5),
      ),
    );
  }
  
  TextStyle _getTextStyle({
    required String fontFamily,
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
  }) {
    // Use Google Fonts for English and fallback fonts for other languages
    if (fontFamily == 'Inter') {
      return GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    } else {
      return TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    }
  }
}

// Main Navigation Screen with proper tab management
class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  
  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  late int _selectedIndex;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _selectedIndex);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const DocumentUploadScreen(),
    const AIAssistantScreen(),
    const SettingsScreen(),
  ];

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C0A),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1916),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, Icons.home_rounded, 'Home', 0),
          _buildNavItem(Icons.upload_file_outlined, Icons.upload_file_rounded, 'Upload', 1),
          _buildNavItem(Icons.psychology_outlined, Icons.psychology_rounded, 'AI', 2),
          _buildNavItem(Icons.settings_outlined, Icons.settings_rounded, 'Settings', 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData outlineIcon, IconData filledIcon, String label, int index) {
    final isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onNavTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFF8A00) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? filledIcon : outlineIcon,
                key: ValueKey(isActive),
                color: isActive ? const Color(0xFF0D0C0A) : Colors.white.withOpacity(0.5),
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isActive ? const Color(0xFF0D0C0A) : Colors.white.withOpacity(0.5),
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}