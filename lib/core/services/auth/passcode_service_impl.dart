import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/key_derivators/pbkdf2.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:pointycastle/pointycastle.dart' show Pbkdf2Parameters;

import '../../constants/secure_storage_keys.dart';
import '../../constants/security_constants.dart';
import 'i_passcode_service.dart';

/// PBKDF2-SHA256 passcode service.
///
/// Port of `vault-it-app/lib/core/services/passcode_service.dart:24-119`
/// adapted to Habit-It's `SecureStorageKeys` / `SecurityConstants` namespaces.
///
/// **Format:** `"1$<base64Salt>$<base64Hash>"` (literal dollar-sign separator).
/// `1` is the on-disk format version. Bumping it requires a migration step
/// since older stored hashes can't be re-derived from a different KDF.
class PasscodeServiceImpl implements IPasscodeService {
  PasscodeServiceImpl({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  // Storage keys (TS §6).
  static const _kPasscode = SecureStorageKeys.pinHash;
  static const _kAttempts = SecureStorageKeys.failedAttempts;
  static const _kLockout = SecureStorageKeys.lockoutUntil;

  // PBKDF2 parameters (AUTH-001 AC#2). Pulled from SecurityConstants so the
  // PO / sec-review can change them in one place.
  static final int _kIterations = SecurityConstants.kPbkdf2Iterations;
  static final int _kSaltBytes = SecurityConstants.kSaltBytes;
  static final int _kHashBytes = SecurityConstants.kHashBytes;
  static final String _kFormatVersion = SecurityConstants.kFormatVersion;

  final FlutterSecureStorage _storage;
  final Random _rng = Random.secure();

  @override
  Future<bool> isSet() async =>
      (await _storage.read(key: _kPasscode)) != null;

  @override
  Future<void> setPasscode(String passcode) async {
    // port of vault-it-app/lib/core/services/passcode_service.dart:43-51
    final salt = Uint8List.fromList(
      List<int>.generate(_kSaltBytes, (_) => _rng.nextInt(256)),
    );
    final hash = _pbkdf2(passcode, salt);
    final encoded =
        '$_kFormatVersion\$${base64Encode(salt)}\$${base64Encode(hash)}';
    await _storage.write(key: _kPasscode, value: encoded);
  }

  @override
  Future<bool> verify(String passcode) async {
    // port of vault-it-app/lib/core/services/passcode_service.dart:53-63
    final stored = await _storage.read(key: _kPasscode);
    if (stored == null) return false;
    final parts = stored.split(r'$');
    if (parts.length != 3 || parts[0] != _kFormatVersion) return false;
    final salt = base64Decode(parts[1]);
    final expected = base64Decode(parts[2]);
    final actual = _pbkdf2(passcode, Uint8List.fromList(salt));
    return _constantTimeEquals(actual, expected);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _kPasscode);
    await _storage.delete(key: _kAttempts);
    await _storage.delete(key: _kLockout);
  }

  @override
  Future<int> getFailedAttempts() async {
    final raw = await _storage.read(key: _kAttempts);
    return int.tryParse(raw ?? '0') ?? 0;
  }

  @override
  Future<void> incrementFailedAttempts() async {
    final current = await getFailedAttempts();
    await _storage.write(key: _kAttempts, value: '${current + 1}');
  }

  @override
  Future<void> resetFailedAttempts() async {
    await _storage.delete(key: _kAttempts);
  }

  @override
  Future<DateTime?> getLockoutUntil() async {
    final raw = await _storage.read(key: _kLockout);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  @override
  Future<void> setLockoutUntil(DateTime? until) async {
    if (until == null) {
      await _storage.delete(key: _kLockout);
    } else {
      await _storage.write(key: _kLockout, value: until.toIso8601String());
    }
  }

  // port of vault-it-app/lib/core/services/passcode_service.dart:105-109
  Uint8List _pbkdf2(String passcode, Uint8List salt) {
    final derivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    derivator.init(Pbkdf2Parameters(salt, _kIterations, _kHashBytes));
    return derivator.process(Uint8List.fromList(utf8.encode(passcode)));
  }

  // port of vault-it-app/lib/core/services/passcode_service.dart:111-118
  bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}
