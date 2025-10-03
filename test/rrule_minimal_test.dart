import 'package:flutter_test/flutter_test.dart';
import 'package:rrule/rrule.dart';

void main() {
  test('Minimal RRule test - parse only', () {
    final rule = RecurrenceRule.fromString('RRULE:FREQ=DAILY');
    expect(rule, isNotNull);
  });

  test('Minimal RRule test - get 5 instances with getInstances()', () {
    final rule = RecurrenceRule.fromString('RRULE:FREQ=DAILY');
    final start = DateTime.utc(2025, 1, 1); // MUST be UTC!

    final instances = rule.getInstances(start: start).take(5).toList();

    expect(instances.length, equals(5));
  });

  test('Minimal RRule test - weekly pattern', () {
    final rule = RecurrenceRule.fromString('RRULE:FREQ=WEEKLY;BYDAY=MO,WE,FR');
    final start = DateTime.utc(2025, 1, 1);

    final instances = rule.getInstances(start: start).take(10).toList();

    expect(instances.length, equals(10));
    expect(instances.isNotEmpty, isTrue);
  });
}
