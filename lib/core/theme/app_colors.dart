import 'package:flutter/material.dart';

/// Theme color tokens.
///
/// See [`TECHNICAL_STORIES.md` §10](../../../../docs/TECHNICAL_STORIES.md) for the
/// mapping from legacy `AppColors` values to these tokens.
///
/// PO override G-001: default accent on first launch is [accentDefault] = `#00A36C`
/// (green), not the legacy `#1C2D32` slate.
abstract final class AppColors {
  AppColors._();

  // ---- Defaults ----
  static const Color accentDefault = Color(0xFF00A36C); // PO G-001

  // ---- Dark palette (current app behavior) ----
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF0E0E0E);
  static const Color darkSurfaceContainer = Color(0xFF1C2D32);
  static const Color darkSurfaceContainerHigh = Color(0xFF243A40);
  static const Color darkOnSurface = Color(0xFFFFFFFF);
  static const Color darkOnSurfaceVariant = Color(0xFFB8C2C5);
  static const Color darkPrimary = Color(0xFFFFFFFF);
  static const Color darkOutline = Color(0x40FFFFFF);

  // ---- Light palette ----
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF5F5F5);
  static const Color lightSurfaceContainer = Color(0xFFE7ECEE);
  static const Color lightSurfaceContainerHigh = Color(0xFFD8DFE2);
  static const Color lightOnSurface = Color(0xFF0A0A0A);
  static const Color lightOnSurfaceVariant = Color(0xFF3F4A4D);
  static const Color lightPrimary = Color(0xFF0A0A0A);
  static const Color lightOutline = Color(0x400A0A0A);

  // ---- Cross-theme semantic ----
  static const Color error = Color(0xFF900C3F);
  static const Color success = Color(0xFF00A36C);
  static const Color warning = Color(0xFFF44336);

  // ---- Brand colors ----
  static const Color brandLinkedIn = Color(0xFF0072B1);
  static const Color brandGitHubDark = Color(0xFF000000);
  static const Color brandGitHubLight = Color(0xFFFFFFFF);
  static const Color brandFacebook = Color(0xFF3B5998);
  static const Color brandWhatsApp = Color(0xFF075E54);
  static const Color brandOutlook = Color(0xFF127CD6);

  // ---- SET-005 accent swatches (G-001 order: green default first) ----
  static const Color accentGreen = Color(0xFF00A36C);
  static const Color accentSlate = Color(0xFF1C2D32);
  static const Color accentCoral = Color(0xFFFF725E);
  static const Color accentBlue = Color(0xFF0072B1);
  static const Color accentDeepRed = Color(0xFF900C3F);

  static const List<Color> accentSwatches = [
    accentGreen,
    accentSlate,
    accentCoral,
    accentBlue,
    accentDeepRed,
  ];

  // ---- Legacy back-compat (used by un-ported screens; do NOT add new uses) ----
  static const Color legacyBackground = darkBackground;
  static const Color legacyAccent = darkSurfaceContainer;
  static const Color legacyPrimary = Color(0xFFFFFFFF);
  static const Color legacySecondary = Color(0xFF000000);
  static const Color legacyFontPrimary = Color(0xFFFFFFFF);
  static const Color legacyFontSecondary = Color(0xCCFFFFFF);
  static const Color legacyBorder = Color(0x40FFFFFF);
  static const Color legacyGreen = Color(0xFF00A36C);
  static const Color legacyRed = Color(0xFFF44336);
}
