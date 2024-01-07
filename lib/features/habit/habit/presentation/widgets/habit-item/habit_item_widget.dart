import 'package:flutter/material.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:habit_it/core/utils/app_text_styles.dart';
import 'package:habit_it/core/utils/media_query_values.dart';
import 'package:habit_it/data/entities/habit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../../../core/widgets/day-picker/model/day_in_week.dart';
import '../../../../../../core/widgets/day-picker/widgets/select_day.dart';

class HabitItemWidget extends StatefulWidget {
  final Habit habit;
  final int selectedDay;
  final Function(Habit) onPressRemove;
  final Function(Habit) onPressSave;
  final Function(Habit) onPressActivate;

  const HabitItemWidget({
    Key? key,
    required this.habit,
    required this.onPressRemove,
    required this.onPressSave,
    required this.onPressActivate,
    required this.selectedDay,
  }) : super(key: key);

  @override
  State<HabitItemWidget> createState() => _HabitItemWidgetState();
}

class _HabitItemWidgetState extends State<HabitItemWidget> {
  TextEditingController textEditingController = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    textEditingController.text = widget.habit.name;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        color: AppColors.accent,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 28,
                  height: 28,
                  child: Icon(
                    Icons.drag_handle_outlined,
                    color: AppColors.white.withOpacity(0.9),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 20),
                isEditing
                    ? Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                maxLength: 16,
                                onChanged: (value) {
                                  widget.habit.name = value;
                                },
                                controller: textEditingController,
                                style: AppTextStyles.habitNameText,
                                cursorColor: AppColors.fontPrimary,
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.fontPrimary),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.fontPrimary),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: context.width * 0.12,
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: Row(
                          children: [
                            InkWell(
                              onDoubleTap: () {
                                setState(() {
                                  isEditing = true;
                                });
                              },
                              child: Text(widget.habit.name,
                                  style: AppTextStyles.habitNameText),
                            ),
                            const Expanded(child: SizedBox()),
                          ],
                        ),
                      ),
                isEditing
                    ? Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (textEditingController.text.isNotEmpty) {
                                widget.onPressSave(widget.habit);
                                setState(() {
                                  isEditing = false;
                                });
                              }
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: AppColors.black.withOpacity(0.3),
                              ),
                              child: Icon(LineAwesomeIcons.save,
                                  size: 18.0, color: AppColors.green),
                            ),
                          ),
                          const SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              setState(() {
                                textEditingController.text = widget.habit.name;
                                isEditing = false;
                              });
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: AppColors.black.withOpacity(0.3),
                              ),
                              child: Icon(Icons.restore_outlined,
                                  size: 18.0, color: AppColors.grey),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          InkWell(
                            onTap: () {
                              widget.onPressActivate(widget.habit);
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: AppColors.black.withOpacity(0.3),
                              ),
                              child: Icon(
                                  (widget.habit.values.containsKey(widget.selectedDay))
                                      ? (widget.habit.values[widget.selectedDay] ?? false)
                                          ? Icons.check
                                          : Icons.close
                                      : DateTime(DateTime.now().year, DateTime.now().month, widget.selectedDay, 0)
                                        .isBefore(widget.habit.createdDate)
                                      ? Icons.remove
                                      : Icons.close,
                                  size: 18.0,
                                  color:
                                  (widget.habit.values.containsKey(widget.selectedDay))
                                      ? (widget.habit.values[widget.selectedDay] ?? false)
                                      ? AppColors.green
                                      : AppColors.red
                                      : DateTime(DateTime.now().year, DateTime.now().month, widget.selectedDay, 0)
                                      .isBefore(widget.habit.createdDate)
                                      ? AppColors.grey
                                      : AppColors.red,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              widget.onPressRemove(widget.habit);
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: AppColors.black.withOpacity(0.3),
                              ),
                              child: Icon(Icons.delete_outline,
                                  size: 18.0, color: AppColors.grey),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
            isEditing
                ? Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      SelectWeekDays(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        days: DayInWeek.getWeekDaysBySelectedDays(
                            widget.habit.repeatDays),
                        border: false,
                        boxDecoration: BoxDecoration(
                            border: Border.all(color: AppColors.white)),
                        onSelect: (values) {
                          widget.habit.repeatDays = values;
                        },
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
