import 'package:equatable/equatable.dart';

class SigninClaims extends Equatable {
  final String accessToken;
  final int accessTokenExpireDate;
  final String refreshToken;
  final int refreshTokenExpireDate;

  const SigninClaims(
      {required this.accessToken,
      required this.accessTokenExpireDate,
      required this.refreshToken,
      required this.refreshTokenExpireDate});

  @override
  List<Object?> get props => [accessToken, refreshToken];

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "accessTokenExpireDate": accessTokenExpireDate,
        "refreshToken": refreshToken,
        "refreshTokenExpireDate": refreshTokenExpireDate,
      };
}
