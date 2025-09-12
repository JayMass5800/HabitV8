import 'dart:convert';
import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'services/logging_service.dart';

@pragma('vm:entry-point')
void playAlarmSound(int id) async {
  try {
    AppLogger.info('Alarm fired for ID: $id');

    await AndroidAlarmManager.initialize();

    // Try to get alarm data from file storage (works across isolates)
    final alarmData = await _getAlarmDataFromFile(id);
    
    if (alarmData != null) {
      await _executeBackgroundAlarm(alarmData, id);
      await _removeAlarmDataFile(id);
    } else {
      AppLogger.warning('No alarm data found for ID: $id, using default');
      // Fallback to generic alarm
      await _executeBackgroundAlarm({'habitName': 'Habit', 'alarmSoundName': 'default'}, id);
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
Future<void> _executeBackgroundAlarm(Map<String, dynamic> alarmData, int id) async {
  try {
    final habitName = alarmData['habitName'] ?? 'Habit';
    final alarmSoundName = alarmData['alarmSoundName'] ?? 'default';
    
    AppLogger.info('🔊 Executing background alarm for: $habitName with sound: $alarmSoundName');

    // Initialize notifications plugin for background use
    final FlutterLocalNotificationsPlugin notificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await notificationsPlugin.initialize(initializationSettings);

    // Create notification with custom sound if available
    AndroidNotificationDetails androidPlatformChannelSpecifics;
    
    if (alarmSoundName != 'default' && alarmSoundName.isNotEmpty) {
      // Try to use the selected system sound
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
      // Use default system notification sound
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
      );
    }

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await notificationsPlugin.show(
      id,
      '🔔 $habitName Reminder',
      'Time to complete your habit: $habitName',
      platformChannelSpecifics,
    );

    AppLogger.info('✅ Background alarm executed for: $habitName');
  } catch (e) {
    AppLogger.error('❌ Failed to execute background alarm: $e');
  }
}
