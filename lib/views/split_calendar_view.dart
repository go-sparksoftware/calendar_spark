import 'package:flutter/material.dart';

import '../calendar_controller.dart';
import '../navigators.dart';
import '../viewers.dart';

class SplitCalendarView extends StatelessWidget {
  const SplitCalendarView({
    super.key,
    required this.controller,
    required this.navigator,
    required this.viewer,
  });

  final CalendarController controller;
  final CalendarNavigator navigator;
  final CalendarViewer viewer;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: controller,
      builder: (context, snapshot) {
        return Column(
          children: [
            if (controller.navigatorVisible) navigator,
            Expanded(child: viewer),
          ],
        );
      });
}
