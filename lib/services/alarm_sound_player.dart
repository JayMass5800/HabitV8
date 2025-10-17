import 'package:audioplayers/audioplayers.dart';
import 'logging_service.dart';

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
  /// [soundUri] - Path to the sound file in assets (e.g., 'sounds/Alarm.mp3')
  /// [volume] - Volume level (0.0 to 1.0), defaults to 1.0
  static Future<void> startAlarmSound({
    required int alarmId,
    String? soundUri,
    double volume = 1.0,
  }) async {
    try {
      // Stop any existing alarm sound for this ID
      await stopAlarmSound(alarmId);

      // Default to the basic Alarm sound if none specified
      final sound = soundUri ?? 'sounds/Alarm.mp3';

      AppLogger.info('🔊 Starting alarm sound for alarm $alarmId: $sound');

      // Use custom sound via AudioPlayer
      await _playCustomAlarmSound(alarmId, sound, volume);
    } catch (e) {
      AppLogger.error('Failed to start alarm sound for alarm $alarmId', e);
    }
  }

  /// Play custom alarm sound (looping)
  static Future<void> _playCustomAlarmSound(
    int alarmId,
    String soundUri,
    double volume,
  ) async {
    try {
      AppLogger.info(
          '🔊 Attempting to play alarm sound for alarm $alarmId: $soundUri');

      final player = AudioPlayer();
      _activePlayers[alarmId] = player;

      // Listen for player state changes (for debugging)
      player.onPlayerStateChanged.listen((state) {
        AppLogger.info('🎵 Alarm $alarmId player state: $state');
      });

      // CRITICAL: Set audio context for ALARM so it bypasses mute switch
      // This is essential for alarms to work when device is silenced
      await player.setAudioContext(
        AudioContext(
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: const {AVAudioSessionOptions.duckOthers},
          ),
          android: AudioContextAndroid(
            contentType: AndroidContentType.sonification,
            usageType: AndroidUsageType.alarm,
            // CRITICAL: Use 'gain' not 'gainTransient'!
            // gainTransient = temporary focus that gets released when notification drawer opens
            // gain = permanent focus that persists until explicitly released
            audioFocus: AndroidAudioFocus.gain,
            isSpeakerphoneOn: true,
            stayAwake: true,
          ),
        ),
      );

      // Set release mode to loop
      await player.setReleaseMode(ReleaseMode.loop);
      await player.setVolume(volume);

      // Play the sound from assets using the full path
      await player.play(AssetSource(soundUri));

      AppLogger.info(
          '✅ Successfully started playing alarm sound (looping) for alarm $alarmId: $soundUri');
    } catch (e, stackTrace) {
      AppLogger.error('❌ Failed to play alarm sound for alarm $alarmId', e);
      AppLogger.error('Stack trace: $stackTrace', null);
      rethrow;
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
