import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_strings.dart';

abstract class AppAuthentication {
  String getBearerToken();
  bool isUserLogging();
  bool isUserAuthenticated();
}

class AppAuthenticationImpl extends AppAuthentication {
  final SharedPreferences sharedPreferences;

  AppAuthenticationImpl({required this.sharedPreferences});

  @override
  String getBearerToken() {
    var signinClaims = jsonDecode(sharedPreferences.getString(AppStrings.cachedSigninClaims)!) as Map<String, dynamic>;
    return signinClaims[AppStrings.accessToken];
  }

  @override
  bool isUserAuthenticated() {
    return sharedPreferences.getBool(AppStrings.cachedIsAuthenticated) ?? false;
  }

  @override
  bool isUserLogging() {
    return sharedPreferences.getBool(AppStrings.cachedIsUserLogging) ?? false;
  }
}
