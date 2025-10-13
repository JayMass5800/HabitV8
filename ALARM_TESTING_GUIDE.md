# 🧪 Alarm System Testing Guide

## Quick Start Testing

After the migration from native Android alarms to awesome_notifications, follow this guide to verify everything works correctly.

---

## 🚀 Pre-Testing Setup

### 1. Build the App
```powershell
flutter clean
flutter pub get
flutter build apk --release
```

### 2. Install on Device
```powershell
flutter install
```

### 3. Grant Permissions
- Open the app
- Grant notification permissions when prompted
- Grant exact alarm permissions (Android 12+)
- Optionally disable battery optimization for best results

---

## ✅ Test Scenarios

### Test 1: Basic Daily Alarm
**Goal**: Verify basic alarm functionality

1. Create a new habit:
   - Name: "Test Daily Alarm"
   - Frequency: Daily
   - Set alarm time: 2 minutes from now
   - Select alarm sound: "Gentle Chime"
   - Snooze delay: 5 minutes

2. Wait for alarm to fire

3. **Expected Results**:
   - ✅ Screen wakes up
   - ✅ Full-screen notification appears
   - ✅ Title: "🚨 HABIT ALARM: Test Daily Alarm"
   - ✅ Custom sound plays (Gentle Chime)
   - ✅ Two buttons visible: "✅ COMPLETE" and "⏰ Snooze 5min"

4. **Test Complete Button**:
   - Tap "✅ COMPLETE"
   - ✅ Notification dismisses
   - ✅ Habit marked as complete in app
   - ✅ Widget updates (if widget added)

---

### Test 2: Snooze Functionality
**Goal**: Verify snooze reschedules alarm correctly

1. Create a new habit:
   - Name: "Test Snooze"
   - Frequency: Daily
   - Set alarm time: 2 minutes from now
   - Snooze delay: 3 minutes

2. Wait for alarm to fire

3. **Test Snooze Button**:
   - Tap "⏰ Snooze 3min"
   - ✅ Notification dismisses
   - ✅ Wait 3 minutes
   - ✅ Alarm fires again
   - ✅ Same notification appears

4. **Test Complete After Snooze**:
   - Tap "✅ COMPLETE"
   - ✅ Habit marked as complete
   - ✅ No more alarms fire

---

### Test 3: System Alarm Sounds
**Goal**: Verify system sounds work

1. Create habits with different system sounds:
   - Habit 1: "Default System Alarm"
   - Habit 2: "System Ringtone"
   - Habit 3: "System Notification"

2. Set each alarm 2 minutes apart

3. **Expected Results**:
   - ✅ Each alarm plays different system sound
   - ✅ Sounds are loud and clear
   - ✅ Sounds continue until dismissed

---

### Test 4: Weekly Alarm (Specific Days)
**Goal**: Verify weekly frequency works

1. Create a habit:
   - Name: "Test Weekly"
   - Frequency: Weekly
   - Select days: Monday, Wednesday, Friday
   - Set alarm time: 9:00 AM

2. **Expected Results**:
   - ✅ Alarm fires on Monday at 9:00 AM
   - ✅ Alarm fires on Wednesday at 9:00 AM
   - ✅ Alarm fires on Friday at 9:00 AM
   - ✅ No alarm on Tuesday, Thursday, Saturday, Sunday

---

### Test 5: App States
**Goal**: Verify alarms work in all app states

#### 5a. App Open (Foreground)
1. Create alarm for 2 minutes from now
2. Keep app open and visible
3. **Expected**: ✅ Alarm fires, notification appears

#### 5b. App Backgrounded
1. Create alarm for 2 minutes from now
2. Press home button (app in background)
3. **Expected**: ✅ Alarm fires, notification appears, screen wakes

#### 5c. App Fully Closed
1. Create alarm for 2 minutes from now
2. Swipe app away from recent apps
3. **Expected**: ✅ Alarm fires, notification appears, screen wakes

---

### Test 6: Multiple Alarms
**Goal**: Verify multiple alarms don't interfere

1. Create 3 habits with alarms:
   - Habit 1: Alarm at 10:00 AM
   - Habit 2: Alarm at 10:05 AM
   - Habit 3: Alarm at 10:10 AM

2. **Expected Results**:
   - ✅ All 3 alarms fire at correct times
   - ✅ Each shows correct habit name
   - ✅ Completing one doesn't affect others

---

### Test 7: Alarm Cancellation
**Goal**: Verify alarms can be cancelled

1. Create a habit with alarm
2. Edit the habit and disable alarm
3. **Expected**: ✅ Alarm doesn't fire

4. Re-enable alarm
5. **Expected**: ✅ Alarm fires again

---

### Test 8: Sound Preview
**Goal**: Verify sound preview in UI

1. Go to Create Habit screen
2. Tap "Select Alarm Sound"
3. Tap different sounds
4. **Expected Results**:
   - ✅ Each sound plays immediately
   - ✅ Previous sound stops when new one selected
   - ✅ Sound stops when dialog closed
   - ✅ Sound stops when "Cancel" tapped

---

### Test 9: Hourly Alarms
**Goal**: Verify hourly frequency works

1. Create a habit:
   - Name: "Test Hourly"
   - Frequency: Hourly
   - Set start time: Current hour + 1
   - Set end time: Current hour + 3

2. **Expected Results**:
   - ✅ Alarm fires at hour 1
   - ✅ Alarm fires at hour 2
   - ✅ Alarm fires at hour 3
   - ✅ No alarm before start time
   - ✅ No alarm after end time

---

### Test 10: Monthly Alarms
**Goal**: Verify monthly frequency works

1. Create a habit:
   - Name: "Test Monthly"
   - Frequency: Monthly
   - Select dates: 1st, 15th, 30th
   - Set alarm time: 9:00 AM

2. **Expected Results**:
   - ✅ Alarm fires on 1st of month
   - ✅ Alarm fires on 15th of month
   - ✅ Alarm fires on 30th of month
   - ✅ No alarm on other dates

---

### Test 11: Yearly Alarms
**Goal**: Verify yearly frequency works

1. Create a habit:
   - Name: "Test Yearly"
   - Frequency: Yearly
   - Select date: Today's date
   - Set alarm time: 2 minutes from now

2. **Expected Results**:
   - ✅ Alarm fires today
   - ✅ Alarm won't fire tomorrow
   - ✅ Alarm will fire again next year on same date

---

### Test 12: Widget Integration
**Goal**: Verify widget updates after alarm actions

1. Add widget to home screen
2. Create habit with alarm
3. Wait for alarm to fire
4. Tap "✅ COMPLETE" on notification
5. **Expected Results**:
   - ✅ Widget updates immediately
   - ✅ Habit shows as completed
   - ✅ Streak increments

---

## 🐛 Common Issues & Solutions

### Issue: Alarm doesn't fire
**Solutions**:
- Check notification permissions granted
- Check exact alarm permission granted (Android 12+)
- Disable battery optimization for the app
- Check alarm time is in the future
- Check habit is active

### Issue: No sound plays
**Solutions**:
- Check device volume is up
- Check Do Not Disturb is off
- Try different alarm sound
- Check sound file exists (for custom sounds)

### Issue: Complete button doesn't work
**Solutions**:
- Check app has background execution permission
- Check logs for errors
- Verify payload data is correct
- Restart app and try again

### Issue: Widget doesn't update
**Solutions**:
- Check Workmanager is initialized
- Check widget is added to home screen
- Check logs for widget update messages
- Refer to `error2.md` for widget update troubleshooting

---

## 📊 Test Results Template

Use this template to track your testing:

```
Date: ___________
Device: ___________
Android Version: ___________

[ ] Test 1: Basic Daily Alarm - PASS / FAIL
[ ] Test 2: Snooze Functionality - PASS / FAIL
[ ] Test 3: System Alarm Sounds - PASS / FAIL
[ ] Test 4: Weekly Alarm - PASS / FAIL
[ ] Test 5a: App Open - PASS / FAIL
[ ] Test 5b: App Backgrounded - PASS / FAIL
[ ] Test 5c: App Fully Closed - PASS / FAIL
[ ] Test 6: Multiple Alarms - PASS / FAIL
[ ] Test 7: Alarm Cancellation - PASS / FAIL
[ ] Test 8: Sound Preview - PASS / FAIL
[ ] Test 9: Hourly Alarms - PASS / FAIL
[ ] Test 10: Monthly Alarms - PASS / FAIL
[ ] Test 11: Yearly Alarms - PASS / FAIL
[ ] Test 12: Widget Integration - PASS / FAIL

Notes:
_________________________________
_________________________________
_________________________________
```

---

## 🔍 Debugging Tips

### View Logs
```powershell
# Real-time logs
flutter logs

# Filter for alarm-related logs
flutter logs | Select-String "ALARM|alarm|Alarm"

# Filter for notification logs
flutter logs | Select-String "notification|Notification"
```

### Key Log Messages to Look For
```
✅ Good Signs:
- "🚨 AlarmService initialized successfully"
- "🚨 Scheduling exact alarm:"
- "✅ Exact alarm scheduled successfully"
- "🔔 Notification action received: complete"
- "✅ Widget update scheduled via Workmanager"

❌ Warning Signs:
- "❌ Failed to schedule exact alarm"
- "No alarm data found for ID"
- "Failed to initialize AlarmService"
- "Error scheduling alarm"
```

---

## 📱 Test Devices

### Recommended Test Matrix:

| Android Version | Device Type | Priority |
|----------------|-------------|----------|
| Android 12 | Physical | High |
| Android 13 | Physical | High |
| Android 14 | Physical | Medium |
| Android 15+ | Physical | Medium |
| Android 11 | Emulator | Low |

**Note**: Physical devices are strongly recommended for alarm testing as emulators may not accurately simulate alarm behavior.

---

## ✅ Sign-Off Checklist

Before considering the migration complete:

- [ ] All 12 test scenarios pass
- [ ] No crashes or errors in logs
- [ ] Alarms work in all app states
- [ ] All frequency types work
- [ ] All alarm sounds work
- [ ] Snooze functionality works
- [ ] Complete button works
- [ ] Widget updates work
- [ ] Sound preview works
- [ ] No battery drain issues
- [ ] User experience is smooth
- [ ] Documentation is complete

---

**Happy Testing! 🎉**

If you encounter any issues, refer to:
- `ALARM_MIGRATION_COMPLETE.md` - Technical details
- `error2.md` - Widget update troubleshooting
- Flutter logs - Real-time debugging