import 'dart:convert';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'services/logging_service.dart';

@pragma('vm:entry-point')
void playAlarmSound(int id) async {
  try {
    AppLogger.info('Alarm fired for ID: $id');

    await AndroidAlarmManager.initialize();

    final prefs = await SharedPreferences.getInstance();
    
    // Debug: Check all stored keys
    final allKeys = prefs.getKeys();
    AppLogger.info('All SharedPreferences keys: ${allKeys.toList()}');
    
    // Check for the specific alarm data
    final alarmDataJson = prefs.getString('alarm_manager_data_$id');
    AppLogger.info('Looking for key: alarm_manager_data_$id');
    AppLogger.info('Found data: ${alarmDataJson ?? "null"}');

    if (alarmDataJson != null) {
      final alarmData = jsonDecode(alarmDataJson);
      await _executeBackgroundAlarm(alarmData, id);
      await prefs.remove('alarm_manager_data_$id');
    } else {
      AppLogger.warning('No alarm data found for ID: $id');
      
      // Try to find any alarm data
      final alarmKeys = allKeys.where((key) => key.startsWith('alarm_manager_data_'));
      if (alarmKeys.isNotEmpty) {
        AppLogger.info('Found other alarm keys: ${alarmKeys.toList()}');
        // Use the first available alarm data for now
        final firstKey = alarmKeys.first;
        final firstData = prefs.getString(firstKey);
        if (firstData != null) {
          AppLogger.info('Using fallback alarm data from: $firstKey');
          final alarmData = jsonDecode(firstData);
          await _executeBackgroundAlarm(alarmData, id);
          await prefs.remove(firstKey);
        }
      } else {
        AppLogger.warning('No alarm data found at all');
      }
    }
  } catch (e) {
    AppLogger.error('Error in alarm callback: $e');
  }
}

/// Execute alarm in background isolate using notifications
Future<void> _executeBackgroundAlarm(
    Map<String, dynamic> alarmData, int id) async {
  try {
    final habitName = alarmData['habitName'] ?? 'Habit';
    AppLogger.info('🔊 Executing background alarm for: $habitName');

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
      '🔔 $habitName Reminder',
      'Time to complete your habit: $habitName',
      platformChannelSpecifics,
    );

    AppLogger.info('✅ Background alarm executed for: $habitName');
  } catch (e) {
    AppLogger.error('❌ Failed to execute background alarm: $e');
  }
}
