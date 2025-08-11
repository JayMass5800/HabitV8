Error: Couldn't resolve the package 'device_calendar' in 'package:device_calendar/device_calendar.dart'.
lib/services/calendar_service.dart:1:8: Error: Not found: 'package:device_calendar/device_calendar.dart'
import 'package:device_calendar/device_calendar.dart';
       ^
lib/services/calendar_service.dart:9:16: Error: Type 'DeviceCalendarPlugin' not found.
  static final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
               ^^^^^^^^^^^^^^^^^^^^
lib/services/calendar_service.dart:155:15: Error: Type 'Event' not found.
  static List<Event> _generateEventsForHabit(Habit habit) {
              ^^^^^
lib/services/calendar_service.dart:183:15: Error: Type 'Event' not found.
  static List<Event> _generateDailyEvents(Habit habit, DateTime start, DateTime end) {
              ^^^^^
lib/services/calendar_service.dart:205:15: Error: Type 'Event' not found.
  static List<Event> _generateWeeklyEvents(Habit habit, DateTime start, DateTime end) {
              ^^^^^
lib/services/calendar_service.dart:230:15: Error: Type 'Event' not found.
  static List<Event> _generateMonthlyEvents(Habit habit, DateTime start, DateTime end) {
              ^^^^^
lib/services/calendar_service.dart:263:15: Error: Type 'Event' not found.
  static List<Event> _generateYearlyEvents(Habit habit, DateTime start, DateTime end) {
              ^^^^^
lib/services/calendar_service.dart:300:10: Error: Type 'Event' not found.
  static Event _createHabitEvent(Habit habit, DateTime dateTime) {
         ^^^^^
lib/services/calendar_service.dart:312:22: Error: Type 'Calendar' not found.
  static Future<List<Calendar>> getAvailableCalendars() async {
                     ^^^^^^^^
lib/services/calendar_service.dart:9:16: Error: 'DeviceCalendarPlugin' isn't a type.
  static final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
               ^^^^^^^^^^^^^^^^^^^^
lib/services/calendar_service.dart:9:61: Error: Method not found: 'DeviceCalendarPlugin'.
  static final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
                                                            ^^^^^^^^^^^^^^^^^^^^
lib/services/calendar_service.dart:124:9: Error: Method not found: 'RetrieveEventsParams'.
        RetrieveEventsParams(startDate: startDate, endDate: endDate),
        ^^^^^^^^^^^^^^^^^^^^
lib/services/calendar_service.dart:156:21: Error: 'Event' isn't a type.
    final events = <Event>[];
                    ^^^^^
lib/services/calendar_service.dart:184:21: Error: 'Event' isn't a type.
    final events = <Event>[];
                    ^^^^^
lib/services/calendar_service.dart:193:19: Error: The getter 'hour' isn't defined for the class 'Object'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'hour'.
        eventTime.hour,
                  ^^^^
lib/services/calendar_service.dart:194:19: Error: The getter 'minute' isn't defined for the class 'Object'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'minute'.
        eventTime.minute,
                  ^^^^^^
lib/services/calendar_service.dart:206:21: Error: 'Event' isn't a type.
    final events = <Event>[];
                    ^^^^^
lib/services/calendar_service.dart:217:21: Error: The getter 'hour' isn't defined for the class 'Object'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'hour'.
          eventTime.hour,
                    ^^^^
lib/services/calendar_service.dart:218:21: Error: The getter 'minute' isn't defined for the class 'Object'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'minute'.
          eventTime.minute,
                    ^^^^^^
lib/services/calendar_service.dart:231:21: Error: 'Event' isn't a type.
    final events = <Event>[];
                    ^^^^^
lib/services/calendar_service.dart:247:25: Error: The getter 'hour' isn't defined for the class 'Object'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'hour'.
              eventTime.hour,
                        ^^^^
lib/services/calendar_service.dart:248:25: Error: The getter 'minute' isn't defined for the class 'Object'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'minute'.
              eventTime.minute,
                        ^^^^^^
lib/services/calendar_service.dart:264:21: Error: 'Event' isn't a type.
    final events = <Event>[];
                    ^^^^^
lib/services/calendar_service.dart:283:27: Error: The getter 'hour' isn't defined for the class 'Object'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'hour'.
                eventTime.hour,
                          ^^^^
lib/services/calendar_service.dart:284:27: Error: The getter 'minute' isn't defined for the class 'Object'.
 - 'Object' is from 'dart:core'.
Try correcting the name to the name of an existing getter, or defining a getter or field named 'minute'.
                eventTime.minute,
                          ^^^^^^
lib/services/calendar_service.dart:305:14: Error: Undefined name 'TZDateTime'.
      start: TZDateTime.from(dateTime, timeZone.local),
             ^^^^^^^^^^
lib/services/calendar_service.dart:306:12: Error: Undefined name 'TZDateTime'.
      end: TZDateTime.from(dateTime.add(const Duration(minutes: 30)), timeZone.local),
           ^^^^^^^^^^
lib/services/calendar_service.dart:301:12: Error: Method not found: 'Event'.
    return Event(
           ^^^^^
Unhandled exception:
FileSystemException(uri=org-dartlang-untranslatable-uri:package%3Adevice_calendar%2Fdevice_calendar.dart; message=StandardFileSystem only supports file:* and data:* URIs)
#0      StandardFileSystem.entityForUri (package:front_end/src/api_prototype/standard_file_system.dart:45)
#1      asFileUri (package:vm/kernel_front_end.dart:984)
#2      writeDepfile (package:vm/kernel_front_end.dart:1147)
<asynchronous suspension>
#3      FrontendCompiler.compile (package:frontend_server/frontend_server.dart:713)
<asynchronous suspension>
#4      starter (package:frontend_server/starter.dart:109)
<asynchronous suspension>
#5      main (file:///C:/b/s/w/ir/x/w/sdk/pkg/frontend_server/bin/frontend_server_starter.dart:13)
<asynchronous suspension>

Target kernel_snapshot_program failed: Exception


FAILURE: Build failed with an exception.
