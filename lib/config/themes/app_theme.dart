// Legacy theme entry-point — replaced by `core/theme/app_theme.dart` (FND-004).
//
// Kept as a deprecated forwarder so the import paths used by older docs do not
// 404. Use `ThemeFactory.dark()` / `ThemeFactory.light()` going forward.
import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart' as theme_factory;

@Deprecated('Use ThemeFactory from core/theme/app_theme.dart — see FND-004')
ThemeData appTheme() => theme_factory.ThemeFactory.dark();
