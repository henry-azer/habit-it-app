import 'package:rxdart/rxdart.dart';

import '../../../core/di/injection.dart';
import '../../../data/entities/user_entity.dart';
import '../../../data/repositories/i_user_repository.dart';

/// Legacy Profile screen → ViewModel skeleton. Wholly replaced by Settings
/// hub in SET-001; kept here so the legacy `ProfileScreen` has a back-pointer
/// once we rewrite it.
class ProfileViewModel {
  ProfileViewModel({IUserRepository? userRepo})
      : _userRepo = userRepo ?? getIt<IUserRepository>();

  final IUserRepository _userRepo;

  final BehaviorSubject<UserEntity> user$ =
      BehaviorSubject.seeded(UserEntity.defaults());

  Future<void> load() async {
    final r = await _userRepo.get();
    r.when(
      ok: (m) {
        if (!user$.isClosed) user$.add(m);
      },
      err: (_) {},
    );
  }

  Future<void> updateUsername(String username) =>
      _userRepo.setUsernameAndGender(username, user$.value.gender);

  void dispose() {
    user$.close();
  }
}
