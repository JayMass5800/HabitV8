import 'package:flutter_ringtone_manager/flutter_ringtone_manager.dart';
import 'dart:io';
import 'logging_service.dart';

/// Service for managing system alarm sounds and alarm-related functionality
class AlarmService {
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal();

  /// Get available system alarm sounds
  static Future<List<AlarmSound>> getSystemAlarmSounds() async {
    try {
      AppLogger.info('Fetching system alarm sounds');

      if (Platform.isAndroid) {
        // For now, return predefined Android alarm sounds
        // In a real implementation, you would use the actual ringtone manager
        final List<AlarmSound> androidAlarms = [
          AlarmSound(name: 'Default Alarm', uri: 'default', id: 'default'),
          AlarmSound(name: 'Classic Alarm', uri: 'classic', id: 'classic'),
          AlarmSound(name: 'Digital Alarm', uri: 'digital', id: 'digital'),
          AlarmSound(name: 'Gentle Wake', uri: 'gentle', id: 'gentle'),
          AlarmSound(name: 'Morning Bell', uri: 'morning', id: 'morning'),
          AlarmSound(name: 'Sunrise', uri: 'sunrise', id: 'sunrise'),
        ];

        AppLogger.info('Found ${androidAlarms.length} alarm sounds on Android');
        return androidAlarms;
      } else if (Platform.isIOS) {
        // iOS has predefined system sounds
        final List<AlarmSound> iosAlarms = [
          AlarmSound(name: 'Radar', uri: 'Radar', id: 'radar'),
          AlarmSound(name: 'Apex', uri: 'Apex', id: 'apex'),
          AlarmSound(name: 'Beacon', uri: 'Beacon', id: 'beacon'),
          AlarmSound(name: 'Bulletin', uri: 'Bulletin', id: 'bulletin'),
          AlarmSound(
            name: 'By The Seaside',
            uri: 'By The Seaside',
            id: 'by_the_seaside',
          ),
          AlarmSound(name: 'Chimes', uri: 'Chimes', id: 'chimes'),
          AlarmSound(name: 'Circuit', uri: 'Circuit', id: 'circuit'),
          AlarmSound(
            name: 'Constellation',
            uri: 'Constellation',
            id: 'constellation',
          ),
          AlarmSound(name: 'Cosmic', uri: 'Cosmic', id: 'cosmic'),
          AlarmSound(name: 'Crystals', uri: 'Crystals', id: 'crystals'),
          AlarmSound(name: 'Hillside', uri: 'Hillside', id: 'hillside'),
          AlarmSound(name: 'Illuminate', uri: 'Illuminate', id: 'illuminate'),
          AlarmSound(name: 'Night Owl', uri: 'Night Owl', id: 'night_owl'),
          AlarmSound(name: 'Opening', uri: 'Opening', id: 'opening'),
          AlarmSound(name: 'Playtime', uri: 'Playtime', id: 'playtime'),
          AlarmSound(name: 'Presto', uri: 'Presto', id: 'presto'),
          AlarmSound(name: 'Ripples', uri: 'Ripples', id: 'ripples'),
          AlarmSound(name: 'Sencha', uri: 'Sencha', id: 'sencha'),
          AlarmSound(name: 'Signal', uri: 'Signal', id: 'signal'),
          AlarmSound(name: 'Silk', uri: 'Silk', id: 'silk'),
          AlarmSound(name: 'Slow Rise', uri: 'Slow Rise', id: 'slow_rise'),
          AlarmSound(name: 'Stargaze', uri: 'Stargaze', id: 'stargaze'),
          AlarmSound(name: 'Summit', uri: 'Summit', id: 'summit'),
          AlarmSound(name: 'Twinkle', uri: 'Twinkle', id: 'twinkle'),
          AlarmSound(name: 'Uplift', uri: 'Uplift', id: 'uplift'),
          AlarmSound(name: 'Waves', uri: 'Waves', id: 'waves'),
        ];

        AppLogger.info('Using ${iosAlarms.length} predefined iOS alarm sounds');
        return iosAlarms;
      } else {
        // Fallback for other platforms
        AppLogger.warning(
          'Platform not supported for alarm sounds, using default',
        );
        return [
          AlarmSound(name: 'Default Alarm', uri: 'default', id: 'default'),
        ];
      }
    } catch (e) {
      AppLogger.error('Error fetching system alarm sounds', e);
      // Return a default alarm sound if there's an error
      return [AlarmSound(name: 'Default Alarm', uri: 'default', id: 'default')];
    }
  }

  /// Play a preview of the selected alarm sound
  static Future<void> playAlarmPreview(AlarmSound alarmSound) async {
    try {
      AppLogger.info('Playing alarm preview: ${alarmSound.name}');

      // For now, just log the preview play action
      // In a real implementation, you would play the actual sound
      AppLogger.info(
        'Would play alarm sound: ${alarmSound.name} (${alarmSound.uri})',
      );
    } catch (e) {
      AppLogger.error('Error playing alarm preview', e);
    }
  }

  /// Stop any currently playing alarm preview
  static Future<void> stopAlarmPreview() async {
    try {
      AppLogger.info('Stopping alarm preview');
      // For now, just log the stop action
      // In a real implementation, you would stop the actual sound
      AppLogger.info('Would stop alarm sound preview');
    } catch (e) {
      AppLogger.error('Error stopping alarm preview', e);
    }
  }

  /// Get the default alarm sound for the platform
  static AlarmSound getDefaultAlarmSound() {
    if (Platform.isAndroid) {
      return AlarmSound(name: 'Default Alarm', uri: 'default', id: 'default');
    } else if (Platform.isIOS) {
      return AlarmSound(name: 'Radar', uri: 'Radar', id: 'radar');
    } else {
      return AlarmSound(name: 'Default Alarm', uri: 'default', id: 'default');
    }
  }

  /// Get available alarm sound names (simplified version for UI)
  static Future<List<String>> getAvailableAlarmSounds() async {
    try {
      final alarmSounds = await getSystemAlarmSounds();
      return alarmSounds.map((sound) => sound.name).toList();
    } catch (e) {
      AppLogger.error('Error getting available alarm sounds', e);
      return [
        'Default Alarm',
        'Classic Alarm',
        'Gentle Wake',
        'Morning Bell',
        'Sunrise',
      ];
    }
  }

  /// Get snooze delay options in minutes
  static List<int> getSnoozeDelayOptions() {
    return [5, 10, 15, 30, 45, 60];
  }

  /// Get display text for snooze delay
  static String getSnoozeDelayText(int minutes) {
    if (minutes < 60) {
      return '$minutes minutes';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '$hours hour${hours > 1 ? 's' : ''}';
      } else {
        return '$hours hour${hours > 1 ? 's' : ''} $remainingMinutes minutes';
      }
    }
  }
}

/// Model class for alarm sounds
class AlarmSound {
  final String name;
  final String uri;
  final String id;

  AlarmSound({required this.name, required this.uri, required this.id});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmSound && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AlarmSound(name: $name, id: $id)';
}
