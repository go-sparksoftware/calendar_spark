import 'package:calendar_spark/types/calendar_event.dart';

import 'calendar_month.dart';
import '../date_time_extension.dart';
import 'package:intl/intl.dart';

/// Represents a time of day
///
/// The time is represented by [hour] ([0..23]), [minute] ([0..59]), and [second] ([0..59]).
/// If [hour] is null, thus [minute] and [second] are also null, then the time is considered to be all day.
class CalendarTime {
  const CalendarTime(
      {required int this.hour,
      required int this.minute,
      required int this.second});
  const CalendarTime.allDay()
      : hour = null,
        minute = null,
        second = null;
  const CalendarTime.hour({required int this.hour})
      : minute = null,
        second = null;
  const CalendarTime.minute({required int this.hour, required int this.minute})
      : second = null;
  CalendarTime.date(DateTime date)
      : hour = date.hour,
        minute = date.minute,
        second = date.second;
  final int? hour;
  final int? minute;
  final int? second;
}

typedef CalendarDay = ({int year, int month, int day});

extension CalendarDayExtension on CalendarDay {
  /// Returns the name of the month
  String get monthName => DateFormat.MMMM().format(toLocal());

  /// Returns this CalendarDay value in the local time zone
  DateTime toLocal() => DateTime(year, month, day).toLocal();

  /// Returns this CalendarDay value in the UTC time zone
  DateTime toUtc() => DateTime(year, month, day).toUtc();

  /// The day of the week [DateTime.monday]..[DateTime.sunday].
  int get weekday => toUtc().weekday;

  String get weekdayName => DateFormat.E().format(toLocal());

  /// Returns the first day of the year
  CalendarDay get firstDay => (year: year, month: 1, day: 1);

  /// Adds the specified duration and returns a new CalendarDay
  CalendarDay add({int? days}) =>
      toUtc() // Use UTC, otherwise daylight savings will causing miscalculations
          .add(Duration(days: days ?? 0))
          .toCalendarDay();

  /// Returns the first day of the week with the specified [weekday]
  CalendarDay toStartOfWeek(int weekday) {
    final temp = weekday - this.weekday;
    final distance = temp > 0 ? temp - 7 : temp;
    final calendarFirstDay = add(days: distance);
    return calendarFirstDay;
  }

  /// Returns the week number with the specified [weekday]
  int weekNumberOf(int weekday, {int? year}) {
    final firstDay = firstDayOf(weekday);
    final day = toStartOfWeek(weekday);
    final weeks = day.diffInWeeks(firstDay);
    final weekNumber = (weeks % 52) + 1;
    return weekNumber;
  }

  CalendarMonth toCalendarMonth() => (year: year, month: month);

  CalendarDay firstDayOf(int weekday) => firstDay.toStartOfWeek(weekday);

  Duration difference(CalendarDay calendar) =>
      toUtc().difference(calendar.toUtc());

  int diffInDays(CalendarDay calendar) => difference(calendar).inDays;

  int diffInWeeks(CalendarDay day) {
    final days = diffInDays(day);
    final weeks = (days / DateTime.daysPerWeek).ceil();
    return weeks;
  }

  // operator >(CalendarDay other) =>
  //     year > other.year || month > other.month || day > other.day;

  // operator <(CalendarDay other) =>
  //     year < other.year || month < other.month || day < other.day;

  operator >(CalendarDay other) =>
      year > other.year ||
      (year == other.year && month > other.month) ||
      (year == other.year && month == other.month && day > other.day);

  operator <(CalendarDay other) =>
      year < other.year ||
      (year == other.year && month < other.month) ||
      (year == other.year && month == other.month && day < other.day);

  operator >=(CalendarDay other) => this == other || this > other;

  operator <=(CalendarDay other) => this == other || this < other;
}

extension CalendarDayTupleExtension on (int, int, int) {
  CalendarDay toCalendar() {
    final (year, month, day) = this;
    return (year: year, month: month, day: day);
  }
}

CalendarDay today() => DateTime.now().toCalendarDay();