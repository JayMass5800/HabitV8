I/MinimalHealthPlugin(25231): Granted permissions (9):
I/MinimalHealthPlugin(25231):   - android.permission.health.READ_STEPS
I/MinimalHealthPlugin(25231):   - android.permission.health.READ_ACTIVE_CALORIES_BURNED
I/MinimalHealthPlugin(25231):   - android.permission.health.READ_SLEEP
I/MinimalHealthPlugin(25231):   - android.permission.health.READ_HYDRATION
I/MinimalHealthPlugin(25231):   - android.permission.health.READ_MINDFULNESS
I/MinimalHealthPlugin(25231):   - android.permission.health.READ_WEIGHT
I/MinimalHealthPlugin(25231):   - android.permission.health.READ_HEART_RATE
I/MinimalHealthPlugin(25231):   - android.permission.health.READ_HEALTH_DATA_IN_BACKGROUND
I/MinimalHealthPlugin(25231):   - android.permission.health.READ_TOTAL_CALORIES_BURNED
I/MinimalHealthPlugin(25231): Required permissions (7):
I/MinimalHealthPlugin(25231):   - android.permission.health.READ_STEPS: GRANTED
I/MinimalHealthPlugin(25231):   - android.permission.health.READ_ACTIVE_CALORIES_BURNED: GRANTED
I/MinimalHealthPlugin(25231):   - android.permission.health.READ_TOTAL_CALORIES_BURNED: GRANTED
I/MinimalHealthPlugin(25231):   - android.permission.health.READ_SLEEP: GRANTED
I/MinimalHealthPlugin(25231):   - android.permission.health.READ_HYDRATION: GRANTED
I/MinimalHealthPlugin(25231):   - android.permission.health.READ_WEIGHT: GRANTED
I/MinimalHealthPlugin(25231):   - android.permission.health.READ_HEART_RATE: GRANTED
I/MinimalHealthPlugin(25231): Heart rate permission: GRANTED
I/MinimalHealthPlugin(25231): Background permission: GRANTED
I/MinimalHealthPlugin(25231): All permissions granted: true
I/flutter (25231): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (25231): │ #1   MinimalHealthChannel.hasPermissions (package:habitv8/services/minimal_health_channel.dart:157:17)
I/flutter (25231): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25231): │ 💡 Health permissions status: true
I/flutter (25231): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (25231): │ #1   HealthService.hasPermissions (package:habitv8/services/health_service.dart:385:17)
I/flutter (25231): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25231): │ 💡 Health permissions check result: true
I/flutter (25231): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (25231): │ #1   _InsightsScreenState._loadAllData.<anonymous closure> (package:habitv8/ui/screens/insights_screen.dart:165:27)
I/flutter (25231): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25231): │ 💡 Integration status loaded successfully
I/flutter (25231): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
E/MinimalHealthPlugin(25231): FORBIDDEN DATA TYPE DETECTED: MINDFULNESS
I/flutter (25231): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): │ PlatformException(FORBIDDEN_DATA_TYPE, Data type MINDFULNESS is not allowed, null, null)
I/flutter (25231): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25231): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (25231): │ #1   MinimalHealthChannel.initialize (package:habitv8/services/minimal_health_channel.dart:70:17)
I/flutter (25231): │ #2   <asynchronous suspension>
I/flutter (25231): │ #3   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:249:7)
I/flutter (25231): │ #4   <asynchronous suspension>
I/flutter (25231): │ #5   HealthService.getActiveCaloriesToday (package:habitv8/services/health_service.dart:640:20)
I/flutter (25231): │ #6   <asynchronous suspension>
I/flutter (25231): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25231): │ ⛔ Platform error initializing MinimalHealthChannel: FORBIDDEN_DATA_TYPE - Data type MINDFULNESS is not allowed
I/flutter (25231): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (25231): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:259:17)
I/flutter (25231): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25231): │ 💡 Fetching health data for ACTIVE_ENERGY_BURNED from 2025-08-26T00:00:00.000 to 2025-08-27T00:00:00.000
I/flutter (25231): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
E/MinimalHealthPlugin(25231): FORBIDDEN DATA TYPE DETECTED: MINDFULNESS
I/flutter (25231): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): │ PlatformException(FORBIDDEN_DATA_TYPE, Data type MINDFULNESS is not allowed, null, null)
I/flutter (25231): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25231): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (25231): │ #1   MinimalHealthChannel.initialize (package:habitv8/services/minimal_health_channel.dart:70:17)
I/flutter (25231): │ #2   <asynchronous suspension>
I/flutter (25231): │ #3   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:249:7)
I/flutter (25231): │ #4   <asynchronous suspension>
I/flutter (25231): │ #5   HealthService.getTotalCaloriesToday (package:habitv8/services/health_service.dart:702:20)
I/flutter (25231): │ #6   <asynchronous suspension>
I/flutter (25231): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25231): │ ⛔ Platform error initializing MinimalHealthChannel: FORBIDDEN_DATA_TYPE - Data type MINDFULNESS is not allowed
I/flutter (25231): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (25231): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:259:17)
I/flutter (25231): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25231): │ 💡 Fetching health data for TOTAL_CALORIES_BURNED from 2025-08-26T00:00:00.000 to 2025-08-27T00:00:00.000
I/flutter (25231): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
E/MinimalHealthPlugin(25231): FORBIDDEN DATA TYPE DETECTED: MINDFULNESS
D/CompatChangeReporter(25231): Compat change id reported: 263076149; UID 10451; state: ENABLED
I/flutter (25231): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): │ PlatformException(FORBIDDEN_DATA_TYPE, Data type MINDFULNESS is not allowed, null, null)
I/flutter (25231): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25231): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (25231): │ #1   MinimalHealthChannel.initialize (package:habitv8/services/minimal_health_channel.dart:70:17)
I/flutter (25231): │ #2   <asynchronous suspension>
I/flutter (25231): │ #3   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:249:7)
I/flutter (25231): │ #4   <asynchronous suspension>
I/flutter (25231): │ #5   MinimalHealthChannel.getSleepHoursLastNight (package:habitv8/services/minimal_health_channel.dart:463:20)
I/flutter (25231): │ #6   <asynchronous suspension>
I/flutter (25231): │ #7   HealthService.getSleepHoursLastNight (package:habitv8/services/health_service.dart:755:11)
I/flutter (25231): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25231): │ ⛔ Platform error initializing MinimalHealthChannel: FORBIDDEN_DATA_TYPE - Data type MINDFULNESS is not allowed
I/flutter (25231): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (25231): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:259:17)
I/flutter (25231): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25231): │ 💡 Fetching health data for SLEEP_IN_BED from 2025-08-24T18:00:00.000 to 2025-08-26T09:34:48.987817
I/flutter (25231): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
E/MinimalHealthPlugin(25231): FORBIDDEN DATA TYPE DETECTED: MINDFULNESS
I/flutter (25231): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): │ PlatformException(FORBIDDEN_DATA_TYPE, Data type MINDFULNESS is not allowed, null, null)
I/flutter (25231): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25231): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (25231): │ #1   MinimalHealthChannel.initialize (package:habitv8/services/minimal_health_channel.dart:70:17)
I/flutter (25231): │ #2   <asynchronous suspension>
I/flutter (25231): │ #3   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:249:7)
I/flutter (25231): │ #4   <asynchronous suspension>
I/flutter (25231): │ #5   MinimalHealthChannel.getLatestHeartRate (package:habitv8/services/minimal_health_channel.dart:679:22)
I/flutter (25231): │ #6   <asynchronous suspension>
I/flutter (25231): │ #7   HealthService.getLatestHeartRate (package:habitv8/services/health_service.dart:935:33)
I/flutter (25231): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25231): │ ⛔ Platform error initializing MinimalHealthChannel: FORBIDDEN_DATA_TYPE - Data type MINDFULNESS is not allowed
I/flutter (25231): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (25231): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:259:17)
I/flutter (25231): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25231): │ 💡 Fetching health data for HEART_RATE from 2025-08-26T07:34:48.995884 to 2025-08-26T09:34:48.995884
I/flutter (25231): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(25231): Retrieved 0 records for WATER from 2025-08-26T07:00:00Z to 2025-08-27T07:00:00Z
I/flutter (25231): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (25231): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:280:17)
I/flutter (25231): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25231): │ 💡 Retrieved 0 records for WATER
I/flutter (25231): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (25231): │ #1   MinimalHealthChannel.getWaterIntakeToday (package:habitv8/services/minimal_health_channel.dart:594:17)
I/flutter (25231): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25231): │ 💡 Water intake today: 0ml
I/flutter (25231): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (25231): │ #1   HealthService.getWaterIntakeToday (package:habitv8/services/health_service.dart:848:17)
I/flutter (25231): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25231): │ 💡 Retrieved water intake data: 0ml
I/flutter (25231): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(25231): Retrieved 0 records for WEIGHT from 2025-08-19T16:34:48.959Z to 2025-08-26T16:34:48.959Z
I/flutter (25231): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (25231): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:280:17)
I/flutter (25231): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25231): │ 💡 Retrieved 0 records for WEIGHT
I/flutter (25231): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (25231): │ #1   MinimalHealthChannel.getLatestWeight (package:habitv8/services/minimal_health_channel.dart:641:19)
I/flutter (25231): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25231): │ 💡 No weight data found in the last week
I/flutter (25231): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (25231): │ #1   HealthService.getLatestWeight (package:habitv8/services/health_service.dart:886:19)
I/flutter (25231): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25231): │ 💡 No weight data available
I/flutter (25231): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(25231): Retrieved 0 records for HEART_RATE from 2025-08-26T07:00:00Z to 2025-08-26T16:34:48.960Z
I/flutter (25231): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (25231): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:280:17)
I/flutter (25231): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25231): │ 💡 Retrieved 0 records for HEART_RATE
I/flutter (25231): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25231): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (25231): │ #1   MinimalHealthChannel.initialize (package:habitv8/services/minimal_health_channel.dart:37:17)
I/flutter (25231): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25231): │ 💡 Initializing MinimalHealthChannel...
I/flutter (25231): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
E/AndroidRuntime(25231): FATAL EXCEPTION: main
E/AndroidRuntime(25231): Process: com.habittracker.habitv8.debug, PID: 25231
E/AndroidRuntime(25231): java.lang.NoSuchMethodError: No virtual method getStartZoneOffset()Lj$/time/ZoneOffset; in class Landroid/health/connect/datatypes/StepsRecord; or its super classes (declaration of 'android.health.connect.datatypes.StepsRecord' appears in /apex/com.android.healthfitness/javalib/framework-healthfitness.jar)
E/AndroidRuntime(25231):        at androidx.health.connect.client.impl.platform.records.RecordConvertersKt$$ExternalSyntheticAPIConversion97.m(D8$$SyntheticClass:0)
E/AndroidRuntime(25231):        at androidx.health.connect.client.impl.platform.records.RecordConvertersKt.toSdkStepsRecord(RecordConverters.kt:519)
E/AndroidRuntime(25231):        at androidx.health.connect.client.impl.platform.records.RecordConvertersKt.toSdkRecord(RecordConverters.kt:155)
E/AndroidRuntime(25231):        at androidx.health.connect.client.impl.HealthConnectClientUpsideDownImpl.readRecords(HealthConnectClientUpsideDownImpl.kt:198)
E/AndroidRuntime(25231):        at androidx.health.connect.client.impl.HealthConnectClientUpsideDownImpl$readRecords$1.invokeSuspend(Unknown Source:15)
E/AndroidRuntime(25231):        at kotlin.coroutines.jvm.internal.BaseContinuationImpl.resumeWith(ContinuationImpl.kt:33)
E/AndroidRuntime(25231):        at kotlinx.coroutines.DispatchedTask.run(DispatchedTask.kt:108)
E/AndroidRuntime(25231):        at android.os.Handler.handleCallback(Handler.java:995)
E/AndroidRuntime(25231):        at android.os.Handler.dispatchMessage(Handler.java:103)
E/AndroidRuntime(25231):        at android.os.Looper.loopOnce(Looper.java:248)
E/AndroidRuntime(25231):        at android.os.Looper.loop(Looper.java:338)
E/AndroidRuntime(25231):        at android.app.ActivityThread.main(ActivityThread.java:9067)
E/AndroidRuntime(25231):        at java.lang.reflect.Method.invoke(Native Method)
E/AndroidRuntime(25231):        at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
E/AndroidRuntime(25231):        at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:932)
E/AndroidRuntime(25231):        Suppressed: kotlinx.coroutines.internal.DiagnosticCoroutineContextException: [StandaloneCoroutine{Cancelling}@8ff0289, Dispatchers.Main]
I/Process (25231): Sending signal. PID: 25231 SIG: 9
Lost connection to device.