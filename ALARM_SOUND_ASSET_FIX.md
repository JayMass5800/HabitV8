# Alarm Sound Asset Loading Fix

## Issue
"Unable to load asset" error when trying to preview alarm sounds.

## Root Cause
**Asset changes require a FULL APP REBUILD**, not just hot restart or hot reload. When assets are added, modified, or their declarations in `pubspec.yaml` are changed, Flutter must rebundle the app.

## Solution

### Step 1: Stop the App Completely
```powershell
# Stop any running Flutter process
# In VS Code: Press the Stop button (red square) in the debug toolbar
```

### Step 2: Clean Build Artifacts
```powershell
flutter clean
```

### Step 3: Get Dependencies
```powershell
flutter pub get
```

### Step 4: Full Rebuild and Install
```powershell
# For development device
flutter run

# OR for release build (recommended for testing)
flutter build apk --release
# Then manually install the APK on your device
```

### Step 5: Test Sound Preview
1. Open the app (completely fresh install)
2. Create or edit a habit
3. Enable "Alarm Mode"
4. Tap "Select Alarm Sound"
5. Tap the play button on any sound
6. **Expected**: Sound should play for 4 seconds

## Asset Configuration Verification

### pubspec.yaml declares:
```yaml
assets:
  - assets/sounds/
  - ringtones/
```

### Asset paths in code:
- Format: `ringtones/Alarm.mp3`
- Matches the declaration in pubspec.yaml ✅

### Files exist in project:
```
c:\HabitV8\ringtones\
  ├── 01_Classmate.mp3
  ├── 02_Small_Spring.mp3
  ├── Alarm.mp3
  ├── Alarm_1.mp3
  └── ... (38 total MP3 files)
```

## Troubleshooting

### If still getting "unable to load asset":

1. **Check Flutter logs for exact error**:
   ```powershell
   # Run with verbose logging
   flutter run -v
   ```
   
2. **Look for these log messages**:
   ```
   🔊 Attempting to play preview: ringtones/Alarm.mp3
   🔊 Asset path that will be used: ringtones/Alarm.mp3
   🔊 About to call play() with AssetSource("ringtones/Alarm.mp3")
   ```

3. **Verify asset is bundled**:
   ```powershell
   # After building, check if assets are in the APK
   # Extract APK and look for assets/flutter_assets/ringtones/
   ```

4. **Check for typos**: The sound URI must exactly match:
   - File exists: `c:\HabitV8\ringtones\Alarm.mp3` ✅
   - Code uses: `ringtones/Alarm.mp3` ✅
   - pubspec declares: `ringtones/` ✅

### If error persists after full rebuild:

The issue might be with audioplayers package. Try these diagnostics:

1. **Check audioplayers version** in `pubspec.yaml`:
   ```yaml
   audioplayers: ^6.1.0
   ```

2. **Test with a simple standalone player**:
   ```dart
   final player = AudioPlayer();
   await player.play(AssetSource('ringtones/Alarm.mp3'));
   ```

3. **Check Android permissions** (though this shouldn't affect asset loading):
   - No special permissions needed for asset playback
   - Only external storage sounds need permissions

## Technical Notes

### Why Hot Reload Doesn't Work for Assets
- Hot reload: Updates Dart code only
- Hot restart: Restarts app but uses cached assets
- **Full rebuild**: Rebundles ALL assets into the app ✅

### Asset Loading in Flutter
1. Assets declared in `pubspec.yaml` are bundled into the app
2. At build time, Flutter creates `flutter_assets/` directory
3. `AssetSource('ringtones/Alarm.mp3')` looks for `flutter_assets/ringtones/Alarm.mp3`
4. Path must match EXACTLY as declared in pubspec

### Enhanced Error Logging
The code now includes detailed logging:
- Asset path being used
- Player state changes
- Stream errors
- Full stack traces

This helps diagnose exactly where the failure occurs.

## Files Modified
- ✅ `lib/services/alarm_service.dart` - Enhanced logging
- 📄 `ALARM_SOUND_ASSET_FIX.md` - This documentation

## Next Steps
1. **CRITICAL**: Do a full `flutter clean` and rebuild
2. Test sound preview
3. If still failing, provide the exact error from logs
4. We may need to investigate audioplayers package issue or asset bundling