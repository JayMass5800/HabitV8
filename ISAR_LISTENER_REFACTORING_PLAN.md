# Isar Listener Refactoring Plan
## Replacing Polling Timers with Reactive Listeners

## Executive Summary

**Current State:** Multiple services use polling timers (every 2 seconds, 1 minute, 30 minutes) to check for changes.

**Target State:** Use Isar's built-in reactive streams (`watchLazy()`, `watch()`) to get instant notifications of database changes.

**Benefits:**
- ✅ **Zero polling overhead** - No timers running when idle
- ✅ **Instant updates** - React to changes immediately, not after timer interval
- ✅ **Lower memory usage** - No timer closures, futures, or intermediate objects
- ✅ **Better battery life** - CPU sleeps when nothing is happening
- ✅ **Simpler code** - Event-driven is more maintainable than polling

---

## Existing Isar Listener Infrastructure

### Already Available (from `database_isar.dart`)

```dart
/// Watch for ANY habit changes (lazy - no data transfer)
/// Emits void event whenever any habit is added, updated, or deleted
Stream<void> watchHabitsLazy() {
  return _isar.habits.where().watchLazy(fireImmediately: false);
}

/// Watch for active habits changes (lazy)
Stream<void> watchActiveHabitsLazy() {
  return _isar.habits
      .filter()
      .isActiveEqualTo(true)
      .watchLazy(fireImmediately: false);
}

/// Watch all habits (reactive stream with full data)
Stream<List<Habit>> watchAllHabits() {
  return _isar.habits.where().watch(fireImmediately: true);
}

/// Watch specific habit
Stream<Habit?> watchHabit(String habitId) {
  return _isar.habits
      .filter()
      .idEqualTo(habitId)
      .watch(fireImmediately: true)
      .map((habits) => habits.isNotEmpty ? habits.first : null);
}
```

### Already Using Listeners ✅

1. **Timeline Screen** - Uses `ref.watch(habitsStreamIsarProvider)` ✅
2. **Notification Update Coordinator** - Uses `watchHabitsLazy()` ✅
3. **All Habits Screen** - Uses `ref.watch(habitsStreamIsarProvider)` ✅

---

## Services to Refactor

### 🔴 **Priority 1: Notification Queue Processor**

**Current Implementation:**
```dart
// lib/services/notification_queue_processor.dart (line 62)
_processingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
  await _processNextTask();
  if (_taskQueue.isEmpty) {
    _stopProcessing();
  }
});
```

**Problem:** Polls every 2 seconds even when queue is empty

**Isar Listener Solution:**

```dart
class NotificationQueueProcessor {
  static StreamSubscription<void>? _habitWatchSubscription;
  static bool _isProcessing = false;
  
  /// Initialize listener for habit changes
  static Future<void> initialize() async {
    final isar = await IsarDatabaseService.getInstance();
    final habitService = HabitServiceIsar(isar);
    
    // Listen to any habit changes
    _habitWatchSubscription = habitService.watchHabitsLazy().listen((_) {
      AppLogger.debug('🔔 Habit changed, triggering notification update');
      _scheduleNotificationUpdates();
    });
  }
  
  /// Schedule notifications for all habits (called when database changes)
  static Future<void> _scheduleNotificationUpdates() async {
    if (_isProcessing) {
      AppLogger.debug('⏭️ Already processing, skipping');
      return;
    }
    
    _isProcessing = true;
    
    try {
      final isar = await IsarDatabaseService.getInstance();
      final habitService = HabitServiceIsar(isar);
      final habits = await habitService.getAllHabits();
      
      // Process each habit
      for (final habit in habits) {
        if (habit.hasNotifications) {
          await _scheduleHabitNotifications(habit);
          // Small delay to prevent blocking
          await Future.delayed(const Duration(milliseconds: 50));
        }
      }
      
      AppLogger.info('✅ Notification updates completed');
    } finally {
      _isProcessing = false;
    }
  }
  
  /// Dispose listener
  static void dispose() {
    _habitWatchSubscription?.cancel();
    _habitWatchSubscription = null;
  }
}
```

**Impact:** 
- **Before:** 30 timer callbacks/minute when idle
- **After:** 0 callbacks when idle, instant response when habits change

---

### 🟡 **Priority 2: Widget Integration Service**

**Current Implementation:**
```dart
// lib/services/widget_integration_service.dart (line 553)
Timer.periodic(const Duration(minutes: 30), (timer) async {
  await _updateAllWidgets();
});
```

**Problem:** Polls every 30 minutes regardless of whether habits changed

**Isar Listener Solution:**

```dart
class WidgetIntegrationService {
  StreamSubscription<void>? _habitWatchSubscription;
  
  Future<void> initialize() async {
    // ... existing initialization ...
    
    // Set up habit change listener for automatic widget updates
    final isar = await IsarDatabaseService.getInstance();
    final habitService = HabitServiceIsar(isar);
    
    _habitWatchSubscription = habitService.watchHabitsLazy().listen((_) {
      AppLogger.debug('🔔 Habits changed, updating widgets');
      updateAllWidgets(); // Use existing debounced update method
    });
    
    AppLogger.info('✅ Widget listener initialized');
  }
  
  void dispose() {
    _habitWatchSubscription?.cancel();
    _habitWatchSubscription = null;
    _debounceTimer?.cancel();
  }
}
```

**Additional Optimization:** Also listen to app lifecycle for background/foreground:

```dart
// Update widgets when app comes to foreground (user might want to see latest)
AppLifecycleService.onAppResumed.listen((_) {
  updateAllWidgets();
});
```

**Impact:**
- **Before:** 2 timer callbacks/hour + widget updates on every DB change via separate listener
- **After:** 0 polling, instant updates on DB changes only

---

### 🟡 **Priority 3: Midnight Habit Reset Service**

**Current Implementation:**
```dart
// lib/services/midnight_habit_reset_service.dart (line 56)
_midnightTimer = Timer.periodic(const Duration(days: 1), (timer) async {
  await _performMidnightReset();
});
```

**Analysis:** This one is **legitimate** - it's not checking for database changes, it's scheduled for a specific time (midnight).

**Better Solution:** Use one-time scheduled timer, not periodic:

```dart
class MidnightHabitResetService {
  static Timer? _midnightTimer;
  
  static Future<void> _scheduleMidnightTimer() async {
    _midnightTimer?.cancel();
    
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1, 0, 0, 0);
    final timeUntilMidnight = nextMidnight.difference(now);
    
    AppLogger.info('⏰ Next midnight reset in: ${timeUntilMidnight.inHours}h ${timeUntilMidnight.inMinutes % 60}m');
    
    // ONE-TIME timer for next midnight
    _midnightTimer = Timer(timeUntilMidnight, () async {
      await _performMidnightReset();
      
      // After reset, schedule the next one (recursive)
      _scheduleMidnightTimer();
    });
  }
  
  static Future<void> _performMidnightReset() async {
    AppLogger.info('🌙 Performing midnight reset...');
    
    // ... reset logic ...
    
    // Isar will automatically notify all listeners of the changes!
    // No need to manually trigger widget updates or notifications
  }
}
```

**Why this works:**
- Uses one-time timer instead of periodic
- Reschedules itself after completing (same effect, cleaner code)
- Isar listeners will automatically catch the database changes and update UI/widgets

**Impact:**
- **Before:** Periodic timer object living in memory 24/7
- **After:** One-time timer, recreated after each midnight

---

### 🟢 **Priority 4: Remove Callback Re-registration**

**Current Implementation:**
```dart
// lib/main.dart (line 132)
Timer.periodic(const Duration(minutes: 1), (timer) {
  NotificationActionService.ensureCallbackRegistered();
});
```

**Problem:** Completely unnecessary - callback is already registered at startup

**Solution:** **DELETE THIS CODE**

```dart
// REMOVE THESE LINES:
// Timer.periodic(const Duration(minutes: 1), (timer) {
//   NotificationActionService.ensureCallbackRegistered();
// });

// The callback is already registered at startup (line ~48)
// If it somehow gets lost, that's a bug to fix, not poll around
```

**Impact:**
- **Before:** 60 unnecessary callbacks/hour
- **After:** 0 callbacks

---

### 🔵 **Priority 5: Calendar Renewal Service**

**Current Implementation:**
```dart
// lib/services/calendar_renewal_service.dart (line 45)
_renewalTimer = Timer.periodic(const Duration(hours: 24), (timer) async {
  await _renewalFunction();
});
```

**Analysis:** Check if this is still needed or if it's redundant with midnight reset service.

**Investigation Needed:**
1. What does calendar renewal do?
2. Is it redundant with midnight reset service?
3. Can it listen to Isar changes instead?

**Likely Solution:** 
- If it's UI-only (refreshing calendar view), use Isar listener
- If it's scheduled task (like midnight), use one-time timer pattern
- If it's redundant with midnight reset, **DELETE IT**

---

### 🔵 **Priority 6: Habit Continuation Service**

**Current Implementation:**
```dart
// lib/services/habit_continuation_service.dart (line 52)
Timer.periodic(Duration(hours: intervalHours), (timer) async {
  // ... continuation logic
});
```

**Analysis:** Need to understand what "continuation" means.

**Possible Solutions:**

1. **If it checks for habit progress:** Use Isar listener
   ```dart
   habitService.watchHabitsLazy().listen((_) {
     _checkHabitContinuation();
   });
   ```

2. **If it's time-based reminders:** Use notification scheduler (already event-driven)

3. **If it's genuinely scheduled:** Use one-time timer pattern with rescheduling

---

## Implementation Strategy

### Phase 1: Quick Wins (1-2 hours)
1. ✅ Remove callback re-registration timer (main.dart)
2. ✅ Convert notification queue to event-driven
3. ✅ Add dispose methods to cancel listeners

### Phase 2: Service Refactoring (2-4 hours)
4. ✅ Convert widget integration to Isar listener
5. ✅ Refactor midnight reset to one-time timer
6. ✅ Investigate and fix calendar renewal service
7. ✅ Investigate and fix habit continuation service

### Phase 3: Testing & Validation (2-3 hours)
8. ✅ Test with rapid habit changes (complete/uncomplete)
9. ✅ Test midnight rollover
10. ✅ Test widget updates
11. ✅ Monitor GC logs for improvement
12. ✅ Profile memory usage

### Phase 4: Cleanup (1 hour)
13. ✅ Remove obsolete code
14. ✅ Update documentation
15. ✅ Add code comments explaining reactive patterns

---

## Expected Performance Improvements

### Before (Current State)
```
Notification Queue:     30 callbacks/minute (2s polling)
Callback Registration:  1 callback/minute (1min polling)
Widget Updates:         2 callbacks/hour (30min polling)
Midnight Timer:         1 timer object (24h periodic)
Calendar Renewal:       1 callback/hour (24h polling)
Habit Continuation:     varies (hourly polling)

Total when idle:        ~31+ callbacks/minute = ~1,860/hour
GC every 2-3 seconds freeing 11-13MB
```

### After (With Isar Listeners)
```
Notification Queue:     0 callbacks (event-driven)
Callback Registration:  REMOVED
Widget Updates:         0 callbacks (event-driven)
Midnight Timer:         1 callback/day (scheduled)
Calendar Renewal:       0 callbacks (event-driven or removed)
Habit Continuation:     0 callbacks (event-driven or scheduled)

Total when idle:        ~0 callbacks
GC every 15-30 seconds freeing <5MB
```

### Projected Improvement
- **95% reduction in background activity** when idle
- **70-80% reduction in GC frequency**
- **60% reduction in memory usage**
- **Instant UI updates** instead of delayed polling

---

## Code Patterns to Follow

### ✅ Good: Event-Driven with Isar Listeners

```dart
class MyService {
  StreamSubscription<void>? _subscription;
  
  Future<void> initialize() async {
    final isar = await IsarDatabaseService.getInstance();
    final habitService = HabitServiceIsar(isar);
    
    // React to changes instantly
    _subscription = habitService.watchHabitsLazy().listen((_) {
      _handleHabitChange();
    });
  }
  
  void dispose() {
    _subscription?.cancel();
  }
}
```

### ❌ Bad: Polling with Periodic Timers

```dart
class MyService {
  Timer? _timer;
  
  void start() {
    // DON'T DO THIS - checks every N seconds even if nothing changed
    _timer = Timer.periodic(Duration(seconds: N), (timer) async {
      await _checkForChanges();
    });
  }
}
```

### ✅ Good: One-Time Scheduled Timer

```dart
class ScheduledService {
  Timer? _timer;
  
  void scheduleNext() {
    final timeUntilEvent = _calculateNextEventTime();
    
    _timer = Timer(timeUntilEvent, () async {
      await _performScheduledAction();
      scheduleNext(); // Reschedule for next occurrence
    });
  }
}
```

---

## Migration Checklist

- [ ] Remove `Timer.periodic` from main.dart (callback registration)
- [ ] Refactor NotificationQueueProcessor to use Isar listener
- [ ] Refactor WidgetIntegrationService to use Isar listener
- [ ] Convert MidnightHabitResetService to one-time timer pattern
- [ ] Investigate CalendarRenewalService - convert or remove
- [ ] Investigate HabitContinuationService - convert or remove
- [ ] Add dispose methods to all services with listeners
- [ ] Test all functionality still works
- [ ] Monitor GC logs before/after
- [ ] Profile memory usage before/after
- [ ] Update DEVELOPER_GUIDE.md with reactive patterns
- [ ] Update PERFORMANCE_ANALYSIS_GC_ISSUES.md with results

---

## Testing Scenarios

### Test 1: Rapid Database Changes
1. Complete/uncomplete habits rapidly
2. Verify widgets update instantly
3. Verify no GC spikes
4. Verify no timer overhead

### Test 2: Idle Behavior
1. Leave app idle for 5 minutes
2. Monitor GC logs (should be minimal)
3. Monitor CPU usage (should be near zero)
4. Check for any periodic activity

### Test 3: Midnight Rollover
1. Change system time to 11:59 PM
2. Wait for midnight timer to fire
3. Verify reset happens
4. Verify timer reschedules correctly

### Test 4: Background/Foreground
1. Put app in background
2. Modify habits (if possible via widget/notification)
3. Bring app to foreground
4. Verify UI updates instantly

---

## Additional Optimizations

### Use `watchLazy()` for Triggers
When you only need to know "something changed" but don't need the data:

```dart
// Good - lightweight, just a signal
habitService.watchHabitsLazy().listen((_) {
  _triggerUpdate();
});

// Less efficient - transfers all habit data
habitService.watchAllHabits().listen((habits) {
  _triggerUpdate(); // We don't even use the data!
});
```

### Debounce Rapid Changes
For services that do expensive work, debounce rapid changes:

```dart
StreamSubscription<void>? _subscription;
Timer? _debounceTimer;

_subscription = habitService.watchHabitsLazy().listen((_) {
  _debounceTimer?.cancel();
  _debounceTimer = Timer(const Duration(milliseconds: 300), () {
    _doExpensiveWork();
  });
});
```

### Combine Multiple Listeners
If you need to react to multiple database changes:

```dart
import 'package:rxdart/rxdart.dart';

final combined = Rx.combineLatest2(
  habitService.watchHabitsLazy(),
  settingsService.watchSettingsLazy(),
  (_, __) => null,
);

combined.listen((_) {
  _updateEverything();
});
```

---

## Documentation Updates Needed

1. **DEVELOPER_GUIDE.md**
   - Add "Reactive Programming with Isar" section
   - Document when to use `watch()` vs `watchLazy()`
   - Add listener lifecycle management guidelines

2. **PERFORMANCE_ANALYSIS_GC_ISSUES.md**
   - Update with Isar listener solution
   - Add before/after metrics
   - Mark as resolved

3. **Code Comments**
   - Add comments explaining why listeners are used
   - Document lifecycle (initialize, dispose)
   - Link to Isar documentation

---

## Resources

- [Isar Database - Watchers](https://isar.dev/watchers.html)
- [Flutter Reactive Programming](https://docs.flutter.dev/data-and-backend/state-mgmt/options#streams)
- [Riverpod StreamProvider](https://riverpod.dev/docs/providers/stream_provider/)
- [Dart Streams](https://dart.dev/tutorials/language/streams)

---

## Notes

- All Isar operations are **lazy by default** - they don't execute until you iterate/listen
- `watchLazy()` is more efficient than `watch()` when you don't need the actual data
- Always cancel stream subscriptions in `dispose()` to prevent memory leaks
- Isar listeners are **thread-safe** and can be used from any isolate
- Combining Isar listeners with Riverpod StreamProvider gives you reactive UI + reactive services

---

## Success Criteria

✅ **Zero periodic timers** running when app is idle  
✅ **GC frequency** reduced by 70%+  
✅ **Memory usage** reduced by 50%+  
✅ **Instant UI updates** on database changes  
✅ **No polling overhead** in production  
✅ **Better battery life** (measurable in Android Battery Historian)
