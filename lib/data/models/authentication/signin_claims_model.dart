
import '../../entities/authentication/signin_claims.dart';

class SigninClaimsModel extends SigninClaims {
  const SigninClaimsModel({
    required String accessToken,
    required int accessTokenExpireDate,
    required String refreshToken,
    required int refreshTokenExpireDate,
  }) : super(
            accessToken: accessToken,
            accessTokenExpireDate: accessTokenExpireDate,
            refreshToken: refreshToken,
            refreshTokenExpireDate: refreshTokenExpireDate);

  factory SigninClaimsModel.fromJson(Map<String, dynamic> json) =>
      SigninClaimsModel(
        accessToken: json["accessToken"],
        accessTokenExpireDate: json["accessTokenExpireDate"],
        refreshToken: json["refreshToken"],
        refreshTokenExpireDate: json["refreshTokenExpireDate"],
      );
}
