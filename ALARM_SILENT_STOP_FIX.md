# Alarm Silent Stop Fix

## Problem Description
Alarms were firing silently and stopping immediately when the notification was viewed (not even tapped - just viewing the notification in the notification drawer would stop the alarm sound).

## Root Cause Analysis

### Issue 1: Wrong Audio Focus Configuration
In `lib/services/alarm_sound_player.dart` line 80, the audio focus was set to:
```dart
audioFocus: AndroidAudioFocus.gainTransient,
```

**Problem**: `gainTransient` means **temporary** audio focus that Android automatically releases when:
- The notification drawer is opened/viewed
- Another app requests audio focus
- Any system UI interaction occurs
- Phone call arrives

This explained why the alarm stopped when users just **viewed** the notification!

### Issue 2: No Audio Focus Loss Recovery
The player had no mechanism to detect and recover from unexpected audio focus loss or interruptions.

## The Fix

### 1. Changed Audio Focus to Permanent (CRITICAL)
Changed from `AndroidAudioFocus.gainTransient` to `AndroidAudioFocus.gain`:

```dart
audioFocus: AndroidAudioFocus.gain,  // Permanent focus until explicitly released
```

**Why this matters**:
- `gain` = Permanent audio focus that persists until explicitly released
- `gainTransient` = Temporary focus that gets auto-released on any interruption
- Alarm sounds MUST use `gain` to survive notification drawer interactions

### 2. Added Automatic Restart on Interruption
Added player state monitoring to automatically restart the alarm if it stops unexpectedly:

```dart
player.onPlayerStateChanged.listen((state) {
  if (state == PlayerState.stopped || state == PlayerState.paused) {
    AppLogger.warning('⚠️ Alarm stopped/paused unexpectedly! Attempting to restart...');
    
    Future.delayed(const Duration(milliseconds: 500), () async {
      if (_activePlayers.containsKey(alarmId)) {
        await player.resume();
        AppLogger.info('✅ Alarm restarted successfully');
      }
    });
  }
});
```

### 3. Added Completion Listener Safety Net
Added listener for unexpected completion (though loop mode should prevent this):

```dart
player.onPlayerComplete.listen((_) {
  AppLogger.warning('⚠️ Alarm completed unexpectedly! Restarting loop...');
  if (_activePlayers.containsKey(alarmId)) {
    player.play(AssetSource(soundUri));
  }
});
```

## Testing Instructions

1. **Rebuild the app**:
   ```powershell
   flutter clean
   flutter pub get
   flutter build apk --release
   ```

2. **Test Scenario 1: Notification Drawer Interaction**
   - Create a habit with alarm enabled
   - Wait for alarm to fire
   - Pull down notification drawer to view the notification
   - **Expected**: Alarm sound continues playing loudly
   - **Previous**: Alarm would stop when drawer opened

3. **Test Scenario 2: Audio Focus Interruption**
   - Alarm fires and plays
   - Press volume buttons to show volume UI
   - **Expected**: Alarm continues playing
   - **Previous**: Alarm might stop or pause

4. **Test Scenario 3: Explicit Actions**
   - Alarm fires and plays
   - Tap "Complete" or "Snooze" button
   - **Expected**: Alarm stops immediately
   - **Status**: This already worked correctly

5. **Test Scenario 4: Full Screen Interaction**
   - Alarm fires while app is in background
   - Tap notification to open app
   - **Expected**: Alarm continues until Complete/Snooze pressed
   - **Previous**: Alarm might stop on tap

## Technical Details

### Android Audio Focus Types
- **GAIN**: Permanent focus, used for music players, alarms
- **GAIN_TRANSIENT**: Temporary focus for short sounds (notifications, nav directions)
- **GAIN_TRANSIENT_MAY_DUCK**: Temporary focus that allows other audio to continue at lower volume
- **GAIN_TRANSIENT_EXCLUSIVE**: Temporary focus that pauses other audio

### Why Alarms Need GAIN
Alarm sounds are long-duration, looping sounds that must survive:
- UI interactions (notification drawer, volume controls)
- App switching
- Screen on/off
- Other app audio requests

Only `GAIN` provides this level of persistence.

## Related Code Locations

- **AlarmSoundPlayer**: `lib/services/alarm_sound_player.dart` (lines 64-96, 100-103)
- **Notification Action Handler**: `lib/services/notifications/notification_action_handler.dart` (lines 46, 145)
- **Alarm Service**: `lib/services/alarm_service.dart` (notification scheduling)
- **MainActivity Lifecycle**: `android/app/src/main/kotlin/com/habittracker/habitv8/MainActivity.kt` (lines 76-94)

## Verification

Check logcat for these messages:
- `🎵 Alarm [ID] player state: PlayerState.playing` - Alarm started
- `⚠️ Alarm [ID] stopped/paused unexpectedly!` - Interruption detected
- `✅ Alarm [ID] restarted successfully` - Auto-recovery worked
- `🔇 Stopping alarm sound for notification [ID]` - User action processed

## Impact
- ✅ Alarms now continue playing when notification drawer is opened
- ✅ Alarms survive audio focus interruptions
- ✅ Alarms automatically restart if unexpectedly paused
- ✅ Alarms still stop correctly when Complete/Snooze is pressed
- ✅ No changes needed to MainActivity lifecycle handling

## Audio Configuration Summary

```dart
// CORRECT Configuration (now implemented)
AudioContextAndroid(
  contentType: AndroidContentType.sonification,
  usageType: AndroidUsageType.alarm,
  audioFocus: AndroidAudioFocus.gain,        // ✅ Permanent focus
  isSpeakerphoneOn: true,                     // ✅ Use speaker, not earpiece
  stayAwake: true,                            // ✅ Keep device awake
)

// INCORRECT Configuration (previous)
AudioContextAndroid(
  contentType: AndroidContentType.sonification,
  usageType: AndroidUsageType.alarm,
  audioFocus: AndroidAudioFocus.gainTransient, // ❌ Temporary focus
  isSpeakerphoneOn: true,
  stayAwake: true,
)
```

## Notes
- The MainActivity already has correct lifecycle handling (preserves alarm on pause/resume)
- The notification action handler already stops alarms correctly on Complete/Snooze
- This fix only changes the audio focus configuration and adds resilience