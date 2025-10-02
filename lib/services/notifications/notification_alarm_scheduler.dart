import 'package:timezone/timezone.dart' as tz;
import '../logging_service.dart';
import '../alarm_manager_service.dart';
import '../../domain/model/habit.dart';
import 'notification_helpers.dart';

/// System alarm scheduling functionality
///
/// This module handles:
/// - System alarm scheduling via AlarmManagerService
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

    // Initialize AlarmManagerService to use system alarms for this habit
    await AlarmManagerService.initialize();

    // Skip if alarms are disabled
    if (!habit.alarmEnabled) {
      AppLogger.debug('Skipping alarms - disabled');
      AppLogger.info('Alarms disabled for habit: ${habit.name}');
      return;
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
      await AlarmManagerService.cancelHabitAlarms(habit.id);
      AppLogger.debug('Cancelled existing alarms for habit ID: ${habit.id}');

      // Route to frequency-specific alarm scheduler
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
      await AlarmManagerService.scheduleExactAlarm(
        alarmId: NotificationHelpers.generateSafeId('${habit.id}_daily'),
        habitId: habit.id.toString(),
        habitName: habit.name,
        scheduledTime: nextAlarm,
        frequency: 'daily',
        alarmSoundName: habit.alarmSoundName,
        alarmSoundUri: habit.alarmSoundUri,
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

    for (int weekday in selectedWeekdays) {
      tz.TZDateTime baseTime = tz.TZDateTime.now(tz.local);
      tz.TZDateTime nextAlarm =
          _getNextWeekdayDateTime(baseTime, weekday, hour, minute);

      try {
        await AlarmManagerService.scheduleExactAlarm(
          alarmId:
              NotificationHelpers.generateSafeId('${habit.id}_weekly_$weekday'),
          habitId: habit.id.toString(),
          habitName: habit.name,
          scheduledTime: nextAlarm,
          frequency: 'weekly',
          alarmSoundName: habit.alarmSoundName,
          alarmSoundUri: habit.alarmSoundUri,
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

    for (int day in selectedMonthDays) {
      DateTime nextAlarm = DateTime(now.year, now.month, day, hour, minute);

      // If the day has passed this month, schedule for next month
      if (nextAlarm.isBefore(now)) {
        nextAlarm = DateTime(now.year, now.month + 1, day, hour, minute);
      }

      try {
        await AlarmManagerService.scheduleExactAlarm(
          alarmId:
              NotificationHelpers.generateSafeId('${habit.id}_monthly_$day'),
          habitId: habit.id.toString(),
          habitName: habit.name,
          scheduledTime: nextAlarm,
          frequency: 'monthly',
          alarmSoundName: habit.alarmSoundName,
          alarmSoundUri: habit.alarmSoundUri,
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

        await AlarmManagerService.scheduleExactAlarm(
          alarmId: NotificationHelpers.generateSafeId(
              '${habit.id}_yearly_${month}_$day'),
          habitId: habit.id.toString(),
          habitName: habit.name,
          scheduledTime: nextAlarm,
          frequency: 'yearly',
          alarmSoundName: habit.alarmSoundName,
          alarmSoundUri: habit.alarmSoundUri,
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
      await AlarmManagerService.scheduleExactAlarm(
        alarmId: NotificationHelpers.generateSafeId(
          '${habit.id}_single_${singleDateTime.millisecondsSinceEpoch}',
        ),
        habitId: habit.id.toString(),
        habitName: habit.name,
        scheduledTime: singleDateTime,
        frequency: 'single',
        alarmSoundName: habit.alarmSoundName,
        alarmSoundUri: habit.alarmSoundUri,
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

        await AlarmManagerService.scheduleExactAlarm(
          alarmId:
              NotificationHelpers.generateSafeId('${habit.id}_hourly_$hour'),
          habitId: '${habit.id}|$hour:00',
          habitName: habit.name,
          scheduledTime: nextAlarm,
          frequency: 'hourly',
          alarmSoundName: habit.alarmSoundName,
          alarmSoundUri: habit.alarmSoundUri,
          snoozeDelayMinutes: 10,
        );
      }

      AppLogger.debug('Scheduled default hourly alarms for ${habit.name}');
      return;
    }

    // Schedule alarms for specific times
    AppLogger.debug(
      'Scheduling hourly alarms for specific times: $hourlyTimes',
    );

    for (String timeString in hourlyTimes) {
      try {
        // Parse "HH:mm" format
        final timeParts = timeString.split(':');
        if (timeParts.length != 2) continue;

        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);

        // Check if weekdays are specified and if today matches
        if (selectedWeekdays.isNotEmpty &&
            !selectedWeekdays.contains(now.weekday)) {
          AppLogger.debug(
            'Skipping hourly alarm for ${habit.name} - today (weekday ${now.weekday}) is not in selected weekdays',
          );
          continue;
        }

        DateTime nextAlarm = DateTime(
          now.year,
          now.month,
          now.day,
          hour,
          minute,
        );

        // If the time has passed today, schedule for tomorrow
        if (nextAlarm.isBefore(now)) {
          nextAlarm = nextAlarm.add(const Duration(days: 1));

          // Check weekday constraint for next day
          if (selectedWeekdays.isNotEmpty &&
              !selectedWeekdays.contains(nextAlarm.weekday)) {
            AppLogger.debug(
              'Skipping hourly alarm for ${habit.name} - next day (weekday ${nextAlarm.weekday}) is not in selected weekdays',
            );
            continue;
          }
        }

        await AlarmManagerService.scheduleExactAlarm(
          alarmId: NotificationHelpers.generateSafeId(
              '${habit.id}_hourly_${hour}_$minute'),
          habitId: '${habit.id}|$hour:${minute.toString().padLeft(2, '0')}',
          habitName: habit.name,
          scheduledTime: nextAlarm,
          frequency: 'hourly',
          alarmSoundName: habit.alarmSoundName,
          alarmSoundUri: habit.alarmSoundUri,
          snoozeDelayMinutes: 10,
        );

        AppLogger.debug(
          'Scheduled hourly alarm for $timeString at $nextAlarm',
        );
      } catch (e) {
        AppLogger.error(
          'Error parsing hourly time "$timeString" for habit ${habit.name}',
          e,
        );
      }
    }

    AppLogger.debug(
      'Scheduled ${hourlyTimes.length} hourly alarms for ${habit.name}',
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
}
