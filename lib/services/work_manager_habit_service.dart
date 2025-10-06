// Removed unused kDebugMode import to satisfy analyzer
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import '../data/database_isar.dart';

import 'notification_service.dart';
import 'logging_service.dart';
import 'rrule_service.dart';

/// Service responsible for ensuring habits continue to work indefinitely
/// using WorkManager for guaranteed execution on Android
class WorkManagerHabitService {
  // Constants for WorkManager task names
  static const String _renewalTaskName = 'com.habitv8.HABIT_RENEWAL_TASK';
  static const String _alarmRenewalTaskName = 'com.habitv8.ALARM_RENEWAL_TASK';
  static const String _lastRenewalKey = 'last_habit_continuation_renewal';
  static const String _lastAlarmRenewalKey = 'last_alarm_renewal';
  static const String _renewalIntervalKey = 'habit_continuation_interval_hours';
  static const String _bootTimestampKey = 'last_boot_timestamp';

  // Default renewal every 12 hours to ensure notifications don't expire
  static const int _defaultRenewalIntervalHours = 12;
  // Alarm renewal delay after boot to comply with Android 15+ restrictions
  static const int _alarmRenewalDelayMinutes = 30;
  static bool _isInitialized = false;

  /// Initialize the WorkManager habit service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('🔄 Initializing WorkManager Habit Service');

      // Initialize WorkManager
      await Workmanager().initialize(
        callbackDispatcher,
        // isInDebugMode is deprecated in newer workmanager versions.
        // Debugging can be configured via Workmanager's own debug handlers.
      );

      // Schedule periodic renewal task
      await _schedulePeriodicRenewalTask();

      // Check for boot completion and schedule alarm renewal if needed
      await _checkBootCompletionAndScheduleAlarmRenewal();

      // REMOVED: Boot completion task registration to prevent Android 15+ conflicts
      // The new Android15CompatBootReceiver handles boot completion safely
      // await _registerBootCompletionTask();

      // Perform initial renewal check to ensure all habits are properly scheduled
      await _performRenewalCheck();

      _isInitialized = true;
      AppLogger.info('✅ WorkManager Habit Service initialized successfully');
    } catch (e) {
      AppLogger.error('❌ Failed to initialize WorkManager Habit Service', e);
    }
  }

  /// The callback dispatcher for WorkManager tasks
  @pragma('vm:entry-point')
  static void callbackDispatcher() {
    Workmanager().executeTask((taskName, inputData) async {
      try {
        AppLogger.info('🔄 Executing WorkManager task: $taskName');

        switch (taskName) {
          case _renewalTaskName:
            await _performRenewalCheck();
            break;
          case _alarmRenewalTaskName:
            await _performAlarmRenewalCheck();
            break;
          // REMOVED: Boot completion task to prevent Android 15+ conflicts
          // Boot completion is now handled by Android15CompatBootReceiver
          default:
            AppLogger.warning('Unknown task name: $taskName');
        }

        return true; // Task completed successfully
      } catch (e) {
        AppLogger.error('❌ Error executing WorkManager task: $taskName', e);
        return false; // Task failed
      }
    });
  }

  /// Schedule the periodic renewal task
  static Future<void> _schedulePeriodicRenewalTask() async {
    try {
      // Get renewal interval from preferences
      final prefs = await SharedPreferences.getInstance();
      final intervalHours =
          prefs.getInt(_renewalIntervalKey) ?? _defaultRenewalIntervalHours;

      // Cancel any existing periodic task
      await Workmanager().cancelByUniqueName(_renewalTaskName);

      // Schedule new periodic task with better constraints
      await Workmanager().registerPeriodicTask(
        _renewalTaskName,
        _renewalTaskName,
        frequency: Duration(hours: intervalHours),
        constraints: Constraints(
          networkType: NetworkType.notRequired,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresDeviceIdle: false,
        ),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
        backoffPolicy: BackoffPolicy.linear,
        backoffPolicyDelay: Duration(minutes: 15),
      );

      AppLogger.info(
          '🔄 Scheduled periodic renewal task (interval: ${intervalHours}h)');
    } catch (e) {
      AppLogger.error('❌ Failed to schedule periodic renewal task', e);
    }
  }

  /// Perform renewal check and extend notifications/alarms if needed
  static Future<void> _performRenewalCheck() async {
    try {
      AppLogger.info('🔍 Performing habit continuation renewal check');

      final prefs = await SharedPreferences.getInstance();
      final lastRenewalStr = prefs.getString(_lastRenewalKey);
      final now = DateTime.now();

      DateTime? lastRenewal;
      if (lastRenewalStr != null) {
        try {
          lastRenewal = DateTime.parse(lastRenewalStr);
        } catch (e) {
          AppLogger.warning(
              'Invalid last renewal date format: $lastRenewalStr');
        }
      }

      // Check if renewal is needed (every 6 hours or if never renewed)
      bool needsRenewal = false;
      if (lastRenewal == null) {
        needsRenewal = true;
        AppLogger.info('No previous renewal found, performing initial renewal');
      } else {
        final hoursSinceRenewal = now.difference(lastRenewal).inHours;
        if (hoursSinceRenewal >= 6) {
          needsRenewal = true;
          AppLogger.info(
              '$hoursSinceRenewal hours since last renewal, renewal needed');
        } else {
          AppLogger.info(
              '$hoursSinceRenewal hours since last renewal, no renewal needed yet');
        }
      }

      if (needsRenewal) {
        // Only renew habits that should be active at the current time
        await _performHabitContinuationRenewal(forceRenewal: false);

        // Update last renewal timestamp
        await prefs.setString(_lastRenewalKey, now.toIso8601String());
        AppLogger.info(
            '✅ Habit continuation renewal completed and timestamp updated');
      }
    } catch (e) {
      AppLogger.error('❌ Error during habit continuation renewal check', e);
    }
  }

  /// Perform the actual habit continuation renewal
  static Future<void> _performHabitContinuationRenewal({
    bool forceRenewal = false,
    String? specificHabitId,
  }) async {
    try {
      AppLogger.info(
          '🔄 Starting habit continuation renewal process${forceRenewal ? ' (forced)' : ''}${specificHabitId != null ? ' for habit ID: ' : ''}');

      // Get all active habits
      final isar = await IsarDatabaseService.getInstance();
      final habitService = HabitServiceIsar(isar);
      final habits = await habitService.getAllHabits();

      // Filter habits based on parameters
      List<dynamic> habitsToRenew;
      if (specificHabitId != null) {
        // If a specific habit ID is provided, only renew that habit
        habitsToRenew =
            habits.where((h) => h.id == specificHabitId && h.isActive).toList();
      } else {
        // Otherwise, renew all active habits
        habitsToRenew = habits.where((h) => h.isActive).toList();
      }

      AppLogger.info(
          '🔄 Renewing continuation for ${habitsToRenew.length} active habits');

      int renewedCount = 0;
      int errorCount = 0;

      for (final habit in habitsToRenew) {
        try {
          // Only renew habits that should be active now based on their schedule
          // or if force renewal is requested for a specific habit
          bool shouldRenew = forceRenewal && specificHabitId == habit.id;

          if (!shouldRenew) {
            shouldRenew = _shouldRenewHabit(habit);
          }

          if (shouldRenew) {
            if (habit.notificationsEnabled) {
              await _renewHabitNotifications(habit);
              renewedCount++;
              AppLogger.info(
                  '✅ Renewed notifications for habit: ${habit.name}');
            }
          } else {
            AppLogger.info(
                '⏭️ Skipped renewal for habit: ${habit.name} (not scheduled for current time/day)');
          }
        } catch (e) {
          errorCount++;
          AppLogger.error('❌ Error renewing habit: ${habit.name}', e);
        }
      }

      AppLogger.info(
          '✅ Habit continuation renewal completed: $renewedCount renewed, $errorCount errors');
    } catch (e) {
      AppLogger.error('❌ Error during habit continuation renewal', e);
    }
  }

  /// Check if a habit should be renewed based on its schedule
  /// For continuation service, we should renew ALL active habits to ensure they continue working
  static bool _shouldRenewHabit(dynamic habit, {bool forceRenewal = false}) {
    // If force renewal is requested for a specific habit, allow it
    if (forceRenewal && habit.id != null) return true;

    // For habit continuation, we should renew ALL active habits regardless of current time
    // The purpose of the continuation service is to ensure habits don't lose their future notifications
    // The original logic was too restrictive and caused habits to lose notifications
    // when renewal happened at times that didn't match their scheduled times

    // Simply check if the habit is active and has notifications enabled
    return habit.isActive && habit.notificationsEnabled;
  }

  /// Renew notifications for a habit
  static Future<void> _renewHabitNotifications(dynamic habit) async {
    try {
      // DO NOT cancel existing notifications during renewal
      // This was causing all notifications to fire at renewal time instead of scheduled time
      // Only extend future notifications to ensure long-term continuity

      AppLogger.info(
          '🔄 Extending future notifications for habit: ${habit.name}');

      // Use continuous scheduling to ensure habits work long-term
      // This will only schedule notifications that don't already exist
      await _scheduleContinuousNotifications(habit);
    } catch (e) {
      AppLogger.error(
          '❌ Error renewing notifications for habit: ${habit.name}', e);
      rethrow;
    }
  }

  /// Schedule continuous notifications for a habit (similar to HabitContinuationService)
  static Future<void> _scheduleContinuousNotifications(dynamic habit) async {
    if (!habit.notificationsEnabled) {
      return;
    }

    // For non-hourly, non-single habits, require notification time
    final frequency = habit.frequency.toString().split('.').last;
    if (frequency != 'hourly' &&
        frequency != 'single' &&
        habit.notificationTime == null) {
      return;
    }

    // Use RRule-based scheduling if habit uses RRule
    if (habit.usesRRule && habit.rruleString != null) {
      await _scheduleRRuleContinuous(habit);
      return;
    }

    // Legacy frequency-based scheduling
    switch (frequency) {
      case 'daily':
        await _scheduleDailyContinuous(habit);
        break;
      case 'weekly':
        await _scheduleWeeklyContinuous(habit);
        break;
      case 'monthly':
        await _scheduleMonthlyContinuous(habit);
        break;
      case 'yearly':
        await _scheduleYearlyContinuous(habit);
        break;
      case 'single':
        await _scheduleSingleContinuous(habit);
        break;
      case 'hourly':
        await _scheduleHourlyContinuous(habit);
        break;
      default:
        AppLogger.warning('Unknown habit frequency: ${habit.frequency}');
    }
  }

  /// Check for boot completion and schedule alarm renewal if needed
  /// This provides automated alarm restoration while respecting Android 15+ restrictions
  static Future<void> _checkBootCompletionAndScheduleAlarmRenewal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastBootTimestamp = prefs.getInt(_bootTimestampKey) ?? 0;
      final currentBootTime = DateTime.now().millisecondsSinceEpoch;

      // Check if this is a fresh boot (or first run)
      // We use a simple timestamp comparison rather than relying on boot completion flags
      final timeSinceLastBoot = currentBootTime - lastBootTimestamp;
      final hasRebooted = timeSinceLastBoot >
          (24 *
              60 *
              60 *
              1000); // More than 24 hours difference suggests reboot

      if (hasRebooted || lastBootTimestamp == 0) {
        AppLogger.info('🔄 Boot completion detected, scheduling alarm renewal');

        // Schedule delayed alarm renewal to comply with Android 15+ restrictions
        // This gives the system time to fully boot before starting foreground services
        await _scheduleDelayedAlarmRenewal();

        // Update boot timestamp
        await prefs.setInt(_bootTimestampKey, currentBootTime);
      } else {
        AppLogger.info(
            '🔄 No recent boot detected, skipping alarm renewal scheduling');
      }
    } catch (e) {
      AppLogger.error('❌ Error checking boot completion', e);
    }
  }

  /// Schedule delayed alarm renewal to comply with Android 15+ restrictions
  static Future<void> _scheduleDelayedAlarmRenewal() async {
    try {
      // Cancel any existing alarm renewal task
      await Workmanager().cancelByUniqueName(_alarmRenewalTaskName);

      // Schedule one-time alarm renewal with delay
      await Workmanager().registerOneOffTask(
        _alarmRenewalTaskName,
        _alarmRenewalTaskName,
        initialDelay: Duration(minutes: _alarmRenewalDelayMinutes),
        constraints: Constraints(
          networkType: NetworkType.notRequired,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresDeviceIdle: false,
        ),
        existingWorkPolicy: ExistingWorkPolicy.replace,
        backoffPolicy: BackoffPolicy.exponential,
        backoffPolicyDelay: Duration(minutes: 5),
      );

      AppLogger.info(
          '🔄 Scheduled delayed alarm renewal in $_alarmRenewalDelayMinutes minutes');
    } catch (e) {
      AppLogger.error('❌ Failed to schedule delayed alarm renewal', e);
    }
  }

  /// Perform alarm renewal check - safely restores alarms after boot
  static Future<void> _performAlarmRenewalCheck() async {
    try {
      AppLogger.info('🚨 Performing automated alarm renewal check');

      final prefs = await SharedPreferences.getInstance();
      final lastAlarmRenewal = prefs.getString(_lastAlarmRenewalKey);
      final now = DateTime.now();

      // Check if alarm renewal is needed
      bool needsAlarmRenewal = false;
      if (lastAlarmRenewal == null) {
        needsAlarmRenewal = true;
        AppLogger.info(
            'No previous alarm renewal found, performing alarm restoration');
      } else {
        try {
          final lastRenewalTime = DateTime.parse(lastAlarmRenewal);
          final hoursSinceAlarmRenewal =
              now.difference(lastRenewalTime).inHours;
          if (hoursSinceAlarmRenewal >= 24) {
            needsAlarmRenewal = true;
            AppLogger.info(
                '$hoursSinceAlarmRenewal hours since last alarm renewal, renewal needed');
          }
        } catch (e) {
          needsAlarmRenewal = true;
          AppLogger.warning(
              'Invalid alarm renewal date format, forcing renewal');
        }
      }

      if (needsAlarmRenewal) {
        await _performAutomatedAlarmRenewal();

        // Update timestamp
        await prefs.setString(_lastAlarmRenewalKey, now.toIso8601String());
        AppLogger.info('✅ Automated alarm renewal completed');
      } else {
        AppLogger.info('⏭️ Alarm renewal not needed at this time');
      }
    } catch (e) {
      AppLogger.error('❌ Error during alarm renewal check', e);
    }
  }

  /// Perform automated alarm renewal for all habits with alarms enabled
  static Future<void> _performAutomatedAlarmRenewal() async {
    try {
      AppLogger.info(
          '🚨 Starting automated alarm renewal for all alarm-enabled habits');

      // Get all active habits
      final isar = await IsarDatabaseService.getInstance();
      final habitService = HabitServiceIsar(isar);
      final habits = await habitService.getAllHabits();

      // Filter to only habits with alarms enabled
      final alarmHabits =
          habits.where((h) => h.isActive && h.alarmEnabled).toList();

      AppLogger.info(
          '🚨 Found ${alarmHabits.length} alarm-enabled habits to renew');

      int renewedCount = 0;
      int errorCount = 0;

      for (final habit in alarmHabits) {
        try {
          // Use NotificationService to schedule alarms directly
          await NotificationService.scheduleHabitAlarms(habit);
          renewedCount++;
          AppLogger.info('✅ Renewed alarms for habit: ${habit.name}');
        } catch (e) {
          errorCount++;
          AppLogger.error(
              '❌ Error renewing alarms for habit: ${habit.name}', e);
        }
      }

      AppLogger.info(
          '✅ Automated alarm renewal completed: $renewedCount renewed, $errorCount errors');
    } catch (e) {
      AppLogger.error('❌ Error during automated alarm renewal', e);
    }
  }

  /// Schedule continuous daily notifications (next 30 days)
  static Future<void> _scheduleDailyContinuous(dynamic habit) async {
    final notificationTime = habit.notificationTime;
    final now = DateTime.now();

    int scheduledCount = 0;

    for (int dayOffset = 0; dayOffset < 30; dayOffset++) {
      final targetDate = now.add(Duration(days: dayOffset));
      DateTime scheduledTime = DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
        notificationTime.hour,
        notificationTime.minute,
      );

      if (scheduledTime.isAfter(now)) {
        final id = NotificationService.generateSafeId(
            '${habit.id}_daily_${targetDate.day}_${targetDate.month}');

        await NotificationService.scheduleNotification(
          id: id,
          title: '🎯 ${habit.name}',
          body: 'Time to complete your daily habit! Keep your streak going.',
          scheduledTime: scheduledTime,
          payload: _createNotificationPayload(habit.id, 'daily'),
        );

        scheduledCount++;
      }
    }

    AppLogger.debug(
        '📅 Scheduled $scheduledCount daily notifications for ${habit.name}');
  }

  /// Schedule continuous weekly notifications (next 12 weeks)
  static Future<void> _scheduleWeeklyContinuous(dynamic habit) async {
    final selectedWeekdays = habit.selectedWeekdays;
    if (selectedWeekdays == null || selectedWeekdays.isEmpty) return;

    final notificationTime = habit.notificationTime;
    final now = DateTime.now();
    final endDate = now.add(const Duration(days: 84)); // 12 weeks

    int scheduledCount = 0;

    for (DateTime date = now;
        date.isBefore(endDate);
        date = date.add(const Duration(days: 1))) {
      if (selectedWeekdays.contains(date.weekday)) {
        DateTime scheduledTime = DateTime(
          date.year,
          date.month,
          date.day,
          notificationTime.hour,
          notificationTime.minute,
        );

        if (scheduledTime.isAfter(now)) {
          final id = NotificationService.generateSafeId(
              '${habit.id}_weekly_${date.weekday}_${date.day}_${date.month}');

          await NotificationService.scheduleNotification(
            id: id,
            title: '🎯 ${habit.name}',
            body:
                'Time to complete your weekly habit! Don\'t break your streak.',
            scheduledTime: scheduledTime,
            payload: _createNotificationPayload(habit.id, 'weekly'),
          );

          scheduledCount++;
        }
      }
    }

    AppLogger.debug(
        '📅 Scheduled $scheduledCount weekly notifications for ${habit.name}');
  }

  /// Schedule continuous monthly notifications (next 12 months)
  static Future<void> _scheduleMonthlyContinuous(dynamic habit) async {
    final selectedMonthDays = habit.selectedMonthDays;
    if (selectedMonthDays == null || selectedMonthDays.isEmpty) return;

    final notificationTime = habit.notificationTime;
    final now = DateTime.now();

    int scheduledCount = 0;

    for (int monthOffset = 0; monthOffset < 12; monthOffset++) {
      final targetMonth = DateTime(now.year, now.month + monthOffset, 1);
      final daysInMonth =
          DateTime(targetMonth.year, targetMonth.month + 1, 0).day;

      for (final monthDay in selectedMonthDays) {
        if (monthDay <= daysInMonth) {
          DateTime scheduledTime = DateTime(
            targetMonth.year,
            targetMonth.month,
            monthDay,
            notificationTime.hour,
            notificationTime.minute,
          );

          if (scheduledTime.isAfter(now)) {
            final id = NotificationService.generateSafeId(
                '${habit.id}_monthly_${targetMonth.month}_$monthDay');

            await NotificationService.scheduleNotification(
              id: id,
              title: '🎯 ${habit.name}',
              body: 'Time to complete your monthly habit! Stay consistent.',
              scheduledTime: scheduledTime,
              payload: _createNotificationPayload(habit.id, 'monthly'),
            );

            scheduledCount++;
          }
        }
      }
    }

    AppLogger.debug(
        '📅 Scheduled $scheduledCount monthly notifications for ${habit.name}');
  }

  /// Schedule continuous yearly notifications (next 5 years)
  static Future<void> _scheduleYearlyContinuous(dynamic habit) async {
    final selectedYearlyDates = habit.selectedYearlyDates;
    if (selectedYearlyDates == null || selectedYearlyDates.isEmpty) return;

    final notificationTime = habit.notificationTime;
    final now = DateTime.now();

    int scheduledCount = 0;

    for (int yearOffset = 0; yearOffset < 5; yearOffset++) {
      final targetYear = now.year + yearOffset;

      for (final dateStr in selectedYearlyDates) {
        try {
          final dateParts = dateStr.split('-');
          if (dateParts.length >= 2) {
            final month = int.parse(dateParts[0]);
            final day = int.parse(dateParts[1]);

            DateTime scheduledTime = DateTime(
              targetYear,
              month,
              day,
              notificationTime.hour,
              notificationTime.minute,
            );

            if (scheduledTime.isAfter(now)) {
              final id = NotificationService.generateSafeId(
                  '${habit.id}_yearly_${targetYear}_${month}_$day');

              await NotificationService.scheduleNotification(
                id: id,
                title: '🎯 ${habit.name}',
                body: 'Time to complete your yearly habit! Make it count.',
                scheduledTime: scheduledTime,
                payload: _createNotificationPayload(habit.id, 'yearly'),
              );

              scheduledCount++;
            }
          }
        } catch (e) {
          AppLogger.warning('Invalid yearly date format: $dateStr');
        }
      }
    }

    AppLogger.debug(
        '📅 Scheduled $scheduledCount yearly notifications for ${habit.name}');
  }

  /// Public method to schedule hourly notifications for a habit
  static Future<void> scheduleHourlyNotifications(dynamic habit) async {
    await _scheduleHourlyContinuous(habit);
  }

  /// Schedule continuous hourly notifications (next 48 hours)
  static Future<void> _scheduleHourlyContinuous(dynamic habit) async {
    final hourlyTimes = habit.hourlyTimes;
    if (hourlyTimes == null || hourlyTimes.isEmpty) return;

    final now = DateTime.now();
    final endTime = now.add(const Duration(hours: 48));

    // Check if weekdays are specified for this hourly habit
    final selectedWeekdays = habit.selectedWeekdays ?? <int>[];

    int scheduledCount = 0;

    for (final timeStr in hourlyTimes) {
      final timeParts = timeStr.split(':');
      if (timeParts.length != 2) continue;

      final hour = int.tryParse(timeParts[0]);
      final minute = int.tryParse(timeParts[1]);
      if (hour == null || minute == null) continue;

      for (DateTime date = now;
          date.isBefore(endTime);
          date = date.add(const Duration(days: 1))) {
        // Check if weekdays are specified and if this date matches
        if (selectedWeekdays.isNotEmpty &&
            !selectedWeekdays.contains(date.weekday)) {
          AppLogger.debug(
              'Skipping hourly notification for ${habit.name} - ${date.toString().split(' ')[0]} (weekday ${date.weekday}) is not in selected weekdays: $selectedWeekdays');
          continue; // Skip this day as it's not a selected weekday
        }

        DateTime scheduledTime =
            DateTime(date.year, date.month, date.day, hour, minute);

        if (scheduledTime.isAfter(now)) {
          final id = NotificationService.generateSafeId(
              '${habit.id}_hourly_${date.day}_${hour}_$minute');

          await NotificationService.scheduleNotification(
            id: id,
            title: '🎯 ${habit.name}',
            body: 'Time to complete your hourly habit! Stay on track.',
            scheduledTime: scheduledTime,
            payload: _createNotificationPayload(
                '${habit.id}|${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
                'hourly'),
          );

          scheduledCount++;
        }
      }
    }

    AppLogger.debug(
        '📅 Scheduled $scheduledCount hourly notifications for ${habit.name}');
  }

  /// Schedule single habit notifications (one-time notification)
  static Future<void> _scheduleSingleContinuous(dynamic habit) async {
    // Validate single habit requirements
    if (habit.singleDateTime == null) {
      final error =
          'Single habit "${habit.name}" requires a date/time to be set';
      AppLogger.error(error);
      throw ArgumentError(error);
    }

    final singleDateTime = habit.singleDateTime!;
    final now = DateTime.now();

    // Check if date/time is in the past
    if (singleDateTime.isBefore(now)) {
      final error =
          'Single habit "${habit.name}" date/time is in the past: $singleDateTime';
      AppLogger.error(error);
      throw StateError(error);
    }

    try {
      final id = NotificationService.generateSafeId(
          '${habit.id}_single_${singleDateTime.millisecondsSinceEpoch}');

      await NotificationService.scheduleNotification(
        id: id,
        title: '🎯 ${habit.name}',
        body: 'Time to complete your one-time habit!',
        scheduledTime: singleDateTime,
        payload: _createNotificationPayload(habit.id, 'single'),
      );

      AppLogger.info(
          '✅ Scheduled single notification for "${habit.name}" at $singleDateTime');
    } catch (e) {
      final error =
          'Failed to schedule single habit notification for "${habit.name}": $e';
      AppLogger.error(error);
      throw Exception(error);
    }
  }

  /// Schedule notifications using RRule (new unified approach)
  /// This replaces the separate daily/weekly/monthly scheduling methods for RRule-based habits
  static Future<void> _scheduleRRuleContinuous(dynamic habit) async {
    if (habit.rruleString == null) {
      AppLogger.error('Habit ${habit.name} has no RRule string');
      return;
    }

    final notificationTime = habit.notificationTime;
    if (notificationTime == null) {
      AppLogger.warning('Habit ${habit.name} has no notification time set');
      return;
    }

    final now = DateTime.now();
    // Use frequency-aware scheduling window for optimal coverage
    final frequency = habit.frequency.toString().split('.').last;
    final endDate = switch (frequency) {
      'yearly' =>
        now.add(const Duration(days: 730)), // 2 years for yearly habits
      'monthly' =>
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

      for (final occurrence in occurrences) {
        // Combine occurrence date with notification time
        DateTime scheduledTime = DateTime(
          occurrence.year,
          occurrence.month,
          occurrence.day,
          notificationTime.hour,
          notificationTime.minute,
        );

        if (scheduledTime.isAfter(now)) {
          final id = NotificationService.generateSafeId(
              '${habit.id}_rrule_${occurrence.year}_${occurrence.month}_${occurrence.day}');

          await NotificationService.scheduleNotification(
            id: id,
            title: '🎯 ${habit.name}',
            body: 'Time to complete your habit! Don\'t break your streak.',
            scheduledTime: scheduledTime,
            payload: _createNotificationPayload(habit.id, 'rrule'),
          );

          scheduledCount++;
        }
      }

      AppLogger.debug(
          '📅 Scheduled $scheduledCount RRule notifications for ${habit.name}');
    } catch (e) {
      AppLogger.error(
          'Failed to schedule RRule notifications for ${habit.name}: $e');
    }
  }

  /// Create notification payload
  static String _createNotificationPayload(String habitId, String frequency) {
    return 'habit_$habitId|$frequency';
  }

  /// Force a manual renewal (useful for testing or user-triggered renewal)
  static Future<void> forceRenewal({String? specificHabitId}) async {
    AppLogger.info(
        '🔄 Force renewal requested${specificHabitId != null ? ' for habit ID: $specificHabitId' : ''}');

    await _performHabitContinuationRenewal(
      forceRenewal: true,
      specificHabitId: specificHabitId,
    );

    // Update the last renewal timestamp
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastRenewalKey, DateTime.now().toIso8601String());
  }

  /// Force immediate renewal of all habits (for debugging/testing)
  static Future<void> forceImmediateRenewal() async {
    AppLogger.info('🔄 Force immediate renewal of all habits requested');

    try {
      // Cancel the existing periodic task temporarily
      await Workmanager().cancelByUniqueName(_renewalTaskName);

      // Perform immediate renewal
      await _performHabitContinuationRenewal(forceRenewal: true);

      // Update the last renewal timestamp
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastRenewalKey, DateTime.now().toIso8601String());

      // Reschedule the periodic task
      await _schedulePeriodicRenewalTask();

      AppLogger.info('✅ Force immediate renewal completed successfully');
    } catch (e) {
      AppLogger.error('❌ Error during force immediate renewal', e);
      rethrow;
    }
  }

  /// Set custom renewal interval
  static Future<void> setRenewalInterval(int hours) async {
    if (hours < 1 || hours > 24) {
      throw ArgumentError('Renewal interval must be between 1 and 24 hours');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_renewalIntervalKey, hours);

    // Reschedule periodic task with new interval
    if (_isInitialized) {
      await _schedulePeriodicRenewalTask();
    }

    AppLogger.info('🔄 Renewal interval set to $hours hours');
  }

  /// Stop the continuation service
  static Future<void> stop() async {
    try {
      await Workmanager().cancelByUniqueName(_renewalTaskName);
      _isInitialized = false;
      AppLogger.info('🔄 WorkManager Habit Service stopped');
    } catch (e) {
      AppLogger.error('❌ Error stopping WorkManager Habit Service', e);
    }
  }

  /// Restart the continuation service
  static Future<void> restart() async {
    await stop();
    await initialize();
  }
}
