import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'logging_service.dart';

/// A hybrid alarm service that combines the reliability of the alarm package
/// with the flexibility of flutter_local_notifications
class HybridAlarmService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;
  static const String _alarmDataKey = 'hybrid_alarm_data_';

  /// Initialize the hybrid alarm service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize notifications plugin
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);

      await _notificationsPlugin.initialize(initializationSettings);

      // Initialize alarm plugin
      await Alarm.init();

      AppLogger.info('🔄 HybridAlarmService initialized successfully');
      _isInitialized = true;
    } catch (e) {
      AppLogger.error('Failed to initialize HybridAlarmService', e);
      rethrow;
    }
  }

  /// Schedule an exact alarm for a habit
  static Future<void> scheduleExactAlarm({
    required int alarmId,
    required String habitId,
    required String habitName,
    required DateTime scheduledTime,
    required String frequency,
    String? alarmSoundName,
    int snoozeDelayMinutes = 10,
    Map<String, dynamic>? additionalData,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Store alarm data for the callback
    final alarmData = {
      'habitId': habitId,
      'habitName': habitName,
      'alarmSoundName': alarmSoundName ?? 'default',
      'snoozeDelayMinutes': snoozeDelayMinutes,
      'frequency': frequency,
      'scheduledTime': scheduledTime.toIso8601String(),
      'additionalData': additionalData ?? {},
    };

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${_alarmDataKey}_$alarmId', jsonEncode(alarmData));

    AppLogger.info('🔄 Scheduling exact alarm:');
    AppLogger.info('  - Alarm ID: $alarmId');
    AppLogger.info('  - Habit: $habitName');
    AppLogger.info('  - Scheduled time: $scheduledTime');
    AppLogger.info('  - Sound: $alarmSoundName');

    try {
      // Use the alarm package for exact alarms
      final alarmSettings = AlarmSettings(
        id: alarmId,
        dateTime: scheduledTime,
        assetAudioPath: _getAlarmSoundPath(alarmSoundName),
        loopAudio: true,
        vibrate: true,
        notificationSettings: NotificationSettings(
          title: '🚨 HABIT ALARM: $habitName',
          body: 'Time to complete your habit!',
          stopButton: 'Stop Alarm',
        ),
        volumeSettings: VolumeSettings.fade(
          volume: 1.0,
          fadeDuration: Duration(seconds: 3),
        ),
        warningNotificationOnKill: true,
        androidFullScreenIntent: true,
      );

      await Alarm.set(alarmSettings: alarmSettings);

      AppLogger.info('✅ Exact alarm scheduled successfully');
    } catch (e) {
      AppLogger.error('❌ Failed to schedule exact alarm', e);

      // Fallback to notification if alarm fails
      await _scheduleNotificationAlarm(
        alarmId: alarmId,
        habitName: habitName,
        scheduledTime: scheduledTime,
        alarmSoundName: alarmSoundName,
        snoozeDelayMinutes: snoozeDelayMinutes,
      );
    }
  }

  /// Schedule hourly habit alarms
  static Future<void> scheduleHourlyHabitAlarms(dynamic habit) async {
    if (habit.hourlyTimes == null || habit.hourlyTimes.isEmpty) return;

    final now = DateTime.now();

    // Schedule for the next 24 hours
    for (int dayOffset = 0; dayOffset < 2; dayOffset++) {
      final targetDate = now.add(Duration(days: dayOffset));

      for (final timeStr in habit.hourlyTimes) {
        try {
          final parts = timeStr.split(':');
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);

          DateTime alarmTime = DateTime(
            targetDate.year,
            targetDate.month,
            targetDate.day,
            hour,
            minute,
          );

          if (alarmTime.isAfter(now)) {
            final alarmId = generateHabitAlarmId(
              habit.id,
              suffix: 'hourly___',
            );

            await scheduleExactAlarm(
              alarmId: alarmId,
              habitId: habit.id,
              habitName: habit.name,
              scheduledTime: alarmTime,
              frequency: 'hourly',
              alarmSoundName: habit.alarmSoundName,
              snoozeDelayMinutes: habit.snoozeDelayMinutes ?? 10,
            );
          }
        } catch (e) {
          AppLogger.warning('Invalid hourly time format: $timeStr');
        }
      }
    }

    AppLogger.debug('⏰ Scheduled hourly alarms for ${habit.name}');
  }

  /// Schedule daily habit alarms
  static Future<void> scheduleDailyHabitAlarms(dynamic habit) async {
    if (habit.notificationTime == null) return;

    final alarmTime = habit.notificationTime;
    final now = DateTime.now();

    // Schedule for the next 7 days
    for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
      final targetDate = now.add(Duration(days: dayOffset));

      DateTime scheduledTime = DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
        alarmTime.hour,
        alarmTime.minute,
      );

      if (scheduledTime.isAfter(now)) {
        final alarmId = generateHabitAlarmId(
          habit.id,
          suffix: 'daily__',
        );

        await scheduleExactAlarm(
          alarmId: alarmId,
          habitId: habit.id,
          habitName: habit.name,
          scheduledTime: scheduledTime,
          frequency: 'daily',
          alarmSoundName: habit.alarmSoundName,
          snoozeDelayMinutes: habit.snoozeDelayMinutes ?? 10,
        );
      }
    }

    AppLogger.debug('⏰ Scheduled daily alarms for ${habit.name}');
  }

  /// Schedule weekly habit alarms
  static Future<void> scheduleWeeklyHabitAlarms(dynamic habit) async {
    final selectedWeekdays = habit.selectedWeekdays;
    if (selectedWeekdays == null ||
        selectedWeekdays.isEmpty ||
        habit.notificationTime == null) {
      return;
    }

    final alarmTime = habit.notificationTime;
    final now = DateTime.now();
    final endDate = now.add(Duration(days: 28)); // 4 weeks

    for (DateTime date = now;
        date.isBefore(endDate);
        date = date.add(const Duration(days: 1))) {
      if (selectedWeekdays.contains(date.weekday)) {
        DateTime scheduledTime = DateTime(
          date.year,
          date.month,
          date.day,
          alarmTime.hour,
          alarmTime.minute,
        );

        if (scheduledTime.isAfter(now)) {
          final alarmId = generateHabitAlarmId(
            habit.id,
            suffix: 'weekly___',
          );

          await scheduleExactAlarm(
            alarmId: alarmId,
            habitId: habit.id,
            habitName: habit.name,
            scheduledTime: scheduledTime,
            frequency: 'weekly',
            alarmSoundName: habit.alarmSoundName,
            snoozeDelayMinutes: habit.snoozeDelayMinutes ?? 10,
          );
        }
      }
    }

    AppLogger.debug('⏰ Scheduled weekly alarms for ${habit.name}');
  }

  /// Schedule monthly habit alarms
  static Future<void> scheduleMonthlyHabitAlarms(dynamic habit) async {
    final selectedMonthDays = habit.selectedMonthDays;
    if (selectedMonthDays == null ||
        selectedMonthDays.isEmpty ||
        habit.notificationTime == null) {
      return;
    }

    final alarmTime = habit.notificationTime;
    final now = DateTime.now();

    for (int monthOffset = 0; monthOffset < 3; monthOffset++) {
      final targetMonth = DateTime(now.year, now.month + monthOffset, 1);
      final daysInMonth =
          DateTime(targetMonth.year, targetMonth.month + 1, 0).day;

      for (final monthDay in selectedMonthDays) {
        if (monthDay <= daysInMonth) {
          DateTime scheduledTime = DateTime(
            targetMonth.year,
            targetMonth.month,
            monthDay,
            alarmTime.hour,
            alarmTime.minute,
          );

          if (scheduledTime.isAfter(now)) {
            final alarmId = generateHabitAlarmId(
              habit.id,
              suffix: 'monthly__',
            );

            await scheduleExactAlarm(
              alarmId: alarmId,
              habitId: habit.id,
              habitName: habit.name,
              scheduledTime: scheduledTime,
              frequency: 'monthly',
              alarmSoundName: habit.alarmSoundName,
              snoozeDelayMinutes: habit.snoozeDelayMinutes ?? 10,
            );
          }
        }
      }
    }

    AppLogger.debug('⏰ Scheduled monthly alarms for ${habit.name}');
  }

  /// Schedule yearly habit alarms
  static Future<void> scheduleYearlyHabitAlarms(dynamic habit) async {
    final selectedYearlyDates = habit.selectedYearlyDates;
    if (selectedYearlyDates == null ||
        selectedYearlyDates.isEmpty ||
        habit.notificationTime == null) {
      return;
    }

    final alarmTime = habit.notificationTime;
    final now = DateTime.now();

    for (int yearOffset = 0; yearOffset < 2; yearOffset++) {
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
              alarmTime.hour,
              alarmTime.minute,
            );

            if (scheduledTime.isAfter(now)) {
              final alarmId = generateHabitAlarmId(
                habit.id,
                suffix: 'yearly___',
              );

              await scheduleExactAlarm(
                alarmId: alarmId,
                habitId: habit.id,
                habitName: habit.name,
                scheduledTime: scheduledTime,
                frequency: 'yearly',
                alarmSoundName: habit.alarmSoundName,
                snoozeDelayMinutes: habit.snoozeDelayMinutes ?? 10,
              );
            }
          }
        } catch (e) {
          AppLogger.warning('Invalid yearly date format: $dateStr');
        }
      }
    }

    AppLogger.debug('⏰ Scheduled yearly alarms for ${habit.name}');
  }

  /// Cancel an alarm
  static Future<void> cancelAlarm(int alarmId) async {
    try {
      // Cancel the alarm
      await Alarm.stop(alarmId);

      // Cancel the notification
      await _notificationsPlugin.cancel(alarmId);

      // Clean up stored alarm data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('');

      AppLogger.info('🔄 Cancelled alarm ID: ');
    } catch (e) {
      AppLogger.error('❌ Failed to cancel alarm ', e);
    }
  }

  /// Cancel all alarms for a habit
  static Future<void> cancelHabitAlarms(
    String habitId, {
    int maxAlarms = 100,
  }) async {
    AppLogger.info('🔄 Cancelling all alarms for habit: ');

    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    for (String key in keys) {
      if (key.startsWith(_alarmDataKey)) {
        try {
          final alarmDataJson = prefs.getString(key);
          if (alarmDataJson != null) {
            final alarmData = jsonDecode(alarmDataJson);
            if (alarmData['habitId'] == habitId) {
              final alarmId = int.tryParse(key.substring(_alarmDataKey.length));
              if (alarmId != null) {
                await Alarm.stop(alarmId);
                await _notificationsPlugin.cancel(alarmId);
                await prefs.remove(key);
              }
            }
          }
        } catch (e) {
          AppLogger.error('Error processing alarm data for key $key', e);
        }
      }
    }

    AppLogger.info('✅ Cancelled alarms for habit');
  }

  /// Generate unique alarm ID for habit
  static int generateHabitAlarmId(String habitId, {String? suffix}) {
    int hash = 0;
    final fullId = suffix != null ? '_' : habitId;

    for (int i = 0; i < fullId.length; i++) {
      hash = ((hash << 5) - hash + fullId.codeUnitAt(i)) & 0x7FFFFFFF;
    }

    // Ensure positive ID in safe range (1-2147483647)
    return (hash % 2147483646) + 1;
  }

  /// Schedule notification alarm (fallback method)
  static Future<void> _scheduleNotificationAlarm({
    required int alarmId,
    required String habitName,
    required DateTime scheduledTime,
    String? alarmSoundName,
    required int snoozeDelayMinutes,
  }) async {
    try {
      final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'habit_alarm_channel',
        'Habit Alarms',
        channelDescription: 'High-priority alarm notifications for habits',
        importance: Importance.max,
        priority: Priority.max,
        fullScreenIntent: true,
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
        playSound: true,
        enableVibration: true,
        enableLights: true,
      );

      final platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      final tzDateTime = tz.TZDateTime.from(scheduledTime, tz.local);

      await _notificationsPlugin.zonedSchedule(
        alarmId,
        '🚨 HABIT ALARM: ',
        'Time to complete your habit!',
        tzDateTime,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      AppLogger.info('✅ Notification alarm scheduled as fallback');
    } catch (e) {
      AppLogger.error('❌ Failed to schedule notification alarm', e);
    }
  }

  /// Get alarm sound path
  static String _getAlarmSoundPath(String? alarmSoundName) {
    if (alarmSoundName == null || alarmSoundName == 'default') {
      return 'assets/sounds/digital_beep.mp3';
    }

    if (alarmSoundName.startsWith('assets/')) {
      return alarmSoundName;
    }

    // Map named sounds to paths
    switch (alarmSoundName) {
      case 'Gentle Chime':
        return 'assets/sounds/gentle_chime.mp3';
      case 'Morning Bell':
        return 'assets/sounds/morning_bell.mp3';
      case 'Nature Birds':
        return 'assets/sounds/nature_birds.mp3';
      case 'Digital Beep':
        return 'assets/sounds/digital_beep.mp3';
      default:
        return 'assets/sounds/digital_beep.mp3';
    }
  }

  /// Get a list of available alarm sounds
  static Future<List<Map<String, String>>> getAvailableAlarmSounds() async {
    // Return a list of available alarm sounds
    return [
      {'id': 'default', 'name': 'Default Alarm'},
      {'id': 'gentle', 'name': 'Gentle Reminder'},
      {'id': 'urgent', 'name': 'Urgent Alarm'},
      {'id': 'nature', 'name': 'Nature Sounds'},
      {'id': 'digital', 'name': 'Digital Beep'},
    ];
  }

  /// Play a preview of an alarm sound
  static Future<void> playAlarmSoundPreview(String soundName) async {
    try {
      // Create temporary alarm settings for preview
      final previewSettings = AlarmSettings(
        id: 999999, // Use a very high ID that won't conflict with real alarms
        dateTime: DateTime.now().add(const Duration(seconds: 1)),
        assetAudioPath: _getAlarmSoundPath(soundName),
        loopAudio: false,
        vibrate: false,
        notificationSettings: NotificationSettings(
          title: 'Preview',
          body: 'Sound preview',
          stopButton: 'Stop',
        ),
        volumeSettings: VolumeSettings.fade(
          volume: 0.5,
          fadeDuration: Duration.zero,
        ),
        warningNotificationOnKill: false,
        androidFullScreenIntent: false,
      );

      // Play the sound
      await Alarm.set(alarmSettings: previewSettings);

      AppLogger.debug('Playing alarm sound preview: $soundName');
    } catch (e) {
      AppLogger.error('Failed to play alarm sound preview', e);
    }
  }

  /// Stop the alarm sound preview
  static Future<void> stopAlarmSoundPreview() async {
    try {
      // Stop the preview alarm
      await Alarm.stop(999999);
      AppLogger.debug('Stopped alarm sound preview');
    } catch (e) {
      AppLogger.error('Failed to stop alarm sound preview', e);
    }
  }

  /// Schedule a snooze alarm
  static Future<void> scheduleSnoozeAlarm({
    required int originalAlarmId,
    required String habitId,
    required String habitName,
    required int snoozeDelayMinutes,
    String? alarmSoundName,
  }) async {
    final snoozeTime =
        DateTime.now().add(Duration(minutes: snoozeDelayMinutes));
    final snoozeAlarmId =
        originalAlarmId + 1000000; // Offset to avoid conflicts

    await scheduleExactAlarm(
      alarmId: snoozeAlarmId,
      habitId: habitId,
      habitName: habitName,
      scheduledTime: snoozeTime,
      frequency: 'snooze',
      alarmSoundName: alarmSoundName,
      snoozeDelayMinutes: snoozeDelayMinutes,
    );

    AppLogger.info('⏰ Scheduled snooze alarm for $snoozeDelayMinutes minutes');
  }

  /// Schedule recurring exact alarm (for backward compatibility)
  static Future<void> scheduleRecurringExactAlarm({
    required int alarmId,
    required String habitId,
    required String habitName,
    required DateTime scheduledTime,
    required String frequency,
    String? alarmSoundName,
    int snoozeDelayMinutes = 10,
  }) async {
    await scheduleExactAlarm(
      alarmId: alarmId,
      habitId: habitId,
      habitName: habitName,
      scheduledTime: scheduledTime,
      frequency: frequency,
      alarmSoundName: alarmSoundName,
      snoozeDelayMinutes: snoozeDelayMinutes,
    );
  }
}
