import 'package:flutter/services.dart';

/// Service for accessing Android string resources and billing configuration
class AndroidResourceService {
  static const MethodChannel _channel =
      MethodChannel('habitv8/android_resources');

  /// Get product ID from Android string resources
  /// This ensures the product ID is declared in both Android resources and Dart code
  static Future<String> getProductId(String productKey) async {
    try {
      final String? productId =
          await _channel.invokeMethod('getStringResource', {
        'resourceName': productKey,
      });
      return productId ?? productKey; // Fallback to key if resource not found
    } catch (e) {
      // Fallback to hardcoded value if platform channel fails
      switch (productKey) {
        case 'product_premium_lifetime_access':
          return 'premium_lifetime_access';
        default:
          return productKey;
      }
    }
  }

  /// Get all billing-related string resources
  static Future<Map<String, String>> getBillingStrings() async {
    try {
      final Map<Object?, Object?>? result =
          await _channel.invokeMethod('getBillingStrings');
      return Map<String, String>.from(result ?? {});
    } catch (e) {
      // Return fallback strings
      return {
        'product_premium_lifetime_access': 'premium_lifetime_access',
        'product_premium_title': 'HabitV8 Premium - Lifetime Access',
        'product_premium_description':
            'One-time purchase for lifetime access to all premium features',
        'billing_unavailable':
            'In-app purchases are not available on this device',
        'product_not_found': 'Premium product not available in store',
        'purchase_failed': 'Purchase failed. Please try again.',
        'purchase_successful': 'Welcome to Premium! Your purchase is complete.',
        'restore_successful': 'Purchases restored successfully!',
        'no_purchases_found': 'No previous purchases found',
      };
    }
  }
}
