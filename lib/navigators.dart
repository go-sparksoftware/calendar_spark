import 'package:flutter/material.dart';

export 'navigators/month_calendar_navigator.dart';
export 'navigators/title_calendar_navigator.dart';

abstract class CalendarNavigator extends Widget {
  const CalendarNavigator({super.key});
}
