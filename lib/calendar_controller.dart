import 'package:calendar_spark/types/calendar_day.dart' as day;
import 'package:flutter/material.dart';

import 'calendar_types.dart';
import 'types/calendar_event.dart';
export 'types/calendar_event.dart';

class CalendarController extends ChangeNotifier {
  CalendarController({
    required CalendarMonth initial,
    CalendarDay? day,
    bool showWeeks = false,
    bool showSummary = false,
    bool showHeader = true,
    int firstDayOfWeek = DateTime.sunday,
    bool navigatorVisible = true,
    CalendarEvents events = const {},
    this.summarize = defaultSummarize,
  })  : _primary = initial,
        _secondary = initial,
        _calendarDay = day,
        _showWeeks = showWeeks,
        _showSummary = showSummary,
        _showHeader = showHeader,
        _firstDayOfWeek = firstDayOfWeek,
        _navigatorVisible = navigatorVisible,
        _events = events;
  CalendarController.now({
    bool showWeeks = false,
    bool showSummary = false,
    bool showHeader = true,
    int firstDayOfWeek = DateTime.sunday,
    bool navigatorVisible = true,
    CalendarEvents events = const {},
    this.summarize = defaultSummarize,
  })  : _primary = thisMonth(),
        _secondary = thisMonth(),
        _calendarDay = day.today(),
        _showWeeks = showWeeks,
        _showSummary = showSummary,
        _showHeader = showHeader,
        _firstDayOfWeek = firstDayOfWeek,
        _navigatorVisible = navigatorVisible,
        _events = events;

  final List<String> Function(List<CalendarEvent> events) summarize;

  late CalendarMonth _primary;
  CalendarMonth get primary => _primary;
  set primary(CalendarMonth value) {
    if (value == _primary) return;
    _primary = value;
    _secondary = value;
    notifyListeners();
  }

  late CalendarMonth _secondary;
  CalendarMonth get secondary => _secondary;
  set secondary(CalendarMonth value) {
    if (value == _secondary) return;
    _secondary = value;
    notifyListeners();
  }

  CalendarDay? _calendarDay;
  CalendarDay? get calendarDay => _calendarDay;
  set calendarDay(CalendarDay? value) {
    //if (value == _calendarDay) return;
    _calendarDay = value;
    if (value case CalendarDay day) {
      _primary = day.toCalendarMonth();
      _secondary = day.toCalendarMonth();
    }
    notifyListeners();
  }

  late bool _showWeeks;
  bool get showWeeks => _showWeeks;
  set showWeeks(bool value) {
    if (value == _showWeeks) return;
    _showWeeks = value;
    notifyListeners();
  }

  late bool _showSummary;
  bool get showSummary => _showSummary;
  set showSummary(bool value) {
    if (value == _showSummary) return;
    _showSummary = value;
    notifyListeners();
  }

  bool _showHeader;
  bool get showHeader => _showHeader;
  set showHeader(bool value) {
    if (value == _showHeader) return;
    _showHeader = value;
    notifyListeners();
  }

  int _firstDayOfWeek;
  int get weekday => _firstDayOfWeek;
  set weekday(int value) {
    if (value == _firstDayOfWeek) return;
    _firstDayOfWeek = value;
    notifyListeners();
  }

  bool _navigatorVisible;
  bool get navigatorVisible => _navigatorVisible;
  set navigatorVisible(bool value) {
    if (value == _navigatorVisible) return;
    _navigatorVisible = value;
    notifyListeners();
  }

  CalendarEvents _events;
  CalendarEvents get events => _events;
  set events(CalendarEvents value) {
    if (value == _events) return;
    _events = value;
  }

  void today() {
    calendarDay = day.today();
  }

  void previousMonth1() {
    primary = secondary.add(months: -1);
  }

  void nextMonth1() {
    primary = secondary.add(months: 1);
  }

  void previousMonth2() {
    secondary = secondary.add(months: -1);
  }

  void nextMonth2() {
    secondary = secondary.add(months: 1);
  }

  List<CalendarEvent> getEvents(CalendarDay day, {CalendarDay? to}) {
    if (to == null) {
      return _events.entries
          .where((event) => event.key == day)
          .fold(<CalendarEvent>[], (a, c) => a..addAll(c.value));
    } else {
      return _events.entries
          .where((event) => event.key >= day && event.key <= to)
          .fold(<CalendarEvent>[], (a, c) => a..addAll(c.value));
    }
  }

  static List<String> defaultSummarize(_) => [];
}
