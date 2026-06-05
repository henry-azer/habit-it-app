import 'package:flutter/material.dart';

/// BuildContext convenience extensions used across feature code.
extension BuildContextX on BuildContext {
  /// Screen height (logical pixels).
  double get height => MediaQuery.of(this).size.height;

  /// Screen width (logical pixels).
  double get width => MediaQuery.of(this).size.width;

  /// `ThemeData` shortcut.
  ThemeData get theme => Theme.of(this);

  /// Active color scheme.
  ColorScheme get colors => Theme.of(this).colorScheme;

  /// Active text theme.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Is the active brightness dark.
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
