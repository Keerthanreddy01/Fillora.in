class FormFieldModel {
  final String id;
  final String name;
  final String displayName;
  final FormFieldType fieldType;
  final FormFieldCategory category;
  final String? value;
  final List<String> suggestions;
  final bool isRequired;
  final double confidence;
  final String? placeholder;
  final String? validationRegex;
  final List<String>? dropdownOptions;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FormFieldModel({
    required this.id,
    required this.name,
    required this.displayName,
    required this.fieldType,
    required this.category,
    this.value,
    this.suggestions = const [],
    this.isRequired = false,
    this.confidence = 0.0,
    this.placeholder,
    this.validationRegex,
    this.dropdownOptions,
    this.createdAt,
    this.updatedAt,
  });

  FormFieldModel copyWith({
    String? id,
    String? name,
    String? displayName,
    FormFieldType? fieldType,
    FormFieldCategory? category,
    String? value,
    List<String>? suggestions,
    bool? isRequired,
    double? confidence,
    String? placeholder,
    String? validationRegex,
    List<String>? dropdownOptions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FormFieldModel(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      fieldType: fieldType ?? this.fieldType,
      category: category ?? this.category,
      value: value ?? this.value,
      suggestions: suggestions ?? this.suggestions,
      isRequired: isRequired ?? this.isRequired,
      confidence: confidence ?? this.confidence,
      placeholder: placeholder ?? this.placeholder,
      validationRegex: validationRegex ?? this.validationRegex,
      dropdownOptions: dropdownOptions ?? this.dropdownOptions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'displayName': displayName,
      'fieldType': fieldType.toString(),
      'category': category.toString(),
      'value': value,
      'suggestions': suggestions,
      'isRequired': isRequired,
      'confidence': confidence,
      'placeholder': placeholder,
      'validationRegex': validationRegex,
      'dropdownOptions': dropdownOptions,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory FormFieldModel.fromJson(Map<String, dynamic> json) {
    return FormFieldModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      displayName: json['displayName'] ?? '',
      fieldType: FormFieldType.values.firstWhere(
        (type) => type.toString() == json['fieldType'],
        orElse: () => FormFieldType.text,
      ),
      category: FormFieldCategory.values.firstWhere(
        (cat) => cat.toString() == json['category'],
        orElse: () => FormFieldCategory.other,
      ),
      value: json['value'],
      suggestions: List<String>.from(json['suggestions'] ?? []),
      isRequired: json['isRequired'] ?? false,
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      placeholder: json['placeholder'],
      validationRegex: json['validationRegex'],
      dropdownOptions: json['dropdownOptions'] != null 
          ? List<String>.from(json['dropdownOptions'])
          : null,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  bool get isValid {
    if (!isRequired && (value == null || value!.isEmpty)) {
      return true;
    }
    
    if (isRequired && (value == null || value!.isEmpty)) {
      return false;
    }
    
    if (validationRegex != null && value != null) {
      return RegExp(validationRegex!).hasMatch(value!);
    }
    
    return true;
  }

  String get formattedValue {
    if (value == null || value!.isEmpty) return '';
    
    switch (fieldType) {
      case FormFieldType.phone:
        return _formatPhoneNumber(value!);
      case FormFieldType.date:
        return _formatDate(value!);
      case FormFieldType.email:
        return value!.toLowerCase().trim();
      default:
        return value!;
    }
  }

  String _formatPhoneNumber(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.length == 10) {
      return '${cleaned.substring(0, 3)}-${cleaned.substring(3, 6)}-${cleaned.substring(6)}';
    }
    return phone;
  }

  String _formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return '${parsed.day.toString().padLeft(2, '0')}/${parsed.month.toString().padLeft(2, '0')}/${parsed.year}';
    } catch (e) {
      return date;
    }
  }
}

enum FormFieldType {
  text,
  number,
  email,
  phone,
  date,
  dropdown,
  multiline,
  checkbox,
  radio,
  file,
  password,
  url,
  time
}

enum FormFieldCategory {
  personal,
  contact,
  identity,
  education,
  employment,
  family,
  financial,
  government,
  dates,
  other
}

class FormModel {
  final String id;
  final String name;
  final String description;
  final List<FormFieldModel> fields;
  final String formType;
  final double completionPercentage;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;

  FormModel({
    required this.id,
    required this.name,
    required this.description,
    required this.fields,
    required this.formType,
    required this.completionPercentage,
    required this.createdAt,
    this.updatedAt,
    this.metadata,
  });

  FormModel copyWith({
    String? id,
    String? name,
    String? description,
    List<FormFieldModel>? fields,
    String? formType,
    double? completionPercentage,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return FormModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      fields: fields ?? this.fields,
      formType: formType ?? this.formType,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'fields': fields.map((field) => field.toJson()).toList(),
      'formType': formType,
      'completionPercentage': completionPercentage,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory FormModel.fromJson(Map<String, dynamic> json) {
    return FormModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      fields: (json['fields'] as List<dynamic>?)
          ?.map((fieldJson) => FormFieldModel.fromJson(fieldJson))
          .toList() ?? [],
      formType: json['formType'] ?? 'unknown',
      completionPercentage: (json['completionPercentage'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
      metadata: json['metadata'],
    );
  }

  int get completedFieldsCount {
    return fields.where((field) => 
        field.value != null && field.value!.isNotEmpty).length;
  }

  int get requiredFieldsCount {
    return fields.where((field) => field.isRequired).length;
  }

  bool get isValid {
    return fields.every((field) => field.isValid);
  }

  double get actualCompletionPercentage {
    if (fields.isEmpty) return 0.0;
    return (completedFieldsCount / fields.length) * 100;
  }
}

extension FormFieldExtensions on FormFieldType {
  String get displayName {
    switch (this) {
      case FormFieldType.text:
        return 'Text';
      case FormFieldType.number:
        return 'Number';
      case FormFieldType.email:
        return 'Email';
      case FormFieldType.phone:
        return 'Phone';
      case FormFieldType.date:
        return 'Date';
      case FormFieldType.dropdown:
        return 'Dropdown';
      case FormFieldType.multiline:
        return 'Multi-line Text';
      case FormFieldType.checkbox:
        return 'Checkbox';
      case FormFieldType.radio:
        return 'Radio';
      case FormFieldType.file:
        return 'File';
      case FormFieldType.password:
        return 'Password';
      case FormFieldType.url:
        return 'URL';
      case FormFieldType.time:
        return 'Time';
    }
  }

  String get validationPattern {
    switch (this) {
      case FormFieldType.email:
        return r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
      case FormFieldType.phone:
        return r'^[\+]?[0-9\s\-\(\)]{10,}$';
      case FormFieldType.number:
        return r'^[0-9]+$';
      case FormFieldType.url:
        return r'^https?:\/\/[^\s]+$';
      default:
        return r'^.+$';
    }
  }
}

extension FormFieldCategoryExtensions on FormFieldCategory {
  String get displayName {
    switch (this) {
      case FormFieldCategory.personal:
        return 'Personal Information';
      case FormFieldCategory.contact:
        return 'Contact Details';
      case FormFieldCategory.identity:
        return 'Identity Documents';
      case FormFieldCategory.education:
        return 'Education';
      case FormFieldCategory.employment:
        return 'Employment';
      case FormFieldCategory.family:
        return 'Family Information';
      case FormFieldCategory.financial:
        return 'Financial Details';
      case FormFieldCategory.government:
        return 'Government Information';
      case FormFieldCategory.dates:
        return 'Important Dates';
      case FormFieldCategory.other:
        return 'Other';
    }
  }
}