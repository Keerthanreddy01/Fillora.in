import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Language Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4B73FF), Color(0xFF3A5FE7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4B73FF).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.language,
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Choose Your Language',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Current: ${languageProvider.currentLanguageNativeName}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Language options
                const Text(
                  'Available Languages',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Language list
                ...languageProvider.supportedLanguages.entries.map(
                  (entry) => _buildLanguageOption(
                    context,
                    languageProvider,
                    entry.key,
                    entry.value,
                  ),
                ).toList(),
                
                const SizedBox(height: 32),
                
                // Auto-detect section
                _buildAutoDetectSection(context, languageProvider),
                
                const SizedBox(height: 32),
                
                // Language info section
                _buildLanguageInfoSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    LanguageProvider languageProvider,
    String languageCode,
    Map<String, String> languageInfo,
  ) {
    final isSelected = languageProvider.currentLanguageCode == languageCode;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF4B73FF).withOpacity(0.2) : const Color(0xFF1A1D29),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFF4B73FF) : Colors.transparent,
          width: 2,
        ),
        boxShadow: isSelected ? [
          BoxShadow(
            color: const Color(0xFF4B73FF).withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2D3A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              languageInfo['flag'] ?? '🌐',
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Text(
          languageInfo['nativeName'] ?? 'Unknown',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        subtitle: Text(
          languageInfo['name'] ?? 'Unknown',
          style: const TextStyle(
            color: Color(0xFFA8AEC5),
            fontSize: 14,
          ),
        ),
        trailing: isSelected
            ? const Icon(
                Icons.check_circle,
                color: Color(0xFF4B73FF),
                size: 24,
              )
            : const Icon(
                Icons.radio_button_unchecked,
                color: Color(0xFFA8AEC5),
                size: 24,
              ),
        onTap: () async {
          await languageProvider.changeLanguage(languageCode);
          
          // Show success message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Language changed to ${languageInfo['nativeName']}',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: const Color(0xFF4B73FF),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildAutoDetectSection(BuildContext context, LanguageProvider languageProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D29),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
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
                  color: const Color(0xFF2A2D3A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_fix_high,
                  color: Color(0xFF4B73FF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Auto-Detect Language',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Automatically set language based on your system settings',
            style: TextStyle(
              color: Color(0xFFA8AEC5),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await languageProvider.setSystemLanguage();
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Language set to ${languageProvider.currentLanguageNativeName}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: const Color(0xFF4B73FF),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A2D3A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Use System Language',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D29),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
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
                  color: const Color(0xFF2A2D3A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Color(0xFF4B73FF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Language Support',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Fillora supports multiple languages for:',
            style: TextStyle(
              color: Color(0xFFA8AEC5),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          const _InfoItem(text: '• User interface and navigation'),
          const _InfoItem(text: '• Form field recognition and labeling'),
          const _InfoItem(text: '• AI-powered suggestions and assistance'),
          const _InfoItem(text: '• Document type detection'),
          const _InfoItem(text: '• Voice input and commands'),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String text;
  
  const _InfoItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFBFC3D9),
          fontSize: 13,
        ),
      ),
    );
  }
}