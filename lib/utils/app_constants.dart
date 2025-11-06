/// Application-wide constants and configuration values
/// Contains app name, API endpoints, and other static values used throughout the app
class AppConstants {
  // App Information
  static const String appName = 'Fillora.in';
  static const String appTagline = 'The AI Form Assistant';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.fillora.in';
  static const String openaiApiUrl = 'https://api.openai.com/v1';
  static const String googleVisionApiUrl = 'https://vision.googleapis.com/v1';
  
  // Firebase Configuration
  static const String firestoreUsersCollection = 'users';
  static const String firestoreFormsCollection = 'forms';
  static const String firestoreDocumentsCollection = 'documents';
  
  // Supported Languages
  static const List<String> supportedLanguages = [
    'en', // English
    'hi', // Hindi
    'ta', // Tamil
    'te', // Telugu
  ];
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
  
  // Spacing and Sizing
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  
  static const double defaultBorderRadius = 12.0;
  static const double largeBorderRadius = 16.0;
  static const double circularBorderRadius = 50.0;
  
  // File Handling
  static const List<String> supportedImageFormats = [
    'jpg', 'jpeg', 'png', 'bmp', 'gif'
  ];
  static const List<String> supportedDocumentFormats = [
    'pdf', 'doc', 'docx'
  ];
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  
  // OCR Configuration
  static const double ocrConfidenceThreshold = 0.7;
  static const int maxOcrRetries = 3;
  
  // Chat Configuration
  static const int maxChatHistoryLength = 50;
  static const int typingIndicatorDelay = 1000; // milliseconds
  
  // Form Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxMessageLength = 500;
  
  // Asset Paths
  static const String animationsPath = 'assets/animations';
  static const String imagesPath = 'assets/images';
  static const String iconsPath = 'assets/icons';
  static const String fontsPath = 'assets/fonts';
  
  // Lottie Animation Files
  static const String splashAnimation = '$animationsPath/splash.json';
  static const String loadingAnimation = '$animationsPath/loading.json';
  static const String successAnimation = '$animationsPath/success.json';
  static const String errorAnimation = '$animationsPath/error.json';
  static const String onboardingAnimation = '$animationsPath/onboarding.json';
  static const String ocrScanAnimation = '$animationsPath/ocr_scan.json';
  static const String chatBotAnimation = '$animationsPath/chatbot.json';
  
  // Image Assets
  static const String logoImage = '$imagesPath/logo.png';
  static const String placeholderImage = '$imagesPath/placeholder.png';
  static const String onboardingImage1 = '$imagesPath/onboarding_1.png';
  static const String onboardingImage2 = '$imagesPath/onboarding_2.png';
  static const String onboardingImage3 = '$imagesPath/onboarding_3.png';
  
  // API Keys (These should be stored securely in production)
  // Note: In production, use environment variables or secure storage
  static const String openaiApiKey = 'YOUR_OPENAI_API_KEY';
  static const String googleVisionApiKey = 'YOUR_GOOGLE_VISION_API_KEY';
  
  // Error Messages
  static const String networkErrorMessage = 'Please check your internet connection';
  static const String genericErrorMessage = 'Something went wrong. Please try again';
  static const String authErrorMessage = 'Authentication failed. Please try again';
  static const String ocrErrorMessage = 'Failed to extract text from document';
  static const String aiErrorMessage = 'AI assistant is temporarily unavailable';
  
  // Success Messages
  static const String loginSuccessMessage = 'Successfully logged in';
  static const String logoutSuccessMessage = 'Successfully logged out';
  static const String documentUploadSuccessMessage = 'Document uploaded successfully';
  static const String formSavedSuccessMessage = 'Form saved successfully';
  
  // Validation Messages
  static const String emailValidationMessage = 'Please enter a valid email address';
  static const String passwordValidationMessage = 'Password must be at least 8 characters';
  static const String nameValidationMessage = 'Please enter your name';
  static const String requiredFieldMessage = 'This field is required';
}