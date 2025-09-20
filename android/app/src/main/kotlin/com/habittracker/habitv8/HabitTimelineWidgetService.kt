package com.habittracker.habitv8

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import android.util.Log
import com.habittracker.habitv8.R

class HabitTimelineWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return HabitTimelineRemoteViewsFactory(this.applicationContext, intent)
    }
}

class HabitTimelineRemoteViewsFactory(
    private val context: Context,
    intent: Intent
) : RemoteViewsService.RemoteViewsFactory {

    private var habits: List<Map<String, Any>> = emptyList()
    private val appWidgetId: Int = intent.getIntExtra(
        android.appwidget.AppWidgetManager.EXTRA_APPWIDGET_ID,
        android.appwidget.AppWidgetManager.INVALID_APPWIDGET_ID
    )

    override fun onCreate() {
        // Initialize the factory - this is called once when the factory is created
        Log.d("HabitTimelineService", "RemoteViewsFactory onCreate called")
        loadHabitData()
    }

    override fun onDestroy() {
        habits = emptyList()
    }

    override fun getCount(): Int {
        val count = habits.size
        Log.d("HabitTimelineService", "getCount returning: $count habits")
        return count
    }

    override fun getViewAt(position: Int): RemoteViews {
        Log.d("HabitTimelineService", "getViewAt position: $position")
        
        if (position >= habits.size) {
            Log.w("HabitTimelineService", "Position $position out of bounds for ${habits.size} habits")
            return getLoadingView() ?: RemoteViews(context.packageName, R.layout.widget_habit_item)
        }

        val habit = habits[position]
        val remoteViews = RemoteViews(context.packageName, R.layout.widget_habit_item)

        try {
            // Set habit data
            val habitName = habit["name"] as? String ?: "Unknown Habit"
            val scheduledTime = habit["scheduledTime"] as? String ?: ""
            val isCompleted = habit["isCompleted"] as? Boolean ?: false
            val colorHex = habit["colorHex"] as? String ?: "#4CAF50"
            
            // Parse color safely
            val habitColor = try {
                android.graphics.Color.parseColor(colorHex)
            } catch (e: Exception) {
                android.graphics.Color.parseColor("#4CAF50") // Fallback green
            }

            // Set habit name
            remoteViews.setTextViewText(R.id.habit_name, habitName)
            
            // Set scheduled time if available
            if (scheduledTime.isNotEmpty()) {
                remoteViews.setTextViewText(R.id.habit_time, scheduledTime)
                remoteViews.setViewVisibility(R.id.habit_time, android.view.View.VISIBLE)
            } else {
                remoteViews.setViewVisibility(R.id.habit_time, android.view.View.GONE)
            }

            // Set color indicator
            remoteViews.setInt(R.id.habit_color_indicator, "setBackgroundColor", habitColor)

            // Set completion button state
            if (isCompleted) {
                remoteViews.setImageViewResource(R.id.complete_button, R.drawable.ic_check)
                remoteViews.setInt(R.id.complete_button, "setColorFilter", habitColor)
                remoteViews.setFloat(R.id.habit_name, "setAlpha", 0.7f)
                remoteViews.setFloat(R.id.habit_time, "setAlpha", 0.7f)
            } else {
                remoteViews.setImageViewResource(R.id.complete_button, R.drawable.ic_check_circle_outline)
                remoteViews.setInt(R.id.complete_button, "setColorFilter", habitColor)
                remoteViews.setFloat(R.id.habit_name, "setAlpha", 1.0f)
                remoteViews.setFloat(R.id.habit_time, "setAlpha", 1.0f)
            }

            // Set up click intent for completion toggle
            val fillInIntent = Intent().apply {
                putExtra("habit_id", habit["id"] as? String ?: "")
                putExtra("action", "toggle_completion")
                putExtra("position", position)
            }
            remoteViews.setOnClickFillInIntent(R.id.complete_button, fillInIntent)

            // Set up click intent for opening habit details
            val habitDetailIntent = Intent().apply {
                putExtra("habit_id", habit["id"] as? String ?: "")
                putExtra("action", "open_habit")
                putExtra("position", position)
            }
            remoteViews.setOnClickFillInIntent(R.id.habit_name, habitDetailIntent)

            Log.d("HabitTimelineService", "Created view for habit: $habitName at position $position")

        } catch (e: Exception) {
            Log.e("HabitTimelineService", "Error creating view for position $position", e)
            // Return a basic view on error
            remoteViews.setTextViewText(R.id.habit_name, "Error loading habit")
        }

        return remoteViews
    }

    override fun getLoadingView(): RemoteViews? {
        // Return a loading view or null to use default
        val remoteViews = RemoteViews(context.packageName, R.layout.widget_habit_item)
        remoteViews.setTextViewText(R.id.habit_name, "Loading...")
        remoteViews.setViewVisibility(R.id.habit_time, android.view.View.GONE)
        remoteViews.setViewVisibility(R.id.complete_button, android.view.View.GONE)
        return remoteViews
    }

    override fun getViewTypeCount(): Int {
        // We only have one type of view
        return 1
    }

    override fun getItemId(position: Int): Long {
        // Return a unique ID for the item at the given position
        return position.toLong()
    }

    override fun hasStableIds(): Boolean {
        return true
    }

    override fun onDataSetChanged() {
        // Called when notifyAppWidgetViewDataChanged is triggered
        Log.d("HabitTimelineService", "onDataSetChanged called - reloading habit data")
        loadHabitData()
    }

    private fun loadHabitData() {
        try {
            // Load habit data from SharedPreferences (same as home_widget plugin uses)
            val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val habitsJson = prefs.getString("flutter.habits", null)
            
            Log.d("HabitTimelineService", "Looking for habits data with key: flutter.habits")
            
            if (habitsJson != null) {
                Log.d("HabitTimelineService", "Found habits JSON: ${habitsJson.take(200)}...")
                // Parse JSON data using reflection
                val gson = com.google.gson.Gson()
                val type = com.google.gson.reflect.TypeToken.getParameterized(
                    java.util.List::class.java,
                    Map::class.java
                ).type
                habits = gson.fromJson(habitsJson, type) ?: emptyList()
                Log.d("HabitTimelineService", "Loaded ${habits.size} habits from SharedPreferences")
            } else {
                // Debug: Let's see what keys are actually available
                val allKeys = prefs.all.keys
                Log.d("HabitTimelineService", "No habit data found. Available keys: $allKeys")
                habits = emptyList()
            }
        } catch (e: Exception) {
            Log.e("HabitTimelineService", "Error loading habit data", e)
            habits = emptyList()
        }
    }
}