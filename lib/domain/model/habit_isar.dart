import 'package:isar/isar.dart';

part 'habit_isar.g.dart';

@collection
class Habit {
  Id id = Isar.autoIncrement; // Auto-incrementing ID
  
  @Index(unique: true)
  late String habitId; // Keep string ID for compatibility
  
  late String name;
  
  String? description;
  
  late String category;
  
  late int colorValue;
  
  late DateTime createdAt;
  
  DateTime? nextDueDate;
  
  @Enumerated(EnumType.name)
  late HabitFrequency frequency;
  
  late int targetCount;
  
  // Isar supports List<DateTime> natively!
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

  // Convert habit to JSON for export
  Map<String, dynamic> toJson() {
    return {
      'habitId': habitId,
      'name': name,
      'description': description,
      'category': category,
      'colorValue': colorValue,
      'createdAt': createdAt.toIso8601String(),
      'nextDueDate': nextDueDate?.toIso8601String(),
      'frequency': frequency.name,
      'targetCount': targetCount,
      'completions': completions.map((date) => date.toIso8601String()).toList(),
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'isActive': isActive,
      'notificationsEnabled': notificationsEnabled,
      'notificationTime': notificationTime?.toIso8601String(),
      'weeklySchedule': weeklySchedule,
      'monthlySchedule': monthlySchedule,
      'reminderTime': reminderTime?.toIso8601String(),
      'difficulty': difficulty.name,
      'selectedWeekdays': selectedWeekdays,
      'selectedMonthDays': selectedMonthDays,
      'hourlyTimes': hourlyTimes,
      'selectedYearlyDates': selectedYearlyDates,
      'singleDateTime': singleDateTime?.toIso8601String(),
      'alarmEnabled': alarmEnabled,
      'alarmSoundName': alarmSoundName,
      'alarmSoundUri': alarmSoundUri,
      'snoozeDelayMinutes': snoozeDelayMinutes,
      'rruleString': rruleString,
      'dtStart': dtStart?.toIso8601String(),
      'usesRRule': usesRRule,
    };
  }

  // Create from JSON (for import)
  static Habit fromJson(Map<String, dynamic> json) {
    return Habit()
      ..habitId = json['habitId'] as String? ?? json['id'] as String
      ..name = json['name'] as String
      ..description = json['description'] as String?
      ..category = json['category'] as String
      ..colorValue = json['colorValue'] as int
      ..createdAt = DateTime.parse(json['createdAt'] as String)
      ..nextDueDate = json['nextDueDate'] != null
          ? DateTime.parse(json['nextDueDate'] as String)
          : null
      ..frequency = HabitFrequency.values.firstWhere(
        (e) => e.name == json['frequency'],
      )
      ..targetCount = json['targetCount'] as int
      ..completions = (json['completions'] as List<dynamic>)
          .map((e) => DateTime.parse(e as String))
          .toList()
      ..currentStreak = json['currentStreak'] as int
      ..longestStreak = json['longestStreak'] as int
      ..isActive = json['isActive'] as bool
      ..notificationsEnabled = json['notificationsEnabled'] as bool
      ..notificationTime = json['notificationTime'] != null
          ? DateTime.parse(json['notificationTime'] as String)
          : null
      ..weeklySchedule = (json['weeklySchedule'] as List<dynamic>)
          .map((e) => e as int)
          .toList()
      ..monthlySchedule = (json['monthlySchedule'] as List<dynamic>)
          .map((e) => e as int)
          .toList()
      ..reminderTime = json['reminderTime'] != null
          ? DateTime.parse(json['reminderTime'] as String)
          : null
      ..difficulty = HabitDifficulty.values.firstWhere(
        (e) => e.name == json['difficulty'],
      )
      ..selectedWeekdays = (json['selectedWeekdays'] as List<dynamic>)
          .map((e) => e as int)
          .toList()
      ..selectedMonthDays = (json['selectedMonthDays'] as List<dynamic>)
          .map((e) => e as int)
          .toList()
      ..hourlyTimes = (json['hourlyTimes'] as List<dynamic>)
          .map((e) => e as String)
          .toList()
      ..selectedYearlyDates = (json['selectedYearlyDates'] as List<dynamic>)
          .map((e) => e as String)
          .toList()
      ..singleDateTime = json['singleDateTime'] != null
          ? DateTime.parse(json['singleDateTime'] as String)
          : null
      ..alarmEnabled = json['alarmEnabled'] as bool? ?? false
      ..alarmSoundName = json['alarmSoundName'] as String?
      ..alarmSoundUri = json['alarmSoundUri'] as String?
      ..snoozeDelayMinutes = json['snoozeDelayMinutes'] as int? ?? 10
      ..rruleString = json['rruleString'] as String?
      ..dtStart = json['dtStart'] != null
          ? DateTime.parse(json['dtStart'] as String)
          : null
      ..usesRRule = json['usesRRule'] as bool? ?? false;
  }
}

// Enums remain the same
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
