# V2 Notification Fix - Quick Test Script

## 🚀 Quick Test (5 minutes)

### Test 1: Create Weekly Habit in V2 ✅
```
1. Open app
2. Tap "+" button
3. Name: "Test Weekly V2"
4. Frequency: Select "Weekly" (ChoiceChip)
5. Select Monday, Wednesday, Friday
6. Toggle "Enable Notifications" ON
7. Set time: 2 minutes from now
8. Tap "Save"
9. ✅ Should see green "Habit created successfully!" message
10. Wait 2 minutes
11. ✅ Notification should appear
12. Tap "COMPLETE" on notification
13. ✅ Check timeline - habit should show as completed
```

### Test 2: Create Daily Habit in V2 ✅
```
1. Create new habit
2. Name: "Test Daily V2"
3. Frequency: "Daily"
4. Enable notifications, set time to 1 minute from now
5. Save
6. Wait for notification
7. Tap "SNOOZE 30MIN"
8. ✅ Should get new notification in 30 minutes
```

### Test 3: Verify Data Structure ✅
```
# Check logs while creating habit:
adb logcat | grep -E "Habit created|Notifications.*scheduled"

# Should see:
✅ Habit created: Test Weekly V2
✅ Notifications/alarms scheduled successfully for habit: Test Weekly V2
```

### Test 4: Test Error Handling ✅
```
1. Turn OFF notification permissions in Android settings
2. Create new habit with notifications enabled
3. Try to save
4. ✅ Should see ORANGE warning: "Habit created but notifications/alarms could not be scheduled"
5. ✅ Habit should still be created (check All Habits screen)
```

## 🔍 Debug if Issues Occur

### If "Complete" button doesn't work:

```bash
# Check if habitId is in payload:
adb logcat | grep "habitId"

# Should see:
Extracted habitId from payload: [uuid]

# Check if callback is registered:
adb logcat | grep "callback"

# Should see:
✅ Notification action callback registered
✅ Callback currently set: true
```

### If habit doesn't save:

```bash
# Check for database errors:
adb logcat | grep -E "Database|Retry"

# If you see "Database box is closed":
✅ Should see: "Retrying habit creation with fresh database connection..."
✅ Should see: "✅ Habit created successfully on retry"
```

### If notifications don't schedule:

```bash
# Check notification scheduling:
adb logcat | grep -E "scheduleHabitNotification|Permission"

# Common issues:
- "permissions not granted" → Re-enable notification permissions
- "no time set" → Make sure you set a notification time
- "Notifications disabled" → Check the toggle is ON
```

## ✅ Success Indicators

After the fix, you should see:

1. **Green success message** after creating habit ✅
2. **Notifications appear on schedule** ✅
3. **Complete button marks habit as done** ✅
4. **Snooze button reschedules notification** ✅
5. **Weekly habits only notify on selected days** ✅
6. **Monthly habits notify on selected dates** ✅

## 📊 Comparison

| Feature | V1 | V2 Before Fix | V2 After Fix |
|---------|----|--------------|--------------| 
| Complete button | ✅ | ❌ | ✅ |
| Snooze button | ✅ | ❌ | ✅ |
| Success message | ✅ | ❌ | ✅ |
| Error retry | ✅ | ❌ | ✅ |
| Warning on failure | ✅ | ❌ | ✅ |
| Weekly scheduling | ✅ | ❌ | ✅ |
| Monthly scheduling | ✅ | ❌ | ✅ |

## 🐛 Known Issues (Unrelated to This Fix)

These issues exist in both V1 and V2:
- Hourly habits with alarms may require exact alarm permission
- Single/one-time habits use legacy system (not RRule)
- Advanced mode yearly patterns have complexity limits

## 📝 What Changed

**One line summary:** V2 now uses V1's exact code for saving habits and scheduling notifications.

**Key fixes:**
1. Populates all data fields (selectedMonthDays, selectedYearlyDates, selectedWeekdays)
2. Has database retry logic
3. Shows success/error messages to user
4. Matches V1's proven, working implementation

## 🎯 Expected Behavior After Fix

**Creating a Weekly Habit:**
1. Select days → ✅ Days are saved to both `_simpleWeekdays` AND `selectedWeekdays`
2. Save → ✅ Habit saves with full data structure
3. Notifications schedule → ✅ Uses saved weekdays to schedule
4. Notification appears → ✅ Has habitId in payload
5. Tap complete → ✅ Callback fires, habit marked complete
6. UI updates → ✅ Timeline shows completion

**All steps now work identically to V1** ✅
