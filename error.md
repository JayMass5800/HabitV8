Showing Pixel 9 Pro XL logs:
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   HealthEnhancedHabitCreationService.generateHealthBasedSuggestions (package:habitv8/services/health_enhanced_habit_creation_service.dart:20:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Generating health-based habit suggestions...
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   HealthService.initialize (package:habitv8/services/health_service.dart:84:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Initializing minimal health service...
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:34:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Initializing Minimal Health Service...
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): DEBUG: Building frequency section, current frequency: HabitFrequency.daily
I/flutter (27581): DEBUG: Creating choice chip for frequency: HabitFrequency.hourly
I/flutter (27581): DEBUG: Creating choice chip for frequency: HabitFrequency.daily
I/flutter (27581): DEBUG: Creating choice chip for frequency: HabitFrequency.weekly
I/flutter (27581): DEBUG: Creating choice chip for frequency: HabitFrequency.monthly
I/flutter (27581): DEBUG: Creating choice chip for frequency: HabitFrequency.yearly
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ PlatformException(FORBIDDEN_DATA_TYPE, Data type MINDFULNESS is not allowed, null, null)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:52:17)
I/flutter (27581): │ #2   <asynchronous suspension>
I/flutter (27581): │ #3   HealthService.initialize (package:habitv8/services/health_service.dart:87:27)
I/flutter (27581): │ #4   <asynchronous suspension>
I/flutter (27581): │ #5   HealthService.hasPermissions (package:habitv8/services/health_service.dart:149:7)
I/flutter (27581): │ #6   <asynchronous suspension>
I/flutter (27581): │ #7   HealthEnhancedHabitCreationService.generateHealthBasedSuggestions (package:habitv8/services/health_enhanced_habit_creation_service.dart:23:30)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Failed to initialize Minimal Health Service
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   HealthService.initialize (package:habitv8/services/health_service.dart:94:19)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Failed to initialize minimal health service
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:34:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Initializing Minimal Health Service...
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ PlatformException(FORBIDDEN_DATA_TYPE, Data type MINDFULNESS is not allowed, null, null)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:52:17)
I/flutter (27581): │ #2   <asynchronous suspension>
I/flutter (27581): │ #3   MinimalHealthService.hasPermissions (package:habitv8/services/minimal_health_service.dart:60:7)
I/flutter (27581): │ #4   <asynchronous suspension>
I/flutter (27581): │ #5   HealthService.hasPermissions (package:habitv8/services/health_service.dart:154:29)
I/flutter (27581): │ #6   <asynchronous suspension>
I/flutter (27581): │ #7   HealthEnhancedHabitCreationService.generateHealthBasedSuggestions (package:habitv8/services/health_enhanced_habit_creation_service.dart:23:30)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Failed to initialize Minimal Health Service
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   HealthService.hasPermissions (package:habitv8/services/health_service.dart:155:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Health permissions check result: true
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   HealthService.initialize (package:habitv8/services/health_service.dart:84:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Initializing minimal health service...
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:34:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Initializing Minimal Health Service...
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ PlatformException(FORBIDDEN_DATA_TYPE, Data type MINDFULNESS is not allowed, null, null)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:52:17)
I/flutter (27581): │ #2   <asynchronous suspension>
I/flutter (27581): │ #3   HealthService.initialize (package:habitv8/services/health_service.dart:87:27)
I/flutter (27581): │ #4   <asynchronous suspension>
I/flutter (27581): │ #5   HealthService.getStepsToday (package:habitv8/services/health_service.dart:178:7)
I/flutter (27581): │ #6   <asynchronous suspension>
I/flutter (27581): │ #7   HealthService.getTodayHealthSummary (package:habitv8/services/health_service.dart:262:21)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Failed to initialize Minimal Health Service
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   HealthService.initialize (package:habitv8/services/health_service.dart:94:19)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Failed to initialize minimal health service
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:34:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Initializing Minimal Health Service...
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ PlatformException(FORBIDDEN_DATA_TYPE, Data type MINDFULNESS is not allowed, null, null)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:52:17)
I/flutter (27581): │ #2   <asynchronous suspension>
I/flutter (27581): │ #3   MinimalHealthService.getHealthData (package:habitv8/services/minimal_health_service.dart:124:7)
I/flutter (27581): │ #4   <asynchronous suspension>
I/flutter (27581): │ #5   MinimalHealthService.getStepsToday (package:habitv8/services/minimal_health_service.dart:157:18)
I/flutter (27581): │ #6   <asynchronous suspension>
I/flutter (27581): │ #7   HealthService.getStepsToday (package:habitv8/services/health_service.dart:182:14)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Failed to initialize Minimal Health Service
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ type '_Map<Object?, Object?>' is not a subtype of type 'Map<String, dynamic>' in type cast
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   HealthService.getStepsToday (package:habitv8/services/health_service.dart:184:17)
I/flutter (27581): │ #2   <asynchronous suspension>
I/flutter (27581): │ #3   HealthService.getTodayHealthSummary (package:habitv8/services/health_service.dart:262:21)
I/flutter (27581): │ #4   <asynchronous suspension>
I/flutter (27581): │ #5   HealthEnhancedHabitCreationService.generateHealthBasedSuggestions (package:habitv8/services/health_enhanced_habit_creation_service.dart:30:29)
I/flutter (27581): │ #6   <asynchronous suspension>
I/flutter (27581): │ #7   _CreateHabitScreenState._loadHealthSuggestions (package:habitv8/ui/screens/create_habit_screen.dart:1185:27)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Error getting steps data
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   HealthService.initialize (package:habitv8/services/health_service.dart:84:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Initializing minimal health service...
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:34:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Initializing Minimal Health Service...
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ PlatformException(FORBIDDEN_DATA_TYPE, Data type MINDFULNESS is not allowed, null, null)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:52:17)
I/flutter (27581): │ #2   <asynchronous suspension>
I/flutter (27581): │ #3   HealthService.initialize (package:habitv8/services/health_service.dart:87:27)
I/flutter (27581): │ #4   <asynchronous suspension>
I/flutter (27581): │ #5   HealthService.getActiveCaloriesToday (package:habitv8/services/health_service.dart:192:7)
I/flutter (27581): │ #6   <asynchronous suspension>
I/flutter (27581): │ #7   HealthService.getTodayHealthSummary (package:habitv8/services/health_service.dart:263:24)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Failed to initialize Minimal Health Service
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   HealthService.initialize (package:habitv8/services/health_service.dart:94:19)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Failed to initialize minimal health service
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:34:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Initializing Minimal Health Service...
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ PlatformException(FORBIDDEN_DATA_TYPE, Data type MINDFULNESS is not allowed, null, null)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:52:17)
I/flutter (27581): │ #2   <asynchronous suspension>
I/flutter (27581): │ #3   MinimalHealthService.getHealthData (package:habitv8/services/minimal_health_service.dart:124:7)
I/flutter (27581): │ #4   <asynchronous suspension>
I/flutter (27581): │ #5   MinimalHealthService.getActiveCaloriesToday (package:habitv8/services/minimal_health_service.dart:176:18)
I/flutter (27581): │ #6   <asynchronous suspension>
I/flutter (27581): │ #7   HealthService.getActiveCaloriesToday (package:habitv8/services/health_service.dart:196:14)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Failed to initialize Minimal Health Service
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   HealthService.initialize (package:habitv8/services/health_service.dart:84:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Initializing minimal health service...
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:34:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Initializing Minimal Health Service...
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ PlatformException(FORBIDDEN_DATA_TYPE, Data type MINDFULNESS is not allowed, null, null)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:52:17)
I/flutter (27581): │ #2   <asynchronous suspension>
I/flutter (27581): │ #3   HealthService.initialize (package:habitv8/services/health_service.dart:87:27)
I/flutter (27581): │ #4   <asynchronous suspension>
I/flutter (27581): │ #5   HealthService.getSleepHoursLastNight (package:habitv8/services/health_service.dart:206:7)
I/flutter (27581): │ #6   <asynchronous suspension>
I/flutter (27581): │ #7   HealthService.getTodayHealthSummary (package:habitv8/services/health_service.dart:264:21)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Failed to initialize Minimal Health Service
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   HealthService.initialize (package:habitv8/services/health_service.dart:94:19)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Failed to initialize minimal health service
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:34:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Initializing Minimal Health Service...
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ PlatformException(FORBIDDEN_DATA_TYPE, Data type MINDFULNESS is not allowed, null, null)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:52:17)
I/flutter (27581): │ #2   <asynchronous suspension>
I/flutter (27581): │ #3   MinimalHealthService.getHealthData (package:habitv8/services/minimal_health_service.dart:124:7)
I/flutter (27581): │ #4   <asynchronous suspension>
I/flutter (27581): │ #5   MinimalHealthService.getSleepHoursLastNight (package:habitv8/services/minimal_health_service.dart:195:18)
I/flutter (27581): │ #6   <asynchronous suspension>
I/flutter (27581): │ #7   HealthService.getSleepHoursLastNight (package:habitv8/services/health_service.dart:210:14)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Failed to initialize Minimal Health Service
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   HealthService.initialize (package:habitv8/services/health_service.dart:84:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Initializing minimal health service...
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:34:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Initializing Minimal Health Service...
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ PlatformException(FORBIDDEN_DATA_TYPE, Data type MINDFULNESS is not allowed, null, null)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:52:17)
I/flutter (27581): │ #2   <asynchronous suspension>
I/flutter (27581): │ #3   HealthService.initialize (package:habitv8/services/health_service.dart:87:27)
I/flutter (27581): │ #4   <asynchronous suspension>
I/flutter (27581): │ #5   HealthService.getWaterIntakeToday (package:habitv8/services/health_service.dart:220:7)
I/flutter (27581): │ #6   <asynchronous suspension>
I/flutter (27581): │ #7   HealthService.getTodayHealthSummary (package:habitv8/services/health_service.dart:265:21)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Failed to initialize Minimal Health Service
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   HealthService.initialize (package:habitv8/services/health_service.dart:94:19)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Failed to initialize minimal health service
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:34:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Initializing Minimal Health Service...
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ PlatformException(FORBIDDEN_DATA_TYPE, Data type MINDFULNESS is not allowed, null, null)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:52:17)
I/flutter (27581): │ #2   <asynchronous suspension>
I/flutter (27581): │ #3   MinimalHealthService.getHealthData (package:habitv8/services/minimal_health_service.dart:124:7)
I/flutter (27581): │ #4   <asynchronous suspension>
I/flutter (27581): │ #5   MinimalHealthService.getWaterIntakeToday (package:habitv8/services/minimal_health_service.dart:215:18)
I/flutter (27581): │ #6   <asynchronous suspension>
I/flutter (27581): │ #7   HealthService.getWaterIntakeToday (package:habitv8/services/health_service.dart:224:14)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Failed to initialize Minimal Health Service
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   HealthService.initialize (package:habitv8/services/health_service.dart:84:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Initializing minimal health service...
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:34:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Initializing Minimal Health Service...
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ PlatformException(FORBIDDEN_DATA_TYPE, Data type MINDFULNESS is not allowed, null, null)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:52:17)
I/flutter (27581): │ #2   <asynchronous suspension>
I/flutter (27581): │ #3   HealthService.initialize (package:habitv8/services/health_service.dart:87:27)
I/flutter (27581): │ #4   <asynchronous suspension>
I/flutter (27581): │ #5   HealthService.getMindfulnessMinutesToday (package:habitv8/services/health_service.dart:234:7)
I/flutter (27581): │ #6   <asynchronous suspension>
I/flutter (27581): │ #7   HealthService.getTodayHealthSummary (package:habitv8/services/health_service.dart:266:27)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Failed to initialize Minimal Health Service
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   HealthService.initialize (package:habitv8/services/health_service.dart:94:19)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Failed to initialize minimal health service
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:34:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Initializing Minimal Health Service...
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ PlatformException(FORBIDDEN_DATA_TYPE, Data type MINDFULNESS is not allowed, null, null)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:52:17)
I/flutter (27581): │ #2   <asynchronous suspension>
I/flutter (27581): │ #3   MinimalHealthService.getHealthData (package:habitv8/services/minimal_health_service.dart:124:7)
I/flutter (27581): │ #4   <asynchronous suspension>
I/flutter (27581): │ #5   MinimalHealthService.getMindfulnessMinutesToday (package:habitv8/services/minimal_health_service.dart:234:18)
I/flutter (27581): │ #6   <asynchronous suspension>
I/flutter (27581): │ #7   HealthService.getMindfulnessMinutesToday (package:habitv8/services/health_service.dart:238:14)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Failed to initialize Minimal Health Service
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ PlatformException(FORBIDDEN_DATA_TYPE, Data type MINDFULNESS is not allowed, null, null)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   MinimalHealthService.getHealthData (package:habitv8/services/minimal_health_service.dart:147:17)
I/flutter (27581): │ #2   <asynchronous suspension>
I/flutter (27581): │ #3   MinimalHealthService.getMindfulnessMinutesToday (package:habitv8/services/minimal_health_service.dart:234:18)
I/flutter (27581): │ #4   <asynchronous suspension>
I/flutter (27581): │ #5   HealthService.getMindfulnessMinutesToday (package:habitv8/services/health_service.dart:238:14)
I/flutter (27581): │ #6   <asynchronous suspension>
I/flutter (27581): │ #7   HealthService.getTodayHealthSummary (package:habitv8/services/health_service.dart:266:27)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Error getting health data for MINDFULNESS
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   HealthService.initialize (package:habitv8/services/health_service.dart:84:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Initializing minimal health service...
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:34:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Initializing Minimal Health Service...
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ PlatformException(FORBIDDEN_DATA_TYPE, Data type MINDFULNESS is not allowed, null, null)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:52:17)
I/flutter (27581): │ #2   <asynchronous suspension>
I/flutter (27581): │ #3   HealthService.initialize (package:habitv8/services/health_service.dart:87:27)
I/flutter (27581): │ #4   <asynchronous suspension>
I/flutter (27581): │ #5   HealthService.getLatestWeight (package:habitv8/services/health_service.dart:248:7)
I/flutter (27581): │ #6   <asynchronous suspension>
I/flutter (27581): │ #7   HealthService.getTodayHealthSummary (package:habitv8/services/health_service.dart:267:22)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Failed to initialize Minimal Health Service
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   HealthService.initialize (package:habitv8/services/health_service.dart:94:19)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Failed to initialize minimal health service
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:34:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Initializing Minimal Health Service...
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ PlatformException(FORBIDDEN_DATA_TYPE, Data type MINDFULNESS is not allowed, null, null)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   MinimalHealthService.initialize (package:habitv8/services/minimal_health_service.dart:52:17)
I/flutter (27581): │ #2   <asynchronous suspension>
I/flutter (27581): │ #3   MinimalHealthService.getHealthData (package:habitv8/services/minimal_health_service.dart:124:7)
I/flutter (27581): │ #4   <asynchronous suspension>
I/flutter (27581): │ #5   MinimalHealthService.getLatestWeight (package:habitv8/services/minimal_health_service.dart:253:18)
I/flutter (27581): │ #6   <asynchronous suspension>
I/flutter (27581): │ #7   HealthService.getLatestWeight (package:habitv8/services/health_service.dart:252:14)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Failed to initialize Minimal Health Service
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ type '_Map<Object?, Object?>' is not a subtype of type 'Map<String, dynamic>' in type cast
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27581): │ #1   HealthService.getLatestWeight (package:habitv8/services/health_service.dart:254:17)
I/flutter (27581): │ #2   <asynchronous suspension>
I/flutter (27581): │ #3   HealthService.getTodayHealthSummary (package:habitv8/services/health_service.dart:267:22)
I/flutter (27581): │ #4   <asynchronous suspension>
I/flutter (27581): │ #5   HealthEnhancedHabitCreationService.generateHealthBasedSuggestions (package:habitv8/services/health_enhanced_habit_creation_service.dart:30:29)
I/flutter (27581): │ #6   <asynchronous suspension>
I/flutter (27581): │ #7   _CreateHabitScreenState._loadHealthSuggestions (package:habitv8/ui/screens/create_habit_screen.dart:1185:27)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ ⛔ Error getting weight data
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27581): │ #1   HealthEnhancedHabitCreationService.generateHealthBasedSuggestions (package:habitv8/services/health_enhanced_habit_creation_service.dart:52:17)
I/flutter (27581): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27581): │ 💡 Generated 2 health-based habit suggestions
I/flutter (27581): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27581): DEBUG: Building frequency section, current frequency: HabitFrequency.daily
I/flutter (27581): DEBUG: Creating choice chip for frequency: HabitFrequency.hourly
I/flutter (27581): DEBUG: Creating choice chip for frequency: HabitFrequency.daily
I/flutter (27581): DEBUG: Creating choice chip for frequency: HabitFrequency.weekly
I/flutter (27581): DEBUG: Creating choice chip for frequency: HabitFrequency.monthly
I/flutter (27581): DEBUG: Creating choice chip for frequency: HabitFrequency.yearly
