import 'package:flutter/services.dart';
import 'logging_service.dart';
import 'alarm_manager_service.dart';

/// Service to handle alarm snooze callbacks from native Android
class AlarmSnoozeService {
  static const MethodChannel _channel = MethodChannel(
    'com.habittracker.habitv8/alarm_snooze',
  );

  static bool _isInitialized = false;

  /// Initialize the alarm snooze service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('Initializing AlarmSnoozeService...');

      // Set up method call handler for snooze callbacks
      _channel.setMethodCallHandler(_handleMethodCall);

      _isInitialized = true;
      AppLogger.info('✅ AlarmSnoozeService initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize AlarmSnoozeService', e);
      rethrow;
    }
  }

  /// Handle method calls from native Android
  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    try {
      AppLogger.info('Received method call: ${call.method}');

      switch (call.method) {
        case 'onAlarmSnooze':
          final args = call.arguments as Map<Object?, Object?>;
          final habitId = args['habitId'] as String?;
          final habitName = args['habitName'] as String?;
          final soundUri = args['soundUri'] as String?;

          if (habitId != null && habitName != null) {
            await _handleSnooze(habitId, habitName, soundUri);
          } else {
            AppLogger.warning(
                'Missing habitId or habitName in snooze callback');
          }
          break;

        default:
          AppLogger.warning('Unknown method call: ${call.method}');
      }
    } catch (e) {
      AppLogger.error('Error handling method call: ${call.method}', e);
    }
  }

  /// Handle the snooze action by scheduling a new alarm
  static Future<void> _handleSnooze(
    String habitId,
    String habitName,
    String? soundUri,
  ) async {
    try {
      AppLogger.info('📅 Scheduling snooze alarm for: $habitName');

      // Default snooze delay is 10 minutes
      const snoozeDelayMinutes = 10;
      final snoozeTime =
          DateTime.now().add(const Duration(minutes: snoozeDelayMinutes));

      // Generate a unique snooze alarm ID
      final snoozeAlarmId = AlarmManagerService.generateHabitAlarmId(
        habitId,
        suffix: 'snooze',
      );

      // Schedule the snooze alarm
      await AlarmManagerService.scheduleSnoozeAlarm(
        alarmId: snoozeAlarmId,
        habitId: habitId,
        habitName: habitName,
        snoozeTime: snoozeTime,
        alarmSoundUri: soundUri,
        snoozeDelayMinutes: snoozeDelayMinutes,
      );

      AppLogger.info(
        '✅ Snooze alarm scheduled for $habitName at $snoozeTime',
      );
    } catch (e) {
      AppLogger.error('Failed to schedule snooze alarm for $habitName', e);
    }
  }
}
