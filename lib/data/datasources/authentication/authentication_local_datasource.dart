import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/utils/app_strings.dart';
import '../../entities/authentication/signin_claims.dart';
import '../../entities/user/user.dart';
import '../../models/user/user_model.dart';
import '../../entities/authentication/signin.dart';

abstract class AuthenticationLocalDataSource {
  Future<User> getCurrentUser();

  Future<void> cacheSigninClaims(Signin signin, SigninClaims signinClaims);

  Future<void> cacheIsUserLogging();

  Future<void> cacheCurrentUser(User user);

  Future<void> clearCache();
}

class AuthenticationLocalDataSourceImpl implements AuthenticationLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthenticationLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheSigninClaims(Signin signin, SigninClaims signinClaims) async {
    sharedPreferences.setBool(AppStrings.cachedIsAuthenticated, true);
    sharedPreferences.setBool(AppStrings.cachedRememberMe, signin.rememberme);
    sharedPreferences.setString(AppStrings.cachedSignin, json.encode(signin));
    sharedPreferences.setString(AppStrings.cachedSigninClaims, json.encode(signinClaims));
    sharedPreferences.setBool(AppStrings.cachedIsUserLogging, false);
  }

  @override
  Future<void> cacheIsUserLogging() async {
    sharedPreferences.setBool(AppStrings.cachedIsUserLogging, true);
  }

  @override
  Future<User> getCurrentUser() async {
    final jsonString = sharedPreferences.getString(AppStrings.cachedCurrentUser);
    if (jsonString != null) {
      final cachedCurrentUser = Future.value(UserModel.fromJson(json.decode(jsonString)));
      return cachedCurrentUser;
    } else {
      throw const CacheException();
    }
  }

  @override
  Future<void> cacheCurrentUser(User user) async {
    sharedPreferences.remove(AppStrings.cachedCurrentUser);
    sharedPreferences.setString(AppStrings.cachedCurrentUser, json.encode(user));
  }

  @override
  Future<void> clearCache() async {
    bool isAppWelcomedUser = sharedPreferences.getBool(AppStrings.cachedIsAppWelcomedUser) ?? false;
    sharedPreferences.clear();
    sharedPreferences.setBool(AppStrings.cachedIsAppWelcomedUser, isAppWelcomedUser);
  }
}
