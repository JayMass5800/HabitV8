import 'dart:convert';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../alarm_callback.dart';
import 'logging_service.dart';

/// New alarm service using android_alarm_manager_plus + Platform Channel approach
/// This provides reliable system sound playback following Gemini's recommendations
class NewAlarmService {
  static bool _isInitialized = false;
  static const String _alarmDataKey = 'new_alarm_data_';
  static const MethodChannel _alarmSoundChannel =
      MethodChannel('com.habittracker.habitv8/alarm_sound');

  /// Initialize the new alarm service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize android_alarm_manager_plus
      await AndroidAlarmManager.initialize();

      AppLogger.info('🔄 NewAlarmService initialized successfully');
      _isInitialized = true;
    } catch (e) {
      AppLogger.error('Failed to initialize NewAlarmService', e);
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

    AppLogger.info('🔄 Scheduling new alarm:');
    AppLogger.info('  - Alarm ID: $alarmId');
    AppLogger.info('  - Habit: $habitName');
    AppLogger.info('  - Scheduled time: $scheduledTime');
    AppLogger.info('  - Sound: $alarmSoundName');

    try {
      // Schedule the alarm using android_alarm_manager_plus
      // This will call the playAlarmSound callback when the alarm fires
      await AndroidAlarmManager.oneShotAt(
        scheduledTime,
        alarmId,
        playAlarmSound,
        exact: true,
        wakeup: true,
        rescheduleOnReboot:
            false, // Don't reschedule on reboot to avoid confusion
      );

      AppLogger.info(
          '✅ Alarm scheduled successfully with android_alarm_manager_plus');
    } catch (e) {
      AppLogger.error(
          '❌ Failed to schedule alarm with android_alarm_manager_plus', e);
      rethrow;
    }
  }

  /// Test system sound playback directly
  static Future<void> testSystemSound([String? soundName]) async {
    try {
      AppLogger.info(
          '🔊 Testing system sound playback: ${soundName ?? "default"}');

      String? soundUri;
      if (soundName != null && soundName != 'default') {
        soundUri = _mapSoundNameToUri(soundName);
      }

      await _alarmSoundChannel.invokeMethod('playSystemSound', {
        'soundUri': soundUri,
      });

      AppLogger.info('✅ System sound test completed');
    } catch (e) {
      AppLogger.error('❌ Failed to test system sound', e);
    }
  }

  /// Stop any currently playing system sound
  static Future<void> stopSystemSound() async {
    try {
      await _alarmSoundChannel.invokeMethod('stopSystemSound');
      AppLogger.info('🔇 System sound stopped');
    } catch (e) {
      AppLogger.error('Failed to stop system sound', e);
    }
  }

  /// Pick a system sound using native Android picker
  static Future<Map<String, String>?> pickSystemSound() async {
    try {
      final result = await _alarmSoundChannel.invokeMethod('pickSystemSound');
      if (result != null) {
        return Map<String, String>.from(result);
      }
      return null;
    } catch (e) {
      AppLogger.error('Failed to pick system sound', e);
      return null;
    }
  }

  /// Cancel an alarm
  static Future<void> cancelAlarm(int alarmId) async {
    try {
      await AndroidAlarmManager.cancel(alarmId);

      // Clean up stored alarm data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_alarmDataKey$alarmId');

      AppLogger.info('✅ Alarm $alarmId cancelled');
    } catch (e) {
      AppLogger.error('Failed to cancel alarm $alarmId', e);
    }
  }

  /// Cancel all alarms
  static Future<void> cancelAllAlarms() async {
    try {
      // Get all stored alarm data keys and cancel corresponding alarms
      final prefs = await SharedPreferences.getInstance();
      final keys =
          prefs.getKeys().where((key) => key.startsWith(_alarmDataKey));

      for (final key in keys) {
        final alarmIdStr = key.substring(_alarmDataKey.length);
        final alarmId = int.tryParse(alarmIdStr);
        if (alarmId != null) {
          await AndroidAlarmManager.cancel(alarmId);
        }
        await prefs.remove(key);
      }

      AppLogger.info('✅ All alarms cancelled');
    } catch (e) {
      AppLogger.error('Failed to cancel all alarms', e);
    }
  }

  /// Map sound names to content URIs for system sounds
  static String? _mapSoundNameToUri(String soundName) {
    final soundMap = {
      'Early Twilight': 'content://settings/system/alarm_alert',
      'Argon': 'content://settings/system/alarm_alert',
      'Cesium': 'content://settings/system/alarm_alert',
      'Scandium': 'content://settings/system/alarm_alert',
      'Oxygen': 'content://settings/system/alarm_alert',
      'Helium': 'content://settings/system/alarm_alert',
      'Carbon': 'content://settings/system/alarm_alert',
      'default': null, // Will use system default
    };

    return soundMap[soundName];
  }
}
