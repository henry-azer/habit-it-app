import 'package:rxdart/rxdart.dart';

import '../../../core/di/injection.dart';
import '../../../data/repositories/i_user_repository.dart';

/// FND-006 skeleton — replaced by AUTH-008 multi-step signup.
class SignupViewModel {
  SignupViewModel({IUserRepository? userRepo})
      : _userRepo = userRepo ?? getIt<IUserRepository>();

  final IUserRepository _userRepo;

  final BehaviorSubject<String> username$ = BehaviorSubject.seeded('');
  final BehaviorSubject<String> gender$ = BehaviorSubject.seeded('Male');

  Future<bool> submit() async {
    if (username$.value.trim().isEmpty) return false;
    final r =
        await _userRepo.setUsernameAndGender(username$.value, gender$.value);
    return r.isOk;
  }

  void dispose() {
    username$.close();
    gender$.close();
  }
}
