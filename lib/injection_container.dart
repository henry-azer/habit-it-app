import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/core/managers/biometric-authentication/biometric_auth_manager.dart';
import 'package:habit_it/core/managers/biometric-authentication/i_biometric_auth_manager.dart';
import 'package:habit_it/core/managers/storage-manager/i_storage_manager.dart';
import 'package:habit_it/core/managers/storage-manager/local_storage_manager.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/api/api_consumer.dart';
import 'core/api/app_interceptors.dart';
import 'core/api/dio_consumer.dart';
import 'core/network/network_info.dart';
import 'data/datasources/authentication/authentication_local_datasource.dart';
import 'data/datasources/user/user_local_datasource.dart';

final sl = GetIt.instance;

Future<void> init() async {

  // !---- Data Sources ----!
  // authentication
  sl.registerLazySingleton<AuthenticationLocalDataSource>(() => AuthenticationLocalDataSourceImpl(storageManager: sl()));
  // user
  sl.registerLazySingleton<UserLocalDataSource>(() => UserLocalDataSourceImpl(storageManager: sl()));


  // !---- Core ----!
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectionChecker: sl()));
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));


  // !---- External ----!
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => AppInterceptors());
  sl.registerLazySingleton(() => LogInterceptor(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
      error: true));
  sl.registerLazySingleton<IStorageManager>(() => LocalStorageManager());
  sl.registerLazySingleton<LocalAuthentication>(() => LocalAuthentication());
  sl.registerLazySingleton<IBiometricAuthenticationManager>(() => BiometricAuthenticationManager(localAuthentication: sl(), authenticationLocalDataSource: sl()));
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => Dio());
}
