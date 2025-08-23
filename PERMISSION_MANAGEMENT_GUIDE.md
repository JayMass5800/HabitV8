# Permission Management Guide for HabitV8

This guide provides comprehensive instructions for adding, modifying, or troubleshooting permissions in the HabitV8 Flutter app. Following this guide will help avoid permission-related issues and ensure all permissions work correctly across different build configurations.

## 🎯 Overview

HabitV8 uses a custom permission management system with multiple layers:
- **Android Manifest declarations** (multiple files)
- **Kotlin native plugin** (MinimalHealthPlugin)
- **Dart service layer** (HealthService + MinimalHealthChannel)
- **Build scripts** for permission filtering

## 📋 Complete Checklist for Adding New Permissions

### ✅ Step 1: Android Manifest Files

**You MUST update ALL of these manifest files:**

#### 1.1 Main AndroidManifest.xml
**File:** `android/app/src/main/AndroidManifest.xml`
```xml
<!-- Add your permission here -->
<uses-permission android:name="android.permission.YOUR_PERMISSION" />
```

#### 1.2 Debug AndroidManifest.xml
**File:** `android/app/src/debug/AndroidManifest.xml`
```xml
<!-- Add your permission here -->
<uses-permission android:name="android.permission.YOUR_PERMISSION" />
```

#### 1.3 Release AndroidManifest.xml ⚠️ **CRITICAL**
**File:** `android/app/src/release/AndroidManifest.xml`

**DO NOT let this file remove your permission!**
```xml
<!-- Comment out any removal directives for your permission -->
<!-- <uses-permission android:name="android.permission.YOUR_PERMISSION" tools:node="remove" /> -->

<!-- Add your permission to the positive declarations section -->
<uses-permission android:name="android.permission.YOUR_PERMISSION" />
```

### ✅ Step 2: Kotlin Native Plugin

**File:** `android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin.kt`

#### 2.1 Add Method Call Handler
```kotlin
override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
        // ... existing methods ...
        "yourNewPermissionMethod" -> {
            yourNewPermissionMethod(result)
        }
        // ... rest of methods ...
    }
}
```

#### 2.2 Implement Permission Method
```kotlin
private fun yourNewPermissionMethod(result: Result) {
    try {
        // Your permission logic here
        // For system permissions:
        val hasPermission = ContextCompat.checkSelfPermission(
            context, 
            "android.permission.YOUR_PERMISSION"
        ) == PackageManager.PERMISSION_GRANTED
        
        result.success(hasPermission)
    } catch (e: Exception) {
        Log.e("MinimalHealthPlugin", "Error with permission", e)
        result.error("PERMISSION_ERROR", "Failed: ${e.message}", null)
    }
}
```

#### 2.3 Add Required Imports
```kotlin
// Add any needed imports at the top
import android.your.needed.Import
```

### ✅ Step 3: Dart Service Layer

#### 3.1 MinimalHealthChannel
**File:** `lib/services/minimal_health_channel.dart`

```dart
/// Your new permission method
static Future<bool> yourNewPermissionMethod() async {
  if (!_isInitialized) {
    await initialize();
  }

  try {
    AppLogger.info('Requesting your permission...');
    final bool granted = await _channel.invokeMethod('yourNewPermissionMethod');
    AppLogger.info('Your permission request result: $granted');
    return granted;
  } catch (e) {
    AppLogger.error('Error requesting your permission', e);
    return false;
  }
}
```

#### 3.2 HealthService
**File:** `lib/services/health_service.dart`

```dart
/// Request your new permission
static Future<bool> requestYourPermission() async {
  if (!_isInitialized) {
    await initialize();
  }

  try {
    AppLogger.info('Requesting your permission...');
    final bool result = await MinimalHealthChannel.yourNewPermissionMethod();
    AppLogger.info('Your permission request result: $result');
    return result;
  } catch (e) {
    AppLogger.error('Failed to request your permission', e);
    return false;
  }
}
```

### ✅ Step 4: Build Configuration

#### 4.1 Check Build Scripts
**Files:** 
- `android/app/remove_health_permissions.gradle`
- `android/app/add_health_permissions.gradle`

Make sure your permission is not being removed by these scripts.

#### 4.2 Gradle Dependencies
**File:** `android/app/build.gradle.kts`

Add any required dependencies:
```kotlin
dependencies {
    // Add required dependencies for your permission
    implementation("your.required:dependency:version")
}
```

## 🔍 Troubleshooting Common Issues

### Issue 1: Permission Missing in Release Build

**Symptoms:** Permission works in debug but not in release
**Cause:** Release AndroidManifest.xml is removing the permission
**Solution:** Check `android/app/src/release/AndroidManifest.xml` for removal directives

### Issue 2: Health Permissions Not Working

**Symptoms:** Health permissions are denied even after granting
**Cause:** Multiple possible causes
**Solutions:**
1. Check all 3 AndroidManifest.xml files
2. Verify Health Connect version compatibility
3. Check if permission is in the allowed list in MinimalHealthPlugin

### Issue 3: Build Failures After Adding Permissions

**Symptoms:** Kotlin compilation errors
**Cause:** Missing imports or type mismatches
**Solutions:**
1. Add required imports to MinimalHealthPlugin.kt
2. Check method signatures match between Kotlin and Dart
3. Verify dependency versions in build.gradle.kts

### Issue 4: Permission Granted But Not Working

**Symptoms:** Permission check returns true but functionality doesn't work
**Cause:** Missing manifest declaration or incorrect permission string
**Solutions:**
1. Verify exact permission string matches in all files
2. Check if additional permissions are required
3. Test on different Android versions

## 📱 Testing Your Permissions

### Test Checklist:
- [ ] Debug build works
- [ ] Release build works  
- [ ] Permission request dialog appears
- [ ] Permission can be granted
- [ ] Permission can be denied gracefully
- [ ] App works after permission changes
- [ ] Test on Android 12+ for exact alarms
- [ ] Test on different devices/Android versions

### Debug Tools:
1. Use the debug health permissions screen: `DebugHealthPermissionsScreen`
2. Check Android logs: `adb logcat | grep MinimalHealthPlugin`
3. Check merged manifest: `android/app/build/intermediates/merged_manifests/release/processReleaseManifest/AndroidManifest.xml`

## 🏗️ Build Process Understanding

### Manifest Merging Process:
1. **Main manifest** provides base permissions
2. **Debug/Release manifests** modify permissions for specific builds
3. **Build scripts** may add/remove permissions
4. **Final merged manifest** is what actually gets used

### Key Files to Check After Build:
- `build/intermediates/merged_manifests/debug/processDebugManifest/AndroidManifest.xml`
- `build/intermediates/merged_manifests/release/processReleaseManifest/AndroidManifest.xml`

## 🚨 Critical Rules

### DO NOT:
- ❌ Add permissions only to main AndroidManifest.xml
- ❌ Forget to check release AndroidManifest.xml
- ❌ Add health permissions without updating MinimalHealthPlugin
- ❌ Use different permission strings in different files
- ❌ Skip testing release builds
- ❌ Wait to request critical permissions (notifications, exact alarms) - request at startup

### ALWAYS:
- ✅ Update all 3 AndroidManifest.xml files
- ✅ Add both Kotlin and Dart implementations
- ✅ Test both debug and release builds
- ✅ Check merged manifest after build
- ✅ Add proper error handling
- ✅ Include logging for debugging
- ✅ Request critical permissions during app initialization

## 📚 Examples

### Example 1: Adding Camera Permission

**AndroidManifest.xml files:**
```xml
<uses-permission android:name="android.permission.CAMERA" />
```

**MinimalHealthPlugin.kt:**
```kotlin
"requestCameraPermission" -> {
    requestCameraPermission(result)
}

private fun requestCameraPermission(result: Result) {
    // Implementation here
}
```

**MinimalHealthChannel.dart:**
```dart
static Future<bool> requestCameraPermission() async {
    // Implementation here
}
```

### Example 2: Adding Health Permission

Follow the same pattern but also ensure:
1. Permission is in Health Connect's allowed list
2. Proper Health Connect API usage
3. Background permission handling if needed

## 🚀 Critical Permissions That Must Be Requested at App Startup

### System Permissions (Request During Initialization):
1. **POST_NOTIFICATIONS** - Required for all notifications
2. **SCHEDULE_EXACT_ALARM** - Required for precise notification timing (Android 12+)
3. **ACTIVITY_RECOGNITION** - Required for health data integration

### Where to Add Startup Permission Requests:
**File:** `lib/services/permission_service.dart` - `requestEssentialPermissions()` method
```dart
static Future<bool> requestEssentialPermissions() async {
  try {
    // Request notification permission during startup
    final notificationStatus = await Permission.notification.request();

    // Request exact alarm permission for Android 12+ devices
    bool exactAlarmGranted = true;
    try {
      AppLogger.info('Requesting exact alarm permission during startup...');
      exactAlarmGranted = await HealthService.requestExactAlarmPermission();
      AppLogger.info('Exact alarm permission status: $exactAlarmGranted');
    } catch (e) {
      AppLogger.error('Error requesting exact alarm permission during startup', e);
      exactAlarmGranted = false;
    }

    final notificationGranted = notificationStatus == PermissionStatus.granted ||
        notificationStatus == PermissionStatus.limited;

    return notificationGranted;
  } catch (e) {
    AppLogger.error('Error requesting essential permissions', e);
    return false;
  }
}
```

**This method is automatically called during app startup in `lib/main.dart`:**
```dart
void main() async {
  // ... other initialization ...
  
  // Request only essential permissions during startup (non-blocking)
  _requestEssentialPermissions();
  
  // ... rest of app initialization ...
}

void _requestEssentialPermissions() async {
  try {
    await PermissionService.requestEssentialPermissions();
  } catch (e) {
    AppLogger.error('Error requesting essential permissions', e);
  }
}
```

### Why These Must Be Requested Early:
- **Notifications:** Users expect immediate notification setup
- **Exact Alarms:** Android 12+ requires explicit user consent via system settings
- **Activity Recognition:** Needed for health data background processing

### Common Issue: Exact Alarms Not Appearing in Settings
**Problem:** Permission declared in manifest but not showing in device settings
**Cause:** Permission not requested during app lifecycle
**Solution:** Request permission during app initialization, not on-demand

### Complete Implementation Example: Exact Alarm Permission

**1. AndroidManifest.xml files (all 3):**
```xml
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
```

**2. Kotlin Plugin Method (`MinimalHealthPlugin.kt`):**
```kotlin
"requestExactAlarmPermission" -> {
    requestExactAlarmPermission(result)
}
"hasExactAlarmPermission" -> {
    hasExactAlarmPermission(result)
}

private fun requestExactAlarmPermission(result: Result) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        if (alarmManager.canScheduleExactAlarms()) {
            result.success(true)
            return
        }
        val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
            data = Uri.parse("package:${context.packageName}")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        context.startActivity(intent)
        result.success(true)
    } else {
        result.success(true)
    }
}

private fun hasExactAlarmPermission(result: Result) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        result.success(alarmManager.canScheduleExactAlarms())
    } else {
        result.success(true)
    }
}
```

**3. Dart Channel Methods (`MinimalHealthChannel.dart`):**
```dart
static Future<bool> requestExactAlarmPermission() async {
    final bool granted = await _channel.invokeMethod('requestExactAlarmPermission');
    return granted;
}

static Future<bool> hasExactAlarmPermission() async {
    final bool hasPermission = await _channel.invokeMethod('hasExactAlarmPermission');
    return hasPermission;
}
```

**4. Service Layer Methods (`HealthService.dart`):**
```dart
static Future<bool> requestExactAlarmPermission() async {
    final bool result = await MinimalHealthChannel.requestExactAlarmPermission();
    return result;
}

static Future<bool> hasExactAlarmPermission() async {
    final bool result = await MinimalHealthChannel.hasExactAlarmPermission();
    return result;
}
```

**5. Startup Integration (`PermissionService.dart`):**
```dart
static Future<bool> requestEssentialPermissions() async {
    // Request notification permission
    final notificationStatus = await Permission.notification.request();
    
    // Request exact alarm permission during startup
    bool exactAlarmGranted = true;
    try {
        exactAlarmGranted = await HealthService.requestExactAlarmPermission();
    } catch (e) {
        exactAlarmGranted = false;
    }
    
    return notificationStatus == PermissionStatus.granted;
}
```

## 🔄 Maintenance

### Regular Checks:
- Review merged manifests after major updates
- Test permissions on new Android versions
- Update Health Connect dependencies regularly
- Monitor Google Play Console for permission warnings
- Verify critical permissions are requested at startup

### When Updating Dependencies:
1. Check if new permissions are required
2. Verify existing permissions still work
3. Test on multiple Android versions
4. Update this guide if process changes
5. Test permission request flow on fresh app installs

---

## 📞 Quick Reference

**Files to Always Update for New Permissions:**
1. `android/app/src/main/AndroidManifest.xml`
2. `android/app/src/debug/AndroidManifest.xml`
3. `android/app/src/release/AndroidManifest.xml` ⚠️ **Most Important**
4. `android/app/src/main/kotlin/com/habittracker/habitv8/MinimalHealthPlugin.kt`
5. `lib/services/minimal_health_channel.dart`
6. `lib/services/health_service.dart`

**Commands for Testing:**
```bash
# Clean build
flutter clean

# Debug build
flutter build apk --debug

# Release build  
flutter build apk --release

# Check merged manifest
cat android/app/build/intermediates/merged_manifests/release/processReleaseManifest/AndroidManifest.xml
```

**Remember:** The release AndroidManifest.xml is the most common source of permission issues!