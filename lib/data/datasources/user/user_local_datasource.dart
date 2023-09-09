import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/app_strings.dart';

abstract class UserLocalDataSource {
  Future<void> cacheIsApGetStarted();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  UserLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheIsApGetStarted() async {
    sharedPreferences.setBool(AppStrings.cachedIsUserGetStarted, true);
  }
}
