PS C:\HabitV8> flutter build apk
Cleaning up health permissions for release
Adding critical health permissions for release
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin.kt:46:7 Redeclaration:
class MinimalHealthPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener
class MinimalHealthPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin.kt:284:51 Unresolved reference 'createRequestPermissionResultContract'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin.kt:487:80 Unresolved reference 'ENERGY_TOTAL'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin.kt:491:33 Cannot infer type for this parameter. Please specify it explicitly.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin.kt:491:33 Not enough information to infer type argument for 'T'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin.kt:491:78 Unresolved reference 'ENERGY_TOTAL'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin.kt:491:93 Unresolved reference 'inCalories'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:46:7 Redeclaration:
class MinimalHealthPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener
class MinimalHealthPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:187:9 Unresolved reference 'initializeHealthConnectClient'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:227:21 Unresolved reference 'checkHealthConnectVersionCompatibility'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:383:17 Unresolved reference 'initialize'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:389:36 Argument type mismatch: actual type is 'io.flutter.plugin.common.MethodCall', but 'io.flutter.plugin.common.MethodChannel.Result' was expected.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:389:42 Too many arguments for 'fun requestPermissions(result: MethodChannel.Result): Unit'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:392:17 Unresolved reference 'getHealthData'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:395:17 Unresolved reference 'diagnoseHealthConnect'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:398:17 Unresolved reference 'checkHealthConnectAvailability'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:401:17 Unresolved reference 'getHealthConnectStatus'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:404:17 Unresolved reference 'startBackgroundMonitoring'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:407:17 Unresolved reference 'stopBackgroundMonitoring'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:410:17 Unresolved reference 'isBackgroundMonitoringActive'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:413:17 Unresolved reference 'requestExactAlarmPermission'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:416:17 Unresolved reference 'hasExactAlarmPermission'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:419:17 Unresolved reference 'getTotalCaloriesToday'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:422:17 Unresolved reference 'getSleepHoursLastNight'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:425:17 Unresolved reference 'getWaterIntakeToday'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:428:17 Unresolved reference 'getMindfulnessMinutesToday'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:431:17 Unresolved reference 'getLatestWeight'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:434:17 Unresolved reference 'getLatestHeartRate'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:437:17 Unresolved reference 'getRestingHeartRateToday'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:440:17 Unresolved reference 'getHeartRateData'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:443:17 Unresolved reference 'hasBackgroundHealthDataAccess'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:446:17 Unresolved reference 'getSupportedDataTypes'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:449:17 Unresolved reference 'getServiceStatus'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:452:17 Unresolved reference 'runNativeHealthConnectDiagnostics'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:455:17 Unresolved reference 'checkHealthConnectCompatibility'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:804:13 Unresolved reference 'initializeHealthConnectClient'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:867:13 Unresolved reference 'initializeHealthConnectClient'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:953:40 Unresolved reference 'checkDataTypeCompatibility'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:970:38 Unresolved reference 'readHealthRecordsCompatible'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:984:21 'if' must have both main and 'else' branches when used as an expression.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:995:78 Unresolved reference 'response'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1002:29 Unresolved reference 'response'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1011:42 Unresolved reference 'response'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1011:79 Cannot infer type for this parameter. Please specify it explicitly.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1011:86 Cannot infer type for this parameter. Please specify it explicitly.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1013:55 Unresolved reference 'convertRecordToMap'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1018:87 Cannot infer type for this parameter. Please specify it explicitly.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1018:87 'val <T : Any> KClass<T>.javaClass: Class<KClass<T>>' is deprecated. Use 'java' property to get Java class corresponding to this Kotlin class or cast this instance to Any if you really want to get the runtime Java class of this implementation of KClass.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1018:87 Not enough information to infer type argument for 'T'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1025:93 Unresolved reference 'size'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1030:70 Unresolved reference 'it'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1042:73 Unresolved reference 'it'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1055:73 Unresolved reference 'it'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1064:80 Unresolved reference 'it'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1065:73 Unresolved reference 'it'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1066:73 Unresolved reference 'it'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1075:81 Unresolved reference 'it'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1084:74 Unresolved reference 'it'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1101:23 Unresolved reference 'catch'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1101:30 Unresolved reference 'e'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1101:31 Syntax error: Expecting ')'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1101:31 Syntax error: Unexpected tokens (use ';' to separate expressions on the same line).
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1102:115 Unresolved reference 'e'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1102:128 Unresolved reference 'e'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1109:23 Unresolved reference 'catch'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1109:30 Unresolved reference 'e'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1109:31 Syntax error: Expecting ')'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1109:31 Syntax error: Unexpected tokens (use ';' to separate expressions on the same line).
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1109:44 Argument type mismatch: actual type is 'kotlin.Unit', but 'kotlin.Function0<ERROR CLASS: Unknown return lambda parameter type>' was expected.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1111:44 Unresolved reference 'e'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1121:50 Unresolved reference 'e'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1133:35 Type mismatch: inferred type is 'ERROR CLASS: Unresolved name: e', but 'kotlin.Throwable' was expected.   
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1133:35 Unresolved reference 'e'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1216:43 Unresolved reference 'convertRecordToMapSafe'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1244:37 Unresolved reference 'getRecordStartTimeSafe'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1250:37 Unresolved reference 'getRecordStartTimeSafe'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1256:37 Unresolved reference 'getRecordStartTimeSafe'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1262:37 Unresolved reference 'getRecordStartTimeSafe'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1268:37 Unresolved reference 'getRecordStartTimeSafe'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1274:37 Unresolved reference 'getRecordStartTimeSafe'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1280:37 Unresolved reference 'getRecordStartTimeSafe'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1281:35 Unresolved reference 'getRecordEndTimeSafe'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1289:37 Unresolved reference 'getRecordStartTimeSafe'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1371:25 Unresolved reference 'getRecordStartTimeSafe'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1383:17 Unresolved reference 'getRecordStartTimeSafe'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1387:13 Unresolved reference 'getRecordStartTimeSafe'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:1962:21 Unresolved reference 'initializeHealthConnectClient'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:2082:9 Unresolved reference 'getTodayHealthData'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:2086:9 Unresolved reference 'getLastNightSleepData'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:2090:9 Unresolved reference 'getTodayHealthData'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:2094:9 Unresolved reference 'getTodayHealthData'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:2108:9 Unresolved reference 'getTodayHealthData'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:2122:9 Unresolved reference 'getHeartRateDataWithFallback'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:2246:34 Unresolved reference '_supportedDataTypes'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:2253:47 Unresolved reference '_supportedDataTypes'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:2262:9 Unresolved reference 'diagnoseHealthConnect'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:2478:80 Unresolved reference 'ENERGY_TOTAL'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:2482:33 Cannot infer type for this parameter. Please specify it explicitly.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:2482:33 Not enough information to infer type argument for 'T'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:2482:78 Unresolved reference 'ENERGY_TOTAL'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:2482:93 Unresolved reference 'inCalories'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_backup.kt:2620:6 Syntax error: Missing '}.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_new.kt:46:7 Redeclaration:
class MinimalHealthPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener
class MinimalHealthPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_new.kt:284:51 Unresolved reference 'createRequestPermissionResultContract'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_new.kt:487:80 Unresolved reference 'ENERGY_TOTAL'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_new.kt:491:33 Cannot infer type for this parameter. Please specify it explicitly.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_new.kt:491:33 Not enough information to infer type argument for 'T'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_new.kt:491:78 Unresolved reference 'ENERGY_TOTAL'.
e: file:///C:/HabitV8/android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin_new.kt:491:93 Unresolved reference 'inCalories'.

FAILURE: Build failed with an exception.
