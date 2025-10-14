---
description: Repository Information Overview
alwaysApply: true
---

# HabitV8 Information

## Summary
HabitV8 is a Flutter-based habit tracking application that allows users to create, track, and analyze habits. The app features a comprehensive habit management system with notifications, statistics, insights, and smart recommendations. It supports multiple platforms including mobile, web, and desktop. The application has migrated from Hive to Isar database and from Flutter Local Notifications to Awesome Notifications for improved performance and reliability.

## Structure
- **lib/**: Core application code
  - **data/**: Database implementation using Isar
  - **domain/**: Business logic and models
  - **services/**: Application services (notifications, stats, etc.)
    - **notifications/**: Modular notification system components
  - **ui/**: User interface components and screens
  - **utils/**: Utility functions and helpers
  - **widgets/**: Reusable UI components
- **android/**: Android platform-specific code
- **ios/**: iOS platform-specific code
- **web/**: Web platform-specific code
- **windows/**: Windows platform-specific code
- **linux/**: Linux platform-specific code
- **macos/**: macOS platform-specific code
- **assets/**: Application assets (sounds, images)

## Language & Runtime
**Language**: Dart
**Version**: SDK ^3.4.0
**Framework**: Flutter 3.8.1+
**Build System**: Flutter build system
**Package Manager**: pub (Flutter/Dart package manager)
**App Version**: 9.0.1+37

## Dependencies
**Main Dependencies**:
- flutter: SDK
- cupertino_icons: ^1.0.8
- awesome_notifications: ^0.10.1 (replaced flutter_local_notifications)
- permission_handler: ^12.0.1
- isar: ^3.1.0+1 (primary database)
- isar_flutter_libs: ^3.1.0+1
- flutter_riverpod: ^2.4.10
- provider: ^6.1.2
- go_router: ^16.1.0
- fl_chart: ^0.68.0
- path_provider: ^2.1.3
- rrule: ^0.2.15 (RFC 5545 recurrence rules)
- intl: ^0.20.2
- shared_preferences: ^2.2.2
- timezone: 0.9.4
- logger: ^2.4.0
- url_launcher: ^6.2.5
- table_calendar: ^3.0.9
- device_calendar: ^4.3.3
- flutter_ringtone_manager: ^1.0.0
- audioplayers: ^6.1.0
- workmanager: ^0.9.0+3
- csv: ^6.0.0
- file_picker: ^10.3.2
- share_plus: ^11.1.0
- http: ^1.1.0
- flutter_secure_storage: ^9.2.2
- in_app_purchase: ^3.1.13
- home_widget: ^0.8.0
- android_intent_plus: ^5.1.0

**Development Dependencies**:
- flutter_test: SDK
- flutter_lints: ^6.0.0
- isar_generator: ^3.1.0+1
- build_runner: ^2.4.13

## Build & Installation
```bash
# Install dependencies
flutter pub get

# Generate Isar and Hive adapters
flutter pub run build_runner build --delete-conflicting-outputs

# Run the application
flutter run

# Build for specific platforms
flutter build apk --release  # Android
flutter build appbundle --release  # Android (Play Store)
flutter build ios --release  # iOS
flutter build web --release --web-renderer canvaskit  # Web
flutter build windows --release  # Windows
flutter build linux --release  # Linux
flutter build macos --release  # macOS

# PowerShell build scripts (Windows)
./build_with_version_bump.ps1 -BuildType aab  # Auto-increment version
./build_with_version_bump.ps1 -OnlyBuild -BuildType aab  # No version change
./quick_build.bat  # Increment build number only
```

## Application Structure
**Main Entry Point**: lib/main.dart
**State Management**: Riverpod 2.4.10
**Navigation**: GoRouter 16.1.0
**Database**: Isar 3.1.0+1 (NoSQL)
**Supported Platforms**:
- Android (API 26+)
- iOS (12.0+)
- Web (PWA)
- Windows Desktop
- macOS Desktop
- Linux Desktop

## Key Components

### Data Models
The core data model is the Habit class, which includes:
- Basic properties (name, description, category, color)
- Frequency settings (hourly, daily, weekly, monthly, yearly, single)
- RRule-based scheduling (RFC 5545 standard)
- Completion tracking (completions, streaks)
- Notification and alarm settings
- Custom schedules for different frequencies

```dart
@collection
class Habit {
  Id isarId = Isar.autoIncrement; // Auto-incrementing ID for Isar

  @Index(unique: true)
  late String id; // Original string ID for compatibility

  late String name;
  String? description;
  late String category;
  late int colorValue;
  late DateTime createdAt;
  DateTime? nextDueDate;

  @Enumerated(EnumType.name)
  late HabitFrequency frequency;

  List<DateTime> completions = [];
  int currentStreak = 0;
  int longestStreak = 0;
  
  // RRule fields
  String? rruleString;
  DateTime? dtStart;
  bool usesRRule = false;
  
  // Notification settings
  bool notificationsEnabled = true;
  bool alarmEnabled = false;
  String? alarmSoundName;
  
  // Legacy fields (maintained for backward compatibility)
  List<int> selectedWeekdays = [];
  List<int> selectedMonthDays = [];
  List<String> hourlyTimes = [];
  List<String> selectedYearlyDates = [];
}
```

### Service Layer
The application uses a comprehensive service architecture:

**Core Services**:
- **IsarDatabaseService**: Manages Isar database operations
- **HabitServiceIsar**: Handles habit CRUD operations
- **RRuleService**: Manages RFC 5545 recurrence rules
- **NotificationCore**: Manages notification initialization and permissions
- **NotificationScheduler**: Schedules notifications based on habit recurrence
- **MidnightHabitResetService**: Manages daily habit resets

**Analytics Services**:
- **HabitStatsService**: Calculates statistics and streaks
- **TrendAnalysisService**: Identifies patterns in habit completion
- **ComprehensiveHabitSuggestionsService**: Generates recommendations
- **AIService**: Provides AI-powered insights

**Integration Services**:
- **CalendarService**: Syncs habits with device calendar
- **WidgetIntegrationService**: Manages home screen widgets
- **WidgetBackgroundUpdateService**: Updates widgets from background
- **SubscriptionService**: Handles in-app purchases

**System Services**:
- **PermissionService**: Manages permission requests
- **AppLifecycleService**: Handles application lifecycle
- **LoggingService**: Centralized logging system
- **CacheService**: Performance optimization
- **WorkManagerHabitService**: Background task scheduling

### Notification System
The notification system has been modularized into specialized components:

- **NotificationCore**: Initialization, permissions, channels (core setup)
- **NotificationScheduler**: Time-based reminders and scheduling
- **NotificationAlarmScheduler**: System alarms for critical reminders
- **NotificationActionHandler**: User action processing
- **NotificationStorage**: Persistence of scheduled notifications
- **NotificationBootRescheduler**: Reschedules notifications after device restart
- **NotificationHelpers**: Utility functions for notification management

### UI Components
The application uses a screen-based architecture with:

**Main Screens**:
- TimelineScreen: Main habit tracking view
- AllHabitsScreen: List of all habits
- CalendarScreen: Calendar view of habits
- StatsScreen: Statistics and analytics
- InsightsScreen: AI-powered habit insights
- SettingsScreen: App configuration

**Creation/Editing Screens**:
- CreateHabitScreen: Create new habits
- CreateHabitScreenV2: Enhanced habit creation experience
- EditHabitScreen: Modify existing habits
- OnboardingScreen: User onboarding experience
- PurchaseScreen: In-app purchase interface
- AISettingsScreen: Configure AI features

## Data Flow Architecture

### Initialization Flow
```
main() → AppLifecycleService.initialize()
       → NotificationCore.initialize()
       → PermissionService.requestEssentialPermissions()
       → NotificationActionHandler.initialize()
       → MidnightHabitResetService.initialize() (delayed)
       → WidgetIntegrationService.initialize() (delayed)
       → WorkManagerHabitService.initialize() (background tasks)
```

### State Management
- Uses Riverpod for dependency injection and state management
- Provider containers for service access
- Reactive streams with Isar watchers for real-time updates
- Optimized cache invalidation system for performance

### Database Architecture
- Isar NoSQL database for local storage
- Reactive queries with watchers for real-time UI updates
- Optimized for performance with lazy loading
- Background isolate support for heavy operations
- Legacy Hive support for backward compatibility

### Notification System
- Awesome Notifications for cross-platform notifications
- Background action handling for notification interactions
- Critical alerts for important reminders
- Boot-time rescheduling for reliability
- Modular architecture for maintainability

## Platform-Specific Features

### Mobile (Android/iOS)
- Local notifications with Awesome Notifications
- System alarms for critical reminders
- Home screen widgets with background updates
- Calendar integration
- In-app purchases
- Android 15+ edge-to-edge support

### Desktop (Windows/macOS/Linux)
- Native window management
- System tray integration
- Keyboard shortcuts
- File system access for data export/import

### Web
- Progressive Web App support
- Responsive design
- IndexedDB for data persistence
- Service worker for offline functionality