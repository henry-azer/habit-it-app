import 'package:flutter/material.dart';
import 'package:habit_it/core/utils/app_colors.dart';
import 'package:habit_it/core/utils/date_util.dart';
import 'package:habit_it/core/utils/media_query_values.dart';
import 'package:intl/intl.dart';

import '../../../../../config/locale/app_localization_helper.dart';
import '../../../../../core/utils/app_localization_strings.dart';

Future<DateTime?> showMonthPicker({
  required BuildContext context,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return _MonthPicker(
        firstDate: firstDate,
        lastDate: lastDate,
      );
    },
  );
}

class _MonthPicker extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;

  const _MonthPicker({
    Key? key,
    required this.firstDate,
    required this.lastDate,
  }) : super(key: key);

  @override
  State<_MonthPicker> createState() => __MonthPickerState();
}

class __MonthPickerState extends State<_MonthPicker> {
  final _pageViewKey = GlobalKey();
  late final PageController _pageController;
  late int _displayedPage;
  late DateTime _selectedDate;
  bool _isYearSelection = false;
  late final DateTime _firstDate;
  late final DateTime _lastDate;

  @override
  void initState() {
    super.initState();
    _firstDate = DateTime(widget.firstDate.year, widget.firstDate.month);
    _lastDate = DateTime(widget.lastDate.year, widget.lastDate.month);
    _selectedDate = DateTime(widget.lastDate.year, widget.lastDate.month);
    _displayedPage = _selectedDate.year;
    _pageController = PageController(initialPage: _displayedPage);
  }

  @override
  Widget build(BuildContext context) {
    final content = Material(
      color: AppColors.white.withOpacity(0.9),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildPager(),
            _buildButtonBar(),
          ],
        ),
      ),
    );
    return Center(
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Builder(
              builder: (context) {
                return MediaQuery.of(context).orientation ==
                        Orientation.portrait
                    ? IntrinsicWidth(
                        child: Column(
                        children: [
                          IntrinsicHeight(
                            child: _buildHeader(),
                          ),
                          const SizedBox(height: 8.0),
                          content,
                        ],
                      ))
                    : IntrinsicHeight(
                        child: Row(children: [
                          _buildHeader(),
                          const SizedBox(width: 8.0),
                          content,
                        ]),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildHeader() {
    return Material(
      color: AppColors.accent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: Text(
                DateFormat.MMM().format(_selectedDate),
                style: TextStyle(color: AppColors.fontPrimary, fontSize: 18),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color: AppColors.fontPrimary,
                  ),
                  onPressed: () => _pageController.animateToPage(
                    _displayedPage - 1,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeIn,
                  ),
                ),
                DefaultTextStyle(
                  style: const TextStyle(fontSize: 22),
                  child: (_isYearSelection)
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(DateFormat.y().format(
                              DateTime(_displayedPage * 12),
                            )),
                            const Text(' - '),
                            Text(DateFormat.y().format(
                              DateTime(_displayedPage * 12 + 11),
                            )),
                          ],
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() => _isYearSelection = true);
                            _pageController.jumpToPage(_displayedPage ~/ 12);
                          },
                          child: Text(
                            DateFormat.y().format(DateTime(_displayedPage)),
                          ),
                        ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_right,
                    color: AppColors.fontPrimary,
                  ),
                  onPressed: () => _pageController.animateToPage(
                    _displayedPage + 1,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeIn,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildPager() {
    return SizedBox(
      height: 220,
      width: 300,
      child: PageView.builder(
        key: _pageViewKey,
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        onPageChanged: (index) => setState(() => _displayedPage = index),
        pageSnapping: !_isYearSelection,
        itemBuilder: (context, page) {
          return GridView.count(
            crossAxisCount: 4,
            padding: const EdgeInsets.all(12.0),
            physics: const NeverScrollableScrollPhysics(),
            children: _isYearSelection
                ? List<int>.generate(12, (i) => page * 12 + i)
                    .map(
                      (year) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: _getYearButton(year),
                      ),
                    )
                    .toList()
                : List<int>.generate(12, (i) => i + 1)
                    .map((month) => DateTime(page, month))
                    .map(
                      (date) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: _getMonthButton(date),
                      ),
                    )
                    .toList(),
          );
        },
      ),
    );
  }

  _getYearButton(int year) {
    bool isSelected = year == _selectedDate.year;
    return TextButton(
      onPressed: () => setState(
        () {
          _pageController.jumpToPage(year);
          setState(() => _isYearSelection = false);
        },
      ),
      style: TextButton.styleFrom(
        foregroundColor: isSelected
            ? AppColors.fontPrimary
            : year == DateTime.now().year
                ? AppColors.fontSecondary
                : AppColors.grey.withOpacity(0.9),
        backgroundColor: isSelected ? AppColors.accent : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      child: Text(
        DateFormat.y().format(DateTime(year)),
      ),
    );
  }

  _getMonthButton(DateTime date) {
    bool isSelected = date.month == _selectedDate.month && date.year == _selectedDate.year;
    bool isInRange = DateUtil.isDateInRange(date, _firstDate, _lastDate);

    VoidCallback? callback = isInRange ? () => setState(() => _selectedDate = DateTime(date.year, date.month)) : null;
    return TextButton(
      onPressed: callback,
      style: TextButton.styleFrom(
        foregroundColor: isSelected
            ? AppColors.fontPrimary
            : isInRange
                ? AppColors.black
                : AppColors.grey.withOpacity(0.8),
        backgroundColor: isSelected ? AppColors.accent : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      child: Text(
        DateFormat.MMM().format(date).toUpperCase(),
      ),
    );
  }

  _buildButtonBar() {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: 5.0, horizontal: context.width * 0.06),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            style: TextButton.styleFrom(
                foregroundColor: AppColors.black,
                textStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.pop(context, _selectedDate);
            },
            child: Text(AppLocalizationHelper.translate(
                context, AppLocalizationKeys.submit)),
          ),
          TextButton(
            style: TextButton.styleFrom(
                foregroundColor: AppColors.black,
                textStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            child: Text(AppLocalizationHelper.translate(
                context, AppLocalizationKeys.cancel)),
          ),
        ],
      ),
    );
  }
}
