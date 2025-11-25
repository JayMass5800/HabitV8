import 'dart:io';
import 'package:flutter/services.dart';
import 'logging_service.dart';

/// Service for accessing platform-specific product ID configuration
/// Supports both Android (via Method Channel) and iOS (via bundled config)
class ProductIdService {
  static const String _defaultProductId = 'premium_lifetime_access';

  // iOS product ID configuration
  // These should match the product IDs configured in App Store Connect
  static const Map<String, String> _iosProductIds = {
    'product_premium_lifetime_access': 'premium_lifetime_access',
  };

  /// Get product ID for the given key
  /// Uses Android resources on Android, bundled config on iOS
  static Future<String> getProductId(String productKey) async {
    try {
      if (Platform.isAndroid) {
        return await _getAndroidProductId(productKey);
      } else if (Platform.isIOS) {
        return _getIosProductId(productKey);
      } else {
        // Fallback for other platforms
        return _getFallbackProductId(productKey);
      }
    } catch (e) {
      AppLogger.warning('Failed to get product ID for $productKey: $e');
      return _getFallbackProductId(productKey);
    }
  }

  /// Get product ID from Android string resources
  static Future<String> _getAndroidProductId(String productKey) async {
    try {
      const channel = MethodChannel('habitv8/android_resources');
      final String? productId =
          await channel.invokeMethod('getStringResource', {
        'resourceName': productKey,
      });
      return productId ?? _getFallbackProductId(productKey);
    } catch (e) {
      AppLogger.warning('Failed to get Android product ID: $e');
      return _getFallbackProductId(productKey);
    }
  }

  /// Get product ID from iOS configuration
  static String _getIosProductId(String productKey) {
    return _iosProductIds[productKey] ?? _getFallbackProductId(productKey);
  }

  /// Get fallback product ID
  static String _getFallbackProductId(String productKey) {
    switch (productKey) {
      case 'product_premium_lifetime_access':
        return _defaultProductId;
      default:
        return productKey;
    }
  }

  /// Get all product IDs for the current platform
  static Future<Set<String>> getAllProductIds() async {
    try {
      final premiumId = await getProductId('product_premium_lifetime_access');
      return {premiumId};
    } catch (e) {
      AppLogger.warning('Failed to get all product IDs: $e');
      return {_defaultProductId};
    }
  }
}
