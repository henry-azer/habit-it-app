import '../../../data/repositories/i_user_repository.dart';
import 'i_passcode_service.dart';

/// Result of one legacy-PIN migration attempt.
///
/// PO G-003 override: a successful migration does NOT chain into biometric
/// opt-in; the caller routes the user to `PasscodeUpgradeScreen` to pick a
/// new 4-digit PIN.
enum MigrationOutcome {
  /// No legacy PIN found — user is either fresh or already on the new system.
  notNeeded,

  /// Legacy PIN verified. Caller should clear `user.password` and route to
  /// `PasscodeUpgradeScreen` (NOT `PasscodeSetupScreen`) per PO G-003.
  ///
  /// Note: the legacy 5-digit PIN hash is incompatible with the 4-digit lock
  /// screen, so we do NOT persist the legacy PIN as the new hash. The caller
  /// is expected to drive the upgrade flow.
  verified,

  /// User entered the wrong legacy PIN. Caller increments local attempt
  /// counter; 3 wrong → Reset Data flow per AC#5.
  wrongPin,
}

/// AUTH-001 legacy PIN migrator.
///
/// Reads `user.password` (the legacy plain-text 5-digit PIN) and, on
/// successful entry, surfaces the upgrade path. Does NOT auto-hash the
/// legacy PIN to the new system because PIN-length changes from 5 → 4 and
/// silently truncating is a non-starter (PO G-003).
class AuthMigrator {
  AuthMigrator(this._userRepo, this._passcode);

  final IUserRepository _userRepo;
  // Held for symmetry with the spec signature (see TS-AUTH-001) and so a
  // future post-G-003 reversal can re-introduce in-place hashing without
  // touching the call sites.
  // ignore: unused_field
  final IPasscodeService _passcode;

  /// Cheap predicate: is there anything to migrate?
  ///
  /// True when the user record has a non-empty legacy `password` AND
  /// `flutter_secure_storage` does NOT yet hold a new hash. The caller
  /// (splash redirect) uses this to gate the `/signup/pin-migrate` route.
  Future<bool> isMigrationPending() async {
    final user = (await _userRepo.get()).valueOrNull;
    if (user == null) return false;
    final legacy = user.password;
    if (legacy == null || legacy.isEmpty) return false;
    return !(await _passcode.isSet());
  }

  /// Verify the entered legacy PIN against the on-record plain-text field.
  ///
  /// Note: this is a string compare against plain-text, which is fine for
  /// the *legacy* PIN only — that PIN was never hashed in the first place,
  /// so there is nothing extra to lose by comparing as-is. We do NOT log the
  /// PIN under any circumstance.
  Future<MigrationOutcome> verifyLegacyPin(String enteredLegacyPin) async {
    final user = (await _userRepo.get()).valueOrNull;
    if (user == null) return MigrationOutcome.notNeeded;
    final stored = user.password;
    if (stored == null || stored.isEmpty) return MigrationOutcome.notNeeded;
    if (stored != enteredLegacyPin) return MigrationOutcome.wrongPin;
    return MigrationOutcome.verified;
  }

  /// Clear the legacy plain-text PIN from the user record. Call this once
  /// the user has successfully picked a new 4-digit PIN via the upgrade
  /// screen.
  Future<void> finalize() async {
    await _userRepo.clearLegacyPassword();
  }
}
