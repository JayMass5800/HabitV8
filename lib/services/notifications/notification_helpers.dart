import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../logging_service.dart';
import '../../domain/model/habit.dart';
import 'notification_core.dart';

/// Utility functions for notification management
///
/// This module provides:
/// - ID generation and management
/// - Payload parsing and validation
/// - Habit completion checking logic
/// - Streak calculation
/// - Notification verification
/// - Periodic cleanup scheduling
class NotificationHelpers {
  // Private constructor to prevent instantiation
  NotificationHelpers._();

  // ==================== ID GENERATION ====================

  /// Generate a safe, collision-resistant notification ID from a string
  ///
  /// Uses a custom hash function optimized for Android's notification ID range.
  /// Returns IDs in the range 1-16,777,215 to prevent integer overflow issues.
  ///
  /// Example:
  /// ```dart
  /// final id = NotificationHelpers.generateSafeId('habit_123');
  /// ```
  static int generateSafeId(String input) {
    // Generate a much smaller base hash to leave room for multiplications and additions
    int hash = 0;
    for (int i = 0; i < input.length; i++) {
      hash = ((hash << 3) - hash + input.codeUnitAt(i)) &
          0xFFFFFF; // Use 24 bits max
    }
    // Ensure we have a reasonable range for the base ID (1-16777215)
    return (hash % 16777215) + 1;
  }

  /// Generate a unique notification ID for snooze notifications
  ///
  /// Combines habit ID hash with timestamp and fixed offset to ensure:
  /// - Uniqueness even for multiple snoozes of the same habit
  /// - Clear separation from regular notifications
  /// - Predictable cleanup of snooze notifications
  ///
  /// Returns ID in range: 2,000,000 - 2,900,999
  static int generateSnoozeNotificationId(String habitId) {
    // Enhanced approach - use habitId hash + current timestamp + fixed offset for snooze
    // This makes snooze notifications truly unique and prevents conflicts
    final baseId = habitId.hashCode.abs();
    final timestamp = DateTime.now().millisecondsSinceEpoch %
        1000; // Last 3 digits of timestamp
    final snoozeOffset = 2000000; // Fixed offset for snooze notifications

    // Combine base ID with timestamp to ensure uniqueness even for same habit
    final snoozeId = (baseId % 900000) + snoozeOffset + timestamp;

    AppLogger.debug(
      'Generated snooze notification ID: $snoozeId for habit: $habitId (base: $baseId, timestamp: $timestamp)',
    );
    return snoozeId;
  }

  // ==================== PAYLOAD PARSING ====================

  /// Extract habit ID from notification payload
  ///
  /// Handles both standard and hourly habit payload formats:
  /// - Standard: {"habitId": "abc123"}
  /// - Hourly: {"habitId": "abc123|14:30"}
  ///
  /// Returns null if payload is invalid or habitId is missing.
  static String? extractHabitIdFromPayload(String? payload) {
    if (payload == null || payload.isEmpty) {
      return null;
    }

    try {
      final Map<String, dynamic> data = jsonDecode(payload);
      final String? rawHabitId = data['habitId'];

      if (rawHabitId == null) {
        return null;
      }

      // Handle hourly habit format (id|time)
      if (rawHabitId.contains('|')) {
        return rawHabitId.split('|').first;
      }

      return rawHabitId;
    } catch (e) {
      AppLogger.error('Failed to parse habit ID from payload', e);
      return null;
    }
  }

  /// Extract time slot from hourly habit payload
  ///
  /// For hourly habits with payload format: {"habitId": "abc123|14:30"}
  /// Returns a map with 'hour' and 'minute' keys, or null if not an hourly habit
  /// or if the time format is invalid.
  ///
  /// Example:
  /// ```dart
  /// final timeSlot = extractTimeSlotFromPayload(payload);
  /// if (timeSlot != null) {
  ///   print('Hour: ${timeSlot['hour']}, Minute: ${timeSlot['minute']}');
  /// }
  /// ```
  static Map<String, int>? extractTimeSlotFromPayload(String? payload) {
    if (payload == null || payload.isEmpty) {
      return null;
    }

    try {
      final Map<String, dynamic> data = jsonDecode(payload);
      final String? rawHabitId = data['habitId'];

      if (rawHabitId == null || !rawHabitId.contains('|')) {
        return null; // Not an hourly habit
      }

      // Extract time part (format: "id|HH:MM")
      final parts = rawHabitId.split('|');
      if (parts.length != 2) {
        return null;
      }

      final timeStr = parts[1];
      final timeParts = timeStr.split(':');
      if (timeParts.length != 2) {
        return null;
      }

      final hour = int.tryParse(timeParts[0]);
      final minute = int.tryParse(timeParts[1]);

      if (hour == null ||
          minute == null ||
          hour < 0 ||
          hour > 23 ||
          minute < 0 ||
          minute > 59) {
        return null;
      }

      return {'hour': hour, 'minute': minute};
    } catch (e) {
      AppLogger.error('Failed to parse time slot from payload', e);
      return null;
    }
  }

  // ==================== HABIT COMPLETION CHECKING ====================

  /// Check if a habit has been completed for its current period
  ///
  /// Determines completion based on habit frequency:
  /// - Daily: Completed today
  /// - Weekly: Completed this week
  /// - Monthly: Completed this month
  /// - Yearly: Completed this year
  /// - Single: Completed at least once
  /// - Hourly: Completed in the current hour
  ///
  /// Used to prevent duplicate notifications and update streak counts.
  static bool isHabitCompletedForPeriod(Habit habit, DateTime checkTime) {
    final completions = habit.completions;
    if (completions.isEmpty) return false;

    final now = checkTime;

    switch (habit.frequency) {
      case HabitFrequency.daily:
        // Check if completed today
        return completions.any(
          (completion) =>
              completion.year == now.year &&
              completion.month == now.month &&
              completion.day == now.day,
        );

      case HabitFrequency.weekly:
        // Check if completed this week
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        return completions.any(
          (completion) =>
              completion.isAfter(weekStart.subtract(const Duration(days: 1))),
        );

      case HabitFrequency.monthly:
        // Check if completed this month
        return completions.any(
          (completion) =>
              completion.year == now.year && completion.month == now.month,
        );

      case HabitFrequency.yearly:
        // Check if completed this year
        return completions.any((completion) => completion.year == now.year);

      case HabitFrequency.single:
        // Single habits can only be completed once
        return completions.isNotEmpty;

      case HabitFrequency.hourly:
        // For hourly habits, check if completed in the current hour
        return completions.any(
          (completion) =>
              completion.year == now.year &&
              completion.month == now.month &&
              completion.day == now.day &&
              completion.hour == now.hour,
        );
    }
  }

  // ==================== STREAK CALCULATION ====================

  /// Calculate current streak from completion timestamps
  ///
  /// For daily habits: Counts consecutive days with completions
  /// For other frequencies: Returns total completion count
  ///
  /// Returns 0 if no completions exist.
  static int calculateStreak(
    List<DateTime> completions,
    HabitFrequency frequency,
  ) {
    if (completions.isEmpty) return 0;

    // Sort completions in descending order (most recent first)
    final sortedCompletions = List<DateTime>.from(completions)
      ..sort((a, b) => b.compareTo(a));

    int streak = 0;
    final now = DateTime.now();

    switch (frequency) {
      case HabitFrequency.daily:
        DateTime checkDate = DateTime(now.year, now.month, now.day);
        for (final completion in sortedCompletions) {
          final completionDate =
              DateTime(completion.year, completion.month, completion.day);
          if (completionDate.isAtSameMomentAs(checkDate) ||
              completionDate.isAtSameMomentAs(
                checkDate.subtract(const Duration(days: 1)),
              )) {
            streak++;
            checkDate = checkDate.subtract(const Duration(days: 1));
          } else {
            break;
          }
        }
        break;

      default:
        // For other frequencies, just count completions
        streak = completions.length;
    }

    return streak;
  }

  // ==================== NOTIFICATION VERIFICATION ====================

  /// Verify that a notification was actually scheduled
  ///
  /// Queries the system for pending notifications and confirms the specified
  /// notification ID exists. Useful for debugging scheduling issues.
  ///
  /// Logs verification results without throwing exceptions.
  static Future<bool> verifyNotificationScheduled(
    int notificationId,
    String habitId,
  ) async {
    try {
      final pendingNotifications =
          await AwesomeNotifications().listScheduledNotifications();
      final isScheduled =
          pendingNotifications.any((n) => n.content?.id == notificationId);

      if (isScheduled) {
        AppLogger.info(
          '✅ Verified: Notification $notificationId is properly scheduled for habit: $habitId',
        );
      } else {
        AppLogger.warning(
          '⚠️ Warning: Notification $notificationId may not be properly scheduled for habit: $habitId',
        );
      }

      return isScheduled;
    } catch (e) {
      AppLogger.error('Error verifying notification scheduling', e);
      return false;
    }
  }

  // ==================== CAPABILITY CHECKS ====================

  /// Check if exact alarms can be scheduled on this device
  ///
  /// Delegates to NotificationCore for platform-specific permission checks.
  /// Required for precise notification timing on Android 12+.
  static Future<bool> canScheduleExactAlarms() async {
    try {
      return await NotificationCore.canScheduleExactAlarms();
    } catch (e) {
      AppLogger.error('Error checking exact alarm capability', e);
      return false;
    }
  }

  /// Check and log battery optimization status
  ///
  /// Delegates to NotificationCore for platform-specific checks.
  /// Provides guidance to users if battery optimization may affect notifications.
  static Future<void> checkBatteryOptimizationStatus() async {
    try {
      await NotificationCore.checkBatteryOptimizationStatus();
    } catch (e) {
      AppLogger.error('Error checking battery optimization status', e);
    }
  }

  // ==================== MAINTENANCE ====================

  /// Start periodic cleanup of expired notifications
  ///
  /// Placeholder for future implementation of notification cleanup logic.
  /// Will prevent buildup of stale notifications in the system tray.
  static void startPeriodicCleanup() {
    // TODO: Implement periodic cleanup logic
    // - Remove expired notifications
    // - Clean up completed habit notifications
    // - Remove orphaned snooze notifications
    AppLogger.debug('Periodic cleanup started');
  }

  // ==================== QUERY METHODS ====================

  /// Get all pending notification requests
  ///
  /// Returns a list of all notifications currently scheduled in the system.
  /// Useful for debugging and notification management.
  static Future<List<NotificationModel>> getPendingNotifications() async {
    try {
      return await AwesomeNotifications().listScheduledNotifications();
    } catch (e) {
      AppLogger.error('Error getting pending notifications', e);
      return [];
    }
  }

  /// Check if exact alarms can be scheduled (Android 12+)
  static Future<bool> canScheduleExactAlarmsInternal() async {
    try {
      // awesome_notifications handles this internally
      return true;
    } catch (e) {
      AppLogger.error('Error checking exact alarm capability', e);
      return false;
    }
  }

  /// Check battery optimization status
  static Future<void> checkBatteryOptimizationStatusInternal() async {
    try {
      // awesome_notifications handles this internally
      AppLogger.info(
          'Battery optimization check delegated to awesome_notifications');
    } catch (e) {
      AppLogger.error('Error checking battery optimization status', e);
    }
  }
}
