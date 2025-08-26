import 'dart:async';
import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:flutter_ringtone_manager/flutter_ringtone_manager.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'logging_service.dart';

/// True alarm service using the alarm package for system-level alarms
/// that can override Do Not Disturb and provide persistent alarm behavior
class TrueAlarmService {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool _isInitialized = false;
  static const String _alarmDataKey = 'true_alarm_data_';

  /// Initialize the true alarm service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize the alarm package
      await Alarm.init();

      // Listen for alarm ring events to handle app opening
      Alarm.ringStream.stream.listen((alarmSettings) {
        AppLogger.info('🚨 Alarm ringing: ${alarmSettings.id}');
        // The alarm package automatically handles opening the app when the alarm rings
        // or when the notification is tapped
      });

      AppLogger.info('🚨 TrueAlarmService initialized successfully');
      _isInitialized = true;
    } catch (e) {
      AppLogger.error('Failed to initialize TrueAlarmService', e);
      rethrow;
    }
  }

  /// Schedule a true system alarm for a habit
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

    // Store alarm data for reference
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

    AppLogger.info('🚨 Scheduling true system alarm:');
    AppLogger.info('  - Alarm ID: $alarmId');
    AppLogger.info('  - Habit: $habitName');
    AppLogger.info('  - Scheduled time: $scheduledTime');
    AppLogger.info('  - Sound: $alarmSoundName');

    try {
      // Get the alarm sound path
      final soundPath = await _getAlarmSoundPath(alarmSoundName);

      // Create alarm settings
      final alarmSettings = AlarmSettings(
        id: alarmId,
        dateTime: scheduledTime,
        assetAudioPath: soundPath,
        loopAudio: true,
        vibrate: true,
        volumeSettings: VolumeSettings.fade(
          volume: 1.0,
          fadeDuration: const Duration(seconds: 3),
        ),
        notificationSettings: NotificationSettings(
          title: '🚨 HABIT ALARM: $habitName',
          body: 'Time to complete your habit! Tap to open the app.',
          stopButton: 'Stop Alarm',
          icon: 'notification_icon',
        ),
      );

      // Set the alarm
      await Alarm.set(alarmSettings: alarmSettings);

      AppLogger.info('✅ True system alarm scheduled successfully');
      AppLogger.info('  - Alarm ID: $alarmId');
      AppLogger.info('  - Scheduled for: $scheduledTime');
      AppLogger.info('  - Sound path: $soundPath');
    } catch (e) {
      AppLogger.error('❌ Failed to schedule true system alarm', e);
      rethrow;
    }
  }

  /// Schedule recurring true system alarms for a habit
  static Future<void> scheduleRecurringExactAlarm({
    required int baseAlarmId,
    required String habitId,
    required String habitName,
    required DateTime firstScheduledTime,
    required Duration interval,
    required String frequency,
    String? alarmSoundName,
    int snoozeDelayMinutes = 10,
    int maxRecurrences =
        7, // Schedule for next 7 occurrences to avoid conflicts
  }) async {
    AppLogger.info('🚨 Scheduling recurring true system alarms for $habitName');
    AppLogger.info('  - Base ID: $baseAlarmId');
    AppLogger.info('  - First time: $firstScheduledTime');
    AppLogger.info('  - Interval: $interval');
    AppLogger.info('  - Max recurrences: $maxRecurrences');
    AppLogger.info('  - Current time: ${DateTime.now()}');

    DateTime currentTime = firstScheduledTime;

    for (int i = 0; i < maxRecurrences; i++) {
      final alarmId = baseAlarmId + i;

      AppLogger.info('  - Scheduling alarm $i: ID=$alarmId, Time=$currentTime');

      await scheduleExactAlarm(
        alarmId: alarmId,
        habitId: habitId,
        habitName: habitName,
        scheduledTime: currentTime,
        frequency: frequency,
        alarmSoundName: alarmSoundName,
        snoozeDelayMinutes: snoozeDelayMinutes,
        additionalData: {'recurrence': i, 'baseId': baseAlarmId},
      );

      currentTime = currentTime.add(interval);
    }

    AppLogger.info('✅ Scheduled $maxRecurrences recurring true system alarms');

    // Debug: Log all currently scheduled alarms
    await debugLogAllAlarms();
  }

  /// Cancel a true system alarm
  static Future<void> cancelAlarm(int alarmId) async {
    try {
      // Stop the alarm
      await Alarm.stop(alarmId);

      // Clean up stored alarm data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_alarmDataKey$alarmId');

      AppLogger.info('🚨 Cancelled true system alarm ID: $alarmId');
    } catch (e) {
      AppLogger.error('❌ Failed to cancel true system alarm $alarmId', e);
    }
  }

  /// Cancel all alarms for a habit
  static Future<void> cancelHabitAlarms(
    String habitId, {
    int maxAlarms = 100,
  }) async {
    AppLogger.info('🚨 Cancelling all true system alarms for habit: $habitId');

    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    int cancelledCount = 0;

    for (String key in keys) {
      if (key.startsWith(_alarmDataKey)) {
        try {
          final alarmDataJson = prefs.getString(key);
          if (alarmDataJson != null) {
            final alarmData = jsonDecode(alarmDataJson);
            if (alarmData['habitId'] == habitId) {
              final alarmId = int.tryParse(key.substring(_alarmDataKey.length));
              if (alarmId != null) {
                await Alarm.stop(alarmId);
                await prefs.remove(key);
                cancelledCount++;
              }
            }
          }
        } catch (e) {
          AppLogger.error('Error processing alarm data for key $key', e);
        }
      }
    }

    AppLogger.info(
      '✅ Cancelled $cancelledCount true system alarms for habit: $habitId',
    );
  }

  /// Schedule snooze alarm
  static Future<void> scheduleSnoozeAlarm({
    required String habitId,
    required String habitName,
    required int snoozeDelayMinutes,
    String? alarmSoundName,
  }) async {
    final snoozeTime = DateTime.now().add(
      Duration(minutes: snoozeDelayMinutes),
    );
    final snoozeAlarmId = _generateSnoozeAlarmId(habitId);

    await scheduleExactAlarm(
      alarmId: snoozeAlarmId,
      habitId: habitId,
      habitName: habitName,
      scheduledTime: snoozeTime,
      frequency: 'snooze',
      alarmSoundName: alarmSoundName,
      snoozeDelayMinutes: snoozeDelayMinutes,
      additionalData: {'isSnooze': true},
    );

    AppLogger.info(
      '⏰ Scheduled snooze true system alarm for $habitName in $snoozeDelayMinutes minutes',
    );
  }

  /// Get available system alarm sounds
  static Future<List<Map<String, String>>> getAvailableAlarmSounds() async {
    return [
      // System sounds
      {'name': 'Default System Alarm', 'uri': 'default', 'type': 'system'},
      {'name': 'System Alarm', 'uri': 'alarm', 'type': 'system'},
      {'name': 'System Ringtone', 'uri': 'ringtone', 'type': 'system'},
      {'name': 'System Notification', 'uri': 'notification', 'type': 'system'},

      // Custom sounds (only include sounds that actually exist)
      {
        'name': 'Gentle Chime',
        'uri': 'assets/sounds/gentle_chime.mp3',
        'type': 'custom',
      },
      {
        'name': 'Morning Bell',
        'uri': 'assets/sounds/morning_bell.mp3',
        'type': 'custom',
      },
      {
        'name': 'Nature Birds',
        'uri': 'assets/sounds/nature_birds.mp3',
        'type': 'custom',
      },
      {
        'name': 'Digital Beep',
        'uri': 'assets/sounds/digital_beep.mp3',
        'type': 'custom',
      },
      {
        'name': 'Zen Gong',
        'uri': 'assets/sounds/zen_gong.mp3',
        'type': 'custom',
      },
      {
        'name': 'Upbeat Melody',
        'uri': 'assets/sounds/upbeat_melody.mp3',
        'type': 'custom',
      },
      {
        'name': 'Soft Piano',
        'uri': 'assets/sounds/soft_piano.mp3',
        'type': 'custom',
      },
      {
        'name': 'Ocean Waves',
        'uri': 'assets/sounds/ocean_waves.mp3',
        'type': 'custom',
      },
    ];
  }

  /// Play alarm sound preview
  static Future<void> playAlarmSoundPreview(String soundUri) async {
    try {
      // Stop any currently playing sound
      await stopAlarmSoundPreview();

      if (soundUri.startsWith('assets/')) {
        // Play custom sound using audioplayers
        final assetPath = soundUri.replaceFirst('assets/', '');
        AppLogger.info(
            'Attempting to play custom sound: $soundUri -> $assetPath');

        await _audioPlayer.play(AssetSource(assetPath));
        AppLogger.info('✅ Playing custom sound preview: $soundUri');
      } else {
        // Play system sound using flutter_ringtone_manager
        if (Platform.isAndroid) {
          AppLogger.info('Attempting to play system sound: $soundUri');
          final ringtoneManager = FlutterRingtoneManager();

          switch (soundUri) {
            case 'default':
            case 'alarm':
              await ringtoneManager.playAlarm();
              AppLogger.info('✅ Playing system alarm sound');
              break;
            case 'ringtone':
              await ringtoneManager.playRingtone();
              AppLogger.info('✅ Playing system ringtone sound');
              break;
            case 'notification':
              await ringtoneManager.playNotification();
              AppLogger.info('✅ Playing system notification sound');
              break;
            default:
              await ringtoneManager.playAlarm();
              AppLogger.info('✅ Playing default system alarm sound');
          }
        } else {
          AppLogger.warning('System sounds only supported on Android');
        }
      }
    } catch (e) {
      AppLogger.error('Failed to play alarm sound preview: $soundUri', e);
    }
  }

  /// Stop alarm sound preview
  static Future<void> stopAlarmSoundPreview() async {
    try {
      // Stop audioplayers
      await _audioPlayer.stop();

      // Stop system ringtone manager
      if (Platform.isAndroid) {
        final ringtoneManager = FlutterRingtoneManager();
        await ringtoneManager.stop();
      }
    } catch (e) {
      AppLogger.error('Failed to stop alarm sound preview', e);
    }
  }

  /// Check if an alarm is currently ringing
  static Future<bool> isRinging(int alarmId) async {
    return await Alarm.isRinging(alarmId);
  }

  /// Get all currently set alarms
  static Future<List<AlarmSettings>> getAlarms() async {
    return await Alarm.getAlarms();
  }

  /// Debug method to log all currently scheduled alarms
  static Future<void> debugLogAllAlarms() async {
    try {
      final alarms = await Alarm.getAlarms();
      AppLogger.info('🔍 Currently scheduled alarms: ${alarms.length}');

      for (final alarm in alarms) {
        AppLogger.info('  - ID: ${alarm.id}, Time: ${alarm.dateTime}');
      }
    } catch (e) {
      AppLogger.error('❌ Failed to get alarms for debugging', e);
    }
  }

  /// Stop a currently ringing alarm
  static Future<void> stopRingingAlarm(int alarmId) async {
    try {
      await Alarm.stop(alarmId);
      AppLogger.info('🚨 Stopped ringing alarm ID: $alarmId');
    } catch (e) {
      AppLogger.error('❌ Failed to stop ringing alarm $alarmId', e);
    }
  }

  /// Generate unique alarm ID for habit
  static int generateHabitAlarmId(String habitId, {String? suffix}) {
    int hash = 0;
    final fullId = suffix != null ? '${habitId}_$suffix' : habitId;

    for (int i = 0; i < fullId.length; i++) {
      hash = ((hash << 5) - hash + fullId.codeUnitAt(i)) & 0x7FFFFFFF;
    }

    // Ensure positive ID in safe range (1-2147483647)
    return (hash % 2147483646) + 1;
  }

  /// Generate snooze alarm ID
  static int _generateSnoozeAlarmId(String habitId) {
    return generateHabitAlarmId(habitId, suffix: 'snooze');
  }

  /// Get the appropriate sound path for the alarm package
  static Future<String> _getAlarmSoundPath(String? alarmSoundName) async {
    if (alarmSoundName == null || alarmSoundName == 'Default System Alarm') {
      // Use our best system alarm sound asset
      return await _getSystemAlarmSound();
    }

    // Handle sound names from the sound picker
    switch (alarmSoundName) {
      // System sound names (from the sound picker) - use high-quality asset equivalents
      case 'System Alarm':
        return await _getSystemAlarmSound();
      case 'System Ringtone':
        return await _getSystemRingtoneSound();
      case 'System Notification':
        return await _getSystemNotificationSound();

      // Custom sound names (from the sound picker)
      case 'Gentle Chime':
        return 'assets/sounds/gentle_chime.mp3';
      case 'Morning Bell':
        return 'assets/sounds/morning_bell.mp3';
      case 'Nature Birds':
        return 'assets/sounds/nature_birds.mp3';
      case 'Digital Beep':
        return 'assets/sounds/digital_beep.mp3';
      case 'Zen Gong':
        return 'assets/sounds/zen_gong.mp3';
      case 'Upbeat Melody':
        return 'assets/sounds/upbeat_melody.mp3';
      case 'Soft Piano':
        return 'assets/sounds/soft_piano.mp3';
      case 'Ocean Waves':
        return 'assets/sounds/ocean_waves.mp3';

      // Legacy URI-based handling (for backward compatibility)
      case 'default':
        return await _getSystemAlarmSound();
      case 'alarm':
        return await _getSystemAlarmSound();
      case 'ringtone':
        return await _getSystemRingtoneSound();
      case 'notification':
        return await _getSystemNotificationSound();

      default:
        // If it's already an asset path, use it directly
        if (alarmSoundName.startsWith('assets/')) {
          return alarmSoundName;
        }
        // Fallback to default sound
        AppLogger.warning(
            'Unknown alarm sound: $alarmSoundName, using default');
        return await _getSystemAlarmSound();
    }
  }

  /// Get best alarm sound for system alarm type
  /// Since the alarm package requires asset paths, we use our best alarm sound assets
  static Future<String> _getSystemAlarmSound() async {
    AppLogger.info('Using high-quality alarm sound asset for system alarm');
    return 'assets/sounds/digital_beep.mp3'; // Sharp, attention-getting alarm sound
  }

  /// Get best ringtone sound for system ringtone type
  static Future<String> _getSystemRingtoneSound() async {
    AppLogger.info(
        'Using high-quality ringtone sound asset for system ringtone');
    return 'assets/sounds/morning_bell.mp3'; // Pleasant but attention-getting
  }

  /// Get best notification sound for system notification type
  static Future<String> _getSystemNotificationSound() async {
    AppLogger.info(
        'Using gentle notification sound asset for system notification');
    return 'assets/sounds/gentle_chime.mp3'; // Gentle but noticeable
  }
}
