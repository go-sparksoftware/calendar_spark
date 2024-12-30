import 'package:calendar_spark/date_time_extension.dart';
import 'package:calendar_spark/types/calendar_day.dart';

class CalendarEvent {
  const CalendarEvent(
      {required this.id,
      required this.title,
      required this.day,
      this.properties = const {},
      this.time = const CalendarTime.allDay()});

  CalendarEvent.date({
    required this.id,
    required this.title,
    required DateTime date,
    this.properties = const {},
  })  : day = date.toCalendarDay(),
        time = date.toCalendarTime();

  final String id;
  final String title;
  final CalendarDay day;
  final CalendarTime time;
  final Map<String, dynamic> properties;

  DateTime get date => DateTime(day.year, day.month, day.day, time.hour ?? 0,
      time.minute ?? 0, time.second ?? 0);

  dynamic operator [](String key) =>
      switch (key) { "id" => id, "title" => title, _ => properties[key] };

  static CalendarEvents asCalendarEvents(List<CalendarEvent> events) {
    final map = <CalendarDay, List<CalendarEvent>>{};
    for (final event in events) {
      if (!map.containsKey(event.day)) {
        map[event.day] = [];
      }
      map[event.day]!.add(event);
    }
    return map;
  }
}

typedef CalendarEvents = Map<CalendarDay, List<CalendarEvent>>;
