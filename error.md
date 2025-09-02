I/MinimalHealthPlugin(17736): getHealthData called with:
I/MinimalHealthPlugin(17736):   - dataType: HEART_RATE
I/MinimalHealthPlugin(17736):   - startDate: 1756769518698 (2025-09-01T23:31:58.698Z)
I/MinimalHealthPlugin(17736):   - endDate: 1756791118698 (2025-09-02T05:31:58.698Z)
I/MinimalHealthPlugin(17736): getHealthData called with:
I/MinimalHealthPlugin(17736):   - dataType: TOTAL_CALORIES_BURNED
I/MinimalHealthPlugin(17736):   - startDate: 1756710000000 (2025-09-01T07:00:00Z)
I/MinimalHealthPlugin(17736):   - endDate: 1756791119065 (2025-09-02T05:31:59.065Z)
I/MinimalHealthPlugin(17736): getHealthData called with:
I/MinimalHealthPlugin(17736):   - dataType: HEART_RATE
I/MinimalHealthPlugin(17736):   - startDate: 1756623600000 (2025-08-31T07:00:00Z)
I/MinimalHealthPlugin(17736):   - endDate: 1756791118718 (2025-09-02T05:31:58.718Z)
D/MinimalHealthPlugin(17736): Checking compatibility for ACTIVE_ENERGY_BURNED (ActiveCaloriesBurnedRecord)
D/MinimalHealthPlugin(17736): ✅ ACTIVE_ENERGY_BURNED compatibility check passed (ZoneOffset methods are supported in modern Health Connect)
D/MinimalHealthPlugin(17736): ✅ ACTIVE_ENERGY_BURNED compatibility check passed
I/MinimalHealthPlugin(17736): Executing Health Connect readRecords request for ACTIVE_ENERGY_BURNED...
I/MinimalHealthPlugin(17736):   Time range: 2025-09-01T07:00:00Z to 2025-09-02T05:31:58.914Z
I/MinimalHealthPlugin(17736):   Duration: 22 hours
I/MinimalHealthPlugin(17736):   Record type: ActiveCaloriesBurnedRecord
I/MinimalHealthPlugin(17736): ⏱️  Starting Health Connect API call at 2025-09-02T05:31:59.117Z
D/MinimalHealthPlugin(17736): Checking compatibility for SLEEP_IN_BED (SleepSessionRecord)
D/MinimalHealthPlugin(17736): ✅ SLEEP_IN_BED compatibility check passed (ZoneOffset methods are supported in modern Health Connect)
D/MinimalHealthPlugin(17736): ✅ SLEEP_IN_BED compatibility check passed
I/MinimalHealthPlugin(17736): Executing Health Connect readRecords request for SLEEP_IN_BED...
I/MinimalHealthPlugin(17736):   Time range: 2025-08-30T01:00:00Z to 2025-09-02T05:31:58.971Z
I/MinimalHealthPlugin(17736):   Duration: 76 hours
I/MinimalHealthPlugin(17736):   Record type: SleepSessionRecord
I/MinimalHealthPlugin(17736): ⏱️  Starting Health Connect API call at 2025-09-02T05:31:59.123Z
I/MinimalHealthPlugin(17736): getHealthData called with:
I/MinimalHealthPlugin(17736):   - dataType: STEPS
I/MinimalHealthPlugin(17736):   - startDate: 1756186319102 (2025-08-26T05:31:59.102Z)
I/MinimalHealthPlugin(17736):   - endDate: 1756791119102 (2025-09-02T05:31:59.102Z)
D/MinimalHealthPlugin(17736): Checking compatibility for HEART_RATE (HeartRateRecord)
D/MinimalHealthPlugin(17736): HEART_RATE compatibility check - allowing with robust error handling
D/MinimalHealthPlugin(17736): ✅ HEART_RATE compatibility check passed (using robust error handling)
I/MinimalHealthPlugin(17736): Executing Health Connect readRecords request for HEART_RATE...
I/MinimalHealthPlugin(17736):   Time range: 2025-09-01T23:31:58.698Z to 2025-09-02T05:31:58.698Z
I/MinimalHealthPlugin(17736):   Duration: 6 hours
I/MinimalHealthPlugin(17736):   Record type: HeartRateRecord
I/MinimalHealthPlugin(17736): ⏱️  Starting Health Connect API call at 2025-09-02T05:31:59.127Z
D/MinimalHealthPlugin(17736): Checking compatibility for TOTAL_CALORIES_BURNED (TotalCaloriesBurnedRecord)
D/MinimalHealthPlugin(17736): ✅ TOTAL_CALORIES_BURNED compatibility check passed (ZoneOffset methods are supported in modern Health Connect)
D/MinimalHealthPlugin(17736): ✅ TOTAL_CALORIES_BURNED compatibility check passed
I/MinimalHealthPlugin(17736): Executing Health Connect readRecords request for TOTAL_CALORIES_BURNED...
I/MinimalHealthPlugin(17736):   Time range: 2025-09-01T07:00:00Z to 2025-09-02T05:31:59.065Z
I/MinimalHealthPlugin(17736):   Duration: 22 hours
I/MinimalHealthPlugin(17736):   Record type: TotalCaloriesBurnedRecord
I/MinimalHealthPlugin(17736): ⏱️  Starting Health Connect API call at 2025-09-02T05:31:59.130Z
D/MinimalHealthPlugin(17736): Checking compatibility for HEART_RATE (HeartRateRecord)
D/MinimalHealthPlugin(17736): HEART_RATE compatibility check - allowing with robust error handling
D/MinimalHealthPlugin(17736): ✅ HEART_RATE compatibility check passed (using robust error handling)
I/MinimalHealthPlugin(17736): Executing Health Connect readRecords request for HEART_RATE...
I/MinimalHealthPlugin(17736):   Time range: 2025-08-31T07:00:00Z to 2025-09-02T05:31:58.718Z
I/MinimalHealthPlugin(17736):   Duration: 46 hours
I/MinimalHealthPlugin(17736):   Record type: HeartRateRecord
I/MinimalHealthPlugin(17736): ⏱️  Starting Health Connect API call at 2025-09-02T05:31:59.134Z
D/MinimalHealthPlugin(17736): Checking compatibility for STEPS (StepsRecord)
D/MinimalHealthPlugin(17736): ✅ STEPS compatibility check passed (ZoneOffset methods are supported in modern Health Connect)
D/MinimalHealthPlugin(17736): ✅ STEPS compatibility check passed
I/MinimalHealthPlugin(17736): Executing Health Connect readRecords request for STEPS...
I/MinimalHealthPlugin(17736):   Time range: 2025-08-26T05:31:59.102Z to 2025-09-02T05:31:59.102Z
I/MinimalHealthPlugin(17736):   Duration: 168 hours
I/MinimalHealthPlugin(17736):   Record type: StepsRecord
I/MinimalHealthPlugin(17736): ⏱️  Starting Health Connect API call at 2025-09-02T05:31:59.138Z
I/MinimalHealthPlugin(17736): ✅ Health Connect readRecords completed successfully!
I/MinimalHealthPlugin(17736):   API call duration: 24ms
I/MinimalHealthPlugin(17736):   Raw records count: 0
W/MinimalHealthPlugin(17736): !  NO RECORDS returned from Health Connect for ACTIVE_ENERGY_BURNED
W/MinimalHealthPlugin(17736):   This could indicate:
W/MinimalHealthPlugin(17736):   1. No data exists in the specified time range
W/MinimalHealthPlugin(17736):   2. Data source app is not syncing to Health Connect
W/MinimalHealthPlugin(17736):   3. Permissions are not properly granted
W/MinimalHealthPlugin(17736):   4. Health Connect version compatibility issues
I/MinimalHealthPlugin(17736): ✅ Successfully processed 0 valid records for ACTIVE_ENERGY_BURNED
I/MinimalHealthPlugin(17736):  Total active calories in range: 0 cal
W/MinimalHealthPlugin(17736): ❌ No active calories records found!
W/MinimalHealthPlugin(17736):   This is the most common issue. Troubleshooting:
W/MinimalHealthPlugin(17736):   1. Check if your smartwatch app (Zepp, Wear OS, etc.) is syncing calories to Health Connect
W/MinimalHealthPlugin(17736):   2. Verify Health Connect has active calories permission
W/MinimalHealthPlugin(17736):   3. Ensure your watch recorded workouts/activities in the time range
W/MinimalHealthPlugin(17736):   4. Check Health Connect app -> Data and access -> Active calories burned
W/MinimalHealthPlugin(17736):   5. Try manually syncing your smartwatch app
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:404:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 ✅ Retrieved 0 records for ACTIVE_ENERGY_BURNED
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:408:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ ! !  NO DATA FOUND for ACTIVE_ENERGY_BURNED in the specified time range
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:410:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 Troubleshooting suggestions:
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:411:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 1. Check if your device/app is syncing data to Health Connect
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:413:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 2. Verify the time range contains actual activity
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:414:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 3. Check Health Connect app for data visibility
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:415:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 4. Ensure permissions are properly granted
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getActiveCaloriesToday (package:habitv8/services/minimal_health_channel.dart:484:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 Received 0 active calories records
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getActiveCaloriesToday (package:habitv8/services/minimal_health_channel.dart:487:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ ! No active calories data found for today
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getActiveCaloriesToday (package:habitv8/services/minimal_health_channel.dart:488:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 Troubleshooting steps for calories data:
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getActiveCaloriesToday (package:habitv8/services/minimal_health_channel.dart:489:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 1. Check if your smartwatch is syncing calories to Health Connect
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getActiveCaloriesToday (package:habitv8/services/minimal_health_channel.dart:492:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 2. Verify your watch app has Health Connect integration enabled
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getActiveCaloriesToday (package:habitv8/services/minimal_health_channel.dart:495:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 3. Check Health Connect app for active energy data visibility
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getActiveCaloriesToday (package:habitv8/services/minimal_health_channel.dart:498:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 4. Ensure your watch is tracking workouts and activities
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getActiveCaloriesToday (package:habitv8/services/minimal_health_channel.dart:501:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 5. Try manually syncing your smartwatch data
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   HealthService.getActiveCaloriesToday (package:habitv8/services/health_service.dart:767:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 Retrieved active calories data: 0 (total from 0 records: 0)
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
E/MinimalHealthPlugin(17736): ❌ Health Connect version compatibility issue for SLEEP_IN_BED after 44ms
E/MinimalHealthPlugin(17736):   NoSuchMethodError: No virtual method getStartZoneOffset()Lj$/time/ZoneOffset; in class Landroid/health/connect/datatypes/SleepSessionRecord; or its super classes (declaration of 'android.health.connect.datatypes.SleepSessionRecord' appears in /apex/com.android.healthfitness/javalib/framework-healthfitness.jar)
E/MinimalHealthPlugin(17736):   This indicates a Health Connect client library version mismatch
E/MinimalHealthPlugin(17736):   The device's Health Connect version doesn't support methods expected by the client library
W/MinimalHealthPlugin(17736):   Returning empty data to prevent app crash
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:404:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 ✅ Retrieved 0 records for SLEEP_IN_BED
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:408:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ ! !  NO DATA FOUND for SLEEP_IN_BED in the specified time range
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:410:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 Troubleshooting suggestions:
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:411:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 1. Check if your device/app is syncing data to Health Connect
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:413:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 2. Verify the time range contains actual activity
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:414:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 3. Check Health Connect app for data visibility
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:415:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 4. Ensure permissions are properly granted
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   HealthService.getSleepHoursLastNight (package:habitv8/services/health_service.dart:880:21)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 Raw sleep data records found: 0
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (17736): │ #1   HealthService.getSleepHoursLastNight (package:habitv8/services/health_service.dart:897:23)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ ! No sleep records found in Health Connect for the last 3 days
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   HealthService.getSleepHoursLastNight (package:habitv8/services/health_service.dart:900:23)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 Troubleshooting steps:
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   HealthService.getSleepHoursLastNight (package:habitv8/services/health_service.dart:901:23)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 1. Check if your smartwatch is syncing to Health Connect
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   HealthService.getSleepHoursLastNight (package:habitv8/services/health_service.dart:904:23)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 2. Verify sleep tracking is enabled on your smartwatch
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   HealthService.getSleepHoursLastNight (package:habitv8/services/health_service.dart:907:23)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 3. Check Health Connect app for sleep data visibility
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   HealthService.getSleepHoursLastNight (package:habitv8/services/health_service.dart:910:23)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 4. Ensure your smartwatch app has Health Connect integration
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   HealthService.getSleepHoursLastNight (package:habitv8/services/health_service.dart:913:23)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 5. Try manually syncing your smartwatch data
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(17736): ✅ Health Connect readRecords completed successfully!
I/MinimalHealthPlugin(17736):   API call duration: 69ms
I/MinimalHealthPlugin(17736):   Raw records count: 0
W/MinimalHealthPlugin(17736): !  NO RECORDS returned from Health Connect for HEART_RATE
W/MinimalHealthPlugin(17736):   This could indicate:
W/MinimalHealthPlugin(17736):   1. No data exists in the specified time range
W/MinimalHealthPlugin(17736):   2. Data source app is not syncing to Health Connect
W/MinimalHealthPlugin(17736):   3. Permissions are not properly granted
W/MinimalHealthPlugin(17736):   4. Health Connect version compatibility issues
I/MinimalHealthPlugin(17736): ✅ Successfully processed 0 valid records for HEART_RATE
W/MinimalHealthPlugin(17736): ❌ No heart rate data found!
W/MinimalHealthPlugin(17736):   Check if your smartwatch is syncing heart rate to Health Connect
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:404:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 ✅ Retrieved 0 records for HEART_RATE
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:408:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ ! !  NO DATA FOUND for HEART_RATE in the specified time range
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:410:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 Troubleshooting suggestions:
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:411:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 1. Check if your device/app is syncing data to Health Connect
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:413:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 2. Verify the time range contains actual activity
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:414:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 3. Check Health Connect app for data visibility
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:415:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 4. Ensure permissions are properly granted
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getLatestHeartRate (package:habitv8/services/minimal_health_channel.dart:852:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 MinimalHealthChannel: Received 0 heart rate records in 6h range
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getLatestHeartRate (package:habitv8/services/minimal_health_channel.dart:842:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 MinimalHealthChannel: Requesting heart rate data from 2025-08-31T22:31:58.698076 to 2025-09-01T22:31:58.698076
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:374:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 Fetching health data for HEART_RATE:
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:377:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡   Start: 2025-08-31T22:31:58.698076 (1756704718698)
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:379:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡   End: 2025-09-01T22:31:58.698076 (1756791118698)
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:381:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡   Duration: 24 hours
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:383:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡   Current time: 2025-09-01T22:31:59.210740 (1756791119210)
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(17736): ✅ Health Connect readRecords completed successfully!
I/MinimalHealthPlugin(17736):   API call duration: 91ms
I/MinimalHealthPlugin(17736):   Raw records count: 0
W/MinimalHealthPlugin(17736): !  NO RECORDS returned from Health Connect for HEART_RATE
W/MinimalHealthPlugin(17736):   This could indicate:
W/MinimalHealthPlugin(17736):   1. No data exists in the specified time range
W/MinimalHealthPlugin(17736):   2. Data source app is not syncing to Health Connect
W/MinimalHealthPlugin(17736):   3. Permissions are not properly granted
W/MinimalHealthPlugin(17736):   4. Health Connect version compatibility issues
I/MinimalHealthPlugin(17736): ✅ Successfully processed 0 valid records for HEART_RATE
W/MinimalHealthPlugin(17736): ❌ No heart rate data found!
W/MinimalHealthPlugin(17736):   Check if your smartwatch is syncing heart rate to Health Connect
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:404:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 ✅ Retrieved 0 records for HEART_RATE
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:408:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ ! !  NO DATA FOUND for HEART_RATE in the specified time range
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:410:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 Troubleshooting suggestions:
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:411:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 1. Check if your device/app is syncing data to Health Connect
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:413:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 2. Verify the time range contains actual activity
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:414:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 3. Check Health Connect app for data visibility
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:415:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 4. Ensure permissions are properly granted
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:374:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 Fetching health data for HEART_RATE:
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:377:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡   Start: 2025-08-29T22:31:58.718948 (1756531918718)
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:379:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡   End: 2025-09-01T22:31:58.718948 (1756791118718)
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:381:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡   Duration: 72 hours
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:383:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡   Current time: 2025-09-01T22:31:59.237405 (1756791119237)
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
E/MinimalHealthPlugin(17736): ❌ Health Connect version compatibility issue for TOTAL_CALORIES_BURNED after 122ms
E/MinimalHealthPlugin(17736):   NoSuchMethodError: No virtual method getStartZoneOffset()Lj$/time/ZoneOffset; in class Landroid/health/connect/datatypes/TotalCaloriesBurnedRecord; or its super classes (declaration of 'android.health.connect.datatypes.TotalCaloriesBurnedRecord' appears in /apex/com.android.healthfitness/javalib/framework-healthfitness.jar)
E/MinimalHealthPlugin(17736):   This indicates a Health Connect client library version mismatch
E/MinimalHealthPlugin(17736):   The device's Health Connect version doesn't support methods expected by the client library
W/MinimalHealthPlugin(17736):   Returning empty data to prevent app crash
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:404:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 ✅ Retrieved 0 records for TOTAL_CALORIES_BURNED
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:408:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ ! !  NO DATA FOUND for TOTAL_CALORIES_BURNED in the specified time range
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:410:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 Troubleshooting suggestions:
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:411:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 1. Check if your device/app is syncing data to Health Connect
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:413:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 2. Verify the time range contains actual activity
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:414:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 3. Check Health Connect app for data visibility
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:415:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 4. Ensure permissions are properly granted
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getTotalCaloriesToday (package:habitv8/services/minimal_health_channel.dart:546:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 Received 0 total calories records
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getTotalCaloriesToday (package:habitv8/services/minimal_health_channel.dart:549:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ ! No total calories data found for today
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getTotalCaloriesToday (package:habitv8/services/minimal_health_channel.dart:550:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 Troubleshooting steps for total calories data:
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getTotalCaloriesToday (package:habitv8/services/minimal_health_channel.dart:551:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 1. Check if your smartwatch is syncing total calories to Health Connect
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getTotalCaloriesToday (package:habitv8/services/minimal_health_channel.dart:554:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 2. Verify your watch app has Health Connect integration enabled
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getTotalCaloriesToday (package:habitv8/services/minimal_health_channel.dart:557:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 3. Check Health Connect app for total energy data visibility
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getTotalCaloriesToday (package:habitv8/services/minimal_health_channel.dart:560:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 4. Ensure your watch is tracking workouts and activities
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getTotalCaloriesToday (package:habitv8/services/minimal_health_channel.dart:563:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 5. Try manually syncing your smartwatch data
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   HealthService.getTotalCaloriesToday (package:habitv8/services/health_service.dart:824:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 Retrieved total calories data: 0 (total from 0 records: 0)
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(17736): getHealthData called with:
I/MinimalHealthPlugin(17736):   - dataType: HEART_RATE
I/MinimalHealthPlugin(17736):   - startDate: 1756704718698 (2025-09-01T05:31:58.698Z)
I/MinimalHealthPlugin(17736):   - endDate: 1756791118698 (2025-09-02T05:31:58.698Z)
I/MinimalHealthPlugin(17736): getHealthData called with:
I/MinimalHealthPlugin(17736):   - dataType: HEART_RATE
I/MinimalHealthPlugin(17736):   - startDate: 1756531918718 (2025-08-30T05:31:58.718Z)
I/MinimalHealthPlugin(17736):   - endDate: 1756791118718 (2025-09-02T05:31:58.718Z)
D/MinimalHealthPlugin(17736): Checking compatibility for HEART_RATE (HeartRateRecord)
D/MinimalHealthPlugin(17736): HEART_RATE compatibility check - allowing with robust error handling
D/MinimalHealthPlugin(17736): ✅ HEART_RATE compatibility check passed (using robust error handling)
I/MinimalHealthPlugin(17736): Executing Health Connect readRecords request for HEART_RATE...
I/MinimalHealthPlugin(17736):   Time range: 2025-09-01T05:31:58.698Z to 2025-09-02T05:31:58.698Z
I/MinimalHealthPlugin(17736):   Duration: 24 hours
I/MinimalHealthPlugin(17736):   Record type: HeartRateRecord
I/MinimalHealthPlugin(17736): ⏱️  Starting Health Connect API call at 2025-09-02T05:31:59.283Z
D/MinimalHealthPlugin(17736): Checking compatibility for HEART_RATE (HeartRateRecord)
D/MinimalHealthPlugin(17736): HEART_RATE compatibility check - allowing with robust error handling
D/MinimalHealthPlugin(17736): ✅ HEART_RATE compatibility check passed (using robust error handling)
I/MinimalHealthPlugin(17736): Executing Health Connect readRecords request for HEART_RATE...
I/MinimalHealthPlugin(17736):   Time range: 2025-08-30T05:31:58.718Z to 2025-09-02T05:31:58.718Z
I/MinimalHealthPlugin(17736):   Duration: 72 hours
I/MinimalHealthPlugin(17736):   Record type: HeartRateRecord
I/MinimalHealthPlugin(17736): ⏱️  Starting Health Connect API call at 2025-09-02T05:31:59.289Z
I/MinimalHealthPlugin(17736): ✅ Health Connect readRecords completed successfully!
I/MinimalHealthPlugin(17736):   API call duration: 13ms
I/MinimalHealthPlugin(17736):   Raw records count: 0
W/MinimalHealthPlugin(17736): !  NO RECORDS returned from Health Connect for HEART_RATE
W/MinimalHealthPlugin(17736):   This could indicate:
W/MinimalHealthPlugin(17736):   1. No data exists in the specified time range
W/MinimalHealthPlugin(17736):   2. Data source app is not syncing to Health Connect
W/MinimalHealthPlugin(17736):   3. Permissions are not properly granted
W/MinimalHealthPlugin(17736):   4. Health Connect version compatibility issues
I/MinimalHealthPlugin(17736): ✅ Successfully processed 0 valid records for HEART_RATE
W/MinimalHealthPlugin(17736): ❌ No heart rate data found!
W/MinimalHealthPlugin(17736):   Check if your smartwatch is syncing heart rate to Health Connect
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:404:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 ✅ Retrieved 0 records for HEART_RATE
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:408:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ ! !  NO DATA FOUND for HEART_RATE in the specified time range
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:410:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 Troubleshooting suggestions:
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:411:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 1. Check if your device/app is syncing data to Health Connect
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:413:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 2. Verify the time range contains actual activity
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:414:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 3. Check Health Connect app for data visibility
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:415:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 4. Ensure permissions are properly granted
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getLatestHeartRate (package:habitv8/services/minimal_health_channel.dart:852:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 MinimalHealthChannel: Received 0 heart rate records in 24h range
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getLatestHeartRate (package:habitv8/services/minimal_health_channel.dart:842:19)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 MinimalHealthChannel: Requesting heart rate data from 2025-08-29T22:31:58.698076 to 2025-09-01T22:31:58.698076
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:374:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡 Fetching health data for HEART_RATE:
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:377:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡   Start: 2025-08-29T22:31:58.698076 (1756531918698)
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:379:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡   End: 2025-09-01T22:31:58.698076 (1756791118698)
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:381:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡   Duration: 72 hours
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17736): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17736): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:383:17)
I/flutter (17736): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17736): │ 💡   Current time: 2025-09-01T22:31:59.308312 (1756791119308)
I/flutter (17736): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(17736): getHealthData called with:
I/MinimalHealthPlugin(17736):   - dataType: HEART_RATE
I/MinimalHealthPlugin(17736):   - startDate: 1756531918698 (2025-08-30T05:31:58.698Z)
I/MinimalHealthPlugin(17736):   - endDate: 1756791118698 (2025-09-02T05:31:58.698Z)
D/MinimalHealthPlugin(17736): Checking compatibility for HEART_RATE (HeartRateRecord)
D/MinimalHealthPlugin(17736): HEART_RATE compatibility check - allowing with robust error handling
D/MinimalHealthPlugin(17736): ✅ HEART_RATE compatibility check passed (using robust error handling)
I/MinimalHealthPlugin(17736): Executing Health Connect readRecords request for HEART_RATE...
I/MinimalHealthPlugin(17736):   Time range: 2025-08-30T05:31:58.698Z to 2025-09-02T05:31:58.698Z
I/MinimalHealthPlugin(17736):   Duration: 72 hours
I/MinimalHealthPlugin(17736):   Record type: HeartRateRecord