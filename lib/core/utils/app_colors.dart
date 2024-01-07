import 'package:flutter/material.dart';

import 'hex_color.dart';

class AppColors {
  static Color primary = HexColor('#000000');
  static Color secondary = HexColor('#FFFFFF');
  static Color accent = HexColor('#1C2D32');
  static Color secondaryAccent = HexColor('#FF725E');

  static Color fontPrimary = HexColor('#FFFFFF');
  static Color fontSecondary = HexColor('#000000');

  static Color background = HexColor('#000000');
  static Color error = HexColor('#900C3F');

  static Color button = HexColor('#FFFFFF');
  static Color border = HexColor('#FFFFFF');
  static Color borderSecondary = HexColor('#000000');
  static Color snackbar = HexColor('#FFFFFF');

  static Color black = HexColor('#000000');
  static Color white = HexColor('#FFFFFF');
  static Color grey = HexColor('#808080');
  static Color red = HexColor('#F44336');
  static Color green = HexColor('#00A36C');

  static Color facebook = HexColor('#3B5998');
  static Color github = HexColor('#000000');
  static Color linkedin = HexColor('#0072B1');
  static Color whatsapp = HexColor('#075E54');
  static Color outlook = HexColor('#127CD6');

  static MaterialColor primarySwatch = MaterialColor(
    accent.value,
    <int, Color>{
      50: const Color(0xFFE4E8EA),
      100: const Color(0xFFB9C4C8),
      200: const Color(0xFF8E9BA3),
      300: const Color(0xFF636F7E),
      400: const Color(0xFF3D4C5C),
      500: accent,
      600: const Color(0xFF172327),
      700: const Color(0xFF10171C),
      800: const Color(0xFF0B0F11),
      900: const Color(0xFF050608),
    },
  );
}
