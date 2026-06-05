import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../data/datasources/hive/hive_app_source.dart';
import '../../data/datasources/hive/hive_habit_source.dart';
import '../../data/datasources/hive/hive_magic_meta_source.dart';
import '../../data/datasources/hive/hive_notes_source.dart';
import '../../data/datasources/hive/hive_notification_meta_source.dart';
import '../../data/datasources/hive/hive_settings_source.dart';
import '../../data/datasources/hive/hive_user_source.dart';
import '../../data/datasources/repositories_impl/app_repository_impl.dart';
import '../../data/datasources/repositories_impl/habit_repository_impl.dart';
import '../../data/datasources/repositories_impl/habit_stats_repository_impl.dart';
import '../../data/datasources/repositories_impl/magic_repository_impl.dart';
import '../../data/datasources/repositories_impl/notes_repository_impl.dart';
import '../../data/datasources/repositories_impl/notification_repository_impl.dart';
import '../../data/datasources/repositories_impl/settings_repository_impl.dart';
import '../../data/datasources/repositories_impl/user_repository_impl.dart';
import '../../data/repositories/i_app_repository.dart';
import '../../data/repositories/i_habit_repository.dart';
import '../../data/repositories/i_habit_stats_repository.dart';
import '../../data/repositories/i_magic_repository.dart';
import '../../data/repositories/i_notes_repository.dart';
import '../../data/repositories/i_notification_repository.dart';
import '../../data/repositories/i_settings_repository.dart';
import '../../data/repositories/i_user_repository.dart';
import '../managers/biometric/biometric_manager_impl.dart';
import '../managers/biometric/i_biometric_manager.dart';
import '../services/auth/app_lock_service.dart';
import '../services/auth/auth_boot_cleanup.dart';
import '../services/auth/auth_migrator.dart';
import '../services/auth/i_passcode_service.dart';
import '../services/auth/passcode_service_impl.dart';
import '../services/backup/reset_service.dart';
import '../services/migration/shared_prefs_to_hive_migrator.dart';

// Legacy managers — kept until ported screens are replaced. Importing them
// here keeps the legacy DI graph satisfied so old screens still work.
//
// AUTH-008 ownership: the legacy `UserLocalDataSource` registration is
// REMOVED from this file because AUTH-008 fully rewires User reads to the
// new Hive `IUserRepository`. The TODO(post-AUTH/SET) marker in
// `shared_prefs_to_hive_migrator.dart` is narrowed accordingly.
import '../managers/biometric-authentication/biometric_auth_manager.dart';
import '../managers/biometric-authentication/i_biometric_auth_manager.dart';
import '../managers/storage-manager/i_storage_manager.dart';
import '../managers/storage-manager/local_storage_manager.dart';
import '../../data/datasources/app/app_local_datasource.dart';
import '../../data/datasources/habit/habit_local_datasource.dart';
import '../../data/datasources/habit/habit_stats_local_datasource.dart';
import '../../data/datasources/user/user_local_datasource.dart';

/// GetIt service-locator instance. Use `getIt<T>()` everywhere.
final getIt = GetIt.instance;

/// Legacy alias — old screens reference `sl<T>()`. Kept until those screens
/// are rewritten to use `getIt<T>()`.
final sl = getIt;

Future<void> configureDependencies({SharedPreferences? sharedPrefs}) async {
  // ---- External ----
  final prefs = sharedPrefs ?? await SharedPreferences.getInstance();
  if (!getIt.isRegistered<SharedPreferences>()) {
    getIt.registerSingleton<SharedPreferences>(prefs);
  }
  if (!getIt.isRegistered<FlutterSecureStorage>()) {
    getIt.registerLazySingleton<FlutterSecureStorage>(
        () => const FlutterSecureStorage());
  }
  if (!getIt.isRegistered<LocalAuthentication>()) {
    getIt.registerLazySingleton<LocalAuthentication>(() => LocalAuthentication());
  }
  if (!getIt.isRegistered<http.Client>()) {
    getIt.registerLazySingleton<http.Client>(() => http.Client());
  }
  if (!getIt.isRegistered<Uuid>()) {
    getIt.registerLazySingleton<Uuid>(() => const Uuid());
  }

  // ---- Legacy managers (kept for un-ported screens) ----
  if (!getIt.isRegistered<IStorageManager>()) {
    getIt.registerLazySingleton<IStorageManager>(() => LocalStorageManager());
  }
  if (!getIt.isRegistered<AppLocalDataSource>()) {
    getIt.registerLazySingleton<AppLocalDataSource>(
        () => AppLocalDataSourceImpl(storageManager: getIt()));
  }
  if (!getIt.isRegistered<UserLocalDataSource>()) {
    getIt.registerLazySingleton<UserLocalDataSource>(
        () => UserLocalDataSourceImpl(storageManager: getIt()));
  }
  if (!getIt.isRegistered<HabitLocalDataSource>()) {
    getIt.registerLazySingleton<HabitLocalDataSource>(
        () => HabitLocalDataSourceImpl(storageManager: getIt()));
  }
  if (!getIt.isRegistered<HabitStatsLocalDataSource>()) {
    getIt.registerLazySingleton<HabitStatsLocalDataSource>(
        () => HabitStatsLocalDataSourceImpl(storageManager: getIt()));
  }
  if (!getIt.isRegistered<IBiometricAuthenticationManager>()) {
    getIt.registerLazySingleton<IBiometricAuthenticationManager>(
        () => BiometricAuthenticationManager(
              localAuthentication: getIt(),
              userLocalDataSource: getIt(),
            ));
  }

  // ---- Hive sources (singletons) ----
  if (!getIt.isRegistered<HiveAppSource>()) {
    getIt.registerLazySingleton(() => HiveAppSource());
  }
  if (!getIt.isRegistered<HiveUserSource>()) {
    getIt.registerLazySingleton(() => HiveUserSource());
  }
  if (!getIt.isRegistered<HiveSettingsSource>()) {
    getIt.registerLazySingleton(() => HiveSettingsSource());
  }
  if (!getIt.isRegistered<HiveHabitSource>()) {
    getIt.registerLazySingleton(() => HiveHabitSource());
  }
  if (!getIt.isRegistered<HiveNotesSource>()) {
    getIt.registerLazySingleton(() => HiveNotesSource());
  }
  if (!getIt.isRegistered<HiveNotificationMetaSource>()) {
    getIt.registerLazySingleton(() => HiveNotificationMetaSource());
  }
  if (!getIt.isRegistered<HiveMagicMetaSource>()) {
    getIt.registerLazySingleton(() => HiveMagicMetaSource());
  }

  // ---- Repositories ----
  if (!getIt.isRegistered<IAppRepository>()) {
    getIt.registerLazySingleton<IAppRepository>(
        () => AppRepositoryImpl(getIt()));
  }
  if (!getIt.isRegistered<IUserRepository>()) {
    getIt.registerLazySingleton<IUserRepository>(
        () => UserRepositoryImpl(getIt()));
  }
  if (!getIt.isRegistered<ISettingsRepository>()) {
    getIt.registerLazySingleton<ISettingsRepository>(
        () => SettingsRepositoryImpl(getIt()));
  }
  if (!getIt.isRegistered<IHabitRepository>()) {
    getIt.registerLazySingleton<IHabitRepository>(
        () => HabitRepositoryImpl(getIt()));
  }
  if (!getIt.isRegistered<IHabitStatsRepository>()) {
    getIt.registerLazySingleton<IHabitStatsRepository>(
        () => HabitStatsRepositoryImpl(getIt()));
  }
  if (!getIt.isRegistered<INotesRepository>()) {
    getIt.registerLazySingleton<INotesRepository>(
        () => NotesRepositoryImpl(getIt()));
  }
  if (!getIt.isRegistered<INotificationRepository>()) {
    getIt.registerLazySingleton<INotificationRepository>(
        () => NotificationRepositoryImpl(getIt()));
  }
  if (!getIt.isRegistered<IMagicRepository>()) {
    getIt.registerLazySingleton<IMagicRepository>(
        () => MagicRepositoryImpl(getIt()));
  }

  // ---- Services ----
  if (!getIt.isRegistered<SharedPrefsToHiveMigrator>()) {
    getIt.registerLazySingleton<SharedPrefsToHiveMigrator>(
        () => SharedPrefsToHiveMigrator(
              prefs: getIt(),
              hiveApp: getIt(),
              hiveUser: getIt(),
              hiveHabit: getIt(),
            ));
  }

  // ---- AUTH (Release 2) ----
  if (!getIt.isRegistered<IBiometricManager>()) {
    getIt.registerLazySingleton<IBiometricManager>(
        () => BiometricManagerImpl(getIt<LocalAuthentication>()));
  }
  if (!getIt.isRegistered<IPasscodeService>()) {
    getIt.registerLazySingleton<IPasscodeService>(
        () => PasscodeServiceImpl(storage: getIt<FlutterSecureStorage>()));
  }
  // Eager singleton — owns the `lockedNotifier` consumed by GoRouter
  // `refreshListenable`. Must be alive before `appRouter` is constructed.
  if (!getIt.isRegistered<AppLockService>()) {
    getIt.registerSingleton<AppLockService>(
      AppLockService(
        passcode: getIt<IPasscodeService>(),
        biometric: getIt<IBiometricManager>(),
      ),
    );
  }
  if (!getIt.isRegistered<AuthMigrator>()) {
    getIt.registerLazySingleton<AuthMigrator>(
        () => AuthMigrator(getIt<IUserRepository>(), getIt<IPasscodeService>()));
  }
  if (!getIt.isRegistered<ResetService>()) {
    getIt.registerLazySingleton<ResetService>(() => ResetService(
          getIt<FlutterSecureStorage>(),
          getIt<SharedPreferences>(),
        ));
  }
  if (!getIt.isRegistered<AuthBootCleanup>()) {
    getIt.registerLazySingleton<AuthBootCleanup>(
        () => AuthBootCleanup(getIt<SharedPreferences>()));
  }

  // NOTE: INotificationService, IHabitSuggestionService etc. remain scoped to
  // subsequent epics (SCH, AI). When those epics land, add registrations to
  // this file in the order shown in TECHNICAL_STORIES.md §TS-FND-001.

  await getIt.allReady();
}

/// Test helper — fully resets the GetIt registry between unit tests.
Future<void> resetDependencies() async {
  await getIt.reset();
}
