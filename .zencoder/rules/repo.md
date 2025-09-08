---
description: Repository Information Overview
alwaysApply: true
---

# HabitV8 Information

## Summary
HabitV8 is a Flutter-based habit tracking application that allows users to create, track, and analyze habits. The app features a comprehensive habit management system with notifications, statistics, insights, and smart recommendations.

## Structure
- **lib/**: Core application code
  - **data/**: Database implementation using Hive
  - **domain/**: Business logic and models
  - **services/**: Application services (notifications, stats, etc.)
  - **ui/**: User interface components and screens
- **android/**: Android platform-specific code
- **ios/**: iOS platform-specific code
- **web/**: Web platform-specific code
- **windows/**: Windows platform-specific code
- **linux/**: Linux platform-specific code
- **macos/**: macOS platform-specific code
- **test/**: Test files

## Language & Runtime
**Language**: Dart
**Version**: SDK ^3.8.1
**Framework**: Flutter
**Build System**: Flutter build system
**Package Manager**: pub (Flutter/Dart package manager)

## Dependencies
**Main Dependencies**:
- flutter: SDK
- cupertino_icons: ^1.0.8
- flutter_local_notifications: ^18.0.1
- permission_handler: ^12.0.1
- hive: ^2.2.3
- hive_flutter: ^1.1.0
- flutter_riverpod: ^2.5.1
- go_router: ^16.1.0
- health: ^13.1.1
- device_calendar: ^4.3.3
- fl_chart: ^1.0.0
- tflite_flutter: ^0.11.0
- path_provider: ^2.1.3
- intl: ^0.20.2
- shared_preferences: ^2.2.2
- timezone: ^0.9.4
- logger: ^2.4.0
- table_calendar: ^3.0.9

**Development Dependencies**:
- flutter_test: SDK
- flutter_lints: ^5.0.0
- hive_generator: ^2.0.1
- build_runner: ^2.4.13

## Build & Installation
```bash
# Install dependencies
flutter pub get

# Generate Hive adapters
flutter pub run build_runner build --delete-conflicting-outputs

# Run the application
flutter run

# Build for specific platforms
flutter build apk  # Android
flutter build ios  # iOS
flutter build web  # Web
flutter build windows  # Windows
flutter build linux  # Linux
flutter build macos  # macOS
```

## Testing
**Framework**: flutter_test
**Test Location**: test/
**Run Command**:
```bash
flutter test
```

## Application Structure
**Main Entry Point**: lib/main.dart
**State Management**: flutter_riverpod
**Navigation**: go_router
**Database**: Hive (NoSQL)
**Key Features**:
- Habit tracking with various frequency options (hourly to yearly)
- Streak tracking and statistics
- Health integration
- Calendar integration
- Smart recommendations using TensorFlow Lite
- Notifications and reminders
- Multi-platform support (mobile, web, desktop)

## Service Interaction Map

### Core Components and Data Flow

#### 1. Data Layer
- **Habit Model** (`domain/model/habit.dart`): Central data structure storing habit information including:
  - Basic properties (name, description, category, color)
  - Frequency settings (hourly, daily, weekly, monthly, yearly)
  - Completion tracking (completions, streaks)
  - Notification settings
  - Custom schedules for different frequencies

- **Database Service** (`data/database.dart`): Manages Hive database operations:
  - CRUD operations for habits
  - Data persistence
  - Cache management for performance optimization
  - Integration with calendar for habit events

#### 2. Service Layer
- **Notification System**:
  - `NotificationService`: Manages local notifications with platform-specific implementations
  - `NotificationActionService`: Handles notification action responses (complete/snooze)
  - `HybridAlarmService`: Combines notification and system alarms for reliable reminders
  - `TrueAlarmService`: Handles system-level alarms for critical reminders
  - `NotificationQueueProcessor`: Manages notification delivery queue
  - Bidirectional connection with habit completion tracking

- **Health Integration**:
  - `HealthService`: Interfaces with device health APIs
  - `HealthHabitIntegrationService`: Maps health data to habits
  - `HealthHabitMappingService`: Determines which habits can be auto-completed
  - `AutomaticHabitCompletionService`: Completes habits based on health metrics
  - `HealthHabitAnalyticsService`: Analyzes correlations between habits and health
  - `SmartThresholdService`: Dynamically adjusts health thresholds based on user patterns
  - `HealthHabitUIService`: Provides UI components for health data visualization
  - `HealthHabitBackgroundService`: Manages background health data processing

- **Calendar Integration**:
  - `CalendarService`: Syncs habits with device calendar
  - `CalendarRenewalService`: Manages recurring calendar events

- **Analytics & Insights**:
  - `HabitStatsService`: Calculates statistics (streaks, completion rates)
  - `TrendAnalysisService`: Identifies patterns in habit completion
  - `ComprehensiveHabitSuggestionsService`: Generates habit recommendations
  - `CategorySuggestionService`: Suggests categories for new habits
  - `AchievementsService`: Tracks and awards user achievements

- **System Services**:
  - `PermissionService`: Manages permission requests
  - `LoggingService`: Centralized logging
  - `ThemeService`: UI theme management
  - `CacheService`: Performance optimization
  - `AppLifecycleService`: Manages application lifecycle events
  - `BackgroundTaskService`: Handles background processing
  - `WorkManagerHabitService`: Schedules background work for habit processing
  - `PerformanceService`: Monitors and optimizes app performance
  - `OnboardingService`: Manages user onboarding experience
  - `ActivityRecognitionService`: Detects user activity for context-aware features

#### 3. UI Layer
- **Screens**:
  - `TimelineScreen`: Main habit tracking view
  - `AllHabitsScreen`: List of all habits
  - `CalendarScreen`: Calendar view of habits
  - `StatsScreen`: Statistics and analytics
  - `InsightsScreen`: AI-powered habit insights
  - `SettingsScreen`: App configuration
  - `CreateHabitScreen`/`EditHabitScreen`: Habit management
  - `HealthIntegrationScreen`: Health data connection
  - `AutomaticCompletionSettingsScreen`: Configure auto-completion
  - `OnboardingScreen`: User onboarding experience

- **State Management**:
  - Uses Riverpod for dependency injection and state management
  - Provider containers for service access
  - Reactive UI updates based on habit changes

### Key Interaction Flows

#### 1. Application Initialization Flow
```
main() → AppLifecycleService.initialize()
       → NotificationService.initialize()
       → HybridAlarmService.initialize()
       → PermissionService.requestEssentialPermissions()
       → NotificationActionService.initialize()
       → CalendarRenewalService.initialize() (delayed)
       → HabitContinuationManager.initialize() (delayed)
       → HealthHabitInitializationService.initialize() (delayed)
       → AutomaticHabitCompletionService.initialize() (after health init)
```

#### 2. Habit Creation & Management Flow
```
User → CreateHabitScreen → HabitService.addHabit() → Database
                         → NotificationService.scheduleHabitNotifications()
                         → CalendarService.syncHabitChanges()
                         → HealthHabitMappingService (if health-related)
                         → CategorySuggestionService (for category recommendations)
```

#### 3. Habit Completion Flow
```
User → TimelineScreen → HabitService.markHabitComplete() → Database
                      → HabitStatsService (update statistics)
                      → CalendarService.syncHabitChanges()
                      → NotificationService (cancel notifications)
                      → AchievementsService (check for achievements)
```

#### 4. Health-Based Auto-Completion Flow
```
HealthService → HealthHabitIntegrationService → HealthHabitMappingService
              → AutomaticHabitCompletionService → HabitService.markHabitComplete()
              → NotificationService (send completion notification)
              → SmartThresholdService (adjust thresholds based on completion)
              → HealthHabitAnalyticsService (update analytics)
```

#### 5. Notification Action Flow
```
System Notification → NotificationActionService → HabitService
                    → Database (update habit)
                    → UI refresh via Riverpod
                    → NotificationQueueProcessor (process next notifications)
```

#### 6. Analytics & Insights Flow
```
HabitStatsService ← Database
                  → TrendAnalysisService
                  → ComprehensiveHabitSuggestionsService
                  → InsightsScreen
                  → AchievementsService
```

#### 7. Calendar Synchronization Flow
```
HabitService (CRUD operations) → CalendarService.syncHabitChanges()
                               → Device Calendar API
CalendarRenewalService (periodic) → CalendarService
                                  → Device Calendar API
```

#### 8. Performance Optimization Flow
```
PerformanceService → CacheService (manage cache TTL)
                   → Database (optimize queries)
                   → UI (optimize rendering)
                   → BackgroundTaskService (manage background tasks)
```

### Cross-Component Dependencies

#### 1. Database Dependencies
- **HabitService** depends on Hive database
- **HabitStatsService** depends on habit data from database
- **CacheService** provides caching for database queries
- All UI screens depend on database for habit data

#### 2. Service Interdependencies
- **NotificationService** depends on PermissionService
- **HealthService** depends on PermissionService
- **CalendarService** depends on PermissionService
- **AutomaticHabitCompletionService** depends on HealthService and HabitService
- **HealthHabitIntegrationService** depends on HealthService, HabitService, and NotificationService
- **NotificationActionService** depends on HabitService and NotificationService
- **WorkManagerHabitService** depends on HabitService and NotificationService
- **TrendAnalysisService** depends on HabitStatsService
- **ComprehensiveHabitSuggestionsService** depends on HabitStatsService and TrendAnalysisService
- **SmartThresholdService** depends on HealthService and HabitStatsService
- **AchievementsService** depends on HabitStatsService
- **ActivityRecognitionService** depends on PermissionService

#### 3. UI Dependencies
- All screens depend on Riverpod providers for state management
- Screens access services through provider containers
- UI updates reactively when underlying data changes
- `HealthIntegrationScreen` depends on HealthService and HealthHabitUIService
- `AutomaticCompletionSettingsScreen` depends on SmartThresholdService

### Initialization Sequence

1. **Application Start**:
   - Initialize Flutter binding
   - Set up system UI appearance
   - Initialize timezone data
   - Initialize AppLifecycleService for resource management

2. **Core Services Initialization**:
   - Initialize NotificationService
   - Initialize HybridAlarmService
   - Request essential permissions
   - Create Riverpod provider container
   - Initialize NotificationActionService

3. **Background Services Initialization**:
   - Initialize CalendarRenewalService (delayed)
   - Initialize HabitContinuationManager (delayed)
   - Initialize HealthHabitIntegration (delayed)
   - Initialize AutomaticHabitCompletionService (after health integration)

4. **UI Initialization**:
   - Set up navigation routes
   - Check onboarding status
   - Display appropriate initial screen

### Data Synchronization Mechanisms

1. **Health Data Sync**:
   - Periodic background sync via HealthHabitIntegrationService
   - On-demand sync when viewing health-related screens
   - Automatic habit completion based on health thresholds
   - Smart threshold adjustment based on user patterns
   - Background processing via HealthHabitBackgroundService

2. **Calendar Sync**:
   - Two-way sync between habits and device calendar
   - Calendar events created/updated when habits change
   - Calendar renewal for recurring habits
   - Periodic background sync via CalendarRenewalService

3. **Cache Management**:
   - Performance optimization via CacheService
   - Cached habit statistics with TTL (time-to-live)
   - Cache invalidation on habit updates
   - Memory-efficient caching with dependency tracking

### Error Handling & Recovery

1. **Notification Failures**:
   - Graceful degradation if notifications unavailable
   - Retry mechanisms for scheduled notifications
   - Fallback to in-app notifications
   - HybridAlarmService provides redundancy with system alarms
   - NotificationQueueProcessor manages notification delivery retries

2. **Health Integration Failures**:
   - Continues with limited functionality if health permissions denied
   - Fallback to manual habit tracking
   - Periodic permission re-requests
   - Timeout handling for health API calls
   - Error reporting and diagnostics via HealthHabitUIService

3. **Database Errors**:
   - Recovery mechanisms for corrupted database
   - Automatic database reset if adapter issues detected
   - Logging of database operations for debugging
   - Cache invalidation on database errors
   - Automatic retry for failed database operations