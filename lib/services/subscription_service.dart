import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'logging_service.dart';

/// Subscription status enum
enum SubscriptionStatus {
  trial, // Within 30-day trial period
  trialExpired, // Trial expired, needs to purchase
  premium, // Has active subscription
  cancelled // Subscription cancelled but still in grace period
}

/// Service to manage subscription status, trial period, and premium feature access
class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  static const String _trialStartDateKey = 'trial_start_date';
  static const String _subscriptionStatusKey = 'subscription_status';
  static const String _lastTrialCheckKey = 'last_trial_check';
  static const String _userNotifiedKey = 'user_notified_trial_expiry';

  // Trial period: 30 days
  static const int _trialDurationDays = 30;
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
      await _checkAndStartTrial();
      await _updateSubscriptionStatus();
      _isInitialized = true;
      _initializationCompleter!.complete();
      AppLogger.info('SubscriptionService initialized successfully');
    } catch (e) {
      AppLogger.error('Error initializing subscription service', e);
      _initializationCompleter!.completeError(e);
      _initializationCompleter = null;
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
            .timeout(const Duration(seconds: 3));
      } else {
        // Start initialization if not already started
        // Don't wait - let it complete in background
        initialize();
      }
    } catch (e) {
      // Timeout or error - continue anyway to prevent UI blocking
      AppLogger.warning('Initialization timeout or error, continuing: $e');
    }
  }

  /// Check if this is the first app launch and start trial period
  Future<void> _checkAndStartTrial() async {
    final prefs = await SharedPreferences.getInstance();
    final trialStartDate = prefs.getString(_trialStartDateKey);

    if (trialStartDate == null) {
      // First time user - start trial
      final now = DateTime.now();
      final nowString = now.toIso8601String();
      await prefs.setString(_trialStartDateKey, nowString);
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
    // Ensure initialization is complete before checking status
    await _ensureInitialized();

    final prefs = await SharedPreferences.getInstance();

    // Check if user has purchased premium
    final hasPremium = await _hasPremiumSubscription();
    if (hasPremium) {
      return SubscriptionStatus.premium;
    }

    // Check trial status
    final trialStartDateStr = prefs.getString(_trialStartDateKey);
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_subscriptionStatusKey, status.toString());

    // Update last check timestamp
    await prefs.setString(_lastTrialCheckKey, DateTime.now().toIso8601String());
  }

  /// Check if user has premium subscription (to be implemented with in-app purchases)
  Future<bool> _hasPremiumSubscription() async {
    try {
      // Check local storage for purchase receipt/token
      final purchaseToken = await _secureStorage.read(key: 'purchase_token');
      if (purchaseToken != null && purchaseToken.isNotEmpty) {
        // Validate the purchase token (would normally verify with play store/app store)
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

    final prefs = await SharedPreferences.getInstance();
    final trialStartDateStr = prefs.getString(_trialStartDateKey);
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
      _ensureInitialized(); // Fire and forget if not initialized
    }

    final status =
        await getSubscriptionStatus(); // Premium users have access to all features
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
      await _secureStorage.write(key: 'purchase_token', value: purchaseToken);
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
      return await _secureStorage.read(key: 'purchase_token');
    } catch (e) {
      AppLogger.error('Error reading purchase token', e);
      return null;
    }
  }

  /// Store audit data securely (for purchase verification trail)
  Future<void> storeAuditData(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
    } catch (e) {
      AppLogger.error('Error storing audit data', e);
      // Don't throw error - audit storage failure shouldn't block purchases
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
  Future<bool> shouldShowTrialExpiryWarning() async {
    final remainingDays = await getRemainingTrialDays();
    final status = await getSubscriptionStatus();

    if (status != SubscriptionStatus.trial) return false;

    // Show warning when 3 days or less remaining
    if (remainingDays <= 3 && remainingDays > 0) {
      final prefs = await SharedPreferences.getInstance();
      final lastNotified = prefs.getString(_userNotifiedKey);
      final today = DateTime.now().toIso8601String().substring(0, 10);

      // Only show once per day
      if (lastNotified != today) {
        await prefs.setString(_userNotifiedKey, today);
        return true;
      }
    }

    return false;
  }

  /// Get trial start date
  Future<DateTime?> getTrialStartDate() async {
    final prefs = await SharedPreferences.getInstance();
    final trialStartDateStr = prefs.getString(_trialStartDateKey);
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

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_trialStartDateKey);
    await prefs.remove(_subscriptionStatusKey);
    await prefs.remove(_lastTrialCheckKey);
    await prefs.remove(_userNotifiedKey);
    await _secureStorage.delete(key: 'purchase_token');
    AppLogger.info('🔄 Trial period reset for debugging');
  }

  /// For debugging: Simulate trial expiry by setting start date to 31 days ago
  Future<void> simulateTrialExpiry() async {
    if (!kDebugMode) {
      AppLogger.warning(
          'simulateTrialExpiry called in release mode - ignoring');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final expiredStartDate =
        DateTime.now().subtract(Duration(days: _trialDurationDays + 1));
    await prefs.setString(
        _trialStartDateKey, expiredStartDate.toIso8601String());
    await prefs.remove(_subscriptionStatusKey);
    await prefs.remove(_lastTrialCheckKey);
    await prefs.remove(_userNotifiedKey);
    await _secureStorage.delete(key: 'purchase_token');
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

    final prefs = await SharedPreferences.getInstance();
    final trialStartDateStr = prefs.getString(_trialStartDateKey);
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

    return {
      'trialStarted': true,
      'trialStartDate': trialStartDate.toIso8601String(),
      'currentDate': now.toIso8601String(),
      'daysSinceStart': daysSinceTrialStart,
      'trialDurationDays': _trialDurationDays,
      'remainingDays': remainingDays,
      'clampedRemainingDays': remainingDays > 0 ? remainingDays : 0,
      'subscriptionStatus': status.toString(),
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
