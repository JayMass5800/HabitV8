import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'services/logging_service.dart';

// Global flag to track if alarm manager is already initialized in this isolate
bool _isAlarmManagerInitialized = false;

@pragma('vm:entry-point')
void playAlarmSound(int id) async {
  try {
    AppLogger.info('Alarm fired for ID: $id');

    // Only initialize if not already initialized in this isolate
    if (!_isAlarmManagerInitialized) {
      await AndroidAlarmManager.initialize();
      _isAlarmManagerInitialized = true;
      AppLogger.info('AndroidAlarmManager initialized for isolate');
    }

    // Try to get alarm data from file storage (works across isolates)
    final alarmData = await _getAlarmDataFromFile(id);

    if (alarmData != null) {
      await _executeBackgroundAlarm(alarmData, id);
      await _removeAlarmDataFile(id);
    } else {
      AppLogger.warning('No alarm data found for ID: $id, using default');
      // Fallback to generic alarm
      await _executeBackgroundAlarm(
          {'habitName': 'Habit', 'alarmSoundName': 'default'}, id);
    }
  } catch (e) {
    AppLogger.error('Error in alarm callback: $e');
  }
}

/// Get alarm data from file storage (works in background isolates)
Future<Map<String, dynamic>?> _getAlarmDataFromFile(int id) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/alarm_data_$id.json');

    if (await file.exists()) {
      final content = await file.readAsString();
      return jsonDecode(content);
    }
  } catch (e) {
    AppLogger.error('Error reading alarm data file: $e');
  }
  return null;
}

/// Handle alarm notification actions (stop/snooze)
@pragma('vm:entry-point')
void _handleAlarmAction(NotificationResponse notificationResponse) async {
  try {
    AppLogger.info(
        '🔔 Alarm action received: ${notificationResponse.actionId}');

    final int notificationId = notificationResponse.id ?? 0;

    if (notificationResponse.actionId == 'stop_alarm') {
      AppLogger.info('⏹️ Stopping alarm notification $notificationId');

      // Initialize notifications plugin for action handling
      final FlutterLocalNotificationsPlugin notificationsPlugin =
          FlutterLocalNotificationsPlugin();
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      await notificationsPlugin.initialize(initializationSettings);

      // Cancel the notification
      await notificationsPlugin.cancel(notificationId);
    } else if (notificationResponse.actionId == 'snooze_alarm') {
      AppLogger.info('😴 Snoozing alarm notification $notificationId');

      // Initialize notifications plugin for action handling
      final FlutterLocalNotificationsPlugin notificationsPlugin =
          FlutterLocalNotificationsPlugin();
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      await notificationsPlugin.initialize(initializationSettings);

      // Cancel current notification
      await notificationsPlugin.cancel(notificationId);

      // Try to get alarm data and reschedule
      final alarmData = await _getAlarmDataFromFile(notificationId);
      if (alarmData != null) {
        final snoozeDelayMinutes = alarmData['snoozeDelayMinutes'] ?? 10;
        final snoozeTime =
            DateTime.now().add(Duration(minutes: snoozeDelayMinutes));

        // Reschedule the alarm for snooze time
        await AndroidAlarmManager.oneShotAt(
          snoozeTime,
          notificationId + 50000, // Use different ID for snooze
          playAlarmSound,
          exact: true,
          wakeup: true,
        );

        AppLogger.info('✅ Alarm snoozed for $snoozeDelayMinutes minutes');
      }
    }
  } catch (e) {
    AppLogger.error('Error handling alarm action: $e');
  }
}

/// Remove alarm data file after use
Future<void> _removeAlarmDataFile(int id) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/alarm_data_$id.json');

    if (await file.exists()) {
      await file.delete();
      AppLogger.info('Alarm data file removed for ID: $id');
    }
  } catch (e) {
    AppLogger.error('Error removing alarm data file: $e');
  }
}

/// Execute alarm in background isolate using notifications
Future<void> _executeBackgroundAlarm(
    Map<String, dynamic> alarmData, int id) async {
  try {
    final habitName = alarmData['habitName'] ?? 'Habit';
    final alarmSoundName = alarmData['alarmSoundName'] ?? 'default';
    final alarmSoundUri = alarmData['alarmSoundUri'] ?? '';

    AppLogger.info(
        '🔊 Executing background alarm for: $habitName with sound: $alarmSoundName (URI: $alarmSoundUri)');

    // If we don't have a valid URI, try to resolve it from the sound name
    String? resolvedSoundUri = alarmSoundUri;
    if (resolvedSoundUri?.isEmpty == true || resolvedSoundUri == 'default') {
      AppLogger.info(
          '🔍 No URI provided, attempting to resolve sound name: $alarmSoundName');
      resolvedSoundUri = await _resolveSoundUriFromName(alarmSoundName);
    }

    // Initialize notifications plugin for background use
    final FlutterLocalNotificationsPlugin notificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Initialize with background notification response handler
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: _handleAlarmAction,
    );

    // Create notification with custom sound if available
    AndroidNotificationDetails androidPlatformChannelSpecifics;

    if (resolvedSoundUri != null &&
        resolvedSoundUri.isNotEmpty &&
        resolvedSoundUri != 'default') {
      try {
        // Validate sound URI before using it
        if (await _isValidSoundUri(resolvedSoundUri)) {
          AppLogger.info('✅ Using resolved sound URI: $resolvedSoundUri');
          // Use the selected system sound URI with proper alarm behavior
          androidPlatformChannelSpecifics = AndroidNotificationDetails(
            'habit_alarm_channel',
            'Habit Alarms',
            channelDescription: 'High-priority alarm notifications for habits',
            importance: Importance.max,
            priority: Priority.high,
            fullScreenIntent: true,
            category: AndroidNotificationCategory.alarm,
            playSound: true,
            enableVibration: true,
            vibrationPattern: Int64List.fromList(
                [0, 1000, 500, 1000, 500, 1000]), // Repeating vibration
            ongoing: true, // Make notification persistent
            autoCancel: false, // Prevent auto-dismissal
            onlyAlertOnce: false, // Allow repeated alerts
            showWhen: true,
            when: DateTime.now().millisecondsSinceEpoch,
            usesChronometer: false,
            sound: UriAndroidNotificationSound(resolvedSoundUri),
            actions: [
              AndroidNotificationAction(
                'stop_alarm',
                'Stop',
                cancelNotification: false, // Don't auto-cancel on action
                showsUserInterface: true,
              ),
              AndroidNotificationAction(
                'snooze_alarm',
                'Snooze',
                cancelNotification: false, // Don't auto-cancel on action
                showsUserInterface: true,
              ),
            ],
          );
        } else {
          throw Exception('Invalid sound URI: $resolvedSoundUri');
        }
      } catch (e) {
        AppLogger.warning(
            'Failed to use custom sound ($resolvedSoundUri): $e, falling back to default');
        // Fall through to default sound
        androidPlatformChannelSpecifics = _createDefaultAlarmNotification();
      }
    } else {
      AppLogger.info(
          'No valid sound URI available, using default alarm notification');
      // Use default system notification sound with proper alarm behavior
      androidPlatformChannelSpecifics = _createDefaultAlarmNotification();
    }

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Create payload with alarm data for action handling
    final payload = jsonEncode({
      'habitId': alarmData['habitId'],
      'habitName': habitName,
      'alarmSoundName': alarmSoundName,
      'snoozeDelayMinutes': alarmData['snoozeDelayMinutes'] ?? 10,
      'type': 'alarm',
    });

    await notificationsPlugin.show(
      id,
      '🔔 $habitName Reminder',
      'Time to complete your habit: $habitName',
      platformChannelSpecifics,
      payload: payload,
    );

    AppLogger.info('✅ Background alarm executed for: $habitName');
  } catch (e) {
    AppLogger.error('❌ Failed to execute background alarm: $e');
  }
}

/// Validate if a sound URI is accessible and playable
Future<bool> _isValidSoundUri(String uri) async {
  try {
    // Basic URI validation
    if (uri.isEmpty || uri == 'default') return false;

    // Check if it's a content:// URI (Android content provider)
    if (uri.startsWith('content://')) {
      // For content URIs, we assume they're valid if they follow the pattern
      // Real validation would require platform channel calls to Android
      return uri.contains('media') ||
          uri.contains('ringtone') ||
          uri.contains('notification');
    }

    // Check if it's a file:// URI
    if (uri.startsWith('file://')) {
      final file = File(uri.replaceFirst('file://', ''));
      return await file.exists();
    }

    // For other URIs, assume valid for now
    return true;
  } catch (e) {
    AppLogger.warning('Sound URI validation failed: $e');
    return false;
  }
}

/// Create default alarm notification settings
AndroidNotificationDetails _createDefaultAlarmNotification() {
  return AndroidNotificationDetails(
    'habit_alarm_channel',
    'Habit Alarms',
    channelDescription: 'High-priority alarm notifications for habits',
    importance: Importance.max,
    priority: Priority.high,
    fullScreenIntent: true,
    category: AndroidNotificationCategory.alarm,
    playSound: true,
    enableVibration: true,
    vibrationPattern: Int64List.fromList(
        [0, 1000, 500, 1000, 500, 1000]), // Repeating vibration
    ongoing: true, // Make notification persistent
    autoCancel: false, // Prevent auto-dismissal
    onlyAlertOnce: false, // Allow repeated alerts
    showWhen: true,
    when: DateTime.now().millisecondsSinceEpoch,
    usesChronometer: false,
    actions: [
      AndroidNotificationAction(
        'stop_alarm',
        'Stop',
        cancelNotification: false, // Don't auto-cancel on action
        showsUserInterface: true,
      ),
      AndroidNotificationAction(
        'snooze_alarm',
        'Snooze',
        cancelNotification: false, // Don't auto-cancel on action
        showsUserInterface: true,
      ),
    ],
  );
}

/// Resolve sound URI from sound name using platform channel
Future<String?> _resolveSoundUriFromName(String soundName) async {
  try {
    // In background isolate, we can't easily access the platform channel
    // So we'll implement a fallback system using typical Android sound URIs

    AppLogger.info('🔍 Attempting to resolve sound URI for: $soundName');

    // Common system alarm sounds and their typical URIs
    final Map<String, String> commonSounds = {
      'Icicles': 'content://settings/system/ringtone_2', // Common alarm URI
      'Oxygen': 'content://settings/system/ringtone_3',
      'Timer': 'content://settings/system/alarm_alert',
      'Beep': 'content://settings/system/notification_sound',
      'Digital': 'content://media/internal/audio/media/1',
      'Chime': 'content://media/internal/audio/media/2',
      'Classic': 'content://settings/system/ringtone',
    };

    // Try to find a match for the sound name
    String? resolvedUri = commonSounds[soundName];

    if (resolvedUri != null) {
      AppLogger.info('✅ Resolved $soundName to URI: $resolvedUri');
      return resolvedUri;
    }

    // If no specific match, try to use default alarm sound
    AppLogger.warning(
        '⚠️ Could not resolve specific URI for $soundName, using default alarm');
    return 'content://settings/system/alarm_alert';
  } catch (e) {
    AppLogger.error('❌ Error resolving sound URI for $soundName: $e');
    return null;
  }
}
