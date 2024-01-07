import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_it/data/entities/habit.dart';

import '../../../../../../core/utils/app_colors.dart';
import 'habit_item_widget.dart';

class HabitListWidget extends StatefulWidget {
  final int selectedDay;
  final List<Habit> habits;
  final Function(int, int) onReorder;
  final Function(Habit) onPressAction;
  final Function(Habit) onPressRemove;
  final Function(Habit) onPressSave;

  const HabitListWidget(
      {super.key,
      required this.habits,
      required this.onReorder,
      required this.onPressAction,
      required this.onPressRemove,
      required this.onPressSave,
      required this.selectedDay});

  @override
  State<HabitListWidget> createState() => _HabitListWidgetState();
}

class _HabitListWidgetState extends State<HabitListWidget> {
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
          return _buildHabitCategoryItem(index);
        },
      ),
    );
  }

  Widget _buildHabitCategoryItem(int index) {
    return Column(
      key: ValueKey(widget.habits[index].id),
      children: [
        HabitItemWidget(
          habit: widget.habits[index],
          onPressSave: (habit) async {
            await widget.onPressSave(habit);
          },
          onPressRemove: (habit) async {
            await widget.onPressRemove(habit);
          },
          onPressActivate: (habit) async {
            await widget.onPressAction(habit);
          },
          selectedDay: widget.selectedDay,
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
