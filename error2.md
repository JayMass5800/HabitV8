Act as a senior mobile developer and expert debugger, specializing in complex data access issues with native health platforms like Android's Health Connect and iOS's HealthKit.

Problem Description:

My application has a feature (an "Insights" page) that displays health data to the user. This feature was previously working correctly, reading and displaying data from the user's phone and connected watch. Recently, it has stopped working.

Symptoms:

The app successfully requests and is granted all necessary health data permissions. Checking the device's system settings confirms our app has the required read access.

We can see recent, valid health data (steps, heart rate, etc.) in the native health application (e.g., Google Fit, Apple Health) for the exact time periods our app is querying.

When our app attempts to fetch this data, the API returns an empty set or null result, as if no data exists.

There are no obvious crashes or exceptions being thrown; the failure is silent, leading to an empty state in the UI.

My Goal:

I need you to analyze my data fetching code to identify the root cause of this silent failure. The solution must be robust and account for potential changes in the underlying health platform APIs or OS behavior.

Your Task:

Analyze the Code for Potential Failure Points: I will provide the relevant code snippet responsible for querying the health data. Scrutinize it for common and subtle issues, including:

API Changes: Are there any deprecated methods or changes in query patterns in recent versions of Health Connect / HealthKit?

Time Range & Timezone Errors: Check for off-by-one errors, incorrect epoch time conversion, or timezone mismatches that could cause the query window to miss the existing data.

Data Source Specificity: Is the code querying for data from a specific device/source that is no longer providing data, instead of querying for the aggregated data from all sources?

Silent Error Handling: Is a try-catch block too broad, catching a specific new exception (like a security or serialization error) and incorrectly interpreting it as "no data"?

Background Execution Limits: Could a recent OS update be preventing the app from accessing this data in the background, causing the query to fail silently?

Client Initialization: Is the Health Connect/HealthKit client being initialized correctly, and is its state being managed properly?

Suggest Enhanced Logging: Modify the code to add verbose, specific logging. I need to know the exact query parameters being sent (start time, end time, data types) and the precise, raw response received from the API before it's processed by the app. Log any and all exceptions, even if they are caught.

Rewrite for Resilience: Provide a rewritten, production-ready version of the code that incorporates fixes for any identified issues. The new code should be more resilient, with better error handling and clearer logging.

Provide a Clear Explanation: Add comments to the new code and a summary explaining the likely root cause of the problem and how your changes address it.

here is the data from my device logs:




I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:908:21)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Health type WATER matched with score 0.029411764705882353 (2 keywords)
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(17397): getHealthData called with:
I/MinimalHealthPlugin(17397):   - dataType: ACTIVE_ENERGY_BURNED
I/MinimalHealthPlugin(17397):   - startDate: 1756278000000 (2025-08-27T07:00:00Z)
I/MinimalHealthPlugin(17397):   - endDate: 1756364400000 (2025-08-28T07:00:00Z)
I/MinimalHealthPlugin(17397): getHealthData called with:
I/MinimalHealthPlugin(17397):   - dataType: TOTAL_CALORIES_BURNED
I/MinimalHealthPlugin(17397):   - startDate: 1756278000000 (2025-08-27T07:00:00Z)
I/MinimalHealthPlugin(17397):   - endDate: 1756364400000 (2025-08-28T07:00:00Z)
I/MinimalHealthPlugin(17397): getHealthData called with:
I/MinimalHealthPlugin(17397):   - dataType: SLEEP_IN_BED
I/MinimalHealthPlugin(17397):   - startDate: 1756170000000 (2025-08-26T01:00:00Z)
I/MinimalHealthPlugin(17397):   - endDate: 1756317631804 (2025-08-27T18:00:31.804Z)
I/MinimalHealthPlugin(17397): getHealthData called with:
I/MinimalHealthPlugin(17397):   - dataType: HEART_RATE
I/MinimalHealthPlugin(17397):   - startDate: 1756310431808 (2025-08-27T16:00:31.808Z)
I/MinimalHealthPlugin(17397):   - endDate: 1756317631808 (2025-08-27T18:00:31.808Z)
I/MinimalHealthPlugin(17397): Initialize called with types: MINDFULNESS
I/MinimalHealthPlugin(17397): Current allowed data types: STEPS, ACTIVE_ENERGY_BURNED, TOTAL_CALORIES_BURNED, SLEEP_IN_BED, WATER, WEIGHT, HEART_RATE, BACKGROUND_HEALTH_DATA
W/MinimalHealthPlugin(17397): MINDFULNESS was requested but not available on this device/version
W/MinimalHealthPlugin(17397): This is normal if the Health Connect version doesn't support MindfulnessSessionRecord
I/MinimalHealthPlugin(17397): Valid types after filtering:
I/MinimalHealthPlugin(17397): Initialized successfully with 1 data types: MINDFULNESS
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.isDataTypeSupported (package:habitv8/services/minimal_health_channel.dart:258:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 MINDFULNESS data type support check result: true
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthHabitMappingService._isMindfulnessSupported (package:habitv8/services/health_habit_mapping_service.dart:1798:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 MINDFULNESS support check result: true
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:908:21)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Health type MINDFULNESS matched with score 0.1038961038961039 (7 keywords)
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:908:21)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Health type WEIGHT matched with score 0.032467532467532464 (2 keywords)
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:908:21)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Health type MEDICATION matched with score 0.034482758620689655 (2 keywords)
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:908:21)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Health type HEART_RATE matched with score 0.04065040650406504 (4 keywords)
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(17397): Executing Health Connect readRecords request for ACTIVE_ENERGY_BURNED...
I/MinimalHealthPlugin(17397): Executing Health Connect readRecords request for TOTAL_CALORIES_BURNED...
I/MinimalHealthPlugin(17397): Executing Health Connect readRecords request for SLEEP_IN_BED...
I/MinimalHealthPlugin(17397): Executing Health Connect readRecords request for HEART_RATE...
I/MinimalHealthPlugin(17397): Initialize called with types: MINDFULNESS
I/MinimalHealthPlugin(17397): Current allowed data types: STEPS, ACTIVE_ENERGY_BURNED, TOTAL_CALORIES_BURNED, SLEEP_IN_BED, WATER, WEIGHT, HEART_RATE, BACKGROUND_HEALTH_DATA
W/MinimalHealthPlugin(17397): MINDFULNESS was requested but not available on this device/version
W/MinimalHealthPlugin(17397): This is normal if the Health Connect version doesn't support MindfulnessSessionRecord
I/MinimalHealthPlugin(17397): Valid types after filtering:
I/MinimalHealthPlugin(17397): Initialized successfully with 1 data types: MINDFULNESS
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.isDataTypeSupported (package:habitv8/services/minimal_health_channel.dart:258:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 MINDFULNESS data type support check result: true
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthHabitMappingService._isMindfulnessSupported (package:habitv8/services/health_habit_mapping_service.dart:1798:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 MINDFULNESS support check result: true
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:929:21)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Category "wellness" matched to MINDFULNESS with score 0.8
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:929:21)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Category "wellness" matched to SLEEP_IN_BED with score 0.7
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
Another exception was thrown: A RenderFlex overflowed by 18 pixels on the bottom.
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:929:21)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Category "wellness" matched to HEART_RATE with score 0.6
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:929:21)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Category "wellness" matched to WATER with score 0.6
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:929:21)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Category "wellness" matched to STEPS with score 0.6
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(17397): Health Connect readRecords completed, processing 0 records...
I/MinimalHealthPlugin(17397): Successfully processed 0 records for WATER from 2025-08-27T07:00:00Z to 2025-08-28T07:00:00Z
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:317:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Retrieved 0 records for WATER
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getWaterIntakeToday (package:habitv8/services/minimal_health_channel.dart:631:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Water intake today: 0ml
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getWaterIntakeToday (package:habitv8/services/health_service.dart:848:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Retrieved water intake data: 0ml
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(17397): Initialize called with types: MINDFULNESS
I/MinimalHealthPlugin(17397): Current allowed data types: STEPS, ACTIVE_ENERGY_BURNED, TOTAL_CALORIES_BURNED, SLEEP_IN_BED, WATER, WEIGHT, HEART_RATE, BACKGROUND_HEALTH_DATA
W/MinimalHealthPlugin(17397): MINDFULNESS was requested but not available on this device/version
W/MinimalHealthPlugin(17397): This is normal if the Health Connect version doesn't support MindfulnessSessionRecord
I/MinimalHealthPlugin(17397): Valid types after filtering:
I/MinimalHealthPlugin(17397): Initialized successfully with 1 data types: MINDFULNESS
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.isDataTypeSupported (package:habitv8/services/minimal_health_channel.dart:258:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 MINDFULNESS data type support check result: true
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthHabitMappingService._isMindfulnessSupported (package:habitv8/services/health_habit_mapping_service.dart:1798:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 MINDFULNESS support check result: true
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:968:21)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Combined score for MINDFULNESS: keyword + category bonus = 0.3438961038961039
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:974:21)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Category-only match for SLEEP_IN_BED: 0.7
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:968:21)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Combined score for HEART_RATE: keyword + category bonus = 0.22065040650406503
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:968:21)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Combined score for WATER: keyword + category bonus = 0.20941176470588235
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:968:21)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Combined score for STEPS: keyword + category bonus = 0.20450980392156862
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:1038:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Best match for habit "Daily Meditation": SLEEP_IN_BED (score: 0.7)
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:1128:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Created health mapping for habit "Daily Meditation": SLEEP_IN_BED, threshold: 7.0 (moderate)
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   _InsightsScreenState._loadAllData.<anonymous closure> (package:habitv8/ui/screens/insights_screen.dart:166:27)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Integration status loaded successfully
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(17397): Health Connect readRecords completed, processing 0 records...
I/MinimalHealthPlugin(17397): Successfully processed 0 records for WEIGHT from 2025-08-20T18:00:31.790Z to 2025-08-27T18:00:31.790Z
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:317:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Retrieved 0 records for WEIGHT
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getLatestWeight (package:habitv8/services/minimal_health_channel.dart:678:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 No weight data found in the last week
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getLatestWeight (package:habitv8/services/health_service.dart:886:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 No weight data available
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
E/MinimalHealthPlugin(17397): Health Connect version compatibility issue for STEPS: No virtual method getStartZoneOffset()Lj$/time/ZoneOffset; in class Landroid/health/connect/datatypes/StepsRecord; or its super classes (declaration of 'android.health.connect.datatypes.StepsRecord' appears in /apex/com.android.healthfitness/javalib/framework-healthfitness.jar)
E/MinimalHealthPlugin(17397): java.lang.NoSuchMethodError: No virtual method getStartZoneOffset()Lj$/time/ZoneOffset; in class Landroid/health/connect/datatypes/StepsRecord; or its super classes (declaration of 'android.health.connect.datatypes.StepsRecord' appears in /apex/com.android.healthfitness/javalib/framework-healthfitness.jar)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt$$ExternalSyntheticAPIConversion97.m(D8$$SyntheticClass:0)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt.toSdkStepsRecord(RecordConverters.kt:519)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt.toSdkRecord(RecordConverters.kt:155)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.HealthConnectClientUpsideDownImpl.readRecords(HealthConnectClientUpsideDownImpl.kt:198)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.HealthConnectClientUpsideDownImpl$readRecords$1.invokeSuspend(Unknown Source:15)
E/MinimalHealthPlugin(17397):   at kotlin.coroutines.jvm.internal.BaseContinuationImpl.resumeWith(ContinuationImpl.kt:33)
E/MinimalHealthPlugin(17397):   at kotlinx.coroutines.DispatchedTask.run(DispatchedTask.kt:108)
E/MinimalHealthPlugin(17397):   at android.os.Handler.handleCallback(Handler.java:995)
E/MinimalHealthPlugin(17397):   at android.os.Handler.dispatchMessage(Handler.java:103)
E/MinimalHealthPlugin(17397):   at android.os.Looper.loopOnce(Looper.java:248)
E/MinimalHealthPlugin(17397):   at android.os.Looper.loop(Looper.java:338)
E/MinimalHealthPlugin(17397):   at android.app.ActivityThread.main(ActivityThread.java:9067)
E/MinimalHealthPlugin(17397):   at java.lang.reflect.Method.invoke(Native Method)
E/MinimalHealthPlugin(17397):   at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
E/MinimalHealthPlugin(17397):   at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:932)
W/MinimalHealthPlugin(17397): This may be due to Health Connect version mismatch. Returning empty data.
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:317:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Retrieved 0 records for STEPS
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getStepsToday (package:habitv8/services/minimal_health_channel.dart:348:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Total steps today: 0
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getStepsToday (package:habitv8/services/health_service.dart:603:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Retrieved steps data: 0
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(17397): Health Connect readRecords completed, processing 0 records...
I/MinimalHealthPlugin(17397): Successfully processed 0 records for HEART_RATE from 2025-08-27T07:00:00Z to 2025-08-27T18:00:31.792Z
W/MinimalHealthPlugin(17397): No heart rate data found - check if Zepp app is syncing heart rate to Health Connect
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:317:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Retrieved 0 records for HEART_RATE
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:296:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Fetching health data for HEART_RATE from 2025-08-26T00:00:00.000 to 2025-08-27T11:00:31.792595
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(17397): getHealthData called with:
I/MinimalHealthPlugin(17397):   - dataType: HEART_RATE
I/MinimalHealthPlugin(17397):   - startDate: 1756191600000 (2025-08-26T07:00:00Z)
I/MinimalHealthPlugin(17397):   - endDate: 1756317631792 (2025-08-27T18:00:31.792Z)
I/MinimalHealthPlugin(17397): Executing Health Connect readRecords request for HEART_RATE...
I/MinimalHealthPlugin(17397): Health Connect readRecords completed, processing 0 records...
I/MinimalHealthPlugin(17397): Successfully processed 0 records for ACTIVE_ENERGY_BURNED from 2025-08-27T07:00:00Z to 2025-08-28T07:00:00Z
I/MinimalHealthPlugin(17397): Total active calories in range: 0 cal
W/MinimalHealthPlugin(17397): No active calories records found! Troubleshooting:
W/MinimalHealthPlugin(17397): 1. Check if Zepp app is syncing calories to Health Connect
W/MinimalHealthPlugin(17397): 2. Verify Health Connect has active calories permission
W/MinimalHealthPlugin(17397): 3. Ensure your watch is recording physical activities
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:317:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Retrieved 0 records for ACTIVE_ENERGY_BURNED
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getActiveCaloriesToday (package:habitv8/services/health_service.dart:646:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Active calories raw data: 0 records
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getActiveCaloriesToday (package:habitv8/services/minimal_health_channel.dart:363:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Requesting active calories data from 2025-08-27T00:00:00.000 to 2025-08-28T00:00:00.000
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:296:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Fetching health data for ACTIVE_ENERGY_BURNED from 2025-08-27T00:00:00.000 to 2025-08-28T00:00:00.000
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(17397): getHealthData called with:
I/MinimalHealthPlugin(17397):   - dataType: ACTIVE_ENERGY_BURNED
I/MinimalHealthPlugin(17397):   - startDate: 1756278000000 (2025-08-27T07:00:00Z)
I/MinimalHealthPlugin(17397):   - endDate: 1756364400000 (2025-08-28T07:00:00Z)
I/MinimalHealthPlugin(17397): Executing Health Connect readRecords request for ACTIVE_ENERGY_BURNED...
E/MinimalHealthPlugin(17397): Health Connect version compatibility issue for TOTAL_CALORIES_BURNED: No virtual method getStartZoneOffset()Lj$/time/ZoneOffset; in class Landroid/health/connect/datatypes/TotalCaloriesBurnedRecord; or its super classes (declaration of 'android.health.connect.datatypes.TotalCaloriesBurnedRecord' appears in /apex/com.android.healthfitness/javalib/framework-healthfitness.jar)
E/MinimalHealthPlugin(17397): java.lang.NoSuchMethodError: No virtual method getStartZoneOffset()Lj$/time/ZoneOffset; in class Landroid/health/connect/datatypes/TotalCaloriesBurnedRecord; or its super classes (declaration of 'android.health.connect.datatypes.TotalCaloriesBurnedRecord' appears in /apex/com.android.healthfitness/javalib/framework-healthfitness.jar)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt$$ExternalSyntheticAPIConversion102.m(D8$$SyntheticClass:0)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt.toSdkTotalCaloriesBurnedRecord(RecordConverters.kt:529)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt.toSdkRecord(RecordConverters.kt:156)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.HealthConnectClientUpsideDownImpl.readRecords(HealthConnectClientUpsideDownImpl.kt:198)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.HealthConnectClientUpsideDownImpl$readRecords$1.invokeSuspend(Unknown Source:15)
E/MinimalHealthPlugin(17397):   at kotlin.coroutines.jvm.internal.BaseContinuationImpl.resumeWith(ContinuationImpl.kt:33)
E/MinimalHealthPlugin(17397):   at kotlinx.coroutines.DispatchedTask.run(DispatchedTask.kt:108)
E/MinimalHealthPlugin(17397):   at android.os.Handler.handleCallback(Handler.java:995)
E/MinimalHealthPlugin(17397):   at android.os.Handler.dispatchMessage(Handler.java:103)
E/MinimalHealthPlugin(17397):   at android.os.Looper.loopOnce(Looper.java:248)
E/MinimalHealthPlugin(17397):   at android.os.Looper.loop(Looper.java:338)
E/MinimalHealthPlugin(17397):   at android.app.ActivityThread.main(ActivityThread.java:9067)
E/MinimalHealthPlugin(17397):   at java.lang.reflect.Method.invoke(Native Method)
E/MinimalHealthPlugin(17397):   at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
E/MinimalHealthPlugin(17397):   at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:932)
W/MinimalHealthPlugin(17397): This may be due to Health Connect version mismatch. Returning empty data.
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:317:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Retrieved 0 records for TOTAL_CALORIES_BURNED
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getTotalCaloriesToday (package:habitv8/services/health_service.dart:708:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Total calories raw data: 0 records
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getTotalCaloriesToday (package:habitv8/services/minimal_health_channel.dart:425:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Requesting total calories data from 2025-08-27T00:00:00.000 to 2025-08-28T00:00:00.000
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:296:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Fetching health data for TOTAL_CALORIES_BURNED from 2025-08-27T00:00:00.000 to 2025-08-28T00:00:00.000
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(17397): Health Connect readRecords completed, processing 0 records...
I/MinimalHealthPlugin(17397): Successfully processed 0 records for SLEEP_IN_BED from 2025-08-26T01:00:00Z to 2025-08-27T18:00:31.804Z
W/MinimalHealthPlugin(17397): No sleep data found - check if Zepp app is syncing sleep data to Health Connect
I/MinimalHealthPlugin(17397): Health Connect readRecords completed, processing 0 records...
I/MinimalHealthPlugin(17397): Successfully processed 0 records for HEART_RATE from 2025-08-27T16:00:31.808Z to 2025-08-27T18:00:31.808Z
W/MinimalHealthPlugin(17397): No heart rate data found - check if Zepp app is syncing heart rate to Health Connect
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:317:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Retrieved 0 records for SLEEP_IN_BED
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getSleepHoursLastNight (package:habitv8/services/minimal_health_channel.dart:506:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 MinimalHealthChannel: Received 0 sleep records
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getSleepHoursLastNight (package:habitv8/services/minimal_health_channel.dart:511:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ ! No sleep records found in expanded time range
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getSleepHoursLastNight (package:habitv8/services/health_service.dart:756:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Retrieved sleep data: 0.0 hours
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (17397): │ #1   HealthService.getSleepHoursLastNight (package:habitv8/services/health_service.dart:762:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ ! Sleep data returned 0 hours - investigating...
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getSleepHoursLastNight (package:habitv8/services/health_service.dart:775:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Checking sleep data from 2025-08-24T18:00:00.000 to 2025-08-27T11:00:31.877434
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:296:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Fetching health data for SLEEP_IN_BED from 2025-08-24T18:00:00.000 to 2025-08-27T11:00:31.877434
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:317:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Retrieved 0 records for HEART_RATE
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getLatestHeartRate (package:habitv8/services/minimal_health_channel.dart:722:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 MinimalHealthChannel: Received 0 heart rate records in 2h range
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getLatestHeartRate (package:habitv8/services/minimal_health_channel.dart:712:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 MinimalHealthChannel: Requesting heart rate data from 2025-08-27T05:00:31.808414 to 2025-08-27T11:00:31.808414
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:296:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Fetching health data for HEART_RATE from 2025-08-27T05:00:31.808414 to 2025-08-27T11:00:31.808414
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(17397): Health Connect readRecords completed, processing 0 records...
I/MinimalHealthPlugin(17397): Successfully processed 0 records for HEART_RATE from 2025-08-26T07:00:00Z to 2025-08-27T18:00:31.792Z
W/MinimalHealthPlugin(17397): No heart rate data found - check if Zepp app is syncing heart rate to Health Connect
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:317:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Retrieved 0 records for HEART_RATE
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:296:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Fetching health data for HEART_RATE from 2025-08-24T11:00:31.792595 to 2025-08-27T11:00:31.792595
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(17397): Health Connect readRecords completed, processing 0 records...
I/MinimalHealthPlugin(17397): Successfully processed 0 records for ACTIVE_ENERGY_BURNED from 2025-08-27T07:00:00Z to 2025-08-28T07:00:00Z
I/MinimalHealthPlugin(17397): Total active calories in range: 0 cal
W/MinimalHealthPlugin(17397): No active calories records found! Troubleshooting:
W/MinimalHealthPlugin(17397): 1. Check if Zepp app is syncing calories to Health Connect
W/MinimalHealthPlugin(17397): 2. Verify Health Connect has active calories permission
W/MinimalHealthPlugin(17397): 3. Ensure your watch is recording physical activities
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:317:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Retrieved 0 records for ACTIVE_ENERGY_BURNED
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getActiveCaloriesToday (package:habitv8/services/minimal_health_channel.dart:373:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Received 0 active calories records
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getActiveCaloriesToday (package:habitv8/services/minimal_health_channel.dart:376:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ ! No active calories data found for today
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getActiveCaloriesToday (package:habitv8/services/minimal_health_channel.dart:377:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Troubleshooting steps for calories data:
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getActiveCaloriesToday (package:habitv8/services/minimal_health_channel.dart:378:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 1. Check if your smartwatch is syncing calories to Health Connect
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getActiveCaloriesToday (package:habitv8/services/minimal_health_channel.dart:381:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 2. Verify your watch app has Health Connect integration enabled
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getActiveCaloriesToday (package:habitv8/services/minimal_health_channel.dart:384:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 3. Check Health Connect app for active energy data visibility
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getActiveCaloriesToday (package:habitv8/services/minimal_health_channel.dart:387:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 4. Ensure your watch is tracking workouts and activities
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getActiveCaloriesToday (package:habitv8/services/minimal_health_channel.dart:390:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 5. Try manually syncing your smartwatch data
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getActiveCaloriesToday (package:habitv8/services/health_service.dart:663:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Retrieved active calories data: 0 (total from 0 records: 0)
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(17397): Granted permissions (9):
I/MinimalHealthPlugin(17397):   - android.permission.health.READ_STEPS
I/MinimalHealthPlugin(17397):   - android.permission.health.READ_ACTIVE_CALORIES_BURNED
I/MinimalHealthPlugin(17397):   - android.permission.health.READ_SLEEP
I/MinimalHealthPlugin(17397):   - android.permission.health.READ_HYDRATION
I/MinimalHealthPlugin(17397):   - android.permission.health.READ_MINDFULNESS
I/MinimalHealthPlugin(17397):   - android.permission.health.READ_WEIGHT
I/MinimalHealthPlugin(17397):   - android.permission.health.READ_HEART_RATE
I/MinimalHealthPlugin(17397):   - android.permission.health.READ_HEALTH_DATA_IN_BACKGROUND
I/MinimalHealthPlugin(17397):   - android.permission.health.READ_TOTAL_CALORIES_BURNED
I/MinimalHealthPlugin(17397): Required permissions (7):
I/MinimalHealthPlugin(17397):   - android.permission.health.READ_STEPS: GRANTED
I/MinimalHealthPlugin(17397):   - android.permission.health.READ_ACTIVE_CALORIES_BURNED: GRANTED
I/MinimalHealthPlugin(17397):   - android.permission.health.READ_TOTAL_CALORIES_BURNED: GRANTED
I/MinimalHealthPlugin(17397):   - android.permission.health.READ_SLEEP: GRANTED
I/MinimalHealthPlugin(17397):   - android.permission.health.READ_HYDRATION: GRANTED
I/MinimalHealthPlugin(17397):   - android.permission.health.READ_WEIGHT: GRANTED
I/MinimalHealthPlugin(17397):   - android.permission.health.READ_HEART_RATE: GRANTED
I/MinimalHealthPlugin(17397): Heart rate permission: GRANTED
I/MinimalHealthPlugin(17397): Background permission: GRANTED
I/MinimalHealthPlugin(17397): All permissions granted: true
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.hasPermissions (package:habitv8/services/minimal_health_channel.dart:157:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Health permissions status: true
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.hasPermissions (package:habitv8/services/health_service.dart:385:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Health permissions check result: true
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(17397): getHealthData called with:
I/MinimalHealthPlugin(17397):   - dataType: TOTAL_CALORIES_BURNED
I/MinimalHealthPlugin(17397):   - startDate: 1756278000000 (2025-08-27T07:00:00Z)
I/MinimalHealthPlugin(17397):   - endDate: 1756364400000 (2025-08-28T07:00:00Z)
I/MinimalHealthPlugin(17397): getHealthData called with:
I/MinimalHealthPlugin(17397):   - dataType: SLEEP_IN_BED
I/MinimalHealthPlugin(17397):   - startDate: 1756083600000 (2025-08-25T01:00:00Z)
I/MinimalHealthPlugin(17397):   - endDate: 1756317631877 (2025-08-27T18:00:31.877Z)
I/MinimalHealthPlugin(17397): getHealthData called with:
I/MinimalHealthPlugin(17397):   - dataType: HEART_RATE
I/MinimalHealthPlugin(17397):   - startDate: 1756296031808 (2025-08-27T12:00:31.808Z)
I/MinimalHealthPlugin(17397):   - endDate: 1756317631808 (2025-08-27T18:00:31.808Z)
I/MinimalHealthPlugin(17397): getHealthData called with:
I/MinimalHealthPlugin(17397):   - dataType: HEART_RATE
I/MinimalHealthPlugin(17397):   - startDate: 1756058431792 (2025-08-24T18:00:31.792Z)
I/MinimalHealthPlugin(17397):   - endDate: 1756317631792 (2025-08-27T18:00:31.792Z)
I/MinimalHealthPlugin(17397): Executing Health Connect readRecords request for TOTAL_CALORIES_BURNED...
I/MinimalHealthPlugin(17397): Executing Health Connect readRecords request for SLEEP_IN_BED...
I/MinimalHealthPlugin(17397): Executing Health Connect readRecords request for HEART_RATE...
I/MinimalHealthPlugin(17397): Executing Health Connect readRecords request for HEART_RATE...
E/MinimalHealthPlugin(17397): Health Connect version compatibility issue for SLEEP_IN_BED: No virtual method getStartZoneOffset()Lj$/time/ZoneOffset; in class Landroid/health/connect/datatypes/SleepSessionRecord; or its super classes (declaration of 'android.health.connect.datatypes.SleepSessionRecord' appears in /apex/com.android.healthfitness/javalib/framework-healthfitness.jar)
E/MinimalHealthPlugin(17397): java.lang.NoSuchMethodError: No virtual method getStartZoneOffset()Lj$/time/ZoneOffset; in class Landroid/health/connect/datatypes/SleepSessionRecord; or its super classes (declaration of 'android.health.connect.datatypes.SleepSessionRecord' appears in /apex/com.android.healthfitness/javalib/framework-healthfitness.jar)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt$$ExternalSyntheticAPIConversion48.m(D8$$SyntheticClass:0)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt.toSdkSleepSessionRecord(RecordConverters.kt:487)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt.toSdkRecord(RecordConverters.kt:152)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.HealthConnectClientUpsideDownImpl.readRecords(HealthConnectClientUpsideDownImpl.kt:198)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.HealthConnectClientUpsideDownImpl$readRecords$1.invokeSuspend(Unknown Source:15)
E/MinimalHealthPlugin(17397):   at kotlin.coroutines.jvm.internal.BaseContinuationImpl.resumeWith(ContinuationImpl.kt:33)
E/MinimalHealthPlugin(17397):   at kotlinx.coroutines.DispatchedTask.run(DispatchedTask.kt:108)
E/MinimalHealthPlugin(17397):   at android.os.Handler.handleCallback(Handler.java:995)
E/MinimalHealthPlugin(17397):   at android.os.Handler.dispatchMessage(Handler.java:103)
E/MinimalHealthPlugin(17397):   at android.os.Looper.loopOnce(Looper.java:248)
E/MinimalHealthPlugin(17397):   at android.os.Looper.loop(Looper.java:338)
E/MinimalHealthPlugin(17397):   at android.app.ActivityThread.main(ActivityThread.java:9067)
E/MinimalHealthPlugin(17397):   at java.lang.reflect.Method.invoke(Native Method)
E/MinimalHealthPlugin(17397):   at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
E/MinimalHealthPlugin(17397):   at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:932)
W/MinimalHealthPlugin(17397): This may be due to Health Connect version mismatch. Returning empty data.
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:317:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Retrieved 0 records for SLEEP_IN_BED
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getSleepHoursLastNight (package:habitv8/services/health_service.dart:786:21)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Raw sleep data records found: 0
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (17397): │ #1   HealthService.getSleepHoursLastNight (package:habitv8/services/health_service.dart:803:23)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ ! No sleep records found in Health Connect for the last 3 days
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getSleepHoursLastNight (package:habitv8/services/health_service.dart:806:23)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Troubleshooting steps:
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getSleepHoursLastNight (package:habitv8/services/health_service.dart:807:23)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 1. Check if your smartwatch is syncing to Health Connect
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getSleepHoursLastNight (package:habitv8/services/health_service.dart:810:23)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 2. Verify sleep tracking is enabled on your smartwatch
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getSleepHoursLastNight (package:habitv8/services/health_service.dart:813:23)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 3. Check Health Connect app for sleep data visibility
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getSleepHoursLastNight (package:habitv8/services/health_service.dart:816:23)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 4. Ensure your smartwatch app has Health Connect integration
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getSleepHoursLastNight (package:habitv8/services/health_service.dart:819:23)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 5. Try manually syncing your smartwatch data
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
E/MinimalHealthPlugin(17397): Health Connect version compatibility issue for TOTAL_CALORIES_BURNED: No virtual method getStartZoneOffset()Lj$/time/ZoneOffset; in class Landroid/health/connect/datatypes/TotalCaloriesBurnedRecord; or its super classes (declaration of 'android.health.connect.datatypes.TotalCaloriesBurnedRecord' appears in /apex/com.android.healthfitness/javalib/framework-healthfitness.jar)
E/MinimalHealthPlugin(17397): java.lang.NoSuchMethodError: No virtual method getStartZoneOffset()Lj$/time/ZoneOffset; in class Landroid/health/connect/datatypes/TotalCaloriesBurnedRecord; or its super classes (declaration of 'android.health.connect.datatypes.TotalCaloriesBurnedRecord' appears in /apex/com.android.healthfitness/javalib/framework-healthfitness.jar)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt$$ExternalSyntheticAPIConversion102.m(D8$$SyntheticClass:0)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt.toSdkTotalCaloriesBurnedRecord(RecordConverters.kt:529)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt.toSdkRecord(RecordConverters.kt:156)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.HealthConnectClientUpsideDownImpl.readRecords(HealthConnectClientUpsideDownImpl.kt:198)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.HealthConnectClientUpsideDownImpl$readRecords$1.invokeSuspend(Unknown Source:15)
E/MinimalHealthPlugin(17397):   at kotlin.coroutines.jvm.internal.BaseContinuationImpl.resumeWith(ContinuationImpl.kt:33)
E/MinimalHealthPlugin(17397):   at kotlinx.coroutines.DispatchedTask.run(DispatchedTask.kt:108)
E/MinimalHealthPlugin(17397):   at android.os.Handler.handleCallback(Handler.java:995)
E/MinimalHealthPlugin(17397):   at android.os.Handler.dispatchMessage(Handler.java:103)
E/MinimalHealthPlugin(17397):   at android.os.Looper.loopOnce(Looper.java:248)
E/MinimalHealthPlugin(17397):   at android.os.Looper.loop(Looper.java:338)
E/MinimalHealthPlugin(17397):   at android.app.ActivityThread.main(ActivityThread.java:9067)
E/MinimalHealthPlugin(17397):   at java.lang.reflect.Method.invoke(Native Method)
E/MinimalHealthPlugin(17397):   at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
E/MinimalHealthPlugin(17397):   at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:932)
W/MinimalHealthPlugin(17397): This may be due to Health Connect version mismatch. Returning empty data.
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:317:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Retrieved 0 records for TOTAL_CALORIES_BURNED
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getTotalCaloriesToday (package:habitv8/services/minimal_health_channel.dart:435:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Received 0 total calories records
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getTotalCaloriesToday (package:habitv8/services/minimal_health_channel.dart:438:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ ! No total calories data found for today
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getTotalCaloriesToday (package:habitv8/services/minimal_health_channel.dart:439:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Troubleshooting steps for total calories data:
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getTotalCaloriesToday (package:habitv8/services/minimal_health_channel.dart:440:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 1. Check if your smartwatch is syncing total calories to Health Connect
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getTotalCaloriesToday (package:habitv8/services/minimal_health_channel.dart:443:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 2. Verify your watch app has Health Connect integration enabled
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getTotalCaloriesToday (package:habitv8/services/minimal_health_channel.dart:446:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 3. Check Health Connect app for total energy data visibility
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getTotalCaloriesToday (package:habitv8/services/minimal_health_channel.dart:449:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 4. Ensure your watch is tracking workouts and activities
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getTotalCaloriesToday (package:habitv8/services/minimal_health_channel.dart:452:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 5. Try manually syncing your smartwatch data
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getTotalCaloriesToday (package:habitv8/services/health_service.dart:726:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Retrieved total calories data: 0 (total from 0 records: 0)
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(17397): Health Connect readRecords completed, processing 0 records...
I/MinimalHealthPlugin(17397): Successfully processed 0 records for HEART_RATE from 2025-08-27T12:00:31.808Z to 2025-08-27T18:00:31.808Z
W/MinimalHealthPlugin(17397): No heart rate data found - check if Zepp app is syncing heart rate to Health Connect
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:317:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Retrieved 0 records for HEART_RATE
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getLatestHeartRate (package:habitv8/services/minimal_health_channel.dart:722:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 MinimalHealthChannel: Received 0 heart rate records in 6h range
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getLatestHeartRate (package:habitv8/services/minimal_health_channel.dart:712:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 MinimalHealthChannel: Requesting heart rate data from 2025-08-26T11:00:31.808414 to 2025-08-27T11:00:31.808414
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:296:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Fetching health data for HEART_RATE from 2025-08-26T11:00:31.808414 to 2025-08-27T11:00:31.808414
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(17397): getHealthData called with:
I/MinimalHealthPlugin(17397):   - dataType: HEART_RATE
I/MinimalHealthPlugin(17397):   - startDate: 1756231231808 (2025-08-26T18:00:31.808Z)
I/MinimalHealthPlugin(17397):   - endDate: 1756317631808 (2025-08-27T18:00:31.808Z)
I/MinimalHealthPlugin(17397): Executing Health Connect readRecords request for HEART_RATE...
I/MinimalHealthPlugin(17397): Health Connect readRecords completed, processing 0 records...
I/MinimalHealthPlugin(17397): Successfully processed 0 records for HEART_RATE from 2025-08-26T18:00:31.808Z to 2025-08-27T18:00:31.808Z
W/MinimalHealthPlugin(17397): No heart rate data found - check if Zepp app is syncing heart rate to Health Connect
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:317:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Retrieved 0 records for HEART_RATE
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getLatestHeartRate (package:habitv8/services/minimal_health_channel.dart:722:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 MinimalHealthChannel: Received 0 heart rate records in 24h range
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getLatestHeartRate (package:habitv8/services/minimal_health_channel.dart:712:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 MinimalHealthChannel: Requesting heart rate data from 2025-08-24T11:00:31.808414 to 2025-08-27T11:00:31.808414
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:296:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Fetching health data for HEART_RATE from 2025-08-24T11:00:31.808414 to 2025-08-27T11:00:31.808414
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(17397): getHealthData called with:
I/MinimalHealthPlugin(17397):   - dataType: HEART_RATE
I/MinimalHealthPlugin(17397):   - startDate: 1756058431808 (2025-08-24T18:00:31.808Z)
I/MinimalHealthPlugin(17397):   - endDate: 1756317631808 (2025-08-27T18:00:31.808Z)
I/MinimalHealthPlugin(17397): Executing Health Connect readRecords request for HEART_RATE...
E/MinimalHealthPlugin(17397): Health Connect version compatibility issue for HEART_RATE: No virtual method getStartZoneOffset()Lj$/time/ZoneOffset; in class Landroid/health/connect/datatypes/HeartRateRecord; or its super classes (declaration of 'android.health.connect.datatypes.HeartRateRecord' appears in /apex/com.android.healthfitness/javalib/framework-healthfitness.jar)
E/MinimalHealthPlugin(17397): java.lang.NoSuchMethodError: No virtual method getStartZoneOffset()Lj$/time/ZoneOffset; in class Landroid/health/connect/datatypes/HeartRateRecord; or its super classes (declaration of 'android.health.connect.datatypes.HeartRateRecord' appears in /apex/com.android.healthfitness/javalib/framework-healthfitness.jar)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt$$ExternalSyntheticAPIConversion42.m(D8$$SyntheticClass:0)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt.toSdkHeartRateRecord(RecordConverters.kt:316)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt.toSdkRecord(RecordConverters.kt:137)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.HealthConnectClientUpsideDownImpl.readRecords(HealthConnectClientUpsideDownImpl.kt:198)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.HealthConnectClientUpsideDownImpl$readRecords$1.invokeSuspend(Unknown Source:15)
E/MinimalHealthPlugin(17397):   at kotlin.coroutines.jvm.internal.BaseContinuationImpl.resumeWith(ContinuationImpl.kt:33)
E/MinimalHealthPlugin(17397):   at kotlinx.coroutines.DispatchedTask.run(DispatchedTask.kt:108)
E/MinimalHealthPlugin(17397):   at android.os.Handler.handleCallback(Handler.java:995)
E/MinimalHealthPlugin(17397):   at android.os.Handler.dispatchMessage(Handler.java:103)
E/MinimalHealthPlugin(17397):   at android.os.Looper.loopOnce(Looper.java:248)
E/MinimalHealthPlugin(17397):   at android.os.Looper.loop(Looper.java:338)
E/MinimalHealthPlugin(17397):   at android.app.ActivityThread.main(ActivityThread.java:9067)
E/MinimalHealthPlugin(17397):   at java.lang.reflect.Method.invoke(Native Method)
E/MinimalHealthPlugin(17397):   at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
E/MinimalHealthPlugin(17397):   at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:932)
W/MinimalHealthPlugin(17397): This may be due to Health Connect version mismatch. Returning empty data.
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:317:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Retrieved 0 records for HEART_RATE
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getRestingHeartRateToday (package:habitv8/services/minimal_health_channel.dart:857:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 No valid heart rate data found for resting heart rate calculation
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getRestingHeartRateToday (package:habitv8/services/health_service.dart:1057:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 No resting heart rate data available
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
E/MinimalHealthPlugin(17397): Health Connect version compatibility issue for HEART_RATE: No virtual method getStartZoneOffset()Lj$/time/ZoneOffset; in class Landroid/health/connect/datatypes/HeartRateRecord; or its super classes (declaration of 'android.health.connect.datatypes.HeartRateRecord' appears in /apex/com.android.healthfitness/javalib/framework-healthfitness.jar)
E/MinimalHealthPlugin(17397): java.lang.NoSuchMethodError: No virtual method getStartZoneOffset()Lj$/time/ZoneOffset; in class Landroid/health/connect/datatypes/HeartRateRecord; or its super classes (declaration of 'android.health.connect.datatypes.HeartRateRecord' appears in /apex/com.android.healthfitness/javalib/framework-healthfitness.jar)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt$$ExternalSyntheticAPIConversion42.m(D8$$SyntheticClass:0)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt.toSdkHeartRateRecord(RecordConverters.kt:316)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt.toSdkRecord(RecordConverters.kt:137)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.HealthConnectClientUpsideDownImpl.readRecords(HealthConnectClientUpsideDownImpl.kt:198)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.HealthConnectClientUpsideDownImpl$readRecords$1.invokeSuspend(Unknown Source:15)
E/MinimalHealthPlugin(17397):   at kotlin.coroutines.jvm.internal.BaseContinuationImpl.resumeWith(ContinuationImpl.kt:33)
E/MinimalHealthPlugin(17397):   at kotlinx.coroutines.DispatchedTask.run(DispatchedTask.kt:108)
E/MinimalHealthPlugin(17397):   at android.os.Handler.handleCallback(Handler.java:995)
E/MinimalHealthPlugin(17397):   at android.os.Handler.dispatchMessage(Handler.java:103)
E/MinimalHealthPlugin(17397):   at android.os.Looper.loopOnce(Looper.java:248)
E/MinimalHealthPlugin(17397):   at android.os.Looper.loop(Looper.java:338)
E/MinimalHealthPlugin(17397):   at android.app.ActivityThread.main(ActivityThread.java:9067)
E/MinimalHealthPlugin(17397):   at java.lang.reflect.Method.invoke(Native Method)
E/MinimalHealthPlugin(17397):   at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
E/MinimalHealthPlugin(17397):   at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:932)
W/MinimalHealthPlugin(17397): This may be due to Health Connect version mismatch. Returning empty data.
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:317:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Retrieved 0 records for HEART_RATE
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getLatestHeartRate (package:habitv8/services/minimal_health_channel.dart:722:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 MinimalHealthChannel: Received 0 heart rate records in 72h range
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getLatestHeartRate (package:habitv8/services/minimal_health_channel.dart:798:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ ! No heart rate data found in any time range up to 3 days
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getLatestHeartRate (package:habitv8/services/health_service.dart:939:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 No heart rate data available - investigating...
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getLatestHeartRate (package:habitv8/services/health_service.dart:947:19)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Checking heart rate data from 2025-08-26T11:00:31.995690 to 2025-08-27T11:00:31.995690
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:296:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Fetching health data for HEART_RATE from 2025-08-26T11:00:31.995690 to 2025-08-27T11:00:31.995690
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(17397): getHealthData called with:
I/MinimalHealthPlugin(17397):   - dataType: HEART_RATE
I/MinimalHealthPlugin(17397):   - startDate: 1756231231995 (2025-08-26T18:00:31.995Z)
I/MinimalHealthPlugin(17397):   - endDate: 1756317631995 (2025-08-27T18:00:31.995Z)
I/MinimalHealthPlugin(17397): Executing Health Connect readRecords request for HEART_RATE...
I/MinimalHealthPlugin(17397): Health Connect readRecords completed, processing 0 records...
I/MinimalHealthPlugin(17397): Successfully processed 0 records for HEART_RATE from 2025-08-26T18:00:31.995Z to 2025-08-27T18:00:31.995Z
W/MinimalHealthPlugin(17397): No heart rate data found - check if Zepp app is syncing heart rate to Health Connect
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:317:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Retrieved 0 records for HEART_RATE
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getLatestHeartRate (package:habitv8/services/health_service.dart:958:21)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Raw heart rate data records found: 0
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (17397): │ #1   HealthService.getLatestHeartRate (package:habitv8/services/health_service.dart:967:23)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ ! No heart rate records found in Health Connect for the last 24 hours
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getLatestHeartRate (package:habitv8/services/health_service.dart:970:23)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 This could mean:
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getLatestHeartRate (package:habitv8/services/health_service.dart:971:23)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 1. Your smartwatch heart rate data is not syncing to Health Connect
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getLatestHeartRate (package:habitv8/services/health_service.dart:974:23)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 2. Heart rate data permissions are not properly granted
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getLatestHeartRate (package:habitv8/services/health_service.dart:977:23)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 3. Your smartwatch app is not compatible with Health Connect
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getLatestHeartRate (package:habitv8/services/health_service.dart:980:23)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 4. Heart rate data is stored in a different format or location
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getLatestHeartRate (package:habitv8/services/health_service.dart:988:23)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Trying wider time range: last 7 days...
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:296:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Fetching health data for HEART_RATE from 2025-08-20T11:00:31.995690 to 2025-08-27T11:00:31.995690
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(17397): getHealthData called with:
I/MinimalHealthPlugin(17397):   - dataType: HEART_RATE
I/MinimalHealthPlugin(17397):   - startDate: 1755712831995 (2025-08-20T18:00:31.995Z)
I/MinimalHealthPlugin(17397):   - endDate: 1756317631995 (2025-08-27T18:00:31.995Z)
I/MinimalHealthPlugin(17397): Executing Health Connect readRecords request for HEART_RATE...
E/MinimalHealthPlugin(17397): Health Connect version compatibility issue for HEART_RATE: No virtual method getStartZoneOffset()Lj$/time/ZoneOffset; in class Landroid/health/connect/datatypes/HeartRateRecord; or its super classes (declaration of 'android.health.connect.datatypes.HeartRateRecord' appears in /apex/com.android.healthfitness/javalib/framework-healthfitness.jar)
E/MinimalHealthPlugin(17397): java.lang.NoSuchMethodError: No virtual method getStartZoneOffset()Lj$/time/ZoneOffset; in class Landroid/health/connect/datatypes/HeartRateRecord; or its super classes (declaration of 'android.health.connect.datatypes.HeartRateRecord' appears in /apex/com.android.healthfitness/javalib/framework-healthfitness.jar)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt$$ExternalSyntheticAPIConversion42.m(D8$$SyntheticClass:0)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt.toSdkHeartRateRecord(RecordConverters.kt:316)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt.toSdkRecord(RecordConverters.kt:137)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.HealthConnectClientUpsideDownImpl.readRecords(HealthConnectClientUpsideDownImpl.kt:198)
E/MinimalHealthPlugin(17397):   at androidx.health.connect.client.impl.HealthConnectClientUpsideDownImpl$readRecords$1.invokeSuspend(Unknown Source:15)
E/MinimalHealthPlugin(17397):   at kotlin.coroutines.jvm.internal.BaseContinuationImpl.resumeWith(ContinuationImpl.kt:33)
E/MinimalHealthPlugin(17397):   at kotlinx.coroutines.DispatchedTask.run(DispatchedTask.kt:108)
E/MinimalHealthPlugin(17397):   at android.os.Handler.handleCallback(Handler.java:995)
E/MinimalHealthPlugin(17397):   at android.os.Handler.dispatchMessage(Handler.java:103)
E/MinimalHealthPlugin(17397):   at android.os.Looper.loopOnce(Looper.java:248)
E/MinimalHealthPlugin(17397):   at android.os.Looper.loop(Looper.java:338)
E/MinimalHealthPlugin(17397):   at android.app.ActivityThread.main(ActivityThread.java:9067)
E/MinimalHealthPlugin(17397):   at java.lang.reflect.Method.invoke(Native Method)
E/MinimalHealthPlugin(17397):   at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
E/MinimalHealthPlugin(17397):   at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:932)
W/MinimalHealthPlugin(17397): This may be due to Health Connect version mismatch. Returning empty data.
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   MinimalHealthChannel.getHealthData (package:habitv8/services/minimal_health_channel.dart:317:17)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Retrieved 0 records for HEART_RATE
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getLatestHeartRate (package:habitv8/services/health_service.dart:996:23)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Heart rate data in last 7 days: 0 records
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (17397): │ #1   HealthService.getLatestHeartRate (package:habitv8/services/health_service.dart:1012:25)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ ! No heart rate data found even in 7-day range
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getLatestHeartRate (package:habitv8/services/health_service.dart:1013:25)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 Troubleshooting steps:
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getLatestHeartRate (package:habitv8/services/health_service.dart:1014:25)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 1. Check if your smartwatch is measuring heart rate
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getLatestHeartRate (package:habitv8/services/health_service.dart:1017:25)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 2. Verify heart rate data is syncing to Health Connect
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getLatestHeartRate (package:habitv8/services/health_service.dart:1020:25)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 3. Check Health Connect app for heart rate data visibility
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getLatestHeartRate (package:habitv8/services/health_service.dart:1023:25)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 4. Ensure continuous heart rate monitoring is enabled
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17397): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17397): │ #1   HealthService.getLatestHeartRate (package:habitv8/services/health_service.dart:1026:25)
I/flutter (17397): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17397): │ 💡 5. Try manually syncing your smartwatch data
I/flutter (17397): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────




