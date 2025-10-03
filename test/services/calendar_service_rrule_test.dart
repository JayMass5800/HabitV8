import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:habitv8/domain/model/habit.dart';
import 'package:habitv8/services/calendar_service.dart';

void main() {
  group('CalendarService RRule Integration', () {
    test('isHabitDueOnDate works with RRule-based daily habit', () {
      final habit = Habit.create(
        name: 'Daily RRule Habit',
        category: 'Health',
        colorValue: Colors.blue.toARGB32(),
        frequency: HabitFrequency.daily,
      )
        ..usesRRule = true
        ..rruleString = 'FREQ=DAILY'
        ..dtStart = DateTime(2025, 1, 1);

      final testDate = DateTime(2025, 10, 3);
      expect(CalendarService.isHabitDueOnDate(habit, testDate), isTrue);
    });

    test('isHabitDueOnDate works with RRule-based weekly habit', () {
      // Weekly on Monday, Wednesday, Friday
      final habit = Habit.create(
        name: 'Weekly RRule Habit',
        category: 'Health',
        colorValue: Colors.green.toARGB32(),
        frequency: HabitFrequency.weekly,
      )
        ..usesRRule = true
        ..rruleString = 'FREQ=WEEKLY;BYDAY=MO,WE,FR'
        ..dtStart = DateTime(2025, 1, 1);

      // Oct 3, 2025 is a Friday
      final friday = DateTime(2025, 10, 3);
      expect(CalendarService.isHabitDueOnDate(habit, friday), isTrue);

      // Oct 4, 2025 is a Saturday
      final saturday = DateTime(2025, 10, 4);
      expect(CalendarService.isHabitDueOnDate(habit, saturday), isFalse);

      // Oct 6, 2025 is a Monday
      final monday = DateTime(2025, 10, 6);
      expect(CalendarService.isHabitDueOnDate(habit, monday), isTrue);
    });

    test('isHabitDueOnDate falls back to legacy logic for non-RRule habits',
        () {
      // Legacy daily habit (no RRule)
      final habit = Habit.create(
        name: 'Legacy Daily Habit',
        category: 'Health',
        colorValue: Colors.red.toARGB32(),
        frequency: HabitFrequency.daily,
      );

      final testDate = DateTime(2025, 10, 3);
      expect(CalendarService.isHabitDueOnDate(habit, testDate), isTrue);
    });

    test('isHabitDueOnDate works with legacy weekly habit', () {
      // Legacy weekly habit on Monday (weekday = 1)
      final habit = Habit.create(
        name: 'Legacy Weekly Habit',
        category: 'Health',
        colorValue: Colors.orange.toARGB32(),
        frequency: HabitFrequency.weekly,
        selectedWeekdays: const [1], // Monday
      );

      // Oct 6, 2025 is a Monday
      final monday = DateTime(2025, 10, 6);
      expect(CalendarService.isHabitDueOnDate(habit, monday), isTrue);

      // Oct 3, 2025 is a Friday
      final friday = DateTime(2025, 10, 3);
      expect(CalendarService.isHabitDueOnDate(habit, friday), isFalse);
    });

    test(
        'getHabitsForDate filters correctly with mix of RRule and legacy habits',
        () {
      final rruleHabit = Habit.create(
        name: 'RRule Weekly',
        category: 'Health',
        colorValue: Colors.purple.toARGB32(),
        frequency: HabitFrequency.weekly,
      )
        ..usesRRule = true
        ..rruleString = 'FREQ=WEEKLY;BYDAY=FR'
        ..dtStart = DateTime(2025, 1, 1);

      final legacyHabit = Habit.create(
        name: 'Legacy Daily',
        category: 'Health',
        colorValue: Colors.teal.toARGB32(),
        frequency: HabitFrequency.daily,
      );

      final allHabits = [rruleHabit, legacyHabit];

      // Oct 3, 2025 is a Friday - both should be included
      final friday = DateTime(2025, 10, 3);
      final habitsOnFriday =
          CalendarService.getHabitsForDate(friday, allHabits);
      expect(habitsOnFriday.length, equals(2));

      // Oct 4, 2025 is a Saturday - only legacy daily should be included
      final saturday = DateTime(2025, 10, 4);
      final habitsOnSaturday =
          CalendarService.getHabitsForDate(saturday, allHabits);
      expect(habitsOnSaturday.length, equals(1));
      expect(habitsOnSaturday.first.name, equals('Legacy Daily'));
    });

    test('isHabitDueOnDate handles RRule with interval', () {
      // Every 2 weeks
      final habit = Habit.create(
        name: 'Bi-weekly Habit',
        category: 'Health',
        colorValue: Colors.indigo.toARGB32(),
        frequency: HabitFrequency.weekly,
      )
        ..usesRRule = true
        ..rruleString = 'FREQ=WEEKLY;INTERVAL=2;BYDAY=FR'
        ..dtStart = DateTime(2025, 10, 3); // Starting Oct 3 (Friday)

      // Oct 3, 2025 - first occurrence
      expect(CalendarService.isHabitDueOnDate(habit, DateTime(2025, 10, 3)),
          isTrue);

      // Oct 10, 2025 - one week later (should be false)
      expect(CalendarService.isHabitDueOnDate(habit, DateTime(2025, 10, 10)),
          isFalse);

      // Oct 17, 2025 - two weeks later (should be true)
      expect(CalendarService.isHabitDueOnDate(habit, DateTime(2025, 10, 17)),
          isTrue);
    });
  });
}
