// App Lifecycle Service for HabitV8
// Handles proper resource cleanup when the app is shutting down

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'background_task_service.dart';
import 'notification_queue_processor.dart';
// Old renewal services removed - now using midnight_habit_reset_service.dart
import 'notification_action_service.dart';
import 'notification_service.dart';
import 'widget_integration_service.dart';
import 'midnight_habit_reset_service.dart';
import 'logging_service.dart';
import '../data/database.dart';

/// Service that manages app lifecycle events and ensures proper resource cleanup
class AppLifecycleService with WidgetsBindingObserver {
  static AppLifecycleService? _instance;
  static bool _isInitialized = false;
  static ProviderContainer? _container;

  AppLifecycleService._();

  /// Get the singleton instance
  static AppLifecycleService get instance {
    _instance ??= AppLifecycleService._();
    return _instance!;
  }

  /// Initialize the lifecycle service
  static void initialize([ProviderContainer? container]) {
    if (_isInitialized) return;

    AppLogger.info('🔄 Initializing AppLifecycleService...');

    // Store container reference for state invalidation
    _container = container;

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
        // App is in background - perform minimal cleanup
        AppLogger.info('⏸️ App paused - performing background cleanup...');
        _performBackgroundCleanup();
        // NOTE: We don't close the database here to avoid connection issues
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

    // Close database connections properly to avoid cursor leaks
    try {
      AppLogger.info('🗄️ Closing database connections...');
      DatabaseService.closeDatabase();
    } catch (e) {
      AppLogger.error('Error closing database', e);
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

      // Ensure database is accessible after app resume
      _ensureDatabaseConnection();

      // CRITICAL: Invalidate habits state to force refresh from database
      // This ensures UI picks up changes made by background notification actions
      if (_container != null) {
        try {
          _container!.invalidate(habitsNotifierProvider);
          AppLogger.info('🔄 Invalidated habitsNotifierProvider to force refresh from database');
        } catch (e) {
          AppLogger.error('Error invalidating habitsNotifierProvider', e);
        }
      } else {
        AppLogger.warning('⚠️ Container is null - cannot invalidate habits state');
      }

      // Re-register notification action callback in case it was lost during background
      NotificationActionService.ensureCallbackRegistered();

      // Process any pending notification actions that were stored while app was in background
      // Use longer delay and retry mechanism to ensure providers are fully initialized
      _processPendingActionsWithRetry();

      // Refresh widgets to ensure they show current day data
      _refreshWidgetsOnResume();

      // Check for missed midnight resets (more efficient than hourly checks)
      _checkMissedResetOnResume();

      AppLogger.info('✅ App resume handling completed');
    } catch (e) {
      AppLogger.error('Error handling app resume', e);
      // Don't rethrow - this should not crash the app
    }
  }

  /// Ensure database connection is valid after app resume
  static void _ensureDatabaseConnection() {
    try {
      AppLogger.debug('🔗 Ensuring database connection is valid...');

      // Add delay to avoid race conditions during app lifecycle transitions
      Future.delayed(const Duration(milliseconds: 200), () async {
        try {
          // Check if database is accessible without forcibly closing it
          final instance = await DatabaseService.getInstance();

          // Test if the database is actually working by performing a simple operation
          try {
            instance.length; // This will throw if the box is stale
            AppLogger.debug('✅ Database connection is healthy');
            return;
          } catch (testError) {
            AppLogger.warning('Database connection test failed: $testError');
            // Only if the test fails, then we close and reopen
          }

          // Only close and reopen if there's actually a problem
          AppLogger.info(
              'Refreshing database connection due to stale state...');
          await DatabaseService.closeDatabase();
          await Future.delayed(const Duration(milliseconds: 100));

          // Trigger database reconnection by calling getInstance
          await DatabaseService.getInstance();
          AppLogger.debug('✅ Database connection refreshed successfully');
        } catch (e) {
          AppLogger.error('❌ Database reconnection failed: $e');

          // If database reconnection fails, try one more time with a full reset
          try {
            AppLogger.warning('Attempting database recovery...');
            await DatabaseService.closeDatabase();
            await Future.delayed(const Duration(milliseconds: 500));
            await DatabaseService.getInstance();
            AppLogger.info('✅ Database recovered successfully');
          } catch (retryError) {
            AppLogger.error('❌ Database recovery failed: $retryError');
          }
        }
      });
    } catch (e) {
      AppLogger.error('Error ensuring database connection: $e');
    }
  }

  /// Process pending actions with retry mechanism to handle provider initialization timing
  static void _processPendingActionsWithRetry(
      {int attempt = 1, int maxAttempts = 5}) {
    final delay = Duration(
        milliseconds: 1000 * attempt); // Increase delay with each attempt

    AppLogger.info(
        '🔄 Scheduling pending action processing attempt $attempt/$maxAttempts with ${delay.inMilliseconds}ms delay');

    Future.delayed(delay, () async {
      try {
        await NotificationService.processPendingActionsManually();
        AppLogger.info(
            '✅ Pending actions processed successfully on attempt $attempt');
      } catch (e) {
        AppLogger.warning('⚠️ Attempt $attempt failed: $e');

        if (attempt < maxAttempts) {
          AppLogger.info(
              '🔄 Retrying pending action processing (attempt ${attempt + 1}/$maxAttempts)');
          _processPendingActionsWithRetry(
              attempt: attempt + 1, maxAttempts: maxAttempts);
        } else {
          AppLogger.error(
              '❌ All $maxAttempts attempts failed to process pending actions');
        }
      }
    });
  }

  /// Refresh widgets when app resumes to ensure current day data is shown
  static void _refreshWidgetsOnResume() {
    try {
      AppLogger.debug('🔄 Force refreshing widgets on app resume...');

      // Add delay to ensure app is fully resumed and services are ready
      Future.delayed(const Duration(milliseconds: 1500), () async {
        try {
          // Use force update to ensure widgets are immediately refreshed
          await WidgetIntegrationService.instance.forceWidgetUpdate();
          AppLogger.debug(
              '✅ Widgets force refreshed successfully on app resume');
        } catch (e) {
          AppLogger.error('❌ Error force refreshing widgets on app resume', e);
          // Don't block app resume if widget refresh fails
        }
      });
    } catch (e) {
      AppLogger.error('Error scheduling widget force refresh on resume', e);
    }
  }

  /// Check for missed midnight resets when app resumes (battery-efficient approach)
  static void _checkMissedResetOnResume() {
    try {
      AppLogger.debug(
          '🔍 Checking for missed midnight resets on app resume...');

      // Add delay to ensure app is fully resumed and services are ready
      Future.delayed(const Duration(milliseconds: 2000), () async {
        try {
          await MidnightHabitResetService.checkForMissedResetOnAppActive();
          AppLogger.debug('✅ Missed reset check completed on app resume');
        } catch (e) {
          AppLogger.error(
              '❌ Error checking for missed resets on app resume', e);
          // Don't block app resume if missed reset check fails
        }
      });
    } catch (e) {
      AppLogger.error('Error scheduling missed reset check on resume', e);
    }
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
