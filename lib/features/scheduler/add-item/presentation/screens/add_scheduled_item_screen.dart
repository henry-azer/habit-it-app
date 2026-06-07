import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../config/locale/app_localization_helper.dart';
import '../../../../../core/managers/storage-manager/i_storage_manager.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_local_storage_strings.dart';
import '../../../../../core/utils/app_localization_strings.dart';
import '../../../../../core/utils/app_notifier.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../../../../core/utils/date_util.dart';
import '../../../../../core/utils/numbers_util.dart';
import '../../../../../core/widgets/appbar/header_widget.dart';
import '../../../../../core/widgets/buttons/button_widget.dart';
import '../../../../../data/datasources/scheduler/scheduled_item_local_datasource.dart';
import '../../../../../data/entities/recurrence.dart';
import '../../../../../data/entities/scheduled_item.dart';
import '../../../../../data/enums/habit_state.dart';
import '../../../../../data/enums/recurrence_kind.dart';
import '../widgets/daily_options.dart';
import '../widgets/monthly_options.dart';
import '../widgets/one_off_options.dart';
import '../widgets/recurrence_kind_picker.dart';
import '../widgets/weekly_options.dart';
import '../widgets/yearly_options.dart';

/// Unified add screen for any of the five recurrence flavors. Form fields
/// below the recurrence picker adapt to the selected kind. Saves to the
/// `ScheduledItemLocalDataSource` and pops the new item back to the caller.
///
/// Story 2.x acceptance criteria covered:
/// - 2.1 one-off: date picker, back-date allowed with hint.
/// - 2.2 daily: no extra inputs, startDate=today.
/// - 2.3 weekly: weekday chips (`SelectWeekDays`), >=1 weekday required,
///   "use Daily instead" hint at 7-of-7.
/// - 2.4 monthly: dayOfMonth dropdown, short-months hint, carry-over toggle
///   defaults true.
/// - 2.5 yearly: month + day dropdowns, leap-day hint, one-time "no
///   notifications" snackbar.
class AddScheduledItemScreen extends StatefulWidget {
  final RecurrenceKind? initialKind;
  final DateTime? prefillDate;

  const AddScheduledItemScreen({super.key, this.initialKind, this.prefillDate});

  @override
  State<AddScheduledItemScreen> createState() => _AddScheduledItemScreenState();
}

class _AddScheduledItemScreenState extends State<AddScheduledItemScreen> {
  final TextEditingController _nameController = TextEditingController();
  late RecurrenceKind _kind;
  late DateTime _oneOffDate;
  List<String> _weeklyDays = const <String>[];
  late int _monthlyDay;
  bool _monthlyCarryOver = true;
  late int _yearlyMonth;
  late int _yearlyDay;

  late ScheduledItemLocalDataSource _datasource;
  late IStorageManager _storage;

  @override
  void initState() {
    super.initState();
    _kind = widget.initialKind ?? RecurrenceKind.oneOff;
    final today = DateUtil.getTodayDate();
    _oneOffDate = widget.prefillDate ?? today;
    _monthlyDay = today.day;
    _yearlyMonth = today.month;
    _yearlyDay = today.day;
    _datasource = GetIt.instance<ScheduledItemLocalDataSource>();
    _storage = GetIt.instance<IStorageManager>();
    _maybeShowYearlyHint();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _maybeShowYearlyHint() async {
    if (_kind != RecurrenceKind.yearly) return;
    final shown = await _storage.getValue<bool>(
          AppLocalStorageKeys.schedulerYearlyHintShown,
        ) ??
        false;
    if (shown || !mounted) return;
    await _storage.setValue(
      AppLocalStorageKeys.schedulerYearlyHintShown,
      true,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizationHelper.translate(
            context,
            AppLocalizationKeys.schedulerYearlyNoNotificationsHint,
          ),
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  bool get _canSave {
    if (_nameController.text.trim().isEmpty) return false;
    switch (_kind) {
      case RecurrenceKind.oneOff:
      case RecurrenceKind.daily:
      case RecurrenceKind.monthlyByDay:
      case RecurrenceKind.yearly:
        return true;
      case RecurrenceKind.weekly:
        return _weeklyDays.isNotEmpty;
    }
  }

  Recurrence _buildRecurrence() {
    final today = DateUtil.getTodayDate();
    switch (_kind) {
      case RecurrenceKind.oneOff:
        return Recurrence.oneOff(_oneOffDate);
      case RecurrenceKind.daily:
        return Recurrence.daily(today);
      case RecurrenceKind.weekly:
        return Recurrence.weekly(_weeklyDays, today);
      case RecurrenceKind.monthlyByDay:
        return Recurrence.monthlyByDay(_monthlyDay, today);
      case RecurrenceKind.yearly:
        return Recurrence.yearly(_yearlyMonth, _yearlyDay, today);
    }
  }

  Future<void> _save() async {
    if (!_canSave) {
      AppNotifier.showSnackBar(
        context: context,
        message: AppLocalizationHelper.translate(
          context,
          _kind == RecurrenceKind.weekly &&
                  _nameController.text.trim().isNotEmpty
              ? AppLocalizationKeys.schedulerWeeklyPickAtLeastOne
              : AppLocalizationKeys.schedulerItemNameRequired,
        ),
      );
      return;
    }
    Recurrence recurrence;
    try {
      recurrence = _buildRecurrence();
    } on ArgumentError catch (_) {
      AppNotifier.showSnackBar(
        context: context,
        message: AppLocalizationHelper.translate(
          context,
          AppLocalizationKeys.schedulerItemNameRequired,
        ),
      );
      return;
    }
    final item = ScheduledItem(
      id: NumbersUtil.getRandomId(),
      name: _nameController.text.trim(),
      createdDate: DateUtil.getTodayDate(),
      recurrence: recurrence,
      completionLog: <String, HabitState>{},
      // Monthly defaults true; every other flavor defaults false.
      carryOverEnabled:
          _kind == RecurrenceKind.monthlyByDay ? _monthlyCarryOver : false,
    );
    await _datasource.add(item);
    if (!mounted) return;
    Navigator.of(context).pop(item);
  }

  void _onKindChanged(RecurrenceKind next) {
    setState(() {
      final wasMonthly = _kind == RecurrenceKind.monthlyByDay;
      _kind = next;
      if (next == RecurrenceKind.monthlyByDay && !wasMonthly) {
        // Adopt the per-flavor default when switching INTO monthly.
        _monthlyCarryOver = true;
      } else if (next != RecurrenceKind.monthlyByDay) {
        _monthlyCarryOver = false;
      }
    });
    if (next == RecurrenceKind.yearly) {
      _maybeShowYearlyHint();
    }
  }

  Widget _buildFlavorFields() {
    switch (_kind) {
      case RecurrenceKind.oneOff:
        return OneOffOptions(
          date: _oneOffDate,
          onChanged: (date) => setState(() => _oneOffDate = date),
        );
      case RecurrenceKind.daily:
        return const DailyOptions();
      case RecurrenceKind.weekly:
        return WeeklyOptions(
          initialDays: _weeklyDays,
          onChanged: (days) => setState(() => _weeklyDays = days),
        );
      case RecurrenceKind.monthlyByDay:
        return MonthlyOptions(
          initialDayOfMonth: _monthlyDay,
          initialCarryOverEnabled: _monthlyCarryOver,
          onDayChanged: (d) => setState(() => _monthlyDay = d),
          onCarryOverChanged: (v) => setState(() => _monthlyCarryOver = v),
        );
      case RecurrenceKind.yearly:
        return YearlyOptions(
          initialMonth: _yearlyMonth,
          initialDay: _yearlyDay,
          onMonthChanged: (m) => setState(() => _yearlyMonth = m),
          onDayChanged: (d) => setState(() => _yearlyDay = d),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            HeaderWidget(
              title: AppLocalizationHelper.translate(
                context,
                AppLocalizationKeys.schedulerAddTitle,
              ),
              backButton: true,
              height: 125,
              onPressBack: () => Navigator.of(context).pop(),
              titleStyle: AppTextStyles.headerTitle,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizationHelper.translate(
                          context,
                          AppLocalizationKeys.schedulerItemName,
                        ),
                        style: TextStyle(
                          color: AppColors.fontPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nameController,
                        maxLength: 60,
                        style: TextStyle(color: AppColors.fontPrimary),
                        decoration: InputDecoration(
                          hintText: AppLocalizationHelper.translate(
                            context,
                            AppLocalizationKeys.schedulerItemNameHint,
                          ),
                          hintStyle: TextStyle(color: AppColors.grey),
                          counterStyle: TextStyle(color: AppColors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        AppLocalizationHelper.translate(
                          context,
                          AppLocalizationKeys.schedulerRecurrenceTitle,
                        ),
                        style: TextStyle(
                          color: AppColors.fontPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RecurrenceKindPicker(
                        selected: _kind,
                        onChanged: _onKindChanged,
                      ),
                      const SizedBox(height: 24),
                      _buildFlavorFields(),
                      const SizedBox(height: 32),
                      Center(
                        child: ButtonWidget(
                          width: 220,
                          height: 45,
                          borderRadius: 0,
                          borderWidth: 1.0,
                          borderColor: AppColors.border,
                          backgroundColor:
                              _canSave ? AppColors.secondary : AppColors.grey,
                          onPress: _canSave ? _save : () {},
                          child: Text(
                            AppLocalizationHelper.translate(
                              context,
                              AppLocalizationKeys.schedulerSave,
                            ),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.signupSuccessButton,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
