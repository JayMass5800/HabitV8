# Full Screen Intent Permission - Quick Reference

## What Changed?
The app now asks users to manually grant the "Display over other apps" permission when they try to enable alarms, instead of requesting it automatically. This is required for Google Play Store compliance on Android 14+.

## Why?
Google Play Store requires that apps using `USE_FULL_SCREEN_INTENT` permission on Android 14+ must:
1. Only request the permission when the user needs it (contextually)
2. Allow the user to manually grant it through system settings
3. Not request it automatically during app installation

## Quick Implementation Summary

### Native Side (Kotlin)
```kotlin
// Check permission
if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
    val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    notificationManager.canUseFullScreenIntent()
} else {
    true // Auto-granted on Android 13-
}

// Open settings
val intent = Intent(Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT).apply {
    data = Uri.parse("package:$packageName")
}
startActivity(intent)
```

### Dart Side
```dart
// Check if permission is granted
final hasPermission = await PermissionService.canUseFullScreenIntent();

// Open settings for user to grant permission
await PermissionService.openFullScreenIntentSettings();
```

### UI Flow
```dart
// When user toggles alarm ON
if (value) {
  final hasPermission = await PermissionService.canUseFullScreenIntent();
  
  if (!hasPermission) {
    // Show dialog explaining permission
    // User clicks "Open Settings"
    // System settings page opens
    // User manually grants permission
    // User returns to app
  }
  
  // Enable alarm
}
```

## Files Modified
1. **AndroidManifest.xml** - Added comment about manual permission
2. **MainActivity.kt** - Added method channel for permission check/settings
3. **permission_service.dart** - Added permission check/request methods
4. **create_habit_screen_v2.dart** - Added permission check before enabling alarms
5. **edit_habit_screen.dart** - Added permission check before enabling alarms

## User Experience
- **Android 13 and below**: No changes, alarms work immediately
- **Android 14+**: User sees a dialog when enabling alarms, can open settings to grant permission

## Testing Command
```bash
# Build and test
flutter build apk --release
# or
flutter build appbundle --release

# Install on Android 14+ device
adb install build/app/outputs/flutter-apk/app-release.apk

# Test flow:
# 1. Create habit
# 2. Enable alarms
# 3. Verify dialog appears
# 4. Click "Open Settings"
# 5. Grant permission
# 6. Return to app
# 7. Enable alarms again
# 8. Verify alarms work
```

## Key Methods

### PermissionService
- `canUseFullScreenIntent()` - Check if permission is granted
- `openFullScreenIntentSettings()` - Open system settings
- `requestFullScreenIntentPermission()` - High-level request method

### MainActivity
- `canUseFullScreenIntent` - Native check via NotificationManager
- `openFullScreenIntentSettings` - Native settings intent

## Android Version Handling
| Version | API Level | Behavior |
|---------|-----------|----------|
| Android 13 and below | ≤ 33 | Auto-granted, no dialog |
| Android 14+ | ≥ 34 | Manual permission, shows dialog |

## Compliance Checklist
- ✅ Permission requested only when needed (contextually)
- ✅ User must manually grant via system settings
- ✅ Clear explanation provided to user
- ✅ No automatic permission requests
- ✅ Backward compatible with Android 13 and below

## Troubleshooting

### Dialog doesn't appear
- Check method channel setup in MainActivity.kt
- Verify `setupFullScreenIntentChannel()` is called in `configureFlutterEngine()`

### Settings page doesn't open
- Verify intent action: `Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT`
- Check package name is correct

### Permission still auto-granted on Android 14+
- Ensure target SDK is 34+
- Check manifest configuration

## Related Documentation
- [FULL_SCREEN_INTENT_PERMISSION_FIX.md](./FULL_SCREEN_INTENT_PERMISSION_FIX.md) - Detailed explanation
- [FULL_SCREEN_INTENT_TESTING_GUIDE.md](./FULL_SCREEN_INTENT_TESTING_GUIDE.md) - Testing procedures

## Build Version
This fix will be included in version **9.0.2+38** or later.