Note: C:\Users\James\AppData\Local\Pub\Cache\hosted\pub.dev\flutter_fgbg-0.6.0\android\src\main\java\com\ajinasokan\flutter_fgbg\FlutterFGBGPlugin.java uses or overrides a deprecated API.
Note: Recompile with -Xlint:deprecation for details.
lib/services/notification_service.dart:1086:11: Error: Undefined name 'AlarmService'.
    await AlarmService.initialize();
          ^^^^^^^^^^^^
lib/services/notification_service.dart:1117:13: Error: Undefined name 'AlarmService'.
      await AlarmService.cancelHabitAlarms(habit.id);
            ^^^^^^^^^^^^
lib/services/notification_service.dart:2444:21: Error: Undefined name 'AlarmService'.
    final alarmId = AlarmService.generateHabitAlarmId(
                    ^^^^^^^^^^^^
lib/services/notification_service.dart:2491:23: Error: Undefined name 'AlarmService'.
      final alarmId = AlarmService.generateHabitAlarmId(
                      ^^^^^^^^^^^^
lib/services/notification_service.dart:2548:23: Error: Undefined name 'AlarmService'.
      final alarmId = AlarmService.generateHabitAlarmId(
                      ^^^^^^^^^^^^
lib/services/notification_service.dart:2604:25: Error: Undefined name 'AlarmService'.
        final alarmId = AlarmService.generateHabitAlarmId(
                        ^^^^^^^^^^^^
lib/services/notification_service.dart:2666:27: Error: Undefined name 'AlarmService'.
          final alarmId = AlarmService.generateHabitAlarmId(
                          ^^^^^^^^^^^^
lib/services/notification_service.dart:2706:25: Error: Undefined name 'AlarmService'.
        final alarmId = AlarmService.generateHabitAlarmId(
                        ^^^^^^^^^^^^
lib/services/notification_service.dart:2729:18: Error: Undefined name 'AlarmService'.
    return await AlarmService.getAvailableAlarmSounds();
                 ^^^^^^^^^^^^
lib/services/notification_service.dart:2734:11: Error: Undefined name 'AlarmService'.
    await AlarmService.playAlarmSoundPreview(soundUri);
          ^^^^^^^^^^^^
lib/services/notification_service.dart:2739:11: Error: Undefined name 'AlarmService'.
    await AlarmService.stopAlarmSoundPreview();
          ^^^^^^^^^^^^
lib/ui/screens/settings_screen.dart:592:65: Error: Required named parameter 'groupValue' must be provided.
                  builder: (context) => RadioListTile<ThemeMode>(
                                                                ^
/C:/Users/James/fvm/versions/3.32.8/packages/flutter/lib/src/material/radio_list_tile.dart:174:9: Context: Found this candidate, but the arguments don't match.
  const RadioListTile({
        ^^^^^^^^^^^^^
lib/ui/screens/settings_screen.dart:598:65: Error: Required named parameter 'groupValue' must be provided.
                  builder: (context) => RadioListTile<ThemeMode>(
                                                                ^
/C:/Users/James/fvm/versions/3.32.8/packages/flutter/lib/src/material/radio_list_tile.dart:174:9: Context: Found this candidate, but the arguments don't match.
  const RadioListTile({
        ^^^^^^^^^^^^^
lib/ui/screens/settings_screen.dart:604:65: Error: Required named parameter 'groupValue' must be provided.
                  builder: (context) => RadioListTile<ThemeMode>(
                                                                ^
/C:/Users/James/fvm/versions/3.32.8/packages/flutter/lib/src/material/radio_list_tile.dart:174:9: Context: Found this candidate, but the arguments don't match.
  const RadioListTile({
        ^^^^^^^^^^^^^
lib/ui/screens/create_habit_screen.dart:330:11: Error: No named parameter with the name 'initialValue'.
          initialValue: _selectedCategory,
          ^^^^^^^^^^^^
/C:/Users/James/fvm/versions/3.32.8/packages/flutter/lib/src/material/dropdown.dart:1708:3: Context: Found this candidate, but the arguments don't match.
  DropdownButtonFormField({
  ^^^^^^^^^^^^^^^^^^^^^^^
lib/services/true_alarm_service.dart:311:18: Error: A value of type 'Future<bool>' can't be returned from a function with return type 'bool'.
 - 'Future' is from 'dart:async'.
    return Alarm.isRinging(alarmId);
                 ^
lib/services/true_alarm_service.dart:316:18: Error: A value of type 'Future<List<AlarmSettings>>' can't be returned from a function with return type 'List<AlarmSettings>'.
 - 'Future' is from 'dart:async'.
 - 'List' is from 'dart:core'.
 - 'AlarmSettings' is from 'package:alarm/model/alarm_settings.dart' ('/C:/Users/James/AppData/Local/Pub/Cache/hosted/pub.dev/alarm-4.1.1/lib/model/alarm_settings.dart').
    return Alarm.getAlarms();
                 ^
lib/ui/screens/edit_habit_screen.dart:131:11: Error: No named parameter with the name 'initialValue'.
          initialValue: _selectedCategory,
          ^^^^^^^^^^^^
/C:/Users/James/fvm/versions/3.32.8/packages/flutter/lib/src/material/dropdown.dart:1708:3: Context: Found this candidate, but the arguments don't match.
  DropdownButtonFormField({
  ^^^^^^^^^^^^^^^^^^^^^^^
lib/ui/screens/edit_habit_screen.dart:585:15: Error: No named parameter with the name 'activeThumbColor'.
              activeThumbColor: _selectedColor,
              ^^^^^^^^^^^^^^^^
/C:/Users/James/fvm/versions/3.32.8/packages/flutter/lib/src/material/switch_list_tile.dart:174:9: Context: Found this candidate, but the arguments don't match.
  const SwitchListTile({
        ^^^^^^^^^^^^^^
lib/ui/screens/edit_habit_screen.dart:671:15: Error: No named parameter with the name 'activeThumbColor'.
              activeThumbColor: _selectedColor,
              ^^^^^^^^^^^^^^^^
/C:/Users/James/fvm/versions/3.32.8/packages/flutter/lib/src/material/switch_list_tile.dart:174:9: Context: Found this candidate, but the arguments don't match.
  const SwitchListTile({
        ^^^^^^^^^^^^^^
Target kernel_snapshot_program failed: Exception


FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':app:compileFlutterBuildRelease'.
> Process 'command 'C:\Users\James\fvm\versions\3.32.8\bin\flutter.bat'' finished with non-zero exit value 1