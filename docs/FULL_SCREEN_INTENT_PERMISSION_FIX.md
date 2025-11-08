# Full Screen Intent Permission Fix - Google Play Store Compliance

## Problem
Google Play Store was flagging the app as non-compliant for automatically requesting the `USE_FULL_SCREEN_INTENT` permission. Starting with Android 14 (API 34+), this permission must be manually granted by the user through system settings rather than being automatically granted when the app is installed.

## Solution Overview
Changed the permission request flow from **automatic** to **manual user-initiated** permission request when the user tries to enable alarms.

## Changes Made

### 1. Android Native Code (`MainActivity.kt`)

#### Added Import
```kotlin
import android.provider.Settings
```

#### Added Method Channel
```kotlin
private val FULL_SCREEN_INTENT_CHANNEL = "com.habittracker.habitv8/full_screen_intent"
```

#### Added Permission Check and Settings Methods
```kotlin
private fun setupFullScreenIntentChannel(flutterEngine: FlutterEngine) {
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, FULL_SCREEN_INTENT_CHANNEL)
        .setMethodCallHandler { call, result ->
            when (call.method) {
                "canUseFullScreenIntent" -> {
                    // Check if permission is granted
                    // Android 14+: Use NotificationManager.canUseFullScreenIntent()
                    // Android 13-: Auto-granted
                }
                "openFullScreenIntentSettings" -> {
                    // Open system settings page for full screen intent
                    // Android 14+: Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT
                    // Android 13-: Not needed
                }
            }
        }
}
```

**Key Features:**
- Uses `NotificationManager.canUseFullScreenIntent()` on Android 14+ to check permission status
- Opens `Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT` for Android 14+ users
- Returns `true` automatically for Android 13 and below (permission is auto-granted)

### 2. Dart Permission Service (`permission_service.dart`)

#### Added Methods
1. **`canUseFullScreenIntent()`**
   - Checks if the app has full screen intent permission
   - Returns `true` on iOS and Android 13-
   - Calls native method on Android 14+

2. **`openFullScreenIntentSettings()`**
   - Opens system settings for the permission
   - Returns `true` if settings opened, `false` if not needed

3. **`requestFullScreenIntentPermission()`**
   - High-level method that checks permission first
   - If not granted, opens settings for user to enable
   - Returns `true` if permission granted or not needed

### 3. UI Changes

#### Create Habit Screen V2 (`create_habit_screen_v2.dart`)
- **Modified**: Alarm toggle now checks permission before enabling
- **Added**: Dialog explaining the permission requirement
- **Behavior**: When user toggles alarm on:
  1. Check if permission is granted
  2. If not granted, show dialog explaining why permission is needed
  3. User can choose to open settings or cancel
  4. If user opens settings, they can manually grant the permission
  5. Alarm only enables if permission is granted or user dismisses dialog

#### Edit Habit Screen (`edit_habit_screen.dart`)
- Same changes as Create Habit Screen V2

#### Updated Info Messages
Changed alarm permission warning from orange (warning) to blue (info) with updated text:
```
"Alarms require special permissions on Android 14+ to show on the lock screen. 
You can grant this in system settings if prompted."
```

### 4. AndroidManifest.xml
Added comment clarifying the permission requirement:
```xml
<!-- USE_FULL_SCREEN_INTENT now requires user to manually enable via settings (Android 14+) -->
<uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT" />
```

## User Experience Flow

### Old Behavior (Non-Compliant)
1. App requests permission automatically on install
2. Permission auto-granted
3. User can create alarms immediately

### New Behavior (Compliant)
1. User tries to enable alarms in habit creation/editing
2. App checks if permission is granted
3. **If Android 14+ and not granted:**
   - Show dialog explaining permission requirement
   - User clicks "Open Settings"
   - System settings page opens
   - User manually grants permission
   - User returns to app and enables alarms
4. **If Android 13- or already granted:**
   - Alarms enable immediately

## Benefits

### Google Play Store Compliance
✅ Permission is only requested when user actually needs it  
✅ User must manually grant permission (Android 14+ requirement)  
✅ Clear explanation provided to user before opening settings  

### User Experience
✅ Permission request is contextual (when enabling alarms)  
✅ Clear explanation of why permission is needed  
✅ Direct link to system settings  
✅ No disruption for Android 13 and below users  

### Backward Compatibility
✅ Android 13 and below: Permission auto-granted (existing behavior)  
✅ Android 14+: Manual permission grant (new requirement)  
✅ iOS: Not affected  

## Technical Details

### Android API Levels
- **Android 13 and below (API ≤ 33)**: `USE_FULL_SCREEN_INTENT` is automatically granted
- **Android 14+ (API 34+)**: `USE_FULL_SCREEN_INTENT` requires manual user approval via system settings

### Permission Check Method
```kotlin
if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
    // Android 14+ (API 34+)
    val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    notificationManager.canUseFullScreenIntent()
} else {
    // Android 13 and below - auto-granted
    true
}
```

### Settings Intent
```kotlin
val intent = Intent(Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT).apply {
    data = Uri.parse("package:$packageName")
    flags = Intent.FLAG_ACTIVITY_NEW_TASK
}
startActivity(intent)
```

## Testing

### Test Cases
1. **Android 14+ without permission**:
   - Enable alarm toggle → Dialog shows → Open Settings → Grant permission → Enable alarm
   
2. **Android 14+ with permission**:
   - Enable alarm toggle → Enables immediately
   
3. **Android 13 and below**:
   - Enable alarm toggle → Enables immediately (auto-granted)
   
4. **User cancels permission**:
   - Enable alarm toggle → Dialog shows → Cancel → Alarm stays disabled

### Verification
- Build and upload to Google Play Console
- Check for policy compliance warnings
- Test on Android 14+ device
- Test on Android 13 device

## Files Modified

### Android Native
- `android/app/src/main/AndroidManifest.xml`
- `android/app/src/main/kotlin/com/habittracker/habitv8/MainActivity.kt`

### Dart Services
- `lib/services/permission_service.dart`

### UI Screens
- `lib/ui/screens/create_habit_screen_v2.dart`
- `lib/ui/screens/edit_habit_screen.dart`

## Related Documentation
- [Android Developer Docs - Full Screen Intent](https://developer.android.com/about/versions/14/changes/fgs-types-required#full-screen-intent)
- [Google Play Policy - Permissions](https://support.google.com/googleplay/android-developer/answer/9888170)

## Version
- **Fix Version**: 9.0.2 (to be released)
- **Android Target SDK**: 34 (Android 14)
- **Minimum SDK**: 26 (Android 8.0)

## Notes
- This fix ensures compliance with Google Play Store policies for Android 14+
- The permission is still declared in the manifest (required for functionality)
- The change only affects **when** and **how** the permission is requested, not **what** the permission does
- Existing users on Android 13 and below will not see any changes
- New Android 14+ users will see a permission request dialog when enabling alarms