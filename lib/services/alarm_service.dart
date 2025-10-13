import 'dart:async';
import 'dart:io';
import 'package:flutter_ringtone_manager/flutter_ringtone_manager.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'dart:convert';
import 'logging_service.dart';

@pragma('vm:entry-point')
class AlarmService {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static bool _isInitialized = false;
  static const String _alarmDataKey = 'alarm_data_';

  /// Initialize the alarm service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Verify AwesomeNotifications is initialized (should be done by NotificationCore)
      if (!await AwesomeNotifications().isNotificationAllowed()) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }

      AppLogger.info('🚨 AlarmService initialized successfully');
      _isInitialized = true;
    } catch (e) {
      AppLogger.error('Failed to initialize AlarmService', e);
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
    await prefs.setString('$_alarmDataKey$alarmId', jsonEncode(alarmData));

    AppLogger.info('🚨 Scheduling exact alarm:');
    AppLogger.info('  - Alarm ID: $alarmId');
    AppLogger.info('  - Habit: $habitName');
    AppLogger.info('  - Scheduled time: $scheduledTime');
    AppLogger.info('  - Sound: $alarmSoundName');

    try {
      // Use awesome_notifications for scheduling
      await _scheduleNotificationAlarm(
        alarmId: alarmId,
        habitId: habitId,
        habitName: habitName,
        scheduledTime: scheduledTime,
        alarmSoundName: alarmSoundName,
        snoozeDelayMinutes: snoozeDelayMinutes,
      );

      AppLogger.info('✅ Exact alarm scheduled successfully');
    } catch (e) {
      AppLogger.error('❌ Failed to schedule exact alarm', e);
      rethrow;
    }
  }

  /// Schedule recurring exact alarms for a habit
  static Future<void> scheduleRecurringExactAlarm({
    required int baseAlarmId,
    required String habitId,
    required String habitName,
    required DateTime firstScheduledTime,
    required Duration interval,
    required String frequency,
    String? alarmSoundName,
    int snoozeDelayMinutes = 10,
    int maxRecurrences = 30, // Schedule for next 30 occurrences
  }) async {
    if (!Platform.isAndroid) {
      AppLogger.warning('Exact alarms only supported on Android');
      return;
    }

    AppLogger.info('🚨 Scheduling recurring exact alarms for $habitName');
    AppLogger.info('  - Base ID: $baseAlarmId');
    AppLogger.info('  - First time: $firstScheduledTime');
    AppLogger.info('  - Interval: $interval');
    AppLogger.info('  - Max recurrences: $maxRecurrences');

    DateTime currentTime = firstScheduledTime;

    for (int i = 0; i < maxRecurrences; i++) {
      final alarmId = baseAlarmId + i;

      await scheduleExactAlarm(
        alarmId: alarmId,
        habitId: habitId,
        habitName: habitName,
        scheduledTime: currentTime,
        frequency: frequency,
        alarmSoundName: alarmSoundName,
        snoozeDelayMinutes: snoozeDelayMinutes,
        additionalData: {'recurrence': i, 'baseId': baseAlarmId},
      );

      currentTime = currentTime.add(interval);
    }

    AppLogger.info('✅ Scheduled $maxRecurrences recurring alarms');
  }

  /// Cancel an alarm
  static Future<void> cancelAlarm(int alarmId) async {
    try {
      // Cancel the scheduled notification
      await AwesomeNotifications().cancel(alarmId);

      // Clean up stored alarm data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_alarmDataKey$alarmId');

      AppLogger.info('🚨 Cancelled alarm ID: $alarmId');
    } catch (e) {
      AppLogger.error('❌ Failed to cancel alarm $alarmId', e);
    }
  }

  /// Cancel all alarms for a habit
  static Future<void> cancelHabitAlarms(
    String habitId, {
    int maxAlarms = 100,
  }) async {
    AppLogger.info('🚨 Cancelling all alarms for habit: $habitId');

    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    int cancelledCount = 0;

    for (String key in keys) {
      if (key.startsWith(_alarmDataKey)) {
        try {
          final alarmDataJson = prefs.getString(key);
          if (alarmDataJson != null) {
            final alarmData = jsonDecode(alarmDataJson);
            if (alarmData['habitId'] == habitId) {
              final alarmId = int.tryParse(key.substring(_alarmDataKey.length));
              if (alarmId != null) {
                await AwesomeNotifications().cancel(alarmId);
                await prefs.remove(key);
                cancelledCount++;
              }
            }
          }
        } catch (e) {
          AppLogger.error('Error processing alarm data for key $key', e);
        }
      }
    }

    AppLogger.info('✅ Cancelled $cancelledCount alarms for habit: $habitId');
  }

  /// Get available system alarm sounds
  static Future<List<Map<String, String>>> getAvailableAlarmSounds() async {
    return [
      // System sounds
      {'name': 'Default System Alarm', 'uri': 'default', 'type': 'system'},
      {'name': 'System Alarm', 'uri': 'alarm', 'type': 'system'},
      {'name': 'System Ringtone', 'uri': 'ringtone', 'type': 'system'},
      {'name': 'System Notification', 'uri': 'notification', 'type': 'system'},

      // Custom sounds (only include sounds that actually exist)
      {
        'name': 'Gentle Chime',
        'uri': 'assets/sounds/gentle_chime.mp3',
        'type': 'custom',
      },
      {
        'name': 'Morning Bell',
        'uri': 'assets/sounds/morning_bell.mp3',
        'type': 'custom',
      },
      {
        'name': 'Nature Birds',
        'uri': 'assets/sounds/nature_birds.mp3',
        'type': 'custom',
      },
      {
        'name': 'Digital Beep',
        'uri': 'assets/sounds/digital_beep.mp3',
        'type': 'custom',
      },
      // Note: The following sounds are referenced in README.md but files don't exist:
      // - zen_gong.mp3
      // - upbeat_melody.mp3
      // - soft_piano.mp3
      // - ocean_waves.mp3
      // Uncomment and add the files if you want to include them
    ];
  }

  /// Play alarm sound preview
  static Future<void> playAlarmSoundPreview(String soundUri) async {
    try {
      // Stop any currently playing sound
      await stopAlarmSoundPreview();

      if (soundUri.startsWith('assets/')) {
        // Play custom sound using audioplayers
        await _audioPlayer.play(
          AssetSource(soundUri.replaceFirst('assets/', '')),
        );
        AppLogger.info('Playing custom sound preview: $soundUri');
      } else {
        // Play system sound using flutter_ringtone_manager
        if (Platform.isAndroid) {
          final ringtoneManager = FlutterRingtoneManager();

          switch (soundUri) {
            case 'default':
            case 'alarm':
              await ringtoneManager.playAlarm();
              break;
            case 'ringtone':
              await ringtoneManager.playRingtone();
              break;
            case 'notification':
              await ringtoneManager.playNotification();
              break;
            default:
              await ringtoneManager.playAlarm();
          }
          AppLogger.info('Playing system sound preview: $soundUri');
        }
      }
    } catch (e) {
      AppLogger.error('Failed to play alarm sound preview: $soundUri', e);
    }
  }

  /// Stop alarm sound preview
  static Future<void> stopAlarmSoundPreview() async {
    try {
      // Stop audioplayers
      await _audioPlayer.stop();

      // Stop system ringtone manager
      if (Platform.isAndroid) {
        final ringtoneManager = FlutterRingtoneManager();
        await ringtoneManager.stop();
      }
    } catch (e) {
      AppLogger.error('Failed to stop alarm sound preview', e);
    }
  }

  /// Schedule notification-based alarm
  static Future<void> _scheduleNotificationAlarm({
    required int alarmId,
    required String habitId,
    required String habitName,
    required DateTime scheduledTime,
    String? alarmSoundName,
    required int snoozeDelayMinutes,
  }) async {
    // Create snooze text
    String snoozeText = '⏰ Snooze ';
    if (snoozeDelayMinutes < 60) {
      snoozeText += '${snoozeDelayMinutes}min';
    } else {
      final hours = snoozeDelayMinutes ~/ 60;
      final minutes = snoozeDelayMinutes % 60;
      if (minutes == 0) {
        snoozeText += '${hours}h';
      } else {
        snoozeText += '${hours}h ${minutes}min';
      }
    }

    // Prepare custom sound if provided
    String? customSound;
    if (alarmSoundName != null && alarmSoundName != 'default') {
      // Convert sound name to resource format (remove .mp3 extension)
      customSound = 'resource://raw/${alarmSoundName.replaceAll('.mp3', '')}';
    }

    // CRITICAL: Create payload with habitId so the notification action handler
    // can process the completion. This matches the format used by regular notifications.
    final payloadData = jsonEncode({
      'habitId': habitId,
      'habitName': habitName,
      'type': 'alarm',
    });

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: alarmId,
        channelKey: 'habit_alarms',
        title: '🚨 HABIT ALARM: $habitName',
        body: 'Time to complete your habit! Tap to mark as complete or snooze.',
        category: NotificationCategory.Alarm,
        notificationLayout: NotificationLayout.Default,
        fullScreenIntent: true,
        wakeUpScreen: true,
        criticalAlert: true,
        locked: true,
        customSound: customSound,
        payload: {'data': payloadData},
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'complete',
          label: '✅ COMPLETE',
          actionType: ActionType.SilentBackgroundAction,
          autoDismissible: true,
        ),
        NotificationActionButton(
          key: 'snooze_alarm',
          label: snoozeText,
          actionType: ActionType.SilentBackgroundAction,
          autoDismissible: false,
        ),
      ],
      schedule: NotificationCalendar.fromDate(
        date: scheduledTime,
        allowWhileIdle: true,
        preciseAlarm: true,
      ),
    );
  }

  /// Schedule snooze alarm
  static Future<void> scheduleSnoozeAlarm({
    required String habitId,
    required String habitName,
    required int snoozeDelayMinutes,
    String? alarmSoundName,
  }) async {
    final snoozeTime = DateTime.now().add(
      Duration(minutes: snoozeDelayMinutes),
    );
    final snoozeAlarmId = _generateSnoozeAlarmId(habitId);

    await scheduleExactAlarm(
      alarmId: snoozeAlarmId,
      habitId: habitId,
      habitName: habitName,
      scheduledTime: snoozeTime,
      frequency: 'snooze',
      alarmSoundName: alarmSoundName,
      snoozeDelayMinutes: snoozeDelayMinutes,
      additionalData: {'isSnooze': true},
    );

    AppLogger.info(
      '⏰ Scheduled snooze alarm for $habitName in $snoozeDelayMinutes minutes',
    );
  }

  /// Schedule habit alarm (simplified API for habit_continuation_service)
  /// This is a convenience method that generates the alarm ID automatically
  static Future<void> scheduleHabitAlarm({
    required String habitId,
    required String habitName,
    required DateTime scheduledTime,
    String? alarmSoundName,
    int snoozeDelayMinutes = 10,
    String frequency = 'daily',
  }) async {
    // Generate alarm ID based on habitId and scheduled time
    final alarmId = generateHabitAlarmId(
      habitId,
      suffix: '${scheduledTime.millisecondsSinceEpoch}',
    );

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

  /// Get system ringtones (Android only)
  static Future<List<Map<String, String>>> getSystemRingtones() async {
    if (!Platform.isAndroid) {
      return [];
    }

    try {
      // Note: flutter_ringtone_manager doesn't provide a list method
      // Return predefined system sound options
      return [
        {'name': 'Default Alarm', 'uri': 'default', 'type': 'system'},
        {'name': 'System Alarm', 'uri': 'alarm', 'type': 'system'},
        {'name': 'System Ringtone', 'uri': 'ringtone', 'type': 'system'},
        {
          'name': 'System Notification',
          'uri': 'notification',
          'type': 'system'
        },
      ];
    } catch (e) {
      AppLogger.error('Failed to get system ringtones', e);
      return [];
    }
  }

  /// Open system ringtone picker (Android only)
  /// Returns the selected ringtone URI or null if cancelled
  static Future<String?> openSystemRingtonePicker() async {
    if (!Platform.isAndroid) {
      AppLogger.warning('Ringtone picker only available on Android');
      return null;
    }

    try {
      // Note: flutter_ringtone_manager doesn't have a picker
      // This would require a custom platform channel implementation
      // For now, return null and users can select from predefined sounds
      AppLogger.warning('System ringtone picker not implemented yet');
      return null;
    } catch (e) {
      AppLogger.error('Failed to open ringtone picker', e);
      return null;
    }
  }

  /// Test/preview a system sound
  static Future<void> testSystemSound([String? soundUri]) async {
    await playAlarmSoundPreview(soundUri ?? 'default');
  }

  /// Stop any playing system sound
  static Future<void> stopSystemSound() async {
    await stopAlarmSoundPreview();
  }

  /// Schedule hourly habit alarms (compatibility method)
  /// This is handled by the notification scheduler, but kept for API compatibility
  static Future<void> scheduleHourlyHabitAlarms(dynamic habit) async {
    AppLogger.debug(
        'scheduleHourlyHabitAlarms called - delegating to notification scheduler');
    // This method exists for API compatibility with AlarmManagerService
    // The actual scheduling is done by NotificationAlarmScheduler
  }

  /// Schedule daily habit alarm (compatibility method)
  /// This is handled by the notification scheduler, but kept for API compatibility
  static Future<void> scheduleDailyHabitAlarm(dynamic habit) async {
    AppLogger.debug(
        'scheduleDailyHabitAlarm called - delegating to notification scheduler');
    // This method exists for API compatibility with AlarmManagerService
    // The actual scheduling is done by NotificationAlarmScheduler
  }

  /// Generate unique alarm ID for habit
  static int generateHabitAlarmId(String habitId, {String? suffix}) {
    int hash = 0;
    final fullId = suffix != null ? '${habitId}_$suffix' : habitId;

    for (int i = 0; i < fullId.length; i++) {
      hash = ((hash << 5) - hash + fullId.codeUnitAt(i)) & 0x7FFFFFFF;
    }

    // Ensure positive ID in safe range (1-2147483647)
    return (hash % 2147483646) + 1;
  }

  /// Generate snooze alarm ID
  static int _generateSnoozeAlarmId(String habitId) {
    return generateHabitAlarmId(habitId, suffix: 'snooze');
  }

  /// The alarm callback function - this runs when the alarm fires
  @pragma('vm:entry-point')
  static Future<void> _alarmCallback(int alarmId) async {
    AppLogger.info('🚨 ALARM FIRED! ID: $alarmId');

    try {
      // Get alarm data
      final prefs = await SharedPreferences.getInstance();
      final alarmDataJson = prefs.getString('$_alarmDataKey$alarmId');

      if (alarmDataJson == null) {
        AppLogger.error('No alarm data found for ID: $alarmId');
        return;
      }

      final alarmData = jsonDecode(alarmDataJson);
      final habitId = alarmData['habitId'] as String;
      final habitName = alarmData['habitName'] as String;
      final alarmSoundName = alarmData['alarmSoundName'] as String?;
      final snoozeDelayMinutes = alarmData['snoozeDelayMinutes'] as int? ?? 10;
      final frequency = alarmData['frequency'] as String;
      final additionalData =
          alarmData['additionalData'] as Map<String, dynamic>? ?? {};

      AppLogger.info('🚨 Alarm for habit: $habitName');

      // Show full-screen alarm notification
      await _showAlarmNotification(
        alarmId: alarmId,
        habitId: habitId,
        habitName: habitName,
        alarmSoundName: alarmSoundName,
        snoozeDelayMinutes: snoozeDelayMinutes,
      );

      // If this is a recurring alarm, schedule the next occurrence
      if (additionalData['recurrence'] != null && frequency != 'snooze') {
        await _scheduleNextRecurrence(alarmData, alarmId);
      }

      // Clean up this alarm's data if it's not recurring
      if (frequency == 'snooze' || additionalData['recurrence'] == null) {
        await prefs.remove('$_alarmDataKey$alarmId');
      }
    } catch (e) {
      AppLogger.error('Error in alarm callback', e);
    }
  }

  /// Show full-screen alarm notification
  static Future<void> _showAlarmNotification({
    required int alarmId,
    required String habitId,
    required String habitName,
    String? alarmSoundName,
    required int snoozeDelayMinutes,
  }) async {
    try {
      // Create snooze text
      String snoozeText = '⏰ Snooze ';
      if (snoozeDelayMinutes < 60) {
        snoozeText += '${snoozeDelayMinutes}min';
      } else {
        final hours = snoozeDelayMinutes ~/ 60;
        final minutes = snoozeDelayMinutes % 60;
        if (minutes == 0) {
          snoozeText += '${hours}h';
        } else {
          snoozeText += '${hours}h ${minutes}min';
        }
      }

      // Prepare custom sound if provided
      String? customSound;
      if (alarmSoundName != null && alarmSoundName != 'default') {
        customSound = 'resource://raw/${alarmSoundName.replaceAll('.mp3', '')}';
      }

      final payload = jsonEncode({
        'habitId': habitId,
        'alarmId': alarmId,
        'snoozeDelayMinutes': snoozeDelayMinutes,
        'alarmSoundName': alarmSoundName,
      });

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: alarmId,
          channelKey: 'habit_alarms',
          title: '🚨 HABIT ALARM: $habitName',
          body:
              'Time to complete your habit! Tap to mark as complete or snooze.',
          category: NotificationCategory.Alarm,
          notificationLayout: NotificationLayout.Default,
          fullScreenIntent: true,
          wakeUpScreen: true,
          criticalAlert: true,
          locked: true,
          customSound: customSound,
          payload: {'data': payload},
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'complete',
            label: '✅ COMPLETE',
            actionType: ActionType.SilentBackgroundAction,
            autoDismissible: true,
          ),
          NotificationActionButton(
            key: 'snooze_alarm',
            label: snoozeText,
            actionType: ActionType.SilentBackgroundAction,
            autoDismissible: true,
          ),
        ],
      );

      AppLogger.info('🚨 Alarm notification shown for: $habitName');
    } catch (e) {
      AppLogger.error('Failed to show alarm notification', e);
    }
  }

  /// Schedule next recurrence for recurring alarms
  static Future<void> _scheduleNextRecurrence(
    Map<String, dynamic> alarmData,
    int currentAlarmId,
  ) async {
    try {
      final frequency = alarmData['frequency'] as String;
      final additionalData =
          alarmData['additionalData'] as Map<String, dynamic>;
      final baseId = additionalData['baseId'] as int;
      final currentRecurrence = additionalData['recurrence'] as int;

      // Calculate next occurrence based on frequency
      Duration interval;
      switch (frequency) {
        case 'hourly':
          interval = const Duration(hours: 1);
          break;
        case 'daily':
          interval = const Duration(days: 1);
          break;
        case 'weekly':
          interval = const Duration(days: 7);
          break;
        case 'monthly':
          interval = const Duration(days: 30); // Approximate
          break;
        case 'yearly':
          interval = const Duration(days: 365); // Approximate
          break;
        default:
          return; // Unknown frequency
      }

      final nextScheduledTime = DateTime.now().add(interval);
      final nextAlarmId =
          baseId + currentRecurrence + 30; // Offset for next batch

      await scheduleExactAlarm(
        alarmId: nextAlarmId,
        habitId: alarmData['habitId'],
        habitName: alarmData['habitName'],
        scheduledTime: nextScheduledTime,
        frequency: frequency,
        alarmSoundName: alarmData['alarmSoundName'],
        snoozeDelayMinutes: alarmData['snoozeDelayMinutes'],
        additionalData: {
          'recurrence': currentRecurrence + 30,
          'baseId': baseId,
        },
      );

      AppLogger.info(
        '📅 Scheduled next recurrence for ${alarmData['habitName']} at $nextScheduledTime',
      );
    } catch (e) {
      AppLogger.error('Failed to schedule next recurrence', e);
    }
  }
}
