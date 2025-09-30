I/WM-WorkerWrapper( 9191):      at androidx.work.impl.Processor.interrupt(Processor.java:439)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.Processor.stopAndCancelWork(Processor.java:280)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.cancel(CancelWorkRunnable.kt:33)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.forNameInline$lambda$0(CancelWorkRunnable.kt:127)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.$r8$lambda$gmz-7SyxTGDd6CwHjvOsJ11-hcc(Unknown Source:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable$$ExternalSyntheticLambda0.run(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.room.RoomDatabase.runInTransaction(RoomDatabase.kt:585)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.forNameInline(CancelWorkRunnable.kt:123)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueueWorkWithPrerequisites(EnqueueRunnable.java:249)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueueContinuation(EnqueueRunnable.java:136)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.processContinuation(EnqueueRunnable.java:129)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.addToDatabase(EnqueueRunnable.java:93)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueue(EnqueueRunnable.java:74)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkContinuationImpl.lambda$enqueue$0$androidx-work-impl-WorkContinuationImpl(WorkContinuationImpl.java:201)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkContinuationImpl$$ExternalSyntheticLambda0.invoke(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt.launchOperation$lambda$2$lambda$1(Operation.kt:50)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt.$r8$lambda$XKAkIiEN7OgIvwuLUZRQpJhjmyE(Unknown Source:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt$$ExternalSyntheticLambda1.run(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.SerialExecutorImpl$Task.run(SerialExecutorImpl.java:96)
I/WM-WorkerWrapper( 9191):      at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1156)
I/WM-WorkerWrapper( 9191):      at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:651)
I/WM-WorkerWrapper( 9191):      at java.lang.Thread.run(Thread.java:1119)
D/WM-WorkerWrapper( 9191): Status for d13a47d4-9a36-4c59-8978-200847fd3e1c is null ; not doing any work
D/WM-SystemJobService( 9191): onStartJob for WorkGenerationalId(workSpecId=159b6522-1764-4df1-8833-4dc31b84ec07, generation=0)
D/WM-StopWorkRunnable( 9191): StopWorkRunnable for d13a47d4-9a36-4c59-8978-200847fd3e1c; Processor.stopWork = false
D/WM-Processor( 9191): Processor d13a47d4-9a36-4c59-8978-200847fd3e1c executed; reschedule = false
D/WM-SystemJobService( 9191): d13a47d4-9a36-4c59-8978-200847fd3e1c executed on JobScheduler
D/WM-StopWorkRunnable( 9191): StopWorkRunnable for d13a47d4-9a36-4c59-8978-200847fd3e1c; Processor.stopWork = false
D/WM-Processor( 9191): Processor: processing WorkGenerationalId(workSpecId=159b6522-1764-4df1-8833-4dc31b84ec07, generation=0)
D/WM-Processor( 9191): Work WorkGenerationalId(workSpecId=159b6522-1764-4df1-8833-4dc31b84ec07, generation=0) is already enqueued for processing
D/WM-GreedyScheduler( 9191): Cancelling work ID d13a47d4-9a36-4c59-8978-200847fd3e1c
D/WM-WorkerWrapper( 9191): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker( 9191): Starting widget update work
D/WidgetUpdateWorker( 9191): Widget data loaded: 2 characters
D/WidgetUpdateWorker( 9191): Skipping habits update - no new data to write (would be empty array)
D/WidgetUpdateWorker( 9191): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker( 9191): Widget data updated from Flutter preferences
D/WidgetUpdateWorker( 9191): Updated 1 compact widgets
D/HabitCompactWidget( 9191): onUpdate called with 1 widget IDs
W/HabitCompactWidget( 9191): No habit data found, triggering refresh
I/WidgetUpdateWorker( 9191): ✅ Immediate widget update triggered
D/HabitCompactWidget( 9191): onDataSetChanged called
D/HabitCompactWidget( 9191): Loading theme data
D/HabitCompactWidget( 9191): Theme loaded - mode: dark, text: ffffffff, bg: ff121212, primary: ff2196f3
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'habits': empty array
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'today_habits': empty array
D/HabitCompactWidget( 9191): No habits data found or empty array (from key: null). Available keys: [habits, home_widget.double.selectedDate, habit_count, home_widget.double.primaryColor, primaryColor, themeMode, selectedDate, home_widget.double.habits, today_habit_count, lastUpdate, last_update, home_widget.double.themeMode, home_widget.double.lastUpdate, today_habits]
D/HabitCompactWidget( 9191): getCount called, returning: 0
D/HabitCompactWidget( 9191): ListView setup completed for widget 124 with theme extras: mode=dark, primary=ff2196f3
D/HabitCompactWidget( 9191): Detected theme mode: 'dark'
D/HabitCompactWidget( 9191): Using theme - mode: 'dark', primary: ff2196f3
D/HabitCompactWidget( 9191): Semi-transparent theme applied - isDark: true, bg: 800f0f0f
D/WM-Processor( 9191): Processor cancelling 159b6522-1764-4df1-8833-4dc31b84ec07
D/WM-Processor( 9191): WorkerWrapper interrupted for 159b6522-1764-4df1-8833-4dc31b84ec07
D/HabitCompactWidget( 9191): checkForHabits result: false (from widgetData + HomeWidgetPreferences)
D/WM-GreedyScheduler( 9191): Cancelling work ID 159b6522-1764-4df1-8833-4dc31b84ec07
D/HabitCompactWidget( 9191): getCount called, returning: 0
D/HabitCompactWidget( 9191): Widget update completed for ID: 124
D/WM-SystemJobService( 9191): onStopJob for WorkGenerationalId(workSpecId=159b6522-1764-4df1-8833-4dc31b84ec07, generation=0)
I/WidgetUpdateWorker( 9191): ✅ Widget update work completed successfully
D/HabitCompactWidget( 9191): onDataSetChanged called
D/HabitCompactWidget( 9191): Loading theme data
D/HabitCompactWidget( 9191): Theme loaded - mode: dark, text: ffffffff, bg: ff121212, primary: ff2196f3
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'habits': empty array
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'today_habits': empty array
D/HabitCompactWidget( 9191): No habits data found or empty array (from key: null). Available keys: [habits, home_widget.double.selectedDate, habit_count, home_widget.double.primaryColor, primaryColor, themeMode, selectedDate, home_widget.double.habits, today_habit_count, lastUpdate, last_update, home_widget.double.themeMode, home_widget.double.lastUpdate, today_habits]
D/HabitCompactWidget( 9191): getCount called, returning: 0
W/JobInfo ( 9191): Requested important-while-foreground flag for job309 is ignored and takes no effect
D/WM-SystemJobScheduler( 9191): Scheduling work ID 1db93f20-0cdb-444f-aa9e-5442997722f4Job ID 309
D/WM-GreedyScheduler( 9191): Starting work for 1db93f20-0cdb-444f-aa9e-5442997722f4
I/WM-WorkerWrapper( 9191): Work [ id=159b6522-1764-4df1-8833-4dc31b84ec07, tags={ com.habittracker.habitv8.WidgetUpdateWorker,immediate_widget_update } ] was cancelled
I/WM-WorkerWrapper( 9191): androidx.work.impl.WorkerStoppedException
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkerWrapper.interrupt(WorkerWrapper.kt:348)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.Processor.interrupt(Processor.java:439)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.Processor.stopAndCancelWork(Processor.java:280)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.cancel(CancelWorkRunnable.kt:33)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.forNameInline$lambda$0(CancelWorkRunnable.kt:127)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.$r8$lambda$gmz-7SyxTGDd6CwHjvOsJ11-hcc(Unknown Source:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable$$ExternalSyntheticLambda0.run(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.room.RoomDatabase.runInTransaction(RoomDatabase.kt:585)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.forNameInline(CancelWorkRunnable.kt:123)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueueWorkWithPrerequisites(EnqueueRunnable.java:249)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueueContinuation(EnqueueRunnable.java:136)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.processContinuation(EnqueueRunnable.java:129)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.addToDatabase(EnqueueRunnable.java:93)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueue(EnqueueRunnable.java:74)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkContinuationImpl.lambda$enqueue$0$androidx-work-impl-WorkContinuationImpl(WorkContinuationImpl.java:201)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkContinuationImpl$$ExternalSyntheticLambda0.invoke(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt.launchOperation$lambda$2$lambda$1(Operation.kt:50)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt.$r8$lambda$XKAkIiEN7OgIvwuLUZRQpJhjmyE(Unknown Source:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt$$ExternalSyntheticLambda1.run(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.SerialExecutorImpl$Task.run(SerialExecutorImpl.java:96)
I/WM-WorkerWrapper( 9191):      at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1156)
I/WM-WorkerWrapper( 9191):      at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:651)
I/WM-WorkerWrapper( 9191):      at java.lang.Thread.run(Thread.java:1119)
D/WM-SystemJobService( 9191): onStartJob for WorkGenerationalId(workSpecId=1db93f20-0cdb-444f-aa9e-5442997722f4, generation=0)
D/WM-WorkerWrapper( 9191): Status for 159b6522-1764-4df1-8833-4dc31b84ec07 is null ; not doing any work
D/WM-Processor( 9191): Processor 159b6522-1764-4df1-8833-4dc31b84ec07 executed; reschedule = false
D/WM-SystemJobService( 9191): 159b6522-1764-4df1-8833-4dc31b84ec07 executed on JobScheduler
D/WM-StopWorkRunnable( 9191): StopWorkRunnable for 159b6522-1764-4df1-8833-4dc31b84ec07; Processor.stopWork = false
D/WM-StopWorkRunnable( 9191): StopWorkRunnable for 159b6522-1764-4df1-8833-4dc31b84ec07; Processor.stopWork = false
D/WM-Processor( 9191): Processor: processing WorkGenerationalId(workSpecId=1db93f20-0cdb-444f-aa9e-5442997722f4, generation=0)
D/WM-Processor( 9191): Work WorkGenerationalId(workSpecId=1db93f20-0cdb-444f-aa9e-5442997722f4, generation=0) is already enqueued for processing
D/WM-GreedyScheduler( 9191): Cancelling work ID 159b6522-1764-4df1-8833-4dc31b84ec07
D/WM-WorkerWrapper( 9191): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker( 9191): Starting widget update work
D/WidgetUpdateWorker( 9191): Widget data loaded: 2 characters
D/WidgetUpdateWorker( 9191): Skipping habits update - no new data to write (would be empty array)
D/WidgetUpdateWorker( 9191): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker( 9191): Widget data updated from Flutter preferences
D/WidgetUpdateWorker( 9191): Updated 1 compact widgets
D/HabitCompactWidget( 9191): onUpdate called with 1 widget IDs
W/HabitCompactWidget( 9191): No habit data found, triggering refresh
D/HabitCompactWidget( 9191): onDataSetChanged called
D/HabitCompactWidget( 9191): Loading theme data
I/WidgetUpdateWorker( 9191): ✅ Immediate widget update triggered
D/HabitCompactWidget( 9191): Theme loaded - mode: dark, text: ffffffff, bg: ff121212, primary: ff2196f3
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'habits': empty array
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'today_habits': empty array
D/HabitCompactWidget( 9191): No habits data found or empty array (from key: null). Available keys: [habits, home_widget.double.selectedDate, habit_count, home_widget.double.primaryColor, primaryColor, themeMode, selectedDate, home_widget.double.habits, today_habit_count, lastUpdate, last_update, home_widget.double.themeMode, home_widget.double.lastUpdate, today_habits]
D/HabitCompactWidget( 9191): getCount called, returning: 0
D/HabitCompactWidget( 9191): ListView setup completed for widget 124 with theme extras: mode=dark, primary=ff2196f3
D/HabitCompactWidget( 9191): Detected theme mode: 'dark'
D/HabitCompactWidget( 9191): Using theme - mode: 'dark', primary: ff2196f3
D/HabitCompactWidget( 9191): Semi-transparent theme applied - isDark: true, bg: 800f0f0f
D/WM-Processor( 9191): Processor cancelling 1db93f20-0cdb-444f-aa9e-5442997722f4
D/HabitCompactWidget( 9191): checkForHabits result: false (from widgetData + HomeWidgetPreferences)
D/WM-Processor( 9191): WorkerWrapper interrupted for 1db93f20-0cdb-444f-aa9e-5442997722f4
D/HabitCompactWidget( 9191): getCount called, returning: 0
D/WM-GreedyScheduler( 9191): Cancelling work ID 1db93f20-0cdb-444f-aa9e-5442997722f4
D/HabitCompactWidget( 9191): Widget update completed for ID: 124
I/WidgetUpdateWorker( 9191): ✅ Widget update work completed successfully
D/WM-SystemJobService( 9191): onStopJob for WorkGenerationalId(workSpecId=1db93f20-0cdb-444f-aa9e-5442997722f4, generation=0)
D/HabitCompactWidget( 9191): onDataSetChanged called
D/HabitCompactWidget( 9191): Loading theme data
D/HabitCompactWidget( 9191): Theme loaded - mode: dark, text: ffffffff, bg: ff121212, primary: ff2196f3
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'habits': empty array
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'today_habits': empty array
D/HabitCompactWidget( 9191): No habits data found or empty array (from key: null). Available keys: [habits, home_widget.double.selectedDate, habit_count, home_widget.double.primaryColor, primaryColor, themeMode, selectedDate, home_widget.double.habits, today_habit_count, lastUpdate, last_update, home_widget.double.themeMode, home_widget.double.lastUpdate, today_habits]
D/HabitCompactWidget( 9191): getCount called, returning: 0
W/JobInfo ( 9191): Requested important-while-foreground flag for job310 is ignored and takes no effect
D/WM-SystemJobScheduler( 9191): Scheduling work ID b976ca76-faa5-4dad-be30-61cc96ea1b4aJob ID 310
D/WM-GreedyScheduler( 9191): Starting work for b976ca76-faa5-4dad-be30-61cc96ea1b4a
I/WM-WorkerWrapper( 9191): Work [ id=1db93f20-0cdb-444f-aa9e-5442997722f4, tags={ com.habittracker.habitv8.WidgetUpdateWorker,immediate_widget_update } ] was cancelled
I/WM-WorkerWrapper( 9191): androidx.work.impl.WorkerStoppedException
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkerWrapper.interrupt(WorkerWrapper.kt:348)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.Processor.interrupt(Processor.java:439)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.Processor.stopAndCancelWork(Processor.java:280)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.cancel(CancelWorkRunnable.kt:33)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.forNameInline$lambda$0(CancelWorkRunnable.kt:127)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.$r8$lambda$gmz-7SyxTGDd6CwHjvOsJ11-hcc(Unknown Source:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable$$ExternalSyntheticLambda0.run(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.room.RoomDatabase.runInTransaction(RoomDatabase.kt:585)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.forNameInline(CancelWorkRunnable.kt:123)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueueWorkWithPrerequisites(EnqueueRunnable.java:249)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueueContinuation(EnqueueRunnable.java:136)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.processContinuation(EnqueueRunnable.java:129)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.addToDatabase(EnqueueRunnable.java:93)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueue(EnqueueRunnable.java:74)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkContinuationImpl.lambda$enqueue$0$androidx-work-impl-WorkContinuationImpl(WorkContinuationImpl.java:201)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkContinuationImpl$$ExternalSyntheticLambda0.invoke(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt.launchOperation$lambda$2$lambda$1(Operation.kt:50)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt.$r8$lambda$XKAkIiEN7OgIvwuLUZRQpJhjmyE(Unknown Source:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt$$ExternalSyntheticLambda1.run(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.SerialExecutorImpl$Task.run(SerialExecutorImpl.java:96)
I/WM-WorkerWrapper( 9191):      at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1156)
I/WM-WorkerWrapper( 9191):      at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:651)
I/WM-WorkerWrapper( 9191):      at java.lang.Thread.run(Thread.java:1119)
D/WM-WorkerWrapper( 9191): Status for 1db93f20-0cdb-444f-aa9e-5442997722f4 is null ; not doing any work
D/WM-StopWorkRunnable( 9191): StopWorkRunnable for 1db93f20-0cdb-444f-aa9e-5442997722f4; Processor.stopWork = false
D/WM-StopWorkRunnable( 9191): StopWorkRunnable for 1db93f20-0cdb-444f-aa9e-5442997722f4; Processor.stopWork = false
D/WM-Processor( 9191): Processor: processing WorkGenerationalId(workSpecId=b976ca76-faa5-4dad-be30-61cc96ea1b4a, generation=0)
D/WM-Processor( 9191): Processor 1db93f20-0cdb-444f-aa9e-5442997722f4 executed; reschedule = false
D/WM-SystemJobService( 9191): 1db93f20-0cdb-444f-aa9e-5442997722f4 executed on JobScheduler
D/WM-SystemJobService( 9191): onStartJob for WorkGenerationalId(workSpecId=b976ca76-faa5-4dad-be30-61cc96ea1b4a, generation=0)
D/WM-WorkerWrapper( 9191): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker( 9191): Starting widget update work
D/WidgetUpdateWorker( 9191): Widget data loaded: 2 characters
D/WidgetUpdateWorker( 9191): Skipping habits update - no new data to write (would be empty array)
D/WidgetUpdateWorker( 9191): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker( 9191): Widget data updated from Flutter preferences
D/WM-GreedyScheduler( 9191): Cancelling work ID 1db93f20-0cdb-444f-aa9e-5442997722f4
D/WidgetUpdateWorker( 9191): Updated 1 compact widgets
D/HabitCompactWidget( 9191): onUpdate called with 1 widget IDs
W/HabitCompactWidget( 9191): No habit data found, triggering refresh
D/HabitCompactWidget( 9191): onDataSetChanged called
D/HabitCompactWidget( 9191): Loading theme data
D/HabitCompactWidget( 9191): Theme loaded - mode: dark, text: ffffffff, bg: ff121212, primary: ff2196f3
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'habits': empty array
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'today_habits': empty array
D/HabitCompactWidget( 9191): No habits data found or empty array (from key: null). Available keys: [habits, home_widget.double.selectedDate, habit_count, home_widget.double.primaryColor, primaryColor, themeMode, selectedDate, home_widget.double.habits, today_habit_count, lastUpdate, last_update, home_widget.double.themeMode, home_widget.double.lastUpdate, today_habits]
D/HabitCompactWidget( 9191): getCount called, returning: 0
I/WidgetUpdateWorker( 9191): ✅ Immediate widget update triggered
D/HabitCompactWidget( 9191): ListView setup completed for widget 124 with theme extras: mode=dark, primary=ff2196f3
D/HabitCompactWidget( 9191): Detected theme mode: 'dark'
D/HabitCompactWidget( 9191): Using theme - mode: 'dark', primary: ff2196f3
D/HabitCompactWidget( 9191): Semi-transparent theme applied - isDark: true, bg: 800f0f0f
D/WM-Processor( 9191): Work WorkGenerationalId(workSpecId=b976ca76-faa5-4dad-be30-61cc96ea1b4a, generation=0) is already enqueued for processing
D/HabitCompactWidget( 9191): checkForHabits result: false (from widgetData + HomeWidgetPreferences)
D/WM-Processor( 9191): Processor cancelling b976ca76-faa5-4dad-be30-61cc96ea1b4a
D/HabitCompactWidget( 9191): getCount called, returning: 0
D/WM-Processor( 9191): WorkerWrapper interrupted for b976ca76-faa5-4dad-be30-61cc96ea1b4a
D/HabitCompactWidget( 9191): Widget update completed for ID: 124
I/WidgetUpdateWorker( 9191): ✅ Widget update work completed successfully
D/HabitCompactWidget( 9191): onDataSetChanged called
D/HabitCompactWidget( 9191): Loading theme data
D/HabitCompactWidget( 9191): Theme loaded - mode: dark, text: ffffffff, bg: ff121212, primary: ff2196f3
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'habits': empty array
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'today_habits': empty array
D/HabitCompactWidget( 9191): No habits data found or empty array (from key: null). Available keys: [habits, home_widget.double.selectedDate, habit_count, home_widget.double.primaryColor, primaryColor, themeMode, selectedDate, home_widget.double.habits, today_habit_count, lastUpdate, last_update, home_widget.double.themeMode, home_widget.double.lastUpdate, today_habits]
D/HabitCompactWidget( 9191): getCount called, returning: 0
D/WM-GreedyScheduler( 9191): Cancelling work ID b976ca76-faa5-4dad-be30-61cc96ea1b4a
D/WM-SystemJobService( 9191): onStopJob for WorkGenerationalId(workSpecId=b976ca76-faa5-4dad-be30-61cc96ea1b4a, generation=0)
W/JobInfo ( 9191): Requested important-while-foreground flag for job311 is ignored and takes no effect
D/WM-SystemJobScheduler( 9191): Scheduling work ID c37b7146-5c5f-4112-b4c3-b46caa2a2f40Job ID 311
D/WM-GreedyScheduler( 9191): Starting work for c37b7146-5c5f-4112-b4c3-b46caa2a2f40
I/WM-WorkerWrapper( 9191): Work [ id=b976ca76-faa5-4dad-be30-61cc96ea1b4a, tags={ com.habittracker.habitv8.WidgetUpdateWorker,immediate_widget_update } ] was cancelled
I/WM-WorkerWrapper( 9191): androidx.work.impl.WorkerStoppedException
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkerWrapper.interrupt(WorkerWrapper.kt:348)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.Processor.interrupt(Processor.java:439)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.Processor.stopAndCancelWork(Processor.java:280)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.cancel(CancelWorkRunnable.kt:33)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.forNameInline$lambda$0(CancelWorkRunnable.kt:127)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.$r8$lambda$gmz-7SyxTGDd6CwHjvOsJ11-hcc(Unknown Source:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable$$ExternalSyntheticLambda0.run(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.room.RoomDatabase.runInTransaction(RoomDatabase.kt:585)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.forNameInline(CancelWorkRunnable.kt:123)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueueWorkWithPrerequisites(EnqueueRunnable.java:249)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueueContinuation(EnqueueRunnable.java:136)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.processContinuation(EnqueueRunnable.java:129)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.addToDatabase(EnqueueRunnable.java:93)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueue(EnqueueRunnable.java:74)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkContinuationImpl.lambda$enqueue$0$androidx-work-impl-WorkContinuationImpl(WorkContinuationImpl.java:201)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkContinuationImpl$$ExternalSyntheticLambda0.invoke(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt.launchOperation$lambda$2$lambda$1(Operation.kt:50)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt.$r8$lambda$XKAkIiEN7OgIvwuLUZRQpJhjmyE(Unknown Source:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt$$ExternalSyntheticLambda1.run(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.SerialExecutorImpl$Task.run(SerialExecutorImpl.java:96)
I/WM-WorkerWrapper( 9191):      at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1156)
I/WM-WorkerWrapper( 9191):      at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:651)
I/WM-WorkerWrapper( 9191):      at java.lang.Thread.run(Thread.java:1119)
D/WM-WorkerWrapper( 9191): Status for b976ca76-faa5-4dad-be30-61cc96ea1b4a is null ; not doing any work
D/WM-Processor( 9191): Processor b976ca76-faa5-4dad-be30-61cc96ea1b4a executed; reschedule = false
D/WM-SystemJobService( 9191): b976ca76-faa5-4dad-be30-61cc96ea1b4a executed on JobScheduler
D/WM-SystemJobService( 9191): onStartJob for WorkGenerationalId(workSpecId=c37b7146-5c5f-4112-b4c3-b46caa2a2f40, generation=0)
D/WM-StopWorkRunnable( 9191): StopWorkRunnable for b976ca76-faa5-4dad-be30-61cc96ea1b4a; Processor.stopWork = false
D/WM-StopWorkRunnable( 9191): StopWorkRunnable for b976ca76-faa5-4dad-be30-61cc96ea1b4a; Processor.stopWork = false
D/WM-Processor( 9191): Processor: processing WorkGenerationalId(workSpecId=c37b7146-5c5f-4112-b4c3-b46caa2a2f40, generation=0)
D/WM-GreedyScheduler( 9191): Cancelling work ID b976ca76-faa5-4dad-be30-61cc96ea1b4a
D/WM-Processor( 9191): Work WorkGenerationalId(workSpecId=c37b7146-5c5f-4112-b4c3-b46caa2a2f40, generation=0) is already enqueued for processing
D/WM-WorkerWrapper( 9191): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker( 9191): Starting widget update work
D/WidgetUpdateWorker( 9191): Widget data loaded: 2 characters
D/WidgetUpdateWorker( 9191): Skipping habits update - no new data to write (would be empty array)
D/WidgetUpdateWorker( 9191): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker( 9191): Widget data updated from Flutter preferences
D/WidgetUpdateWorker( 9191): Updated 1 compact widgets
D/HabitCompactWidget( 9191): onUpdate called with 1 widget IDs
W/HabitCompactWidget( 9191): No habit data found, triggering refresh
I/WidgetUpdateWorker( 9191): ✅ Immediate widget update triggered
D/HabitCompactWidget( 9191): onDataSetChanged called
D/HabitCompactWidget( 9191): Loading theme data
D/HabitCompactWidget( 9191): Theme loaded - mode: dark, text: ffffffff, bg: ff121212, primary: ff2196f3
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'habits': empty array
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'today_habits': empty array
D/HabitCompactWidget( 9191): No habits data found or empty array (from key: null). Available keys: [habits, home_widget.double.selectedDate, habit_count, home_widget.double.primaryColor, primaryColor, themeMode, selectedDate, home_widget.double.habits, today_habit_count, lastUpdate, last_update, home_widget.double.themeMode, home_widget.double.lastUpdate, today_habits]
D/HabitCompactWidget( 9191): getCount called, returning: 0
D/WM-Processor( 9191): Processor cancelling c37b7146-5c5f-4112-b4c3-b46caa2a2f40
D/WM-Processor( 9191): WorkerWrapper interrupted for c37b7146-5c5f-4112-b4c3-b46caa2a2f40
D/HabitCompactWidget( 9191): ListView setup completed for widget 124 with theme extras: mode=dark, primary=ff2196f3
D/HabitCompactWidget( 9191): Detected theme mode: 'dark'
D/HabitCompactWidget( 9191): Using theme - mode: 'dark', primary: ff2196f3
D/HabitCompactWidget( 9191): Semi-transparent theme applied - isDark: true, bg: 800f0f0f
D/HabitCompactWidget( 9191): checkForHabits result: false (from widgetData + HomeWidgetPreferences)
D/WM-GreedyScheduler( 9191): Cancelling work ID c37b7146-5c5f-4112-b4c3-b46caa2a2f40
D/WM-SystemJobService( 9191): onStopJob for WorkGenerationalId(workSpecId=c37b7146-5c5f-4112-b4c3-b46caa2a2f40, generation=0)
D/HabitCompactWidget( 9191): getCount called, returning: 0
D/HabitCompactWidget( 9191): Widget update completed for ID: 124
I/WidgetUpdateWorker( 9191): ✅ Widget update work completed successfully
D/HabitCompactWidget( 9191): onDataSetChanged called
D/HabitCompactWidget( 9191): Loading theme data
D/HabitCompactWidget( 9191): Theme loaded - mode: dark, text: ffffffff, bg: ff121212, primary: ff2196f3
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'habits': empty array
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'today_habits': empty array
D/HabitCompactWidget( 9191): No habits data found or empty array (from key: null). Available keys: [habits, home_widget.double.selectedDate, habit_count, home_widget.double.primaryColor, primaryColor, themeMode, selectedDate, home_widget.double.habits, today_habit_count, lastUpdate, last_update, home_widget.double.themeMode, home_widget.double.lastUpdate, today_habits]
D/HabitCompactWidget( 9191): getCount called, returning: 0
W/JobInfo ( 9191): Requested important-while-foreground flag for job312 is ignored and takes no effect
D/WM-SystemJobScheduler( 9191): Scheduling work ID f5e77c09-0214-45fa-b9fd-2206a0cf5192Job ID 312
D/WM-GreedyScheduler( 9191): Starting work for f5e77c09-0214-45fa-b9fd-2206a0cf5192
I/WM-WorkerWrapper( 9191): Work [ id=c37b7146-5c5f-4112-b4c3-b46caa2a2f40, tags={ com.habittracker.habitv8.WidgetUpdateWorker,immediate_widget_update } ] was cancelled
I/WM-WorkerWrapper( 9191): androidx.work.impl.WorkerStoppedException
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkerWrapper.interrupt(WorkerWrapper.kt:348)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.Processor.interrupt(Processor.java:439)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.Processor.stopAndCancelWork(Processor.java:280)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.cancel(CancelWorkRunnable.kt:33)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.forNameInline$lambda$0(CancelWorkRunnable.kt:127)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.$r8$lambda$gmz-7SyxTGDd6CwHjvOsJ11-hcc(Unknown Source:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable$$ExternalSyntheticLambda0.run(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.room.RoomDatabase.runInTransaction(RoomDatabase.kt:585)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.forNameInline(CancelWorkRunnable.kt:123)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueueWorkWithPrerequisites(EnqueueRunnable.java:249)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueueContinuation(EnqueueRunnable.java:136)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.processContinuation(EnqueueRunnable.java:129)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.addToDatabase(EnqueueRunnable.java:93)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueue(EnqueueRunnable.java:74)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkContinuationImpl.lambda$enqueue$0$androidx-work-impl-WorkContinuationImpl(WorkContinuationImpl.java:201)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkContinuationImpl$$ExternalSyntheticLambda0.invoke(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt.launchOperation$lambda$2$lambda$1(Operation.kt:50)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt.$r8$lambda$XKAkIiEN7OgIvwuLUZRQpJhjmyE(Unknown Source:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt$$ExternalSyntheticLambda1.run(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.SerialExecutorImpl$Task.run(SerialExecutorImpl.java:96)
I/WM-WorkerWrapper( 9191):      at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1156)
I/WM-WorkerWrapper( 9191):      at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:651)
I/WM-WorkerWrapper( 9191):      at java.lang.Thread.run(Thread.java:1119)
D/WM-WorkerWrapper( 9191): Status for c37b7146-5c5f-4112-b4c3-b46caa2a2f40 is null ; not doing any work
D/WM-StopWorkRunnable( 9191): StopWorkRunnable for c37b7146-5c5f-4112-b4c3-b46caa2a2f40; Processor.stopWork = false
D/WM-StopWorkRunnable( 9191): StopWorkRunnable for c37b7146-5c5f-4112-b4c3-b46caa2a2f40; Processor.stopWork = false
D/WM-SystemJobService( 9191): onStartJob for WorkGenerationalId(workSpecId=f5e77c09-0214-45fa-b9fd-2206a0cf5192, generation=0)
D/WM-Processor( 9191): Processor c37b7146-5c5f-4112-b4c3-b46caa2a2f40 executed; reschedule = false
D/WM-SystemJobService( 9191): c37b7146-5c5f-4112-b4c3-b46caa2a2f40 executed on JobScheduler
D/WM-Processor( 9191): Processor: processing WorkGenerationalId(workSpecId=f5e77c09-0214-45fa-b9fd-2206a0cf5192, generation=0)
D/WM-Processor( 9191): Work WorkGenerationalId(workSpecId=f5e77c09-0214-45fa-b9fd-2206a0cf5192, generation=0) is already enqueued for processing
D/WM-GreedyScheduler( 9191): Cancelling work ID c37b7146-5c5f-4112-b4c3-b46caa2a2f40
D/WM-WorkerWrapper( 9191): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker( 9191): Starting widget update work
D/WidgetUpdateWorker( 9191): Widget data loaded: 2 characters
D/WidgetUpdateWorker( 9191): Skipping habits update - no new data to write (would be empty array)
D/WidgetUpdateWorker( 9191): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker( 9191): Widget data updated from Flutter preferences
D/HabitCompactWidget( 9191): onDataSetChanged called
D/HabitCompactWidget( 9191): Loading theme data
D/HabitCompactWidget( 9191): Theme loaded - mode: dark, text: ffffffff, bg: ff121212, primary: ff2196f3
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'habits': empty array
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'today_habits': empty array
D/HabitCompactWidget( 9191): No habits data found or empty array (from key: null). Available keys: [habits, home_widget.double.selectedDate, habit_count, home_widget.double.primaryColor, primaryColor, themeMode, selectedDate, home_widget.double.habits, today_habit_count, lastUpdate, last_update, home_widget.double.themeMode, home_widget.double.lastUpdate, today_habits]
D/HabitCompactWidget( 9191): getCount called, returning: 0
D/WidgetUpdateWorker( 9191): Updated 1 compact widgets
D/HabitCompactWidget( 9191): onUpdate called with 1 widget IDs
W/HabitCompactWidget( 9191): No habit data found, triggering refresh
I/WidgetUpdateWorker( 9191): ✅ Immediate widget update triggered
D/HabitCompactWidget( 9191): ListView setup completed for widget 124 with theme extras: mode=dark, primary=ff2196f3
D/HabitCompactWidget( 9191): Detected theme mode: 'dark'
D/HabitCompactWidget( 9191): Using theme - mode: 'dark', primary: ff2196f3
D/HabitCompactWidget( 9191): Semi-transparent theme applied - isDark: true, bg: 800f0f0f
D/HabitCompactWidget( 9191): checkForHabits result: false (from widgetData + HomeWidgetPreferences)
D/WM-Processor( 9191): Processor cancelling f5e77c09-0214-45fa-b9fd-2206a0cf5192
D/WM-Processor( 9191): WorkerWrapper interrupted for f5e77c09-0214-45fa-b9fd-2206a0cf5192
D/HabitCompactWidget( 9191): getCount called, returning: 0
D/HabitCompactWidget( 9191): Widget update completed for ID: 124
I/WidgetUpdateWorker( 9191): ✅ Widget update work completed successfully
D/HabitCompactWidget( 9191): onDataSetChanged called
D/HabitCompactWidget( 9191): Loading theme data
D/HabitCompactWidget( 9191): Theme loaded - mode: dark, text: ffffffff, bg: ff121212, primary: ff2196f3
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'habits': empty array
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'today_habits': empty array
D/HabitCompactWidget( 9191): No habits data found or empty array (from key: null). Available keys: [habits, home_widget.double.selectedDate, habit_count, home_widget.double.primaryColor, primaryColor, themeMode, selectedDate, home_widget.double.habits, today_habit_count, lastUpdate, last_update, home_widget.double.themeMode, home_widget.double.lastUpdate, today_habits]
D/HabitCompactWidget( 9191): getCount called, returning: 0
D/WM-SystemJobService( 9191): onStopJob for WorkGenerationalId(workSpecId=f5e77c09-0214-45fa-b9fd-2206a0cf5192, generation=0)
D/WM-GreedyScheduler( 9191): Cancelling work ID f5e77c09-0214-45fa-b9fd-2206a0cf5192
W/JobInfo ( 9191): Requested important-while-foreground flag for job313 is ignored and takes no effect
D/WM-SystemJobScheduler( 9191): Scheduling work ID 542851fe-ad81-4759-9ccb-ddc36300cd64Job ID 313
D/WM-GreedyScheduler( 9191): Starting work for 542851fe-ad81-4759-9ccb-ddc36300cd64
I/WM-WorkerWrapper( 9191): Work [ id=f5e77c09-0214-45fa-b9fd-2206a0cf5192, tags={ com.habittracker.habitv8.WidgetUpdateWorker,immediate_widget_update } ] was cancelled
I/WM-WorkerWrapper( 9191): androidx.work.impl.WorkerStoppedException
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkerWrapper.interrupt(WorkerWrapper.kt:348)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.Processor.interrupt(Processor.java:439)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.Processor.stopAndCancelWork(Processor.java:280)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.cancel(CancelWorkRunnable.kt:33)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.forNameInline$lambda$0(CancelWorkRunnable.kt:127)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.$r8$lambda$gmz-7SyxTGDd6CwHjvOsJ11-hcc(Unknown Source:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable$$ExternalSyntheticLambda0.run(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.room.RoomDatabase.runInTransaction(RoomDatabase.kt:585)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.forNameInline(CancelWorkRunnable.kt:123)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueueWorkWithPrerequisites(EnqueueRunnable.java:249)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueueContinuation(EnqueueRunnable.java:136)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.processContinuation(EnqueueRunnable.java:129)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.addToDatabase(EnqueueRunnable.java:93)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueue(EnqueueRunnable.java:74)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkContinuationImpl.lambda$enqueue$0$androidx-work-impl-WorkContinuationImpl(WorkContinuationImpl.java:201)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkContinuationImpl$$ExternalSyntheticLambda0.invoke(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt.launchOperation$lambda$2$lambda$1(Operation.kt:50)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt.$r8$lambda$XKAkIiEN7OgIvwuLUZRQpJhjmyE(Unknown Source:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt$$ExternalSyntheticLambda1.run(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.SerialExecutorImpl$Task.run(SerialExecutorImpl.java:96)
I/WM-WorkerWrapper( 9191):      at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1156)
I/WM-WorkerWrapper( 9191):      at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:651)
I/WM-WorkerWrapper( 9191):      at java.lang.Thread.run(Thread.java:1119)
D/WM-SystemJobService( 9191): onStartJob for WorkGenerationalId(workSpecId=542851fe-ad81-4759-9ccb-ddc36300cd64, generation=0)
D/WM-WorkerWrapper( 9191): Status for f5e77c09-0214-45fa-b9fd-2206a0cf5192 is null ; not doing any work
D/WM-StopWorkRunnable( 9191): StopWorkRunnable for f5e77c09-0214-45fa-b9fd-2206a0cf5192; Processor.stopWork = false
D/WM-StopWorkRunnable( 9191): StopWorkRunnable for f5e77c09-0214-45fa-b9fd-2206a0cf5192; Processor.stopWork = false
D/WM-Processor( 9191): Processor f5e77c09-0214-45fa-b9fd-2206a0cf5192 executed; reschedule = false
D/WM-SystemJobService( 9191): f5e77c09-0214-45fa-b9fd-2206a0cf5192 executed on JobScheduler
D/WM-Processor( 9191): Processor: processing WorkGenerationalId(workSpecId=542851fe-ad81-4759-9ccb-ddc36300cd64, generation=0)
D/WM-Processor( 9191): Work WorkGenerationalId(workSpecId=542851fe-ad81-4759-9ccb-ddc36300cd64, generation=0) is already enqueued for processing
D/WM-GreedyScheduler( 9191): Cancelling work ID f5e77c09-0214-45fa-b9fd-2206a0cf5192
D/WM-WorkerWrapper( 9191): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker( 9191): Starting widget update work
D/WidgetUpdateWorker( 9191): Widget data loaded: 2 characters
D/WidgetUpdateWorker( 9191): Skipping habits update - no new data to write (would be empty array)
D/WidgetUpdateWorker( 9191): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker( 9191): Widget data updated from Flutter preferences
D/WidgetUpdateWorker( 9191): Updated 1 compact widgets
D/HabitCompactWidget( 9191): onUpdate called with 1 widget IDs
W/HabitCompactWidget( 9191): No habit data found, triggering refresh
D/HabitCompactWidget( 9191): onDataSetChanged called
D/HabitCompactWidget( 9191): Loading theme data
D/HabitCompactWidget( 9191): Theme loaded - mode: dark, text: ffffffff, bg: ff121212, primary: ff2196f3
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'habits': empty array
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'today_habits': empty array
D/HabitCompactWidget( 9191): No habits data found or empty array (from key: null). Available keys: [habits, home_widget.double.selectedDate, habit_count, home_widget.double.primaryColor, primaryColor, themeMode, selectedDate, home_widget.double.habits, today_habit_count, lastUpdate, last_update, home_widget.double.themeMode, home_widget.double.lastUpdate, today_habits]
D/HabitCompactWidget( 9191): getCount called, returning: 0
D/WM-Processor( 9191): Processor cancelling 542851fe-ad81-4759-9ccb-ddc36300cd64
D/WM-Processor( 9191): WorkerWrapper interrupted for 542851fe-ad81-4759-9ccb-ddc36300cd64
I/WidgetUpdateWorker( 9191): ✅ Immediate widget update triggered
D/HabitCompactWidget( 9191): ListView setup completed for widget 124 with theme extras: mode=dark, primary=ff2196f3
D/HabitCompactWidget( 9191): Detected theme mode: 'dark'
D/HabitCompactWidget( 9191): Using theme - mode: 'dark', primary: ff2196f3
D/HabitCompactWidget( 9191): Semi-transparent theme applied - isDark: true, bg: 800f0f0f
D/WM-GreedyScheduler( 9191): Cancelling work ID 542851fe-ad81-4759-9ccb-ddc36300cd64
D/WM-SystemJobService( 9191): onStopJob for WorkGenerationalId(workSpecId=542851fe-ad81-4759-9ccb-ddc36300cd64, generation=0)
D/HabitCompactWidget( 9191): checkForHabits result: false (from widgetData + HomeWidgetPreferences)
D/HabitCompactWidget( 9191): getCount called, returning: 0
D/HabitCompactWidget( 9191): Widget update completed for ID: 124
I/WidgetUpdateWorker( 9191): ✅ Widget update work completed successfully
D/HabitCompactWidget( 9191): onDataSetChanged called
D/HabitCompactWidget( 9191): Loading theme data
D/HabitCompactWidget( 9191): Theme loaded - mode: dark, text: ffffffff, bg: ff121212, primary: ff2196f3
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'habits': empty array
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'today_habits': empty array
D/HabitCompactWidget( 9191): No habits data found or empty array (from key: null). Available keys: [habits, home_widget.double.selectedDate, habit_count, home_widget.double.primaryColor, primaryColor, themeMode, selectedDate, home_widget.double.habits, today_habit_count, lastUpdate, last_update, home_widget.double.themeMode, home_widget.double.lastUpdate, today_habits]
D/HabitCompactWidget( 9191): getCount called, returning: 0
W/JobInfo ( 9191): Requested important-while-foreground flag for job314 is ignored and takes no effect
D/WM-SystemJobScheduler( 9191): Scheduling work ID cd81dc2b-816e-401c-9bf8-805d440b7f7bJob ID 314
D/WM-GreedyScheduler( 9191): Starting work for cd81dc2b-816e-401c-9bf8-805d440b7f7b
I/WM-WorkerWrapper( 9191): Work [ id=542851fe-ad81-4759-9ccb-ddc36300cd64, tags={ com.habittracker.habitv8.WidgetUpdateWorker,immediate_widget_update } ] was cancelled
I/WM-WorkerWrapper( 9191): androidx.work.impl.WorkerStoppedException
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkerWrapper.interrupt(WorkerWrapper.kt:348)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.Processor.interrupt(Processor.java:439)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.Processor.stopAndCancelWork(Processor.java:280)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.cancel(CancelWorkRunnable.kt:33)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.forNameInline$lambda$0(CancelWorkRunnable.kt:127)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.$r8$lambda$gmz-7SyxTGDd6CwHjvOsJ11-hcc(Unknown Source:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable$$ExternalSyntheticLambda0.run(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.room.RoomDatabase.runInTransaction(RoomDatabase.kt:585)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.forNameInline(CancelWorkRunnable.kt:123)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueueWorkWithPrerequisites(EnqueueRunnable.java:249)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueueContinuation(EnqueueRunnable.java:136)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.processContinuation(EnqueueRunnable.java:129)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.addToDatabase(EnqueueRunnable.java:93)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueue(EnqueueRunnable.java:74)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkContinuationImpl.lambda$enqueue$0$androidx-work-impl-WorkContinuationImpl(WorkContinuationImpl.java:201)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkContinuationImpl$$ExternalSyntheticLambda0.invoke(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt.launchOperation$lambda$2$lambda$1(Operation.kt:50)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt.$r8$lambda$XKAkIiEN7OgIvwuLUZRQpJhjmyE(Unknown Source:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt$$ExternalSyntheticLambda1.run(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.SerialExecutorImpl$Task.run(SerialExecutorImpl.java:96)
I/WM-WorkerWrapper( 9191):      at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1156)
I/WM-WorkerWrapper( 9191):      at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:651)
I/WM-WorkerWrapper( 9191):      at java.lang.Thread.run(Thread.java:1119)
D/WM-WorkerWrapper( 9191): Status for 542851fe-ad81-4759-9ccb-ddc36300cd64 is null ; not doing any work
D/WM-StopWorkRunnable( 9191): StopWorkRunnable for 542851fe-ad81-4759-9ccb-ddc36300cd64; Processor.stopWork = false
D/WM-StopWorkRunnable( 9191): StopWorkRunnable for 542851fe-ad81-4759-9ccb-ddc36300cd64; Processor.stopWork = false
D/WM-Processor( 9191): Processor 542851fe-ad81-4759-9ccb-ddc36300cd64 executed; reschedule = false
D/WM-SystemJobService( 9191): 542851fe-ad81-4759-9ccb-ddc36300cd64 executed on JobScheduler
D/WM-SystemJobService( 9191): onStartJob for WorkGenerationalId(workSpecId=cd81dc2b-816e-401c-9bf8-805d440b7f7b, generation=0)
D/WM-Processor( 9191): Processor: processing WorkGenerationalId(workSpecId=cd81dc2b-816e-401c-9bf8-805d440b7f7b, generation=0)
D/WM-GreedyScheduler( 9191): Cancelling work ID 542851fe-ad81-4759-9ccb-ddc36300cd64
D/WM-WorkerWrapper( 9191): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker( 9191): Starting widget update work
D/WidgetUpdateWorker( 9191): Widget data loaded: 2 characters
D/WidgetUpdateWorker( 9191): Skipping habits update - no new data to write (would be empty array)
D/WidgetUpdateWorker( 9191): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker( 9191): Widget data updated from Flutter preferences
D/WM-Processor( 9191): Work WorkGenerationalId(workSpecId=cd81dc2b-816e-401c-9bf8-805d440b7f7b, generation=0) is already enqueued for processing
D/WidgetUpdateWorker( 9191): Updated 1 compact widgets
D/HabitCompactWidget( 9191): onUpdate called with 1 widget IDs
W/HabitCompactWidget( 9191): No habit data found, triggering refresh
D/HabitCompactWidget( 9191): onDataSetChanged called
D/HabitCompactWidget( 9191): Loading theme data
D/HabitCompactWidget( 9191): Theme loaded - mode: dark, text: ffffffff, bg: ff121212, primary: ff2196f3
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'habits': empty array
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'today_habits': empty array
D/HabitCompactWidget( 9191): No habits data found or empty array (from key: null). Available keys: [habits, home_widget.double.selectedDate, habit_count, home_widget.double.primaryColor, primaryColor, themeMode, selectedDate, home_widget.double.habits, today_habit_count, lastUpdate, last_update, home_widget.double.themeMode, home_widget.double.lastUpdate, today_habits]
D/HabitCompactWidget( 9191): getCount called, returning: 0
I/WidgetUpdateWorker( 9191): ✅ Immediate widget update triggered
D/WM-Processor( 9191): Processor cancelling cd81dc2b-816e-401c-9bf8-805d440b7f7b
D/HabitCompactWidget( 9191): ListView setup completed for widget 124 with theme extras: mode=dark, primary=ff2196f3
D/HabitCompactWidget( 9191): Detected theme mode: 'dark'
D/HabitCompactWidget( 9191): Using theme - mode: 'dark', primary: ff2196f3
D/HabitCompactWidget( 9191): Semi-transparent theme applied - isDark: true, bg: 800f0f0f
D/WM-Processor( 9191): WorkerWrapper interrupted for cd81dc2b-816e-401c-9bf8-805d440b7f7b
D/HabitCompactWidget( 9191): checkForHabits result: false (from widgetData + HomeWidgetPreferences)
D/WM-GreedyScheduler( 9191): Cancelling work ID cd81dc2b-816e-401c-9bf8-805d440b7f7b
D/WM-SystemJobService( 9191): onStopJob for WorkGenerationalId(workSpecId=cd81dc2b-816e-401c-9bf8-805d440b7f7b, generation=0)
D/HabitCompactWidget( 9191): getCount called, returning: 0
D/HabitCompactWidget( 9191): Widget update completed for ID: 124
I/WidgetUpdateWorker( 9191): ✅ Widget update work completed successfully
D/HabitCompactWidget( 9191): onDataSetChanged called
D/HabitCompactWidget( 9191): Loading theme data
D/HabitCompactWidget( 9191): Theme loaded - mode: dark, text: ffffffff, bg: ff121212, primary: ff2196f3
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'habits': empty array
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'today_habits': empty array
D/HabitCompactWidget( 9191): No habits data found or empty array (from key: null). Available keys: [habits, home_widget.double.selectedDate, habit_count, home_widget.double.primaryColor, primaryColor, themeMode, selectedDate, home_widget.double.habits, today_habit_count, lastUpdate, last_update, home_widget.double.themeMode, home_widget.double.lastUpdate, today_habits]
D/HabitCompactWidget( 9191): getCount called, returning: 0
W/JobInfo ( 9191): Requested important-while-foreground flag for job315 is ignored and takes no effect
D/WM-SystemJobScheduler( 9191): Scheduling work ID d08a116e-77ee-4aa8-860f-d4f61f246619Job ID 315
D/WM-GreedyScheduler( 9191): Starting work for d08a116e-77ee-4aa8-860f-d4f61f246619
I/WM-WorkerWrapper( 9191): Work [ id=cd81dc2b-816e-401c-9bf8-805d440b7f7b, tags={ com.habittracker.habitv8.WidgetUpdateWorker,immediate_widget_update } ] was cancelled
I/WM-WorkerWrapper( 9191): androidx.work.impl.WorkerStoppedException
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkerWrapper.interrupt(WorkerWrapper.kt:348)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.Processor.interrupt(Processor.java:439)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.Processor.stopAndCancelWork(Processor.java:280)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.cancel(CancelWorkRunnable.kt:33)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.forNameInline$lambda$0(CancelWorkRunnable.kt:127)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.$r8$lambda$gmz-7SyxTGDd6CwHjvOsJ11-hcc(Unknown Source:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable$$ExternalSyntheticLambda0.run(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.room.RoomDatabase.runInTransaction(RoomDatabase.kt:585)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.forNameInline(CancelWorkRunnable.kt:123)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueueWorkWithPrerequisites(EnqueueRunnable.java:249)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueueContinuation(EnqueueRunnable.java:136)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.processContinuation(EnqueueRunnable.java:129)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.addToDatabase(EnqueueRunnable.java:93)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueue(EnqueueRunnable.java:74)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkContinuationImpl.lambda$enqueue$0$androidx-work-impl-WorkContinuationImpl(WorkContinuationImpl.java:201)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkContinuationImpl$$ExternalSyntheticLambda0.invoke(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt.launchOperation$lambda$2$lambda$1(Operation.kt:50)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt.$r8$lambda$XKAkIiEN7OgIvwuLUZRQpJhjmyE(Unknown Source:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt$$ExternalSyntheticLambda1.run(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.SerialExecutorImpl$Task.run(SerialExecutorImpl.java:96)
I/WM-WorkerWrapper( 9191):      at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1156)
I/WM-WorkerWrapper( 9191):      at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:651)
I/WM-WorkerWrapper( 9191):      at java.lang.Thread.run(Thread.java:1119)
D/WM-SystemJobService( 9191): onStartJob for WorkGenerationalId(workSpecId=d08a116e-77ee-4aa8-860f-d4f61f246619, generation=0)
D/WM-WorkerWrapper( 9191): Status for cd81dc2b-816e-401c-9bf8-805d440b7f7b is null ; not doing any work
D/WM-Processor( 9191): Processor cd81dc2b-816e-401c-9bf8-805d440b7f7b executed; reschedule = false
D/WM-SystemJobService( 9191): cd81dc2b-816e-401c-9bf8-805d440b7f7b executed on JobScheduler
D/WM-StopWorkRunnable( 9191): StopWorkRunnable for cd81dc2b-816e-401c-9bf8-805d440b7f7b; Processor.stopWork = false
D/WM-StopWorkRunnable( 9191): StopWorkRunnable for cd81dc2b-816e-401c-9bf8-805d440b7f7b; Processor.stopWork = false
D/WM-Processor( 9191): Processor: processing WorkGenerationalId(workSpecId=d08a116e-77ee-4aa8-860f-d4f61f246619, generation=0)
D/WM-Processor( 9191): Work WorkGenerationalId(workSpecId=d08a116e-77ee-4aa8-860f-d4f61f246619, generation=0) is already enqueued for processing
D/WM-GreedyScheduler( 9191): Cancelling work ID cd81dc2b-816e-401c-9bf8-805d440b7f7b
D/WM-WorkerWrapper( 9191): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker( 9191): Starting widget update work
D/WidgetUpdateWorker( 9191): Widget data loaded: 2 characters
D/WidgetUpdateWorker( 9191): Skipping habits update - no new data to write (would be empty array)
D/WidgetUpdateWorker( 9191): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker( 9191): Widget data updated from Flutter preferences
D/WidgetUpdateWorker( 9191): Updated 1 compact widgets
D/HabitCompactWidget( 9191): onUpdate called with 1 widget IDs
W/HabitCompactWidget( 9191): No habit data found, triggering refresh
D/HabitCompactWidget( 9191): onDataSetChanged called
D/HabitCompactWidget( 9191): Loading theme data
D/HabitCompactWidget( 9191): Theme loaded - mode: dark, text: ffffffff, bg: ff121212, primary: ff2196f3
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'habits': empty array
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'today_habits': empty array
D/HabitCompactWidget( 9191): No habits data found or empty array (from key: null). Available keys: [habits, home_widget.double.selectedDate, habit_count, home_widget.double.primaryColor, primaryColor, themeMode, selectedDate, home_widget.double.habits, today_habit_count, lastUpdate, last_update, home_widget.double.themeMode, home_widget.double.lastUpdate, today_habits]
D/HabitCompactWidget( 9191): getCount called, returning: 0
I/WidgetUpdateWorker( 9191): ✅ Immediate widget update triggered
D/HabitCompactWidget( 9191): ListView setup completed for widget 124 with theme extras: mode=dark, primary=ff2196f3
D/HabitCompactWidget( 9191): Detected theme mode: 'dark'
D/HabitCompactWidget( 9191): Using theme - mode: 'dark', primary: ff2196f3
D/HabitCompactWidget( 9191): Semi-transparent theme applied - isDark: true, bg: 800f0f0f
D/WM-Processor( 9191): Processor cancelling d08a116e-77ee-4aa8-860f-d4f61f246619
D/HabitCompactWidget( 9191): checkForHabits result: false (from widgetData + HomeWidgetPreferences)
D/WM-Processor( 9191): WorkerWrapper interrupted for d08a116e-77ee-4aa8-860f-d4f61f246619
D/WM-GreedyScheduler( 9191): Cancelling work ID d08a116e-77ee-4aa8-860f-d4f61f246619
D/WM-SystemJobService( 9191): onStopJob for WorkGenerationalId(workSpecId=d08a116e-77ee-4aa8-860f-d4f61f246619, generation=0)
D/HabitCompactWidget( 9191): Widget update completed for ID: 124
I/WidgetUpdateWorker( 9191): ✅ Widget update work completed successfully
D/HabitCompactWidget( 9191): getCount called, returning: 0
W/JobInfo ( 9191): Requested important-while-foreground flag for job316 is ignored and takes no effect
D/WM-SystemJobScheduler( 9191): Scheduling work ID 9bdbbd94-9dc7-4a3c-9d81-2e62c03cd4fcJob ID 316
D/HabitCompactWidget( 9191): onDataSetChanged called
D/HabitCompactWidget( 9191): Loading theme data
D/HabitCompactWidget( 9191): Theme loaded - mode: dark, text: ffffffff, bg: ff121212, primary: ff2196f3
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'habits': empty array
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'today_habits': empty array
D/HabitCompactWidget( 9191): No habits data found or empty array (from key: null). Available keys: [habits, home_widget.double.selectedDate, habit_count, home_widget.double.primaryColor, primaryColor, themeMode, selectedDate, home_widget.double.habits, today_habit_count, lastUpdate, last_update, home_widget.double.themeMode, home_widget.double.lastUpdate, today_habits]
D/HabitCompactWidget( 9191): getCount called, returning: 0
D/WM-GreedyScheduler( 9191): Starting work for 9bdbbd94-9dc7-4a3c-9d81-2e62c03cd4fc
I/WM-WorkerWrapper( 9191): Work [ id=d08a116e-77ee-4aa8-860f-d4f61f246619, tags={ com.habittracker.habitv8.WidgetUpdateWorker,immediate_widget_update } ] was cancelled
I/WM-WorkerWrapper( 9191): androidx.work.impl.WorkerStoppedException
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkerWrapper.interrupt(WorkerWrapper.kt:348)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.Processor.interrupt(Processor.java:439)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.Processor.stopAndCancelWork(Processor.java:280)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.cancel(CancelWorkRunnable.kt:33)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.forNameInline$lambda$0(CancelWorkRunnable.kt:127)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.$r8$lambda$gmz-7SyxTGDd6CwHjvOsJ11-hcc(Unknown Source:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable$$ExternalSyntheticLambda0.run(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.room.RoomDatabase.runInTransaction(RoomDatabase.kt:585)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.forNameInline(CancelWorkRunnable.kt:123)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueueWorkWithPrerequisites(EnqueueRunnable.java:249)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueueContinuation(EnqueueRunnable.java:136)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.processContinuation(EnqueueRunnable.java:129)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.addToDatabase(EnqueueRunnable.java:93)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueue(EnqueueRunnable.java:74)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkContinuationImpl.lambda$enqueue$0$androidx-work-impl-WorkContinuationImpl(WorkContinuationImpl.java:201)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkContinuationImpl$$ExternalSyntheticLambda0.invoke(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt.launchOperation$lambda$2$lambda$1(Operation.kt:50)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt.$r8$lambda$XKAkIiEN7OgIvwuLUZRQpJhjmyE(Unknown Source:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt$$ExternalSyntheticLambda1.run(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.SerialExecutorImpl$Task.run(SerialExecutorImpl.java:96)
I/WM-WorkerWrapper( 9191):      at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1156)
I/WM-WorkerWrapper( 9191):      at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:651)
I/WM-WorkerWrapper( 9191):      at java.lang.Thread.run(Thread.java:1119)
D/WM-WorkerWrapper( 9191): Status for d08a116e-77ee-4aa8-860f-d4f61f246619 is null ; not doing any work
D/WM-StopWorkRunnable( 9191): StopWorkRunnable for d08a116e-77ee-4aa8-860f-d4f61f246619; Processor.stopWork = false
D/WM-StopWorkRunnable( 9191): StopWorkRunnable for d08a116e-77ee-4aa8-860f-d4f61f246619; Processor.stopWork = false
D/WM-SystemJobService( 9191): onStartJob for WorkGenerationalId(workSpecId=9bdbbd94-9dc7-4a3c-9d81-2e62c03cd4fc, generation=0)
D/WM-Processor( 9191): Processor d08a116e-77ee-4aa8-860f-d4f61f246619 executed; reschedule = false
D/WM-SystemJobService( 9191): d08a116e-77ee-4aa8-860f-d4f61f246619 executed on JobScheduler
D/WM-Processor( 9191): Processor: processing WorkGenerationalId(workSpecId=9bdbbd94-9dc7-4a3c-9d81-2e62c03cd4fc, generation=0)
D/WM-Processor( 9191): Work WorkGenerationalId(workSpecId=9bdbbd94-9dc7-4a3c-9d81-2e62c03cd4fc, generation=0) is already enqueued for processing
D/WM-GreedyScheduler( 9191): Cancelling work ID d08a116e-77ee-4aa8-860f-d4f61f246619
D/WM-WorkerWrapper( 9191): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker( 9191): Starting widget update work
D/WidgetUpdateWorker( 9191): Widget data loaded: 2 characters
D/WidgetUpdateWorker( 9191): Skipping habits update - no new data to write (would be empty array)
D/WidgetUpdateWorker( 9191): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker( 9191): Widget data updated from Flutter preferences
D/WidgetUpdateWorker( 9191): Updated 1 compact widgets
D/HabitCompactWidget( 9191): onDataSetChanged called
D/HabitCompactWidget( 9191): Loading theme data
D/HabitCompactWidget( 9191): Theme loaded - mode: dark, text: ffffffff, bg: ff121212, primary: ff2196f3
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'habits': empty array
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'today_habits': empty array
D/HabitCompactWidget( 9191): No habits data found or empty array (from key: null). Available keys: [habits, home_widget.double.selectedDate, habit_count, home_widget.double.primaryColor, primaryColor, themeMode, selectedDate, home_widget.double.habits, today_habit_count, lastUpdate, last_update, home_widget.double.themeMode, home_widget.double.lastUpdate, today_habits]
D/HabitCompactWidget( 9191): getCount called, returning: 0
D/HabitCompactWidget( 9191): onUpdate called with 1 widget IDs
W/HabitCompactWidget( 9191): No habit data found, triggering refresh
I/WidgetUpdateWorker( 9191): ✅ Immediate widget update triggered
D/HabitCompactWidget( 9191): ListView setup completed for widget 124 with theme extras: mode=dark, primary=ff2196f3
D/HabitCompactWidget( 9191): Detected theme mode: 'dark'
D/HabitCompactWidget( 9191): Using theme - mode: 'dark', primary: ff2196f3
D/HabitCompactWidget( 9191): Semi-transparent theme applied - isDark: true, bg: 800f0f0f
D/WM-Processor( 9191): Processor cancelling 9bdbbd94-9dc7-4a3c-9d81-2e62c03cd4fc
D/WM-Processor( 9191): WorkerWrapper interrupted for 9bdbbd94-9dc7-4a3c-9d81-2e62c03cd4fc
D/HabitCompactWidget( 9191): checkForHabits result: false (from widgetData + HomeWidgetPreferences)
D/WM-GreedyScheduler( 9191): Cancelling work ID 9bdbbd94-9dc7-4a3c-9d81-2e62c03cd4fc
D/WM-SystemJobService( 9191): onStopJob for WorkGenerationalId(workSpecId=9bdbbd94-9dc7-4a3c-9d81-2e62c03cd4fc, generation=0)
D/HabitCompactWidget( 9191): getCount called, returning: 0
D/HabitCompactWidget( 9191): Widget update completed for ID: 124
I/WidgetUpdateWorker( 9191): ✅ Widget update work completed successfully
D/HabitCompactWidget( 9191): onDataSetChanged called
D/HabitCompactWidget( 9191): Loading theme data
D/HabitCompactWidget( 9191): Theme loaded - mode: dark, text: ffffffff, bg: ff121212, primary: ff2196f3
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'habits': empty array
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'today_habits': empty array
D/HabitCompactWidget( 9191): No habits data found or empty array (from key: null). Available keys: [habits, home_widget.double.selectedDate, habit_count, home_widget.double.primaryColor, primaryColor, themeMode, selectedDate, home_widget.double.habits, today_habit_count, lastUpdate, last_update, home_widget.double.themeMode, home_widget.double.lastUpdate, today_habits]
D/HabitCompactWidget( 9191): getCount called, returning: 0
W/JobInfo ( 9191): Requested important-while-foreground flag for job317 is ignored and takes no effect
D/WM-SystemJobScheduler( 9191): Scheduling work ID 24d341b3-1e65-4e2c-9571-e4790fc24d18Job ID 317
D/WM-SystemJobService( 9191): onStartJob for WorkGenerationalId(workSpecId=24d341b3-1e65-4e2c-9571-e4790fc24d18, generation=0)
D/WM-GreedyScheduler( 9191): Starting work for 24d341b3-1e65-4e2c-9571-e4790fc24d18
I/WM-WorkerWrapper( 9191): Work [ id=9bdbbd94-9dc7-4a3c-9d81-2e62c03cd4fc, tags={ com.habittracker.habitv8.WidgetUpdateWorker,immediate_widget_update } ] was cancelled
I/WM-WorkerWrapper( 9191): androidx.work.impl.WorkerStoppedException
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkerWrapper.interrupt(WorkerWrapper.kt:348)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.Processor.interrupt(Processor.java:439)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.Processor.stopAndCancelWork(Processor.java:280)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.cancel(CancelWorkRunnable.kt:33)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.forNameInline$lambda$0(CancelWorkRunnable.kt:127)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.$r8$lambda$gmz-7SyxTGDd6CwHjvOsJ11-hcc(Unknown Source:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable$$ExternalSyntheticLambda0.run(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.room.RoomDatabase.runInTransaction(RoomDatabase.kt:585)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.forNameInline(CancelWorkRunnable.kt:123)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueueWorkWithPrerequisites(EnqueueRunnable.java:249)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueueContinuation(EnqueueRunnable.java:136)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.processContinuation(EnqueueRunnable.java:129)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.addToDatabase(EnqueueRunnable.java:93)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueue(EnqueueRunnable.java:74)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkContinuationImpl.lambda$enqueue$0$androidx-work-impl-WorkContinuationImpl(WorkContinuationImpl.java:201)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkContinuationImpl$$ExternalSyntheticLambda0.invoke(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt.launchOperation$lambda$2$lambda$1(Operation.kt:50)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt.$r8$lambda$XKAkIiEN7OgIvwuLUZRQpJhjmyE(Unknown Source:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt$$ExternalSyntheticLambda1.run(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.SerialExecutorImpl$Task.run(SerialExecutorImpl.java:96)
I/WM-WorkerWrapper( 9191):      at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1156)
I/WM-WorkerWrapper( 9191):      at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:651)
I/WM-WorkerWrapper( 9191):      at java.lang.Thread.run(Thread.java:1119)
D/WM-WorkerWrapper( 9191): Status for 9bdbbd94-9dc7-4a3c-9d81-2e62c03cd4fc is null ; not doing any work
D/WM-StopWorkRunnable( 9191): StopWorkRunnable for 9bdbbd94-9dc7-4a3c-9d81-2e62c03cd4fc; Processor.stopWork = false
D/WM-StopWorkRunnable( 9191): StopWorkRunnable for 9bdbbd94-9dc7-4a3c-9d81-2e62c03cd4fc; Processor.stopWork = false
D/WM-Processor( 9191): Processor 9bdbbd94-9dc7-4a3c-9d81-2e62c03cd4fc executed; reschedule = false
D/WM-SystemJobService( 9191): 9bdbbd94-9dc7-4a3c-9d81-2e62c03cd4fc executed on JobScheduler
D/WM-Processor( 9191): Processor: processing WorkGenerationalId(workSpecId=24d341b3-1e65-4e2c-9571-e4790fc24d18, generation=0)
D/WM-Processor( 9191): Work WorkGenerationalId(workSpecId=24d341b3-1e65-4e2c-9571-e4790fc24d18, generation=0) is already enqueued for processing
D/WM-GreedyScheduler( 9191): Cancelling work ID 9bdbbd94-9dc7-4a3c-9d81-2e62c03cd4fc
D/WM-WorkerWrapper( 9191): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker( 9191): Starting widget update work
D/WidgetUpdateWorker( 9191): Widget data loaded: 2 characters
D/WidgetUpdateWorker( 9191): Skipping habits update - no new data to write (would be empty array)
D/WidgetUpdateWorker( 9191): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker( 9191): Widget data updated from Flutter preferences
D/WidgetUpdateWorker( 9191): Updated 1 compact widgets
D/HabitCompactWidget( 9191): onUpdate called with 1 widget IDs
W/HabitCompactWidget( 9191): No habit data found, triggering refresh
D/HabitCompactWidget( 9191): onDataSetChanged called
D/HabitCompactWidget( 9191): Loading theme data
D/HabitCompactWidget( 9191): Theme loaded - mode: dark, text: ffffffff, bg: ff121212, primary: ff2196f3
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'habits': empty array
I/WidgetUpdateWorker( 9191): ✅ Immediate widget update triggered
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'today_habits': empty array
D/HabitCompactWidget( 9191): No habits data found or empty array (from key: null). Available keys: [habits, home_widget.double.selectedDate, habit_count, home_widget.double.primaryColor, primaryColor, themeMode, selectedDate, home_widget.double.habits, today_habit_count, lastUpdate, last_update, home_widget.double.themeMode, home_widget.double.lastUpdate, today_habits]
D/HabitCompactWidget( 9191): getCount called, returning: 0
D/HabitCompactWidget( 9191): ListView setup completed for widget 124 with theme extras: mode=dark, primary=ff2196f3
D/HabitCompactWidget( 9191): Detected theme mode: 'dark'
D/HabitCompactWidget( 9191): Using theme - mode: 'dark', primary: ff2196f3
D/HabitCompactWidget( 9191): Semi-transparent theme applied - isDark: true, bg: 800f0f0f
D/WM-Processor( 9191): Processor cancelling 24d341b3-1e65-4e2c-9571-e4790fc24d18
D/HabitCompactWidget( 9191): checkForHabits result: false (from widgetData + HomeWidgetPreferences)
D/WM-Processor( 9191): WorkerWrapper interrupted for 24d341b3-1e65-4e2c-9571-e4790fc24d18
D/HabitCompactWidget( 9191): getCount called, returning: 0
D/HabitCompactWidget( 9191): Widget update completed for ID: 124
I/WidgetUpdateWorker( 9191): ✅ Widget update work completed successfully
D/WM-GreedyScheduler( 9191): Cancelling work ID 24d341b3-1e65-4e2c-9571-e4790fc24d18
D/WM-SystemJobService( 9191): onStopJob for WorkGenerationalId(workSpecId=24d341b3-1e65-4e2c-9571-e4790fc24d18, generation=0)
D/HabitCompactWidget( 9191): onDataSetChanged called
D/HabitCompactWidget( 9191): Loading theme data
D/HabitCompactWidget( 9191): Theme loaded - mode: dark, text: ffffffff, bg: ff121212, primary: ff2196f3
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'habits': empty array
D/HabitCompactWidget( 9191): ⏭️ Skipping key 'today_habits': empty array
D/HabitCompactWidget( 9191): No habits data found or empty array (from key: null). Available keys: [habits, home_widget.double.selectedDate, habit_count, home_widget.double.primaryColor, primaryColor, themeMode, selectedDate, home_widget.double.habits, today_habit_count, lastUpdate, last_update, home_widget.double.themeMode, home_widget.double.lastUpdate, today_habits]
D/HabitCompactWidget( 9191): getCount called, returning: 0
W/JobInfo ( 9191): Requested important-while-foreground flag for job318 is ignored and takes no effect
D/WM-SystemJobScheduler( 9191): Scheduling work ID 06c5cff6-1659-47ea-b20f-fe0d848e9fc6Job ID 318
D/WM-GreedyScheduler( 9191): Starting work for 06c5cff6-1659-47ea-b20f-fe0d848e9fc6
I/WM-WorkerWrapper( 9191): Work [ id=24d341b3-1e65-4e2c-9571-e4790fc24d18, tags={ com.habittracker.habitv8.WidgetUpdateWorker,immediate_widget_update } ] was cancelled
I/WM-WorkerWrapper( 9191): androidx.work.impl.WorkerStoppedException
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkerWrapper.interrupt(WorkerWrapper.kt:348)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.Processor.interrupt(Processor.java:439)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.Processor.stopAndCancelWork(Processor.java:280)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.cancel(CancelWorkRunnable.kt:33)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.forNameInline$lambda$0(CancelWorkRunnable.kt:127)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.$r8$lambda$gmz-7SyxTGDd6CwHjvOsJ11-hcc(Unknown Source:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable$$ExternalSyntheticLambda0.run(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.room.RoomDatabase.runInTransaction(RoomDatabase.kt:585)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.CancelWorkRunnable.forNameInline(CancelWorkRunnable.kt:123)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueueWorkWithPrerequisites(EnqueueRunnable.java:249)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueueContinuation(EnqueueRunnable.java:136)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.processContinuation(EnqueueRunnable.java:129)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.addToDatabase(EnqueueRunnable.java:93)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.EnqueueRunnable.enqueue(EnqueueRunnable.java:74)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkContinuationImpl.lambda$enqueue$0$androidx-work-impl-WorkContinuationImpl(WorkContinuationImpl.java:201)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.WorkContinuationImpl$$ExternalSyntheticLambda0.invoke(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt.launchOperation$lambda$2$lambda$1(Operation.kt:50)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt.$r8$lambda$XKAkIiEN7OgIvwuLUZRQpJhjmyE(Unknown Source:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.OperationKt$$ExternalSyntheticLambda1.run(D8$$SyntheticClass:0)
I/WM-WorkerWrapper( 9191):      at androidx.work.impl.utils.SerialExecutorImpl$Task.run(SerialExecutorImpl.java:96)
I/WM-WorkerWrapper( 9191):      at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1156)
I/WM-WorkerWrapper( 9191):      at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:651)
I/WM-WorkerWrapper( 9191):      at java.lang.Thread.run(Thread.java:1119)
D/WM-WorkerWrapper( 9191): Status for 24d341b3-1e65-4e2c-9571-e4790fc24d18 is null ; not doing any work
D/WM-StopWorkRunnable( 9191): StopWorkRunnable for 24d341b3-1e65-4e2c-9571-e4790fc24d18; Processor.stopWork = false
D/WM-Processor( 9191): Processor 24d341b3-1e65-4e2c-9571-e4790fc24d18 executed; reschedule = false
D/WM-SystemJobService( 9191): 24d341b3-1e65-4e2c-9571-e4790fc24d18 executed on JobScheduler
D/WM-StopWorkRunnable( 9191): StopWorkRunnable for 24d341b3-1e65-4e2c-9571-e4790fc24d18; Processor.stopWork = false
D/WM-SystemJobService( 9191): onStartJob for WorkGenerationalId(workSpecId=06c5cff6-1659-47ea-b20f-fe0d848e9fc6, generation=0)
D/WM-Processor( 9191): Processor: processing WorkGenerationalId(workSpecId=06c5cff6-1659-47ea-b20f-fe0d848e9fc6, generation=0)
D/WM-GreedyScheduler( 9191): Cancelling work ID 24d341b3-1e65-4e2c-9571-e4790fc24d18
D/WM-Processor( 9191): Work WorkGenerationalId(workSpecId=06c5cff6-1659-47ea-b20f-fe0d848e9fc6, generation=0) is already enqueued for processing
D/WM-WorkerWrapper( 9191): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker( 9191): Starting widget update work
D/WidgetUpdateWorker( 9191): Widget data loaded: 2 characters