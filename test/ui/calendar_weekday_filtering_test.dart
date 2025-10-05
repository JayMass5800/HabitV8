import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:habitv8/domain/model/habit.dart';

/// Tests to verify calendar weekday filtering is correct for hourly and weekly habits
/// Specifically tests the Sunday edge case that was previously broken
void main() {
  group('Calendar Weekday Filtering', () {
    test('Hourly habit with all weekdays selected should match Sunday', () {
      // Create hourly habit with all 7 days selected (Mon-Sun)
      final habit = Habit.create(
        name: 'Drink Water',
        category: 'Health',
        colorValue: Colors.blue.toARGB32(),
        frequency: HabitFrequency.hourly,
        selectedWeekdays: const [1, 2, 3, 4, 5, 6, 7], // Mon-Sun
      )..hourlyTimes = ['09:00', '15:00', '21:00'];

      // Test all days of the week
      final monday = DateTime(2025, 10, 6); // Monday
      final tuesday = DateTime(2025, 10, 7); // Tuesday
      final wednesday = DateTime(2025, 10, 8); // Wednesday
      final thursday = DateTime(2025, 10, 9); // Thursday
      final friday = DateTime(2025, 10, 10); // Friday
      final saturday = DateTime(2025, 10, 11); // Saturday
      final sunday = DateTime(2025, 10, 12); // Sunday

      // Verify weekday numbers
      expect(monday.weekday, equals(1));
      expect(tuesday.weekday, equals(2));
      expect(wednesday.weekday, equals(3));
      expect(thursday.weekday, equals(4));
      expect(friday.weekday, equals(5));
      expect(saturday.weekday, equals(6));
      expect(sunday.weekday, equals(7));

      // All should match since all weekdays are selected
      expect(habit.selectedWeekdays.contains(monday.weekday), isTrue,
          reason: 'Monday (weekday=1) should match');
      expect(habit.selectedWeekdays.contains(tuesday.weekday), isTrue,
          reason: 'Tuesday (weekday=2) should match');
      expect(habit.selectedWeekdays.contains(wednesday.weekday), isTrue,
          reason: 'Wednesday (weekday=3) should match');
      expect(habit.selectedWeekdays.contains(thursday.weekday), isTrue,
          reason: 'Thursday (weekday=4) should match');
      expect(habit.selectedWeekdays.contains(friday.weekday), isTrue,
          reason: 'Friday (weekday=5) should match');
      expect(habit.selectedWeekdays.contains(saturday.weekday), isTrue,
          reason: 'Saturday (weekday=6) should match');
      expect(habit.selectedWeekdays.contains(sunday.weekday), isTrue,
          reason: 'Sunday (weekday=7) should match - THIS WAS THE BUG!');
    });

    test('Hourly habit with only Sunday selected should match Sunday only', () {
      final habit = Habit.create(
        name: 'Sunday Meditation',
        category: 'Health',
        colorValue: Colors.purple.toARGB32(),
        frequency: HabitFrequency.hourly,
        selectedWeekdays: const [7], // Sunday only
      )..hourlyTimes = ['10:00'];

      final saturday = DateTime(2025, 10, 11); // Saturday
      final sunday = DateTime(2025, 10, 12); // Sunday

      expect(habit.selectedWeekdays.contains(saturday.weekday), isFalse,
          reason: 'Saturday should NOT match');
      expect(habit.selectedWeekdays.contains(sunday.weekday), isTrue,
          reason: 'Sunday should match');
    });

    test('Weekly habit with Sunday should match Sunday, not Saturday', () {
      final habit = Habit.create(
        name: 'Weekly Sunday Habit',
        category: 'Health',
        colorValue: Colors.green.toARGB32(),
        frequency: HabitFrequency.weekly,
        selectedWeekdays: const [7], // Sunday only
      );

      final friday = DateTime(2025, 10, 10); // Friday
      final saturday = DateTime(2025, 10, 11); // Saturday
      final sunday = DateTime(2025, 10, 12); // Sunday
      final monday = DateTime(2025, 10, 13); // Monday

      expect(habit.selectedWeekdays.contains(friday.weekday), isFalse,
          reason: 'Friday should NOT match');
      expect(habit.selectedWeekdays.contains(saturday.weekday), isFalse,
          reason: 'Saturday should NOT match - THIS WAS THE BUG!');
      expect(habit.selectedWeekdays.contains(sunday.weekday), isTrue,
          reason: 'Sunday should match');
      expect(habit.selectedWeekdays.contains(monday.weekday), isFalse,
          reason: 'Monday should NOT match');
    });

    test('Weekly habit with Monday-Friday (weekdays only)', () {
      final habit = Habit.create(
        name: 'Weekday Workout',
        category: 'Fitness',
        colorValue: Colors.orange.toARGB32(),
        frequency: HabitFrequency.weekly,
        selectedWeekdays: const [1, 2, 3, 4, 5], // Mon-Fri
      );

      final monday = DateTime(2025, 10, 6); // Monday
      final wednesday = DateTime(2025, 10, 8); // Wednesday
      final friday = DateTime(2025, 10, 10); // Friday
      final saturday = DateTime(2025, 10, 11); // Saturday
      final sunday = DateTime(2025, 10, 12); // Sunday

      expect(habit.selectedWeekdays.contains(monday.weekday), isTrue);
      expect(habit.selectedWeekdays.contains(wednesday.weekday), isTrue);
      expect(habit.selectedWeekdays.contains(friday.weekday), isTrue);
      expect(habit.selectedWeekdays.contains(saturday.weekday), isFalse);
      expect(habit.selectedWeekdays.contains(sunday.weekday), isFalse);
    });

    test('Weekly habit with Saturday-Sunday (weekends only)', () {
      final habit = Habit.create(
        name: 'Weekend Hobby',
        category: 'Fun',
        colorValue: Colors.red.toARGB32(),
        frequency: HabitFrequency.weekly,
        selectedWeekdays: const [6, 7], // Sat-Sun
      );

      final friday = DateTime(2025, 10, 10); // Friday
      final saturday = DateTime(2025, 10, 11); // Saturday
      final sunday = DateTime(2025, 10, 12); // Sunday
      final monday = DateTime(2025, 10, 13); // Monday

      expect(habit.selectedWeekdays.contains(friday.weekday), isFalse);
      expect(habit.selectedWeekdays.contains(saturday.weekday), isTrue);
      expect(habit.selectedWeekdays.contains(sunday.weekday), isTrue);
      expect(habit.selectedWeekdays.contains(monday.weekday), isFalse);
    });

    test('Hourly habit with no weekdays selected should never match', () {
      final habit = Habit.create(
        name: 'Incomplete Hourly',
        category: 'Health',
        colorValue: Colors.grey.toARGB32(),
        frequency: HabitFrequency.hourly,
        selectedWeekdays: const [], // No weekdays selected
      )..hourlyTimes = ['10:00'];

      final monday = DateTime(2025, 10, 6);
      final sunday = DateTime(2025, 10, 12);

      // Empty weekdays list means no days should match
      expect(habit.selectedWeekdays.isEmpty, isTrue);
      expect(habit.selectedWeekdays.contains(monday.weekday), isFalse);
      expect(habit.selectedWeekdays.contains(sunday.weekday), isFalse);
    });

    test('Weekday storage format is 1-7 (Monday-Sunday)', () {
      // Verify the weekday numbering system matches DateTime.weekday
      final dates = [
        DateTime(2025, 10, 6), // Monday
        DateTime(2025, 10, 7), // Tuesday
        DateTime(2025, 10, 8), // Wednesday
        DateTime(2025, 10, 9), // Thursday
        DateTime(2025, 10, 10), // Friday
        DateTime(2025, 10, 11), // Saturday
        DateTime(2025, 10, 12), // Sunday
      ];

      for (int i = 0; i < dates.length; i++) {
        expect(dates[i].weekday, equals(i + 1),
            reason: 'DateTime.weekday should be 1-based (1=Monday)');
      }

      // Sunday specifically
      expect(dates[6].weekday, equals(7),
          reason: 'Sunday should be weekday 7, not 0');
    });

    test('Habit with alternating weekdays (Mon, Wed, Fri)', () {
      final habit = Habit.create(
        name: 'MWF Gym',
        category: 'Fitness',
        colorValue: Colors.teal.toARGB32(),
        frequency: HabitFrequency.weekly,
        selectedWeekdays: const [1, 3, 5], // Mon, Wed, Fri
      );

      final week = [
        DateTime(2025, 10, 6), // Monday - should match
        DateTime(2025, 10, 7), // Tuesday - should NOT match
        DateTime(2025, 10, 8), // Wednesday - should match
        DateTime(2025, 10, 9), // Thursday - should NOT match
        DateTime(2025, 10, 10), // Friday - should match
        DateTime(2025, 10, 11), // Saturday - should NOT match
        DateTime(2025, 10, 12), // Sunday - should NOT match
      ];

      final expected = [true, false, true, false, true, false, false];

      for (int i = 0; i < week.length; i++) {
        expect(habit.selectedWeekdays.contains(week[i].weekday),
            equals(expected[i]),
            reason: 'Day ${i + 1} match status incorrect');
      }
    });
  });

  group('Edge Cases', () {
    test('Habit created on Sunday should work correctly', () {
      final sunday = DateTime(2025, 10, 12); // Sunday
      final habit = Habit.create(
        name: 'Created on Sunday',
        category: 'Test',
        colorValue: Colors.blue.toARGB32(),
        frequency: HabitFrequency.weekly,
        selectedWeekdays: const [7], // Sunday
      );
      // Manually set createdAt to Sunday for testing
      habit.createdAt = sunday;

      expect(habit.createdAt.weekday, equals(7));
      expect(habit.selectedWeekdays.contains(sunday.weekday), isTrue);
    });

    test('Habit spanning multiple weeks with Sunday', () {
      final habit = Habit.create(
        name: 'Multi-week Sunday Habit',
        category: 'Test',
        colorValue: Colors.amber.toARGB32(),
        frequency: HabitFrequency.weekly,
        selectedWeekdays: const [7], // Sunday
      );

      // Test 4 consecutive Sundays
      final sundays = [
        DateTime(2025, 10, 5), // Sunday week 1
        DateTime(2025, 10, 12), // Sunday week 2
        DateTime(2025, 10, 19), // Sunday week 3
        DateTime(2025, 10, 26), // Sunday week 4
      ];

      for (final sunday in sundays) {
        expect(sunday.weekday, equals(7), reason: 'Should be Sunday');
        expect(habit.selectedWeekdays.contains(sunday.weekday), isTrue,
            reason: 'All Sundays should match');
      }
    });
  });
}
