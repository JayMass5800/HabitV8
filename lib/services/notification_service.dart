import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'dart:convert';
import 'logging_service.dart';

@pragma('vm:entry-point')
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  // Callback for handling notification actions
  static Function(String habitId, String action)? onNotificationAction;
  
  // Queue for storing pending actions when callback is not available
  static final List<Map<String, String>> _pendingActions = [];

  /// Initialize the notification service
  @pragma('vm:entry-point')
  static Future<void> initialize() async {
    if (_isInitialized) return;

    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings with notification categories
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: [
        DarwinNotificationCategory(
          'habit_category',
          actions: [
            DarwinNotificationAction.plain(
              'complete',
              'Complete',
              options: {DarwinNotificationActionOption.foreground},
            ),
            DarwinNotificationAction.plain(
              'snooze',
              'Snooze 30min',
              options: {DarwinNotificationActionOption.foreground},
            ),
          ],
        ),
      ],
    );

    // Combined initialization settings
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Initialize the plugin
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: onBackgroundNotificationResponse,
    );

    // Request permissions for Android 13+
    if (Platform.isAndroid) {
      await _requestAndroidPermissions();
      await _createNotificationChannels();
    }

    _isInitialized = true;
    AppLogger.info('🔔 NotificationService initialized successfully');
    AppLogger.info('📱 Platform: ${Platform.operatingSystem}');
    AppLogger.info('🔧 Background handler registered: ${_onNotificationTapped != null}');
  }

  /// Check if device is running Android 12+ (API level 31+)
  static Future<bool> _isAndroid12Plus() async {
    if (!Platform.isAndroid) return false;

    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt >= 31; // Android 12 = API 31
    } catch (e) {
      AppLogger.error('Error checking Android version', e);
      return false; // Assume older version if error
    }
  }

  /// Check if device is running Android 12+ (API level 31+) - public version
  static Future<bool> isAndroid12Plus() async {
    return await _isAndroid12Plus();
  }

  /// Create Android notification channels
  static Future<void> _createNotificationChannels() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      // Create habit notification channel
      const AndroidNotificationChannel habitChannel = AndroidNotificationChannel(
        'habit_channel',
        'Habit Notifications',
        description: 'Notifications for habit reminders',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      // Create scheduled habit notification channel
      const AndroidNotificationChannel scheduledHabitChannel = AndroidNotificationChannel(
        'habit_scheduled_channel',
        'Scheduled Habit Notifications',
        description: 'Scheduled notifications for habit reminders',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      await androidImplementation.createNotificationChannel(habitChannel);
      await androidImplementation.createNotificationChannel(scheduledHabitChannel);
      
      AppLogger.info('Notification channels created successfully');
      AppLogger.info('Habit channel: ${habitChannel.id} - ${habitChannel.name}');
      AppLogger.info('Scheduled habit channel: ${scheduledHabitChannel.id} - ${scheduledHabitChannel.name}');
    }
  }

  /// Request Android notification permissions with enhanced exact alarm handling
  static Future<void> _requestAndroidPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      // Request notification permission
      await androidImplementation.requestNotificationsPermission();

      // Check if we're on Android 12+ and handle exact alarms accordingly
      final bool isAndroid12Plus = await _isAndroid12Plus();

      if (isAndroid12Plus) {
        AppLogger.info('Android 12+ detected - requesting exact alarm permissions');

        // Request exact alarms permission (Android 12+)
        try {
          final bool? exactAlarmPermission =
              await androidImplementation.requestExactAlarmsPermission();
          AppLogger.info('Exact alarm permission granted: $exactAlarmPermission');

          if (exactAlarmPermission != true) {
            AppLogger.warning(
                'WARNING: Exact alarm permission not granted. Scheduled notifications may not work on Android 12+');
            AppLogger.warning(
                'User may need to manually enable "Alarms & reminders" in app settings');
          }
        } catch (e) {
          AppLogger.error('Error requesting exact alarm permission', e);
        }
      } else {
        AppLogger.info('Android 11 or below detected - exact alarm permissions not required');
      }
    }
  }

  /// Handle background notification responses (when app is not in foreground)
  /// This method is called when the app is not running or in background
  @pragma('vm:entry-point')
  static void onBackgroundNotificationResponse(NotificationResponse notificationResponse) {
    AppLogger.info('=== BACKGROUND NOTIFICATION RESPONSE ===');
    AppLogger.info('Background notification ID: ${notificationResponse.id}');
    AppLogger.info('Background action ID: ${notificationResponse.actionId}');
    AppLogger.info('Background payload: ${notificationResponse.payload}');
    AppLogger.info('Background response type: ${notificationResponse.notificationResponseType}');
    AppLogger.info('Background input: ${notificationResponse.input}');
    
    // Log the raw response object for debugging
    AppLogger.info('Raw background response: $notificationResponse');
    
    // Handle the notification response directly in background
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(payload);
        final String? habitId = data['habitId'];
        final String? action = notificationResponse.actionId;
        
        if (habitId != null && action != null && action.isNotEmpty) {
          AppLogger.info('Processing background action: $action for habit: $habitId');
          _handleNotificationAction(habitId, action);
        }
      } catch (e) {
        AppLogger.error('Error parsing background notification payload', e);
      }
    }
  }

  /// Handle notification tap and actions
  @pragma('vm:entry-point')
  static void _onNotificationTapped(NotificationResponse notificationResponse) async {
    // CRITICAL: Add print statements that will show in Flutter console
    print('🚨🚨🚨 FLUTTER NOTIFICATION HANDLER CALLED! 🚨🚨🚨');
    print('🔔 Notification ID: ${notificationResponse.id}');
    print('🔔 Action ID: ${notificationResponse.actionId}');
    print('🔔 Response Type: ${notificationResponse.notificationResponseType}');
    print('🔔 Payload: ${notificationResponse.payload}');
    
    AppLogger.info('=== NOTIFICATION RESPONSE DEBUG ===');
    AppLogger.info('🔔 NOTIFICATION RECEIVED!');
    AppLogger.info('Notification ID: ${notificationResponse.id}');
    AppLogger.info('Action ID: ${notificationResponse.actionId}');
    AppLogger.info('Input: ${notificationResponse.input}');
    AppLogger.info('Payload: ${notificationResponse.payload}');
    AppLogger.info('Notification response type: ${notificationResponse.notificationResponseType}');
    
    // Log the raw response object for complete debugging
    AppLogger.info('Raw notification response: $notificationResponse');
    
    // Additional debugging for action button presses
    if (notificationResponse.actionId != null && notificationResponse.actionId!.isNotEmpty) {
      print('🔥🔥🔥 ACTION BUTTON DETECTED: ${notificationResponse.actionId} 🔥🔥🔥');
      AppLogger.info('🔥🔥🔥 ACTION BUTTON PRESSED: ${notificationResponse.actionId}');
      AppLogger.info('Response type for action: ${notificationResponse.notificationResponseType}');
      AppLogger.info('Action button working! Processing action...');
    } else {
      print('📱 REGULAR NOTIFICATION TAP (no action button)');
      AppLogger.info('📱 NOTIFICATION TAPPED (no action button)');
    }
    
    // Always log that we received something
    AppLogger.info('✅ Notification handler called successfully');
    
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      print('📦 Processing payload: $payload');
      AppLogger.info('Processing notification with payload: $payload');
      
      try {
        final Map<String, dynamic> data = jsonDecode(payload);
        final String? habitId = data['habitId'];
        final String? action = notificationResponse.actionId;
        
        print('🎯 Parsed habitId: $habitId');
        print('⚡ Parsed action: $action');
        AppLogger.info('Parsed habitId: $habitId');
        AppLogger.info('Parsed action: $action');
        
        if (habitId != null) {
          if (action != null && action.isNotEmpty) {
            // Handle the action button press
            print('🚀 CALLING _handleNotificationAction with: $action, $habitId');
            AppLogger.info('Processing action button: $action for habit: $habitId');
            _handleNotificationAction(habitId, action);
          } else {
            // Handle regular notification tap (no action button)
            print('👆 Regular tap for habit: $habitId');
            AppLogger.info('Regular notification tap for habit: $habitId');
            // You could open the app to the habit details or timeline here
            // For now, we'll just log it
          }
        } else {
          print('❌ No habitId found in payload!');
          AppLogger.warning('No habitId found in notification payload');
        }
      } catch (e) {
        print('💥 Error parsing payload: $e');
        AppLogger.error('Error parsing notification payload', e);
      }
    } else {
      print('❌ No payload provided!');
      AppLogger.warning('Notification tapped but no payload provided');
    }
    
    print('✅ _onNotificationTapped completed');
  }

  /// Handle notification actions (Complete/Snooze)
  @pragma('vm:entry-point')
  static void _handleNotificationAction(String habitId, String action) async {
    print('🚀 DEBUG: _handleNotificationAction called with habitId: $habitId, action: $action');
    AppLogger.info('Handling notification action: $action for habit: $habitId');
    
    try {
      // Normalize action IDs to handle both iOS and Android formats
      final normalizedAction = action.toLowerCase().replaceAll('_action', '');
      print('🔄 DEBUG: Normalized action: $normalizedAction');
      
      switch (normalizedAction) {
        case 'complete':
          print('✅ DEBUG: Processing complete action for habit: $habitId');
          AppLogger.info('🔥 Processing complete action for habit: $habitId');
          
          // Always cancel the notification first for complete action
          final notificationId = habitId.hashCode;
          await cancelNotification(notificationId);
          print('🗑️ DEBUG: Notification cancelled with ID: $notificationId');
          AppLogger.info('✅ Notification cancelled for complete action for habit: $habitId');
          
          // Call the callback if set
          if (onNotificationAction != null) {
            print('📞 DEBUG: Calling notification action callback');
            AppLogger.info('📞 Calling complete action callback for habit: $habitId');
            onNotificationAction!(habitId, 'complete');
            print('✅ DEBUG: Callback executed successfully');
            AppLogger.info('✅ Complete action callback executed for habit: $habitId');
          } else {
            print('❌ DEBUG: No notification action callback set!');
            AppLogger.warning('❌ No notification action callback set - action will be lost');
            // Store the action for later processing if callback is not set
            _storeActionForLaterProcessing(habitId, 'complete');
          }
          break;
          
        case 'snooze':
          print('😴 DEBUG: Processing snooze action for habit: $habitId');
          AppLogger.info('😴 Processing snooze action for habit: $habitId');
          // Handle snooze action
          await _handleSnoozeAction(habitId);
          AppLogger.info('✅ Snooze action completed for habit: $habitId');
          break;
          
        default:
          print('❓ DEBUG: Unknown action: $action (normalized: $normalizedAction)');
          AppLogger.warning('Unknown notification action: $action (normalized: $normalizedAction)');
      }
    } catch (e) {
      print('💥 DEBUG: Error in _handleNotificationAction: $e');
      AppLogger.error('Error handling notification action: $action', e);
    }
  }
  
  /// Store action for later processing if callback is not available
  static void _storeActionForLaterProcessing(String habitId, String action) {
    AppLogger.warning('Storing action for later processing: $action for habit: $habitId');
    _pendingActions.add({
      'habitId': habitId,
      'action': action,
      'timestamp': DateTime.now().toIso8601String(),
    });
    AppLogger.info('Pending actions queue size: ${_pendingActions.length}');
  }
  
  /// Set the notification action callback and process any pending actions
  static void setNotificationActionCallback(Function(String habitId, String action) callback) {
    onNotificationAction = callback;
    AppLogger.info('🔗 Notification action callback set');
    
    // Process any pending actions
    if (_pendingActions.isNotEmpty) {
      AppLogger.info('📦 Processing ${_pendingActions.length} pending notification actions');
      
      final actionsToProcess = List<Map<String, String>>.from(_pendingActions);
      _pendingActions.clear();
      
      for (final actionData in actionsToProcess) {
        final habitId = actionData['habitId']!;
        final action = actionData['action']!;
        final timestamp = actionData['timestamp']!;
        
        AppLogger.info('⚡ Processing pending action: $action for habit: $habitId (queued at: $timestamp)');
        
        try {
          callback(habitId, action);
          AppLogger.info('✅ Successfully processed pending action: $action for habit: $habitId');
        } catch (e) {
          AppLogger.error('❌ Error processing pending action: $action for habit: $habitId', e);
        }
      }
      
      AppLogger.info('🎉 All pending actions processed');
    } else {
      AppLogger.info('📭 No pending actions to process');
    }
  }
  
  /// Get the number of pending actions (for debugging)
  static int getPendingActionsCount() {
    return _pendingActions.length;
  }
  
  /// Handle snooze action specifically
  static Future<void> _handleSnoozeAction(String habitId) async {
    try {
      final notificationId = habitId.hashCode;
      AppLogger.info('🔔 Starting snooze process for habit: $habitId (notification ID: $notificationId)');
      
      // Cancel the current notification
      await cancelNotification(notificationId);
      AppLogger.info('❌ Cancelled current notification for habit: $habitId');
      
      // For snooze from background, just log success and call callback
      // Don't try to schedule new notification as it may fail due to context issues
      AppLogger.info('😴 Snooze action processed - notification dismissed');
      
      // Call the callback if set
      if (onNotificationAction != null) {
        onNotificationAction!(habitId, 'snooze');
        AppLogger.info('📞 Snooze action callback executed for habit: $habitId');
      } else {
        AppLogger.warning('⚠️ No notification action callback set for snooze');
      }
      
      AppLogger.info('✅ Snooze action completed for habit: $habitId');
    } catch (e) {
      AppLogger.error('❌ Error handling snooze action for habit: $habitId', e);
    }
  }

  /// Show an immediate notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'habit_channel',
      'Habit Notifications',
      channelDescription: 'Notifications for habit reminders',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  /// Schedule a notification for a specific time using device local time
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'habit_scheduled_channel',
      'Scheduled Habit Notifications',
      channelDescription: 'Scheduled notifications for habit reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // Enhanced timezone handling with detailed debugging
    final deviceNow = DateTime.now();
    final localScheduledTime = scheduledTime.toLocal();

    print('DEBUG: === Notification Scheduling Debug ===');
    print('DEBUG: Device current time: $deviceNow');
    print('DEBUG: Original scheduled time: $scheduledTime');
    print('DEBUG: Local scheduled time: $localScheduledTime');
    print('DEBUG: Device timezone offset: ${deviceNow.timeZoneOffset}');
    print('DEBUG: Time until notification: ${localScheduledTime.difference(deviceNow).inSeconds} seconds');

    // Validate scheduling time
    if (localScheduledTime.isBefore(deviceNow)) {
      print('DEBUG: WARNING - Scheduled time is in the past!');
      print('DEBUG: Past by: ${deviceNow.difference(localScheduledTime).inSeconds} seconds');
    }

    // Create TZDateTime with better error handling
    tz.TZDateTime tzScheduledTime;
    try {
      // First try to create from the local scheduled time
      tzScheduledTime = tz.TZDateTime.from(localScheduledTime, tz.local);
      print('DEBUG: TZ Scheduled time (method 1): $tzScheduledTime');
    } catch (e) {
      print('DEBUG: TZDateTime.from failed: $e');
      // Fallback: create manually
      try {
        tzScheduledTime = tz.TZDateTime(
          tz.local,
          localScheduledTime.year,
          localScheduledTime.month,
          localScheduledTime.day,
          localScheduledTime.hour,
          localScheduledTime.minute,
          localScheduledTime.second,
        );
        print('DEBUG: TZ Scheduled time (method 2): $tzScheduledTime');
      } catch (e2) {
        print('DEBUG: Manual TZDateTime creation failed: $e2');
        // Ultimate fallback: use UTC
        tzScheduledTime = tz.TZDateTime.utc(
          localScheduledTime.year,
          localScheduledTime.month,
          localScheduledTime.day,
          localScheduledTime.hour,
          localScheduledTime.minute,
          localScheduledTime.second,
        );
        print('DEBUG: TZ Scheduled time (UTC fallback): $tzScheduledTime');
      }
    }

    print('DEBUG: TZ Local timezone: ${tz.local.name}');
    print('DEBUG: TZ offset: ${tzScheduledTime.timeZoneOffset}');
    print('DEBUG: Device vs TZ offset match: ${deviceNow.timeZoneOffset == tzScheduledTime.timeZoneOffset}');

    // Additional validation
    final secondsUntilNotification = tzScheduledTime.difference(tz.TZDateTime.now(tz.local)).inSeconds;
    print('DEBUG: Seconds until TZ notification: $secondsUntilNotification');

    if (secondsUntilNotification < 0) {
      print('DEBUG: ERROR - TZ scheduled time is in the past!');
      return; // Don't schedule past notifications
    }

    AppLogger.info('Device current time: $deviceNow');
    AppLogger.info('Target scheduled time: $localScheduledTime');
    AppLogger.info('Time until notification: ${localScheduledTime.difference(deviceNow).inSeconds} seconds');
    AppLogger.info('TZ Scheduled time: $tzScheduledTime');
    AppLogger.info('TZ Local timezone: ${tz.local.name}');

    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledTime,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
      print('DEBUG: Notification successfully scheduled with plugin');
    } catch (e) {
      print('DEBUG: Plugin scheduling failed: $e');
      throw Exception('Failed to schedule notification: $e');
    }
  }

  /// Schedule daily recurring notifications
  static Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'habit_daily_channel',
      'Daily Habit Notifications',
      channelDescription: 'Daily recurring notifications for habit reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the scheduled time is in the past, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  /// Schedule daily habit reminder - wrapper method for specific habit reminders
  static Future<void> scheduleDailyHabitReminder({
    required String habitId,
    required String habitName,
    required DateTime reminderTime,
  }) async {
    final id = habitId.hashCode; // Generate unique ID from habit ID
    final hour = reminderTime.hour;
    final minute = reminderTime.minute;

    await scheduleDailyNotification(
      id: id,
      title: 'Habit Reminder',
      body: 'Time to complete your habit: $habitName',
      hour: hour,
      minute: minute,
      payload: jsonEncode({
        'habitId': habitId,
        'habitName': habitName,
        'type': 'habit_reminder',
      }),
    );
  }

  /// Cancel a specific notification
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  /// Cancel all notifications for a specific habit
  static Future<void> cancelHabitNotifications(int habitId) async {
    if (!_isInitialized) await initialize();

    // Cancel the main notification
    await _notificationsPlugin.cancel(habitId);

    // Cancel related notifications with safe approach - try common patterns
    // For weekly notifications (7 days)
    for (int weekday = 1; weekday <= 7; weekday++) {
      await _notificationsPlugin.cancel(generateSafeId('${habitId}_week_$weekday'));
    }

    // For monthly notifications (31 days)
    for (int monthDay = 1; monthDay <= 31; monthDay++) {
      await _notificationsPlugin.cancel(generateSafeId('${habitId}_month_$monthDay'));
    }

    // For yearly notifications (12 months x 31 days)
    for (int month = 1; month <= 12; month++) {
      for (int day = 1; day <= 31; day++) {
        await _notificationsPlugin.cancel(generateSafeId('${habitId}_year_${month}_$day'));
      }
    }

    // For hourly notifications (24 hours x 60 minutes)
    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 15) { // Check every 15 minutes
        await _notificationsPlugin.cancel(generateSafeId('${habitId}_hour_${hour}_$minute'));
      }
    }

    AppLogger.info('Cancelled all notifications for habit ID: $habitId');
  }

  /// Schedule notifications for a habit based on its frequency and settings
  static Future<void> scheduleHabitNotifications(dynamic habit) async {
    print('DEBUG: Starting notification scheduling for habit: ${habit.name}');
    print('DEBUG: Notifications enabled: ${habit.notificationsEnabled}');
    print('DEBUG: Notification time: ${habit.notificationTime}');
    
    if (!_isInitialized) {
      print('DEBUG: Initializing notification service');
      await initialize();
    }

    // Skip if notifications are disabled
    if (!habit.notificationsEnabled) {
      print('DEBUG: Skipping notifications - disabled');
      AppLogger.info('Notifications disabled for habit: ${habit.name}');
      return;
    }

    // For non-hourly habits, require notification time
    final frequency = habit.frequency.toString().split('.').last;
    if (frequency != 'hourly' && habit.notificationTime == null) {
      print('DEBUG: Skipping notifications - no time set for non-hourly habit');
      AppLogger.info('No notification time set for habit: ${habit.name}');
      return;
    }

    final notificationTime = habit.notificationTime;
    int hour = 9; // Default hour for hourly habits
    int minute = 0; // Default minute for hourly habits
    
    if (notificationTime != null) {
      hour = notificationTime.hour;
      minute = notificationTime.minute;
      print('DEBUG: Scheduling for $hour:$minute');
    } else {
      print('DEBUG: Using default time for hourly habit');
    }

    try {
      // Cancel any existing notifications for this habit first
      await cancelHabitNotifications(generateSafeId(habit.id)); // Use safe ID generation
      print('DEBUG: Cancelled existing notifications for habit ID: ${habit.id}');

      final frequency = habit.frequency.toString().split('.').last;
      print('DEBUG: Habit frequency: $frequency');
      
      switch (frequency) {
        case 'daily':
          print('DEBUG: Scheduling daily notifications');
          await _scheduleDailyHabitNotifications(habit, hour, minute);
          break;

        case 'weekly':
          print('DEBUG: Scheduling weekly notifications');
          await _scheduleWeeklyHabitNotifications(habit, hour, minute);
          break;

        case 'monthly':
          print('DEBUG: Scheduling monthly notifications');
          await _scheduleMonthlyHabitNotifications(habit, hour, minute);
          break;

        case 'yearly':
          print('DEBUG: Scheduling yearly notifications');
          await _scheduleYearlyHabitNotifications(habit, hour, minute);
          break;

        case 'hourly':
          print('DEBUG: Scheduling hourly notifications');
          await _scheduleHourlyHabitNotifications(habit);
          break;

        default:
          print('DEBUG: Unknown frequency: $frequency');
          AppLogger.warning('Unknown habit frequency: ${habit.frequency}');
      }

      print('DEBUG: Successfully scheduled notifications for habit: ${habit.name}');
      AppLogger.info('Successfully scheduled notifications for habit: ${habit.name}');
    } catch (e) {
      print('DEBUG: Error scheduling notifications: $e');
      AppLogger.error('Failed to schedule notifications for habit: ${habit.name}', e);
      rethrow; // Re-throw so the UI can show the error
    }
  }

  /// Schedule daily habit notifications
  static Future<void> _scheduleDailyHabitNotifications(dynamic habit, int hour, int minute) async {
    print('DEBUG: Scheduling daily notifications for ${habit.name}');
    final now = DateTime.now();
    DateTime nextNotification = DateTime(now.year, now.month, now.day, hour, minute);
    
    print('DEBUG: Current time: $now');
    print('DEBUG: Initial notification time: $nextNotification');

    // If the time has passed today, schedule for tomorrow
    if (nextNotification.isBefore(now)) {
      nextNotification = nextNotification.add(const Duration(days: 1));
      print('DEBUG: Time has passed today, scheduling for tomorrow: $nextNotification');
    } else {
      print('DEBUG: Scheduling for today: $nextNotification');
    }

    try {
      await scheduleHabitNotification(
        id: generateSafeId(habit.id), // Use safe ID generation
        habitId: habit.id.toString(),
        title: '🎯 ${habit.name}',
        body: 'Time to complete your daily habit! Keep your streak going.',
        scheduledTime: nextNotification,
      );
      print('DEBUG: Successfully scheduled daily notification for ${habit.name}');
    } catch (e) {
      print('DEBUG: Error scheduling daily notification: $e');
      rethrow;
    }
  }

  /// Schedule weekly habit notifications
  static Future<void> _scheduleWeeklyHabitNotifications(dynamic habit, int hour, int minute) async {
    final selectedWeekdays = habit.selectedWeekdays ?? <int>[];
    final now = DateTime.now();

    for (int weekday in selectedWeekdays) {
      DateTime nextNotification = DateTime(now.year, now.month, now.day, hour, minute);

      // Find the next occurrence of this weekday
      while (nextNotification.weekday != weekday) {
        nextNotification = nextNotification.add(const Duration(days: 1));
      }

      // If the time has passed today, schedule for next week
      if (nextNotification.isBefore(now)) {
        nextNotification = nextNotification.add(const Duration(days: 7));
      }

      await scheduleHabitNotification(
        id: generateSafeId(habit.id + '_week_$weekday'), // Use string concatenation for uniqueness
        habitId: habit.id.toString(),
        title: '🎯 ${habit.name}',
        body: 'Time to complete your weekly habit! Don\'t break your streak.',
        scheduledTime: nextNotification,
      );
    }
  }

  /// Schedule monthly habit notifications
  static Future<void> _scheduleMonthlyHabitNotifications(dynamic habit, int hour, int minute) async {
    final selectedMonthDays = habit.selectedMonthDays ?? <int>[];
    final now = DateTime.now();

    for (int monthDay in selectedMonthDays) {
      DateTime nextNotification = DateTime(now.year, now.month, monthDay, hour, minute);

      // If the day has passed this month, schedule for next month
      if (nextNotification.isBefore(now)) {
        nextNotification = DateTime(now.year, now.month + 1, monthDay, hour, minute);
      }

      // Handle case where the day doesn't exist in the target month
      try {
        nextNotification = DateTime(nextNotification.year, nextNotification.month, monthDay, hour, minute);
      } catch (e) {
        // Skip this month if the day doesn't exist (e.g., Feb 30)
        continue;
      }

      await scheduleHabitNotification(
        id: generateSafeId(habit.id + '_month_$monthDay'), // Use string concatenation for uniqueness
        habitId: habit.id.toString(),
        title: '🎯 ${habit.name}',
        body: 'Time to complete your monthly habit! Stay consistent.',
        scheduledTime: nextNotification,
      );
    }
  }

  /// Schedule yearly habit notifications
  static Future<void> _scheduleYearlyHabitNotifications(dynamic habit, int hour, int minute) async {
    final selectedYearlyDates = habit.selectedYearlyDates ?? <String>[];
    final now = DateTime.now();

    for (String dateString in selectedYearlyDates) {
      try {
        // Parse the date string (format: "yyyy-MM-dd")
        final parts = dateString.split('-');
        if (parts.length != 3) continue;
        
        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);
        
        DateTime nextNotification = DateTime(now.year, month, day, hour, minute);

        // If the date has passed this year, schedule for next year
        if (nextNotification.isBefore(now)) {
          nextNotification = DateTime(now.year + 1, month, day, hour, minute);
        }

        await scheduleHabitNotification(
          id: generateSafeId(habit.id + '_year_${month}_$day'), // Use string concatenation for uniqueness
          habitId: habit.id.toString(),
          title: '🎯 ${habit.name}',
          body: 'Time to complete your yearly habit! This is your special day.',
          scheduledTime: nextNotification,
        );
      } catch (e) {
        AppLogger.error('Error parsing yearly date: $dateString', e);
      }
    }
  }

  /// Schedule hourly habit notifications
  static Future<void> _scheduleHourlyHabitNotifications(dynamic habit) async {
    final now = DateTime.now();
    
    // For hourly habits, use the specific times set by the user
    if (habit.hourlyTimes != null && habit.hourlyTimes.isNotEmpty) {
      print('DEBUG: Scheduling hourly notifications for specific times: ${habit.hourlyTimes}');
      
      for (String timeString in habit.hourlyTimes) {
        try {
          // Parse the time string (format: "HH:mm")
          final timeParts = timeString.split(':');
          final hour = int.tryParse(timeParts[0]) ?? 9;
          final minute = timeParts.length > 1 ? (int.tryParse(timeParts[1]) ?? 0) : 0;
          
          DateTime nextNotification = DateTime(now.year, now.month, now.day, hour, minute);
          
          // If the time has passed today, schedule for tomorrow
          if (nextNotification.isBefore(now)) {
            nextNotification = nextNotification.add(const Duration(days: 1));
          }

          await scheduleHabitNotification(
            id: generateSafeId('${habit.id}_hourly_${hour}_$minute'), // Use hour and minute for uniqueness
            habitId: habit.id.toString(),
            title: '⏰ ${habit.name}',
            body: 'Time for your habit! Scheduled for $timeString',
            scheduledTime: nextNotification,
          );
          
          print('DEBUG: Scheduled hourly notification for $timeString at $nextNotification');
        } catch (e) {
          print('DEBUG: Error parsing hourly time "$timeString": $e');
          AppLogger.error('Error parsing hourly time "$timeString" for habit ${habit.name}', e);
        }
      }
    } else {
      // Fallback: For hourly habits without specific times, schedule every hour during active hours (8 AM - 10 PM)
      print('DEBUG: No specific hourly times set, using default hourly schedule (8 AM - 10 PM)');
      for (int hour = 8; hour <= 22; hour++) {
        DateTime nextNotification = DateTime(now.year, now.month, now.day, hour, 0);
        
        // If the time has passed today, schedule for tomorrow
        if (nextNotification.isBefore(now)) {
          nextNotification = nextNotification.add(const Duration(days: 1));
        }

        await scheduleHabitNotification(
          id: generateSafeId('${habit.id}_hourly_$hour'), // Use string concatenation for uniqueness
          habitId: habit.id.toString(),
          title: '⏰ ${habit.name}',
          body: 'Hourly reminder: Time for your habit!',
          scheduledTime: nextNotification,
        );
      }
    }
  }

  /// Generate a safe 32-bit integer ID from a string
  static int generateSafeId(String habitId) {
    // Generate a much smaller base hash to leave room for multiplications and additions
    int hash = 0;
    for (int i = 0; i < habitId.length; i++) {
      hash = ((hash << 3) - hash + habitId.codeUnitAt(i)) & 0xFFFFFF; // Use 24 bits max
    }
    // Ensure we have a reasonable range for the base ID (1-16777215)
    return (hash % 16777215) + 1;
  }

  /// Get pending notifications
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }

  /// Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        return await androidImplementation.areNotificationsEnabled() ?? false;
      }
    }

    // For iOS, we assume they're enabled if the user granted permission
    return true;
  }

  /// Test notification - useful for debugging
  static Future<void> showTestNotification() async {
    await showNotification(
      id: 999,
      title: '🎯 Test Notification',
      body: 'This is a test notification to verify the system is working!',
      payload: 'test_notification',
    );
  }

  /// Show an actionable habit notification with Complete and Snooze buttons
  static Future<void> showHabitNotification({
    required int id,
    required String habitId,
    required String title,
    required String body,
  }) async {
    if (!_isInitialized) await initialize();

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'habit_channel',
      'Habit Notifications',
      channelDescription: 'Notifications for habit reminders',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      enableVibration: true,
      playSound: true,
      actions: [
        const AndroidNotificationAction(
          'complete',
          '✅ Complete',
          showsUserInterface: false,
          cancelNotification: true,
          allowGeneratedReplies: false,
        ),
        const AndroidNotificationAction(
          'snooze',
          '⏰ Snooze 30min',
          showsUserInterface: false,
          cancelNotification: true,
          allowGeneratedReplies: false,
        ),
      ],
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      categoryIdentifier: 'habit_category',
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final payload = jsonEncode({
      'habitId': habitId,
      'type': 'habit_reminder',
    });

    await _notificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  /// Schedule a habit notification with action buttons
  static Future<void> scheduleHabitNotification({
    required int id,
    required String habitId,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    if (!_isInitialized) await initialize();

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'habit_scheduled_channel',
      'Scheduled Habit Notifications',
      channelDescription: 'Scheduled notifications for habit reminders',
      importance: Importance.max,
      priority: Priority.high,
      actions: [
        const AndroidNotificationAction(
          'complete',
          '✅ Complete',
          showsUserInterface: false,
          cancelNotification: true,
          allowGeneratedReplies: false,
        ),
        const AndroidNotificationAction(
          'snooze',
          '⏰ Snooze 30min',
          showsUserInterface: false,
          cancelNotification: true,
          allowGeneratedReplies: false,
        ),
      ],
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      categoryIdentifier: 'habit_category',
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final deviceNow = DateTime.now();
    final localScheduledTime = scheduledTime.toLocal();

    AppLogger.info('Device current time: $deviceNow');
    AppLogger.info('Target scheduled time: $localScheduledTime');
    AppLogger.info('Time until notification: ${localScheduledTime.difference(deviceNow).inSeconds} seconds');

    final tzScheduledTime = tz.TZDateTime.from(localScheduledTime, tz.local);

    AppLogger.info('TZ Scheduled time: $tzScheduledTime');
    AppLogger.info('TZ Local timezone: ${tz.local.name}');

    final payload = jsonEncode({
      'habitId': habitId,
      'type': 'habit_reminder',
    });

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// Snooze a notification for 30 minutes
  static Future<void> snoozeNotification({
    required int id,
    required String habitId,
    required String title,
    required String body,
  }) async {
    AppLogger.info('🔄 Snoozing notification ID: $id for habit: $habitId');
    
    // Cancel the current notification
    await _notificationsPlugin.cancel(id);
    AppLogger.info('❌ Current notification cancelled');
    
    // Schedule a new one for 30 minutes later
    final snoozeTime = DateTime.now().add(const Duration(minutes: 30));
    AppLogger.info('⏰ Scheduling new notification for: $snoozeTime');
    
    await scheduleHabitNotification(
      id: id,
      habitId: habitId,
      title: title,
      body: body,
      scheduledTime: snoozeTime,
    );
    
    AppLogger.info('✅ Notification snoozed for 30 minutes - new notification scheduled');
  }

  /// Debug method to check exact alarm permissions and timezone
  static Future<Map<String, dynamic>> getSchedulingDebugInfo() async {
    final Map<String, dynamic> debugInfo = {};

    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        debugInfo['notificationsEnabled'] = await androidImplementation.areNotificationsEnabled();

        // Check exact alarm permission status
        final bool canScheduleExact = await canScheduleExactAlarms();
        debugInfo['canScheduleExactAlarms'] = canScheduleExact;
        debugInfo['isAndroid12Plus'] = await _isAndroid12Plus();
      }
    }

    // Get device's actual local timezone instead of hardcoded one
    final now = DateTime.now();
    final tzNow = tz.TZDateTime.now(tz.local);

    debugInfo['deviceLocalTime'] = now.toString();
    debugInfo['tzLocalTime'] = tzNow.toString();
    debugInfo['timezone'] = tz.local.name;
    debugInfo['timezoneOffset'] = now.timeZoneOffset.inHours;
    debugInfo['deviceTimezoneOffset'] = now.timeZoneOffset.toString();

    // Test scheduled time (10 seconds from now)
    final testTime = now.add(const Duration(seconds: 10));
    debugInfo['testScheduledTime'] = testTime.toString();

    return debugInfo;
  }

  /// Enhanced test method for scheduled notifications with comprehensive logging
  static Future<void> testScheduledNotification() async {
    AppLogger.info('=== Testing Scheduled Notification ===');

    final debugInfo = await getSchedulingDebugInfo();
    AppLogger.info('Debug Info: $debugInfo');

    // Check if exact alarms are enabled
    final canScheduleExact = await canScheduleExactAlarms();
    AppLogger.info('Can schedule exact alarms: $canScheduleExact');

    if (!canScheduleExact) {
      AppLogger.error('ERROR: Exact alarm permission not granted!');
      return;
    }

    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = now.add(const Duration(seconds: 10));

    AppLogger.info('Current time: $now');
    AppLogger.info('Scheduled time: $scheduledTime');
    AppLogger.info('Time difference: ${scheduledTime.difference(now).inSeconds} seconds');

    try {
      // Cancel any existing test notifications first
      await cancelNotification(1001);
      AppLogger.info('Cancelled any existing test notifications');

      await scheduleNotification(
        id: 1001,
        title: '🔔 Debug Scheduled Test',
        body: 'This notification was scheduled at ${now.toString().substring(11, 19)} and should fire at ${scheduledTime.toString().substring(11, 19)}',
        scheduledTime: scheduledTime.toLocal(),
        payload: 'debug_scheduled_test',
      );
      AppLogger.info('Scheduled notification successfully queued');

      // Check if it was actually scheduled
      final pending = await getPendingNotifications();
      AppLogger.info('Pending notifications: ${pending.length}');
      for (var notification in pending) {
        AppLogger.info('- ID: ${notification.id}, Title: ${notification.title}');
      }

      // Add a verification step
      AppLogger.info('Verification: Notification system should deliver the notification in 10 seconds');
      AppLogger.info('Watch your device for the notification!');

    } catch (e) {
      AppLogger.error('Error scheduling notification', e);
      AppLogger.error('Stack trace: ${StackTrace.current}');
    }
  }

  /// Check if exact alarm permission is granted (Android 12+)
  static Future<bool> canScheduleExactAlarms() async {
    if (!Platform.isAndroid) return true;

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      try {
        // Check if device is Android 12+
        final bool isAndroid12Plus = await _isAndroid12Plus();

        if (isAndroid12Plus) {
          // On Android 12+, check if exact alarms are permitted
          final bool? canSchedule = await androidImplementation.canScheduleExactNotifications();
          AppLogger.info('Can schedule exact alarms: $canSchedule');
          return canSchedule ?? false;
        } else {
          // Android 11 and below don't need exact alarm permission
          return true;
        }
      } catch (e) {
        AppLogger.error('Error checking exact alarm permission', e);
        return false;
      }
    }
    return false;
  }

  /// Open Android settings to allow exact alarms (Android 12+)
  static Future<void> openExactAlarmSettings() async {
    if (!Platform.isAndroid) return;

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      try {
        await androidImplementation.requestExactAlarmsPermission();
        AppLogger.info('Opened exact alarm settings');
      } catch (e) {
        AppLogger.error('Error opening exact alarm settings', e);
      }
    }
  }

  /// Test method to show a notification with action buttons for debugging
  static Future<void> showTestNotificationWithActions() async {
    AppLogger.info('🧪 Creating test notification with action buttons...');
    AppLogger.info('📱 Platform: ${Platform.operatingSystem}');
    AppLogger.info('🔧 Background handler registered: ${onBackgroundNotificationResponse != null}');
    
    await showHabitNotification(
      id: 999999,
      habitId: 'test-habit-id',
      title: '🧪 Test Notification with Actions',
      body: 'Try the Complete and Snooze buttons below!',
    );
    AppLogger.info('✅ Test notification with actions shown with ID: 999999');
    AppLogger.info('🔘 Action buttons: complete, snooze');
    AppLogger.info('💡 Tap the notification or use the action buttons to test functionality');
  }

  /// Show a simple test notification to verify basic functionality
  static Future<void> showSimpleTestNotification() async {
    AppLogger.info('🧪 Creating simple test notification...');
    
    await showNotification(
      id: 888888,
      title: '🔔 Simple Test Notification',
      body: 'This is a basic test notification without actions. Tap me!',
      payload: jsonEncode({
        'habitId': 'simple-test',
        'type': 'test',
      }),
    );
    AppLogger.info('✅ Simple test notification shown with ID: 888888');
  }

  /// Debug method to test notification system comprehensively
  static Future<void> debugNotificationSystem() async {
    AppLogger.info('🔍 === NOTIFICATION SYSTEM DEBUG ===');
    AppLogger.info('🔧 Initialized: $_isInitialized');
    AppLogger.info('📱 Platform: ${Platform.operatingSystem}');
    AppLogger.info('🔗 Callback set: ${onNotificationAction != null}');
    AppLogger.info('📋 Pending actions: ${_pendingActions.length}');
    
    if (_pendingActions.isNotEmpty) {
      AppLogger.info('📋 Pending actions details:');
      for (int i = 0; i < _pendingActions.length; i++) {
        final action = _pendingActions[i];
        AppLogger.info('  [$i] ${action['action']} for ${action['habitId']} at ${action['timestamp']}');
      }
    }
    
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidImplementation != null) {
        final bool? notificationsEnabled = await androidImplementation.areNotificationsEnabled();
        AppLogger.info('🔔 Notifications enabled: $notificationsEnabled');
        
        final bool canScheduleExact = await canScheduleExactAlarms();
        AppLogger.info('⏰ Can schedule exact alarms: $canScheduleExact');
      }
    }
    
    AppLogger.info('🔍 === END DEBUG ===');
  }
}
