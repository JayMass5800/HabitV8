# Widget Background Update Implementation Plan

## Problem Analysis

### Current Behavior
Your home screen widgets **do not update until the app is opened** because:

1. **WidgetUpdateWorker** (Android WorkManager) runs every 15 minutes and hourly
2. However, it only reads from **SharedPreferences** (`HomeWidgetPreferences`)
3. The SharedPreferences data is only written when the **Flutter app is running**
4. When app is closed/killed:
   - Isar database listener stops
   - No new data is written to SharedPreferences
   - WorkManager updates widgets with stale data

### Root Cause
```
┌─────────────────────────────────────────────────────────────┐
│ Current Flow (App Closed)                                   │
├─────────────────────────────────────────────────────────────┤
│ 1. WorkManager triggers WidgetUpdateWorker                  │
│ 2. Worker reads from SharedPreferences (STALE DATA)         │
│ 3. Worker updates widget UI with stale data                 │
│ 4. Widget shows yesterday's habits ❌                        │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ Current Flow (App Open)                                     │
├─────────────────────────────────────────────────────────────┤
│ 1. App opens Isar database                                  │
│ 2. Flutter listener writes FRESH data to SharedPreferences  │
│ 3. Widget updates with fresh data ✅                         │
└─────────────────────────────────────────────────────────────┘
```

## Solution: Headless Dart Background Callback

Following the guidance in `error.md` and Flutter's `workmanager` package pattern, we need to:

### Step 1: Create Headless Dart Function
Create a top-level function that WorkManager can invoke even when the app is closed. This function will:
- Initialize Flutter bindings
- Open Isar database
- Fetch fresh habit data
- Write to SharedPreferences
- Update widgets

### Step 2: Register with WorkManager
Use the `workmanager` package (already in dependencies) to:
- Register the callback function
- Schedule daily morning updates (e.g., 7:00 AM)
- Ensure updates happen independently of app state

### Step 3: Native Android Integration
Modify `WidgetUpdateWorker` to trigger the Dart callback instead of just reading SharedPreferences.

---

## Implementation

### File 1: Create `lib/services/widget_background_service.dart`

```dart
import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';
import 'package:home_widget/home_widget.dart';
import 'package:path_provider/path_provider.dart';
import '../data/database_isar.dart';
import '../domain/model/habit.dart';
import 'rrule_service.dart';
import 'dart:convert';

/// Background service for updating widgets when app is closed
/// Uses WorkManager to run headless Dart code independently
class WidgetBackgroundService {
  static const String _taskName = 'widgetBackgroundUpdate';
  static const String _uniqueName = 'widgetDailyUpdate';

  /// Initialize background widget update service
  /// Called once in main.dart
  static Future<void> initialize() async {
    try {
      // Initialize WorkManager with callback dispatcher
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: true, // Set to false in production
      );

      // Register daily task for morning updates
      await scheduleDailyUpdate();

      debugPrint('✅ Widget background service initialized');
    } catch (e) {
      debugPrint('❌ Error initializing widget background service: $e');
    }
  }

  /// Schedule daily widget update for morning (7:00 AM local time)
  static Future<void> scheduleDailyUpdate() async {
    try {
      final now = DateTime.now();
      final nextRun = DateTime(now.year, now.month, now.day, 7, 0, 0);
      final initialDelay = nextRun.isAfter(now)
          ? nextRun.difference(now)
          : nextRun.add(const Duration(days: 1)).difference(now);

      // Register periodic task (every 24 hours)
      await Workmanager().registerPeriodicTask(
        _uniqueName,
        _taskName,
        frequency: const Duration(hours: 24),
        initialDelay: initialDelay,
        constraints: Constraints(
          networkType: NetworkType.not_required,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresDeviceIdle: false,
          requiresStorageNotLow: false,
        ),
        backoffPolicy: BackoffPolicy.exponential,
        backoffPolicyDelay: const Duration(minutes: 5),
      );

      debugPrint(
          '✅ Daily widget update scheduled for ${nextRun.hour}:${nextRun.minute.toString().padLeft(2, '0')}');
    } catch (e) {
      debugPrint('❌ Error scheduling daily widget update: $e');
    }
  }

  /// Cancel scheduled updates
  static Future<void> cancelScheduledUpdates() async {
    await Workmanager().cancelByUniqueName(_uniqueName);
    debugPrint('🔕 Widget background updates cancelled');
  }

  /// Trigger immediate widget update (for testing)
  static Future<void> triggerImmediateUpdate() async {
    await Workmanager().registerOneOffTask(
      'immediateWidgetUpdate',
      _taskName,
      initialDelay: const Duration(seconds: 5),
    );
    debugPrint('🧪 Immediate widget update triggered');
  }
}

/// Top-level callback dispatcher for WorkManager
/// CRITICAL: Must be a top-level function, not a class method
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    debugPrint('🔄 Widget background task started: $taskName');

    try {
      // Initialize Flutter bindings for background execution
      WidgetsFlutterBinding.ensureInitialized();

      // Set app group ID for iOS widget data sharing
      await HomeWidget.setAppGroupId('group.com.habittracker.habitv8.widget');

      // Open Isar database
      final dir = await getApplicationSupportDirectory();
      final isar = await IsarDatabaseService.getInstanceWithPath(dir.path);
      final habitService = HabitServiceIsar(isar);

      // Fetch all active habits
      final habits = await habitService.getAllHabits();
      final activeHabits = habits.where((h) => h.isActive).toList();

      debugPrint('📊 Fetched ${activeHabits.length} active habits from Isar');

      // Filter habits for today
      final today = DateTime.now();
      final todayHabits = _filterHabitsForToday(activeHabits, today);

      debugPrint('📅 Filtered to ${todayHabits.length} habits for today');

      // Prepare widget data
      final habitsJson = jsonEncode(
        todayHabits.map((h) => _habitToWidgetJson(h, today)).toList(),
      );

      // Save to HomeWidget preferences
      await HomeWidget.saveWidgetData('habits', habitsJson);
      await HomeWidget.saveWidgetData('today_habits', habitsJson);
      await HomeWidget.saveWidgetData('habits_data', habitsJson);
      await HomeWidget.saveWidgetData('habit_count', activeHabits.length);
      await HomeWidget.saveWidgetData('today_habit_count', todayHabits.length);
      await HomeWidget.saveWidgetData(
        'last_update',
        DateTime.now().toIso8601String(),
      );

      debugPrint('💾 Widget data saved to SharedPreferences');

      // Trigger widget UI update
      await HomeWidget.updateWidget(
        name: 'HabitTimelineWidgetProvider',
        androidName: 'HabitTimelineWidgetProvider',
      );
      await HomeWidget.updateWidget(
        name: 'HabitCompactWidgetProvider',
        androidName: 'HabitCompactWidgetProvider',
      );

      debugPrint('✅ Widget background update completed successfully');
      return Future.value(true);
    } catch (e) {
      debugPrint('❌ Error in widget background task: $e');
      return Future.value(false);
    }
  });
}

/// Filter habits for a specific date (using RRule or legacy logic)
List<Habit> _filterHabitsForToday(List<Habit> habits, DateTime date) {
  return habits.where((habit) {
    try {
      // Use RRule if available
      if (habit.usesRRule && habit.rruleString != null) {
        return RRuleService.isDueOnDate(habit, date);
      }

      // Legacy frequency logic
      final dateOnly = DateTime(date.year, date.month, date.day);

      switch (habit.frequency) {
        case HabitFrequency.daily:
          return true;

        case HabitFrequency.weekly:
          final dayOfWeek = date.weekday % 7; // 0 = Sunday
          return habit.selectedWeekdays.contains(dayOfWeek);

        case HabitFrequency.monthly:
          return habit.selectedMonthDays.contains(date.day);

        case HabitFrequency.yearly:
          return habit.selectedYearlyDates.any((yearlyDate) {
            return yearlyDate.month == date.month &&
                yearlyDate.day == date.day;
          });

        case HabitFrequency.hourly:
          return habit.hourlyTimes.isNotEmpty;

        case HabitFrequency.single:
          if (habit.singleDateTime != null) {
            final singleDateOnly = DateTime(
              habit.singleDateTime!.year,
              habit.singleDateTime!.month,
              habit.singleDateTime!.day,
            );
            return singleDateOnly == dateOnly;
          }
          return false;

        default:
          return false;
      }
    } catch (e) {
      debugPrint('⚠️ Error filtering habit ${habit.name}: $e');
      return false;
    }
  }).toList();
}

/// Convert Habit to widget-compatible JSON
Map<String, dynamic> _habitToWidgetJson(Habit habit, DateTime date) {
  final isCompleted = habit.completionDates.any((completionDate) {
    return completionDate.year == date.year &&
        completionDate.month == date.month &&
        completionDate.day == date.day;
  });

  return {
    'id': habit.id,
    'name': habit.name,
    'isActive': habit.isActive,
    'isCompleted': isCompleted,
    'frequency': habit.frequency.toString().split('.').last,
    'notificationTime': habit.notificationTime?.toIso8601String(),
    'selectedWeekdays': habit.selectedWeekdays,
    'selectedMonthDays': habit.selectedMonthDays,
    'selectedYearlyDates':
        habit.selectedYearlyDates.map((d) => d.toIso8601String()).toList(),
    'hourlyTimes': habit.hourlyTimes,
    'singleDateTime': habit.singleDateTime?.toIso8601String(),
    'difficulty': habit.difficulty.toString().split('.').last,
    'category': habit.category,
    'streakCount': habit.streakCount,
  };
}
```

### File 2: Update `lib/data/database_isar.dart`

Add a new static method to open Isar with a custom path (needed for background execution):

```dart
// Add this method to IsarDatabaseService class

/// Get Isar instance with custom path (for background execution)
static Future<Isar> getInstanceWithPath(String customPath) async {
  final isar = await Isar.open(
    [HabitSchema],
    directory: customPath,
    name: 'habitv8', // Same name as main instance
  );
  return isar;
}
```

### File 3: Update `lib/main.dart`

Initialize the background service:

```dart
// Add after _initializeWidgetService() call (around line 140)

// Initialize widget background service for updates when app is closed
_initializeWidgetBackgroundService();

// Add this function with the other initialization functions:

/// Initialize widget background service for morning updates
void _initializeWidgetBackgroundService() async {
  try {
    // Small delay to let other services initialize
    await Future.delayed(const Duration(seconds: 3));
    await WidgetBackgroundService.initialize();
    AppLogger.info(
        '✅ Widget background service initialized - widgets will update at 7 AM daily');
  } catch (e) {
    AppLogger.error('Error initializing widget background service', e);
    // Don't block app startup if background service fails
  }
}

// Add import at top of file:
import 'services/widget_background_service.dart';
```

### File 4: Update `pubspec.yaml`

Ensure `workmanager` dependency is present (already exists):

```yaml
dependencies:
  workmanager: ^0.9.0+3 # Already present ✅
```

### File 5: Update Android Configuration

#### `android/app/src/main/AndroidManifest.xml`

Ensure WorkManager permissions are present (should already exist):

```xml
<!-- Already present in your manifest -->
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
```

---

## Testing Plan

### Test 1: Immediate Update (When App is Closed)

```dart
// Add test button in Settings screen
ElevatedButton(
  onPressed: () async {
    await WidgetBackgroundService.triggerImmediateUpdate();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Widget will update in 5 seconds (app can be closed)'),
      ),
    );
  },
  child: const Text('Test Widget Background Update'),
)
```

**Test Steps:**
1. Open app and tap "Test Widget Background Update"
2. **Close the app completely** (swipe away from recent apps)
3. Wait 5-10 seconds
4. Check home screen widget - should show current data

### Test 2: Morning Update

```powershell
# Use ADB to check WorkManager logs
adb logcat | Select-String "widgetBackgroundUpdate|WidgetBackgroundService|Workmanager"
```

**Test Steps:**
1. Change the scheduled time to 1-2 minutes from now in `scheduleDailyUpdate()`
2. Build and install app
3. Close app completely
4. Wait for scheduled time
5. Check home screen widget updates automatically

### Test 3: Data Accuracy

1. Complete a habit in the app
2. Close the app
3. Wait for background update (or trigger immediate update)
4. Widget should show the completion even though app was closed

---

## Key Benefits

✅ **Independent Updates**: Widgets update at 7 AM daily, regardless of app state  
✅ **Fresh Data**: Directly reads from Isar database, not stale SharedPreferences  
✅ **Battery Efficient**: Uses WorkManager's optimized scheduling  
✅ **Reliable**: Survives battery optimization and doze mode  
✅ **RRule Compatible**: Works with both legacy frequency and new RRule system  

---

## Migration Path

### Phase 1: Implementation (1-2 hours)
1. Create `widget_background_service.dart`
2. Update `database_isar.dart` with `getInstanceWithPath()`
3. Update `main.dart` to initialize service
4. Add test button to Settings screen

### Phase 2: Testing (30 minutes)
1. Test immediate background update
2. Test scheduled morning update
3. Verify data accuracy
4. Check battery impact

### Phase 3: Refinement (Optional)
1. Adjust update frequency if needed
2. Add additional update times (e.g., evening refresh)
3. Implement smart scheduling based on user's most active times

---

## Potential Issues & Solutions

### Issue 1: "Isar instance already open"
**Solution**: Use `Isar.openAsync()` with proper instance management

### Issue 2: Background task killed by battery saver
**Solution**: Already handled - WorkManager uses JobScheduler which survives battery optimization

### Issue 3: iOS widget updates
**Solution**: iOS uses different mechanism (Timeline Provider). Current implementation focuses on Android. iOS can be added later using similar pattern.

### Issue 4: Data consistency
**Solution**: Background task and main app share same Isar database file, ensuring consistency

---

## Next Steps

Would you like me to:
1. **Implement this solution now** - I can create/update all the files
2. **Start with just the test** - Add immediate trigger button to verify it works
3. **Review existing setup first** - Check if there's any conflicting WorkManager usage

Let me know and I'll proceed with the implementation! 🚀
