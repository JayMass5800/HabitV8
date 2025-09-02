import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habitv8/services/health_service.dart';

void main() {
  group('Health Sync Preference Tests', () {
    setUp(() {
      // Clear shared preferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    test('isHealthSyncEnabled returns false by default', () async {
      final result = await HealthService.isHealthSyncEnabled();
      expect(result, false);
    });

    test('shouldPerformHealthOperations returns false when sync disabled',
        () async {
      // Set health sync to disabled
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('health_sync_enabled', false);

      final result = await HealthService.shouldPerformHealthOperations();
      expect(result, false);
    });

    test('health data methods return default values when sync disabled',
        () async {
      // Set health sync to disabled
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('health_sync_enabled', false);

      // Test various health data methods
      expect(await HealthService.getStepsToday(), 0);
      expect(await HealthService.getActiveCaloriesToday(), 0.0);
      expect(await HealthService.getTotalCaloriesToday(), 0.0);
      expect(await HealthService.getSleepHoursLastNight(), 0.0);
      expect(await HealthService.getWaterIntakeToday(), 0.0);
      expect(await HealthService.getMindfulnessMinutesToday(), 0.0);
      expect(await HealthService.getLatestWeight(), null);
      expect(await HealthService.getMedicationAdherenceToday(), 0.0);
      expect(await HealthService.getLatestHeartRate(), null);
      expect(await HealthService.getRestingHeartRateToday(), null);
    });

    test('getTodayHealthSummary returns disabled message when sync disabled',
        () async {
      // Set health sync to disabled
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('health_sync_enabled', false);

      final summary = await HealthService.getTodayHealthSummary();
      expect(summary['error'], 'Health data sync is disabled');
    });
  });
}
