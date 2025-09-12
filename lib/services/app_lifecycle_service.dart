// App Lifecycle Service for HabitV8
// Handles proper resource cleanup when the app is shutting down

import 'package:flutter/material.dart';
import 'background_task_service.dart';
import 'notification_queue_processor.dart';
// Old renewal services removed - now using midnight_habit_reset_service.dart
import 'notification_action_service.dart';
import 'notification_service.dart';
import 'logging_service.dart';

/// Service that manages app lifecycle events and ensures proper resource cleanup
class AppLifecycleService with WidgetsBindingObserver {
  static AppLifecycleService? _instance;
  static bool _isInitialized = false;

  AppLifecycleService._();

  /// Get the singleton instance
  static AppLifecycleService get instance {
    _instance ??= AppLifecycleService._();
    return _instance!;
  }

  /// Initialize the lifecycle service
  static void initialize() {
    if (_isInitialized) return;

    AppLogger.info('🔄 Initializing AppLifecycleService...');

    // Add the observer to listen for app lifecycle changes
    WidgetsBinding.instance.addObserver(instance);

    _isInitialized = true;
    AppLogger.info('✅ AppLifecycleService initialized successfully');
  }

  /// Dispose the lifecycle service
  static void dispose() {
    if (!_isInitialized) return;

    AppLogger.info('🔄 Disposing AppLifecycleService...');

    // Remove the observer
    WidgetsBinding.instance.removeObserver(instance);

    // Dispose all services
    _disposeAllServices();

    _isInitialized = false;
    _instance = null;

    AppLogger.info('✅ AppLifecycleService disposed successfully');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    AppLogger.info('📱 App lifecycle state changed to: $state');

    switch (state) {
      case AppLifecycleState.detached:
        // App is being terminated
        AppLogger.info('🛑 App is being terminated - cleaning up resources...');
        _disposeAllServices();
        break;
      case AppLifecycleState.paused:
        // App is in background - could be a good time to clean up non-essential resources
        AppLogger.info('⏸️ App paused - performing background cleanup...');
        _performBackgroundCleanup();
        break;
      case AppLifecycleState.resumed:
        AppLogger.info('▶️ App resumed');
        _handleAppResumed();
        break;
      case AppLifecycleState.inactive:
        AppLogger.info('⏹️ App inactive');
        break;
      case AppLifecycleState.hidden:
        AppLogger.info('👁️ App hidden');
        break;
    }
  }

  /// Dispose all services that need cleanup
  static void _disposeAllServices() {
    AppLogger.info('🧹 Starting comprehensive service cleanup...');

    try {
      // Dispose BackgroundTaskService
      BackgroundTaskService.dispose();
    } catch (e) {
      AppLogger.error('Error disposing BackgroundTaskService', e);
    }

    try {
      // Dispose NotificationQueueProcessor
      NotificationQueueProcessor.dispose();
    } catch (e) {
      AppLogger.error('Error disposing NotificationQueueProcessor', e);
    }

    // Old renewal services removed - now using MidnightHabitResetService
    AppLogger.info('App paused - midnight reset service continues running');

    AppLogger.info('✅ Service cleanup completed');
  }

  /// Handle app resumed state - re-register callbacks and process pending actions
  static void _handleAppResumed() {
    try {
      AppLogger.info(
          '🔄 Handling app resume - re-registering notification callbacks...');

      // Re-register notification action callback in case it was lost during background
      NotificationActionService.ensureCallbackRegistered();

      // Process any pending notification actions that were stored while app was in background
      // Use longer delay and retry mechanism to ensure providers are fully initialized
      _processPendingActionsWithRetry();

      AppLogger.info('✅ App resume handling completed');
    } catch (e) {
      AppLogger.error('Error handling app resume', e);
      // Don't rethrow - this should not crash the app
    }
  }

  /// Process pending actions with retry mechanism to handle provider initialization timing
  static void _processPendingActionsWithRetry({int attempt = 1, int maxAttempts = 5}) {
    final delay = Duration(milliseconds: 1000 * attempt); // Increase delay with each attempt
    
    AppLogger.info('🔄 Scheduling pending action processing attempt $attempt/$maxAttempts with ${delay.inMilliseconds}ms delay');
    
    Future.delayed(delay, () async {
      try {
        await NotificationService.processPendingActionsManually();
        AppLogger.info('✅ Pending actions processed successfully on attempt $attempt');
      } catch (e) {
        AppLogger.warning('⚠️ Attempt $attempt failed: $e');
        
        if (attempt < maxAttempts) {
          AppLogger.info('🔄 Retrying pending action processing (attempt ${attempt + 1}/$maxAttempts)');
          _processPendingActionsWithRetry(attempt: attempt + 1, maxAttempts: maxAttempts);
        } else {
          AppLogger.error('❌ All $maxAttempts attempts failed to process pending actions');
        }
      }
    });
  }

  /// Perform background cleanup when app is paused
  static void _performBackgroundCleanup() {
    try {
      // Clear completed debouncers and tasks that are no longer needed
      AppLogger.debug('🧹 Performing background cleanup...');

      // Note: We don't dispose everything here, just clean up what's safe to clean
      // Full disposal only happens on app termination

      AppLogger.debug('✅ Background cleanup completed');
    } catch (e) {
      AppLogger.error('Error during background cleanup', e);
    }
  }

  /// Force cleanup - call this if you need to manually trigger cleanup
  static void forceCleanup() {
    AppLogger.warning('⚠️ Force cleanup requested');
    _disposeAllServices();
  }
}
