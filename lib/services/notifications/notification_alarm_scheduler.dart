import 'package:timezone/timezone.dart' as tz;
import '../logging_service.dart';
import '../alarm_service.dart';
import '../permission_service.dart';
import '../rrule_service.dart';
import '../../domain/model/habit.dart';
import 'notification_helpers.dart';
import 'notification_core.dart';

/// System alarm scheduling functionality
///
/// This module handles:
/// - System alarm scheduling via AlarmService (awesome_notifications)
/// - Frequency-specific alarm scheduling (daily, weekly, monthly, yearly, hourly, single)
/// - Alarm cancellation
/// - Weekday calculations for recurring alarms
class NotificationAlarmScheduler {
  // Private constructor for singleton pattern
  NotificationAlarmScheduler._();

  /// Singleton instance
  static final NotificationAlarmScheduler instance =
      NotificationAlarmScheduler._();

  // ==================== MAIN ENTRY POINT ====================

  /// Schedule alarms for a habit based on its frequency and settings
  ///
  /// Main entry point for habit alarm scheduling.
  /// Routes to appropriate frequency-specific alarm scheduler.
  Future<void> scheduleHabitAlarms(Habit habit) async {
    AppLogger.debug('Starting alarm scheduling for habit: ${habit.name}');
    AppLogger.debug('Alarm enabled: ${habit.alarmEnabled}');
    AppLogger.debug('Alarm sound: ${habit.alarmSoundName}');
    AppLogger.debug('Alarm sound URI: ${habit.alarmSoundUri}');

    // Skip if alarms are disabled
    if (!habit.alarmEnabled) {
      AppLogger.debug('Skipping alarms - disabled');
      AppLogger.info('Alarms disabled for habit: ${habit.name}');
      return;
    }

    // Request notification permissions before scheduling alarms
    // This ensures the user sees the permission dialog when enabling alarms
    AppLogger.info(
        '🔔 Checking notification permissions before scheduling alarm...');
    final bool hasPermission =
        await NotificationCore.ensureNotificationPermissions();
    if (!hasPermission) {
      AppLogger.warning(
        '⚠️ Notification permission denied - alarm will fire but notification may not show',
      );
      // Continue anyway - the alarm will still fire and play sound
      // The foreground service should still work even without notification permission
    }

    // Initialize AlarmService to use awesome_notifications alarms for this habit
    await AlarmService.initialize();

    final hasExactAlarmPermission =
        await PermissionService.hasExactAlarmPermission();
    if (!hasExactAlarmPermission) {
      AppLogger.warning(
        '⚠️ Exact alarm permission not granted - alarms may be delayed on Android 12/12L',
      );
    }

    // For non-hourly, non-single habits, require notification time
    if (habit.frequency != HabitFrequency.hourly &&
        habit.frequency != HabitFrequency.single &&
        habit.notificationTime == null) {
      AppLogger.debug('Skipping alarms - no time set for non-hourly habit');
      AppLogger.info('No alarm time set for habit: ${habit.name}');
      return;
    }

    final notificationTime = habit.notificationTime;
    int hour = 9; // Default hour
    int minute = 0; // Default minute

    if (notificationTime != null) {
      hour = notificationTime.hour;
      minute = notificationTime.minute;
      AppLogger.debug('Scheduling alarm for $hour:$minute');
    } else {
      AppLogger.debug('Using default time for hourly habit alarm');
    }

    try {
      // Cancel any existing alarms for this habit first
      await AlarmService.cancelHabitAlarms(habit.id);
      AppLogger.debug('Cancelled existing alarms for habit ID: ${habit.id}');

      // Use RRule-based scheduling if habit uses RRule
      if (habit.usesRRule && habit.rruleString != null) {
        AppLogger.debug('Scheduling RRule-based alarms');
        await _scheduleRRuleHabitAlarms(habit, hour, minute);
      } else {
        // Route to legacy frequency-specific alarm scheduler
        switch (habit.frequency) {
          case HabitFrequency.daily:
            AppLogger.debug('Scheduling daily alarms');
            await _scheduleDailyHabitAlarms(habit, hour, minute);
            break;

          case HabitFrequency.weekly:
            AppLogger.debug('Scheduling weekly alarms');
            await _scheduleWeeklyHabitAlarms(habit, hour, minute);
            break;

          case HabitFrequency.monthly:
            AppLogger.debug('Scheduling monthly alarms');
            await _scheduleMonthlyHabitAlarms(habit, hour, minute);
            break;

          case HabitFrequency.yearly:
            AppLogger.debug('Scheduling yearly alarms');
            await _scheduleYearlyHabitAlarms(habit, hour, minute);
            break;

          case HabitFrequency.single:
            AppLogger.debug('Scheduling single habit alarm');
            await _scheduleSingleHabitAlarms(habit, hour, minute);
            break;

          case HabitFrequency.hourly:
            AppLogger.debug('Scheduling hourly alarms');
            await _scheduleHourlyHabitAlarms(habit);
            break;
        }
      }

      AppLogger.info(
          '✅ Successfully scheduled alarms for habit: ${habit.name}');
    } catch (e) {
      AppLogger.error('Failed to schedule alarms for habit: ${habit.name}', e);
      rethrow;
    }
  }

  // ==================== FREQUENCY-SPECIFIC ALARM SCHEDULERS ====================

  /// Schedule daily habit alarms
  Future<void> _scheduleDailyHabitAlarms(
    Habit habit,
    int hour,
    int minute,
  ) async {
    AppLogger.debug('Scheduling daily alarm for ${habit.name}');

    // Calculate next alarm time
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime nextAlarm = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the time has passed today, schedule for tomorrow
    if (nextAlarm.isBefore(now)) {
      nextAlarm = nextAlarm.add(const Duration(days: 1));
    }

    try {
      // CRITICAL FIX: Convert alarm sound name to full asset path
      final alarmSoundUri = _normalizeAlarmSoundUri(habit);

      await AlarmService.scheduleExactAlarm(
        alarmId: NotificationHelpers.generateSafeId('${habit.id}_daily'),
        habitId: habit.id.toString(),
        habitName: habit.name,
        scheduledTime: nextAlarm,
        frequency: 'daily',
        alarmSoundName: alarmSoundUri,
        snoozeDelayMinutes: 10,
      );

      AppLogger.debug(
        'Scheduled daily alarm for ${habit.name} at $nextAlarm',
      );
    } catch (e) {
      AppLogger.error('Error scheduling daily alarm for ${habit.name}', e);
      rethrow;
    }
  }

  /// Schedule weekly habit alarms
  Future<void> _scheduleWeeklyHabitAlarms(
    Habit habit,
    int hour,
    int minute,
  ) async {
    AppLogger.debug('Scheduling weekly alarms for ${habit.name}');

    final selectedWeekdays = habit.selectedWeekdays;
    if (selectedWeekdays.isEmpty) {
      AppLogger.warning('No weekdays selected for habit: ${habit.name}');
      return;
    }

    // CRITICAL FIX: Convert alarm sound name to full asset path
    final alarmSoundUri = _normalizeAlarmSoundUri(habit);

    for (int weekday in selectedWeekdays) {
      tz.TZDateTime baseTime = tz.TZDateTime.now(tz.local);
      tz.TZDateTime nextAlarm =
          _getNextWeekdayDateTime(baseTime, weekday, hour, minute);

      try {
        await AlarmService.scheduleExactAlarm(
          alarmId:
              NotificationHelpers.generateSafeId('${habit.id}_weekly_$weekday'),
          habitId: habit.id.toString(),
          habitName: habit.name,
          scheduledTime: nextAlarm,
          frequency: 'weekly',
          alarmSoundName: alarmSoundUri,
          snoozeDelayMinutes: 10,
        );

        AppLogger.debug(
          'Scheduled weekly alarm for ${habit.name} on weekday $weekday at $nextAlarm',
        );
      } catch (e) {
        AppLogger.error(
          'Error scheduling weekly alarm for ${habit.name} on weekday $weekday',
          e,
        );
      }
    }

    AppLogger.debug(
      'Scheduled ${selectedWeekdays.length} weekly alarms for ${habit.name}',
    );
  }

  /// Schedule monthly habit alarms
  Future<void> _scheduleMonthlyHabitAlarms(
    Habit habit,
    int hour,
    int minute,
  ) async {
    AppLogger.debug('Scheduling monthly alarms for ${habit.name}');
    final now = DateTime.now();

    final selectedMonthDays = habit.selectedMonthDays;
    if (selectedMonthDays.isEmpty) {
      AppLogger.warning('No month days selected for habit: ${habit.name}');
      return;
    }

    // CRITICAL FIX: Convert alarm sound name to full asset path
    final alarmSoundUri = _normalizeAlarmSoundUri(habit);

    for (int day in selectedMonthDays) {
      DateTime nextAlarm = DateTime(now.year, now.month, day, hour, minute);

      // If the day has passed this month, schedule for next month
      if (nextAlarm.isBefore(now)) {
        nextAlarm = DateTime(now.year, now.month + 1, day, hour, minute);
      }

      try {
        await AlarmService.scheduleExactAlarm(
          alarmId:
              NotificationHelpers.generateSafeId('${habit.id}_monthly_$day'),
          habitId: habit.id.toString(),
          habitName: habit.name,
          scheduledTime: nextAlarm,
          frequency: 'monthly',
          alarmSoundName: alarmSoundUri,
          snoozeDelayMinutes: 10,
        );

        AppLogger.debug(
          'Scheduled monthly alarm for ${habit.name} on day $day at $nextAlarm',
        );
      } catch (e) {
        AppLogger.error(
          'Error scheduling monthly alarm for ${habit.name} on day $day',
          e,
        );
      }
    }

    AppLogger.debug(
      'Scheduled ${selectedMonthDays.length} monthly alarms for ${habit.name}',
    );
  }

  /// Schedule yearly habit alarms
  Future<void> _scheduleYearlyHabitAlarms(
    Habit habit,
    int hour,
    int minute,
  ) async {
    AppLogger.debug('Scheduling yearly alarms for ${habit.name}');
    final now = DateTime.now();

    final selectedYearlyDates = habit.selectedYearlyDates;
    if (selectedYearlyDates.isEmpty) {
      AppLogger.warning('No yearly dates selected for habit: ${habit.name}');
      return;
    }

    // CRITICAL FIX: Convert alarm sound name to full asset path
    final alarmSoundUri = _normalizeAlarmSoundUri(habit);

    for (String dateString in selectedYearlyDates) {
      try {
        // Parse "yyyy-MM-dd" format
        final dateParts = dateString.split('-');
        if (dateParts.length != 3) continue;

        final month = int.parse(dateParts[1]);
        final day = int.parse(dateParts[2]);

        DateTime nextAlarm = DateTime(now.year, month, day, hour, minute);

        // If the date has passed this year, schedule for next year
        if (nextAlarm.isBefore(now)) {
          nextAlarm = DateTime(now.year + 1, month, day, hour, minute);
        }

        await AlarmService.scheduleExactAlarm(
          alarmId: NotificationHelpers.generateSafeId(
              '${habit.id}_yearly_${month}_$day'),
          habitId: habit.id.toString(),
          habitName: habit.name,
          scheduledTime: nextAlarm,
          frequency: 'yearly',
          alarmSoundName: alarmSoundUri,
          snoozeDelayMinutes: 10,
        );

        AppLogger.debug(
          'Scheduled yearly alarm for ${habit.name} on $dateString at $nextAlarm',
        );
      } catch (e) {
        AppLogger.error('Error parsing yearly date: $dateString', e);
      }
    }

    AppLogger.debug(
      'Scheduled ${selectedYearlyDates.length} yearly alarms for ${habit.name}',
    );
  }

  /// Schedule single-time habit alarm
  Future<void> _scheduleSingleHabitAlarms(
    Habit habit,
    int hour,
    int minute,
  ) async {
    AppLogger.debug('Scheduling single alarm for ${habit.name}');

    if (habit.singleDateTime == null) {
      AppLogger.error('Single habit "${habit.name}" requires a date/time');
      return;
    }

    final singleDateTime = habit.singleDateTime!;
    final now = DateTime.now();

    // Check if date/time is in the past
    if (singleDateTime.isBefore(now)) {
      AppLogger.error(
        'Single habit "${habit.name}" date/time is in the past: $singleDateTime',
      );
      return;
    }

    try {
      // CRITICAL FIX: Convert alarm sound name to full asset path
      final alarmSoundUri = _normalizeAlarmSoundUri(habit);

      await AlarmService.scheduleExactAlarm(
        alarmId: NotificationHelpers.generateSafeId(
          '${habit.id}_single_${singleDateTime.millisecondsSinceEpoch}',
        ),
        habitId: habit.id.toString(),
        habitName: habit.name,
        scheduledTime: singleDateTime,
        frequency: 'single',
        alarmSoundName: alarmSoundUri,
        snoozeDelayMinutes: 10,
      );

      AppLogger.debug(
        'Scheduled single alarm for ${habit.name} at $singleDateTime',
      );
    } catch (e) {
      AppLogger.error('Error scheduling single alarm for ${habit.name}', e);
      rethrow;
    }
  }

  /// Schedule hourly habit alarms
  Future<void> _scheduleHourlyHabitAlarms(Habit habit) async {
    final now = DateTime.now();
    final selectedWeekdays = habit.selectedWeekdays;
    final hourlyTimes = habit.hourlyTimes;

    // CRITICAL FIX: Convert alarm sound name to full asset path
    final alarmSoundUri = _normalizeAlarmSoundUri(habit);

    if (hourlyTimes.isEmpty) {
      // Fallback: schedule every hour during active hours (8 AM - 10 PM)
      AppLogger.debug(
        'No specific hourly times set, using default hourly alarm schedule (8 AM - 10 PM)',
      );

      // Check if weekdays are specified and if today matches
      if (selectedWeekdays.isNotEmpty &&
          !selectedWeekdays.contains(now.weekday)) {
        AppLogger.debug(
          'Skipping default hourly alarms for ${habit.name} - today (weekday ${now.weekday}) is not in selected weekdays',
        );
        return;
      }

      for (int hour = 8; hour <= 22; hour++) {
        DateTime nextAlarm = DateTime(now.year, now.month, now.day, hour, 0);

        // If the time has passed today, schedule for tomorrow
        if (nextAlarm.isBefore(now)) {
          nextAlarm = nextAlarm.add(const Duration(days: 1));

          // Check weekday constraint for next day
          if (selectedWeekdays.isNotEmpty &&
              !selectedWeekdays.contains(nextAlarm.weekday)) {
            continue;
          }
        }

        await AlarmService.scheduleExactAlarm(
          alarmId:
              NotificationHelpers.generateSafeId('${habit.id}_hourly_$hour'),
          habitId: '${habit.id}|$hour:00',
          habitName: habit.name,
          scheduledTime: nextAlarm,
          frequency: 'hourly',
          alarmSoundName: alarmSoundUri,
          snoozeDelayMinutes: 10,
        );
      }

      AppLogger.debug('Scheduled default hourly alarms for ${habit.name}');
      return;
    }

    // CRITICAL FIX: Check if weekdays are selected for hourly habits
    // Hourly habits must respect their selected weekdays
    if (selectedWeekdays.isEmpty) {
      AppLogger.warning(
        'No weekdays selected for hourly habit: ${habit.name}',
      );
      return;
    }

    // Schedule alarms for specific times
    AppLogger.debug(
      'Scheduling hourly alarms for specific times: $hourlyTimes on weekdays: $selectedWeekdays',
    );

    for (String timeString in hourlyTimes) {
      try {
        // Parse "HH:mm" format
        final timeParts = timeString.split(':');
        if (timeParts.length != 2) continue;

        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);

        // Schedule alarm for each selected weekday
        for (final weekday in selectedWeekdays) {
          tz.TZDateTime baseTime = tz.TZDateTime.now(tz.local);
          tz.TZDateTime nextAlarm =
              _getNextWeekdayDateTime(baseTime, weekday, hour, minute);

          await AlarmService.scheduleExactAlarm(
            alarmId: NotificationHelpers.generateSafeId(
                '${habit.id}_hourly_${weekday}_${hour}_$minute'),
            habitId: '${habit.id}|$hour:${minute.toString().padLeft(2, '0')}',
            habitName: habit.name,
            scheduledTime: nextAlarm,
            frequency: 'hourly',
            alarmSoundName: alarmSoundUri,
            snoozeDelayMinutes: 10,
          );

          AppLogger.debug(
            'Scheduled hourly alarm for ${habit.name} on weekday $weekday at $timeString -> $nextAlarm',
          );
        }
      } catch (e) {
        AppLogger.error(
          'Error parsing hourly time "$timeString" for habit ${habit.name}',
          e,
        );
      }
    }

    AppLogger.debug(
      'Scheduled ${hourlyTimes.length} hourly alarms for ${habit.name} on ${selectedWeekdays.length} weekdays',
    );
  }

  // ==================== HELPER METHODS ====================

  /// Calculate next occurrence of a specific weekday
  ///
  /// Given a base time and a target weekday (1=Monday, 7=Sunday),
  /// calculates the next occurrence of that weekday at the specified hour/minute.
  tz.TZDateTime _getNextWeekdayDateTime(
    tz.TZDateTime baseTime,
    int targetWeekday,
    int hour,
    int minute,
  ) {
    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      baseTime.year,
      baseTime.month,
      baseTime.day,
      hour,
      minute,
    );

    // If today is the target weekday but time has passed, or if it's a different weekday,
    // find the next occurrence
    int daysUntilTarget = (targetWeekday - scheduled.weekday) % 7;

    if (daysUntilTarget == 0 && scheduled.isBefore(baseTime)) {
      // Today is the target day but the time has passed
      daysUntilTarget = 7;
    } else if (daysUntilTarget == 0) {
      // Today is the target day and time hasn't passed
      return scheduled;
    }

    return scheduled.add(Duration(days: daysUntilTarget));
  }

  /// Schedule alarms using RRule (respects start/end dates)
  ///
  /// This method properly handles RRule-based habits by:
  /// - Respecting dtStart (start date) from the RRule
  /// - Respecting UNTIL (end date) if present in the RRule
  /// - Only scheduling alarms for valid occurrences within the date range
  Future<void> _scheduleRRuleHabitAlarms(
    Habit habit,
    int hour,
    int minute,
  ) async {
    if (habit.rruleString == null) {
      AppLogger.error('Habit ${habit.name} has no RRule string');
      return;
    }

    try {
      // Use the same 14-day look-ahead as notification scheduler
      // to prevent hitting Android's 500 concurrent alarm limit
      final now = DateTime.now();
      final startDate = habit.dtStart ?? now;
      final rangeEnd = now.add(const Duration(days: 14));

      // CRITICAL: Use RRuleService to get valid occurrences
      // This respects both dtStart and UNTIL from the RRule
      final occurrences = RRuleService.getOccurrences(
        rruleString: habit.rruleString!,
        startDate: startDate,
        rangeStart: now,
        rangeEnd: rangeEnd,
      );

      if (occurrences.isEmpty) {
        AppLogger.info(
          'No valid alarm occurrences found for habit: ${habit.name} '
          '(start: ${startDate.toIso8601String()}, range: ${now.toIso8601String()} to ${rangeEnd.toIso8601String()})',
        );
        return;
      }

      // CRITICAL FIX: Convert alarm sound name to full asset path
      final alarmSoundUri = _normalizeAlarmSoundUri(habit);

      // Schedule alarm for each valid occurrence
      int scheduledCount = 0;
      final nowTz = tz.TZDateTime.now(tz.local);

      for (final occurrence in occurrences) {
        final scheduledTime = _resolveOccurrenceTzDateTime(
          habit,
          occurrence,
          hour,
          minute,
        );

        // Only schedule if the time is in the future
        if (scheduledTime.isAfter(nowTz)) {
          try {
            await AlarmService.scheduleExactAlarm(
              alarmId: NotificationHelpers.generateSafeId(
                '${habit.id}_${scheduledTime.toIso8601String()}',
              ),
              habitId: habit.id.toString(),
              habitName: habit.name,
              scheduledTime: scheduledTime,
              frequency: 'rrule',
              alarmSoundName: alarmSoundUri,
              snoozeDelayMinutes: habit.snoozeDelayMinutes,
            );
            scheduledCount++;

            AppLogger.debug(
              'Scheduled RRule alarm for ${habit.name} at $scheduledTime',
            );
          } catch (e) {
            AppLogger.error(
              'Error scheduling RRule alarm for ${habit.name} at $scheduledTime',
              e,
            );
          }
        }
      }

      AppLogger.info(
        '✅ Scheduled $scheduledCount RRule-based alarms for ${habit.name} '
        '(${occurrences.length} valid occurrences found)',
      );
    } catch (e) {
      AppLogger.error('Failed to schedule RRule alarms for ${habit.name}', e);
      rethrow;
    }
  }

  /// Normalize alarm sound URI to full asset path
  ///
  /// CRITICAL FIX: Converts alarm sound names to full asset paths.
  /// - If alarmSoundUri is already set and starts with "sounds/", returns it as-is
  /// - If alarmSoundName is set and doesn't start with "sounds/", converts it to "sounds/name.ogg"
  /// - Otherwise returns default "sounds/alarm.ogg"
  /// - NOTE: Flutter assets are in OGG format. Android raw resources normalization happens
  ///   in AlarmService._normalizeAlarmSoundName() which handles the resource name conversion.
  /// - NOTE: File names must be lowercase to match Android resource naming conventions
  String _normalizeAlarmSoundUri(Habit habit) {
    // If alarmSoundUri is already properly set, use it
    if (habit.alarmSoundUri != null && habit.alarmSoundUri!.isNotEmpty) {
      if (habit.alarmSoundUri!.startsWith('sounds/')) {
        return habit.alarmSoundUri!;
      }
    }

    // If alarmSoundName is set, convert it to full path
    if (habit.alarmSoundName != null && habit.alarmSoundName!.isNotEmpty) {
      final name = habit.alarmSoundName!;

      // If it already has .ogg or .mp3 extension, just prepend "sounds/"
      if (name.endsWith('.ogg') || name.endsWith('.mp3')) {
        return 'sounds/$name';
      }

      // Otherwise add both "sounds/" prefix and ".ogg" extension
      // Note: Flutter assets are in .ogg format, and alarm_service will
      // normalize this to Android raw resource names (without extension)
      return 'sounds/$name.ogg';
    }

    // Default to system alarm sound (OGG format to match Flutter assets)
    return 'sounds/alarm.ogg';
  }

  tz.TZDateTime _resolveOccurrenceTzDateTime(
    Habit habit,
    DateTime occurrence,
    int fallbackHour,
    int fallbackMinute,
  ) {
    final resolved = _resolveOccurrenceDateTime(
      habit,
      occurrence,
      fallbackHour,
      fallbackMinute,
    );
    return tz.TZDateTime.from(resolved, tz.local);
  }

  DateTime _resolveOccurrenceDateTime(
    Habit habit,
    DateTime occurrence,
    int fallbackHour,
    int fallbackMinute,
  ) {
    // CRITICAL FIX: RRule occurrences are in UTC.
    // If we convert to local directly, we might shift the day and get a time component
    // (e.g. midnight UTC -> 7pm previous day EST).
    // We should treat the UTC occurrence as "floating" time (date components only)
    // unless it has a specific time set in the RRule.

    // Check if the occurrence is exactly midnight UTC (implies date-only RRule)
    final isMidnightUtc = occurrence.hour == 0 &&
        occurrence.minute == 0 &&
        occurrence.second == 0 &&
        occurrence.millisecond == 0 &&
        occurrence.microsecond == 0;

    if (isMidnightUtc) {
      // It's a date-only occurrence (e.g. FREQ=DAILY).
      // Use the date from the occurrence, but apply the habit's notification time.
      final notificationTime = habit.notificationTime;
      if (notificationTime != null) {
        return DateTime(
          occurrence.year,
          occurrence.month,
          occurrence.day,
          notificationTime.hour,
          notificationTime.minute,
        );
      }

      // Fallback if no notification time
      return DateTime(
        occurrence.year,
        occurrence.month,
        occurrence.day,
        fallbackHour,
        fallbackMinute,
      );
    }

    // If it's NOT midnight UTC, the RRule has a specific time (e.g. BYHOUR=10).
    // We treat this as floating time (local time).
    return DateTime(
      occurrence.year,
      occurrence.month,
      occurrence.day,
      occurrence.hour,
      occurrence.minute,
      occurrence.second,
      occurrence.millisecond,
      occurrence.microsecond,
    );
  }
}
