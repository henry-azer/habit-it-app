import 'package:flutter_test/flutter_test.dart';
import 'package:habit_it/core/router/app_routes.dart';
import 'package:habit_it/core/utils/result.dart';
import 'package:habit_it/data/entities/app_entity.dart';
import 'package:habit_it/data/entities/user_entity.dart';
import 'package:habit_it/data/repositories/i_app_repository.dart';
import 'package:habit_it/data/repositories/i_user_repository.dart';
import 'package:habit_it/features/splash/viewmodels/splash_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class _MockAppRepo extends Mock implements IAppRepository {}

class _MockUserRepo extends Mock implements IUserRepository {}

void main() {
  late _MockAppRepo appRepo;
  late _MockUserRepo userRepo;

  setUp(() {
    appRepo = _MockAppRepo();
    userRepo = _MockUserRepo();
    when(() => appRepo.setLastDate(any())).thenAnswer((_) async => const Ok(null));
  });

  test('routes to onboarding when app not initialised', () async {
    when(() => appRepo.get()).thenAnswer(
        (_) async => const Ok(AppEntity(init: false)));
    when(() => userRepo.get()).thenAnswer(
        (_) async => const Ok(UserEntity()));

    final vm = SplashViewModel(
      appRepo: appRepo,
      userRepo: userRepo,
      splashDelay: Duration.zero,
    );

    final emissions = <SplashUiState>[];
    final sub = vm.state$.listen(emissions.add);
    await vm.load();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await sub.cancel();

    final navigates = emissions.whereType<SplashNavigate>().toList();
    expect(navigates, isNotEmpty);
    expect(navigates.last.targetPath, AppRoutes.onboardingPath);

    vm.dispose();
  });

  test('routes to signup when init=true but user not registered', () async {
    when(() => appRepo.get()).thenAnswer(
        (_) async => const Ok(AppEntity(init: true)));
    when(() => userRepo.get()).thenAnswer(
        (_) async => const Ok(UserEntity(isRegistered: false)));

    final vm = SplashViewModel(
      appRepo: appRepo,
      userRepo: userRepo,
      splashDelay: Duration.zero,
    );
    await vm.load();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(vm.state$.value, isA<SplashNavigate>());
    expect((vm.state$.value as SplashNavigate).targetPath,
        AppRoutes.signupWelcomePath);

    vm.dispose();
  });

  test('routes to biometric signin when user is registered with biometric', () async {
    when(() => appRepo.get()).thenAnswer(
        (_) async => const Ok(AppEntity(init: true)));
    when(() => userRepo.get()).thenAnswer(
        (_) async => const Ok(UserEntity(
              isRegistered: true,
              isBiometricAuthenticated: true,
            )));

    final vm = SplashViewModel(
      appRepo: appRepo,
      userRepo: userRepo,
      splashDelay: Duration.zero,
    );
    await vm.load();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect((vm.state$.value as SplashNavigate).targetPath,
        AppRoutes.signinBiometricPath);
    verify(() => appRepo.setLastDate(any())).called(1);

    vm.dispose();
  });

  test('routes to PIN signin when registered without biometric', () async {
    when(() => appRepo.get()).thenAnswer(
        (_) async => const Ok(AppEntity(init: true)));
    when(() => userRepo.get()).thenAnswer(
        (_) async => const Ok(UserEntity(isRegistered: true)));

    final vm = SplashViewModel(
      appRepo: appRepo,
      userRepo: userRepo,
      splashDelay: Duration.zero,
    );
    await vm.load();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect((vm.state$.value as SplashNavigate).targetPath,
        AppRoutes.signinPinPath);

    vm.dispose();
  });
}
