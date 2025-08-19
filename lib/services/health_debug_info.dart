import 'package:flutter/material.dart';
import 'health_service.dart';
import 'minimal_health_channel.dart';
import 'logging_service.dart';

/// Helper class to debug health permissions
class HealthDebugInfo {
  /// Show debug info dialog
  static Future<void> showDebugInfo(BuildContext context) async {
    try {
      // Get debug info
      final debugInfo = await HealthService.getHealthConnectDebugInfo();

      // Log debug info
      AppLogger.info('Health debug info: $debugInfo');

      // Show dialog
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Health Permissions Debug Info'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Initialized: ${debugInfo['isInitialized'] ?? 'Unknown'}',
                  ),
                  Text('Available: ${debugInfo['isAvailable'] ?? 'Unknown'}'),
                  Text(
                    'Has Permissions: ${debugInfo['hasPermissions'] ?? 'Unknown'}',
                  ),
                  Text(
                    'Has Background Access: ${debugInfo['hasBackgroundAccess'] ?? 'Unknown'}',
                  ),
                  Text(
                    'Has Heart Rate Permission: ${debugInfo['hasHeartRatePermission'] ?? 'Unknown'}',
                  ),
                  Text(
                    'Background Monitoring Active: ${debugInfo['isBackgroundMonitoringActive'] ?? 'Unknown'}',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Allowed Data Types:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${debugInfo['allowedDataTypes']?.join(', ') ?? 'None'}',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Supported Data Types:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${debugInfo['supportedDataTypes']?.join(', ') ?? 'None'}',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Platform:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${debugInfo['platform'] ?? 'Unknown'}'),
                  const SizedBox(height: 16),
                  const Text(
                    'Message:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${debugInfo['message'] ?? 'No message'}'),
                  if (debugInfo['currentHealthSummary'] != null) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Current Health Summary:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${debugInfo['currentHealthSummary']}'),
                  ],
                  if (debugInfo['error'] != null) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Error:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      '${debugInfo['error']}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _forceRequestPermissions(context);
                },
                child: const Text('Force Request Permissions'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _toggleBackgroundMonitoring(context);
                },
                child: const Text('Toggle Background Monitoring'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      AppLogger.error('Error showing health debug info', e);
    }
  }

  /// Force request permissions
  static Future<void> _forceRequestPermissions(BuildContext context) async {
    try {
      final result = await HealthService.forceRequestAllPermissions();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Force request permissions result: $result'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      AppLogger.error('Error force requesting permissions', e);
    }
  }

  /// Toggle background monitoring
  static Future<void> _toggleBackgroundMonitoring(BuildContext context) async {
    try {
      final isActive =
          await MinimalHealthChannel.isBackgroundMonitoringActive();

      if (isActive) {
        await MinimalHealthChannel.stopBackgroundMonitoring();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Background monitoring stopped'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        await MinimalHealthChannel.startBackgroundMonitoring();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Background monitoring started'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      AppLogger.error('Error toggling background monitoring', e);
    }
  }
}
