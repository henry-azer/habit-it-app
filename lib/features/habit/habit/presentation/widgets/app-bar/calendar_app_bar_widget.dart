import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../../../../../config/locale/app_localization_helper.dart';
import '../../../../../../core/utils/app_localization_strings.dart';
import '../../../../../../core/utils/date_util.dart';

class CalendarAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Color? accent;
  final Color? white;
  final Color? black;
  final DateTime lastDate;
  final DateTime firstDate;
  final DateTime selectedDate;
  final List<DateTime>? events;
  final Function onDateChanged;
  final double? padding;
  final String? locale;
  final Color? fontColor;

  const CalendarAppBar({
    Key? key,
    required this.lastDate,
    required this.firstDate,
    required this.selectedDate,
    required this.onDateChanged,
    this.fontColor,
    this.events,
    this.accent,
    this.white,
    this.black,
    this.padding,
    this.locale,
  }) : super(key: key);

  @override
  CalendarAppBarState createState() => CalendarAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(250.0);
}

class CalendarAppBarState extends State<CalendarAppBar> {
  late DateTime selectedDate;
  late DateTime firstDate;
  late DateTime lastDate;
  late int position;
  late DateTime referenceDate;
  late List<DateTime> days = [];
  late List<String> datesWithEntries = [];
  late Color white;
  late Color accent;
  late Color black;
  late Color fontColor;
  late double padding;
  late bool fullCalendar;

  String get _locale => widget.locale ?? 'en';
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    setState(() {
      accent = widget.accent ?? const Color(0xFF0039D9);
      firstDate = widget.firstDate;
      lastDate = widget.lastDate;
      white = widget.white ?? Colors.white;
      black = widget.black ?? Colors.black87;
      fontColor = widget.fontColor ?? Colors.white;
      padding = widget.padding ?? 20.0;
      selectedDate = widget.selectedDate;
      referenceDate = widget.selectedDate;
      initializeDateFormatting(_locale);
      position = 1;
      days = DateUtil.getMonthDaysUntil(lastDate);
    });

    if (widget.events != null) {
      datesWithEntries = widget.events!.map((element) {
        return element.toString().split(" ").first;
      }).toList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 235.0,
      child: Stack(
        children: [
          Positioned(
            top: 0.0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 215.0,
              color: accent,
            ),
          ),
          Positioned(
            top: 55.0,
            child: Padding(
              padding:
                  EdgeInsets.only(left: padding, right: padding, top: 15.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - (padding * 2),
                child: Row(
                  children: [
                    Text(
                      AppLocalizationHelper.translate(
                          context, AppLocalizationKeys.appName),
                      style: TextStyle(
                          fontSize: 23.0,
                          color: fontColor,
                          fontWeight: FontWeight.w300),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat.yMMMM(Locale(_locale).toString())
                          .format(selectedDate),
                      style: TextStyle(
                          fontSize: 22.0,
                          color: fontColor,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: _calendarView(),
          ),
        ],
      ),
    );
  }

  Widget _calendarView() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 130.0,
      alignment: Alignment.bottomCenter,
      child: NotificationListener(
        onNotification: (dynamic notification) {
          double width = MediaQuery.of(context).size.width;
          double widthUnit = width / 5 - 4.0;
          double offset = scrollController.offset;

          if (notification is UserScrollNotification &&
              notification.direction == ScrollDirection.idle &&
              scrollController.position.activity is! HoldScrollActivity) {
            if (offset > 0) {
              scrollController.animateTo(
                (offset / widthUnit).round() * (widthUnit),
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
              );
            }

            if (referenceDate.toString().split(" ").first !=
                selectedDate.toString().split(" ").first) {
              Future.delayed(const Duration(milliseconds: 100), () {
                widget.onDateChanged(selectedDate);
              });
              setState(() {
                referenceDate = selectedDate;
              });
            }
          }

          if (offset > position * widthUnit - (widthUnit / 2)) {
            setState(() {
              position = position + 1;
              selectedDate = selectedDate.subtract(const Duration(days: 1));
            });
          } else if (offset + width < position * widthUnit - (widthUnit / 2)) {
            setState(() {
              position = position - 1;
              selectedDate = selectedDate.add(const Duration(days: 1));
            });
          }
          return true;
        },
        child: ListView.builder(
          padding: days.length < 5
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width *
                      (5 - days.length) /
                      10)
              : const EdgeInsets.symmetric(horizontal: 10),
          scrollDirection: Axis.horizontal,
          reverse: true,
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: days.length,
          itemBuilder: (context, index) {
            DateTime date = days[index];
            bool isSelected = position == index + 1;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDate = date;
                  referenceDate = selectedDate;
                  position = index + 1;
                });
                widget.onDateChanged(selectedDate);
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 5 - 4.0,
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 5.0),
                    child: Container(
                      height: 120.0,
                      width: MediaQuery.of(context).size.width / 5 - 4.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: isSelected ? white : null,
                        boxShadow: [
                          isSelected
                              ? BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                )
                              : BoxShadow(
                                  color: Colors.grey.withOpacity(0.0),
                                  spreadRadius: 5,
                                  blurRadius: 20,
                                  offset: const Offset(0, 3),
                                )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          datesWithEntries
                                  .contains(date.toString().split(" ").first)
                              ? Container(
                                  width: 5.0,
                                  height: 5.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? accent
                                        : white.withOpacity(0.8),
                                  ),
                                )
                              : const SizedBox(
                                  height: 5.0,
                                ),
                          const SizedBox(height: 10),
                          Text(
                            DateFormat("dd").format(date),
                            style: TextStyle(
                                fontSize: 22.0,
                                color: isSelected ? accent : fontColor,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            DateFormat.E(Locale(_locale).toString())
                                .format(date),
                            style: TextStyle(
                                fontSize: 12.0,
                                color: isSelected ? accent : fontColor,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
