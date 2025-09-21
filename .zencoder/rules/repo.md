---
description: Repository Information Overview
alwaysApply: true
---

# HabitV8 Information

## Summary
HabitV8 is a Flutter-based habit tracking application that allows users to create, track, and analyze habits. The app features a comprehensive habit management system with notifications, statistics, insights, and smart recommendations. It supports multiple platforms including mobile, web, and desktop.

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
- **assets/**: Application assets (sounds, images)

## Language & Runtime
**Language**: Dart
**Version**: SDK ^3.4.0
**Framework**: Flutter 3.8.1+
**Build System**: Flutter build system
**Package Manager**: pub (Flutter/Dart package manager)

## Dependencies
**Main Dependencies**:
- flutter: SDK
- cupertino_icons: ^1.0.8
- flutter_local_notifications: ^18.0.1
- permission_handler: ^12.0.1
- device_info_plus: ^11.5.0
- hive: ^2.2.3
- hive_flutter: ^1.1.0
- flutter_riverpod: ^2.4.10
- provider: ^6.1.2
- go_router: ^16.1.0
- fl_chart: ^0.68.0
- path_provider: ^2.1.3
- flutter_launcher_icons: ^0.14.4
- flutter_native_splash: ^2.4.0
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

**Development Dependencies**:
- flutter_test: SDK
- flutter_lints: ^6.0.0
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
flutter build apk --release  # Android
flutter build appbundle --release  # Android (Play Store)
flutter build ios --release  # iOS
flutter build web --release --web-renderer canvaskit  # Web
flutter build windows --release  # Windows
flutter build linux --release  # Linux
flutter build macos --release  # macOS
```

## Application Structure
**Main Entry Point**: lib/main.dart
**State Management**: Riverpod 2.4.10
**Navigation**: GoRouter 16.1.0
**Database**: Hive 2.2.3 (NoSQL)
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
- Completion tracking (completions, streaks)
- Notification and alarm settings
- Custom schedules for different frequencies

```dart
@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  late String id;
  
  @HiveField(1)
  late String name;
  
  @HiveField(3)
  late String category;
  
  @HiveField(7)
  late HabitFrequency frequency;
  
  @HiveField(9)
  List<DateTime> completions = [];
  
  // Additional fields for scheduling, notifications, etc.
}
```

### Service Layer
The application uses a comprehensive service architecture:

**Core Services**:
- **DatabaseService**: Manages Hive database operations
- **HabitService**: Handles habit CRUD operations
- **NotificationService**: Manages local notifications
- **AlarmManagerService**: Handles system-level alarms
- **MidnightHabitResetService**: Manages daily habit resets

**Analytics Services**:
- **HabitStatsService**: Calculates statistics and streaks
- **TrendAnalysisService**: Identifies patterns in habit completion
- **ComprehensiveHabitSuggestionsService**: Generates recommendations

**Integration Services**:
- **CalendarService**: Syncs habits with device calendar
- **WidgetIntegrationService**: Manages home screen widgets
- **SubscriptionService**: Handles in-app purchases

**System Services**:
- **PermissionService**: Manages permission requests
- **AppLifecycleService**: Handles application lifecycle
- **LoggingService**: Centralized logging system
- **CacheService**: Performance optimization

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
- EditHabitScreen: Modify existing habits
- OnboardingScreen: User onboarding experience
- PurchaseScreen: In-app purchase interface

## Data Flow Architecture

### Initialization Flow
```
main() → AppLifecycleService.initialize()
       → NotificationService.initialize()
       → AlarmManagerService.initialize()
       → PermissionService.requestEssentialPermissions()
       → NotificationActionService.initialize()
       → MidnightHabitResetService.initialize() (delayed)
       → WidgetIntegrationService.initialize() (delayed)
```

### State Management
- Uses Riverpod for dependency injection and state management
- Provider containers for service access
- StateNotifier for real-time habit updates
- Reactive UI updates based on habit changes

### Database Architecture
- Hive NoSQL database for local storage
- Box<Habit> for storing habit data
- Cache invalidation system for performance
- Error recovery mechanisms for database corruption

### Notification System
- Flutter Local Notifications for cross-platform notifications
- System alarms as backup for critical reminders
- Notification action handling for habit completion
- Background processing with WorkManager

## Platform-Specific Features

### Mobile (Android/iOS)
- Local notifications
- System alarms
- Home screen widgets
- Calendar integration
- In-app purchases

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