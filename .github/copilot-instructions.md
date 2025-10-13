# HabitV8 AI Coding Agent Instructions

## Project Overview
HabitV8 is a cross-platform habit tracking Flutter app (Android, iOS, Web, Desktop) with AI-powered insights, local-first Isar database (migrated from Hive), and advanced notification/alarm system using Awesome Notifications. The app is currently at version 9.0.1+37 and has completed the migration from legacy frequency system to RFC 5545 RRule standard.

## Critical Architecture Patterns

### Data Layer: Isar + Riverpod + Reactive Streams
- **Database**: Isar NoSQL with `@collection` annotations (replaced Hive)
- **State Management**: Riverpod providers with reactive streams via Isar watchers
- **Migration Pattern**: Dual-field system maintained for backward compatibility:
  - Legacy: `HabitFrequency` enum + `selectedWeekdays/selectedMonthDays/hourlyTimes/selectedYearlyDates` (kept for compatibility)
  - Modern: `rruleString` + `dtStart` + `usesRRule` flag (primary system)
  - **CRITICAL**: Legacy fields remain for backward compatibility; `usesRRule` flag determines which system to use
- **Models**: `lib/domain/model/habit.dart` contains Habit, HabitFrequency enum, HabitDifficulty enum
- **Error Recovery**: Database providers use Isar's built-in error handling and recovery mechanisms
- **Reactive Updates**: Isar watchers provide real-time updates to UI via `watchAllHabits()` and `watchHabitsLazy()`

### Service Layer: Modular Services with Single Responsibility
- **RRule Service** (`lib/services/rrule_service.dart`): Central RRule operations - ALWAYS use `getInstances()` not `getAllInstances()` (API requirement), all DateTime must be UTC
- **Notification System** (modularized in `lib/services/notifications/`):
  - `notification_core.dart`: Initialization, permissions, channels
  - `notification_scheduler.dart`: Time-based reminders
  - `notification_alarm_scheduler.dart`: System alarms
  - `notification_action_handler.dart`: User actions
  - `notification_storage.dart`: Persistence
  - `notification_boot_rescheduler.dart`: Reschedules after device restart
  - `notification_helpers.dart`: Utility functions
- **Alarm System**: Hybrid model using Awesome Notifications with critical alerts
- **Widget System**: `WidgetIntegrationService` + `WidgetBackgroundUpdateService` + `home_widget` package - callback MUST be registered in `main()` before widget interactions

### UI Layer: Screens + Reusable Widgets
- **Navigation**: GoRouter with 5 main routes (timeline, all_habits, calendar, insights, settings)
- **Screens**: `lib/ui/screens/` for full pages, `lib/widgets/` for cross-screen components, `lib/ui/widgets/` for screen-specific
- **State**: Riverpod providers for app state, StatefulWidget only for UI-specific local state
- **Performance**: Optimized widgets with `PerformanceOptimizedWidget` wrapper for heavy components

## Development Workflows

### Build & Version Management (PowerShell on Windows)
```powershell
# Auto-increment patch version (9.0.1+37 → 9.0.2+38) and build
./build_with_version_bump.ps1 -BuildType aab

# Build without version change
./build_with_version_bump.ps1 -OnlyBuild -BuildType aab

# Quick build (increment build number only, then build AAB)
./quick_build.bat  # Double-click in Windows Explorer
```
- **CRITICAL**: Build number MUST increment for each Play Store upload
- Build outputs: APK in `build/app/outputs/flutter-apk/`, AAB in `build/app/outputs/bundle/release/`

### Testing
```powershell
# Run unit tests
flutter test

# Specific test files
flutter test test/services/rrule_service_test.dart
```
- Tests in `test/` directory mirror `lib/` structure
- RRule tests: `test/services/rrule_service_test.dart`, `test/rrule_minimal_test.dart`, `test/rrule_date_offset_bug_test.dart`
- Calendar tests: `test/services/calendar_service_rrule_test.dart`, `test/ui/calendar_weekday_filtering_test.dart`

### Git Strategy
- **Main Branch**: `master` (stable)
- **Feature Branches**: Create for new features and major refactoring
- **Strategy**: Feature branch workflow with periodic merges to master when stable
- See `GIT_BRANCHING_STRATEGY.md` for full branching strategy

## Project-Specific Conventions

### Naming & Style
- Files: `snake_case.dart`
- Classes: `PascalCase` 
- Variables: `camelCase`
- Constants: `SCREAMING_SNAKE_CASE`
- Max line length: 80 characters, use trailing commas for better diffs
- Linting: `flutter_lints` package enforces Dart style guide

### Isar Collection Management
- **NEVER modify existing schema without migration strategy** - will corrupt database
- Use `@collection` for Isar models and `@Index` for indexed fields
- Maintain backward compatibility with legacy fields
- Use `watchAllHabits()` for reactive UI updates and `watchHabitsLazy()` for efficient background updates

### RRule Integration Pattern
When working with habit frequency:
1. Check `habit.usesRRule` flag first
2. If true: Use `RRuleService` methods (`getOccurrences()`, `isDueOnDate()`)
3. If false: Fall back to legacy frequency logic or migrate to RRule
4. Document migration status in code comments
5. All DateTime values passed to RRule methods MUST be UTC

### Notification System Patterns
- **NEVER** import `notification_service_monolithic.dart.bak` or other backup files
- Use modular services in `lib/services/notifications/`
- Schedule notifications via `NotificationScheduler`, not directly through plugin
- Action handling: Goes through `NotificationActionHandler` with storage persistence
- Background actions: Must use `ActionType.SilentBackgroundAction` and top-level functions with `@pragma('vm:entry-point')`

### Android Native Integration
- Kotlin code: `android/app/src/main/kotlin/com/habittracker/habitv8/MainActivity.kt`
- Method channels: `RINGTONE_CHANNEL`, `SYSTEM_SOUND_CHANNEL`, `NATIVE_ALARM_CHANNEL`, `ANDROID_RESOURCES_CHANNEL`, `WIDGET_UPDATE_CHANNEL`
- Edge-to-edge: Uses `enableEdgeToEdge()` + `WindowCompat.setDecorFitsSystemWindows()` for Android 15+ compatibility
- Foreground Service: Required for reliable background operations on Android 15+

## Key Documentation Files
- `DEVELOPER_GUIDE.md`: Comprehensive architecture, setup, deployment
- `RRULE_ARCHITECTURE.md`: RRule system architecture diagrams and data flow
- `NOTIFICATION_REFACTORING_PLAN.md`: Notification modularization plan
- `BUILD_SCRIPTS_README.md`: PowerShell build automation guide
- `CHANGELOG.md`: Version history and feature additions
- `ISAR_MIGRATION_PLAN.md`: Database migration from Hive to Isar
- `WIDGET_UPDATE_ARCHITECTURE.md`: Home screen widget architecture

## Common Pitfalls to Avoid
1. **RRule API**: Don't use `getAllInstances()` - it hangs. Use `getInstances()` with UTC DateTime
2. **Isar Watchers**: Don't create too many watchers - use `watchHabitsLazy()` for efficiency
3. **Background Actions**: Must use top-level functions with `@pragma('vm:entry-point')` annotation
4. **Widget Callbacks**: Must register in `main()` before any widget interactions
5. **Build Numbers**: Always increment for Play Store uploads (automated in build scripts)
6. **Notification Modules**: Keep each module focused on a single responsibility
7. **Android 15 Compatibility**: Use `enableEdgeToEdge()` and proper foreground service declarations

## Quick Start for New Features
1. Determine layer: Data (model), Service (business logic), or UI (screens/widgets)
2. Add to appropriate directory maintaining existing structure
3. Use Riverpod providers for state, not StatefulWidget unless UI-only
4. Use Isar watchers for reactive updates
5. Add unit tests in mirrored `test/` structure
6. Run `flutter pub run build_runner build` if using Isar or Hive annotations
7. Test on Android (primary platform) then iOS

## Dependencies of Note
- `isar: ^3.1.0+1` + `isar_flutter_libs: ^3.1.0+1` - Primary database
- `rrule: ^0.2.15` - RFC 5545 recurrence rules
- `flutter_riverpod: ^2.4.10` - State management
- `awesome_notifications: ^0.10.1` - Notification system
- `go_router: ^16.1.0` - Declarative routing
- `fl_chart: ^0.68.0` - Progress visualizations
- `home_widget: ^0.8.0` - Home screen widgets
- `in_app_purchase: ^3.1.13` - Subscriptions
- `workmanager: ^0.9.0+3` - Background tasks

## When Confused About...
- **Habit recurrence**: Read `RRULE_ARCHITECTURE.md` sections on "System Architecture Overview" and "Data Flow"
- **Build errors**: Check `BUILD_SCRIPTS_README.md` and use automated PowerShell scripts
- **Notification bugs**: Reference `NOTIFICATION_REFACTORING_PLAN.md` module responsibilities
- **Database migrations**: See `ISAR_MIGRATION_PLAN.md` for migration strategy
- **Widget updates**: Check `WIDGET_UPDATE_ARCHITECTURE.md` for home screen widget architecture
- **Performance issues**: Look for `PERFORMANCE_OPTIMIZATION_SUMMARY.md` and `MEMORY_PERFORMANCE_OPTIMIZATION.md`
