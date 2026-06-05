import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_it/core/theme/app_colors.dart';
import 'package:habit_it/core/theme/app_theme.dart';

void main() {
  group('ThemeFactory', () {
    test('default light theme uses G-001 accent green', () {
      final theme = ThemeFactory.light();
      expect(theme.brightness, Brightness.light);
      expect(theme.colorScheme.primaryContainer, AppColors.accentDefault);
    });

    test('default dark theme uses G-001 accent green', () {
      final theme = ThemeFactory.dark();
      expect(theme.brightness, Brightness.dark);
      expect(theme.colorScheme.primaryContainer, AppColors.accentDefault);
      expect(theme.scaffoldBackgroundColor, AppColors.darkBackground);
    });

    test('custom accent flows through colorScheme', () {
      final theme = ThemeFactory.dark(accent: AppColors.accentCoral);
      expect(theme.colorScheme.primaryContainer, AppColors.accentCoral);
      expect(theme.colorScheme.secondary, AppColors.accentCoral);
    });
  });
}
