import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../calendar_controller.dart';
import '../calendar_delegate.dart';
import '../calendar_types.dart';
import '../month_calendar.dart';
import '../viewers.dart';

class MonthCalendarView extends StatelessWidget implements CalendarViewer {
  const MonthCalendarView({
    super.key,
    required this.controller,
  });

  final CalendarController controller;
  @override
  Widget build(BuildContext context) => MonthCalendar(
        controller: controller,
        delegate: const MonthCalendarViewDelegate(),
      );
}

class MonthCalendarViewDelegate extends CalendarDelegate {
  const MonthCalendarViewDelegate({
    this.headerHeight = 30,
    this.rowHeaderWidth = 30,
    TextStyle? eventStyle,
  }) : _eventStyle = eventStyle;
  @override
  final double headerHeight;
  @override
  final double rowHeaderWidth;
  @override
  final topHeight = 0;
  @override
  final primary = true;

  final TextStyle? _eventStyle;
  TextStyle eventStyle(BuildContext context) =>
      _eventStyle ?? Theme.of(context).textTheme.labelMedium!;

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

    final side = BorderSide(color: getBorderColor(context));
    final border = Border(
      left: side,
      bottom: side,
    );

    final events = controller.getEvents(calendar);
    final style = eventStyle(context);
    final bulletStyle = style.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.secondary);

    Widget buildEvent(CalendarEvent event) => Padding(
          padding: const EdgeInsets.only(top: 4, left: 4),
          child: Text.rich(
            TextSpan(
              style: style,
              children: [
                TextSpan(text: "• ", style: bulletStyle),
                TextSpan(text: event.title),
              ],
            ),
          ),
        );

    return Container(
      decoration: BoxDecoration(border: border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: IconButton(
                style: background != null
                    ? ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(background))
                    : null,
                iconSize: 20,
                onPressed: null,
                icon: Text("${calendar.day}")),
          ),

          ...events.map(buildEvent),
          //const Align(alignment: Alignment.topLeft, child: Text("Test item"))
        ],
      ),
    );
  }

  @override
  Widget buildTitle(BuildContext context, CalendarController controller,
          CalendarMonth calendar) =>
      throw Exception("Invalid call");

  @override
  Widget buildWeek(BuildContext context, int week) {
    final side = BorderSide(color: getBorderColor(context));
    final border = Border(bottom: side);
    return Container(
      decoration:
          BoxDecoration(color: getRowHeaderColor(context), border: border),
      child: Center(
          child: Text("$week",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary))),
    );
  }

  @override
  Widget buildWeekSummary(BuildContext context, CalendarController controller,
      CalendarDay from, CalendarDay to, int week) {
    final side = BorderSide(color: getBorderColor(context));
    final border = Border(bottom: side);
    final events = controller.getEvents(from, to: to);
    final summaries = controller.summarize(events);
    final style = eventStyle(context);
    return Container(
      decoration: BoxDecoration(border: border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...summaries.map((summary) => Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(summary, style: style),
              )),
          //const Align(alignment: Alignment.topLeft, child: Text("Test item"))
        ],
      ),
    );

    // return Container(
    //   decoration: BoxDecoration(border: border),
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Column(
    //       spacing: 2,
    //       children: [
    //         ...summaries.map((summary) => Text(summary,
    //             style: Theme.of(context).textTheme.bodyMedium!.copyWith(
    //                 fontWeight: FontWeight.bold,
    //                 color: Theme.of(context).colorScheme.secondary))),
    //       ],
    //     ),
    //     // child2: Text("some summary",
    //     //     style: Theme.of(context).textTheme.bodyMedium!.copyWith(
    //     //         fontWeight: FontWeight.bold,
    //     //         color: Theme.of(context).colorScheme.secondary)),
    //   ),
    // );
  }

  @override
  Widget buildWeekday(BuildContext context, int weekday) {
    final template = DateTime(2024, 12, 1);
    final temp = template.add(Duration(days: weekday));
    final theme = Theme.of(context);
    final weekDayTitle = DateFormat.E().format(temp);

    final side = BorderSide(color: getBorderColor(context));
    final border = Border(left: side);
    return Container(
      decoration: BoxDecoration(border: border),
      child: Center(
        child: Text(weekDayTitle.substring(0, 3).toUpperCase(),
            style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.secondary)),
      ),
    );
  }

  @override
  Widget buildEmptyRowHeader(BuildContext context) {
    final side = BorderSide(color: getBorderColor(context));
    final border = Border(left: side);
    return Container(
        decoration:
            BoxDecoration(color: getRowHeaderColor(context), border: border),
        width: rowHeaderWidth,
        height: headerHeight,
        child: const SizedBox());
  }
}
