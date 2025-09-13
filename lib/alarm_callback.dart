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
    AppLogger.info('🔔 Alarm action received: ${notificationResponse.actionId}');
    
    final int notificationId = notificationResponse.id ?? 0;
    
    if (notificationResponse.actionId == 'stop_alarm') {
      AppLogger.info('⏹️ Stopping alarm notification $notificationId');
      
      // Cancel the notification
      final FlutterLocalNotificationsPlugin notificationsPlugin =
          FlutterLocalNotificationsPlugin();
      await notificationsPlugin.cancel(notificationId);
      
    } else if (notificationResponse.actionId == 'snooze_alarm') {
      AppLogger.info('😴 Snoozing alarm notification $notificationId');
      
      // Cancel current notification and reschedule for 10 minutes later
      final FlutterLocalNotificationsPlugin notificationsPlugin =
          FlutterLocalNotificationsPlugin();
      await notificationsPlugin.cancel(notificationId);
      
      // Try to get alarm data and reschedule
      final alarmData = await _getAlarmDataFromFile(notificationId);
      if (alarmData != null) {
        final snoozeDelayMinutes = alarmData['snoozeDelayMinutes'] ?? 10;
        final snoozeTime = DateTime.now().add(Duration(minutes: snoozeDelayMinutes));
        
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

    AppLogger.info(
        '🔊 Executing background alarm for: $habitName with sound: $alarmSoundName');

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

    if (alarmSoundName != 'default' && alarmSoundName.isNotEmpty) {
      // Try to use the selected system sound with proper alarm behavior
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
        vibrationPattern: Int64List.fromList([0, 1000, 500, 1000, 500, 1000]), // Repeating vibration
        ongoing: true, // Make notification persistent
        autoCancel: false, // Prevent auto-dismissal
        sound: UriAndroidNotificationSound(alarmSoundName),
        actions: [
          AndroidNotificationAction(
            'stop_alarm',
            'Stop',
            cancelNotification: true,
            showsUserInterface: false,
          ),
          AndroidNotificationAction(
            'snooze_alarm',
            'Snooze',
            cancelNotification: true,
            showsUserInterface: false,
          ),
        ],
      );
    } else {
      // Use default system notification sound with proper alarm behavior
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
        vibrationPattern: Int64List.fromList([0, 1000, 500, 1000, 500, 1000]), // Repeating vibration
        ongoing: true, // Make notification persistent
        autoCancel: false, // Prevent auto-dismissal
        actions: [
          AndroidNotificationAction(
            'stop_alarm',
            'Stop',
            cancelNotification: true,
            showsUserInterface: false,
          ),
          AndroidNotificationAction(
            'snooze_alarm',
            'Snooze',
            cancelNotification: true,
            showsUserInterface: false,
          ),
        ],
      );
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
