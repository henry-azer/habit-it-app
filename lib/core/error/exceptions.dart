import 'package:equatable/equatable.dart';

import '../utils/app_strings.dart';

class GenericException extends Equatable implements Exception {
  final String message;

  const GenericException({required this.message});

  @override
  List<Object?> get props => [message];
}

class FetchDataException extends GenericException {
  const FetchDataException([message]) : super(message: AppStrings.fetchDataException);
}

class BadRequestException extends GenericException {
  const BadRequestException([message]) : super(message: AppStrings.badRequestException);
}

class UnauthorizedException extends GenericException {
  const UnauthorizedException([message]) : super(message: AppStrings.unauthorizedException);
}

class NotFoundException extends GenericException {
  const NotFoundException([message]) : super(message: AppStrings.notFoundException);
}

class ConflictException extends GenericException {
  const ConflictException([message]) : super(message: AppStrings.conflictException);
}

class InternalServerErrorException extends GenericException {
  const InternalServerErrorException([message]) : super(message: AppStrings.internalServerErrorException);
}

class NoInternetConnectionException extends GenericException {
  const NoInternetConnectionException([message]) : super(message: AppStrings.noNetworkConnectionException);
}

class CacheException extends GenericException {
  const CacheException([message]) : super(message: AppStrings.cacheException);
}
