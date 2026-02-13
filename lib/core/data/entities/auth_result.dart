import 'package:habit_it/core/data/entities/auth_user.dart';
import 'package:habit_it/core/data/entities/auth_failure.dart';

class AuthResult<T> {
  final T? data;
  final AuthFailure? failure;

  const AuthResult._({this.data, this.failure});

  factory AuthResult.success(T data) {
    return AuthResult._(data: data);
  }

  factory AuthResult.failure(AuthFailure failure) {
    return AuthResult._(failure: failure);
  }

  bool get isSuccess => failure == null;
  bool get isFailure => failure != null;

  R fold<R>({
    required R Function(T? data) onSuccess,
    required R Function(AuthFailure failure) onFailure,
  }) {
    if (isSuccess) {
      return onSuccess(data);
    } else {
      return onFailure(failure!);
    }
  }
}

class AuthSession {
  final AuthUser user;
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  const AuthSession({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt.toIso8601String(),
    };
  }

  AuthSession copyWith({
    AuthUser? user,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
  }) {
    return AuthSession(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
