import 'package:flutter_test/flutter_test.dart';
import 'package:habitv8/services/background_task_service.dart';
import 'package:habitv8/services/notification_queue_processor.dart';
import 'package:habitv8/services/calendar_renewal_service.dart';
import 'package:habitv8/services/habit_continuation_service.dart';
import 'package:habitv8/services/app_lifecycle_service.dart';

void main() {
  group('Resource Cleanup Tests', () {
    test('BackgroundTaskService dispose should clean up resources', () {
      // Add some debounced tasks
      BackgroundTaskService.debounceTask('test_task_1', () {});
      BackgroundTaskService.debounceTask('test_task_2', () {});

      // Check that debouncers exist
      final metrics = BackgroundTaskService.getTaskMetrics();
      expect(metrics['activeDebouncers'], greaterThan(0));

      // Dispose the service
      BackgroundTaskService.dispose();

      // Check that resources are cleaned up
      final metricsAfter = BackgroundTaskService.getTaskMetrics();
      expect(metricsAfter['activeDebouncers'], equals(0));
      expect(metricsAfter['queuedTasks'], equals(0));
      expect(metricsAfter['currentTasks'], equals(0));
    });

    test('NotificationQueueProcessor dispose should clean up resources', () {
      // Check initial state
      final statusBefore = NotificationQueueProcessor.getQueueStatus();

      // Dispose the service
      NotificationQueueProcessor.dispose();

      // Check that resources are cleaned up
      final statusAfter = NotificationQueueProcessor.getQueueStatus();
      expect(statusAfter['isProcessing'], isFalse);
      expect(statusAfter['queueSize'], equals(0));
      expect(statusAfter['processedCount'], equals(0));
      expect(statusAfter['failedCount'], equals(0));
    });

    test('AppLifecycleService should dispose all services', () {
      // Initialize the lifecycle service
      AppLifecycleService.initialize();

      // Force cleanup to test disposal
      AppLifecycleService.forceCleanup();

      // Verify that services are cleaned up
      final backgroundMetrics = BackgroundTaskService.getTaskMetrics();
      expect(backgroundMetrics['activeDebouncers'], equals(0));

      final queueStatus = NotificationQueueProcessor.getQueueStatus();
      expect(queueStatus['isProcessing'], isFalse);
    });

    test('All services should have dispose methods', () {
      // Test that all services have dispose methods and they don't throw
      expect(() => BackgroundTaskService.dispose(), returnsNormally);
      expect(() => NotificationQueueProcessor.dispose(), returnsNormally);
      expect(() => CalendarRenewalService.dispose(), returnsNormally);
      expect(() => HabitContinuationService.dispose(), returnsNormally);
    });
  });
}
