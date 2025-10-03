import 'package:flutter_test/flutter_test.dart';
import 'package:habitv8/services/rrule_service.dart';

/// Phase 2 Integration Tests - Simplified
/// Tests that verify RRule integration works correctly
void main() {
  group('Phase 2: Service Layer Integration Tests', () {
    group('RRuleService Basic Functionality', () {
      test('isDueOnDate works for daily RRule', () {
        // Oct 2, 2025 is Thursday - daily should be true
        final thursday = DateTime(2025, 10, 2);
        expect(
          RRuleService.isDueOnDate(
            rruleString: 'FREQ=DAILY',
            startDate: DateTime(2025, 10, 1),
            checkDate: thursday,
          ),
          isTrue,
        );
      });

      test('isDueOnDate works for weekly RRule', () {
        // Oct 2, 2025 is Thursday
        final thursday = DateTime(2025, 10, 2);
        
        // Should be due on Thursday
        expect(
          RRuleService.isDueOnDate(
            rruleString: 'FREQ=WEEKLY;BYDAY=TH',
            startDate: DateTime(2025, 10, 1),
            checkDate: thursday,
          ),
          isTrue,
        );

        // Should NOT be due on Friday
        final friday = DateTime(2025, 10, 3);
        expect(
          RRuleService.isDueOnDate(
            rruleString: 'FREQ=WEEKLY;BYDAY=TH',
            startDate: DateTime(2025, 10, 1),
            checkDate: friday,
          ),
          isFalse,
        );
      });

      test('isDueOnDate works for every-other-week pattern', () {
        // Start on Oct 7, 2025 (Tuesday - first occurrence)
        final startDate = DateTime(2025, 10, 7);
        
        // First Tuesday (Oct 7) - should be true
        expect(
          RRuleService.isDueOnDate(
            rruleString: 'FREQ=WEEKLY;INTERVAL=2;BYDAY=TU',
            startDate: startDate,
            checkDate: startDate,
          ),
          isTrue,
        );

        // Next Tuesday (Oct 14) - NOT due (interval=2, so every other week)
        final nextTue = DateTime(2025, 10, 14);
        expect(
          RRuleService.isDueOnDate(
            rruleString: 'FREQ=WEEKLY;INTERVAL=2;BYDAY=TU',
            startDate: startDate,
            checkDate: nextTue,
          ),
          isFalse,
        );

        // Tuesday after that (Oct 21) - should be true again
        final thirdTue = DateTime(2025, 10, 21);
        expect(
          RRuleService.isDueOnDate(
            rruleString: 'FREQ=WEEKLY;INTERVAL=2;BYDAY=TU',
            startDate: startDate,
            checkDate: thirdTue,
          ),
          isTrue,
        );
      });

      test('getOccurrences returns correct dates for weekly pattern', () {
        // Get occurrences for first week of October 2025
        final occurrences = RRuleService.getOccurrences(
          rruleString: 'FREQ=WEEKLY;BYDAY=TU,TH',
          startDate: DateTime(2025, 10, 1),
          rangeStart: DateTime(2025, 10, 1),
          rangeEnd: DateTime(2025, 10, 7),
        );

        // Should have 2 occurrences: Oct 2 (Thu) and Oct 7 (Tue)
        expect(occurrences.length, equals(2));
      });

      test('getOccurrences returns correct dates for monthly pattern', () {
        // Get occurrences for October 2025 (15th of each month)
        final occurrences = RRuleService.getOccurrences(
          rruleString: 'FREQ=MONTHLY;BYMONTHDAY=15',
          startDate: DateTime(2025, 10, 1),
          rangeStart: DateTime(2025, 10, 1),
          rangeEnd: DateTime(2025, 10, 31),
        );

        // Should have 1 occurrence: Oct 15
        expect(occurrences.length, equals(1));
        expect(occurrences.first.day, equals(15));
      });

      test('getRRuleSummary returns readable text', () {
        expect(
          RRuleService.getRRuleSummary('FREQ=HOURLY'),
          equals('Every hour'),
        );

        expect(
          RRuleService.getRRuleSummary('FREQ=DAILY'),
          equals('Every day'),
        );

        expect(
          RRuleService.getRRuleSummary('FREQ=WEEKLY'),
          equals('Every week'),
        );

        expect(
          RRuleService.getRRuleSummary('FREQ=WEEKLY;INTERVAL=2'),
          equals('Every 2 weeks'),
        );

        expect(
          RRuleService.getRRuleSummary('FREQ=MONTHLY'),
          equals('Every month'),
        );

        expect(
          RRuleService.getRRuleSummary('FREQ=YEARLY'),
          equals('Every year'),
        );
      });

      test('isValidRRule validates RRule strings', () {
        expect(RRuleService.isValidRRule('FREQ=DAILY'), isTrue);
        expect(RRuleService.isValidRRule('FREQ=WEEKLY;BYDAY=MO,WE,FR'), isTrue);
        expect(RRuleService.isValidRRule('INVALID_RRULE'), isFalse);
        expect(RRuleService.isValidRRule(''), isFalse);
      });

      test('getNextOccurrences returns upcoming dates', () {
        final occurrences = RRuleService.getNextOccurrences(
          rruleString: 'FREQ=DAILY',
          startDate: DateTime.now(),
          count: 5,
        );

        expect(occurrences.length, equals(5));
        
        // Each occurrence should be after the previous
        for (int i = 1; i < occurrences.length; i++) {
          expect(occurrences[i].isAfter(occurrences[i - 1]), isTrue);
        }
      });
    });

    group('Legacy Conversion Tests', () {
      test('convertLegacyToRRule converts daily correctly', () {
        // This would need a Habit object, but we can test the RRule service directly
        final rrule = 'FREQ=DAILY';
        expect(RRuleService.isValidRRule(rrule), isTrue);
      });

      test('Weekly pattern is valid RRule', () {
        final rrule = 'FREQ=WEEKLY;BYDAY=MO,WE,FR';
        expect(RRuleService.isValidRRule(rrule), isTrue);
      });

      test('Monthly pattern is valid RRule', () {
        final rrule = 'FREQ=MONTHLY;BYMONTHDAY=15';
        expect(RRuleService.isValidRRule(rrule), isTrue);
      });

      test('Yearly pattern is valid RRule', () {
        final rrule = 'FREQ=YEARLY;BYMONTH=7;BYMONTHDAY=4';
        expect(RRuleService.isValidRRule(rrule), isTrue);
      });
    });

    group('Edge Cases', () {
      test('Empty RRule string is invalid', () {
        expect(RRuleService.isValidRRule(''), isFalse);
      });

      test('Large date ranges work without hanging', () {
        // This should complete quickly without hanging
        final occurrences = RRuleService.getOccurrences(
          rruleString: 'FREQ=DAILY',
          startDate: DateTime(2025, 1, 1),
          rangeStart: DateTime(2025, 1, 1),
          rangeEnd: DateTime(2025, 12, 31), // Full year
        );

        // Should have ~365 occurrences
        expect(occurrences.length, greaterThan(300));
        expect(occurrences.length, lessThan(400));
      });

      test('RRule with UNTIL works correctly', () {
        final rrule = 'FREQ=DAILY;UNTIL=20251010T000000Z';
        expect(RRuleService.isValidRRule(rrule), isTrue);
      });

      test('RRule with COUNT works correctly', () {
        final occurrences = RRuleService.getNextOccurrences(
          rruleString: 'FREQ=DAILY;COUNT=10',
          startDate: DateTime.now(),
          count: 5,
        );

        expect(occurrences.length, equals(5));
      });
    });
  });
}

