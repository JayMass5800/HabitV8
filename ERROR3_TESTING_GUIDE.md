# Quick Testing Guide - error3.md Fixes

## 🚀 Quick Start Testing

### Test 1: Notification Complete/Snooze (5 min)
1. Create a daily habit with notifications enabled
2. Wait for notification to appear (or trigger manually via device settings)
3. Tap "Complete" action button on notification
4. ✅ **Expected**: Habit shows as completed in timeline
5. Create another habit, wait for notification
6. Tap "Snooze" action button
7. ✅ **Expected**: New notification appears in 30 minutes

**If it fails:**
- Check logs for: `onNotificationAction callback is properly registered`
- Check logs for: `directCompletionHandler` is set
- Look for: `NotificationStorage.storeAction()` calls

---

### Test 2: Alarm Selection in V2 (3 min)
1. Open app → Tap "+" → Select "Create Habit"
2. Enter habit name: "Test Alarm"
3. Scroll to "Notifications & Alarms" section
4. ✅ **Expected**: See "Enable Alarms" switch (should be toggleable)
5. Toggle "Enable Alarms" ON
6. ✅ **Expected**: "Alarm Sound" option appears below
7. Tap "Alarm Sound"
8. ✅ **Expected**: Dialog shows with list of alarm sounds
9. Tap play button on any sound
10. ✅ **Expected**: Sound plays for 4 seconds then stops
11. Select a sound and tap it
12. ✅ **Expected**: Dialog closes, selected sound name shows in "Alarm Sound" field

---

### Test 3: Habit Suggestions (2 min)
1. Open app → Tap "+" → Select "Create Habit"
2. Wait 1-2 seconds
3. ✅ **Expected**: "Habit Suggestions" card appears (if suggestions loaded)
4. Tap "Show" button on suggestions card
5. ✅ **Expected**: Suggestions expand showing grouped categories (Health, Fitness, etc.)
6. Tap any suggestion (e.g., "Drink 8 glasses of water")
7. ✅ **Expected**: 
   - Habit name field fills with suggestion name
   - Description fills
   - Category and color update
   - Frequency sets appropriately
   - Suggestions panel collapses

---

### Test 4: Advanced Mode - No Crash (2 min)
1. Open app → Tap "+" → Select "Create Habit"
2. In "Schedule" section, select "One-time" frequency (ChoiceChip)
3. Toggle "Advanced" mode button
4. ✅ **Expected**: Advanced mode UI appears WITHOUT crashing
5. ✅ **Expected**: NO duplicate frequency selector shown
6. Switch back to "Daily" frequency
7. Toggle "Advanced" mode again
8. ✅ **Expected**: Shows interval selector, termination options
9. ✅ **Expected**: Still NO duplicate frequency selector

---

## 🐛 Common Issues & Solutions

### Issue: "Complete" button doesn't mark habit
**Symptoms:** Tap complete on notification, nothing happens
**Check:**
```
adb logcat | grep "NotificationAction"
```
Look for:
- `✅ Notification action callback is properly registered`
- `✅ Using callback to process pending actions`

**Solution:** 
- Restart app (callback re-registers on startup)
- Check `NotificationStorage` - action may be pending for next app launch

---

### Issue: "Enable Alarms" switch is grayed out
**Symptoms:** Can't toggle alarm switch
**Check:** File `create_habit_screen_v2.dart` line 62
**Should be:** `bool _alarmEnabled = false;`
**NOT:** `final bool _alarmEnabled = false;`

---

### Issue: No habit suggestions appear
**Symptoms:** Suggestions card never shows
**Check:**
```dart
// In create_habit_screen_v2.dart
if (_habitSuggestions.isNotEmpty) ...
```
**Possible causes:**
- `ComprehensiveHabitSuggestionsService` failing to load
- Network/permission issues (if suggestions use health data)
- Service not initialized

**Debug:**
```
adb logcat | grep "HabitSuggestion"
```

---

### Issue: Advanced mode crashes on "One-time" frequency
**Symptoms:** App crashes with dropdown assertion error
**Check:** File `rrule_builder_widget.dart` around line 395
**Should have:**
```dart
if (!widget.forceAdvancedMode) ...[
  _buildFrequencySelector(),
  const SizedBox(height: 16),
],
```

---

## 📊 Verification Commands

### Check notification callback status:
```bash
adb logcat | grep -E "callback|NotificationAction"
```

### Check alarm permissions:
```bash
adb shell dumpsys alarm | grep HabitV8
```

### Check pending notifications:
```bash
adb shell dumpsys notification | grep HabitV8
```

### Clear app data for fresh test:
```bash
adb shell pm clear com.habittracker.habitv8
```

---

## 🎯 Success Criteria

All fixes successful when:
- ✅ Notification complete/snooze marks habits
- ✅ Alarm toggle works in V2 creation screen
- ✅ Alarm sound picker shows and plays sounds
- ✅ Habit suggestions load and apply correctly
- ✅ Advanced mode doesn't crash on any frequency
- ✅ No duplicate frequency selectors in advanced mode

---

## 📝 Notes

- **Alarms and Notifications are mutually exclusive** - enabling one disables the other
- **Habit suggestions** may take 1-2 seconds to load on first app launch
- **Advanced mode frequency dropdown** should ONLY appear when `forceAdvancedMode: false` (standalone use)
- **Notification actions** use fallback storage system if callback isn't ready

---

## 🔧 Developer Commands

### Build and test:
```powershell
flutter clean
flutter pub get
flutter run --release
```

### Run tests:
```powershell
flutter test test/services/rrule_service_test.dart
```

### Check for errors:
```powershell
flutter analyze lib/ui/screens/create_habit_screen_v2.dart
flutter analyze lib/ui/widgets/rrule_builder_widget.dart
```
