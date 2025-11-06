# Fillora.in - The AI Form Assistant

An AI-powered Flutter application that helps users fill long and complex online forms automatically using document scanning, text extraction (OCR), and conversational AI. Built with modern Material 3 design and multilingual support for Indian users.

## 🚀 Features

### Core Functionality
- **Smart Document Scanning**: Upload or scan documents to extract data automatically using advanced OCR technology
- **AI-Powered Assistant**: Get help filling forms with intelligent AI that understands multiple Indian languages
- **Secure & Private**: Your data is encrypted and secure with end-to-end privacy protection
- **Multilingual Support**: Available in English, Hindi, Tamil, and Telugu

### User Experience
- **Material 3 Design**: Modern, clean UI with glassmorphism effects
- **Dark Mode Support**: Switch between light and dark themes
- **Accessibility Features**: Voice input, adjustable text size, and high contrast options
- **Smooth Animations**: Lottie animations and smooth transitions throughout the app

### Technical Features
- **Firebase Integration**: Authentication with Google Sign-in and email/password
- **OCR Processing**: Google ML Kit for text extraction from documents
- **AI Chat Interface**: Conversational assistance for form filling
- **State Management**: Riverpod for efficient state management
- **MVVM Architecture**: Clean separation of concerns for maintainable code

## 🛠️ Technology Stack

- **Frontend**: Flutter 3.13+ with Material 3
- **Backend**: Firebase (Auth, Firestore, Storage)
- **OCR Engine**: Google ML Kit / Vision API
- **AI/NLP**: OpenAI API / Dialogflow (placeholder implementation included)
- **State Management**: Flutter Riverpod
- **Architecture**: MVVM (Model-View-ViewModel)
- **Animations**: Lottie animations with animate_do
- **Localization**: Flutter Intl for multi-language support

## 📱 App Structure

### Main Screens
1. **Splash Screen**: App introduction with loading animation
2. **Onboarding**: Feature highlights with smooth transitions
3. **Authentication**: Google Sign-in, Email/Password, and Guest access
4. **Home Dashboard**: Quick actions and recent activity overview
5. **Document Upload**: Camera, gallery, and file upload with OCR processing
6. **AI Chat Assistant**: Conversational help for form filling
7. **Form Auto-Fill**: Review and edit extracted information
8. **Profile & Settings**: User preferences and app configuration

### Key Components
- **Glassmorphism UI**: Modern glass-effect containers and cards
- **Custom Widgets**: Reusable text fields, buttons, and form components
- **Theme System**: Dynamic light/dark mode switching
- **Localization**: ARB files for English, Hindi, Tamil, and Telugu

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.13 or higher
- Dart SDK 3.1 or higher
- Android Studio / VS Code
- Firebase project (for backend services)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Keerthanreddy01/Fillora.in.git
   cd Fillora.in
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a new Firebase project
   - Add Android/iOS apps to the project
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the appropriate directories

4. **Set up API keys**
   - Update `lib/utils/app_constants.dart` with your API keys:
     - OpenAI API key (for AI chat)
     - Google Vision API key (for OCR)

5. **Run the app**
   ```bash
   flutter run
   ```

### Development Setup

1. **Generate localization files**
   ```bash
   flutter packages pub run build_runner build
   ```

2. **Run with hot reload**
   ```bash
   flutter run --debug
   ```

3. **Build for release**
   ```bash
   flutter build apk --release
   # or
   flutter build ios --release
   ```

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── user_model.dart
│   ├── document_model.dart
│   └── chat_model.dart
├── views/                    # UI screens
│   ├── splash_screen.dart
│   ├── onboarding_screen.dart
│   ├── auth_screen.dart
│   ├── home_screen.dart
│   ├── document_upload_screen.dart
│   └── ai_chat_screen.dart
├── viewmodels/              # State management
│   ├── auth_provider.dart
│   ├── theme_provider.dart
│   └── locale_provider.dart
├── services/                # Business logic
│   └── auth_service.dart
├── widgets/                 # Reusable components
│   ├── glassmorphism_container.dart
│   └── custom_text_field.dart
├── utils/                   # Utilities and constants
│   ├── app_theme.dart
│   └── app_constants.dart
├── l10n/                    # Localization files
│   ├── app_en.arb
│   ├── app_hi.arb
│   ├── app_ta.arb
│   └── app_te.arb
└── generated/               # Generated files
    └── l10n.dart
```

## 🔧 Configuration

### Firebase Setup
1. Authentication methods: Email/Password, Google Sign-in, Anonymous (Guest)
2. Firestore collections: `users`, `forms`, `documents`
3. Storage for uploaded documents and extracted data

### API Integration
- **OCR Service**: Google ML Kit (offline) or Google Vision API (online)
- **AI Chat**: OpenAI API or Dialogflow for conversational assistance
- **Placeholder implementations**: Ready for easy API integration

### Localization
- Support for 4 languages: English, Hindi, Tamil, Telugu
- ARB files for easy translation management
- RTL support structure (expandable)

## 🎨 Design Features

### Glassmorphism UI
- Translucent cards with blur effects
- Modern gradient backgrounds
- Smooth shadows and borders

### Material 3 Design
- Dynamic color theming
- Consistent typography scale
- Accessible color contrast ratios

### Animations
- Lottie animations for onboarding and success states
- Smooth page transitions
- Micro-interactions throughout the app

## 📝 Development Notes

### State Management with Riverpod
```dart
// Example provider usage
final authProvider = StateNotifierProvider<AuthNotifier, UserModel?>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(authService);
});
```

### Custom Widgets
```dart
// Glassmorphism container usage
GlassmorphismContainer(
  child: YourWidget(),
  blur: 10.0,
  opacity: 0.1,
)
```

### Localization
```dart
// Using localized strings
Text(S.of(context).appName)
```

## 🚀 Deployment

### Android
1. Update `android/app/build.gradle` with your signing configuration
2. Build release APK: `flutter build apk --release`
3. Upload to Google Play Store

### iOS
1. Configure signing in Xcode
2. Build release IPA: `flutter build ios --release`
3. Upload to App Store Connect

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and queries:
- GitHub: [@Keerthanreddy01](https://github.com/Keerthanreddy01)
- GitHub Issues: [Create an issue](https://github.com/Keerthanreddy01/Fillora.in/issues)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Material Design team for design guidelines
- Open source community for various packages used

---

**Built with ❤️ for making form filling easier for everyone**