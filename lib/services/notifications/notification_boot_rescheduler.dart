import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../logging_service.dart';
import 'scheduled_notification_storage.dart';
import 'notification_scheduler.dart';

/// Service for rescheduling notifications after device reboot
///
/// This service:
/// - Loads persisted notification data from storage
/// - Filters out expired notifications
/// - Reschedules valid future notifications
/// - Cleans up old notification records
class NotificationBootRescheduler {
  final FlutterLocalNotificationsPlugin _plugin;
  final NotificationScheduler _scheduler;

  NotificationBootRescheduler(this._plugin)
      : _scheduler = NotificationScheduler(_plugin);

  /// Reschedule all pending notifications after device reboot
  ///
  /// This method should be called after a device reboot to restore
  /// all scheduled notifications that were lost during the reboot.
  Future<void> rescheduleAllNotifications() async {
    try {
      AppLogger.info('🔄 Starting notification rescheduling after reboot');

      // Initialize storage if needed
      await ScheduledNotificationStorage.initialize();

      // Get all stored notifications
      final allNotifications =
          await ScheduledNotificationStorage.getAllNotifications();
      AppLogger.info(
          '📋 Found ${allNotifications.length} stored notifications');

      if (allNotifications.isEmpty) {
        AppLogger.info('No stored notifications to reschedule');
        return;
      }

      // Clear all existing scheduled notifications from the OS
      // This prevents duplicates and ensures a clean slate
      await _plugin.cancelAll();
      AppLogger.info('🧹 Cleared all existing OS notifications');

      final now = DateTime.now();
      int rescheduledCount = 0;
      int expiredCount = 0;
      int errorCount = 0;

      // Process each stored notification
      for (final notification in allNotifications) {
        try {
          // Check if notification is still in the future
          if (notification.scheduledTime.isAfter(now)) {
            // Reschedule the notification
            await _scheduler.scheduleHabitNotification(
              id: notification.id,
              habitId: notification.habitId,
              title: notification.title,
              body: notification.body,
              scheduledTime: notification.scheduledTime,
            );

            rescheduledCount++;
            AppLogger.debug(
              '✅ Rescheduled notification ${notification.id} for ${notification.scheduledTime}',
            );
          } else {
            // Notification is in the past, clean it up
            await ScheduledNotificationStorage.deleteNotification(
                notification.id);
            expiredCount++;
            AppLogger.debug(
              '🗑️ Deleted expired notification ${notification.id}',
            );
          }
        } catch (e) {
          errorCount++;
          AppLogger.error(
            'Error rescheduling notification ${notification.id}',
            e,
          );
        }
      }

      // Cleanup old notifications (more than 24 hours past)
      await ScheduledNotificationStorage.cleanupOldNotifications();

      AppLogger.info(
        '✅ Notification rescheduling complete: '
        '$rescheduledCount rescheduled, '
        '$expiredCount expired, '
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

      await ScheduledNotificationStorage.initialize();

      final notifications =
          await ScheduledNotificationStorage.getNotificationsByHabitId(habitId);

      if (notifications.isEmpty) {
        AppLogger.info('No stored notifications for habit $habitId');
        return;
      }

      final now = DateTime.now();
      int rescheduledCount = 0;
      int expiredCount = 0;

      for (final notification in notifications) {
        if (notification.scheduledTime.isAfter(now)) {
          await _scheduler.scheduleHabitNotification(
            id: notification.id,
            habitId: notification.habitId,
            title: notification.title,
            body: notification.body,
            scheduledTime: notification.scheduledTime,
          );
          rescheduledCount++;
        } else {
          await ScheduledNotificationStorage.deleteNotification(
              notification.id);
          expiredCount++;
        }
      }

      AppLogger.info(
        '✅ Rescheduled $rescheduledCount notifications for habit $habitId '
        '($expiredCount expired)',
      );
    } catch (e) {
      AppLogger.error(
        'Error rescheduling notifications for habit $habitId',
        e,
      );
    }
  }

  /// Get statistics about stored notifications
  ///
  /// Useful for debugging and monitoring notification state.
  Future<Map<String, int>> getNotificationStats() async {
    try {
      await ScheduledNotificationStorage.initialize();

      final allNotifications =
          await ScheduledNotificationStorage.getAllNotifications();
      final now = DateTime.now();

      final pending =
          allNotifications.where((n) => n.scheduledTime.isAfter(now)).length;
      final expired =
          allNotifications.where((n) => n.scheduledTime.isBefore(now)).length;
      final alarms = allNotifications.where((n) => n.isAlarm).length;
      final regular = allNotifications.where((n) => !n.isAlarm).length;

      return {
        'total': allNotifications.length,
        'pending': pending,
        'expired': expired,
        'alarms': alarms,
        'regular': regular,
      };
    } catch (e) {
      AppLogger.error('Error getting notification stats', e);
      return {};
    }
  }
}
