/// Document model for storing uploaded document information
/// Represents a document that has been uploaded and processed by OCR
class DocumentModel {
  final String id;
  final String userId;
  final String fileName;
  final String filePath;
  final String fileType;
  final int fileSize;
  final DateTime uploadedAt;
  final DocumentStatus status;
  final Map<String, dynamic> extractedData;
  final double confidence;
  final List<String> detectedLanguages;

  const DocumentModel({
    required this.id,
    required this.userId,
    required this.fileName,
    required this.filePath,
    required this.fileType,
    required this.fileSize,
    required this.uploadedAt,
    required this.status,
    this.extractedData = const {},
    this.confidence = 0.0,
    this.detectedLanguages = const [],
  });

  /// Creates a DocumentModel from a JSON map
  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      fileName: json['fileName'] as String,
      filePath: json['filePath'] as String,
      fileType: json['fileType'] as String,
      fileSize: json['fileSize'] as int,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      status: DocumentStatus.values.firstWhere(
        (e) => e.toString() == 'DocumentStatus.${json['status']}',
        orElse: () => DocumentStatus.pending,
      ),
      extractedData: json['extractedData'] as Map<String, dynamic>? ?? {},
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      detectedLanguages: List<String>.from(json['detectedLanguages'] as List? ?? []),
    );
  }

  /// Converts the DocumentModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fileName': fileName,
      'filePath': filePath,
      'fileType': fileType,
      'fileSize': fileSize,
      'uploadedAt': uploadedAt.toIso8601String(),
      'status': status.toString().split('.').last,
      'extractedData': extractedData,
      'confidence': confidence,
      'detectedLanguages': detectedLanguages,
    };
  }

  /// Creates a copy of the DocumentModel with updated fields
  DocumentModel copyWith({
    String? id,
    String? userId,
    String? fileName,
    String? filePath,
    String? fileType,
    int? fileSize,
    DateTime? uploadedAt,
    DocumentStatus? status,
    Map<String, dynamic>? extractedData,
    double? confidence,
    List<String>? detectedLanguages,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      fileType: fileType ?? this.fileType,
      fileSize: fileSize ?? this.fileSize,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      status: status ?? this.status,
      extractedData: extractedData ?? this.extractedData,
      confidence: confidence ?? this.confidence,
      detectedLanguages: detectedLanguages ?? this.detectedLanguages,
    );
  }

  @override
  String toString() {
    return 'DocumentModel(id: $id, fileName: $fileName, status: $status)';
  }
}

/// Enum representing the status of document processing
enum DocumentStatus {
  pending,    // Document uploaded but not processed
  processing, // OCR extraction in progress
  completed,  // Processing completed successfully
  failed,     // Processing failed
  error,      // Error occurred during processing
}

/// Extension for DocumentStatus to get human-readable strings
extension DocumentStatusExtension on DocumentStatus {
  String get displayName {
    switch (this) {
      case DocumentStatus.pending:
        return 'Pending';
      case DocumentStatus.processing:
        return 'Processing';
      case DocumentStatus.completed:
        return 'Completed';
      case DocumentStatus.failed:
        return 'Failed';
      case DocumentStatus.error:
        return 'Error';
    }
  }

  String get description {
    switch (this) {
      case DocumentStatus.pending:
        return 'Document is waiting to be processed';
      case DocumentStatus.processing:
        return 'Extracting text from document';
      case DocumentStatus.completed:
        return 'Text extraction completed successfully';
      case DocumentStatus.failed:
        return 'Failed to extract text from document';
      case DocumentStatus.error:
        return 'An error occurred during processing';
    }
  }
}