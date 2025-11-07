PS C:\HabitV8> adb logcat | Select-String -Pattern "flutter|AIService|InsightsService|GEMINI|OPENAI"

11-07 11:52:48.973  6245  6299 I ajqd    : #isGeminiDefaultSystemFeatureEnabled: false
11-07 11:52:48.973  6245  6298 I ajqd    : #isGeminiDefaultSystemFeatureEnabled: false
11-07 11:52:55.784  6313  6313 D HabitTimelineService:   - Flutter['flutter.theme_mode']: null
11-07 11:53:00.674  6313  6353 D nativeloader: Load 
/data/app/~~oclg6T29UqVYVWUldLQqcg==/com.habittracker.habitv8-D1vl4ESazaq-1Awm5aJmfQ==/base.apk!/lib/arm64-v8a/libflutter.so using 
class loader ns clns-9 (caller=/data/app/~~oclg6T29UqVYVWUldLQqcg==/com.habittracker.habitv8-D1vl4ESazaq-1Awm5aJmfQ==/base.apk): ok
11-07 11:53:00.703  6313  6355 I flutter : [IMPORTANT:flutter/shell/platform/android/android_context_vk_impeller.cc(62)] Using the 
Impeller rendering backend (Vulkan).
11-07 11:53:01.298  6313  6313 I flutter : ✅ WidgetBackgroundUpdateService initialized
11-07 11:53:01.300  6313  6313 I flutter : ✅ Scheduled periodic widget background updates (every 30 minutes)
11-07 11:53:03.331  6313  6313 I flutter : Old widget preferences and stale fallback keys cleaned up
11-07 11:53:03.331  6313  6313 I flutter : 📱 [2025-11-07T11:53:03.331442] updateAllWidgets() called
11-07 11:53:03.331  6313  6313 I flutter : 📱 Performing immediate widget update...
11-07 11:53:03.343  6313  6313 I flutter : Filtering 8 habits for date 2025-11-07:
11-07 11:53:03.343  6313  6313 I flutter :   - Blood Pressure Med: HabitFrequency.daily -> INCLUDED
11-07 11:53:03.343  6313  6313 I flutter :   - Cholesterol Med: HabitFrequency.daily -> INCLUDED
11-07 11:53:03.343  6313  6313 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 11:53:03.343  6313  6313 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 11:53:03.343  6313  6313 I flutter :   - Vibration Plate: HabitFrequency.daily -> EXCLUDED
11-07 11:53:03.344  6313  6313 I flutter :   - Mandi's Birthday Tomorrow!!: HabitFrequency.daily -> EXCLUDED
11-07 11:53:03.344  6313  6313 I flutter :   - Do one push up: HabitFrequency.daily -> INCLUDED
11-07 11:53:03.344  6313  6313 I flutter :   - Drink Water: HabitFrequency.hourly -> INCLUDED
11-07 11:53:03.344  6313  6313 I flutter : Result: 4 habits for today
11-07 11:53:03.345  6313  6313 I flutter : Widget data preparation: Found 8 total habits, 4 for today
11-07 11:53:03.345  6313  6313 I flutter : 🎨 Getting app theme: ThemeMode.system
11-07 11:53:03.345  6313  6313 I flutter : 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
11-07 11:53:03.345  6313  6313 I flutter : 🎨 Final theme mode to send to widgets: dark
11-07 11:53:03.345  6313  6313 I flutter : 🎨 Using app primary color: 4280391411
11-07 11:53:03.345  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 08:40 for Drink Water: true
11-07 11:53:03.345  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 11:30 for Drink Water: false
11-07 11:53:03.345  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 14:40 for Drink Water: false
11-07 11:53:03.345  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 18:30 for Drink Water: false
11-07 11:53:03.345  6313  6313 I flutter : 🎯 Widget data prepared: 4 habits in list, JSON length: 1050
11-07 11:53:03.345  6313  6313 I flutter : 🎯 Completion status: 2/4 (allComplete: false)
11-07 11:53:03.345  6313  6313 I flutter :   📋 Blood Pressure Med: isCompleted=true
11-07 11:53:03.345  6313  6313 I flutter :   📋 Drink Water (hourly): 1/4 slots, isCompleted=false
11-07 11:53:03.345  6313  6313 I flutter :   📋 Do one push up: isCompleted=true
11-07 11:53:03.345  6313  6313 I flutter :   📋 Cholesterol Med: isCompleted=false
11-07 11:53:03.345  6313  6313 I flutter : 🎯 First 200 chars of habits JSON: [{"id":"1762545112793_0","name":"Blood Pressure Med","c 
ategory":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay":"08:30","frequency":"HabitFrequency.d 
aily"},{"id"
11-07 11:53:03.345  6313  6313 I flutter : 🎯 Theme data: dark, primary: 4280391411
11-07 11:53:03.354  6313  6313 I flutter : Saved widget theme data: dark, color: 4280391411
11-07 11:53:03.354  6313  6313 I flutter : Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit,
selectedDate, themeMode, primaryColor, lastUpdate]
11-07 11:53:03.355  6313  6313 I flutter : ✅ Saved habits: length=1050, preview=[{"id":"1762545112793_0","name":"Blood Pressure      
Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 11:53:03.360  6313  6313 I flutter : ✅ Saved nextHabit: {"id":"1762545112911_1","name":"Cholesterol 
Med","category":"Health","colorValue":4278228616,"isComp...
11-07 11:53:03.361  6313  6313 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 11:53:03.365  6313  6313 I flutter : ✅ Saved themeMode: dark
11-07 11:53:03.366  6313  6313 I flutter : ✅ Saved primaryColor: 4280391411
11-07 11:53:03.371  6313  6313 I flutter : ✅ Saved lastUpdate: 1762545183345
11-07 11:53:03.490  6313  6405 D HabitTimelineService:   - Flutter['flutter.theme_mode']: null
11-07 11:53:03.500  6313  6405 D HabitTimelineService:   - Flutter['flutter.theme_mode']: null
11-07 11:53:03.578  6313  6313 I flutter : Widget HabitTimelineWidgetProvider update completed
11-07 11:53:03.578  6313  6313 I flutter : Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit,
selectedDate, themeMode, primaryColor, lastUpdate]
11-07 11:53:03.580  6313  6313 I flutter : ✅ Saved habits: length=1050, preview=[{"id":"1762545112793_0","name":"Blood Pressure      
Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 11:53:03.580  6313  6313 I flutter : ✅ Saved nextHabit: {"id":"1762545112911_1","name":"Cholesterol
Med","category":"Health","colorValue":4278228616,"isComp...
11-07 11:53:03.582  6313  6313 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 11:53:03.583  6313  6313 I flutter : ✅ Saved themeMode: dark
11-07 11:53:03.583  6313  6313 I flutter : ✅ Saved primaryColor: 4280391411
11-07 11:53:03.584  6313  6313 I flutter : ✅ Saved lastUpdate: 1762545183345
11-07 11:53:03.795  6313  6313 I flutter : Widget HabitCompactWidgetProvider update completed
11-07 11:53:03.795  6313  6313 I flutter : ✅ All widgets updated successfully (debounced)
11-07 11:53:03.795  6313  6313 I flutter : 📱 [2025-11-07T11:53:03.331442] updateAllWidgets() completed
11-07 11:53:03.796  6313  6313 I flutter : ✅ Widget Isar lazy listener initialized (efficient change detection)
11-07 11:53:03.796  6313  6313 I flutter : 🔔 [2025-11-07T11:53:03.796838] Isar lazy listener fired: habit change detected
11-07 11:53:03.796  6313  6313 I flutter : 🔔 Updating widgets via Isar listener...
11-07 11:53:03.796  6313  6313 I flutter : 📱 [2025-11-07T11:53:03.796970] updateAllWidgets() called
11-07 11:53:03.797  6313  6313 I flutter : 📱 Performing immediate widget update...
11-07 11:53:03.799  6313  6313 I flutter : ✅ Hybrid widget updates enabled: Isar listeners + 30-min safety net
11-07 11:53:03.799  6313  6313 I flutter : ✅ Widget integration initialized with Isar listener
11-07 11:53:03.804  6313  6313 I flutter : Filtering 8 habits for date 2025-11-07:
11-07 11:53:03.804  6313  6313 I flutter :   - Blood Pressure Med: HabitFrequency.daily -> INCLUDED
11-07 11:53:03.805  6313  6313 I flutter :   - Cholesterol Med: HabitFrequency.daily -> INCLUDED
11-07 11:53:03.805  6313  6313 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 11:53:03.805  6313  6313 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 11:53:03.805  6313  6313 I flutter :   - Vibration Plate: HabitFrequency.daily -> EXCLUDED
11-07 11:53:03.806  6313  6313 I flutter :   - Mandi's Birthday Tomorrow!!: HabitFrequency.daily -> EXCLUDED
11-07 11:53:03.806  6313  6313 I flutter :   - Do one push up: HabitFrequency.daily -> INCLUDED
11-07 11:53:03.806  6313  6313 I flutter :   - Drink Water: HabitFrequency.hourly -> INCLUDED
11-07 11:53:03.806  6313  6313 I flutter : Result: 4 habits for today
11-07 11:53:03.809  6313  6313 I flutter : Widget data preparation: Found 8 total habits, 4 for today
11-07 11:53:03.809  6313  6313 I flutter : 🎨 Getting app theme: ThemeMode.system
11-07 11:53:03.809  6313  6313 I flutter : 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
11-07 11:53:03.809  6313  6313 I flutter : 🎨 Final theme mode to send to widgets: dark
11-07 11:53:03.809  6313  6313 I flutter : 🎨 Using app primary color: 4280391411
11-07 11:53:03.809  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 08:40 for Drink Water: true
11-07 11:53:03.810  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 11:30 for Drink Water: false
11-07 11:53:03.810  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 14:40 for Drink Water: false
11-07 11:53:03.810  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 18:30 for Drink Water: false
11-07 11:53:03.810  6313  6313 I flutter : 🎯 Widget data prepared: 4 habits in list, JSON length: 1050
11-07 11:53:03.810  6313  6313 I flutter : 🎯 Completion status: 2/4 (allComplete: false)
11-07 11:53:03.810  6313  6313 I flutter :   📋 Blood Pressure Med: isCompleted=true
11-07 11:53:03.810  6313  6313 I flutter :   📋 Drink Water (hourly): 1/4 slots, isCompleted=false
11-07 11:53:03.810  6313  6313 I flutter :   📋 Do one push up: isCompleted=true
11-07 11:53:03.810  6313  6313 I flutter :   📋 Cholesterol Med: isCompleted=false
11-07 11:53:03.810  6313  6313 I flutter : 🎯 First 200 chars of habits JSON: [{"id":"1762545112793_0","name":"Blood Pressure Med","c 
ategory":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay":"08:30","frequency":"HabitFrequency.d 
aily"},{"id"
11-07 11:53:03.810  6313  6313 I flutter : 🎯 Theme data: dark, primary: 4280391411
11-07 11:53:03.813  6313  6313 I flutter : Saved widget theme data: dark, color: 4280391411
11-07 11:53:03.814  6313  6313 I flutter : Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit,
selectedDate, themeMode, primaryColor, lastUpdate]
11-07 11:53:03.815  6313  6313 I flutter : ✅ Saved habits: length=1050, preview=[{"id":"1762545112793_0","name":"Blood Pressure      
Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 11:53:03.815  6313  6313 I flutter : ✅ Saved nextHabit: {"id":"1762545112911_1","name":"Cholesterol
Med","category":"Health","colorValue":4278228616,"isComp...
11-07 11:53:03.815  6313  6313 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 11:53:03.815  6313  6313 I flutter : ✅ Saved themeMode: dark
11-07 11:53:03.815  6313  6313 I flutter : ✅ Saved primaryColor: 4280391411
11-07 11:53:03.818  6313  6313 I flutter : ✅ Saved lastUpdate: 1762545183810
11-07 11:53:03.939  6313  6405 D HabitTimelineService:   - Flutter['flutter.theme_mode']: null
11-07 11:53:04.025  6313  6313 I flutter : Widget HabitTimelineWidgetProvider update completed
11-07 11:53:04.025  6313  6313 I flutter : Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit,
selectedDate, themeMode, primaryColor, lastUpdate]
11-07 11:53:04.027  6313  6313 I flutter : ✅ Saved habits: length=1050, preview=[{"id":"1762545112793_0","name":"Blood Pressure      
Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 11:53:04.028  6313  6313 I flutter : ✅ Saved nextHabit: {"id":"1762545112911_1","name":"Cholesterol
Med","category":"Health","colorValue":4278228616,"isComp...
11-07 11:53:04.028  6313  6313 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 11:53:04.029  6313  6313 I flutter : ✅ Saved themeMode: dark
11-07 11:53:04.029  6313  6313 I flutter : ✅ Saved primaryColor: 4280391411
11-07 11:53:04.030  6313  6313 I flutter : ✅ Saved lastUpdate: 1762545183810
11-07 11:53:04.244  6313  6313 I flutter : Widget HabitCompactWidgetProvider update completed
11-07 11:53:04.244  6313  6313 I flutter : ✅ All widgets updated successfully (debounced)
11-07 11:53:04.244  6313  6313 I flutter : 📱 [2025-11-07T11:53:03.796970] updateAllWidgets() completed
11-07 11:53:04.293  6313  6313 I flutter : 🔄 onHabitsChanged called - updating all widgets
11-07 11:53:04.294  6313  6313 I flutter : 📱 [2025-11-07T11:53:04.294021] updateAllWidgets() called
11-07 11:53:04.294  6313  6313 I flutter : 📱 Performing immediate widget update...
11-07 11:53:04.300  6313  6313 I flutter : Filtering 8 habits for date 2025-11-07:
11-07 11:53:04.301  6313  6313 I flutter :   - Blood Pressure Med: HabitFrequency.daily -> INCLUDED
11-07 11:53:04.302  6313  6313 I flutter :   - Cholesterol Med: HabitFrequency.daily -> INCLUDED
11-07 11:53:04.302  6313  6313 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 11:53:04.302  6313  6313 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 11:53:04.302  6313  6313 I flutter :   - Vibration Plate: HabitFrequency.daily -> EXCLUDED
11-07 11:53:04.302  6313  6313 I flutter :   - Mandi's Birthday Tomorrow!!: HabitFrequency.daily -> EXCLUDED
11-07 11:53:04.302  6313  6313 I flutter :   - Do one push up: HabitFrequency.daily -> INCLUDED
11-07 11:53:04.302  6313  6313 I flutter :   - Drink Water: HabitFrequency.hourly -> INCLUDED
11-07 11:53:04.302  6313  6313 I flutter : Result: 4 habits for today
11-07 11:53:04.304  6313  6313 I flutter : Widget data preparation: Found 8 total habits, 4 for today
11-07 11:53:04.304  6313  6313 I flutter : 🎨 Getting app theme: ThemeMode.system
11-07 11:53:04.304  6313  6313 I flutter : 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
11-07 11:53:04.304  6313  6313 I flutter : 🎨 Final theme mode to send to widgets: dark
11-07 11:53:04.304  6313  6313 I flutter : 🎨 Using app primary color: 4280391411
11-07 11:53:04.304  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 08:40 for Drink Water: true
11-07 11:53:04.304  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 11:30 for Drink Water: false
11-07 11:53:04.304  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 14:40 for Drink Water: false
11-07 11:53:04.304  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 18:30 for Drink Water: false
11-07 11:53:04.305  6313  6313 I flutter : 🎯 Widget data prepared: 4 habits in list, JSON length: 1050
11-07 11:53:04.305  6313  6313 I flutter : 🎯 Completion status: 2/4 (allComplete: false)
11-07 11:53:04.305  6313  6313 I flutter :   📋 Blood Pressure Med: isCompleted=true
11-07 11:53:04.305  6313  6313 I flutter :   📋 Drink Water (hourly): 1/4 slots, isCompleted=false
11-07 11:53:04.305  6313  6313 I flutter :   📋 Do one push up: isCompleted=true
11-07 11:53:04.305  6313  6313 I flutter :   📋 Cholesterol Med: isCompleted=false
11-07 11:53:04.305  6313  6313 I flutter : 🎯 First 200 chars of habits JSON: [{"id":"1762545112793_0","name":"Blood Pressure Med","c 
ategory":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay":"08:30","frequency":"HabitFrequency.d 
aily"},{"id"
11-07 11:53:04.305  6313  6313 I flutter : 🎯 Theme data: dark, primary: 4280391411
11-07 11:53:04.308  6313  6313 I flutter : Saved widget theme data: dark, color: 4280391411
11-07 11:53:04.308  6313  6313 I flutter : Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit,
selectedDate, themeMode, primaryColor, lastUpdate]
11-07 11:53:04.309  6313  6313 I flutter : ✅ Saved habits: length=1050, preview=[{"id":"1762545112793_0","name":"Blood Pressure      
Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 11:53:04.309  6313  6313 I flutter : ✅ Saved nextHabit: {"id":"1762545112911_1","name":"Cholesterol
Med","category":"Health","colorValue":4278228616,"isComp...
11-07 11:53:04.309  6313  6313 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 11:53:04.311  6313  6313 I flutter : ✅ Saved themeMode: dark
11-07 11:53:04.311  6313  6313 I flutter : ✅ Saved primaryColor: 4280391411
11-07 11:53:04.315  6313  6313 I flutter : ✅ Saved lastUpdate: 1762545184305
11-07 11:53:04.443  6313  6405 D HabitTimelineService:   - Flutter['flutter.theme_mode']: null
11-07 11:53:04.448  6313  6313 I flutter : Android widget immediate update triggered
11-07 11:53:04.448  6313  6313 I flutter : 🔔 Widget update completed from Isar listener (data + UI refresh)
11-07 11:53:04.483  6313  6408 D WidgetUpdateWorker: ✅ Updated widget data with 4 today's habits (pre-filtered by Flutter)
11-07 11:53:04.483  6313  6408 D WidgetUpdateWorker: Widget data updated from Flutter preferences
11-07 11:53:04.487  6313  6405 D HabitTimelineService:   - Flutter['flutter.theme_mode']: null
11-07 11:53:04.504  6313  6405 D HabitTimelineService:   - Flutter['flutter.theme_mode']: null
11-07 11:53:04.524  6313  6313 I flutter : Widget HabitTimelineWidgetProvider update completed
11-07 11:53:04.525  6313  6313 I flutter : Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit,
selectedDate, themeMode, primaryColor, lastUpdate]
11-07 11:53:04.527  6313  6313 I flutter : ✅ Saved habits: length=1050, preview=[{"id":"1762545112793_0","name":"Blood Pressure      
Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 11:53:04.528  6313  6313 I flutter : ✅ Saved nextHabit: {"id":"1762545112911_1","name":"Cholesterol
Med","category":"Health","colorValue":4278228616,"isComp...
11-07 11:53:04.529  6313  6313 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 11:53:04.529  6313  6313 I flutter : ✅ Saved themeMode: dark
11-07 11:53:04.530  6313  6313 I flutter : ✅ Saved primaryColor: 4280391411
11-07 11:53:04.530  6313  6313 I flutter : ✅ Saved lastUpdate: 1762545184305
11-07 11:53:04.743  6313  6313 I flutter : Widget HabitCompactWidgetProvider update completed
11-07 11:53:04.743  6313  6313 I flutter : ✅ All widgets updated successfully (debounced)
11-07 11:53:04.743  6313  6313 I flutter : 📱 [2025-11-07T11:53:04.294021] updateAllWidgets() completed
11-07 11:53:04.744  6313  6313 I flutter : Android widget immediate update triggered
11-07 11:53:04.744  6313  6313 I flutter : ✅ Widget update completed after habit changes
11-07 11:53:04.775  6313  6416 D WidgetUpdateWorker: ✅ Updated widget data with 4 today's habits (pre-filtered by Flutter)
11-07 11:53:04.775  6313  6416 D WidgetUpdateWorker: Widget data updated from Flutter preferences
11-07 11:53:04.778  6313  6405 D HabitTimelineService:   - Flutter['flutter.theme_mode']: null
11-07 11:53:04.786  6313  6405 D HabitTimelineService:   - Flutter['flutter.theme_mode']: null
11-07 11:54:30.307  6313  6313 I flutter : 🔄 Re-establishing Isar listener after app resume...
11-07 11:54:30.308  6313  6313 I flutter : ✅ Widget Isar lazy listener initialized (efficient change detection)
11-07 11:54:30.308  6313  6313 I flutter : ✅ Isar listener re-established successfully
11-07 11:54:30.308  6313  6313 I flutter : 🔔 [2025-11-07T11:54:30.308222] Isar lazy listener fired: habit change detected
11-07 11:54:30.308  6313  6313 I flutter : 🔔 Updating widgets via Isar listener...
11-07 11:54:30.308  6313  6313 I flutter : 📱 [2025-11-07T11:54:30.308257] updateAllWidgets() called
11-07 11:54:30.308  6313  6313 I flutter : 📱 Performing immediate widget update...
11-07 11:54:30.313  6313  6313 I flutter : Filtering 8 habits for date 2025-11-07:
11-07 11:54:30.313  6313  6313 I flutter :   - Blood Pressure Med: HabitFrequency.daily -> INCLUDED
11-07 11:54:30.314  6313  6313 I flutter :   - Cholesterol Med: HabitFrequency.daily -> INCLUDED
11-07 11:54:30.314  6313  6313 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 11:54:30.314  6313  6313 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 11:54:30.314  6313  6313 I flutter :   - Vibration Plate: HabitFrequency.daily -> EXCLUDED
11-07 11:54:30.314  6313  6313 I flutter :   - Mandi's Birthday Tomorrow!!: HabitFrequency.daily -> EXCLUDED
11-07 11:54:30.314  6313  6313 I flutter :   - Do one push up: HabitFrequency.daily -> INCLUDED
11-07 11:54:30.314  6313  6313 I flutter :   - Drink Water: HabitFrequency.hourly -> INCLUDED
11-07 11:54:30.314  6313  6313 I flutter : Result: 4 habits for today
11-07 11:54:30.315  6313  6313 I flutter : Widget data preparation: Found 8 total habits, 4 for today
11-07 11:54:30.315  6313  6313 I flutter : 🎨 Getting app theme: ThemeMode.system
11-07 11:54:30.315  6313  6313 I flutter : 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
11-07 11:54:30.315  6313  6313 I flutter : 🎨 Final theme mode to send to widgets: dark
11-07 11:54:30.316  6313  6313 I flutter : 🎨 Using app primary color: 4280391411
11-07 11:54:30.316  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 08:40 for Drink Water: true
11-07 11:54:30.316  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 11:30 for Drink Water: false
11-07 11:54:30.316  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 14:40 for Drink Water: false
11-07 11:54:30.316  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 18:30 for Drink Water: false
11-07 11:54:30.316  6313  6313 I flutter : 🎯 Widget data prepared: 4 habits in list, JSON length: 1050
11-07 11:54:30.316  6313  6313 I flutter : 🎯 Completion status: 2/4 (allComplete: false)
11-07 11:54:30.316  6313  6313 I flutter :   📋 Blood Pressure Med: isCompleted=true
11-07 11:54:30.316  6313  6313 I flutter :   📋 Drink Water (hourly): 1/4 slots, isCompleted=false
11-07 11:54:30.316  6313  6313 I flutter :   📋 Do one push up: isCompleted=true
11-07 11:54:30.316  6313  6313 I flutter :   📋 Cholesterol Med: isCompleted=false
11-07 11:54:30.316  6313  6313 I flutter : 🎯 First 200 chars of habits JSON: [{"id":"1762545112793_0","name":"Blood Pressure Med","c 
ategory":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay":"08:30","frequency":"HabitFrequency.d 
aily"},{"id"
11-07 11:54:30.316  6313  6313 I flutter : 🎯 Theme data: dark, primary: 4280391411
11-07 11:54:30.336  6313  6313 I flutter : Saved widget theme data: dark, color: 4280391411
11-07 11:54:30.336  6313  6313 I flutter : Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit,
selectedDate, themeMode, primaryColor, lastUpdate]
11-07 11:54:30.336  6313  6313 I flutter : ✅ Saved habits: length=1050, preview=[{"id":"1762545112793_0","name":"Blood Pressure      
Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 11:54:30.337  6313  6313 I flutter : ✅ Saved nextHabit: {"id":"1762545112911_1","name":"Cholesterol
Med","category":"Health","colorValue":4278228616,"isComp...
11-07 11:54:30.337  6313  6313 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 11:54:30.337  6313  6313 I flutter : ✅ Saved themeMode: dark
11-07 11:54:30.337  6313  6313 I flutter : ✅ Saved primaryColor: 4280391411
11-07 11:54:30.338  6313  6313 I flutter : ✅ Saved lastUpdate: 1762545270316
11-07 11:54:30.451  6313  6662 D HabitTimelineService:   - Flutter['flutter.theme_mode']: null
11-07 11:54:30.458  6313  6662 D HabitTimelineService:   - Flutter['flutter.theme_mode']: null
11-07 11:54:30.542  6313  6313 I flutter : Widget HabitTimelineWidgetProvider update completed
11-07 11:54:30.542  6313  6313 I flutter : Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, 
selectedDate, themeMode, primaryColor, lastUpdate]
11-07 11:54:30.543  6313  6313 I flutter : ✅ Saved habits: length=1050, preview=[{"id":"1762545112793_0","name":"Blood Pressure      
Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 11:54:30.544  6313  6313 I flutter : ✅ Saved nextHabit: {"id":"1762545112911_1","name":"Cholesterol
Med","category":"Health","colorValue":4278228616,"isComp...
11-07 11:54:30.544  6313  6313 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 11:54:30.544  6313  6313 I flutter : ✅ Saved themeMode: dark
11-07 11:54:30.544  6313  6313 I flutter : ✅ Saved primaryColor: 4280391411
11-07 11:54:30.545  6313  6313 I flutter : ✅ Saved lastUpdate: 1762545270316
11-07 11:54:30.750  6313  6313 I flutter : Widget HabitCompactWidgetProvider update completed
11-07 11:54:30.750  6313  6313 I flutter : ✅ All widgets updated successfully (debounced)
11-07 11:54:30.750  6313  6313 I flutter : 📱 [2025-11-07T11:54:30.308257] updateAllWidgets() completed
11-07 11:54:30.953  6313  6313 I flutter : Android widget immediate update triggered
11-07 11:54:30.953  6313  6313 I flutter : 🔔 Widget update completed from Isar listener (data + UI refresh)
11-07 11:54:30.969  6313  6679 D WidgetUpdateWorker: ✅ Updated widget data with 4 today's habits (pre-filtered by Flutter)
11-07 11:54:30.969  6313  6679 D WidgetUpdateWorker: Widget data updated from Flutter preferences
11-07 11:54:30.970  6313  6662 D HabitTimelineService:   - Flutter['flutter.theme_mode']: null
11-07 11:54:30.974  6313  6662 D HabitTimelineService:   - Flutter['flutter.theme_mode']: null
11-07 11:54:32.111  6313  6313 I flutter : 🧪 FORCE UPDATE: Starting immediate widget update...
11-07 11:54:32.111  6313  6313 I flutter : 🧪 FORCE UPDATE: Called from notification completion handler
11-07 11:54:32.111  6313  6313 I flutter : 📱 [2025-11-07T11:54:32.111413] updateAllWidgets() called
11-07 11:54:32.111  6313  6313 I flutter : 📱 Performing immediate widget update...
11-07 11:54:32.116  6313  6313 I flutter : Filtering 8 habits for date 2025-11-07:
11-07 11:54:32.116  6313  6313 I flutter :   - Blood Pressure Med: HabitFrequency.daily -> INCLUDED
11-07 11:54:32.117  6313  6313 I flutter :   - Cholesterol Med: HabitFrequency.daily -> INCLUDED
11-07 11:54:32.117  6313  6313 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 11:54:32.117  6313  6313 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 11:54:32.118  6313  6313 I flutter :   - Vibration Plate: HabitFrequency.daily -> EXCLUDED
11-07 11:54:32.119  6313  6313 I flutter :   - Mandi's Birthday Tomorrow!!: HabitFrequency.daily -> EXCLUDED
11-07 11:54:32.119  6313  6313 I flutter :   - Do one push up: HabitFrequency.daily -> INCLUDED
11-07 11:54:32.119  6313  6313 I flutter :   - Drink Water: HabitFrequency.hourly -> INCLUDED
11-07 11:54:32.119  6313  6313 I flutter : Result: 4 habits for today
11-07 11:54:32.122  6313  6313 I flutter : Widget data preparation: Found 8 total habits, 4 for today
11-07 11:54:32.122  6313  6313 I flutter : 🎨 Getting app theme: ThemeMode.system
11-07 11:54:32.122  6313  6313 I flutter : 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
11-07 11:54:32.122  6313  6313 I flutter : 🎨 Final theme mode to send to widgets: dark
11-07 11:54:32.122  6313  6313 I flutter : 🎨 Using app primary color: 4280391411
11-07 11:54:32.122  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 08:40 for Drink Water: true
11-07 11:54:32.122  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 11:30 for Drink Water: false
11-07 11:54:32.122  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 14:40 for Drink Water: false
11-07 11:54:32.122  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 18:30 for Drink Water: false
11-07 11:54:32.123  6313  6313 I flutter : 🎯 Widget data prepared: 4 habits in list, JSON length: 1050
11-07 11:54:32.123  6313  6313 I flutter : 🎯 Completion status: 2/4 (allComplete: false)
11-07 11:54:32.123  6313  6313 I flutter :   📋 Blood Pressure Med: isCompleted=true
11-07 11:54:32.123  6313  6313 I flutter :   📋 Drink Water (hourly): 1/4 slots, isCompleted=false
11-07 11:54:32.123  6313  6313 I flutter :   📋 Do one push up: isCompleted=true
11-07 11:54:32.123  6313  6313 I flutter :   📋 Cholesterol Med: isCompleted=false
11-07 11:54:32.123  6313  6313 I flutter : 🎯 First 200 chars of habits JSON: [{"id":"1762545112793_0","name":"Blood Pressure Med","c 
ategory":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay":"08:30","frequency":"HabitFrequency.d 
aily"},{"id"
11-07 11:54:32.123  6313  6313 I flutter : 🎯 Theme data: dark, primary: 4280391411
11-07 11:54:32.127  6313  6313 I flutter : Saved widget theme data: dark, color: 4280391411
11-07 11:54:32.127  6313  6313 I flutter : Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit,
selectedDate, themeMode, primaryColor, lastUpdate]
11-07 11:54:32.128  6313  6313 I flutter : ✅ Saved habits: length=1050, preview=[{"id":"1762545112793_0","name":"Blood Pressure      
Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 11:54:32.128  6313  6313 I flutter : ✅ Saved nextHabit: {"id":"1762545112911_1","name":"Cholesterol
Med","category":"Health","colorValue":4278228616,"isComp...
11-07 11:54:32.128  6313  6313 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 11:54:32.128  6313  6313 I flutter : ✅ Saved themeMode: dark
11-07 11:54:32.128  6313  6313 I flutter : ✅ Saved primaryColor: 4280391411
11-07 11:54:32.130  6313  6313 I flutter : ✅ Saved lastUpdate: 1762545272123
11-07 11:54:32.239  6313  6662 D HabitTimelineService:   - Flutter['flutter.theme_mode']: null
11-07 11:54:32.337  6313  6313 I flutter : Widget HabitTimelineWidgetProvider update completed
11-07 11:54:32.337  6313  6313 I flutter : Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, 
selectedDate, themeMode, primaryColor, lastUpdate]
11-07 11:54:32.339  6313  6313 I flutter : ✅ Saved habits: length=1050, preview=[{"id":"1762545112793_0","name":"Blood Pressure      
Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 11:54:32.339  6313  6313 I flutter : ✅ Saved nextHabit: {"id":"1762545112911_1","name":"Cholesterol
Med","category":"Health","colorValue":4278228616,"isComp...
11-07 11:54:32.340  6313  6313 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 11:54:32.340  6313  6313 I flutter : ✅ Saved themeMode: dark
11-07 11:54:32.345  6313  6313 I flutter : ✅ Saved primaryColor: 4280391411
11-07 11:54:32.345  6313  6313 I flutter : ✅ Saved lastUpdate: 1762545272123
11-07 11:54:32.551  6313  6313 I flutter : Widget HabitCompactWidgetProvider update completed
11-07 11:54:32.552  6313  6313 I flutter : ✅ All widgets updated successfully (debounced)
11-07 11:54:32.552  6313  6313 I flutter : 📱 [2025-11-07T11:54:32.111413] updateAllWidgets() completed
11-07 11:54:32.552  6313  6313 I flutter : 🧪 FORCE UPDATE: updateAllWidgets() completed
11-07 11:54:32.610  6313  6313 I flutter : 🔄 onHabitCompleted called - updating all widgets
11-07 11:54:32.610  6313  6313 I flutter : 📱 [2025-11-07T11:54:32.610165] updateAllWidgets() called
11-07 11:54:32.610  6313  6313 I flutter : 📱 Performing immediate widget update...
11-07 11:54:32.618  6313  6313 I flutter : Filtering 8 habits for date 2025-11-07:
11-07 11:54:32.619  6313  6313 I flutter :   - Blood Pressure Med: HabitFrequency.daily -> INCLUDED
11-07 11:54:32.619  6313  6313 I flutter :   - Cholesterol Med: HabitFrequency.daily -> INCLUDED
11-07 11:54:32.619  6313  6313 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 11:54:32.620  6313  6313 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 11:54:32.620  6313  6313 I flutter :   - Vibration Plate: HabitFrequency.daily -> EXCLUDED
11-07 11:54:32.620  6313  6313 I flutter :   - Mandi's Birthday Tomorrow!!: HabitFrequency.daily -> EXCLUDED
11-07 11:54:32.620  6313  6313 I flutter :   - Do one push up: HabitFrequency.daily -> INCLUDED
11-07 11:54:32.620  6313  6313 I flutter :   - Drink Water: HabitFrequency.hourly -> INCLUDED
11-07 11:54:32.620  6313  6313 I flutter : Result: 4 habits for today
11-07 11:54:32.622  6313  6313 I flutter : Widget data preparation: Found 8 total habits, 4 for today
11-07 11:54:32.622  6313  6313 I flutter : 🎨 Getting app theme: ThemeMode.system
11-07 11:54:32.622  6313  6313 I flutter : 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
11-07 11:54:32.622  6313  6313 I flutter : 🎨 Final theme mode to send to widgets: dark
11-07 11:54:32.622  6313  6313 I flutter : 🎨 Using app primary color: 4280391411
11-07 11:54:32.622  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 08:40 for Drink Water: true
11-07 11:54:32.622  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 11:30 for Drink Water: false
11-07 11:54:32.622  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 14:40 for Drink Water: false
11-07 11:54:32.622  6313  6313 I flutter : 🔍 [Widget FG] Checking slot 18:30 for Drink Water: false
11-07 11:54:32.622  6313  6313 I flutter : 🎯 Widget data prepared: 4 habits in list, JSON length: 1050
11-07 11:54:32.622  6313  6313 I flutter : 🎯 Completion status: 2/4 (allComplete: false)
11-07 11:54:32.622  6313  6313 I flutter :   📋 Blood Pressure Med: isCompleted=true
11-07 11:54:32.622  6313  6313 I flutter :   📋 Drink Water (hourly): 1/4 slots, isCompleted=false
11-07 11:54:32.622  6313  6313 I flutter :   📋 Do one push up: isCompleted=true
11-07 11:54:32.622  6313  6313 I flutter :   📋 Cholesterol Med: isCompleted=false
11-07 11:54:32.622  6313  6313 I flutter : 🎯 First 200 chars of habits JSON: [{"id":"1762545112793_0","name":"Blood Pressure Med","c 
ategory":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay":"08:30","frequency":"HabitFrequency.d 
aily"},{"id"
11-07 11:54:32.622  6313  6313 I flutter : 🎯 Theme data: dark, primary: 4280391411
11-07 11:54:32.625  6313  6313 I flutter : Saved widget theme data: dark, color: 4280391411
11-07 11:54:32.625  6313  6313 I flutter : Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit,
selectedDate, themeMode, primaryColor, lastUpdate]
11-07 11:54:32.625  6313  6313 I flutter : ✅ Saved habits: length=1050, preview=[{"id":"1762545112793_0","name":"Blood Pressure      
Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 11:54:32.625  6313  6313 I flutter : ✅ Saved nextHabit: {"id":"1762545112911_1","name":"Cholesterol
Med","category":"Health","colorValue":4278228616,"isComp...
11-07 11:54:32.625  6313  6313 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 11:54:32.625  6313  6313 I flutter : ✅ Saved themeMode: dark
11-07 11:54:32.625  6313  6313 I flutter : ✅ Saved primaryColor: 4280391411
11-07 11:54:32.627  6313  6313 I flutter : ✅ Saved lastUpdate: 1762545272622
11-07 11:54:32.745  6313  6662 D HabitTimelineService:   - Flutter['flutter.theme_mode']: null
11-07 11:54:32.753  6313  6313 I flutter : 🧪 FORCE UPDATE: Waited for data persistence
11-07 11:54:32.753  6313  6313 I flutter : 🧪 FORCE UPDATE: Triggering immediate widget refresh
11-07 11:54:32.758  6313  6313 I flutter : 🧪 FORCE UPDATE: Successfully triggered widget refresh via method channel
11-07 11:54:32.758  6313  6313 I flutter : 🧪 FORCE UPDATE: Completed successfully
11-07 11:54:32.772  6313  6680 D HabitTimelineService:   - Flutter['flutter.theme_mode']: null
11-07 11:54:32.774  6313  6662 D HabitTimelineService:   - Flutter['flutter.theme_mode']: null
11-07 11:54:32.833  6313  6313 I flutter : Widget HabitTimelineWidgetProvider update completed
11-07 11:54:32.834  6313  6313 I flutter : Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, 
selectedDate, themeMode, primaryColor, lastUpdate]
11-07 11:54:32.835  6313  6313 I flutter : ✅ Saved habits: length=1050, preview=[{"id":"1762545112793_0","name":"Blood Pressure      
Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 11:54:32.836  6313  6313 I flutter : ✅ Saved nextHabit: {"id":"1762545112911_1","name":"Cholesterol
Med","category":"Health","colorValue":4278228616,"isComp...
11-07 11:54:32.836  6313  6313 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 11:54:32.837  6313  6313 I flutter : ✅ Saved themeMode: dark
11-07 11:54:32.837  6313  6313 I flutter : ✅ Saved primaryColor: 4280391411
11-07 11:54:32.838  6313  6313 I flutter : ✅ Saved lastUpdate: 1762545272622
11-07 11:54:33.043  6313  6313 I flutter : Widget HabitCompactWidgetProvider update completed
11-07 11:54:33.043  6313  6313 I flutter : ✅ All widgets updated successfully (debounced)
11-07 11:54:33.043  6313  6313 I flutter : 📱 [2025-11-07T11:54:32.610165] updateAllWidgets() completed
11-07 11:54:33.045  6313  6313 I flutter : Android widget immediate update triggered
11-07 11:54:33.045  6313  6313 I flutter : ✅ Widget update completed after habit completion
11-07 11:54:33.083  6313  6681 D WidgetUpdateWorker: ✅ Updated widget data with 4 today's habits (pre-filtered by Flutter)
11-07 11:54:33.083  6313  6681 D WidgetUpdateWorker: Widget data updated from Flutter preferences
11-07 11:54:33.087  6313  6662 D HabitTimelineService:   - Flutter['flutter.theme_mode']: null
11-07 11:54:33.110  6313  6662 D HabitTimelineService:   - Flutter['flutter.theme_mode']: null
