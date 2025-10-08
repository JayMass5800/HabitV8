import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../logging_service.dart';
import '../../data/database_isar.dart';
import '../notification_service.dart';

/// Service for rescheduling notifications after device reboot
///
/// This service:
/// - Queries active habits from Isar database
/// - Reschedules notifications for habits with notifications enabled
/// - Uses Isar habit data as source of truth (no separate notification storage)
class NotificationBootRescheduler {
  final FlutterLocalNotificationsPlugin _plugin;

  NotificationBootRescheduler(this._plugin);

  /// Reschedule all pending notifications after device reboot
  ///
  /// This method queries all active habits from Isar and reschedules
  /// their notifications based on habit configuration.
  Future<void> rescheduleAllNotifications() async {
    try {
      AppLogger.info('🔄 Starting notification rescheduling after reboot (using Isar)');

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
      await _plugin.cancelAll();
      AppLogger.info('🧹 Cleared all existing OS notifications');

      int rescheduledCount = 0;
      int skippedCount = 0;
      int errorCount = 0;

      // Process each habit
      for (final habit in habits) {
        try {
          // Only reschedule if notifications are enabled
          if (habit.notificationsEnabled) {
            // Use NotificationService to reschedule properly
            // This handles all frequency types (daily, weekly, RRule, etc.)
            await NotificationService.scheduleHabitNotifications(habit);
            rescheduledCount++;
            AppLogger.debug('✅ Rescheduled notifications for: ${habit.name}');
          } else {
            skippedCount++;
          }
        } catch (e) {
          errorCount++;
          AppLogger.error('Error rescheduling notifications for habit ${habit.name}', e);
        }
      }

      AppLogger.info(
        '✅ Notification rescheduling complete: '
        '$rescheduledCount rescheduled, '
        '$skippedCount skipped, '
        '$errorCount errors',
      );
    } catch (e) {
      AppLogger.error('❌ Error during notification rescheduling', e);
    }
  }

  /// Reschedule notifications for a specific habit
  ///
  /// Useful when updating a single habit's notifications without
  /// touching other habits.
  Future<void> rescheduleHabitNotifications(String habitId) async {
    try {
      AppLogger.info('🔄 Rescheduling notifications for habit: $habitId');

      // Get Isar database instance
      final isar = await IsarDatabaseService.getInstance();
      final habitService = HabitServiceIsar(isar);

      // Get the specific habit
      final habit = await habitService.getHabitById(habitId);

      if (habit == null) {
        AppLogger.info('Habit $habitId not found');
        return;
      }

      if (habit.notificationsEnabled) {
        await NotificationService.scheduleHabitNotifications(habit);
        AppLogger.info('✅ Rescheduled notifications for habit: ${habit.name}');
      } else {
        AppLogger.info('Notifications disabled for habit: ${habit.name}');
      }
    } catch (e) {
      AppLogger.error('Error rescheduling notifications for habit $habitId', e);
    }
  }

  /// Get statistics about pending notifications
  ///
  /// Useful for debugging and monitoring notification state.
  Future<Map<String, int>> getNotificationStats() async {
    try {
      final pendingNotifications = await _plugin.pendingNotificationRequests();
      
      // Count notification types based on ID patterns
      int alarms = 0;
      int regular = 0;
      
      for (final notification in pendingNotifications) {
        // Alarm notifications typically have different ID patterns
        // This is a simple heuristic - adjust based on your ID generation logic
        if (notification.payload?.contains('"isAlarm":true') ?? false) {
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
