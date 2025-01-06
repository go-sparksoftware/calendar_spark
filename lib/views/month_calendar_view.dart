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
      Theme.of(context).colorScheme.surfaceVariant;
  // Theme.of(context).colorScheme.surfaceContainer;
  Color getRowHeaderColor(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceVariant.withAlpha(128);
  // Theme.of(context).colorScheme.surfaceContainerHigh;

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
      left: cell.column == 0 ? BorderSide.none : side,
      bottom: side,
    );

    final events = controller.getEvents(calendar);
    final eventTitleStyle = eventStyle(context);
    final defaultIndicatorColor = Theme.of(context).colorScheme.primary;

    final track = <CalendarDay>{};

    Widget buildEvent(CalendarEvent event) {
      final indicatorColor =
          controller.groups[event.groupId]?.color ?? defaultIndicatorColor;

      bool primary = !track.contains(event.day);
      track.add(event.day);
      late String? line1;
      late List<String> sublines;
      if (primary) {
        if (event.header case String header) {
          line1 = header;
          sublines = [event.title, ...event.subtitles];
        } else {
          line1 = event.title;
          sublines = [...event.subtitles];
        }
      } else {
        line1 = null;
        sublines = [
          if (event.header != null) event.header!,
          event.title,
          ...event.subtitles
        ];
      }

      return Padding(
        padding: const EdgeInsets.only(top: 4, left: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (line1 != null)
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: indicatorColor,
                  ),
                  const SizedBox(width: 4),
                  ...line1
                      .split(" ")
                      .map((word) => Text(" $word", style: eventTitleStyle)),
                ],
              ),
            ...sublines.map((line) => Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(line, style: eventTitleStyle),
                )),
          ],
        ),
      );
    }

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
                        backgroundColor: MaterialStatePropertyAll(background))
                    : null,
                iconSize: 20,
                onPressed: null,
                icon: Text("${calendar.day}")),
          ),
          ...events.map(buildEvent),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: Text("Summary"),
          // ),
          ...summaries.map((summary) => Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(summary, style: style),
              )),
          //const Align(alignment: Alignment.topLeft, child: Text("Test item"))
        ],
      ),
    );
  }

  @override
  Widget buildWeekday(BuildContext context, int weekday, int index) {
    final template = DateTime(2024, 12, 1);
    final temp = template.add(Duration(days: weekday));
    final theme = Theme.of(context);
    final weekDayTitle = DateFormat.E().format(temp);

    final side = BorderSide(color: getBorderColor(context));
    final border = Border(left: index == 0 ? BorderSide.none : side);
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
  Widget? buildWeekSummaryTitle(BuildContext context) {
    return Center(
        child: Text("SUMMARY",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary)));
  }

  @override
  Widget buildEmptyRowHeader(BuildContext context) {
    //final side = BorderSide(color: getBorderColor(context));
    //final border = Border(left: side);
    return Container(
        decoration: BoxDecoration(color: getRowHeaderColor(context)),
        width: rowHeaderWidth,
        height: headerHeight,
        child: const SizedBox());
  }
}
