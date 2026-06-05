import 'package:rxdart/rxdart.dart';

import '../../../core/di/injection.dart';
import '../../../data/repositories/i_app_repository.dart';

/// Onboarding state.
sealed class OnboardingUiState {
  const OnboardingUiState();
}

class OnboardingShowing extends OnboardingUiState {
  const OnboardingShowing();
}

class OnboardingFinished extends OnboardingUiState {
  const OnboardingFinished();
}

class OnboardingViewModel {
  OnboardingViewModel({IAppRepository? appRepo})
      : _appRepo = appRepo ?? getIt<IAppRepository>();

  final IAppRepository _appRepo;

  final BehaviorSubject<OnboardingUiState> state$ =
      BehaviorSubject.seeded(const OnboardingShowing());

  /// Persist that the user has seen onboarding and emit [OnboardingFinished].
  Future<void> finish() async {
    final result = await _appRepo.setInit(true);
    result.when(
      ok: (_) {
        if (!state$.isClosed) state$.add(const OnboardingFinished());
      },
      err: (_) {
        // Even on persistence failure, advance — the worst case is the user
        // sees onboarding again on next launch. Better than a stuck UI.
        if (!state$.isClosed) state$.add(const OnboardingFinished());
      },
    );
  }

  void dispose() {
    state$.close();
  }
}
