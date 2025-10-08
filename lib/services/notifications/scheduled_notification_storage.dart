import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/model/scheduled_notification.dart';
import '../logging_service.dart';

/// Service for persisting scheduled notification data
/// This allows rescheduling notifications after device reboot
class ScheduledNotificationStorage {
  static const String _boxName = 'scheduled_notifications';
  static Box<ScheduledNotification>? _box;

  /// Initialize the storage
  static Future<void> initialize() async {
    try {
      if (_box != null && _box!.isOpen) {
        AppLogger.debug('ScheduledNotificationStorage already initialized');
        return;
      }

      // Register adapter if not already registered
      if (!Hive.isAdapterRegistered(3)) {
        Hive.registerAdapter(ScheduledNotificationAdapter());
      }

      _box = await Hive.openBox<ScheduledNotification>(_boxName);
      AppLogger.info(
          '✅ ScheduledNotificationStorage initialized with ${_box!.length} stored notifications');
    } catch (e) {
      AppLogger.error('Error initializing ScheduledNotificationStorage', e);
      rethrow;
    }
  }

  /// Save a scheduled notification
  static Future<void> saveNotification(
      ScheduledNotification notification) async {
    try {
      await _ensureInitialized();

      // Use notification ID as key for easy lookup and updates
      await _box!.put(notification.id, notification);

      AppLogger.debug('✅ Saved scheduled notification: $notification');
    } catch (e) {
      AppLogger.error('Error saving scheduled notification', e);
    }
  }

  /// Save multiple scheduled notifications
  static Future<void> saveNotifications(
      List<ScheduledNotification> notifications) async {
    try {
      await _ensureInitialized();

      final Map<int, ScheduledNotification> notificationMap = {
        for (var notification in notifications) notification.id: notification
      };

      await _box!.putAll(notificationMap);

      AppLogger.info('✅ Saved ${notifications.length} scheduled notifications');
    } catch (e) {
      AppLogger.error('Error saving multiple notifications', e);
    }
  }

  /// Get a scheduled notification by ID
  static Future<ScheduledNotification?> getNotification(int id) async {
    try {
      await _ensureInitialized();
      return _box!.get(id);
    } catch (e) {
      AppLogger.error('Error getting scheduled notification', e);
      return null;
    }
  }

  /// Get all scheduled notifications
  static Future<List<ScheduledNotification>> getAllNotifications() async {
    try {
      await _ensureInitialized();
      return _box!.values.toList();
    } catch (e) {
      AppLogger.error('Error getting all scheduled notifications', e);
      return [];
    }
  }

  /// Get all notifications for a specific habit
  static Future<List<ScheduledNotification>> getNotificationsByHabitId(
      String habitId) async {
    try {
      await _ensureInitialized();
      return _box!.values.where((n) => n.habitId == habitId).toList();
    } catch (e) {
      AppLogger.error('Error getting notifications for habit $habitId', e);
      return [];
    }
  }

  /// Get all future (pending) notifications
  static Future<List<ScheduledNotification>> getPendingNotifications() async {
    try {
      await _ensureInitialized();
      final now = DateTime.now();
      return _box!.values.where((n) => n.scheduledTime.isAfter(now)).toList();
    } catch (e) {
      AppLogger.error('Error getting pending notifications', e);
      return [];
    }
  }

  /// Delete a scheduled notification by ID
  static Future<void> deleteNotification(int id) async {
    try {
      await _ensureInitialized();
      await _box!.delete(id);
      AppLogger.debug('🗑️ Deleted scheduled notification: $id');
    } catch (e) {
      AppLogger.error('Error deleting scheduled notification', e);
    }
  }

  /// Delete all notifications for a specific habit
  static Future<void> deleteNotificationsByHabitId(String habitId) async {
    try {
      await _ensureInitialized();
      final keysToDelete = _box!.values
          .where((n) => n.habitId == habitId)
          .map((n) => n.id)
          .toList();

      await _box!.deleteAll(keysToDelete);
      AppLogger.info(
          '🗑️ Deleted ${keysToDelete.length} notifications for habit $habitId');
    } catch (e) {
      AppLogger.error('Error deleting notifications for habit', e);
    }
  }

  /// Clean up old notifications (past scheduled time by more than 24 hours)
  static Future<void> cleanupOldNotifications() async {
    try {
      await _ensureInitialized();
      final cutoffTime = DateTime.now().subtract(const Duration(hours: 24));
      final keysToDelete = _box!.values
          .where((n) => n.scheduledTime.isBefore(cutoffTime))
          .map((n) => n.id)
          .toList();

      if (keysToDelete.isNotEmpty) {
        await _box!.deleteAll(keysToDelete);
        AppLogger.info(
            '🧹 Cleaned up ${keysToDelete.length} old notifications');
      }
    } catch (e) {
      AppLogger.error('Error cleaning up old notifications', e);
    }
  }

  /// Clear all stored notifications
  static Future<void> clearAll() async {
    try {
      await _ensureInitialized();
      final count = _box!.length;
      await _box!.clear();
      AppLogger.info('🗑️ Cleared all $count scheduled notifications');
    } catch (e) {
      AppLogger.error('Error clearing all notifications', e);
    }
  }

  /// Get count of stored notifications
  static Future<int> getCount() async {
    try {
      await _ensureInitialized();
      return _box!.length;
    } catch (e) {
      AppLogger.error('Error getting notification count', e);
      return 0;
    }
  }

  /// Ensure the storage is initialized
  static Future<void> _ensureInitialized() async {
    if (_box == null || !_box!.isOpen) {
      await initialize();
    }
  }

  /// Close the storage
  static Future<void> close() async {
    try {
      if (_box != null && _box!.isOpen) {
        await _box!.close();
        _box = null;
        AppLogger.info('ScheduledNotificationStorage closed');
      }
    } catch (e) {
      AppLogger.error('Error closing ScheduledNotificationStorage', e);
    }
  }
}
