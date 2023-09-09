import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/api/api_consumer.dart';
import 'core/api/app_authentication.dart';
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
import 'features/splash/domain/usecases/change_lang_usecase.dart';
import 'features/splash/domain/usecases/get_saved_lang_usecase.dart';
import 'features/splash/presentation/cubit/localization_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {

  // !---- Cubits ----!
  // splash
  sl.registerFactory<LocalizationCubit>(() => LocalizationCubit(getSavedLangUseCase: sl(), changeLangUseCase: sl()));


  // !---- Use cases ----!
  // splash
  sl.registerLazySingleton<ChangeLangUseCase>(() => ChangeLangUseCase(langRepository: sl()));
  sl.registerLazySingleton<GetSavedLangUseCase>(() => GetSavedLangUseCase(langRepository: sl()));


  // !---- Repository ----!
  // authentication
  sl.registerLazySingleton<AuthenticationRepository>(() => AuthenticationRepositoryImpl(networkInfo: sl(), authenticationLocalDataSource: sl(), authenticationRemoteDataSource: sl(),));
  // user
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(networkInfo: sl(), userLocalDataSource: sl(), userRemoteDataSource: sl(),));
  // localization
  sl.registerLazySingleton<LocalizationRepository>(() => LocalizationRepositoryImpl(localizationLocalDataSource: sl()));


  // !---- Data Sources ----!
  // authentication
  sl.registerLazySingleton<AuthenticationLocalDataSource>(() => AuthenticationLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<AuthenticationRemoteDataSource>(() => AuthenticationRemoteDataSourceImpl(apiConsumer: sl()));
  // user
  sl.registerLazySingleton<UserLocalDataSource>(() => UserLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(apiConsumer: sl()));
  // localization
  sl.registerLazySingleton<LocalizationLocalDataSource>(() => LocalizationLocalDataSourceImpl(sharedPreferences: sl()));


  // !---- Core ----!
  sl.registerLazySingleton<AppAuthentication>(() => AppAuthenticationImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectionChecker: sl()));
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));


  // !---- External ----!
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => AppInterceptors(sl()));
  sl.registerLazySingleton(() => LogInterceptor(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
      error: true));
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => Dio());
}
