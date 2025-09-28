import 'package:flutter/material.dart';
import '../../services/subscription_service.dart';
import '../screens/purchase_screen.dart';

/// Wrapper widget that locks the entire app when trial expires
/// Only allows access to purchase screen and basic navigation
class AppLockWrapper extends StatefulWidget {
  final Widget child;

  const AppLockWrapper({super.key, required this.child});

  @override
  State<AppLockWrapper> createState() => _AppLockWrapperState();
}

class _AppLockWrapperState extends State<AppLockWrapper> {
  SubscriptionStatus? _subscriptionStatus;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkSubscriptionStatus();
  }

  Future<void> _checkSubscriptionStatus() async {
    try {
      final status = await SubscriptionService().getSubscriptionStatus();
      if (mounted) {
        setState(() {
          _subscriptionStatus = status;
          _isLoading = false;
        });
      }
    } catch (e) {
      // On error, assume trial expired for safety
      if (mounted) {
        setState(() {
          _subscriptionStatus = SubscriptionStatus.trialExpired;
          _isLoading = false;
        });
      }
    }
  }

  /// Refresh subscription status (called after purchase attempts)
  Future<void> refreshStatus() async {
    setState(() {
      _isLoading = true;
    });
    await _checkSubscriptionStatus();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If trial expired, show lock screen
    if (_subscriptionStatus == SubscriptionStatus.trialExpired) {
      return _buildLockScreen(context);
    }

    // Otherwise, show the normal app
    return widget.child;
  }

  Widget _buildLockScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lock icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outline,
                  size: 60,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                'Trial Period Ended',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Description
              Text(
                'Your 30-day free trial has expired. To continue using HabitV8 and access all your habits, please upgrade to the premium version.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Features list
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceVariant
                      .withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Premium Features:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(
                        context, Icons.psychology, 'AI-Powered Insights'),
                    _buildFeatureItem(
                        context, Icons.all_inclusive, 'Unlimited Habits'),
                    _buildFeatureItem(
                        context, Icons.analytics, 'Advanced Analytics'),
                    _buildFeatureItem(
                        context, Icons.file_download, 'Data Export/Import'),
                    _buildFeatureItem(
                        context, Icons.category, 'Custom Categories'),
                    _buildFeatureItem(
                        context, Icons.access_time, 'Full App Access'),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Purchase button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Navigate to purchase screen
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PurchaseScreen(),
                      ),
                    );

                    // If purchase was successful, refresh status
                    if (result == true) {
                      await refreshStatus();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_cart),
                      const SizedBox(width: 8),
                      Text(
                        'Upgrade to Premium',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Restore purchases button
              TextButton(
                onPressed: () async {
                  try {
                    // Show loading
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const AlertDialog(
                        content: Row(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 16),
                            Text('Restoring purchases...'),
                          ],
                        ),
                      ),
                    );

                    // Attempt to restore purchases
                    final success =
                        await SubscriptionService().restorePurchases();

                    // Close loading dialog
                    if (mounted) Navigator.of(context).pop();

                    if (success) {
                      // Refresh status to check if purchase was restored
                      await refreshStatus();

                      if (mounted &&
                          _subscriptionStatus != SubscriptionStatus.premium) {
                        // No purchases found
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No previous purchases found'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to restore purchases'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    // Close loading dialog if still open
                    if (mounted) Navigator.of(context).pop();

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Error restoring purchases: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: Text(
                  'Restore Purchases',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ],
      ),
    );
  }
}
