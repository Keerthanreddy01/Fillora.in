import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Language provider for managing app localization
class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  
  Locale _currentLocale = const Locale('en', 'US');
  
  Locale get currentLocale => _currentLocale;
  
  String get currentLanguageCode => _currentLocale.languageCode;
  
  /// Supported languages with their display names
  final Map<String, Map<String, String>> supportedLanguages = {
    'en': {
      'code': 'en',
      'name': 'English',
      'nativeName': 'English',
      'flag': '🇺🇸',
    },
    'hi': {
      'code': 'hi',
      'name': 'Hindi',
      'nativeName': 'हिन्दी',
      'flag': '🇮🇳',
    },
    'te': {
      'code': 'te',
      'name': 'Telugu',
      'nativeName': 'తెలుగు',
      'flag': '🇮🇳',
    },
    'fr': {
      'code': 'fr',
      'name': 'French',
      'nativeName': 'Français',
      'flag': '🇫🇷',
    },
    'es': {
      'code': 'es',
      'name': 'Spanish',
      'nativeName': 'Español',
      'flag': '🇪🇸',
    },
    'de': {
      'code': 'de',
      'name': 'German',
      'nativeName': 'Deutsch',
      'flag': '🇩🇪',
    },
    'pt': {
      'code': 'pt',
      'name': 'Portuguese',
      'nativeName': 'Português',
      'flag': '🇵🇹',
    },
    'ar': {
      'code': 'ar',
      'name': 'Arabic',
      'nativeName': 'العربية',
      'flag': '🇸🇦',
    },
    'zh': {
      'code': 'zh',
      'name': 'Chinese',
      'nativeName': '中文',
      'flag': '🇨🇳',
    },
    'ja': {
      'code': 'ja',
      'name': 'Japanese',
      'nativeName': '日本語',
      'flag': '🇯🇵',
    },
  };

  LanguageProvider() {
    _loadSavedLanguage();
  }

  /// Load the saved language from SharedPreferences
  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString(_languageKey);
      
      if (savedLanguageCode != null && supportedLanguages.containsKey(savedLanguageCode)) {
        _currentLocale = Locale(savedLanguageCode);
        notifyListeners();
      }
    } catch (e) {
      // If there's an error loading the language, use the default (English)
      debugPrint('Error loading saved language: $e');
    }
  }

  /// Change the app language and save the preference
  Future<void> changeLanguage(String languageCode) async {
    if (!supportedLanguages.containsKey(languageCode)) {
      return;
    }

    try {
      _currentLocale = Locale(languageCode);
      
      // Save the language preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error changing language: $e');
    }
  }

  /// Get the display name for a language code
  String getLanguageDisplayName(String languageCode) {
    return supportedLanguages[languageCode]?['name'] ?? 'Unknown';
  }

  /// Get the native name for a language code
  String getLanguageNativeName(String languageCode) {
    return supportedLanguages[languageCode]?['nativeName'] ?? 'Unknown';
  }

  /// Get the flag emoji for a language code
  String getLanguageFlag(String languageCode) {
    return supportedLanguages[languageCode]?['flag'] ?? '🏳️';
  }

  /// Get the current language display name
  String get currentLanguageDisplayName => getLanguageDisplayName(_currentLocale.languageCode);

  /// Get the current language native name
  String get currentLanguageNativeName => getLanguageNativeName(_currentLocale.languageCode);

  /// Get the current language flag
  String get currentLanguageFlag => getLanguageFlag(_currentLocale.languageCode);

  /// Check if a language is RTL (Right-to-Left)
  bool isRTL(String languageCode) {
    // Add RTL languages here if needed in the future
    // For now, all supported languages are LTR
    return false;
  }

  /// Get the text direction for the current language
  TextDirection get textDirection {
    return isRTL(_currentLocale.languageCode) 
        ? TextDirection.rtl 
        : TextDirection.ltr;
  }

  /// Auto-detect system language and set if supported
  Future<void> setSystemLanguage() async {
    try {
      final systemLocales = WidgetsBinding.instance.platformDispatcher.locales;
      
      for (final locale in systemLocales) {
        if (supportedLanguages.containsKey(locale.languageCode)) {
          await changeLanguage(locale.languageCode);
          return;
        }
      }
      
      // If no supported language found, default to English
      await changeLanguage('en');
    } catch (e) {
      debugPrint('Error setting system language: $e');
      await changeLanguage('en');
    }
  }

  /// Get localized font family based on language
  String getFontFamily() {
    switch (_currentLocale.languageCode) {
      case 'hi':
        return 'Noto Sans Devanagari'; // For Hindi text
      case 'te':
        return 'Noto Sans Telugu'; // For Telugu text
      default:
        return 'Inter'; // Default font for English and other languages
    }
  }

  /// Get language-specific text scale factor
  double getTextScaleFactor() {
    switch (_currentLocale.languageCode) {
      case 'hi':
      case 'te':
        return 1.1; // Slightly larger for Indic scripts
      default:
        return 1.0;
    }
  }

  /// Format numbers according to locale
  String formatNumber(num number) {
    // This is a simplified formatter
    // In a production app, you'd use proper number formatting
    switch (_currentLocale.languageCode) {
      case 'hi':
        // Use Devanagari numerals if needed
        return number.toString();
      case 'te':
        // Use Telugu numerals if needed
        return number.toString();
      default:
        return number.toString();
    }
  }

  /// Get appropriate keyboard type for language
  TextInputType getKeyboardType() {
    switch (_currentLocale.languageCode) {
      case 'hi':
      case 'te':
        // Use text input that supports Indic scripts
        return TextInputType.text;
      default:
        return TextInputType.text;
    }
  }

  /// Get supported document types based on language/region
  List<String> getSupportedDocumentTypes() {
    switch (_currentLocale.languageCode) {
      case 'hi':
      case 'te':
        return [
          'Aadhaar Card',
          'PAN Card',
          'Voter ID',
          'Passport',
          'Driver License',
          'Ration Card',
          'Bank Statement',
          'Other Document'
        ];
      default:
        return [
          'ID Document',
          'Passport',
          'Driver License',
          'Bank Statement',
          'Tax Document',
          'Insurance Card',
          'Medical Record',
          'Other Document'
        ];
    }
  }

  /// Get language-specific field names for forms
  Map<String, String> getCommonFieldNames() {
    switch (_currentLocale.languageCode) {
      case 'hi':
        return {
          'name': 'नाम',
          'father_name': 'पिता का नाम',
          'mother_name': 'माता का नाम',
          'address': 'पता',
          'phone': 'फोन नंबर',
          'email': 'ईमेल',
          'date_of_birth': 'जन्म तारीख',
          'aadhar_number': 'आधार संख्या',
          'pan_number': 'पैन संख्या',
        };
      case 'te':
        return {
          'name': 'పేరు',
          'father_name': 'తండ్రి పేరు',
          'mother_name': 'తల్లి పేరు',
          'address': 'చిరునామా',
          'phone': 'ఫోన్ నంబర్',
          'email': 'ఇమెయిల్',
          'date_of_birth': 'పుట్టిన తేదీ',
          'aadhar_number': 'ఆధార్ నంబర్',
          'pan_number': 'పాన్ నంబర్',
        };
      default:
        return {
          'name': 'Name',
          'father_name': 'Father\'s Name',
          'mother_name': 'Mother\'s Name',
          'address': 'Address',
          'phone': 'Phone Number',
          'email': 'Email',
          'date_of_birth': 'Date of Birth',
          'aadhar_number': 'Aadhaar Number',
          'pan_number': 'PAN Number',
        };
    }
  }
}