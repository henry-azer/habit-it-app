import 'package:rxdart/rxdart.dart';

/// FND-006 skeleton — full implementation lands with AUTH-005.
class BiometricSigninViewModel {
  final BehaviorSubject<bool> attempting$ = BehaviorSubject.seeded(false);
  final BehaviorSubject<String?> error$ = BehaviorSubject.seeded(null);

  void dispose() {
    attempting$.close();
    error$.close();
  }
}
