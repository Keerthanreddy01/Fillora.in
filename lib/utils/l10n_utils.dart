import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

/// Utility class for getting localized strings
class L10n {
  /// Get localized string based on key and current language
  static String get(BuildContext context, String key) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    return _getLocalizedString(languageProvider.currentLanguageCode, key);
  }

  /// Get localized string directly with language code
  static String getString(String languageCode, String key) {
    return _getLocalizedString(languageCode, key);
  }

  /// Private method to get localized strings
  static String _getLocalizedString(String languageCode, String key) {
    final translations = _getTranslations(languageCode);
    return translations[key] ?? _getTranslations('en')[key] ?? key;
  }

  /// Get translations map for a language
  static Map<String, String> _getTranslations(String languageCode) {
    switch (languageCode) {
      case 'en':
        return _englishTranslations;
      case 'hi':
        return _hindiTranslations;
      case 'te':
        return _teluguTranslations;
      case 'fr':
        return _frenchTranslations;
      case 'es':
        return _spanishTranslations;
      case 'de':
        return _germanTranslations;
      case 'pt':
        return _portugueseTranslations;
      case 'ar':
        return _arabicTranslations;
      case 'zh':
        return _chineseTranslations;
      case 'ja':
        return _japaneseTranslations;
      default:
        return _englishTranslations;
    }
  }

  // English translations
  static const Map<String, String> _englishTranslations = {
    // App General
    'app_name': 'Fillora.in',
    'app_tagline': 'AI Form Assistant',
    'welcome': 'Welcome to Fillora',
    'get_started': 'Get Started',
    'continue': 'Continue',
    'next': 'Next',
    'back': 'Back',
    'cancel': 'Cancel',
    'save': 'Save',
    'done': 'Done',
    'loading': 'Loading...',
    'error': 'Error',
    'success': 'Success',
    'retry': 'Retry',
    'close': 'Close',

    // Navigation
    'home': 'Home',
    'upload': 'Upload',
    'ai_assistant': 'AI Assistant',
    'settings': 'Settings',
    'profile': 'Profile',

    // Document Scanner
    'scan_document': 'Scan Document',
    'take_photo': 'Take Photo',
    'select_from_gallery': 'Select from Gallery',
    'scanning': 'Scanning...',
    'scan_result': 'Scan Result',
    'detected_text': 'Detected Text',
    'no_text_detected': 'No text detected in image',

    // AI Assistant
    'ai_chat': 'AI Chat',
    'ask_ai': 'Ask AI Assistant',
    'type_message': 'Type your message...',
    'ai_thinking': 'AI is thinking...',
    'form_detection': 'Form Detection',
    'auto_fill': 'Auto Fill',

    // Form Fields
    'name': 'Name',
    'email': 'Email',
    'phone': 'Phone Number',
    'address': 'Address',
    'date_of_birth': 'Date of Birth',
    'gender': 'Gender',
    'occupation': 'Occupation',
    'company': 'Company',
    'father_name': 'Father\'s Name',
    'mother_name': 'Mother\'s Name',

    // Settings
    'language_settings': 'Language Settings',
    'choose_language': 'Choose Your Language',
    'current_language': 'Current Language',
    'auto_detect': 'Auto-Detect Language',
    'api_settings': 'API Settings',
    'about': 'About',

    // Errors
    'network_error': 'Network connection error',
    'camera_permission': 'Camera permission required',
    'storage_permission': 'Storage permission required',
    'invalid_image': 'Invalid image format',
    'processing_error': 'Error processing document',

    // Success Messages
    'language_changed': 'Language changed successfully',
    'document_scanned': 'Document scanned successfully',
    'form_filled': 'Form filled automatically',
    'settings_saved': 'Settings saved successfully',
  };

  // Hindi translations
  static const Map<String, String> _hindiTranslations = {
    // App General
    'app_name': 'फिलोरा.इन',
    'app_tagline': 'एआई फॉर्म असिस्टेंट',
    'welcome': 'फिलोरा में आपका स्वागत है',
    'get_started': 'शुरू करें',
    'continue': 'जारी रखें',
    'next': 'अगला',
    'back': 'वापस',
    'cancel': 'रद्द करें',
    'save': 'सेव करें',
    'done': 'पूर्ण',
    'loading': 'लोड हो रहा है...',
    'error': 'त्रुटि',
    'success': 'सफलता',
    'retry': 'फिर से कोशिश करें',
    'close': 'बंद करें',

    // Navigation
    'home': 'होम',
    'upload': 'अपलोड',
    'ai_assistant': 'एआई असिस्टेंट',
    'settings': 'सेटिंग्स',
    'profile': 'प्रोफाइल',

    // Document Scanner
    'scan_document': 'दस्तावेज़ स्कैन करें',
    'take_photo': 'फोटो लें',
    'select_from_gallery': 'गैलरी से चुनें',
    'scanning': 'स्कैन हो रहा है...',
    'scan_result': 'स्कैन परिणाम',
    'detected_text': 'पहचाना गया टेक्स्ट',
    'no_text_detected': 'छवि में कोई टेक्स्ट नहीं मिला',

    // AI Assistant
    'ai_chat': 'एआई चैट',
    'ask_ai': 'एआई असिस्टेंट से पूछें',
    'type_message': 'अपना संदेश टाइप करें...',
    'ai_thinking': 'एआई सोच रहा है...',
    'form_detection': 'फॉर्म डिटेक्शन',
    'auto_fill': 'ऑटो फिल',

    // Form Fields
    'name': 'नाम',
    'email': 'ईमेल',
    'phone': 'फोन नंबर',
    'address': 'पता',
    'date_of_birth': 'जन्म तारीख',
    'gender': 'लिंग',
    'occupation': 'पेशा',
    'company': 'कंपनी',
    'father_name': 'पिता का नाम',
    'mother_name': 'माता का नाम',

    // Settings
    'language_settings': 'भाषा सेटिंग्स',
    'choose_language': 'अपनी भाषा चुनें',
    'current_language': 'वर्तमान भाषा',
    'auto_detect': 'भाषा को स्वतः पहचानें',
    'api_settings': 'एपीआई सेटिंग्स',
    'about': 'के बारे में',

    // Errors
    'network_error': 'नेटवर्क कनेक्शन त्रुटि',
    'camera_permission': 'कैमरा अनुमति आवश्यक',
    'storage_permission': 'स्टोरेज अनुमति आवश्यक',
    'invalid_image': 'अमान्य छवि प्रारूप',
    'processing_error': 'दस्तावेज़ प्रसंस्करण में त्रुटि',

    // Success Messages
    'language_changed': 'भाषा सफलतापूर्वक बदली गई',
    'document_scanned': 'दस्तावेज़ सफलतापूर्वक स्कैन किया गया',
    'form_filled': 'फॉर्म स्वचालित रूप से भरा गया',
    'settings_saved': 'सेटिंग्स सफलतापूर्वक सेव की गईं',
  };

  // Telugu translations
  static const Map<String, String> _teluguTranslations = {
    // App General
    'app_name': 'ఫిలోరా.ఇన్',
    'app_tagline': 'AI ఫార్మ్ అసిస్టెంట్',
    'welcome': 'ఫిలోరాకు స్వాగతం',
    'get_started': 'ప్రారంభించండి',
    'continue': 'కొనసాగించండి',
    'next': 'తదుపరి',
    'back': 'వెనుకకు',
    'cancel': 'రద్దు చేయండి',
    'save': 'సేవ్ చేయండి',
    'done': 'పూర్తయింది',
    'loading': 'లోడ్ అవుతోంది...',
    'error': 'లోపం',
    'success': 'విజయం',
    'retry': 'మళ్లీ ప్రయత్నించండి',
    'close': 'మూసివేయండి',

    // Navigation
    'home': 'హోమ్',
    'upload': 'అప్‌లోడ్',
    'ai_assistant': 'AI అసిస్టెంట్',
    'settings': 'సెట్టింగ్స్',
    'profile': 'ప్రొఫైల్',

    // Document Scanner
    'scan_document': 'పత్రాన్ని స్కాన్ చేయండి',
    'take_photo': 'ఫోటో తీయండి',
    'select_from_gallery': 'గ్యాలరీ నుంచి ఎంచుకోండి',
    'scanning': 'స్కాన్ అవుతోంది...',
    'scan_result': 'స్కాన్ ఫలితం',
    'detected_text': 'గుర్తించిన టెక్స్ట్',
    'no_text_detected': 'చిత్రంలో టెక్స్ట్ కనుగొనబడలేదు',

    // AI Assistant
    'ai_chat': 'AI చాట్',
    'ask_ai': 'AI అసిస్టెంట్‌ను అడగండి',
    'type_message': 'మీ సందేశాన్ని టైప్ చేయండి...',
    'ai_thinking': 'AI ఆలోచిస్తోంది...',
    'form_detection': 'ఫార్మ్ గుర్తింపు',
    'auto_fill': 'ఆటో ఫిల్',

    // Form Fields
    'name': 'పేరు',
    'email': 'ఇమెయిల్',
    'phone': 'ఫోన్ నంబర్',
    'address': 'చిరునామా',
    'date_of_birth': 'పుట్టిన తేదీ',
    'gender': 'లింగం',
    'occupation': 'వృత్తి',
    'company': 'కంపెనీ',
    'father_name': 'తండ్రి పేరు',
    'mother_name': 'తల్లి పేరు',

    // Settings
    'language_settings': 'భాష సెట్టింగ్స్',
    'choose_language': 'మీ భాషను ఎంచుకోండి',
    'current_language': 'ప్రస్తుత భాష',
    'auto_detect': 'భాషను స్వయంచాలకంగా గుర్తించండి',
    'api_settings': 'API సెట్టింగ్స్',
    'about': 'గురించి',

    // Errors
    'network_error': 'నెట్‌వర్క్ కనెక్షన్ లోపం',
    'camera_permission': 'కెమెరా అనుమతి అవసరం',
    'storage_permission': 'స్టోరేజ్ అనుమతి అవసరం',
    'invalid_image': 'చెల్లని చిత్ర ఫార్మాట్',
    'processing_error': 'పత్రం ప్రాసెసింగ్‌లో లోపం',

    // Success Messages
    'language_changed': 'భాష విజయవంతంగా మార్చబడింది',
    'document_scanned': 'పత్రం విజయవంతంగా స్కాన్ అయింది',
    'form_filled': 'ఫార్మ్ స్వయంచాలకంగా నింపబడింది',
    'settings_saved': 'సెట్టింగ్స్ విజయవంతంగా సేవ్ చేయబడ్డాయి',
  };

  // French translations
  static const Map<String, String> _frenchTranslations = {
    // App General
    'app_name': 'Fillora.in',
    'app_tagline': 'Assistant de Formulaire IA',
    'welcome': 'Bienvenue à Fillora',
    'get_started': 'Commencer',
    'continue': 'Continuer',
    'next': 'Suivant',
    'back': 'Retour',
    'cancel': 'Annuler',
    'save': 'Enregistrer',
    'done': 'Terminé',
    'loading': 'Chargement...',
    'error': 'Erreur',
    'success': 'Succès',
    'retry': 'Réessayer',
    'close': 'Fermer',

    // Navigation
    'home': 'Accueil',
    'upload': 'Télécharger',
    'ai_assistant': 'Assistant IA',
    'settings': 'Paramètres',
    'profile': 'Profil',

    // Document Scanner
    'scan_document': 'Scanner le document',
    'take_photo': 'Prendre une photo',
    'select_from_gallery': 'Sélectionner depuis la galerie',
    'scanning': 'Numérisation...',
    'scan_result': 'Résultat du scan',
    'detected_text': 'Texte détecté',
    'no_text_detected': 'Aucun texte détecté dans l\'image',

    // Form Fields
    'name': 'Nom',
    'email': 'Email',
    'phone': 'Numéro de téléphone',
    'address': 'Adresse',
    'date_of_birth': 'Date de naissance',
  };

  // Spanish translations  
  static const Map<String, String> _spanishTranslations = {
    'app_name': 'Fillora.in',
    'app_tagline': 'Asistente de Formularios IA',
    'welcome': 'Bienvenido a Fillora',
    'get_started': 'Comenzar',
    'home': 'Inicio',
    'upload': 'Subir',
    'ai_assistant': 'Asistente IA',
    'settings': 'Configuración',
    'profile': 'Perfil',
    'name': 'Nombre',
    'email': 'Correo electrónico',
  };

  // German translations
  static const Map<String, String> _germanTranslations = {
    'app_name': 'Fillora.in',
    'app_tagline': 'KI-Formular-Assistent',
    'welcome': 'Willkommen bei Fillora',
    'get_started': 'Loslegen',
    'home': 'Startseite',
    'upload': 'Hochladen',
    'ai_assistant': 'KI-Assistent',
    'settings': 'Einstellungen',
    'profile': 'Profil',
    'name': 'Name',
    'email': 'E-Mail',
  };

  // Portuguese translations
  static const Map<String, String> _portugueseTranslations = {
    'app_name': 'Fillora.in',
    'app_tagline': 'Assistente de Formulários IA',
    'welcome': 'Bem-vindo ao Fillora',
    'get_started': 'Começar',
    'home': 'Início',
    'upload': 'Enviar',
    'ai_assistant': 'Assistente IA',
    'settings': 'Configurações',
    'profile': 'Perfil',
    'name': 'Nome',
    'email': 'Email',
  };

  // Arabic translations
  static const Map<String, String> _arabicTranslations = {
    'app_name': 'Fillora.in',
    'app_tagline': 'مساعد النماذج بالذكاء الاصطناعي',
    'welcome': 'مرحباً بك في فيلورا',
    'get_started': 'ابدأ',
    'home': 'الرئيسية',
    'upload': 'رفع',
    'ai_assistant': 'المساعد الذكي',
    'settings': 'الإعدادات',
    'profile': 'الملف الشخصي',
    'name': 'الاسم',
    'email': 'البريد الإلكتروني',
  };

  // Chinese translations
  static const Map<String, String> _chineseTranslations = {
    'app_name': 'Fillora.in',
    'app_tagline': 'AI表单助手',
    'welcome': '欢迎使用Fillora',
    'get_started': '开始',
    'home': '首页',
    'upload': '上传',
    'ai_assistant': 'AI助手',
    'settings': '设置',
    'profile': '个人资料',
    'name': '姓名',
    'email': '电子邮件',
  };

  // Japanese translations
  static const Map<String, String> _japaneseTranslations = {
    'app_name': 'Fillora.in',
    'app_tagline': 'AIフォームアシスタント',
    'welcome': 'Filloraへようこそ',
    'get_started': '始める',
    'home': 'ホーム',
    'upload': 'アップロード',
    'ai_assistant': 'AIアシスタント',
    'settings': '設定',
    'profile': 'プロフィール',
    'name': '名前',
    'email': 'メール',
  };

  /// Helper method to get all available language codes
  static List<String> getSupportedLanguages() {
    return ['en', 'hi', 'te'];
  }

  /// Helper method to check if a language is supported
  static bool isLanguageSupported(String languageCode) {
    return getSupportedLanguages().contains(languageCode);
  }

  /// Get language-specific date format
  static String getDateFormat(String languageCode) {
    switch (languageCode) {
      case 'hi':
      case 'te':
        return 'dd/MM/yyyy'; // DD/MM/YYYY format common in India
      default:
        return 'MM/dd/yyyy'; // MM/DD/YYYY format for English
    }
  }

  /// Get language-specific number format
  static String formatNumber(String languageCode, num number) {
    // This is a simplified implementation
    // In production, use proper NumberFormat from intl package
    switch (languageCode) {
      case 'hi':
        // Use Indian number system if needed
        return number.toString();
      case 'te':
        // Use Telugu number system if needed
        return number.toString();
      default:
        return number.toString();
    }
  }

  /// Get greeting based on time and language
  static String getGreeting(String languageCode) {
    final hour = DateTime.now().hour;
    
    if (hour < 12) {
      // Morning
      switch (languageCode) {
        case 'hi':
          return 'सुप्रभात';
        case 'te':
          return 'శుభోదయం';
        default:
          return 'Good Morning';
      }
    } else if (hour < 17) {
      // Afternoon
      switch (languageCode) {
        case 'hi':
          return 'नमस्कार';
        case 'te':
          return 'శుభ మధ్యాహ్నం';
        default:
          return 'Good Afternoon';
      }
    } else {
      // Evening
      switch (languageCode) {
        case 'hi':
          return 'शुभ संध्या';
        case 'te':
          return 'శుభ సాయంత్రం';
        default:
          return 'Good Evening';
      }
    }
  }
}