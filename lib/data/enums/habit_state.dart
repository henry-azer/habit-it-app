import 'package:json_annotation/json_annotation.dart';

/// Habit-day state.
///
/// **Ordinal stability:** `CREATED`/`DONE`/`NOT_DONE`/`SUSPENDED` retain their
/// legacy `.index` positions (0..3) so existing on-disk payloads continue to
/// load. `IN_PROGRESS` is appended at the end (FND-003 AC#3) and is only
/// emitted by quantitative habits (UX-001).
///
/// Names are deliberately SCREAMING_CASE to keep source-level compatibility
/// with legacy screens that still reference `HabitState.DONE` etc. New code
/// may also use the lower-case aliases (e.g. [done]) via the static getters.
// ignore_for_file: constant_identifier_names
@JsonEnum(valueField: 'wireName')
enum HabitState {
  CREATED('CREATED'),
  DONE('DONE'),
  NOT_DONE('NOT_DONE'),
  SUSPENDED('SUSPENDED'),
  IN_PROGRESS('IN_PROGRESS');

  const HabitState(this.wireName);
  final String wireName;

  // ---- camelCase aliases for new code (FND-006 onwards) ----
  static const HabitState created = HabitState.CREATED;
  static const HabitState done = HabitState.DONE;
  static const HabitState notDone = HabitState.NOT_DONE;
  static const HabitState suspended = HabitState.SUSPENDED;
  static const HabitState inProgress = HabitState.IN_PROGRESS;

  /// Maps a legacy `.index` int (used in payloads written prior to FND-003)
  /// to the corresponding enum value. Out-of-range indexes coerce to
  /// [HabitState.CREATED] (defensive — legacy data should never produce one).
  static HabitState fromLegacyIndex(int i) =>
      (i >= 0 && i < HabitState.values.length)
          ? HabitState.values[i]
          : HabitState.CREATED;

  /// Round-trips both legacy (`int`) and modern (`String`) JSON representations.
  static HabitState fromJsonDynamic(Object? raw) {
    if (raw is int) return fromLegacyIndex(raw);
    if (raw is String) {
      for (final s in HabitState.values) {
        if (s.wireName == raw) return s;
      }
    }
    return HabitState.CREATED;
  }
}
