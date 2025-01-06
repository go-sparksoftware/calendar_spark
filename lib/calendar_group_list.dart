import 'package:calendar_spark/calendar.dart';
import 'package:flutter/material.dart';

class CalendarGroupList extends StatelessWidget {
  const CalendarGroupList({
    super.key,
    required this.title,
    required this.controller,
    this.menu,
  });

  final Widget title;
  final CalendarController controller;
  //final Function(AssignedCalendarEventGroup group)? onOption;
  //final List<Widget> Function(AssignedCalendarEventGroup group)? menuChildren;
  final Widget Function(AssignedCalendarEventGroup group)? menu;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return ExpansionTile(
            title: title,
            initiallyExpanded: true,
            shape: const Border(),
            children: [
              ...controller.groups.entries.map((entry) {
                final visible = controller.isVisible(entry.key);
                final menu = this.menu?.call(entry.value);
                return ListTile(
                  leading: Checkbox(
                    value: visible,
                    fillColor: WidgetStateProperty.all(entry.value.color),
                    onChanged: (value) {
                      value ??= false;
                      if (value) {
                        controller.show(entry.key);
                      } else {
                        controller.hide(entry.key);
                      }
                    },
                  ),
                  title: Text(entry.value.name),
                  subtitle: entry.value.description != null
                      ? Text(entry.value.description!)
                      : null,

                  trailing: menu,
                  onTap: () {
                    if (visible) {
                      controller.hide(entry.key);
                    } else {
                      controller.show(entry.key);
                    }
                  },
                  //tileColor: entry.value.color,
                );
                // return CheckboxListTile(
                //   title: Text(entry.value.name),
                //   subtitle: entry.value.description != null
                //       ? Text(entry.value.description!)
                //       : null,
                //   value: visible,
                //   onChanged: (bool? value) {
                //     value ??= false;
                //     if (value) {
                //       controller.show(entry.key);
                //     } else {
                //       controller.hide(entry.key);
                //     }
                //   },
                //   fillColor: WidgetStateProperty.all(entry.value.color),
                // );
              }),
            ]);
      });
}
