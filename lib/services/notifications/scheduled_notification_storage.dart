import 'package:isar/isar.dart';
import '../../domain/model/scheduled_notification.dart';
import '../../data/database_isar.dart';
import '../logging_service.dart';

/// Service for persisting scheduled notification data using Isar
/// This allows rescheduling notifications after device reboot
class ScheduledNotificationStorage {
  /// Save a scheduled notification
  static Future<void> saveNotification(
      ScheduledNotification notification) async {
    try {
      final isar = await IsarDatabase.instance;

      await isar.writeTxn(() async {
        await isar.scheduledNotifications.put(notification);
      });

      AppLogger.debug('✅ Saved scheduled notification: $notification');
    } catch (e) {
      AppLogger.error('Error saving scheduled notification', e);
    }
  }

  /// Save multiple scheduled notifications
  static Future<void> saveNotifications(
      List<ScheduledNotification> notifications) async {
    try {
      final isar = await IsarDatabase.instance;

      await isar.writeTxn(() async {
        await isar.scheduledNotifications.putAll(notifications);
      });

      AppLogger.info('✅ Saved ${notifications.length} scheduled notifications');
    } catch (e) {
      AppLogger.error('Error saving multiple notifications', e);
    }
  }

  /// Get a scheduled notification by notification ID
  static Future<ScheduledNotification?> getNotification(
      int notificationId) async {
    try {
      final isar = await IsarDatabase.instance;

      return await isar.scheduledNotifications
          .filter()
          .notificationIdEqualTo(notificationId)
          .findFirst();
    } catch (e) {
      AppLogger.error('Error getting scheduled notification', e);
      return null;
    }
  }

  /// Get all scheduled notifications
  static Future<List<ScheduledNotification>> getAllNotifications() async {
    try {
      final isar = await IsarDatabase.instance;
      return await isar.scheduledNotifications.where().findAll();
    } catch (e) {
      AppLogger.error('Error getting all scheduled notifications', e);
      return [];
    }
  }

  /// Get all notifications for a specific habit
  static Future<List<ScheduledNotification>> getNotificationsByHabitId(
      String habitId) async {
    try {
      final isar = await IsarDatabase.instance;

      return await isar.scheduledNotifications
          .filter()
          .habitIdEqualTo(habitId)
          .findAll();
    } catch (e) {
      AppLogger.error('Error getting notifications for habit $habitId', e);
      return [];
    }
  }

  /// Get all future (pending) notifications
  static Future<List<ScheduledNotification>> getPendingNotifications() async {
    try {
      final isar = await IsarDatabase.instance;
      final now = DateTime.now().millisecondsSinceEpoch;

      return await isar.scheduledNotifications
          .filter()
          .scheduledTimeMillisGreaterThan(now)
          .findAll();
    } catch (e) {
      AppLogger.error('Error getting pending notifications', e);
      return [];
    }
  }

  /// Delete a scheduled notification by notification ID
  static Future<void> deleteNotification(int notificationId) async {
    try {
      final isar = await IsarDatabase.instance;

      await isar.writeTxn(() async {
        final notification = await isar.scheduledNotifications
            .filter()
            .notificationIdEqualTo(notificationId)
            .findFirst();

        if (notification != null) {
          await isar.scheduledNotifications.delete(notification.id);
          AppLogger.debug(
              '🗑️ Deleted scheduled notification: $notificationId');
        }
      });
    } catch (e) {
      AppLogger.error('Error deleting scheduled notification', e);
    }
  }

  /// Delete all notifications for a specific habit
  static Future<void> deleteNotificationsByHabitId(String habitId) async {
    try {
      final isar = await IsarDatabase.instance;

      await isar.writeTxn(() async {
        final notifications = await isar.scheduledNotifications
            .filter()
            .habitIdEqualTo(habitId)
            .findAll();

        final ids = notifications.map((n) => n.id).toList();
        final count = await isar.scheduledNotifications.deleteAll(ids);

        AppLogger.info('🗑️ Deleted $count notifications for habit $habitId');
      });
    } catch (e) {
      AppLogger.error('Error deleting notifications for habit', e);
    }
  }

  /// Clean up old notifications (past scheduled time by more than 24 hours)
  static Future<void> cleanupOldNotifications() async {
    try {
      final isar = await IsarDatabase.instance;
      final cutoffTime = DateTime.now()
          .subtract(const Duration(hours: 24))
          .millisecondsSinceEpoch;

      await isar.writeTxn(() async {
        final oldNotifications = await isar.scheduledNotifications
            .filter()
            .scheduledTimeMillisLessThan(cutoffTime)
            .findAll();

        final ids = oldNotifications.map((n) => n.id).toList();

        if (ids.isNotEmpty) {
          final count = await isar.scheduledNotifications.deleteAll(ids);
          AppLogger.info('🧹 Cleaned up $count old notifications');
        }
      });
    } catch (e) {
      AppLogger.error('Error cleaning up old notifications', e);
    }
  }

  /// Clear all stored notifications
  static Future<void> clearAll() async {
    try {
      final isar = await IsarDatabase.instance;

      await isar.writeTxn(() async {
        final count = await isar.scheduledNotifications.count();
        await isar.scheduledNotifications.clear();
        AppLogger.info('🗑️ Cleared all $count scheduled notifications');
      });
    } catch (e) {
      AppLogger.error('Error clearing all notifications', e);
    }
  }

  /// Get count of stored notifications
  static Future<int> getCount() async {
    try {
      final isar = await IsarDatabase.instance;
      return await isar.scheduledNotifications.count();
    } catch (e) {
      AppLogger.error('Error getting notification count', e);
      return 0;
    }
  }
}
