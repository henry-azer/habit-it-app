/// Padding / margin spacing tokens. Use these instead of hard-coded
/// `SizedBox(height: 10)` or `MediaQuery.size.height * 0.0X` literals.
///
/// Mirrors `padlock_app/lib/core/theme/app_spacing.dart`.
abstract final class AppSpacing {
  AppSpacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
}
