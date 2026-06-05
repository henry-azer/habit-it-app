import 'package:rxdart/rxdart.dart';

/// FND-006 skeleton — full state machine lands with AUTH-003.
enum PasscodeSetupStep { create, confirm }

class PasscodeSetupViewModel {
  final BehaviorSubject<PasscodeSetupStep> step$ =
      BehaviorSubject.seeded(PasscodeSetupStep.create);
  final BehaviorSubject<String> buffer$ = BehaviorSubject.seeded('');
  final BehaviorSubject<String?> error$ = BehaviorSubject.seeded(null);

  void dispose() {
    step$.close();
    buffer$.close();
    error$.close();
  }
}
