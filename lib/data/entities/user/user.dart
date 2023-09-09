import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String birthdate;
  final String phoneNumber;

  const User(
      {required this.firstName,
      required this.lastName,
      required this.id,
      required this.email,
      required this.password,
      required this.birthdate,
      required this.phoneNumber});

  @override
  List<Object?> get props => [id];

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
        "firstName": firstName,
        "lastName": lastName,
        "birthdate": birthdate,
        "phoneNumber": phoneNumber,
      };
}
