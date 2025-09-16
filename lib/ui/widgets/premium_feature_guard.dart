import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/subscription_service.dart';

/// Widget that wraps premium features and shows trial/purchase prompts when needed
class PremiumFeatureGuard extends ConsumerStatefulWidget {
  final PremiumFeature feature;
  final Widget child;
  final Widget? lockedWidget;
  final String? customTitle;
  final String? customDescription;

  const PremiumFeatureGuard({
    super.key,
    required this.feature,
    required this.child,
    this.lockedWidget,
    this.customTitle,
    this.customDescription,
  });

  @override
  ConsumerState<PremiumFeatureGuard> createState() =>
      _PremiumFeatureGuardState();
}

class _PremiumFeatureGuardState extends ConsumerState<PremiumFeatureGuard> {
  bool _isFeatureAvailable = false;
  bool _isLoading = true;
  SubscriptionStatus _subscriptionStatus = SubscriptionStatus.trial;

  @override
  void initState() {
    super.initState();
    _checkFeatureAvailability();
  }

  Future<void> _checkFeatureAvailability() async {
    final subscriptionService = SubscriptionService();

    try {
      final isAvailable =
          await subscriptionService.isFeatureAvailable(widget.feature);
      final status = await subscriptionService.getSubscriptionStatus();

      if (mounted) {
        setState(() {
          _isFeatureAvailable = isAvailable;
          _subscriptionStatus = status;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isFeatureAvailable = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_isFeatureAvailable) {
      return widget.child;
    }

    // Show locked widget or default locked UI
    return widget.lockedWidget ?? _buildDefaultLockedUI(context);
  }

  Widget _buildDefaultLockedUI(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Lock icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_outline,
              size: 32,
              color: colorScheme.onPrimaryContainer,
            ),
          ),

          const SizedBox(height: 16),

          // Title
          Text(
            widget.customTitle ?? _getDefaultTitle(),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Description
          Text(
            widget.customDescription ?? _getDefaultDescription(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Status-specific content
          if (_subscriptionStatus == SubscriptionStatus.trial) ...[
            _buildTrialExpiredContent(context),
          ] else if (_subscriptionStatus ==
              SubscriptionStatus.trialExpired) ...[
            _buildTrialExpiredContent(context),
          ],
        ],
      ),
    );
  }

  Widget _buildTrialExpiredContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Trial status info
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _subscriptionStatus == SubscriptionStatus.trial
                ? colorScheme.primaryContainer
                : colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: FutureBuilder<String>(
            future: SubscriptionService().getStatusDisplayText(),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? 'Loading...',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: _subscriptionStatus == SubscriptionStatus.trial
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // Action buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Maybe Later'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  context.push('/purchase');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                child: const Text('Upgrade Now'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getDefaultTitle() {
    switch (_subscriptionStatus) {
      case SubscriptionStatus.trial:
        return 'Premium Feature';
      case SubscriptionStatus.trialExpired:
        return 'Trial Expired';
      case SubscriptionStatus.premium:
        return 'Premium Feature';
      case SubscriptionStatus.cancelled:
        return 'Subscription Cancelled';
    }
  }

  String _getDefaultDescription() {
    switch (_subscriptionStatus) {
      case SubscriptionStatus.trial:
        return 'This feature is part of HabitV8 Premium. Your trial is still active, but this feature requires an upgrade.';
      case SubscriptionStatus.trialExpired:
        return 'Your free trial has ended. Upgrade to HabitV8 Premium to access this feature and more.';
      case SubscriptionStatus.premium:
        return 'This premium feature is available with your subscription.';
      case SubscriptionStatus.cancelled:
        return 'Your subscription has been cancelled. Renew to access this feature.';
    }
  }
}

/// Simple wrapper for premium features that shows a banner instead of blocking access
class PremiumFeatureBanner extends ConsumerWidget {
  final PremiumFeature feature;
  final Widget child;
  final bool showBanner;

  const PremiumFeatureBanner({
    super.key,
    required this.feature,
    required this.child,
    this.showBanner = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<bool>(
      future: SubscriptionService().isFeatureAvailable(feature),
      builder: (context, snapshot) {
        final isAvailable = snapshot.data ?? false;

        if (isAvailable || !showBanner) {
          return child;
        }

        return Column(
          children: [
            _buildPremiumBanner(context),
            child,
          ],
        );
      },
    );
  }

  Widget _buildPremiumBanner(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer,
            colorScheme.primaryContainer.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.star_outline,
            color: colorScheme.onPrimaryContainer,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${feature.displayName} - Upgrade to Premium',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.push('/purchase');
            },
            child: Text(
              'Upgrade',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Provider for subscription status
final subscriptionStatusProvider =
    FutureProvider<SubscriptionStatus>((ref) async {
  return await SubscriptionService().getSubscriptionStatus();
});

/// Provider for remaining trial days
final remainingTrialDaysProvider = FutureProvider<int>((ref) async {
  return await SubscriptionService().getRemainingTrialDays();
});

/// Provider for checking if a specific feature is available
final featureAvailabilityProvider =
    FutureProvider.family<bool, PremiumFeature>((ref, feature) async {
  return await SubscriptionService().isFeatureAvailable(feature);
});
