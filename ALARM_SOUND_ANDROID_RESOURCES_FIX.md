# Alarm Sound Android Resources Fix

## Problem
Alarm sounds were not playing from notifications because Awesome Notifications requires sound files to be in Android native resources (`android/app/src/main/res/raw/`), not just Flutter assets.

## Root Cause
The app had two separate systems:
1. **Preview playback**: Uses `audioplayers` to play from Flutter assets (`ringtones/` folder) ✅ Working
2. **Notification sounds**: Awesome Notifications needs files in `android/app/src/main/res/raw/` ❌ Missing

## Changes Made

### 1. Copied Sound Files to Android Resources
All 38 MP3 files from `ringtones/` folder copied to `android/app/src/main/res/raw/` with proper Android resource naming:
- **Must start with a letter** (not a number)
- Converted to lowercase
- Replaced spaces with underscores
- Replaced hyphens with underscores
- Removed number prefixes (e.g., `01_`, `02_`)

Examples:
- `01_Classmate.mp3` → `classmate.mp3`
- `Wake_Up.mp3` → `wake_up.mp3`
- `3d_Bomb.mp3` → `bomb_3d.mp3`

### 2. Updated Notification Channel (notification_core.dart)
```dart
playSound: true, // Changed from false - enables custom sounds
```

### 3. Enhanced Resource Name Conversion (alarm_service.dart)
Added proper conversion logic to transform Flutter asset names to Android resource format:
```dart
String resourceName = alarmSoundName
    .replaceAll('.mp3', '')
    .toLowerCase()
    .replaceAll(' ', '_')
    .replaceAll('-', '_');

// Remove leading number prefixes (e.g., "01_classmate" -> "classmate")
resourceName = resourceName.replaceFirst(RegExp(r'^\d+_'), '');

// Handle special case: 3d_bomb -> bomb_3d
if (resourceName == '3d_bomb') {
  resourceName = 'bomb_3d';
}

customSound = 'resource://raw/$resourceName';
```

This ensures all resource names comply with Android requirements (must start with a letter).

## Testing Instructions

1. **Rebuild the app** (required for Android resource changes):
   ```powershell
   flutter clean
   flutter pub get
   flutter build apk --release
   ```

2. **Test alarm sound selection**:
   - Create/edit a habit
   - Enable alarm
   - Select a custom sound
   - Save habit

3. **Test actual alarm**:
   - Wait for scheduled time or use test notification
   - Verify custom sound plays (not just vibration)

4. **Test preview**:
   - In sound selection dialog, tap any sound
   - Preview should play immediately

## Files Modified
- `lib/services/notifications/notification_core.dart` - Channel configuration
- `lib/services/alarm_service.dart` - Resource name conversion
- `android/app/src/main/res/raw/*.mp3` - Added 38 sound files

## Note on ImeTracker Error
The reported `ImeTracker` error is unrelated to alarm sounds - it's an Android input method framework timeout warning that doesn't affect functionality.