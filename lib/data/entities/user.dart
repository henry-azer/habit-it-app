class User {
  late String username;
  late String gender;
  late String password;
  late bool isUserBiometricAuthenticated;

  User({
    this.username = "",
    this.gender = "",
    this.password = "",
    this.isUserBiometricAuthenticated = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'gender': gender,
      'password': password,
      'isUserBiometricAuthenticated': isUserBiometricAuthenticated,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? "",
      gender: json['gender'] ?? "",
      password: json['password'] ?? "",
      isUserBiometricAuthenticated: json['isUserBiometricAuthenticated'] ?? false,
    );
  }
}
