# Fix: Alarms Not Firing Issue

## Problem
Alarms were not firing at all on Android 13+ devices. The app was silently failing to schedule alarms.

## Root Cause
The `AndroidManifest.xml` had a critical misconfiguration:

```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" android:maxSdkVersion="32" />
```

This permission was **limited to Android 12 (API 32) and below**. Since the app targets Android 16 (API 36), devices running Android 13+ (API 33+) were **not getting the permission**, causing all alarm scheduling to fail silently.

Additionally, the Dart code had a **hardcoded permission check** that always returned `true` without actually checking if the system granted the permission.

## Solution

### 1. Fixed AndroidManifest.xml Permission Declaration

**File:** `android/app/src/main/AndroidManifest.xml`

**Changed:**
```xml
<!-- OLD - BROKEN -->
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" android:maxSdkVersion="32" />

<!-- NEW - FIXED -->
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
```

**Why this fixes it:**
- Removed the `maxSdkVersion="32"` restriction
- Now the permission is requested on **all Android versions** that need it
- Android 14+ (API 34+) with `USE_EXACT_ALARM` gets automatic approval
- Android 12-13 (API 31-33) with `SCHEDULE_EXACT_ALARM` requires user approval

### 2. Added Native Permission Check

**File:** `android/app/src/main/kotlin/com/habittracker/habitv8/MainActivity.kt`

**Added:**
- New method channel: `PERMISSION_CHANNEL = "com.habittracker.habitv8/permissions"`
- Method: `canScheduleExactAlarms()` - Uses Android's `AlarmManager.canScheduleExactAlarms()` API
- Method: `openExactAlarmSettings()` - Opens system settings for user to grant permission

**Implementation:**
```kotlin
"canScheduleExactAlarms" -> {
    val canSchedule = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.canScheduleExactAlarms()
    } else {
        true // Android 11 and below don't need special permission
    }
    result.success(canSchedule)
}
```

### 3. Updated Dart Permission Service

**File:** `lib/services/permission_service.dart`

**Changed:**
- `hasExactAlarmPermission()` - Now calls native method instead of returning hardcoded `true`
- `requestExactAlarmPermission()` - Opens system settings to allow user to grant permission
- Added `MethodChannel` import for native communication

**Before (BROKEN):**
```dart
static Future<bool> hasExactAlarmPermission() async {
  // Hardcoded to always return true!
  return true;
}
```

**After (FIXED):**
```dart
static Future<bool> hasExactAlarmPermission() async {
  const platform = MethodChannel('com.habittracker.habitv8/permissions');
  final bool canSchedule = await platform.invokeMethod('canScheduleExactAlarms');
  return canSchedule;
}
```

## How It Works Now

### Permission Flow:
1. **App checks permission** via `hasExactAlarmPermission()`
2. **Native Android API** returns actual permission status
3. **If denied**, app can call `requestExactAlarmPermission()`
4. **System settings open** for user to grant permission
5. **Alarms can be scheduled** once permission is granted

### Android Version Behavior:
- **Android 11 and below**: No special permission needed ✅
- **Android 12-13 (API 31-33)**: Requires `SCHEDULE_EXACT_ALARM` - user must grant in settings
- **Android 14+ (API 34+)**: Uses `USE_EXACT_ALARM` - automatically granted ✅

## Testing Steps

1. **Rebuild the app** to apply manifest changes:
   ```powershell
   flutter clean
   flutter build apk
   ```

2. **Install on Android 13+ device**

3. **Check permission status**:
   - Go to Settings → Apps → HabitV8 → Permissions
   - Look for "Alarms & reminders" permission
   - Should be listed and can be toggled

4. **Test alarm scheduling**:
   - Create a habit with an alarm
   - Set alarm time
   - Verify alarm fires at scheduled time

5. **Check logs**:
   ```
   adb logcat | grep "Exact alarm permission"
   ```
   Should show: `Exact alarm permission check: true`

## Files Modified

1. ✅ `android/app/src/main/AndroidManifest.xml` - Fixed permission declaration
2. ✅ `android/app/src/main/kotlin/com/habittracker/habitv8/MainActivity.kt` - Added native permission check
3. ✅ `lib/services/permission_service.dart` - Fixed Dart permission logic

## Expected Outcome

- ✅ Alarms will fire on time on all Android versions
- ✅ Permission status is accurately checked
- ✅ User can grant/revoke permission in system settings
- ✅ App handles permission denial gracefully
- ✅ No more silent alarm scheduling failures

## Related Issues

This fix also addresses:
- Silent notification failures
- Alarms not appearing in system alarm list
- "Alarms & reminders" permission not showing in settings
- Awesome Notifications scheduling failures

## Important Notes

⚠️ **Users must reinstall the app** for manifest changes to take effect. Simply updating won't work - the permission declaration is read during installation.

⚠️ **On Android 12-13**, users may need to manually grant the permission in Settings → Apps → HabitV8 → Alarms & reminders.

⚠️ **On Android 14+**, the permission should be automatically granted due to `USE_EXACT_ALARM`.

## Verification

After applying this fix:
1. Check `adb logcat` for "Exact alarm permission check: true"
2. Verify alarms appear in system alarm list
3. Confirm alarms fire at scheduled time
4. Test on multiple Android versions (12, 13, 14+)