import 'dart:async';
import '../data/database_isar.dart';
import 'logging_service.dart';
import 'widget_integration_service.dart';

/// Notification Update Coordinator
///
/// This service listens to Isar's lazy watchers and coordinates updates
/// across all app components when habits change (especially from background
/// notification completions).
///
/// ENHANCEMENT 4: Ensures completing a habit from notification shade
/// automatically updates Timeline, All Habits, Stats, Widgets, and all screens.
class NotificationUpdateCoordinator {
  static NotificationUpdateCoordinator? _instance;
  static NotificationUpdateCoordinator get instance {
    _instance ??= NotificationUpdateCoordinator._();
    return _instance!;
  }

  NotificationUpdateCoordinator._();

  StreamSubscription<void>? _habitsWatchSubscription;
  bool _isInitialized = false;

  /// Initialize the update coordinator with lazy watchers
  /// This should be called once during app startup
  Future<void> initialize() async {
    if (_isInitialized) {
      AppLogger.info('📡 NotificationUpdateCoordinator already initialized');
      return;
    }

    try {
      AppLogger.info('📡 Initializing NotificationUpdateCoordinator...');

      // Get database service
      final isar = await IsarDatabaseService.getInstance();
      final habitService = HabitServiceIsar(isar);

      // Set up lazy watcher - this listens for ANY habit change
      // without transferring the actual data (efficient!)
      _habitsWatchSubscription = habitService.watchHabitsLazy().listen(
        (_) => _onHabitsChanged(),
        onError: (error) {
          AppLogger.error('Error in habits lazy watcher', error);
        },
      );

      _isInitialized = true;
      AppLogger.info(
          '✅ NotificationUpdateCoordinator initialized successfully');
      AppLogger.info(
          '📡 Now listening for habit changes (notifications, widgets, etc.)');
    } catch (e) {
      AppLogger.error('Failed to initialize NotificationUpdateCoordinator', e);
    }
  }

  /// Called whenever any habit changes (add, update, delete, complete)
  /// This is the central coordination point for all UI updates
  void _onHabitsChanged() {
    AppLogger.info('🔔 Habits changed detected by lazy watcher!');
    AppLogger.info(
        '📱 Triggering coordinated updates across all components...');

    // Widget updates are critical for home screen widgets
    _updateWidgets();

    // The Timeline, All Habits, Stats screens will update automatically
    // because they use habitsStreamIsarProvider which watches the database
    // This log helps with debugging to see the update flow
    AppLogger.info(
        '✅ All screens using habitsStreamIsarProvider will auto-update');
  }

  /// Update widgets when habits change
  Future<void> _updateWidgets() async {
    try {
      await WidgetIntegrationService.instance.onHabitsChanged();
      AppLogger.info('✅ Widgets updated successfully');
    } catch (e) {
      AppLogger.error('Failed to update widgets', e);
    }
  }

  /// Manually trigger updates (useful for testing or force refresh)
  Future<void> triggerManualUpdate() async {
    AppLogger.info('🔄 Manual update triggered');
    _onHabitsChanged();
  }

  /// Dispose of resources
  void dispose() {
    _habitsWatchSubscription?.cancel();
    _habitsWatchSubscription = null;
    _isInitialized = false;
    AppLogger.info('🔌 NotificationUpdateCoordinator disposed');
  }

  /// Check if coordinator is initialized
  bool get isInitialized => _isInitialized;
}
