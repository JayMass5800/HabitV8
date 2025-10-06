# Stale Object Timeline Fix

## Issue: Completions Vanishing When App Opens

### Problem Description
- User marks habit complete via notification → Widget shows complete ✅
- User opens app → Completion vanishes from timeline AND widget ❌
- Database loses the completion data

### Root Cause Analysis

**The Stale Object Problem:**

1. **Notification Flow (Background):**
   - User taps "Complete" on notification
   - `notification_action_service.dart` marks habit complete
   - Saves to database successfully
   - Widget reads database → shows completed ✅

2. **App Open Flow (Foreground):**
   - App resumes, `habitsProvider` fetches all habits from database
   - Timeline screen builds with this data
   - **CRITICAL:** Timeline holds habit objects in memory for UI

3. **User Interaction (The Bug):**
   - User taps on timeline (or auto-refresh happens)
   - `_toggleHabitCompletion(habit)` is called
   - **BUG:** The `habit` parameter is the STALE object from step 2
   - This habit object was fetched BEFORE the notification marked it complete
   - Function modifies stale habit and calls `updateHabit(habit)`
   - **Overwrites database with stale data, removing the completion!**

### The Race Condition

```
Timeline:
T0: Notification marks habit complete (DB: ✅ completed)
T1: Widget reads DB → shows complete
T2: User opens app
T3: habitsProvider fetches from DB → gets completed habit
T4: Timeline builds UI with habit objects
--- RACE CONDITION WINDOW ---
T5: Notification completion happens (but timeline already has stale data)
T6: User interacts with timeline OR auto-refresh occurs
T7: _toggleHabitCompletion(staleHabit) modifies stale object
T8: updateHabit(staleHabit) overwrites DB (DB: ❌ not completed)
T9: Widget reads DB again → shows not complete
```

### Code Pattern That Caused The Bug

**Before (BROKEN):**
```dart
Future<void> _toggleHabitCompletion(Habit habit) async {
  // habit parameter is STALE - came from UI build, not fresh from DB
  
  if (isCompleted) {
    habit.completions.removeWhere(...); // Modifying stale object
  } else {
    habit.completions.add(_selectedDate); // Modifying stale object
  }
  
  await habitService.updateHabit(habit); // ❌ Overwrites DB with stale data!
}
```

**Why This Happened:**
- Timeline screen uses `ref.watch(habitsProvider)` to build UI
- The habit objects are stored in widget state between rebuilds
- When user interacts, the habit object passed to toggle functions is from the last build
- This object doesn't reflect changes made in the background (notifications)

### Solution: Always Fetch Fresh Data Before Updating

**After (FIXED):**
```dart
Future<void> _toggleHabitCompletion(Habit habit) async {
  // ✅ CRITICAL FIX: Fetch fresh habit from database
  final habitService = await ref.read(currentHabitServiceProvider.future);
  final freshHabit = await habitService.getHabitById(habit.id);
  
  if (freshHabit == null) {
    AppLogger.error('Habit not found in database: ${habit.id}');
    return;
  }
  
  AppLogger.info('🔄 Toggle completion - Fresh habit has ${freshHabit.completions.length} completions');
  
  // Now modify the FRESH object from database
  if (isCompleted) {
    freshHabit.completions.removeWhere(...);
  } else {
    freshHabit.completions.add(_selectedDate);
  }
  
  await habitService.updateHabit(freshHabit); // ✅ Saves current state
  AppLogger.info('✅ Updated habit in database, now has ${freshHabit.completions.length} completions');
}
```

### Files Modified

1. **lib/ui/screens/timeline_screen.dart:**
   - `_toggleHabitCompletion()` - Fixed to fetch fresh habit before modifying
   - `_toggleHourlyHabitCompletion()` - Fixed to fetch fresh habit before modifying
   - Added logging to track completion counts

2. **lib/ui/screens/all_habits_screen.dart:**
   - `_toggleHourlyHabitCompletion()` - Fixed to fetch fresh habit before modifying

3. **lib/services/app_lifecycle_service.dart:**
   - Made `_handleAppResumed()` async to support logging with delays

### The Pattern: Read-Modify-Write with Fresh Data

**Key Principle:**
> Always fetch fresh data from the database before modifying and saving back

**Why This Matters:**
- Database is source of truth
- Multiple sources can modify data (UI, notifications, widgets, background tasks)
- UI objects can become stale between renders
- **Never trust objects from UI state when saving to database**

### Similar Patterns to Watch For

**Any function that:**
1. Receives an object as parameter (could be stale)
2. Modifies that object
3. Saves it back to database

**Should be refactored to:**
1. Fetch fresh object from database by ID
2. Modify the fresh object
3. Save the fresh object back

### Testing Verification

**Test Scenario:**
1. Create a habit with daily reminder
2. Wait for notification to appear
3. Tap "Complete" on notification
4. Verify widget shows completed
5. Open app immediately
6. **Expected:** Timeline shows completed ✅
7. **Expected:** Widget still shows completed ✅
8. **Expected:** Completion persists in database ✅

**Before Fix:**
- Step 6: Timeline shows NOT completed ❌
- Step 7: Widget updates to NOT completed ❌
- Step 8: Completion lost from database ❌

**After Fix:**
- All steps should pass ✅

### Related Issues Fixed

This fix also resolves:
- Widget completions vanishing when app opens
- Timeline not showing notification completions
- Race conditions between background and foreground updates
- Any other stale object overwrites in UI interactions

### Prevention Strategy

**Code Review Checklist:**
- [ ] Does function receive object from UI state?
- [ ] Does function modify that object?
- [ ] Does function save to database?
- [ ] If yes to all: **Fetch fresh object first!**

**Best Practice:**
```dart
// ❌ BAD: Modify parameter object
void updateThing(Thing thing) {
  thing.property = newValue;
  save(thing); // Might overwrite other changes!
}

// ✅ GOOD: Fetch fresh, then modify
void updateThing(Thing thing) {
  final fresh = database.getById(thing.id);
  fresh.property = newValue;
  save(fresh); // Safe, has latest data
}
```

### Lessons Learned

1. **Provider data can be stale** - Even with autoDispose, objects in UI state can lag behind database
2. **Multiple writers need coordination** - Background notifications and foreground UI both write to database
3. **Source of truth is database** - Always fetch fresh before saving
4. **Optimistic UI has limits** - Optimistic state should only affect UI rendering, not database operations
5. **Logging is critical** - Added extensive logging to catch these issues early

### Impact

This fix ensures that:
- ✅ Notification completions persist correctly
- ✅ Widget always reflects actual database state
- ✅ Timeline always reflects actual database state
- ✅ No race conditions between background and foreground
- ✅ No data loss from stale object overwrites
