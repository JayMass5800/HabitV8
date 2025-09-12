import 'dart:convert';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/logging_service.dart';

/// Top-level callback function for android_alarm_manager_plus
/// This function runs in the background when an alarm fires
@pragma('vm:entry-point')
void playAlarmSound() async {
  try {
    AppLogger.info('🔊 Alarm fired - starting background callback');

    // Initialize the alarm service
    await AndroidAlarmManager.initialize();

    // Get alarm data from shared preferences
    final prefs = await SharedPreferences.getInstance();

    // Find the most recent alarm that should be firing
    final now = DateTime.now();
    String? alarmDataJson;
    String? alarmKey;

    // Look for alarm data stored by the AlarmManagerService
    final keys =
        prefs.getKeys().where((key) => key.startsWith('alarm_manager_data_'));

    AppLogger.info('🔍 Found ${keys.length} alarm data keys to check');

    for (final key in keys) {
      final data = prefs.getString(key);
      if (data != null) {
        try {
          final alarmData = jsonDecode(data);
          final scheduledTime = DateTime.parse(alarmData['scheduledTime']);

          // Check if this alarm should be firing now (within 2 minutes)
          final timeDiff = now.difference(scheduledTime).inMinutes.abs();
          AppLogger.info(
              '⏰ Checking alarm: ${alarmData['habitName']}, scheduled: $scheduledTime, diff: ${timeDiff}m');

          if (timeDiff <= 2) {
            alarmDataJson = data;
            alarmKey = key;
            AppLogger.info(
                '✅ Found matching alarm for ${alarmData['habitName']}');
            break;
          }
        } catch (e) {
          AppLogger.error('Error parsing alarm data for key $key', e);
        }
      }
    }

    if (alarmDataJson == null) {
      AppLogger.warning(
          '❌ No matching alarm data found for current time: $now');

      // Try to find any alarm data as fallback
      final fallbackKeys = prefs.getKeys().where((key) =>
          key.startsWith('hybrid_alarm_data_') ||
          key.startsWith('new_alarm_data_'));
      for (final key in fallbackKeys) {
        final data = prefs.getString(key);
        if (data != null) {
          try {
            final alarmData = jsonDecode(data);
            final scheduledTime = DateTime.parse(alarmData['scheduledTime']);
            final timeDiff = now.difference(scheduledTime).inMinutes.abs();

            if (timeDiff <= 5) {
              // More lenient for fallback
              alarmDataJson = data;
              alarmKey = key;
              AppLogger.info('🔄 Using fallback alarm data from $key');
              break;
            }
          } catch (e) {
            AppLogger.error(
                'Error parsing fallback alarm data for key $key', e);
          }
        }
      }

      if (alarmDataJson == null) {
        AppLogger.error(
            '❌ No alarm data found at all - alarm callback exiting');
        return;
      }
    }

    // Parse alarm data and execute the alarm
    final alarmData = jsonDecode(alarmDataJson);
    await _executeAlarmCallback(alarmData);

    // Clean up the alarm data after execution
    if (alarmKey != null) {
      await prefs.remove(alarmKey);
      AppLogger.info('🧹 Cleaned up alarm data: $alarmKey');
    }
  } catch (e, stackTrace) {
    AppLogger.error('❌ Error in alarm callback', e);
    AppLogger.error('Stack trace: $stackTrace');
  }
}

/// Execute the alarm callback with the provided alarm data
Future<void> _executeAlarmCallback(Map<String, dynamic> alarmData) async {
  try {
    final habitName = alarmData['habitName'] ?? 'Unknown Habit';
    final alarmSoundName = alarmData['alarmSoundName'];

    AppLogger.info('🚨 Executing alarm for habit: $habitName');
    AppLogger.info('🔊 Sound: ${alarmSoundName ?? "default"}');

    // Use platform channel to play system sound
    const platform = MethodChannel('com.habittracker.habitv8/system_sound');

    try {
      await platform.invokeMethod('playSystemSound', {
        'soundUri': alarmSoundName != 'default' ? alarmSoundName : null,
        'volume': 0.8,
        'loop': true,
        'habitName': habitName,
      });

      AppLogger.info('✅ System sound playback initiated for: $habitName');
    } catch (e) {
      AppLogger.error('❌ Failed to play system sound via platform channel', e);

      // Fallback: try to trigger a notification sound
      await _playFallbackNotificationSound(habitName);
    }

    AppLogger.info('✅ Alarm callback execution completed for: $habitName');
  } catch (e, stackTrace) {
    AppLogger.error('❌ Error executing alarm callback', e);
    AppLogger.error('Stack trace: $stackTrace');
  }
}

/// Play a fallback notification sound if platform channel fails
Future<void> _playFallbackNotificationSound(String habitName) async {
  try {
    AppLogger.info('🔄 Attempting fallback notification sound for: $habitName');

    // Try using the system notification sound as fallback
    const platform = MethodChannel('com.habittracker.habitv8/system_sound');
    await platform.invokeMethod('playSystemSound', {
      'soundUri': 'content://settings/system/notification_sound',
      'volume': 0.7,
      'loop': false,
      'habitName': habitName,
    });

    AppLogger.info('✅ Fallback notification sound played');
  } catch (e) {
    AppLogger.error('❌ Fallback notification sound also failed', e);
  }
}
