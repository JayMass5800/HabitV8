import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import 'logging_service.dart';
import 'permission_service.dart';
import 'preferences_service.dart';

@pragma('vm:entry-point')
class AlarmService {
  static bool _isInitialized = false;
  static const String _alarmDataKey = 'alarm_data_';

  /// Initialize the alarm service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Verify AwesomeNotifications is initialized (should be done by NotificationCore)
      if (!await AwesomeNotifications().isNotificationAllowed()) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }

      AppLogger.info('🚨 AlarmService initialized successfully');
      _isInitialized = true;
    } catch (e) {
      AppLogger.error('Failed to initialize AlarmService', e);
      rethrow;
    }
  }

  /// Schedule an exact alarm for a habit
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

    await PreferencesService.setString(
        '$_alarmDataKey$alarmId', jsonEncode(alarmData));

    AppLogger.info('🚨 Scheduling exact alarm:');
    AppLogger.info('  - Alarm ID: $alarmId');
    AppLogger.info('  - Habit: $habitName');
    AppLogger.info('  - Scheduled time: $scheduledTime');
    AppLogger.info('  - Sound: $alarmSoundName');

    try {
      // Use awesome_notifications for scheduling
      await _scheduleNotificationAlarm(
        alarmId: alarmId,
        habitId: habitId,
        habitName: habitName,
        scheduledTime: scheduledTime,
        alarmSoundName: alarmSoundName,
        snoozeDelayMinutes: snoozeDelayMinutes,
      );

      AppLogger.info('✅ Exact alarm scheduled successfully');
    } catch (e) {
      AppLogger.error('❌ Failed to schedule exact alarm', e);
      rethrow;
    }
  }

  /// Schedule recurring exact alarms for a habit
  static Future<void> scheduleRecurringExactAlarm({
    required int baseAlarmId,
    required String habitId,
    required String habitName,
    required DateTime firstScheduledTime,
    required Duration interval,
    required String frequency,
    String? alarmSoundName,
    int snoozeDelayMinutes = 10,
    int maxRecurrences = 30, // Schedule for next 30 occurrences
  }) async {
    if (!Platform.isAndroid) {
      AppLogger.warning('Exact alarms only supported on Android');
      return;
    }

    AppLogger.info('🚨 Scheduling recurring exact alarms for $habitName');
    AppLogger.info('  - Base ID: $baseAlarmId');
    AppLogger.info('  - First time: $firstScheduledTime');
    AppLogger.info('  - Interval: $interval');
    AppLogger.info('  - Max recurrences: $maxRecurrences');

    DateTime currentTime = firstScheduledTime;

    for (int i = 0; i < maxRecurrences; i++) {
      final alarmId = baseAlarmId + i;

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

    AppLogger.info('✅ Scheduled $maxRecurrences recurring alarms');
  }

  /// Cancel an alarm
  static Future<void> cancelAlarm(int alarmId) async {
    try {
      // Cancel the scheduled notification
      await AwesomeNotifications().cancel(alarmId);

      // Clean up stored alarm data
      await PreferencesService.remove('$_alarmDataKey$alarmId');

      AppLogger.info('🚨 Cancelled alarm ID: $alarmId');
    } catch (e) {
      AppLogger.error('❌ Failed to cancel alarm $alarmId', e);
    }
  }

  /// Cancel all alarms for a habit
  static Future<void> cancelHabitAlarms(
    String habitId, {
    int maxAlarms = 100,
  }) async {
    AppLogger.info('🚨 Cancelling all alarms for habit: $habitId');

    final keys = await PreferencesService.getKeys();

    int cancelledCount = 0;

    for (String key in keys) {
      if (key.startsWith(_alarmDataKey)) {
        try {
          final alarmDataJson = await PreferencesService.getString(key);
          if (alarmDataJson != null) {
            final alarmData = jsonDecode(alarmDataJson);
            if (alarmData['habitId'] == habitId) {
              final alarmId = int.tryParse(key.substring(_alarmDataKey.length));
              if (alarmId != null) {
                await AwesomeNotifications().cancel(alarmId);
                await PreferencesService.remove(key);
                cancelledCount++;
              }
            }
          }
        } catch (e) {
          AppLogger.error('Error processing alarm data for key $key', e);
        }
      }
    }

    AppLogger.info('✅ Cancelled $cancelledCount alarms for habit: $habitId');
  }

  /// Get available alarm sounds from app assets
  /// Returns all custom alarm sounds bundled with the app
  static Future<List<Map<String, String>>> getAvailableAlarmSounds() async {
    // All custom alarm sounds from sounds folder
    // IMPORTANT: File names must be lowercase to match Android resource naming conventions
    // Audio files converted to OGG Vorbis format for better compression (~30% smaller)
    final customSounds = [
      {'name': 'Alarm', 'uri': 'sounds/alarm.ogg', 'type': 'custom'},
      {'name': 'Alarm 1', 'uri': 'sounds/alarm_1.ogg', 'type': 'custom'},
      {'name': 'Alarm 2', 'uri': 'sounds/alarm_2.ogg', 'type': 'custom'},
      {'name': 'Alarm 3', 'uri': 'sounds/alarm_3.ogg', 'type': 'custom'},
      {'name': 'Alarm 4', 'uri': 'sounds/alarm_4.ogg', 'type': 'custom'},
      {'name': 'Alarm Mix', 'uri': 'sounds/alarm_mix.ogg', 'type': 'custom'},
      {'name': 'Alarm Pro', 'uri': 'sounds/alarm_pro.ogg', 'type': 'custom'},
      {'name': 'Army Alarm', 'uri': 'sounds/army_alarm.ogg', 'type': 'custom'},
      {'name': 'Auto Alarm', 'uri': 'sounds/auto_alarm.ogg', 'type': 'custom'},
      {'name': 'Beeps', 'uri': 'sounds/beeps.ogg', 'type': 'custom'},
      {'name': 'Bell', 'uri': 'sounds/bell.ogg', 'type': 'custom'},
      {'name': 'Best Alarm', 'uri': 'sounds/best_alarm.ogg', 'type': 'custom'},
      {'name': 'Bubble', 'uri': 'sounds/bubble.ogg', 'type': 'custom'},
      {'name': 'Classic', 'uri': 'sounds/classic.ogg', 'type': 'custom'},
      {'name': 'Dreamy', 'uri': 'sounds/dreamy.ogg', 'type': 'custom'},
      {'name': 'Fade In', 'uri': 'sounds/fade_in.ogg', 'type': 'custom'},
      {'name': 'Instance', 'uri': 'sounds/instance.ogg', 'type': 'custom'},
      {'name': 'Light', 'uri': 'sounds/light.ogg', 'type': 'custom'},
      {
        'name': 'Musical Alarm',
        'uri': 'sounds/musical_alarm.ogg',
        'type': 'custom'
      },
      {'name': 'New Day', 'uri': 'sounds/newday.ogg', 'type': 'custom'},
      {'name': 'Positive', 'uri': 'sounds/positive.ogg', 'type': 'custom'},
      {
        'name': 'Smoke Alarm',
        'uri': 'sounds/smoke_alarm.ogg',
        'type': 'custom'
      },
      {'name': 'Snooze', 'uri': 'sounds/snooze.ogg', 'type': 'custom'},
      {'name': 'Snoozer', 'uri': 'sounds/snoozer.ogg', 'type': 'custom'},
      {'name': 'Trrrrrrrr', 'uri': 'sounds/trrrrrrrr.ogg', 'type': 'custom'},
      {'name': 'Wake Up', 'uri': 'sounds/wake_up.ogg', 'type': 'custom'},
      {
        'name': 'Wake Up Wake Up',
        'uri': 'sounds/wake_up_wake_up.ogg',
        'type': 'custom'
      },
    ];

    AppLogger.info('Loaded ${customSounds.length} custom alarm sounds');
    return customSounds;
  }

  // Audio player for previewing sounds
  static AudioPlayer? _previewPlayer;

  // Audio player for active alarm (looping until dismissed)
  static AudioPlayer? _activeAlarmPlayer;
  static int? _activeAlarmId;

  /// Start looping alarm audio for a notification
  static Future<void> startAlarmAudio({
    required int alarmId,
    String? alarmSoundName,
  }) async {
    try {
      // Stop any existing alarm first
      await stopAlarmAudio();

      AppLogger.info('🔊 Starting looping alarm audio for alarm ID: $alarmId');
      AppLogger.info('🔊 Alarm sound: ${alarmSoundName ?? 'default'}');

      _activeAlarmId = alarmId;
      _activeAlarmPlayer = AudioPlayer();

      // Determine the sound file to use
      String soundPath = 'sounds/alarm.ogg'; // Default
      if (alarmSoundName != null && alarmSoundName != 'default') {
        // Normalize the sound name to match asset path
        String normalizedName = alarmSoundName;
        if (normalizedName.startsWith('sounds/')) {
          normalizedName = normalizedName.substring(7);
        }
        if (normalizedName.endsWith('.ogg') ||
            normalizedName.endsWith('.mp3')) {
          normalizedName =
              normalizedName.substring(0, normalizedName.length - 4);
        }
        soundPath = 'sounds/$normalizedName.ogg';
      }

      AppLogger.info('🔊 Using sound path: $soundPath');

      // Configure audio context for ALARM playback with maximum priority
      await _activeAlarmPlayer!.setAudioContext(
        AudioContext(
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: {
              AVAudioSessionOptions.duckOthers,
            },
          ),
          android: AudioContextAndroid(
            isSpeakerphoneOn: true,
            stayAwake: true,
            contentType: AndroidContentType.sonification,
            usageType: AndroidUsageType.alarm, // CRITICAL: Use alarm usage type
            audioFocus: AndroidAudioFocus.gain, // Gain full audio focus
          ),
        ),
      );

      // Set to LOOP mode - this is the key to continuous playback
      await _activeAlarmPlayer!.setReleaseMode(ReleaseMode.loop);
      await _activeAlarmPlayer!.setVolume(1.0);

      AppLogger.info(
          '🔊 Audio player configured: loop=true, volume=1.0, usageType=ALARM');

      // Play the sound from assets
      await _activeAlarmPlayer!.play(AssetSource(soundPath));

      AppLogger.info(
          '✅ Alarm audio started successfully and will loop until stopped');
    } catch (e, stackTrace) {
      AppLogger.error('❌ Failed to start alarm audio', e);
      AppLogger.error('Stack trace: $stackTrace', null);
      _activeAlarmPlayer = null;
      _activeAlarmId = null;
    }
  }

  /// Stop looping alarm audio
  static Future<void> stopAlarmAudio({int? alarmId}) async {
    try {
      if (_activeAlarmPlayer != null) {
        // If alarmId is specified, only stop if it matches
        if (alarmId != null && _activeAlarmId != alarmId) {
          AppLogger.info(
              '⏭️ Not stopping alarm audio - ID mismatch (active: $_activeAlarmId, requested: $alarmId)');
          return;
        }

        AppLogger.info('🔇 Stopping alarm audio for alarm ID: $_activeAlarmId');
        await _activeAlarmPlayer!.stop();
        await _activeAlarmPlayer!.dispose();
        _activeAlarmPlayer = null;
        _activeAlarmId = null;
        AppLogger.info('✅ Alarm audio stopped successfully');
      }
    } catch (e) {
      AppLogger.error('Failed to stop alarm audio', e);
      _activeAlarmPlayer = null;
      _activeAlarmId = null;
    }
  }

  /// Check if alarm audio is currently playing
  static bool isAlarmAudioPlaying() {
    return _activeAlarmPlayer != null && _activeAlarmId != null;
  }

  /// Play alarm sound preview
  static Future<void> playAlarmSoundPreview(String soundUri) async {
    try {
      // Stop any currently playing sound
      await stopAlarmSoundPreview();

      AppLogger.info('🔊 Attempting to play preview: $soundUri');
      AppLogger.info('🔊 Asset path that will be used: $soundUri');

      _previewPlayer = AudioPlayer();

      // Configure audio context for proper playback
      await _previewPlayer!.setAudioContext(
        AudioContext(
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: {AVAudioSessionOptions.mixWithOthers},
          ),
          android: AudioContextAndroid(
            isSpeakerphoneOn: false,
            stayAwake: false,
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.media,
            audioFocus: AndroidAudioFocus.gain,
          ),
        ),
      );

      // Listen for player state changes (consolidated listener)
      _previewPlayer!.onPlayerStateChanged.listen(
        (state) {
          AppLogger.info('🎵 Player state changed: $state');
          if (state == PlayerState.stopped) {
            AppLogger.info(
                '🎵 Player stopped - may indicate error or completion');
          } else if (state == PlayerState.playing) {
            AppLogger.info(
                '✅ Player successfully playing - audio focus should be maintained');
          } else if (state == PlayerState.paused) {
            AppLogger.info('⏸️ Player paused');
          } else if (state == PlayerState.completed) {
            AppLogger.info('✅ Player completed successfully');
          }
        },
        onError: (error) {
          AppLogger.error('❌ Player stream error', error);
        },
      );

      // Listen for completion
      _previewPlayer!.onPlayerComplete.listen((event) {
        AppLogger.info('🎵 Playback completed normally');
      });

      // Set player mode for better reliability
      await _previewPlayer!.setReleaseMode(ReleaseMode.stop);
      await _previewPlayer!.setVolume(1.0);

      AppLogger.info('🔊 About to call play() with AssetSource("$soundUri")');
      AppLogger.info(
          '🔊 Player configured with: volume=1.0, releaseMode=stop, audioFocus=gain');

      // Play the sound from assets
      // Note: soundUri should be in format "sounds/alarm.ogg" (OGG Vorbis format)
      // AssetSource will automatically prepend "assets/"
      await _previewPlayer!.play(AssetSource(soundUri));

      AppLogger.info('✅ play() call completed without throwing error');
      AppLogger.info('✅ Started playing alarm sound preview: $soundUri');
    } catch (e, stackTrace) {
      AppLogger.error('❌ Failed to play alarm sound preview: $soundUri', e);
      AppLogger.error('❌ Error details: ${e.toString()}', null);
      AppLogger.error('❌ Stack trace:', null);
      AppLogger.error('$stackTrace', null);
      rethrow;
    }
  }

  /// Stop alarm sound preview
  static Future<void> stopAlarmSoundPreview() async {
    try {
      if (_previewPlayer != null) {
        await _previewPlayer!.stop();
        await _previewPlayer!.dispose();
        _previewPlayer = null;
      }
    } catch (e) {
      AppLogger.error('Failed to stop alarm sound preview', e);
    }
  }

  /// Schedule notification-based alarm
  static Future<void> _scheduleNotificationAlarm({
    required int alarmId,
    required String habitId,
    required String habitName,
    required DateTime scheduledTime,
    String? alarmSoundName,
    required int snoozeDelayMinutes,
  }) async {
    // Create snooze text
    String snoozeText = '⏰ Snooze ';
    if (snoozeDelayMinutes < 60) {
      snoozeText += '${snoozeDelayMinutes}min';
    } else {
      final hours = snoozeDelayMinutes ~/ 60;
      final minutes = snoozeDelayMinutes % 60;
      if (minutes == 0) {
        snoozeText += '${hours}h';
      } else {
        snoozeText += '${hours}h ${minutes}min';
      }
    }

    // Convert alarm sound path to raw resource name
    // Maps "sounds/alarm.ogg" → "alarm" (normalized to Android raw resource name)
    String normalizedSoundName =
        _normalizeAlarmSoundName(alarmSoundName ?? 'default');

    // Create a unique channel for this sound (or use default)
    String channelKey = normalizedSoundName == 'default'
        ? 'habit_alarms'
        : 'habit_alarm_$normalizedSoundName';

    if (normalizedSoundName != 'default') {
      // Create a custom channel with the selected sound
      try {
        await AwesomeNotifications().setChannel(
          NotificationChannel(
            channelKey: channelKey,
            channelName: 'Habit Alarm - $normalizedSoundName',
            channelDescription: 'Alarm channel with custom sound',
            importance: NotificationImportance.Max,
            defaultColor: const Color(0xFFFF0000),
            ledColor: Colors.red,
            playSound: true,
            soundSource:
                'resource://raw/$normalizedSoundName', // Custom sound for this channel
            enableVibration: true,
            enableLights: true,
            locked: true,
            defaultPrivacy: NotificationPrivacy.Public,
            criticalAlerts: true,
            channelShowBadge: true,
            onlyAlertOnce: false,
          ),
        );
        AppLogger.debug(
            'Created custom alarm channel: $channelKey with sound: $normalizedSoundName');
      } catch (e) {
        AppLogger.warning(
            'Failed to create custom alarm channel, using default: $e');
        channelKey = 'habit_alarms'; // Fallback to default
        normalizedSoundName = 'default';
      }
    }

    final payloadData = jsonEncode({
      'habitId': habitId,
      'habitName': habitName,
      'type': 'alarm',
      'alarmSoundName': alarmSoundName ?? 'default',
    });

    // Determine the custom sound for this notification
    String? notificationSound;
    if (normalizedSoundName != 'default') {
      notificationSound = 'resource://raw/$normalizedSoundName';
    } else {
      notificationSound = 'resource://raw/alarm'; // Default alarm sound
    }

    final bool canUseFullScreenIntent =
        await PermissionService.canUseFullScreenIntent();
    AppLogger.info(
        'Full screen intent available for alarm? $canUseFullScreenIntent');

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: alarmId,
        channelKey:
            channelKey, // Use the appropriate channel with sound configured
        title: '🚨 HABIT ALARM: $habitName',
        body: 'Time to complete your habit! Tap buttons below.',
        category: NotificationCategory.Alarm,
        notificationLayout: NotificationLayout.Default,
        fullScreenIntent: canUseFullScreenIntent,
        wakeUpScreen: canUseFullScreenIntent,
        criticalAlert: true,
        locked: true, // Cannot swipe away - must use buttons
        autoDismissible: false, // Prevent accidental dismissal
        payload: {'data': payloadData},
        backgroundColor: const Color(0xFFFF0000),
        largeIcon: 'resource://drawable/ic_launcher',
        customSound:
            notificationSound, // CRITICAL: Set sound on notification itself
        // Use KeepOnTop so notification stays visible and sound continues
        actionType: ActionType.KeepOnTop,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'complete',
          label: '✅ COMPLETE',
          actionType:
              ActionType.SilentBackgroundAction, // Process in background
          autoDismissible: true,
          isDangerousOption: false,
        ),
        NotificationActionButton(
          key: 'snooze_alarm',
          label: snoozeText,
          actionType:
              ActionType.SilentBackgroundAction, // Process in background
          autoDismissible: true,
          isDangerousOption: false,
        ),
      ],
      schedule: NotificationCalendar.fromDate(
        date: scheduledTime,
        allowWhileIdle: true,
        preciseAlarm: true,
        repeats: false,
      ),
    );
  }

  /// Normalize alarm sound name to match Android raw resource filename
  /// Maps display names to lowercase underscore format, removing extensions
  /// Examples:
  ///   "sounds/alarm.ogg" → "alarm"
  ///   "sounds/alarm_1.ogg" → "alarm_1"
  ///   "sounds/army_alarm.ogg" → "army_alarm"
  ///   "alarm.mp3" → "alarm" (for backward compatibility)
  ///   "default" → "default"
  static String _normalizeAlarmSoundName(String? soundName) {
    if (soundName == null || soundName.isEmpty || soundName == 'default') {
      return 'default';
    }

    // Extract filename from path and remove extension
    String filename =
        soundName.contains('/') ? soundName.split('/').last : soundName;

    // Remove file extensions (.mp3, .ogg) if present
    if (filename.endsWith('.mp3')) {
      filename = filename.substring(0, filename.length - 4); // Remove .mp3
    } else if (filename.endsWith('.ogg')) {
      filename = filename.substring(0, filename.length - 4); // Remove .ogg
    }

    // Convert to lowercase and normalize spaces/hyphens to underscores
    return filename.toLowerCase().replaceAll(' ', '_').replaceAll('-', '_');
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
      '⏰ Scheduled snooze alarm for $habitName in $snoozeDelayMinutes minutes',
    );
  }

  /// Schedule habit alarm (simplified API for habit_continuation_service)
  /// This is a convenience method that generates the alarm ID automatically
  static Future<void> scheduleHabitAlarm({
    required String habitId,
    required String habitName,
    required DateTime scheduledTime,
    String? alarmSoundName,
    int snoozeDelayMinutes = 10,
    String frequency = 'daily',
  }) async {
    // Generate alarm ID based on habitId and scheduled time
    final alarmId = generateHabitAlarmId(
      habitId,
      suffix: '${scheduledTime.millisecondsSinceEpoch}',
    );

    await scheduleExactAlarm(
      alarmId: alarmId,
      habitId: habitId,
      habitName: habitName,
      scheduledTime: scheduledTime,
      frequency: frequency,
      alarmSoundName: alarmSoundName,
      snoozeDelayMinutes: snoozeDelayMinutes,
    );
  }

  /// Schedule hourly habit alarms (compatibility method)
  /// This is handled by the notification scheduler, but kept for API compatibility
  static Future<void> scheduleHourlyHabitAlarms(dynamic habit) async {
    AppLogger.debug(
        'scheduleHourlyHabitAlarms called - delegating to notification scheduler');
    // This method exists for API compatibility with AlarmManagerService
    // The actual scheduling is done by NotificationAlarmScheduler
  }

  /// Schedule daily habit alarm (compatibility method)
  /// This is handled by the notification scheduler, but kept for API compatibility
  static Future<void> scheduleDailyHabitAlarm(dynamic habit) async {
    AppLogger.debug(
        'scheduleDailyHabitAlarm called - delegating to notification scheduler');
    // This method exists for API compatibility with AlarmManagerService
    // The actual scheduling is done by NotificationAlarmScheduler
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

  /// The alarm callback function - this runs when the alarm fires
  @pragma('vm:entry-point')
  static Future<void> _alarmCallback(int alarmId) async {
    AppLogger.info('🚨 ALARM FIRED! ID: $alarmId');

    try {
      // Get alarm data
      final alarmDataJson =
          await PreferencesService.getString('$_alarmDataKey$alarmId');

      if (alarmDataJson == null) {
        AppLogger.error('No alarm data found for ID: $alarmId');
        return;
      }

      final alarmData = jsonDecode(alarmDataJson);
      final habitId = alarmData['habitId'] as String;
      final habitName = alarmData['habitName'] as String;
      final alarmSoundName = alarmData['alarmSoundName'] as String?;
      final snoozeDelayMinutes = alarmData['snoozeDelayMinutes'] as int? ?? 10;
      final frequency = alarmData['frequency'] as String;
      final additionalData =
          alarmData['additionalData'] as Map<String, dynamic>? ?? {};

      AppLogger.info('🚨 Alarm for habit: $habitName');

      // Show full-screen alarm notification
      await _showAlarmNotification(
        alarmId: alarmId,
        habitId: habitId,
        habitName: habitName,
        alarmSoundName: alarmSoundName,
        snoozeDelayMinutes: snoozeDelayMinutes,
      );

      // If this is a recurring alarm, schedule the next occurrence
      if (additionalData['recurrence'] != null && frequency != 'snooze') {
        await _scheduleNextRecurrence(alarmData, alarmId);
      }

      // Clean up this alarm's data if it's not recurring
      if (frequency == 'snooze' || additionalData['recurrence'] == null) {
        await PreferencesService.remove('$_alarmDataKey$alarmId');
      }
    } catch (e) {
      AppLogger.error('Error in alarm callback', e);
    }
  }

  /// Show full-screen alarm notification
  static Future<void> _showAlarmNotification({
    required int alarmId,
    required String habitId,
    required String habitName,
    String? alarmSoundName,
    required int snoozeDelayMinutes,
  }) async {
    try {
      // Create snooze text
      String snoozeText = '⏰ Snooze ';
      if (snoozeDelayMinutes < 60) {
        snoozeText += '${snoozeDelayMinutes}min';
      } else {
        final hours = snoozeDelayMinutes ~/ 60;
        final minutes = snoozeDelayMinutes % 60;
        if (minutes == 0) {
          snoozeText += '${hours}h';
        } else {
          snoozeText += '${hours}h ${minutes}min';
        }
      }

      // Prepare custom sound if provided
      // Sound files must be in android/app/src/main/res/raw/ directory
      // with lowercase names and underscores only (Android resource naming rules)
      String? customSound;
      if (alarmSoundName != null && alarmSoundName != 'default') {
        // Convert filename to Android resource format: lowercase with underscores
        // Also remove number prefixes (e.g., "01_" -> "") and handle special cases
        String resourceName = alarmSoundName
            .replaceAll('.mp3', '')
            .toLowerCase()
            .replaceAll(' ', '_')
            .replaceAll('-', '_');

        // Remove leading number prefixes (e.g., "01_classmate" -> "classmate")
        resourceName = resourceName.replaceFirst(RegExp(r'^\d+_'), '');

        // Handle special case: 3d_bomb -> bomb_3d
        if (resourceName == '3d_bomb') {
          resourceName = 'bomb_3d';
        }

        customSound = 'resource://raw/$resourceName';
        AppLogger.info('🔊 Using custom alarm sound: $customSound');
      }

      final payload = jsonEncode({
        'habitId': habitId,
        'alarmId': alarmId,
        'snoozeDelayMinutes': snoozeDelayMinutes,
        'alarmSoundName': alarmSoundName,
      });

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: alarmId,
          channelKey: 'habit_alarms',
          title: '🚨 HABIT ALARM: $habitName',
          body:
              'Time to complete your habit! Tap to mark as complete or snooze.',
          category: NotificationCategory.Alarm,
          notificationLayout: NotificationLayout.Default,
          fullScreenIntent: true,
          wakeUpScreen: true,
          criticalAlert: true,
          locked: true,
          customSound: customSound,
          payload: {'data': payload},
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'complete',
            label: '✅ COMPLETE',
            actionType: ActionType.SilentBackgroundAction,
            autoDismissible: true,
          ),
          NotificationActionButton(
            key: 'snooze_alarm',
            label: snoozeText,
            actionType: ActionType.SilentBackgroundAction,
            autoDismissible: true,
          ),
        ],
      );

      AppLogger.info('🚨 Alarm notification shown for: $habitName');
    } catch (e) {
      AppLogger.error('Failed to show alarm notification', e);
    }
  }

  /// Schedule next recurrence for recurring alarms
  static Future<void> _scheduleNextRecurrence(
    Map<String, dynamic> alarmData,
    int currentAlarmId,
  ) async {
    try {
      final frequency = alarmData['frequency'] as String;
      final additionalData =
          alarmData['additionalData'] as Map<String, dynamic>;
      final baseId = additionalData['baseId'] as int;
      final currentRecurrence = additionalData['recurrence'] as int;

      // Calculate next occurrence based on frequency
      Duration interval;
      switch (frequency) {
        case 'hourly':
          interval = const Duration(hours: 1);
          break;
        case 'daily':
          interval = const Duration(days: 1);
          break;
        case 'weekly':
          interval = const Duration(days: 7);
          break;
        case 'monthly':
          interval = const Duration(days: 30); // Approximate
          break;
        case 'yearly':
          interval = const Duration(days: 365); // Approximate
          break;
        default:
          return; // Unknown frequency
      }

      final nextScheduledTime = DateTime.now().add(interval);
      final nextAlarmId =
          baseId + currentRecurrence + 30; // Offset for next batch

      await scheduleExactAlarm(
        alarmId: nextAlarmId,
        habitId: alarmData['habitId'],
        habitName: alarmData['habitName'],
        scheduledTime: nextScheduledTime,
        frequency: frequency,
        alarmSoundName: alarmData['alarmSoundName'],
        snoozeDelayMinutes: alarmData['snoozeDelayMinutes'],
        additionalData: {
          'recurrence': currentRecurrence + 30,
          'baseId': baseId,
        },
      );

      AppLogger.info(
        '📅 Scheduled next recurrence for ${alarmData['habitName']} at $nextScheduledTime',
      );
    } catch (e) {
      AppLogger.error('Failed to schedule next recurrence', e);
    }
  }
}
