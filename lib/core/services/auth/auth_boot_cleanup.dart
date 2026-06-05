import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_constants.dart';

/// AUTH-008 ownership of the FND `TODO(post-AUTH/SET)` cleanup for the User
/// domain.
///
/// Called once AUTH-008 multi-step signup has established the canonical user
/// record in Hive. Drops the specific legacy `APP/USER` SharedPreferences
/// key so the legacy `UserLocalDataSourceImpl` (kept registered for the
/// un-rewritten screens — see PROGRESS.md AQ-7) will read defaults from
/// here on. The other `APP/*` keys belong to App / Habit / Profile screens
/// that are outside the AUTH slice and are intentionally untouched.
class AuthBootCleanup {
  AuthBootCleanup(this._prefs);

  final SharedPreferences _prefs;

  /// Idempotent — safe to call after every AUTH-008 completion.
  Future<void> clearLegacyUserKey() async {
    if (_prefs.containsKey(AppConstants.legacyUserKey)) {
      await _prefs.remove(AppConstants.legacyUserKey);
    }
  }
}
