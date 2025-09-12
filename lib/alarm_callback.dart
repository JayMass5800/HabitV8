import 'dart:convert';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/logging_service.dart';

@pragma('vm:entry-point')
void playAlarmSound(int id) async {
  try {
    AppLogger.info('Alarm fired for ID: $id');

    await AndroidAlarmManager.initialize();

    final prefs = await SharedPreferences.getInstance();
    final alarmDataJson = prefs.getString('alarm_manager_data_$id');

    if (alarmDataJson != null) {
      final alarmData = jsonDecode(alarmDataJson);
      await executeAlarm(alarmData);
      await prefs.remove('alarm_manager_data_$id');
    } else {
      AppLogger.warning('No alarm data found for ID: $id');
    }
  } catch (e) {
    AppLogger.error('Error in alarm callback: $e');
  }
}

Future<void> executeAlarm(Map<String, dynamic> alarmData) async {
  try {
    const platform = MethodChannel('com.habittracker.habitv8/system_sound');
    final soundUri = alarmData['alarmSoundName'] ?? 'default';

    await platform.invokeMethod('playSystemSound', {'soundUri': soundUri});
    AppLogger.info('Alarm executed for: ${alarmData['habitName']}');
  } catch (e) {
    AppLogger.error('Error executing alarm: $e');
  }
}
