import 'package:equatable/equatable.dart';

class Signup extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String birthdate;
  final String phoneNumber;

  const Signup(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.birthdate,
      required this.phoneNumber});

  @override
  List<Object?> get props => [email];

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "firstName": firstName,
        "lastName": lastName,
        "birthdate": birthdate,
        "phoneNumber": phoneNumber,
      };
}
