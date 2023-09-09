class EndPoints {
  // base
  static const String baseStagingUrl = 'http://192.168.1.7:8010/';
  static const String baseProductionUrl = '';

  // auth
  static const String signin = '$baseProductionUrl/auth/log-in';
  static const String signout = '$baseProductionUrl/auth/log-out';
  static const String currentUser = '$baseProductionUrl/auth/current';
  static const String refreshToken = '$baseProductionUrl/auth/refresh-token';

  // user
  static const String signup = '$baseProductionUrl/user';
}
