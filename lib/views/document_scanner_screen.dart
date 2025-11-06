import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../services/gemini_service.dart';
import 'smart_form_editor_screen.dart';
import 'dart:io';

class DocumentScannerScreen extends StatefulWidget {
  const DocumentScannerScreen({super.key});

  @override
  State<DocumentScannerScreen> createState() => _DocumentScannerScreenState();
}

class _DocumentScannerScreenState extends State<DocumentScannerScreen>
    with TickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();
  
  File? _selectedImage;
  String _extractedText = '';
  String _geminiAnalysis = '';
  Map<String, dynamic>? _structuredData;
  bool _isProcessing = false;
  bool _isAnalyzing = false;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  String _selectedDocumentType = 'ID Document';
  final List<String> _documentTypes = [
    'ID Document',
    'Passport',
    'Driver License', 
    'Bank Statement',
    'Tax Document',
    'Insurance Card',
    'Medical Record',
    'Other Document'
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
      Permission.photos,
    ].request();

    if (statuses[Permission.camera] != PermissionStatus.granted) {
      _showPermissionDialog('Camera permission is required to scan documents.');
    }
  }

  void _showPermissionDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1916),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Permission Required',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8A00),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Settings',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _takePicture() async {
    await _requestPermissions();
    
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _extractedText = '';
          _geminiAnalysis = '';
          _structuredData = null;
          _isProcessing = true;
        });
        await _processImage(image.path);
      }
    } catch (e) {
      _showErrorDialog('Failed to take picture', e.toString());
    }
  }

  Future<void> _pickFromGallery() async {
    await _requestPermissions();
    
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _extractedText = '';
          _geminiAnalysis = '';
          _structuredData = null;
          _isProcessing = true;
        });
        await _processImage(image.path);
      }
    } catch (e) {
      _showErrorDialog('Failed to pick image', e.toString());
    }
  }

  Future<void> _processImage(String imagePath) async {
    try {
      // Step 1: OCR Text Extraction
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      String text = recognizedText.text;
      
      setState(() {
        _extractedText = text.isNotEmpty ? text : 'No text detected in the image.';
        _isProcessing = false;
        _isAnalyzing = true;
      });

      if (text.isNotEmpty) {
        // Step 2: Gemini AI Analysis (if API key is available)
        try {
          final analysis = await GeminiService.analyzeDocument(
            extractedText: text,
            documentType: _selectedDocumentType,
          );
          
          final structured = await GeminiService.extractStructuredData(
            extractedText: text,
            documentType: _selectedDocumentType,
          );
          
          setState(() {
            _geminiAnalysis = analysis;
            _structuredData = structured;
            _isAnalyzing = false;
          });
          
          _showSuccessDialog();
        } catch (e) {
          setState(() {
            _geminiAnalysis = 'AI Analysis unavailable. Please set Gemini API key.';
            _isAnalyzing = false;
          });
          _showSuccessDialog();
        }
      }
    } catch (e) {
      setState(() {
        _extractedText = 'Error extracting text: $e';
        _isProcessing = false;
        _isAnalyzing = false;
      });
      _showErrorDialog('Processing failed', e.toString());
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1916),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
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
              'Document Processed!',
              style: GoogleFonts.poppins(color: Colors.green, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Successfully extracted and analyzed your document.',
              style: GoogleFonts.poppins(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFF8A00).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFF8A00).withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Words found: ${_extractedText.split(' ').length}',
                    style: GoogleFonts.poppins(color: const Color(0xFFFF8A00), fontSize: 12),
                  ),
                  if (_structuredData != null && _structuredData!['parsed'] == true)
                    Text(
                      'Structured data extracted ✓',
                      style: GoogleFonts.poppins(color: Colors.green, fontSize: 12),
                    ),
                  if (_geminiAnalysis.isNotEmpty && !_geminiAnalysis.contains('unavailable'))
                    Text(
                      'AI analysis completed ✓',
                      style: GoogleFonts.poppins(color: Colors.green, fontSize: 12),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'View Results',
              style: GoogleFonts.poppins(color: const Color(0xFFFF8A00)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _openSmartFormEditor();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Create Smart Form',
              style: GoogleFonts.poppins(color: Colors.white),
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
          'AI Document Scanner',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_selectedImage != null)
            IconButton(
              onPressed: () {
                setState(() {
                  _selectedImage = null;
                  _extractedText = '';
                  _geminiAnalysis = '';
                  _structuredData = null;
                  _isProcessing = false;
                  _isAnalyzing = false;
                });
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8A00).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.refresh, color: Color(0xFFFF8A00), size: 20),
              ),
            ),
        ],
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
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_selectedImage == null) ...[
                          _buildDocumentTypeSelector(),
                          const SizedBox(height: 24),
                          _buildInstructions(),
                          const SizedBox(height: 32),
                          _buildScanOptions(),
                        ] else ...[
                          _buildImagePreview(),
                          const SizedBox(height: 24),
                          if (_isProcessing)
                            _buildProcessingIndicator()
                          else if (_isAnalyzing)
                            _buildAnalyzingIndicator()
                          else ...[
                            if (_extractedText.isNotEmpty) _buildExtractedText(),
                            const SizedBox(height: 16),
                            if (_geminiAnalysis.isNotEmpty) _buildAIAnalysis(),
                            const SizedBox(height: 16),
                            if (_structuredData != null) _buildStructuredData(),
                          ],
                          const SizedBox(height: 24),
                          _buildActionButtons(),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentTypeSelector() {
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
                  color: const Color(0xFFFF8A00).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.category, color: Color(0xFFFF8A00), size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Document Type',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFF8A00).withOpacity(0.3)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedDocumentType,
                dropdownColor: const Color(0xFF1A1916),
                icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFFFF8A00)),
                style: GoogleFonts.poppins(color: Colors.white),
                items: _documentTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type, style: GoogleFonts.poppins(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedDocumentType = newValue;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
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
                  color: const Color(0xFFFF8A00).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome, color: Color(0xFFFF8A00), size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'AI-Powered Scanning',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInstructionStep('1', 'Capture or select your document image'),
          _buildInstructionStep('2', 'OCR extracts text automatically'),
          _buildInstructionStep('3', 'AI analyzes and structures the data'),
          _buildInstructionStep('4', 'Use extracted data in forms instantly'),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8A00), Color(0xFFFFC876)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0D0C0A),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanOptions() {
    return Column(
      children: [
        _buildScanButton(
          icon: Icons.camera_alt,
          title: 'Take Photo',
          subtitle: 'Use camera to scan document',
          gradient: const LinearGradient(colors: [Color(0xFFFF8A00), Color(0xFFFFC876)]),
          onTap: _takePicture,
        ),
        const SizedBox(height: 16),
        _buildScanButton(
          icon: Icons.photo_library,
          title: 'Choose from Gallery',
          subtitle: 'Select existing photo',
          gradient: LinearGradient(colors: [Colors.blue.shade600, Colors.blue.shade400]),
          onTap: _pickFromGallery,
        ),
      ],
    );
  }

  Widget _buildScanButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient.colors.first.withOpacity(0.1) == gradient.colors.first.withOpacity(0.1) 
              ? LinearGradient(
                  colors: gradient.colors.map((c) => c.withOpacity(0.1)).toList(),
                )
              : gradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: gradient.colors.first.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF8A00).withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          height: 250,
        ),
      ),
    );
  }

  Widget _buildProcessingIndicator() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1916),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF8A00)),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Extracting text...',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Using OCR to recognize text in your document',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzingIndicator() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1916),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8A00), Color(0xFFFFC876)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'AI is analyzing...',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Gemini AI is extracting structured data',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildExtractedText() {
    return Container(
      width: double.infinity,
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
              const Icon(Icons.text_fields, color: Color(0xFFFF8A00), size: 20),
              const SizedBox(width: 8),
              Text(
                'Extracted Text',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8A00).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_extractedText.split(' ').length} words',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: const Color(0xFFFF8A00),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 150),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: SingleChildScrollView(
              child: Text(
                _extractedText,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIAnalysis() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1916),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF8A00).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF8A00), Color(0xFFFFC876)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                'AI Analysis',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8A00).withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFF8A00).withOpacity(0.2)),
            ),
            child: SingleChildScrollView(
              child: Text(
                _geminiAnalysis,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStructuredData() {
    if (_structuredData == null) return const SizedBox.shrink();
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1916),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.data_object, color: Colors.green, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                'Structured Data',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _structuredData!.entries
                  .where((entry) => entry.key != 'raw_response' && entry.key != 'parsed')
                  .map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              constraints: const BoxConstraints(minWidth: 80),
                              child: Text(
                                '${entry.key.replaceAll('_', ' ').toUpperCase()}:',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                entry.value.toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildActionButton(
          title: 'Create Smart Form',
          subtitle: 'Auto-fill form fields with AI',
          icon: Icons.smart_display,
          color: Colors.green,
          onTap: _openSmartFormEditor,
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          title: 'Use in AI Assistant',
          subtitle: 'Get AI help with the data',
          icon: Icons.psychology,
          color: const Color(0xFFFF8A00),
          onTap: () {
            Navigator.pushNamed(context, '/ai-assistant');
          },
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          title: 'Scan Another Document',
          subtitle: 'Take or select another photo',
          icon: Icons.add_a_photo,
          color: Colors.blue,
          onTap: () {
            setState(() {
              _selectedImage = null;
              _extractedText = '';
              _geminiAnalysis = '';
              _structuredData = null;
              _isProcessing = false;
              _isAnalyzing = false;
            });
          },
        ),
      ],
    );
  }

  void _openSmartFormEditor() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SmartFormEditorScreen(
          extractedText: _extractedText,
          documentType: _selectedDocumentType,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
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
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}