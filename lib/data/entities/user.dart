class User {
  late String id;
  late String username;
  late String gender;
  late String password;
  late bool isRegistered;
  late bool isAuthenticated;
  late bool isPINAuthenticated;
  late bool isBiometricAuthenticated;

  User({
    this.id = "",
    this.username = "",
    this.gender = "",
    this.password = "",
    this.isRegistered = false,
    this.isAuthenticated = false,
    this.isPINAuthenticated = false,
    this.isBiometricAuthenticated = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'gender': gender,
      'password': password,
      'isRegistered': isRegistered,
      'isAuthenticated': isAuthenticated,
      'isPINAuthenticated': isPINAuthenticated,
      'isBiometricAuthenticated': isBiometricAuthenticated,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? "",
      username: json['username'] ?? "",
      gender: json['gender'] ?? "",
      password: json['password'] ?? "",
      isRegistered: json['isRegistered'] ?? false,
      isAuthenticated: json['isAuthenticated'] ?? false,
      isPINAuthenticated: json['isPINAuthenticated'] ?? false,
      isBiometricAuthenticated: json['isBiometricAuthenticated'] ?? false,
    );
  }
}
