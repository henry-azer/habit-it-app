import 'dart:async';

import '../../../core/managers/storage-manager/i_storage_manager.dart';
import '../../../core/utils/app_local_storage_strings.dart';
import '../../../core/utils/date_util.dart';
import '../../entities/scheduled_item.dart';
import '../../enums/habit_state.dart';

/// CRUD + occurrence-log access for the unified scheduler store. Backed by a
/// single SharedPreferences key (`APP/SCHEDULER/ITEMS`) holding a JSON array
/// of [ScheduledItem]s. See `docs/scheduler/architecture.md` §4 + §7.
abstract class ScheduledItemLocalDataSource {
  Future<List<ScheduledItem>> getAll();
  Future<ScheduledItem?> getById(String id);
  Future<List<ScheduledItem>> getOccurringOn(DateTime date);

  Future<void> add(ScheduledItem item);
  Future<void> update(ScheduledItem item);

  /// §12.4 hard-delete: drops the entire item including its [completionLog].
  Future<void> remove(String id);

  /// §12.1 reorder via array position. No-op when ids match or are missing.
  Future<void> reorder(String movedId, String targetId);

  Future<HabitState?> getOccurrenceState(String id, DateTime date);
  Future<void> setOccurrenceState(String id, DateTime date, HabitState state);
}

class ScheduledItemLocalDataSourceImpl implements ScheduledItemLocalDataSource {
  final IStorageManager storageManager;

  /// Single-flight transaction queue. Mitigates risk #1 in
  /// `architecture.md` §11: every mutation is a read-modify-write of the full
  /// blob. The whole transaction (not just the `setValue` call) must be
  /// serialized — otherwise two concurrent `setOccurrenceState` calls both
  /// `getAll` the same snapshot and the second write wipes the first.
  Future<void>? _pendingTransaction;

  ScheduledItemLocalDataSourceImpl({required this.storageManager});

  @override
  Future<List<ScheduledItem>> getAll() async {
    final raw = await storageManager.getValue<List<dynamic>>(
      AppLocalStorageKeys.schedulerItems,
    );
    if (raw == null || raw.isEmpty) return <ScheduledItem>[];
    return raw
        .map((e) => ScheduledItem.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<ScheduledItem?> getById(String id) async {
    final items = await getAll();
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  @override
  Future<List<ScheduledItem>> getOccurringOn(DateTime date) async {
    final items = await getAll();
    return items.where((item) => item.occursOn(date)).toList();
  }

  @override
  Future<void> add(ScheduledItem item) {
    return _runTransaction((items) {
      items.add(item);
    });
  }

  @override
  Future<void> update(ScheduledItem item) {
    return _runTransaction((items) {
      final index = items.indexWhere((it) => it.id == item.id);
      if (index == -1) return;
      items[index] = item;
    });
  }

  @override
  Future<void> remove(String id) {
    return _runTransaction((items) {
      items.removeWhere((it) => it.id == id);
    });
  }

  @override
  Future<void> reorder(String movedId, String targetId) {
    if (movedId == targetId) return Future.value();
    return _runTransaction((items) {
      final movedIndex = items.indexWhere((it) => it.id == movedId);
      final targetIndex = items.indexWhere((it) => it.id == targetId);
      if (movedIndex == -1 || targetIndex == -1) return;
      final moved = items.removeAt(movedIndex);
      // After removal, the target shifts left by one if it was past the moved.
      final adjustedTarget = (targetIndex > movedIndex)
          ? targetIndex - 1
          : targetIndex;
      items.insert(adjustedTarget, moved);
    });
  }

  @override
  Future<HabitState?> getOccurrenceState(String id, DateTime date) async {
    final item = await getById(id);
    if (item == null) return null;
    return item.completionLog[DateUtil.isoDate(date)];
  }

  @override
  Future<void> setOccurrenceState(String id, DateTime date, HabitState state) {
    return _runTransaction((items) {
      final index = items.indexWhere((it) => it.id == id);
      if (index == -1) return;
      items[index].completionLog[DateUtil.isoDate(date)] = state;
    });
  }

  /// Read-modify-write through a single-flight queue. The [mutate] callback
  /// receives the freshly-loaded item list and mutates it in place; we then
  /// persist the result. Chaining via [_pendingTransaction] guarantees that
  /// concurrent calls observe each other's writes.
  Future<void> _runTransaction(
    void Function(List<ScheduledItem> items) mutate,
  ) async {
    final prev = _pendingTransaction;
    final c = Completer<void>();
    _pendingTransaction = c.future;
    if (prev != null) {
      try {
        await prev;
      } catch (_) {
        // The prior transaction's error is its caller's problem; proceed.
      }
    }
    try {
      final items = await getAll();
      mutate(items);
      await storageManager.setValue(
        AppLocalStorageKeys.schedulerItems,
        items.map((it) => it.toJson()).toList(),
      );
      c.complete();
    } catch (e, st) {
      c.completeError(e, st);
      rethrow;
    } finally {
      if (identical(_pendingTransaction, c.future)) {
        _pendingTransaction = null;
      }
    }
  }
}
