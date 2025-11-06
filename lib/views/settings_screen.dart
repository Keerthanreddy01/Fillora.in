import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/gemini_service.dart';
import '../providers/language_provider.dart';
import 'language_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  final TextEditingController _apiKeyController = TextEditingController();
  bool _isObscured = true;
  bool _isLoading = false;
  String? _currentApiKey;
  bool _apiKeyValid = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _loadCurrentApiKey();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentApiKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final apiKey = prefs.getString('gemini_api_key');
      if (apiKey != null && apiKey.isNotEmpty) {
        setState(() {
          _currentApiKey = apiKey;
          _apiKeyController.text = apiKey;
          _apiKeyValid = true;
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _saveApiKey() async {
    final apiKey = _apiKeyController.text.trim();
    
    if (apiKey.isEmpty) {
      _showErrorDialog('Please enter your Gemini API key');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Test the API key by making a simple request
      await GeminiService.testApiKey(apiKey);
      
      // Save the API key
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('gemini_api_key', apiKey);
      
      setState(() {
        _currentApiKey = apiKey;
        _apiKeyValid = true;
        _isLoading = false;
      });
      
      _showSuccessDialog();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Invalid API key. Please check and try again.');
    }
  }

  Future<void> _removeApiKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('gemini_api_key');
      
      setState(() {
        _currentApiKey = null;
        _apiKeyController.clear();
        _apiKeyValid = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'API key removed successfully',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } catch (e) {
      _showErrorDialog('Failed to remove API key');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1916),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Error',
          style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.w600),
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8A00),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'OK',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1916),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 24),
            const SizedBox(width: 8),
            Text(
              'API Key Saved!',
              style: GoogleFonts.poppins(color: Colors.green, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Text(
          'Your Gemini API key has been saved successfully. You can now use AI-powered document analysis!',
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Great!',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showApiKeyInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1916),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.info, color: Color(0xFFFF8A00), size: 24),
            const SizedBox(width: 8),
            Text(
              'Getting Your API Key',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To use AI-powered document analysis, you need a Gemini API key:',
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            _buildInfoStep('1', 'Visit ai.google.dev'),
            _buildInfoStep('2', 'Sign in with your Google account'),
            _buildInfoStep('3', 'Go to "Get API Key" section'),
            _buildInfoStep('4', 'Create a new API key'),
            _buildInfoStep('5', 'Copy and paste it here'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFF8A00).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFF8A00).withOpacity(0.3)),
              ),
              child: Text(
                'The API key is stored locally on your device and never shared.',
                style: GoogleFonts.poppins(
                  color: const Color(0xFFFF8A00),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8A00),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Got it!',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFFFF8A00),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.8, -0.6),
            radius: 1.2,
            colors: [
              const Color(0xFFFF8A00).withOpacity(0.15),
              const Color(0xFF0D0C0A),
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
                      _buildLanguageSection(),
                      const SizedBox(height: 24),
                      _buildFeaturesSection(),
                      const SizedBox(height: 24),
                      _buildAboutSection(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1916),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF8A00), Color(0xFFFFC876)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Configuration',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Configure Gemini AI for enhanced document processing',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildApiKeySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1916),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _apiKeyValid 
              ? Colors.green.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _apiKeyValid 
                      ? Colors.green.withOpacity(0.2)
                      : const Color(0xFFFF8A00).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _apiKeyValid ? Icons.verified : Icons.key,
                  color: _apiKeyValid ? Colors.green : const Color(0xFFFF8A00),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gemini API Key',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _apiKeyValid 
                          ? 'API key configured and validated'
                          : _currentApiKey != null 
                              ? 'Saved: ${_currentApiKey!.substring(0, 8)}...'
                              : 'Required for AI document analysis',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: _apiKeyValid 
                            ? Colors.green
                            : Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _showApiKeyInfo,
                icon: const Icon(Icons.help_outline, color: Color(0xFFFF8A00), size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _apiKeyController,
            obscureText: _isObscured,
            style: GoogleFonts.poppins(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter your Gemini API key...',
              hintStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.5)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFFF8A00)),
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                    icon: Icon(
                      _isObscured ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white.withOpacity(0.5),
                      size: 20,
                    ),
                  ),
                  if (_apiKeyValid)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveApiKey,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8A00),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          _apiKeyValid ? 'Update API Key' : 'Save API Key',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                ),
              ),
              if (_apiKeyValid) ...[
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _removeApiKey,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.1),
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: const Icon(Icons.delete, size: 20),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSection() {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF4B73FF).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.language,
              color: Color(0xFF4B73FF),
              size: 20,
            ),
          ),
          title: Text(
            'Language',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            languageProvider.currentLanguageNativeName,
            style: GoogleFonts.poppins(
              color: const Color(0xFFA8AEC5),
              fontSize: 14,
            ),
          ),
          trailing: Text(
            languageProvider.currentLanguageFlag,
            style: const TextStyle(fontSize: 24),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LanguageSettingsScreen(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1916),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.settings, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'AI Features',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFeatureItem(
            'Document Analysis',
            'Intelligent analysis of scanned documents',
            Icons.analytics,
            _apiKeyValid,
          ),
          _buildFeatureItem(
            'Structured Data Extraction',
            'Extract key information into structured format',
            Icons.data_object,
            _apiKeyValid,
          ),
          _buildFeatureItem(
            'Form Suggestions',
            'Auto-fill forms with extracted document data',
            Icons.auto_fix_high,
            _apiKeyValid,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description, IconData icon, bool enabled) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: enabled 
                  ? Colors.green.withOpacity(0.15)
                  : Colors.grey.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: enabled ? Colors.green : Colors.grey,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: enabled ? Colors.white : Colors.grey,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: enabled 
                        ? Colors.white.withOpacity(0.7)
                        : Colors.grey.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            enabled ? Icons.check_circle : Icons.lock,
            color: enabled ? Colors.green : Colors.grey,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1916),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.info, color: Colors.purple, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'About Fillora',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Fillora is an AI-powered document processing app that helps you scan, analyze, and extract information from documents using advanced OCR and machine learning.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.purple.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.security, color: Colors.purple, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your data and API keys are stored locally and never shared.',
                    style: GoogleFonts.poppins(
                      color: Colors.purple,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}