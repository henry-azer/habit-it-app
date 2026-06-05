import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Compatibility shim for the legacy `line_awesome_flutter` package, which
/// was removed from pubspec in FND-001. Re-exports identifiers used by
/// pre-Foundation screens as `IconDataBrands` (font_awesome subtype).
///
/// All identifiers are static getters typed `dynamic` so that legacy const
/// `Icon(LineAwesomeIcons.x)` calls type-check (Icon's `icon` parameter is
/// `IconData?`, and `IconDataBrands` is an IconData subtype but Dart's const
/// type-checking requires the surface type to match exactly).
///
/// New code MUST import `font_awesome_flutter` directly. This file is
/// scheduled for removal once `lib/features/profile/`, `lib/features/habit/`
/// and `lib/core/widgets/appbar/` are rewritten under the SET / ENG sprints.
abstract final class LineAwesomeIcons {
  LineAwesomeIcons._();

  // ignore_for_file: non_constant_identifier_names
  static dynamic get angle_left => FontAwesomeIcons.angleLeft;
  static dynamic get angle_right => FontAwesomeIcons.angleRight;
  static dynamic get clipboard_list => FontAwesomeIcons.clipboardList;
  static dynamic get pie_chart => FontAwesomeIcons.chartPie;
  static dynamic get user => FontAwesomeIcons.user;
  static dynamic get user_edit => FontAwesomeIcons.userPen;
  static dynamic get info => FontAwesomeIcons.circleInfo;
  static dynamic get alternate_sign_out => FontAwesomeIcons.rightFromBracket;
  static dynamic get linkedin_in => FontAwesomeIcons.linkedinIn;
  static dynamic get github => FontAwesomeIcons.github;
  static dynamic get what_s_app => FontAwesomeIcons.whatsapp;
  static dynamic get facebook_f => FontAwesomeIcons.facebookF;
  static dynamic get save => FontAwesomeIcons.floppyDisk;
  static dynamic get link => FontAwesomeIcons.link;
  static dynamic get unlink => FontAwesomeIcons.linkSlash;
  static dynamic get pushed => FontAwesomeIcons.thumbtack;
  static dynamic get tools => FontAwesomeIcons.screwdriverWrench;
  static dynamic get list => FontAwesomeIcons.list;
}
