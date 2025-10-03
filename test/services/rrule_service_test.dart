import 'package:flutter_test/flutter_test.dart';
import 'package:habitv8/services/rrule_service.dart';
import 'package:rrule/rrule.dart';

void main() {
  group('RRuleService Tests', () {
    test('Create RRule from components - hourly', () {
      final rrule = RRuleService.createRRule(
        frequency: Frequency.hourly,
      );

      expect(rrule, equals('FREQ=HOURLY'));
    });

    test('Create RRule from components - daily', () {
      final rrule = RRuleService.createRRule(
        frequency: Frequency.daily,
      );

      expect(rrule, equals('FREQ=DAILY'));
    });

    test('Create RRule from components - weekly with interval', () {
      final rrule = RRuleService.createRRule(
        frequency: Frequency.weekly,
        interval: 2,
        byWeekDays: [DateTime.monday, DateTime.wednesday],
      );

      expect(rrule, contains('FREQ=WEEKLY'));
      expect(rrule, contains('INTERVAL=2'));
      expect(rrule, contains('BYDAY=MO,WE'));
    });

    test('Create RRule from components - monthly', () {
      final rrule = RRuleService.createRRule(
        frequency: Frequency.monthly,
        byMonthDays: [1, 15, 30],
      );

      expect(rrule, contains('FREQ=MONTHLY'));
      expect(rrule, contains('BYMONTHDAY=1,15,30'));
    });

    test('Check if habit is due on date - weekly', () {
      final startDate = DateTime(2025, 1, 1); // Wednesday
      final checkDate = DateTime(2025, 1, 8); // Next Wednesday

      final isDue = RRuleService.isDueOnDate(
        rruleString: 'FREQ=WEEKLY;BYDAY=WE',
        startDate: startDate,
        checkDate: checkDate,
      );

      expect(isDue, isTrue);
    });

    test('Check habit NOT due on date', () {
      final startDate = DateTime(2025, 1, 1); // Wednesday
      final checkDate = DateTime(2025, 1, 9); // Thursday

      final isDue = RRuleService.isDueOnDate(
        rruleString: 'FREQ=WEEKLY;BYDAY=WE',
        startDate: startDate,
        checkDate: checkDate,
      );

      expect(isDue, isFalse);
    });

    test('Get occurrences in date range', () {
      final startDate = DateTime(2025, 1, 1);
      final rangeStart = DateTime(2025, 1, 1);
      final rangeEnd = DateTime(2025, 1, 31);

      final occurrences = RRuleService.getOccurrences(
        rruleString: 'FREQ=WEEKLY;BYDAY=MO,WE,FR',
        startDate: startDate,
        rangeStart: rangeStart,
        rangeEnd: rangeEnd,
      );

      // January 2025 has about 13 Mon/Wed/Fri days
      expect(occurrences.length, greaterThan(10));
    });

    test('Validate RRule string', () {
      expect(RRuleService.isValidRRule('FREQ=DAILY'), isTrue);
      expect(RRuleService.isValidRRule('FREQ=WEEKLY;BYDAY=MO'), isTrue);
      expect(RRuleService.isValidRRule('INVALID_RRULE'), isFalse);
    });

    test('Get RRule summary', () {
      expect(RRuleService.getRRuleSummary('FREQ=HOURLY'), equals('Every hour'));
      expect(RRuleService.getRRuleSummary('FREQ=DAILY'), equals('Every day'));
      expect(RRuleService.getRRuleSummary('FREQ=WEEKLY'), equals('Every week'));
      expect(RRuleService.getRRuleSummary('FREQ=WEEKLY;INTERVAL=2'),
          equals('Every 2 weeks'));
      expect(
          RRuleService.getRRuleSummary('FREQ=MONTHLY'), equals('Every month'));
      expect(RRuleService.getRRuleSummary('FREQ=YEARLY'), equals('Every year'));
    });

    test('Get next occurrences', () {
      final startDate = DateTime(2025, 1, 1);

      final next = RRuleService.getNextOccurrences(
        rruleString: 'FREQ=DAILY',
        startDate: startDate,
        count: 5,
      );

      expect(next.length, equals(5));
    });

    test('Parse and cache RRule', () {
      final startDate = DateTime(2025, 1, 1);

      final rule1 = RRuleService.parseRRule('FREQ=DAILY', startDate);
      final rule2 = RRuleService.parseRRule('FREQ=DAILY', startDate);

      expect(rule1, isNotNull);
      expect(rule2, isNotNull);
      expect(identical(rule1, rule2), isTrue,
          reason: 'Should use cached instance');
    });

    test('Clear cache', () {
      final startDate = DateTime(2025, 1, 1);

      RRuleService.parseRRule('FREQ=DAILY', startDate);
      RRuleService.clearCache();

      final rule = RRuleService.parseRRule('FREQ=DAILY', startDate);
      expect(rule, isNotNull);
    });
  });
}
