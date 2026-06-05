import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_entity.freezed.dart';
part 'app_entity.g.dart';

/// App-level state held in the `app` Hive box under `app_state`.
@freezed
sealed class AppEntity with _$AppEntity {
  const factory AppEntity({
    @Default(false) bool init,
    @Default('') String initDate,
    @Default('') String lastDate,
    @Default(false) bool migratedV1,
  }) = _AppEntity;

  factory AppEntity.defaults() => const AppEntity();

  factory AppEntity.fromJson(Map<String, dynamic> json) =>
      _$AppEntityFromJson(json);
}
