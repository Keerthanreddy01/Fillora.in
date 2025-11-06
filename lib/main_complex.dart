import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_core/firebase_core.dart'; // Temporarily commented
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'utils/app_theme.dart';
import 'utils/app_constants.dart';
import 'views/splash_screen.dart';
import 'viewmodels/theme_provider.dart';
import 'viewmodels/locale_provider.dart';
import 'generated/l10n.dart';

/// Main entry point of the Fillora.in app
/// Initializes Firebase, sets up theming, localization, and navigation
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase - temporarily commented for UI testing
  // await Firebase.initializeApp();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(
    const ProviderScope(
      child: FilloraApp(),
    ),
  );
}

/// Root widget of the Fillora application
/// Handles theming, localization, and app-wide configuration
class FilloraApp extends ConsumerWidget {
  const FilloraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      
      // Theming configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      
      // Localization configuration
      locale: locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      
      // Home screen
      home: const SplashScreen(),
      
      // Global app configuration
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.3),
          ),
          child: child!,
        );
      },
    );
  }
}