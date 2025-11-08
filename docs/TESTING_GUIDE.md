# 🧪 Testing Guide: Notification Terminated State Fix

## 📋 Quick Start

All fixes have been applied. Now you need to test them on a physical Android device.

### Prerequisites
- ✅ Physical Android device (Android 8.0+)
- ✅ USB debugging enabled
- ✅ Device connected via USB or WiFi ADB

---

## 🚀 Testing Steps

### Step 1: Run Full Diagnostic
```powershell
.\full_diagnostic.ps1
```

This will check:
- Device connection
- App installation status
- Build type (must be RELEASE)
- Service declarations
- Permissions
- Battery optimization
- Current app state

**Fix any CRITICAL issues before proceeding!**

---

### Step 2: Build and Install Release APK

If diagnostic shows issues or app not installed:

```powershell
# Clean build
flutter clean

# Build release APK (this is where tree-shaking happens!)
flutter build apk --release

# Install on device
adb install build\app\outputs\flutter-apk\app-release.apk
```

**⚠️ IMPORTANT:** You MUST test with a RELEASE build, not debug!
- Debug builds don't use tree-shaking
- The pragma annotations only matter in release builds
- Testing in debug mode will give false positives

---

### Step 3: Run Simple Test

```powershell
.\test_notification_simple.ps1
```

This automated script will:
1. ✅ Check device connection
2. ✅ Verify app is installed
3. ✅ Launch the app
4. ⏸️ Wait for you to create a test habit
5. ⏸️ Wait for notification to appear
6. ✅ Force-stop the app (simulates terminated state)
7. ✅ Monitor logs for background handler execution
8. ✅ Show verification checklist

---

### Step 4: Manual Testing Steps

When the script pauses:

1. **Create a test habit:**
   - Open the app
   - Create a new habit (e.g., "Test Habit")
   - Enable notifications
   - Set notification time to **1-2 minutes from now**
   - Save the habit

2. **Wait for notification:**
   - Keep the app open or in background
   - Wait for the notification to appear
   - **DON'T tap it yet!**

3. **Return to PowerShell:**
   - Press Enter when notification is visible
   - Script will force-stop the app
   - Notification should remain visible

4. **Tap the Complete button:**
   - On your device, tap "COMPLETE" on the notification
   - Watch the PowerShell window for logs

---

## ✅ Success Indicators

If the fix is working, you should see these logs:

```
✅ BACKGROUND notification action received (Isar)
✅ Flutter binding initialized in background isolate
✅ Isar opened in background isolate
✅ Found habit in background: Test Habit
✅ Habit completed in background: Test Habit (Streak: 1)
✅ Widget update completed from background
```

**Visual confirmation:**
- ✅ Notification dismisses after tapping Complete
- ✅ Widget updates (if you have widget on home screen)
- ✅ When you open the app, habit shows as completed
- ✅ Streak increases by 1

---

## ❌ Troubleshooting

### Issue: No logs appear after tapping Complete

**Possible causes:**

#### 1. Battery Optimization Enabled
```powershell
# Check status
adb shell dumpsys deviceidle whitelist | Select-String "habitv8"
```

**Fix:**
- Settings → Apps → HabitV8 → Battery → **Unrestricted**

#### 2. Testing Debug Build
```powershell
# Check if debug build is installed
adb shell pm list packages | Select-String "debug"
```

**Fix:**
- Uninstall debug build
- Build and install release: `flutter build apk --release`

#### 3. Service Declarations Missing
```powershell
# Check services
adb shell dumpsys package com.habittracker.habitv8 | Select-String "ForegroundService"
```

**Fix:**
- Verify AndroidManifest.xml has the service declarations
- Rebuild and reinstall

#### 4. Manufacturer-Specific Battery Restrictions

**Xiaomi (MIUI):**
- Settings → Battery & Performance → Manage apps battery usage → HabitV8 → No restrictions
- Settings → Permissions → Autostart → Enable for HabitV8

**Huawei (EMUI):**
- Settings → Battery → App launch → HabitV8 → Manage manually → Enable all

**OnePlus (OxygenOS):**
- Settings → Battery → Battery optimization → HabitV8 → Don't optimize

**Samsung (One UI):**
- Settings → Apps → HabitV8 → Battery → Unrestricted
- Settings → Device care → Battery → Background usage limits → Remove HabitV8

---

### Issue: Notification disappears when app is force-stopped

This is **EXPECTED** on some Android versions/manufacturers. The notification system may dismiss notifications when the app is force-stopped. This is different from the app being naturally terminated.

**Alternative test:**
1. Create habit with notification
2. Wait for notification to appear
3. **Swipe away the app** from recent apps (don't force-stop)
4. Wait 5-10 minutes for Android to naturally terminate the app
5. Tap Complete button

---

### Issue: Logs show errors about Isar or schema

**Possible causes:**
- Isar configuration mismatch
- Schema not found (tree-shaking issue)

**Check:**
```powershell
# Look for specific errors
adb logcat | Select-String "Isar|Schema|HabitSchema"
```

**Fix:**
- Verify `domain/model/habit.dart` is imported in `main.dart`
- Verify `inspector: true` in both main app and background handler
- Rebuild release APK

---

## 📊 Diagnostic Commands

### Check if app is running
```powershell
adb shell ps | Select-String "habitv8"
```

### Check active notifications
```powershell
adb shell dumpsys notification | Select-String "habitv8"
```

### Check battery optimization
```powershell
adb shell dumpsys deviceidle whitelist | Select-String "habitv8"
```

### Monitor logs in real-time
```powershell
adb logcat | Select-String "HabitV8|BACKGROUND|NotificationAction"
```

### Clear logs
```powershell
adb logcat -c
```

### Force stop app
```powershell
adb shell am force-stop com.habittracker.habitv8
```

### Launch app
```powershell
adb shell am start -n com.habittracker.habitv8/.MainActivity
```

---

## 🔍 What Each Fix Does

### Fix #1: Android Service Declarations
**File:** `android/app/src/main/AndroidManifest.xml`

Added:
- `ForegroundService` - Allows background execution
- `NotificationActionReceiver` - Handles button clicks

**Why needed:** Awesome Notifications requires these but doesn't add them automatically.

### Fix #2: Tree-Shaking Protection (extractHabitIdFromPayload)
**File:** `lib/services/notifications/notification_helpers.dart`

Added: `@pragma('vm:entry-point')`

**Why needed:** This method is called from background isolate. Without pragma, Flutter's tree-shaker removes it in release builds, causing crashes.

### Fix #3: Tree-Shaking Protection (_calculateStreak)
**File:** `lib/services/notifications/notification_action_handler.dart`

Added: `@pragma('vm:entry-point')`

**Why needed:** Private helper method called from background isolate. Tree-shaker can't detect cross-isolate usage.

### Fix #4: Isar Configuration Consistency
**File:** `lib/services/notifications/notification_action_handler.dart`

Changed: `inspector: false` → `inspector: true`

**Why needed:** Isar requires identical configuration across all isolates. Mismatch causes access errors.

### Fix #5: iOS Background Modes
**File:** `ios/Runner/Info.plist`

Added: `UIBackgroundModes` array

**Why needed:** Improves background state handling on iOS (though iOS still can't execute local notification actions in terminated state).

### Fix #6: Explicit Schema Import
**File:** `lib/main.dart`

Added: `import 'domain/model/habit.dart';`

**Why needed:** Prevents tree-shaking of `HabitSchema` class, which is needed by background isolate to open Isar database.

---

## 📱 Platform Differences

### Android ✅
- **Foreground:** ✅ Works
- **Background:** ✅ Works  
- **Terminated:** ✅ Should work now (after fixes)

**Limitations:**
- Aggressive battery optimization can still prevent execution
- Manufacturer-specific restrictions may apply
- Force-stop may dismiss notifications on some devices

### iOS ⚠️
- **Foreground:** ✅ Works
- **Background:** ✅ Works
- **Terminated:** ❌ iOS platform limitation

**Why iOS doesn't work:**
- iOS does not allow local notifications to execute code when app is terminated
- This is an operating system restriction, not a bug
- Only remote notifications (APNs) can wake a terminated app
- To support iOS terminated state, you would need to implement Firebase Cloud Messaging

---

## 🎯 Expected Test Results

### Scenario 1: App in Foreground
- ✅ Notification appears
- ✅ Tap Complete → Habit marked complete immediately
- ✅ UI updates instantly
- ✅ Notification dismisses

### Scenario 2: App in Background
- ✅ Notification appears
- ✅ Tap Complete → Background handler executes
- ✅ Habit marked complete in database
- ✅ Widget updates
- ✅ Notification dismisses
- ✅ When you open app, completion is visible

### Scenario 3: App Terminated (THE TEST)
- ✅ Notification appears
- ✅ Force-stop app
- ✅ Notification remains visible
- ✅ Tap Complete → Background handler executes
- ✅ Logs show "BACKGROUND notification action received"
- ✅ Habit marked complete in database
- ✅ Widget updates
- ✅ Notification dismisses
- ✅ When you open app, completion is visible

---

## 📝 Testing Checklist

Before reporting results, verify:

- [ ] Tested on **release build** (not debug)
- [ ] Battery optimization is **disabled** for the app
- [ ] Notification permission is **granted**
- [ ] Exact alarm permission is **granted** (Android 12+)
- [ ] App was **force-stopped** before tapping button
- [ ] Logs were **cleared** before the test
- [ ] Logs were **monitored** during button tap
- [ ] Checked for **manufacturer-specific restrictions**

---

## 🆘 Still Not Working?

If you've tried everything and it still doesn't work:

1. **Run full diagnostic:**
   ```powershell
   .\full_diagnostic.ps1
   ```

2. **Capture full logs:**
   ```powershell
   adb logcat -c
   # Tap Complete button
   adb logcat -d > notification_logs.txt
   ```

3. **Check for errors:**
   ```powershell
   Get-Content notification_logs.txt | Select-String "error|exception|failed" -Context 2
   ```

4. **Verify service declarations:**
   ```powershell
   adb shell dumpsys package com.habittracker.habitv8 | Select-String "Service|Receiver"
   ```

5. **Test on different device:**
   - Some manufacturers have very aggressive battery optimization
   - Try on a Pixel, Samsung, or other device if available

---

## 📚 Additional Resources

- **FIXES_APPLIED.md** - Detailed explanation of all fixes
- **NOTIFICATION_TERMINATED_STATE_ANALYSIS.md** - Technical analysis
- **IMPLEMENTATION_COMPLETE.md** - Implementation summary
- **full_diagnostic.ps1** - Comprehensive diagnostic tool
- **test_notification_simple.ps1** - Automated testing script

---

## 🎉 Success Criteria

The fix is working if:

1. ✅ You see "BACKGROUND notification action received" in logs
2. ✅ You see "Habit completed in background" in logs
3. ✅ Notification dismisses after tapping Complete
4. ✅ Habit shows as completed when you open the app
5. ✅ Streak increases correctly
6. ✅ Widget updates (if applicable)

If all 6 criteria are met, **the fix is successful!** 🎉

---

**Good luck with testing!** 🚀