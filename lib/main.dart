import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'views/hero_intro_screen.dart';
import 'views/home_screen.dart';
import 'views/profile_screen.dart';
import 'views/document_scanner_screen.dart';
import 'views/ai_assistant_screen.dart';
import 'views/document_upload_screen.dart';
import 'views/services_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0F1419),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  
  runApp(const FilloraApp());
}

class FilloraApp extends StatelessWidget {
  const FilloraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fillora.in - AI Form Assistant',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HeroIntroScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/document-scanner': (context) => const DocumentScannerScreen(),
        '/ai-assistant': (context) => const AIAssistantScreen(),
        '/upload': (context) => const DocumentUploadScreen(),
        '/progress': (context) => const ServicesScreen(),
        '/settings': (context) => const ServicesScreen(),
      },
      theme: ThemeData(
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
        
        // App Bar Theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        // Text Theme with Poppins
        textTheme: GoogleFonts.poppinsTextTheme(
          const TextTheme(
            displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 32),
            displayMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 28),
            displaySmall: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 26),
            headlineLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 26),
            headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 24),
            headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 22),
            titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
            titleMedium: TextStyle(color: Color(0xFFA8AEC5), fontWeight: FontWeight.w500, fontSize: 16),
            titleSmall: TextStyle(color: Color(0xFFA8AEC5), fontWeight: FontWeight.w500, fontSize: 14),
            bodyLarge: TextStyle(color: Color(0xFFBFC3D9), fontWeight: FontWeight.normal, fontSize: 16),
            bodyMedium: TextStyle(color: Color(0xFFBFC3D9), fontWeight: FontWeight.normal, fontSize: 14),
            bodySmall: TextStyle(color: Color(0xFFA8AEC5), fontWeight: FontWeight.normal, fontSize: 12),
            labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
            labelMedium: TextStyle(color: Color(0xFFBFC3D9), fontWeight: FontWeight.w500, fontSize: 12),
            labelSmall: TextStyle(color: Color(0xFFA8AEC5), fontWeight: FontWeight.w500, fontSize: 11),
          ),
        ),
        
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
      ),
    );
  }
}