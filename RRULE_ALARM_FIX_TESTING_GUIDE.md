# RRule Alarm Fix - Quick Testing Guide

## What Was Fixed
Alarms now properly respect RRule start dates (`dtStart`) and end dates (`UNTIL`). Previously, alarms would fire immediately regardless of the start date setting.

## Quick Test Steps

### Test 1: Daily Habit Starting Tomorrow ⭐ (Your Reported Issue)
1. Create a new **Daily** habit
2. Enable **Advanced Mode** (RRule)
3. Set **Start Date** to **Tomorrow**
4. Set **End Date** to **3 days from tomorrow**
5. Enable **Alarm**
6. Set alarm time to 5 minutes from now
7. Save the habit

**Expected Result:**
- ❌ NO alarm should go off today (within 5 minutes)
- ✅ Alarm should only start tomorrow at the set time
- Timeline should NOT show the habit today
- Widgets should NOT show the habit today

### Test 2: Weekly Habit Starting Next Week
1. Create a new **Weekly** habit
2. Enable **Advanced Mode** (RRule)
3. Set **Start Date** to **next Monday**
4. Select days: Mon, Wed, Fri
5. Enable **Alarm**
6. Save the habit

**Expected Result:**
- ❌ No alarms this week
- ✅ Alarms start next Monday at selected days only

### Test 3: Habit with End Date
1. Create a new **Daily** habit
2. Enable **Advanced Mode** (RRule)
3. Set **Start Date** to **Today**
4. Set **End Date** to **3 days from today**
5. Enable **Alarm**
6. Save the habit

**Expected Result:**
- ✅ Alarms for the next 3 days
- ❌ No alarms after day 3

### Test 4: Verify Alarm Count (Check Logs)
Look for log messages like:
```
✅ Scheduled N RRule-based alarms for [habit name] (M valid occurrences found)
```

For a daily habit starting tomorrow with 3-day duration:
- Should show: "Scheduled 3 RRule-based alarms... (3 valid occurrences found)"
- NOT: "Scheduled 14 RRule-based alarms..." (that would mean it ignored start date)

## How to Check Scheduled Alarms

### Option 1: Check App Logs
Enable debug logging and look for:
```
🔔 Scheduling RRule-based alarms
✅ Scheduled N RRule-based alarms for [habit name]
No valid alarm occurrences found... (if start date is in future)
```

### Option 2: Android ADB Command
```bash
adb shell dumpsys alarm | grep -A 10 "com.habittracker.habitv8"
```

### Option 3: Check Notifications Settings
- Android Settings → Apps → HabitV8 → Notifications
- Scheduled notifications should only show future dates

## All Frequencies Covered

The fix applies to **ALL** frequency types when using RRule (Advanced Mode):

| Frequency | Start Date | End Date | Status |
|-----------|-----------|----------|--------|
| Daily | ✅ Fixed | ✅ Fixed | RRule-based |
| Weekly | ✅ Fixed | ✅ Fixed | RRule-based |
| Monthly | ✅ Fixed | ✅ Fixed | RRule-based |
| Yearly | ✅ Fixed | ✅ Fixed | RRule-based |
| Hourly | ✅ Fixed | ✅ Fixed | RRule-based |
| Single | ✅ Fixed | N/A | RRule-based |

## Legacy Habits (Non-RRule)
If you have old habits NOT using Advanced Mode (RRule):
- They continue to work as before
- No start/end date concept in legacy mode
- No changes needed

## Rebuild and Test

```powershell
# Quick rebuild and install
./quick_build.bat

# Or manual:
flutter clean
flutter pub get
flutter build apk --debug
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

## What to Look For

### ✅ SUCCESS Indicators
- Alarm does NOT fire before start date
- Alarm fires ON start date at correct time
- Alarm stops firing after end date
- Timeline shows habit only on valid dates
- Widget shows habit only on valid dates
- Logs show "RRule-based alarms" for RRule habits

### ❌ FAILURE Indicators
- Alarm fires immediately (before start date)
- Alarm continues after end date
- Timeline/widgets don't match alarm schedule
- Logs show "daily alarms" instead of "RRule-based alarms" for RRule habits

## Troubleshooting

### If Alarm Still Fires Before Start Date
1. Check if habit actually uses RRule:
   - Open habit → Edit → Advanced Mode should be enabled
   - Check logs for "Scheduling RRule-based alarms" message
   
2. Verify start date is set:
   - Edit habit → Check Start Date field
   - Should show future date, not today
   
3. Check logs for:
   ```
   No valid alarm occurrences found for habit: [name]
   (start: [future date], range: [today] to [14 days from now])
   ```
   This means the fix is working correctly!

### If No Alarms at All
1. Check alarm permission:
   - Android Settings → Apps → HabitV8 → Alarms & reminders → Enabled
   
2. Check exact alarm permission:
   - Android Settings → Apps → HabitV8 → Schedule exact alarms → Enabled
   
3. Verify habit alarm is enabled:
   - Edit habit → Alarm toggle should be ON

## Quick Verification Checklist

- [ ] No alarm today for habit starting tomorrow
- [ ] Alarm scheduled for valid dates only
- [ ] Timeline doesn't show habit before start date
- [ ] Widget doesn't show habit before start date
- [ ] Logs show "RRule-based alarms" message
- [ ] Alarm count matches expected occurrences

## Files Modified
- ✅ `lib/services/notifications/notification_alarm_scheduler.dart` - Added RRule support

## Related Documentation
- See `RRULE_ALARM_START_DATE_FIX.md` for technical details
- See `RRULE_ARCHITECTURE.md` for RRule system overview