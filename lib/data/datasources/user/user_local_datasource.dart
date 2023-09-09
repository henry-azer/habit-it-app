import 'package:shared_preferences/shared_preferences.dart';

abstract class UserLocalDataSource {
  Future<void> cacheIsAppWelcomedUser();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  UserLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheIsAppWelcomedUser() async {
    // TODO: Remove it when production
    // sharedPreferences.setBool(AppStrings.cachedIsAppWelcomedUser, true);
  }
}
