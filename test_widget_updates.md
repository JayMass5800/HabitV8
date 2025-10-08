# Widget Update Testing Checklist

## Pre-Test Setup
1. ✅ Build and install the app with the new changes
2. ✅ Add at least 3 test habits with different frequencies (daily, weekly, hourly)
3. ✅ Add both Timeline and Compact widgets to home screen
4. ✅ Enable developer options and "Stay awake" for easier testing

## Test 1: Immediate Updates (Isar Listener)

### Test 1.1: Complete a Habit
1. Open the app
2. Complete a habit by tapping the checkmark
3. **Immediately** press home button (don't wait)
4. Check widget on home screen

**Expected:** Widget shows habit as completed within 1-2 seconds

**Result:** ⬜ PASS / ⬜ FAIL

---

### Test 1.2: Add a New Habit
1. Open the app
2. Create a new habit with notification enabled
3. Press home button
4. Check widget on home screen

**Expected:** Widget shows the new habit immediately

**Result:** ⬜ PASS / ⬜ FAIL

---

### Test 1.3: Edit a Habit
1. Open the app
2. Edit an existing habit (change name or time)
3. Press home button
4. Check widget on home screen

**Expected:** Widget reflects the changes immediately

**Result:** ⬜ PASS / ⬜ FAIL

---

### Test 1.4: Delete a Habit
1. Open the app
2. Delete a habit
3. Press home button
4. Check widget on home screen

**Expected:** Widget no longer shows the deleted habit

**Result:** ⬜ PASS / ⬜ FAIL

---

## Test 2: Notification Actions

### Test 2.1: Complete from Notification
1. Wait for a habit notification to appear
2. Tap "Complete" action button on notification
3. Check widget on home screen (don't open app)

**Expected:** Widget shows habit as completed within 1-2 seconds

**Result:** ⬜ PASS / ⬜ FAIL

---

### Test 2.2: Snooze from Notification
1. Wait for a habit notification to appear
2. Tap "Snooze" action button on notification
3. Check widget on home screen

**Expected:** Widget still shows habit as incomplete (correct behavior)

**Result:** ⬜ PASS / ⬜ FAIL

---

## Test 3: Midnight Reset

### Test 3.1: Natural Midnight Reset
1. Leave app running overnight (or in background)
2. Check widget at 12:01 AM

**Expected:** Widget shows all habits reset for new day

**Result:** ⬜ PASS / ⬜ FAIL

---

### Test 3.2: Manual Date Change
1. Complete a habit
2. Go to device Settings → Date & Time
3. Disable "Automatic date & time"
4. Change date to tomorrow
5. Check widget on home screen

**Expected:** Widget shows habits reset for new day

**Result:** ⬜ PASS / ⬜ FAIL

**Note:** Remember to re-enable "Automatic date & time" after test!

---

## Test 4: System Events

### Test 4.1: Timezone Change
1. Go to device Settings → Date & Time
2. Disable "Automatic time zone"
3. Change timezone (e.g., from EST to PST)
4. Check widget on home screen

**Expected:** Widget updates to reflect new timezone

**Result:** ⬜ PASS / ⬜ FAIL

**Note:** Remember to re-enable "Automatic time zone" after test!

---

### Test 4.2: Time Change
1. Go to device Settings → Date & Time
2. Disable "Automatic date & time"
3. Change time forward by 1 hour
4. Check widget on home screen

**Expected:** Widget updates to reflect new time

**Result:** ⬜ PASS / ⬜ FAIL

**Note:** Remember to re-enable "Automatic date & time" after test!

---

## Test 5: App Lifecycle

### Test 5.1: App in Background
1. Open app and complete a habit
2. Press home button (app in background)
3. Wait 5 minutes
4. Complete another habit from notification
5. Check widget

**Expected:** Widget updates even with app in background

**Result:** ⬜ PASS / ⬜ FAIL

---

### Test 5.2: App Force-Stopped
1. Go to Settings → Apps → HabitV8
2. Tap "Force Stop"
3. Return to home screen
4. Wait 1 minute
5. Check widget

**Expected:** Widget shows last known state (no crash)

**Result:** ⬜ PASS / ⬜ FAIL

---

### Test 5.3: App Reopened After Force-Stop
1. After Test 5.2, open the app
2. Complete a habit
3. Press home button
4. Check widget

**Expected:** Widget updates normally (Isar listener reactivated)

**Result:** ⬜ PASS / ⬜ FAIL

---

## Test 6: Battery Impact Verification

### Test 6.1: Check WorkManager Jobs
Run in terminal:
```powershell
adb shell dumpsys jobscheduler | Select-String "habitv8"
```

**Expected:** Should show NO periodic jobs scheduled (or very few)

**Result:** ⬜ PASS / ⬜ FAIL

---

### Test 6.2: Check Wake Locks
Run in terminal:
```powershell
adb shell dumpsys power | Select-String "HabitV8"
```

**Expected:** Should show minimal wake lock usage

**Result:** ⬜ PASS / ⬜ FAIL

---

### Test 6.3: Battery Stats (24-hour test)
Run in terminal:
```powershell
# Reset stats
adb shell dumpsys batterystats --reset

# Wait 24 hours of normal usage

# Get stats
adb shell dumpsys batterystats > battery_stats.txt
```

**Expected:** HabitV8 should show significantly reduced battery usage compared to before

**Result:** ⬜ PASS / ⬜ FAIL

---

## Test 7: Edge Cases

### Test 7.1: Multiple Rapid Completions
1. Open app
2. Rapidly complete 5 habits in quick succession (within 5 seconds)
3. Press home button immediately
4. Check widget

**Expected:** Widget shows all 5 habits as completed (debouncing works)

**Result:** ⬜ PASS / ⬜ FAIL

---

### Test 7.2: Widget After Device Reboot
1. Complete some habits
2. Reboot device
3. Check widget on home screen (don't open app yet)

**Expected:** Widget shows last known state (data persisted)

**Result:** ⬜ PASS / ⬜ FAIL

---

### Test 7.3: Widget Update After Reboot + App Open
1. After Test 7.2, open the app
2. Complete a habit
3. Press home button
4. Check widget

**Expected:** Widget updates normally (Isar listener reactivated)

**Result:** ⬜ PASS / ⬜ FAIL

---

## Test 8: Performance

### Test 8.1: Widget Update Speed
1. Open app
2. Complete a habit
3. **Time how long it takes** for widget to update after pressing home button

**Expected:** Widget updates within 1-3 seconds

**Actual Time:** _______ seconds

**Result:** ⬜ PASS / ⬜ FAIL

---

### Test 8.2: App Responsiveness
1. Open app
2. Navigate through different screens
3. Complete multiple habits

**Expected:** App remains responsive (no lag from widget updates)

**Result:** ⬜ PASS / ⬜ FAIL

---

## Summary

**Total Tests:** 21  
**Passed:** _____  
**Failed:** _____  
**Pass Rate:** _____%

### Critical Issues Found:
(List any critical issues that would prevent release)

---

### Minor Issues Found:
(List any minor issues that can be addressed later)

---

### Notes:
(Any additional observations)

---

## Sign-Off

**Tester:** _________________  
**Date:** _________________  
**Build Version:** _________________  
**Device:** _________________  
**Android Version:** _________________  

**Recommendation:**  
⬜ Ready for production  
⬜ Needs fixes before release  
⬜ Needs further testing  