import 'package:calendar_spark/types/calendar_day.dart';
import 'package:calendar_spark/calendar_types.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const weekday = DateTime.sunday;

  test("add with timezones", () {
    const CalendarDay start = (year: 2024, month: 10, day: 27);
    final a = start.add(days: 7);
    final b = start.add(days: 8);
    expect(a, (year: 2024, month: 11, day: 3));
    expect(b, (year: 2024, month: 11, day: 4));
  });

  test("January 2024 weeks", () {
    expect((2024, 1, 1).toCalendar().weekNumberOf(weekday), 1);
    expect((2024, 1, 6).toCalendar().weekNumberOf(weekday), 1);
    expect((2024, 1, 7).toCalendar().weekNumberOf(weekday), 2);
    expect((2024, 1, 13).toCalendar().weekNumberOf(weekday), 2);
    expect((2024, 1, 14).toCalendar().weekNumberOf(weekday), 3);
  });

  test("Edge case #1a", () {
    expect((2024, 1, 1).toCalendar().weekNumberOf(weekday), 1);
  });

  test("Edge case #1b", () {
    expect((2024, 1, 6).toCalendar().weekNumberOf(weekday), 1);
  });

  test("Edge case #1c", () {
    expect((2024, 1, 7).toCalendar().weekNumberOf(weekday), 2);
  });

  test("Edge case #2a", () {
    expect((2024, 3, 10).toCalendar().weekNumberOf(weekday), 11);
  });

  test("Edge case #2b", () {
    expect((2024, 3, 17).toCalendar().weekNumberOf(weekday), 12);
  });

  test("Edge case #3a", () {
    expect((2023, 12, 31).toCalendar().weekNumberOf(weekday), 1);
  });

  test("Edge case #3b", () {
    expect(
        (2023, 12, 31).toCalendar().weekNumberOf(
              weekday,
            ),
        // .weekNumberOf(weekday, firstDay: (2023, 12, 31).toCalendar()),
        1);
  });

  test("Edge case #3c", () {
    expect(
        (2025, 1, 1).toCalendar().weekNumberOf(
              weekday,
            ),
        // .weekNumberOf(weekday, firstDay: (2023, 12, 31).toCalendar()),
        1);
  });

  test("Edge case #3c", () {
    expect(
        (2025, 1, 5).toCalendar().weekNumberOf(
              weekday,
            ),
        // .weekNumberOf(weekday, firstDay: (2023, 12, 31).toCalendar()),
        2);
  });

  group("equality", () {
    final from = (2024, 12, 29).toCalendar();
    final to = (2025, 1, 4).toCalendar();
    group(">=", () {
      test(">= test 1", () {
        expect(from >= to, false);
      });

      test(">= test 2", () {
        expect(from >= from, true);
      });

      test(">= test 3", () {
        expect(to >= from, true);
      });
    });

    group("<=", () {
      test("<= test 1", () {
        expect(from <= to, true);
      });

      test("<= test 2", () {
        expect(from <= from, true);
      });

      test("<= test 3", () {
        expect(to <= from, false);
      });
    });
  });
}
