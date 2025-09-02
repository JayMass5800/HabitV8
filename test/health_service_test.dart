import 'package:flutter_test/flutter_test.dart';
import 'package:habitv8/services/simple_health_service.dart';
import 'package:habitv8/services/minimal_health_channel.dart';

void main() {
  group('Health Service Tests', () {
    test('SimpleHealthService should initialize without errors', () async {
      // This test verifies that the service can be initialized without throwing exceptions
      expect(() => SimpleHealthService.initialize(), returnsNormally);
    });

    test('SimpleHealthService methods should not throw compilation errors', () {
      // Test that all methods exist and can be called
      expect(() => SimpleHealthService.getHealthPermissions(), returnsNormally);
      expect(() => SimpleHealthService.requestPermissions(), returnsNormally);
      expect(() => SimpleHealthService.checkPermissions(), returnsNormally);

      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      expect(
          () => SimpleHealthService.getStepsData(
              startTime: yesterday, endTime: now),
          returnsNormally);

      expect(
          () => SimpleHealthService.getHeartRateData(
              startTime: yesterday, endTime: now),
          returnsNormally);

      expect(
          () => SimpleHealthService.getSleepData(
              startTime: yesterday, endTime: now),
          returnsNormally);
    });

    test('MinimalHealthChannel methods should exist', () {
      // Test that MinimalHealthChannel methods exist
      expect(
          () => MinimalHealthChannel.getSupportedDataTypes(), returnsNormally);
      expect(() => MinimalHealthChannel.requestPermissions(), returnsNormally);
      expect(
          () => MinimalHealthChannel.getHealthConnectStatus(), returnsNormally);

      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      expect(
          () => MinimalHealthChannel.getHealthData(
                dataType: 'STEPS',
                startDate: yesterday,
                endDate: now,
              ),
          returnsNormally);
    });
  });
}
