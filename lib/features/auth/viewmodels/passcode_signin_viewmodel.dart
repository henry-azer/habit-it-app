import 'package:rxdart/rxdart.dart';

/// FND-006 skeleton — full implementation lands with AUTH-005 lock screen.
class PasscodeSigninViewModel {
  final BehaviorSubject<String> buffer$ = BehaviorSubject.seeded('');
  final BehaviorSubject<String?> error$ = BehaviorSubject.seeded(null);

  void dispose() {
    buffer$.close();
    error$.close();
  }
}
