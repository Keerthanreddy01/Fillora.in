/// Chat message model for AI conversation
/// Represents a message in the chat interface between user and AI assistant
class ChatMessage {
  final String id;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final MessageStatus status;
  final Map<String, dynamic>? metadata;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.metadata,
  });

  /// Creates a ChatMessage from a JSON map
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      content: json['content'] as String,
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${json['type']}',
        orElse: () => MessageType.user,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: MessageStatus.values.firstWhere(
        (e) => e.toString() == 'MessageStatus.${json['status']}',
        orElse: () => MessageStatus.sent,
      ),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Converts the ChatMessage to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'status': status.toString().split('.').last,
      'metadata': metadata,
    };
  }

  /// Creates a copy of the ChatMessage with updated fields
  ChatMessage copyWith({
    String? id,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    MessageStatus? status,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, type: $type, content: ${content.substring(0, content.length > 50 ? 50 : content.length)}...)';
  }
}

/// Enum representing the type of chat message
enum MessageType {
  user,      // Message from user
  assistant, // Message from AI assistant
  system,    // System message
  error,     // Error message
}

/// Enum representing the status of a chat message
enum MessageStatus {
  sending,   // Message being sent
  sent,      // Message sent successfully
  delivered, // Message delivered
  failed,    // Message failed to send
  typing,    // AI is typing (for assistant messages)
}

/// Form data model for storing form information
/// Represents a form that can be filled using extracted document data
class FormModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final List<FormField> fields;
  final DateTime createdAt;
  final DateTime updatedAt;
  final FormStatus status;
  final Map<String, dynamic> filledData;
  final String? documentId;

  const FormModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.fields,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.filledData = const {},
    this.documentId,
  });

  /// Creates a FormModel from a JSON map
  factory FormModel.fromJson(Map<String, dynamic> json) {
    return FormModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      fields: (json['fields'] as List)
          .map((field) => FormField.fromJson(field as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      status: FormStatus.values.firstWhere(
        (e) => e.toString() == 'FormStatus.${json['status']}',
        orElse: () => FormStatus.draft,
      ),
      filledData: json['filledData'] as Map<String, dynamic>? ?? {},
      documentId: json['documentId'] as String?,
    );
  }

  /// Converts the FormModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'fields': fields.map((field) => field.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'status': status.toString().split('.').last,
      'filledData': filledData,
      'documentId': documentId,
    };
  }

  /// Creates a copy of the FormModel with updated fields
  FormModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    List<FormField>? fields,
    DateTime? createdAt,
    DateTime? updatedAt,
    FormStatus? status,
    Map<String, dynamic>? filledData,
    String? documentId,
  }) {
    return FormModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      fields: fields ?? this.fields,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      filledData: filledData ?? this.filledData,
      documentId: documentId ?? this.documentId,
    );
  }
}

/// Form field model representing individual fields in a form
class FormField {
  final String id;
  final String label;
  final String type;
  final bool isRequired;
  final String? placeholder;
  final String? defaultValue;
  final List<String>? options;
  final Map<String, dynamic>? validation;

  const FormField({
    required this.id,
    required this.label,
    required this.type,
    this.isRequired = false,
    this.placeholder,
    this.defaultValue,
    this.options,
    this.validation,
  });

  /// Creates a FormField from a JSON map
  factory FormField.fromJson(Map<String, dynamic> json) {
    return FormField(
      id: json['id'] as String,
      label: json['label'] as String,
      type: json['type'] as String,
      isRequired: json['isRequired'] as bool? ?? false,
      placeholder: json['placeholder'] as String?,
      defaultValue: json['defaultValue'] as String?,
      options: (json['options'] as List?)?.cast<String>(),
      validation: json['validation'] as Map<String, dynamic>?,
    );
  }

  /// Converts the FormField to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'type': type,
      'isRequired': isRequired,
      'placeholder': placeholder,
      'defaultValue': defaultValue,
      'options': options,
      'validation': validation,
    };
  }
}

/// Enum representing the status of a form
enum FormStatus {
  draft,      // Form is being edited
  completed,  // Form has been filled and completed
  submitted,  // Form has been submitted
  archived,   // Form has been archived
}