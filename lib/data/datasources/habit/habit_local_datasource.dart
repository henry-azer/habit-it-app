import '../../../core/managers/storage-manager/i_storage_manager.dart';

abstract class HabitLocalDataSource {}

class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  final IStorageManager storageManager;

  HabitLocalDataSourceImpl({required this.storageManager});
}
