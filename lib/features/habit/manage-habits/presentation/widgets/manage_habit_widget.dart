import 'package:flutter/material.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:habit_it/core/utils/app_text_styles.dart';
import 'package:habit_it/core/utils/media_query_values.dart';
import 'package:habit_it/data/entities/habit.dart';
import 'package:habit_it/data/enums/habit_state.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../../core/utils/date_util.dart';
import '../../../../../core/widgets/day-picker/model/day_in_week.dart';
import '../../../../../core/widgets/day-picker/widgets/select_day.dart';

class ManageHabitWidget extends StatefulWidget {
  final Habit habit;
  final int selectedDay;
  final Function(Habit) onPressSave;
  final Function(Habit) onPressSuspend;
  final Function(Habit) onPressUnsuspend;
  final Function(Habit) onPressRemove;

  const ManageHabitWidget({
    Key? key,
    required this.habit,
    required this.selectedDay,
    required this.onPressSave,
    required this.onPressSuspend,
    required this.onPressUnsuspend,
    required this.onPressRemove,
  }) : super(key: key);

  @override
  State<ManageHabitWidget> createState() => _ManageHabitWidgetState();
}

class _ManageHabitWidgetState extends State<ManageHabitWidget> {
  TextEditingController habitNameTexController = TextEditingController();
  List<String> repeatDays = [];
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    habitNameTexController.text = widget.habit.name;
    repeatDays = widget.habit.repeatDays;
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
                if (isEditing) ...{
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            maxLines: 1,
                            maxLength: 20,
                            onChanged: (value) {
                              habitNameTexController.text = value;
                            },
                            controller: habitNameTexController,
                            style: AppTextStyles.habitNameText,
                            cursorColor: AppColors.fontPrimary,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.fontPrimary),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.fontPrimary),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: context.width * 0.11,
                        ),
                      ],
                    ),
                  )
                } else ...{
                  Expanded(
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
                },
                if (isEditing) ...{
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (habitNameTexController.text.isNotEmpty) {
                                widget.habit.name = habitNameTexController.text;
                                widget.habit.repeatDays = repeatDays;
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
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              habitNameTexController.text = widget.habit.name;
                              repeatDays = widget.habit.repeatDays;
                              setState(() {
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
                              child: Icon(Icons.close,
                                  size: 18.0, color: AppColors.grey),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                } else ...{
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (widget.habit.daysStates[widget.selectedDay] ==
                                  HabitState.DONE ||
                              widget.habit.daysStates[widget.selectedDay] ==
                                  HabitState.NOT_DONE) {
                            widget.onPressSuspend(widget.habit);
                          } else {
                            widget.onPressUnsuspend(widget.habit);
                          }
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: AppColors.black.withOpacity(0.3),
                          ),
                          child: Icon(
                            ((widget.habit.daysStates[widget.selectedDay] ==
                                            HabitState.DONE ||
                                        widget.habit.daysStates[
                                                widget.selectedDay] ==
                                            HabitState.NOT_DONE) ||
                                    (widget.habit.repeatDays.contains(
                                            DateUtil.getDateDayName(
                                                DateUtil.getDateByDay(
                                                    widget.selectedDay))) &&
                                        widget.habit.daysStates[
                                                widget.selectedDay] ==
                                            HabitState.CREATED))
                                ? LineAwesomeIcons.link
                                : LineAwesomeIcons.unlink,
                            size: 18.0,
                            color:
                                ((widget.habit.daysStates[widget.selectedDay] ==
                                                HabitState.DONE ||
                                            widget.habit.daysStates[
                                                    widget.selectedDay] ==
                                                HabitState.NOT_DONE) ||
                                        (widget.habit.repeatDays.contains(
                                                DateUtil.getDateDayName(
                                                    DateUtil.getDateByDay(
                                                        widget.selectedDay))) &&
                                            widget.habit.daysStates[
                                                    widget.selectedDay] ==
                                                HabitState.CREATED))
                                    ? AppColors.green
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
                }
              ],
            ),
            if (isEditing) ...{
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: SelectWeekDays(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  days: DayInWeek.getWeekDaysBySelectedDays(
                      widget.habit.repeatDays),
                  border: false,
                  boxDecoration:
                      BoxDecoration(border: Border.all(color: AppColors.white)),
                  onSelect: (values) {
                    repeatDays = values;
                  },
                ),
              ),
            }
          ],
        ),
      ),
    );
  }
}
