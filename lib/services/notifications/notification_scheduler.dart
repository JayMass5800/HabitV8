import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../logging_service.dart';
import '../rrule_service.dart';
import '../../domain/model/habit.dart';
import 'notification_core.dart';
import 'notification_helpers.dart';

/// Notification scheduling functionality
///
/// This module handles:
/// - Time-based notification scheduling
/// - Frequency-specific scheduling (daily, weekly, monthly, yearly, hourly, single)
/// - Notification cancellation
/// - Schedule validation and timezone handling
class NotificationScheduler {
  /// Create a notification scheduler
  NotificationScheduler();

  // ==================== CORE SCHEDULING METHODS ====================

  /// Schedule a habit notification with action buttons
  ///
  /// This is the core scheduling method used by all frequency-specific schedulers.
  /// Handles timezone conversion, permission checks, and validation.
  Future<void> scheduleHabitNotification({
    required int id,
    required String habitId,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    // Check and request all notification permissions if needed
    final bool permissionsGranted =
        await NotificationCore.ensureNotificationPermissions();
    if (!permissionsGranted) {
      AppLogger.warning(
        'Cannot schedule notification - permissions not granted',
      );
      return; // Don't schedule if permissions are denied
    }

    final deviceNow = DateTime.now();
    final localScheduledTime = scheduledTime.toLocal();

    // Enhanced time validation and timezone handling
    final timeDiff = localScheduledTime.difference(deviceNow);
    AppLogger.debug('Device current time: $deviceNow');
    AppLogger.debug('Target scheduled time: $localScheduledTime');
    AppLogger.debug(
      'Time until notification: ${timeDiff.inSeconds} seconds (${timeDiff.inMinutes} minutes)',
    );

    // Validate scheduling time is reasonable
    if (timeDiff.inSeconds < 0) {
      AppLogger.warning(
        '⚠️ Warning: Scheduling time is in the past! Adjusting to 1 minute from now.',
      );
      final adjustedTime = deviceNow.add(const Duration(minutes: 1));
      return await scheduleHabitNotification(
        id: id,
        habitId: habitId,
        title: title,
        body: body,
        scheduledTime: adjustedTime,
      );
    }

    if (timeDiff.inDays > 1) {
      AppLogger.warning(
        '⚠️ Warning: Scheduling time is more than 1 day in the future (${timeDiff.inDays} days)',
      );
    }

    final payload = jsonEncode({'habitId': habitId, 'type': 'habit_reminder'});

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'habit_scheduled_channel',
        title: title,
        body: body,
        payload: {'data': payload},
        notificationLayout: NotificationLayout.Default,
        wakeUpScreen: true,
        category: NotificationCategory.Reminder,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'complete',
          label: 'COMPLETE',
          actionType: ActionType.SilentBackgroundAction,
          autoDismissible: true,
        ),
        NotificationActionButton(
          key: 'snooze',
          label: 'SNOOZE 30MIN',
          actionType: ActionType.SilentBackgroundAction,
          autoDismissible: true,
        ),
      ],
      schedule: NotificationCalendar.fromDate(date: localScheduledTime),
    );

    // Note: Notification persistence removed - now using Isar habit data for rescheduling
    // Boot rescheduling queries habits directly from Isar database

    AppLogger.info(
      '✅ Scheduled notification ID $id for habit $habitId at $localScheduledTime',
    );
  }

  /// Show an immediate notification
  ///
  /// Displays a notification now without scheduling.
  /// Useful for testing and instant alerts.
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'habit_channel',
        title: title,
        body: body,
        payload: payload != null ? {'data': payload} : null,
        notificationLayout: NotificationLayout.Default,
        wakeUpScreen: true,
        category: NotificationCategory.Reminder,
      ),
    );

    AppLogger.info('📢 Showed immediate notification: $title');
  }

  // ==================== HABIT-BASED SCHEDULING ====================

  /// Schedule notifications for a habit based on its frequency and settings
  ///
  /// Main entry point for habit notification scheduling.
  /// Routes to appropriate frequency-specific scheduler.
  ///
  /// [isNewHabit] - Set to true when creating a new habit to skip unnecessary
  /// notification cancellation (new habits can't have existing notifications).
  /// Defaults to false for safety (assumes editing existing habit).
  Future<void> scheduleHabitNotifications(
    Habit habit, {
    bool isNewHabit = false,
  }) async {
    AppLogger.debug(
      'Starting notification scheduling for habit: ${habit.name} (isNewHabit: $isNewHabit)',
    );
    AppLogger.debug('Notifications enabled: ${habit.notificationsEnabled}');

    // Skip if notifications are disabled
    if (!habit.notificationsEnabled) {
      AppLogger.debug('Skipping notifications - disabled');
      AppLogger.info('Notifications disabled for habit: ${habit.name}');
      return;
    }

    // Skip hourly habits if alarms are enabled - the alarm system will handle them
    // This prevents double notifications for hourly habits
    if (habit.frequency == HabitFrequency.hourly && habit.alarmEnabled) {
      AppLogger.debug(
        'Skipping regular notifications for hourly habit - alarm system will handle it',
      );
      AppLogger.info(
        'Hourly habit ${habit.name} will use alarm system instead of regular notifications',
      );
      return;
    }

    // Check and request all notification permissions if needed
    try {
      final bool permissionsGranted =
          await NotificationCore.ensureNotificationPermissions();
      if (!permissionsGranted) {
        AppLogger.warning(
          'Cannot schedule notifications for habit: ${habit.name} - permissions not granted',
        );
        throw Exception('Notification permissions not granted');
      }
    } catch (e) {
      AppLogger.error(
        'Error checking notification permissions for habit: ${habit.name}',
        e,
      );
      throw Exception('Failed to verify notification permissions: $e');
    }

    // For non-hourly, non-single habits, require notification time
    if (habit.frequency != HabitFrequency.hourly &&
        habit.frequency != HabitFrequency.single &&
        habit.notificationTime == null) {
      AppLogger.debug(
        'Skipping notifications - no time set for non-hourly habit',
      );
      AppLogger.info('No notification time set for habit: ${habit.name}');
      return;
    }

    final notificationTime = habit.notificationTime;
    int hour = 9; // Default hour for hourly habits
    int minute = 0; // Default minute for hourly habits

    if (notificationTime != null) {
      hour = notificationTime.hour;
      minute = notificationTime.minute;
      AppLogger.debug('Scheduling for $hour:$minute');
    } else {
      AppLogger.debug('Using default time for hourly habit');
    }

    try {
      // Only cancel existing notifications if this is an existing habit being updated
      // New habits can't have notifications yet, so skip the expensive scan
      if (!isNewHabit) {
        await cancelHabitNotifications(
          NotificationHelpers.generateSafeId(habit.id),
        );
        AppLogger.debug(
          'Cancelled existing notifications for habit ID: ${habit.id}',
        );
      } else {
        AppLogger.debug(
          'Skipping notification cancellation - new habit with no existing notifications',
        );
      }

      // Use RRule-based scheduling if habit uses RRule
      if (habit.usesRRule && habit.rruleString != null) {
        AppLogger.debug('Scheduling RRule-based notifications');
        await _scheduleRRuleHabitNotifications(habit, hour, minute);
      } else {
        // Legacy frequency-specific scheduler
        switch (habit.frequency) {
          case HabitFrequency.daily:
            AppLogger.debug('Scheduling daily notifications');
            await _scheduleDailyHabitNotifications(habit, hour, minute);
            break;

          case HabitFrequency.weekly:
            AppLogger.debug('Scheduling weekly notifications');
            await _scheduleWeeklyHabitNotifications(habit, hour, minute);
            break;

          case HabitFrequency.monthly:
            AppLogger.debug('Scheduling monthly notifications');
            await _scheduleMonthlyHabitNotifications(habit, hour, minute);
            break;

          case HabitFrequency.yearly:
            AppLogger.debug('Scheduling yearly notifications');
            await _scheduleYearlyHabitNotifications(habit, hour, minute);
            break;

          case HabitFrequency.single:
            AppLogger.debug('Scheduling single habit notification');
            await _scheduleSingleHabitNotifications(habit);
            break;

          case HabitFrequency.hourly:
            AppLogger.debug('Scheduling hourly notifications');
            await _scheduleHourlyHabitNotifications(habit, hour, minute);
            break;
        }
      }

      AppLogger.info(
        '✅ Successfully scheduled notifications for habit: ${habit.name}',
      );
    } catch (e) {
      AppLogger.error(
        'Failed to schedule notifications for habit: ${habit.name}',
        e,
      );
      rethrow;
    }
  }

  // ==================== FREQUENCY-SPECIFIC SCHEDULERS ====================

  /// Schedule daily habit notifications
  Future<void> _scheduleDailyHabitNotifications(
    Habit habit,
    int hour,
    int minute,
  ) async {
    final now = DateTime.now();
    DateTime nextNotification = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the time has passed today, schedule for tomorrow
    if (nextNotification.isBefore(now)) {
      nextNotification = nextNotification.add(const Duration(days: 1));
    }

    // Validate habit ID before scheduling
    if (habit.id.isEmpty) {
      AppLogger.error(
          'Cannot schedule notification: habit ID is empty for ${habit.name}');
      return;
    }

    AppLogger.debug(
        'Scheduling daily notification with habit ID: "${habit.id}"');

    try {
      await scheduleHabitNotification(
        id: NotificationHelpers.generateSafeId(habit.id),
        habitId: habit.id,
        title: '🎯 ${habit.name}',
        body: 'Time to complete your daily habit! Keep your streak going.',
        scheduledTime: nextNotification,
      );
      AppLogger.debug(
        'Daily notification scheduled for ${habit.name} at $nextNotification',
      );
    } catch (e) {
      AppLogger.error('Failed to schedule daily notification', e);
      rethrow;
    }
  }

  /// Schedule weekly habit notifications
  Future<void> _scheduleWeeklyHabitNotifications(
    Habit habit,
    int hour,
    int minute,
  ) async {
    final now = DateTime.now();
    final selectedWeekdays = habit.selectedWeekdays;

    if (selectedWeekdays.isEmpty) {
      AppLogger.warning('No weekdays selected for weekly habit: ${habit.name}');
      return;
    }

    // Find the next occurrence for each selected weekday
    for (final weekday in selectedWeekdays) {
      DateTime nextNotification = _getNextWeekday(now, weekday, hour, minute);

      await scheduleHabitNotification(
        id: NotificationHelpers.generateSafeId('${habit.id}_$weekday'),
        habitId: habit.id,
        title: '🎯 ${habit.name}',
        body: 'Time to complete your weekly habit!',
        scheduledTime: nextNotification,
      );
    }

    AppLogger.debug(
      'Weekly notifications scheduled for ${habit.name} on ${selectedWeekdays.length} days',
    );
  }

  /// Schedule monthly habit notifications
  Future<void> _scheduleMonthlyHabitNotifications(
    Habit habit,
    int hour,
    int minute,
  ) async {
    final now = DateTime.now();
    final selectedMonthDays = habit.selectedMonthDays;

    if (selectedMonthDays.isEmpty) {
      AppLogger.warning(
          'No month days selected for monthly habit: ${habit.name}');
      return;
    }

    // Schedule for the next occurrence of each selected day
    for (final day in selectedMonthDays) {
      DateTime nextNotification = _getNextMonthDay(now, day, hour, minute);

      await scheduleHabitNotification(
        id: NotificationHelpers.generateSafeId('${habit.id}_$day'),
        habitId: habit.id,
        title: '🎯 ${habit.name}',
        body: 'Time to complete your monthly habit!',
        scheduledTime: nextNotification,
      );
    }

    AppLogger.debug(
      'Monthly notifications scheduled for ${habit.name} on ${selectedMonthDays.length} days',
    );
  }

  /// Schedule yearly habit notifications
  Future<void> _scheduleYearlyHabitNotifications(
    Habit habit,
    int hour,
    int minute,
  ) async {
    final selectedYearlyDates = habit.selectedYearlyDates;

    if (selectedYearlyDates.isEmpty) {
      AppLogger.warning(
          'No yearly dates selected for yearly habit: ${habit.name}');
      return;
    }

    final now = DateTime.now();

    for (final dateStr in selectedYearlyDates) {
      // Parse date string (format: "MM-DD")
      final parts = dateStr.split('-');
      if (parts.length != 2) continue;

      final month = int.tryParse(parts[0]);
      final day = int.tryParse(parts[1]);
      if (month == null || day == null) continue;

      DateTime nextNotification = DateTime(
        now.year,
        month,
        day,
        hour,
        minute,
      );

      // If the date has passed this year, schedule for next year
      if (nextNotification.isBefore(now)) {
        nextNotification = DateTime(
          now.year + 1,
          month,
          day,
          hour,
          minute,
        );
      }

      await scheduleHabitNotification(
        id: NotificationHelpers.generateSafeId('${habit.id}_${month}_$day'),
        habitId: habit.id,
        title: '🎯 ${habit.name}',
        body: 'Time to complete your yearly habit!',
        scheduledTime: nextNotification,
      );
    }

    AppLogger.debug(
      'Yearly notifications scheduled for ${habit.name} on ${selectedYearlyDates.length} dates',
    );
  }

  /// Schedule single habit notification
  Future<void> _scheduleSingleHabitNotifications(Habit habit) async {
    if (habit.singleDateTime == null) {
      AppLogger.warning('No date set for single habit: ${habit.name}');
      return;
    }

    final scheduledTime = habit.singleDateTime!;

    await scheduleHabitNotification(
      id: NotificationHelpers.generateSafeId(habit.id),
      habitId: habit.id,
      title: '🎯 ${habit.name}',
      body: 'Time to complete your habit!',
      scheduledTime: scheduledTime,
    );

    AppLogger.debug(
      'Single notification scheduled for ${habit.name} at $scheduledTime',
    );
  }

  /// Schedule hourly habit notifications
  Future<void> _scheduleHourlyHabitNotifications(
    Habit habit,
    int hour,
    int minute,
  ) async {
    final hourlyTimes = habit.hourlyTimes;

    if (hourlyTimes.isEmpty) {
      AppLogger.warning('No times selected for hourly habit: ${habit.name}');
      return;
    }

    final now = DateTime.now();

    for (final timeStr in hourlyTimes) {
      // Parse time string (format: "HH:mm")
      final parts = timeStr.split(':');
      if (parts.length != 2) continue;

      final timeHour = int.tryParse(parts[0]);
      final timeMinute = int.tryParse(parts[1]);
      if (timeHour == null || timeMinute == null) continue;

      DateTime nextNotification = DateTime(
        now.year,
        now.month,
        now.day,
        timeHour,
        timeMinute,
      );

      // If the time has passed today, schedule for tomorrow
      if (nextNotification.isBefore(now)) {
        nextNotification = nextNotification.add(const Duration(days: 1));
      }

      await scheduleHabitNotification(
        id: NotificationHelpers.generateSafeId(
            '${habit.id}_${timeHour}_$timeMinute'),
        habitId: habit.id,
        title: '🎯 ${habit.name}',
        body: 'Time to complete your habit!',
        scheduledTime: nextNotification,
      );
    }

    AppLogger.debug(
      'Hourly notifications scheduled for ${habit.name} at ${hourlyTimes.length} times',
    );
  }

  // ==================== HELPER METHODS ====================

  /// Get the next occurrence of a specific weekday
  DateTime _getNextWeekday(
      DateTime from, int targetWeekday, int hour, int minute) {
    DateTime next = DateTime(from.year, from.month, from.day, hour, minute);
    int daysToAdd = (targetWeekday - from.weekday) % 7;

    if (daysToAdd == 0 && next.isBefore(from)) {
      daysToAdd = 7;
    }

    return next.add(Duration(days: daysToAdd));
  }

  /// Get the next occurrence of a specific day of the month
  DateTime _getNextMonthDay(DateTime from, int day, int hour, int minute) {
    DateTime next = DateTime(from.year, from.month, day, hour, minute);

    if (next.isBefore(from)) {
      // Try next month
      next = DateTime(from.year, from.month + 1, day, hour, minute);
    }

    return next;
  }

  // ==================== CANCELLATION METHODS ====================

  /// Cancel a single notification by ID
  Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);

    // Note: Persistent storage removed - using Isar habit data instead
    AppLogger.debug('Cancelled notification ID: $id');
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await AwesomeNotifications().cancelAll();

    // Note: Persistent storage removed - using Isar habit data instead
    AppLogger.info('Cancelled all notifications');
  }

  /// Cancel all notifications for a specific habit
  ///
  /// Uses the base ID and cancels all variations (weekly, monthly, etc.)
  Future<void> cancelHabitNotifications(int baseId) async {
    // Cancel the main notification
    await AwesomeNotifications().cancel(baseId);

    // Note: Persistent storage removed - using Isar habit data instead
    AppLogger.debug('Cancelled notification with base ID: $baseId');
  }

  /// Cancel all notifications for a habit by habit ID string
  ///
  /// Optimized approach: Only cancels pending notifications that actually exist
  Future<void> cancelHabitNotificationsByHabitId(String habitId) async {
    AppLogger.debug(
        '🚫 Starting notification cancellation for habit: $habitId');

    try {
      // Get all currently scheduled notifications
      final scheduledNotifications =
          await AwesomeNotifications().listScheduledNotifications();

      int cancelledCount = 0;
      final List<int> cancelledIds = []; // Batch IDs for single log entry

      // Only cancel notifications that:
      // 1. Match this habit ID in the payload
      // 2. Have IDs generated from this habit ID
      for (final notification in scheduledNotifications) {
        bool shouldCancel = false;

        // Check if payload contains this habit ID
        if (notification.content?.payload != null &&
            notification.content!.payload!['data'] != null &&
            notification.content!.payload!['data']!.contains(habitId)) {
          shouldCancel = true;
        }

        // Check if notification ID was generated from this habit ID pattern
        final expectedMainId = NotificationHelpers.generateSafeId(habitId);
        if (notification.content?.id == expectedMainId) {
          shouldCancel = true;
        }

        if (shouldCancel && notification.content?.id != null) {
          await AwesomeNotifications().cancel(notification.content!.id!);
          cancelledCount++;
          cancelledIds.add(notification.content!.id!);
        }
      }

      // Single batched log entry instead of one per notification
      if (cancelledCount > 0) {
        AppLogger.info(
          '✅ Cancelled $cancelledCount notifications for habit: $habitId (scanned ${scheduledNotifications.length} pending)',
        );
        // Only log individual IDs in debug mode and only if count is reasonable
        if (cancelledCount <= 10) {
          AppLogger.debug('Cancelled IDs: ${cancelledIds.join(", ")}');
        }
      }

      // Note: Persistent storage removed - using Isar habit data instead
    } catch (e) {
      AppLogger.error('Error during optimized notification cancellation', e);
      // Fallback to cancelling the main notification only
      final mainNotificationId = NotificationHelpers.generateSafeId(habitId);
      await AwesomeNotifications().cancel(mainNotificationId);
      AppLogger.info(
          '✅ Fallback: Cancelled main notification for habit: $habitId');
    }
  }

  /// Schedule notifications using RRule (new unified approach)
  Future<void> _scheduleRRuleHabitNotifications(
    Habit habit,
    int hour,
    int minute,
  ) async {
    if (habit.rruleString == null) {
      AppLogger.error('Habit ${habit.name} has no RRule string');
      return;
    }

    try {
      // Get next 30 occurrences from RRule
      final now = DateTime.now();
      final startDate = habit.dtStart ?? now;
      final rangeEnd = now.add(const Duration(days: 90)); // Look ahead 90 days

      final occurrences = RRuleService.getOccurrences(
        rruleString: habit.rruleString!,
        startDate: startDate,
        rangeStart: now,
        rangeEnd: rangeEnd,
      );

      if (occurrences.isEmpty) {
        AppLogger.warning('No occurrences found for habit: ${habit.name}');
        return;
      }

      // Schedule notification for each occurrence
      int scheduledCount = 0;
      for (final occurrence in occurrences) {
        final scheduledTime = DateTime(
          occurrence.year,
          occurrence.month,
          occurrence.day,
          hour,
          minute,
        );

        if (scheduledTime.isAfter(now)) {
          await scheduleHabitNotification(
            id: NotificationHelpers.generateSafeId(
                '${habit.id}_${occurrence.toIso8601String()}'),
            habitId: habit.id,
            title: '🎯 ${habit.name}',
            body: 'Time to complete your habit!',
            scheduledTime: scheduledTime,
          );
          scheduledCount++;
        }
      }

      AppLogger.info(
        'RRule notifications scheduled for ${habit.name}: $scheduledCount occurrences',
      );
    } catch (e) {
      AppLogger.error('Failed to schedule RRule notifications', e);
      rethrow;
    }
  }
}
