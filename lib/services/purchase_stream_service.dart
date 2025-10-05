import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'subscription_service.dart';
import 'logging_service.dart';

/// Global service to handle purchase stream events
/// This ensures purchase restoration works even when PurchaseScreen is not open
class PurchaseStreamService {
  static final PurchaseStreamService _instance = PurchaseStreamService._internal();
  factory PurchaseStreamService() => _instance;
  PurchaseStreamService._internal();

  static bool _isInitialized = false;
  static StreamSubscription<List<PurchaseDetails>>? _subscription;
  static final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  /// Initialize the global purchase stream listener
  /// This MUST be called before any restorePurchases() calls
  static Future<void> initialize() async {
    if (_isInitialized) {
      AppLogger.info('PurchaseStreamService already initialized');
      return;
    }

    try {
      AppLogger.info('🛒 Initializing PurchaseStreamService...');

      // Check if in-app purchases are available
      final isAvailable = await _inAppPurchase.isAvailable();
      if (!isAvailable) {
        AppLogger.warning('In-app purchases not available - skipping stream initialization');
        return;
      }

      // Set up global purchase stream listener
      // This will catch purchase events even when PurchaseScreen is not open
      _subscription = _inAppPurchase.purchaseStream.listen(
        _onPurchaseUpdate,
        onDone: () {
          AppLogger.info('Purchase stream closed');
        },
        onError: (error) {
          AppLogger.error('Purchase stream error', error);
        },
      );

      _isInitialized = true;
      AppLogger.info('✅ PurchaseStreamService initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize PurchaseStreamService', e);
      rethrow;
    }
  }

  /// Handle purchase updates from the global stream
  static void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      AppLogger.info(
          '🔔 Global purchase update: ${purchaseDetails.status} for ${purchaseDetails.productID}');

      if (purchaseDetails.status == PurchaseStatus.pending) {
        AppLogger.info('Purchase pending - waiting for completion');
        // Don't grant entitlement yet - wait for PURCHASED state
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        AppLogger.error(
            'Purchase error in global handler: ${purchaseDetails.error?.message}',
            purchaseDetails.error);
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // Process completed purchases
        _processCompletedPurchase(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        AppLogger.info('Purchase was canceled by user');
      }

      // Complete the purchase to acknowledge it
      if (purchaseDetails.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  /// Process a completed purchase (purchased or restored)
  static Future<void> _processCompletedPurchase(
      PurchaseDetails purchaseDetails) async {
    try {
      AppLogger.info('Processing completed purchase: ${purchaseDetails.productID}');

      // Check if this is a valid premium purchase
      // Product ID should match our premium product
      if (!_isValidPremiumProduct(purchaseDetails.productID)) {
        AppLogger.warning(
            'Ignoring purchase for unknown product: ${purchaseDetails.productID}');
        return;
      }

      // Basic verification
      if (purchaseDetails.verificationData.serverVerificationData.isEmpty) {
        AppLogger.error('Purchase has no verification data - skipping');
        return;
      }

      // Check for duplicate purchase
      final existingToken = await SubscriptionService().getExistingPurchaseToken();
      final purchaseToken = purchaseDetails.purchaseID ??
          purchaseDetails.verificationData.serverVerificationData;

      if (existingToken != null && existingToken == purchaseToken) {
        AppLogger.info('Purchase already processed - skipping duplicate');
        return;
      }

      // Activate premium subscription
      await SubscriptionService().activatePremiumSubscription(purchaseToken);

      // Store audit data
      await _storeAuditData(purchaseDetails);

      AppLogger.info('✅ Premium access activated from global purchase handler');
    } catch (e) {
      AppLogger.error('Failed to process completed purchase', e);
    }
  }

  /// Check if product ID is a valid premium product
  static bool _isValidPremiumProduct(String productId) {
    // Accept both the primary product ID and any variations
    return productId.contains('premium') || 
           productId == 'premium_lifetime_access';
  }

  /// Store audit data for purchase
  static Future<void> _storeAuditData(PurchaseDetails purchaseDetails) async {
    try {
      final auditData = {
        'purchaseId': purchaseDetails.purchaseID ?? 'unknown',
        'productId': purchaseDetails.productID,
        'status': purchaseDetails.status.toString(),
        'timestamp': DateTime.now().toIso8601String(),
        'source': 'global_handler',
      };

      final auditJson = auditData.entries.map((e) => '${e.key}:${e.value}').join(',');
      await SubscriptionService().storeAuditData(
        'purchase_audit_global_${DateTime.now().millisecondsSinceEpoch}',
        auditJson,
      );
    } catch (e) {
      AppLogger.warning('Failed to store audit data: $e');
      // Don't fail the purchase for audit storage issues
    }
  }

  /// Dispose of the service (cleanup)
  static Future<void> dispose() async {
    if (_subscription != null) {
      await _subscription!.cancel();
      _subscription = null;
    }
    _isInitialized = false;
    AppLogger.info('PurchaseStreamService disposed');
  }
}
