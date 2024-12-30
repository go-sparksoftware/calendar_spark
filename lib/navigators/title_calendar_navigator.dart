import 'package:app_spark/material_symbols.dart';
import 'package:flutter/material.dart';

import '../calendar_controller.dart';
import '../types/calendar_month.dart';
import '../calendar_types.dart';
import '../navigators.dart';

class TitleCalendarNavigator extends StatelessWidget
    implements CalendarNavigator {
  const TitleCalendarNavigator({
    super.key,
    required this.controller,
    this.primary = true,
  }) : _compact = false;

  const TitleCalendarNavigator.compact({
    super.key,
    required this.controller,
    this.primary = true,
  }) : _compact = true;

  final CalendarController controller;
  final bool primary;
  final bool _compact;

  @override
  Widget build(BuildContext context) {
    Widget buildDefault(CalendarController controller) {
      final calendar = primary ? controller.primary : controller.secondary;
      return Row(
        children: [
          FilledButton(
              onPressed: () => controller.today(),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Today"),
              )),
          const SizedBox(width: 8),
          IconButton(
              onPressed: primary
                  ? controller.previousMonth1
                  : controller.previousMonth2,
              icon: const Icon(MaterialSymbols.chevronLeft)),
          IconButton(
              onPressed:
                  primary ? controller.nextMonth1 : controller.nextMonth2,
              icon: const Icon(MaterialSymbols.chevronRight)),
          const SizedBox(width: 8),
          Text("${calendar.monthName} ${calendar.year}",
              style: Theme.of(context).textTheme.titleLarge),
        ],
      );
    }

    Widget buildCompact(CalendarController controller) {
      final calendar = primary ? controller.primary : controller.secondary;
      return Row(
        children: [
          TextButton.icon(
            onPressed: () {
              controller.navigatorVisible = !controller.navigatorVisible;
            },
            icon: controller.navigatorVisible
                ? const Icon(MaterialSymbols.arrowDropDown)
                : const Icon(MaterialSymbols.arrowDropUp),
            iconAlignment: IconAlignment.end,
            label: Text(calendar.monthYearName,
                style: Theme.of(context).textTheme.titleLarge),
          ),
        ],
      );
    }

    return ListenableBuilder(
        listenable: controller,
        builder: (context, snapshot) =>
            _compact ? buildCompact(controller) : buildDefault(controller));
  }
}
