import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habit_it/config/localization/app_localization.dart';
import 'package:habit_it/core/utils/app_local_storage_strings.dart';
import 'package:habit_it/core/utils/app_strings.dart';

class BiometricProvider with ChangeNotifier {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isBiometricEnabled = false;
  bool _isBiometricAvailable = false;
  List<BiometricType> _availableBiometrics = [];

  bool get isBiometricEnabled => _isBiometricEnabled;
  bool get isBiometricAvailable => _isBiometricAvailable;
  List<BiometricType> get availableBiometrics => _availableBiometrics;

  String get biometricTypeLabel {
    if (_availableBiometrics.isEmpty) return AppStrings.biometric.tr;
    
    if (Platform.isIOS) {
      if (_availableBiometrics.contains(BiometricType.face)) {
        return AppStrings.faceId.tr;
      } else if (_availableBiometrics.contains(BiometricType.fingerprint)) {
        return AppStrings.touchId.tr;
      }
    } else if (Platform.isAndroid) {
      if (_availableBiometrics.contains(BiometricType.face)) {
        return AppStrings.faceUnlock.tr;
      } else if (_availableBiometrics.contains(BiometricType.fingerprint)) {
        return AppStrings.fingerprint.tr;
      }
    }
    
    return AppStrings.biometric.tr;
  }

  BiometricProvider() {
    _init();
  }

  Future<void> _init() async {
    await _checkBiometricAvailability();
    await _loadBiometricPreference();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      _isBiometricAvailable = await _localAuth.canCheckBiometrics;
      if (_isBiometricAvailable) {
        _availableBiometrics = await _localAuth.getAvailableBiometrics();
      }
      notifyListeners();
    } on PlatformException catch (e) {
      debugPrint('Error checking biometric availability: $e');
      _isBiometricAvailable = false;
      notifyListeners();
    }
  }

  Future<void> _loadBiometricPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isBiometricEnabled = prefs.getBool(AppLocalStorageKeys.biometricEnabled) ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading biometric preference: $e');
    }
  }

  Future<bool> toggleBiometric(bool value) async {
    if (!_isBiometricAvailable) {
      return false;
    }

    if (value) {
      final authenticated = await authenticate(
        reason: AppStrings.authenticateToUnlock.tr,
      );
      if (!authenticated) {
        return false;
      }
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppLocalStorageKeys.biometricEnabled, value);
      _isBiometricEnabled = value;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error toggling biometric: $e');
      return false;
    }
  }

  Future<bool> authenticate({String? reason}) async {
    if (!_isBiometricAvailable) {
      return false;
    }

    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: reason ?? 'Please authenticate to continue',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      return authenticated;
    } on PlatformException catch (e) {
      debugPrint('Biometric authentication error: $e');
      return false;
    }
  }

  Future<void> refresh() async {
    await _checkBiometricAvailability();
    await _loadBiometricPreference();
  }
}
