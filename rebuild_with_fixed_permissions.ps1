# Script to clean and rebuild the app with the fixed permissions

Write-Host "Cleaning the project..." -ForegroundColor Cyan
Set-Location "c:\HabitV8"
flutter clean

Write-Host "Removing build artifacts..." -ForegroundColor Cyan
if (Test-Path "c:\HabitV8\android\app\build") {
    Remove-Item -Recurse -Force "c:\HabitV8\android\app\build"
}
if (Test-Path "c:\HabitV8\android\.gradle") {
    Remove-Item -Recurse -Force "c:\HabitV8\android\.gradle"
}

Write-Host "Getting dependencies..." -ForegroundColor Cyan
flutter pub get

Write-Host "Building the app with fixed permissions..." -ForegroundColor Cyan
flutter build apk --debug

Write-Host "Build completed. Check the APK for the fixed permissions." -ForegroundColor Green
Write-Host "APK location: C:\HabitV8\android\app\build\outputs\flutter-apk\app-debug.apk" -ForegroundColor Yellow

Write-Host "Adding debug info to help diagnose permission issues..." -ForegroundColor Cyan
$debugInfoFile = "c:\HabitV8\lib\services\health_debug_info.dart"

$debugInfoContent = @"
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
      AppLogger.info('Health debug info: \${debugInfo.toString()}');
      
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
                  Text('Initialized: \${debugInfo['isInitialized']}'),
                  Text('Available: \${debugInfo['isAvailable']}'),
                  Text('Has Permissions: \${debugInfo['hasPermissions']}'),
                  Text('Has Background Access: \${debugInfo['hasBackgroundAccess']}'),
                  Text('Has Heart Rate Permission: \${debugInfo['hasHeartRatePermission']}'),
                  Text('Background Monitoring Active: \${debugInfo['isBackgroundMonitoringActive']}'),
                  const SizedBox(height: 16),
                  const Text('Allowed Data Types:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('\${(debugInfo['allowedDataTypes'] as List).join(', ')}'),
                  const SizedBox(height: 16),
                  const Text('Supported Data Types:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('\${(debugInfo['supportedDataTypes'] as List).join(', ')}'),
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
            content: Text('Force request permissions result: \$result'),
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
      final isActive = await MinimalHealthChannel.isBackgroundMonitoringActive();
      
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
"@

Set-Content -Path $debugInfoFile -Value $debugInfoContent

Write-Host "Debug info helper created at: $debugInfoFile" -ForegroundColor Green
Write-Host "Add this to your app to help diagnose permission issues." -ForegroundColor Yellow