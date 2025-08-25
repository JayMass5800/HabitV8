import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/model/habit.dart';
import '../data/database.dart';
import 'notification_service.dart';
import 'hybrid_alarm_service.dart';
import 'logging_service.dart';

/// Service responsible for ensuring habits continue to work indefinitely
/// Handles automatic renewal of notifications and alarms for all habit frequencies
class HabitContinuationService {
  static Timer? _renewalTimer;
  static bool _isInitialized = false;
  static const String _lastRenewalKey = 'last_habit_continuation_renewal';
  static const String _renewalIntervalKey = 'habit_continuation_interval_hours';

  // Default renewal every 12 hours to ensure notifications don't expire
  static const int _defaultRenewalIntervalHours = 12;

  /// Initialize the habit continuation service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('🔄 Initializing Habit Continuation Service');

      // Start the renewal timer
      await _startRenewalTimer();

      // Perform initial renewal check
      await _performRenewalCheck();

      _isInitialized = true;
      AppLogger.info('✅ Habit Continuation Service initialized successfully');
    } catch (e) {
      AppLogger.error('❌ Failed to initialize Habit Continuation Service', e);
    }
  }

  /// Start the automatic renewal timer
  static Future<void> _startRenewalTimer() async {
    // Cancel existing timer if any
    _renewalTimer?.cancel();

    // Get renewal interval from preferences
    final prefs = await SharedPreferences.getInstance();
    final intervalHours =
        prefs.getInt(_renewalIntervalKey) ?? _defaultRenewalIntervalHours;

    // Check for renewal at specified interval
    _renewalTimer =
        Timer.periodic(Duration(hours: intervalHours), (timer) async {
      await _performRenewalCheck();
    });

    AppLogger.info(
        '🔄 Habit continuation timer started (interval: ${intervalHours}h)');
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
          AppLogger.debug(
              '$hoursSinceRenewal hours since last renewal, no renewal needed yet');
        }
      }

      if (needsRenewal) {
        await _performHabitContinuationRenewal();

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
  static Future<void> _performHabitContinuationRenewal() async {
    try {
      AppLogger.info('🔄 Starting habit continuation renewal process');

      // Get all active habits
      final habitBox = await DatabaseService.getInstance();
      final habitService = HabitService(habitBox);
      final habits = await habitService.getAllHabits();
      final activeHabits = habits.where((habit) => habit.isActive).toList();

      AppLogger.info(
          '🔄 Renewing continuation for ${activeHabits.length} active habits');

      int renewedCount = 0;
      int errorCount = 0;

      for (final habit in activeHabits) {
        try {
          if (habit.notificationsEnabled || habit.alarmEnabled) {
            await _renewHabitContinuation(habit);
            renewedCount++;
            AppLogger.debug('✅ Renewed continuation for habit: ${habit.name}');
          }
        } catch (e) {
          errorCount++;
          AppLogger.error('❌ Error renewing habit "${habit.name}"', e);
        }
      }

      AppLogger.info(
          '✅ Habit continuation renewal completed: $renewedCount renewed, $errorCount errors');
    } catch (e) {
      AppLogger.error('❌ Error during habit continuation renewal', e);
    }
  }

  /// Renew continuation for a single habit
  static Future<void> _renewHabitContinuation(Habit habit) async {
    try {
      AppLogger.debug('🔄 Renewing continuation for habit: ${habit.name}');

      if (habit.alarmEnabled) {
        await _renewHabitAlarms(habit);
      } else if (habit.notificationsEnabled) {
        await _renewHabitNotifications(habit);
      }

      AppLogger.debug(
          '✅ Successfully renewed continuation for habit: ${habit.name}');
    } catch (e) {
      AppLogger.error(
          '❌ Error renewing continuation for habit "${habit.name}"', e);
      rethrow;
    }
  }

  /// Renew notifications for a habit based on its frequency
  static Future<void> _renewHabitNotifications(Habit habit) async {
    try {
      AppLogger.debug('🔔 Renewing notifications for habit: ${habit.name}');

      // Cancel existing notifications first
      await NotificationService.cancelHabitNotifications(
        NotificationService.generateSafeId(habit.id),
      );

      // Schedule new notifications based on frequency
      switch (habit.frequency) {
        case HabitFrequency.hourly:
          await _scheduleHourlyNotificationsContinuous(habit);
          break;
        case HabitFrequency.daily:
          await _scheduleDailyNotificationsContinuous(habit);
          break;
        case HabitFrequency.weekly:
          await _scheduleWeeklyNotificationsContinuous(habit);
          break;
        case HabitFrequency.monthly:
          await _scheduleMonthlyNotificationsContinuous(habit);
          break;
        case HabitFrequency.yearly:
          await _scheduleYearlyNotificationsContinuous(habit);
          break;
      }

      AppLogger.debug('✅ Renewed notifications for habit: ${habit.name}');
    } catch (e) {
      AppLogger.error(
          '❌ Error renewing notifications for habit "${habit.name}"', e);
      rethrow;
    }
  }

  /// Renew alarms for a habit based on its frequency
  static Future<void> _renewHabitAlarms(Habit habit) async {
    try {
      AppLogger.debug('🚨 Renewing alarms for habit: ${habit.name}');

      // Cancel existing alarms first
      await HybridAlarmService.cancelHabitAlarms(habit.id);

      // Schedule new alarms based on frequency with extended duration
      switch (habit.frequency) {
        case HabitFrequency.hourly:
          await _scheduleHourlyAlarmsContinuous(habit);
          break;
        case HabitFrequency.daily:
          await _scheduleDailyAlarmsContinuous(habit);
          break;
        case HabitFrequency.weekly:
          await _scheduleWeeklyAlarmsContinuous(habit);
          break;
        case HabitFrequency.monthly:
          await _scheduleMonthlyAlarmsContinuous(habit);
          break;
        case HabitFrequency.yearly:
          await _scheduleYearlyAlarmsContinuous(habit);
          break;
      }

      AppLogger.debug('✅ Renewed alarms for habit: ${habit.name}');
    } catch (e) {
      AppLogger.error('❌ Error renewing alarms for habit "${habit.name}"', e);
      rethrow;
    }
  }

  // ========== CONTINUOUS NOTIFICATION SCHEDULING METHODS ==========

  /// Schedule continuous hourly notifications (next 48 hours)
  static Future<void> _scheduleHourlyNotificationsContinuous(
      Habit habit) async {
    final hourlyTimes = habit.hourlyTimes;
    if (hourlyTimes.isEmpty) return;

    final now = DateTime.now();
    final endTime =
        now.add(const Duration(hours: 48)); // Schedule for next 48 hours

    int scheduledCount = 0;

    for (final timeStr in hourlyTimes) {
      final timeParts = timeStr.split(':');
      if (timeParts.length != 2) continue;

      final hour = int.tryParse(timeParts[0]);
      final minute = int.tryParse(timeParts[1]);
      if (hour == null || minute == null) continue;

      // Schedule for each day in the next 48 hours
      for (DateTime date = now;
          date.isBefore(endTime);
          date = date.add(const Duration(days: 1))) {
        DateTime notificationTime =
            DateTime(date.year, date.month, date.day, hour, minute);

        // Only schedule future notifications
        if (notificationTime.isAfter(now)) {
          final id = NotificationService.generateSafeId(
              '${habit.id}_hourly_${date.day}_$hour_$minute');

          await NotificationService.scheduleNotification(
            id: id,
            title: '⏰ ${habit.name}',
            body: 'Time for your hourly habit!',
            scheduledTime: notificationTime,
            payload: _createNotificationPayload(habit.id, 'hourly'),
          );

          scheduledCount++;
        }
      }
    }

    AppLogger.debug(
        '📅 Scheduled $scheduledCount hourly notifications for ${habit.name}');
  }

  /// Schedule continuous daily notifications (next 30 days)
  static Future<void> _scheduleDailyNotificationsContinuous(Habit habit) async {
    if (habit.notificationTime == null) return;

    final notificationTime = habit.notificationTime!;
    final now = DateTime.now();
    final endDate =
        now.add(const Duration(days: 30)); // Schedule for next 30 days

    int scheduledCount = 0;

    for (DateTime date = now;
        date.isBefore(endDate);
        date = date.add(const Duration(days: 1))) {
      DateTime scheduledTime = DateTime(
        date.year,
        date.month,
        date.day,
        notificationTime.hour,
        notificationTime.minute,
      );

      // Only schedule future notifications
      if (scheduledTime.isAfter(now)) {
        final id = NotificationService.generateSafeId(
            '${habit.id}_daily_${date.day}_${date.month}');

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
  static Future<void> _scheduleWeeklyNotificationsContinuous(
      Habit habit) async {
    final selectedWeekdays = habit.selectedWeekdays;
    if (selectedWeekdays.isEmpty || habit.notificationTime == null) return;

    final notificationTime = habit.notificationTime!;
    final now = DateTime.now();
    final endDate =
        now.add(const Duration(days: 84)); // Schedule for next 12 weeks

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

        // Only schedule future notifications
        if (scheduledTime.isAfter(now)) {
          final id = NotificationService.generateSafeId(
              '${habit.id}_weekly_${date.day}_${date.month}_${date.weekday}');

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
  static Future<void> _scheduleMonthlyNotificationsContinuous(
      Habit habit) async {
    final selectedMonthDays = habit.selectedMonthDays;
    if (selectedMonthDays.isEmpty || habit.notificationTime == null) return;

    final notificationTime = habit.notificationTime!;
    final now = DateTime.now();

    int scheduledCount = 0;

    // Schedule for next 12 months
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

          // Only schedule future notifications
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
  static Future<void> _scheduleYearlyNotificationsContinuous(
      Habit habit) async {
    final selectedYearlyDates = habit.selectedYearlyDates;
    if (selectedYearlyDates.isEmpty || habit.notificationTime == null) return;

    final notificationTime = habit.notificationTime!;
    final now = DateTime.now();

    int scheduledCount = 0;

    // Schedule for next 5 years
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

            // Only schedule future notifications
            if (scheduledTime.isAfter(now)) {
              final id = NotificationService.generateSafeId(
                  '${habit.id}_yearly_${targetYear}_$month_$day');

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

  // ========== CONTINUOUS ALARM SCHEDULING METHODS ==========

  /// Schedule continuous hourly alarms (next 48 hours)
  static Future<void> _scheduleHourlyAlarmsContinuous(Habit habit) async {
    final hourlyTimes = habit.hourlyTimes;
    if (hourlyTimes.isEmpty) return;

    final now = DateTime.now();
    final endTime = now.add(const Duration(hours: 48));

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
        DateTime alarmTime =
            DateTime(date.year, date.month, date.day, hour, minute);

        if (alarmTime.isAfter(now)) {
          final alarmId = HybridAlarmService.generateHabitAlarmId(
            habit.id,
            suffix: 'hourly_${date.day}_${hour}_${minute}',
          );

          await HybridAlarmService.scheduleExactAlarm(
            alarmId: alarmId,
            habitId: habit.id,
            habitName: habit.name,
            scheduledTime: alarmTime,
            frequency: 'hourly',
            alarmSoundName: habit.alarmSoundName,
            snoozeDelayMinutes: habit.snoozeDelayMinutes,
          );

          scheduledCount++;
        }
      }
    }

    AppLogger.debug(
        '⏰ Scheduled $scheduledCount hourly alarms for ${habit.name}');
  }

  /// Schedule continuous daily alarms (next 30 days)
  static Future<void> _scheduleDailyAlarmsContinuous(Habit habit) async {
    if (habit.notificationTime == null) return;

    final notificationTime = habit.notificationTime!;
    final now = DateTime.now();

    int scheduledCount = 0;

    for (int dayOffset = 0; dayOffset < 30; dayOffset++) {
      final targetDate = now.add(Duration(days: dayOffset));
      DateTime alarmTime = DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
        notificationTime.hour,
        notificationTime.minute,
      );

      if (alarmTime.isAfter(now)) {
        final alarmId = HybridAlarmService.generateHabitAlarmId(
          habit.id,
          suffix: 'daily_${targetDate.day}_${targetDate.month}',
        );

        await HybridAlarmService.scheduleExactAlarm(
          alarmId: alarmId,
          habitId: habit.id,
          habitName: habit.name,
          scheduledTime: alarmTime,
          frequency: 'daily',
          alarmSoundName: habit.alarmSoundName,
          snoozeDelayMinutes: habit.snoozeDelayMinutes,
        );

        scheduledCount++;
      }
    }

    AppLogger.debug(
        '⏰ Scheduled $scheduledCount daily alarms for ${habit.name}');
  }

  /// Schedule continuous weekly alarms (next 12 weeks)
  static Future<void> _scheduleWeeklyAlarmsContinuous(Habit habit) async {
    final selectedWeekdays = habit.selectedWeekdays;
    if (selectedWeekdays.isEmpty || habit.notificationTime == null) return;

    final notificationTime = habit.notificationTime!;
    final now = DateTime.now();
    final endDate = now.add(const Duration(days: 84));

    int scheduledCount = 0;

    for (DateTime date = now;
        date.isBefore(endDate);
        date = date.add(const Duration(days: 1))) {
      if (selectedWeekdays.contains(date.weekday)) {
        DateTime alarmTime = DateTime(
          date.year,
          date.month,
          date.day,
          notificationTime.hour,
          notificationTime.minute,
        );

        if (alarmTime.isAfter(now)) {
          final alarmId = HybridAlarmService.generateHabitAlarmId(
            habit.id,
            suffix: 'weekly_${date.day}_${date.month}_${date.weekday}',
          );

          await HybridAlarmService.scheduleExactAlarm(
            alarmId: alarmId,
            habitId: habit.id,
            habitName: habit.name,
            scheduledTime: alarmTime,
            frequency: 'weekly',
            alarmSoundName: habit.alarmSoundName,
            snoozeDelayMinutes: habit.snoozeDelayMinutes,
          );

          scheduledCount++;
        }
      }
    }

    AppLogger.debug(
        '⏰ Scheduled $scheduledCount weekly alarms for ${habit.name}');
  }

  /// Schedule continuous monthly alarms (next 12 months)
  static Future<void> _scheduleMonthlyAlarmsContinuous(Habit habit) async {
    final selectedMonthDays = habit.selectedMonthDays;
    if (selectedMonthDays.isEmpty || habit.notificationTime == null) return;

    final notificationTime = habit.notificationTime!;
    final now = DateTime.now();

    int scheduledCount = 0;

    for (int monthOffset = 0; monthOffset < 12; monthOffset++) {
      final targetMonth = DateTime(now.year, now.month + monthOffset, 1);
      final daysInMonth =
          DateTime(targetMonth.year, targetMonth.month + 1, 0).day;

      for (final monthDay in selectedMonthDays) {
        if (monthDay <= daysInMonth) {
          DateTime alarmTime = DateTime(
            targetMonth.year,
            targetMonth.month,
            monthDay,
            notificationTime.hour,
            notificationTime.minute,
          );

          if (alarmTime.isAfter(now)) {
            final alarmId = HybridAlarmService.generateHabitAlarmId(
              habit.id,
              suffix: 'monthly_${targetMonth.month}_$monthDay',
            );

            await HybridAlarmService.scheduleExactAlarm(
              alarmId: alarmId,
              habitId: habit.id,
              habitName: habit.name,
              scheduledTime: alarmTime,
              frequency: 'monthly',
              alarmSoundName: habit.alarmSoundName,
              snoozeDelayMinutes: habit.snoozeDelayMinutes,
            );

            scheduledCount++;
          }
        }
      }
    }

    AppLogger.debug(
        '⏰ Scheduled $scheduledCount monthly alarms for ${habit.name}');
  }

  /// Schedule continuous yearly alarms (next 5 years)
  static Future<void> _scheduleYearlyAlarmsContinuous(Habit habit) async {
    final selectedYearlyDates = habit.selectedYearlyDates;
    if (selectedYearlyDates.isEmpty || habit.notificationTime == null) return;

    final notificationTime = habit.notificationTime!;
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

            DateTime alarmTime = DateTime(
              targetYear,
              month,
              day,
              notificationTime.hour,
              notificationTime.minute,
            );

            if (alarmTime.isAfter(now)) {
              final alarmId = HybridAlarmService.generateHabitAlarmId(
                habit.id,
                suffix: 'yearly_${targetYear}_${month}_${day}',
              );

              await HybridAlarmService.scheduleExactAlarm(
                alarmId: alarmId,
                habitId: habit.id,
                habitName: habit.name,
                scheduledTime: alarmTime,
                frequency: 'yearly',
                alarmSoundName: habit.alarmSoundName,
                snoozeDelayMinutes: habit.snoozeDelayMinutes,
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
        '⏰ Scheduled $scheduledCount yearly alarms for ${habit.name}');
  }

  // ========== UTILITY METHODS ==========

  /// Create notification payload for habit
  static String _createNotificationPayload(String habitId, String frequency) {
    return '{"habitId":"$habitId","type":"habit_reminder","frequency":"$frequency"}';
  }

  /// Force a manual renewal (useful for testing or user-triggered renewal)
  static Future<void> forceRenewal() async {
    AppLogger.info('🔄 Force renewal requested');
    await _performHabitContinuationRenewal();

    // Update the last renewal timestamp
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastRenewalKey, DateTime.now().toIso8601String());
  }

  /// Set custom renewal interval
  static Future<void> setRenewalInterval(int hours) async {
    if (hours < 1 || hours > 24) {
      throw ArgumentError('Renewal interval must be between 1 and 24 hours');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_renewalIntervalKey, hours);

    // Restart timer with new interval
    if (_isInitialized) {
      await _startRenewalTimer();
    }

    AppLogger.info('🔄 Renewal interval set to $hours hours');
  }

  /// Get renewal status information
  static Future<Map<String, dynamic>> getRenewalStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastRenewalStr = prefs.getString(_lastRenewalKey);
      final intervalHours =
          prefs.getInt(_renewalIntervalKey) ?? _defaultRenewalIntervalHours;

      DateTime? lastRenewal;
      if (lastRenewalStr != null) {
        try {
          lastRenewal = DateTime.parse(lastRenewalStr);
        } catch (e) {
          // Invalid date format
        }
      }

      final now = DateTime.now();
      final hoursSinceRenewal =
          lastRenewal != null ? now.difference(lastRenewal).inHours : null;
      final nextRenewal = lastRenewal?.add(Duration(hours: intervalHours));

      return {
        'isActive': _isInitialized && _renewalTimer != null,
        'lastRenewal': lastRenewal?.toIso8601String(),
        'hoursSinceRenewal': hoursSinceRenewal,
        'nextRenewal': nextRenewal?.toIso8601String(),
        'renewalIntervalHours': intervalHours,
        'needsRenewal': hoursSinceRenewal == null || hoursSinceRenewal >= 6,
      };
    } catch (e) {
      AppLogger.error('Error getting renewal status', e);
      return {
        'isActive': false,
        'error': e.toString(),
      };
    }
  }

  /// Stop the continuation service
  static void stop() {
    _renewalTimer?.cancel();
    _renewalTimer = null;
    _isInitialized = false;
    AppLogger.info('🔄 Habit Continuation Service stopped');
  }

  /// Restart the continuation service
  static Future<void> restart() async {
    stop();
    await initialize();
  }
}
