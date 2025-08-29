/// Result of a health permission request with detailed status information
class HealthPermissionResult {
  /// Whether the permission request was granted
  final bool granted;
  
  /// Whether background health data access was granted (Android 14+)
  final bool backgroundGranted;
  
  /// Whether Health Connect needs to be installed
  final bool needsHealthConnect;
  
  /// Whether manual setup in Health Connect is required
  final bool needsManualSetup;
  
  /// Human-readable message describing the result
  final String message;

  /// Create a new health permission result
  const HealthPermissionResult({
    required this.granted,
    this.backgroundGranted = false,
    this.needsHealthConnect = false,
    this.needsManualSetup = false,
    required this.message,
  });

  /// Whether the user needs to install or set up Health Connect
  bool get requiresHealthConnectSetup => needsHealthConnect;
  
  /// Whether the user needs to take action (manual setup or install)
  bool get requiresUserAction => needsManualSetup || needsHealthConnect;
  
  /// Whether the user needs to manually set up permissions
  bool get requiresManualPermissionSetup => needsManualSetup;
}
