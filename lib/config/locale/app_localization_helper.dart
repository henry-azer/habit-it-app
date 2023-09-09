import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

class AppLocalizationHelper {
  static String translate(BuildContext context, String key) {
    return AppLocalizations.of(context)!.translate(key)!;
  }
}
