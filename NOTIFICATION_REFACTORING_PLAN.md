# Notification Service Refactoring Plan

## Current Problem
The `notification_service.dart` file is **3,517+ lines** with **66 methods**, suffering from:
- Repeated file truncation/corruption
- Violations of Single Responsibility Principle
- IDE performance issues
- Difficult maintenance and testing

## Proposed Modular Architecture

### Module Breakdown (6 Files)

```
lib/services/notifications/
├── notification_core.dart              # Core initialization & permissions (300 lines)
├── notification_scheduler.dart         # Schedule notifications (600 lines)
├── notification_alarm_scheduler.dart   # Alarm-based scheduling (500 lines)
├── notification_action_handler.dart    # Handle user actions (700 lines)
├── notification_storage.dart           # Persist pending actions (400 lines)
└── notification_service.dart           # Facade/coordinator (200 lines)
```

---

## 1️⃣ **notification_core.dart** (~300 lines)
**Responsibility**: Initialization, permissions, and channel management

**Methods to move** (13 methods):
- `initialize()`
- `_createNotificationChannels()`
- `recreateNotificationChannels()`
- `_requestAndroidPermissions()`
- `_ensureNotificationPermissions()`
- `_isAndroid12Plus()`
- `isAndroid12Plus()`
- `canScheduleExactAlarms()`
- `checkBatteryOptimizationStatus()`
- `_startPeriodicCleanup()`
- Plugin initialization
- Channel configurations
- Permission status checks

**Dependencies**:
- `FlutterLocalNotificationsPlugin`
- `PermissionService`
- `DeviceInfoPlus`

---

## 2️⃣ **notification_scheduler.dart** (~600 lines)
**Responsibility**: Schedule and cancel notifications (time-based reminders)

**Methods to move** (22 methods):
- `scheduleNotification()`
- `showNotification()`
- `scheduleDailyNotification()`
- `scheduleDailyHabitReminder()`
- `scheduleHabitNotifications()`
- `scheduleHabitNotificationsOnly()`
- `_scheduleNotificationsOnly()`
- `_scheduleDailyHabitNotifications()`
- `_scheduleWeeklyHabitNotifications()`
- `_scheduleMonthlyHabitNotifications()`
- `_scheduleYearlyHabitNotifications()`
- `_scheduleSingleHabitNotifications()`
- `_scheduleHourlyHabitNotifications()`
- `_verifyNotificationScheduled()`
- `cancelNotification()`
- `cancelAllNotifications()`
- `cancelHabitNotifications()`
- `cancelHabitNotificationsByHabitId()`
- `_cancelSnoozeNotificationsForHabit()`
- Notification building helpers
- Timezone calculations

**Dependencies**:
- `NotificationCore` (for plugin access)
- `timezone` package
- `Habit` model

---

## 3️⃣ **notification_alarm_scheduler.dart** (~500 lines)
**Responsibility**: System alarm scheduling (wake-device alarms)

**Methods to move** (12 methods):
- `scheduleHabitAlarms()`
- `scheduleHabitAlarm()`
- `_scheduleDailyHabitAlarms()`
- `_scheduleWeeklyHabitAlarms()`
- `_scheduleMonthlyHabitAlarms()`
- `_scheduleYearlyHabitAlarms()`
- `_scheduleSingleHabitAlarms()`
- `_scheduleHourlyHabitAlarms()`
- `_getNextWeekdayDateTime()`
- Alarm-specific helpers

**Dependencies**:
- `AlarmManagerService`
- `Habit` model
- `NotificationCore`

---

## 4️⃣ **notification_action_handler.dart** (~700 lines)
**Responsibility**: Handle notification taps and actions (complete, snooze)

**Methods to move** (20 methods):
- `onBackgroundNotificationResponse()`
- `_onNotificationTapped()`
- `_handleNotificationAction()`
- `_processStoredAction()`
- `processPendingActions()`
- `processPendingActionsManually()`
- `_processPendingActionsWithDirectHandler()`
- `setNotificationActionCallback()`
- `setDirectCompletionHandler()`
- `_completeHabitInBackground()`
- `_completeHabitFromNotification()`
- `_handleSnoozeAction()`
- `handleSnoozeActionWithName()`
- `_fallbackSnoozeScheduling()`
- `_emergencySnoozeNotification()`
- Callback management
- Action routing

**Dependencies**:
- `NotificationScheduler` (for snoozing)
- `NotificationStorage` (for persistence)
- `DatabaseService`
- `HabitStatsService`
- `WidgetIntegrationService`

---

## 5️⃣ **notification_storage.dart** (~400 lines)
**Responsibility**: Persist pending actions across app restarts

**Methods to move** (8 methods):
- `_storeActionForLaterProcessing()`
- `_storeActionInSharedPreferences()`
- `_storeActionInFile()`
- `_removeStoredAction()`
- `_removeActionFromSharedPreferences()`
- `_removeActionFromFile()`
- `_loadActionsFromFile()`
- `_clearActionsFromFile()`
- `_processActionsFromFile()`

**Dependencies**:
- `SharedPreferences`
- `path_provider`
- File I/O operations

---

## 6️⃣ **notification_service.dart** (NEW - ~200 lines)
**Responsibility**: Facade/coordinator - public API for the app

**Purpose**: 
- Provide a simple, unified interface to all notification functionality
- Delegate to specialized modules
- Maintain backward compatibility

**Example structure**:
```dart
import 'notifications/notification_core.dart';
import 'notifications/notification_scheduler.dart';
import 'notifications/notification_alarm_scheduler.dart';
import 'notifications/notification_action_handler.dart';

class NotificationService {
  static final _core = NotificationCore();
  static final _scheduler = NotificationScheduler();
  static final _alarmScheduler = NotificationAlarmScheduler();
  static final _actionHandler = NotificationActionHandler();

  // Public API - delegates to modules
  static Future<void> initialize() => _core.initialize();
  
  static Future<void> scheduleHabitNotifications(Habit habit) => 
      _scheduler.scheduleHabitNotifications(habit);
  
  static Future<void> scheduleHabitAlarms(Habit habit) =>
      _alarmScheduler.scheduleHabitAlarms(habit);
  
  // ... other delegation methods
}
```

---

## Implementation Strategy

### Phase 1: Preparation
1. ✅ **Fix truncation** - Restore missing lines first
2. ✅ **Run tests** - Ensure current functionality works
3. ✅ **Create backup** - Git commit before refactoring
4. ✅ **Create directory** - `lib/services/notifications/`

### Phase 2: Extract Modules (One at a time)
1. **Start with storage** (least dependencies)
2. **Then core** (foundation)
3. **Then schedulers** (depends on core)
4. **Then action handler** (depends on all)
5. **Finally facade** (coordinates everything)

### Phase 3: Testing & Migration
1. Run existing tests after each module extraction
2. Update imports throughout app
3. Verify notification functionality end-to-end
4. Monitor for issues

---

## Benefits of Refactoring

✅ **Maintainability**: Each file ~200-700 lines (manageable)
✅ **Testability**: Focused modules are easier to unit test
✅ **Reliability**: Smaller files less prone to corruption
✅ **Performance**: IDE handles smaller files better
✅ **Team collaboration**: Multiple devs can work on different modules
✅ **Clear boundaries**: Each module has single, clear responsibility
✅ **Easier debugging**: Issues isolated to specific modules

---

## Risk Mitigation

⚠️ **Risks**:
- Breaking existing functionality during refactoring
- Import hell (circular dependencies)
- Performance overhead from module coordination

🛡️ **Mitigations**:
- Keep facade as backward-compatible wrapper
- Extract one module at a time with full testing
- Use dependency injection to avoid circular imports
- Profile performance before/after refactoring

---

## Alternative: Quick Wins (If Full Refactor Not Possible)

If full refactoring is too risky right now, consider these incremental improvements:

1. **Split alarm vs notification scheduling** (2 files instead of 1)
2. **Extract action handling** to separate file
3. **Move storage logic** to separate file
4. **Keep rest as is** for now

This gets you from 1 file (3,500 lines) → 4 files (~800 lines each)

---

## Next Steps

**Option A - Full Refactoring** (recommended):
1. I can create all 6 modular files
2. Test each module independently
3. Update imports throughout the app
4. Verify full functionality

**Option B - Incremental Refactoring**:
1. Start with extracting storage (lowest risk)
2. Then extract one more module per iteration
3. Test thoroughly between each extraction

**Option C - Fix Current File First**:
1. Restore truncated sections
2. Fix compilation errors
3. Defer refactoring until critical bugs resolved

---

Which approach would you like to take?