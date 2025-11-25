import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/subscription_service.dart';

/// Provider that triggers refresh of subscription status
final subscriptionRefreshProvider = StateProvider<int>((ref) => 0);

/// Widget that wraps premium features and shows trial/purchase prompts when needed
/// Now reactive - updates automatically when subscription status changes
class PremiumFeatureGuard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the refresh provider to trigger rebuilds when subscription changes
    ref.watch(subscriptionRefreshProvider);

    // Use the reactive provider
    final featureAvailableAsync =
        ref.watch(featureAvailabilityProvider(feature));
    final subscriptionStatusAsync = ref.watch(subscriptionStatusProvider);

    return featureAvailableAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) =>
          lockedWidget ??
          _buildDefaultLockedUI(
            context,
            ref,
            SubscriptionStatus.trialExpired,
            showRetry: true,
            onRetry: () => ref.invalidate(featureAvailabilityProvider(feature)),
          ),
      data: (isAvailable) {
        if (isAvailable) {
          return child;
        }

        final status = subscriptionStatusAsync.valueOrNull ??
            SubscriptionStatus.trialExpired;
        return lockedWidget ?? _buildDefaultLockedUI(context, ref, status);
      },
    );
  }

  Widget _buildDefaultLockedUI(
    BuildContext context,
    WidgetRef ref,
    SubscriptionStatus status, {
    bool showRetry = false,
    VoidCallback? onRetry,
  }) {
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
            customTitle ?? _getDefaultTitle(status),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Description
          Text(
            customDescription ?? _getDefaultDescription(status),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Status-specific content
          _buildTrialExpiredContent(context, ref, status),

          // Retry button for error state
          if (showRetry && onRetry != null) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrialExpiredContent(
      BuildContext context, WidgetRef ref, SubscriptionStatus status) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Trial status info
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: status == SubscriptionStatus.trial
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
                  color: status == SubscriptionStatus.trial
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
                onPressed: () async {
                  final result = await context.push('/purchase');
                  // Refresh subscription status after returning from purchase
                  if (result == true) {
                    refreshSubscriptionStatus(ref);
                  }
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

  String _getDefaultTitle(SubscriptionStatus status) {
    switch (status) {
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

  String _getDefaultDescription(SubscriptionStatus status) {
    switch (status) {
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
    // Watch refresh provider for reactivity
    ref.watch(subscriptionRefreshProvider);

    final isAvailableAsync = ref.watch(featureAvailabilityProvider(feature));

    return isAvailableAsync.when(
      loading: () => child, // Show child while loading
      error: (_, __) => child, // Show child on error
      data: (isAvailable) {
        if (isAvailable || !showBanner) {
          return child;
        }

        return Column(
          children: [
            _buildPremiumBanner(context, ref),
            child,
          ],
        );
      },
    );
  }

  Widget _buildPremiumBanner(BuildContext context, WidgetRef ref) {
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
            onPressed: () async {
              final result = await context.push('/purchase');
              if (result == true) {
                refreshSubscriptionStatus(ref);
              }
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

/// Provider for subscription status - now auto-refreshing
final subscriptionStatusProvider =
    FutureProvider<SubscriptionStatus>((ref) async {
  // Watch refresh provider to enable manual refresh
  ref.watch(subscriptionRefreshProvider);
  return await SubscriptionService().getSubscriptionStatus();
});

/// Provider for remaining trial days
final remainingTrialDaysProvider = FutureProvider<int>((ref) async {
  ref.watch(subscriptionRefreshProvider);
  return await SubscriptionService().getRemainingTrialDays();
});

/// Provider for checking if a specific feature is available
final featureAvailabilityProvider =
    FutureProvider.family<bool, PremiumFeature>((ref, feature) async {
  ref.watch(subscriptionRefreshProvider);
  return await SubscriptionService().isFeatureAvailable(feature);
});

/// Helper function to trigger subscription status refresh across all providers
void refreshSubscriptionStatus(WidgetRef ref) {
  ref.read(subscriptionRefreshProvider.notifier).state++;
}
