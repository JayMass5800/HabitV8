import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'services/logging_service.dart';

// Global flag to track if alarm manager is already initialized in this isolate
bool _isAlarmManagerInitialized = false;

/// Direct alarm service starter that bypasses platform channel issues
Future<void> _startAlarmServiceDirectly(
    String soundUri, String habitName) async {
  try {
    // Try platform channel first (will work if main isolate)
    const MethodChannel alarmServiceChannel =
        MethodChannel('com.habittracker.habitv8/alarm_service');
    await alarmServiceChannel.invokeMethod('startAlarmService', {
      'soundUri': soundUri,
      'habitName': habitName,
    });
    AppLogger.info('✅ AlarmService started via platform channel');
  } catch (e) {
    AppLogger.warning(
        'Platform channel failed; falling back to notification sound: $e');
    // Direct intent start from Dart is not required with the new native AlarmService integration.
    // Fallback: notification sound will handle the audible alert.
    rethrow;
  }
}

@pragma('vm:entry-point')
void playAlarmSound(int id) async {
  try {
    AppLogger.info('Alarm fired for ID: $id');

    // Only initialize if not already initialized in this isolate
    if (!_isAlarmManagerInitialized) {
      await AndroidAlarmManager.initialize();
      _isAlarmManagerInitialized = true;
      AppLogger.info('AndroidAlarmManager initialized for isolate');
    }

    // Try to get alarm data from file storage (works across isolates)
    final alarmData = await _getAlarmDataFromFile(id);

    if (alarmData != null) {
      await _executeBackgroundAlarm(alarmData, id);
      await _removeAlarmDataFile(id);
    } else {
      AppLogger.warning('No alarm data found for ID: $id, using default');
      // Fallback to generic alarm
      await _executeBackgroundAlarm(
          {'habitName': 'Habit', 'alarmSoundName': 'default'}, id);
    }
  } catch (e) {
    AppLogger.error('Error in alarm callback: $e');
  }
}

/// Get alarm data from file storage (works in background isolates)
Future<Map<String, dynamic>?> _getAlarmDataFromFile(int id) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/alarm_data_$id.json');

    if (await file.exists()) {
      final content = await file.readAsString();
      return jsonDecode(content);
    }
  } catch (e) {
    AppLogger.error('Error reading alarm data file: $e');
  }
  return null;
}

/// Handle alarm notification actions (stop/snooze)
@pragma('vm:entry-point')
void _handleAlarmAction(NotificationResponse notificationResponse) async {
  try {
    AppLogger.info(
        '🔔 Alarm action received: ${notificationResponse.actionId} for notification ${notificationResponse.id}');

    final int notificationId = notificationResponse.id ?? 0;

    // Initialize notifications plugin for action handling
    final FlutterLocalNotificationsPlugin notificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await notificationsPlugin.initialize(initializationSettings);

    // Handle main notification tap (no actionId) - DON'T stop alarm automatically
    if (notificationResponse.actionId == null ||
        notificationResponse.actionId!.isEmpty) {
      AppLogger.info(
          '📱 Main notification tapped - opening app but keeping alarm active');
      // Just open the app, don't stop the alarm
      // The alarm should only stop when user explicitly presses "STOP ALARM" button
      return;
    }

    if (notificationResponse.actionId == 'stop_alarm') {
      AppLogger.info('⏹️ Stopping alarm notification $notificationId');

      // Stop both the platform channel sound and foreground service
      try {
        const MethodChannel systemSoundChannel =
            MethodChannel('com.habittracker.habitv8/system_sound');
        await systemSoundChannel.invokeMethod('stopSystemSound');
        AppLogger.info('✅ Platform channel alarm sound stopped');
      } catch (e) {
        AppLogger.warning('⚠️ Failed to stop platform channel sound: $e');
      }

      // Cancel the notification
      await notificationsPlugin.cancel(notificationId);

      // Also try to cancel all notifications to ensure the alarm stops
      await notificationsPlugin.cancelAll();

      AppLogger.info('✅ Alarm notification stopped successfully');
    } else if (notificationResponse.actionId == 'snooze_alarm') {
      AppLogger.info('😴 Snoozing alarm notification $notificationId');

      // Stop the current alarm first
      try {
        const MethodChannel systemSoundChannel =
            MethodChannel('com.habittracker.habitv8/system_sound');
        await systemSoundChannel.invokeMethod('stopSystemSound');
        AppLogger.info('✅ Platform channel alarm sound stopped for snooze');
      } catch (e) {
        AppLogger.warning('⚠️ Failed to stop platform channel sound: $e');
      }

      // Cancel current notification first
      await notificationsPlugin.cancel(notificationId);
      await notificationsPlugin.cancelAll();

      // Try to get alarm data and reschedule
      final alarmData = await _getAlarmDataFromFile(notificationId);
      if (alarmData != null) {
        final snoozeDelayMinutes = alarmData['snoozeDelayMinutes'] ?? 10;
        final snoozeTime =
            DateTime.now().add(Duration(minutes: snoozeDelayMinutes));

        // Reschedule the alarm for snooze time
        await AndroidAlarmManager.oneShotAt(
          snoozeTime,
          notificationId + 50000, // Use different ID for snooze
          playAlarmSound,
          exact: true,
          wakeup: true,
        );

        AppLogger.info('✅ Alarm snoozed for $snoozeDelayMinutes minutes');
      } else {
        AppLogger.warning(
            '⚠️ Could not find alarm data for snooze, alarm stopped instead');
      }
    }
  } catch (e) {
    AppLogger.error('❌ Error handling alarm action: $e');
  }
}

/// Remove alarm data file after use
Future<void> _removeAlarmDataFile(int id) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/alarm_data_$id.json');

    if (await file.exists()) {
      await file.delete();
      AppLogger.info('Alarm data file removed for ID: $id');
    }
  } catch (e) {
    AppLogger.error('Error removing alarm data file: $e');
  }
}

/// Execute alarm in background isolate using notifications
Future<void> _executeBackgroundAlarm(
    Map<String, dynamic> alarmData, int id) async {
  try {
    final habitName = alarmData['habitName'] ?? 'Habit';
    final alarmSoundName = alarmData['alarmSoundName'] ?? 'default';
    final alarmSoundUri = alarmData['alarmSoundUri'] ?? '';

    AppLogger.info(
        '🔊 Executing background alarm for: $habitName with sound: $alarmSoundName (URI: $alarmSoundUri)');

    // If we don't have a valid URI, try to resolve it from the sound name
    String? resolvedSoundUri = alarmSoundUri;
    if (resolvedSoundUri?.isEmpty == true || resolvedSoundUri == 'default') {
      AppLogger.info(
          '🔍 No URI provided, attempting to resolve sound name: $alarmSoundName');
      resolvedSoundUri = await _resolveSoundUriFromName(alarmSoundName);
    }

    // Initialize notifications plugin for background use
    final FlutterLocalNotificationsPlugin notificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Initialize with background notification response handler
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: _handleAlarmAction,
      onDidReceiveNotificationResponse:
          _handleAlarmAction, // Handle main notification taps too
    );

    // Create or get sound-specific notification channel
    String channelId;
    String soundUriToUse = resolvedSoundUri ?? '';

    if (resolvedSoundUri != null &&
        resolvedSoundUri.isNotEmpty &&
        resolvedSoundUri != 'default') {
      AppLogger.info(
          '✅ Creating sound-specific channel for URI: $resolvedSoundUri');
      // Create unique channel ID based on sound name to avoid conflicts
      final safeSoundName = _makeSafeChannelId(alarmSoundName);
      channelId = 'habit_alarm_$safeSoundName';

      // Create channel with custom sound
      await _createSoundSpecificAlarmChannel(
          notificationsPlugin, channelId, alarmSoundName, resolvedSoundUri);

      soundUriToUse = resolvedSoundUri;
    } else {
      AppLogger.info('Using default alarm channel');
      channelId = 'habit_alarm_default';
      soundUriToUse = 'content://settings/system/alarm_alert';

      // Create default alarm channel
      await _createSoundSpecificAlarmChannel(
          notificationsPlugin, channelId, 'Default Alarm', soundUriToUse);
    }

    // CRITICAL: Start AlarmService directly - more reliable than platform channel attempts
    AppLogger.info('🚨 Starting AlarmService for background alarm');

    try {
      await _startAlarmServiceDirectly(soundUriToUse, habitName);
      AppLogger.info('✅ AlarmService started successfully');
    } catch (serviceError) {
      AppLogger.warning(
          '⚠️ AlarmService failed, using notification sound fallback: $serviceError');
      // Continue with notification as fallback - at least the sound will play through notification
    }

    // Create notification details using the sound-specific channel
    // Make this notification extremely persistent and professional
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      'Habit Alarms',
      channelDescription: 'High-priority alarm notifications for habits',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: false, // Don't auto-open app - let user control
      category: AndroidNotificationCategory.alarm,
      playSound: true, // Sound will play through notification channel
      enableVibration: true,
      vibrationPattern: Int64List.fromList([
        0,
        1000,
        500,
        1000,
        500,
        1000,
        500,
        1000,
        500,
        1000,
        500,
        1000,
        500,
        1000
      ]), // Extended vibration pattern (14 seconds total)
      ongoing: true, // Keep notification visible and prevent swipe-away
      autoCancel: false, // Don't auto-dismiss when tapped
      onlyAlertOnce: false, // Allow sound to repeat
      showWhen: true,
      when: DateTime.now().millisecondsSinceEpoch,
      usesChronometer: false,
      timeoutAfter: 1800000, // Auto-dismiss after 30 minutes instead of 5
      visibility: NotificationVisibility.public,
      ticker: 'Habit Alarm: $habitName',
      groupKey: 'habit_alarms',
      setAsGroupSummary: false,
      color: const Color(0xFF2196F3), // Blue color for alarms
      colorized: true,
      actions: [
        const AndroidNotificationAction(
          'stop_alarm',
          '⏹️ STOP ALARM',
          showsUserInterface: false,
          cancelNotification: true,
          contextual: false,
        ),
        const AndroidNotificationAction(
          'snooze_alarm',
          '😴 SNOOZE 5min',
          showsUserInterface: false,
          cancelNotification: true,
          contextual: false,
        ),
      ],
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Create payload with alarm data for action handling
    final payload = jsonEncode({
      'habitId': alarmData['habitId'],
      'habitName': habitName,
      'alarmSoundName': alarmSoundName,
      'snoozeDelayMinutes': alarmData['snoozeDelayMinutes'] ?? 10,
      'type': 'alarm',
    });

    await notificationsPlugin.show(
      id,
      '🔔 $habitName Reminder',
      'Time to complete your habit: $habitName',
      platformChannelSpecifics,
      payload: payload,
    );

    AppLogger.info('✅ Background alarm executed for: $habitName');
  } catch (e) {
    AppLogger.error('❌ Failed to execute background alarm: $e');
  }
}

/// Resolve sound URI from sound name using fallback to default system sound
/// This should only be called if alarmSoundUri is empty but alarmSoundName is provided
Future<String?> _resolveSoundUriFromName(String soundName) async {
  try {
    AppLogger.info('🔍 Attempting to resolve sound URI for: $soundName');

    // Since we're in a background isolate and can't access platform channels,
    // we can only fall back to default system sound URIs
    // The proper sound URI should have been passed through alarmSoundUri
    AppLogger.warning(
        '⚠️ Sound URI was empty but sound name provided: $soundName');
    AppLogger.warning(
        '⚠️ In background isolate, cannot resolve actual system sound URIs');
    AppLogger.warning('⚠️ Falling back to default system alarm sound');

    // Return default system alarm as fallback since we can't resolve actual system sounds
    // in background isolate context
    return 'content://settings/system/alarm_alert';
  } catch (e) {
    AppLogger.error('❌ Error resolving sound URI for $soundName: $e');
    return 'content://settings/system/alarm_alert';
  }
}

/// Create a safe channel ID from sound name
String _makeSafeChannelId(String soundName) {
  // Remove special characters and spaces, make lowercase
  return soundName
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9_]'), '_')
      .replaceAll(
          RegExp(r'_{2,}'), '_') // Replace multiple underscores with single
      .replaceAll(RegExp(r'^_|_$'), ''); // Remove leading/trailing underscores
}

/// Create a sound-specific alarm notification channel
Future<void> _createSoundSpecificAlarmChannel(
  FlutterLocalNotificationsPlugin notificationsPlugin,
  String channelId,
  String soundName,
  String soundUri,
) async {
  try {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      AppLogger.info(
          '🔔 Creating alarm channel: $channelId for sound: $soundName');

      // Create channel with the specific sound and alarm properties
      final alarmChannel = AndroidNotificationChannel(
        channelId,
        'Habit Alarm - $soundName',
        description: 'High-priority alarm notifications with $soundName sound',
        importance: Importance.max,
        playSound: true,
        sound: UriAndroidNotificationSound(soundUri),
        enableVibration: true,
        enableLights: true,
        showBadge: true,
      );

      await androidImplementation.createNotificationChannel(alarmChannel);
      AppLogger.info(
          '✅ Created alarm channel: $channelId with sound: $soundUri');
    }
  } catch (e) {
    AppLogger.error('❌ Failed to create alarm channel $channelId: $e');
    // Don't throw - let caller handle fallback
  }
}
