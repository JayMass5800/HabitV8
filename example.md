import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'dart:developer';

// --- Placeholder for your actual habit tracking service ---
// This class simulates your service that handles data persistence
class HabitService {
  // Simulates updating the habit status in a persistent storage (e.g., Firestore or local database)
  static Future<void> completeHabit(String habitId) async {
    // 1. **DATABASE/STORAGE UPDATE:**
    // This is where you'd call your Firebase/Firestore update, Hive, or Shared Preferences logic.
    log('[$habitId] Habit completion triggered.');
    
    // Example: Update the 'is_completed' field for the specific habit in your database.
    // await Firestore.instance.collection('habits').doc(habitId).update({'completed': true});

    // For demonstration, we'll log success:
    await Future.delayed(const Duration(milliseconds: 500));
    log('[$habitId] Habit data successfully updated in database/storage.');
  }
}

// --- MANDATORY BACKGROUND ENTRY POINT ---
// This annotation is crucial. It tells the native platform (Android/iOS) which function
// to execute in a background Isolates when a widget action (or notification action) is clicked.
@pragma('vm:entry-point')
Future<void> backgroundWidgetHandler(Uri? uri) async {
  // Initialize the Flutter engine needed for background execution
  // HomeWidget.set===() must be called here to ensure the platform channel is initialized.
  await HomeWidget.set/// (or the equivalent initialization call for your chosen package).

  // 2. **ACTION IDENTIFICATION:**
  // The 'uri' carries the information about which button was pressed and for which habit.
  if (uri != null) {
    // Example URI format: 'app://habit.tracker?action=complete&id=habit_001'
    final action = uri.queryParameters['action'];
    final habitId = uri.queryParameters['id'];

    if (action == 'complete' && habitId != null) {
      log('Background handler received action: $action for Habit ID: $habitId');
      
      // 3. **DATA PROCESSING:**
      // Call the service function to update the data source
      await HabitService.completeHabit(habitId);
      
      // 4. **EXPLICIT WIDGET REFRESH (THE KEY STEP):**
      // This command forces the OS to reread the widget layout/data immediately.
      await HomeWidget.updateWidget(
        // Pass the name/class of your main widget here (platform-specific)
        name: 'MyHabitWidget', 
        // Optional: you can pass data to the widget if needed, but the widget
        // will usually just read the state from the updated HabitService
      );
      
      log('Widget update signal sent successfully.');
    }
  }
}

void main() {
  // Ensure background handler is registered on launch
  HomeWidget.widgetClicked.listen(backgroundWidgetHandler);
  
  runApp(const MyApp());
}

// ... rest of your Flutter application code (MyApp, etc.)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Habit Tracker')),
      body: const Center(
        child: Text('Main app running. Data updates handled by service.'),
      ),
    );
  }
}

// --- Widget Layout Code (Conceptual) ---
// Inside your native code (e.g., Android's RemoteViews or iOS's WidgetBundle), 
// you would set up a button that broadcasts an intent/URL to the Flutter engine:
/*
  <Button 
    onClick="app://habit.tracker?action=complete&id={{habit.id}}" 
    text="✅" 
  />
*/
// The 'home_widget' package is responsible for listening to that broadcast and 
// routing it to the 'backgroundWidgetHandler' function defined above.






To enable a home screen widget in Flutter that refreshes when new data is available, you can use the App Widgets feature on Android and WidgetKit on iOS. Below is an example implementation for both platforms.

1. Android Home Screen Widget with Flutter
Flutter uses a plugin like flutter_app_widget or a custom Android implementation for home screen widgets.

Steps:
Create a native Android widget in the android folder.
Use a BroadcastReceiver to listen for updates.
Trigger updates from Flutter using platform channels.
Example Code:
MainActivity.kt (Android Widget Update):


package com.example.myapp

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

class MyWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        val views = RemoteViews(context.packageName, R.layout.widget_layout)
        views.setTextViewText(R.id.widget_text, "Updated Data")

        appWidgetIds.forEach { appWidgetId ->
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    companion object {
        fun updateWidget(context: Context, newData: String) {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val widgetIds = appWidgetManager.getAppWidgetIds(ComponentName(context, MyWidgetProvider::class.java))
            val views = RemoteViews(context.packageName, R.layout.widget_layout)
            views.setTextViewText(R.id.widget_text, newData)

            widgetIds.forEach { appWidgetId ->
                appWidgetManager.updateAppWidget(appWidgetId, views)
            }
        }
    }
}
Flutter Code to Trigger Update:


import 'package:flutter/services.dart';

class WidgetUpdater {
  static const platform = MethodChannel('com.example.myapp/widget');

  static Future<void> updateWidget(String newData) async {
    try {
      await platform.invokeMethod('updateWidget', {'data': newData});
    } catch (e) {
      print("Failed to update widget: $e");
    }
  }
}
2. iOS Home Screen Widget with Flutter
For iOS, use WidgetKit and communicate updates via a shared App Group.

Steps:
Create a Widget Extension in Xcode.
Use App Group to share data between the app and the widget.
Update the widget when new data is available.
Widget Extension Code (Swift):


import WidgetKit
import SwiftUI

struct MyWidgetEntry: TimelineEntry {
    let date: Date
    let data: String
}

struct MyWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> MyWidgetEntry {
        MyWidgetEntry(date: Date(), data: "Loading...")
    }

    func getSnapshot(in context: Context, completion: @escaping (MyWidgetEntry) -> ()) {
        let entry = MyWidgetEntry(date: Date(), data: "Snapshot Data")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MyWidgetEntry>) -> ()) {
        let sharedDefaults = UserDefaults(suiteName: "group.com.example.myapp")
        let data = sharedDefaults?.string(forKey: "widgetData") ?? "No Data"
        let entry = MyWidgetEntry(date: Date(), data: data)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct MyWidgetView: View {
    var entry: MyWidgetProvider.Entry

    var body: some View {
        Text(entry.data)
    }
}

@main
struct MyWidget: Widget {
    let kind: String = "MyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MyWidgetProvider()) { entry in
            MyWidgetView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is a sample widget.")
    }
}
Flutter Code to Update Widget Data:


import 'package:shared_preferences/shared_preferences.dart';

Future<void> updateIOSWidget(String newData) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('widgetData', newData);
  // Trigger WidgetKit reload
  await MethodChannel('com.example.myapp/widget').invokeMethod('reloadWidget');
}
Notes:
Android: Use AppWidgetManager to update widgets.
iOS: Use WidgetKit and App Groups for data sharing.
Flutter: Use MethodChannel to communicate between Flutter and native code.
Let me know if you need further clarification!