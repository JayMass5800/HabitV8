import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_ringtone_manager/flutter_ringtone_manager.dart';
import 'logging_service.dart';
import 'ringtone_service.dart';

/// Service for playing alarm sounds continuously until dismissed
///
/// This service handles the continuous playback of alarm sounds that loop
/// until the user explicitly dismisses the alarm by completing or snoozing.
/// This is necessary because Android notifications don't support looping sounds natively.
class AlarmSoundPlayer {
  static final Map<int, AudioPlayer> _activePlayers = {};
  static bool _isInitialized = false;

  /// Initialize the alarm sound player service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('🔊 AlarmSoundPlayer initialized');
      _isInitialized = true;
    } catch (e) {
      AppLogger.error('Failed to initialize AlarmSoundPlayer', e);
    }
  }

  /// Start playing an alarm sound continuously
  ///
  /// [alarmId] - Unique identifier for this alarm
  /// [soundName] - Name of the sound file (without extension) or 'default' for system alarm
  /// [volume] - Volume level (0.0 to 1.0), defaults to 1.0
  static Future<void> startAlarmSound({
    required int alarmId,
    String? soundName,
    double volume = 1.0,
  }) async {
    try {
      // Stop any existing alarm sound for this ID
      await stopAlarmSound(alarmId);

      AppLogger.info(
          '🔊 Starting alarm sound for alarm $alarmId: ${soundName ?? 'default'}');

      // For Android, we can use the system alarm sound or custom sound
      if (Platform.isAndroid) {
        if (soundName == null || soundName == 'default') {
          // Use system alarm sound via RingtoneManager
          await _playSystemAlarmSound(alarmId);
        } else {
          // Use custom sound via AudioPlayer
          await _playCustomAlarmSound(alarmId, soundName, volume);
        }
      } else {
        // For iOS and other platforms, use AudioPlayer
        if (soundName != null && soundName != 'default') {
          await _playCustomAlarmSound(alarmId, soundName, volume);
        } else {
          // Fallback to system alarm
          await _playSystemAlarmSound(alarmId);
        }
      }
    } catch (e) {
      AppLogger.error('Failed to start alarm sound for alarm $alarmId', e);
    }
  }

  /// Play system alarm sound (looping)
  static Future<void> _playSystemAlarmSound(int alarmId) async {
    try {
      // For both Android and iOS, we'll use a custom alarm sound from assets
      // because system alarm sounds don't support looping reliably
      // and have permission restrictions on some devices

      // Try to play the default alarm sound from assets
      await _playCustomAlarmSound(alarmId, 'alarm', 1.0);

      AppLogger.info('🔊 Playing alarm sound (looping) for alarm $alarmId');
    } catch (e) {
      AppLogger.error('Failed to play alarm sound for alarm $alarmId', e);

      // Last resort: try flutter_ringtone_manager (won't loop but better than nothing)
      try {
        if (Platform.isAndroid) {
          // Use RingtoneService to play a system alarm sound (won't loop)
          final ringtones = await RingtoneService.getSystemRingtones();
          final alarmRingtone = ringtones.firstWhere(
            (r) => r['type'] == 'alarm',
            orElse: () => ringtones.isNotEmpty ? ringtones.first : {},
          );

          if (alarmRingtone.isNotEmpty && alarmRingtone['uri'] != null) {
            await RingtoneService.previewRingtone(alarmRingtone['uri']!);
            AppLogger.info(
                '🔊 Playing system ringtone (no loop) for alarm $alarmId');
          }
        } else {
          // For iOS, use flutter_ringtone_manager
          final ringtoneManager = FlutterRingtoneManager();
          await ringtoneManager.playAlarm();
          AppLogger.info('🔊 Playing system alarm sound for alarm $alarmId');
        }
      } catch (e2) {
        AppLogger.error('All alarm sound playback methods failed', e2);
      }
    }
  }

  /// Play custom alarm sound (looping)
  static Future<void> _playCustomAlarmSound(
    int alarmId,
    String soundName,
    double volume,
  ) async {
    try {
      final player = AudioPlayer();
      _activePlayers[alarmId] = player;

      // Set release mode to loop
      await player.setReleaseMode(ReleaseMode.loop);
      await player.setVolume(volume);

      // Play the custom sound from assets
      // Remove .mp3 extension if present
      final cleanSoundName = soundName.replaceAll('.mp3', '');
      final soundPath = 'sounds/$cleanSoundName.mp3';

      await player.play(AssetSource(soundPath));

      AppLogger.info(
          '🔊 Playing custom alarm sound (looping) for alarm $alarmId: $soundPath');
    } catch (e) {
      AppLogger.error(
          'Failed to play custom alarm sound for alarm $alarmId', e);
    }
  }

  /// Stop alarm sound for a specific alarm
  static Future<void> stopAlarmSound(int alarmId) async {
    try {
      final player = _activePlayers[alarmId];
      if (player != null) {
        await player.stop();
        await player.dispose();
        _activePlayers.remove(alarmId);
        AppLogger.info('🔇 Stopped alarm sound for alarm $alarmId');
      }

      // Also stop any system ringtone that might be playing
      if (Platform.isAndroid) {
        await RingtoneService.stopPreview();
      } else {
        final ringtoneManager = FlutterRingtoneManager();
        await ringtoneManager.stop();
      }
    } catch (e) {
      AppLogger.error('Failed to stop alarm sound for alarm $alarmId', e);
    }
  }

  /// Stop all active alarm sounds
  static Future<void> stopAllAlarmSounds() async {
    try {
      AppLogger.info(
          '🔇 Stopping all alarm sounds (${_activePlayers.length} active)');

      final alarmIds = List<int>.from(_activePlayers.keys);
      for (final alarmId in alarmIds) {
        await stopAlarmSound(alarmId);
      }

      // Also stop any system ringtone
      if (Platform.isAndroid) {
        await RingtoneService.stopPreview();
      } else {
        final ringtoneManager = FlutterRingtoneManager();
        await ringtoneManager.stop();
      }
    } catch (e) {
      AppLogger.error('Failed to stop all alarm sounds', e);
    }
  }

  /// Check if an alarm sound is currently playing
  static bool isAlarmSoundPlaying(int alarmId) {
    return _activePlayers.containsKey(alarmId);
  }

  /// Get the number of active alarm sounds
  static int getActiveAlarmCount() {
    return _activePlayers.length;
  }

  /// Dispose all resources
  static Future<void> dispose() async {
    await stopAllAlarmSounds();
    _isInitialized = false;
    AppLogger.info('🔇 AlarmSoundPlayer disposed');
  }
}
