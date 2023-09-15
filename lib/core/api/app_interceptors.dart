import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/app_strings.dart';

class AppInterceptors extends Interceptor {
  AppInterceptors();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
    options.headers[AppStrings.contentType] = AppStrings.applicationJson;
    // if (appAuthentication.isUserAuthenticated() && !appAuthentication.isUserLogging()) {
    //   options.headers[AppStrings.authorization] = 'Bearer ${appAuthentication.getBearerToken()}';
    // }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    debugPrint(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}
