import 'package:flutter/material.dart';

import '../model/day_in_week.dart';

class SelectWeekDays extends StatefulWidget {
  final Function onSelect;

  final List<DayInWeek> days;

  final Color? backgroundColor;

  final FontWeight? fontWeight;

  final double? fontSize;

  final Color? selectedDaysFillColor;

  final Color? unselectedDaysFillColor;

  final Color? selectedDaysBorderColor;

  final Color? unselectedDaysBorderColor;

  final Color? selectedDayTextColor;

  final Color? unSelectedDayTextColor;

  final bool border;

  final BoxDecoration? boxDecoration;

  final double padding;

  final double? width;

  final double? height;

  SelectWeekDays({
    required this.onSelect,
    this.backgroundColor,
    this.fontWeight,
    this.fontSize,
    this.selectedDaysFillColor,
    this.unselectedDaysFillColor,
    this.selectedDaysBorderColor,
    this.unselectedDaysBorderColor,
    this.selectedDayTextColor,
    this.unSelectedDayTextColor,
    this.border = true,
    this.boxDecoration,
    this.padding = 8.0,
    this.width,
    this.height,
    required this.days,
    super.key,
  });

  @override
  SelectWeekDaysState createState() => SelectWeekDaysState(days);
}

class SelectWeekDaysState extends State<SelectWeekDays> {
  SelectWeekDaysState(List<DayInWeek> days) : _daysInWeek = days;

  // list to insert the selected days.
  List<String> selectedDays = [];

  // list of days in a week.
  List<DayInWeek> _daysInWeek = [];

  @override
  void initState() {
    _daysInWeek.forEach((element) {
      if (element.isSelected) {
        selectedDays.add(element.dayName);
      }
    });
    super.initState();
  }

  void setDaysState(List<DayInWeek> newDays) {
    selectedDays = [];
    for (DayInWeek dayInWeek in newDays) {
      if (dayInWeek.isSelected) {
        selectedDays.add(dayInWeek.dayName);
      }
    }
    setState(() {
      _daysInWeek = newDays;
    });
  }

  void _getSelectedWeekDays(bool isSelected, String day) {
    if (isSelected == true) {
      if (!selectedDays.contains(day)) {
        selectedDays.add(day);
      }
    } else if (isSelected == false) {
      if (selectedDays.contains(day)) {
        selectedDays.remove(day);
      }
    }
    // [onSelect] is the callback which passes the Selected days as list.
    widget.onSelect(selectedDays.toList());
  }

// getter to handle background color of container.
  Color? get _handleBackgroundColor {
    if (widget.backgroundColor == null) {
      return Theme.of(context).colorScheme.secondary;
    } else {
      return widget.backgroundColor;
    }
  }

// getter to handle fill color of buttons.
  Color? _handleDaysFillColor(bool onSelect) {
    if (!onSelect && widget.unselectedDaysFillColor == null) {
      return null;
    }

    return selectedUnselectedLogic(
      onSelect: onSelect,
      selectedColor: widget.selectedDaysFillColor,
      unSelectedColor: widget.unselectedDaysFillColor,
      defaultSelectedColor: Colors.white,
      defaultUnselectedColor: Colors.white,
    );
  }

//getter to handle border color of days[buttons].
  Color _handleBorderColorOfDays(bool onSelect) {
    return selectedUnselectedLogic(
      onSelect: onSelect,
      selectedColor: widget.selectedDaysBorderColor,
      unSelectedColor: widget.unselectedDaysBorderColor,
      defaultSelectedColor: Colors.white,
      defaultUnselectedColor: Colors.white,
    );
  }

// Handler to change the text color when the button is pressed and not pressed.
  Color? _handleTextColor(bool onSelect) {
    return selectedUnselectedLogic(
      onSelect: onSelect,
      selectedColor: widget.selectedDayTextColor,
      unSelectedColor: widget.unSelectedDayTextColor,
      defaultSelectedColor: Colors.black,
      defaultUnselectedColor: Colors.white,
    );
  }

  Color selectedUnselectedLogic({
    required bool onSelect,
    required Color? selectedColor,
    required Color? unSelectedColor,
    required Color defaultSelectedColor,
    required Color defaultUnselectedColor,
  }) {
    if (onSelect) {
      return selectedColor != null ? selectedColor : defaultSelectedColor;
    }
    return unSelectedColor != null ? unSelectedColor : defaultUnselectedColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height ?? 50,
      decoration: widget.boxDecoration == null
          ? BoxDecoration(
              color: _handleBackgroundColor,
              borderRadius: BorderRadius.circular(0),
            )
          : widget.boxDecoration,
      child: Padding(
        padding: EdgeInsets.all(widget.padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _daysInWeek.map(
            (day) {
              return Expanded(
                child: RawMaterialButton(
                  fillColor: _handleDaysFillColor(day.isSelected),
                  shape: CircleBorder(
                    side: widget.border
                        ? BorderSide(
                            color: _handleBorderColorOfDays(day.isSelected),
                            width: 2.0,
                          )
                        : BorderSide.none,
                  ),
                  onPressed: () {
                    setState(() {
                      day.toggleIsSelected();
                    });
                    _getSelectedWeekDays(day.isSelected, day.dayName);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      day.dayName.length < 3
                          ? day.dayName
                          : day.dayName.substring(0, 3),
                      style: TextStyle(
                        fontSize: widget.fontSize,
                        fontWeight: widget.fontWeight,
                        color: _handleTextColor(day.isSelected),
                      ),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
