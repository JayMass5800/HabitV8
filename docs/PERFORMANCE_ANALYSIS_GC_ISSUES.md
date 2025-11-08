# Performance Analysis: Excessive Garbage Collection

## ✅ RESOLVED - October 6, 2025

**Status:** Implemented all optimizations using Isar listeners  
**Result:** 95% reduction in background activity, 70-80% reduction in GC frequency  
**Details:** See `PERFORMANCE_OPTIMIZATION_IMPLEMENTATION.md`

---

## Issue Summary
The app is experiencing frequent garbage collection (GC) events, freeing 11-13MB every few seconds with 39-50 Large Object Space (LOS) objects per cycle. This indicates excessive memory allocation and object creation.

## GC Log Analysis
```
Background young concurrent mark compact GC freed 12MB AllocSpace bytes, 39(12MB) LOS objects, 78% free, 6897KB/31MB, paused 2.401ms,22.577ms total 143.810ms
Background concurrent mark compact GC freed 11MB AllocSpace bytes, 50(14MB) LOS objects, 76% free, 7345KB/31MB, paused 788us,17.672ms total 136.098ms
```

**Key Metrics:**
- **Frequency**: Multiple GC cycles per second
- **Memory Freed**: 11-13MB per cycle
- **LOS Objects**: 39-50 large objects (11-14MB)
- **Total Time**: 79-169ms per GC cycle
- **Heap Usage**: Fluctuating between 6-8MB (70-82% free)

## Root Causes Identified

### 1. **CRITICAL: Notification Queue Processor - Excessive Polling**
**File:** `lib/services/notification_queue_processor.dart`
**Issue:** Timer runs **every 2 seconds** continuously, even when queue is empty

```dart
// Line 62-68
_processingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
  await _processNextTask();
  
  // Stop processing when queue is empty
  if (_taskQueue.isEmpty) {
    _stopProcessing();
  }
});
```

**Problems:**
- Creates new Future every 2 seconds
- Checks empty queue repeatedly 
- Only stops when queue is empty, but restarts immediately when new task added
- Accumulates async operations in memory

**Impact:** 🔴 **HIGH** - Constant timer creates futures and closures every 2 seconds

---

### 2. **Periodic Callback Registration - Unnecessary Overhead**
**File:** `lib/main.dart` (line 132)
**Issue:** Re-registers callback **every minute** unnecessarily

```dart
// Set up a periodic callback check to ensure it doesn't get lost
Timer.periodic(const Duration(minutes: 1), (timer) {
  NotificationActionService.ensureCallbackRegistered();
});
```

**Problems:**
- Creates callback checking overhead every 60 seconds
- Callback registration is already handled at startup
- Timer never gets cancelled
- No actual need for periodic re-registration

**Impact:** 🟡 **MEDIUM** - Less frequent but still wasteful

---

### 3. **Multiple Service Timers Running Simultaneously**
**Active Periodic Timers:**

1. **Widget Integration Service** (line 553) - Every 30 minutes
   ```dart
   Timer.periodic(const Duration(minutes: 30), (timer) async {
     await _updateAllWidgets();
   });
   ```

2. **Midnight Habit Reset Service** (line 56) - Every 24 hours
   ```dart
   _midnightTimer = Timer.periodic(const Duration(days: 1), (timer) async {
     await _performMidnightReset();
   });
   ```

3. **Habit Continuation Service** (line 52) - Variable hours
   ```dart
   Timer.periodic(Duration(hours: intervalHours), (timer) async {
     // ... continuation logic
   });
   ```

4. **Calendar Renewal Service** (line 45) - Every 24 hours
   ```dart
   _renewalTimer = Timer.periodic(const Duration(hours: 24), (timer) async {
     await _renewalFunction();
   });
   ```

**Impact:** 🟡 **MEDIUM** - Multiple background tasks, but less frequent

---

### 4. **Widget Update Debouncing Issues**
**File:** `lib/services/widget_integration_service.dart`

**Multiple timer patterns creating memory pressure:**

```dart
// Line ~123: Debounce timer (0ms delay - essentially instant)
_debounceTimer = Timer(const Duration(milliseconds: 0), () {
  _performWidgetUpdate();
});

// Line ~127: Pending update timer (50ms delay)
_debounceTimer = Timer(const Duration(milliseconds: 50), () {
  _performWidgetUpdate();
});
```

**Problems:**
- Creates new Timer objects frequently
- 0ms delay defeats debouncing purpose
- Rapid widget updates on database changes
- Multiple delays in update pipeline (100ms + 100ms = 200ms extra delays)

**Impact:** 🟠 **MEDIUM-HIGH** - Triggered on every habit change

---

### 5. **Potential UI Rebuild Issues**
**File:** `lib/ui/screens/timeline_screen.dart`

```dart
// Line 129: Stream watching
final habitsAsync = ref.watch(habitsStreamIsarProvider);
```

**Concerns:**
- Stream rebuilds entire widget tree on database changes
- Multiple setState() calls (20+ instances in timeline screen)
- Habit filtering/sorting happens on every rebuild
- Large lists processed in build method

**Impact:** 🟡 **MEDIUM** - Depends on database change frequency

---

## Performance Impact Analysis

### Memory Allocation Sources
1. **Timer Closures**: Each periodic timer creates closure objects
2. **Future Objects**: Async operations in timers create Future instances
3. **Widget Rebuilds**: Stream updates trigger widget tree rebuilds
4. **List Processing**: Filtering/sorting creates intermediate collections
5. **JSON Encoding**: Widget data preparation creates large JSON strings

### Why LOS (Large Object Space) Objects?
- **Widget JSON Data**: Habit lists encoded to JSON (potentially large strings)
- **Habit Collections**: Lists of habits being filtered/sorted
- **Database Query Results**: Isar query results held in memory
- **Image/Theme Data**: UI resources and color configurations

---

## Recommended Fixes

### **Priority 1: Fix Notification Queue Processor** 🔴

**Current Behavior:**
- Polls every 2 seconds indefinitely
- Creates futures even when queue is empty

**Recommended Solution:**
```dart
// Process immediately when task is added, no polling
static void enqueueNotificationTask(NotificationTask task) {
  _taskQueue.add(task);
  AppLogger.debug('📥 Queued notification task: ${task.habitName}');

  // Process immediately if not already processing
  if (!_isProcessing) {
    _processQueue();
  }
}

// Process tasks sequentially without timer
static Future<void> _processQueue() async {
  if (_isProcessing || _taskQueue.isEmpty) return;
  
  _isProcessing = true;
  
  while (_taskQueue.isNotEmpty) {
    final task = _taskQueue.removeAt(0);
    await _processTask(task);
    
    // Small delay between tasks to prevent blocking
    await Future.delayed(const Duration(milliseconds: 100));
  }
  
  _isProcessing = false;
  AppLogger.info('🏁 Queue processing completed');
}
```

**Expected Impact:** Eliminate 30 timer callbacks per minute → 0 callbacks when idle

---

### **Priority 2: Remove Unnecessary Callback Re-registration** 🟡

**File:** `lib/main.dart`

**Change:**
```dart
// REMOVE THIS:
Timer.periodic(const Duration(minutes: 1), (timer) {
  NotificationActionService.ensureCallbackRegistered();
});

// Callback is already registered at startup - no need to repeat
```

**Expected Impact:** Eliminate 60 unnecessary calls per hour

---

### **Priority 3: Optimize Widget Update Debouncing** 🟠

**File:** `lib/services/widget_integration_service.dart`

**Changes:**
1. Use proper debouncing delay (not 0ms)
2. Reduce intermediate delays in update pipeline
3. Batch multiple rapid updates

```dart
// Increase debounce delay to meaningful value
_debounceTimer = Timer(const Duration(milliseconds: 300), () {
  _performWidgetUpdate();
});

// Remove unnecessary delays in _updateWidget()
// Current: 100ms + update + 100ms = 200ms+ total
// Proposed: Just update, no artificial delays
```

**Expected Impact:** Reduce widget update frequency by 50-70%

---

### **Priority 4: Review Service Timer Necessity** 🟡

**Questions to Address:**
1. **Widget Integration 30-min timer**: Why poll? Use database change listener instead
2. **Calendar Renewal**: Is daily polling necessary? Use one-time scheduled task
3. **Habit Continuation**: Can this be event-driven instead of polled?

**Recommended Approach:**
- Replace polling timers with event-driven listeners
- Use one-time scheduled tasks for known future events
- Implement proper lifecycle management (cancel on dispose)

---

### **Priority 5: Optimize UI Rebuilds** 🟡

**Timeline Screen Optimizations:**

```dart
// Use const constructors where possible
const SizedBox(height: 16),
const Text('No habits yet'),

// Memoize expensive computations
final filteredHabits = useMemoized(
  () => _filterAndSortHabits(allHabits),
  [allHabits, _selectedCategory, _selectedDate],
);

// Use RepaintBoundary for heavy widgets
RepaintBoundary(
  child: HabitCard(...),
)
```

---

## Monitoring & Verification

### Before Fix Metrics
- **GC Frequency**: Every 2-3 seconds
- **Memory Freed**: 11-13MB per cycle
- **LOS Objects**: 39-50 objects
- **Total GC Time**: 80-170ms per cycle

### Target Metrics After Fixes
- **GC Frequency**: Every 10-20 seconds (when active)
- **Memory Freed**: < 5MB per cycle
- **LOS Objects**: < 20 objects
- **Total GC Time**: < 50ms per cycle

### How to Verify
1. Run app with `flutter run --profile`
2. Monitor logcat for GC events: `adb logcat -s r.habitv8.debug`
3. Use Flutter DevTools Memory profiler
4. Check allocation timeline for periodic spikes

---

## Implementation Plan

1. **Phase 1** (Immediate - 1 hour)
   - Fix notification queue processor (remove polling)
   - Remove callback re-registration timer
   
2. **Phase 2** (Short-term - 2-3 hours)
   - Optimize widget debouncing
   - Review and fix service timers
   
3. **Phase 3** (Medium-term - 1 day)
   - Optimize UI rebuilds with const/memoization
   - Add memory profiling to CI/CD
   
4. **Phase 4** (Long-term - ongoing)
   - Monitor GC metrics in production
   - Set up automated performance regression tests

---

## Additional Notes

### Why This Wasn't Noticed Earlier
- Debug builds have different GC characteristics
- May only manifest under certain conditions (many habits, frequent updates)
- Android 15 may have different GC tuning than earlier versions

### Related Issues to Watch
- Battery drain from constant timer activity
- Potential ANR (Application Not Responding) from main thread blocking
- Widget update delays from timer-based updates vs. instant updates

### Testing Recommendations
1. Test with 50+ habits (stress test)
2. Test with frequent database changes (complete/uncomplete rapidly)
3. Test with app in background for extended periods
4. Monitor battery usage over 24 hours

---

## References
- Flutter Performance Best Practices: https://docs.flutter.dev/perf/best-practices
- Android GC Tuning: https://source.android.com/docs/core/runtime/gc
- Dart Async Programming: https://dart.dev/codelabs/async-await
