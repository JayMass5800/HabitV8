# Testing Guide for V2 Critical Fixes

## Quick Test Commands

```powershell
# 1. Build and install to test device
flutter run

# 2. Or build APK for manual testing
./build_with_version_bump.ps1 -OnlyBuild -BuildType apk
```

---

## Test Scenario 1: Notification Action Buttons ✅

### Objective
Verify that Daily, Weekly, Monthly, and Yearly habits now show Complete and Snooze buttons

### Steps

1. **Create a Daily Habit**
   - Open app → Create Habit
   - Notice: "Simple/Advanced" toggle is now at the TOP
   - Stay in Simple mode
   - Name: "Test Daily Habit"
   - Select: "Daily" frequency
   - Enable notifications
   - Set notification time to 1 minute from now
   - Save

2. **Wait for Notification**
   - Wait 1-2 minutes for notification to appear
   - Notification should show:
     - Title: "🎯 Test Daily Habit"
     - Body: "Time to complete your daily habit..."
     - **Two action buttons:** [COMPLETE] [SNOOZE 30MIN]

3. **Test Complete Button**
   - Tap [COMPLETE] button
   - App should mark habit as complete for today
   - Check timeline screen - should show green checkmark

4. **Test Snooze Button** (Create another habit)
   - Create another daily habit
   - Wait for its notification
   - Tap [SNOOZE 30MIN]
   - Notification should dismiss
   - Wait 30 minutes - notification should reappear

### Expected Results
✅ All notifications have action buttons  
✅ Complete button works  
✅ Snooze button works  
✅ No crashes or errors  

---

## Test Scenario 2: Performance - Fast Habit Saving ⚡

### Objective
Verify that saving habits now takes < 2 seconds instead of 10+ seconds

### Steps

1. **Baseline Test - Simple Daily Habit**
   - Create new habit
   - Name: "Performance Test 1"
   - Frequency: Daily
   - Enable notifications
   - Set notification time
   - **Start timer** → Tap Save → **Stop timer**
   - Expected: < 2 seconds

2. **Weekly Habit with Multiple Days**
   - Create new habit
   - Name: "Performance Test 2"
   - Frequency: Weekly
   - Select all 7 days of the week
   - Enable notifications
   - **Start timer** → Tap Save → **Stop timer**
   - Expected: < 2 seconds

3. **Monthly Habit with Multiple Days**
   - Create new habit
   - Name: "Performance Test 3"
   - Frequency: Monthly
   - Select 5+ days of the month
   - Enable notifications
   - **Start timer** → Tap Save → **Stop timer**
   - Expected: < 2 seconds

4. **Advanced Mode - Complex RRule**
   - Create new habit
   - Name: "Performance Test 4"
   - Switch to "Advanced" mode
   - Create pattern: "Every 2 weeks on Monday and Thursday"
   - **Start timer** → Tap Save → **Stop timer**
   - Expected: < 2 seconds

### Expected Results
✅ All saves complete in < 2 seconds  
✅ No UI freezing  
✅ Smooth navigation back to main screen  
✅ Habits appear immediately in timeline  

### Performance Metrics
| Test | Before Fix | After Fix |
|------|-----------|----------|
| Daily habit | 10+ seconds | < 1 second |
| Weekly (7 days) | 12+ seconds | < 1 second |
| Monthly (10 days) | 15+ seconds | < 1 second |
| Advanced RRule | 10+ seconds | < 1 second |

---

## Test Scenario 3: Streamlined UX Flow 🎨

### Objective
Verify that the confusing dual-layer frequency selection is gone

### Steps

1. **Open Create Habit Screen**
   - Tap "Create Habit" button
   - **Observe:** Simple/Advanced toggle is visible at TOP of Schedule section
   - **Observe:** NO frequency chips visible yet

2. **Simple Mode Flow**
   - Verify you're in "Simple" mode (toggle should show "Advanced")
   - **Now you see:** Frequency selector (Hourly, Daily, Weekly, etc.)
   - Select "Weekly"
   - **Now you see:** Weekday selector (Mon, Tue, Wed...)
   - Select Monday and Wednesday
   - **Verify:** Clear, linear flow - no confusion

3. **Switch to Advanced Mode**
   - Tap "Advanced" toggle (top right)
   - **Observe:** RRule builder appears immediately
   - **Observe:** No frequency chips - goes straight to pattern builder
   - Can create complex patterns like "2nd Tuesday of each month"

4. **Switch Back to Simple**
   - Tap "Simple" toggle
   - **Verify:** Returns to frequency selector
   - **Verify:** Previous selections are cleared (clean state)

### Expected Results
✅ One clear path: Simple/Advanced choice first  
✅ In Simple: Frequency → Configure  
✅ In Advanced: Direct to RRule builder  
✅ No more confusion about "what's the difference?"  
✅ No redundant selections  

### Old Flow (BEFORE - Confusing)
```
1. See: [Hourly] [Daily] [Weekly] [Monthly] [Yearly]
2. Select: Daily
3. See: [Simple/Advanced] toggle ← Why is this here?
4. Click: Advanced
5. See: Frequency selector AGAIN ← CONFUSION!
```

### New Flow (AFTER - Clear)
```
1. See: [Simple] [Advanced] toggle ← Clear choice first
2. Select: Simple
3. See: [Hourly] [Daily] [Weekly] [Monthly] [Yearly]
4. Select: Daily
5. Done! (or select Advanced for complex patterns)
```

---

## Test Scenario 4: Backward Compatibility 🔄

### Objective
Ensure existing habits and legacy features still work

### Steps

1. **Hourly Habits (Legacy System)**
   - Create hourly habit
   - Select multiple times (8:00 AM, 12:00 PM, 6:00 PM)
   - Select weekdays
   - Save
   - **Verify:** Works as before

2. **Single/One-time Habits**
   - Create one-time habit
   - Select future date/time
   - Save
   - **Verify:** Works as before

3. **Edit Existing Habits**
   - Edit a previously created habit
   - Change notification time
   - Save
   - **Verify:** Updates correctly

4. **Delete Habits**
   - Delete a habit
   - **Verify:** Notifications are cancelled
   - **Check:** Pending notifications list (Settings → Test Notifications)
   - **Verify:** No orphaned notifications

### Expected Results
✅ All legacy features work  
✅ No regressions  
✅ Edit/Delete operations work  
✅ Notification cleanup works  

---

## Debugging Commands

### Check Pending Notifications
```dart
// In app, navigate to Settings → Developer Options
// Tap "Show Pending Notifications"
// Should see list of scheduled notifications with details
```

### Check Logs
```powershell
# View Flutter logs
flutter logs

# Filter for notification-related logs
flutter logs | Select-String "notification|scheduled|cancelled"

# Look for performance markers
flutter logs | Select-String "Cancelled.*notifications|Scheduled.*notifications"
```

### Verify Notification Cancellation Optimization
Look for log messages like:
```
✅ Cancelled 8 notifications for habit: xyz (checked 23 pending)
```

**Before fix would show:**
```
✅ Cancelled all notifications for habit: xyz
(but actually tried 11,688 cancellations)
```

---

## Performance Monitoring

### Key Metrics to Observe

1. **Save Time**
   - Watch for "Habit created: [name]" log
   - Should appear < 1 second after tapping Save

2. **Notification Count**
   - Check "Scheduled X notifications" log
   - Daily: 1 notification
   - Weekly (3 days): 3 notifications
   - Monthly (5 days): 5 notifications

3. **Cancellation Efficiency**
   - Log should show: "Cancelled X notifications (checked Y pending)"
   - X should be small (< 20 typically)
   - Y should match total pending notifications in system

---

## Known Issues to Watch For

### Not Issues (Expected Behavior)
- **Hourly habits:** Don't show regular notifications if alarm is enabled (by design)
- **Past times:** Automatically adjusted to next valid occurrence
- **Snooze delay:** May take a few seconds to reschedule

### Potential Issues (Report if Seen)
- Notifications not appearing at all
- Action buttons not responding
- Save taking > 5 seconds
- App crash on save
- Duplicate notifications

---

## Success Criteria

All tests pass if:
- ✅ Notifications show action buttons
- ✅ Action buttons work (Complete and Snooze)
- ✅ Habits save in < 2 seconds
- ✅ UI flow is clear (no confusion)
- ✅ Existing habits still work
- ✅ No crashes or errors

---

## Reporting Issues

If you find any problems:

1. **Capture logs:**
   ```powershell
   flutter logs > test_log.txt
   ```

2. **Note details:**
   - What were you doing?
   - What did you expect?
   - What actually happened?
   - Can you reproduce it?

3. **Check for errors:**
   - Look for red error messages in logs
   - Check for "Failed to..." messages
   - Note any crashes

4. **Provide context:**
   - Device type (Android version)
   - Habit frequency type
   - Notification time settings
   - Screenshots if helpful

---

## Quick Verification Script

```powershell
# Run this to verify basic functionality
flutter run --debug

# Wait for app to start, then:
# 1. Create daily habit (save time should be < 2s)
# 2. Check logs for "Cancelled X notifications (checked Y pending)"
# 3. Wait for notification (should have action buttons)
# 4. Test Complete button
# 5. Test Snooze button

# If all work: ✅ Fixes are successful
```

---

## Estimated Test Time

- **Quick Test:** 10 minutes (scenarios 1 & 2 only)
- **Full Test:** 30 minutes (all scenarios)
- **Comprehensive Test:** 1 hour (including regression testing)

**Recommended:** Start with Quick Test, then Full Test if any issues found.
