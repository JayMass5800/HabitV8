# HabitV8 AI Coding Agent Instructions

## Project Overview
HabitV8 is a cross-platform habit tracking Flutter app (Android, iOS, Web, Desktop) with AI-powered insights, local-first Isar database (migrated from Hive), and advanced notification/alarm system using Awesome Notifications. The app is currently at version 9.0.1+37 and has completed the migration from legacy frequency system to RFC 5545 RRule standard.

**Last Updated:** November 7, 2025 (Phase 1 & 2 Cleanup Complete)

## Application Architecture Map

```
HabitV8/
├── docs/ (All documentation files - .md files)
│   ├── DEVELOPER_GUIDE.md
│   ├── RRULE_ARCHITECTURE.md
│   ├── NOTIFICATION_REFACTORING_PLAN.md
│   ├── BUILD_SCRIPTS_README.md
│   ├── CHANGELOG.md
│   └── ... (250+ other documentation files)
│
├── lib/
│   ├── main.dart (Entry point, GoRouter setup, initialization)
│   │
│   ├── data/ (Data Access Layer)
│   │   └── database_isar.dart (Isar database singleton, providers, Habit service)
│   │
│   ├── domain/ (Domain Models)
│   │   └── model/
│   │       ├── habit.dart (Habit model with RRule support)
│   │       └── scheduled_notification.dart (Notification metadata model)
│   │
│   ├── services/ (Business Logic Layer - 40+ services)
│   │   │
│   │   ├── Core Services
│   │   │   ├── rrule_service.dart (RFC 5545 recurrence rule operations)
│   │   │   ├── logging_service.dart (App-wide logging)
│   │   │   ├── theme_service.dart (Dark/light theme management)
│   │   │   ├── preferences_service.dart (SharedPreferences wrapper - NEW!)
│   │   │   └── permission_service.dart (Runtime permissions)
│   │   │
│   │   ├── Notification System (Modular)
│   │   │   ├── notification_service.dart (Facade - main entry point)
│   │   │   ├── notification_action_service.dart (Action callback coordinator)
│   │   │   ├── notification_update_coordinator.dart (Update orchestration)
│   │   │   ├── notification_queue_processor.dart (Queue management)
│   │   │   └── notifications/ (Internal modules)
│   │   │       ├── notification_core.dart (Init, permissions, channels)
│   │   │       ├── notification_scheduler.dart (Time-based reminders)
│   │   │       ├── notification_alarm_scheduler.dart (Alarm scheduling)
│   │   │       ├── notification_action_handler.dart (User action handling)
│   │   │       ├── notification_storage.dart (Pending action persistence)
│   │   │       ├── scheduled_notification_storage.dart (Isar-based metadata)
│   │   │       ├── notification_boot_rescheduler.dart (Post-reboot recovery)
│   │   │       └── notification_helpers.dart (Utility functions)
│   │   │
│   │   ├── Alarm System
│   │   │   ├── alarm_service.dart (Main alarm scheduling)
│   │   │   ├── alarm_snooze_service.dart (Snooze logic)
│   │   │   ├── alarm_complete_service.dart (Completion callbacks)
│   │   │   └── alarm_test_helper.dart (Testing utilities)
│   │   │
│   │   ├── Widget/Home Screen Integration
│   │   │   ├── widget_integration_service.dart (Main widget logic, Isar listeners)
│   │   │   ├── widget_background_update_service.dart (WorkManager updates)
│   │   │   └── widget_launch_handler.dart (Widget tap handling)
│   │   │
│   │   ├── Background Task Management
│   │   │   ├── work_manager_habit_service.dart (WorkManager integration)
│   │   │   ├── habit_continuation_manager.dart (Platform abstraction)
│   │   │   ├── midnight_habit_reset_service.dart (Daily reset logic)
│   │   │   ├── background_task_service.dart (General background tasks)
│   │   │   ├── reliable_scheduling_service.dart (Resilient scheduling)
│   │   │   ├── app_lifecycle_service.dart (App state monitoring)
│   │   │   └── ios_background_tasks_service.dart (iOS BGTaskScheduler)
│   │   │
│   │   ├── Insights & Analytics
│   │   │   ├── ai_service.dart (AI-powered habit insights)
│   │   │   ├── insights_service.dart (Statistics calculation)
│   │   │   ├── enhanced_insights_service.dart (Advanced analytics)
│   │   │   ├── trend_analysis_service.dart (Trend detection)
│   │   │   ├── habit_stats_service.dart (Habit-specific stats)
│   │   │   ├── achievements_service.dart (Gamification)
│   │   │   └── activity_recognition_service.dart (Activity patterns)
│   │   │
│   │   ├── Calendar Integration
│   │   │   └── calendar_service.dart (Device calendar sync)
│   │   │
│   │   ├── Data Management
│   │   │   ├── data_export_import_service.dart (Backup/restore)
│   │   │   └── cache_service.dart (Data caching)
│   │   │
│   │   ├── Suggestions & Recommendations
│   │   │   ├── category_suggestion_service.dart (Category recommendations)
│   │   │   └── comprehensive_habit_suggestions_service.dart (Habit ideas)
│   │   │
│   │   ├── Subscription & Purchases
│   │   │   ├── subscription_service.dart (In-app purchase management)
│   │   │   └── purchase_stream_service.dart (Purchase event stream)
│   │   │
│   │   ├── Audio & Media
│   │   │   ├── ringtone_service.dart (Ringtone picker)
│   │   │   └── android_resource_service.dart (Native resource access)
│   │   │
│   │   ├── User Experience
│   │   │   ├── onboarding_service.dart (First-time user experience)
│   │   │   └── performance_service.dart (Performance monitoring)
│   │   │
│   │   └── DEPRECATED (Archived to archive/deprecated_services/)
│   │       ├── habit_continuation_service.dart (Use MidnightHabitResetService)
│   │       └── calendar_renewal_service.dart (Use Isar listeners)
│   │
│   ├── ui/ (Presentation Layer)
│   │   ├── home_screen.dart (Bottom navigation container)
│   │   │
│   │   ├── screens/ (Full-page screens)
│   │   │   ├── timeline_screen.dart (Main habit list with completion)
│   │   │   ├── all_habits_screen.dart (All habits overview)
│   │   │   ├── calendar_screen.dart (Calendar view with filtering)
│   │   │   ├── insights_screen.dart (Statistics and analytics)
│   │   │   ├── stats_screen.dart (Detailed statistics)
│   │   │   ├── settings_screen.dart (App settings)
│   │   │   ├── create_habit_screen.dart (Habit creation - RRule-based)
│   │   │   ├── edit_habit_screen.dart (Habit editing)
│   │   │   ├── onboarding_screen.dart (First-time setup)
│   │   │   ├── purchase_screen.dart (Premium features)
│   │   │   └── ai_settings_screen.dart (AI configuration)
│   │   │
│   │   └── widgets/ (Reusable UI components)
│   │       ├── rrule_builder_widget.dart (RRule configuration UI)
│   │       ├── day_detail_sheet.dart (Day detail bottom sheet)
│   │       ├── calendar_selection_dialog.dart (Date picker)
│   │       ├── category_filter_widget.dart (Category filtering)
│   │       ├── create_habit_fab.dart (Floating action button)
│   │       ├── widget_timeline_view.dart (Widget-specific timeline)
│   │       ├── performance_optimized_widget.dart (Performance wrapper)
│   │       ├── premium_feature_guard.dart (Premium feature gating)
│   │       ├── app_lock_wrapper.dart (Biometric lock)
│   │       ├── standard_app_bar.dart (Consistent app bar)
│   │       ├── loading_widget.dart (Loading indicators)
│   │       ├── gamification_widgets.dart (Gamification UI)
│   │       ├── ai_insights_*.dart (AI-related widgets)
│   │       └── smooth_transitions.dart (Animation helpers)
│   │
│   ├── widgets/ (Cross-screen components)
│   │   └── alarm_test_widget.dart (Alarm testing UI)
│   │
│   └── utils/ (Utility Functions)
│       ├── date_utils.dart (Date/time utilities - NEW!)
│       └── notification_migration.dart (Migration helpers)
│
├── android/ (Android-specific code)
│   └── app/src/main/kotlin/.../MainActivity.kt (Method channels, edge-to-edge)
│
├── test/ (Unit tests - mirrors lib/ structure)
│   ├── services/
│   │   ├── rrule_service_test.dart
│   │   └── calendar_service_rrule_test.dart
│   └── ui/
│       └── calendar_weekday_filtering_test.dart
│
└── archive/ (Archived code - NOT in active use)
    ├── removed_backups/ (*.bak files)
    ├── deprecated_services/ (Old service implementations)
    └── old_screens/ (Previous screen versions)
```

### Service Dependency Graph (Key Relationships)

```
NotificationService (Facade)
  ├─→ NotificationCore (init, permissions)
  ├─→ NotificationScheduler (reminders)
  ├─→ NotificationAlarmScheduler (alarms)
  │    └─→ AlarmService (native alarms)
  ├─→ NotificationActionHandler (action callbacks)
  │    ├─→ NotificationStorage (persistence)
  │    └─→ ScheduledNotificationStorage (Isar)
  └─→ NotificationBootRescheduler (reboot recovery)

WidgetIntegrationService
  ├─→ IsarDatabase (Isar listeners for updates)
  ├─→ WidgetBackgroundUpdateService (WorkManager)
  └─→ ThemeService (theme sync)

HabitService (from database_isar.dart)
  ├─→ RRuleService (frequency calculations)
  ├─→ NotificationService (schedule reminders)
  └─→ AlarmService (schedule alarms)

MidnightHabitResetService
  ├─→ WorkManagerHabitService (Android background)
  └─→ NotificationService (reschedule)
```

### Complete Service Reference

#### Core Services (Foundation)
| Service | Location | Purpose | Key Methods |
|---------|----------|---------|-------------|
| **RRuleService** | `services/rrule_service.dart` | RFC 5545 recurrence rules | `getOccurrences()`, `isDueOnDate()` |
| **LoggingService** | `services/logging_service.dart` | App-wide logging | `AppLogger.info()`, `AppLogger.error()` |
| **ThemeService** | `services/theme_service.dart` | Theme management | `getThemeMode()`, `setThemeMode()` |
| **PreferencesService** | `services/preferences_service.dart` | SharedPreferences wrapper | `getString()`, `setString()`, etc. |
| **PermissionService** | `services/permission_service.dart` | Runtime permissions | `requestPermissions()` |

#### Notification System (9 modules)
| Module | Location | Purpose |
|--------|----------|---------|
| **NotificationService** | `services/notification_service.dart` | Facade - main entry point |
| **NotificationCore** | `services/notifications/notification_core.dart` | Initialization, channels |
| **NotificationScheduler** | `services/notifications/notification_scheduler.dart` | Schedule time-based reminders |
| **NotificationAlarmScheduler** | `services/notifications/notification_alarm_scheduler.dart` | Schedule alarm notifications |
| **NotificationActionHandler** | `services/notifications/notification_action_handler.dart` | Handle user actions |
| **NotificationStorage** | `services/notifications/notification_storage.dart` | Persist pending actions |
| **ScheduledNotificationStorage** | `services/notifications/scheduled_notification_storage.dart` | Isar-based metadata |
| **NotificationBootRescheduler** | `services/notifications/notification_boot_rescheduler.dart` | Post-reboot recovery |
| **NotificationHelpers** | `services/notifications/notification_helpers.dart` | Utility functions |

#### Alarm System (4 services)
| Service | Location | Purpose |
|---------|----------|---------|
| **AlarmService** | `services/alarm_service.dart` | Main alarm scheduling |
| **AlarmSnoozeService** | `services/alarm_snooze_service.dart` | Snooze logic |
| **AlarmCompleteService** | `services/alarm_complete_service.dart` | Completion callbacks |
| **AlarmTestHelper** | `services/alarm_test_helper.dart` | Testing utilities |

#### Widget & Background Services (8 services)
| Service | Location | Purpose |
|---------|----------|---------|
| **WidgetIntegrationService** | `services/widget_integration_service.dart` | Main widget logic, Isar listeners |
| **WidgetBackgroundUpdateService** | `services/widget_background_update_service.dart` | WorkManager background updates |
| **WidgetLaunchHandler** | `services/widget_launch_handler.dart` | Widget tap handling |
| **WorkManagerHabitService** | `services/work_manager_habit_service.dart` | WorkManager integration |
| **HabitContinuationManager** | `services/habit_continuation_manager.dart` | Platform abstraction |
| **MidnightHabitResetService** | `services/midnight_habit_reset_service.dart` | Daily reset logic |
| **BackgroundTaskService** | `services/background_task_service.dart` | General background tasks |
| **ReliableSchedulingService** | `services/reliable_scheduling_service.dart` | Resilient scheduling |
| **AppLifecycleService** | `services/app_lifecycle_service.dart` | App state monitoring |
| **IOSBackgroundTasksService** | `services/ios_background_tasks_service.dart` | iOS BGTaskScheduler |

#### Analytics & Insights (7 services)
| Service | Location | Purpose |
|---------|----------|---------|
| **AIService** | `services/ai_service.dart` | AI-powered insights |
| **InsightsService** | `services/insights_service.dart` | Statistics calculation |
| **EnhancedInsightsService** | `services/enhanced_insights_service.dart` | Advanced analytics |
| **TrendAnalysisService** | `services/trend_analysis_service.dart` | Trend detection |
| **HabitStatsService** | `services/habit_stats_service.dart` | Habit-specific stats |
| **AchievementsService** | `services/achievements_service.dart` | Gamification |
| **ActivityRecognitionService** | `services/activity_recognition_service.dart` | Activity patterns |

#### Data Management (3 services)
| Service | Location | Purpose |
|---------|----------|---------|
| **CalendarService** | `services/calendar_service.dart` | Device calendar sync |
| **DataExportImportService** | `services/data_export_import_service.dart` | Backup/restore |
| **CacheService** | `services/cache_service.dart` | Data caching |

#### User Experience (8 services)
| Service | Location | Purpose |
|---------|----------|---------|
| **CategorySuggestionService** | `services/category_suggestion_service.dart` | Category recommendations |
| **ComprehensiveHabitSuggestionsService** | `services/comprehensive_habit_suggestions_service.dart` | Habit ideas |
| **SubscriptionService** | `services/subscription_service.dart` | In-app purchases |
| **PurchaseStreamService** | `services/purchase_stream_service.dart` | Purchase events |
| **RingtoneService** | `services/ringtone_service.dart` | Ringtone picker |
| **AndroidResourceService** | `services/android_resource_service.dart` | Native resources |
| **OnboardingService** | `services/onboarding_service.dart` | First-time setup |
| **PerformanceService** | `services/performance_service.dart` | Performance monitoring |

#### Action Coordinators (2 services)
| Service | Location | Purpose |
|---------|----------|---------|
| **NotificationActionService** | `services/notification_action_service.dart` | Notification action callbacks |
| **NotificationUpdateCoordinator** | `services/notification_update_coordinator.dart` | Update orchestration |
| **NotificationQueueProcessor** | `services/notification_queue_processor.dart` | Queue management |

### Utility Classes
| Utility | Location | Purpose | Key Methods |
|---------|----------|---------|-------------|
| **DateTimeUtils** | `utils/date_utils.dart` | Date/time operations | `isSameDay()`, `startOfDay()`, `endOfDay()` |
| **NotificationMigration** | `utils/notification_migration.dart` | Migration helpers | Migration utilities |

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
- See `docs/GIT_BRANCHING_STRATEGY.md` for full branching strategy

## Project-Specific Conventions

### Documentation Structure
- **IMPORTANT**: All documentation files (.md) are stored in `docs/` folder
- Only `README.md` remains in project root (standard practice)
- When creating new documentation, always save to `docs/` folder
- Reference documentation files using `docs/` path prefix

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
- **NOTE:** All backup files (*.bak) have been archived to `archive/removed_backups/` as of Nov 2025
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
- `docs/DEVELOPER_GUIDE.md`: Comprehensive architecture, setup, deployment
- `docs/RRULE_ARCHITECTURE.md`: RRule system architecture diagrams and data flow
- `docs/NOTIFICATION_REFACTORING_PLAN.md`: Notification modularization plan
- `docs/BUILD_SCRIPTS_README.md`: PowerShell build automation guide
- `docs/CHANGELOG.md`: Version history and feature additions
- `docs/ISAR_MIGRATION_PLAN.md`: Database migration from Hive to Isar
- `docs/WIDGET_UPDATE_ARCHITECTURE.md`: Home screen widget architecture

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
- **Habit recurrence**: Read `docs/RRULE_ARCHITECTURE.md` sections on "System Architecture Overview" and "Data Flow"
- **Build errors**: Check `docs/BUILD_SCRIPTS_README.md` and use automated PowerShell scripts
- **Notification bugs**: Reference `docs/NOTIFICATION_REFACTORING_PLAN.md` module responsibilities
- **Database migrations**: See `docs/ISAR_MIGRATION_PLAN.md` for migration strategy
- **Widget updates**: Check `docs/WIDGET_UPDATE_ARCHITECTURE.md` for home screen widget architecture
- **Performance issues**: Look for `docs/PERFORMANCE_OPTIMIZATION_SUMMARY.md` and `docs/MEMORY_PERFORMANCE_OPTIMIZATION.md`
