# Alarm Sounds Integration Issue - Root Cause Analysis & Fix

## Problem Summary
Some alarm sounds (especially "Wake Up" and others towards the bottom of the list) don't work and default to the first alarm sound instead.

## Root Cause
There's a **file format mismatch** between Flutter assets and how they're being referenced:

### Current State:
1. **Flutter Assets** (`assets/sounds/`): `.ogg` format (OGG Vorbis)
   - `wake_up.ogg`, `wake_up_wake_up.ogg`, `trrrrrrrr.ogg`, `snoozer.ogg`, `instance.ogg`, etc.
   
2. **Android Raw Resources** (`android/app/src/main/res/raw/`): `.mp3` format
   - `wake_up.mp3`, `wake_up_wake_up.mp3`, `trrrrrrrr.mp3`, `snoozer.mp3`, `instance.mp3`, etc.

3. **Sound Naming in alarm_service.dart**:
   ```dart
   final customSounds = [
     {'name': 'Wake Up', 'uri': 'sounds/wake_up.ogg', 'type': 'custom'},
     ...
   ];
   ```
   These reference `.ogg` files (correct for Flutter assets).

4. **Sound Normalization in notification_alarm_scheduler.dart** (`_normalizeAlarmSoundUri`):
   ```dart
   // Line 558: Forces .mp3 extension!
   return 'sounds/$name.mp3';  // ❌ WRONG! Should be .ogg
   ```
   This function converts sound names to `.mp3` format, but Flutter assets are `.ogg`!

### Why Some Sounds Fail:
- When a sound name like "Wake Up" is used, it gets normalized to `sounds/wake_up.mp3`
- But the actual Flutter asset is `sounds/wake_up.ogg`
- The asset loader can't find the file and falls back to the default alarm sound
- Some sounds might work occasionally due to caching or fallback behavior

## Solution Applied
The fix involves updating alarm sound path normalization to use `.ogg` format (matching Flutter assets):

### 1. **Primary Fix** - `lib/services/notifications/notification_alarm_scheduler.dart`

**Lines 552-560**: Changed `_normalizeAlarmSoundUri` function:
```dart
// BEFORE:
if (name.endsWith('.mp3')) {
  return 'sounds/$name';
}
return 'sounds/$name.mp3';  // ❌ Wrong format

// AFTER:
if (name.endsWith('.ogg') || name.endsWith('.mp3')) {
  return 'sounds/$name';
}
return 'sounds/$name.ogg';  // ✅ Correct format for Flutter assets
```

**Line 564**: Changed default sound:
```dart
// BEFORE: return 'sounds/alarm.mp3';
// AFTER:
return 'sounds/alarm.ogg';
```

### 2. **Extension Handling** - `lib/services/alarm_service.dart`

**Lines 476-481**: Enhanced `_normalizeAlarmSoundName` to handle both extensions:
```dart
// Now removes both .mp3 and .ogg extensions
if (filename.endsWith('.mp3')) {
  filename = filename.substring(0, filename.length - 4);
} else if (filename.endsWith('.ogg')) {
  filename = filename.substring(0, filename.length - 4);
}
```

### 3. **Test Data** - `lib/services/alarm_test_helper.dart`

**Line 24**: Updated test helper:
```dart
// BEFORE: alarmSoundName: 'sounds/alarm.mp3',
// AFTER:
alarmSoundName: 'sounds/alarm.ogg',
```

### 4. **Documentation Updates**

- Updated comments in `notification_alarm_scheduler.dart` to reflect `.ogg` format
- Updated docstring examples in `alarm_service.dart` to use correct format
- Added notes about format expectations

## Why This Works:
1. **Flutter Assets**: Uses exact file paths - `sounds/wake_up.ogg` ✓
2. **Asset Loading**: AssetSource resolves to `assets/sounds/wake_up.ogg` ✓
3. **Android Resources**: AlarmService normalizes to `wake_up` (without extension) → `resource://raw/wake_up` ✓
4. **Consistency**: Both preview (audioplayers) and notification alarms now use correct format ✓

## Files Modified:
- ✅ `lib/services/notifications/notification_alarm_scheduler.dart` - Fixed to use `.ogg`
- ✅ `lib/services/alarm_service.dart` - Enhanced extension handling
- ✅ `lib/services/alarm_test_helper.dart` - Updated test data
- `assets/sounds/` - All `.ogg` files (no change needed)
- `android/app/src/main/res/raw/` - All `.mp3` files (no change needed - Android resource conversion is transparent)

## Testing Recommendations

After building, test these sounds specifically (the ones that had issues):
1. **Wake Up** - `sounds/wake_up.ogg`
2. **Wake Up Wake Up** - `sounds/wake_up_wake_up.ogg`
3. **Snoozer** - `sounds/snoozer.ogg`
4. **Trrrrrrrr** - `sounds/trrrrrrrr.ogg`
5. **Instance** - `sounds/instance.ogg`

**Test Steps**:
1. Create a new habit with alarm enabled
2. Select each sound from the dropdown
3. Tap the play button to preview the sound
4. Set a notification time and verify the alarm triggers with the correct sound
5. Verify snooze alarms also use the correct sound

## Technical Notes

- Flutter asset format (`.ogg`) and Android raw resource format (`.mp3`) are handled separately
- The `_normalizeAlarmSoundUri` function ensures Flutter gets `.ogg` paths
- The `_normalizeAlarmSoundName` function strips extensions to create Android raw resource names
- Both audio preview and notification alarms now use consistent formatting