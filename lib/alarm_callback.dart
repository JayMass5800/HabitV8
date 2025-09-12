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

    // Look for alarm data stored by the scheduling service
    final keys =
        prefs.getKeys().where((key) => key.startsWith('hybrid_alarm_data_'));
    for (final key in keys) {
      final data = prefs.getString(key);
      if (data != null) {
        try {
          final alarmData = jsonDecode(data);
          final scheduledTime = DateTime.parse(alarmData['scheduledTime']);

          // Check if this alarm should be firing now (within 2 minutes)
          final timeDiff = now.difference(scheduledTime).inMinutes.abs();
          if (timeDiff <= 2) {
            alarmDataJson = data;
            alarmKey = key;
            break;
          }
        } catch (e) {
          AppLogger.error('Error parsing alarm data for key $key', e);
        }
      }
    }

    if (alarmDataJson == null) {
      AppLogger.warning('No alarm data found for current time');
      return;
    }

    final alarmData = jsonDecode(alarmDataJson);
    final habitName = alarmData['habitName'] ?? 'Habit Reminder';
    final alarmSoundName = alarmData['alarmSoundName'] ?? 'default';

    AppLogger.info('🔊 Playing alarm for habit: $habitName');
    AppLogger.info('🔊 Sound: $alarmSoundName');

    // Use platform channel to play the system sound
    const platform = MethodChannel('com.habittracker.habitv8/alarm_sound');

    try {
      // Get the system sound URI
      String? soundUri;
      if (alarmSoundName == 'default') {
        soundUri = null; // Will use default alarm sound
      } else {
        // Map sound name to URI (you might want to store this mapping in shared preferences)
        soundUri = _mapSoundNameToUri(alarmSoundName);
      }

      await platform.invokeMethod('playSystemSound', {'soundUri': soundUri});

      AppLogger.info('🔊 Successfully triggered alarm sound playback');

      // Clean up the alarm data after successful playback
      if (alarmKey != null) {
        await prefs.remove(alarmKey);
        AppLogger.info('🔊 Cleaned up alarm data: $alarmKey');
      }
    } catch (e) {
      AppLogger.error('Failed to play alarm sound via platform channel', e);
    }
  } catch (e) {
    AppLogger.error('Error in playAlarmSound callback', e);
  }
}

/// Map sound names to content URIs
String? _mapSoundNameToUri(String soundName) {
  // Map common sound names to their content URIs
  // This could also be loaded from shared preferences for dynamic mapping
  final soundMap = {
    'Early Twilight': 'content://settings/system/alarm_alert',
    'Argon': 'content://settings/system/alarm_alert',
    'Cesium': 'content://settings/system/alarm_alert',
    'Scandium': 'content://settings/system/alarm_alert',
    'default': null,
  };

  return soundMap[soundName];
}
