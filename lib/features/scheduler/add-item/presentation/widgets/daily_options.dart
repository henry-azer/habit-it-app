import 'package:flutter/material.dart';

import '../../../../../config/locale/app_localization_helper.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_localization_strings.dart';

/// Trivial sub-form for the daily flavor — daily has no extra inputs after
/// recurrence is picked. Lives as a widget so the add screen's `if (kind ==
/// daily)` branch has a clear render target.
class DailyOptions extends StatelessWidget {
  const DailyOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        AppLocalizationHelper.translate(
          context,
          AppLocalizationKeys.schedulerDailyStartsToday,
        ),
        style: TextStyle(
          color: AppColors.fontPrimary,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
