import 'package:flutter/services.dart';
import 'services/logging_service.dart';

/// Native Android alarm scheduling service
/// This directly uses Android's AlarmManager instead of the AndroidAlarmManager plugin
/// to avoid platform channel issues from background isolates
class NativeAlarmService {
  static const MethodChannel _channel = MethodChannel(
    'com.habittracker.habitv8/native_alarm',
  );

  /// Schedule a native Android alarm
  static Future<bool> scheduleAlarm({
    required int alarmId,
    required DateTime triggerTime,
    required String habitName,
    String? soundUri,
  }) async {
    try {
      AppLogger.info(
        '📅 Scheduling native alarm for: $habitName at $triggerTime',
      );

      final result = await _channel.invokeMethod('scheduleNativeAlarm', {
        'alarmId': alarmId,
        'triggerTimeMillis': triggerTime.millisecondsSinceEpoch,
        'habitName': habitName,
        'soundUri': soundUri,
      });

      if (result == true) {
        AppLogger.info('✅ Native alarm scheduled successfully');
        return true;
      } else {
        AppLogger.error('❌ Failed to schedule native alarm');
        return false;
      }
    } catch (e) {
      AppLogger.error('❌ Error scheduling native alarm: $e');
      return false;
    }
  }

  /// Cancel a previously scheduled alarm
  static Future<bool> cancelAlarm(int alarmId) async {
    try {
      AppLogger.info('🗑️ Cancelling native alarm: $alarmId');

      final result = await _channel.invokeMethod('cancelNativeAlarm', {
        'alarmId': alarmId,
      });

      if (result == true) {
        AppLogger.info('✅ Native alarm cancelled successfully');
        return true;
      } else {
        AppLogger.error('❌ Failed to cancel native alarm');
        return false;
      }
    } catch (e) {
      AppLogger.error('❌ Error cancelling native alarm: $e');
      return false;
    }
  }

  /// Stop any currently playing alarm sound
  static Future<bool> stopAlarmSound() async {
    try {
      const MethodChannel systemSoundChannel = MethodChannel(
        'com.habittracker.habitv8/system_sound',
      );
      await systemSoundChannel.invokeMethod('stopSystemSound');
      AppLogger.info('✅ Alarm sound stopped');
      return true;
    } catch (e) {
      AppLogger.error('❌ Error stopping alarm sound: $e');
      return false;
    }
  }
}
