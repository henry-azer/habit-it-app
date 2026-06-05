import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/habit_state.dart';
import 'habit_reminder.dart';
import 'habit_schedule.dart';
import 'habit_target.dart';

part 'habit_entity.freezed.dart';
part 'habit_entity.g.dart';

/// Canonical Habit model (FND-003).
///
/// Adds new fields beyond the legacy `Habit`:
/// - [schedule]: replaces flat `repeatDays` with a sealed [HabitSchedule]
/// - [reminder]: optional [HabitReminder] (SCH-002)
/// - [target]: optional [HabitTarget] (UX-001)
/// - [categoryId], [noteIds], [progress]
///
/// On disk, [daysStates] uses `<dayInt>:<wireName:String>` since FND-003.
/// Legacy `<dayInt>:<index:int>` payloads still load via [_HabitStateConverter].
@freezed
sealed class HabitEntity with _$HabitEntity {
  const factory HabitEntity({
    required String id,
    required String name,
    required DateTime createdDate,
    @_HabitScheduleConverter() required HabitSchedule schedule,
    @_HabitStateMapConverter()
    @Default(<int, HabitState>{})
    Map<int, HabitState> daysStates,
    @Default(<int, int>{}) Map<int, int> progress,
    HabitReminder? reminder,
    HabitTarget? target,
    String? categoryId,
    @Default(<String>[]) List<String> noteIds,
    @Default(0) int sortIndex,
  }) = _HabitEntity;

  factory HabitEntity.fromJson(Map<String, dynamic> json) =>
      _$HabitEntityFromJson(json);
}

/// Round-trips the sealed [HabitSchedule] union through Map<String,dynamic>.
/// Needed because json_serializable defaults to a verbatim field assignment
/// for nested objects, which produces a runtime cast error when the inner
/// value is still a sealed instance.
class _HabitScheduleConverter
    implements JsonConverter<HabitSchedule, Map<String, dynamic>> {
  const _HabitScheduleConverter();

  @override
  HabitSchedule fromJson(Map<String, dynamic> json) =>
      HabitSchedule.fromJson(json);

  @override
  Map<String, dynamic> toJson(HabitSchedule object) => object.toJson();
}

/// JSON converter for `Map<int, HabitState>` that tolerates both legacy and
/// modern wire formats:
///
/// - **Legacy** (pre FND-003): `{"<day>": <int:HabitState.index>}`
/// - **Modern** (FND-003+):    `{"<day>": "<wireName:String>"}`
///
/// New writes always emit wireName.
class _HabitStateMapConverter
    implements JsonConverter<Map<int, HabitState>, Map<String, dynamic>> {
  const _HabitStateMapConverter();

  @override
  Map<int, HabitState> fromJson(Map<String, dynamic> json) {
    return json.map(
      (k, v) => MapEntry(int.parse(k), HabitState.fromJsonDynamic(v)),
    );
  }

  @override
  Map<String, dynamic> toJson(Map<int, HabitState> value) {
    return value.map((k, v) => MapEntry(k.toString(), v.wireName));
  }
}
