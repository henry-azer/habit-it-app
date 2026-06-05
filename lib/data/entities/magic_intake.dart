import 'package:freezed_annotation/freezed_annotation.dart';

part 'magic_intake.freezed.dart';
part 'magic_intake.g.dart';

/// AI coach session input (AI-005). Freezed for shape stability; never
/// persisted (PO G-011 — sessions are session-local by design).
@freezed
sealed class MagicIntake with _$MagicIntake {
  const factory MagicIntake({
    required String feelingText,
    @Default(<String, String>{}) Map<String, String> answers,
  }) = _MagicIntake;

  factory MagicIntake.fromJson(Map<String, dynamic> json) =>
      _$MagicIntakeFromJson(json);
}
