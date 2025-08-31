import "package:flutter/material.dart";
import "health_service.dart";
import "logging_service.dart";

/// Example widget demonstrating how to use the updated Health Connect integration
/// with Android 16 (SDK 36) compatibility
class HealthConnectExample extends StatefulWidget {
  const HealthConnectExample({super.key});

  @override
  State<HealthConnectExample> createState() => _HealthConnectExampleState();
}

class _HealthConnectExampleState extends State<HealthConnectExample> {
  bool _isAvailable = false;
  bool _hasPermissions = false;
  bool _hasBackgroundPermissions = false;
  String _statusMessage = "Checking Health Connect...";
  int _steps = 0;

  @override
  void initState() {
    super.initState();
    _checkHealthConnect();
  }

  /// Check Health Connect availability and permissions
  Future<void> _checkHealthConnect() async {
    try {
      // Initialize health service
      final initialized = await HealthService.initialize();

      // Check if Health Connect is available
      final isAvailable = await HealthService.isHealthConnectAvailable();

      // Check if permissions are granted
      final hasPermissions = await HealthService.hasPermissions();

      // Check if background permissions are granted
      final hasBackgroundPermissions =
          await HealthService.hasBackgroundPermissions();

      // Update UI
      setState(() {
        _isAvailable = isAvailable;
        _hasPermissions = hasPermissions;
        _hasBackgroundPermissions = hasBackgroundPermissions;
        _statusMessage = _buildStatusMessage(
            initialized, isAvailable, hasPermissions, hasBackgroundPermissions);
      });

      // If permissions are granted, get steps data
      if (hasPermissions) {
        await _getStepsData();
      }
    } catch (e) {
      AppLogger.error("Error checking Health Connect", e);
      setState(() {
        _statusMessage = "Error: $e";
      });
    }
  }

  /// Request health permissions including background access
  Future<void> _requestPermissions() async {
    try {
      setState(() {
        _statusMessage = "Requesting permissions...";
      });

      // Request permissions with background access
      final result = await HealthService.requestPermissionsWithBackground();

      // Update UI
      setState(() {
        _hasPermissions = result.granted;
        _hasBackgroundPermissions = result.backgroundGranted;
        _statusMessage = result.message;
      });

      // If permissions are granted, get steps data
      if (result.granted) {
        await _getStepsData();
      }
    } catch (e) {
      AppLogger.error("Error requesting permissions", e);
      setState(() {
        _statusMessage = "Error: $e";
      });
    }
  }

  /// Get steps data for today
  Future<void> _getStepsData() async {
    try {
      final steps = await HealthService.getStepsToday();
      setState(() {
        _steps = steps;
      });
    } catch (e) {
      AppLogger.error("Error getting steps data", e);
    }
  }

  /// Start background health monitoring
  Future<void> _startBackgroundMonitoring() async {
    try {
      setState(() {
        _statusMessage = "Starting background monitoring...";
      });

      final result = await HealthService.startBackgroundMonitoring();

      setState(() {
        _statusMessage = result
            ? "Background monitoring started successfully"
            : "Failed to start background monitoring";
      });
    } catch (e) {
      AppLogger.error("Error starting background monitoring", e);
      setState(() {
        _statusMessage = "Error: $e";
      });
    }
  }

  /// Build status message based on Health Connect state
  String _buildStatusMessage(bool initialized, bool isAvailable,
      bool hasPermissions, bool hasBackgroundPermissions) {
    if (!initialized) {
      return "Health Connect initialization failed";
    }

    if (!isAvailable) {
      return "Health Connect is not available on this device";
    }

    if (!hasPermissions) {
      return "Health Connect permissions not granted";
    }

    if (!hasBackgroundPermissions) {
      return "Health Connect permissions granted, but background access is missing";
    }

    return "Health Connect is available and all permissions granted";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Connect Example"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Health Connect Status",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text("Available: ${_isAvailable ? "Yes" : "No"}"),
                    Text(
                        "Permissions: ${_hasPermissions ? "Granted" : "Not granted"}"),
                    Text(
                        "Background: ${_hasBackgroundPermissions ? "Granted" : "Not granted"}"),
                    const SizedBox(height: 8),
                    Text(
                      _statusMessage,
                      style: TextStyle(
                        color: _hasPermissions ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Steps data
            if (_hasPermissions)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Steps Today",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "$_steps steps",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      TextButton(
                        onPressed: _getStepsData,
                        child: const Text("Refresh"),
                      ),
                    ],
                  ),
                ),
              ),

            const Spacer(),

            // Action buttons
            if (!_hasPermissions)
              ElevatedButton(
                onPressed: _requestPermissions,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text("Request Health Permissions"),
              ),

            if (_hasPermissions && !_hasBackgroundPermissions)
              ElevatedButton(
                onPressed: _requestPermissions,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text("Request Background Access"),
              ),

            if (_hasPermissions && _hasBackgroundPermissions)
              ElevatedButton(
                onPressed: _startBackgroundMonitoring,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text("Start Background Monitoring"),
              ),
          ],
        ),
      ),
    );
  }
}
