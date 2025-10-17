# Testing Guide: Alarm Sound Fixes

## Pre-Test Requirements
1. Build and deploy the app: `flutter build apk --release`
2. Install on Android device
3. Enable developer logs to monitor in Android Studio
4. Open app and verify permissions are granted

---

## Test 1: Custom Alarm Sound Selection

### Procedure
1. Create a new habit (any frequency)
2. Enable alarm toggle
3. Set alarm time to NOW + 1 minute
4. Open alarm sound picker
5. **Select "Bell"** (or any non-default sound)
6. Save the habit
7. Wait for alarm to fire

### Expected Results
✅ Alarm fires with "Bell" sound (NOT system alarm)
✅ Sound loops continuously
✅ Logs show: `"Alarm sound URI from payload: sounds/Bell.mp3"`

### If Test Fails
- Check logs for: `"Failed to parse URI"` or `"Falling back to system alarm"`
- Verify `sounds/Bell.mp3` exists in assets/sounds/
- Check that `_normalizeAlarmSoundUri()` is being called

---

## Test 2: Alarm Looping

### Procedure
1. Set alarm for NOW + 1 minute
2. Select alarm sound: "Beeps" (distinctive repeating sound)
3. Wait for alarm to fire
4. Listen carefully to the sound pattern

### Expected Results
✅ "Beeps" plays, stops, then plays again (continuous loop)
✅ No gaps in between (should restart within 0.5 seconds of ending)
✅ Logs show repeated: `"🔄 Restarted looping alarm"`
✅ Sound continues until button pressed

### If Test Fails
- Verify `alarmLoopingTimers` is being used in Android
- Check that Handler is properly posting callbacks
- Ensure `postDelayed(runnable, 3000)` is being called
- Check device might be in battery saver mode (disable for testing)

---

## Test 3: Complete Button Stops Alarm Immediately

### Procedure
1. Set alarm for NOW + 1 minute
2. Select "Army_Alarm" (loud, longer sound)
3. Wait for alarm to fire
4. **Immediately** tap "COMPLETE" button
5. Observe the response

### Expected Results
✅ Alarm stops IMMEDIATELY (within <500ms)
✅ No further sound playback
✅ No device reboot required
✅ Logs show: `"✅ Stopped native alarm sound"`
✅ Logs show: `"🔇 Stopped looping handler"`

### If Test Fails
- Verify `removeCallbacksAndMessages(null)` is called on handler
- Check that both handler AND ringtone are stopped
- Ensure `stopAlarmSound()` is being reached

---

## Test 4: Snooze Button Stops and Reschedules

### Procedure
1. Set alarm for NOW + 1 minute
2. Wait for alarm to fire
3. Tap "SNOOZE 10MIN" button
4. Verify alarm stops
5. Verify new alarm notification shows

### Expected Results
✅ Alarm stops immediately
✅ New alarm scheduled for 10 minutes from now
✅ Same custom sound selected for snooze
✅ Logs show snooze alarm scheduled

---

## Test 5: Multiple Alarms Running

### Procedure
1. Create 3 habits with different alarm sounds
2. Set all to fire at approximately the same time
3. Wait for alarms to fire

### Expected Results
✅ All 3 alarms sound simultaneously
✅ Each plays its own selected sound
✅ All loop independently
✅ Can complete one without affecting others
✅ Logs show different `alarmId` for each

---

## Test 6: Device Goes to Sleep

### Procedure
1. Set alarm for NOW + 1 minute
2. Put device in pocket/face down (screen off)
3. Wait for alarm to fire

### Expected Results
✅ Alarm wakes device (full-screen intent working)
✅ Custom sound plays at full volume
✅ Byp asses silent/vibrate mode
✅ Screen turns on
✅ Notification shown

### Note
- Requires `USE_FULL_SCREEN_INTENT` permission
- Some devices may require additional settings
- Test on multiple devices if possible

---

## Test 7: Sound Selection Persists

### Procedure
1. Create habit with "Bubble" sound
2. Close app completely
3. Reopen app
4. Navigate to habit
5. Edit habit (view alarm settings)
6. Let alarm fire again

### Expected Results
✅ Habit still shows "Bubble" selected
✅ Alarm still uses "Bubble" sound
✅ Sound preference persisted correctly

---

## Debugging: Reading Logs

### Key Log Patterns to Look For

**Success Indicators:**
```
✅ Started native alarm sound for ID: [number]
🚨 Alarm sound URI from payload: sounds/[YourSound].mp3
🔄 Restarted looping alarm for ID: [number]
✅ Stopped native alarm sound for ID: [number]
🔇 Stopped looping handler for alarm ID: [number]
```

**Error Indicators:**
```
❌ Failed to play native alarm
Failed to parse URI
Falling back to system alarm
Error in looping handler
```

### How to Enable Detailed Logs

#### Android Studio Method
```
1. Open Android Profiler
2. Logcat tab
3. Filter for "NativeAlarm" or "Alarm"
4. Watch logs as alarm fires
```

#### Command Line Method
```bash
adb logcat | grep -i "NativeAlarm\|Alarm"
```

---

## Common Issues & Solutions

### Issue: Custom Sound Doesn't Play
**Solution:** 
- Verify sound file exists: `assets/sounds/YourSound.mp3`
- Check file is listed in `pubspec.yaml`
- Clear app cache: `adb shell pm clear com.habittracker.habitv8`
- Rebuild: `flutter clean && flutter build apk`

### Issue: Alarm Stops Immediately
**Solution:**
- Device may have blocked permissions
- Check: Settings → Apps → Notifications
- Rebuild with: `flutter build apk --release`

### Issue: Multiple Alarms Interfere
**Solution:**
- Different `alarmId` should be unique
- Check logs show different IDs
- Each should have own entry in `activeAlarmRingtones`

### Issue: Sound Doesn't Loop
**Solution:**
- Verify Handler is created and `postDelayed` is called
- Check `Looper.getMainLooper()` is available
- Ensure `alarmLoopingTimers` is being populated

---

## Performance Notes

- Handler uses main thread (safe for UI operations)
- 3-second interval is optimized for ~2-4 second sounds
- No CPU load when not playing alarms
- Timers are cleaned up immediately on stop (no memory leak)

---

## Next Steps After Testing

1. If all tests pass: Deploy to production ✅
2. If specific test fails: Check corresponding section in ALARM_SOUND_LOOPING_FIX.md
3. Report any issues with:
   - Device model & Android version
   - App logs (Logcat)
   - Steps to reproduce
   - Expected vs actual behavior

---

## Quick Verification Script

Run this to check Android implementation:
```bash
grep -n "alarmLoopingTimers\|postDelayed\|removeCallbacks" \
  android/app/src/main/kotlin/com/habittracker/habitv8/MainActivity.kt

# Should show multiple matches for looping implementation
```

Check Dart implementation:
```bash
grep -n "_normalizeAlarmSoundUri\|sounds/" \
  lib/services/notifications/notification_alarm_scheduler.dart

# Should show normalization being applied to all schedulers
```