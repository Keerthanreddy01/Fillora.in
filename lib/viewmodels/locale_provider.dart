import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing app locale/language settings
/// Handles language persistence and provides language switching functionality
class LocaleNotifier extends StateNotifier<Locale> {
  static const String _localeKey = 'app_locale';
  
  // Supported locales for the app
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('hi', 'IN'), // Hindi
    Locale('ta', 'IN'), // Tamil
    Locale('te', 'IN'), // Telugu
  ];

  LocaleNotifier() : super(const Locale('en', 'US')) {
    _loadLocale();
  }

  /// Load saved locale from shared preferences
  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeCode = prefs.getString(_localeKey);
      
      if (localeCode != null) {
        final locale = supportedLocales.firstWhere(
          (locale) => locale.languageCode == localeCode,
          orElse: () => const Locale('en', 'US'),
        );
        state = locale;
      }
    } catch (e) {
      // If loading fails, keep English as default
      state = const Locale('en', 'US');
    }
  }

  /// Save locale to shared preferences
  Future<void> _saveLocale(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, locale.languageCode);
    } catch (e) {
      // Handle save error silently
    }
  }

  /// Change app language
  Future<void> setLocale(Locale locale) async {
    if (supportedLocales.contains(locale)) {
      state = locale;
      await _saveLocale(locale);
    }
  }

  /// Change language by language code
  Future<void> setLanguage(String languageCode) async {
    final locale = supportedLocales.firstWhere(
      (locale) => locale.languageCode == languageCode,
      orElse: () => const Locale('en', 'US'),
    );
    await setLocale(locale);
  }

  /// Get current language code
  String get currentLanguageCode => state.languageCode;

  /// Get current language name
  String get currentLanguageName {
    switch (state.languageCode) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिंदी';
      case 'ta':
        return 'தமிழ்';
      case 'te':
        return 'తెలుగు';
      default:
        return 'English';
    }
  }

  /// Check if current language is RTL
  bool get isRTL {
    // Add RTL languages here if needed
    return false;
  }
}

/// Global provider for locale management
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

/// Provider for getting current language code
final currentLanguageProvider = Provider<String>((ref) {
  final locale = ref.watch(localeProvider);
  return locale.languageCode;
});

/// Provider for getting current language name
final currentLanguageNameProvider = Provider<String>((ref) {
  final notifier = ref.read(localeProvider.notifier);
  return notifier.currentLanguageName;
});

/// Provider for checking if current language is RTL
final isRTLProvider = Provider<bool>((ref) {
  final notifier = ref.read(localeProvider.notifier);
  return notifier.isRTL;
});