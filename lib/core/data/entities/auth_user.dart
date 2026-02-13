class AuthUser {
  final String id;
  final String email;
  final String? username;
  final bool emailVerified;
  final DateTime? lastSignInAt;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const AuthUser({
    required this.id,
    required this.email,
    this.username,
    required this.emailVerified,
    this.lastSignInAt,
    required this.createdAt,
    this.metadata,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String?,
      emailVerified: json['email_verified'] as bool? ?? false,
      lastSignInAt: json['last_sign_in_at'] != null
          ? DateTime.parse(json['last_sign_in_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'email_verified': emailVerified,
      'last_sign_in_at': lastSignInAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  AuthUser copyWith({
    String? id,
    String? email,
    String? username,
    bool? emailVerified,
    DateTime? lastSignInAt,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      emailVerified: emailVerified ?? this.emailVerified,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }
}
