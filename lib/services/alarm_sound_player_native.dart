import 'package:flutter/services.dart';
import 'logging_service.dart';

/// Native Android alarm sound player using Ringtone API
///
/// This uses Android's native Ringtone API which properly handles:
/// - Alarm audio stream (bypasses silent mode)
/// - Audio focus (maintains during device interactions)
/// - Speaker routing (plays through speaker even with headphones connected)
/// - Looping (plays continuously until stopped)
class NativeAlarmSoundPlayer {
  static const String _channel = 'com.habittracker.habitv8/native_alarm';
  static const platform = MethodChannel(_channel);

  static final Map<int, bool> _activeSounds = {};

  /// Start playing an alarm sound using native Android API
  ///
  /// [alarmId] - Unique identifier for this alarm
  /// [soundUri] - Path to the sound file in assets or system ringtone URI
  /// [volume] - Volume level (0.0 to 1.0), defaults to 1.0
  static Future<void> startAlarmSound({
    required int alarmId,
    String? soundUri,
    double volume = 1.0,
  }) async {
    try {
      AppLogger.info('🚨 Starting native alarm sound for alarm $alarmId');
      AppLogger.info('   Sound URI: ${soundUri ?? 'default'}');
      AppLogger.info('   Volume: $volume');

      // If a custom sound is specified, use it; otherwise use system default
      final sound = soundUri ?? 'default';

      // Call native Android code to play the alarm
      final bool result = await platform.invokeMethod<bool>('playAlarmSound', {
            'alarmId': alarmId,
            'soundUri': sound,
            'volume': volume,
          }) ??
          false;

      if (result) {
        _activeSounds[alarmId] = true;
        AppLogger.info(
            '✅ Native alarm sound started successfully for alarm $alarmId');
      } else {
        AppLogger.error(
            '❌ Native alarm sound failed to start for alarm $alarmId', null);
      }
    } catch (e) {
      AppLogger.error(
          'Failed to start native alarm sound for alarm $alarmId', e);
    }
  }

  /// Stop alarm sound for a specific alarm
  static Future<void> stopAlarmSound(int alarmId) async {
    try {
      AppLogger.info('🔇 Stopping native alarm sound for alarm $alarmId');
      AppLogger.info('   Active sounds before stop: ${_activeSounds.keys}');

      final result = await platform.invokeMethod('stopAlarmSound', {
        'alarmId': alarmId,
      });

      _activeSounds.remove(alarmId);
      AppLogger.info(
          '✅ Native alarm sound stopped for alarm $alarmId (result: $result)');
      AppLogger.info('   Active sounds after stop: ${_activeSounds.keys}');
    } catch (e) {
      AppLogger.error(
          'Failed to stop native alarm sound for alarm $alarmId', e);
      // Force remove from tracking if method call fails
      _activeSounds.remove(alarmId);
    }
  }

  /// Stop all active alarm sounds
  static Future<void> stopAllAlarmSounds() async {
    try {
      AppLogger.info(
          '🔇 Stopping all native alarm sounds (${_activeSounds.length} active)');

      final alarmIds = List<int>.from(_activeSounds.keys);
      for (final alarmId in alarmIds) {
        await stopAlarmSound(alarmId);
      }
    } catch (e) {
      AppLogger.error('Failed to stop all native alarm sounds', e);
    }
  }

  /// Check if an alarm sound is currently playing
  static bool isAlarmSoundPlaying(int alarmId) {
    return _activeSounds.containsKey(alarmId);
  }

  /// Get the number of active alarm sounds
  static int getActiveAlarmCount() {
    return _activeSounds.length;
  }
}
