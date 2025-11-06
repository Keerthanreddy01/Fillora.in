import 'package:flutter/material.dart';

/// App localization delegate for multi-language support
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('hi', 'IN'), // Hindi
    Locale('te', 'IN'), // Telugu
  ];

  // App Name & Branding
  String get appName {
    switch (locale.languageCode) {
      case 'hi':
        return 'फिलोरा'; // Fillora in Devanagari
      case 'te':
        return 'ఫిలోరా'; // Fillora in Telugu
      default:
        return 'Fillora';
    }
  }

  String get appTagline {
    switch (locale.languageCode) {
      case 'hi':
        return 'आपका AI फॉर्म सहायक';
      case 'te':
        return 'మీ AI ఫారమ్ సహాయకుడు';
      default:
        return 'Your AI Form Assistant';
    }
  }

  // Navigation & Screen Titles
  String get homeScreenTitle {
    switch (locale.languageCode) {
      case 'hi':
        return 'होम';
      case 'te':
        return 'హోమ్';
      default:
        return 'Home';
    }
  }

  String get documentScannerTitle {
    switch (locale.languageCode) {
      case 'hi':
        return 'दस्तावेज़ स्कैनर';
      case 'te':
        return 'డాక్యుమెంట్ స్కానర్';
      default:
        return 'Document Scanner';
    }
  }

  String get smartFormEditorTitle {
    switch (locale.languageCode) {
      case 'hi':
        return 'स्मार्ट फॉर्म एडिटर';
      case 'te':
        return 'స్మార్ట్ ఫారమ్ ఎడిటర్';
      default:
        return 'Smart Form Editor';
    }
  }

  String get aiAssistantTitle {
    switch (locale.languageCode) {
      case 'hi':
        return 'AI सहायक';
      case 'te':
        return 'AI సహాయకుడు';
      default:
        return 'AI Assistant';
    }
  }

  String get settingsTitle {
    switch (locale.languageCode) {
      case 'hi':
        return 'सेटिंग्स';
      case 'te':
        return 'సెట్టింగ్స్';
      default:
        return 'Settings';
    }
  }

  // Document Scanner
  String get takePicture {
    switch (locale.languageCode) {
      case 'hi':
        return 'फोटो लें';
      case 'te':
        return 'ఫోటో తీయండి';
      default:
        return 'Take Photo';
    }
  }

  String get chooseFromGallery {
    switch (locale.languageCode) {
      case 'hi':
        return 'गैलरी से चुनें';
      case 'te':
        return 'గ్యాలరీ నుండి ఎంచుకోండి';
      default:
        return 'Choose from Gallery';
    }
  }

  String get documentType {
    switch (locale.languageCode) {
      case 'hi':
        return 'दस्तावेज़ प्रकार';
      case 'te':
        return 'డాక్యుమెంట్ రకం';
      default:
        return 'Document Type';
    }
  }

  String get extractingText {
    switch (locale.languageCode) {
      case 'hi':
        return 'टेक्स्ट निकाला जा रहा है...';
      case 'te':
        return 'టెక్స్ట్ తీయబడుతోంది...';
      default:
        return 'Extracting text...';
    }
  }

  String get aiAnalyzing {
    switch (locale.languageCode) {
      case 'hi':
        return 'AI विश्लेषण कर रहा है...';
      case 'te':
        return 'AI విశ్లేషిస్తోంది...';
      default:
        return 'AI is analyzing...';
    }
  }

  String get documentProcessed {
    switch (locale.languageCode) {
      case 'hi':
        return 'दस्तावेज़ प्रोसेस हो गया!';
      case 'te':
        return 'డాక్యుమెంట్ ప్రాసెస్ అయ్యింది!';
      default:
        return 'Document Processed!';
    }
  }

  // Form Editor
  String get formCompletion {
    switch (locale.languageCode) {
      case 'hi':
        return 'फॉर्म पूर्णता';
      case 'te':
        return 'ఫారమ్ పూర్తి';
      default:
        return 'Form Completion';
    }
  }

  String get personalInformation {
    switch (locale.languageCode) {
      case 'hi':
        return 'व्यक्तिगत जानकारी';
      case 'te':
        return 'వ్యక్తిగత సమాచారం';
      default:
        return 'Personal Information';
    }
  }

  String get contactDetails {
    switch (locale.languageCode) {
      case 'hi':
        return 'संपर्क विवरण';
      case 'te':
        return 'సంప్రదింపు వివరాలు';
      default:
        return 'Contact Details';
    }
  }

  String get identityDocuments {
    switch (locale.languageCode) {
      case 'hi':
        return 'पहचान दस्तावेज़';
      case 'te':
        return 'గుర్తింపు పత్రాలు';
      default:
        return 'Identity Documents';
    }
  }

  String get education {
    switch (locale.languageCode) {
      case 'hi':
        return 'शिक्षा';
      case 'te':
        return 'విద్య';
      default:
        return 'Education';
    }
  }

  String get employment {
    switch (locale.languageCode) {
      case 'hi':
        return 'रोजगार';
      case 'te':
        return 'ఉద్యోగం';
      default:
        return 'Employment';
    }
  }

  String get saveForm {
    switch (locale.languageCode) {
      case 'hi':
        return 'फॉर्म सेव करें';
      case 'te':
        return 'ఫారమ్ సేవ్ చేయండి';
      default:
        return 'Save Form';
    }
  }

  String get preview {
    switch (locale.languageCode) {
      case 'hi':
        return 'पूर्वावलोकन';
      case 'te':
        return 'ప్రివ్యూ';
      default:
        return 'Preview';
    }
  }

  // Voice Input
  String get voiceInput {
    switch (locale.languageCode) {
      case 'hi':
        return 'आवाज़ इनपुट';
      case 'te':
        return 'వాయిస్ ఇన్‌పుట్';
      default:
        return 'Voice Input';
    }
  }

  String get listening {
    switch (locale.languageCode) {
      case 'hi':
        return 'सुन रहा है...';
      case 'te':
        return 'వింటోంది...';
      default:
        return 'Listening...';
    }
  }

  String get speakNow {
    switch (locale.languageCode) {
      case 'hi':
        return 'अब बोलें';
      case 'te':
        return 'ఇప్పుడు మాట్లాడండి';
      default:
        return 'Speak now';
    }
  }

  String get voiceInputComingSoon {
    switch (locale.languageCode) {
      case 'hi':
        return 'आवाज़ इनपुट जल्द ही आ रहा है!';
      case 'te':
        return 'వాయిస్ ఇన్‌పుట్ త్వరలో వస్తుంది!';
      default:
        return 'Voice input coming soon!';
    }
  }

  // Common Actions
  String get save {
    switch (locale.languageCode) {
      case 'hi':
        return 'सेव करें';
      case 'te':
        return 'సేవ్ చేయండి';
      default:
        return 'Save';
    }
  }

  String get cancel {
    switch (locale.languageCode) {
      case 'hi':
        return 'रद्द करें';
      case 'te':
        return 'రద్దు చేయండి';
      default:
        return 'Cancel';
    }
  }

  String get ok {
    switch (locale.languageCode) {
      case 'hi':
        return 'ठीक है';
      case 'te':
        return 'సరే';
      default:
        return 'OK';
    }
  }

  String get next {
    switch (locale.languageCode) {
      case 'hi':
        return 'अगला';
      case 'te':
        return 'తదుపరి';
      default:
        return 'Next';
    }
  }

  String get back {
    switch (locale.languageCode) {
      case 'hi':
        return 'वापस';
      case 'te':
        return 'వెనుకకు';
      default:
        return 'Back';
    }
  }

  String get retry {
    switch (locale.languageCode) {
      case 'hi':
        return 'पुनः प्रयास करें';
      case 'te':
        return 'మళ్లీ ప్రయత్నించండి';
      default:
        return 'Retry';
    }
  }

  // Settings
  String get language {
    switch (locale.languageCode) {
      case 'hi':
        return 'भाषा';
      case 'te':
        return 'భాష';
      default:
        return 'Language';
    }
  }

  String get apiKey {
    switch (locale.languageCode) {
      case 'hi':
        return 'API कुंजी';
      case 'te':
        return 'API కీ';
      default:
        return 'API Key';
    }
  }

  String get theme {
    switch (locale.languageCode) {
      case 'hi':
        return 'थीम';
      case 'te':
        return 'థీమ్';
      default:
        return 'Theme';
    }
  }

  // Languages
  String get english {
    switch (locale.languageCode) {
      case 'hi':
        return 'अंग्रेजी';
      case 'te':
        return 'ఆంగ్లం';
      default:
        return 'English';
    }
  }

  String get hindi {
    switch (locale.languageCode) {
      case 'hi':
        return 'हिन्दी';
      case 'te':
        return 'హిందీ';
      default:
        return 'हिन्दी';
    }
  }

  String get telugu {
    switch (locale.languageCode) {
      case 'hi':
        return 'तेलुगु';
      case 'te':
        return 'తెలుగు';
      default:
        return 'తెలుగు';
    }
  }

  // Form Field Types
  String get name {
    switch (locale.languageCode) {
      case 'hi':
        return 'नाम';
      case 'te':
        return 'పేరు';
      default:
        return 'Name';
    }
  }

  String get email {
    switch (locale.languageCode) {
      case 'hi':
        return 'ईमेल';
      case 'te':
        return 'ఇమెయిల్';
      default:
        return 'Email';
    }
  }

  String get phone {
    switch (locale.languageCode) {
      case 'hi':
        return 'फोन';
      case 'te':
        return 'ఫోన్';
      default:
        return 'Phone';
    }
  }

  String get address {
    switch (locale.languageCode) {
      case 'hi':
        return 'पता';
      case 'te':
        return 'చిరునామా';
      default:
        return 'Address';
    }
  }

  String get dateOfBirth {
    switch (locale.languageCode) {
      case 'hi':
        return 'जन्म तारीख';
      case 'te':
        return 'పుట్టిన తేదీ';
      default:
        return 'Date of Birth';
    }
  }

  // Error Messages
  String get error {
    switch (locale.languageCode) {
      case 'hi':
        return 'त्रुटि';
      case 'te':
        return 'లోపం';
      default:
        return 'Error';
    }
  }

  String get permissionRequired {
    switch (locale.languageCode) {
      case 'hi':
        return 'अनुमति आवश्यक';
      case 'te':
        return 'అనుమతి అవసరం';
      default:
        return 'Permission Required';
    }
  }

  String get cameraPermissionRequired {
    switch (locale.languageCode) {
      case 'hi':
        return 'कैमरा अनुमति आवश्यक है';
      case 'te':
        return 'కెమెరా అనుమతి అవసరం';
      default:
        return 'Camera permission is required';
    }
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .map((l) => l.languageCode)
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}