import 'types/calendar_day.dart';
import 'types/calendar_month.dart';

extension DateTimeExtension on DateTime {
  CalendarDay toCalendarDay() => (year: year, month: month, day: day);
  CalendarTime toCalendarTime() => CalendarTime.date(this);
  CalendarMonth toCalendarMonth() => (year: year, month: month);
}
