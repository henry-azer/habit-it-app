import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Notifiers driving live theme + locale switches.
///
/// Per PO G-012, locale changes update gradually via `languageNotifier`; ViewModels
/// MUST NOT push localised strings through their streams. Strings are read at
/// widget build time via `'key'.tr`.
final ValueNotifier<ThemeMode> themeModeNotifier =
    ValueNotifier<ThemeMode>(ThemeMode.system);

/// Default accent on first launch is `#00A36C` (PO G-001).
final ValueNotifier<Color> accentColorNotifier =
    ValueNotifier<Color>(AppColors.accentDefault);

final ValueNotifier<Locale> languageNotifier =
    ValueNotifier<Locale>(const Locale('en'));
