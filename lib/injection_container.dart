import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_it/core/managers/biometric-authentication/biometric_auth_manager.dart';
import 'package:habit_it/core/managers/biometric-authentication/i_biometric_auth_manager.dart';
import 'package:habit_it/core/managers/storage-manager/i_storage_manager.dart';
import 'package:habit_it/core/managers/storage-manager/local_storage_manager.dart';
import 'package:habit_it/features/onboarding/domain/cubit/app_get_started_cubit.dart';
import 'package:habit_it/features/onboarding/domain/usecase/app_get_started_usecase.dart';
import 'package:habit_it/features/signup/local-pin/domain/cubit/user_pin_registration_cubit.dart';
import 'package:habit_it/features/signup/local-pin/domain/usecase/user_pin_registration_usecase.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/api/api_consumer.dart';
import 'core/api/app_interceptors.dart';
import 'core/api/dio_consumer.dart';
import 'core/network/network_info.dart';
import 'data/datasources/authentication/authentication_local_datasource.dart';
import 'data/datasources/authentication/authentication_remote_datasource.dart';
import 'data/datasources/user/user_local_datasource.dart';
import 'data/datasources/user/user_remote_datasource.dart';
import 'data/repositories/authentication/authentication_repository.dart';
import 'data/repositories/authentication/authentication_repository_impl.dart';
import 'data/repositories/user/user_repository.dart';
import 'data/repositories/user/user_repository_impl.dart';
import 'data/datasources/localization/localization_local_data_source.dart';
import 'data/repositories/localization/localization_repository_impl.dart';
import 'data/repositories/localization/localization_repository.dart';
import 'features/splash/domain/cubit/localization_cubit.dart';
import 'features/splash/domain/usecases/change_lang_usecase.dart';
import 'features/splash/domain/usecases/get_saved_lang_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {

  // !---- Cubits ----!
  // splash
  sl.registerFactory<LocalizationCubit>(() => LocalizationCubit(getSavedLangUseCase: sl(), changeLangUseCase: sl()));
  // onboarding
  sl.registerFactory<AppGetStartedCubit>(() => AppGetStartedCubit(appGetStartedUseCase: sl()));
  // signup
  sl.registerFactory<UserPINRegistrationCubit>(() => UserPINRegistrationCubit(userPINRegistrationUseCase: sl()));


  // !---- Use cases ----!
  // splash
  sl.registerLazySingleton<ChangeLangUseCase>(() => ChangeLangUseCase(langRepository: sl()));
  sl.registerLazySingleton<GetSavedLangUseCase>(() => GetSavedLangUseCase(langRepository: sl()));
  // onboarding
  sl.registerLazySingleton<AppGetStartedUseCase>(() => AppGetStartedUseCase(userRepository: sl()));
  // signup
  sl.registerLazySingleton<UserPINRegistrationUseCase>(() => UserPINRegistrationUseCase(authenticationRepository: sl()));

  // !---- Repository ----!
  // authentication
  sl.registerLazySingleton<AuthenticationRepository>(() => AuthenticationRepositoryImpl(networkInfo: sl(), authenticationLocalDataSource: sl(), authenticationRemoteDataSource: sl(),));
  // user
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(networkInfo: sl(), userLocalDataSource: sl(), userRemoteDataSource: sl(),));
  // localization
  sl.registerLazySingleton<LocalizationRepository>(() => LocalizationRepositoryImpl(localizationLocalDataSource: sl()));


  // !---- Data Sources ----!
  // authentication
  sl.registerLazySingleton<AuthenticationLocalDataSource>(() => AuthenticationLocalDataSourceImpl(storageManager: sl()));
  sl.registerLazySingleton<AuthenticationRemoteDataSource>(() => AuthenticationRemoteDataSourceImpl(apiConsumer: sl()));
  // user
  sl.registerLazySingleton<UserLocalDataSource>(() => UserLocalDataSourceImpl(storageManager: sl()));
  sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(apiConsumer: sl()));
  // localization
  sl.registerLazySingleton<LocalizationLocalDataSource>(() => LocalizationLocalDataSourceImpl(sharedPreferences: sl()));


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
  sl.registerLazySingleton<IBiometricAuthenticationManager>(() => BiometricAuthenticationManager(localAuthentication: sl(), storageManager: sl()));
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => Dio());
}
