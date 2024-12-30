import 'package:flutter/material.dart';

import '../calendar_types.dart';
import '../calendar_controller.dart';
import '../viewers.dart';

class DayCalendarView extends StatelessWidget implements CalendarViewer {
  const DayCalendarView({
    super.key,
    required this.controller,
    this.compact = false,
    this.backgroundColor,
    this.dividerColor,
  });

  final CalendarController controller;
  final bool compact;
  final Color? backgroundColor;
  final Color? dividerColor;

  @override
  Widget build(BuildContext context) {
    final dividerColor =
        this.dividerColor ?? Theme.of(context).colorScheme.surfaceContainerLow;

    Widget buildSlot({required Widget leading, required Widget content}) {
      return ListTile(
          shape: Border(bottom: BorderSide(color: dividerColor)),
          leading: leading,
          title: content);
    }

    Widget buildHourlySlot(int timeIndex, List<String> items) {
      final period = timeIndex < 11 ? "AM" : "PM";
      final hour = timeIndex % 12 + 1;
      return buildSlot(
          leading: Text("$hour $period"),
          content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [...items.map((item) => Text(item))]));
    }

    Widget buildDailySlot(List<String> items) {
      return buildSlot(
          leading: Column(mainAxisSize: MainAxisSize.min, children: [
            Text("${controller.calendarDay?.weekdayName}"),
            CircleAvatar(
                radius: 16,
                child: Text("${controller.calendarDay?.day}",
                    style: Theme.of(context).textTheme.bodyLarge))
          ]),
          content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [...items.map((item) => Text(item))]));
    }

    Widget build() => Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            ListView(
              children: [
                const ListTile(),
                ...Iterable.generate(23, (index) => buildHourlySlot(index, [])),
              ],
            ),
            Container(
              color: backgroundColor,
              child: buildDailySlot([]),
            ),
          ],
        );
    return ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          return PageView(
            controller: PageController(initialPage: 1),
            children: [Container(), build(), Container()],
          );
        });
  }
}
