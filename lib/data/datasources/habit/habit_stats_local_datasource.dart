import '../../../core/managers/storage-manager/i_storage_manager.dart';
import 'habit_local_datasource.dart';

abstract class HabitStatsLocalDataSource {}

class HabitStatsLocalDataSourceImpl implements HabitStatsLocalDataSource {
  final HabitLocalDataSource habitLocalDataSource;
  final IStorageManager storageManager;

  HabitStatsLocalDataSourceImpl(
      {required this.storageManager, required this.habitLocalDataSource});
}
