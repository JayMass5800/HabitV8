import 'package:isar/isar.dart';

part 'archived_habit.g.dart';

/// Model for storing archived habit completion data
/// When a habit is deleted with the "Keep completion data" option,
/// its completion history is preserved in this collection for analytics
/// and future reference.
@collection
class ArchivedHabit {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id; // Original habit ID

  late String name; // Habit name at time of deletion

  String? description;

  late String category;

  late int colorValue;

  late DateTime createdAt; // When habit was originally created

  late DateTime archivedAt; // When habit was archived/deleted

  // Completion history preserved from the original habit
  List<DateTime> completions = [];

  // Metadata at time of archival
  int finalCurrentStreak = 0;
  int finalLongestStreak = 0;

  // RRule information for reference
  String? rruleString;
  DateTime? dtStart;
  bool usedRRule = false;

  /// Named constructor for creating archived habits from existing habits
  static ArchivedHabit fromHabit({
    required String id,
    required String name,
    String? description,
    required String category,
    required int colorValue,
    required DateTime createdAt,
    required List<DateTime> completions,
    required int currentStreak,
    required int longestStreak,
    String? rruleString,
    DateTime? dtStart,
    bool usedRRule = false,
  }) {
    return ArchivedHabit()
      ..id = id
      ..name = name
      ..description = description
      ..category = category
      ..colorValue = colorValue
      ..createdAt = createdAt
      ..archivedAt = DateTime.now()
      ..completions = List<DateTime>.from(completions)
      ..finalCurrentStreak = currentStreak
      ..finalLongestStreak = longestStreak
      ..rruleString = rruleString
      ..dtStart = dtStart
      ..usedRRule = usedRRule;
  }

  /// Get total completion count
  int get totalCompletions => completions.length;

  /// Get date range of completions
  @ignore
  DateRange? get completionDateRange {
    if (completions.isEmpty) return null;
    final sorted = List<DateTime>.from(completions)..sort();
    return DateRange(first: sorted.first, last: sorted.last);
  }

  /// Check if archived habit has any completions
  bool get hasCompletions => completions.isNotEmpty;

  /// Convert to JSON for export
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'colorValue': colorValue,
      'createdAt': createdAt.toIso8601String(),
      'archivedAt': archivedAt.toIso8601String(),
      'completions': completions.map((dt) => dt.toIso8601String()).toList(),
      'finalCurrentStreak': finalCurrentStreak,
      'finalLongestStreak': finalLongestStreak,
      'rruleString': rruleString,
      'dtStart': dtStart?.toIso8601String(),
      'usedRRule': usedRRule,
    };
  }

  /// Create from JSON for import
  static ArchivedHabit fromJson(Map<String, dynamic> json) {
    return ArchivedHabit()
      ..id = json['id'] as String
      ..name = json['name'] as String
      ..description = json['description'] as String?
      ..category = json['category'] as String
      ..colorValue = json['colorValue'] as int
      ..createdAt = DateTime.parse(json['createdAt'] as String)
      ..archivedAt = DateTime.parse(json['archivedAt'] as String)
      ..completions = (json['completions'] as List)
          .map((dt) => DateTime.parse(dt as String))
          .toList()
      ..finalCurrentStreak = json['finalCurrentStreak'] as int
      ..finalLongestStreak = json['finalLongestStreak'] as int
      ..rruleString = json['rruleString'] as String?
      ..dtStart = json['dtStart'] != null
          ? DateTime.parse(json['dtStart'] as String)
          : null
      ..usedRRule = json['usedRRule'] as bool;
  }
}

/// Helper class for date range
class DateRange {
  final DateTime first;
  final DateTime last;

  DateRange({required this.first, required this.last});

  Duration get duration => last.difference(first);
}
