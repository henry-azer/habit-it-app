import 'package:flutter/material.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:habit_it/core/utils/app_text_styles.dart';
import 'package:habit_it/data/entities/habit.dart';
import 'package:habit_it/data/enums/habit_state.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../../core/utils/date_util.dart';

class AttachHabitItemWidget extends StatefulWidget {
  final Habit habit;
  final int selectedDay;
  final Function(Habit) onPressSuspend;
  final Function(Habit) onPressUnsuspend;
  final Function(Habit) onPressRemove;

  const AttachHabitItemWidget({
    Key? key,
    required this.habit,
    required this.selectedDay,
    required this.onPressSuspend,
    required this.onPressUnsuspend,
    required this.onPressRemove,
  }) : super(key: key);

  @override
  State<AttachHabitItemWidget> createState() => _AttachHabitItemWidgetState();
}

class _AttachHabitItemWidgetState extends State<AttachHabitItemWidget> {
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
                Expanded(
                  child: Row(
                    children: [
                      Text(widget.habit.name,
                          style: AppTextStyles.habitNameText),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (widget.habit.daysStates[widget.selectedDay] == HabitState.DONE || widget.habit.daysStates[widget.selectedDay] == HabitState.NOT_DONE) {
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
                                      widget.habit
                                              .daysStates[widget.selectedDay] ==
                                          HabitState.NOT_DONE) ||
                                  (widget.habit.repeatDays.contains(
                                          DateUtil.getDateDayName(
                                              DateUtil.getDateByDay(
                                                  widget.selectedDay))) &&
                                      widget.habit
                                              .daysStates[widget.selectedDay] ==
                                          HabitState.CREATED))
                              ? LineAwesomeIcons.link
                              : LineAwesomeIcons.unlink,
                          size: 18.0,
                          color: ((widget.habit
                                              .daysStates[widget.selectedDay] ==
                                          HabitState.DONE ||
                                      widget.habit
                                              .daysStates[widget.selectedDay] ==
                                          HabitState.NOT_DONE) ||
                                  (widget.habit.repeatDays.contains(
                                          DateUtil.getDateDayName(
                                              DateUtil.getDateByDay(
                                                  widget.selectedDay))) &&
                                      widget.habit
                                              .daysStates[widget.selectedDay] ==
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
