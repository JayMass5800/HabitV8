import 'package:flutter/material.dart';
import '../../services/preferences_service.dart';
import '../../services/time_service.dart';
import '../screens/ai_settings_screen.dart';

/// Service to show AI insights prompts at appropriate times
class AIInsightsNotificationService {
  static const String _lastPromptKey = 'ai_insights_last_prompt';
  static const String _dismissedKey = 'ai_insights_dismissed';
  static const String _setupCompleteKey = 'ai_insights_setup_complete';

  /// Check if we should show a notification and display it
  static Future<void> checkAndShowNotification(
    BuildContext context, {
    required int habitCount,
    required int completionCount,
    required bool isAIEnabled,
    required bool hasAPIKey,
  }) async {
    if (!context.mounted) return;

    final dismissed =
        await PreferencesService.getBoolOrDefault(_dismissedKey, false);
    final setupComplete =
        await PreferencesService.getBoolOrDefault(_setupCompleteKey, false);
    final lastPrompt =
        await PreferencesService.getIntOrDefault(_lastPromptKey, 0);
    final now = TimeService.instance.nowLocal().millisecondsSinceEpoch;

    // Don't show if dismissed or setup is complete
    if (dismissed || setupComplete) return;

    // Don't prompt too frequently (once per day)
    if (now - lastPrompt < 24 * 60 * 60 * 1000) return;

    String? notificationType;

    // Determine what type of notification to show
    if (!isAIEnabled && !hasAPIKey && habitCount > 0 && completionCount >= 3) {
      notificationType = 'enable_ai';
    } else if (isAIEnabled && !hasAPIKey) {
      notificationType = 'add_api_key';
    } else if (isAIEnabled && hasAPIKey && completionCount >= 10) {
      notificationType = 'ai_ready';
    }

    if (notificationType != null && context.mounted) {
      await _showNotification(context, notificationType);
      await PreferencesService.setInt(_lastPromptKey, now);
    }
  }

  /// Mark setup as complete to stop showing notifications
  static Future<void> markSetupComplete() async {
    await PreferencesService.setBool(_setupCompleteKey, true);
  }

  /// Mark notifications as dismissed
  static Future<void> dismiss() async {
    await PreferencesService.setBool(_dismissedKey, true);
  }

  /// Reset all notification preferences (for testing)
  static Future<void> reset() async {
    await PreferencesService.remove(_dismissedKey);
    await PreferencesService.remove(_setupCompleteKey);
    await PreferencesService.remove(_lastPromptKey);
  }

  static Future<void> _showNotification(
    BuildContext context,
    String type,
  ) async {
    String title;
    String message;
    IconData icon;
    Color color;

    switch (type) {
      case 'enable_ai':
        title = '🤖 Ready for AI Insights?';
        message =
            'You\'ve been tracking habits consistently! Enable AI insights to get personalized recommendations.';
        icon = Icons.psychology;
        color = Colors.blue;
        break;
      case 'add_api_key':
        title = '🔑 Complete AI Setup';
        message =
            'Add your API key to start getting AI-powered insights about your habits.';
        icon = Icons.key;
        color = Colors.orange;
        break;
      case 'ai_ready':
        title = '✨ AI Insights Ready!';
        message =
            'Great progress! Your AI insights should now be providing valuable recommendations.';
        icon = Icons.celebration;
        color = Colors.green;
        break;
      default:
        return;
    }

    // Show as a snackbar with action
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(message),
            ],
          ),
          backgroundColor: color,
          duration: const Duration(seconds: 6),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          action: SnackBarAction(
            label: type == 'ai_ready' ? 'View' : 'Set Up',
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AISettingsScreen(),
                ),
              );
            },
          ),
        ),
      );
    }
  }
}

/// Widget that automatically checks and shows notifications
class AIInsightsNotificationChecker extends StatefulWidget {
  final Widget child;
  final int habitCount;
  final int completionCount;
  final bool isAIEnabled;
  final bool hasAPIKey;

  const AIInsightsNotificationChecker({
    super.key,
    required this.child,
    required this.habitCount,
    required this.completionCount,
    required this.isAIEnabled,
    required this.hasAPIKey,
  });

  @override
  State<AIInsightsNotificationChecker> createState() =>
      _AIInsightsNotificationCheckerState();
}

class _AIInsightsNotificationCheckerState
    extends State<AIInsightsNotificationChecker> {
  @override
  void initState() {
    super.initState();
    _checkNotifications();
  }

  void _checkNotifications() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AIInsightsNotificationService.checkAndShowNotification(
        context,
        habitCount: widget.habitCount,
        completionCount: widget.completionCount,
        isAIEnabled: widget.isAIEnabled,
        hasAPIKey: widget.hasAPIKey,
      );
    });
  }

  @override
  void didUpdateWidget(AIInsightsNotificationChecker oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check for significant changes that might trigger a new notification
    if (widget.habitCount != oldWidget.habitCount ||
        widget.completionCount != oldWidget.completionCount ||
        widget.isAIEnabled != oldWidget.isAIEnabled ||
        widget.hasAPIKey != oldWidget.hasAPIKey) {
      _checkNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
