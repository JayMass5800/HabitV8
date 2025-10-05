import 'package:flutter_test/flutter_test.dart';
import 'package:habitv8/services/rrule_service.dart';

void main() {
  group('RRule Date Offset Bug Tests', () {
    test('Monthly habit on 5th, 10th, 15th - should only show on those days',
        () {
      final startDate = DateTime(2025, 10, 1); // Oct 1, 2025

      // Test the 5th - should be TRUE
      final isDueOn5th = RRuleService.isDueOnDate(
        rruleString: 'FREQ=MONTHLY;BYMONTHDAY=5,10,15',
        startDate: startDate,
        checkDate: DateTime(2025, 10, 5),
      );
      expect(isDueOn5th, isTrue, reason: 'Should be due on the 5th');

      // Test the 4th - should be FALSE
      final isDueOn4th = RRuleService.isDueOnDate(
        rruleString: 'FREQ=MONTHLY;BYMONTHDAY=5,10,15',
        startDate: startDate,
        checkDate: DateTime(2025, 10, 4),
      );
      expect(isDueOn4th, isFalse, reason: 'Should NOT be due on the 4th');

      // Test the 6th - should be FALSE
      final isDueOn6th = RRuleService.isDueOnDate(
        rruleString: 'FREQ=MONTHLY;BYMONTHDAY=5,10,15',
        startDate: startDate,
        checkDate: DateTime(2025, 10, 6),
      );
      expect(isDueOn6th, isFalse, reason: 'Should NOT be due on the 6th');

      // Test the 10th - should be TRUE
      final isDueOn10th = RRuleService.isDueOnDate(
        rruleString: 'FREQ=MONTHLY;BYMONTHDAY=5,10,15',
        startDate: startDate,
        checkDate: DateTime(2025, 10, 10),
      );
      expect(isDueOn10th, isTrue, reason: 'Should be due on the 10th');

      // Test the 9th - should be FALSE
      final isDueOn9th = RRuleService.isDueOnDate(
        rruleString: 'FREQ=MONTHLY;BYMONTHDAY=5,10,15',
        startDate: startDate,
        checkDate: DateTime(2025, 10, 9),
      );
      expect(isDueOn9th, isFalse, reason: 'Should NOT be due on the 9th');

      // Test the 15th - should be TRUE
      final isDueOn15th = RRuleService.isDueOnDate(
        rruleString: 'FREQ=MONTHLY;BYMONTHDAY=5,10,15',
        startDate: startDate,
        checkDate: DateTime(2025, 10, 15),
      );
      expect(isDueOn15th, isTrue, reason: 'Should be due on the 15th');

      // Test the 14th - should be FALSE
      final isDueOn14th = RRuleService.isDueOnDate(
        rruleString: 'FREQ=MONTHLY;BYMONTHDAY=5,10,15',
        startDate: startDate,
        checkDate: DateTime(2025, 10, 14),
      );
      expect(isDueOn14th, isFalse, reason: 'Should NOT be due on the 14th');
    });

    test('Weekly habit on Monday - should only show on Mondays', () {
      final startDate = DateTime(2025, 10, 6); // Oct 6, 2025 (Monday)

      // Test Monday Oct 6 - should be TRUE
      final isDueOnMon6 = RRuleService.isDueOnDate(
        rruleString: 'FREQ=WEEKLY;BYDAY=MO',
        startDate: startDate,
        checkDate: DateTime(2025, 10, 6),
      );
      expect(isDueOnMon6, isTrue, reason: 'Should be due on Monday Oct 6');

      // Test Sunday Oct 5 - should be FALSE
      final isDueOnSun5 = RRuleService.isDueOnDate(
        rruleString: 'FREQ=WEEKLY;BYDAY=MO',
        startDate: startDate,
        checkDate: DateTime(2025, 10, 5),
      );
      expect(isDueOnSun5, isFalse, reason: 'Should NOT be due on Sunday Oct 5');

      // Test Tuesday Oct 7 - should be FALSE
      final isDueOnTue7 = RRuleService.isDueOnDate(
        rruleString: 'FREQ=WEEKLY;BYDAY=MO',
        startDate: startDate,
        checkDate: DateTime(2025, 10, 7),
      );
      expect(isDueOnTue7, isFalse,
          reason: 'Should NOT be due on Tuesday Oct 7');

      // Test next Monday Oct 13 - should be TRUE
      final isDueOnMon13 = RRuleService.isDueOnDate(
        rruleString: 'FREQ=WEEKLY;BYDAY=MO',
        startDate: startDate,
        checkDate: DateTime(2025, 10, 13),
      );
      expect(isDueOnMon13, isTrue, reason: 'Should be due on Monday Oct 13');
    });

    test('Daily habit - should show every day', () {
      final startDate = DateTime(2025, 10, 1);

      for (int day = 1; day <= 10; day++) {
        final isDue = RRuleService.isDueOnDate(
          rruleString: 'FREQ=DAILY',
          startDate: startDate,
          checkDate: DateTime(2025, 10, day),
        );
        expect(isDue, isTrue, reason: 'Should be due on Oct $day');
      }
    });

    test('Get occurrences for monthly habit - verify exact dates', () {
      final startDate = DateTime(2025, 10, 1);
      final rangeStart = DateTime(2025, 10, 1);
      final rangeEnd = DateTime(2025, 10, 31);

      final occurrences = RRuleService.getOccurrences(
        rruleString: 'FREQ=MONTHLY;BYMONTHDAY=5,10,15',
        startDate: startDate,
        rangeStart: rangeStart,
        rangeEnd: rangeEnd,
      );

      expect(occurrences.length, equals(3),
          reason: 'Should have exactly 3 occurrences in October');

      // Check that the dates are exactly the 5th, 10th, and 15th
      expect(occurrences[0].day, equals(5),
          reason: 'First occurrence should be on the 5th');
      expect(occurrences[1].day, equals(10),
          reason: 'Second occurrence should be on the 10th');
      expect(occurrences[2].day, equals(15),
          reason: 'Third occurrence should be on the 15th');
    });
  });
}
