import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'alarm_service.dart';
import 'true_alarm_service.dart';
import 'logging_service.dart';

/// Hybrid alarm service that allows users to choose between notification-based
/// alarms and true system alarms
class HybridAlarmService {
  static const String _useSystemAlarmsKey = 'use_system_alarms';
  static bool _useSystemAlarms = false;

  /// Initialize the hybrid alarm service
  static Future<void> initialize() async {
    try {
      // Load user preference
      final prefs = await SharedPreferences.getInstance();
      _useSystemAlarms = prefs.getBool(_useSystemAlarmsKey) ?? false;

      // Initialize both services
      await AlarmService.initialize();
      await TrueAlarmService.initialize();

      AppLogger.info('🚨 HybridAlarmService initialized successfully');
      AppLogger.info('  - Using system alarms: $_useSystemAlarms');
    } catch (e) {
      AppLogger.error('Failed to initialize HybridAlarmService', e);
      rethrow;
    }
  }

  /// Get whether system alarms are enabled
  static bool get useSystemAlarms => _useSystemAlarms;

  /// Set whether to use system alarms
  static Future<void> setUseSystemAlarms(bool useSystemAlarms) async {
    _useSystemAlarms = useSystemAlarms;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_useSystemAlarmsKey, useSystemAlarms);

    AppLogger.info(
      '🚨 Alarm type changed to: ${useSystemAlarms ? "System Alarms" : "Notification Alarms"}',
    );
  }

  /// Schedule an exact alarm using system alarms (for habit alarms)
  static Future<void> scheduleExactAlarm({
    required int alarmId,
    required String habitId,
    required String habitName,
    required DateTime scheduledTime,
    required String frequency,
    String? alarmSoundName,
    int snoozeDelayMinutes = 10,
    Map<String, dynamic>? additionalData,
    bool useSystemAlarms = true, // Default to system alarms for habit alarms
  }) async {
    if (useSystemAlarms) {
      await TrueAlarmService.scheduleExactAlarm(
        alarmId: alarmId,
        habitId: habitId,
        habitName: habitName,
        scheduledTime: scheduledTime,
        frequency: frequency,
        alarmSoundName: alarmSoundName,
        snoozeDelayMinutes: snoozeDelayMinutes,
        additionalData: additionalData,
      );
    } else {
      await AlarmService.scheduleExactAlarm(
        alarmId: alarmId,
        habitId: habitId,
        habitName: habitName,
        scheduledTime: scheduledTime,
        frequency: frequency,
        alarmSoundName: alarmSoundName,
        snoozeDelayMinutes: snoozeDelayMinutes,
        additionalData: additionalData,
      );
    }
  }

  /// Schedule recurring exact alarms using system alarms (for habit alarms)
  static Future<void> scheduleRecurringExactAlarm({
    required int baseAlarmId,
    required String habitId,
    required String habitName,
    required DateTime firstScheduledTime,
    required Duration interval,
    required String frequency,
    String? alarmSoundName,
    int snoozeDelayMinutes = 10,
    int maxRecurrences = 30,
    bool useSystemAlarms = true, // Default to system alarms for habit alarms
  }) async {
    if (useSystemAlarms) {
      await TrueAlarmService.scheduleRecurringExactAlarm(
        baseAlarmId: baseAlarmId,
        habitId: habitId,
        habitName: habitName,
        firstScheduledTime: firstScheduledTime,
        interval: interval,
        frequency: frequency,
        alarmSoundName: alarmSoundName,
        snoozeDelayMinutes: snoozeDelayMinutes,
        maxRecurrences: maxRecurrences,
      );
    } else {
      await AlarmService.scheduleRecurringExactAlarm(
        baseAlarmId: baseAlarmId,
        habitId: habitId,
        habitName: habitName,
        firstScheduledTime: firstScheduledTime,
        interval: interval,
        frequency: frequency,
        alarmSoundName: alarmSoundName,
        snoozeDelayMinutes: snoozeDelayMinutes,
        maxRecurrences: maxRecurrences,
      );
    }
  }

  /// Cancel an alarm using both methods to ensure cleanup
  static Future<void> cancelAlarm(int alarmId) async {
    // Cancel from both services to ensure cleanup
    await Future.wait([
      AlarmService.cancelAlarm(alarmId),
      TrueAlarmService.cancelAlarm(alarmId),
    ]);
  }

  /// Cancel all alarms for a habit using both methods
  static Future<void> cancelHabitAlarms(
    String habitId, {
    int maxAlarms = 100,
  }) async {
    // Cancel from both services to ensure cleanup
    await Future.wait([
      AlarmService.cancelHabitAlarms(habitId, maxAlarms: maxAlarms),
      TrueAlarmService.cancelHabitAlarms(habitId, maxAlarms: maxAlarms),
    ]);
  }

  /// Schedule snooze alarm using system alarms (for habit alarms)
  static Future<void> scheduleSnoozeAlarm({
    required String habitId,
    required String habitName,
    required int snoozeDelayMinutes,
    String? alarmSoundName,
    bool useSystemAlarms = true, // Default to system alarms for habit alarms
  }) async {
    if (useSystemAlarms) {
      await TrueAlarmService.scheduleSnoozeAlarm(
        habitId: habitId,
        habitName: habitName,
        snoozeDelayMinutes: snoozeDelayMinutes,
        alarmSoundName: alarmSoundName,
      );
    } else {
      await AlarmService.scheduleSnoozeAlarm(
        habitId: habitId,
        habitName: habitName,
        snoozeDelayMinutes: snoozeDelayMinutes,
        alarmSoundName: alarmSoundName,
      );
    }
  }

  /// Get available alarm sounds (use TrueAlarmService for better sound handling)
  static Future<List<Map<String, String>>> getAvailableAlarmSounds() async {
    return await TrueAlarmService.getAvailableAlarmSounds();
  }

  /// Play alarm sound preview (use TrueAlarmService for better sound handling)
  static Future<void> playAlarmSoundPreview(String soundUri) async {
    await TrueAlarmService.playAlarmSoundPreview(soundUri);
  }

  /// Stop alarm sound preview (use TrueAlarmService for better sound handling)
  static Future<void> stopAlarmSoundPreview() async {
    await TrueAlarmService.stopAlarmSoundPreview();
  }

  /// Generate unique alarm ID for habit (same for both services)
  static int generateHabitAlarmId(String habitId, {String? suffix}) {
    return AlarmService.generateHabitAlarmId(habitId, suffix: suffix);
  }

  /// Check if an alarm is currently ringing (only for system alarms)
  static Future<bool> isRinging(int alarmId) async {
    if (_useSystemAlarms) {
      return await TrueAlarmService.isRinging(alarmId);
    }
    return false; // Notification alarms don't have a "ringing" state
  }

  /// Stop a currently ringing alarm (only for system alarms)
  static Future<void> stopRingingAlarm(int alarmId) async {
    if (_useSystemAlarms) {
      await TrueAlarmService.stopRingingAlarm(alarmId);
    }
    // For notification alarms, we can cancel the notification
    await AlarmService.cancelAlarm(alarmId);
  }

  /// Get alarm type description for UI
  static String getAlarmTypeDescription() {
    if (_useSystemAlarms) {
      return 'System Alarms (Override Do Not Disturb, persistent until dismissed)';
    } else {
      return 'Notification Alarms (High-priority notifications with alarm sounds)';
    }
  }

  /// Get alarm type benefits for UI
  static List<String> getAlarmTypeBenefits() {
    if (_useSystemAlarms) {
      return [
        '✅ Override Do Not Disturb mode',
        '✅ Persistent until dismissed',
        '✅ True alarm behavior',
        '✅ Wake device from deep sleep',
        '⚠️ Requires app to be open to handle completion',
      ];
    } else {
      return [
        '✅ Quick Complete/Snooze actions',
        '✅ Works in background',
        '✅ Integrates with habit tracking',
        '⚠️ May not override Do Not Disturb',
        '⚠️ Can be dismissed like notifications',
      ];
    }
  }
}
