// Activity recognition feature has been removed from the app.
// This file intentionally left as a stub to avoid import errors if referenced.

class ActivityRecognitionService {
  static Future<bool> initialize() async => false;
  static Future<bool> requestPermissions() async => false;
  static Future<bool> hasPermissions() async => false;
  static Future<bool> startMonitoring() async => false;
  static Future<void> stopMonitoring() async {}
  static Future<Map<String, dynamic>> getCurrentActivity() async => {
        'activity': 'unknown',
        'confidence': 0.0,
        'timestamp': DateTime.now().toIso8601String(),
        'monitoring': false,
      };
  static Future<Map<String, dynamic>> getTodayActivitySummary() async => {
        'totalActiveMinutes': 0,
        'walkingMinutes': 0,
        'runningMinutes': 0,
        'cyclingMinutes': 0,
        'stillMinutes': 0,
        'activities': <Map<String, dynamic>>[],
        'timestamp': DateTime.now().toIso8601String(),
      };
  static Future<bool> wasActivityDetectedToday(String activityType) async =>
      false;
  static Future<Map<String, dynamic>> getServiceStatus() async => {
        'isInitialized': false,
        'isMonitoring': false,
        'hasPermissions': false,
        'supportedActivities': const <String, String>{},
        'timestamp': DateTime.now().toIso8601String(),
      };
  static Future<void> dispose() async {}
}
