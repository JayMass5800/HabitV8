package com.habittracker.habitv8

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import android.util.Log
import com.habittracker.habitv8.R

class HabitCompactWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return HabitCompactRemoteViewsFactory(this.applicationContext, intent)
    }
}

class HabitCompactRemoteViewsFactory(
    private val context: Context,
    intent: Intent
) : RemoteViewsService.RemoteViewsFactory {

    private var habits: List<Map<String, Any>> = emptyList()
    private val appWidgetId: Int = intent.getIntExtra(
        android.appwidget.AppWidgetManager.EXTRA_APPWIDGET_ID,
        android.appwidget.AppWidgetManager.INVALID_APPWIDGET_ID
    )

    override fun onCreate() {
        Log.d("HabitCompactService", "RemoteViewsFactory onCreate called")
        loadHabitData()
    }

    override fun onDestroy() {
        habits = emptyList()
    }

    override fun getCount(): Int {
        // Limit compact widget to show max 5 habits for better UX
        val count = minOf(habits.size, 5)
        Log.d("HabitCompactService", "getCount returning: $count habits (${habits.size} total)")
        return count
    }

    override fun getViewAt(position: Int): RemoteViews {
        Log.d("HabitCompactService", "getViewAt position: $position")
        
        if (position >= habits.size || position >= 5) {
            Log.w("HabitCompactService", "Position $position out of bounds")
            return getLoadingView() ?: RemoteViews(context.packageName, R.layout.widget_compact_habit_item)
        }

        val habit = habits[position]
        val remoteViews = RemoteViews(context.packageName, R.layout.widget_compact_habit_item)

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

            // Set habit name - truncate for compact display
            val displayName = if (habitName.length > 20) "${habitName.take(17)}..." else habitName
            remoteViews.setTextViewText(R.id.compact_habit_name, displayName)
            
            // Set scheduled time if available
            if (scheduledTime.isNotEmpty()) {
                remoteViews.setTextViewText(R.id.compact_habit_time, scheduledTime)
                remoteViews.setViewVisibility(R.id.compact_habit_time, android.view.View.VISIBLE)
            } else {
                remoteViews.setViewVisibility(R.id.compact_habit_time, android.view.View.GONE)
            }

            // Set color indicator
            remoteViews.setInt(R.id.compact_habit_color_indicator, "setBackgroundColor", habitColor)

            // Set completion button state
            if (isCompleted) {
                remoteViews.setImageViewResource(R.id.compact_complete_button, R.drawable.ic_check_circle)
                remoteViews.setInt(R.id.compact_complete_button, "setColorFilter", habitColor)
                remoteViews.setFloat(R.id.compact_habit_name, "setAlpha", 0.7f)
                remoteViews.setFloat(R.id.compact_habit_time, "setAlpha", 0.7f)
            } else {
                remoteViews.setImageViewResource(R.id.compact_complete_button, R.drawable.ic_check_circle_outline)
                remoteViews.setInt(R.id.compact_complete_button, "setColorFilter", habitColor)
                remoteViews.setFloat(R.id.compact_habit_name, "setAlpha", 1.0f)
                remoteViews.setFloat(R.id.compact_habit_time, "setAlpha", 1.0f)
            }

            // Set up click intent for completion toggle
            val fillInIntent = Intent().apply {
                putExtra("habit_id", habit["id"] as? String ?: "")
                putExtra("action", "toggle_completion")
                putExtra("position", position)
            }
            remoteViews.setOnClickFillInIntent(R.id.compact_complete_button, fillInIntent)

            // Set up click intent for opening habit details
            val habitDetailIntent = Intent().apply {
                putExtra("habit_id", habit["id"] as? String ?: "")
                putExtra("action", "open_habit")
                putExtra("position", position)
            }
            remoteViews.setOnClickFillInIntent(R.id.compact_habit_name, habitDetailIntent)

            Log.d("HabitCompactService", "Created view for habit: $habitName at position $position")

        } catch (e: Exception) {
            Log.e("HabitCompactService", "Error creating view for position $position", e)
            // Return a basic view on error
            remoteViews.setTextViewText(R.id.compact_habit_name, "Error loading habit")
        }

        return remoteViews
    }

    override fun getLoadingView(): RemoteViews? {
        val remoteViews = RemoteViews(context.packageName, R.layout.widget_compact_habit_item)
        remoteViews.setTextViewText(R.id.compact_habit_name, "Loading...")
        remoteViews.setViewVisibility(R.id.compact_habit_time, android.view.View.GONE)
        remoteViews.setViewVisibility(R.id.compact_complete_button, android.view.View.GONE)
        return remoteViews
    }

    override fun getViewTypeCount(): Int {
        return 1
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun hasStableIds(): Boolean {
        return true
    }

    override fun onDataSetChanged() {
        Log.d("HabitCompactService", "onDataSetChanged called - reloading habit data")
        loadHabitData()
    }

    private fun loadHabitData() {
        try {
            // Load habit data from SharedPreferences (same as home_widget plugin uses)
            val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val habitsJson = prefs.getString("flutter.habits_data", null)
            
            if (habitsJson != null) {
                // Parse JSON data
                val gson = com.google.gson.Gson()
                val habitsList = gson.fromJson(habitsJson, Array<Map<String, Any>>::class.java)
                habits = habitsList?.toList() ?: emptyList()
                Log.d("HabitCompactService", "Loaded ${habits.size} habits from SharedPreferences")
            } else {
                habits = emptyList()
                Log.d("HabitCompactService", "No habit data found in SharedPreferences")
            }
        } catch (e: Exception) {
            Log.e("HabitCompactService", "Error loading habit data", e)
            habits = emptyList()
        }
    }
}