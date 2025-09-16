import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'dart:async';
import '../../services/subscription_service.dart';
import '../../services/logging_service.dart';
import '../../services/android_resource_service.dart';

/// Screen for purchasing premium access (one-time purchase)
class PurchaseScreen extends ConsumerStatefulWidget {
  const PurchaseScreen({super.key});

  @override
  ConsumerState<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends ConsumerState<PurchaseScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // In-app purchase related state
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  String? _queryProductError;

  // Product IDs - loaded from Android string resources for Play Console detection
  // Note: Product IDs must start with a number or lowercase letter for Google Play
  // and can contain numbers (0-9), lowercase letters (a-z), underscores (_), and periods (.)
  String _kPremiumPurchaseId = 'premium_lifetime_access'; // Default fallback
  Set<String> _kProductIds = {'premium_lifetime_access'}; // Default fallback

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    // Initialize in-app purchases with product IDs from Android resources
    _initializeInAppPurchases();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Premium'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header section
              _buildHeader(context),

              const SizedBox(height: 32),

              // Trial status
              _buildTrialStatus(context),

              const SizedBox(height: 32),

              // Features list
              _buildFeaturesList(context),

              const SizedBox(height: 32),

              // Pricing options
              _buildPricingOptions(context),

              const SizedBox(height: 24),

              // Purchase button
              _buildPurchaseButton(context),

              const SizedBox(height: 16),

              // Restore purchases
              _buildRestoreButton(context),

              const SizedBox(height: 24),

              // Terms and privacy
              _buildLegalText(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.primary.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(
                Icons.star,
                size: 48,
                color: colorScheme.onPrimary,
              ),
              const SizedBox(height: 12),
              Text(
                'HabitV8 Premium',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'One-time purchase • Lifetime access',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimary.withValues(alpha: 0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrialStatus(BuildContext context) {
    return FutureBuilder<String>(
      future: SubscriptionService().getStatusDisplayText(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.schedule,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  snapshot.data!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeaturesList(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final features = [
      _FeatureItem(
        icon: Icons.psychology,
        title: 'AI-Powered Insights',
        description: 'Get personalized recommendations and habit analysis',
      ),
      _FeatureItem(
        icon: Icons.all_inclusive,
        title: 'Keep Unlimited Habits',
        description: 'Continue tracking unlimited habits beyond your trial',
      ),
      _FeatureItem(
        icon: Icons.analytics,
        title: 'Advanced Analytics',
        description: 'Detailed progress tracking and trend analysis',
      ),
      _FeatureItem(
        icon: Icons.cloud_sync,
        title: 'Cloud Sync',
        description: 'Sync your data across all your devices',
      ),
      _FeatureItem(
        icon: Icons.file_download,
        title: 'Data Export/Import',
        description: 'Backup and transfer your habit data',
      ),
      _FeatureItem(
        icon: Icons.support_agent,
        title: 'Priority Support',
        description: 'Get faster help when you need it',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Premium Features',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...features.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      feature.icon,
                      size: 20,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feature.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          feature.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildPricingOptions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Premium Upgrade',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Show error message if products couldn't be loaded
        if (_queryProductError != null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.error),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.error, color: colorScheme.error),
                    const SizedBox(width: 8),
                    Text(
                      'Store Configuration Issue',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _queryProductError!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onErrorContainer,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    setState(() {
                      _queryProductError = null;
                      _isLoading = true;
                    });
                    await _loadProducts();
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // One-time purchase option
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.primary,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'LIFETIME ACCESS',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Premium Features',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'One-time purchase • No recurring fees',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Keep all features forever after your trial',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Show dynamic pricing if products are loaded
                      if (_products.isNotEmpty)
                        Text(
                          _products.first.price,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        )
                      else if (_queryProductError == null)
                        Text(
                          'Loading...',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary.withValues(alpha: 0.6),
                          ),
                        )
                      else
                        Text(
                          '\$19.99',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary.withValues(alpha: 0.6),
                          ),
                        ),
                      Text(
                        'once',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPurchaseButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Show error message if there's an issue with products
        if (_queryProductError != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: colorScheme.onErrorContainer,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _queryProductError!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        // Show loading state for purchase pending
        if (_purchasePending) ...[
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation(colorScheme.onPrimaryContainer),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Processing your purchase...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],

        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: (_isLoading ||
                    _purchasePending ||
                    !_isAvailable ||
                    _queryProductError != null)
                ? null
                : _handlePurchase,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Text(
                    !_isAvailable
                        ? 'Purchases Not Available'
                        : _products.isEmpty
                            ? 'Loading Product...'
                            : 'Get Premium - ${_products.isNotEmpty ? _products.first.price : '\$19.99'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildRestoreButton(BuildContext context) {
    return TextButton(
      onPressed: _isLoading ? null : _handleRestore,
      child: Text(
        'Restore Previous Purchase',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  Widget _buildLegalText(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Text(
      'One-time purchase provides lifetime access to all premium features. No recurring charges. Purchase is final and non-refundable according to store policies.',
      style: theme.textTheme.bodySmall?.copyWith(
        color: colorScheme.onSurface.withValues(alpha: 0.6),
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Initialize in-app purchase system
  Future<void> _initializeInAppPurchases() async {
    try {
      // First, load product IDs from Android string resources
      // This ensures the product IDs are declared in Android resources for Play Console detection
      try {
        final productId = await AndroidResourceService.getProductId(
            'product_premium_lifetime_access');
        _kPremiumPurchaseId = productId;
        _kProductIds = {productId};
        AppLogger.info('Loaded product ID from Android resources: $productId');
      } catch (e) {
        AppLogger.warning(
            'Failed to load product ID from Android resources, using fallback: $e');
        // Fallback values are already set in the field declarations
      }

      // Initialize in-app purchase
      final bool isAvailable = await _inAppPurchase.isAvailable();
      setState(() {
        _isAvailable = isAvailable;
      });

      if (!isAvailable) {
        AppLogger.warning('In-app purchases not available');
        return;
      }

      // Listen to purchase updates
      _subscription = _inAppPurchase.purchaseStream.listen(
        _onPurchaseUpdate,
        onDone: () => _subscription.cancel(),
        onError: (error) => AppLogger.error('Purchase stream error', error),
      );

      // Load available products
      await _loadProducts();

      AppLogger.info('In-app purchase system initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize in-app purchases', e);
      setState(() {
        _queryProductError = 'Failed to initialize purchases: ${e.toString()}';
      });
    }
  }

  /// Load available products from the store
  Future<void> _loadProducts() async {
    try {
      final ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails(_kProductIds);

      if (response.notFoundIDs.isNotEmpty) {
        final notFoundProducts = response.notFoundIDs.join(', ');
        AppLogger.warning('Products not found in store: $notFoundProducts');

        // Provide specific guidance for Play Console setup
        final errorMessage =
            'Product "$notFoundProducts" not found in store.\n\n'
            'Play Console Setup Required:\n'
            '1. Go to Play Console → Your App → Monetize → Products → One-time products\n'
            '2. Create a product with ID: "$_kPremiumPurchaseId"\n'
            '3. Set title (max 55 chars): "HabitV8 Premium - Lifetime Access"\n'
            '4. Set description (max 200 chars): "One-time purchase for lifetime access to all premium features"\n'
            '5. Set pricing and activate the product\n'
            '6. Ensure app is published to Internal Testing track minimum\n'
            '7. Product ID is declared in Android string resources for detection';

        setState(() {
          _queryProductError = errorMessage;
        });
        return;
      }

      if (response.error != null) {
        setState(() {
          _queryProductError = 'Store error: ${response.error!.message}\n\n'
              'Common causes:\n'
              '• App not published to any testing track in Play Console\n'
              '• Product not activated in Play Console\n'
              '• Device not authorized for testing\n'
              '• Wrong product ID in code vs Play Console';
        });
        AppLogger.error('Error loading products', response.error);
        return;
      }

      setState(() {
        _products = response.productDetails;
        _queryProductError = null;
      });

      AppLogger.info('Loaded ${_products.length} products');
      for (final product in _products) {
        AppLogger.debug(
            'Product: ${product.id} - ${product.title} - ${product.price}');
      }
    } catch (e) {
      AppLogger.error('Failed to load products', e);
      setState(() {
        _queryProductError = 'Failed to load products: ${e.toString()}\n\n'
            'Check:\n'
            '• Internet connection\n'
            '• Google Play Store app is updated\n'
            '• App is signed with release key\n'
            '• Device supports Google Play Billing';
      });
    }
  }

  /// Handle purchase updates from the store
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      AppLogger.info(
          'Purchase update: ${purchaseDetails.status} for ${purchaseDetails.productID}');

      if (purchaseDetails.status == PurchaseStatus.pending) {
        setState(() {
          _purchasePending = true;
        });
      } else {
        setState(() {
          _purchasePending = false;
        });

        if (purchaseDetails.status == PurchaseStatus.error) {
          _handlePurchaseError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          _verifyAndFinalizePurchase(purchaseDetails);
        }
      }

      // Always complete the purchase
      if (purchaseDetails.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  /// Handle purchase errors
  void _handlePurchaseError(IAPError error) {
    AppLogger.error('Purchase error: ${error.code} - ${error.message}', error);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      String errorMessage = 'Purchase failed';
      switch (error.code) {
        case 'user_cancelled':
          errorMessage = 'Purchase was cancelled';
          break;
        case 'payment_invalid':
          errorMessage = 'Payment method is invalid';
          break;
        case 'product_not_available':
          errorMessage = 'Product is not available';
          break;
        default:
          errorMessage = 'Purchase failed: ${error.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  /// Verify and finalize a successful purchase
  Future<void> _verifyAndFinalizePurchase(
      PurchaseDetails purchaseDetails) async {
    try {
      AppLogger.info('Verifying purchase: ${purchaseDetails.productID}');

      // In a real app, you would verify the purchase with your backend server
      // For now, we'll just activate the premium access directly
      final purchaseToken = purchaseDetails.purchaseID ??
          purchaseDetails.verificationData.serverVerificationData;

      await SubscriptionService().activatePremiumSubscription(purchaseToken);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('🎉 Welcome to Premium!'),
            content: const Text(
                'Your one-time purchase is complete! You now have lifetime access to all premium features.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  context.pop(); // Go back to previous screen
                },
                child: const Text('Start Using Premium'),
              ),
            ],
          ),
        );
      }

      AppLogger.info('Premium access activated successfully');
    } catch (e) {
      AppLogger.error('Failed to verify purchase', e);
      _handlePurchaseError(IAPError(
        source: 'verification',
        code: 'verification_failed',
        message: 'Failed to verify purchase: ${e.toString()}',
        details: {},
      ));
    }
  }

  /// Start purchase for a specific product
  Future<void> _buyProduct(ProductDetails productDetails) async {
    setState(() {
      _isLoading = true;
    });

    try {
      AppLogger.info('Starting purchase for: ${productDetails.id}');

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: null, // You can set a user identifier here
      );

      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      AppLogger.error('Failed to start purchase', e);
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start purchase: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _handlePurchase() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check if in-app purchases are available
      if (!_isAvailable) {
        throw Exception('In-app purchases are not available on this device.\n\n'
            'Possible causes:\n'
            '• Device doesn\'t support Google Play Billing\n'
            '• Google Play Store is not installed or updated\n'
            '• Device is in restricted region');
      }

      // Check if products are loaded
      if (_products.isEmpty) {
        if (_queryProductError != null) {
          throw Exception('Cannot purchase: Product not available in store.\n\n'
              'Please check the Play Console setup instructions above and try again.');
        } else {
          throw Exception('Premium product not available.\n\n'
              'The product "$_kPremiumPurchaseId" was not found in the store.\n'
              'Please ensure it\'s properly configured in Google Play Console.');
        }
      }

      // Purchase the premium lifetime product
      final ProductDetails productToPurchase = _products.first;

      AppLogger.info('Initiating purchase for: ${productToPurchase.id}');

      // Start the purchase flow
      await _buyProduct(productToPurchase);

      // Note: The actual purchase completion is handled by _onPurchaseUpdate
      // We don't set _isLoading = false here because it will be set in the purchase callback
    } catch (e) {
      AppLogger.error('Purchase failed', e);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Show detailed error dialog for purchase issues
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 8),
                Text('Purchase Failed'),
              ],
            ),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
              if (_queryProductError != null)
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    setState(() {
                      _queryProductError = null;
                      _isLoading = true;
                    });
                    await _loadProducts();
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  child: const Text('Retry Setup'),
                ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _handleRestore() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check if in-app purchases are available
      if (!_isAvailable) {
        throw Exception('In-app purchases are not available on this device');
      }

      AppLogger.info('Attempting to restore purchases...');

      // Restore purchases from the store
      await _inAppPurchase.restorePurchases();

      // The actual restoration is handled by _onPurchaseUpdate
      // If no purchases are found, we'll show a message after a brief delay
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Check if we have any active subscriptions after restore
        final status = await SubscriptionService().getSubscriptionStatus();

        if (status == SubscriptionStatus.premium) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Purchases restored successfully!'),
            ),
          );
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No previous purchases found'),
            ),
          );
        }
      }
    } catch (e) {
      AppLogger.error('Restore failed', e);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Restore failed: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String description;

  _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}
