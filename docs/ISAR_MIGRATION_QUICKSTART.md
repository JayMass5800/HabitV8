# Isar Migration Quick Start Guide

## 🚀 Ready to Start? Follow These Steps

This guide will help you begin the Hive to Isar migration for HabitV8.

---

## Prerequisites Checklist

Before starting, ensure you have:

- [ ] Read `ISAR_MIGRATION_PLAN.md` completely
- [ ] Read `HIVE_VS_ISAR_COMPARISON.md` for context
- [ ] Backed up current database
- [ ] Created a new Git branch for migration
- [ ] Informed team members about migration
- [ ] Set up testing environment

---

## Step 1: Create Migration Branch

```powershell
# Create and switch to migration branch
git checkout -b feature/isar-migration

# Ensure you're on the right branch
git branch
```

---

## Step 2: Backup Current Database

### Option A: Export All Habits (Recommended)

Add this temporary function to your app:

```dart
// Add to lib/services/data_export_import_service.dart
Future<void> exportAllHabitsForMigration() async {
  final habitService = await ref.read(habitServiceProvider.future);
  final habits = await habitService.getAllHabits();
  
  final jsonData = habits.map((h) => {
    'id': h.id,
    'name': h.name,
    'description': h.description,
    'category': h.category,
    'colorValue': h.colorValue,
    'createdAt': h.createdAt.toIso8601String(),
    'frequency': h.frequency.name,
    'completions': h.completions.map((c) => c.toIso8601String()).toList(),
    // ... all other fields
  }).toList();
  
  final file = File('${dir.path}/habits_backup_${DateTime.now().millisecondsSinceEpoch}.json');
  await file.writeAsString(jsonEncode(jsonData));
  
  AppLogger.info('✅ Backup saved to: ${file.path}');
}
```

### Option B: Copy Hive Database Files

```powershell
# Find Hive database location
# Usually in: C:\Users\<username>\AppData\Local\<app_name>\

# Copy the entire directory
Copy-Item -Path "path\to\hive\db" -Destination "path\to\backup" -Recurse
```

---

## Step 3: Update Dependencies

### 3.1 Update `pubspec.yaml`

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Keep existing dependencies...
  cupertino_icons: ^1.0.8
  flutter_local_notifications: ^18.0.1
  permission_handler: ^12.0.1
  device_info_plus: ^11.5.0
  
  # COMMENT OUT Hive (don't remove yet - we need it for migration)
  hive: ^2.2.3  # TODO: Remove after migration
  hive_flutter: ^1.1.0  # TODO: Remove after migration
  
  # ADD Isar
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1
  
  # Keep all other dependencies...
  flutter_riverpod: ^2.4.10
  provider: ^6.1.2
  go_router: ^16.1.0
  fl_chart: ^0.68.0
  path_provider: ^2.1.3
  # ... rest of dependencies

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  
  # COMMENT OUT Hive generator (don't remove yet)
  hive_generator: ^2.0.1  # TODO: Remove after migration
  
  # ADD Isar generator
  isar_generator: ^3.1.0+1
  
  build_runner: ^2.4.13
```

### 3.2 Install Dependencies

```powershell
# Get new packages
flutter pub get

# Verify installation
flutter pub deps | Select-String "isar"
```

Expected output:
```
|-- isar 3.1.0+1
|-- isar_flutter_libs 3.1.0+1
`-- isar_generator 3.1.0+1
```

---

## Step 4: Create Isar Model

### 4.1 Create New Model File

Create `lib/domain/model/habit_isar.dart`:

```dart
import 'package:isar/isar.dart';

part 'habit_isar.g.dart';

@collection
class Habit {
  // Isar auto-increment ID
  Id id = Isar.autoIncrement;
  
  // Keep string ID for compatibility
  @Index(unique: true)
  late String habitId;
  
  late String name;
  
  String? description;
  
  late String category;
  
  late int colorValue;
  
  late DateTime createdAt;
  
  DateTime? nextDueDate;
  
  @Enumerated(EnumType.name)
  late HabitFrequency frequency;
  
  late int targetCount;
  
  List<DateTime> completions = [];
  
  int currentStreak = 0;
  
  int longestStreak = 0;
  
  bool isActive = true;
  
  bool notificationsEnabled = true;
  
  DateTime? notificationTime;
  
  List<int> weeklySchedule = [];
  
  List<int> monthlySchedule = [];
  
  DateTime? reminderTime;
  
  @Enumerated(EnumType.name)
  HabitDifficulty difficulty = HabitDifficulty.medium;
  
  List<int> selectedWeekdays = [];
  
  List<int> selectedMonthDays = [];
  
  List<String> hourlyTimes = [];
  
  List<String> selectedYearlyDates = [];
  
  DateTime? singleDateTime;
  
  bool alarmEnabled = false;
  
  String? alarmSoundName;
  
  String? alarmSoundUri;
  
  int snoozeDelayMinutes = 10;
  
  // RRule fields
  String? rruleString;
  
  DateTime? dtStart;
  
  bool usesRRule = false;
}

enum HabitFrequency {
  hourly,
  daily,
  weekly,
  monthly,
  yearly,
  single,
}

enum HabitDifficulty {
  easy,
  medium,
  hard,
}
```

### 4.2 Generate Isar Schema

```powershell
# Generate Isar schema
flutter pub run build_runner build --delete-conflicting-outputs
```

This will create `lib/domain/model/habit_isar.g.dart`.

---

## Step 5: Create Migration Utility

Create `lib/data/migration/hive_to_isar_migrator.dart`:

```dart
import 'package:hive/hive.dart';
import 'package:isar/isar.dart';
import '../../domain/model/habit.dart' as hive_model;
import '../../domain/model/habit_isar.dart' as isar_model;
import '../../services/logging_service.dart';

class HiveToIsarMigrator {
  /// Migrate all habits from Hive to Isar
  static Future<MigrationResult> migrateAllHabits(
    Box<hive_model.Habit> hiveBox,
    Isar isar,
  ) async {
    try {
      AppLogger.info('🔄 Starting migration...');
      
      final hiveHabits = hiveBox.values.toList();
      AppLogger.info('📊 Found ${hiveHabits.length} habits in Hive');
      
      final isarHabits = <isar_model.Habit>[];
      final errors = <String>[];
      
      for (final hiveHabit in hiveHabits) {
        try {
          isarHabits.add(_convertHabitToIsar(hiveHabit));
        } catch (e) {
          errors.add('Failed to convert habit ${hiveHabit.id}: $e');
          AppLogger.error('Error converting habit ${hiveHabit.id}', e);
        }
      }
      
      AppLogger.info('✅ Converted ${isarHabits.length} habits');
      
      // Write to Isar in a transaction
      await isar.writeTxn(() async {
        await isar.habits.putAll(isarHabits);
      });
      
      AppLogger.info('✅ Wrote ${isarHabits.length} habits to Isar');
      
      // Verify migration
      final isarCount = await isar.habits.count();
      AppLogger.info('📊 Isar now contains $isarCount habits');
      
      return MigrationResult(
        success: errors.isEmpty,
        migratedCount: isarHabits.length,
        totalCount: hiveHabits.length,
        errors: errors,
      );
    } catch (e) {
      AppLogger.error('❌ Migration failed', e);
      return MigrationResult(
        success: false,
        migratedCount: 0,
        totalCount: 0,
        errors: ['Migration failed: $e'],
      );
    }
  }
  
  /// Convert single Hive habit to Isar habit
  static isar_model.Habit _convertHabitToIsar(hive_model.Habit hiveHabit) {
    return isar_model.Habit()
      ..habitId = hiveHabit.id
      ..name = hiveHabit.name
      ..description = hiveHabit.description
      ..category = hiveHabit.category
      ..colorValue = hiveHabit.colorValue
      ..createdAt = hiveHabit.createdAt
      ..nextDueDate = hiveHabit.nextDueDate
      ..frequency = _convertFrequency(hiveHabit.frequency)
      ..targetCount = hiveHabit.targetCount
      ..completions = List.from(hiveHabit.completions)
      ..currentStreak = hiveHabit.currentStreak
      ..longestStreak = hiveHabit.longestStreak
      ..isActive = hiveHabit.isActive
      ..notificationsEnabled = hiveHabit.notificationsEnabled
      ..notificationTime = hiveHabit.notificationTime
      ..weeklySchedule = List.from(hiveHabit.weeklySchedule)
      ..monthlySchedule = List.from(hiveHabit.monthlySchedule)
      ..reminderTime = hiveHabit.reminderTime
      ..difficulty = _convertDifficulty(hiveHabit.difficulty)
      ..selectedWeekdays = List.from(hiveHabit.selectedWeekdays)
      ..selectedMonthDays = List.from(hiveHabit.selectedMonthDays)
      ..hourlyTimes = List.from(hiveHabit.hourlyTimes)
      ..selectedYearlyDates = List.from(hiveHabit.selectedYearlyDates)
      ..singleDateTime = hiveHabit.singleDateTime
      ..alarmEnabled = hiveHabit.alarmEnabled
      ..alarmSoundName = hiveHabit.alarmSoundName
      ..alarmSoundUri = hiveHabit.alarmSoundUri
      ..snoozeDelayMinutes = hiveHabit.snoozeDelayMinutes
      ..rruleString = hiveHabit.rruleString
      ..dtStart = hiveHabit.dtStart
      ..usesRRule = hiveHabit.usesRRule;
  }
  
  static isar_model.HabitFrequency _convertFrequency(
    hive_model.HabitFrequency freq,
  ) {
    return isar_model.HabitFrequency.values.firstWhere(
      (e) => e.name == freq.name,
    );
  }
  
  static isar_model.HabitDifficulty _convertDifficulty(
    hive_model.HabitDifficulty diff,
  ) {
    return isar_model.HabitDifficulty.values.firstWhere(
      (e) => e.name == diff.name,
    );
  }
}

class MigrationResult {
  final bool success;
  final int migratedCount;
  final int totalCount;
  final List<String> errors;
  
  MigrationResult({
    required this.success,
    required this.migratedCount,
    required this.totalCount,
    required this.errors,
  });
  
  @override
  String toString() {
    return 'MigrationResult(success: $success, migrated: $migratedCount/$totalCount, errors: ${errors.length})';
  }
}
```

---

## Step 6: Create Isar Database Service

Create `lib/data/database_isar.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/model/habit_isar.dart';
import '../services/logging_service.dart';

// Provider for Isar instance
final isarProvider = FutureProvider<Isar>((ref) async {
  return await IsarDatabaseService.getInstance();
});

// Provider for HabitService
final habitServiceIsarProvider = FutureProvider<HabitServiceIsar>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return HabitServiceIsar(isar);
});

// Stream provider for reactive habit updates
final habitsStreamIsarProvider = StreamProvider.autoDispose<List<Habit>>((ref) {
  return Stream<List<Habit>>.multi((controller) async {
    try {
      final habitService = await ref.watch(habitServiceIsarProvider.future);
      
      // Listen to Isar's watch stream for real-time updates
      final subscription = habitService.watchAllHabits().listen(
        (habits) {
          AppLogger.info('🔔 Isar: Emitting ${habits.length} habits');
          controller.add(habits);
        },
        onError: (error) {
          AppLogger.error('Error in Isar habits stream: $error');
          controller.addError(error);
        },
      );
      
      ref.onDispose(() {
        subscription.cancel();
      });
      
      await controller.done;
    } catch (e) {
      AppLogger.error('Error in habitsStreamIsarProvider: $e');
      controller.addError(e);
    }
  });
});

class IsarDatabaseService {
  static Isar? _isar;
  
  /// Get Isar instance (singleton pattern)
  static Future<Isar> getInstance() async {
    if (_isar != null && _isar!.isOpen) {
      return _isar!;
    }
    
    final dir = await getApplicationDocumentsDirectory();
    
    _isar = await Isar.open(
      [HabitSchema],
      directory: dir.path,
      name: 'habitv8_db',
      inspector: true, // Enable Isar Inspector for debugging
    );
    
    AppLogger.info('✅ Isar database initialized at: ${dir.path}');
    return _isar!;
  }
  
  /// Close Isar instance
  static Future<void> closeDatabase() async {
    if (_isar != null && _isar!.isOpen) {
      await _isar!.close();
      _isar = null;
      AppLogger.info('✅ Isar database closed');
    }
  }
  
  /// Reset database (delete all data)
  static Future<void> resetDatabase() async {
    if (_isar != null && _isar!.isOpen) {
      await _isar!.writeTxn(() async {
        await _isar!.clear();
      });
      AppLogger.info('✅ Isar database reset completed');
    }
  }
}

class HabitServiceIsar {
  final Isar _isar;
  
  HabitServiceIsar(this._isar);
  
  /// Get all habits
  Future<List<Habit>> getAllHabits() async {
    return await _isar.habits.where().findAll();
  }
  
  /// Get active habits only
  Future<List<Habit>> getActiveHabits() async {
    return await _isar.habits
        .filter()
        .isActiveEqualTo(true)
        .findAll();
  }
  
  /// Get habit by ID
  Future<Habit?> getHabitById(String habitId) async {
    return await _isar.habits
        .filter()
        .habitIdEqualTo(habitId)
        .findFirst();
  }
  
  /// Add new habit
  Future<void> addHabit(Habit habit) async {
    await _isar.writeTxn(() async {
      await _isar.habits.put(habit);
    });
    AppLogger.info('✅ Habit added: ${habit.name}');
  }
  
  /// Update existing habit
  Future<void> updateHabit(Habit habit) async {
    await _isar.writeTxn(() async {
      await _isar.habits.put(habit);
    });
    AppLogger.info('✅ Habit updated: ${habit.name}');
  }
  
  /// Delete habit
  Future<void> deleteHabit(String habitId) async {
    await _isar.writeTxn(() async {
      final habit = await _isar.habits
          .filter()
          .habitIdEqualTo(habitId)
          .findFirst();
      
      if (habit != null) {
        await _isar.habits.delete(habit.id);
        AppLogger.info('✅ Habit deleted: ${habit.name}');
      }
    });
  }
  
  /// Mark habit as complete
  Future<void> completeHabit(String habitId, DateTime completionTime) async {
    await _isar.writeTxn(() async {
      final habit = await _isar.habits
          .filter()
          .habitIdEqualTo(habitId)
          .findFirst();
      
      if (habit != null) {
        habit.completions.add(completionTime);
        await _isar.habits.put(habit);
        AppLogger.info('✅ Habit completed: ${habit.name}');
      }
    });
  }
  
  /// Watch all habits (reactive stream)
  Stream<List<Habit>> watchAllHabits() {
    return _isar.habits.where().watch(fireImmediately: true);
  }
  
  /// Watch specific habit (reactive stream)
  Stream<Habit?> watchHabit(String habitId) {
    return _isar.habits
        .filter()
        .habitIdEqualTo(habitId)
        .watch(fireImmediately: true)
        .map((habits) => habits.isNotEmpty ? habits.first : null);
  }
}
```

---

## Step 7: Test Migration Locally

Create a test file: `test/data/migration/hive_to_isar_migrator_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:isar/isar.dart';
import 'package:habitv8/domain/model/habit.dart' as hive_model;
import 'package:habitv8/domain/model/habit_isar.dart' as isar_model;
import 'package:habitv8/data/migration/hive_to_isar_migrator.dart';

void main() {
  group('HiveToIsarMigrator', () {
    test('converts Hive habit to Isar habit correctly', () async {
      // Create test Hive habit
      final hiveHabit = hive_model.Habit.create(
        name: 'Test Habit',
        category: 'Health',
        colorValue: 0xFF0000FF,
        frequency: hive_model.HabitFrequency.daily,
      );
      
      // TODO: Add migration test logic
      
      expect(true, true); // Placeholder
    });
  });
}
```

Run tests:
```powershell
flutter test test/data/migration/
```

---

## Step 8: Commit Your Progress

```powershell
# Stage changes
git add .

# Commit
git commit -m "feat: Add Isar dependencies and initial migration setup

- Add Isar and Isar generator dependencies
- Create Isar-based Habit model
- Create HiveToIsarMigrator utility
- Create IsarDatabaseService
- Add migration tests

Part of: feature/isar-migration
Ref: ISAR_MIGRATION_PLAN.md Phase 1-2"

# Push to remote
git push origin feature/isar-migration
```

---

## Next Steps

After completing these steps, you're ready for:

1. **Phase 3**: Migrate database service layer
2. **Phase 4**: Update notification system
3. **Phase 5**: Update UI layer
4. **Phase 6**: Implement one-time migration
5. **Phase 7**: Cleanup and documentation

Refer to `ISAR_MIGRATION_PLAN.md` for detailed instructions on each phase.

---

## Troubleshooting

### Issue: Build runner fails

```powershell
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Isar schema not generated

Check that:
- `part 'habit_isar.g.dart';` is present in model file
- `@collection` annotation is on the class
- All fields are supported Isar types

### Issue: Migration test fails

Ensure:
- Both Hive and Isar are properly initialized
- Test database paths are different
- Cleanup happens after each test

---

## Getting Help

- **Isar Documentation**: https://isar.dev/
- **Isar Discord**: https://discord.gg/X9jF3Xd
- **Migration Plan**: See `ISAR_MIGRATION_PLAN.md`
- **Comparison**: See `HIVE_VS_ISAR_COMPARISON.md`

---

## Checklist: Phase 1-2 Complete

- [ ] Git branch created
- [ ] Database backed up
- [ ] Dependencies updated
- [ ] Isar model created
- [ ] Schema generated successfully
- [ ] Migration utility created
- [ ] Database service created
- [ ] Tests written
- [ ] Changes committed

Once all items are checked, you're ready for Phase 3!

---

**Document Version**: 1.0  
**Last Updated**: 2024  
**Status**: Quick Start Guide