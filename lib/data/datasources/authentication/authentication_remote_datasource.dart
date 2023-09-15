import '../../../core/api/api_consumer.dart';

abstract class AuthenticationRemoteDataSource {}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final ApiConsumer apiConsumer;

  AuthenticationRemoteDataSourceImpl({required this.apiConsumer});
}
