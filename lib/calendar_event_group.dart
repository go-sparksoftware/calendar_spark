import 'package:flutter/material.dart';

class CalendarEventGroup {
  const CalendarEventGroup(this.id,
      {required this.name, this.description, this.properties = const {}});

  final String id;
  final String name;
  final String? description;

  final Map<String, dynamic> properties;

  operator [](String key) => properties[key];

  static Map<String, AssignedCalendarEventGroup> assign(
      List<CalendarEventGroup> groups, List<Color> colors) {
    assert(colors.isNotEmpty);

    final map = <String, AssignedCalendarEventGroup>{};
    for (var i = 0; i < groups.length; i++) {
      final group = groups[i];
      final nextColorIndex = i % colors.length;
      final nextColor = colors[nextColorIndex];
      map[groups[i].id] = AssignedCalendarEventGroup(group.id,
          name: group.name,
          description: group.description,
          color: nextColor,
          properties: group.properties);
    }
    return map;
  }
}

class AssignedCalendarEventGroup extends CalendarEventGroup {
  const AssignedCalendarEventGroup(super.id,
      {required super.name,
      required this.color,
      super.description,
      super.properties = const {}});

  final Color color;
}
