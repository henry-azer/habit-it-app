import '../../entities/authentication/signin.dart';

class SigninModel extends Signin {
  const SigninModel({
    required String email,
    required String password,
    required bool rememberme,
  }) : super(email: email, password: password, rememberme: rememberme);

  factory SigninModel.fromJson(Map<String, dynamic> json) => SigninModel(
        email: json["email"],
        password: json["password"],
        rememberme: json["rememberme"],
      );
}
