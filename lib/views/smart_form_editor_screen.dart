import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/form_field_model.dart';
import '../services/gemini_service.dart';
import '../widgets/gradient_button.dart';
import '../widgets/voice_input_widget.dart';

class SmartFormEditorScreen extends StatefulWidget {
  final String extractedText;
  final String? documentType;
  final FormModel? existingForm;

  const SmartFormEditorScreen({
    super.key,
    required this.extractedText,
    this.documentType,
    this.existingForm,
  });

  @override
  State<SmartFormEditorScreen> createState() => _SmartFormEditorScreenState();
}

class _SmartFormEditorScreenState extends State<SmartFormEditorScreen> 
    with TickerProviderStateMixin {
  
  late TabController _tabController;
  FormModel? _currentForm;
  Map<String, TextEditingController> _controllers = {};
  Map<String, FocusNode> _focusNodes = {};
  bool _isLoading = true;
  bool _isAnalyzing = false;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      Map<String, dynamic> formData;
      
      if (widget.existingForm != null) {
        // Use existing form
        _currentForm = widget.existingForm;
        formData = {
          'detected_fields': {},
          'form_type_detected': widget.existingForm!.formType,
          'completion_percentage': widget.existingForm!.completionPercentage,
        };
      } else {
        // Analyze document and create new form
        formData = await GeminiService.detectFormFields(
          extractedText: widget.extractedText,
          formType: widget.documentType,
        );

        _currentForm = _createFormFromAIData(formData);
      }

      _setupControllers();
      _setupTabController();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to analyze document: $e';
        _isLoading = false;
      });
    }
  }

  FormModel _createFormFromAIData(Map<String, dynamic> data) {
    final detectedFields = data['detected_fields'] as Map<String, dynamic>? ?? {};
    final formType = data['form_type_detected'] as String? ?? 'Unknown';
    
    List<FormFieldModel> fields = [];
    
    // Convert AI detected fields to FormFieldModel objects
    detectedFields.forEach((fieldName, fieldData) {
      if (fieldData is Map<String, dynamic>) {
        final field = FormFieldModel(
          id: DateTime.now().millisecondsSinceEpoch.toString() + fieldName,
          name: fieldName,
          displayName: _formatFieldName(fieldName),
          fieldType: _parseFieldType(fieldData['field_type'] as String?),
          category: _parseFieldCategory(fieldData['category'] as String?),
          value: fieldData['value'] as String?,
          confidence: (fieldData['confidence'] as num?)?.toDouble() ?? 0.0,
          isRequired: _isCommonRequiredField(fieldName),
          placeholder: _generatePlaceholder(fieldName),
          validationRegex: _getValidationRegex(fieldName),
          createdAt: DateTime.now(),
        );
        fields.add(field);
      }
    });

    // Add common missing fields
    final missingFields = data['missing_common_fields'] as List<dynamic>? ?? [];
    for (String missingField in missingFields) {
      if (!fields.any((f) => f.name.toLowerCase() == missingField.toLowerCase())) {
        fields.add(_createMissingField(missingField));
      }
    }

    return FormModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '$formType Form',
      description: 'Auto-generated form from document analysis',
      fields: fields,
      formType: formType,
      completionPercentage: (data['completion_percentage'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.now(),
    );
  }

  void _setupControllers() {
    _controllers.clear();
    _focusNodes.clear();
    
    for (final field in _currentForm!.fields) {
      _controllers[field.id] = TextEditingController(text: field.value ?? '');
      _focusNodes[field.id] = FocusNode();
    }
  }

  void _setupTabController() {
    final categories = _currentForm!.fields
        .map((f) => f.category)
        .toSet()
        .toList();
    
    _tabController = TabController(
      length: categories.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controllers.values.forEach((controller) => controller.dispose());
    _focusNodes.values.forEach((node) => node.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Smart Form Editor',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (!_isLoading && _currentForm != null)
            IconButton(
              icon: const Icon(Icons.auto_fix_high, color: Color(0xFFB037F5)),
              onPressed: _enhanceFormWithAI,
            ),
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _isLoading ? null : _saveForm,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF0F1419),
            ],
          ),
        ),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFB037F5)),
            SizedBox(height: 16),
            Text(
              'Analyzing document with AI...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GradientButton(
              text: 'Retry',
              onPressed: _initializeForm,
            ),
          ],
        ),
      );
    }

    if (_currentForm == null) {
      return const Center(
        child: Text(
          'No form data available',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    return Column(
      children: [
        _buildFormHeader(),
        _buildTabBar(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _buildTabViews(),
          ),
        ),
        _buildBottomActions(),
      ],
    );
  }

  Widget _buildFormHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _currentForm!.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _currentForm!.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          _buildProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final completionPercentage = _currentForm!.actualCompletionPercentage;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Completion: ${completionPercentage.toInt()}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${_currentForm!.completedFieldsCount}/${_currentForm!.fields.length} fields',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: completionPercentage / 100,
          backgroundColor: Colors.white.withOpacity(0.2),
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFB037F5)),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    final categories = _currentForm!.fields
        .map((f) => f.category)
        .toSet()
        .toList();

    return Container(
      color: const Color(0xFF1A1A2E),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: const Color(0xFFB037F5),
        labelColor: const Color(0xFFB037F5),
        unselectedLabelColor: Colors.white.withOpacity(0.7),
        tabs: categories.map((category) => Tab(
          text: category.displayName,
        )).toList(),
      ),
    );
  }

  List<Widget> _buildTabViews() {
    final categories = _currentForm!.fields
        .map((f) => f.category)
        .toSet()
        .toList();

    return categories.map((category) {
      final categoryFields = _currentForm!.fields
          .where((f) => f.category == category)
          .toList();

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categoryFields.length,
        itemBuilder: (context, index) {
          return _buildFormField(categoryFields[index]);
        },
      );
    }).toList();
  }

  Widget _buildFormField(FormFieldModel field) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  field.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (field.isRequired)
                const Text(
                  '*',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              if (field.confidence > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getConfidenceColor(field.confidence),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${(field.confidence * 100).toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          _buildFieldInput(field),
          if (field.suggestions.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildSuggestions(field),
          ],
        ],
      ),
    );
  }

  Widget _buildFieldInput(FormFieldModel field) {
    final controller = _controllers[field.id]!;
    final focusNode = _focusNodes[field.id]!;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: focusNode.hasFocus 
              ? const Color(0xFFB037F5) 
              : Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        style: const TextStyle(color: Colors.white),
        keyboardType: _getKeyboardType(field.fieldType),
        maxLines: field.fieldType == FormFieldType.multiline ? 3 : 1,
        onChanged: (value) => _updateFieldValue(field.id, value),
        decoration: InputDecoration(
          hintText: field.placeholder,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (field.suggestions.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.auto_awesome, color: Color(0xFFB037F5)),
                  onPressed: () => _showSuggestions(field),
                ),
              IconButton(
                icon: const Icon(Icons.mic, color: Colors.white70),
                onPressed: () => _startVoiceInput(field),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestions(FormFieldModel field) {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: field.suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = field.suggestions[index];
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(
                suggestion,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              backgroundColor: const Color(0xFF2A2A3E),
              onPressed: () => _applySuggestion(field, suggestion),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _previewForm,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFB037F5)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Preview',
                style: TextStyle(color: Color(0xFFB037F5)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: GradientButton(
              text: 'Save Form',
              onPressed: _saveForm,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  FormFieldType _parseFieldType(String? type) {
    switch (type?.toLowerCase()) {
      case 'email': return FormFieldType.email;
      case 'phone': return FormFieldType.phone;
      case 'number': return FormFieldType.number;
      case 'date': return FormFieldType.date;
      case 'dropdown': return FormFieldType.dropdown;
      default: return FormFieldType.text;
    }
  }

  FormFieldCategory _parseFieldCategory(String? category) {
    switch (category?.toLowerCase()) {
      case 'personal': return FormFieldCategory.personal;
      case 'contact': return FormFieldCategory.contact;
      case 'identity': return FormFieldCategory.identity;
      case 'education': return FormFieldCategory.education;
      case 'employment': return FormFieldCategory.employment;
      case 'family': return FormFieldCategory.family;
      case 'financial': return FormFieldCategory.financial;
      case 'government': return FormFieldCategory.government;
      case 'dates': return FormFieldCategory.dates;
      default: return FormFieldCategory.other;
    }
  }

  String _formatFieldName(String name) {
    return name.split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  bool _isCommonRequiredField(String fieldName) {
    final requiredFields = ['name', 'email', 'phone', 'date_of_birth'];
    return requiredFields.any((field) => 
        fieldName.toLowerCase().contains(field));
  }

  String _generatePlaceholder(String fieldName) {
    switch (fieldName.toLowerCase()) {
      case 'name': return 'Enter your full name';
      case 'email': return 'Enter your email address';
      case 'phone': return 'Enter your phone number';
      case 'address': return 'Enter your address';
      default: return 'Enter ${_formatFieldName(fieldName).toLowerCase()}';
    }
  }

  String? _getValidationRegex(String fieldName) {
    switch (fieldName.toLowerCase()) {
      case 'email': return FormFieldType.email.validationPattern;
      case 'phone': return FormFieldType.phone.validationPattern;
      default: return null;
    }
  }

  FormFieldModel _createMissingField(String fieldName) {
    return FormFieldModel(
      id: DateTime.now().millisecondsSinceEpoch.toString() + fieldName,
      name: fieldName,
      displayName: _formatFieldName(fieldName),
      fieldType: FormFieldType.text,
      category: FormFieldCategory.other,
      isRequired: _isCommonRequiredField(fieldName),
      placeholder: _generatePlaceholder(fieldName),
      createdAt: DateTime.now(),
    );
  }

  TextInputType _getKeyboardType(FormFieldType fieldType) {
    switch (fieldType) {
      case FormFieldType.email: return TextInputType.emailAddress;
      case FormFieldType.phone: return TextInputType.phone;
      case FormFieldType.number: return TextInputType.number;
      case FormFieldType.url: return TextInputType.url;
      default: return TextInputType.text;
    }
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.orange;
    return Colors.red;
  }

  void _updateFieldValue(String fieldId, String value) {
    final fieldIndex = _currentForm!.fields.indexWhere((f) => f.id == fieldId);
    if (fieldIndex != -1) {
      final updatedField = _currentForm!.fields[fieldIndex].copyWith(
        value: value,
        updatedAt: DateTime.now(),
      );
      
      final updatedFields = List<FormFieldModel>.from(_currentForm!.fields);
      updatedFields[fieldIndex] = updatedField;
      
      setState(() {
        _currentForm = _currentForm!.copyWith(
          fields: updatedFields,
          updatedAt: DateTime.now(),
        );
      });
    }
  }

  void _applySuggestion(FormFieldModel field, String suggestion) {
    _controllers[field.id]?.text = suggestion;
    _updateFieldValue(field.id, suggestion);
  }

  void _showSuggestions(FormFieldModel field) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Suggestions for ${field.displayName}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...field.suggestions.map((suggestion) => ListTile(
              title: Text(
                suggestion,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: const Icon(Icons.add, color: Color(0xFFB037F5)),
              onTap: () {
                _applySuggestion(field, suggestion);
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _startVoiceInput(FormFieldModel field) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: VoiceInputWidget(
          field: field,
          onTextInput: (text) {
            _controllers[field.id]?.text = text;
            _updateFieldValue(field.id, text);
          },
          onVoiceInputComplete: () {
            Navigator.pop(context);
          },
          selectedLanguage: 'en', // TODO: Use selected app language
        ),
      ),
    );
  }

  void _enhanceFormWithAI() async {
    setState(() {
      _isAnalyzing = true;
    });

    try {
      // Get enhanced suggestions for empty fields
      for (final field in _currentForm!.fields) {
        if (field.value == null || field.value!.isEmpty) {
          final suggestions = await GeminiService.generateSmartSuggestions(
            fieldName: field.name,
            fieldType: field.fieldType.toString(),
            extractedText: widget.extractedText,
            currentValue: field.value,
          );
          
          if (suggestions.isNotEmpty) {
            final updatedField = field.copyWith(suggestions: suggestions);
            final fieldIndex = _currentForm!.fields.indexOf(field);
            final updatedFields = List<FormFieldModel>.from(_currentForm!.fields);
            updatedFields[fieldIndex] = updatedField;
            
            setState(() {
              _currentForm = _currentForm!.copyWith(fields: updatedFields);
            });
          }
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Form enhanced with AI suggestions!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to enhance form: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  void _previewForm() {
    // TODO: Navigate to form preview screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Form preview feature coming soon!'),
        backgroundColor: Color(0xFFB037F5),
      ),
    );
  }

  void _saveForm() {
    // TODO: Implement form saving functionality
    Navigator.pop(context, _currentForm);
  }
}