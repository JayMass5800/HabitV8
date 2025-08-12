lib/services/calendar_renewal_service.dart:117:59: Error: The getter 'isArchived' isn't defined for the class 'Habit'.
 - 'Habit' is from 'package:Habitv8/domain/model/habit.dart' ('lib/domain/model/habit.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'isArchived'.
      final activeHabits = habits.where((habit) => !habit.isArchived).toList();
                                                          ^^^^^^^^^^
lib/services/health_habit_analytics_service.dart:550:59: Error: A value of type 'num' can't be returned from a function with return type 'double'.
    return math.max(0, 1 - (standardDeviation / average)).clamp(0, 1);
                                                          ^
lib/services/health_habit_analytics_service.dart:799:64: Error: The argument type 'num' can't be assigned to the parameter type 'double'.
          relevantData.add((point.value as NumericHealthValue).numericValue);
                                                               ^
lib/services/health_habit_mapping_service.dart:408:55: Error: A value of type 'num' can't be assigned to a variable of type 'double'.
          value = (point.value as NumericHealthValue).numericValue;
                                                      ^
lib/services/health_enhanced_habit_creation_service.dart:56:44: Error: The method 'compareTo' isn't defined for the class 'HabitPriority'.
 - 'HabitPriority' is from 'package:Habitv8/services/health_enhanced_habit_creation_service.dart' ('lib/services/health_enhanced_habit_creation_service.dart').
Try correcting the name to the name of an existing method, or defining a method named 'compareTo'.
        final priorityCompare = b.priority.compareTo(a.priority);
                                           ^^^^^^^^^
lib/services/health_enhanced_habit_creation_service.dart:86:9: Error: No named parameter with the name 'id'.
        id: _generateHabitId(),
        ^^
lib/domain/model/habit.dart:78:3: Context: Found this candidate, but the arguments don't match.
  Habit() {
  ^^^^^
lib/services/health_enhanced_habit_creation_service.dart:641:56: Error: Member not found: '_healthMappings'.
      final defaultMapping = HealthHabitMappingService._healthMappings[healthDataType];
                                                       ^^^^^^^^^^^^^^^
lib/services/health_habit_ui_service.dart:789:28: Error: 'NumericHealthValue' isn't a type.
        if (point.value is NumericHealthValue) {
                           ^^^^^^^^^^^^^^^^^^
lib/services/health_habit_ui_service.dart:793:55: Error: 'NumericHealthValue' isn't a type.
          healthByType[typeName]!.add((point.value as NumericHealthValue).numericValue);
                                                      ^^^^^^^^^^^^^^^^^^
Target kernel_snapshot_program failed: Exception


FAILURE: Build failed with an exception.