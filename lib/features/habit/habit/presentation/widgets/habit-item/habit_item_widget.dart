import 'package:flutter/material.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:habit_it/core/utils/app_text_styles.dart';
import 'package:habit_it/data/entities/habit.dart';
import 'package:habit_it/data/enums/habit_state.dart';

class HabitItemWidget extends StatefulWidget {
  final Habit habit;
  final int selectedDay;
  final Function(Habit) onPressSuspend;
  final Function(Habit) onPressActivate;

  const HabitItemWidget({
    Key? key,
    required this.habit,
    required this.selectedDay,
    required this.onPressActivate,
    required this.onPressSuspend,
  }) : super(key: key);

  @override
  State<HabitItemWidget> createState() => _HabitItemWidgetState();
}

class _HabitItemWidgetState extends State<HabitItemWidget> {
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
                          (widget.habit.daysStates[widget.selectedDay] ==
                                  HabitState.DONE)
                              ? Icons.check
                              : (widget.habit.daysStates[widget.selectedDay] ==
                                      HabitState.NOT_DONE)
                                  ? Icons.close
                                  : Icons.remove,
                          size: 18.0,
                          color: (widget.habit.daysStates[widget.selectedDay] ==
                                  HabitState.DONE)
                              ? AppColors.green
                              : (widget.habit.daysStates[widget.selectedDay] ==
                                          HabitState.NOT_DONE) ||
                                      (widget.habit
                                              .daysStates[widget.selectedDay] ==
                                          HabitState.SUSPENDED)
                                  ? AppColors.red
                                  : AppColors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    InkWell(
                      onTap: () {
                        widget.onPressSuspend(widget.habit);
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
