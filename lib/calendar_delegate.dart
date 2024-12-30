import 'package:flutter/material.dart';

import 'calendar_controller.dart';
import 'calendar_types.dart';

abstract class CalendarDelegate {
  const CalendarDelegate();

  double get headerHeight;
  double get rowHeaderWidth;
  double get topHeight;
  bool get primary;

  Widget buildTitle(BuildContext context, CalendarController controller,
      CalendarMonth calendar);
  Widget buildWeekday(BuildContext context, int weekday);
  Widget buildWeek(BuildContext context, int week);
  Widget? buildWeekSummary(BuildContext context, CalendarController controller,
          CalendarDay from, CalendarDay to, int week) =>
      null;
  Widget buildDay(
      BuildContext context,
      CalendarController controller,
      Cell cell,
      CalendarDay calendar,
      CalendarDay today,
      CalendarDay? selected);
  Widget buildEmptyRowHeader(BuildContext context) =>
      SizedBox(width: rowHeaderWidth);
}
