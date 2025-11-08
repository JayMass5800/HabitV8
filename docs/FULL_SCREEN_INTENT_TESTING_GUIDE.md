# Full Screen Intent Permission - Testing Guide

## Quick Test Checklist

### Prerequisites
- Device or emulator running Android 14+ (API 34+)
- Device or emulator running Android 13 (API 33) for comparison
- Fresh install of the app

### Test Scenario 1: Android 14+ - First Time User

#### Steps:
1. Install the app on Android 14+ device
2. Complete onboarding
3. Try to create a new habit
4. Scroll to "Notifications & Alarms" section
5. Toggle "Enable Alarms" **ON**

#### Expected Result:
✅ A dialog appears with:
- Title: "Alarm Permission Required"
- Message explaining the permission requirement
- Two buttons: "Cancel" and "Open Settings"

6. Click "Open Settings"

#### Expected Result:
✅ Android system settings page opens showing:
- "Alarms & reminders" settings
- HabitV8 app listed
- Toggle to enable full screen intent permission

7. Enable the permission in system settings
8. Return to the app
9. Toggle "Enable Alarms" again

#### Expected Result:
✅ Alarm toggle enables without showing the dialog
✅ Alarm sound picker appears

---

### Test Scenario 2: Android 14+ - User Cancels

#### Steps:
1. Fresh app state (no alarm permission granted)
2. Try to enable alarms
3. Dialog appears
4. Click "Cancel"

#### Expected Result:
✅ Dialog dismisses
✅ Alarm toggle remains **OFF**
✅ No errors or crashes

---

### Test Scenario 3: Android 14+ - Permission Already Granted

#### Steps:
1. Permission already granted (from previous test or system settings)
2. Try to create a new habit
3. Toggle "Enable Alarms" **ON**

#### Expected Result:
✅ No dialog appears
✅ Alarm toggle enables immediately
✅ Alarm sound picker appears

---

### Test Scenario 4: Android 13 - Auto-Granted Permission

#### Steps:
1. Install the app on Android 13 device
2. Try to create a new habit
3. Toggle "Enable Alarms" **ON**

#### Expected Result:
✅ No dialog appears
✅ Alarm toggle enables immediately
✅ Alarm sound picker appears
✅ Works exactly as before (no behavior change)

---

### Test Scenario 5: Edit Existing Habit

#### Steps:
1. Create a habit without alarms
2. Edit the habit
3. Try to enable alarms

#### Expected Result:
✅ Same behavior as creating new habit
✅ Dialog appears if permission not granted (Android 14+)
✅ Works immediately if permission granted or Android 13

---

### Test Scenario 6: Permission Check Method

#### Verify Method Channel Communication:
```dart
// Check permission status
final canUse = await PermissionService.canUseFullScreenIntent();
print('Can use full screen intent: $canUse');

// Open settings
final opened = await PermissionService.openFullScreenIntentSettings();
print('Settings opened: $opened');
```

#### Expected Logs (Android 14+):
```
I/FullScreenIntent: Can use full screen intent: false (API 34)
I/PermissionService: Full screen intent permission check: false
I/FullScreenIntent: Opening full screen intent settings
I/PermissionService: Opened full screen intent settings
```

#### Expected Logs (Android 13):
```
I/FullScreenIntent: Can use full screen intent: true (API 33)
I/PermissionService: Full screen intent permission check: true
I/FullScreenIntent: Full screen intent settings not needed for API 33
```

---

## Automated Testing

### Unit Test - Permission Check (Android 14+)
```dart
test('Full screen intent permission check on Android 14+', () async {
  final canUse = await PermissionService.canUseFullScreenIntent();
  // Should return false if not granted, true if granted
  expect(canUse, isA<bool>());
});
```

### Integration Test - Alarm Toggle Flow
```dart
testWidgets('Alarm toggle shows permission dialog on Android 14+', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.tap(find.text('Create Habit'));
  await tester.pumpAndSettle();
  
  await tester.tap(find.byType(SwitchListTile).last); // Alarm toggle
  await tester.pumpAndSettle();
  
  // Expect dialog to appear if permission not granted
  expect(find.text('Alarm Permission Required'), findsOneWidget);
  expect(find.text('Open Settings'), findsOneWidget);
  expect(find.text('Cancel'), findsOneWidget);
});
```

---

## Visual Verification

### Dialog Appearance
Check that the dialog:
- Has proper title and message
- Buttons are properly styled (Cancel = text button, Open Settings = filled button)
- Text is readable and clear
- Dialog is centered on screen
- Background dimmed properly

### Info Box Appearance
Check that the info box below alarm settings:
- Uses blue color (info) instead of orange (warning)
- Has info icon instead of warning icon
- Text is updated to mention Android 14+
- Properly formatted and aligned

---

## Error Scenarios

### Test Error Handling:

1. **Method channel error**:
   - Disconnect from native bridge temporarily
   - Try to enable alarms
   - Should gracefully handle error and not crash

2. **Settings activity not found**:
   - Should log error but not crash
   - User should see error message

3. **Permission denied multiple times**:
   - Try to enable alarms
   - Deny permission in settings
   - Return to app
   - Try again
   - Should show dialog again each time

---

## Google Play Console Verification

### Pre-Upload Check:
1. Build release APK/AAB with the fix
2. Run Google Play pre-launch report locally
3. Check for policy warnings
4. Ensure no "Inappropriate permission usage" warnings

### Post-Upload Check:
1. Upload to Internal Testing track
2. Wait for Google Play automated testing
3. Check "Policy status" in Play Console
4. Verify no warnings about USE_FULL_SCREEN_INTENT

---

## Common Issues and Solutions

### Issue: Dialog doesn't appear on Android 14+
**Solution**: Check that the method channel is properly set up in MainActivity.kt and called in configureFlutterEngine()

### Issue: Settings page doesn't open
**Solution**: Verify that Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT intent is correct and package name is properly set

### Issue: Permission still auto-granted on Android 14+
**Solution**: Ensure the app is targeting SDK 34+ and manifest is properly configured

### Issue: Crash when checking permission
**Solution**: Check API level checks are correct (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE)

---

## Performance Considerations

### Method Channel Calls:
- Each permission check makes a native call
- Cached result for performance (permission status doesn't change often)
- Dialog only shown once per alarm enable attempt

### User Experience:
- Permission check is fast (<50ms typical)
- Settings page opens immediately
- No blocking operations on UI thread

---

## Success Criteria

✅ Google Play Store accepts the app without warnings  
✅ Android 14+ users can grant permission via settings  
✅ Android 13 and below users see no changes  
✅ Dialog is clear and user-friendly  
✅ No crashes or errors during permission flow  
✅ Permission persists after being granted  
✅ Alarms work properly after permission is granted  

---

## Rollback Plan

If issues are found:
1. Revert changes to permission flow
2. Use old alarm system without full screen intent
3. Update documentation
4. Investigate alternative solutions

Current implementation allows easy rollback by:
- Removing permission check in UI
- Keeping old behavior (auto-request)
- Maintaining backward compatibility