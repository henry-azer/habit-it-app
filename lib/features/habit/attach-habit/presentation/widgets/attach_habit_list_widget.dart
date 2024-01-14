import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_it/data/entities/habit.dart';

import '../../../../../../core/utils/app_colors.dart';
import 'attach_habit_item_widget.dart';

class AttachHabitListWidget extends StatefulWidget {
  final int selectedDay;
  final List<Habit> habits;
  final Function(int, int) onReorder;
  final Function(Habit) onPressSuspend;
  final Function(Habit) onPressUnsuspend;
  final Function(Habit) onPressRemove;

  const AttachHabitListWidget(
      {super.key,
      required this.habits,
      required this.onReorder,
      required this.onPressSuspend,
      required this.onPressUnsuspend,
      required this.onPressRemove,
      required this.selectedDay});

  @override
  State<AttachHabitListWidget> createState() => _AttachHabitListWidgetState();
}

class _AttachHabitListWidgetState extends State<AttachHabitListWidget> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      child: ReorderableListView.builder(
        itemCount: widget.habits.length,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        onReorder: (int oldIndex, int newIndex) {
          widget.onReorder(oldIndex, newIndex);
        },
        itemBuilder: (BuildContext context, int index) {
          return _buildHabitItem(index);
        },
      ),
    );
  }

  Widget _buildHabitItem(int index) {
    return Column(
      key: ValueKey(widget.habits[index].id),
      children: [
        AttachHabitItemWidget(
          key: ValueKey(widget.habits[index].id),
          habit: widget.habits[index],
          onPressSuspend: (habit) async {
            await widget.onPressSuspend(habit);
          },
          onPressUnsuspend: (habit) async {
            await widget.onPressUnsuspend(habit);
          },
          selectedDay: widget.selectedDay,
          onPressRemove: (habit) async {
            await widget.onPressRemove(habit);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Divider(
            color: AppColors.white.withOpacity(0.7),
          ),
        ),
        if (index == widget.habits.length - 1) ...{
          const SizedBox(
            height: 80,
          ),
        },
      ],
    );
  }
}
