import 'dart:async';
import 'dart:convert';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'logging_service.dart';
import '../alarm_callback.dart';

/// Unified alarm service using android_alarm_manager_plus for reliable system-level alarms
/// with native Android system sound support via Platform Channels
@pragma('vm:entry-point')
class AlarmManagerService {
  static bool _isInitialized = false;
  static const String _alarmDataKey = 'alarm_manager_data_';
  static const MethodChannel _systemSoundChannel =
      MethodChannel('com.habittracker.habitv8/system_sound');
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize the alarm manager service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize android_alarm_manager_plus
      await AndroidAlarmManager.initialize();

      // Initialize notifications plugin for fallback notifications
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      await _notificationsPlugin.initialize(initializationSettings);

      AppLogger.info('🔄 AlarmManagerService initialized successfully');
      _isInitialized = true;
    } catch (e) {
      AppLogger.error('Failed to initialize AlarmManagerService', e);
      rethrow;
    }
  }

  /// Schedule an exact alarm using android_alarm_manager_plus
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
    await prefs.setString('$_alarmDataKey$alarmId', jsonEncode(alarmData));

    AppLogger.info('🔄 Scheduling alarm with AlarmManagerService:');
    AppLogger.info('  - Alarm ID: $alarmId');
    AppLogger.info('  - Habit: $habitName');
    AppLogger.info('  - Scheduled time: $scheduledTime');
    AppLogger.info('  - Sound: ${alarmSoundName ?? "default"}');

    try {
      // Schedule the alarm using android_alarm_manager_plus
      await AndroidAlarmManager.oneShotAt(
        scheduledTime,
        alarmId,
        playAlarmSound,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: false,
      );

      AppLogger.info(
          '✅ Alarm scheduled successfully with android_alarm_manager_plus');
    } catch (e) {
      AppLogger.error(
          '❌ Failed to schedule alarm with android_alarm_manager_plus', e);

      // Fallback to notification if alarm manager fails
      await _scheduleNotificationFallback(
        alarmId: alarmId,
        habitName: habitName,
        scheduledTime: scheduledTime,
        alarmSoundName: alarmSoundName,
      );

      rethrow;
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

          // Skip past times on the current day
          if (dayOffset == 0 && alarmTime.isBefore(now)) {
            continue;
          }

          final alarmId = _generateHourlyAlarmId(habit.id, alarmTime);

          await scheduleExactAlarm(
            alarmId: alarmId,
            habitId: habit.id,
            habitName: habit.name,
            scheduledTime: alarmTime,
            frequency: 'hourly',
            alarmSoundName: habit.selectedSound,
            snoozeDelayMinutes: habit.snoozeDelay ?? 10,
          );

          AppLogger.info(
              '✅ Scheduled hourly alarm for ${habit.name} at $timeStr');
        } catch (e) {
          AppLogger.error(
              'Failed to schedule hourly alarm for ${habit.name} at $timeStr',
              e);
        }
      }
    }
  }

  /// Schedule daily habit alarms
  static Future<void> scheduleDailyHabitAlarm(dynamic habit) async {
    if (habit.reminderTime == null) return;

    final now = DateTime.now();
    final parts = habit.reminderTime.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    DateTime alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the time has passed today, schedule for tomorrow
    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }

    final alarmId = _generateDailyAlarmId(habit.id);

    try {
      await scheduleExactAlarm(
        alarmId: alarmId,
        habitId: habit.id,
        habitName: habit.name,
        scheduledTime: alarmTime,
        frequency: 'daily',
        alarmSoundName: habit.selectedSound,
        snoozeDelayMinutes: habit.snoozeDelay ?? 10,
      );

      AppLogger.info(
          '✅ Scheduled daily alarm for ${habit.name} at ${habit.reminderTime}');
    } catch (e) {
      AppLogger.error('Failed to schedule daily alarm for ${habit.name}', e);
    }
  }

  /// Cancel an alarm
  static Future<void> cancelAlarm(int alarmId) async {
    try {
      await AndroidAlarmManager.cancel(alarmId);

      // Remove alarm data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_alarmDataKey$alarmId');

      AppLogger.info('✅ Alarm $alarmId cancelled successfully');
    } catch (e) {
      AppLogger.error('Failed to cancel alarm $alarmId', e);
    }
  }

  /// Cancel all alarms for a habit
  static Future<void> cancelHabitAlarms(String habitId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys =
          prefs.getKeys().where((key) => key.startsWith(_alarmDataKey));

      for (final key in keys) {
        final data = prefs.getString(key);
        if (data != null) {
          try {
            final alarmData = jsonDecode(data);
            if (alarmData['habitId'] == habitId) {
              final alarmIdStr = key.substring(_alarmDataKey.length);
              final alarmId = int.parse(alarmIdStr);
              await cancelAlarm(alarmId);
            }
          } catch (e) {
            AppLogger.error('Error parsing alarm data for key $key', e);
          }
        }
      }

      AppLogger.info('✅ Cancelled all alarms for habit $habitId');
    } catch (e) {
      AppLogger.error('Failed to cancel alarms for habit $habitId', e);
    }
  }

  /// Open system ringtone picker
  static Future<String?> openSystemRingtonePicker() async {
    try {
      final result =
          await _systemSoundChannel.invokeMethod('openRingtonePicker');
      AppLogger.info('📱 System ringtone picker result: $result');
      return result;
    } catch (e) {
      AppLogger.error('Failed to open system ringtone picker', e);
      return null;
    }
  }

  /// Test system sound playback
  static Future<void> testSystemSound([String? soundUri]) async {
    try {
      AppLogger.info('🔊 Testing system sound: ${soundUri ?? "default"}');
      await _systemSoundChannel.invokeMethod('playSystemSound', {
        'soundUri': soundUri,
        'volume': 0.8,
        'loop': false,
      });
    } catch (e) {
      AppLogger.error('Failed to test system sound', e);
    }
  }

  /// Stop system sound playback
  static Future<void> stopSystemSound() async {
    try {
      await _systemSoundChannel.invokeMethod('stopSystemSound');
    } catch (e) {
      AppLogger.error('Failed to stop system sound', e);
    }
  }

  /// Execute the alarm - play sound and create notification
  static Future<void> executeAlarm(Map<String, dynamic> alarmData) async {
    try {
      final habitName = alarmData['habitName'] ?? 'Habit';
      final alarmSoundName = alarmData['alarmSoundName'];

      AppLogger.info('🔊 Executing alarm for: $habitName');

      // Play system sound using platform channel
      await _systemSoundChannel.invokeMethod('playSystemSound', {
        'soundUri': alarmSoundName,
        'volume': 0.8,
        'loop': true,
        'habitName': habitName,
      });

      // Show notification as backup
      await _showAlarmNotification(habitName);

      AppLogger.info('✅ Alarm executed successfully for: $habitName');
    } catch (e) {
      AppLogger.error('Failed to execute alarm', e);
    }
  }

  /// Show alarm notification
  static Future<void> _showAlarmNotification(String habitName) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'habit_alarms',
        'Habit Alarms',
        channelDescription: 'Alarm notifications for habit reminders',
        importance: Importance.max,
        priority: Priority.high,
        fullScreenIntent: true,
        category: AndroidNotificationCategory.alarm,
        playSound: false, // Sound is handled by native code
        enableVibration: true,
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _notificationsPlugin.show(
        999999, // Use a high ID for alarm notifications
        '🚨 HABIT ALARM: $habitName',
        'Time to complete your habit!',
        platformChannelSpecifics,
      );
    } catch (e) {
      AppLogger.error('Failed to show alarm notification', e);
    }
  }

  /// Schedule notification fallback if alarm manager fails
  static Future<void> _scheduleNotificationFallback({
    required int alarmId,
    required String habitName,
    required DateTime scheduledTime,
    String? alarmSoundName,
  }) async {
    try {
      AppLogger.info('🔄 Scheduling notification fallback for $habitName');

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'habit_reminders',
        'Habit Reminders',
        channelDescription: 'Scheduled reminders for habits',
        importance: Importance.high,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('notification'),
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _notificationsPlugin.zonedSchedule(
        alarmId,
        '🚨 HABIT REMINDER: $habitName',
        'Time to complete your habit!',
        tz.TZDateTime.from(scheduledTime, tz.local),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      AppLogger.info('✅ Notification fallback scheduled for $habitName');
    } catch (e) {
      AppLogger.error('Failed to schedule notification fallback', e);
    }
  }

  /// Generate alarm ID for hourly alarms
  static int _generateHourlyAlarmId(String habitId, DateTime dateTime) {
    // Use a combination of habit ID hash and time to create unique IDs
    final habitHash = habitId.hashCode.abs() % 10000;
    final timeHash = (dateTime.hour * 100 + dateTime.minute) % 10000;
    return habitHash + timeHash + 100000; // Add offset to avoid conflicts
  }

  /// Generate alarm ID for daily alarms
  static int _generateDailyAlarmId(String habitId) {
    // Use habit ID hash with offset for daily alarms
    return habitId.hashCode.abs() % 10000 +
        200000; // Add offset to avoid conflicts
  }

  /// Get available system ringtones
  static Future<List<Map<String, String>>> getSystemRingtones() async {
    try {
      final result =
          await _systemSoundChannel.invokeMethod('getSystemRingtones');
      final List<dynamic> ringtonesData = result ?? [];

      return ringtonesData
          .map((item) => Map<String, String>.from(item))
          .toList();
    } catch (e) {
      AppLogger.error('Failed to get system ringtones', e);
      return [];
    }
  }

  /// Get available alarm sounds (alias for getSystemRingtones for compatibility)
  static Future<List<Map<String, String>>> getAvailableAlarmSounds() async {
    return await getSystemRingtones();
  }

  /// Play alarm sound preview
  static Future<void> playAlarmSoundPreview(String? soundUri) async {
    try {
      await _systemSoundChannel.invokeMethod('playSystemSound', {
        'soundUri': soundUri,
        'volume': 0.6,
        'loop': false,
        'habitName': 'Preview',
      });
    } catch (e) {
      AppLogger.error('Failed to play alarm sound preview', e);
    }
  }

  /// Stop alarm sound preview
  static Future<void> stopAlarmSoundPreview() async {
    try {
      await _systemSoundChannel.invokeMethod('stopSystemSound');
    } catch (e) {
      AppLogger.error('Failed to stop alarm sound preview', e);
    }
  }

  /// Generate habit alarm ID for compatibility
  static int generateHabitAlarmId(String habitId, {String? suffix}) {
    final habitHash = habitId.hashCode.abs() % 10000;
    final suffixHash = suffix != null ? suffix.hashCode.abs() % 1000 : 0;
    return habitHash + suffixHash + 300000; // Add offset to avoid conflicts
  }

  /// Schedule recurring exact alarm (maps to scheduleExactAlarm for compatibility)
  static Future<void> scheduleRecurringExactAlarm({
    required int alarmId,
    required String habitId,
    required String habitName,
    required DateTime scheduledTime,
    required String frequency,
    String? alarmSoundName,
    int snoozeDelayMinutes = 10,
    Map<String, dynamic>? additionalData,
  }) async {
    // For recurring alarms, we'll schedule the next occurrence
    // The alarm manager plus doesn't handle recurring directly,
    // so this will need to be rescheduled after each alarm fires
    await scheduleExactAlarm(
      alarmId: alarmId,
      habitId: habitId,
      habitName: habitName,
      scheduledTime: scheduledTime,
      frequency: frequency,
      alarmSoundName: alarmSoundName,
      snoozeDelayMinutes: snoozeDelayMinutes,
      additionalData: additionalData,
    );
  }

  /// Schedule snooze alarm (maps to scheduleExactAlarm for compatibility)
  static Future<void> scheduleSnoozeAlarm({
    required int alarmId,
    required String habitId,
    required String habitName,
    required DateTime snoozeTime,
    String? alarmSoundName,
    int snoozeDelayMinutes = 10,
    int? originalAlarmId, // Added for compatibility
  }) async {
    await scheduleExactAlarm(
      alarmId: alarmId,
      habitId: habitId,
      habitName: habitName,
      scheduledTime: snoozeTime,
      frequency: 'snooze',
      alarmSoundName: alarmSoundName,
      snoozeDelayMinutes: snoozeDelayMinutes,
    );
  }
}
