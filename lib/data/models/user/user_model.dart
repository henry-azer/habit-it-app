import '../../../core/utils/app_strings.dart';
import '../../entities/user/user.dart';

class UserModel extends User {
  const UserModel(
      {required firstName,
      required lastName,
      required id,
      required email,
      required password,
      required birthdate,
      required phoneNumber})
      : super(
            firstName: firstName,
            lastName: lastName,
            id: id,
            email: email,
            password: password,
            birthdate: birthdate,
            phoneNumber: phoneNumber);

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        email: json["email"] ?? AppStrings.undefined,
        password: json["password"] ?? AppStrings.undefined,
        firstName: json["firstName"] ?? AppStrings.undefined,
        lastName: json["lastName"] ?? AppStrings.undefined,
        birthdate: json["birthdate"] ?? AppStrings.undefined,
        phoneNumber: json["phoneNumber"] ?? AppStrings.undefined,
      );
}
