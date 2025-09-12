import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'services/logging_service.dart';

@pragma('vm:entry-point')
void playAlarmSound(int id) async {
  try {
    AppLogger.info('Alarm fired for ID: $id');

    await AndroidAlarmManager.initialize();

    // Since SharedPreferences isn't shared between isolates,
    // create a generic habit alarm notification
    await _executeBackgroundAlarm(id);
  } catch (e) {
    AppLogger.error('Error in alarm callback: $e');
  }
}

/// Execute alarm in background isolate using notifications
Future<void> _executeBackgroundAlarm(int id) async {
  try {
    AppLogger.info('🔊 Executing background alarm for ID: $id');

    // Initialize notifications plugin for background use
    final FlutterLocalNotificationsPlugin notificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await notificationsPlugin.initialize(initializationSettings);

    // Create high-priority alarm notification with sound
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'habit_alarms',
      'Habit Alarms',
      channelDescription: 'Alarm notifications for habit reminders',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      playSound: true,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound('alarm_sound'),
      // Use default alarm sound since we can't access platform channels
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await notificationsPlugin.show(
      id,
      '🔔 Habit Reminder',
      'Time to complete your habit! (ID: $id)',
      platformChannelSpecifics,
    );

    AppLogger.info('✅ Background alarm executed for ID: $id');
  } catch (e) {
    AppLogger.error('❌ Failed to execute background alarm: $e');
  }
}
