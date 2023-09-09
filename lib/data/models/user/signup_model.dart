import '../../entities/user/signup.dart';

class SignupModel extends Signup {
  const SignupModel(
      {required firstName,
      required lastName,
      required email,
      required password,
      required birthdate,
      required phoneNumber})
      : super(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            birthdate: birthdate,
            phoneNumber: phoneNumber);

  factory SignupModel.fromJson(Map<String, dynamic> json) => SignupModel(
        email: json["email"] ?? "Empty",
        password: json["password"] ?? "Empty",
        firstName: json["firstName"] ?? "Empty",
        lastName: json["lastName"] ?? "Empty",
        birthdate: json["birthdate"] ?? "Empty",
        phoneNumber: json["phoneNumber"] ?? "Empty",
      );
}
