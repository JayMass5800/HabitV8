package com.habittracker.habitv8

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import android.util.Log
import com.habittracker.habitv8.R

class HabitTimelineWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        android.util.Log.d("HabitTimelineService", "onGetViewFactory called - creating new factory")
        return HabitTimelineRemoteViewsFactory(this.applicationContext, intent)
    }
}

class HabitTimelineRemoteViewsFactory(
    private val context: Context,
    intent: Intent
) : RemoteViewsService.RemoteViewsFactory {

    private var habits: List<Map<String, Any>> = emptyList()
    private var isDarkMode: Boolean = false
    private var primaryColor: Int = 0xFF6200EE.toInt()
    private var textColor: Int = 0xFF000000.toInt()
    private var backgroundColor: Int = 0xFFFFFFFF.toInt()
    private val appWidgetId: Int = intent.getIntExtra(
        android.appwidget.AppWidgetManager.EXTRA_APPWIDGET_ID,
        android.appwidget.AppWidgetManager.INVALID_APPWIDGET_ID
    )
    private val themeModeExtra: String? = intent.getStringExtra("themeMode")
    private val primaryColorExtra: Int = intent.getIntExtra("primaryColor", -1)

    override fun onCreate() {
        // Initialize the factory - this is called once when the factory is created
        Log.d("HabitTimelineService", "RemoteViewsFactory onCreate called")
        loadThemeData()
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
            val habitStatus = habit["status"] as? String ?: "Due"
            
            // Parse color safely
            val habitColor = try {
                android.graphics.Color.parseColor(colorHex)
            } catch (e: Exception) {
                android.graphics.Color.parseColor("#4CAF50") // Fallback green
            }

            // Set habit name with theme-aware text color
            remoteViews.setTextViewText(R.id.habit_name, habitName)
            remoteViews.setTextColor(R.id.habit_name, textColor)
            
            // Set scheduled time if available with theme-aware text color
            if (scheduledTime.isNotEmpty()) {
                remoteViews.setTextViewText(R.id.habit_time, scheduledTime)
                remoteViews.setTextColor(R.id.habit_time, textColor)
                remoteViews.setViewVisibility(R.id.habit_time, android.view.View.VISIBLE)
            } else {
                remoteViews.setViewVisibility(R.id.habit_time, android.view.View.GONE)
            }

            // Set color indicator
            remoteViews.setInt(R.id.habit_color_indicator, "setBackgroundColor", habitColor)

            // Set completion button state and visual indicators
            if (isCompleted) {
                // Show completed state with checkmark
                remoteViews.setImageViewResource(R.id.complete_button, R.drawable.ic_check)
                remoteViews.setInt(R.id.complete_button, "setColorFilter", android.graphics.Color.parseColor("#4CAF50"))
                
                // Add visual completion indicators
                remoteViews.setFloat(R.id.habit_name, "setAlpha", 0.7f)
                remoteViews.setFloat(R.id.habit_time, "setAlpha", 0.7f)
                
                // Add border to indicate completion
                remoteViews.setInt(R.id.habit_item_container, "setBackgroundResource", R.drawable.widget_habit_item_completed_background)
                
                // Update status text with theme-aware colors
                remoteViews.setTextViewText(R.id.habit_status, "Completed")
                remoteViews.setTextColor(R.id.habit_status, 0xFFFFFFFF.toInt()) // White text on green
                remoteViews.setInt(R.id.habit_status, "setBackgroundColor", android.graphics.Color.parseColor("#4CAF50"))
            } else {
                // Show pending state with outline
                remoteViews.setImageViewResource(R.id.complete_button, R.drawable.ic_check_circle_outline)
                remoteViews.setInt(R.id.complete_button, "setColorFilter", habitColor)
                
                // Normal opacity for pending habits
                remoteViews.setFloat(R.id.habit_name, "setAlpha", 1.0f)
                remoteViews.setFloat(R.id.habit_time, "setAlpha", 1.0f)
                
                // Normal background
                remoteViews.setInt(R.id.habit_item_container, "setBackgroundResource", R.drawable.widget_habit_item_background)
                
                // Update status based on time with theme-aware colors
                remoteViews.setTextViewText(R.id.habit_status, habitStatus)
                remoteViews.setTextColor(R.id.habit_status, textColor)
                remoteViews.setInt(R.id.habit_status, "setBackgroundResource", R.drawable.widget_status_background)
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

            // Set up click intent for edit button
            val editHabitIntent = Intent().apply {
                putExtra("habit_id", habit["id"] as? String ?: "")
                putExtra("action", "edit_habit")
                putExtra("position", position)
            }
            remoteViews.setOnClickFillInIntent(R.id.edit_button, editHabitIntent)

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
        loadThemeData()
        loadHabitData()
    }

    private fun loadHabitData() {
        try {
            // Load habit data from the SAME SharedPreferences that the widget provider uses
            // The widget provider gets data from home_widget plugin, not FlutterSharedPreferences
            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
            val habitsJson = prefs.getString("habits", null)
            
            Log.d("HabitTimelineService", "Looking for habits data with key: habits in HomeWidgetPreferences")
            
            if (habitsJson != null) {
                Log.d("HabitTimelineService", "Found habits JSON: ${habitsJson.take(200)}...")
                Log.d("HabitTimelineService", "Full JSON length: ${habitsJson.length}")
                
                // Parse JSON data using reflection
                val gson = com.google.gson.Gson()
                val type = com.google.gson.reflect.TypeToken.getParameterized(
                    java.util.List::class.java,
                    Map::class.java
                ).type
                habits = gson.fromJson(habitsJson, type) ?: emptyList()
                Log.d("HabitTimelineService", "Loaded ${habits.size} habits from HomeWidgetPreferences")
                
                // Debug first habit if available
                if (habits.isNotEmpty()) {
                    val firstHabit = habits[0]
                    Log.d("HabitTimelineService", "First habit keys: ${firstHabit.keys}")
                    Log.d("HabitTimelineService", "First habit name: ${firstHabit["name"]}")
                    Log.d("HabitTimelineService", "First habit isCompleted: ${firstHabit["isCompleted"]}")
                }
            } else {
                // Debug: Let's see what keys are actually available
                val allKeys = prefs.all.keys
                Log.d("HabitTimelineService", "No habit data found in HomeWidgetPreferences. Available keys: $allKeys")
                
                // Also check the theme data in the correct store
                val themeMode = prefs.getString("themeMode", null)
                val primaryColor = prefs.getInt("primaryColor", -1)
                Log.d("HabitTimelineService", "HomeWidget theme mode: $themeMode, Primary color: $primaryColor")
                
                habits = emptyList()
            }
        } catch (e: Exception) {
            Log.e("HabitTimelineService", "Error loading habit data", e)
            habits = emptyList()
        }
    }

    private fun loadThemeData() {
        try {
            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
            val flutterPrefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            
            // Load theme mode with robust fallbacks (prefer extras from provider → HomeWidget → Flutter prefs → system)
            var themeMode = themeModeExtra
                ?: prefs.getString("themeMode", null) 
                ?: prefs.getString("home_widget.double.themeMode", null)
                ?: flutterPrefs.getString("flutter.theme_mode", null)
                ?: flutterPrefs.getString("theme_mode", null)
            
            // If no explicit theme mode is found, check system theme
            if (themeMode == null || themeMode == "system") {
                val systemNightMode = context.resources.configuration.uiMode and 
                    android.content.res.Configuration.UI_MODE_NIGHT_MASK
                themeMode = when (systemNightMode) {
                    android.content.res.Configuration.UI_MODE_NIGHT_YES -> "dark"
                    android.content.res.Configuration.UI_MODE_NIGHT_NO -> "light"
                    else -> "light"
                }
                Log.d("HabitTimelineService", "No saved theme found, using system theme: $themeMode")
            }
            
            Log.d("HabitTimelineService", "Detected theme mode: '$themeMode'")
            
            // Load primary color with fallbacks; prefer extras from provider
            primaryColor = when {
                primaryColorExtra != -1 -> primaryColorExtra
                prefs.contains("primaryColor") -> prefs.getInt("primaryColor", 0xFF6200EE.toInt())
                prefs.contains("home_widget.double.primaryColor") -> {
                    try {
                        prefs.getFloat("home_widget.double.primaryColor", 0xFF6200EE.toFloat()).toInt()
                    } catch (e: Exception) {
                        0xFF6200EE.toInt()
                    }
                }
                flutterPrefs.contains("flutter.primary_color") -> flutterPrefs.getInt("flutter.primary_color", 0xFF6200EE.toInt())
                flutterPrefs.contains("primary_color") -> flutterPrefs.getInt("primary_color", 0xFF6200EE.toInt())
                prefs.contains("flutter.primaryColor") -> prefs.getInt("flutter.primaryColor", 0xFF6200EE.toInt())
                else -> 0xFF6200EE.toInt()
            }
            
            // Set theme-based colors
            isDarkMode = themeMode.equals("dark", ignoreCase = true)
            textColor = if (isDarkMode) 0xFFFFFFFF.toInt() else 0xFF000000.toInt()
            backgroundColor = if (isDarkMode) 0xFF121212.toInt() else 0xFFFFFFFF.toInt()
            
            Log.d("HabitTimelineService", "Theme applied - isDark: $isDarkMode, textColor: ${Integer.toHexString(textColor)}, primary: ${Integer.toHexString(primaryColor)}")
            
        } catch (e: Exception) {
            Log.e("HabitTimelineService", "Error loading theme data, using defaults", e)
            // Fallback to light theme
            isDarkMode = false
            textColor = 0xFF000000.toInt()
            backgroundColor = 0xFFFFFFFF.toInt()
            primaryColor = 0xFF6200EE.toInt()
        }
    }
}