import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen>
    with TickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();
  
  bool _isUploading = false;
  bool _isCompleted = false;
  String? _selectedFileName;
  File? _selectedFile;
  String _extractedText = '';
  double _uploadProgress = 0.0;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
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
      _showPermissionDialog('Camera permission is required to take photos.');
    }
  }

  void _showPermissionDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1916),
        title: Text(
          'Permission Required',
          style: GoogleFonts.poppins(color: Colors.white),
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
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text(
              'Settings',
              style: GoogleFonts.poppins(color: const Color(0xFFFF8A00)),
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
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image != null) {
        setState(() {
          _selectedFile = File(image.path);
          _selectedFileName = 'Captured_${DateTime.now().millisecondsSinceEpoch}.jpg';
        });
        await _processUpload();
      }
    } catch (e) {
      _showErrorDialog('Failed to take picture: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    await _requestPermissions();
    
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedFile = File(image.path);
          _selectedFileName = path.basename(image.path);
        });
        await _processUpload();
      }
    } catch (e) {
      _showErrorDialog('Failed to pick image: $e');
    }
  }

  Future<void> _pickFile() async {
    _showErrorDialog('File browser is temporarily disabled. Please use camera or gallery options.');
  }

  Future<void> _processUpload() async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    _progressController.reset();
    _progressController.forward();

    // Listen to animation progress
    _progressAnimation.addListener(() {
      setState(() {
        _uploadProgress = _progressAnimation.value;
      });
    });

    try {
      // Simulate file validation
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Extract text if it's an image
      if (_selectedFile != null && _isImageFile(_selectedFile!.path)) {
        await _extractTextFromFile(_selectedFile!.path);
      } else {
        _extractedText = 'File uploaded successfully. ${_selectedFileName}';
      }

      // Wait for animation to complete
      await Future.delayed(const Duration(seconds: 3));

      setState(() {
        _isUploading = false;
        _isCompleted = true;
      });

      _showSuccessDialog();
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      _showErrorDialog('Upload failed: $e');
    }
  }

  bool _isImageFile(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    return ['.jpg', '.jpeg', '.png'].contains(extension);
  }

  Future<void> _extractTextFromFile(String filePath) async {
    try {
      final inputImage = InputImage.fromFilePath(filePath);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      String text = recognizedText.text;
      
      setState(() {
        _extractedText = text.isNotEmpty ? text : 'No text detected in the image.';
      });
    } catch (e) {
      setState(() {
        _extractedText = 'Error extracting text: $e';
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1916),
        title: Text(
          'Error',
          style: GoogleFonts.poppins(color: Colors.red),
        ),
        content: Text(
          message,
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.poppins(color: const Color(0xFFFF8A00)),
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
        title: Text(
          'Upload Successful!',
          style: GoogleFonts.poppins(color: Colors.green),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'File: $_selectedFileName',
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
            ),
            if (_extractedText.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Found ${_extractedText.split(' ').length} words of text.',
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'View Details',
              style: GoogleFonts.poppins(color: const Color(0xFFFF8A00)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/ai-assistant');
            },
            child: Text(
              'Use in AI Assistant',
              style: GoogleFonts.poppins(color: Colors.green),
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
      body: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0D0C0A),
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
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _isCompleted ? _buildCompletedView() : 
                       _isUploading ? _buildUploadingView() : _buildUploadOptions(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Upload Document',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          if (_selectedFile != null && !_isUploading)
            IconButton(
              onPressed: () {
                setState(() {
                  _selectedFile = null;
                  _selectedFileName = null;
                  _extractedText = '';
                  _isCompleted = false;
                });
              },
              icon: const Icon(Icons.refresh, color: Colors.white),
            ),
        ],
      ),
    );
  }

  Widget _buildUploadOptions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Choose Upload Method',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Select how you\'d like to upload your document',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          
          // Upload options
          _buildUploadOption(
            icon: Icons.camera_alt_rounded,
            title: 'Take Photo',
            subtitle: 'Use camera to capture document',
            onTap: _takePicture,
          ),
          const SizedBox(height: 16),
          _buildUploadOption(
            icon: Icons.photo_library_rounded,
            title: 'Choose from Gallery',
            subtitle: 'Select image from your device',
            onTap: _pickFromGallery,
          ),
          const SizedBox(height: 16),
          _buildUploadOption(
            icon: Icons.folder_rounded,
            title: 'Browse Files',
            subtitle: 'Upload PDF, images, or document files',
            onTap: _pickFile,
          ),
          
          const SizedBox(height: 40),
          
          // Tips section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1916),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline_rounded,
                      color: Color(0xFFFF8A00),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Tips for best results',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '• Ensure good lighting and clear text\n• Keep document flat and within frame\n• Supported formats: JPG, PNG, PDF, TXT, DOCX\n• Maximum file size: 10MB',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.7),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1916),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFF8A00).withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFFF8A00),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withOpacity(0.3),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8A00), Color(0xFFFFC876)],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      value: _uploadProgress,
                      color: const Color(0xFF0D0C0A),
                      strokeWidth: 4,
                    ),
                  ),
                  Text(
                    '${(_uploadProgress * 100).toInt()}%',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D0C0A),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Processing Document...',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          if (_selectedFileName != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1916),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Text(
                _selectedFileName!,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFFF8A00),
                ),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            _uploadProgress < 0.3 ? 'Validating file...' :
            _uploadProgress < 0.7 ? 'Extracting text...' : 'Finalizing...',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 60),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF22C55E),
              size: 60,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Upload Successful!',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          if (_selectedFileName != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1916),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.description, color: Color(0xFFFF8A00), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selectedFileName!,
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  if (_extractedText.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Text extracted: ${_extractedText.split(' ').length} words',
                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
          const SizedBox(height: 40),
          
          // Action buttons
          Column(
            children: [
              // Continue to AI Assistant
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/ai-assistant');
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF8A00), Color(0xFFFFC876)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF8A00).withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        color: Color(0xFF0D0C0A),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Continue to AI Assistant',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF0D0C0A),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // View Extracted Text
              if (_extractedText.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _showExtractedTextDialog();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFFF8A00).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.text_fields,
                          color: Color(0xFFFF8A00),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'View Extracted Text',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFFF8A00),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showExtractedTextDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1916),
        title: Text(
          'Extracted Text',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        content: Container(
          width: double.maxFinite,
          constraints: const BoxConstraints(maxHeight: 300),
          child: SingleChildScrollView(
            child: Text(
              _extractedText,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(color: const Color(0xFFFF8A00)),
            ),
          ),
        ],
      ),
    );
  }
}