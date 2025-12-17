import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'logging_service.dart';
import 'preferences_service.dart';

/// Subscription status enum
enum SubscriptionStatus {
  trial, // Within 30-day trial period
  trialExpired, // Trial expired, needs to purchase
  premium, // Has active subscription
  cancelled // Subscription cancelled/revoked
}

/// Service to manage subscription status, trial period, and premium feature access
class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  // Keys for secure storage (encrypted)
  static const String _trialStartDateKey = 'secure_trial_start_date';
  static const String _purchaseTokenKey = 'purchase_token';
  static const String _purchaseStatusKey = 'purchase_status';
  static const String _lastRevalidationKey = 'last_purchase_revalidation';

  // Keys for preferences (non-sensitive)
  static const String _subscriptionStatusKey = 'subscription_status';
  static const String _lastTrialCheckKey = 'last_trial_check';
  static const String _userNotifiedKey = 'user_notified_trial_expiry';
  static const String _userNotified7DaysKey = 'user_notified_trial_7_days';

  // Trial period: 30 days
  static const int _trialDurationDays = 30;

  // Revalidation interval: 7 days (check if purchase is still valid)
  static const int _revalidationIntervalDays = 7;

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Initialization state to prevent race conditions
  static Completer<void>? _initializationCompleter;
  static bool _isInitialized = false;

  /// Initialize the subscription service and start trial if first time user
  Future<void> initialize() async {
    // If already initialized or in progress, wait for completion
    if (_isInitialized) return;
    if (_initializationCompleter != null) {
      return _initializationCompleter!.future;
    }

    _initializationCompleter = Completer<void>();

    try {
      // Migrate trial date from SharedPreferences to secure storage if needed
      await _migrateTrialDateToSecureStorage();

      await _checkAndStartTrial();
      await _updateSubscriptionStatus();

      // Check if we need to revalidate the purchase
      await _checkAndRevalidatePurchase();

      _isInitialized = true;
      _initializationCompleter!.complete();
      AppLogger.info('SubscriptionService initialized successfully');
    } catch (e) {
      AppLogger.error('Error initializing subscription service', e);
      _initializationCompleter!.completeError(e);
      _initializationCompleter = null;
    }
  }

  /// Migrate trial start date from SharedPreferences to FlutterSecureStorage
  Future<void> _migrateTrialDateToSecureStorage() async {
    try {
      // Check if already migrated
      final existingSecure = await _secureStorage.read(key: _trialStartDateKey);
      if (existingSecure != null) return;

      // Check old location (SharedPreferences)
      final oldKey = 'trial_start_date';
      final oldValue = await PreferencesService.getString(oldKey);

      if (oldValue != null) {
        // Migrate to secure storage
        await _secureStorage.write(key: _trialStartDateKey, value: oldValue);
        // Remove from old location
        await PreferencesService.remove(oldKey);
        AppLogger.info('✅ Migrated trial start date to secure storage');
      }
    } catch (e) {
      AppLogger.warning('Trial date migration error (non-critical): $e');
    }
  }

  /// Check if purchase needs revalidation and trigger if necessary
  Future<void> _checkAndRevalidatePurchase() async {
    try {
      final hasPurchase = await _hasPremiumSubscription();
      if (!hasPurchase) return;

      final lastRevalidation =
          await _secureStorage.read(key: _lastRevalidationKey);
      final now = DateTime.now();

      if (lastRevalidation != null) {
        final lastDate = DateTime.parse(lastRevalidation);
        final daysSince = now.difference(lastDate).inDays;

        if (daysSince < _revalidationIntervalDays) {
          AppLogger.info(
              '📅 Purchase revalidation not needed yet ($daysSince days since last check)');
          return;
        }
      }

      AppLogger.info('🔄 Triggering purchase revalidation...');
      await revalidatePurchase();
    } catch (e) {
      AppLogger.warning('Purchase revalidation check failed: $e');
    }
  }

  /// Wait for initialization to complete (prevents race conditions)
  /// Returns early if initialization takes too long to prevent UI blocking
  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;

    try {
      if (_initializationCompleter != null) {
        // Wait for initialization with timeout to prevent deadlock
        await _initializationCompleter!.future
            .timeout(const Duration(seconds: 5));
      } else {
        // Start initialization if not already started
        await initialize().timeout(const Duration(seconds: 5));
      }
    } on TimeoutException catch (e) {
      // Timeout - force complete to prevent permanent blocking
      AppLogger.warning('Initialization timeout, forcing completion: $e');
      _isInitialized = true;
      if (_initializationCompleter != null &&
          !_initializationCompleter!.isCompleted) {
        _initializationCompleter!.complete();
      }
    } catch (e) {
      // Other error - mark as initialized to prevent blocking
      AppLogger.error('Initialization error, continuing: $e');
      _isInitialized = true;
      if (_initializationCompleter != null &&
          !_initializationCompleter!.isCompleted) {
        _initializationCompleter!.completeError(e);
      }
    }
  }

  /// Check if this is the first app launch and start trial period
  Future<void> _checkAndStartTrial() async {
    final trialStartDate = await _secureStorage.read(key: _trialStartDateKey);

    if (trialStartDate == null) {
      // First time user - start trial
      final now = DateTime.now();
      final nowString = now.toIso8601String();
      await _secureStorage.write(key: _trialStartDateKey, value: nowString);
      AppLogger.info('🎉 Trial period started for new user at: $now');
      AppLogger.info(
          '🎉 Trial will expire after $_trialDurationDays days on: ${now.add(Duration(days: _trialDurationDays))}');
    } else {
      // Existing user - log current trial status
      final startDate = DateTime.parse(trialStartDate);
      final daysSince = DateTime.now().difference(startDate).inDays;
      AppLogger.info(
          '📅 Existing user - Trial started: $startDate, Days since: $daysSince');
    }
  }

  /// Get current subscription status
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    // Try to ensure initialization, but don't block UI
    // This prevents deadlock during app startup
    if (!_isInitialized) {
      unawaited(_ensureInitialized());
    }

    // Check if purchase was cancelled/revoked
    final purchaseStatus = await _secureStorage.read(key: _purchaseStatusKey);
    if (purchaseStatus == 'cancelled') {
      return SubscriptionStatus.cancelled;
    }

    // Check if user has purchased premium
    final hasPremium = await _hasPremiumSubscription();
    if (hasPremium) {
      return SubscriptionStatus.premium;
    }

    // Check trial status using secure storage
    final trialStartDateStr =
        await _secureStorage.read(key: _trialStartDateKey);
    if (trialStartDateStr == null) {
      // This shouldn't happen after initialization, but handle gracefully
      await _checkAndStartTrial();
      return SubscriptionStatus.trial;
    }

    final trialStartDate = DateTime.parse(trialStartDateStr);
    final now = DateTime.now();
    final daysSinceTrialStart = now.difference(trialStartDate).inDays;

    if (daysSinceTrialStart < _trialDurationDays) {
      return SubscriptionStatus.trial;
    } else {
      return SubscriptionStatus.trialExpired;
    }
  }

  /// Update internal subscription status cache
  Future<void> _updateSubscriptionStatus() async {
    final status = await getSubscriptionStatus();
    await PreferencesService.setString(
        _subscriptionStatusKey, status.toString());

    // Update last check timestamp
    await PreferencesService.setString(
        _lastTrialCheckKey, DateTime.now().toIso8601String());
  }

  /// Check if user has premium subscription (to be implemented with in-app purchases)
  Future<bool> _hasPremiumSubscription() async {
    try {
      // Check local storage for purchase receipt/token
      final purchaseToken = await _secureStorage.read(key: _purchaseTokenKey);
      if (purchaseToken != null && purchaseToken.isNotEmpty) {
        // Check if purchase has been cancelled/revoked
        final purchaseStatus =
            await _secureStorage.read(key: _purchaseStatusKey);
        if (purchaseStatus == 'cancelled') {
          AppLogger.info('Purchase exists but is cancelled/revoked');
          return false;
        }
        return true;
      }
      return false;
    } catch (e) {
      AppLogger.error('Error checking premium subscription', e);
      return false;
    }
  }

  /// Get remaining trial days
  Future<int> getRemainingTrialDays() async {
    final status = await getSubscriptionStatus();
    if (status == SubscriptionStatus.premium) {
      return -1; // Premium users don't have trial limitation
    }

    final trialStartDateStr =
        await _secureStorage.read(key: _trialStartDateKey);
    if (trialStartDateStr == null) return 0;

    final trialStartDate = DateTime.parse(trialStartDateStr);
    final now = DateTime.now();

    // Use hours-based calculation to prevent losing up to 24 hours due to time truncation
    final hoursSinceTrialStart = now.difference(trialStartDate).inHours;
    final daysSinceTrialStart = (hoursSinceTrialStart / 24).floor();

    final remainingDays = _trialDurationDays - daysSinceTrialStart;

    // Debug logging to track trial calculation
    AppLogger.info(
        '🔍 Trial Debug: Start Date=$trialStartDate, Now=$now, Hours=$hoursSinceTrialStart, Days=$daysSinceTrialStart, Remaining=$remainingDays');

    return remainingDays > 0 ? remainingDays : 0;
  }

  /// Check if a specific feature is available to the current user
  Future<bool> isFeatureAvailable(PremiumFeature feature) async {
    // Try to ensure initialization without blocking
    if (!_isInitialized) {
      unawaited(_ensureInitialized());
    }

    final status = await getSubscriptionStatus();

    // Premium users have access to all features
    if (status == SubscriptionStatus.premium) {
      return true;
    }

    // Trial expired users have no access to any features (entire app is locked)
    if (status == SubscriptionStatus.trialExpired) {
      return false;
    }

    // Trial users have access to all features during trial period
    if (status == SubscriptionStatus.trial) {
      switch (feature) {
        case PremiumFeature.aiInsights:
          return true; // Allow AI insights during trial
        case PremiumFeature.unlimitedHabits:
          return true; // Allow unlimited habits during trial for full immersion
        case PremiumFeature.advancedAnalytics:
          return true; // Allow advanced analytics during trial
        case PremiumFeature.dataExport:
          return true; // Allow data export during trial
        case PremiumFeature.customCategories:
          return true; // Allow custom categories during trial for full immersion
      }
    }

    return false;
  }

  /// Check if the entire app should be accessible (not locked)
  Future<bool> isAppAccessible() async {
    final status = await getSubscriptionStatus();
    return status != SubscriptionStatus.trialExpired;
  }

  /// Mark user as having premium access (called after successful one-time purchase)
  Future<void> activatePremiumSubscription(String purchaseToken) async {
    try {
      await _secureStorage.write(key: _purchaseTokenKey, value: purchaseToken);
      await _secureStorage.write(key: _purchaseStatusKey, value: 'active');
      await _secureStorage.write(
          key: _lastRevalidationKey, value: DateTime.now().toIso8601String());
      await _updateSubscriptionStatus();
      AppLogger.info('✅ Premium access activated');
    } catch (e) {
      AppLogger.error('Error activating premium access', e);
      throw Exception('Failed to activate premium access');
    }
  }

  /// Get existing purchase token (for duplicate purchase detection)
  Future<String?> getExistingPurchaseToken() async {
    try {
      return await _secureStorage.read(key: _purchaseTokenKey);
    } catch (e) {
      AppLogger.error('Error reading purchase token', e);
      return null;
    }
  }

  /// Revalidate existing purchase by restoring from store
  /// This verifies the purchase is still valid (not refunded/cancelled)
  Future<bool> revalidatePurchase() async {
    try {
      AppLogger.info('🔄 Revalidating purchase with store...');

      // Check if in-app purchases are available
      final isAvailable = await InAppPurchase.instance.isAvailable();
      if (!isAvailable) {
        AppLogger.warning('In-app purchases not available for revalidation');
        return true; // Don't revoke if we can't check
      }

      // Clear the revalidation flag to force a check
      // The PurchaseStreamService will handle the response
      // and call activatePremiumSubscription if valid

      // Restore purchases - the stream listener will process results
      await InAppPurchase.instance.restorePurchases();

      // Update last revalidation time
      await _secureStorage.write(
          key: _lastRevalidationKey, value: DateTime.now().toIso8601String());

      AppLogger.info('✅ Purchase revalidation completed');
      return true;
    } catch (e) {
      AppLogger.error('Purchase revalidation failed', e);
      return false;
    }
  }

  /// Mark purchase as cancelled/revoked
  /// Called when purchase verification fails or purchase is refunded
  Future<void> markPurchaseCancelled() async {
    try {
      await _secureStorage.write(key: _purchaseStatusKey, value: 'cancelled');
      await _updateSubscriptionStatus();
      AppLogger.warning('⚠️ Purchase marked as cancelled/revoked');
    } catch (e) {
      AppLogger.error('Error marking purchase as cancelled', e);
    }
  }

  /// Reactivate a cancelled purchase (after successful revalidation)
  Future<void> reactivatePurchase() async {
    try {
      final purchaseToken = await _secureStorage.read(key: _purchaseTokenKey);
      if (purchaseToken != null && purchaseToken.isNotEmpty) {
        await _secureStorage.write(key: _purchaseStatusKey, value: 'active');
        await _updateSubscriptionStatus();
        AppLogger.info('✅ Purchase reactivated');
      }
    } catch (e) {
      AppLogger.error('Error reactivating purchase', e);
    }
  }

  /// Store audit data securely (for purchase verification trail)
  /// Now accepts `Map<String, dynamic>` for proper JSON storage
  Future<void> storeAuditData(String key, dynamic value) async {
    try {
      String jsonValue;
      if (value is Map) {
        jsonValue = jsonEncode(value);
      } else if (value is String) {
        // Legacy support - convert comma-separated to JSON if needed
        if (value.contains(':') && !value.startsWith('{')) {
          // Convert legacy format "key1:value1,key2:value2" to JSON
          final pairs = value.split(',');
          final map = <String, String>{};
          for (final pair in pairs) {
            final parts = pair.split(':');
            if (parts.length >= 2) {
              map[parts[0].trim()] = parts.sublist(1).join(':').trim();
            }
          }
          jsonValue = jsonEncode(map);
        } else {
          jsonValue = value;
        }
      } else {
        jsonValue = jsonEncode(value);
      }
      await _secureStorage.write(key: key, value: jsonValue);
    } catch (e) {
      AppLogger.error('Error storing audit data', e);
      // Don't throw error - audit storage failure shouldn't block purchases
    }
  }

  /// Read audit data (returns parsed JSON or null)
  Future<Map<String, dynamic>?> readAuditData(String key) async {
    try {
      final value = await _secureStorage.read(key: key);
      if (value == null) return null;
      return jsonDecode(value) as Map<String, dynamic>;
    } catch (e) {
      AppLogger.warning('Error reading audit data: $e');
      return null;
    }
  }

  /// Get security audit summary (for debugging and monitoring)
  Future<Map<String, dynamic>> getSecurityAuditSummary() async {
    try {
      final allKeys = await _secureStorage.readAll();
      final auditKeys = allKeys.keys
          .where((key) => key.startsWith('purchase_audit_'))
          .toList();

      return {
        'totalAuditEntries': auditKeys.length,
        'latestAuditTimestamp': auditKeys.isNotEmpty
            ? auditKeys
                .map((key) => key.split('_').last)
                .reduce((a, b) => int.parse(a) > int.parse(b) ? a : b)
            : null,
        'hasPurchaseToken': await getExistingPurchaseToken() != null,
        'auditStorageHealthy': true,
      };
    } catch (e) {
      AppLogger.error('Error generating audit summary', e);
      return {
        'totalAuditEntries': 0,
        'latestAuditTimestamp': null,
        'hasPurchaseToken': false,
        'auditStorageHealthy': false,
        'error': e.toString(),
      };
    }
  }

  /// Restore purchases (for users who already purchased on another device)
  Future<bool> restorePurchases() async {
    try {
      AppLogger.info('🔄 Attempting to restore purchases...');

      // Check if we already have a purchase token stored
      final existingToken = await getExistingPurchaseToken();
      if (existingToken != null && existingToken.isNotEmpty) {
        AppLogger.info('✅ Purchase already restored (existing token found)');
        return true;
      }

      // This will be called by the automatic restoration in main.dart
      // The actual restore logic is handled by the InAppPurchase.instance.restorePurchases()
      // When purchases are found, activatePremiumSubscription will be called
      AppLogger.info(
          '🔍 Purchase restoration initiated - waiting for platform response');
      return true;
    } catch (e) {
      AppLogger.error('Error restoring purchases', e);
      return false;
    }
  }

  /// Check if user should be shown trial expiry warning
  /// Returns the warning type: 'urgent' (≤3 days), 'early' (≤7 days), or null
  Future<String?> shouldShowTrialExpiryWarning() async {
    final remainingDays = await getRemainingTrialDays();
    final status = await getSubscriptionStatus();

    if (status != SubscriptionStatus.trial) return null;
    if (remainingDays <= 0) return null;

    final today = DateTime.now().toIso8601String().substring(0, 10);

    // Show urgent warning when 3 days or less remaining
    if (remainingDays <= 3) {
      final lastNotified = await PreferencesService.getString(_userNotifiedKey);
      // Only show once per day
      if (lastNotified != today) {
        await PreferencesService.setString(_userNotifiedKey, today);
        return 'urgent';
      }
    }
    // Show early warning when 7 days or less remaining
    else if (remainingDays <= 7) {
      final lastNotified7Days =
          await PreferencesService.getString(_userNotified7DaysKey);
      // Only show once per day
      if (lastNotified7Days != today) {
        await PreferencesService.setString(_userNotified7DaysKey, today);
        return 'early';
      }
    }

    return null;
  }

  // NOTE: shouldShowTrialExpiryWarningLegacy removed - use shouldShowTrialExpiryWarning() instead

  /// Get trial start date
  Future<DateTime?> getTrialStartDate() async {
    final trialStartDateStr =
        await _secureStorage.read(key: _trialStartDateKey);
    if (trialStartDateStr != null) {
      return DateTime.parse(trialStartDateStr);
    }
    return null;
  }

  /// For debugging: Reset trial period
  Future<void> resetTrialPeriod() async {
    if (!kDebugMode) {
      AppLogger.warning('resetTrialPeriod called in release mode - ignoring');
      return;
    }

    await _secureStorage.delete(key: _trialStartDateKey);
    await _secureStorage.delete(key: _purchaseTokenKey);
    await _secureStorage.delete(key: _purchaseStatusKey);
    await _secureStorage.delete(key: _lastRevalidationKey);
    await PreferencesService.remove(_subscriptionStatusKey);
    await PreferencesService.remove(_lastTrialCheckKey);
    await PreferencesService.remove(_userNotifiedKey);
    await PreferencesService.remove(_userNotified7DaysKey);
    // Also clear old location for migration cleanup
    await PreferencesService.remove('trial_start_date');
    AppLogger.info('🔄 Trial period reset for debugging');
  }

  /// For debugging: Simulate trial expiry by setting start date to 31 days ago
  Future<void> simulateTrialExpiry() async {
    if (!kDebugMode) {
      AppLogger.warning(
          'simulateTrialExpiry called in release mode - ignoring');
      return;
    }

    final expiredStartDate =
        DateTime.now().subtract(Duration(days: _trialDurationDays + 1));
    await _secureStorage.write(
        key: _trialStartDateKey, value: expiredStartDate.toIso8601String());
    await _secureStorage.delete(key: _purchaseTokenKey);
    await _secureStorage.delete(key: _purchaseStatusKey);
    await PreferencesService.remove(_subscriptionStatusKey);
    await PreferencesService.remove(_lastTrialCheckKey);
    await PreferencesService.remove(_userNotifiedKey);
    AppLogger.info(
        '🔄 Trial expiry simulated for debugging - start date set to: $expiredStartDate');
  }

  /// For debugging: Simulate premium purchase
  Future<void> simulatePremiumPurchase() async {
    if (!kDebugMode) {
      AppLogger.warning(
          'simulatePremiumPurchase called in release mode - ignoring');
      return;
    }

    final debugToken =
        'debug_premium_token_${DateTime.now().millisecondsSinceEpoch}';
    await activatePremiumSubscription(debugToken);
    AppLogger.info(
        '🔄 Premium purchase simulated for debugging with token: $debugToken');
  }

  /// For debugging: Get detailed trial information
  Future<Map<String, dynamic>> getTrialDebugInfo() async {
    if (!kDebugMode) {
      AppLogger.warning(
          'getTrialDebugInfo called in release mode - returning empty data');
      return {
        'trialStarted': false,
        'message': 'Debug info not available in release mode',
      };
    }

    final trialStartDateStr =
        await _secureStorage.read(key: _trialStartDateKey);
    final now = DateTime.now();

    if (trialStartDateStr == null) {
      return {
        'trialStarted': false,
        'message': 'Trial has not been initialized yet',
      };
    }

    final trialStartDate = DateTime.parse(trialStartDateStr);
    final daysSinceTrialStart = now.difference(trialStartDate).inDays;
    final remainingDays = _trialDurationDays - daysSinceTrialStart;
    final status = await getSubscriptionStatus();
    final purchaseStatus = await _secureStorage.read(key: _purchaseStatusKey);
    final lastRevalidation =
        await _secureStorage.read(key: _lastRevalidationKey);

    return {
      'trialStarted': true,
      'trialStartDate': trialStartDate.toIso8601String(),
      'currentDate': now.toIso8601String(),
      'daysSinceStart': daysSinceTrialStart,
      'trialDurationDays': _trialDurationDays,
      'remainingDays': remainingDays,
      'clampedRemainingDays': remainingDays > 0 ? remainingDays : 0,
      'subscriptionStatus': status.toString(),
      'purchaseStatus': purchaseStatus,
      'lastRevalidation': lastRevalidation,
      'isTrialActive': status == SubscriptionStatus.trial,
      'willExpireOn': trialStartDate
          .add(Duration(days: _trialDurationDays))
          .toIso8601String(),
    };
  }

  /// Get subscription status display text
  Future<String> getStatusDisplayText() async {
    final status = await getSubscriptionStatus();
    switch (status) {
      case SubscriptionStatus.trial:
        final remainingDays = await getRemainingTrialDays();
        return 'Free Trial ($remainingDays days remaining)';
      case SubscriptionStatus.trialExpired:
        return 'Trial Expired - Upgrade to Premium';
      case SubscriptionStatus.premium:
        return 'Premium Active';
      case SubscriptionStatus.cancelled:
        return 'Subscription Cancelled';
    }
  }
}

/// Enum for premium features
enum PremiumFeature {
  aiInsights,
  unlimitedHabits,
  advancedAnalytics,
  dataExport,
  customCategories,
}

/// Extension to get user-friendly feature names
extension PremiumFeatureExtension on PremiumFeature {
  String get displayName {
    switch (this) {
      case PremiumFeature.aiInsights:
        return 'AI-Powered Insights';
      case PremiumFeature.unlimitedHabits:
        return 'Unlimited Habits';
      case PremiumFeature.advancedAnalytics:
        return 'Advanced Analytics';
      case PremiumFeature.dataExport:
        return 'Data Export/Import';
      case PremiumFeature.customCategories:
        return 'Custom Categories';
    }
  }

  String get description {
    switch (this) {
      case PremiumFeature.aiInsights:
        return 'Get personalized insights and recommendations powered by AI';
      case PremiumFeature.unlimitedHabits:
        return 'Create and track unlimited habits without restrictions';
      case PremiumFeature.advancedAnalytics:
        return 'Detailed analytics, trends, and progress visualizations';
      case PremiumFeature.dataExport:
        return 'Export your data and import from other habit trackers';
      case PremiumFeature.customCategories:
        return 'Create and customize your own habit categories';
    }
  }
}
