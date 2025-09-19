import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/widget_integration_service.dart';
import '../services/logging_service.dart';

/// Handles widget launch navigation and deep linking
class WidgetLaunchHandler {
  static bool _hasCheckedWidgetLaunch = false;

  /// Check if app was launched from widget and handle navigation
  static Future<void> handleWidgetLaunch(BuildContext context) async {
    // Only check once per app session
    if (_hasCheckedWidgetLaunch) return;
    _hasCheckedWidgetLaunch = true;

    try {
      final widgetService = WidgetIntegrationService.instance;
      final wasLaunchedFromWidget = await widgetService.wasLaunchedFromWidget();

      if (!wasLaunchedFromWidget) return;

      final launchData = await widgetService.getWidgetLaunchData();
      if (launchData == null) return;

      final route = launchData['route'] as String?;
      if (route == null || route.isEmpty) return;

      AppLogger.info('App launched from widget with route: $route');

      // Navigate to the specified route after a small delay to ensure app is ready
      await Future.delayed(const Duration(milliseconds: 500));

      if (context.mounted) {
        _navigateToWidgetRoute(context, route);
      }
    } catch (e) {
      AppLogger.error('Error handling widget launch: $e');
    }
  }

  /// Navigate to the route specified by widget launch
  static void _navigateToWidgetRoute(BuildContext context, String route) {
    try {
      // Handle different route patterns
      if (route.startsWith('/edit-habit/')) {
        final habitId = route.substring('/edit-habit/'.length);
        context.go('/habits/edit/$habitId');
      } else if (route == '/create-habit') {
        context.go('/habits/create');
      } else if (route == '/timeline') {
        context.go('/');
      } else {
        // Fallback to main timeline if route is not recognized
        context.go('/');
      }
    } catch (e) {
      AppLogger.error('Error navigating to widget route: $route', e);
      // Fallback to main screen
      context.go('/');
    }
  }

  /// Reset the launch check flag (useful for testing)
  static void resetLaunchCheck() {
    _hasCheckedWidgetLaunch = false;
  }
}
