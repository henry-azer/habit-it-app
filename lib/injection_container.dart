import 'package:get_it/get_it.dart';
import 'package:habit_it/core/managers/biometric-authentication/biometric_auth_manager.dart';
import 'package:habit_it/core/managers/biometric-authentication/i_biometric_auth_manager.dart';
import 'package:habit_it/core/managers/storage-manager/i_storage_manager.dart';
import 'package:habit_it/core/managers/storage-manager/local_storage_manager.dart';
import 'package:habit_it/data/datasources/app/app_local_datasource.dart';
import 'package:habit_it/data/datasources/habit/habit_local_datasource.dart';
import 'package:habit_it/data/datasources/habit/habit_stats_local_datasource.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasources/user/user_local_datasource.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // !---- Data Sources ----!
  sl.registerLazySingleton<AppLocalDataSource>(() => AppLocalDataSourceImpl(storageManager: sl()));
  sl.registerLazySingleton<UserLocalDataSource>(() => UserLocalDataSourceImpl(storageManager: sl()));
  sl.registerLazySingleton<HabitLocalDataSource>(() => HabitLocalDataSourceImpl(storageManager: sl()));
  sl.registerLazySingleton<HabitStatsLocalDataSource>(() => HabitStatsLocalDataSourceImpl(storageManager: sl()));

  // !---- External ----!
  sl.registerLazySingleton(() => SharedPreferences.getInstance());
  sl.registerLazySingleton<IStorageManager>(() => LocalStorageManager());
  sl.registerLazySingleton<LocalAuthentication>(() => LocalAuthentication());
  sl.registerLazySingleton<IBiometricAuthenticationManager>(() => BiometricAuthenticationManager(localAuthentication: sl(), userLocalDataSource: sl()));
}
