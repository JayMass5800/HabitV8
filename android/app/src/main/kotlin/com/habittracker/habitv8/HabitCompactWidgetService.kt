package com.habittracker.habitv8

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import android.util.Log
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject

class HabitCompactWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return HabitCompactRemoteViewsFactory(this.applicationContext, intent)
    }
}

class HabitCompactRemoteViewsFactory(
    private val context: Context,
    intent: Intent
) : RemoteViewsService.RemoteViewsFactory {

    private var habits = mutableListOf<Map<String, Any>>()
    private var themeMode = ""
    private var primaryColor = 0
    private var textColor = 0
    private var backgroundColor = 0
    private var isDarkMode = false
    private val appWidgetId = intent.getIntExtra("appWidgetId", 0)

    override fun onCreate() {
        Log.d("HabitCompactWidget", "HabitCompactRemoteViewsFactory onCreate called")
        loadThemeData()
        loadHabitData()
    }

    override fun getCount(): Int {
        val count = habits.size.coerceAtMost(3)
        Log.d("HabitCompactWidget", "getCount called, returning: $count")
        return count
    }

    override fun getViewAt(position: Int): RemoteViews? {
        Log.d("HabitCompactWidget", "getViewAt called for position: $position")

        if (position >= habits.size) {
            Log.e("HabitCompactWidget", "Position $position out of bounds")
            return getLoadingView()
        }

        val habit = habits[position]
        val remoteViews = RemoteViews(context.packageName, R.layout.widget_compact_habit_item)

        try {
            // Extract habit data
            val habitName = habit["name"] as? String ?: "Unknown Habit"
            val scheduledTime = habit["scheduledTime"] as? String ?: ""
            val isCompleted = habit["isCompleted"] as? Boolean ?: false
            val colorHex = habit["color"] as? String ?: "#4CAF50"
            val habitStatus = habit["status"] as? String ?: ""

            // Parse color
            val color = try {
                android.graphics.Color.parseColor(colorHex)
            } catch (e: Exception) {
                android.graphics.Color.parseColor("#4CAF50")
            }

            // Set habit name
            remoteViews.setTextViewText(R.id.compact_habit_name, habitName)
            remoteViews.setTextColor(R.id.compact_habit_name, textColor)

            // Set time text 
            remoteViews.setTextViewText(R.id.compact_habit_time, scheduledTime)
            remoteViews.setTextColor(R.id.compact_habit_time, textColor)

            // Set color indicator
            remoteViews.setInt(R.id.compact_habit_color_indicator, "setBackgroundColor", color)

            // Set completion button appearance
            if (isCompleted) {
                remoteViews.setTextViewText(R.id.compact_complete_button, "✓")
                remoteViews.setTextColor(R.id.compact_complete_button, color)
            } else {
                remoteViews.setTextViewText(R.id.compact_complete_button, "○")
                remoteViews.setTextColor(R.id.compact_complete_button, textColor)
            }

            // Set background color
            remoteViews.setInt(R.id.compact_habit_item_container, "setBackgroundColor", backgroundColor)

            // Set click intent for completion toggle
            val completionIntent = Intent()
            completionIntent.putExtra("habitId", habit["id"] as? String ?: "")
            completionIntent.putExtra("action", "toggle_completion")
            completionIntent.putExtra("widgetId", appWidgetId)
            
            remoteViews.setOnClickFillInIntent(R.id.compact_complete_button, completionIntent)

            // Set habit name click intent for details
            val detailIntent = Intent()
            detailIntent.putExtra("habitId", habit["id"] as? String ?: "")
            remoteViews.setOnClickFillInIntent(R.id.compact_habit_name, detailIntent)
            
        } catch (e: Exception) {
            Log.e("HabitCompactWidget", "Error creating view for habit: $habitName", e)
        }

        Log.d("HabitCompactWidget", "Created view for habit: $habitName")
        return remoteViews
    }

    override fun getLoadingView(): RemoteViews? {
        val loadingView = RemoteViews(context.packageName, R.layout.widget_compact_habit_item)
        loadingView.setTextViewText(R.id.compact_habit_name, "Loading...")
        loadingView.setTextColor(R.id.compact_habit_name, textColor)
        return loadingView
    }

    override fun getViewTypeCount(): Int = 1

    override fun getItemId(position: Int): Long = position.toLong()

    override fun hasStableIds(): Boolean = true

    override fun onDataSetChanged() {
        Log.d("HabitCompactWidget", "onDataSetChanged called")
        loadThemeData()
        loadHabitData()
    }

    override fun onDestroy() {}

    private fun loadHabitData() {
        try {
            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
            val habitsJson = prefs.getString("habits", "[]")
            
            if (habitsJson != null) {
                Log.d("HabitCompactWidget", "Raw habits JSON: $habitsJson")
                
                if (habitsJson == "[]") {
                    Log.d("HabitCompactWidget", "No habits data found, JSON is empty array")
                    habits = mutableListOf()
                    return
                }

                val habitsArray = JSONArray(habitsJson)
                Log.d("HabitCompactWidget", "Parsed habits array with ${habitsArray.length()} items")

                habits = mutableListOf()
                
                for (i in 0 until habitsArray.length()) {
                    try {
                        val habitObj = habitsArray.getJSONObject(i)
                        Log.d("HabitCompactWidget", "Processing habit $i: ${habitObj.toString()}")
                        
                        val habitMap = mutableMapOf<String, Any>()
                        val habitKeys = habitObj.keys()
                        
                        while (habitKeys.hasNext()) {
                            val key = habitKeys.next()
                            val value = habitObj.get(key)
                            habitMap[key] = value
                        }
                        
                        habits.add(habitMap)
                    } catch (e: Exception) {
                        Log.e("HabitCompactWidget", "Error processing habit at index $i", e)
                    }
                }
                
                Log.d("HabitCompactWidget", "Final habits list size: ${habits.size}")
                
            } else {
                habits = mutableListOf()
            }
        } catch (e: Exception) {
            Log.e("HabitCompactWidget", "Error loading habit data", e)
            habits = mutableListOf()
        }
    }

    private fun loadThemeData() {
        Log.d("HabitCompactWidget", "Loading theme data")
        
        try {
            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
            
            themeMode = prefs.getString("theme_mode", "system") ?: "system"
            
            if (themeMode == "system") {
                val systemNightMode = context.resources.configuration.uiMode and 
                    android.content.res.Configuration.UI_MODE_NIGHT_MASK
                
                when (systemNightMode) {
                    android.content.res.Configuration.UI_MODE_NIGHT_YES -> themeMode = "dark"
                    android.content.res.Configuration.UI_MODE_NIGHT_NO -> themeMode = "light"
                    else -> themeMode = "light"
                }
            }
            
            Log.d("HabitCompactWidget", "Resolved theme mode: $themeMode")
            
            isDarkMode = themeMode == "dark"
            
            // Load colors based on theme
            try {
                primaryColor = when (isDarkMode) {
                    true -> {
                        val primaryHex = prefs.getString("primary_color_dark", "#BB86FC") ?: "#BB86FC"
                        android.graphics.Color.parseColor(primaryHex)
                    }
                    false -> {
                        val primaryHex = prefs.getString("primary_color_light", "#6200EE") ?: "#6200EE"
                        android.graphics.Color.parseColor(primaryHex)
                    }
                }
            } catch (e: Exception) {
                Log.e("HabitCompactWidget", "Error loading primary color", e)
                primaryColor = if (isDarkMode) {
                    android.graphics.Color.parseColor("#BB86FC")
                } else {
                    android.graphics.Color.parseColor("#6200EE")
                }
            }
            
            textColor = if (isDarkMode) {
                android.graphics.Color.parseColor("#FFFFFF")
            } else {
                android.graphics.Color.parseColor("#000000")
            }
            
            backgroundColor = if (isDarkMode) {
                android.graphics.Color.parseColor("#121212")
            } else {
                android.graphics.Color.parseColor("#FFFFFF")
            }
            
            Log.d("HabitCompactWidget", "Theme loaded - isDark: $isDarkMode, textColor: $textColor, primaryColor: $primaryColor")
            
        } catch (e: Exception) {
            Log.e("HabitCompactWidget", "Error loading theme data", e)
            isDarkMode = false
            textColor = android.graphics.Color.parseColor("#000000")
            backgroundColor = android.graphics.Color.parseColor("#FFFFFF") 
            primaryColor = android.graphics.Color.parseColor("#6200EE")
        }
    }
}