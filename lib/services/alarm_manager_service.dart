import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import '../native_alarm_service.dart';
import 'logging_service.dart';

/// Unified alarm service using native Android AlarmManager for reliable system-level alarms
/// with proper BroadcastReceiver pattern and foreground service architecture
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
      // Initialize native alarm service
      AppLogger.debug('Initializing native alarm service...');

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
    String? alarmSoundUri,
    int snoozeDelayMinutes = 10,
    Map<String, dynamic>? additionalData,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Only check if this exact alarm already exists (same ID and same schedule time)
    // This prevents true duplicates while allowing multiple legitimate alarms
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingAlarmData = prefs.getString('$_alarmDataKey$alarmId');

      if (existingAlarmData != null) {
        final existing = jsonDecode(existingAlarmData);
        final existingTime = DateTime.parse(existing['scheduledTime']);

        // Only cancel if it's the exact same alarm (same time and habit)
        if (existingTime.isAtSameMomentAs(scheduledTime) &&
            existing['habitId'] == habitId) {
          await NativeAlarmService.cancelAlarm(alarmId);
          AppLogger.debug(
              'Cancelled duplicate alarm for habit $habitId at $scheduledTime');
        }
      }
    } catch (e) {
      // Ignore errors when checking for duplicates
      AppLogger.debug('Could not check for duplicate alarm: $e');
    }

    // Debug logging for alarm data
    AppLogger.debug('Preparing alarm data:');
    AppLogger.debug('  - Habit ID: $habitId');
    AppLogger.debug('  - Habit Name: $habitName');
    AppLogger.debug('  - Sound Name: ${alarmSoundName ?? "default"}');
    AppLogger.debug('  - Sound URI: ${alarmSoundUri ?? "NULL/EMPTY"}');
    AppLogger.debug('  - Frequency: $frequency');

    // Store alarm data for the callback (both SharedPreferences and file for cross-isolate access)
    final alarmData = {
      'habitId': habitId,
      'habitName': habitName,
      'alarmSoundName': alarmSoundName ?? 'default',
      'alarmSoundUri': alarmSoundUri ?? '',
      'snoozeDelayMinutes': snoozeDelayMinutes,
      'frequency': frequency,
      'scheduledTime': scheduledTime.toIso8601String(),
      'additionalData': additionalData ?? {},
    };

    // Store in SharedPreferences for main app access
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_alarmDataKey$alarmId', jsonEncode(alarmData));

    // Also store in file for background isolate access
    await _saveAlarmDataToFile(alarmId, alarmData);

    AppLogger.info('🔄 Scheduling alarm with AlarmManagerService:');
    AppLogger.info('  - Alarm ID: $alarmId');
    AppLogger.info('  - Habit: $habitName');
    AppLogger.info('  - Scheduled time: $scheduledTime');
    AppLogger.info('  - Sound: ${alarmSoundName ?? "default"}');

    try {
      // Use native Android alarm scheduling for better reliability
      final success = await NativeAlarmService.scheduleAlarm(
        alarmId: alarmId,
        triggerTime: scheduledTime,
        habitName: habitName,
        soundUri: alarmSoundUri,
      );

      if (success) {
        AppLogger.info('✅ Native alarm scheduled successfully');
      } else {
        throw Exception('Native alarm scheduling failed');
      }
    } catch (e) {
      AppLogger.error('❌ Failed to schedule native alarm', e);
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
            alarmSoundName: habit.alarmSoundName,
            alarmSoundUri: habit.alarmSoundUri,
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
        alarmSoundName: habit.alarmSoundName,
        alarmSoundUri: habit.alarmSoundUri,
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
      await NativeAlarmService.cancelAlarm(alarmId);

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
      try {
        await _systemSoundChannel.invokeMethod('playSystemSound', {
          'soundUri': alarmSoundName, // Note: platform expects URI or "default"
          'volume': 0.8,
          'loop': true,
          'habitName': habitName,
        });
        AppLogger.info('✅ Platform channel sound call successful');
      } catch (e) {
        AppLogger.error('❌ Platform channel sound call failed: $e');
        // Fallback: enable sound in notification, prefer per-habit URI if available
        await _showAlarmNotificationWithSound(
          habitName,
          alarmSoundUri: alarmData['alarmSoundUri'],
          alarmSoundName: alarmData['alarmSoundName'],
        );
        return;
      }

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

  /// Show alarm notification with sound fallback
  /// Prefer per-habit URI; fall back to alarmSoundName; then system default
  static Future<void> _showAlarmNotificationWithSound(String habitName,
      {String? alarmSoundUri, String? alarmSoundName}) async {
    try {
      AndroidNotificationDetails androidPlatformChannelSpecifics;

      final bool hasUri = alarmSoundUri != null &&
          alarmSoundUri.isNotEmpty &&
          alarmSoundUri != 'default';
      final bool hasName =
          alarmSoundName != null && alarmSoundName != 'default';

      if (hasUri) {
        androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'habit_alarms',
          'Habit Alarms',
          channelDescription: 'Alarm notifications for habit reminders',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.alarm,
          playSound: true,
          enableVibration: true,
          sound: UriAndroidNotificationSound(alarmSoundUri),
        );
      } else if (hasName) {
        androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'habit_alarms',
          'Habit Alarms',
          channelDescription: 'Alarm notifications for habit reminders',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.alarm,
          playSound: true,
          enableVibration: true,
          sound: UriAndroidNotificationSound(alarmSoundName),
        );
      } else {
        androidPlatformChannelSpecifics = const AndroidNotificationDetails(
          'habit_alarms',
          'Habit Alarms',
          channelDescription: 'Alarm notifications for habit reminders',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.alarm,
          playSound: true,
          enableVibration: true,
          sound: UriAndroidNotificationSound(
              'content://settings/system/alarm_alert'),
        );
      }

      final NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _notificationsPlugin.show(
        999998, // Use a different ID for sound fallback notifications
        '🔊 HABIT ALARM: $habitName',
        'Time to complete your habit! (Sound fallback)',
        platformChannelSpecifics,
      );

      AppLogger.info('✅ Sound fallback notification shown for: $habitName');
    } catch (e) {
      AppLogger.error('Failed to show sound fallback notification', e);
    }
  }

  /// Generate alarm ID for hourly alarms
  static int _generateHourlyAlarmId(String habitId, DateTime dateTime) {
    // Create a truly unique ID for each habit's hourly alarm
    // Use habit ID hash, year, day of year, and time in minutes
    final habitHash = habitId.hashCode.abs() % 1000;
    final year = dateTime.year % 100; // Last 2 digits of year
    final dayOfYear = dateTime.difference(DateTime(dateTime.year, 1, 1)).inDays;
    final timeMinutes = dateTime.hour * 60 + dateTime.minute;

    // Create a unique ID: habitHash(3) + year(2) + dayOfYear(3) + timeMinutes(4) = 12 digits max
    return (habitHash * 100000000) +
        (year * 1000000) +
        (dayOfYear * 1440) +
        timeMinutes +
        10000000;
  }

  /// Generate alarm ID for daily alarms
  static int _generateDailyAlarmId(String habitId) {
    // Create a unique ID for each habit's daily alarm
    final habitHash = habitId.hashCode.abs() % 10000;
    final now = DateTime.now();
    final year = now.year % 100; // Last 2 digits of year
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;

    // Create a unique ID: habitHash(4) + year(2) + dayOfYear(3) = 9 digits max
    return (habitHash * 100000) + (year * 1000) + dayOfYear + 20000000;
  }

  /// Get available system ringtones
  static Future<List<Map<String, String>>> getSystemRingtones() async {
    try {
      final result =
          await _systemSoundChannel.invokeMethod('getSystemRingtones');
      final List<dynamic> ringtonesData = result ?? [];

      AppLogger.debug(
          'Platform channel returned ${ringtonesData.length} ringtones');

      final mappedData =
          ringtonesData.map((item) => Map<String, String>.from(item)).toList();

      // Debug logging for first few sounds
      for (int i = 0; i < mappedData.length && i < 3; i++) {
        final sound = mappedData[i];
        AppLogger.debug(
            'Platform sound $i: ${sound['name']} -> ${sound['uri']} (${sound['type']})');
      }

      return mappedData;
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
    final timeComponent = DateTime.now().millisecondsSinceEpoch %
        1000; // Add time component for uniqueness

    final alarmId = habitHash + suffixHash + timeComponent + 300000;

    AppLogger.debug(
        'Generated alarm ID $alarmId for habit $habitId (suffix: $suffix)');
    return alarmId;
  }

  /// Schedule recurring exact alarm (maps to scheduleExactAlarm for compatibility)
  static Future<void> scheduleRecurringExactAlarm({
    required int alarmId,
    required String habitId,
    required String habitName,
    required DateTime scheduledTime,
    required String frequency,
    String? alarmSoundName,
    String? alarmSoundUri,
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
      alarmSoundUri: alarmSoundUri,
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
    String? alarmSoundUri,
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
      alarmSoundUri: alarmSoundUri,
      snoozeDelayMinutes: snoozeDelayMinutes,
    );
  }

  /// Save alarm data to file for background isolate access
  static Future<void> _saveAlarmDataToFile(
      int alarmId, Map<String, dynamic> alarmData) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/alarm_data_$alarmId.json');
      await file.writeAsString(jsonEncode(alarmData));
      AppLogger.info('Alarm data saved to file for ID: $alarmId');
    } catch (e) {
      AppLogger.error('Error saving alarm data to file: $e');
    }
  }
}
