/// User model for storing user information
/// Represents a user in the Fillora.in application with authentication and profile data
class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isGuest;
  final String preferredLanguage;
  final Map<String, dynamic> settings;

  const UserModel({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isGuest = false,
    this.preferredLanguage = 'en',
    this.settings = const {},
  });

  /// Creates a UserModel from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      photoUrl: json['photoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isGuest: json['isGuest'] as bool? ?? false,
      preferredLanguage: json['preferredLanguage'] as String? ?? 'en',
      settings: json['settings'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Converts the UserModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isGuest': isGuest,
      'preferredLanguage': preferredLanguage,
      'settings': settings,
    };
  }

  /// Creates a copy of the UserModel with updated fields
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isGuest,
    String? preferredLanguage,
    Map<String, dynamic>? settings,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isGuest: isGuest ?? this.isGuest,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      settings: settings ?? this.settings,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, isGuest: $isGuest)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}