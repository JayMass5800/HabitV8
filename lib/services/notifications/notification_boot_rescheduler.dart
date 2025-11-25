import 'package:awesome_notifications/awesome_notifications.dart';
import '../logging_service.dart';
import '../../data/database_isar.dart';
import '../notification_service.dart';
import 'notification_validation_service.dart';
import 'scheduling_reliability_service.dart';

/// Service for rescheduling notifications after device reboot
///
/// This service:
/// - Queries active habits from Isar database
/// - Reschedules notifications for habits with notifications enabled
/// - Uses Isar habit data as source of truth (no separate notification storage)
/// - Implements retry logic and error aggregation for reliability
class NotificationBootRescheduler {
  NotificationBootRescheduler();

  /// Reschedule all pending notifications after device reboot
  ///
  /// This method queries all active habits from Isar and reschedules
  /// their notifications based on habit configuration.
  ///
  /// Uses retry logic for transient failures and aggregates errors
  /// for comprehensive reporting.
  Future<void> rescheduleAllNotifications() async {
    final failedHabits = <String, String>{}; // habitName -> error message
    final retriedHabits = <String>[]; // habits that succeeded after retry

    try {
      AppLogger.info(
          '🔄 Starting notification rescheduling after reboot (using Isar)');

      // Get Isar database instance
      final isar = await IsarDatabaseService.getInstance();
      final habitService = HabitServiceIsar(isar);

      // Get all active habits
      final habits = await habitService.getActiveHabits();
      AppLogger.info('📋 Found ${habits.length} active habits');

      if (habits.isEmpty) {
        AppLogger.info('No active habits to reschedule notifications for');
        return;
      }

      // Clear all existing scheduled notifications from the OS
      // This prevents duplicates and ensures a clean slate
      await AwesomeNotifications().cancelAll();
      AppLogger.info('🧹 Cleared all existing OS notifications');

      int notificationRescheduledCount = 0;
      int alarmOnlyRefreshedCount = 0;
      int skippedCount = 0;

      // Process each habit with retry logic
      for (final habit in habits) {
        // Skip habits with neither notifications nor alarms enabled
        if (!habit.notificationsEnabled && !habit.alarmEnabled) {
          skippedCount++;
          continue;
        }

        // Use retry with backoff for resilience
        final success = await SchedulingReliabilityService.retryWithBackoff(
          operation: () async {
            await NotificationService.scheduleHabitNotifications(habit);
          },
          operationName: 'boot_reschedule_${habit.name}',
          maxAttempts: 3,
        );

        if (success) {
          if (habit.notificationsEnabled) {
            notificationRescheduledCount++;
            AppLogger.debug('✅ Rescheduled notifications for: ${habit.name}');
          } else {
            alarmOnlyRefreshedCount++;
            AppLogger.debug(
                '✅ Refreshed alarms for alarm-only habit: ${habit.name}');
          }
        } else {
          failedHabits[habit.name] = 'Failed after 3 retry attempts';
          AppLogger.error(
              '❌ Failed to reschedule after retries: ${habit.name}');
        }
      }

      // Log comprehensive summary
      final errorCount = failedHabits.length;
      AppLogger.info(
        '✅ Notification rescheduling complete: '
        '$notificationRescheduledCount notifications rescheduled, '
        '$alarmOnlyRefreshedCount alarm-only habits refreshed, '
        '$skippedCount skipped, '
        '$errorCount errors',
      );

      // Log detailed error summary if any failures occurred
      if (failedHabits.isNotEmpty) {
        AppLogger.error(
          '⚠️ BOOT RESCHEDULE FAILURES:\n'
          '${failedHabits.entries.map((e) => '  - ${e.key}: ${e.value}').join('\n')}',
        );

        // Attempt self-healing for failed habits
        final habitsToHeal =
            habits.where((h) => failedHabits.containsKey(h.name)).toList();
        if (habitsToHeal.isNotEmpty) {
          AppLogger.info(
              '🔧 Attempting self-heal for ${habitsToHeal.length} failed habits...');

          // Wait a bit before retrying (system may be under load during boot)
          await Future.delayed(const Duration(seconds: 5));

          for (final habit in habitsToHeal) {
            try {
              await NotificationService.scheduleHabitNotifications(habit);
              retriedHabits.add(habit.name);
              failedHabits.remove(habit.name);
              AppLogger.info('✅ Self-heal succeeded for: ${habit.name}');
            } catch (e) {
              AppLogger.error('❌ Self-heal failed for: ${habit.name}', e);
            }
          }

          if (retriedHabits.isNotEmpty) {
            AppLogger.info(
                '🔧 Self-heal recovered ${retriedHabits.length} habits');
          }
        }
      }

      // Final audit to verify state
      final auditResults =
          await NotificationValidationService.auditHabits(habits);
      NotificationValidationService.logAuditDiscrepancies(
        habits: habits,
        results: auditResults,
        context: 'boot_reschedule',
      );

      // Log final status with any remaining failures
      if (failedHabits.isNotEmpty) {
        AppLogger.error(
          '⚠️ BOOT RESCHEDULE INCOMPLETE: ${failedHabits.length} habits still have no notifications. '
          'These habits may not trigger reminders until app is opened: '
          '${failedHabits.keys.join(", ")}',
        );
      }
    } catch (e) {
      AppLogger.error('❌ Critical error during notification rescheduling', e);
      // Don't rethrow - we want the app to continue even if boot reschedule fails
    }
  }

  /// Reschedule all habits after boot (alias for rescheduleAllNotifications)
  Future<void> rescheduleAllHabitsAfterBoot() async {
    await rescheduleAllNotifications();
  }

  /// Reschedule notifications for a specific habit with retry logic
  ///
  /// Useful when updating a single habit's notifications without
  /// touching other habits.
  Future<bool> rescheduleHabitNotifications(String habitId) async {
    try {
      AppLogger.info('🔄 Rescheduling notifications for habit: $habitId');

      // Get Isar database instance
      final isar = await IsarDatabaseService.getInstance();
      final habitService = HabitServiceIsar(isar);

      // Get the specific habit
      final habit = await habitService.getHabitById(habitId);

      if (habit == null) {
        AppLogger.info('Habit $habitId not found');
        return false;
      }

      if (!habit.notificationsEnabled && !habit.alarmEnabled) {
        AppLogger.info(
            'Neither notifications nor alarms enabled for habit: ${habit.name}');
        return true; // Not a failure, just nothing to do
      }

      // Use retry with backoff
      final success = await SchedulingReliabilityService.retryWithBackoff(
        operation: () async {
          await NotificationService.scheduleHabitNotifications(habit);
        },
        operationName: 'reschedule_single_${habit.name}',
      );

      if (success) {
        AppLogger.info('✅ Rescheduled notifications for habit: ${habit.name}');
      } else {
        AppLogger.error(
            '❌ Failed to reschedule notifications for habit: ${habit.name}');
      }

      return success;
    } catch (e) {
      AppLogger.error('Error rescheduling notifications for habit $habitId', e);
      return false;
    }
  }

  /// Get statistics about pending notifications
  ///
  /// Useful for debugging and monitoring notification state.
  Future<Map<String, int>> getNotificationStats() async {
    try {
      final pendingNotifications =
          await AwesomeNotifications().listScheduledNotifications();

      // Count notification types based on channel keys
      int alarms = 0;
      int regular = 0;

      for (final notification in pendingNotifications) {
        // Alarm notifications use the alarm channel
        if (notification.content?.channelKey == 'habit_alarm_default') {
          alarms++;
        } else {
          regular++;
        }
      }

      return {
        'total': pendingNotifications.length,
        'pending': pendingNotifications.length,
        'expired': 0, // No longer tracked separately
        'alarms': alarms,
        'regular': regular,
      };
    } catch (e) {
      AppLogger.error('Error getting notification stats', e);
      return {};
    }
  }
}
