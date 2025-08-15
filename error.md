=== FINAL HEALTH PERMISSIONS VERIFICATION ===

✅ Found AAB file: android\app\build\outputs\bundle\release\app-release.aab
📦 AAB Size: 56.34 MB
✅ Extracted AAB for analysis

📄 Found AndroidManifest.xml files:
  - base\manifest\AndroidManifest.xml

🔍 ANALYZING HEALTH PERMISSIONS...

📋 Analyzing: base\manifest\AndroidManifest.xml
  ✅ ALLOWED: android.permission.health.READ_STEPS
  ✅ ALLOWED: android.permission.health.READ_ACTIVE_CALORIES_BURNED
  ✅ ALLOWED: android.permission.health.READ_SLEEP
  ✅ ALLOWED: android.permission.health.READ_HYDRATION
  ✅ ALLOWED: android.permission.health.READ_MINDFULNESS
  ✅ ALLOWED: android.permission.health.READ_WEIGHT
  ⚠️  UNKNOWN: android.permission.health.READ_HEALTH_DATA_IN_BACKGROUND

📊 FINAL RESULTS
=================

✅ ALLOWED PERMISSIONS FOUND (6/6):
  ✅ android.permission.health.READ_STEPS
  ✅ android.permission.health.READ_ACTIVE_CALORIES_BURNED
  ✅ android.permission.health.READ_SLEEP
  ✅ android.permission.health.READ_HYDRATION
  ✅ android.permission.health.READ_MINDFULNESS
  ✅ android.permission.health.READ_WEIGHT

📈 SUMMARY:
  Total health permissions found: 7
  Allowed permissions: 6
  Forbidden permissions: 0

🎉 SUCCESS! No forbidden health permissions found!
This AAB should pass Google Play Console review.

✅ NEXT STEPS:
1. Upload this AAB to Google Play Console
2. The health permissions warning should be gone
3. Your app should be approved without health policy issues

🔍 ADDITIONAL CHECKS:
⚠️  ACTIVITY_RECOGNITION permission found - this might also trigger health policy

🧹 Analysis complete. Temporary files cleaned up.                                                                       
                                                                                                                        
📝 REPORT SUMMARY:
==================                                                                                                      
AAB File: android\app\build\outputs\bundle\release\app-release.aab                                                      
AAB Size: 56.34 MB                                                                                                      
Health Permissions Found: 7                                                                                             
Forbidden Permissions: 0                                                                                                
Analysis Date: 2025-08-14 17:17:04                                                                                      
                                                                                                                        
🎯 RESULT: SUCCESS - Ready for Google Play Console upload!     


activity reocognition might be a useful one to integrate into our app, perhaps add this to the monitored permissions and add it to our health services to track habits with activity involved.

also when building an apk the system cant find the output files, its because its looking in the wrong folder, can you update the system to look C:\HabitV8\android\app\build\outputs this is where they are all output to.


Error: Couldn't resolve the package 'health' in 'package:health/health.dart'.
lib/services/permission_service.dart:3:8: Error: Not found: 'package:health/health.dart'
import 'package:health/health.dart';
       ^
lib/ui/screens/create_habit_screen.dart:6:8: Error: Not found: 'package:health/health.dart'
import 'package:health/health.dart';
       ^
lib/services/health_habit_integration_service.dart:3:8: Error: Not found: 'package:health/health.dart'
import 'package:health/health.dart';
       ^
lib/services/health_habit_analytics_service.dart:2:8: Error: Not found: 'package:health/health.dart'
import 'package:health/health.dart';
       ^
lib/services/health_habit_mapping_service.dart:2:8: Error: Not found: 'package:health/health.dart'
import 'package:health/health.dart';
       ^
lib/services/health_enhanced_habit_creation_service.dart:2:8: Error: Not found: 'package:health/health.dart'
import 'package:health/health.dart';
       ^
lib/services/health_habit_ui_service.dart:2:8: Error: Not found: 'package:health/health.dart'
import 'package:health/health.dart';
       ^
lib/ui/screens/create_habit_screen.dart:40:3: Error: Type 'HealthDataType' not found.
  HealthDataType? _selectedHealthDataType;
  ^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:226:19: Error: Type 'HealthDataPoint' not found.
    required List<HealthDataPoint> healthData,
                  ^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:356:19: Error: Type 'HealthDataPoint' not found.
    required List<HealthDataPoint> healthData,
                  ^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:436:19: Error: Type 'HealthDataPoint' not found.
    required List<HealthDataPoint> healthData,
                  ^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:492:19: Error: Type 'HealthDataPoint' not found.
    required List<HealthDataPoint> healthData,
                  ^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:541:10: Error: Type 'HealthDataPoint' not found.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:570:69: Error: Type 'HealthDataPoint' not found.
  static double _calculateIntegrationScore(List<Habit> habits, List<HealthDataPoint> healthData) {
                                                                    ^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:588:69: Error: Type 'HealthDataPoint' not found.
  static Future<List<String>> _generateHealthDrivenSuggestions(List<HealthDataPoint> healthData) async {
                                                                    ^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:626:57: Error: Type 'HealthDataPoint' not found.
  static Map<String, dynamic> _analyzeHealthTrends(List<HealthDataPoint> healthData) {
                                                        ^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:680:10: Error: Type 'HealthDataPoint' not found.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:78:10: Error: Type 'HealthDataPoint' not found.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:105:70: Error: Type 'HealthDataPoint' not found.
  static Future<double> _calculateHabitHealthScore(Habit habit, List<HealthDataPoint> healthData) async {
                                                                     ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:140:10: Error: Type 'HealthDataPoint' not found.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:184:10: Error: Type 'HealthDataPoint' not found.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:225:10: Error: Type 'HealthDataPoint' not found.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:296:10: Error: Type 'HealthDataPoint' not found.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:351:10: Error: Type 'HealthDataPoint' not found.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:407:10: Error: Type 'HealthDataPoint' not found.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:449:10: Error: Type 'HealthDataPoint' not found.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:492:76: Error: Type 'HealthDataPoint' not found.
  static Future<double> _calculateHabitHealthCorrelation(Habit habit, List<HealthDataPoint> healthData) async {
                                                                           ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:539:48: Error: Type 'HealthDataPoint' not found.
  static double _calculateDataConsistency(List<HealthDataPoint> healthData) {
                                               ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:560:71: Error: Type 'HealthDataPoint' not found.
  static Future<String?> _findStrongestHealthMetric(Habit habit, List<HealthDataPoint> healthData) async {
                                                                      ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:593:19: Error: Type 'HealthDataPoint' not found.
    required List<HealthDataPoint> healthData,
                  ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:621:71: Error: Type 'HealthDataPoint' not found.
  static Future<double> _calculateHealthImpactScore(Habit habit, List<HealthDataPoint> healthData) async {
                                                                      ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:626:75: Error: Type 'HealthDataPoint' not found.
  static Future<double> _calculateOptimizationPotential(Habit habit, List<HealthDataPoint> healthData) async {
                                                                          ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:648:67: Error: Type 'HealthDataPoint' not found.
  static Future<double> _predictHabitCompletion(Habit habit, List<HealthDataPoint> healthData) async {
                                                                  ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:666:66: Error: Type 'HealthDataPoint' not found.
  static double _calculatePredictionConfidence(Habit habit, List<HealthDataPoint> healthData) {
                                                                 ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:685:68: Error: Type 'HealthDataPoint' not found.
  static Future<DateTime?> _predictOptimalTiming(Habit habit, List<HealthDataPoint> healthData) async {
                                                                   ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:704:86: Error: Type 'HealthDataPoint' not found.
  static Future<Map<String, dynamic>> _calculateUserMetrics(List<Habit> habits, List<HealthDataPoint> healthData) async {
                                                                                     ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:771:10: Error: Type 'HealthDataPoint' not found.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:14:20: Error: Type 'HealthDataType' not found.
  static const Map<HealthDataType, HealthHabitMapping> healthMappings = {
                   ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:620:21: Error: Type 'HealthDataType' not found.
  static Future<Set<HealthDataType>> getActiveHealthDataTypes(List<Habit> habits) async {
                    ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:636:14: Error: Type 'HealthDataType' not found.
    required HealthDataType healthDataType,
             ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:811:61: Error: Type 'HealthDataType' not found.
  static double? _extractCustomThreshold(String searchText, HealthDataType healthType) {
                                                            ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:915:9: Error: Type 'HealthDataType' not found.
  final HealthDataType healthDataType;
        ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:949:9: Error: Type 'HealthDataType' not found.
  final HealthDataType? healthDataType;
        ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:76:5: Error: Type 'HealthDataType' not found.
    HealthDataType? healthDataType,
    ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:231:10: Error: Type 'HealthDataPoint' not found.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:305:10: Error: Type 'HealthDataPoint' not found.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:361:10: Error: Type 'HealthDataPoint' not found.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:420:10: Error: Type 'HealthDataPoint' not found.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:462:10: Error: Type 'HealthDataPoint' not found.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:519:10: Error: Type 'HealthDataPoint' not found.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:632:14: Error: Type 'HealthDataType' not found.
    required HealthDataType healthDataType,
             ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:679:21: Error: Type 'HealthDataType' not found.
  static Future<Map<HealthDataType, HealthPatternAnalysis>> _analyzeHealthPatterns(
                    ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:680:10: Error: Type 'HealthDataPoint' not found.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:698:10: Error: Type 'HealthDataPoint' not found.
    List<HealthDataPoint> data,
         ^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:749:36: Error: Type 'HealthDataType' not found.
  static double _getBenchmarkValue(HealthDataType type) {
                                   ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:769:60: Error: Type 'HealthDataType' not found.
  static Future<bool> _hasRelatedHabit(List<Habit> habits, HealthDataType healthType) async {
                                                           ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:781:5: Error: Type 'HealthDataType' not found.
    HealthDataType healthType,
    ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:803:9: Error: Type 'HealthDataType' not found.
  final HealthDataType healthDataType;
        ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:15:5: Error: Undefined name 'HealthDataType'.
    HealthDataType.STEPS: HealthHabitMapping(
    ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:50:5: Error: Undefined name 'HealthDataType'.
    HealthDataType.ACTIVE_ENERGY_BURNED: HealthHabitMapping(
    ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:89:5: Error: Undefined name 'HealthDataType'.
    HealthDataType.SLEEP_IN_BED: HealthHabitMapping(
    ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:121:5: Error: Undefined name 'HealthDataType'.
    HealthDataType.WATER: HealthHabitMapping(
    ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:155:5: Error: Undefined name 'HealthDataType'.
    HealthDataType.MINDFULNESS: HealthHabitMapping(
    ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:196:5: Error: Undefined name 'HealthDataType'.
    HealthDataType.WEIGHT: HealthHabitMapping(
    ^^^^^^^^^^^^^^
lib/services/permission_service.dart:75:10: Error: 'HealthDataType' isn't a type.
    List<HealthDataType> types;
         ^^^^^^^^^^^^^^
lib/services/permission_service.dart:81:9: Error: Undefined name 'HealthDataType'.
        HealthDataType.STEPS,                    // Primary fitness metric
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:82:9: Error: Undefined name 'HealthDataType'.
        HealthDataType.ACTIVE_ENERGY_BURNED,     // Exercise intensity tracking
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:83:9: Error: Undefined name 'HealthDataType'.
        HealthDataType.SLEEP_IN_BED,             // Sleep duration tracking
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:84:9: Error: Undefined name 'HealthDataType'.
        HealthDataType.WATER,                    // Hydration habits
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:85:9: Error: Undefined name 'HealthDataType'.
        HealthDataType.MINDFULNESS,              // Meditation tracking
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:86:9: Error: Undefined name 'HealthDataType'.
        HealthDataType.WEIGHT,                   // Weight tracking habits
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:91:9: Error: Undefined name 'HealthDataType'.
        HealthDataType.STEPS,
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:92:9: Error: Undefined name 'HealthDataType'.
        HealthDataType.ACTIVE_ENERGY_BURNED,
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:93:9: Error: Undefined name 'HealthDataType'.
        HealthDataType.SLEEP_IN_BED,
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:94:9: Error: Undefined name 'HealthDataType'.
        HealthDataType.WATER,
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:95:9: Error: Undefined name 'HealthDataType'.
        HealthDataType.MINDFULNESS,
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:96:9: Error: Undefined name 'HealthDataType'.
        HealthDataType.WEIGHT,
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:101:9: Error: Undefined name 'HealthDataType'.
        HealthDataType.STEPS,
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:102:9: Error: Undefined name 'HealthDataType'.
        HealthDataType.SLEEP_IN_BED,
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:103:9: Error: Undefined name 'HealthDataType'.
        HealthDataType.WATER,
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:108:45: Error: Undefined name 'HealthDataAccess'.
    final permissions = types.map((type) => HealthDataAccess.READ).toList();
                                            ^^^^^^^^^^^^^^^^
lib/services/permission_service.dart:114:30: Error: Method not found: 'Health'.
      bool requested = await Health().requestAuthorization(
                             ^^^^^^
lib/services/permission_service.dart:126:43: Error: Method not found: 'Health'.
        final bool hasPermissions = await Health().hasPermissions(types) ?? false;
                                          ^^^^^^
lib/services/permission_service.dart:139:53: Error: Method not found: 'Health'.
              final hasIndividualPermission = await Health().hasPermissions([type]) ?? false;
                                                    ^^^^^^
lib/services/permission_service.dart:145:44: Error: Method not found: 'Health'.
          final hasStepsPermission = await Health().hasPermissions([HealthDataType.STEPS]) ?? false;
                                           ^^^^^^
lib/services/permission_service.dart:145:69: Error: Undefined name 'HealthDataType'.
          final hasStepsPermission = await Health().hasPermissions([HealthDataType.STEPS]) ?? false;
                                                                    ^^^^^^^^^^^^^^
lib/services/permission_service.dart:197:10: Error: 'HealthDataType' isn't a type.
    List<HealthDataType> types;
         ^^^^^^^^^^^^^^
lib/services/permission_service.dart:203:9: Error: The getter 'HealthDataType' isn't defined for the class 'PermissionService'.
 - 'PermissionService' is from 'package:habitv8/services/permission_service.dart' ('lib/services/permission_service.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'HealthDataType'.
        HealthDataType.STEPS,                    // Primary fitness metric
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:204:9: Error: The getter 'HealthDataType' isn't defined for the class 'PermissionService'.
 - 'PermissionService' is from 'package:habitv8/services/permission_service.dart' ('lib/services/permission_service.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'HealthDataType'.
        HealthDataType.ACTIVE_ENERGY_BURNED,     // Exercise intensity tracking
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:205:9: Error: The getter 'HealthDataType' isn't defined for the class 'PermissionService'.
 - 'PermissionService' is from 'package:habitv8/services/permission_service.dart' ('lib/services/permission_service.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'HealthDataType'.
        HealthDataType.SLEEP_IN_BED,             // Sleep duration tracking
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:206:9: Error: The getter 'HealthDataType' isn't defined for the class 'PermissionService'.
 - 'PermissionService' is from 'package:habitv8/services/permission_service.dart' ('lib/services/permission_service.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'HealthDataType'.
        HealthDataType.WATER,                    // Hydration habits
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:207:9: Error: The getter 'HealthDataType' isn't defined for the class 'PermissionService'.
 - 'PermissionService' is from 'package:habitv8/services/permission_service.dart' ('lib/services/permission_service.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'HealthDataType'.
        HealthDataType.MINDFULNESS,              // Meditation tracking
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:208:9: Error: The getter 'HealthDataType' isn't defined for the class 'PermissionService'.
 - 'PermissionService' is from 'package:habitv8/services/permission_service.dart' ('lib/services/permission_service.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'HealthDataType'.
        HealthDataType.WEIGHT,                   // Weight tracking habits
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:213:9: Error: The getter 'HealthDataType' isn't defined for the class 'PermissionService'.
 - 'PermissionService' is from 'package:habitv8/services/permission_service.dart' ('lib/services/permission_service.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'HealthDataType'.
        HealthDataType.STEPS,
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:214:9: Error: The getter 'HealthDataType' isn't defined for the class 'PermissionService'.
 - 'PermissionService' is from 'package:habitv8/services/permission_service.dart' ('lib/services/permission_service.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'HealthDataType'.
        HealthDataType.ACTIVE_ENERGY_BURNED,
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:215:9: Error: The getter 'HealthDataType' isn't defined for the class 'PermissionService'.
 - 'PermissionService' is from 'package:habitv8/services/permission_service.dart' ('lib/services/permission_service.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'HealthDataType'.
        HealthDataType.SLEEP_IN_BED,
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:216:9: Error: The getter 'HealthDataType' isn't defined for the class 'PermissionService'.
 - 'PermissionService' is from 'package:habitv8/services/permission_service.dart' ('lib/services/permission_service.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'HealthDataType'.
        HealthDataType.WATER,
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:217:9: Error: The getter 'HealthDataType' isn't defined for the class 'PermissionService'.
 - 'PermissionService' is from 'package:habitv8/services/permission_service.dart' ('lib/services/permission_service.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'HealthDataType'.
        HealthDataType.MINDFULNESS,
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:218:9: Error: The getter 'HealthDataType' isn't defined for the class 'PermissionService'.
 - 'PermissionService' is from 'package:habitv8/services/permission_service.dart' ('lib/services/permission_service.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'HealthDataType'.
        HealthDataType.WEIGHT,
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:223:9: Error: The getter 'HealthDataType' isn't defined for the class 'PermissionService'.
 - 'PermissionService' is from 'package:habitv8/services/permission_service.dart' ('lib/services/permission_service.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'HealthDataType'.
        HealthDataType.STEPS,
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:224:9: Error: The getter 'HealthDataType' isn't defined for the class 'PermissionService'.
 - 'PermissionService' is from 'package:habitv8/services/permission_service.dart' ('lib/services/permission_service.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'HealthDataType'.
        HealthDataType.SLEEP_IN_BED,
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:225:9: Error: The getter 'HealthDataType' isn't defined for the class 'PermissionService'.
 - 'PermissionService' is from 'package:habitv8/services/permission_service.dart' ('lib/services/permission_service.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'HealthDataType'.
        HealthDataType.WATER,
        ^^^^^^^^^^^^^^
lib/services/permission_service.dart:230:36: Error: The method 'Health' isn't defined for the class 'PermissionService'.
 - 'PermissionService' is from 'package:habitv8/services/permission_service.dart' ('lib/services/permission_service.dart').
Try correcting the name to the name of an existing method, or defining a method named 'Health'.
      final hasPermissions = await Health().hasPermissions(types);
                                   ^^^^^^
lib/services/permission_service.dart:239:40: Error: The method 'Health' isn't defined for the class 'PermissionService'.
 - 'PermissionService' is from 'package:habitv8/services/permission_service.dart' ('lib/services/permission_service.dart').
Try correcting the name to the name of an existing method, or defining a method named 'Health'.
      final hasStepsPermission = await Health().hasPermissions([HealthDataType.STEPS]) ?? false;
                                       ^^^^^^
lib/services/permission_service.dart:239:65: Error: The getter 'HealthDataType' isn't defined for the class 'PermissionService'.
 - 'PermissionService' is from 'package:habitv8/services/permission_service.dart' ('lib/services/permission_service.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'HealthDataType'.
      final hasStepsPermission = await Health().hasPermissions([HealthDataType.STEPS]) ?? false;
                                                                ^^^^^^^^^^^^^^
lib/services/permission_service.dart:247:47: Error: The method 'Health' isn't defined for the class 'PermissionService'.
 - 'PermissionService' is from 'package:habitv8/services/permission_service.dart' ('lib/services/permission_service.dart').
Try correcting the name to the name of an existing method, or defining a method named 'Health'.
            final bool? hasIndividual = await Health().hasPermissions([type]);
                                              ^^^^^^
lib/services/health_habit_initialization_service.dart:81:60: Error: Method not found: '_initializeActivityRecognitionService'.
      result.activityRecognitionServiceInitialized = await _initializeActivityRecognitionService();
                                                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
lib/services/health_habit_initialization_service.dart:81:14: Error: The setter 'activityRecognitionServiceInitialized' isn't defined for the class 'HealthHabitInitializationResult'.
 - 'HealthHabitInitializationResult' is from 'package:habitv8/services/health_habit_initialization_service.dart' ('lib/services/health_habit_initialization_service.dart').
Try correcting the name to the name of an existing setter, or defining a setter or field named 'activityRecognitionServiceInitialized'.
      result.activityRecognitionServiceInitialized = await _initializeActivityRecognitionService();
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
lib/services/health_habit_initialization_service.dart:82:19: Error: The getter 'activityRecognitionServiceInitialized' isn't defined for the class 'HealthHabitInitializationResult'.
 - 'HealthHabitInitializationResult' is from 'package:habitv8/services/health_habit_initialization_service.dart' ('lib/services/health_habit_initialization_service.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'activityRecognitionServiceInitialized'.
      if (!result.activityRecognitionServiceInitialized) {
                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
lib/ui/screens/create_habit_screen.dart:40:3: Error: 'HealthDataType' isn't a type.
  HealthDataType? _selectedHealthDataType;
  ^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:167:46: Error: Member not found: 'HealthService.getAllHealthData'.
      final healthData = await HealthService.getAllHealthData(
                                             ^^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:226:19: Error: 'HealthDataPoint' isn't a type.
    required List<HealthDataPoint> healthData,
                  ^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:356:19: Error: 'HealthDataPoint' isn't a type.
    required List<HealthDataPoint> healthData,
                  ^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:366:32: Error: 'NumericHealthValue' isn't a type.
            if (point.value is NumericHealthValue) {
                               ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:367:45: Error: 'NumericHealthValue' isn't a type.
              totalSteps += (point.value as NumericHealthValue).numericValue.toInt();
                                            ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:377:32: Error: 'NumericHealthValue' isn't a type.
            if (point.value is NumericHealthValue) {
                               ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:378:46: Error: 'NumericHealthValue' isn't a type.
              totalEnergy += (point.value as NumericHealthValue).numericValue;
                                             ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:388:32: Error: 'NumericHealthValue' isn't a type.
            if (point.value is NumericHealthValue) {
                               ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:389:45: Error: 'NumericHealthValue' isn't a type.
              totalSleep += (point.value as NumericHealthValue).numericValue;
                                            ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:399:32: Error: 'NumericHealthValue' isn't a type.
            if (point.value is NumericHealthValue) {
                               ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:400:45: Error: 'NumericHealthValue' isn't a type.
              totalWater += (point.value as NumericHealthValue).numericValue;
                                            ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:410:32: Error: 'NumericHealthValue' isn't a type.
            if (point.value is NumericHealthValue) {
                               ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:411:51: Error: 'NumericHealthValue' isn't a type.
              totalMindfulness += (point.value as NumericHealthValue).numericValue;
                                                  ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:421:66: Error: 'NumericHealthValue' isn't a type.
          if (healthData.isNotEmpty && healthData.first.value is NumericHealthValue) {
                                                                 ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:422:55: Error: 'NumericHealthValue' isn't a type.
            result.value = (healthData.first.value as NumericHealthValue).numericValue;
                                                      ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:367:26: Error: A value of type 'num' can't be assigned to a variable of type 'int'.
              totalSteps += (point.value as NumericHealthValue).numericValue.toInt();
                         ^
lib/services/health_habit_integration_service.dart:436:19: Error: 'HealthDataPoint' isn't a type.
    required List<HealthDataPoint> healthData,
                  ^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:460:46: Error: 'HealthDataPoint' isn't a type.
      final healthDataByType = <String, List<HealthDataPoint>>{};
                                             ^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:492:19: Error: 'HealthDataPoint' isn't a type.
    required List<HealthDataPoint> healthData,
                  ^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:500:28: Error: 'NumericHealthValue' isn't a type.
        if (point.value is NumericHealthValue) {
                           ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:502:31: Error: 'NumericHealthValue' isn't a type.
              (point.value as NumericHealthValue).numericValue;
                              ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:541:10: Error: 'HealthDataPoint' isn't a type.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:570:69: Error: 'HealthDataPoint' isn't a type.
  static double _calculateIntegrationScore(List<Habit> habits, List<HealthDataPoint> healthData) {
                                                                    ^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:588:69: Error: 'HealthDataPoint' isn't a type.
  static Future<List<String>> _generateHealthDrivenSuggestions(List<HealthDataPoint> healthData) async {
                                                                    ^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:626:57: Error: 'HealthDataPoint' isn't a type.
  static Map<String, dynamic> _analyzeHealthTrends(List<HealthDataPoint> healthData) {
                                                        ^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:631:40: Error: 'HealthDataPoint' isn't a type.
      final dataByType = <String, List<HealthDataPoint>>{};
                                       ^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:647:48: Error: 'NumericHealthValue' isn't a type.
              .where((point) => point.value is NumericHealthValue)
                                               ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:648:47: Error: 'NumericHealthValue' isn't a type.
              .map((point) => (point.value as NumericHealthValue).numericValue)
                                              ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:647:39: Error: The getter 'value' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'value'.
              .where((point) => point.value is NumericHealthValue)
                                      ^^^^^
lib/services/health_habit_integration_service.dart:648:38: Error: The getter 'value' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'value'.
              .map((point) => (point.value as NumericHealthValue).numericValue)
                                     ^^^^^
lib/services/health_habit_integration_service.dart:680:10: Error: 'HealthDataPoint' isn't a type.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_habit_integration_service.dart:699:19: Error: The getter 'type' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'type'.
            point.type.name == healthType).toList();
                  ^^^^
lib/services/health_habit_analytics_service.dart:42:46: Error: Member not found: 'HealthService.getAllHealthData'.
      final healthData = await HealthService.getAllHealthData(
                                             ^^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:78:10: Error: 'HealthDataPoint' isn't a type.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:105:70: Error: 'HealthDataPoint' isn't a type.
  static Future<double> _calculateHabitHealthScore(Habit habit, List<HealthDataPoint> healthData) async {
                                                                     ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:140:10: Error: 'HealthDataPoint' isn't a type.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:184:10: Error: 'HealthDataPoint' isn't a type.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:191:40: Error: 'HealthDataPoint' isn't a type.
    final healthByType = <String, List<HealthDataPoint>>{};
                                       ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:225:10: Error: 'HealthDataPoint' isn't a type.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:232:38: Error: 'HealthDataPoint' isn't a type.
    final dataByType = <String, List<HealthDataPoint>>{};
                                     ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:257:28: Error: 'NumericHealthValue' isn't a type.
        if (point.value is NumericHealthValue) {
                           ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:258:41: Error: 'NumericHealthValue' isn't a type.
          final value = (point.value as NumericHealthValue).numericValue;
                                        ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:251:29: Error: The getter 'dateFrom' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'dateFrom'.
      data.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));
                            ^^^^^^^^
lib/services/health_habit_analytics_service.dart:251:50: Error: The getter 'dateFrom' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'dateFrom'.
      data.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));
                                                 ^^^^^^^^
lib/services/health_habit_analytics_service.dart:296:10: Error: 'HealthDataPoint' isn't a type.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:351:10: Error: 'HealthDataPoint' isn't a type.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:407:10: Error: 'HealthDataPoint' isn't a type.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:449:10: Error: 'HealthDataPoint' isn't a type.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:492:76: Error: 'HealthDataPoint' isn't a type.
  static Future<double> _calculateHabitHealthCorrelation(Habit habit, List<HealthDataPoint> healthData) async {
                                                                           ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:507:26: Error: 'NumericHealthValue' isn't a type.
      if (point.value is NumericHealthValue) {
                         ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:508:70: Error: 'NumericHealthValue' isn't a type.
        healthByDay[day] = (healthByDay[day] ?? 0) + (point.value as NumericHealthValue).numericValue;
                                                                     ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:539:48: Error: 'HealthDataPoint' isn't a type.
  static double _calculateDataConsistency(List<HealthDataPoint> healthData) {
                                               ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:560:71: Error: 'HealthDataPoint' isn't a type.
  static Future<String?> _findStrongestHealthMetric(Habit habit, List<HealthDataPoint> healthData) async {
                                                                      ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:564:38: Error: 'HealthDataPoint' isn't a type.
    final dataByType = <String, List<HealthDataPoint>>{};
                                     ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:593:19: Error: 'HealthDataPoint' isn't a type.
    required List<HealthDataPoint> healthData,
                  ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:621:71: Error: 'HealthDataPoint' isn't a type.
  static Future<double> _calculateHealthImpactScore(Habit habit, List<HealthDataPoint> healthData) async {
                                                                      ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:626:75: Error: 'HealthDataPoint' isn't a type.
  static Future<double> _calculateOptimizationPotential(Habit habit, List<HealthDataPoint> healthData) async {
                                                                          ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:648:67: Error: 'HealthDataPoint' isn't a type.
  static Future<double> _predictHabitCompletion(Habit habit, List<HealthDataPoint> healthData) async {
                                                                  ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:666:66: Error: 'HealthDataPoint' isn't a type.
  static double _calculatePredictionConfidence(Habit habit, List<HealthDataPoint> healthData) {
                                                                 ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:685:68: Error: 'HealthDataPoint' isn't a type.
  static Future<DateTime?> _predictOptimalTiming(Habit habit, List<HealthDataPoint> healthData) async {
                                                                   ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:704:86: Error: 'HealthDataPoint' isn't a type.
  static Future<Map<String, dynamic>> _calculateUserMetrics(List<Habit> habits, List<HealthDataPoint> healthData) async {
                                                                                     ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:771:10: Error: 'HealthDataPoint' isn't a type.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:777:38: Error: 'HealthDataPoint' isn't a type.
    final dataByType = <String, List<HealthDataPoint>>{};
                                     ^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:805:59: Error: 'NumericHealthValue' isn't a type.
        if (isInPeriod == duringStreaks && point.value is NumericHealthValue) {
                                                          ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:806:44: Error: 'NumericHealthValue' isn't a type.
          relevantData.add((point.value as NumericHealthValue).numericValue.toDouble());
                                           ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:14:20: Error: 'HealthDataType' isn't a type.
  static const Map<HealthDataType, HealthHabitMapping> healthMappings = {
                   ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:251:24: Error: 'HealthDataType' isn't a type.
      final matches = <HealthDataType, double>{};
                       ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:291:11: Error: 'HealthDataType' isn't a type.
          HealthDataType? inferredType;
          ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:296:28: Error: Undefined name 'HealthDataType'.
            inferredType = HealthDataType.STEPS;
                           ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:299:28: Error: Undefined name 'HealthDataType'.
            inferredType = HealthDataType.SLEEP_IN_BED;
                           ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:302:28: Error: Undefined name 'HealthDataType'.
            inferredType = HealthDataType.WATER;
                           ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:308:28: Error: Undefined name 'HealthDataType'.
            inferredType = HealthDataType.WEIGHT;
                           ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:311:28: Error: Undefined name 'HealthDataType'.
            inferredType = HealthDataType.MINDFULNESS;
                           ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:314:28: Error: Undefined name 'HealthDataType'.
            inferredType = HealthDataType.STEPS;
                           ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:317:28: Error: Undefined name 'HealthDataType'.
            inferredType = HealthDataType.STEPS;
                           ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:424:46: Error: Member not found: 'HealthService.getHealthDataFromTypes'.
      final healthData = await HealthService.getHealthDataFromTypes(
                                             ^^^^^^^^^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:432:39: Error: Undefined name 'HealthDataType'.
        if (mapping.healthDataType == HealthDataType.WEIGHT) {
                                      ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:447:39: Error: Undefined name 'HealthDataType'.
        if (mapping.healthDataType == HealthDataType.WATER) {
                                      ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:465:28: Error: 'NumericHealthValue' isn't a type.
        if (point.value is NumericHealthValue) {
                           ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:466:41: Error: 'NumericHealthValue' isn't a type.
          final value = (point.value as NumericHealthValue).numericValue;
                                        ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:470:18: Error: Undefined name 'HealthDataType'.
            case HealthDataType.SLEEP_IN_BED:
                 ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:474:18: Error: Undefined name 'HealthDataType'.
            case HealthDataType.WEIGHT:
                 ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:523:12: Error: Undefined name 'HealthDataType'.
      case HealthDataType.STEPS:
           ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:532:12: Error: Undefined name 'HealthDataType'.
      case HealthDataType.ACTIVE_ENERGY_BURNED:
           ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:541:12: Error: Undefined name 'HealthDataType'.
      case HealthDataType.SLEEP_IN_BED:
           ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:551:12: Error: Undefined name 'HealthDataType'.
      case HealthDataType.WATER:
           ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:561:12: Error: Undefined name 'HealthDataType'.
      case HealthDataType.MINDFULNESS:
           ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:570:12: Error: Undefined name 'HealthDataType'.
      case HealthDataType.WEIGHT:
           ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:621:26: Error: 'HealthDataType' isn't a type.
    final activeTypes = <HealthDataType>{};
                         ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:636:14: Error: 'HealthDataType' isn't a type.
    required HealthDataType healthDataType,
             ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:643:46: Error: Member not found: 'HealthService.getHealthDataFromTypes'.
      final healthData = await HealthService.getHealthDataFromTypes(
                                             ^^^^^^^^^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:661:28: Error: 'NumericHealthValue' isn't a type.
        if (point.value is NumericHealthValue) {
                           ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:662:35: Error: 'NumericHealthValue' isn't a type.
          value = (point.value as NumericHealthValue).numericValue.toDouble();
                                  ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:665:33: Error: Undefined name 'HealthDataType'.
          if (healthDataType == HealthDataType.SLEEP_IN_BED) {
                                ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:811:61: Error: 'HealthDataType' isn't a type.
  static double? _extractCustomThreshold(String searchText, HealthDataType healthType) {
                                                            ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:817:14: Error: Undefined name 'HealthDataType'.
        case HealthDataType.STEPS:
             ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:832:14: Error: Undefined name 'HealthDataType'.
        case HealthDataType.ACTIVE_ENERGY_BURNED:
             ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:839:14: Error: Undefined name 'HealthDataType'.
        case HealthDataType.WATER:
             ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:847:14: Error: Undefined name 'HealthDataType'.
        case HealthDataType.MINDFULNESS:
             ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:854:14: Error: Undefined name 'HealthDataType'.
        case HealthDataType.SLEEP_IN_BED:
             ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:873:20: Error: Undefined name 'HealthDataType'.
              case HealthDataType.WATER:
                   ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:879:20: Error: Undefined name 'HealthDataType'.
              case HealthDataType.SLEEP_IN_BED:
                   ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:915:9: Error: 'HealthDataType' isn't a type.
  final HealthDataType healthDataType;
        ^^^^^^^^^^^^^^
lib/services/health_habit_mapping_service.dart:949:9: Error: 'HealthDataType' isn't a type.
  final HealthDataType? healthDataType;
        ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:35:46: Error: Member not found: 'HealthService.getAllHealthData'.
      final healthData = await HealthService.getAllHealthData(
                                             ^^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:76:5: Error: 'HealthDataType' isn't a type.
    HealthDataType? healthDataType,
    ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:179:46: Error: Member not found: 'HealthService.getAllHealthData'.
      final healthData = await HealthService.getAllHealthData(
                                             ^^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:231:10: Error: 'HealthDataPoint' isn't a type.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:236:57: Error: Undefined name 'HealthDataType'.
    final stepsData = healthData.where((p) => p.type == HealthDataType.STEPS).toList();
                                                        ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:243:37: Error: 'NumericHealthValue' isn't a type.
      final value = (point.value as NumericHealthValue).numericValue;
                                    ^^^^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:259:25: Error: Undefined name 'HealthDataType'.
        healthDataType: HealthDataType.STEPS,
                        ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:273:25: Error: Undefined name 'HealthDataType'.
        healthDataType: HealthDataType.STEPS,
                        ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:290:25: Error: Undefined name 'HealthDataType'.
        healthDataType: HealthDataType.STEPS,
                        ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:236:49: Error: The getter 'type' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'type'.
    final stepsData = healthData.where((p) => p.type == HealthDataType.STEPS).toList();
                                                ^^^^
lib/services/health_enhanced_habit_creation_service.dart:305:10: Error: 'HealthDataPoint' isn't a type.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:310:58: Error: Undefined name 'HealthDataType'.
    final energyData = healthData.where((p) => p.type == HealthDataType.ACTIVE_ENERGY_BURNED).toList();
                                                         ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:317:37: Error: 'NumericHealthValue' isn't a type.
      final value = (point.value as NumericHealthValue).numericValue;
                                    ^^^^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:332:25: Error: Undefined name 'HealthDataType'.
        healthDataType: HealthDataType.ACTIVE_ENERGY_BURNED,
                        ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:346:25: Error: Undefined name 'HealthDataType'.
        healthDataType: HealthDataType.ACTIVE_ENERGY_BURNED,
                        ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:310:50: Error: The getter 'type' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'type'.
    final energyData = healthData.where((p) => p.type == HealthDataType.ACTIVE_ENERGY_BURNED).toList();
                                                 ^^^^
lib/services/health_enhanced_habit_creation_service.dart:361:10: Error: 'HealthDataPoint' isn't a type.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:366:57: Error: Undefined name 'HealthDataType'.
    final sleepData = healthData.where((p) => p.type == HealthDataType.SLEEP_IN_BED).toList();
                                                        ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:373:45: Error: 'NumericHealthValue' isn't a type.
      final durationHours = (point.value as NumericHealthValue).numericValue / 60.0; // Convert minutes to hours
                                            ^^^^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:389:25: Error: Undefined name 'HealthDataType'.
        healthDataType: HealthDataType.SLEEP_IN_BED,
                        ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:405:25: Error: Undefined name 'HealthDataType'.
        healthDataType: HealthDataType.SLEEP_IN_BED,
                        ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:366:49: Error: The getter 'type' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'type'.
    final sleepData = healthData.where((p) => p.type == HealthDataType.SLEEP_IN_BED).toList();
                                                ^^^^
lib/services/health_enhanced_habit_creation_service.dart:420:10: Error: 'HealthDataPoint' isn't a type.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:425:57: Error: Undefined name 'HealthDataType'.
    final waterData = healthData.where((p) => p.type == HealthDataType.WATER).toList();
                                                        ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:432:37: Error: 'NumericHealthValue' isn't a type.
      final value = (point.value as NumericHealthValue).numericValue;
                                    ^^^^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:447:25: Error: Undefined name 'HealthDataType'.
        healthDataType: HealthDataType.WATER,
                        ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:425:49: Error: The getter 'type' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'type'.
    final waterData = healthData.where((p) => p.type == HealthDataType.WATER).toList();
                                                ^^^^
lib/services/health_enhanced_habit_creation_service.dart:462:10: Error: 'HealthDataPoint' isn't a type.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:467:63: Error: Undefined name 'HealthDataType'.
    final mindfulnessData = healthData.where((p) => p.type == HealthDataType.MINDFULNESS).toList();
                                                              ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:476:25: Error: Undefined name 'HealthDataType'.
        healthDataType: HealthDataType.MINDFULNESS,
                        ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:491:37: Error: 'NumericHealthValue' isn't a type.
      final value = (point.value as NumericHealthValue).numericValue;
                                    ^^^^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:504:25: Error: Undefined name 'HealthDataType'.
        healthDataType: HealthDataType.MINDFULNESS,
                        ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:467:55: Error: The getter 'type' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'type'.
    final mindfulnessData = healthData.where((p) => p.type == HealthDataType.MINDFULNESS).toList();
                                                      ^^^^
lib/services/health_enhanced_habit_creation_service.dart:519:10: Error: 'HealthDataPoint' isn't a type.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:524:58: Error: Undefined name 'HealthDataType'.
    final weightData = healthData.where((p) => p.type == HealthDataType.WEIGHT).toList();
                                                         ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:533:25: Error: Undefined name 'HealthDataType'.
        healthDataType: HealthDataType.WEIGHT,
                        ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:558:25: Error: Undefined name 'HealthDataType'.
        healthDataType: HealthDataType.WEIGHT,
                        ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:524:50: Error: The getter 'type' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'type'.
    final weightData = healthData.where((p) => p.type == HealthDataType.WEIGHT).toList();
                                                 ^^^^
lib/services/health_enhanced_habit_creation_service.dart:546:18: Error: The getter 'dateFrom' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'dateFrom'.
      DateTime(p.dateFrom.year, p.dateFrom.month, p.dateFrom.day)
                 ^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:546:35: Error: The getter 'dateFrom' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'dateFrom'.
      DateTime(p.dateFrom.year, p.dateFrom.month, p.dateFrom.day)
                                  ^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:546:53: Error: The getter 'dateFrom' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'dateFrom'.
      DateTime(p.dateFrom.year, p.dateFrom.month, p.dateFrom.day)
                                                    ^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:592:25: Error: Undefined name 'HealthDataType'.
        healthDataType: HealthDataType.STEPS,
                        ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:605:25: Error: Undefined name 'HealthDataType'.
        healthDataType: HealthDataType.WATER,
                        ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:618:25: Error: Undefined name 'HealthDataType'.
        healthDataType: HealthDataType.MINDFULNESS,
                        ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:632:14: Error: 'HealthDataType' isn't a type.
    required HealthDataType healthDataType,
             ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:680:10: Error: 'HealthDataPoint' isn't a type.
    List<HealthDataPoint> healthData,
         ^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:683:23: Error: 'HealthDataType' isn't a type.
    final patterns = <HealthDataType, HealthPatternAnalysis>{};
                      ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:685:30: Error: Undefined name 'HealthDataType'.
    for (final healthType in HealthDataType.values) {
                             ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:686:50: Error: The getter 'type' isn't defined for the class 'Object?'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'type'.
      final typeData = healthData.where((p) => p.type == healthType).toList();
                                                 ^^^^
lib/services/health_enhanced_habit_creation_service.dart:698:10: Error: 'HealthDataPoint' isn't a type.
    List<HealthDataPoint> data,
         ^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:705:37: Error: 'NumericHealthValue' isn't a type.
      final value = (point.value as NumericHealthValue).numericValue;
                                    ^^^^^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:749:36: Error: 'HealthDataType' isn't a type.
  static double _getBenchmarkValue(HealthDataType type) {
                                   ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:751:12: Error: Undefined name 'HealthDataType'.
      case HealthDataType.STEPS:
           ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:753:12: Error: Undefined name 'HealthDataType'.
      case HealthDataType.ACTIVE_ENERGY_BURNED:
           ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:755:12: Error: Undefined name 'HealthDataType'.
      case HealthDataType.SLEEP_IN_BED:
           ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:757:12: Error: Undefined name 'HealthDataType'.
      case HealthDataType.WATER:
           ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:759:12: Error: Undefined name 'HealthDataType'.
      case HealthDataType.MINDFULNESS:
           ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:761:12: Error: Undefined name 'HealthDataType'.
      case HealthDataType.WEIGHT:
           ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:769:60: Error: 'HealthDataType' isn't a type.
  static Future<bool> _hasRelatedHabit(List<Habit> habits, HealthDataType healthType) async {
                                                           ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:781:5: Error: 'HealthDataType' isn't a type.
    HealthDataType healthType,
    ^^^^^^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:803:9: Error: 'HealthDataType' isn't a type.
  final HealthDataType healthDataType;
        ^^^^^^^^^^^^^^
lib/services/health_habit_ui_service.dart:769:46: Error: Member not found: 'HealthService.getAllHealthData'.
      final healthData = await HealthService.getAllHealthData(
                                             ^^^^^^^^^^^^^^^^
lib/services/health_habit_ui_service.dart:790:28: Error: 'NumericHealthValue' isn't a type.
        if (point.value is NumericHealthValue) {
                           ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_ui_service.dart:794:55: Error: 'NumericHealthValue' isn't a type.
          healthByType[typeName]!.add((point.value as NumericHealthValue).numericValue.toDouble());
                                                      ^^^^^^^^^^^^^^^^^^
Unhandled exception:
FileSystemException(uri=org-dartlang-untranslatable-uri:package%3Ahealth%2Fhealth.dart; message=StandardFileSystem only supports file:* and data:* URIs)
#0      StandardFileSystem.entityForUri (package:front_end/src/api_prototype/standard_file_system.dart:45)
#1      asFileUri (package:vm/kernel_front_end.dart:984)
#2      writeDepfile (package:vm/kernel_front_end.dart:1147)
<asynchronous suspension>
#3      FrontendCompiler.compile (package:frontend_server/frontend_server.dart:713)
<asynchronous suspension>
#4      starter (package:frontend_server/starter.dart:109)
<asynchronous suspension>
#5      main (file:///C:/b/s/w/ir/x/w/sdk/pkg/frontend_server/bin/frontend_server_starter.dart:13)
<asynchronous suspension>

Target kernel_snapshot_program failed: Exception