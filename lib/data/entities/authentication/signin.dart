import 'package:equatable/equatable.dart';

class Signin extends Equatable {
  final String email;
  final String password;
  final bool rememberme;

  const Signin({required this.email, required this.password, required this.rememberme});

  @override
  List<Object?> get props => [email, password];

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "rememberme": rememberme,
      };
}
