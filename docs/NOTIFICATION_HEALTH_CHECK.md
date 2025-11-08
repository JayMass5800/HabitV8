# Quick Notification System Health Check

## ⚡ 30-Second Verification

After starting the app, check the debug console for these logs (in order):

### 1. Isar Database Initialization ✅
```
✅ Isar database initialized at: /data/user/0/.../app_flutter/
```

### 2. Notification Service Initialization ✅
```
✅ Notification permission granted
🔔 Notification channels created successfully
```

### 3. **NEW: Habit Notification Scheduling** ✅
```
🔔 Scheduling notifications for all existing habits (Isar)
📋 Found X active habits to schedule notifications for
✅ Notification scheduling complete: X scheduled, Y skipped, 0 errors
```

### 4. Midnight Reset Service ✅
```
✅ Midnight Habit Reset Service initialized successfully
⏰ Next midnight reset in: XXh XXm
```

## ❌ Common Error Patterns

### ERROR: No scheduling logs appear
**Problem:** `_scheduleAllHabitNotifications()` not being called
**Solution:** Verify the changes to `lib/main.dart` were saved correctly

### ERROR: "Undefined name 'IsarDatabaseService'"
**Problem:** Missing import in main.dart
**Solution:** Ensure this import is at the top of lib/main.dart:
```dart
import 'data/database_isar.dart';
```

### ERROR: Notifications scheduled but don't fire
**Problem:** Notification permissions not granted
**Solution:** 
1. Check Settings > Apps > HabitV8 > Notifications (should be ON)
2. Check for "Notification permission denied" in logs
3. Grant permission and restart app

### ERROR: "Habit not found in background"
**Problem:** Orphaned notifications from deleted habits
**Solution:** Normal and expected - the system will auto-cancel these

## 🧪 Quick Functional Test

### Test Scenario: 2-Minute Notification
```dart
1. Create a habit named "Test Notification"
2. Set frequency to "Daily"
3. Enable notifications
4. Set notification time to 2 minutes from now
5. Save habit
6. Close app (don't force-stop)
7. Wait 2 minutes
8. ✅ Notification should appear
9. Tap "COMPLETE" button
10. Open app
11. ✅ Habit should be marked as complete
```

Expected logs when notification fires:
```
🔔 BACKGROUND notification response received (Isar)
Background action ID: complete
⚙️ Completing habit in background (Isar): [habitId]
✅ Isar opened in background isolate
✅ Habit completed in background: Test Notification
🎉 Background completion successful with Isar!
```

## 📊 Health Check Command

Run this in PowerShell to check for critical logs:
```powershell
# Start app and capture logs
flutter run | Select-String -Pattern "Scheduling notifications|scheduled, |Notification scheduling complete"
```

Look for:
```
🔔 Scheduling notifications for all existing habits (Isar)
✅ Notification scheduling complete: X scheduled, Y skipped, 0 errors
```

## 🔍 Detailed Status Check

### Check 1: Verify Isar Database is Working
```dart
// Open app
// Go to "All Habits" screen
// Count number of habits displayed
// Check logs for: "🔔 Isar: Emitting X habits"
```

### Check 2: Verify Notifications are Scheduled
```dart
// After app starts
// Check logs for: "✅ Scheduled notifications for: [Habit Name]"
// Should appear for EACH habit with notifications enabled
```

### Check 3: Verify Pending Notifications
```dart
// From terminal while app is running:
adb shell dumpsys notification --noredact | findstr "habitv8"

// Should show pending notifications with package name
```

### Check 4: Verify Background Handler Registration
```dart
// Check logs for:
✅ Widget interaction callback registered in main()
✅ Notification action callback registered (Isar)
✅ Direct completion handler registered (Isar)
```

## 🚨 Emergency Fixes

### If notifications completely stop working:

**Option 1: Force Midnight Reset**
1. Open app
2. Go to Settings
3. Scroll to "Developer Options" (if available)
4. Tap "Force Midnight Reset"
5. This will reschedule all notifications

**Option 2: Manual Reschedule**
1. Edit each habit
2. Toggle notifications OFF
3. Save
4. Edit again
5. Toggle notifications ON
6. Save
7. Notifications will be rescheduled

**Option 3: Clear App Data** (Nuclear option)
1. Settings > Apps > HabitV8 > Storage
2. Clear Data (⚠️ THIS WILL DELETE ALL HABITS)
3. Restore from backup if you have one

## ✅ Success Indicators

Your notification system is healthy if:

1. ✅ Logs show "Notification scheduling complete" within 5 seconds of app start
2. ✅ Number of "scheduled" matches number of habits with notifications enabled
3. ✅ No "Error scheduling" messages in logs
4. ✅ Notifications appear at expected times
5. ✅ Action buttons work correctly
6. ✅ Background completion updates database

## 📞 Still Having Issues?

Check these files for potential problems:

1. **lib/main.dart** - Lines 1-50 (imports) and lines 880-930 (_scheduleAllHabitNotifications)
2. **lib/data/database_isar.dart** - Verify Isar is initializing correctly
3. **lib/services/notification_service.dart** - Check initialization
4. **lib/services/notifications/notification_scheduler.dart** - Core scheduling logic

Look for compile errors:
```powershell
flutter analyze
```

Check for runtime errors:
```powershell
flutter run --verbose
```

## 📝 Report Template

If you need to report an issue:

```
**Environment:**
- Device: [Android/iOS version]
- App Version: [from pubspec.yaml]
- Fresh Install or Update: [which?]

**Issue:**
- Notifications work: [YES/NO]
- Logs show scheduling: [YES/NO]
- Habits displayed: [number]
- Notifications scheduled: [number from logs]

**Logs:**
[Paste relevant logs here, especially startup logs]

**Steps to Reproduce:**
1. [Step 1]
2. [Step 2]
3. [Expected result]
4. [Actual result]
```

## 🎯 Bottom Line

**If you see this log message, notifications are working:**
```
✅ Notification scheduling complete: X scheduled, Y skipped, 0 errors
```

**If you DON'T see this message within 5 seconds of app start, notifications are broken.**

Time to fix: Check imports in lib/main.dart, verify database_isar.dart exists, run `flutter clean && flutter pub get`.
