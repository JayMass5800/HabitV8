11-07 15:01:58.095  4733  4899 I DisplayManager: Choreographer implicitly registered for the refresh rate.
--------- beginning of main
11-07 15:02:55.196  4733  4733 D ViewRootImpl: Skipping stats log for color mode
11-07 15:02:55.196  4733  4733 I MainActivity: onRestart: Preserving alarm sound if playing
11-07 15:02:55.198  4733  4733 I MainActivity: onResume: Preserving alarm sound state
11-07 15:02:55.637  4733  4733 D ImeBackDispatcher: switch root view (mImeCallbacks.size=0)
11-07 15:02:55.638  4733  4733 I flutter : 🔄 Re-establishing Isar listener after app resume...
11-07 15:02:55.639  4733  4733 I flutter : ✅ Widget Isar lazy listener initialized (efficient change detection)
11-07 15:02:55.639  4733  4733 I flutter : ✅ Isar listener re-established successfully
11-07 15:02:55.639  4733  4733 I flutter : 🔔 [2025-11-07T15:02:55.639070] Isar lazy listener fired: habit change detected
11-07 15:02:55.639  4733  4733 I flutter : 🔔 Updating widgets via Isar listener...
11-07 15:02:55.639  4733  4733 I flutter : 📱 [2025-11-07T15:02:55.639098] updateAllWidgets() called
11-07 15:02:55.639  4733  4733 I flutter : 📱 Performing immediate widget update...
11-07 15:02:55.640  4733  4733 I flutter : Filtering 8 habits for date 2025-11-07:
11-07 15:02:55.640  4733  4733 I flutter :   - Blood Pressure Med: HabitFrequency.daily -> INCLUDED
11-07 15:02:55.640  4733  4733 I flutter :   - Cholesterol Med: HabitFrequency.daily -> INCLUDED
11-07 15:02:55.640  4733  4733 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 15:02:55.641  4733  4733 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 15:02:55.641  4733  4733 I flutter :   - Vibration Plate: HabitFrequency.daily -> EXCLUDED
11-07 15:02:55.641  4733  4733 I flutter :   - Mandi's Birthday Tomorrow!!: HabitFrequency.daily -> EXCLUDED
11-07 15:02:55.641  4733  4733 I flutter :   - Do one push up: HabitFrequency.daily -> INCLUDED
11-07 15:02:55.641  4733  4733 I flutter :   - Drink Water: HabitFrequency.hourly -> INCLUDED
11-07 15:02:55.641  4733  4733 I flutter : Result: 4 habits for today
11-07 15:02:55.642  4733  4733 I flutter : Widget data preparation: Found 8 total habits, 4 for today
11-07 15:02:55.642  4733  4733 I flutter : 🎨 Getting app theme: ThemeMode.system
11-07 15:02:55.642  4733  4733 I flutter : 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
11-07 15:02:55.642  4733  4733 I flutter : 🎨 Final theme mode to send to widgets: dark
11-07 15:02:55.642  4733  4733 I flutter : 🎨 Using app primary color: 4280391411
11-07 15:02:55.642  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 08:40 for Drink Water: true
11-07 15:02:55.642  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 11:30 for Drink Water: false
11-07 15:02:55.642  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 14:40 for Drink Water: false
11-07 15:02:55.642  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 18:30 for Drink Water: false
11-07 15:02:55.642  4733  4733 I flutter : 🎯 Widget data prepared: 4 habits in list, JSON length: 1045
11-07 15:02:55.642  4733  4733 I flutter : 🎯 Completion status: 1/4 (allComplete: false)
11-07 15:02:55.642  4733  4733 I flutter :   📋 Blood Pressure Med: isCompleted=true
11-07 15:02:55.642  4733  4733 I flutter :   📋 Drink Water (hourly): 1/4 slots, isCompleted=false
11-07 15:02:55.642  4733  4733 I flutter :   📋 Do one push up: isCompleted=false
11-07 15:02:55.642  4733  4733 I flutter :   📋 Cholesterol Med: isCompleted=false
11-07 15:02:55.642  4733  4733 I flutter : 🎯 First 200 chars of habits JSON: [{"id":"1762555679976_0","name":"Blood Pressure Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay":"08:30","frequency":"HabitFrequency.daily"},{"id"
11-07 15:02:55.642  4733  4733 I flutter : 🎯 Theme data: dark, primary: 4280391411
11-07 15:02:55.643  4733  4733 D InsetsController: hide(ime())
11-07 15:02:55.643  4733  4733 I ImeTracker: com.habittracker.habitv8:6051c91d: onCancelled at PHASE_CLIENT_ALREADY_HIDDEN
11-07 15:02:55.643  4733  4733 I flutter : Saved widget theme data: dark, color: 4280391411
11-07 15:02:55.643  4733  4733 I flutter : Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
11-07 15:02:55.643  4733  4733 I flutter : ✅ Saved habits: length=1045, preview=[{"id":"1762555679976_0","name":"Blood Pressure Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 15:02:55.644  4733  4733 I flutter : ✅ Saved nextHabit: {"id":"1762555680103_1","name":"Cholesterol Med","category":"Health","colorValue":4278228616,"isComp...
11-07 15:02:55.644  4733  4733 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 15:02:55.645  4733  4733 I flutter : ✅ Saved themeMode: dark
11-07 15:02:55.656  4733  4733 I flutter : 🔍 _buildAIInsightsTab: checking conditions - _isAIEnabled=true, _isAIAvailable=true       
11-07 15:02:55.656  4733  4733 I flutter : 🔍 Will use AI insights: true
11-07 15:02:55.656  4733  4733 I flutter : 🔍 _buildAIInsights called - _aiInsightsRequested=true, _isAIEnabled=true, _isAIAvailable=true
11-07 15:02:55.656  4733  4733 I flutter : 🔍 Building AI insights - _aiInsightsFuture is null: false
11-07 15:02:55.656  4733  4733 I flutter : 🔍 Number of habits for AI analysis: 8
11-07 15:02:55.656  4733  4733 I flutter : 🔍 About to call generateComprehensiveInsights...
11-07 15:02:55.656  4733  4733 I flutter : 🔍 _aiInsightsFuture is NOT NULL, reusing existing future
11-07 15:02:55.656  4733  4733 I flutter : 🔍 After assignment, _aiInsightsFuture is null: false
11-07 15:02:55.660  4733  4733 I flutter : ✅ Saved primaryColor: 4280391411
11-07 15:02:55.663  4733  4733 I flutter : ✅ Saved lastUpdate: 1762556575642
11-07 15:02:55.677  4733  4733 I flutter : 🔍 _buildAIInsightsTab: checking conditions - _isAIEnabled=true, _isAIAvailable=true       
11-07 15:02:55.677  4733  4733 I flutter : 🔍 Will use AI insights: true
11-07 15:02:55.677  4733  4733 I flutter : 🔍 _buildAIInsights called - _aiInsightsRequested=true, _isAIEnabled=true, _isAIAvailable=true
11-07 15:02:55.677  4733  4733 I flutter : 🔍 Building AI insights - _aiInsightsFuture is null: false
11-07 15:02:55.677  4733  4733 I flutter : 🔍 Number of habits for AI analysis: 8
11-07 15:02:55.677  4733  4733 I flutter : 🔍 About to call generateComprehensiveInsights...
11-07 15:02:55.677  4733  4733 I flutter : 🔍 _aiInsightsFuture is NOT NULL, reusing existing future
11-07 15:02:55.677  4733  4733 I flutter : 🔍 After assignment, _aiInsightsFuture is null: false
11-07 15:02:55.866  4733  4733 I flutter : Widget HabitTimelineWidgetProvider update completed
11-07 15:02:55.866  4733  4733 I flutter : Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
11-07 15:02:55.867  4733  4733 I flutter : ✅ Saved habits: length=1045, preview=[{"id":"1762555679976_0","name":"Blood Pressure Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 15:02:55.867  4733  4733 I flutter : ✅ Saved nextHabit: {"id":"1762555680103_1","name":"Cholesterol Med","category":"Health","colorValue":4278228616,"isComp...
11-07 15:02:55.868  4733  4733 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 15:02:55.868  4733  4733 I flutter : ✅ Saved themeMode: dark
11-07 15:02:55.868  4733  4733 I flutter : ✅ Saved primaryColor: 4280391411
11-07 15:02:55.868  4733  4733 I flutter : ✅ Saved lastUpdate: 1762556575642
11-07 15:02:56.074  4733  4733 I flutter : Widget HabitCompactWidgetProvider update completed
11-07 15:02:56.074  4733  4733 I flutter : ✅ All widgets updated successfully (debounced)
11-07 15:02:56.074  4733  4733 I flutter : 📱 [2025-11-07T15:02:55.639098] updateAllWidgets() completed
11-07 15:02:56.277  4733  4733 I WidgetUpdateWorker: ✅ Immediate widget update triggered
11-07 15:02:56.277  4733  4733 I MainActivity: Immediate widget update triggered via WidgetUpdateWorker
11-07 15:02:56.277  4733  4733 I flutter : Android widget immediate update triggered
11-07 15:02:56.277  4733  4733 I flutter : 🔔 Widget update completed from Isar listener (data + UI refresh)
11-07 15:02:56.286  4733  4769 W JobInfo : Requested important-while-foreground flag for job46 is ignored and takes no effect
11-07 15:02:56.286  4733  4769 D WM-SystemJobScheduler: Scheduling work ID 95de8922-3689-4d4d-83c7-645463fe25eaJob ID 46
11-07 15:02:56.290  4733  4769 D WM-GreedyScheduler: Starting work for 95de8922-3689-4d4d-83c7-645463fe25ea
11-07 15:02:56.290  4733  4733 D WM-SystemJobService: onStartJob for WorkGenerationalId(workSpecId=95de8922-3689-4d4d-83c7-645463fe25ea, generation=0)
11-07 15:02:56.291  4733  4769 D WM-Processor: Processor: processing WorkGenerationalId(workSpecId=95de8922-3689-4d4d-83c7-645463fe25ea, generation=0)
11-07 15:02:56.292  4733  4769 D WM-Processor: Work WorkGenerationalId(workSpecId=95de8922-3689-4d4d-83c7-645463fe25ea, generation=0) is already enqueued for processing
11-07 15:02:56.293  4733  4733 D WM-WorkerWrapper: Starting work for com.habittracker.habitv8.WidgetUpdateWorker
11-07 15:02:56.294  4733  4986 I WidgetUpdateWorker: Starting widget update work
11-07 15:02:56.294  4733  4986 D WidgetUpdateWorker: Widget data loaded from HomeWidgetPreferences: 1045 characters
11-07 15:02:56.294  4733  4986 D WidgetUpdateWorker: ✅ Updated widget data with 4 today's habits (pre-filtered by Flutter)
11-07 15:02:56.294  4733  4986 D WidgetUpdateWorker: Theme settings copied: mode=null, color=ffffffff
11-07 15:02:56.294  4733  4986 D WidgetUpdateWorker: Widget data updated from Flutter preferences
11-07 15:02:56.295  4733  4986 I WidgetUpdateWorker: ✅ Widget update work completed successfully
11-07 15:02:56.297  4733  4750 I WM-WorkerWrapper: Worker result SUCCESS for Work [ id=95de8922-3689-4d4d-83c7-645463fe25ea, tags={ com.habittracker.habitv8.WidgetUpdateWorker,immediate_widget_update } ]
11-07 15:02:56.299  4733  4733 D WM-Processor: Processor 95de8922-3689-4d4d-83c7-645463fe25ea executed; reschedule = false
11-07 15:02:56.300  4733  4733 D WM-SystemJobService: 95de8922-3689-4d4d-83c7-645463fe25ea executed on JobScheduler
11-07 15:02:56.304  4733  4750 D WM-GreedyScheduler: Cancelling work ID 95de8922-3689-4d4d-83c7-645463fe25ea
11-07 15:02:57.443  4733  4733 I flutter : 🧪 FORCE UPDATE: Starting immediate widget update...
11-07 15:02:57.443  4733  4733 I flutter : 🧪 FORCE UPDATE: Called from notification completion handler
11-07 15:02:57.443  4733  4733 I flutter : 📱 [2025-11-07T15:02:57.443597] updateAllWidgets() called
11-07 15:02:57.444  4733  4733 I flutter : 📱 Performing immediate widget update...
11-07 15:02:57.455  4733  4733 I flutter : Filtering 8 habits for date 2025-11-07:
11-07 15:02:57.456  4733  4733 I flutter :   - Blood Pressure Med: HabitFrequency.daily -> INCLUDED
11-07 15:02:57.457  4733  4733 I flutter :   - Cholesterol Med: HabitFrequency.daily -> INCLUDED
11-07 15:02:57.458  4733  4733 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 15:02:57.459  4733  4733 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 15:02:57.459  4733  4733 I flutter :   - Vibration Plate: HabitFrequency.daily -> EXCLUDED
11-07 15:02:57.461  4733  4733 I flutter :   - Mandi's Birthday Tomorrow!!: HabitFrequency.daily -> EXCLUDED
11-07 15:02:57.462  4733  4733 I flutter :   - Do one push up: HabitFrequency.daily -> INCLUDED
11-07 15:02:57.462  4733  4733 I flutter :   - Drink Water: HabitFrequency.hourly -> INCLUDED
11-07 15:02:57.462  4733  4733 I flutter : Result: 4 habits for today
11-07 15:02:57.465  4733  4733 I flutter : Widget data preparation: Found 8 total habits, 4 for today
11-07 15:02:57.465  4733  4733 I flutter : 🎨 Getting app theme: ThemeMode.system
11-07 15:02:57.465  4733  4733 I flutter : 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
11-07 15:02:57.465  4733  4733 I flutter : 🎨 Final theme mode to send to widgets: dark
11-07 15:02:57.465  4733  4733 I flutter : 🎨 Using app primary color: 4280391411
11-07 15:02:57.466  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 08:40 for Drink Water: true
11-07 15:02:57.466  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 11:30 for Drink Water: false
11-07 15:02:57.466  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 14:40 for Drink Water: false
11-07 15:02:57.466  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 18:30 for Drink Water: false
11-07 15:02:57.466  4733  4733 I flutter : 🎯 Widget data prepared: 4 habits in list, JSON length: 1045
11-07 15:02:57.466  4733  4733 I flutter : 🎯 Completion status: 1/4 (allComplete: false)
11-07 15:02:57.466  4733  4733 I flutter :   📋 Blood Pressure Med: isCompleted=true
11-07 15:02:57.466  4733  4733 I flutter :   📋 Drink Water (hourly): 1/4 slots, isCompleted=false
11-07 15:02:57.466  4733  4733 I flutter :   📋 Do one push up: isCompleted=false
11-07 15:02:57.466  4733  4733 I flutter :   📋 Cholesterol Med: isCompleted=false
11-07 15:02:57.466  4733  4733 I flutter : 🎯 First 200 chars of habits JSON: [{"id":"1762555679976_0","name":"Blood Pressure Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay":"08:30","frequency":"HabitFrequency.daily"},{"id"
11-07 15:02:57.466  4733  4733 I flutter : 🎯 Theme data: dark, primary: 4280391411
11-07 15:02:57.468  4733  4733 I flutter : Saved widget theme data: dark, color: 4280391411
11-07 15:02:57.468  4733  4733 I flutter : Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
11-07 15:02:57.468  4733  4733 I flutter : ✅ Saved habits: length=1045, preview=[{"id":"1762555679976_0","name":"Blood Pressure Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 15:02:57.469  4733  4733 I flutter : ✅ Saved nextHabit: {"id":"1762555680103_1","name":"Cholesterol Med","category":"Health","colorValue":4278228616,"isComp...
11-07 15:02:57.469  4733  4733 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 15:02:57.469  4733  4733 I flutter : ✅ Saved themeMode: dark
11-07 15:02:57.470  4733  4733 I flutter : ✅ Saved primaryColor: 4280391411
11-07 15:02:57.474  4733  4733 I flutter : ✅ Saved lastUpdate: 1762556577466
11-07 15:02:57.683  4733  4733 I flutter : Widget HabitTimelineWidgetProvider update completed
11-07 15:02:57.684  4733  4733 I flutter : Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
11-07 15:02:57.686  4733  4733 I flutter : ✅ Saved habits: length=1045, preview=[{"id":"1762555679976_0","name":"Blood Pressure Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 15:02:57.687  4733  4733 I flutter : ✅ Saved nextHabit: {"id":"1762555680103_1","name":"Cholesterol Med","category":"Health","colorValue":4278228616,"isComp...
11-07 15:02:57.688  4733  4733 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 15:02:57.688  4733  4733 I flutter : ✅ Saved themeMode: dark
11-07 15:02:57.688  4733  4733 I flutter : ✅ Saved primaryColor: 4280391411
11-07 15:02:57.689  4733  4733 I flutter : ✅ Saved lastUpdate: 1762556577466
11-07 15:02:57.900  4733  4733 I flutter : Widget HabitCompactWidgetProvider update completed
11-07 15:02:57.901  4733  4733 I flutter : ✅ All widgets updated successfully (debounced)
11-07 15:02:57.901  4733  4733 I flutter : 📱 [2025-11-07T15:02:57.443597] updateAllWidgets() completed
11-07 15:02:57.901  4733  4733 I flutter : 🧪 FORCE UPDATE: updateAllWidgets() completed
11-07 15:02:57.941  4733  4733 I flutter : 🔄 onHabitCompleted called - updating all widgets
11-07 15:02:57.941  4733  4733 I flutter : 📱 [2025-11-07T15:02:57.941189] updateAllWidgets() called
11-07 15:02:57.941  4733  4733 I flutter : 📱 Performing immediate widget update...
11-07 15:02:57.956  4733  4733 I flutter : Filtering 8 habits for date 2025-11-07:
11-07 15:02:57.957  4733  4733 I flutter :   - Blood Pressure Med: HabitFrequency.daily -> INCLUDED
11-07 15:02:57.958  4733  4733 I flutter :   - Cholesterol Med: HabitFrequency.daily -> INCLUDED
11-07 15:02:57.958  4733  4733 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 15:02:57.958  4733  4733 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 15:02:57.958  4733  4733 I flutter :   - Vibration Plate: HabitFrequency.daily -> EXCLUDED
11-07 15:02:57.959  4733  4733 I flutter :   - Mandi's Birthday Tomorrow!!: HabitFrequency.daily -> EXCLUDED
11-07 15:02:57.960  4733  4733 I flutter :   - Do one push up: HabitFrequency.daily -> INCLUDED
11-07 15:02:57.960  4733  4733 I flutter :   - Drink Water: HabitFrequency.hourly -> INCLUDED
11-07 15:02:57.960  4733  4733 I flutter : Result: 4 habits for today
11-07 15:02:57.965  4733  4733 I flutter : Widget data preparation: Found 8 total habits, 4 for today
11-07 15:02:57.966  4733  4733 I flutter : 🎨 Getting app theme: ThemeMode.system
11-07 15:02:57.966  4733  4733 I flutter : 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
11-07 15:02:57.966  4733  4733 I flutter : 🎨 Final theme mode to send to widgets: dark
11-07 15:02:57.966  4733  4733 I flutter : 🎨 Using app primary color: 4280391411
11-07 15:02:57.966  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 08:40 for Drink Water: true
11-07 15:02:57.966  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 11:30 for Drink Water: false
11-07 15:02:57.966  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 14:40 for Drink Water: false
11-07 15:02:57.966  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 18:30 for Drink Water: false
11-07 15:02:57.966  4733  4733 I flutter : 🎯 Widget data prepared: 4 habits in list, JSON length: 1045
11-07 15:02:57.966  4733  4733 I flutter : 🎯 Completion status: 1/4 (allComplete: false)
11-07 15:02:57.966  4733  4733 I flutter :   📋 Blood Pressure Med: isCompleted=true
11-07 15:02:57.966  4733  4733 I flutter :   📋 Drink Water (hourly): 1/4 slots, isCompleted=false
11-07 15:02:57.966  4733  4733 I flutter :   📋 Do one push up: isCompleted=false
11-07 15:02:57.966  4733  4733 I flutter :   📋 Cholesterol Med: isCompleted=false
11-07 15:02:57.966  4733  4733 I flutter : 🎯 First 200 chars of habits JSON: [{"id":"1762555679976_0","name":"Blood Pressure Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay":"08:30","frequency":"HabitFrequency.daily"},{"id"
11-07 15:02:57.966  4733  4733 I flutter : 🎯 Theme data: dark, primary: 4280391411
11-07 15:02:57.968  4733  4733 I flutter : Saved widget theme data: dark, color: 4280391411
11-07 15:02:57.968  4733  4733 I flutter : Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
11-07 15:02:57.968  4733  4733 I flutter : ✅ Saved habits: length=1045, preview=[{"id":"1762555679976_0","name":"Blood Pressure Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 15:02:57.968  4733  4733 I flutter : ✅ Saved nextHabit: {"id":"1762555680103_1","name":"Cholesterol Med","category":"Health","colorValue":4278228616,"isComp...
11-07 15:02:57.969  4733  4733 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 15:02:57.969  4733  4733 I flutter : ✅ Saved themeMode: dark
11-07 15:02:57.969  4733  4733 I flutter : ✅ Saved primaryColor: 4280391411
11-07 15:02:57.974  4733  4733 I flutter : ✅ Saved lastUpdate: 1762556577966
11-07 15:02:58.103  4733  4733 I flutter : 🧪 FORCE UPDATE: Waited for data persistence
11-07 15:02:58.103  4733  4733 I flutter : 🧪 FORCE UPDATE: Triggering immediate widget refresh
11-07 15:02:58.104  4733  4733 I MainActivity: 🔄 Force widget refresh requested
11-07 15:02:58.107  4733  4733 I MainActivity: Found 0 timeline widgets, 0 compact widgets
11-07 15:02:58.113  4733  4733 I MainActivity: ✅ Widget force refresh completed successfully
11-07 15:02:58.114  4733  4733 I flutter : 🧪 FORCE UPDATE: Successfully triggered widget refresh via method channel
11-07 15:02:58.114  4733  4733 I flutter : 🧪 FORCE UPDATE: Completed successfully
11-07 15:02:58.182  4733  4733 I flutter : Widget HabitTimelineWidgetProvider update completed
11-07 15:02:58.182  4733  4733 I flutter : Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
11-07 15:02:58.184  4733  4733 I flutter : ✅ Saved habits: length=1045, preview=[{"id":"1762555679976_0","name":"Blood Pressure Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 15:02:58.185  4733  4733 I flutter : ✅ Saved nextHabit: {"id":"1762555680103_1","name":"Cholesterol Med","category":"Health","colorValue":4278228616,"isComp...
11-07 15:02:58.186  4733  4733 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 15:02:58.186  4733  4733 I flutter : ✅ Saved themeMode: dark
11-07 15:02:58.187  4733  4733 I flutter : ✅ Saved primaryColor: 4280391411
11-07 15:02:58.187  4733  4733 I flutter : ✅ Saved lastUpdate: 1762556577966
11-07 15:02:58.397  4733  4733 I flutter : Widget HabitCompactWidgetProvider update completed
11-07 15:02:58.397  4733  4733 I flutter : ✅ All widgets updated successfully (debounced)
11-07 15:02:58.398  4733  4733 I flutter : 📱 [2025-11-07T15:02:57.941189] updateAllWidgets() completed
11-07 15:02:58.399  4733  4733 I WidgetUpdateWorker: ✅ Immediate widget update triggered
11-07 15:02:58.400  4733  4733 I MainActivity: Immediate widget update triggered via WidgetUpdateWorker
11-07 15:02:58.400  4733  4733 I flutter : Android widget immediate update triggered
11-07 15:02:58.400  4733  4733 I flutter : ✅ Widget update completed after habit completion
11-07 15:02:58.415  4733  4765 W JobInfo : Requested important-while-foreground flag for job47 is ignored and takes no effect
11-07 15:02:58.415  4733  4765 D WM-SystemJobScheduler: Scheduling work ID 142b4192-a9d9-4517-9525-5902ca8e2cc4Job ID 47
11-07 15:02:58.421  4733  4765 D WM-GreedyScheduler: Starting work for 142b4192-a9d9-4517-9525-5902ca8e2cc4
11-07 15:02:58.423  4733  4765 D WM-Processor: Processor: processing WorkGenerationalId(workSpecId=142b4192-a9d9-4517-9525-5902ca8e2cc4, generation=0)
11-07 15:02:58.426  4733  4733 D WM-SystemJobService: onStartJob for WorkGenerationalId(workSpecId=142b4192-a9d9-4517-9525-5902ca8e2cc4, generation=0)
11-07 15:02:58.426  4733  4733 D WM-WorkerWrapper: Starting work for com.habittracker.habitv8.WidgetUpdateWorker
11-07 15:02:58.427  4733  4987 I WidgetUpdateWorker: Starting widget update work
11-07 15:02:58.427  4733  4987 D WidgetUpdateWorker: Widget data loaded from HomeWidgetPreferences: 1045 characters
11-07 15:02:58.427  4733  4765 D WM-Processor: Work WorkGenerationalId(workSpecId=142b4192-a9d9-4517-9525-5902ca8e2cc4, generation=0) is already enqueued for processing
11-07 15:02:58.432  4733  4987 D WidgetUpdateWorker: ✅ Updated widget data with 4 today's habits (pre-filtered by Flutter)
11-07 15:02:58.432  4733  4987 D WidgetUpdateWorker: Theme settings copied: mode=null, color=ffffffff
11-07 15:02:58.432  4733  4987 D WidgetUpdateWorker: Widget data updated from Flutter preferences
11-07 15:02:58.434  4733  4987 I WidgetUpdateWorker: ✅ Widget update work completed successfully
11-07 15:02:58.436  4733  4769 I WM-WorkerWrapper: Worker result SUCCESS for Work [ id=142b4192-a9d9-4517-9525-5902ca8e2cc4, tags={ com.habittracker.habitv8.WidgetUpdateWorker,immediate_widget_update } ]
11-07 15:02:58.448  4733  4733 D WM-Processor: Processor 142b4192-a9d9-4517-9525-5902ca8e2cc4 executed; reschedule = false
11-07 15:02:58.449  4733  4733 D WM-SystemJobService: 142b4192-a9d9-4517-9525-5902ca8e2cc4 executed on JobScheduler
11-07 15:02:58.456  4733  4769 D WM-GreedyScheduler: Cancelling work ID 142b4192-a9d9-4517-9525-5902ca8e2cc4
11-07 15:03:24.770  4733  4981 I TRuntime.CctTransportBackend: Making request to: https://firebaselogging.googleapis.com/v0cc/log/batch?format=json_proto3
11-07 15:03:24.962  4733  4981 I TRuntime.CctTransportBackend: Status Code: 200
11-07 15:03:25.182  4733  4733 D ImeBackDispatcher: Clear (mImeCallbacks.size=0)
11-07 15:03:25.724  4733  4733 I MainActivity: onPause: Preserving alarm sound if playing
11-07 15:03:25.730  4733  4733 D VRI[MainActivity]: visibilityChanged oldVisibility=true newVisibility=false
11-07 15:03:25.797  4733  4733 D ImeBackDispatcher: Clear (mImeCallbacks.size=0)
11-07 15:03:25.797  4733  4733 D ImeBackDispatcher: switch root view (mImeCallbacks.size=0)
11-07 15:03:57.948  4733  4733 D ViewRootImpl: Skipping stats log for color mode
11-07 15:03:57.948  4733  4733 I MainActivity: onRestart: Preserving alarm sound if playing
11-07 15:03:57.950  4733  4733 I MainActivity: onResume: Preserving alarm sound state
11-07 15:03:58.404  4733  4733 D ImeBackDispatcher: switch root view (mImeCallbacks.size=0)
11-07 15:03:58.404  4733  4733 I flutter : 🔄 Re-establishing Isar listener after app resume...
11-07 15:03:58.405  4733  4733 I flutter : ✅ Widget Isar lazy listener initialized (efficient change detection)
11-07 15:03:58.405  4733  4733 I flutter : ✅ Isar listener re-established successfully
11-07 15:03:58.405  4733  4733 I flutter : 🔔 [2025-11-07T15:03:58.405812] Isar lazy listener fired: habit change detected
11-07 15:03:58.405  4733  4733 I flutter : 🔔 Updating widgets via Isar listener...
11-07 15:03:58.405  4733  4733 I flutter : 📱 [2025-11-07T15:03:58.405845] updateAllWidgets() called
11-07 15:03:58.405  4733  4733 I flutter : 📱 Performing immediate widget update...
11-07 15:03:58.406  4733  4733 D InsetsController: hide(ime())
11-07 15:03:58.406  4733  4733 I ImeTracker: com.habittracker.habitv8:fb41035d: onCancelled at PHASE_CLIENT_ALREADY_HIDDEN
11-07 15:03:58.408  4733  4733 I flutter : Filtering 8 habits for date 2025-11-07:
11-07 15:03:58.408  4733  4733 I flutter :   - Blood Pressure Med: HabitFrequency.daily -> INCLUDED
11-07 15:03:58.408  4733  4733 I flutter :   - Cholesterol Med: HabitFrequency.daily -> INCLUDED
11-07 15:03:58.408  4733  4733 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 15:03:58.408  4733  4733 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 15:03:58.408  4733  4733 I flutter :   - Vibration Plate: HabitFrequency.daily -> EXCLUDED
11-07 15:03:58.409  4733  4733 I flutter :   - Mandi's Birthday Tomorrow!!: HabitFrequency.daily -> EXCLUDED
11-07 15:03:58.409  4733  4733 I flutter :   - Do one push up: HabitFrequency.daily -> INCLUDED
11-07 15:03:58.409  4733  4733 I flutter :   - Drink Water: HabitFrequency.hourly -> INCLUDED
11-07 15:03:58.409  4733  4733 I flutter : Result: 4 habits for today
11-07 15:03:58.410  4733  4733 I flutter : Widget data preparation: Found 8 total habits, 4 for today
11-07 15:03:58.410  4733  4733 I flutter : 🎨 Getting app theme: ThemeMode.system
11-07 15:03:58.410  4733  4733 I flutter : 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
11-07 15:03:58.410  4733  4733 I flutter : 🎨 Final theme mode to send to widgets: dark
11-07 15:03:58.410  4733  4733 I flutter : 🎨 Using app primary color: 4280391411
11-07 15:03:58.410  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 08:40 for Drink Water: true
11-07 15:03:58.411  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 11:30 for Drink Water: false
11-07 15:03:58.411  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 14:40 for Drink Water: false
11-07 15:03:58.411  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 18:30 for Drink Water: false
11-07 15:03:58.411  4733  4733 I flutter : 🎯 Widget data prepared: 4 habits in list, JSON length: 1045
11-07 15:03:58.411  4733  4733 I flutter : 🎯 Completion status: 1/4 (allComplete: false)
11-07 15:03:58.411  4733  4733 I flutter :   📋 Blood Pressure Med: isCompleted=true
11-07 15:03:58.411  4733  4733 I flutter :   📋 Drink Water (hourly): 1/4 slots, isCompleted=false
11-07 15:03:58.411  4733  4733 I flutter :   📋 Do one push up: isCompleted=false
11-07 15:03:58.411  4733  4733 I flutter :   📋 Cholesterol Med: isCompleted=false
11-07 15:03:58.411  4733  4733 I flutter : 🎯 First 200 chars of habits JSON: [{"id":"1762555679976_0","name":"Blood Pressure Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay":"08:30","frequency":"HabitFrequency.daily"},{"id"
11-07 15:03:58.411  4733  4733 I flutter : 🎯 Theme data: dark, primary: 4280391411
11-07 15:03:58.423  4733  4733 I flutter : 🔍 _buildAIInsightsTab: checking conditions - _isAIEnabled=true, _isAIAvailable=true
11-07 15:03:58.423  4733  4733 I flutter : 🔍 Will use AI insights: true
11-07 15:03:58.423  4733  4733 I flutter : 🔍 _buildAIInsights called - _aiInsightsRequested=true, _isAIEnabled=true, _isAIAvailable=true
11-07 15:03:58.423  4733  4733 I flutter : 🔍 Building AI insights - _aiInsightsFuture is null: false
11-07 15:03:58.423  4733  4733 I flutter : 🔍 Number of habits for AI analysis: 8
11-07 15:03:58.423  4733  4733 I flutter : 🔍 About to call generateComprehensiveInsights...
11-07 15:03:58.423  4733  4733 I flutter : 🔍 _aiInsightsFuture is NOT NULL, reusing existing future
11-07 15:03:58.423  4733  4733 I flutter : 🔍 After assignment, _aiInsightsFuture is null: false
11-07 15:03:58.430  4733  4733 I flutter : Saved widget theme data: dark, color: 4280391411
11-07 15:03:58.430  4733  4733 I flutter : Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
11-07 15:03:58.431  4733  4733 I flutter : ✅ Saved habits: length=1045, preview=[{"id":"1762555679976_0","name":"Blood Pressure Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 15:03:58.431  4733  4733 I flutter : ✅ Saved nextHabit: {"id":"1762555680103_1","name":"Cholesterol Med","category":"Health","colorValue":4278228616,"isComp...
11-07 15:03:58.431  4733  4733 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 15:03:58.431  4733  4733 I flutter : ✅ Saved themeMode: dark
11-07 15:03:58.431  4733  4733 I flutter : ✅ Saved primaryColor: 4280391411
11-07 15:03:58.433  4733  4733 I flutter : ✅ Saved lastUpdate: 1762556638411
11-07 15:03:58.452  4733  4733 I flutter : 🔍 _buildAIInsightsTab: checking conditions - _isAIEnabled=true, _isAIAvailable=true
11-07 15:03:58.452  4733  4733 I flutter : 🔍 Will use AI insights: true
11-07 15:03:58.452  4733  4733 I flutter : 🔍 _buildAIInsights called - _aiInsightsRequested=true, _isAIEnabled=true, _isAIAvailable=true
11-07 15:03:58.452  4733  4733 I flutter : 🔍 Building AI insights - _aiInsightsFuture is null: false
11-07 15:03:58.452  4733  4733 I flutter : 🔍 Number of habits for AI analysis: 8
11-07 15:03:58.452  4733  4733 I flutter : 🔍 About to call generateComprehensiveInsights...
11-07 15:03:58.452  4733  4733 I flutter : 🔍 _aiInsightsFuture is NOT NULL, reusing existing future
11-07 15:03:58.452  4733  4733 I flutter : 🔍 After assignment, _aiInsightsFuture is null: false
11-07 15:03:58.636  4733  4733 I flutter : Widget HabitTimelineWidgetProvider update completed
11-07 15:03:58.636  4733  4733 I flutter : Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
11-07 15:03:58.637  4733  4733 I flutter : ✅ Saved habits: length=1045, preview=[{"id":"1762555679976_0","name":"Blood Pressure Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 15:03:58.637  4733  4733 I flutter : ✅ Saved nextHabit: {"id":"1762555680103_1","name":"Cholesterol Med","category":"Health","colorValue":4278228616,"isComp...
11-07 15:03:58.637  4733  4733 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 15:03:58.637  4733  4733 I flutter : ✅ Saved themeMode: dark
11-07 15:03:58.637  4733  4733 I flutter : ✅ Saved primaryColor: 4280391411
11-07 15:03:58.637  4733  4733 I flutter : ✅ Saved lastUpdate: 1762556638411
11-07 15:03:58.841  4733  4733 I flutter : Widget HabitCompactWidgetProvider update completed
11-07 15:03:58.841  4733  4733 I flutter : ✅ All widgets updated successfully (debounced)
11-07 15:03:58.841  4733  4733 I flutter : 📱 [2025-11-07T15:03:58.405845] updateAllWidgets() completed
11-07 15:03:59.044  4733  4733 I WidgetUpdateWorker: ✅ Immediate widget update triggered
11-07 15:03:59.044  4733  4733 I MainActivity: Immediate widget update triggered via WidgetUpdateWorker
11-07 15:03:59.045  4733  4733 I flutter : Android widget immediate update triggered
11-07 15:03:59.045  4733  4733 I flutter : 🔔 Widget update completed from Isar listener (data + UI refresh)
11-07 15:03:59.057  4733  4750 W JobInfo : Requested important-while-foreground flag for job48 is ignored and takes no effect
11-07 15:03:59.057  4733  4750 D WM-SystemJobScheduler: Scheduling work ID 63054d4b-04d4-46b4-8f80-2e5fbf9262f4Job ID 48
11-07 15:03:59.064  4733  4750 D WM-GreedyScheduler: Starting work for 63054d4b-04d4-46b4-8f80-2e5fbf9262f4
11-07 15:03:59.065  4733  4733 D WM-SystemJobService: onStartJob for WorkGenerationalId(workSpecId=63054d4b-04d4-46b4-8f80-2e5fbf9262f4, generation=0)
11-07 15:03:59.066  4733  4750 D WM-Processor: Processor: processing WorkGenerationalId(workSpecId=63054d4b-04d4-46b4-8f80-2e5fbf9262f4, generation=0)
11-07 15:03:59.067  4733  4750 D WM-Processor: Work WorkGenerationalId(workSpecId=63054d4b-04d4-46b4-8f80-2e5fbf9262f4, generation=0) is already enqueued for processing
11-07 15:03:59.070  4733  4733 D WM-WorkerWrapper: Starting work for com.habittracker.habitv8.WidgetUpdateWorker
11-07 15:03:59.071  4733  5096 I WidgetUpdateWorker: Starting widget update work
11-07 15:03:59.071  4733  5096 D WidgetUpdateWorker: Widget data loaded from HomeWidgetPreferences: 1045 characters
11-07 15:03:59.074  4733  5096 D WidgetUpdateWorker: ✅ Updated widget data with 4 today's habits (pre-filtered by Flutter)
11-07 15:03:59.074  4733  5096 D WidgetUpdateWorker: Theme settings copied: mode=null, color=ffffffff
11-07 15:03:59.075  4733  5096 D WidgetUpdateWorker: Widget data updated from Flutter preferences
11-07 15:03:59.076  4733  5096 I WidgetUpdateWorker: ✅ Widget update work completed successfully
11-07 15:03:59.078  4733  4769 I WM-WorkerWrapper: Worker result SUCCESS for Work [ id=63054d4b-04d4-46b4-8f80-2e5fbf9262f4, tags={ com.habittracker.habitv8.WidgetUpdateWorker,immediate_widget_update } ]
11-07 15:03:59.078  4733  4733 D WM-Processor: Processor 63054d4b-04d4-46b4-8f80-2e5fbf9262f4 executed; reschedule = false
11-07 15:03:59.079  4733  4733 D WM-SystemJobService: 63054d4b-04d4-46b4-8f80-2e5fbf9262f4 executed on JobScheduler
11-07 15:03:59.081  4733  4769 D WM-GreedyScheduler: Cancelling work ID 63054d4b-04d4-46b4-8f80-2e5fbf9262f4
11-07 15:04:00.208  4733  4733 I flutter : 🧪 FORCE UPDATE: Starting immediate widget update...
11-07 15:04:00.208  4733  4733 I flutter : 🧪 FORCE UPDATE: Called from notification completion handler
11-07 15:04:00.208  4733  4733 I flutter : 📱 [2025-11-07T15:04:00.208853] updateAllWidgets() called
11-07 15:04:00.209  4733  4733 I flutter : 📱 Performing immediate widget update...
11-07 15:04:00.216  4733  4733 I flutter : Filtering 8 habits for date 2025-11-07:
11-07 15:04:00.216  4733  4733 I flutter :   - Blood Pressure Med: HabitFrequency.daily -> INCLUDED
11-07 15:04:00.217  4733  4733 I flutter :   - Cholesterol Med: HabitFrequency.daily -> INCLUDED
11-07 15:04:00.217  4733  4733 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 15:04:00.218  4733  4733 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 15:04:00.218  4733  4733 I flutter :   - Vibration Plate: HabitFrequency.daily -> EXCLUDED
11-07 15:04:00.218  4733  4733 I flutter :   - Mandi's Birthday Tomorrow!!: HabitFrequency.daily -> EXCLUDED
11-07 15:04:00.218  4733  4733 I flutter :   - Do one push up: HabitFrequency.daily -> INCLUDED
11-07 15:04:00.218  4733  4733 I flutter :   - Drink Water: HabitFrequency.hourly -> INCLUDED
11-07 15:04:00.218  4733  4733 I flutter : Result: 4 habits for today
11-07 15:04:00.220  4733  4733 I flutter : Widget data preparation: Found 8 total habits, 4 for today
11-07 15:04:00.220  4733  4733 I flutter : 🎨 Getting app theme: ThemeMode.system
11-07 15:04:00.220  4733  4733 I flutter : 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
11-07 15:04:00.220  4733  4733 I flutter : 🎨 Final theme mode to send to widgets: dark
11-07 15:04:00.220  4733  4733 I flutter : 🎨 Using app primary color: 4280391411
11-07 15:04:00.220  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 08:40 for Drink Water: true
11-07 15:04:00.220  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 11:30 for Drink Water: false
11-07 15:04:00.220  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 14:40 for Drink Water: false
11-07 15:04:00.220  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 18:30 for Drink Water: false
11-07 15:04:00.221  4733  4733 I flutter : 🎯 Widget data prepared: 4 habits in list, JSON length: 1045
11-07 15:04:00.221  4733  4733 I flutter : 🎯 Completion status: 1/4 (allComplete: false)
11-07 15:04:00.221  4733  4733 I flutter :   📋 Blood Pressure Med: isCompleted=true
11-07 15:04:00.221  4733  4733 I flutter :   📋 Drink Water (hourly): 1/4 slots, isCompleted=false
11-07 15:04:00.221  4733  4733 I flutter :   📋 Do one push up: isCompleted=false
11-07 15:04:00.221  4733  4733 I flutter :   📋 Cholesterol Med: isCompleted=false
11-07 15:04:00.221  4733  4733 I flutter : 🎯 First 200 chars of habits JSON: [{"id":"1762555679976_0","name":"Blood Pressure Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay":"08:30","frequency":"HabitFrequency.daily"},{"id"
11-07 15:04:00.221  4733  4733 I flutter : 🎯 Theme data: dark, primary: 4280391411
11-07 15:04:00.224  4733  4733 I flutter : Saved widget theme data: dark, color: 4280391411
11-07 15:04:00.224  4733  4733 I flutter : Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
11-07 15:04:00.224  4733  4733 I flutter : ✅ Saved habits: length=1045, preview=[{"id":"1762555679976_0","name":"Blood Pressure Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 15:04:00.224  4733  4733 I flutter : ✅ Saved nextHabit: {"id":"1762555680103_1","name":"Cholesterol Med","category":"Health","colorValue":4278228616,"isComp...
11-07 15:04:00.225  4733  4733 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 15:04:00.225  4733  4733 I flutter : ✅ Saved themeMode: dark
11-07 15:04:00.225  4733  4733 I flutter : ✅ Saved primaryColor: 4280391411
11-07 15:04:00.230  4733  4733 I flutter : ✅ Saved lastUpdate: 1762556640221
11-07 15:04:00.442  4733  4733 I flutter : Widget HabitTimelineWidgetProvider update completed
11-07 15:04:00.442  4733  4733 I flutter : Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
11-07 15:04:00.445  4733  4733 I flutter : ✅ Saved habits: length=1045, preview=[{"id":"1762555679976_0","name":"Blood Pressure Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 15:04:00.446  4733  4733 I flutter : ✅ Saved nextHabit: {"id":"1762555680103_1","name":"Cholesterol Med","category":"Health","colorValue":4278228616,"isComp...
11-07 15:04:00.446  4733  4733 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 15:04:00.447  4733  4733 I flutter : ✅ Saved themeMode: dark
11-07 15:04:00.447  4733  4733 I flutter : ✅ Saved primaryColor: 4280391411
11-07 15:04:00.448  4733  4733 I flutter : ✅ Saved lastUpdate: 1762556640221
11-07 15:04:00.659  4733  4733 I flutter : Widget HabitCompactWidgetProvider update completed
11-07 15:04:00.659  4733  4733 I flutter : ✅ All widgets updated successfully (debounced)
11-07 15:04:00.659  4733  4733 I flutter : 📱 [2025-11-07T15:04:00.208853] updateAllWidgets() completed
11-07 15:04:00.659  4733  4733 I flutter : 🧪 FORCE UPDATE: updateAllWidgets() completed
11-07 15:04:00.708  4733  4733 I flutter : 🔄 onHabitCompleted called - updating all widgets
11-07 15:04:00.708  4733  4733 I flutter : 📱 [2025-11-07T15:04:00.708754] updateAllWidgets() called
11-07 15:04:00.708  4733  4733 I flutter : 📱 Performing immediate widget update...
11-07 15:04:00.720  4733  4733 I flutter : Filtering 8 habits for date 2025-11-07:
11-07 15:04:00.720  4733  4733 I flutter :   - Blood Pressure Med: HabitFrequency.daily -> INCLUDED
11-07 15:04:00.721  4733  4733 I flutter :   - Cholesterol Med: HabitFrequency.daily -> INCLUDED
11-07 15:04:00.721  4733  4733 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 15:04:00.721  4733  4733 I flutter :   - Put The Bins Out: HabitFrequency.daily -> EXCLUDED
11-07 15:04:00.722  4733  4733 I flutter :   - Vibration Plate: HabitFrequency.daily -> EXCLUDED
11-07 15:04:00.722  4733  4733 I flutter :   - Mandi's Birthday Tomorrow!!: HabitFrequency.daily -> EXCLUDED
11-07 15:04:00.723  4733  4733 I flutter :   - Do one push up: HabitFrequency.daily -> INCLUDED
11-07 15:04:00.723  4733  4733 I flutter :   - Drink Water: HabitFrequency.hourly -> INCLUDED
11-07 15:04:00.723  4733  4733 I flutter : Result: 4 habits for today
11-07 15:04:00.725  4733  4733 I flutter : Widget data preparation: Found 8 total habits, 4 for today
11-07 15:04:00.725  4733  4733 I flutter : 🎨 Getting app theme: ThemeMode.system
11-07 15:04:00.725  4733  4733 I flutter : 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
11-07 15:04:00.725  4733  4733 I flutter : 🎨 Final theme mode to send to widgets: dark
11-07 15:04:00.725  4733  4733 I flutter : 🎨 Using app primary color: 4280391411
11-07 15:04:00.726  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 08:40 for Drink Water: true
11-07 15:04:00.726  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 11:30 for Drink Water: false
11-07 15:04:00.726  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 14:40 for Drink Water: false
11-07 15:04:00.726  4733  4733 I flutter : 🔍 [Widget FG] Checking slot 18:30 for Drink Water: false
11-07 15:04:00.726  4733  4733 I flutter : 🎯 Widget data prepared: 4 habits in list, JSON length: 1045
11-07 15:04:00.726  4733  4733 I flutter : 🎯 Completion status: 1/4 (allComplete: false)
11-07 15:04:00.726  4733  4733 I flutter :   📋 Blood Pressure Med: isCompleted=true
11-07 15:04:00.726  4733  4733 I flutter :   📋 Drink Water (hourly): 1/4 slots, isCompleted=false
11-07 15:04:00.726  4733  4733 I flutter :   📋 Do one push up: isCompleted=false
11-07 15:04:00.726  4733  4733 I flutter :   📋 Cholesterol Med: isCompleted=false
11-07 15:04:00.726  4733  4733 I flutter : 🎯 First 200 chars of habits JSON: [{"id":"1762555679976_0","name":"Blood Pressure Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay":"08:30","frequency":"HabitFrequency.daily"},{"id"
11-07 15:04:00.726  4733  4733 I flutter : 🎯 Theme data: dark, primary: 4280391411
11-07 15:04:00.729  4733  4733 I flutter : Saved widget theme data: dark, color: 4280391411
11-07 15:04:00.729  4733  4733 I flutter : Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
11-07 15:04:00.730  4733  4733 I flutter : ✅ Saved habits: length=1045, preview=[{"id":"1762555679976_0","name":"Blood Pressure Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 15:04:00.730  4733  4733 I flutter : ✅ Saved nextHabit: {"id":"1762555680103_1","name":"Cholesterol Med","category":"Health","colorValue":4278228616,"isComp...
11-07 15:04:00.730  4733  4733 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 15:04:00.731  4733  4733 I flutter : ✅ Saved themeMode: dark
11-07 15:04:00.732  4733  4733 I flutter : ✅ Saved primaryColor: 4280391411
11-07 15:04:00.736  4733  4733 I flutter : ✅ Saved lastUpdate: 1762556640726
11-07 15:04:00.817  4733  4733 D WindowOnBackDispatcher: setTopOnBackInvokedCallback (unwrapped): androidx.activity.z@b9871cd
11-07 15:04:00.862  4733  4733 I flutter : 🧪 FORCE UPDATE: Waited for data persistence
11-07 15:04:00.862  4733  4733 I flutter : 🧪 FORCE UPDATE: Triggering immediate widget refresh
11-07 15:04:00.863  4733  4733 I MainActivity: 🔄 Force widget refresh requested
11-07 15:04:00.864  4733  4733 I MainActivity: Found 0 timeline widgets, 0 compact widgets
11-07 15:04:00.874  4733  4733 I MainActivity: ✅ Widget force refresh completed successfully
11-07 15:04:00.874  4733  4733 I flutter : 🧪 FORCE UPDATE: Successfully triggered widget refresh via method channel
11-07 15:04:00.875  4733  4733 I flutter : 🧪 FORCE UPDATE: Completed successfully
11-07 15:04:00.940  4733  4733 I flutter : Widget HabitTimelineWidgetProvider update completed
11-07 15:04:00.940  4733  4733 I flutter : Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
11-07 15:04:00.941  4733  4733 I flutter : ✅ Saved habits: length=1045, preview=[{"id":"1762555679976_0","name":"Blood Pressure Med","category":"Health","colorValue":4278238420,"isCompleted":true,"status":"Completed","timeDisplay"...
11-07 15:04:00.942  4733  4733 I flutter : ✅ Saved nextHabit: {"id":"1762555680103_1","name":"Cholesterol Med","category":"Health","colorValue":4278228616,"isComp...
11-07 15:04:00.942  4733  4733 I flutter : ✅ Saved selectedDate: 2025-11-07
11-07 15:04:00.942  4733  4733 I flutter : ✅ Saved themeMode: dark
11-07 15:04:00.942  4733  4733 I flutter : ✅ Saved primaryColor: 4280391411
11-07 15:04:00.943  4733  4733 I flutter : ✅ Saved lastUpdate: 1762556640726
11-07 15:04:01.149  4733  4733 I flutter : Widget HabitCompactWidgetProvider update completed
11-07 15:04:01.149  4733  4733 I flutter : ✅ All widgets updated successfully (debounced)
11-07 15:04:01.149  4733  4733 I flutter : 📱 [2025-11-07T15:04:00.708754] updateAllWidgets() completed
11-07 15:04:01.152  4733  4733 I WidgetUpdateWorker: ✅ Immediate widget update triggered
11-07 15:04:01.152  4733  4733 I MainActivity: Immediate widget update triggered via WidgetUpdateWorker
11-07 15:04:01.152  4733  4733 I flutter : Android widget immediate update triggered
11-07 15:04:01.152  4733  4733 I flutter : ✅ Widget update completed after habit completion
11-07 15:04:01.167  4733  4765 W JobInfo : Requested important-while-foreground flag for job49 is ignored and takes no effect
11-07 15:04:01.168  4733  4765 D WM-SystemJobScheduler: Scheduling work ID 1e4d6017-4492-450f-a8ce-92682ebea726Job ID 49
11-07 15:04:01.179  4733  4765 D WM-GreedyScheduler: Starting work for 1e4d6017-4492-450f-a8ce-92682ebea726
11-07 15:04:01.181  4733  4733 D WM-SystemJobService: onStartJob for WorkGenerationalId(workSpecId=1e4d6017-4492-450f-a8ce-92682ebea726, generation=0)
11-07 15:04:01.181  4733  4765 D WM-Processor: Processor: processing WorkGenerationalId(workSpecId=1e4d6017-4492-450f-a8ce-92682ebea726, generation=0)
11-07 15:04:01.185  4733  4769 D WM-Processor: Work WorkGenerationalId(workSpecId=1e4d6017-4492-450f-a8ce-92682ebea726, generation=0) is already enqueued for processing
11-07 15:04:01.186  4733  4733 D WM-WorkerWrapper: Starting work for com.habittracker.habitv8.WidgetUpdateWorker
11-07 15:04:01.187  4733  5128 I WidgetUpdateWorker: Starting widget update work
11-07 15:04:01.187  4733  5128 D WidgetUpdateWorker: Widget data loaded from HomeWidgetPreferences: 1045 characters
11-07 15:04:01.192  4733  5128 D WidgetUpdateWorker: ✅ Updated widget data with 4 today's habits (pre-filtered by Flutter)
11-07 15:04:01.192  4733  5128 D WidgetUpdateWorker: Theme settings copied: mode=null, color=ffffffff
11-07 15:04:01.192  4733  5128 D WidgetUpdateWorker: Widget data updated from Flutter preferences
11-07 15:04:01.193  4733  5128 I WidgetUpdateWorker: ✅ Widget update work completed successfully
11-07 15:04:01.199  4733  4769 I WM-WorkerWrapper: Worker result SUCCESS for Work [ id=1e4d6017-4492-450f-a8ce-92682ebea726, tags={ com.habittracker.habitv8.WidgetUpdateWorker,immediate_widget_update } ]
11-07 15:04:01.205  4733  4733 D WM-Processor: Processor 1e4d6017-4492-450f-a8ce-92682ebea726 executed; reschedule = false
11-07 15:04:01.205  4733  4733 D WM-SystemJobService: 1e4d6017-4492-450f-a8ce-92682ebea726 executed on JobScheduler
11-07 15:04:01.211  4733  4750 D WM-GreedyScheduler: Cancelling work ID 1e4d6017-4492-450f-a8ce-92682ebea726
11-07 15:04:01.765  4733  4733 I flutter : 🔍 Refresh Insights button pressed
11-07 15:04:01.784  4733  4733 I flutter : 🔍 _buildAIInsightsTab: checking conditions - _isAIEnabled=true, _isAIAvailable=true
11-07 15:04:01.784  4733  4733 I flutter : 🔍 Will use AI insights: true
11-07 15:04:01.784  4733  4733 I flutter : 🔍 _buildAIInsights called - _aiInsightsRequested=false, _isAIEnabled=true, _isAIAvailable=true
11-07 15:04:01.784  4733  4733 I flutter : 🔍 _buildAIInsights: returning early - _aiInsightsRequested is false
11-07 15:04:01.790  4733  4733 D WindowOnBackDispatcher: setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@6b8954e
11-07 15:04:03.218  4733  4733 I flutter : 🔍 Load AI Insights button TAPPED
11-07 15:04:03.218  4733  4733 I flutter : 🔍 _loadAIInsights() called - Current state: _aiInsightsRequested=false, _aiInsightsFuture is null: true
11-07 15:04:03.218  4733  4733 I flutter : 🔍 State updated: _aiInsightsRequested=true, _aiInsightsFuture set to null
11-07 15:04:03.248  4733  4733 I flutter : 🔍 _buildAIInsightsTab: checking conditions - _isAIEnabled=true, _isAIAvailable=true
11-07 15:04:03.248  4733  4733 I flutter : 🔍 Will use AI insights: true
11-07 15:04:03.248  4733  4733 I flutter : 🔍 _buildAIInsights called - _aiInsightsRequested=true, _isAIEnabled=true, _isAIAvailable=true
11-07 15:04:03.248  4733  4733 I flutter : 🔍 Building AI insights - _aiInsightsFuture is null: true
11-07 15:04:03.248  4733  4733 I flutter : 🔍 Number of habits for AI analysis: 8
11-07 15:04:03.248  4733  4733 I flutter : 🔍 About to call generateComprehensiveInsights...
11-07 15:04:03.248  4733  4733 I flutter : 🔍 _aiInsightsFuture IS NULL, calling generateComprehensiveInsights
11-07 15:04:03.249  4733  4733 I flutter : 🚨 METHOD ENTRY: generateComprehensiveInsights called with 8 habits
11-07 15:04:03.249  4733  4733 I flutter : 🚨 useAI=true, preferredAIProvider=null
11-07 15:04:03.265  4733  4733 I flutter : 🚨 SYNC CHECK: hasApiKey=true
11-07 15:04:03.266  4733  4733 I flutter : 🔍 Called generateComprehensiveInsights, future assigned
11-07 15:04:03.266  4733  4733 I flutter : 🔍 After assignment, _aiInsightsFuture is null: false
11-07 15:04:03.271  4733  4733 I flutter : 🚨 isConfiguredAsync returned: true
11-07 15:04:03.271  4733  4733 I flutter : 🚨 FINAL: aiConfigured=true, useAI=true, willGenerateAI=true
11-07 15:04:03.999  4733  4733 I flutter : 🚨 METHOD EXIT: Returning 3 insights (AI=true)
11-07 15:04:03.999  4733  4733 I flutter : 🔍 ✅ Future completed with 3 insights
