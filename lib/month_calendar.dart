import 'package:flutter/material.dart';

import 'calendar_controller.dart';
import 'calendar_delegate.dart';
import 'calendar_types.dart';

typedef CellBuilder = Widget Function(Cell cell);
typedef WeekDayBuilder = Widget Function(
    BuildContext context, int dayOfWeekIndex);
typedef WeekNumberBuilder = Widget Function(BuildContext context, int week);
typedef HeaderBuilder = Widget Function(
    BuildContext context, CalendarMonth calendarMonth);

class MonthCalendar extends StatelessWidget {
  const MonthCalendar({
    super.key,
    required this.controller,
    required this.delegate,
    this.backgroundColor,
    bool? showSummary,
  }) : _showSummary = showSummary;

  static const int weeksPerMonth = 6;
  static const int daysPerWeek = DateTime.daysPerWeek;

  final CalendarController controller;
  final CalendarDelegate delegate;
  final Color? backgroundColor;
  final bool? _showSummary;

  @override
  Widget build(BuildContext context) {
    final columnCount = getColumnCount();
    final rowCount = getRowCount();
    final cellCount = columnCount * rowCount;

    final showWeeks = controller.showWeeks;
    final showSummary = this.showSummary;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.hasBoundedWidth) throw Exception("Unbounded width");

        final cellWidth =
            (constraints.maxWidth - (showWeeks ? delegate.rowHeaderWidth : 0)) /
                (showSummary ? daysPerWeek + 1 : daysPerWeek);
        // ignore: unnecessary_nullable_for_final_variable_declarations
        final cellHeight = constraints.hasBoundedHeight
            ? (constraints.maxHeight -
                    delegate.headerHeight -
                    delegate.topHeight) /
                rowCount
            : cellWidth * 1.1;
        return ListenableBuilder(
            listenable: controller,
            builder: (context, child) {
              final calendar =
                  delegate.primary ? controller.primary : controller.secondary;
              final selectedWeekday = controller.weekday;
              final startOfWeek = calendar.toStartOfWeek(selectedWeekday);

              return Container(
                color: backgroundColor,
                child: Wrap(
                  children: [
                    if (delegate.topHeight > 0)
                      ConstrainedBox(
                          constraints: BoxConstraints.tightFor(
                              width: constraints.maxWidth,
                              height: delegate.topHeight),
                          child: delegate.buildTitle(
                              context, controller, calendar)),
                    if (showWeeks) delegate.buildEmptyRowHeader(context),
                    ...Iterable.generate(daysPerWeek, (index) {
                      final dayOfWeek = (index + selectedWeekday) % daysPerWeek;
                      return ConstrainedBox(
                          constraints: BoxConstraints.tightFor(
                              width: cellWidth, height: delegate.headerHeight),
                          child:
                              delegate.buildWeekday(context, dayOfWeek, index));
                    }),
                    if (showSummary)
                      SizedBox(
                          width: cellWidth,
                          height: delegate.headerHeight,
                          child: delegate.buildWeekSummaryTitle(context)),
                    ...Iterable.generate(cellCount, (index) {
                      final cell = cellFromIndex(index, columnCount);

                      final rowHeader = cell.column == 0 && showWeeks;
                      final rowSummary = !rowHeader &&
                          showSummary &&
                          cell.column == (columnCount - 1);
                      if (rowHeader) {
                        final calendarCell =
                            normalizedForCalendar(cell.nextColumn);
                        final days = calendarCell.row * daysPerWeek +
                            calendarCell.column;
                        final calendarDay = startOfWeek.add(days: days);

                        return ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: rowHeader
                                    ? delegate.rowHeaderWidth
                                    : cellWidth,
                                height: cellHeight),
                            child: Container(
                                child: delegate.buildWeek(
                                    context,
                                    calendarDay.weekNumberOf(
                                      selectedWeekday,
                                    ))));
                      } else if (rowSummary) {
                        final from =
                            startOfWeek.add(days: cell.row * daysPerWeek);
                        final to = from.add(days: daysPerWeek - 1);

                        return ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: rowHeader
                                    ? delegate.rowHeaderWidth
                                    : cellWidth,
                                height: cellHeight),
                            child: Container(
                                child: delegate.buildWeekSummary(
                                    context,
                                    controller,
                                    from,
                                    to,
                                    from.weekNumberOf(
                                      selectedWeekday,
                                    ))));
                      } else {
                        final calendarCell = normalizedForCalendar(cell);
                        final days = calendarCell.row * 7 + calendarCell.column;
                        final calendarDay = startOfWeek.add(days: days);

                        return ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: rowHeader
                                    ? delegate.rowHeaderWidth
                                    : cellWidth,
                                height: cellHeight),
                            child: Container(
                                child: delegate.buildDay(
                                    context,
                                    controller,
                                    calendarCell,
                                    calendarDay,
                                    today(),
                                    controller.calendarDay)));
                      }
                    }),
                  ],
                ),
              );
            });
      },
    );
  }

  bool get showSummary => _showSummary ?? controller.showSummary;

  int getColumnCount() {
    final x = controller.showWeeks ? 1 : 0;
    final y = showSummary ? 1 : 0;
    return daysPerWeek + x + y;
  }

  int getRowCount() => weeksPerMonth;

  Cell normalizedForCalendar(Cell cell) {
    final x = controller.showWeeks ? 1 : 0;
    //final y = showSummary ? 1 : 0;

    return (row: cell.row, column: cell.column - x);
  }

  static Cell cellFromIndex(int index, int columnCount) =>
      (row: (index / columnCount).floor(), column: index % columnCount);
}
