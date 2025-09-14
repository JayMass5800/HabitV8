import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'logging_service.dart';
import 'permission_service.dart';
import 'background_task_service.dart';
import 'notification_queue_processor.dart';
import '../data/database.dart';
import 'alarm_manager_service.dart';

@pragma('vm:entry-point')
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;
  static bool _channelsCreated = false;

  // Callback for handling notification actions
  static Function(String habitId, String action)? onNotificationAction;

  // Direct completion function (to avoid circular imports)
  static Future<void> Function(String habitId)? directCompletionHandler;

  // Debug tracking for callback state
  static int _callbackSetCount = 0;
  static DateTime? _lastCallbackSetTime;

  // Queue for storing pending actions when callback is not available
  static final List<Map<String, String>> _pendingActions = [];

  // Memory management constants
  static const int _maxPendingActions = 100;
  static Timer? _cleanupTimer;

  /// Initialize the notification service
  @pragma('vm:entry-point')
  static Future<void> initialize() async {
    if (_isInitialized) return;

    // Set up the callback for the queue processor
    NotificationQueueProcessor.setScheduleNotificationCallback(
        scheduleHabitNotification);

    // Start periodic cleanup for memory management
    _startPeriodicCleanup();

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
              'COMPLETE',
              options: {DarwinNotificationActionOption.foreground},
            ),
            DarwinNotificationAction.plain(
              'snooze',
              'SNOOZE 30MIN',
              options: {},
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
      onDidReceiveBackgroundNotificationResponse:
          onBackgroundNotificationResponse,
    );

    // Add debug logging to verify initialization
    AppLogger.info('🔔 Notification plugin initialized with handlers:');
    AppLogger.info('  - Foreground handler: _onNotificationTapped');
    AppLogger.info('  - Background handler: onBackgroundNotificationResponse');

    // Test if the plugin is actually working by checking its state
    try {
      final androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        final areEnabled =
            await androidImplementation.areNotificationsEnabled();
        AppLogger.info('🔔 Android notifications enabled: $areEnabled');
      }
    } catch (e) {
      AppLogger.error('Error checking notification plugin state', e);
    }

    // Request permissions for Android 13+
    if (Platform.isAndroid) {
      await _requestAndroidPermissions();
      await recreateNotificationChannels();
    }

    _isInitialized = true;
    AppLogger.info('🔔 NotificationService initialized successfully');
    AppLogger.info('📱 Platform: ${Platform.operatingSystem}');
    AppLogger.info('🔧 Background handler registered: true');
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
    if (_channelsCreated) {
      AppLogger.debug('Notification channels already created, skipping');
      return;
    }

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      // Create habit notification channel
      const AndroidNotificationChannel habitChannel =
          AndroidNotificationChannel(
        'habit_channel',
        'Habit Notifications',
        description: 'Notifications for habit reminders',
        importance: Importance.max,
        playSound: true,
        sound: UriAndroidNotificationSound(
            'content://settings/system/notification_sound'),
        enableVibration: true,
      );

      // Create scheduled habit notification channel
      const AndroidNotificationChannel scheduledHabitChannel =
          AndroidNotificationChannel(
        'habit_scheduled_channel',
        'Scheduled Habit Notifications',
        description: 'Scheduled notifications for habit reminders',
        importance: Importance.max,
        playSound: true,
        sound: UriAndroidNotificationSound(
            'content://settings/system/notification_sound'),
        enableVibration: true,
      );

      // Create default alarm notification channel (fallback for non-background alarms)
      const AndroidNotificationChannel alarmChannel =
          AndroidNotificationChannel(
        'habit_alarm_default',
        'Habit Alarms (Default)',
        description: 'Default high-priority alarm notifications for habits',
        importance: Importance.max,
        playSound: true,
        sound: UriAndroidNotificationSound(
            'content://settings/system/alarm_alert'),
        enableVibration: true,
        enableLights: true,
        showBadge: true,
      );

      await androidImplementation.createNotificationChannel(habitChannel);
      await androidImplementation.createNotificationChannel(
        scheduledHabitChannel,
      );
      await androidImplementation.createNotificationChannel(alarmChannel);

      _channelsCreated = true;

      AppLogger.info('Notification channels created successfully');
      AppLogger.info(
        'Habit channel: ${habitChannel.id} - ${habitChannel.name}',
      );
      AppLogger.info(
        'Scheduled habit channel: ${scheduledHabitChannel.id} - ${scheduledHabitChannel.name}',
      );
      AppLogger.info(
        'Alarm channel: ${alarmChannel.id} - ${alarmChannel.name}',
      );
    }
  }

  /// Recreate notification channels with updated sound configuration
  /// This is necessary when sound settings change, especially on Android 16+
  static Future<void> recreateNotificationChannels() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      AppLogger.info(
          'Recreating notification channels with updated sound configuration...');

      // Delete existing channels first
      try {
        await androidImplementation.deleteNotificationChannel('habit_channel');
        await androidImplementation
            .deleteNotificationChannel('habit_scheduled_channel');
        await androidImplementation
            .deleteNotificationChannel('habit_alarm_default');
        AppLogger.info('Existing notification channels deleted');
      } catch (e) {
        AppLogger.warning('Some channels may not have existed: $e');
      }

      // Reset the flag to allow recreation
      _channelsCreated = false;

      // Recreate channels with new configuration
      await _createNotificationChannels();
      AppLogger.info('Notification channels recreated successfully');
    }
  }

  /// Initialize Android notification settings without requesting permissions
  /// Permissions will be requested contextually when actually needed
  static Future<void> _requestAndroidPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      // DO NOT request notification permission during initialization on Android 13+
      // This causes the permission to become greyed out in system settings
      // Notification permission will be requested only when user enables notifications

      // Note: We also don't request exact alarm permission during initialization
      // This will be requested only when the user specifically enables alarms/reminders
      // to avoid the greyed-out permission issue on Android 14+
      AppLogger.info(
        'Notification service initialized. All permissions will be requested contextually when needed.',
      );
    }
  }

  /// Ensure all required permissions are granted before scheduling notifications
  /// This method requests permissions only when actually needed
  static Future<bool> _ensureNotificationPermissions() async {
    try {
      // First, ensure basic notification permission is granted
      AppLogger.info('Checking notification permission...');
      final bool hasNotificationPermission =
          await Permission.notification.isGranted;

      if (!hasNotificationPermission) {
        AppLogger.info('Requesting notification permission for scheduling...');
        final bool notificationGranted =
            await PermissionService.requestNotificationPermissionWithContext();

        if (!notificationGranted) {
          AppLogger.warning(
            'Notification permission denied - cannot schedule notifications',
          );
          return false;
        }
      } else {
        AppLogger.info('Notification permission already granted');
      }

      // Then, check if we need exact alarm permission (Android 12+)
      final bool isAndroid12Plus = await NotificationService.isAndroid12Plus();
      if (!isAndroid12Plus) {
        AppLogger.info('Exact alarm permission not required for Android < 12');
        return true;
      }

      // Check if we already have exact alarm permission
      final bool hasExactAlarmPermission =
          await PermissionService.hasExactAlarmPermission().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          AppLogger.warning(
            'Exact alarm permission check timed out in notification service - assuming false',
          );
          return false;
        },
      );
      if (hasExactAlarmPermission) {
        AppLogger.info('Exact alarm permission already available');
        return true;
      }

      AppLogger.info(
        'Checking exact alarm permission availability for precise scheduling...',
      );

      // For Android 13+ with USE_EXACT_ALARM: Should be automatically granted
      // For Android 12 with SCHEDULE_EXACT_ALARM: May require user action
      // We'll attempt to request it, but don't block the UI if it fails
      final bool exactAlarmGranted =
          await PermissionService.requestExactAlarmPermissionWithContext()
              .timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          AppLogger.warning(
            'Exact alarm permission request timed out in notification service - continuing without exact alarms',
          );
          return false;
        },
      );

      if (exactAlarmGranted) {
        AppLogger.info(
          'Exact alarm permission available - notifications will be precise',
        );
      } else {
        AppLogger.info(
          'Exact alarm permission not available - notifications will use standard scheduling (this is normal for Android 12 if user denies permission)',
        );
        // Continue anyway - notifications will still work but may not be precise
      }

      // Always return true - don't block the UI based on exact alarm permission
      // Basic notifications will work regardless of exact alarm permission status
      return true;
    } catch (e) {
      AppLogger.error('Error ensuring notification permissions', e);
      return false; // Block notification scheduling if there's an error
    }
  }

  /// Handle background notification responses (when app is not in foreground)
  /// This method is called when the app is not running or in background
  @pragma('vm:entry-point')
  static void onBackgroundNotificationResponse(
    NotificationResponse notificationResponse,
  ) {
    AppLogger.info('🌙🌙🌙 BACKGROUND NOTIFICATION HANDLER CALLED! 🌙🌙🌙');
    AppLogger.info('=== BACKGROUND NOTIFICATION RESPONSE ===');
    AppLogger.info('Background notification ID: ${notificationResponse.id}');
    AppLogger.info('Background action ID: ${notificationResponse.actionId}');
    AppLogger.info('Background payload: ${notificationResponse.payload}');
    AppLogger.info(
      'Background response type: ${notificationResponse.notificationResponseType}',
    );
    AppLogger.info('Background input: ${notificationResponse.input}');

    // Log the raw response object for debugging
    AppLogger.info('Raw background response: $notificationResponse');

    // For background processing, we need to store the action for later processing
    // when the app is opened, since we don't have full app context here
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(payload);
        final String? habitId = data['habitId'];
        final String? action = notificationResponse.actionId;

        if (habitId != null && action != null && action.isNotEmpty) {
          AppLogger.info(
            'Storing background action for later processing: $action for habit: $habitId',
          );

          // Store the action for processing when app is opened
          _storeActionForLaterProcessing(habitId, action);

          // Try to process immediately using direct completion handler if available
          // This bypasses the callback system which may not be available in background
          if (action.toLowerCase() == 'complete' &&
              directCompletionHandler != null) {
            AppLogger.info(
                'Attempting direct completion in background for habit: $habitId');
            try {
              // Use a Future to handle async operations in background
              Future.microtask(() async {
                try {
                  await directCompletionHandler!(habitId);
                  AppLogger.info(
                      '✅ Background direct completion successful for habit: $habitId');

                  // Remove the stored action since we processed it successfully
                  await _removeStoredAction(habitId, action);
                } catch (e) {
                  AppLogger.error(
                      '❌ Background direct completion failed for habit: $habitId',
                      e);
                  // Keep the stored action for later processing
                }
              });
            } catch (e) {
              AppLogger.error(
                  'Error initiating background completion for habit: $habitId',
                  e);
            }
          } else {
            AppLogger.info(
                'Direct completion handler not available or action is not complete, action will be processed when app resumes');
          }
        }
      } catch (e) {
        AppLogger.error('Error parsing background notification payload', e);
      }
    }
  }

  /// Handle notification tap and actions
  @pragma('vm:entry-point')
  static void _onNotificationTapped(
    NotificationResponse notificationResponse,
  ) async {
    // CRITICAL: Add debug statements that will show in Flutter console
    AppLogger.debug('🚨🚨🚨 FLUTTER NOTIFICATION HANDLER CALLED! 🚨🚨🚨');
    AppLogger.info('🚨🚨🚨 FLUTTER NOTIFICATION HANDLER CALLED! 🚨🚨🚨');
    AppLogger.debug('🔔 Notification ID: ${notificationResponse.id}');
    AppLogger.debug('🔔 Action ID: ${notificationResponse.actionId}');
    AppLogger.debug(
      '🔔 Response Type: ${notificationResponse.notificationResponseType}',
    );
    AppLogger.debug('🔔 Payload: ${notificationResponse.payload}');

    AppLogger.info('=== NOTIFICATION RESPONSE DEBUG ===');
    AppLogger.info('🔔 NOTIFICATION RECEIVED!');
    AppLogger.info('Notification ID: ${notificationResponse.id}');
    AppLogger.info('Action ID: ${notificationResponse.actionId}');
    AppLogger.info('Input: ${notificationResponse.input}');
    AppLogger.info('Payload: ${notificationResponse.payload}');
    AppLogger.info(
      'Notification response type: ${notificationResponse.notificationResponseType}',
    );

    // Log the raw response object for complete debugging
    AppLogger.info('Raw notification response: $notificationResponse');

    // Additional debugging for action button presses
    if (notificationResponse.actionId != null &&
        notificationResponse.actionId!.isNotEmpty) {
      AppLogger.debug(
        '🔥🔥🔥 ACTION BUTTON DETECTED: ${notificationResponse.actionId} 🔥🔥🔥',
      );
      AppLogger.info(
        '🔥🔥🔥 ACTION BUTTON PRESSED: ${notificationResponse.actionId}',
      );
      AppLogger.info(
        'Response type for action: ${notificationResponse.notificationResponseType}',
      );
      AppLogger.info('Action button working! Processing action...');
    } else {
      AppLogger.debug('📱 REGULAR NOTIFICATION TAP (no action button)');
      AppLogger.info('📱 NOTIFICATION TAPPED (no action button)');
    }

    // Always log that we received something
    AppLogger.info('✅ Notification handler called successfully');

    final String? payload = notificationResponse.payload;
    if (payload != null) {
      AppLogger.debug('📦 Processing payload: $payload');
      AppLogger.info('Processing notification with payload: $payload');

      try {
        final Map<String, dynamic> data = jsonDecode(payload);
        final String? habitId = data['habitId'];
        final String? action = notificationResponse.actionId;

        AppLogger.debug('🎯 Parsed habitId: $habitId');
        AppLogger.debug('⚡ Parsed action: $action');
        AppLogger.info('Parsed habitId: $habitId');
        AppLogger.info('Parsed action: $action');

        if (habitId != null) {
          if (action != null && action.isNotEmpty) {
            // Handle the action button press
            AppLogger.debug(
              '🚀 CALLING _handleNotificationAction with: $action, $habitId',
            );
            AppLogger.info(
              'Processing action button: $action for habit: $habitId',
            );
            _handleNotificationAction(habitId, action);
          } else {
            // Handle regular notification tap (no action button)
            AppLogger.debug('👆 Regular tap for habit: $habitId');
            AppLogger.info('Regular notification tap for habit: $habitId');
            // You could open the app to the habit details or timeline here
            // For now, we'll just log it
          }
        } else {
          AppLogger.debug('❌ No habitId found in payload!');
          AppLogger.warning('No habitId found in notification payload');
        }
      } catch (e) {
        AppLogger.debug('💥 Error parsing payload: $e');
        AppLogger.error('Error parsing notification payload', e);
      }
    } else {
      AppLogger.debug('❌ No payload provided!');
      AppLogger.warning('Notification tapped but no payload provided');
    }

    AppLogger.debug('✅ _onNotificationTapped completed');
  }

  /// Store notification action for later processing when app is opened
  static void _storeActionForLaterProcessing(
      String habitId, String action) async {
    try {
      AppLogger.info(
          'Storing action for later processing: $action for habit $habitId');

      // Create action entry with timestamp
      final actionEntry = {
        'habitId': habitId,
        'action': action,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      // Use both SharedPreferences and file storage for reliability
      await _storeActionInSharedPreferences(actionEntry);
      await _storeActionInFile(actionEntry);

      AppLogger.info(
          'Successfully stored pending action: $action for habit $habitId');
    } catch (e) {
      AppLogger.error('Error storing action for later processing', e);
    }
  }

  /// Store action in SharedPreferences
  static Future<void> _storeActionInSharedPreferences(
      Map<String, dynamic> actionEntry) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get existing pending actions
      final existingActions =
          prefs.getStringList('pending_notification_actions') ?? [];

      // Add new action to the list
      existingActions.add(jsonEncode(actionEntry));

      // Store updated list
      await prefs.setStringList(
          'pending_notification_actions', existingActions);

      // Debug: Verify storage
      final verifyActions =
          prefs.getStringList('pending_notification_actions') ?? [];
      AppLogger.debug(
          '🔍 SharedPrefs: Verified storage: ${verifyActions.length} actions stored');
      AppLogger.debug(
          '🔍 SharedPrefs: All keys after storage: ${prefs.getKeys().toList()}');
    } catch (e) {
      AppLogger.error('Error storing action in SharedPreferences', e);
    }
  }

  /// Store action in file as backup with file locking to prevent corruption
  static Future<void> _storeActionInFile(
      Map<String, dynamic> actionEntry) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/pending_notification_actions.json';
      final lockFilePath =
          '${directory.path}/pending_notification_actions.lock';
      final file = File(filePath);
      final lockFile = File(lockFilePath);

      AppLogger.debug('🔍 File: Storing action at path: $filePath');

      // Wait for lock to be available (simple file-based locking)
      int attempts = 0;
      while (await lockFile.exists() && attempts < 50) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }

      if (attempts >= 50) {
        AppLogger.error('🔍 File: Timeout waiting for file lock');
        return;
      }

      // Create lock file
      await lockFile.writeAsString('locked');

      try {
        List<Map<String, dynamic>> actions = [];

        // Read existing actions if file exists
        if (await file.exists()) {
          final content = await file.readAsString();
          AppLogger.debug(
              '🔍 File: Existing file content length: ${content.length}');
          if (content.isNotEmpty) {
            try {
              final List<dynamic> jsonList = jsonDecode(content);
              actions = jsonList.cast<Map<String, dynamic>>();
              AppLogger.debug(
                  '🔍 File: Loaded ${actions.length} existing actions');
            } catch (e) {
              AppLogger.error(
                  '🔍 File: Corrupted file detected, starting fresh', e);
              actions = [];
            }
          }
        } else {
          AppLogger.debug('🔍 File: Creating new file');
        }

        // Add new action
        actions.add(actionEntry);

        // Write to temporary file first (atomic write)
        final tempFilePath = '$filePath.tmp';
        final tempFile = File(tempFilePath);
        final jsonContent = jsonEncode(actions);
        await tempFile.writeAsString(jsonContent);

        // Verify temp file was written correctly
        final verifyContent = await tempFile.readAsString();
        if (verifyContent.length != jsonContent.length) {
          throw Exception('Temp file write verification failed');
        }

        // Atomic move from temp to final file
        await tempFile.rename(filePath);

        AppLogger.debug(
            '🔍 File: Stored action in file, total: ${actions.length}');
        AppLogger.debug(
            '🔍 File: Written content length: ${jsonContent.length}');
      } finally {
        // Always remove lock file
        if (await lockFile.exists()) {
          await lockFile.delete();
        }
      }
    } catch (e) {
      AppLogger.error('Error storing action in file', e);
    }
  }

  /// Remove a specific stored action from both SharedPreferences and file storage
  static Future<void> _removeStoredAction(String habitId, String action) async {
    try {
      AppLogger.info('Removing stored action: $action for habit $habitId');

      // Remove from SharedPreferences
      await _removeActionFromSharedPreferences(habitId, action);

      // Remove from file storage
      await _removeActionFromFile(habitId, action);

      AppLogger.info(
          'Successfully removed stored action: $action for habit $habitId');
    } catch (e) {
      AppLogger.error('Error removing stored action', e);
    }
  }

  /// Remove action from SharedPreferences
  static Future<void> _removeActionFromSharedPreferences(
      String habitId, String action) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingActions =
          prefs.getStringList('pending_notification_actions') ?? [];

      // Filter out the matching action
      final filteredActions = existingActions.where((actionString) {
        try {
          final actionData = jsonDecode(actionString) as Map<String, dynamic>;
          return !(actionData['habitId'] == habitId &&
              actionData['action'] == action);
        } catch (e) {
          // Keep malformed entries to avoid data loss
          return true;
        }
      }).toList();

      await prefs.setStringList(
          'pending_notification_actions', filteredActions);
      AppLogger.debug(
          'Removed action from SharedPreferences. Remaining: ${filteredActions.length}');
    } catch (e) {
      AppLogger.error('Error removing action from SharedPreferences', e);
    }
  }

  /// Remove action from file storage
  static Future<void> _removeActionFromFile(
      String habitId, String action) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/pending_notification_actions.json';
      final lockFilePath =
          '${directory.path}/pending_notification_actions.lock';
      final file = File(filePath);
      final lockFile = File(lockFilePath);

      if (!await file.exists()) {
        return; // Nothing to remove
      }

      // Wait for lock to be available
      int attempts = 0;
      while (await lockFile.exists() && attempts < 50) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }

      if (attempts >= 50) {
        AppLogger.error('Timeout waiting for file lock during removal');
        return;
      }

      // Create lock file
      await lockFile.writeAsString('locked');

      try {
        // Read existing actions
        final content = await file.readAsString();
        if (content.isEmpty) {
          return;
        }

        List<Map<String, dynamic>> actions = [];
        try {
          final List<dynamic> jsonList = jsonDecode(content);
          actions = jsonList.cast<Map<String, dynamic>>();
        } catch (e) {
          AppLogger.error('Corrupted file during removal, keeping as is', e);
          return;
        }

        // Filter out the matching action
        final filteredActions = actions.where((actionEntry) {
          return !(actionEntry['habitId'] == habitId &&
              actionEntry['action'] == action);
        }).toList();

        // Write back the filtered actions
        final jsonContent = jsonEncode(filteredActions);
        await file.writeAsString(jsonContent);

        AppLogger.debug(
            'Removed action from file. Remaining: ${filteredActions.length}');
      } finally {
        // Always remove lock file
        if (await lockFile.exists()) {
          await lockFile.delete();
        }
      }
    } catch (e) {
      AppLogger.error('Error removing action from file', e);
    }
  }

  /// Process all pending notification actions stored during background execution
  static Future<void> processPendingActions() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Debug: Check all keys in SharedPreferences
      final allKeys = prefs.getKeys();
      AppLogger.debug('🔍 All SharedPreferences keys: ${allKeys.toList()}');

      // Try multiple approaches to get the data
      final pendingActions1 =
          prefs.getStringList('pending_notification_actions');
      final pendingActions2 = prefs.get('pending_notification_actions');

      AppLogger.debug('🔍 Method 1 (getStringList): $pendingActions1');
      AppLogger.debug('🔍 Method 2 (get): $pendingActions2');

      final pendingActions = pendingActions1 ?? [];

      AppLogger.debug(
          '🔍 Found ${pendingActions.length} pending actions in SharedPreferences');
      if (pendingActions.isNotEmpty) {
        AppLogger.debug('🔍 Pending actions: $pendingActions');
      }

      if (pendingActions.isEmpty) {
        AppLogger.debug(
            'No pending notification actions to process in SharedPreferences');

        // Try alternative storage keys in case there's a mismatch
        final alternativeKeys = [
          'pending_actions',
          'notification_actions',
          'stored_actions'
        ];
        for (final key in alternativeKeys) {
          final altActions = prefs.getStringList(key);
          if (altActions != null && altActions.isNotEmpty) {
            AppLogger.debug(
                '🔍 Found actions under alternative key "$key": $altActions');
          }
        }

        // Try file storage as backup
        final fileActions = await _loadActionsFromFile();
        if (fileActions.isNotEmpty) {
          AppLogger.info(
              '🔍 Found ${fileActions.length} actions in file storage, processing them');
          await _processActionsFromFile(fileActions);
          return;
        }

        AppLogger.debug('No pending actions found in any storage method');
        return;
      }

      AppLogger.info(
          'Processing ${pendingActions.length} pending notification actions');

      for (final actionString in pendingActions) {
        try {
          final actionData = jsonDecode(actionString) as Map<String, dynamic>;
          final habitId = actionData['habitId'] as String;
          final action = actionData['action'] as String;
          final timestamp = actionData['timestamp'] as int;

          // Check if action is not too old (e.g., within last 24 hours)
          final actionTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
          final now = DateTime.now();
          final timeDifference = now.difference(actionTime);

          if (timeDifference.inHours > 24) {
            AppLogger.warning(
                'Skipping old pending action: $action for habit $habitId (${timeDifference.inHours} hours old)');
            continue;
          }

          // Process the action
          await _processStoredAction(habitId, action, actionTime);
        } catch (e) {
          AppLogger.error('Error processing individual pending action', e);
        }
      }

      // Clear processed actions
      await prefs.remove('pending_notification_actions');
      AppLogger.info('Cleared all processed pending actions');
    } catch (e) {
      AppLogger.error('Error processing pending notification actions', e);
    }
  }

  /// Load actions from file storage with corruption handling
  static Future<List<Map<String, dynamic>>> _loadActionsFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/pending_notification_actions.json';
      final file = File(filePath);

      AppLogger.debug('🔍 File: Checking for actions at path: $filePath');

      if (!await file.exists()) {
        AppLogger.debug('🔍 File: File does not exist');
        return [];
      }

      final content = await file.readAsString();
      AppLogger.debug('🔍 File: File content length: ${content.length}');

      if (content.isEmpty) {
        AppLogger.debug('🔍 File: File is empty');
        return [];
      }

      try {
        final List<dynamic> jsonList = jsonDecode(content);
        final actions = jsonList.cast<Map<String, dynamic>>();
        AppLogger.debug('🔍 File: Loaded ${actions.length} actions from file');
        return actions;
      } catch (e) {
        AppLogger.error(
            '🔍 File: JSON parsing failed, file corrupted. Content: $content',
            e);

        // Delete corrupted file to prevent future issues
        try {
          await file.delete();
          AppLogger.info('🔍 File: Deleted corrupted file');
        } catch (deleteError) {
          AppLogger.error(
              '🔍 File: Failed to delete corrupted file', deleteError);
        }

        return [];
      }
    } catch (e) {
      AppLogger.error('Error loading actions from file', e);
      return [];
    }
  }

  /// Clear all actions from file storage
  static Future<void> _clearActionsFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/pending_notification_actions.json';
      final lockFilePath =
          '${directory.path}/pending_notification_actions.lock';
      final file = File(filePath);
      final lockFile = File(lockFilePath);

      // Wait for lock to be available
      int attempts = 0;
      while (await lockFile.exists() && attempts < 50) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }

      if (attempts >= 50) {
        AppLogger.error('Timeout waiting for file lock during clear');
        return;
      }

      // Create lock file
      await lockFile.writeAsString('locked');

      try {
        if (await file.exists()) {
          await file.delete();
          AppLogger.info('✅ Cleared all actions from file storage');
        }
      } finally {
        // Always remove lock file
        if (await lockFile.exists()) {
          await lockFile.delete();
        }
      }
    } catch (e) {
      AppLogger.error('Error clearing actions from file', e);
    }
  }

  /// Process actions loaded from file
  static Future<void> _processActionsFromFile(
      List<Map<String, dynamic>> actions) async {
    try {
      for (final actionData in actions) {
        final habitId = actionData['habitId'] as String;
        final action = actionData['action'] as String;
        final timestamp = actionData['timestamp'] as int;

        // Check if action is not too old (e.g., within last 24 hours)
        final actionTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final now = DateTime.now();
        final timeDifference = now.difference(actionTime);

        if (timeDifference.inHours > 24) {
          AppLogger.warning(
              'Skipping old pending action from file: $action for habit $habitId (${timeDifference.inHours} hours old)');
          continue;
        }

        // Process the action
        await _processStoredAction(habitId, action, actionTime);
      }

      // Clear the file after processing
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/pending_notification_actions.json');
      if (await file.exists()) {
        await file.delete();
        AppLogger.info('Cleared processed actions from file');
      }
    } catch (e) {
      AppLogger.error('Error processing actions from file', e);
    }
  }

  /// Process a stored notification action
  static Future<void> _processStoredAction(
      String habitId, String action, DateTime actionTime) async {
    try {
      AppLogger.info(
          'Processing stored action: $action for habit $habitId at $actionTime');

      final normalizedAction = action.toLowerCase().replaceAll('_action', '');

      switch (normalizedAction) {
        case 'complete':
          // Mark habit as complete using the stored action time
          await _completeHabitFromNotification(habitId, actionTime);
          break;
        case 'snooze':
          // Reschedule notification for later
          await _snoozeHabitNotification(habitId);
          break;
        default:
          AppLogger.warning('Unknown stored action: $action');
      }
    } catch (e) {
      AppLogger.error(
          'Error processing stored action: $action for habit $habitId', e);
    }
  }

  /// Handle notification actions (Complete/Snooze)
  @pragma('vm:entry-point')
  static void _handleNotificationAction(String habitId, String action) async {
    AppLogger.debug(
      '🚀 DEBUG: _handleNotificationAction called with habitId: $habitId, action: $action',
    );
    AppLogger.info('🚀🚀🚀 NOTIFICATION ACTION HANDLER CALLED! 🚀🚀🚀');
    AppLogger.info('Handling notification action: $action for habit: $habitId');

    // Check callback status for debugging
    final callbackAvailable = ensureCallbackIsSet();

    // If callback is not available, try to re-register it
    if (!callbackAvailable) {
      AppLogger.warning(
          '🔄 Callback not available, attempting to re-register...');
      // Import the notification action service dynamically to avoid circular imports
      try {
        // Try to re-register the callback by calling the ensure method
        // This will be handled by the app lifecycle service when app resumes
        AppLogger.info(
            '📦 Storing action for later processing due to missing callback');
        _storeActionForLaterProcessing(habitId, action);
        return;
      } catch (e) {
        AppLogger.error('Failed to handle missing callback', e);
      }
    }

    try {
      // Normalize action IDs to handle both iOS and Android formats
      final normalizedAction = action.toLowerCase().replaceAll('_action', '');
      AppLogger.debug('🔄 DEBUG: Original action: $action');
      AppLogger.debug('🔄 DEBUG: Normalized action: $normalizedAction');

      switch (normalizedAction) {
        case 'complete':
          AppLogger.debug(
            '✅ DEBUG: Processing complete action for habit: $habitId',
          );
          AppLogger.info('🔥 Processing complete action for habit: $habitId');

          // Always cancel the notification first for complete action
          final notificationId = habitId.hashCode;
          await cancelNotification(notificationId);
          AppLogger.debug(
            '🗑️ DEBUG: Notification cancelled with ID: $notificationId',
          );
          AppLogger.info(
            '✅ Notification cancelled for complete action for habit: $habitId',
          );

          // Call the callback if set
          if (onNotificationAction != null) {
            AppLogger.debug('📞 DEBUG: Calling notification action callback');
            AppLogger.info(
              '📞 Calling complete action callback for habit: $habitId',
            );
            AppLogger.info(
              '🔍 Callback state: set $_callbackSetCount times, last at $_lastCallbackSetTime',
            );
            try {
              onNotificationAction!(habitId, 'complete');
              AppLogger.debug('✅ DEBUG: Callback executed successfully');
              AppLogger.info(
                '✅ Complete action callback executed for habit: $habitId',
              );
            } catch (callbackError) {
              AppLogger.error(
                'Error executing complete action callback for habit: $habitId',
                callbackError,
              );
              // Store for later processing if callback fails
              _storeActionForLaterProcessing(habitId, 'complete');
            }
          } else {
            AppLogger.debug('❌ DEBUG: No notification action callback set!');
            AppLogger.warning(
              '❌ No notification action callback set - action will be lost',
            );
            AppLogger.warning(
              '🔍 Callback debug: set $_callbackSetCount times, last at $_lastCallbackSetTime',
            );
            AppLogger.warning('🔍 Current time: ${DateTime.now()}');

            // Store the action for later processing if callback is not set
            _storeActionForLaterProcessing(habitId, 'complete');

            // Try to re-register the callback in case it was lost
            ensureCallbackIsSet();
          }
          break;

        case 'snooze':
          AppLogger.debug('😴 Processing snooze action for habit: $habitId');
          AppLogger.info('😴 Processing snooze action for habit: $habitId');
          // Handle snooze action
          try {
            await _handleSnoozeAction(habitId);
            AppLogger.info('✅ Snooze action completed for habit: $habitId');
          } catch (snoozeError) {
            AppLogger.error(
              'Error processing snooze action for habit: $habitId',
              snoozeError,
            );
            // Store for later processing if snooze fails
            _storeActionForLaterProcessing(habitId, 'snooze');
          }
          break;

        default:
          AppLogger.debug(
            '❓ Unknown action: $action (normalized: $normalizedAction)',
          );
          AppLogger.warning(
            'Unknown notification action: $action (normalized: $normalizedAction)',
          );
      }
    } catch (e) {
      AppLogger.debug('💥 Error in _handleNotificationAction: $e');
      AppLogger.error('Error handling notification action: $action', e);
    }
  }

  /// Set the direct completion handler (to avoid circular imports)
  static void setDirectCompletionHandler(
    Future<void> Function(String habitId) handler,
  ) {
    directCompletionHandler = handler;
    AppLogger.info('🎯 Direct completion handler set');
  }

  /// Set the notification action callback and process any pending actions
  static void setNotificationActionCallback(
    Function(String habitId, String action) callback,
  ) async {
    onNotificationAction = callback;
    _callbackSetCount++;
    _lastCallbackSetTime = DateTime.now();
    AppLogger.info(
      '🔗 Notification action callback set (count: $_callbackSetCount, time: $_lastCallbackSetTime)',
    );

    // Process any pending actions from memory queue
    if (_pendingActions.isNotEmpty) {
      AppLogger.info(
        '📦 Processing ${_pendingActions.length} pending notification actions from memory',
      );

      final actionsToProcess = List<Map<String, String>>.from(_pendingActions);
      _pendingActions.clear();

      for (final actionData in actionsToProcess) {
        final habitId = actionData['habitId']!;
        final action = actionData['action']!;
        final timestamp = actionData['timestamp']!;

        AppLogger.info(
          '⚡ Processing pending action: $action for habit: $habitId (queued at: $timestamp)',
        );

        try {
          callback(habitId, action);
          AppLogger.info(
            '✅ Successfully processed pending action: $action for habit: $habitId',
          );
        } catch (e) {
          AppLogger.error(
            '❌ Error processing pending action: $action for habit: $habitId',
            e,
          );
        }
      }

      AppLogger.info('🎉 All pending actions processed');
    } else {
      AppLogger.info('📭 No pending actions to process');
    }

    // Process persistent actions from SharedPreferences after a short delay
    // This ensures the provider container is fully initialized
    Future.delayed(const Duration(milliseconds: 500), () async {
      AppLogger.info('🔄 Processing persistent pending actions after delay');
      await processPendingActions();
    });
  }

  /// Get the number of pending actions (for debugging)
  static int getPendingActionsCount() {
    return _pendingActions.length;
  }

  /// Manually trigger processing of pending actions (for app initialization)
  static Future<void> processPendingActionsManually() async {
    AppLogger.info('🔄 Manually processing pending actions');

    // Always try to process actions, using either callback or direct handler
    if (onNotificationAction != null) {
      AppLogger.info('✅ Using callback to process pending actions');
      await processPendingActions();
    } else if (directCompletionHandler != null) {
      AppLogger.warning('⚠️ Callback not set, using direct completion handler');
      await _processPendingActionsWithDirectHandler();
    } else {
      AppLogger.error(
          '❌ Cannot process pending actions - neither callback nor direct handler available');
    }
  }

  /// Process pending actions using the direct completion handler when callback is not available
  static Future<void> _processPendingActionsWithDirectHandler() async {
    try {
      AppLogger.info(
          '🎯 Processing pending actions with direct completion handler');

      // Load actions from both sources
      final prefs = await SharedPreferences.getInstance();
      final sharedPrefsActions =
          prefs.getStringList('pending_notification_actions') ?? [];
      final fileActions = await _loadActionsFromFile();

      AppLogger.info(
          'Found ${sharedPrefsActions.length} actions in SharedPreferences');
      AppLogger.info('Found ${fileActions.length} actions in file storage');

      int processedCount = 0;

      // Process SharedPreferences actions
      for (final actionString in sharedPrefsActions) {
        try {
          final actionData = jsonDecode(actionString) as Map<String, dynamic>;
          final habitId = actionData['habitId'] as String;
          final action = actionData['action'] as String;
          final timestamp = actionData['timestamp'] as int;

          // Check if action is not too old (e.g., within last 24 hours)
          final actionTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
          final now = DateTime.now();
          final timeDifference = now.difference(actionTime);

          if (timeDifference.inHours > 24) {
            AppLogger.warning(
                'Skipping old pending action: $action for habit $habitId (${timeDifference.inHours} hours old)');
            continue;
          }

          // Only process complete actions with direct handler
          if (action.toLowerCase() == 'complete' &&
              directCompletionHandler != null) {
            AppLogger.info(
                'Processing complete action for habit: $habitId using direct handler');
            try {
              await directCompletionHandler!(habitId);
              processedCount++;
              AppLogger.info('✅ Successfully completed habit: $habitId');
            } catch (e) {
              final errorMessage = e.toString().toLowerCase();
              if (errorMessage.contains('still loading') ||
                  errorMessage.contains('loading')) {
                AppLogger.warning(
                    '⏳ Habit service still loading for $habitId, will retry later');
                // Don't count as processed, so the action stays in storage for retry
              } else {
                AppLogger.error('❌ Failed to complete habit: $habitId', e);
                processedCount++; // Count as processed even if failed to avoid infinite retry
              }
            }
          } else {
            AppLogger.info(
                'Skipping non-complete action or missing handler: $action for habit $habitId');
          }
        } catch (e) {
          AppLogger.error(
              'Error processing individual pending action from SharedPreferences',
              e);
        }
      }

      // Process file actions
      for (final actionData in fileActions) {
        try {
          final habitId = actionData['habitId'] as String;
          final action = actionData['action'] as String;
          final timestamp = actionData['timestamp'] as int;

          // Check if action is not too old
          final actionTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
          final now = DateTime.now();
          final timeDifference = now.difference(actionTime);

          if (timeDifference.inHours > 24) {
            AppLogger.warning(
                'Skipping old file action: $action for habit $habitId (${timeDifference.inHours} hours old)');
            continue;
          }

          // Only process complete actions with direct handler
          if (action.toLowerCase() == 'complete' &&
              directCompletionHandler != null) {
            AppLogger.info(
                'Processing file complete action for habit: $habitId using direct handler');
            try {
              await directCompletionHandler!(habitId);
              processedCount++;
              AppLogger.info(
                  '✅ Successfully completed habit from file: $habitId');
            } catch (e) {
              final errorMessage = e.toString().toLowerCase();
              if (errorMessage.contains('still loading') ||
                  errorMessage.contains('loading')) {
                AppLogger.warning(
                    '⏳ Habit service still loading for $habitId (file), will retry later');
                // Don't count as processed, so the action stays in storage for retry
              } else {
                AppLogger.error(
                    '❌ Failed to complete habit from file: $habitId', e);
                processedCount++; // Count as processed even if failed to avoid infinite retry
              }
            }
          } else {
            AppLogger.info(
                'Skipping non-complete file action or missing handler: $action for habit $habitId');
          }
        } catch (e) {
          AppLogger.error(
              'Error processing individual pending action from file', e);
        }
      }

      // Clear processed actions if we successfully processed any
      if (processedCount > 0) {
        await prefs.remove('pending_notification_actions');
        await _clearActionsFromFile();
        AppLogger.info(
            '✅ Cleared all processed actions. Total processed: $processedCount');
      } else {
        AppLogger.info('No actions were processed successfully');
      }
    } catch (e) {
      AppLogger.error('Error in _processPendingActionsWithDirectHandler', e);
    }
  }

  /// Check if callback is set and re-initialize if needed
  static bool ensureCallbackIsSet() {
    final isSet = onNotificationAction != null;
    AppLogger.info('🔍 Callback check: ${isSet ? "SET" : "NOT SET"}');
    if (!isSet) {
      AppLogger.warning(
        '⚠️ Callback is not set! This may cause notification actions to fail.',
      );
      AppLogger.info(
        '🔍 Callback was set $_callbackSetCount times, last at $_lastCallbackSetTime',
      );
    }
    return isSet;
  }

  /// Handle snooze action specifically with enhanced error handling and validation
  static Future<void> _handleSnoozeAction(String habitId) async {
    try {
      // Generate a unique notification ID for the snooze to prevent conflicts
      final snoozeId = _generateSnoozeNotificationId(habitId);
      AppLogger.info(
        '🔔 Starting enhanced snooze process for habit: $habitId (snooze ID: $snoozeId)',
      );

      // Cancel the current notification (use the original ID)
      final originalNotificationId = habitId.hashCode;
      await cancelNotification(originalNotificationId);
      AppLogger.info('❌ Cancelled current notification for habit: $habitId');

      // Schedule a new notification for 30 minutes later
      final snoozeTime = DateTime.now().add(const Duration(minutes: 30));
      AppLogger.info('⏰ Scheduling snoozed notification for: $snoozeTime');

      // Validate the snooze time is reasonable
      final timeDiff = snoozeTime.difference(DateTime.now()).inMinutes;
      if (timeDiff < 29 || timeDiff > 31) {
        AppLogger.warning(
            '⚠️ Snooze time calculation seems off: $timeDiff minutes');
      }

      // Check exact alarm permissions before scheduling
      final canScheduleExact = await canScheduleExactAlarms();
      AppLogger.info('📋 Can schedule exact alarms: $canScheduleExact');

      if (!canScheduleExact) {
        AppLogger.warning(
            '⚠️ Exact alarm permission not available - snooze may be delayed');
        AppLogger.warning(
            '💡 Note: Exact alarm permission should have been granted during habit setup');
        AppLogger.warning(
            '💡 If snooze is still delayed, it\'s likely due to battery optimization');
        // Log battery optimization guidance
        await checkBatteryOptimizationStatus();
      } else {
        AppLogger.info(
            '✅ Exact alarm permission available - checking for battery optimization issues');
        // Even with exact alarm permission, battery optimization can still cause delays
        AppLogger.info(
            '💡 If snooze notifications are delayed, check battery optimization settings:');
        AppLogger.info(
            '1. Settings > Apps > HabitV8 > Battery > Don\'t optimize');
        AppLogger.info('2. Samsung: Add to "Never sleeping apps"');
        AppLogger.info(
            '3. MIUI: Enable "Autostart" and disable "Battery saver"');
      }

      try {
        // Use generic snooze notification content
        String title = 'Habit Reminder (Snoozed)';
        String body = 'Time to complete your habit!';

        // Attempt to schedule the notification with the unique snooze ID
        await scheduleHabitNotification(
          id: snoozeId,
          habitId: habitId,
          title: title,
          body: body,
          scheduledTime: snoozeTime,
        );

        // Verify the notification was actually scheduled
        await _verifyNotificationScheduled(snoozeId, habitId);

        AppLogger.info(
          '✅ Snoozed notification scheduled successfully for habit: $habitId at $snoozeTime (ID: $snoozeId)',
        );
      } catch (scheduleError) {
        AppLogger.error(
          '❌ Failed to schedule snoozed notification for habit: $habitId',
          scheduleError,
        );

        // Try fallback scheduling method
        await _fallbackSnoozeScheduling(habitId, snoozeId, snoozeTime);
      }

      AppLogger.info('✅ Snooze action completed for habit: $habitId');
    } catch (e) {
      AppLogger.error('❌ Error handling snooze action for habit: $habitId', e);
      // Try emergency fallback
      await _emergencySnoozeNotification(habitId);
    }
  }

  /// Generate a unique notification ID for snooze notifications
  static int _generateSnoozeNotificationId(String habitId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final baseId = habitId.hashCode.abs();
    // Combine habitId hash with timestamp to ensure uniqueness
    // Use modulo to keep within 32-bit integer range
    return ((baseId + timestamp) % 2147483647) +
        1000000; // Add offset to avoid conflicts
  }

  /// Verify that a notification was actually scheduled
  static Future<void> _verifyNotificationScheduled(
      int notificationId, String habitId) async {
    try {
      final pendingNotifications = await getPendingNotifications();
      final isScheduled =
          pendingNotifications.any((n) => n.id == notificationId);

      if (isScheduled) {
        AppLogger.info(
            '✅ Verified: Snooze notification is properly scheduled for habit: $habitId');
      } else {
        AppLogger.warning(
            '⚠️ Warning: Snooze notification may not be properly scheduled for habit: $habitId');
      }
    } catch (e) {
      AppLogger.error('Error verifying notification scheduling', e);
    }
  }

  /// Fallback scheduling method for when primary scheduling fails
  static Future<void> _fallbackSnoozeScheduling(
      String habitId, int notificationId, DateTime snoozeTime) async {
    try {
      AppLogger.info(
          '🔄 Attempting fallback snooze scheduling for habit: $habitId');

      // Try scheduling as an alarm instead of a notification
      await scheduleHabitAlarm(
        id: notificationId,
        habitId: habitId,
        title: 'Habit Reminder (Snoozed)',
        body: 'Time to complete your habit!',
        scheduledTime: snoozeTime,
        snoozeDelayMinutes: 10,
      );

      AppLogger.info(
          '✅ Fallback alarm scheduling successful for habit: $habitId');
    } catch (fallbackError) {
      AppLogger.error('❌ Fallback scheduling also failed for habit: $habitId',
          fallbackError);
    }
  }

  /// Emergency notification for when all scheduling methods fail
  static Future<void> _emergencySnoozeNotification(String habitId) async {
    try {
      AppLogger.info(
          '🚨 Triggering emergency snooze notification for habit: $habitId');

      // Show an immediate notification telling user to check manually
      await showNotification(
        id: DateTime.now().millisecondsSinceEpoch,
        title: 'Snooze Error',
        body:
            'Snooze failed to schedule. Please check your habit manually in 30 minutes.',
        payload: jsonEncode({'habitId': habitId, 'type': 'snooze_error'}),
      );
    } catch (e) {
      AppLogger.error('Emergency notification also failed', e);
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
      sound: UriAndroidNotificationSound(
          'content://settings/system/notification_sound'),
      playSound: true,
      enableVibration: true,
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

    // Check and request all notification permissions if needed
    final bool permissionsGranted = await _ensureNotificationPermissions();
    if (!permissionsGranted) {
      AppLogger.warning(
        'Cannot schedule notification - permissions not granted',
      );
      return; // Don't schedule if permissions are denied
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'habit_scheduled_channel',
      'Scheduled Habit Notifications',
      channelDescription: 'Scheduled notifications for habit reminders',
      importance: Importance.max,
      priority: Priority.high,
      sound: UriAndroidNotificationSound(
          'content://settings/system/notification_sound'),
      playSound: true,
      enableVibration: true,
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

    _debugLog('=== Notification Scheduling Debug ===');
    _debugLog('Device current time: $deviceNow');
    _debugLog('Original scheduled time: $scheduledTime');
    _debugLog('Local scheduled time: $localScheduledTime');
    _debugLog('Device timezone offset: ${deviceNow.timeZoneOffset}');
    _debugLog(
      'Time until notification: ${localScheduledTime.difference(deviceNow).inSeconds} seconds',
    );

    // Validate scheduling time
    if (localScheduledTime.isBefore(deviceNow)) {
      _debugLog('WARNING - Scheduled time is in the past!');
      _debugLog(
        'Past by: ${deviceNow.difference(localScheduledTime).inSeconds} seconds',
      );
    }

    // Create TZDateTime with better error handling
    tz.TZDateTime tzScheduledTime;
    try {
      // First try to create from the local scheduled time
      tzScheduledTime = tz.TZDateTime.from(localScheduledTime, tz.local);
      _debugLog('TZ Scheduled time (method 1): $tzScheduledTime');
    } catch (e) {
      _debugLog('TZDateTime.from failed: $e');
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
        AppLogger.debug('TZ Scheduled time (method 2): $tzScheduledTime');
      } catch (e2) {
        AppLogger.debug('Manual TZDateTime creation failed: $e2');
        // Ultimate fallback: use UTC
        tzScheduledTime = tz.TZDateTime.utc(
          localScheduledTime.year,
          localScheduledTime.month,
          localScheduledTime.day,
          localScheduledTime.hour,
          localScheduledTime.minute,
          localScheduledTime.second,
        );
        AppLogger.debug('TZ Scheduled time (UTC fallback): $tzScheduledTime');
      }
    }

    AppLogger.debug('TZ Local timezone: ${tz.local.name}');
    AppLogger.debug('TZ offset: ${tzScheduledTime.timeZoneOffset}');
    AppLogger.debug(
      'Device vs TZ offset match: ${deviceNow.timeZoneOffset == tzScheduledTime.timeZoneOffset}',
    );

    // Additional validation
    final secondsUntilNotification =
        tzScheduledTime.difference(tz.TZDateTime.now(tz.local)).inSeconds;
    AppLogger.debug('Seconds until TZ notification: $secondsUntilNotification');

    if (secondsUntilNotification < 0) {
      AppLogger.debug('ERROR - TZ scheduled time is in the past!');
      return; // Don't schedule past notifications
    }

    AppLogger.info('Device current time: $deviceNow');
    AppLogger.info('Target scheduled time: $localScheduledTime');
    AppLogger.info(
      'Time until notification: ${localScheduledTime.difference(deviceNow).inSeconds} seconds',
    );
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
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
      AppLogger.debug('Notification successfully scheduled with plugin');
    } catch (e) {
      AppLogger.debug('Plugin scheduling failed: $e');
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

    // Check and request all notification permissions if needed
    final bool permissionsGranted = await _ensureNotificationPermissions();
    if (!permissionsGranted) {
      AppLogger.warning(
        'Cannot schedule notification - permissions not granted',
      );
      return; // Don't schedule if permissions are denied
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'habit_scheduled_channel', // Use existing channel instead of undefined habit_daily_channel
      'Scheduled Habit Notifications',
      channelDescription: 'Scheduled notifications for habit reminders',
      importance: Importance.max,
      priority: Priority.high,
      sound: UriAndroidNotificationSound(
          'content://settings/system/notification_sound'),
      playSound: true,
      enableVibration: true,
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
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
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
      await _notificationsPlugin.cancel(
        generateSafeId('${habitId}_week_$weekday'),
      );
    }

    // For monthly notifications (31 days)
    for (int monthDay = 1; monthDay <= 31; monthDay++) {
      await _notificationsPlugin.cancel(
        generateSafeId('${habitId}_month_$monthDay'),
      );
    }

    // For yearly notifications (12 months x 31 days)
    for (int month = 1; month <= 12; month++) {
      for (int day = 1; day <= 31; day++) {
        await _notificationsPlugin.cancel(
          generateSafeId('${habitId}_year_${month}_$day'),
        );
      }
    }

    // For hourly notifications (24 hours x 60 minutes)
    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 15) {
        // Check every 15 minutes
        await _notificationsPlugin.cancel(
          generateSafeId('${habitId}_hour_${hour}_$minute'),
        );
      }
    }

    AppLogger.info('Cancelled all notifications for habit ID: $habitId');
  }

  /// Schedule notifications for a habit based on its frequency and settings
  static Future<void> scheduleHabitNotifications(dynamic habit) async {
    AppLogger.debug(
      'Starting notification scheduling for habit: ${habit.name}',
    );
    AppLogger.debug('Notifications enabled: ${habit.notificationsEnabled}');
    AppLogger.debug('Alarm enabled: ${habit.alarmEnabled}');
    AppLogger.debug('Notification time: ${habit.notificationTime}');

    if (!_isInitialized) {
      AppLogger.debug('Initializing notification service');
      await initialize();
    }

    // Check and request all notification permissions if needed
    // Only do this if notifications or alarms are actually enabled
    if (habit.notificationsEnabled || habit.alarmEnabled) {
      try {
        final bool permissionsGranted = await _ensureNotificationPermissions();
        if (!permissionsGranted) {
          AppLogger.warning(
            'Cannot schedule notifications for habit: ${habit.name} - permissions not granted',
          );
          throw Exception('Notification permissions not granted');
        }
      } catch (e) {
        AppLogger.error(
          'Error checking notification permissions for habit: ${habit.name}',
          e,
        );
        throw Exception('Failed to verify notification permissions: $e');
      }
    }

    // If alarms are enabled, use alarms instead of notifications (mutually exclusive)
    if (habit.alarmEnabled) {
      AppLogger.debug(
        'Alarms enabled - scheduling alarms instead of notifications',
      );
      await scheduleHabitAlarms(habit);
      return;
    }

    // Skip if notifications are disabled
    if (!habit.notificationsEnabled) {
      AppLogger.debug('Skipping notifications - disabled');
      AppLogger.info('Notifications disabled for habit: ${habit.name}');
      return;
    }

    // For non-hourly, non-single habits, require notification time
    final frequency = habit.frequency.toString().split('.').last;
    if (frequency != 'hourly' &&
        frequency != 'single' &&
        habit.notificationTime == null) {
      AppLogger.debug(
        'Skipping notifications - no time set for non-hourly habit',
      );
      AppLogger.info('No notification time set for habit: ${habit.name}');
      return;
    }

    final notificationTime = habit.notificationTime;
    int hour = 9; // Default hour for hourly habits
    int minute = 0; // Default minute for hourly habits

    if (notificationTime != null) {
      hour = notificationTime.hour;
      minute = notificationTime.minute;
      AppLogger.debug('Scheduling for $hour:$minute');
    } else {
      AppLogger.debug('Using default time for hourly habit');
    }

    try {
      // Cancel any existing notifications for this habit first
      await cancelHabitNotifications(
        generateSafeId(habit.id),
      ); // Use safe ID generation
      AppLogger.debug(
        'Cancelled existing notifications for habit ID: ${habit.id}',
      );

      final frequency = habit.frequency.toString().split('.').last;
      AppLogger.debug('Habit frequency: $frequency');

      switch (frequency) {
        case 'daily':
          AppLogger.debug('Scheduling daily notifications');
          await _scheduleDailyHabitNotifications(habit, hour, minute);
          break;

        case 'weekly':
          AppLogger.debug('Scheduling weekly notifications');
          await _scheduleWeeklyHabitNotifications(habit, hour, minute);
          break;

        case 'monthly':
          AppLogger.debug('Scheduling monthly notifications');
          await _scheduleMonthlyHabitNotifications(habit, hour, minute);
          break;

        case 'yearly':
          AppLogger.debug('Scheduling yearly notifications');
          await _scheduleYearlyHabitNotifications(habit, hour, minute);
          break;

        case 'single':
          AppLogger.debug('Scheduling single habit notification');
          await _scheduleSingleHabitNotifications(habit);
          break;

        case 'hourly':
          AppLogger.debug(
              'Skipping hourly notifications - handled by WorkManagerHabitService');
          // Hourly habits are handled by WorkManagerHabitService to avoid duplicates
          break;

        default:
          AppLogger.debug('Unknown frequency: $frequency');
          AppLogger.warning('Unknown habit frequency: ${habit.frequency}');
      }

      AppLogger.debug(
        'Successfully scheduled notifications for habit: ${habit.name}',
      );
      AppLogger.info(
        'Successfully scheduled notifications for habit: ${habit.name}',
      );
    } catch (e) {
      AppLogger.debug('Error scheduling notifications: $e');
      AppLogger.error(
        'Failed to schedule notifications for habit: ${habit.name}',
        e,
      );
      rethrow; // Re-throw so the UI can show the error
    }
  }

  /// Schedule alarm notifications for a habit (mutually exclusive with regular notifications)
  static Future<void> scheduleHabitAlarms(dynamic habit) async {
    AppLogger.debug('Starting alarm scheduling for habit: ${habit.name}');
    AppLogger.debug('Alarm enabled: ${habit.alarmEnabled}');
    AppLogger.debug('Alarm sound: ${habit.alarmSoundName}');
    AppLogger.debug('Snooze delay: 10 minutes (fixed default)');

    // Initialize AlarmManagerService to use system alarms for this habit
    await AlarmManagerService.initialize();

    // Skip if alarms are disabled
    if (!habit.alarmEnabled) {
      AppLogger.debug('Skipping alarms - disabled');
      AppLogger.info('Alarms disabled for habit: ${habit.name}');
      return;
    }

    // For non-hourly habits, require notification time (alarms use same time as notifications)
    final frequency = habit.frequency.toString().split('.').last;
    if (frequency != 'hourly' && habit.notificationTime == null) {
      AppLogger.debug('Skipping alarms - no time set for non-hourly habit');
      AppLogger.info('No alarm time set for habit: ${habit.name}');
      return;
    }

    final notificationTime = habit.notificationTime;
    int hour = 9; // Default hour for hourly habits
    int minute = 0; // Default minute for hourly habits

    if (notificationTime != null) {
      hour = notificationTime.hour;
      minute = notificationTime.minute;
      AppLogger.debug('Scheduling alarm for $hour:$minute');
    } else {
      AppLogger.debug('Using default time for hourly habit alarm');
    }

    try {
      // Cancel any existing alarms for this habit first
      await AlarmManagerService.cancelHabitAlarms(habit.id);
      AppLogger.debug('Cancelled existing alarms for habit ID: ${habit.id}');

      final frequency = habit.frequency.toString().split('.').last;
      AppLogger.debug('Habit frequency: $frequency');

      switch (frequency) {
        case 'daily':
          AppLogger.debug('Scheduling daily alarms');
          await _scheduleDailyHabitAlarmsNew(habit, hour, minute);
          break;

        case 'weekly':
          AppLogger.debug('Scheduling weekly alarms');
          await _scheduleWeeklyHabitAlarmsNew(habit, hour, minute);
          break;

        case 'monthly':
          AppLogger.debug('Scheduling monthly alarms');
          await _scheduleMonthlyHabitAlarmsNew(habit, hour, minute);
          break;

        case 'yearly':
          AppLogger.debug('Scheduling yearly alarms');
          await _scheduleYearlyHabitAlarmsNew(habit, hour, minute);
          break;

        case 'single':
          AppLogger.debug('Scheduling single habit alarm');
          await _scheduleSingleHabitAlarmsNew(habit);
          break;

        case 'hourly':
          AppLogger.debug('Scheduling hourly alarms');
          await _scheduleHourlyHabitAlarmsNew(habit);
          break;

        default:
          AppLogger.debug('Unknown frequency: $frequency');
          AppLogger.warning('Unknown habit frequency: ${habit.frequency}');
      }

      AppLogger.debug('Successfully scheduled alarms for habit: ${habit.name}');
      AppLogger.info('Successfully scheduled alarms for habit: ${habit.name}');
    } catch (e) {
      AppLogger.debug('Error scheduling alarms: $e');
      AppLogger.error('Failed to schedule alarms for habit: ${habit.name}', e);
      rethrow; // Re-throw so the UI can show the error
    }
  }

  /// Schedule daily habit notifications
  static Future<void> _scheduleDailyHabitNotifications(
    dynamic habit,
    int hour,
    int minute,
  ) async {
    // Minimal logging to reduce main thread work
    final now = DateTime.now();
    DateTime nextNotification = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the time has passed today, schedule for tomorrow
    if (nextNotification.isBefore(now)) {
      nextNotification = nextNotification.add(const Duration(days: 1));
    }

    try {
      await scheduleHabitNotification(
        id: generateSafeId(habit.id), // Use safe ID generation
        habitId: habit.id.toString(),
        title: '🎯 ${habit.name}',
        body: 'Time to complete your daily habit! Keep your streak going.',
        scheduledTime: nextNotification,
      );
      AppLogger.debug(
        'Successfully scheduled daily notification for ${habit.name}',
      );
    } catch (e) {
      AppLogger.debug('Error scheduling daily notification: $e');
      rethrow;
    }
  }

  /// Schedule weekly habit notifications
  static Future<void> _scheduleWeeklyHabitNotifications(
    dynamic habit,
    int hour,
    int minute,
  ) async {
    final selectedWeekdays = habit.selectedWeekdays ?? <int>[];
    final now = DateTime.now();

    for (int weekday in selectedWeekdays) {
      DateTime nextNotification = DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      // Find the next occurrence of this weekday
      while (nextNotification.weekday != weekday) {
        nextNotification = nextNotification.add(const Duration(days: 1));
      }

      // If the time has passed today, schedule for next week
      if (nextNotification.isBefore(now)) {
        nextNotification = nextNotification.add(const Duration(days: 7));
      }

      await scheduleHabitNotification(
        id: generateSafeId(
          habit.id + '_week_$weekday',
        ), // Use string concatenation for uniqueness
        habitId: habit.id.toString(),
        title: '🎯 ${habit.name}',
        body: 'Time to complete your weekly habit! Don\'t break your streak.',
        scheduledTime: nextNotification,
      );
    }
  }

  /// Schedule monthly habit notifications
  static Future<void> _scheduleMonthlyHabitNotifications(
    dynamic habit,
    int hour,
    int minute,
  ) async {
    final selectedMonthDays = habit.selectedMonthDays ?? <int>[];
    final now = DateTime.now();

    for (int monthDay in selectedMonthDays) {
      DateTime nextNotification = DateTime(
        now.year,
        now.month,
        monthDay,
        hour,
        minute,
      );

      // If the day has passed this month, schedule for next month
      if (nextNotification.isBefore(now)) {
        nextNotification = DateTime(
          now.year,
          now.month + 1,
          monthDay,
          hour,
          minute,
        );
      }

      // Handle case where the day doesn't exist in the target month
      try {
        nextNotification = DateTime(
          nextNotification.year,
          nextNotification.month,
          monthDay,
          hour,
          minute,
        );
      } catch (e) {
        // Skip this month if the day doesn't exist (e.g., Feb 30)
        continue;
      }

      await scheduleHabitNotification(
        id: generateSafeId(
          habit.id + '_month_$monthDay',
        ), // Use string concatenation for uniqueness
        habitId: habit.id.toString(),
        title: '🎯 ${habit.name}',
        body: 'Time to complete your monthly habit! Stay consistent.',
        scheduledTime: nextNotification,
      );
    }
  }

  /// Schedule yearly habit notifications
  static Future<void> _scheduleYearlyHabitNotifications(
    dynamic habit,
    int hour,
    int minute,
  ) async {
    final selectedYearlyDates = habit.selectedYearlyDates ?? <String>[];
    final now = DateTime.now();

    for (String dateString in selectedYearlyDates) {
      try {
        // Parse the date string (format: "yyyy-MM-dd")
        final parts = dateString.split('-');
        if (parts.length != 3) continue;

        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);

        DateTime nextNotification = DateTime(
          now.year,
          month,
          day,
          hour,
          minute,
        );

        // If the date has passed this year, schedule for next year
        if (nextNotification.isBefore(now)) {
          nextNotification = DateTime(now.year + 1, month, day, hour, minute);
        }

        await scheduleHabitNotification(
          id: generateSafeId(
            habit.id + '_year_${month}_$day',
          ), // Use string concatenation for uniqueness
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

  /// Schedule single habit notifications (one-time notification)
  static Future<void> _scheduleSingleHabitNotifications(
    dynamic habit,
  ) async {
    // Validate single habit requirements
    if (habit.singleDateTime == null) {
      final error =
          'Single habit "${habit.name}" requires a date/time to be set';
      AppLogger.error(error);
      throw ArgumentError(error);
    }

    final singleDateTime = habit.singleDateTime!;
    final now = DateTime.now();

    // Check if date/time is in the past
    if (singleDateTime.isBefore(now)) {
      final error =
          'Single habit "${habit.name}" date/time is in the past: $singleDateTime';
      AppLogger.error(error);
      throw StateError(error);
    }

    try {
      await scheduleHabitNotification(
        id: generateSafeId(
          '${habit.id}_single_${singleDateTime.millisecondsSinceEpoch}',
        ), // Use structured ID generation for uniqueness
        habitId: habit.id.toString(),
        title: '🎯 ${habit.name}',
        body: 'Time to complete your one-time habit!',
        scheduledTime: singleDateTime,
      );

      AppLogger.info(
          '✅ Scheduled single notification for "${habit.name}" at $singleDateTime');
    } catch (e) {
      final error =
          'Failed to schedule single habit notification for "${habit.name}": $e';
      AppLogger.error(error);
      throw Exception(error);
    }
  }

  // ============ ALARM SCHEDULING METHODS (DEPRECATED - USING AlarmService) ============
  // Old alarm scheduling methods removed - now using AlarmService for exact alarms

  /// Schedule weekly habit alarms
  // ignore: unused_element
  static Future<void> _scheduleWeeklyHabitAlarms(
    dynamic habit,
    int hour,
    int minute,
  ) async {
    AppLogger.debug('Scheduling weekly alarms for ${habit.name}');

    if (habit.selectedWeekdays != null && habit.selectedWeekdays.isNotEmpty) {
      for (int weekday in habit.selectedWeekdays) {
        DateTime nextAlarm = _getNextWeekdayDateTime(weekday, hour, minute);

        try {
          await scheduleHabitAlarm(
            id: generateSafeId('${habit.id}_weekly_$weekday'),
            habitId: habit.id.toString(),
            title: '🚨 ${habit.name}',
            body: 'Alarm: Time for your weekly habit!',
            scheduledTime: nextAlarm,
            alarmSoundName: habit.alarmSoundName,
            snoozeDelayMinutes:
                10, // Fixed default - no snooze for alarm habits
          );

          AppLogger.debug(
            'Scheduled weekly alarm for ${habit.name} on weekday $weekday at $nextAlarm',
          );
        } catch (e) {
          AppLogger.error(
            'Error scheduling weekly alarm for ${habit.name} on weekday $weekday',
            e,
          );
        }
      }
    }
  }

  /// Schedule monthly habit alarms
  // ignore: unused_element
  static Future<void> _scheduleMonthlyHabitAlarms(
    dynamic habit,
    int hour,
    int minute,
  ) async {
    AppLogger.debug('Scheduling monthly alarms for ${habit.name}');
    final now = DateTime.now();

    if (habit.selectedMonthDays != null && habit.selectedMonthDays.isNotEmpty) {
      for (int day in habit.selectedMonthDays) {
        DateTime nextAlarm = DateTime(now.year, now.month, day, hour, minute);

        // If the day has passed this month, schedule for next month
        if (nextAlarm.isBefore(now)) {
          nextAlarm = DateTime(now.year, now.month + 1, day, hour, minute);
        }

        try {
          await scheduleHabitAlarm(
            id: generateSafeId('${habit.id}_monthly_$day'),
            habitId: habit.id.toString(),
            title: '🚨 ${habit.name}',
            body: 'Alarm: Time for your monthly habit!',
            scheduledTime: nextAlarm,
            alarmSoundName: habit.alarmSoundName,
            snoozeDelayMinutes:
                10, // Fixed default - no snooze for alarm habits
          );

          AppLogger.debug(
            'Scheduled monthly alarm for ${habit.name} on day $day at $nextAlarm',
          );
        } catch (e) {
          AppLogger.error(
            'Error scheduling monthly alarm for ${habit.name} on day $day',
            e,
          );
        }
      }
    }
  }

  /// Schedule yearly habit alarms
  // ignore: unused_element
  static Future<void> _scheduleYearlyHabitAlarms(
    dynamic habit,
    int hour,
    int minute,
  ) async {
    AppLogger.debug('Scheduling yearly alarms for ${habit.name}');
    final now = DateTime.now();

    if (habit.selectedYearlyDates != null &&
        habit.selectedYearlyDates.isNotEmpty) {
      for (String dateString in habit.selectedYearlyDates) {
        try {
          final dateParts = dateString.split('-');
          final month = int.parse(dateParts[1]);
          final day = int.parse(dateParts[2]);

          DateTime nextAlarm = DateTime(now.year, month, day, hour, minute);

          // If the date has passed this year, schedule for next year
          if (nextAlarm.isBefore(now)) {
            nextAlarm = DateTime(now.year + 1, month, day, hour, minute);
          }

          await scheduleHabitAlarm(
            id: generateSafeId('${habit.id}_yearly_${month}_$day'),
            habitId: habit.id.toString(),
            title: '🚨 ${habit.name}',
            body:
                'Alarm: Time for your yearly habit! This is your special day.',
            scheduledTime: nextAlarm,
            alarmSoundName: habit.alarmSoundName,
            snoozeDelayMinutes:
                10, // Fixed default - no snooze for alarm habits
          );

          AppLogger.debug(
            'Scheduled yearly alarm for ${habit.name} on $dateString at $nextAlarm',
          );
        } catch (e) {
          AppLogger.error('Error parsing yearly date: $dateString', e);
        }
      }
    }
  }

  /// Schedule hourly habit alarms
  // ignore: unused_element
  static Future<void> _scheduleHourlyHabitAlarms(dynamic habit) async {
    final now = DateTime.now();

    // For hourly habits, use the specific times set by the user
    if (habit.hourlyTimes != null && habit.hourlyTimes.isNotEmpty) {
      AppLogger.debug(
        'Scheduling hourly alarms for specific times: ${habit.hourlyTimes}',
      );

      for (String timeString in habit.hourlyTimes) {
        try {
          // Parse the time string (format: "HH:mm")
          final timeParts = timeString.split(':');
          final hour = int.tryParse(timeParts[0]) ?? 9;
          final minute =
              timeParts.length > 1 ? (int.tryParse(timeParts[1]) ?? 0) : 0;

          DateTime nextAlarm = DateTime(
            now.year,
            now.month,
            now.day,
            hour,
            minute,
          );

          // If the time has passed today, schedule for tomorrow
          if (nextAlarm.isBefore(now)) {
            nextAlarm = nextAlarm.add(const Duration(days: 1));
          }

          await scheduleHabitAlarm(
            id: generateSafeId('${habit.id}_hourly_${hour}_$minute'),
            habitId: '${habit.id}|$hour:${minute.toString().padLeft(2, '0')}',
            title: '🚨 ${habit.name}',
            body: 'Alarm: Time for your habit! Scheduled for $timeString',
            scheduledTime: nextAlarm,
            alarmSoundName: habit.alarmSoundName,
            snoozeDelayMinutes:
                10, // Fixed default - no snooze for alarm habits
          );

          AppLogger.debug(
            'Scheduled hourly alarm for $timeString at $nextAlarm',
          );
        } catch (e) {
          AppLogger.error(
            'Error parsing hourly time "$timeString" for habit ${habit.name}',
            e,
          );
        }
      }
    } else {
      // Fallback: For hourly habits without specific times, schedule every hour during active hours (8 AM - 10 PM)
      AppLogger.debug(
        'No specific hourly times set, using default hourly alarm schedule (8 AM - 10 PM)',
      );
      for (int hour = 8; hour <= 22; hour++) {
        DateTime nextAlarm = DateTime(now.year, now.month, now.day, hour, 0);

        // If the time has passed today, schedule for tomorrow
        if (nextAlarm.isBefore(now)) {
          nextAlarm = nextAlarm.add(const Duration(days: 1));
        }

        await scheduleHabitAlarm(
          id: generateSafeId('${habit.id}_hourly_$hour'),
          habitId: '${habit.id}|$hour:00',
          title: '🚨 ${habit.name}',
          body: 'Hourly alarm: Time for your habit!',
          scheduledTime: nextAlarm,
          alarmSoundName: habit.alarmSoundName,
          snoozeDelayMinutes: 10, // Fixed default - no snooze for alarm habits
        );
      }
    }
  }

  /// Generate a safe 32-bit integer ID from a string
  static int generateSafeId(String habitId) {
    // Generate a much smaller base hash to leave room for multiplications and additions
    int hash = 0;
    for (int i = 0; i < habitId.length; i++) {
      hash = ((hash << 3) - hash + habitId.codeUnitAt(i)) &
          0xFFFFFF; // Use 24 bits max
    }
    // Ensure we have a reasonable range for the base ID (1-16777215)
    return (hash % 16777215) + 1;
  }

  /// Get pending notifications
  static Future<List<PendingNotificationRequest>>
      getPendingNotifications() async {
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
    if (!_isInitialized) await initialize();

    AppLogger.info(
        '🧪 Creating SIMPLE test notification to verify handlers work...');

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      channelDescription: 'Test notifications for debugging',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      // NO ACTIONS - just basic notification
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    final payload = jsonEncode({'habitId': 'test', 'type': 'test'});

    await _notificationsPlugin.show(
      999,
      '🧪 SIMPLE TEST',
      'Tap this notification (no buttons) to test basic handlers!',
      details,
      payload: payload,
    );

    AppLogger.info(
        '🧪 SIMPLE test notification created - tap the notification body (not buttons) to see if handlers are called');
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
      sound: UriAndroidNotificationSound(
          'content://settings/system/notification_sound'),
      enableVibration: true,
      playSound: true,
      actions: [
        const AndroidNotificationAction(
          'complete',
          'COMPLETE',
        ),
        const AndroidNotificationAction(
          'snooze',
          'SNOOZE 30MIN',
        ),
      ],
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(categoryIdentifier: 'habit_category');

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final payload = jsonEncode({'habitId': habitId, 'type': 'habit_reminder'});

    await _notificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );

    // Debug logging for notification creation
    AppLogger.info('🔔 Habit notification created with:');
    AppLogger.info('  - ID: $id');
    AppLogger.info('  - HabitID: $habitId');
    AppLogger.info('  - Title: $title');
    AppLogger.info('  - Body: $body');
    AppLogger.info('  - Payload: $payload');
    AppLogger.info('  - Actions: complete_action, snooze_action');
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

    // Check and request all notification permissions if needed
    final bool permissionsGranted = await _ensureNotificationPermissions();
    if (!permissionsGranted) {
      AppLogger.warning(
        'Cannot schedule notification - permissions not granted',
      );
      return; // Don't schedule if permissions are denied
    }

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'habit_scheduled_channel',
      'Scheduled Habit Notifications',
      channelDescription: 'Scheduled notifications for habit reminders',
      importance: Importance.max,
      priority: Priority.high,
      sound: UriAndroidNotificationSound(
          'content://settings/system/notification_sound'),
      playSound: true,
      enableVibration: true,
      actions: [
        const AndroidNotificationAction(
          'complete',
          'COMPLETE',
        ),
        const AndroidNotificationAction(
          'snooze',
          'SNOOZE 30MIN',
        ),
      ],
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(categoryIdentifier: 'habit_category');

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final deviceNow = DateTime.now();
    final localScheduledTime = scheduledTime.toLocal();

    // Enhanced time validation and timezone handling
    final timeDiff = localScheduledTime.difference(deviceNow);
    AppLogger.debug('Device current time: $deviceNow');
    AppLogger.debug('Target scheduled time: $localScheduledTime');
    AppLogger.debug(
        'Time until notification: ${timeDiff.inSeconds} seconds (${timeDiff.inMinutes} minutes)');

    // Validate scheduling time is reasonable
    if (timeDiff.inSeconds < 0) {
      AppLogger.warning(
          '⚠️ Warning: Scheduling time is in the past! Adjusting to 1 minute from now.');
      final adjustedTime = deviceNow.add(const Duration(minutes: 1));
      return await scheduleHabitNotification(
        id: id,
        habitId: habitId,
        title: title,
        body: body,
        scheduledTime: adjustedTime,
      );
    }

    if (timeDiff.inDays > 1) {
      AppLogger.warning(
          '⚠️ Warning: Scheduling time is more than 1 day in the future (${timeDiff.inDays} days)');
    }

    // Create timezone-aware scheduled time with proper validation
    tz.TZDateTime tzScheduledTime;
    try {
      tzScheduledTime = tz.TZDateTime.from(localScheduledTime, tz.local);
      AppLogger.debug('TZ Scheduled time: $tzScheduledTime');
      AppLogger.debug('TZ Local timezone: ${tz.local.name}');

      // Verify timezone conversion didn't cause time drift
      final tzTimeDiff =
          tzScheduledTime.difference(tz.TZDateTime.now(tz.local));
      if ((tzTimeDiff.inSeconds - timeDiff.inSeconds).abs() > 60) {
        AppLogger.warning(
            '⚠️ Timezone conversion caused significant time drift: ${tzTimeDiff.inSeconds - timeDiff.inSeconds} seconds');
      }
    } catch (tzError) {
      AppLogger.error('Timezone conversion failed, using UTC', tzError);
      tzScheduledTime = tz.TZDateTime.from(localScheduledTime.toUtc(), tz.UTC);
    }

    final payload = jsonEncode({'habitId': habitId, 'type': 'habit_reminder'});

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// Schedule an alarm notification with custom sound and snooze delay
  static Future<void> scheduleHabitAlarm({
    required int id,
    required String habitId,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? alarmSoundName,
    int snoozeDelayMinutes = 10,
  }) async {
    if (!_isInitialized) await initialize();

    AppLogger.info('🚨 Scheduling alarm notification:');
    AppLogger.info('  - ID: $id');
    AppLogger.info('  - Habit ID: $habitId');
    AppLogger.info('  - Title: $title');
    AppLogger.info('  - Scheduled time: $scheduledTime');
    AppLogger.info(
      '  - Alarm sound: $alarmSoundName (using default system sound)',
    );
    AppLogger.info('  - Snooze delay: ${snoozeDelayMinutes}min');

    // Check and request all notification permissions if needed
    final bool permissionsGranted = await _ensureNotificationPermissions();
    if (!permissionsGranted) {
      AppLogger.warning(
        'Cannot schedule notification - permissions not granted',
      );
      return; // Don't schedule if permissions are denied
    }

    // Create custom snooze text based on delay
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

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'habit_alarm_default',
      'Habit Alarms',
      channelDescription: 'High-priority alarm notifications for habits',
      importance: Importance.max,
      priority: Priority.max,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
      // Use system alarm sound for maximum compatibility with Android 16
      sound:
          UriAndroidNotificationSound('content://settings/system/alarm_alert'),
      playSound: true,
      enableVibration: true,
      enableLights: true,
      actions: [
        const AndroidNotificationAction(
          'complete',
          '✅ COMPLETE',
          showsUserInterface: true,
          cancelNotification: true,
          allowGeneratedReplies: false,
        ),
        AndroidNotificationAction(
          'snooze_alarm',
          snoozeText,
          showsUserInterface: true,
          cancelNotification: true,
          allowGeneratedReplies: false,
        ),
      ],
    );

    final DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      categoryIdentifier: 'habit_category',
      sound: alarmSoundName != null && alarmSoundName != 'default'
          ? alarmSoundName
          : 'default',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.critical,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );

    final payload = jsonEncode({
      'habitId': habitId,
      'type': 'habit_alarm',
      'snoozeDelayMinutes': snoozeDelayMinutes,
    });

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
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

    AppLogger.info(
      '✅ Notification snoozed for 30 minutes - new notification scheduled',
    );
  }

  /// Snooze an alarm notification with custom delay
  static Future<void> snoozeAlarm({
    required int id,
    required String habitId,
    required String title,
    required String body,
    String? alarmSoundName,
    int snoozeDelayMinutes = 10,
  }) async {
    AppLogger.info(
      '🔄 Snoozing alarm ID: $id for habit: $habitId for $snoozeDelayMinutes minutes',
    );

    // Cancel the current alarm
    await _notificationsPlugin.cancel(id);
    AppLogger.info('❌ Current alarm cancelled');

    // Schedule a new one for the specified delay
    final snoozeTime = DateTime.now().add(
      Duration(minutes: snoozeDelayMinutes),
    );
    AppLogger.info('⏰ Scheduling new alarm for: $snoozeTime');

    await scheduleHabitAlarm(
      id: id,
      habitId: habitId,
      title: title,
      body: body,
      scheduledTime: snoozeTime,
      alarmSoundName: alarmSoundName,
      snoozeDelayMinutes: snoozeDelayMinutes,
    );

    AppLogger.info(
      '✅ Alarm snoozed for $snoozeDelayMinutes minutes - new alarm scheduled',
    );
  }

  /// Debug method to check exact alarm permissions and timezone
  static Future<Map<String, dynamic>> getSchedulingDebugInfo() async {
    final Map<String, dynamic> debugInfo = {};

    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        debugInfo['notificationsEnabled'] =
            await androidImplementation.areNotificationsEnabled();

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
    AppLogger.info(
      'Time difference: ${scheduledTime.difference(now).inSeconds} seconds',
    );

    try {
      // Cancel any existing test notifications first
      await cancelNotification(1001);
      AppLogger.info('Cancelled any existing test notifications');

      await scheduleNotification(
        id: 1001,
        title: '🔔 Debug Scheduled Test',
        body:
            'This notification was scheduled at ${now.toString().substring(11, 19)} and should fire at ${scheduledTime.toString().substring(11, 19)}',
        scheduledTime: scheduledTime.toLocal(),
        payload: 'debug_scheduled_test',
      );
      AppLogger.info('Scheduled notification successfully queued');

      // Check if it was actually scheduled
      final pending = await getPendingNotifications();
      AppLogger.info('Pending notifications: ${pending.length}');
      for (var notification in pending) {
        AppLogger.info(
          '- ID: ${notification.id}, Title: ${notification.title}',
        );
      }

      // Add a verification step
      AppLogger.info(
        'Verification: Notification system should deliver the notification in 10 seconds',
      );
      AppLogger.info('Watch your device for the notification!');
    } catch (e) {
      AppLogger.error('Error scheduling notification', e);
      AppLogger.error('Stack trace: ${StackTrace.current}');
    }
  }

  /// Check if the device has aggressive battery optimization that might affect notifications
  static Future<void> checkBatteryOptimizationStatus() async {
    try {
      AppLogger.info('🔋 Checking battery optimization status...');

      // Note: This is informational only. The actual battery optimization check
      // would require additional platform-specific code or plugins
      AppLogger.info('💡 To ensure reliable snooze notifications:');
      AppLogger.info('1. Go to Settings > Apps > HabitV8 > Battery');
      AppLogger.info('2. Set battery optimization to "Don\'t optimize"');
      AppLogger.info('3. Ensure "Allow background activity" is enabled');
      AppLogger.info(
          '4. For Samsung devices: Add HabitV8 to "Never sleeping apps"');
      AppLogger.info(
          '5. For MIUI devices: Enable "Autostart" and disable "Battery saver"');
      AppLogger.info(
          '6. For OnePlus/OPPO: Disable "Smart Power Saving" for this app');
      AppLogger.info(
          '7. For Huawei: Add to "Protected Apps" and disable "Battery Optimization"');
    } catch (e) {
      AppLogger.error('Error checking battery optimization', e);
    }
  }

  /// Test the snooze functionality with comprehensive validation
  static Future<void> testSnoozeFunction() async {
    try {
      AppLogger.info('🧪 Testing snooze function...');

      // Create a test habit ID
      const testHabitId = 'test_snooze_habit';

      // First, check all prerequisites
      AppLogger.info('1. Checking prerequisites...');
      final canScheduleExact = await canScheduleExactAlarms();
      final notificationsEnabled = await areNotificationsEnabled();

      AppLogger.info('   - Exact alarms: $canScheduleExact');
      AppLogger.info('   - Notifications enabled: $notificationsEnabled');

      if (!notificationsEnabled) {
        AppLogger.error(
            '❌ Notifications are not enabled - test cannot proceed');
        return;
      }

      // Show immediate test notification
      AppLogger.info('2. Showing immediate test notification...');
      final testNotificationId = _generateSnoozeNotificationId(testHabitId);

      await showNotification(
        id: testNotificationId,
        title: '🧪 Snooze Test Notification',
        body: 'Tap "SNOOZE 30MIN" to test the snooze function',
        payload: jsonEncode({'habitId': testHabitId, 'type': 'habit_reminder'}),
      );

      AppLogger.info('3. Test notification shown with ID: $testNotificationId');
      AppLogger.info('4. Use the snooze button to test the function');
      AppLogger.info('5. Check logs for snooze scheduling details');

      // Set up verification timer
      Timer(const Duration(seconds: 5), () async {
        final pending = await getPendingNotifications();
        AppLogger.info('6. Current pending notifications: ${pending.length}');
        for (final notif in pending) {
          if (notif.id == testNotificationId) {
            AppLogger.info('   - Original test notification still pending');
          } else if (notif.title?.contains('Snoozed') == true) {
            AppLogger.info('   - Found snoozed notification: ID ${notif.id}');
          }
        }
      });
    } catch (e) {
      AppLogger.error('Error testing snooze function', e);
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
          final bool? canSchedule =
              await androidImplementation.canScheduleExactNotifications();
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

  /// Request exact alarm permission (Android 12+)
  static Future<bool> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return true;

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      try {
        // Check if device is Android 12+
        final bool isAndroid12Plus = await _isAndroid12Plus();

        if (isAndroid12Plus) {
          // Request exact alarm permission
          final bool? granted =
              await androidImplementation.requestExactAlarmsPermission();
          AppLogger.info('Exact alarm permission granted: $granted');
          return granted ?? false;
        } else {
          // Android 11 and below don't need exact alarm permission
          return true;
        }
      } catch (e) {
        AppLogger.error('Error requesting exact alarm permission', e);
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

  /// Request exact alarm permission with user guidance
  /// This should be called when the user specifically wants to enable exact timing
  static Future<bool> requestExactAlarmPermissionWithGuidance() async {
    if (!Platform.isAndroid) return true;

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      try {
        // Check if device is Android 12+
        final bool isAndroid12Plus = await _isAndroid12Plus();

        if (isAndroid12Plus) {
          AppLogger.info(
            'User requested exact alarm permission - opening settings',
          );

          // Request exact alarm permission (this will open Android settings)
          final bool? granted =
              await androidImplementation.requestExactAlarmsPermission();

          AppLogger.info('Exact alarm permission request result: $granted');
          return granted ?? false;
        } else {
          // Android 11 and below don't need exact alarm permission
          AppLogger.info(
            'Android 11 or below - exact alarms automatically available',
          );
          return true;
        }
      } catch (e) {
        AppLogger.error(
          'Error requesting exact alarm permission with guidance',
          e,
        );
        return false;
      }
    }
    return false;
  }

  /// Get detailed information about exact alarm permission status
  static Future<Map<String, dynamic>> getExactAlarmPermissionInfo() async {
    final info = <String, dynamic>{};

    if (!Platform.isAndroid) {
      info['platform'] = 'non-android';
      info['canScheduleExact'] = true;
      info['message'] = 'Exact alarms are supported on this platform';
      return info;
    }

    try {
      final isAndroid12Plus = await _isAndroid12Plus();
      final canSchedule = await canScheduleExactAlarms();

      info['platform'] = 'android';
      info['isAndroid12Plus'] = isAndroid12Plus;
      info['canScheduleExact'] = canSchedule;

      if (!isAndroid12Plus) {
        info['message'] =
            'Exact alarms are automatically available on Android 11 and below';
      } else if (canSchedule) {
        info['message'] = 'Exact alarms are enabled and working properly';
      } else {
        info['message'] =
            'Exact alarms are restricted. The app will use inexact alarms (may be delayed by up to 15 minutes)';
        info['userAction'] =
            'To enable exact timing, go to Android Settings > Apps > HabitV8 > Alarms & reminders and toggle it on';
        info['note'] =
            'On Android 14+, this permission is restricted by default to preserve battery life';
      }
    } catch (e) {
      info['error'] = e.toString();
      info['message'] = 'Unable to determine exact alarm permission status';
    }

    return info;
  }

  /// Test method to show a notification with action buttons for debugging
  static Future<void> showTestNotificationWithActions() async {
    AppLogger.info('🧪 Creating test notification with action buttons...');
    AppLogger.info('📱 Platform: ${Platform.operatingSystem}');
    AppLogger.info('🔧 Background handler registered: true');
    AppLogger.info('🔗 Callback set: ${onNotificationAction != null}');

    await showHabitNotification(
      id: 999999,
      habitId: 'test-habit-id',
      title: '🧪 Test Notification with Actions',
      body: 'Try the Complete and Snooze buttons below!',
    );
    AppLogger.info('✅ Test notification with actions shown with ID: 999999');
    AppLogger.info('🔘 Action buttons: complete, snooze');
    AppLogger.info(
      '💡 Tap the notification or use the action buttons to test functionality',
    );
    AppLogger.info('🔍 Expected behavior:');
    AppLogger.info(
        '  - COMPLETE button should call the notification action callback');
    AppLogger.info(
        '  - SNOOZE button should schedule a new notification in 30 minutes');
  }

  /// Show a simple test notification to verify basic functionality
  static Future<void> showSimpleTestNotification() async {
    AppLogger.info('🧪 Creating simple test notification...');

    await showNotification(
      id: 888888,
      title: '🔔 Simple Test Notification',
      body: 'This is a basic test notification without actions. Tap me!',
      payload: jsonEncode({'habitId': 'simple-test', 'type': 'test'}),
    );
    AppLogger.info('✅ Simple test notification shown with ID: 888888');
  }

  /// Debug method to test notification system comprehensively
  static Future<void> debugNotificationSystem() async {
    AppLogger.info('🔍 === NOTIFICATION SYSTEM DEBUG ===');
    AppLogger.info('🔧 Initialized: $_isInitialized');
    AppLogger.info('📱 Platform: ${Platform.operatingSystem}');
    AppLogger.info('🔗 Callback set: ${onNotificationAction != null}');
    AppLogger.info('🔍 Callback set count: $_callbackSetCount');
    AppLogger.info('🔍 Last callback set time: $_lastCallbackSetTime');
    AppLogger.info('🔍 Current time: ${DateTime.now()}');
    AppLogger.info('📋 Pending actions: ${_pendingActions.length}');

    if (_pendingActions.isNotEmpty) {
      AppLogger.info('📋 Pending actions details:');
      for (int i = 0; i < _pendingActions.length; i++) {
        final action = _pendingActions[i];
        AppLogger.info(
          '  [$i] ${action['action']} for ${action['habitId']} at ${action['timestamp']}',
        );
      }
    }

    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final bool? notificationsEnabled =
            await androidImplementation.areNotificationsEnabled();
        AppLogger.info('🔔 Notifications enabled: $notificationsEnabled');

        final bool canScheduleExact = await canScheduleExactAlarms();
        AppLogger.info('⏰ Can schedule exact alarms: $canScheduleExact');
      }
    }

    AppLogger.info('🔍 === END DEBUG ===');
  }

  /// Helper method to get the next occurrence of a specific weekday at a specific time
  static DateTime _getNextWeekdayDateTime(int weekday, int hour, int minute) {
    final now = DateTime.now();
    DateTime nextDate = DateTime(now.year, now.month, now.day, hour, minute);

    // Calculate days until the target weekday
    // weekday: 1 = Monday, 2 = Tuesday, ..., 7 = Sunday
    // DateTime.weekday: 1 = Monday, 2 = Tuesday, ..., 7 = Sunday
    int daysUntilTarget = (weekday - now.weekday) % 7;

    // If it's the same weekday but the time has passed, schedule for next week
    if (daysUntilTarget == 0 && nextDate.isBefore(now)) {
      daysUntilTarget = 7;
    }

    nextDate = nextDate.add(Duration(days: daysUntilTarget));
    return nextDate;
  }

  /// Schedule notifications/alarms for all existing habits
  /// This should be called during app initialization to ensure existing habits have their notifications scheduled
  static Future<void> scheduleAllHabitNotifications() async {
    // Use debouncing to prevent multiple rapid calls during app startup
    BackgroundTaskService.debounceTask(
      'scheduleAllHabitNotifications',
      () => _performScheduleAllHabitNotificationsWithQueue(),
      delay: const Duration(seconds: 2),
    );
  }

  /// Alternative method using the queue processor for better main thread protection
  static Future<void> _performScheduleAllHabitNotificationsWithQueue() async {
    try {
      AppLogger.info('🔄 Starting queue-based notification scheduling...');

      // First, cancel all existing notifications to prevent duplicates
      await BackgroundTaskService.executeLightweightTask(
        'cancelAllNotifications',
        () => cancelAllNotifications(),
      );

      // Get all habits from the database
      final habitBox = await DatabaseService.getInstance();
      final habitService = HabitService(habitBox);
      final habits = await habitService.getAllHabits();

      AppLogger.info('📋 Found ${habits.length} habits to process with queue');

      // Use the queue processor to handle notifications in the background
      await NotificationQueueProcessor.processHabitsForNotifications(habits);

      AppLogger.info('✅ Queue-based notification scheduling initiated');
    } catch (e) {
      AppLogger.error('❌ Error in queue-based notification scheduling', e);
    }
  }

  // ========== NEW ALARM SCHEDULING METHODS USING ANDROID ALARM MANAGER PLUS ==========

  /// Schedule daily habit alarms using AlarmService
  static Future<void> _scheduleDailyHabitAlarmsNew(
    dynamic habit,
    int hour,
    int minute,
  ) async {
    final now = DateTime.now();
    DateTime nextAlarm = DateTime(now.year, now.month, now.day, hour, minute);

    // If the time has passed today, schedule for tomorrow
    if (nextAlarm.isBefore(now)) {
      nextAlarm = nextAlarm.add(const Duration(days: 1));
    }

    final alarmId = AlarmManagerService.generateHabitAlarmId(
      habit.id,
      suffix: 'daily',
    );

    await AlarmManagerService.scheduleRecurringExactAlarm(
      alarmId: alarmId,
      habitId: habit.id,
      habitName: habit.name,
      scheduledTime: nextAlarm,
      frequency: 'daily',
      alarmSoundName: habit.alarmSoundName,
      alarmSoundUri: habit.alarmSoundUri,
      snoozeDelayMinutes: 10, // Fixed default - no snooze for alarm habits
    );
    AppLogger.info('✅ Scheduled daily alarms for ${habit.name}');
  }

  /// Schedule weekly habit alarms using AlarmService
  static Future<void> _scheduleWeeklyHabitAlarmsNew(
    dynamic habit,
    int hour,
    int minute,
  ) async {
    final selectedWeekdays = habit.selectedWeekdays ?? <int>[];
    if (selectedWeekdays.isEmpty) {
      AppLogger.warning('No weekdays selected for weekly habit: ${habit.name}');
      return;
    }

    final now = DateTime.now();

    for (int i = 0; i < selectedWeekdays.length; i++) {
      final weekday = selectedWeekdays[i];
      DateTime nextAlarm = DateTime(now.year, now.month, now.day, hour, minute);

      // Find the next occurrence of this weekday
      while (nextAlarm.weekday != weekday) {
        nextAlarm = nextAlarm.add(const Duration(days: 1));
      }

      // If the time has passed today, schedule for next week
      if (nextAlarm.isBefore(now)) {
        nextAlarm = nextAlarm.add(const Duration(days: 7));
      }

      final alarmId = AlarmManagerService.generateHabitAlarmId(
        habit.id,
        suffix: 'weekly_$weekday',
      );

      await AlarmManagerService.scheduleRecurringExactAlarm(
        alarmId: alarmId,
        habitId: habit.id,
        habitName: habit.name,
        scheduledTime: nextAlarm,
        frequency: 'weekly',
        alarmSoundName: habit.alarmSoundName,
        alarmSoundUri: habit.alarmSoundUri,
        snoozeDelayMinutes: 10, // Fixed default - no snooze for alarm habits
      );
    }

    AppLogger.info(
      '✅ Scheduled weekly alarms for ${habit.name} on ${selectedWeekdays.length} days',
    );
  }

  /// Schedule monthly habit alarms using AlarmService
  static Future<void> _scheduleMonthlyHabitAlarmsNew(
    dynamic habit,
    int hour,
    int minute,
  ) async {
    final selectedMonthDays = habit.selectedMonthDays ?? <int>[];
    if (selectedMonthDays.isEmpty) {
      AppLogger.warning(
        'No month days selected for monthly habit: ${habit.name}',
      );
      return;
    }

    final now = DateTime.now();

    for (int i = 0; i < selectedMonthDays.length; i++) {
      final monthDay = selectedMonthDays[i];
      DateTime nextAlarm;

      try {
        nextAlarm = DateTime(now.year, now.month, monthDay, hour, minute);

        // If the date has passed this month, schedule for next month
        if (nextAlarm.isBefore(now)) {
          nextAlarm = DateTime(now.year, now.month + 1, monthDay, hour, minute);
        }
      } catch (e) {
        // Handle invalid dates (e.g., February 30th)
        AppLogger.warning(
          'Invalid date for monthly habit ${habit.name}: day $monthDay',
        );
        continue;
      }

      final alarmId = AlarmManagerService.generateHabitAlarmId(
        habit.id,
        suffix: 'monthly_$monthDay',
      );

      await AlarmManagerService.scheduleRecurringExactAlarm(
        alarmId: alarmId,
        habitId: habit.id,
        habitName: habit.name,
        scheduledTime: nextAlarm,
        frequency: 'monthly',
        alarmSoundName: habit.alarmSoundName,
        alarmSoundUri: habit.alarmSoundUri,
        snoozeDelayMinutes: 10, // Fixed default - no snooze for alarm habits
      );
    }

    AppLogger.info(
      '✅ Scheduled monthly alarms for ${habit.name} on ${selectedMonthDays.length} days',
    );
  }

  /// Schedule yearly habit alarms using AlarmService
  static Future<void> _scheduleYearlyHabitAlarmsNew(
    dynamic habit,
    int hour,
    int minute,
  ) async {
    final selectedYearlyDates = habit.selectedYearlyDates ?? <String>[];
    if (selectedYearlyDates.isEmpty) {
      AppLogger.warning(
        'No yearly dates selected for yearly habit: ${habit.name}',
      );
      return;
    }

    final now = DateTime.now();

    for (int i = 0; i < selectedYearlyDates.length; i++) {
      final dateString = selectedYearlyDates[i];

      try {
        // Parse date string (format: "yyyy-MM-dd")
        final dateParts = dateString.split('-');
        if (dateParts.length != 3) continue;

        final month = int.parse(dateParts[1]);
        final day = int.parse(dateParts[2]);

        DateTime nextAlarm = DateTime(now.year, month, day, hour, minute);

        // If the date has passed this year, schedule for next year
        if (nextAlarm.isBefore(now)) {
          nextAlarm = DateTime(now.year + 1, month, day, hour, minute);
        }

        final alarmId = AlarmManagerService.generateHabitAlarmId(
          habit.id,
          suffix: 'yearly_${month}_$day',
        );

        await AlarmManagerService.scheduleRecurringExactAlarm(
          alarmId: alarmId,
          habitId: habit.id,
          habitName: habit.name,
          scheduledTime: nextAlarm,
          frequency: 'yearly',
          alarmSoundName: habit.alarmSoundName,
          alarmSoundUri: habit.alarmSoundUri,
          snoozeDelayMinutes: 10, // Fixed default - no snooze for alarm habits
        );
      } catch (e) {
        AppLogger.warning(
          'Invalid yearly date for habit ${habit.name}: $dateString',
        );
        continue;
      }
    }

    AppLogger.info(
      '✅ Scheduled yearly alarms for ${habit.name} on ${selectedYearlyDates.length} dates',
    );
  }

  /// Schedule single habit alarms using AlarmService
  static Future<void> _scheduleSingleHabitAlarmsNew(dynamic habit) async {
    // Validate single habit requirements
    if (habit.singleDateTime == null) {
      final error =
          'Single habit "${habit.name}" requires a date/time to be set for alarms';
      AppLogger.error(error);
      throw ArgumentError(error);
    }

    final singleDateTime = habit.singleDateTime!;
    final now = DateTime.now();

    // Check if date/time is in the past
    if (singleDateTime.isBefore(now)) {
      final error =
          'Single habit "${habit.name}" alarm date/time is in the past: $singleDateTime';
      AppLogger.error(error);
      throw StateError(error);
    }

    try {
      final alarmId = AlarmManagerService.generateHabitAlarmId(
        habit.id,
        suffix: 'single_${singleDateTime.millisecondsSinceEpoch}',
      );

      await AlarmManagerService.scheduleExactAlarm(
        alarmId: alarmId,
        habitId: habit.id,
        habitName: habit.name,
        scheduledTime: singleDateTime,
        frequency: 'single',
        alarmSoundName: habit.alarmSoundName,
        alarmSoundUri: habit.alarmSoundUri,
        snoozeDelayMinutes: habit.snoozeDelayMinutes,
      );

      AppLogger.info(
          '✅ Scheduled single alarm for "${habit.name}" at $singleDateTime');
    } catch (e) {
      final error =
          'Failed to schedule single habit alarm for "${habit.name}": $e';
      AppLogger.error(error);
      throw Exception(error);
    }
  }

  /// Schedule hourly habit alarms using AlarmService
  static Future<void> _scheduleHourlyHabitAlarmsNew(dynamic habit) async {
    final now = DateTime.now();

    // For hourly habits, use the specific times set by the user
    if (habit.hourlyTimes != null && habit.hourlyTimes.isNotEmpty) {
      AppLogger.debug(
        'Scheduling hourly alarms for specific times: ${habit.hourlyTimes}',
      );

      for (int i = 0; i < habit.hourlyTimes.length; i++) {
        final timeString = habit.hourlyTimes[i];

        try {
          // Parse the time string (format: "HH:mm")
          final timeParts = timeString.split(':');
          final hour = int.tryParse(timeParts[0]) ?? 9;
          final minute =
              timeParts.length > 1 ? (int.tryParse(timeParts[1]) ?? 0) : 0;

          DateTime nextAlarm = DateTime(
            now.year,
            now.month,
            now.day,
            hour,
            minute,
          );

          // If the time has passed today, schedule for tomorrow
          if (nextAlarm.isBefore(now)) {
            nextAlarm = nextAlarm.add(const Duration(days: 1));
          }

          final alarmId = AlarmManagerService.generateHabitAlarmId(
            habit.id,
            suffix: 'hourly_${hour}_$minute',
          );

          await AlarmManagerService.scheduleRecurringExactAlarm(
            alarmId: alarmId,
            habitId: habit.id,
            habitName: habit.name,
            scheduledTime: nextAlarm,
            frequency: 'hourly',
            alarmSoundName: habit.alarmSoundName,
            alarmSoundUri: habit.alarmSoundUri,
            snoozeDelayMinutes:
                10, // Fixed default - no snooze for alarm habits
          );

          AppLogger.debug(
            'Scheduled hourly alarm for $timeString at $nextAlarm',
          );
        } catch (e) {
          AppLogger.error(
            'Error parsing hourly time "$timeString" for habit ${habit.name}',
            e,
          );
        }
      }
    } else {
      // Fallback: For hourly habits without specific times, schedule every hour during active hours (8 AM - 10 PM)
      AppLogger.debug(
        'No specific hourly times set, using default hourly alarm schedule (8 AM - 10 PM)',
      );

      for (int hour = 8; hour <= 22; hour++) {
        DateTime nextAlarm = DateTime(now.year, now.month, now.day, hour, 0);

        // If the time has passed today, schedule for tomorrow
        if (nextAlarm.isBefore(now)) {
          nextAlarm = nextAlarm.add(const Duration(days: 1));
        }

        final alarmId = AlarmManagerService.generateHabitAlarmId(
          habit.id,
          suffix: 'hourly_default_$hour',
        );

        await AlarmManagerService.scheduleRecurringExactAlarm(
          alarmId: alarmId,
          habitId: habit.id,
          habitName: habit.name,
          scheduledTime: nextAlarm,
          frequency: 'hourly',
          alarmSoundName: habit.alarmSoundName,
          alarmSoundUri: habit.alarmSoundUri,
          snoozeDelayMinutes: 10, // Fixed default - no snooze for alarm habits
        );
      }
    }

    AppLogger.info('✅ Scheduled hourly alarms for ${habit.name}');
  }

  /// Get available alarm sounds (delegated to AlarmManagerService)
  static Future<List<Map<String, String>>> getAvailableAlarmSounds() async {
    return await AlarmManagerService.getAvailableAlarmSounds();
  }

  /// Play alarm sound preview (delegated to AlarmManagerService)
  static Future<void> playAlarmSoundPreview(String soundUri) async {
    await AlarmManagerService.playAlarmSoundPreview(soundUri);
  }

  /// Stop alarm sound preview (delegated to AlarmManagerService)
  static Future<void> stopAlarmSoundPreview() async {
    await AlarmManagerService.stopAlarmSoundPreview();
  }

  /// Complete habit from notification action
  static Future<void> _completeHabitFromNotification(
      String habitId, DateTime actionTime) async {
    try {
      AppLogger.info(
          'Completing habit $habitId from notification at $actionTime');

      // Always try the callback first if available
      if (onNotificationAction != null) {
        AppLogger.info('Using callback to complete habit: $habitId');
        onNotificationAction!(habitId, 'complete');
        AppLogger.info('Complete action callback executed for habit: $habitId');
        return; // Success - exit early
      }

      // If no callback is available, we need to complete the habit directly
      // This happens when processing stored actions and the callback isn't set yet
      AppLogger.info(
          'No callback available, attempting direct completion for habit: $habitId');

      try {
        // Try to complete the habit directly using the direct completion handler
        // This bypasses the callback dependency
        if (directCompletionHandler != null) {
          await directCompletionHandler!(habitId);
          AppLogger.info('✅ Direct completion successful for habit: $habitId');
        } else {
          AppLogger.error('No direct completion handler available');
          AppLogger.error(
              'Habit completion failed - both callback and direct handler unavailable');
        }
      } catch (directError) {
        AppLogger.error(
            'Direct completion failed for habit: $habitId', directError);
        AppLogger.error(
            'Habit completion failed - both callback and direct completion failed');
      }
    } catch (e) {
      AppLogger.error('Error completing habit from notification: $habitId', e);
    }
  }

  /// Snooze habit notification
  static Future<void> _snoozeHabitNotification(String habitId) async {
    try {
      AppLogger.info('Snoozing notification for habit: $habitId');
      await _handleSnoozeAction(habitId);
    } catch (e) {
      AppLogger.error('Error snoozing habit notification: $habitId', e);
    }
  }

  // ========== MEMORY MANAGEMENT METHODS ==========

  /// Debug logging that only runs in debug mode
  static void _debugLog(String message) {
    if (kDebugMode) {
      AppLogger.debug(message);
    }
  }

  /// Start periodic cleanup to prevent memory leaks
  static void _startPeriodicCleanup() {
    _cleanupTimer?.cancel();
    _cleanupTimer =
        Timer.periodic(Duration(hours: 1), (_) => _cleanupPendingActions());
  }

  /// Clean up old pending actions to prevent memory leaks
  static void _cleanupPendingActions() {
    if (_pendingActions.length > _maxPendingActions) {
      final removeCount = _pendingActions.length - _maxPendingActions;
      _pendingActions.removeRange(0, removeCount);
      AppLogger.info('Cleaned up $removeCount old pending actions');
    }

    // Remove actions older than 24 hours
    final cutoff = DateTime.now().subtract(Duration(hours: 24));
    final initialCount = _pendingActions.length;
    _pendingActions.removeWhere((action) {
      final timestamp = DateTime.tryParse(action['timestamp'] ?? '');
      return timestamp != null && timestamp.isBefore(cutoff);
    });

    final removedCount = initialCount - _pendingActions.length;
    if (removedCount > 0) {
      AppLogger.info('Cleaned up $removedCount expired pending actions');
    }
  }

  /// Dispose resources when app is shutting down
  static void dispose() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
    _pendingActions.clear();
    AppLogger.info('NotificationService resources disposed');
  }
}
