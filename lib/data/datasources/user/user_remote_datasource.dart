import '../../../core/api/api_consumer.dart';

abstract class UserRemoteDataSource {}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiConsumer apiConsumer;

  UserRemoteDataSourceImpl({required this.apiConsumer});
}
