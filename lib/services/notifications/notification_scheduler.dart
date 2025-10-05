import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../logging_service.dart';
import '../rrule_service.dart';
import '../../domain/model/habit.dart';
import 'notification_core.dart';
import 'notification_helpers.dart';

/// Notification scheduling functionality
///
/// This module handles:
/// - Time-based notification scheduling (zonedSchedule)
/// - Frequency-specific scheduling (daily, weekly, monthly, yearly, hourly, single)
/// - Notification cancellation
/// - Schedule validation and timezone handling
class NotificationScheduler {
  final FlutterLocalNotificationsPlugin _plugin;

  /// Create a notification scheduler with the provided plugin
  NotificationScheduler(this._plugin);

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

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'habit_scheduled_channel',
      'Scheduled Habit Notifications',
      channelDescription: 'Scheduled notifications for habit reminders',
      importance: Importance.max,
      priority: Priority.high,
      sound: const UriAndroidNotificationSound(
          'content://settings/system/notification_sound'),
      playSound: true,
      enableVibration: true,
      actions: const [
        AndroidNotificationAction(
          'complete',
          'COMPLETE',
          showsUserInterface: false,
        ),
        AndroidNotificationAction(
          'snooze',
          'SNOOZE 30MIN',
          showsUserInterface: false,
        ),
      ],
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(categoryIdentifier: 'habit_category');

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

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

    // Create timezone-aware scheduled time with proper validation
    tz.TZDateTime tzScheduledTime;
    try {
      tzScheduledTime = tz.TZDateTime.from(localScheduledTime, tz.local);
      AppLogger.debug('TZ Scheduled time: $tzScheduledTime');
      AppLogger.debug('TZ Local timezone: ${tz.local.name}');

      // Verify timezone conversion didn't cause time drift
      final tzTimeDiff =
          tzScheduledTime.difference(tz.TZDateTime.now(tz.local));
      if ((tzTimeDiff.inSeconds - timeDiff.inSeconds).abs() > 60) {
        AppLogger.warning(
          '⚠️ Timezone conversion caused significant time drift: ${tzTimeDiff.inSeconds - timeDiff.inSeconds} seconds',
        );
      }
    } catch (tzError) {
      AppLogger.error('Timezone conversion failed, using UTC', tzError);
      tzScheduledTime = tz.TZDateTime.from(localScheduledTime.toUtc(), tz.UTC);
    }

    final payload = jsonEncode({'habitId': habitId, 'type': 'habit_reminder'});

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );

    AppLogger.info(
      '✅ Scheduled notification ID $id for habit $habitId at $tzScheduledTime',
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
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'habit_channel',
      'Habit Notifications',
      channelDescription: 'Notifications for habit reminders',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      sound: UriAndroidNotificationSound(
          'content://settings/system/notification_sound'),
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _plugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
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
        'Successfully scheduled daily notification for ${habit.name}',
      );
    } catch (e) {
      AppLogger.error('Error scheduling daily notification', e);
      rethrow;
    }
  }

  /// Schedule weekly habit notifications
  Future<void> _scheduleWeeklyHabitNotifications(
    Habit habit,
    int hour,
    int minute,
  ) async {
    final selectedWeekdays = habit.selectedWeekdays;
    final now = DateTime.now();

    for (int weekday in selectedWeekdays) {
      DateTime nextNotification = DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      // Find the next occurrence of this weekday
      while (nextNotification.weekday != weekday) {
        nextNotification = nextNotification.add(const Duration(days: 1));
      }

      // If the time has passed today, schedule for next week
      if (nextNotification.isBefore(now)) {
        nextNotification = nextNotification.add(const Duration(days: 7));
      }

      await scheduleHabitNotification(
        id: NotificationHelpers.generateSafeId('${habit.id}_week_$weekday'),
        habitId: habit.id,
        title: '🎯 ${habit.name}',
        body: 'Time to complete your weekly habit! Don\'t break your streak.',
        scheduledTime: nextNotification,
      );
    }

    AppLogger.debug(
      'Scheduled ${selectedWeekdays.length} weekly notifications for ${habit.name}',
    );
  }

  /// Schedule monthly habit notifications
  Future<void> _scheduleMonthlyHabitNotifications(
    Habit habit,
    int hour,
    int minute,
  ) async {
    final selectedMonthDays = habit.selectedMonthDays;
    final now = DateTime.now();

    for (int monthDay in selectedMonthDays) {
      DateTime nextNotification = DateTime(
        now.year,
        now.month,
        monthDay,
        hour,
        minute,
      );

      // If the day has passed this month, schedule for next month
      if (nextNotification.isBefore(now)) {
        nextNotification = DateTime(
          now.year,
          now.month + 1,
          monthDay,
          hour,
          minute,
        );
      }

      // Handle case where the day doesn't exist in the target month
      try {
        nextNotification = DateTime(
          nextNotification.year,
          nextNotification.month,
          nextNotification.day,
          hour,
          minute,
        );
      } catch (e) {
        // Skip this day if it doesn't exist in the month (e.g., Feb 30)
        AppLogger.warning(
          'Day $monthDay does not exist in month ${nextNotification.month}, skipping',
        );
        continue;
      }

      await scheduleHabitNotification(
        id: NotificationHelpers.generateSafeId('${habit.id}_month_$monthDay'),
        habitId: habit.id,
        title: '🎯 ${habit.name}',
        body:
            'Time to complete your monthly habit! Stay consistent with your goals.',
        scheduledTime: nextNotification,
      );
    }

    AppLogger.debug(
      'Scheduled ${selectedMonthDays.length} monthly notifications for ${habit.name}',
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
      AppLogger.warning('No yearly dates set for habit: ${habit.name}');
      return;
    }

    final now = DateTime.now();

    for (String dateStr in selectedYearlyDates) {
      try {
        // Parse "yyyy-MM-dd" format
        final dateParts = dateStr.split('-');
        if (dateParts.length != 3) continue;

        final month = int.parse(dateParts[1]);
        final day = int.parse(dateParts[2]);

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
          id: NotificationHelpers.generateSafeId(
            '${habit.id}_year_${month}_$day',
          ),
          habitId: habit.id,
          title: '🎯 ${habit.name}',
          body: 'Time for your yearly habit! Make this milestone count.',
          scheduledTime: nextNotification,
        );

        AppLogger.debug(
          'Scheduled yearly notification for ${habit.name} on $month/$day',
        );
      } catch (e) {
        AppLogger.error('Failed to parse yearly date: $dateStr', e);
      }
    }
  }

  /// Schedule single-time habit notifications
  Future<void> _scheduleSingleHabitNotifications(Habit habit) async {
    final singleDateTime = habit.singleDateTime;
    if (singleDateTime == null) {
      AppLogger.warning(
        'No single date/time set for habit: ${habit.name}',
      );
      return;
    }

    final now = DateTime.now();
    if (singleDateTime.isBefore(now)) {
      AppLogger.warning(
        'Single habit date/time is in the past for habit: ${habit.name}',
      );
      return;
    }

    await scheduleHabitNotification(
      id: NotificationHelpers.generateSafeId('${habit.id}_single'),
      habitId: habit.id,
      title: '🎯 ${habit.name}',
      body: 'Time to complete your one-time habit!',
      scheduledTime: singleDateTime,
    );

    AppLogger.debug(
      'Scheduled single notification for ${habit.name} at $singleDateTime',
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
      AppLogger.warning('No hourly times set for habit: ${habit.name}');
      return;
    }

    final now = DateTime.now();
    int scheduledCount = 0;

    for (String timeStr in hourlyTimes) {
      try {
        // Parse "HH:mm" format
        final timeParts = timeStr.split(':');
        if (timeParts.length != 2) continue;

        final hourValue = int.parse(timeParts[0]);
        final minuteValue = int.parse(timeParts[1]);

        DateTime nextNotification = DateTime(
          now.year,
          now.month,
          now.day,
          hourValue,
          minuteValue,
        );

        // If the time has passed today, schedule for tomorrow
        if (nextNotification.isBefore(now)) {
          nextNotification = nextNotification.add(const Duration(days: 1));
        }

        // Only schedule up to 48 hours ahead to avoid excessive notifications
        if (nextNotification.difference(now).inHours > 48) {
          continue;
        }

        await scheduleHabitNotification(
          id: NotificationHelpers.generateSafeId(
            '${habit.id}_hour_${hourValue}_$minuteValue',
          ),
          habitId: '${habit.id}|$hourValue:$minuteValue',
          title: '🎯 ${habit.name}',
          body: 'Time to complete your hourly habit!',
          scheduledTime: nextNotification,
        );

        scheduledCount++;
      } catch (e) {
        AppLogger.error('Failed to parse hourly time: $timeStr', e);
      }
    }

    AppLogger.debug(
      'Scheduled $scheduledCount hourly notifications for ${habit.name}',
    );
  }

  // ==================== CANCELLATION METHODS ====================

  /// Cancel a single notification by ID
  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
    AppLogger.debug('Cancelled notification ID: $id');
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
    AppLogger.info('Cancelled all notifications');
  }

  /// Cancel all notifications for a specific habit
  ///
  /// Uses the base ID and cancels all variations (weekly, monthly, etc.)
  Future<void> cancelHabitNotifications(int baseId) async {
    // Cancel the main notification
    await _plugin.cancel(baseId);

    AppLogger.debug('Cancelled notification with base ID: $baseId');
  }

  /// Cancel all notifications for a habit by habit ID string
  ///
  /// Optimized approach: Only cancels pending notifications that actually exist
  Future<void> cancelHabitNotificationsByHabitId(String habitId) async {
    AppLogger.debug(
        '🚫 Starting notification cancellation for habit: $habitId');

    try {
      // Get all currently pending notifications
      final pendingNotifications = await _plugin.pendingNotificationRequests();

      int cancelledCount = 0;
      final List<int> cancelledIds = []; // Batch IDs for single log entry

      // Only cancel notifications that:
      // 1. Match this habit ID in the payload
      // 2. Have IDs generated from this habit ID
      for (final notification in pendingNotifications) {
        bool shouldCancel = false;

        // Check if payload contains this habit ID
        if (notification.payload != null &&
            notification.payload!.contains(habitId)) {
          shouldCancel = true;
        }

        // Check if notification ID was generated from this habit ID pattern
        final expectedMainId = NotificationHelpers.generateSafeId(habitId);
        if (notification.id == expectedMainId) {
          shouldCancel = true;
        }

        if (shouldCancel) {
          await _plugin.cancel(notification.id);
          cancelledCount++;
          cancelledIds.add(notification.id);
        }
      }

      // Single batched log entry instead of one per notification
      if (cancelledCount > 0) {
        AppLogger.info(
          '✅ Cancelled $cancelledCount notifications for habit: $habitId (scanned ${pendingNotifications.length} pending)',
        );
        // Only log individual IDs in debug mode and only if count is reasonable
        if (cancelledCount <= 10) {
          AppLogger.debug('Cancelled IDs: ${cancelledIds.join(", ")}');
        }
      }
    } catch (e) {
      AppLogger.error('Error during optimized notification cancellation', e);
      // Fallback to cancelling the main notification only
      final mainNotificationId = NotificationHelpers.generateSafeId(habitId);
      await _plugin.cancel(mainNotificationId);
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

    final now = tz.TZDateTime.now(tz.local);
    // Use frequency-aware scheduling window for optimal coverage
    final endDate = switch (habit.frequency) {
      HabitFrequency.yearly =>
        now.add(const Duration(days: 730)), // 2 years for yearly habits
      HabitFrequency.monthly =>
        now.add(const Duration(days: 365)), // 1 year for monthly habits
      _ => now.add(const Duration(days: 84)), // 12 weeks for all others
    };

    try {
      // Get all occurrences from RRule
      final occurrences = RRuleService.getOccurrences(
        rruleString: habit.rruleString!,
        startDate: habit.dtStart ?? habit.createdAt,
        rangeStart: now,
        rangeEnd: endDate,
      );

      int scheduledCount = 0;

      // Pre-create reusable notification details to reduce memory allocations
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'habit_scheduled_channel',
        'Scheduled Habit Notifications',
        channelDescription: 'Scheduled notifications for habit reminders',
        importance: Importance.max,
        priority: Priority.high,
        sound: UriAndroidNotificationSound(
            'content://settings/system/notification_sound'),
        playSound: true,
        enableVibration: true,
        actions: [
          AndroidNotificationAction(
            'complete',
            'COMPLETE',
            showsUserInterface: false,
          ),
          AndroidNotificationAction(
            'snooze',
            'SNOOZE 30MIN',
            showsUserInterface: false,
          ),
        ],
      );

      const DarwinNotificationDetails iOSDetails =
          DarwinNotificationDetails(categoryIdentifier: 'habit_category');

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidDetails,
        iOS: iOSDetails,
      );

      // Pre-create reusable payload to reduce string allocations
      final payload =
          jsonEncode({'habitId': habit.id, 'type': 'habit_reminder'});
      final notificationTitle = '🎯 ${habit.name}';
      const notificationBody =
          'Time to complete your habit! Don\'t break your streak.';

      for (final occurrence in occurrences) {
        // Create TZDateTime for the notification
        final scheduledTime = tz.TZDateTime(
          tz.local,
          occurrence.year,
          occurrence.month,
          occurrence.day,
          hour,
          minute,
        );

        if (scheduledTime.isAfter(now)) {
          final notificationId = NotificationHelpers.generateSafeId(
              '${habit.id}_rrule_${occurrence.year}_${occurrence.month}_${occurrence.day}');

          await _plugin.zonedSchedule(
            notificationId,
            notificationTitle,
            notificationBody,
            scheduledTime,
            platformChannelSpecifics,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: payload,
          );

          scheduledCount++;
        }
      }

      AppLogger.info(
          '📅 Scheduled $scheduledCount RRule notifications for ${habit.name}');
    } catch (e) {
      AppLogger.error(
          'Failed to schedule RRule notifications for ${habit.name}: $e');
    }
  }
}
