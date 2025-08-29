# Health Connect Integration for Android 16 (SDK 36)

This implementation provides a complete solution for integrating with Health Connect on Android 16 (SDK 36) with proper background permission handling.

## Key Components

### 1. HealthConnectActivity

This activity handles the permission request flow using the proper Health Connect API patterns. It:
- Checks Health Connect availability
- Requests permissions including background access
- Handles permission results

### 2. PermissionsRationaleActivity

This activity is shown when the user clicks on the privacy policy link in the Health Connect permissions screen. It:
- Explains how the app uses health data
- Provides a link to the full privacy policy
- Required for proper Health Connect integration on Android 14+

### 3. MinimalHealthPlugin

This plugin provides the native implementation for Health Connect integration. It:
- Initializes Health Connect client
- Requests permissions including background access
- Reads health data
- Handles background monitoring

## Permission Handling

The implementation properly handles all required permissions, including:
- Regular health data permissions (steps, heart rate, etc.)
- Background health data access permission

## Background Monitoring

Background health data access is properly implemented with:
- Explicit background permission request
- Verification of background permission grant
- Background monitoring service

## Usage

1. Initialize Health Connect:
```kotlin
val healthConnectClient = HealthConnectClient.getOrCreate(context)
```

2. Request permissions including background access:
```kotlin
val permissions = setOf(
    HealthPermission.getReadPermission(StepsRecord::class),
    HealthPermission.getReadPermission(HeartRateRecord::class),
    "android.permission.health.READ_HEALTH_DATA_IN_BACKGROUND"
)

val requestPermissionLauncher = registerForActivityResult(
    PermissionController.createRequestPermissionResultContract()
) { granted ->
    // Handle permission result
}

requestPermissionLauncher.launch(permissions)
```

3. Check if background permission is granted:
```kotlin
val grantedPermissions = healthConnectClient.permissionController.getGrantedPermissions()
val hasBackgroundPermission = grantedPermissions.contains("android.permission.health.READ_HEALTH_DATA_IN_BACKGROUND")
```

## Android 16 (SDK 36) Compatibility

This implementation is fully compatible with Android 16 (SDK 36) and includes:
- Updated Health Connect client library (1.1.0)
- Proper activity-alias for Android 14+ compatibility
- Background permission handling
- Privacy policy rationale activity

## Testing

Test the implementation on:
- Android 13 devices (API 33)
- Android 14 devices (API 34)
- Android 15 devices (API 35)
- Android 16 devices (API 36)

Verify that:
- Permissions are properly requested
- Background access is granted
- Health data can be read
- Background monitoring works correctly

