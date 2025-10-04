# HabitV8 AI Coding Agent Instructions

## Project Overview
HabitV8 is a cross-platform habit tracking Flutter app (Android, iOS, Web, Desktop) with AI-powered insights, local-first Hive database, and advanced notification/alarm system. Currently on feature branch `feature/rrule-refactoring` migrating from legacy frequency system to RFC 5545 RRule standard.

## Critical Architecture Patterns

### Data Layer: Hive + Riverpod + Migration Strategy
- **Database**: Hive NoSQL with `@HiveType` annotations (typeId 0-2 reserved for Habit models)
- **State Management**: Riverpod providers (`databaseProvider`, `habitServiceProvider`) with stale data recovery
- **Migration Pattern**: Dual-field system during RRule refactoring:
  - Legacy: `HabitFrequency` enum + `selectedWeekdays/selectedMonthDays/hourlyTimes/selectedYearlyDates` (deprecated)
  - Modern: `rruleString` + `dtStart` + `usesRRule` flag (target state)
  - **CRITICAL**: Never remove legacy fields until migration is complete; use `usesRRule` flag to determine which system to read
- **Models**: `lib/domain/model/habit.dart` contains Habit, HabitFrequency enum, HabitDifficulty enum
- **Error Recovery**: Database providers auto-recover from `StaleDataException` and closed box errors via `ref.invalidate()`

### Service Layer: Modular Services with Single Responsibility
- **RRule Service** (`lib/services/rrule_service.dart`): Central RRule operations - ALWAYS use `getInstances()` not `getAllInstances()` (API requirement), all DateTime must be UTC
- **Notification System** (refactored to 6 modules in `lib/services/notifications/`):
  - `notification_core.dart`: Initialization, permissions, channels (300 lines)
  - `notification_scheduler.dart`: Time-based reminders (600 lines)
  - `notification_alarm_scheduler.dart`: System alarms (500 lines)
  - `notification_action_handler.dart`: User actions (700 lines)
  - `notification_storage.dart`: Persistence (400 lines)
  - `notification_service.dart`: Facade/coordinator (200 lines)
- **Alarm System**: Hybrid model using `AlarmManagerService` (system alarms) + `notification_service` (notifications)
- **Widget System**: `WidgetIntegrationService` + `home_widget` package - callback MUST be registered in `main()` before widget interactions

### UI Layer: Screens + Reusable Widgets
- **Navigation**: GoRouter with 5 main routes (timeline, all_habits, calendar, insights, settings)
- **Screens**: `lib/ui/screens/` for full pages, `lib/widgets/` for cross-screen components, `lib/ui/widgets/` for screen-specific
- **State**: Riverpod providers for app state, StatefulWidget only for UI-specific local state

## Development Workflows

### Build & Version Management (PowerShell on Windows)
```powershell
# Auto-increment patch version (8.2.0+11 → 8.2.1+12) and build
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
- RRule tests: `test/services/rrule_service_test.dart` (11 tests), `test/rrule_minimal_test.dart` (API verification)

### Git Strategy
- **Main Branch**: `master` (stable)
- **Current Branch**: `feature/rrule-refactoring` (active development)
- **Rollback Tag**: `v1.0-pre-rrule` (stable snapshot before RRule work)
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

### HiveField Management
- **NEVER reuse typeId or HiveField numbers** - will corrupt database
- Next available: typeId 3+, HiveField 31+ for Habit class
- Deprecated fields MUST remain until migration complete (e.g., legacy frequency fields)

### RRule Integration Pattern (ACTIVE REFACTORING)
When modifying frequency-related code:
1. Check `habit.usesRRule` flag first
2. If true: Use `RRuleService` methods (`getOccurrences()`, `isDueOnDate()`)
3. If false: Fall back to legacy frequency logic
4. Document migration status in code comments
5. See `RRULE_REFACTORING_PLAN.md` for phase status and affected files

### Notification System Patterns
- **NEVER** import `notification_service_monolithic.dart.bak` - it's archived backup
- Use modular services in `lib/services/notifications/`
- Schedule notifications via `NotificationScheduler`, not directly through plugin
- Action handling: Goes through `NotificationActionHandler` with storage persistence

### Android Native Integration
- Kotlin code: `android/app/src/main/kotlin/com/habittracker/habitv8/MainActivity.kt` (829 lines)
- Method channels: `RINGTONE_CHANNEL`, `SYSTEM_SOUND_CHANNEL`, `NATIVE_ALARM_CHANNEL`, `ANDROID_RESOURCES_CHANNEL`, `WIDGET_UPDATE_CHANNEL`
- Edge-to-edge: Uses `enableEdgeToEdge()` + `WindowCompat.setDecorFitsSystemWindows()` for Android 15+ compatibility

## Key Documentation Files
- `DEVELOPER_GUIDE.md`: Comprehensive architecture, setup, deployment
- `RRULE_REFACTORING_PLAN.md`: Phase-by-phase RRule migration plan with file impact analysis
- `RRULE_ARCHITECTURE.md`: RRule system architecture diagrams and data flow
- `NOTIFICATION_REFACTORING_PLAN.md`: Notification modularization plan
- `BUILD_SCRIPTS_README.md`: PowerShell build automation guide
- `CHANGELOG.md`: Version history and feature additions

## Common Pitfalls to Avoid
1. **RRule API**: Don't use `getAllInstances()` - it hangs. Use `getInstances()` with UTC DateTime
2. **Hive Migration**: Never delete legacy fields during active refactoring - use dual-system approach
3. **Database Errors**: StaleDataException is recoverable - check `database.dart` provider pattern
4. **Widget Callbacks**: Must register in `main()` before any widget interactions (see `main.dart:42-48`)
5. **Build Numbers**: Always increment for Play Store uploads (automated in build scripts)
6. **Notification File Size**: Original `notification_service.dart` was 3,517 lines and caused IDE issues - keep modules under 800 lines
7. **Android 15 Compatibility**: Use `enableEdgeToEdge()` not deprecated window flags

## Quick Start for New Features
1. Determine layer: Data (model), Service (business logic), or UI (screens/widgets)
2. Check if RRule-related: Reference `RRULE_REFACTORING_PLAN.md` Phase status
3. Add to appropriate directory maintaining existing structure
4. Use Riverpod providers for state, not StatefulWidget unless UI-only
5. Add unit tests in mirrored `test/` structure
6. Run `flutter pub run build_runner build` if using Hive annotations
7. Test on Android (primary platform) then iOS

## Dependencies of Note
- `rrule: ^0.2.15` - RFC 5545 recurrence rules (CRITICAL: v0.2.17+ installed)
- `flutter_riverpod: ^2.4.10` - State management
- `hive: ^2.2.3` + `hive_flutter: ^1.1.0` - Local database
- `flutter_local_notifications: ^18.0.1` - Cross-platform notifications
- `go_router: ^16.1.0` - Declarative routing
- `fl_chart: ^0.68.0` - Progress visualizations
- `home_widget: ^0.8.0` - Home screen widgets
- `in_app_purchase: ^3.1.13` - Subscriptions

## When Confused About...
- **Habit recurrence**: Read `RRULE_ARCHITECTURE.md` sections on "System Architecture Overview" and "Data Flow"
- **Build errors**: Check `BUILD_SCRIPTS_README.md` and use automated PowerShell scripts
- **Notification bugs**: Reference `NOTIFICATION_REFACTORING_PLAN.md` module responsibilities
- **Database migrations**: See `database.dart` provider error recovery pattern (lines 20-70)
- **Testing RRule**: Run `test/rrule_minimal_test.dart` to verify API behavior before complex changes
