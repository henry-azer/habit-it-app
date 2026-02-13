import 'package:get_it/get_it.dart';
import 'package:habit_it/core/managers/storage-manager/i_storage_manager.dart';
import 'package:habit_it/core/managers/storage-manager/local_storage_manager.dart';
import 'package:habit_it/core/managers/auth-token/auth_token_manager.dart';
import 'package:habit_it/core/services/i_auth_service.dart';
import 'package:habit_it/core/services/supabase_auth_service.dart';
import 'package:habit_it/core/services/biometric_auth_manager.dart';
import 'package:habit_it/core/data/repositories/auth_repository.dart';
import 'package:habit_it/core/data/repositories/auth_repository_impl.dart';
import 'package:habit_it/core/providers/biometric_provider.dart';
import 'package:habit_it/data/datasources/app/app_local_datasource.dart';
import 'package:habit_it/data/datasources/habit/habit_local_datasource.dart';
import 'package:habit_it/data/datasources/habit/habit_stats_local_datasource.dart';
import 'package:habit_it/data/datasources/user/user_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {

  // !---- Managers ----!
  sl.registerLazySingleton<IStorageManager>(() => LocalStorageManager());

  // !---- External ----!
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // !---- Auth Services ----!
  sl.registerLazySingleton<IAuthService>(() => SupabaseAuthService());
  sl.registerLazySingleton<AuthTokenManager>(() => AuthTokenManager());
  sl.registerLazySingleton<BiometricProvider>(() => BiometricProvider());
  sl.registerLazySingleton<BiometricAuthManager>(() => BiometricAuthManager(
    tokenManager: sl(),
    biometricProvider: sl(),
    authService: sl(),
  ));

  // !---- Auth Repository ----!
  sl.registerLazySingleton<IAuthRepository>(() => AuthRepositoryImpl(
    tokenManager: sl(),
    userLocalDataSource: sl(),
  ));

  // !---- Data Sources ----!
  sl.registerLazySingleton<AppLocalDataSource>(() => AppLocalDataSourceImpl(storageManager: sl()));
  sl.registerLazySingleton<UserLocalDataSource>(() => UserLocalDataSourceImpl(storageManager: sl()));
  sl.registerLazySingleton<HabitLocalDataSource>(() => HabitLocalDataSourceImpl(storageManager: sl()));
  sl.registerLazySingleton<HabitStatsLocalDataSource>(() => HabitStatsLocalDataSourceImpl(storageManager: sl()));

}
