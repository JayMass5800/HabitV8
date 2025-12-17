import 'package:flutter/material.dart';

/// Standardized error state widget for consistent error display across screens.
///
/// Displays an error icon, message, and optional retry button.
/// Use this widget whenever displaying an error state to users.
class ErrorStateWidget extends StatelessWidget {
  /// The error message to display.
  final String message;

  /// Optional detailed error information (shown in smaller text).
  final String? details;

  /// Callback when retry button is pressed. If null, no retry button is shown.
  final VoidCallback? onRetry;

  /// Icon to display. Defaults to error_outline.
  final IconData icon;

  /// Icon color. Defaults to theme's error color.
  final Color? iconColor;

  /// Icon size. Defaults to 64.
  final double iconSize;

  const ErrorStateWidget({
    super.key,
    required this.message,
    this.details,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.iconColor,
    this.iconSize = 64,
  });

  /// Factory constructor for common "something went wrong" error.
  factory ErrorStateWidget.generic({
    VoidCallback? onRetry,
  }) {
    return ErrorStateWidget(
      message: 'Something went wrong',
      details: 'Please try again later',
      onRetry: onRetry,
    );
  }

  /// Factory constructor for network/connection errors.
  factory ErrorStateWidget.network({
    VoidCallback? onRetry,
  }) {
    return ErrorStateWidget(
      message: 'Connection error',
      details: 'Please check your internet connection',
      icon: Icons.wifi_off,
      onRetry: onRetry,
    );
  }

  /// Factory constructor for "no data" states (not exactly an error).
  factory ErrorStateWidget.noData({
    String message = 'No data available',
    String? details,
    VoidCallback? onRetry,
  }) {
    return ErrorStateWidget(
      message: message,
      details: details,
      icon: Icons.inbox_outlined,
      onRetry: onRetry,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconColor = iconColor ?? theme.colorScheme.error;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: effectiveIconColor,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (details != null) ...[
              const SizedBox(height: 8),
              Text(
                details!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.tonal(
                onPressed: onRetry,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh, size: 18),
                    SizedBox(width: 8),
                    Text('Try again'),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Standardized loading state widget for consistent loading display.
///
/// Displays a circular progress indicator with optional message.
class LoadingStateWidget extends StatelessWidget {
  /// Optional message to display below the loading indicator.
  final String? message;

  /// Size of the progress indicator. Defaults to 40.
  final double size;

  /// Stroke width of the progress indicator. Defaults to 3.
  final double strokeWidth;

  const LoadingStateWidget({
    super.key,
    this.message,
    this.size = 40,
    this.strokeWidth = 3,
  });

  /// Factory constructor for common "Loading..." state.
  factory LoadingStateWidget.standard({String? message}) {
    return LoadingStateWidget(message: message ?? 'Loading...');
  }

  /// Factory constructor for smaller inline loading indicator.
  factory LoadingStateWidget.inline() {
    return const LoadingStateWidget(size: 24, strokeWidth: 2);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Standardized empty state widget for "no items" scenarios.
///
/// Displays an icon, message, and optional action button.
class EmptyStateWidget extends StatelessWidget {
  /// The main message to display.
  final String message;

  /// Optional subtitle/description.
  final String? subtitle;

  /// Icon to display. Defaults to inbox_outlined.
  final IconData icon;

  /// Optional action button label.
  final String? actionLabel;

  /// Callback when action button is pressed.
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  /// Factory constructor for "no habits" state.
  factory EmptyStateWidget.noHabits({VoidCallback? onCreateHabit}) {
    return EmptyStateWidget(
      icon: Icons.check_circle_outline,
      message: 'No habits yet',
      subtitle: 'Create your first habit to get started!',
      actionLabel: onCreateHabit != null ? 'Create Habit' : null,
      onAction: onCreateHabit,
    );
  }

  /// Factory constructor for "no results" after filtering/search.
  factory EmptyStateWidget.noResults({String? searchTerm}) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      message: 'No results found',
      subtitle: searchTerm != null
          ? 'No habits match "$searchTerm"'
          : 'Try adjusting your filters',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
