/// Border-radius tokens. Use [smBorder] / [mdBorder] / [lgBorder] / [pillBorder]
/// instead of literal `BorderRadius.circular(8|12|16|999)` in screens.
abstract final class AppRadius {
  AppRadius._();

  static const double smBorder = 8;
  static const double mdBorder = 12;
  static const double lgBorder = 16;
  static const double pillBorder = 999;

  // Legacy header-curve constant kept until UX-002 ships
  static const double headerCurve = 60;
}
