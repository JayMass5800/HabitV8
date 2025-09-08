import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habitv8/services/smart_threshold_service.dart';

void main() {
  group('SmartThresholdService Tests', () {
    setUp(() async {
      // Initialize SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
    });

    test('should initialize habit thresholds', () async {
      const habitId = 'test_habit_123';

      // Initialize thresholds for a habit
      await SmartThresholdService.initializeHabitThresholds(habitId);

      // Verify initialization doesn't throw errors
      expect(true, isTrue); // Basic test to ensure no exceptions
    });

    test('should get smart threshold stats', () async {
      // Get stats (should work even with no data)
      final stats = await SmartThresholdService.getSmartThresholdStats();

      // Verify stats structure
      expect(stats, isA<Map<String, dynamic>>());
      expect(stats.containsKey('totalHabits'), isTrue);
      expect(stats.containsKey('habitsWithAdjustments'), isTrue);
      expect(stats.containsKey('totalAdjustments'), isTrue);
      expect(stats.containsKey('averageConfidence'), isTrue);
      expect(stats.containsKey('totalLearningPoints'), isTrue);
    });

    test('should get adaptive threshold with fallback', () async {
      const habitId = 'test_habit_456';
      const healthDataType = 'STEPS';
      const originalThreshold = 5000.0;
      final date = DateTime.now();

      // Get adaptive threshold (should fallback to original when no learning data)
      final result = await SmartThresholdService.getAdaptiveThreshold(
        habitId: habitId,
        healthDataType: healthDataType,
        originalThreshold: originalThreshold,
        date: date,
      );

      // Verify result structure
      expect(result.threshold, isA<double>());
      expect(result.confidence, isA<double>());
      expect(result.reason, isA<String>());
      expect(result.isAdapted, isA<bool>());

      // Should fallback to original threshold when no learning data
      expect(result.threshold, equals(originalThreshold));
      expect(result.isAdapted, isFalse);
    });

    test('should learn from completion data', () async {
      const habitId = 'test_habit_789';
      const healthDataType = 'STEPS';
      const healthValue = 7500.0;
      const usedThreshold = 5000.0;
      final date = DateTime.now();

      // Learn from completion (should not throw errors)
      await SmartThresholdService.learnFromCompletion(
        habitId: habitId,
        healthDataType: healthDataType,
        healthValue: healthValue,
        usedThreshold: usedThreshold,
        wasAutoCompleted: true,
        wasManuallyCompleted: false,
        date: date,
      );

      // Verify no exceptions thrown
      expect(true, isTrue);
    });

    test('should handle multiple learning cycles', () async {
      const habitId = 'test_habit_multiple';
      const healthDataType = 'STEPS';
      final date = DateTime.now();

      // Learn from multiple completions
      for (int i = 0; i < 5; i++) {
        await SmartThresholdService.learnFromCompletion(
          habitId: habitId,
          healthDataType: healthDataType,
          healthValue: 5000.0 + (i * 500),
          usedThreshold: 5000.0,
          wasAutoCompleted: i % 2 == 0,
          wasManuallyCompleted: i % 2 == 1,
          date: date.add(Duration(days: i)),
        );
      }

      // Verify no exceptions thrown
      expect(true, isTrue);
    });

    test('should handle edge cases gracefully', () async {
      const habitId = 'test_habit_edge';
      const healthDataType = 'INVALID_TYPE';
      const originalThreshold = 0.0;
      final date = DateTime.now();

      // Test with edge case values
      final result = await SmartThresholdService.getAdaptiveThreshold(
        habitId: habitId,
        healthDataType: healthDataType,
        originalThreshold: originalThreshold,
        date: date,
      );

      // Should handle gracefully
      expect(result.threshold, isA<double>());
      expect(result.confidence, isA<double>());
    });
  });
}
