# Quick Reference - Isar Migration

## ✅ What Was Fixed

### Problem
- App was using Hive for `ScheduledNotification` storage
- Hive was never initialized in background isolates
- Background notification actions failed when app was fully closed
- Widget updates couldn't access notification metadata

### Solution
- Migrated `ScheduledNotification` from Hive to Isar
- Updated all background isolates to include complete schema set
- Ensured multi-isolate database compatibility

---

## 🔑 Key Files Changed

### 1. Model
**File:** `lib/domain/model/scheduled_notification.dart`
```dart
// BEFORE: Hive
@HiveType(typeId: 3)
class ScheduledNotification extends HiveObject {
  @HiveField(0)
  late int id;
  // ...
}

// AFTER: Isar
@collection
class ScheduledNotification {
  Id id = Isar.autoIncrement;
  late int notificationId;  // Renamed from 'id'
  @Index()
  late String habitId;
  // ...
}
```

### 2. Storage Service
**File:** `lib/services/notifications/scheduled_notification_storage.dart`
```dart
// BEFORE: Hive Box API
final box = await Hive.openBox<ScheduledNotification>('scheduled_notifications');
await box.put(notification.id, notification);

// AFTER: Isar Transaction API
final isar = await IsarDatabase.instance;
await isar.writeTxn(() async {
  await isar.scheduledNotifications.put(notification);
});
```

### 3. Database Schema
**File:** `lib/data/database_isar.dart`
```dart
// BEFORE: Only HabitSchema
_isar = await Isar.open(
  [HabitSchema],
  // ...
);

// AFTER: Both schemas
_isar = await Isar.open(
  [HabitSchema, ScheduledNotificationSchema],
  // ...
);
```

### 4. Background Isolates
**File:** `lib/services/notifications/notification_action_handler.dart`
```dart
// CRITICAL: Must include ALL schemas in background isolates
final isar = await Isar.open(
  [HabitSchema, ScheduledNotificationSchema],  // ✅ Both schemas
  directory: dir.path,
  name: 'habitv8_db',      // ✅ Same name as main app
  inspector: true,          // ✅ Same setting as main app
);
```

### 5. Tree-Shaking Prevention
**File:** `lib/main.dart`
```dart
// CRITICAL: Prevent tree-shaking in release builds
// ignore: unused_import
import 'domain/model/habit.dart' as habit_model;
// ignore: unused_import
import 'domain/model/scheduled_notification.dart' as notification_model;
```

---

## 🎯 Critical Rules for Isar Multi-Isolate

### Rule 1: Same Database Name
```dart
// ✅ CORRECT - Same name everywhere
name: 'habitv8_db'

// ❌ WRONG - Different names
name: 'habitv8_db'  // main isolate
name: 'habits_db'   // background isolate
```

### Rule 2: Same Inspector Setting
```dart
// ✅ CORRECT - Same setting everywhere
inspector: true

// ❌ WRONG - Different settings
inspector: true   // main isolate
inspector: false  // background isolate
```

### Rule 3: Complete Schema List
```dart
// ✅ CORRECT - All schemas in all isolates
[HabitSchema, ScheduledNotificationSchema]

// ❌ WRONG - Missing schema in background
[HabitSchema]  // background isolate missing ScheduledNotificationSchema
```

### Rule 4: Background Entry Points
```dart
// ✅ CORRECT - Annotated top-level function
@pragma('vm:entry-point')
void callbackDispatcher() {
  // ...
}

// ❌ WRONG - Missing annotation
void callbackDispatcher() {  // Will be tree-shaken in release
  // ...
}
```

---

## 🧪 Testing Checklist

### Before Testing
- [ ] Run `flutter analyze` (should show 0 issues)
- [ ] Run `dart run build_runner build --delete-conflicting-outputs`
- [ ] Verify `scheduled_notification.g.dart` exists
- [ ] Check logcat is ready: `adb logcat | grep -i "habit\|isar\|notification"`

### Test 1: Background Completion (App Closed)
- [ ] Close app completely (swipe from recent apps)
- [ ] Wait for notification or trigger manually
- [ ] Tap "Complete" button
- [ ] Open app - habit should be marked complete
- [ ] Check widget - should show updated status
- [ ] Check logcat - no Hive errors

### Test 2: Widget Background Update
- [ ] Close app completely
- [ ] Wait for WorkManager task (or trigger)
- [ ] Check widget shows current data
- [ ] Open app - data should match widget
- [ ] Check logcat - no database errors

### Test 3: Boot Reschedule
- [ ] Schedule future notifications
- [ ] Reboot device
- [ ] Verify notifications appear at scheduled times
- [ ] Check logcat - no initialization errors

---

## 🐛 Debugging Tips

### Check Isar Database
```dart
// In any isolate
final isar = await IsarDatabase.instance;
print('Isar is open: ${isar.isOpen}');
print('Schemas: ${isar.schemas.map((s) => s.name).toList()}');
```

### Check Notification Storage
```dart
final count = await ScheduledNotificationStorage.getCount();
print('Stored notifications: $count');

final all = await ScheduledNotificationStorage.getAllNotifications();
all.forEach((n) => print('Notification: ${n.notificationId} for habit ${n.habitId}'));
```

### Logcat Filters
```bash
# All app logs
adb logcat | grep "HabitV8"

# Isar specific
adb logcat | grep -i "isar"

# Background isolate
adb logcat | grep -i "background"

# Notification actions
adb logcat | grep -i "notification.*action"
```

---

## 📊 Performance Metrics

### Expected Behavior
- **Database Open Time**: < 100ms (first time), < 10ms (subsequent)
- **Write Transaction**: < 50ms for single record
- **Query Time**: < 10ms for indexed queries
- **Background Isolate Startup**: < 500ms total

### Warning Signs
- ⚠️ Database open > 1 second (check for schema mismatch)
- ⚠️ "Isar instance already exists" (check database name consistency)
- ⚠️ "Schema mismatch" (check inspector setting consistency)
- ⚠️ "Collection not found" (check schema list completeness)

---

## 🔄 Common Issues & Solutions

### Issue: "Isar instance already exists with different schema"
**Cause:** Schema list mismatch between isolates  
**Solution:** Ensure ALL isolates include `[HabitSchema, ScheduledNotificationSchema]`

### Issue: "Collection 'ScheduledNotification' not found"
**Cause:** Schema not included in `Isar.open()`  
**Solution:** Add `ScheduledNotificationSchema` to schema list

### Issue: Background completion doesn't work
**Cause:** Missing `@pragma('vm:entry-point')` annotation  
**Solution:** Add annotation to all background entry point functions

### Issue: Release build crashes on notification action
**Cause:** Tree-shaking removed schema code  
**Solution:** Add explicit imports in `main.dart` with `// ignore: unused_import`

---

## 📝 Optional Cleanup

After successful testing, you can remove Hive dependencies:

**File:** `pubspec.yaml`
```yaml
# Remove these lines:
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0

dev_dependencies:
  hive_generator: ^2.0.1
```

Then run:
```bash
flutter pub get
flutter clean
flutter pub get
```

---

## ✅ Success Criteria

Your migration is successful when:
- ✅ `flutter analyze` shows 0 issues
- ✅ App builds without errors
- ✅ Habits can be completed from notifications (app closed)
- ✅ Widgets update immediately after background completion
- ✅ No Hive errors in logcat
- ✅ No "schema mismatch" errors in logcat
- ✅ Background isolates can access all data

---

**Last Updated:** After Hive to Isar migration  
**Status:** Ready for device testing