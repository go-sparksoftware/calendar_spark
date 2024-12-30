import 'package:app_spark/material_symbols.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../calendar_controller.dart';
import '../calendar_types.dart';
import '../month_calendar.dart';
import '../calendar_delegate.dart';
import '../navigators.dart';

class MonthCalendarNavigator extends StatelessWidget
    implements CalendarNavigator {
  const MonthCalendarNavigator({
    super.key,
    required this.controller,
    this.showTitle = true,
    this.swipeToNavigate = false,
    this.backgroundColor,
  });

  const MonthCalendarNavigator.tap({
    super.key,
    required this.controller,
    this.backgroundColor,
  })  : showTitle = true,
        swipeToNavigate = false;

  const MonthCalendarNavigator.swipe({
    super.key,
    required this.controller,
    this.backgroundColor,
  })  : showTitle = false,
        swipeToNavigate = true;

  final CalendarController controller;
  final bool showTitle;
  final bool swipeToNavigate;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    Widget buildCalendar(CalendarController controller) => MonthCalendar(
          controller: controller,
          backgroundColor: backgroundColor,
          delegate: showTitle
              ? const NavigatorCalendarDelegate()
              : const NavigatorCalendarDelegate.noTitle(),
          showSummary: false,
        );
    final current = buildCalendar(controller);

    return swipeToNavigate
        ? ListenableBuilder(
            listenable: controller,
            builder: (context, child) {
              return Flexible(
                key: ValueKey(controller.primary),
                child: PageView(
                  controller: PageController(initialPage: 1),
                  onPageChanged: (value) {
                    Future.delayed(Durations.short4, () {
                      if (value == 2) {
                        controller.nextMonth1();
                      } else if (value == 0) {
                        controller.previousMonth1();
                      }
                    });
                  },
                  children: [
                    buildCalendar(CalendarController(
                      initial: controller.primary.previousMonth,
                      showWeeks: controller.showWeeks,
                      showHeader: controller.showHeader,
                    )),
                    current,
                    buildCalendar(CalendarController(
                      initial: controller.primary.nextMonth,
                      showWeeks: controller.showWeeks,
                      showHeader: controller.showHeader,
                    )),
                  ],
                ),
              );
            })
        : current;
  }
}

class NavigatorCalendarDelegate extends CalendarDelegate {
  static const defaultSize = 30.0;
  const NavigatorCalendarDelegate(
      {this.headerHeight = defaultSize,
      this.rowHeaderWidth = defaultSize,
      this.topHeight = 40,
      TextStyle? textStyle})
      : _textStyle = textStyle;
  const NavigatorCalendarDelegate.noTitle({
    this.headerHeight = defaultSize,
    this.rowHeaderWidth = defaultSize,
    TextStyle? textStyle,
  })  : topHeight = 0,
        _textStyle = textStyle;
  @override
  final double headerHeight;
  @override
  final double rowHeaderWidth;
  @override
  final double topHeight;

  @override
  final primary = false;

  final TextStyle? _textStyle;

  TextStyle? textStyle(BuildContext context) =>
      _textStyle ?? Theme.of(context).textTheme.labelMedium;

  Color getBorderColor(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainer;
  Color getRowHeaderColor(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerHigh;

  @override
  Widget buildDay(
      BuildContext context,
      CalendarController controller,
      Cell cell,
      CalendarDay calendar,
      CalendarDay today,
      CalendarDay? selected) {
    final background = calendar == selected
        ? Theme.of(context).colorScheme.primaryContainer
        : calendar == today
            ? Theme.of(context).colorScheme.secondaryContainer
            : null;
    return Center(
        child: IconButton(
            style: background != null
                ? ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(background))
                : null,
            onPressed: () {
              controller.calendarDay = calendar;
            },
            icon: Text("${calendar.day}", style: textStyle(context))));
  }

  @override
  Widget buildTitle(BuildContext context, CalendarController controller,
      CalendarMonth calendar) {
    return Row(
      children: [
        Expanded(
          child: Text("${calendar.monthName} ${calendar.year}",
              style: Theme.of(context).textTheme.titleMedium),
        ),
        IconButton(
            onPressed: controller.previousMonth2,
            icon: const Icon(MaterialSymbols.chevronLeft)),
        IconButton(
            onPressed: controller.nextMonth2,
            icon: const Icon(MaterialSymbols.chevronRight)),
      ],
    );
  }

  @override
  Widget buildWeek(BuildContext context, int week) {
    return Container(
      decoration: BoxDecoration(
        color: getRowHeaderColor(context),
      ),
      child: Center(
        child: Text("$week",
            style: textStyle(context)!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary)),
      ),
    );
  }

  @override
  Widget buildWeekday(BuildContext context, int weekday) {
    // Using a random date where the 1st day is a Sunday
    final date = DateTime(2024, 12, 1).add(Duration(days: weekday));
    final weekDayTitle = DateFormat.E().format(date);
    final theme = Theme.of(context);
    return Center(
      child: Text(weekDayTitle.substring(0, 1),
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.secondary)),
    );
  }
}
