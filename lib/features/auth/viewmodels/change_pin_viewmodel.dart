import 'package:rxdart/rxdart.dart';

import '../../../core/constants/security_constants.dart';
import '../../../core/di/injection.dart';
import '../../../core/services/auth/app_lock_service.dart';
import '../../../core/services/auth/unlock_result.dart';

/// AUTH-007 — three-phase Change PIN flow.
enum ChangePinStep { current, create, confirm }

class ChangePinViewModel {
  ChangePinViewModel({AppLockService? appLock})
      : _appLock = appLock ?? getIt<AppLockService>();

  final AppLockService _appLock;

  final BehaviorSubject<ChangePinStep> step$ =
      BehaviorSubject.seeded(ChangePinStep.current);
  final BehaviorSubject<String> buffer$ = BehaviorSubject.seeded('');
  final BehaviorSubject<String?> error$ = BehaviorSubject.seeded(null);
  final BehaviorSubject<UnlockResult?> result$ = BehaviorSubject.seeded(null);
  final BehaviorSubject<bool> completed$ = BehaviorSubject.seeded(false);

  String _current = '';
  String _next = '';

  static const int _kPinLength = SecurityConstants.kPinLength;

  Future<void> onDigit(String d) async {
    final buf = buffer$.value;
    if (buf.length >= _kPinLength) return;
    final next = buf + d;
    buffer$.add(next);
    if (error$.value != null) error$.add(null);
    if (next.length == _kPinLength) await _advance();
  }

  void onBackspace() {
    final buf = buffer$.value;
    if (buf.isEmpty) return;
    buffer$.add(buf.substring(0, buf.length - 1));
  }

  Future<void> _advance() async {
    final entered = buffer$.value;
    switch (step$.value) {
      case ChangePinStep.current:
        // Verify against AppLockService so wrong-PIN counts toward AUTH-005
        // lockout per TS-AUTH-007 AC#3.
        final r = await _appLock.verifyPasscode(entered);
        result$.add(r);
        if (r is UnlockSuccess) {
          _current = entered;
          buffer$.add('');
          step$.add(ChangePinStep.create);
        } else {
          buffer$.add('');
          error$.add('wrong');
        }
        return;
      case ChangePinStep.create:
        _next = entered;
        buffer$.add('');
        step$.add(ChangePinStep.confirm);
        return;
      case ChangePinStep.confirm:
        if (entered != _next) {
          _next = '';
          buffer$.add('');
          error$.add('mismatch');
          step$.add(ChangePinStep.create);
          return;
        }
        // Use changePasscode to swap atomically + reset counters.
        final r = await _appLock.changePasscode(current: _current, next: _next);
        result$.add(r);
        if (r is UnlockSuccess) {
          completed$.add(true);
        } else {
          // Should not normally happen (verified above) — guard anyway.
          step$.add(ChangePinStep.current);
          buffer$.add('');
          error$.add('failed');
        }
        return;
    }
  }

  void dispose() {
    step$.close();
    buffer$.close();
    error$.close();
    result$.close();
    completed$.close();
  }
}
