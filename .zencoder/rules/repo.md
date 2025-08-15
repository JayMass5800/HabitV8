---
description: Repository Information Overview
alwaysApply: true
---

NO To Do or placeholder code, only complete functional code

 info - Don't invoke 'print' in production code

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