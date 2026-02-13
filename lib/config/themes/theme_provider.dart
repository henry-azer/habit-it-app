import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/core/utils/app_constants.dart';
import 'package:habit_it/data/datasources/app/app_local_datasource.dart';

class ThemeProvider with ChangeNotifier {

  late AppLocalDataSource _appLocalDataSource;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider() {
    _appLocalDataSource = GetIt.instance<AppLocalDataSource>();
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    return _themeMode == ThemeMode.dark;
  }

  bool get isLightMode {
    return _themeMode == ThemeMode.light;
  }

  bool get isSystemMode {
    return _themeMode == ThemeMode.system;
  }

  void _loadThemeMode() async {
    try {
      final themeString = await _appLocalDataSource.getThemeMode();
      switch (themeString) {
        case AppConstants.light:
          _themeMode = ThemeMode.light;
          break;
        case AppConstants.dark:
          _themeMode = ThemeMode.dark;
          break;
        default:
          _themeMode = ThemeMode.system;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme mode: $e');
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      _themeMode = mode;
      String themeString;
      switch (mode) {
        case ThemeMode.light:
          themeString = AppConstants.light;
          break;
        case ThemeMode.dark:
          themeString = AppConstants.dark;
          break;
        default:
          themeString = AppConstants.system;
      }
      await _appLocalDataSource.setThemeMode(themeString);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }
}
