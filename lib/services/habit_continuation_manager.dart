import 'dart:io';
import 'work_manager_habit_service.dart';
import 'logging_service.dart' as logging;

/// Manager class that selects the appropriate habit continuation service
/// based on the platform (WorkManager for Android, different approach for iOS)
class HabitContinuationManager {
  static bool _isInitialized = false;

  /// Initialize the appropriate habit continuation service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      logging.AppLogger.info('🔄 Initializing Habit Continuation Manager');

      if (Platform.isAndroid) {
        // Use WorkManager for Android
        await WorkManagerHabitService.initialize();
        logging.AppLogger.info(
            '✅ Using WorkManager for Android habit continuation');
      } else if (Platform.isIOS) {
        // iOS implementation would go here
        // For now, we'll just log that iOS is not fully supported
        logging.AppLogger.info(
            '⚠️ iOS habit continuation not fully implemented');
      } else {
        logging.AppLogger.warning(
            '⚠️ Habit continuation not supported on this platform');
      }

      _isInitialized = true;
      logging.AppLogger.info(
          '✅ Habit Continuation Manager initialized successfully');
    } catch (e) {
      logging.AppLogger.error(
          '❌ Failed to initialize Habit Continuation Manager', e);
    }
  }

  /// Force renewal of all habits
  static Future<void> forceRenewal({String? specificHabitId}) async {
    try {
      logging.AppLogger.info(
          '🔄 Force renewal requested via manager${specificHabitId != null ? ' for habit ID: ' : ''}');

      if (Platform.isAndroid) {
        await WorkManagerHabitService.forceRenewal(
            specificHabitId: specificHabitId);
      } else if (Platform.isIOS) {
        // iOS implementation would go here - for now just log
        logging.AppLogger.info('⚠️ Force renewal not fully implemented on iOS');
      } else {
        logging.AppLogger.warning(
            '⚠️ Force renewal not supported on this platform');
      }
    } catch (e) {
      logging.AppLogger.error('❌ Error during force renewal', e);
    }
  }

  /// Set custom renewal interval
  static Future<void> setRenewalInterval(int hours) async {
    try {
      if (Platform.isAndroid) {
        await WorkManagerHabitService.setRenewalInterval(hours);
      } else if (Platform.isIOS) {
        // iOS implementation would go here - for now just log
        logging.AppLogger.info(
            '⚠️ Setting renewal interval not fully implemented on iOS');
      } else {
        logging.AppLogger.warning(
            '⚠️ Setting renewal interval not supported on this platform');
      }
    } catch (e) {
      logging.AppLogger.error('❌ Error setting renewal interval', e);
    }
  }

  /// Get renewal status information
  static Future<Map<String, dynamic>> getRenewalStatus() async {
    try {
      if (Platform.isAndroid) {
        // For Android, we'll use the WorkManagerHabitService status
        return {
          'isActive': _isInitialized,
          'platform': 'Android',
          'implementation': 'WorkManager',
          // Add more status information as needed
        };
      } else if (Platform.isIOS) {
        // iOS implementation would go here - for now return basic status
        return {
          'isActive': false,
          'platform': 'iOS',
          'implementation': 'Not implemented',
          'message': 'iOS habit continuation not fully implemented',
        };
      } else {
        return {
          'isActive': false,
          'platform': 'Unsupported',
          'error': 'Habit continuation not supported on this platform',
        };
      }
    } catch (e) {
      logging.AppLogger.error('Error getting renewal status', e);
      return {
        'isActive': false,
        'error': e.toString(),
      };
    }
  }

  /// Stop the continuation service
  static Future<void> stop() async {
    try {
      if (Platform.isAndroid) {
        await WorkManagerHabitService.stop();
      } else if (Platform.isIOS) {
        // iOS implementation would go here - for now just log
        logging.AppLogger.info(
            '⚠️ Stopping continuation service not fully implemented on iOS');
      }

      _isInitialized = false;
    } catch (e) {
      logging.AppLogger.error('❌ Error stopping continuation service', e);
    }
  }

  /// Restart the continuation service
  static Future<void> restart() async {
    await stop();
    await initialize();
  }
}
