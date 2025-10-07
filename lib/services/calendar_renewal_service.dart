import 'dart:async';
import 'logging_service.dart';

/// DEPRECATED: Service to handle automatic calendar sync renewal
/// This service is now redundant - calendar sync is handled by midnight reset service
/// and Isar listeners provide automatic updates
///
/// PERFORMANCE NOTE: This service used Timer.periodic polling which caused
/// unnecessary background activity and garbage collection.
///
/// Kept for backward compatibility but should not be initialized in new code.
@Deprecated('Use MidnightHabitResetService and Isar listeners instead')
class CalendarRenewalService {
  static Timer? _renewalTimer;
  static bool _isInitialized = false;

  /// Initialize the calendar renewal service
  /// DEPRECATED: This service is no longer needed
  @Deprecated('Use MidnightHabitResetService and Isar listeners instead')
  static Future<void> initialize() async {
    if (_isInitialized) return;

    AppLogger.warning(
        '⚠️ CalendarRenewalService.initialize() called but this service is deprecated');
    AppLogger.info(
        '🔄 Please use MidnightHabitResetService and Isar listeners instead');

    // Don't start the polling timer - let it remain unused
    _isInitialized = true;
  }

  /// Force a manual renewal (useful for testing or user-triggered renewal)
  /// DEPRECATED: Use CalendarService directly instead
  @Deprecated('Use CalendarService methods directly')
  static Future<void> forceRenewal() async {
    AppLogger.warning(
        '⚠️ CalendarRenewalService.forceRenewal() called but this service is deprecated');
    AppLogger.info('🔄 Please use CalendarService methods directly');
  }

  /// Stop the renewal service
  static void stop() {
    _renewalTimer?.cancel();
    _renewalTimer = null;
    _isInitialized = false;
    AppLogger.info('Calendar renewal service stopped');
  }

  /// Dispose all resources properly - call this when app is shutting down
  static void dispose() {
    AppLogger.info('🔄 Disposing CalendarRenewalService resources...');

    // Cancel the renewal timer if active
    if (_renewalTimer != null && _renewalTimer!.isActive) {
      _renewalTimer!.cancel();
    }
    _renewalTimer = null;

    // Reset state
    _isInitialized = false;

    AppLogger.info('✅ CalendarRenewalService disposed successfully');
  }

  /// Get renewal status information
  /// DEPRECATED: This information is no longer relevant
  @Deprecated('Service is deprecated')
  static Future<Map<String, dynamic>> getRenewalStatus() async {
    return {
      'isActive': false,
      'deprecated': true,
      'message': 'CalendarRenewalService is deprecated. Use MidnightHabitResetService instead.',
    };
  }
}
