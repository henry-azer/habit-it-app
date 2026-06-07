import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../config/locale/app_localization_helper.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_localization_strings.dart';
import '../../../../../core/utils/app_notifier.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../../../../core/utils/date_util.dart';
import '../../../../../core/widgets/appbar/header_widget.dart';
import '../../../../../core/widgets/buttons/button_widget.dart';
import '../../../../../data/datasources/scheduler/scheduled_item_local_datasource.dart';
import '../../../../../data/entities/recurrence.dart';
import '../../../../../data/entities/scheduled_item.dart';
import '../../../../../data/enums/recurrence_kind.dart';
import '../../../add-item/presentation/widgets/monthly_options.dart';
import '../../../add-item/presentation/widgets/one_off_options.dart';
import '../../../add-item/presentation/widgets/recurrence_kind_picker.dart';
import '../../../add-item/presentation/widgets/weekly_options.dart';
import '../../../add-item/presentation/widgets/yearly_options.dart';

/// Full edit form for an existing `ScheduledItem`. Field locks per Story 2.x
/// AC:
/// - Recurrence kind: read-only (chip picker disabled). Changing kind would
///   orphan completionLog entries; user can delete and re-add instead.
/// - One-off date: editable when in the future, locked when past.
/// - Daily startDate: not editable (Story 2.2 AC).
/// - Weekly weekdays: editable; past log entries preserved on removal; no
///   back-fill on addition.
/// - Monthly dayOfMonth: editable; applies to future months only.
/// - Yearly month/day: editable; applies to future years only.
/// - Monthly carryOverEnabled: editable.
class EditScheduledItemScreen extends StatefulWidget {
  final String itemId;

  const EditScheduledItemScreen({super.key, required this.itemId});

  @override
  State<EditScheduledItemScreen> createState() =>
      _EditScheduledItemScreenState();
}

class _EditScheduledItemScreenState extends State<EditScheduledItemScreen> {
  ScheduledItem? _item;
  late TextEditingController _nameController;
  late ScheduledItemLocalDataSource _datasource;
  bool _loading = true;

  // Per-flavor editable copies, hydrated from `_item.recurrence`.
  DateTime? _oneOffDate;
  List<String>? _weeklyDays;
  int? _monthlyDay;
  bool _monthlyCarryOver = false;
  int? _yearlyMonth;
  int? _yearlyDay;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _datasource = GetIt.instance<ScheduledItemLocalDataSource>();
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final item = await _datasource.getById(widget.itemId);
    if (!mounted) return;
    if (item == null) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _item = item;
      _nameController.text = item.name;
      _monthlyCarryOver = item.carryOverEnabled;
      switch (item.recurrence.kind) {
        case RecurrenceKind.oneOff:
          _oneOffDate = item.recurrence.oneOffDate;
          break;
        case RecurrenceKind.daily:
          break;
        case RecurrenceKind.weekly:
          _weeklyDays = List<String>.from(item.recurrence.weekdays!);
          break;
        case RecurrenceKind.monthlyByDay:
          _monthlyDay = item.recurrence.dayOfMonth;
          break;
        case RecurrenceKind.yearly:
          _yearlyMonth = item.recurrence.yearlyMonth;
          _yearlyDay = item.recurrence.yearlyDay;
          break;
      }
      _loading = false;
    });
  }

  bool get _oneOffDateLocked {
    final item = _item;
    if (item == null) return true;
    if (item.recurrence.kind != RecurrenceKind.oneOff) return true;
    final originalDate = item.recurrence.oneOffDate!;
    final today = DateUtil.getTodayDate();
    return DateTime(
      originalDate.year,
      originalDate.month,
      originalDate.day,
    ).isBefore(today);
  }

  bool get _canSave {
    if (_item == null) return false;
    if (_nameController.text.trim().isEmpty) return false;
    switch (_item!.recurrence.kind) {
      case RecurrenceKind.weekly:
        return _weeklyDays != null && _weeklyDays!.isNotEmpty;
      case RecurrenceKind.oneOff:
      case RecurrenceKind.daily:
      case RecurrenceKind.monthlyByDay:
      case RecurrenceKind.yearly:
        return true;
    }
  }

  Future<void> _save() async {
    final item = _item;
    if (item == null) return;
    if (!_canSave) {
      AppNotifier.showSnackBar(
        context: context,
        message: AppLocalizationHelper.translate(
          context,
          item.recurrence.kind == RecurrenceKind.weekly
              ? AppLocalizationKeys.schedulerWeeklyPickAtLeastOne
              : AppLocalizationKeys.schedulerItemNameRequired,
        ),
      );
      return;
    }
    item.name = _nameController.text.trim();
    final originalStartDate =
        item.recurrence.startDate ?? item.recurrence.oneOffDate!;
    switch (item.recurrence.kind) {
      case RecurrenceKind.oneOff:
        item.recurrence = Recurrence.oneOff(_oneOffDate ?? originalStartDate);
        break;
      case RecurrenceKind.daily:
        // startDate is locked; nothing to rebuild beyond name.
        break;
      case RecurrenceKind.weekly:
        try {
          item.recurrence = Recurrence.weekly(
            _weeklyDays!,
            originalStartDate,
          );
        } on ArgumentError catch (_) {
          AppNotifier.showSnackBar(
            context: context,
            message: AppLocalizationHelper.translate(
              context,
              AppLocalizationKeys.schedulerWeeklyPickAtLeastOne,
            ),
          );
          return;
        }
        break;
      case RecurrenceKind.monthlyByDay:
        item.recurrence = Recurrence.monthlyByDay(
          _monthlyDay!,
          originalStartDate,
        );
        item.carryOverEnabled = _monthlyCarryOver;
        break;
      case RecurrenceKind.yearly:
        item.recurrence = Recurrence.yearly(
          _yearlyMonth!,
          _yearlyDay!,
          originalStartDate,
        );
        break;
    }
    await _datasource.update(item);
    if (!mounted) return;
    Navigator.of(context).pop(item);
  }

  Future<void> _confirmDelete() async {
    final item = _item;
    if (item == null) return;
    AppNotifier.showAlertDialog(
      context: context,
      message: AppLocalizationHelper.translate(
        context,
        AppLocalizationKeys.schedulerDeleteConfirm,
      ),
      onClickYes: () async {
        Navigator.of(context).pop();
        await _datasource.remove(item.id);
        if (!mounted) return;
        Navigator.of(context).pop(true);
      },
    );
  }

  Widget _buildFlavorFields() {
    final item = _item!;
    switch (item.recurrence.kind) {
      case RecurrenceKind.oneOff:
        return OneOffOptions(
          date: _oneOffDate ?? item.recurrence.oneOffDate!,
          onChanged: (date) => setState(() => _oneOffDate = date),
          enabled: !_oneOffDateLocked,
          lockHint: _oneOffDateLocked
              ? AppLocalizationHelper.translate(
                  context,
                  AppLocalizationKeys.schedulerOneOffPastDateLocked,
                )
              : null,
        );
      case RecurrenceKind.daily:
        return Text(
          AppLocalizationHelper.translate(
            context,
            AppLocalizationKeys.schedulerEditStartDateLockedHint,
          ),
          style: TextStyle(
            color: AppColors.grey,
            fontStyle: FontStyle.italic,
            fontSize: 12,
          ),
        );
      case RecurrenceKind.weekly:
        return WeeklyOptions(
          initialDays: _weeklyDays ?? const <String>[],
          onChanged: (days) => setState(() => _weeklyDays = days),
        );
      case RecurrenceKind.monthlyByDay:
        return MonthlyOptions(
          initialDayOfMonth: _monthlyDay!,
          initialCarryOverEnabled: _monthlyCarryOver,
          onDayChanged: (d) => setState(() => _monthlyDay = d),
          onCarryOverChanged: (v) => setState(() => _monthlyCarryOver = v),
        );
      case RecurrenceKind.yearly:
        return YearlyOptions(
          initialMonth: _yearlyMonth!,
          initialDay: _yearlyDay!,
          onMonthChanged: (m) => setState(() => _yearlyMonth = m),
          onDayChanged: (d) => setState(() => _yearlyDay = d),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = _item;
    return Material(
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            HeaderWidget(
              title: AppLocalizationHelper.translate(
                context,
                AppLocalizationKeys.schedulerEditTitle,
              ),
              backButton: true,
              height: 125,
              onPressBack: () => Navigator.of(context).pop(),
              titleStyle: AppTextStyles.headerTitle,
            ),
            Expanded(
              child: _loading || item == null
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.secondary,
                      ),
                    )
                  : SingleChildScrollView(
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
                                  borderSide:
                                      BorderSide(color: AppColors.border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  borderSide:
                                      BorderSide(color: AppColors.border),
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
                              selected: item.recurrence.kind,
                              onChanged: (_) {},
                              readOnly: true,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppLocalizationHelper.translate(
                                context,
                                AppLocalizationKeys.schedulerEditKindLockedHint,
                              ),
                              style: TextStyle(
                                color: AppColors.grey,
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                              ),
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
                                backgroundColor: _canSave
                                    ? AppColors.secondary
                                    : AppColors.grey,
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
                            const SizedBox(height: 12),
                            Center(
                              child: TextButton.icon(
                                onPressed: _confirmDelete,
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: AppColors.error,
                                ),
                                label: Text(
                                  AppLocalizationHelper.translate(
                                    context,
                                    AppLocalizationKeys.schedulerDelete,
                                  ),
                                  style: TextStyle(color: AppColors.error),
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
