The complete and possibly snooze functions on the habit notification shade is not working , habits are not marked. 

Since updating the creation page Alarms are no longer selectable, please examine the v1 creation screen and reimplement them into the v2 screen. The same is also true of habit suggestions they are missing and need to be reimplemented and possibly updated to use rrule where needed.

Sometimes when selecting advanced mode this error occurs...'package:flutter/src/

material/dropdown.dart': Failed assertion: line 1796 pos 10: 'items == null ||

items.isEmpty || (initialValue ==

.where((

null && value == null) || items

DropdownMenuItem<T> item) => item.value == (initialValue ?? value))

.length

1': There

should be exactly one item with [DropdownButton]'s value: HabitFrequency.single.

Either zero or 2 or more [DropdownMenuItem]s were detected with the same value See also: https:// docs.flutter.dev/testing/