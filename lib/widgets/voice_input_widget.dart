import 'package:flutter/material.dart';
import 'dart:async';
import '../services/voice_input_service.dart';
import '../models/form_field_model.dart';

class VoiceInputWidget extends StatefulWidget {
  final FormFieldModel field;
  final Function(String) onTextInput;
  final VoidCallback? onVoiceInputComplete;
  final String? selectedLanguage;

  const VoiceInputWidget({
    super.key,
    required this.field,
    required this.onTextInput,
    this.onVoiceInputComplete,
    this.selectedLanguage,
  });

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget>
    with TickerProviderStateMixin {
  
  final VoiceInputService _voiceService = VoiceInputService();
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;
  
  StreamSubscription<String>? _wordsSubscription;
  StreamSubscription<bool>? _listeningSubscription;
  StreamSubscription<double>? _confidenceSubscription;
  StreamSubscription<String>? _errorSubscription;
  
  bool _isListening = false;
  String _currentText = '';
  double _confidence = 0.0;
  String? _error;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupVoiceListeners();
    _initializeVoiceService();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
  }

  void _setupVoiceListeners() {
    _wordsSubscription = _voiceService.wordsStream.listen((words) {
      setState(() {
        _currentText = words;
      });
      widget.onTextInput(words);
    });

    _listeningSubscription = _voiceService.listeningStream.listen((isListening) {
      setState(() {
        _isListening = isListening;
      });
      
      if (isListening) {
        _pulseController.repeat(reverse: true);
        _waveController.repeat();
      } else {
        _pulseController.stop();
        _waveController.stop();
        widget.onVoiceInputComplete?.call();
      }
    });

    _confidenceSubscription = _voiceService.confidenceStream.listen((confidence) {
      setState(() {
        _confidence = confidence;
      });
    });

    _errorSubscription = _voiceService.errorStream.listen((error) {
      setState(() {
        _error = error;
        _isListening = false;
      });
      _showErrorSnackBar(error);
    });
  }

  Future<void> _initializeVoiceService() async {
    final initialized = await _voiceService.initialize();
    setState(() {
      _isInitialized = initialized;
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _wordsSubscription?.cancel();
    _listeningSubscription?.cancel();
    _confidenceSubscription?.cancel();
    _errorSubscription?.cancel();
    super.dispose();
  }

  void _toggleVoiceInput() async {
    if (!_isInitialized) {
      await _initializeVoiceService();
      if (!_isInitialized) return;
    }

    if (_isListening) {
      await _voiceService.stopListening();
    } else {
      setState(() {
        _currentText = '';
        _confidence = 0.0;
        _error = null;
      });

      final languageCode = widget.selectedLanguage ?? 'en';
      await _voiceService.startListeningWithLanguage(languageCode);
    }
  }

  void _showErrorSnackBar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isListening 
              ? const Color(0xFFB037F5) 
              : Colors.white.withOpacity(0.2),
          width: _isListening ? 2 : 1,
        ),
        boxShadow: _isListening ? [
          BoxShadow(
            color: const Color(0xFFB037F5).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ] : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildVoiceButton(),
          if (_currentText.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildTranscriptionBox(),
          ],
          if (_confidence > 0) ...[
            const SizedBox(height: 8),
            _buildConfidenceIndicator(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.mic,
          color: _isListening ? const Color(0xFFB037F5) : Colors.white.withOpacity(0.7),
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Voice Input for ${widget.field.displayName}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (_isListening)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFB037F5).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Listening...',
              style: TextStyle(
                color: const Color(0xFFB037F5),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVoiceButton() {
    return Center(
      child: GestureDetector(
        onTap: _isInitialized ? _toggleVoiceInput : null,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isListening ? _pulseAnimation.value : 1.0,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: _isListening
                        ? [const Color(0xFFB037F5), const Color(0xFF3C78FF)]
                        : [Colors.grey.shade600, Colors.grey.shade700],
                  ),
                  boxShadow: _isListening ? [
                    BoxShadow(
                      color: const Color(0xFFB037F5).withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ] : [],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_isListening)
                      AnimatedBuilder(
                        animation: _waveAnimation,
                        builder: (context, child) {
                          return Container(
                            width: 80 + (20 * _waveAnimation.value),
                            height: 80 + (20 * _waveAnimation.value),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFB037F5).withOpacity(
                                  0.3 * (1 - _waveAnimation.value)
                                ),
                                width: 2,
                              ),
                            ),
                          );
                        },
                      ),
                    Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      color: Colors.white,
                      size: 32,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTranscriptionBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFB037F5).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transcribed Text:',
            style: TextStyle(
              color: const Color(0xFFB037F5),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _currentText.isEmpty ? 'Speak now...' : _currentText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontStyle: _currentText.isEmpty ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceIndicator() {
    return Row(
      children: [
        Text(
          'Confidence: ',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: _confidence,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              _confidence > 0.8 
                  ? Colors.green 
                  : _confidence > 0.6 
                      ? Colors.orange 
                      : Colors.red,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(_confidence * 100).toInt()}%',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// Voice Input Button for quick integration
class VoiceInputButton extends StatefulWidget {
  final Function(String) onTextInput;
  final String? currentValue;
  final String? languageCode;

  const VoiceInputButton({
    super.key,
    required this.onTextInput,
    this.currentValue,
    this.languageCode,
  });

  @override
  State<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends State<VoiceInputButton> {
  final VoiceInputService _voiceService = VoiceInputService();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _voiceService.listeningStream.listen((isListening) {
      setState(() {
        _isListening = isListening;
      });
    });

    _voiceService.wordsStream.listen((words) {
      widget.onTextInput(words);
    });
  }

  void _toggleVoiceInput() async {
    if (_isListening) {
      await _voiceService.stopListening();
    } else {
      await _voiceService.startListeningWithLanguage(
        widget.languageCode ?? 'en'
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isListening ? Icons.mic : Icons.mic_none,
        color: _isListening ? const Color(0xFFB037F5) : Colors.white70,
      ),
      onPressed: _toggleVoiceInput,
    );
  }
}