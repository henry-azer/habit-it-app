class User {
  final String id;
  final String email;
  final String username;
  final String? displayName;
  final String? gender;
  final DateTime? birthday;
  final String? phoneNumber;
  final bool isAuthenticated;
  final bool isOnboardingCompleted;
  final bool emailVerified;
  final DateTime? lastSignInAt;
  final DateTime createdDate;
  final Map<String, dynamic>? metadata;

  const User({
    required this.id,
    required this.email,
    required this.username,
    this.displayName,
    this.gender,
    this.birthday,
    this.phoneNumber,
    required this.isAuthenticated,
    required this.isOnboardingCompleted,
    this.emailVerified = false,
    this.lastSignInAt,
    required this.createdDate,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'displayName': displayName,
      'gender': gender,
      'birthday': birthday?.toIso8601String(),
      'phoneNumber': phoneNumber,
      'isAuthenticated': isAuthenticated,
      'isOnboardingCompleted': isOnboardingCompleted,
      'emailVerified': emailVerified,
      'lastSignInAt': lastSignInAt?.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      displayName: map['displayName'] as String?,
      gender: map['gender'] as String?,
      birthday: map['birthday'] != null
          ? DateTime.parse(map['birthday'])
          : null,
      phoneNumber: map['phoneNumber'] as String?,
      isAuthenticated: map['isAuthenticated'] ?? false,
      isOnboardingCompleted: map['isOnboardingCompleted'] ?? false,
      emailVerified: map['emailVerified'] ?? false,
      lastSignInAt: map['lastSignInAt'] != null
          ? DateTime.parse(map['lastSignInAt'])
          : null,
      createdDate: DateTime.parse(
          map['createdDate'] ?? DateTime.now().toIso8601String()),
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? displayName,
    String? gender,
    DateTime? birthday,
    String? phoneNumber,
    bool? isAuthenticated,
    bool? isOnboardingCompleted,
    bool? emailVerified,
    DateTime? lastSignInAt,
    DateTime? createdDate,
    Map<String, dynamic>? metadata,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isOnboardingCompleted:
          isOnboardingCompleted ?? this.isOnboardingCompleted,
      emailVerified: emailVerified ?? this.emailVerified,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      createdDate: createdDate ?? this.createdDate,
      metadata: metadata ?? this.metadata,
    );
  }
}
