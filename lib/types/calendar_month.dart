import 'package:calendar_spark/types/calendar_day.dart';
import 'package:calendar_spark/date_time_extension.dart';
import 'package:intl/intl.dart';

typedef CalendarMonth = ({int year, int month});

extension CalendarMonthExtension on CalendarMonth {
  bool get sameYear => this.year == DateTime.now().year;

  String get monthName => DateFormat.MMMM().format(toLocal());
  String get monthYearName {
    return sameYear ? monthName : "$monthName ${this.year}";
  }

  DateTime toLocal() => DateTime(year, month, 1).toLocal();
  DateTime toUtc() => DateTime(year, month, 1).toUtc();
  CalendarDay toCalendarDay() => (year: year, month: month, day: 1);
  CalendarDay get firstDay => (year: year, month: 1, day: 1);

  CalendarDay firstDayOf(int weekday) => firstDay.firstDayOf(weekday);

  CalendarDay toStartOfWeek(int weekday) =>
      toCalendarDay().toStartOfWeek(weekday);

  CalendarMonth add({int? months, int? years}) {
    final date = DateTime(year + (years ?? 0), month + (months ?? 0), 1);
    return date.toCalendarMonth();
  }

  CalendarMonth get previousMonth => add(months: -1);
  CalendarMonth get nextMonth => add(months: 1);
}

CalendarMonth thisMonth() => DateTime.now().toCalendarMonth();
