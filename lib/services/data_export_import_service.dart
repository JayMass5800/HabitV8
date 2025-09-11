import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../domain/model/habit.dart';
import '../data/database.dart';
import 'logging_service.dart';

class DataExportImportService {
  static const String _exportVersion = '1.0.0';

  /// Export data in JSON format with user-selected save location
  static Future<ExportResult> exportToJSON(List<Habit> habits) async {
    try {
      AppLogger.info('Starting JSON export for ${habits.length} habits');

      // Request storage permission
      if (!await _requestStoragePermission()) {
        return ExportResult(
          success: false,
          message:
              'Storage permission is required to export files. Please grant permission in your device settings if the permission dialog didn\'t appear.',
        );
      }

      final exportData = {
        'version': _exportVersion,
        'exportedAt': DateTime.now().toIso8601String(),
        'totalHabits': habits.length,
        'habits': habits.map((habit) => habit.toJson()).toList(),
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);

      // Let user choose save location
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'habitv8_export_$timestamp.json';

      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save HabitV8 Export File',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes: utf8.encode(jsonString),
      );

      if (result == null) {
        AppLogger.info('User cancelled file save');
        return ExportResult(
          success: false,
          message: 'Export cancelled by user',
          cancelled: true,
        );
      }

      AppLogger.info('JSON export completed: $result');
      return ExportResult(
        success: true,
        filePath: result,
        message: 'JSON export completed successfully',
      );
    } catch (e) {
      AppLogger.error('Error exporting to JSON', e);
      return ExportResult(
        success: false,
        message: 'Error exporting to JSON: ${e.toString()}',
      );
    }
  }

  /// Export data in CSV format
  static Future<ExportResult> exportToCSV(List<Habit> habits) async {
    try {
      AppLogger.info('Starting CSV export for ${habits.length} habits');

      // Request storage permission
      if (!await _requestStoragePermission()) {
        return ExportResult(
          success: false,
          message:
              'Storage permission is required to export files. Please grant permission in your device settings if the permission dialog didn\'t appear.',
        );
      }

      final csvData = <List<String>>[];

      // CSV Headers
      csvData.add([
        'ID',
        'Name',
        'Description',
        'Category',
        'Color',
        'Created At',
        'Frequency',
        'Target Count',
        'Current Streak',
        'Longest Streak',
        'Is Active',
        'Notifications Enabled',
        'Notification Time',
        'Reminder Time',
        'Difficulty',
        'Total Completions',
        'Last Completion',
        'Completion Rate (%)',
        'Selected Weekdays',
        'Selected Month Days',
        'Hourly Times',
        'Yearly Dates',
        'Alarm Enabled',
        'Alarm Sound',
        'Snooze Delay (min)',
      ]);

      // Add habit data rows
      for (final habit in habits) {
        final completionRate = habit.completions.isEmpty
            ? 0.0
            : (habit.completions.length /
                DateTime.now()
                    .difference(habit.createdAt)
                    .inDays
                    .clamp(1, double.infinity) *
                100);

        csvData.add([
          habit.id,
          habit.name,
          habit.description ?? '',
          habit.category,
          habit.colorValue.toString(),
          habit.createdAt.toIso8601String(),
          habit.frequency.toString().split('.').last,
          habit.targetCount.toString(),
          habit.currentStreak.toString(),
          habit.longestStreak.toString(),
          habit.isActive.toString(),
          habit.notificationsEnabled.toString(),
          habit.notificationTime?.toIso8601String() ?? '',
          habit.reminderTime?.toIso8601String() ?? '',
          habit.difficulty.toString().split('.').last,
          habit.completions.length.toString(),
          habit.completions.isEmpty
              ? ''
              : habit.completions.last.toIso8601String(),
          completionRate.toStringAsFixed(2),
          habit.selectedWeekdays.join(';'),
          habit.selectedMonthDays.join(';'),
          habit.hourlyTimes.join(';'),
          habit.selectedYearlyDates.join(';'),
          habit.alarmEnabled.toString(),
          habit.alarmSoundName ?? '',
          habit.snoozeDelayMinutes.toString(),
        ]);
      }

      final csv = const ListToCsvConverter().convert(csvData);

      // Let user choose save location
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'habitv8_export_$timestamp.csv';

      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save HabitV8 Export File',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['csv'],
        bytes: utf8.encode(csv),
      );

      if (result == null) {
        AppLogger.info('User cancelled file save');
        return ExportResult(
          success: false,
          message: 'Export cancelled by user',
          cancelled: true,
        );
      }

      AppLogger.info('CSV export completed: $result');
      return ExportResult(
        success: true,
        filePath: result,
        message: 'CSV export completed successfully',
      );
    } catch (e) {
      AppLogger.error('Error exporting to CSV', e);
      return ExportResult(
        success: false,
        message: 'Error exporting to CSV: ${e.toString()}',
      );
    }
  }

  /// Share exported file
  static Future<bool> shareFile(String filePath, String fileType) async {
    try {
      AppLogger.info('Starting file share process: $filePath');

      final file = File(filePath);
      if (!await file.exists()) {
        AppLogger.error('Export file not found: $filePath');
        return false;
      }

      final fileName = filePath.split('/').last;

      // Add a small delay to ensure any navigation operations have completed
      await Future.delayed(const Duration(milliseconds: 100));

      final result = await Share.shareXFiles(
        [XFile(filePath)],
        subject: 'HabitV8 Data Export ($fileType)',
        text: 'Here is my habit tracking data exported from HabitV8 in $fileType format.',
      );

      final success = result.status == ShareResultStatus.success;
      AppLogger.info('File shared with result: ${result.status} - $fileName');
      return success;
    } catch (e) {
      AppLogger.error('Error sharing file', e);
      return false;
    }
  }

  /// Import data from JSON file
  static Future<ImportResult> importFromJSON() async {
    try {
      AppLogger.info('Starting JSON import process');

      // Pick file directly - no permissions needed for reading via system picker
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
        dialogTitle: 'Select HabitV8 JSON Export File',
      );

      if (result == null || result.files.isEmpty) {
        AppLogger.info('User cancelled file selection');
        return ImportResult(
          success: false,
          message: 'No file selected',
        );
      }

      final file = result.files.first;
      String jsonString;

      // Use bytes if path is null (web/some platforms)
      if (file.path != null) {
        final fileObj = File(file.path!);
        jsonString = await fileObj.readAsString();
      } else if (file.bytes != null) {
        jsonString = utf8.decode(file.bytes!);
      } else {
        return ImportResult(
          success: false,
          message: 'Unable to read file content',
        );
      }
      final jsonData = jsonDecode(jsonString);

      // Validate JSON structure
      if (!_isValidExportData(jsonData)) {
        return ImportResult(
          success: false,
          message: 'Invalid export file format',
        );
      }

      final habitsData = jsonData['habits'] as List;
      final importedHabits = <Habit>[];

      for (final habitData in habitsData) {
        try {
          final habit = _createHabitFromJson(habitData);
          importedHabits.add(habit);
        } catch (e) {
          AppLogger.error('Error importing individual habit: $habitData', e);
        }
      }

      if (importedHabits.isEmpty) {
        return ImportResult(
          success: false,
          message: 'No valid habits found in the file',
        );
      }

      // Save imported habits to database
      final habitService =
          await DatabaseService.getInstance().then((box) => HabitService(box));
      int duplicateCount = 0;
      int importedCount = 0;

      for (final habit in importedHabits) {
        final existingHabits = await habitService.getAllHabits();
        final isDuplicate = existingHabits.any((existing) =>
            existing.name == habit.name && existing.category == habit.category);

        if (isDuplicate) {
          duplicateCount++;
        } else {
          // Generate new ID to avoid conflicts
          habit.id = '${DateTime.now().millisecondsSinceEpoch}_$importedCount';
          await habitService.addHabit(habit);
          importedCount++;
        }
      }

      AppLogger.info(
          'Import completed: $importedCount imported, $duplicateCount duplicates skipped');

      return ImportResult(
        success: true,
        message:
            'Successfully imported $importedCount habits${duplicateCount > 0 ? ' ($duplicateCount duplicates skipped)' : ''}',
        importedCount: importedCount,
        duplicateCount: duplicateCount,
      );
    } catch (e) {
      AppLogger.error('Error during JSON import', e);
      return ImportResult(
        success: false,
        message: 'Error importing data: ${e.toString()}',
      );
    }
  }

  /// Import data from CSV file
  static Future<ImportResult> importFromCSV() async {
    try {
      AppLogger.info('Starting CSV import process');

      // Pick file directly - no permissions needed for reading via system picker
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
        dialogTitle: 'Select HabitV8 CSV Export File',
      );

      if (result == null || result.files.isEmpty) {
        AppLogger.info('User cancelled file selection');
        return ImportResult(
          success: false,
          message: 'No file selected',
        );
      }

      final file = result.files.first;
      String csvString;

      // Use bytes if path is null (web/some platforms)
      if (file.path != null) {
        final fileObj = File(file.path!);
        csvString = await fileObj.readAsString();
      } else if (file.bytes != null) {
        csvString = utf8.decode(file.bytes!);
      } else {
        return ImportResult(
          success: false,
          message: 'Unable to read file content',
        );
      }
      final csvData = const CsvToListConverter().convert(csvString);

      if (csvData.length < 2) {
        return ImportResult(
          success: false,
          message: 'CSV file must contain headers and at least one habit',
        );
      }

      final headers = csvData.first.map((e) => e.toString()).toList();
      final importedHabits = <Habit>[];

      for (int i = 1; i < csvData.length; i++) {
        try {
          final row = csvData[i];
          final habit = _createHabitFromCsvRow(headers, row);
          importedHabits.add(habit);
        } catch (e) {
          AppLogger.error('Error importing CSV row $i: ${csvData[i]}', e);
        }
      }

      if (importedHabits.isEmpty) {
        return ImportResult(
          success: false,
          message: 'No valid habits found in the CSV file',
        );
      }

      // Save imported habits to database
      final habitService =
          await DatabaseService.getInstance().then((box) => HabitService(box));
      int duplicateCount = 0;
      int importedCount = 0;

      for (final habit in importedHabits) {
        final existingHabits = await habitService.getAllHabits();
        final isDuplicate = existingHabits.any((existing) =>
            existing.name == habit.name && existing.category == habit.category);

        if (isDuplicate) {
          duplicateCount++;
        } else {
          // Generate new ID to avoid conflicts
          habit.id = '${DateTime.now().millisecondsSinceEpoch}_$importedCount';
          await habitService.addHabit(habit);
          importedCount++;
        }
      }

      AppLogger.info(
          'CSV import completed: $importedCount imported, $duplicateCount duplicates skipped');

      return ImportResult(
        success: true,
        message:
            'Successfully imported $importedCount habits${duplicateCount > 0 ? ' ($duplicateCount duplicates skipped)' : ''}',
        importedCount: importedCount,
        duplicateCount: duplicateCount,
      );
    } catch (e) {
      AppLogger.error('Error during CSV import', e);
      return ImportResult(
        success: false,
        message: 'Error importing CSV data: ${e.toString()}',
      );
    }
  }

  /// Request storage permission for file operations
  static Future<bool> _requestStoragePermission() async {
    try {
      if (Platform.isAndroid) {
        // For Android 13+ (API 33+), we need different permissions
        final androidVersion = await _getAndroidApiLevel();

        if (androidVersion >= 33) {
          // Android 13+: Check if we already have permission
          final photosStatus = await Permission.photos.status;
          final videosStatus = await Permission.videos.status;

          if (photosStatus.isGranted && videosStatus.isGranted) {
            return true;
          }

          // Try to get manage external storage permission first (more comprehensive)
          final manageResult = await Permission.manageExternalStorage.request();
          if (manageResult.isGranted) {
            return true;
          }

          // Fallback to media permissions
          final mediaResults = await [
            Permission.photos,
            Permission.videos,
          ].request();

          return mediaResults.values.any((status) => status.isGranted);
        } else {
          // Android 12 and below
          final status = await Permission.manageExternalStorage.status;
          if (status.isGranted) return true;

          final result = await Permission.manageExternalStorage.request();
          if (result.isGranted) return true;

          // Fallback to basic storage permission
          final storageStatus = await Permission.storage.status;
          if (storageStatus.isGranted) return true;

          final storageResult = await Permission.storage.request();
          return storageResult.isGranted;
        }
      }
      return true; // iOS handles permissions differently
    } catch (e) {
      AppLogger.error('Error requesting storage permission', e);
      return false;
    }
  }

  /// Get Android API level for permission compatibility
  static Future<int> _getAndroidApiLevel() async {
    try {
      // This is a simplified version - in a real app you might use device_info_plus
      return 34; // Assume modern Android for better compatibility
    } catch (e) {
      return 34; // Default to modern Android
    }
  }

  /// Validate export data structure
  static bool _isValidExportData(dynamic data) {
    if (data is! Map<String, dynamic>) return false;

    return data.containsKey('version') &&
        data.containsKey('habits') &&
        data['habits'] is List;
  }

  /// Create Habit object from JSON data
  static Habit _createHabitFromJson(Map<String, dynamic> json) {
    final habit = Habit();

    habit.name = json['name'] as String;
    habit.description = json['description'] as String?;
    habit.category = json['category'] as String;
    habit.colorValue = json['colorValue'] as int;
    habit.createdAt = DateTime.parse(json['createdAt'] as String);

    // Parse frequency
    final frequencyStr = json['frequency'] as String;
    habit.frequency = HabitFrequency.values.firstWhere(
      (freq) => freq.toString().split('.').last == frequencyStr,
      orElse: () => HabitFrequency.daily,
    );

    // Parse difficulty
    final difficultyStr = json['difficulty'] as String;
    habit.difficulty = HabitDifficulty.values.firstWhere(
      (diff) => diff.toString().split('.').last == difficultyStr,
      orElse: () => HabitDifficulty.medium,
    );

    habit.targetCount = json['targetCount'] as int;
    habit.currentStreak = json['currentStreak'] as int;
    habit.longestStreak = json['longestStreak'] as int;
    habit.isActive = json['isActive'] as bool;
    habit.notificationsEnabled = json['notificationsEnabled'] as bool;

    // Parse optional DateTime fields
    if (json['notificationTime'] != null) {
      habit.notificationTime =
          DateTime.parse(json['notificationTime'] as String);
    }
    if (json['reminderTime'] != null) {
      habit.reminderTime = DateTime.parse(json['reminderTime'] as String);
    }

    // Parse lists
    habit.completions = (json['completions'] as List?)
            ?.map((e) => DateTime.parse(e as String))
            .toList() ??
        [];
    habit.weeklySchedule = (json['weeklySchedule'] as List?)?.cast<int>() ?? [];
    habit.monthlySchedule =
        (json['monthlySchedule'] as List?)?.cast<int>() ?? [];
    habit.selectedWeekdays =
        (json['selectedWeekdays'] as List?)?.cast<int>() ?? [];
    habit.selectedMonthDays =
        (json['selectedMonthDays'] as List?)?.cast<int>() ?? [];
    habit.hourlyTimes = (json['hourlyTimes'] as List?)?.cast<String>() ?? [];
    habit.selectedYearlyDates =
        (json['selectedYearlyDates'] as List?)?.cast<String>() ?? [];

    // Parse alarm fields
    habit.alarmEnabled = json['alarmEnabled'] as bool? ?? false;
    habit.alarmSoundName = json['alarmSoundName'] as String?;
    habit.snoozeDelayMinutes = json['snoozeDelayMinutes'] as int? ?? 10;

    return habit;
  }

  /// Create Habit object from CSV row
  static Habit _createHabitFromCsvRow(List<String> headers, List<dynamic> row) {
    final habit = Habit();

    for (int i = 0; i < headers.length && i < row.length; i++) {
      final header = headers[i];
      final value = row[i]?.toString() ?? '';

      switch (header) {
        case 'Name':
          habit.name = value;
          break;
        case 'Description':
          habit.description = value.isEmpty ? null : value;
          break;
        case 'Category':
          habit.category = value;
          break;
        case 'Color':
          habit.colorValue = int.tryParse(value) ?? 0xFF2196F3;
          break;
        case 'Created At':
          habit.createdAt =
              value.isEmpty ? DateTime.now() : DateTime.parse(value);
          break;
        case 'Frequency':
          habit.frequency = HabitFrequency.values.firstWhere(
            (freq) => freq.toString().split('.').last == value,
            orElse: () => HabitFrequency.daily,
          );
          break;
        case 'Target Count':
          habit.targetCount = int.tryParse(value) ?? 1;
          break;
        case 'Current Streak':
          habit.currentStreak = int.tryParse(value) ?? 0;
          break;
        case 'Longest Streak':
          habit.longestStreak = int.tryParse(value) ?? 0;
          break;
        case 'Is Active':
          habit.isActive = value.toLowerCase() == 'true';
          break;
        case 'Notifications Enabled':
          habit.notificationsEnabled = value.toLowerCase() == 'true';
          break;
        case 'Notification Time':
          if (value.isNotEmpty) {
            habit.notificationTime = DateTime.parse(value);
          }
          break;
        case 'Reminder Time':
          if (value.isNotEmpty) {
            habit.reminderTime = DateTime.parse(value);
          }
          break;
        case 'Difficulty':
          habit.difficulty = HabitDifficulty.values.firstWhere(
            (diff) => diff.toString().split('.').last == value,
            orElse: () => HabitDifficulty.medium,
          );
          break;
        case 'Selected Weekdays':
          habit.selectedWeekdays = value.isEmpty
              ? []
              : value.split(';').map((e) => int.tryParse(e) ?? 0).toList();
          break;
        case 'Selected Month Days':
          habit.selectedMonthDays = value.isEmpty
              ? []
              : value.split(';').map((e) => int.tryParse(e) ?? 0).toList();
          break;
        case 'Hourly Times':
          habit.hourlyTimes = value.isEmpty ? [] : value.split(';');
          break;
        case 'Yearly Dates':
          habit.selectedYearlyDates = value.isEmpty ? [] : value.split(';');
          break;
        case 'Alarm Enabled':
          habit.alarmEnabled = value.toLowerCase() == 'true';
          break;
        case 'Alarm Sound':
          habit.alarmSoundName = value.isEmpty ? null : value;
          break;
        case 'Snooze Delay (min)':
          habit.snoozeDelayMinutes = int.tryParse(value) ?? 10;
          break;
      }
    }

    return habit;
  }
}

class ImportResult {
  final bool success;
  final String message;
  final int importedCount;
  final int duplicateCount;

  ImportResult({
    required this.success,
    required this.message,
    this.importedCount = 0,
    this.duplicateCount = 0,
  });
}

class ExportResult {
  final bool success;
  final String message;
  final String? filePath;
  final bool cancelled;

  ExportResult({
    required this.success,
    required this.message,
    this.filePath,
    this.cancelled = false,
  });
}
