package com.habittracker.habitv8package com.habittracker.habitv8package com.habittracker.habitv8



import android.content.Context

import android.content.Intent

import android.widget.RemoteViewsimport android.content.Contextimport android.content.Context

import android.widget.RemoteViewsService

import android.util.Logimport android.content.Intentimport android.content.Intent

import com.habittracker.habitv8.R

import es.antonborri.home_widget.HomeWidgetPluginimport android.widget.RemoteViewsimport android.widget.RemoteViews

import org.json.JSONArray

import org.json.JSONExceptionimport android.widget.RemoteViewsServiceimport android.widget.RemoteViewsService

import org.json.JSONObject

import android.util.Logimport android.util.Log

class HabitCompactWidgetService : RemoteViewsService() {

    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {import com.habittracker.habitv8.Rimport com.habittracker.habitv8.R

        return HabitCompactRemoteViewsFactory(this.applicationContext, intent)

    }

}

class HabitCompactWidgetService : RemoteViewsService() {class HabitCompactWidgetService : RemoteViewsService() {

class HabitCompactRemoteViewsFactory(

    private val context: Context,    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {

    intent: Intent

) : RemoteViewsService.RemoteViewsFactory {        android.util.Log.d("HabitCompactService", "onGetViewFactory called - creating new factory")        android.util.Log.d("HabitCompactService", "onGetViewFactory called - creating new factory")



    private var habits = mutableListOf<Map<String, Any>>()        return HabitCompactRemoteViewsFactory(this.applicationContext, intent)        return HabitCompactRemoteViewsFactory(this.applicationContext, intent)

    private var themeMode = ""

    private var primaryColor = 0    }    }

    private var textColor = 0

    private var backgroundColor = 0}}

    private var isDarkMode = false

    private val appWidgetId = intent.getIntExtra("appWidgetId", 0)



    override fun onCreate() {class HabitCompactRemoteViewsFactory(class HabitCompactRemoteViewsFactory(

        Log.d("HabitCompactWidget", "HabitCompactRemoteViewsFactory onCreate called")

        loadThemeData()    private val context: Context,    private val context: Context,

        loadHabitData()

    }    intent: Intent    intent: Intent



    override fun getCount(): Int {) : RemoteViewsService.RemoteViewsFactory {) : RemoteViewsService.RemoteViewsFactory {

        val count = habits.size.coerceAtMost(3)

        Log.d("HabitCompactWidget", "getCount called, returning: $count")

        return count

    }    private var habits: List<Map<String, Any>> = emptyList()    private var habits: List<Map<String, Any>> = emptyList()



    override fun getViewAt(position: Int): RemoteViews? {    private var isDarkMode: Boolean = false    private var isDarkMode: Boolean = false

        Log.d("HabitCompactWidget", "getViewAt called for position: $position")

    private var primaryColor: Int = 0xFF6200EE.toInt()    private var primaryColor: Int = 0xFF6200EE.toInt()

        if (position >= habits.size) {

            Log.e("HabitCompactWidget", "Position $position out of bounds")    private var textColor: Int = 0xFF000000.toInt()    private var textColor: Int = 0xFF000000.toInt()

            return getLoadingView()

        }    private var backgroundColor: Int = 0xFFFFFFFF.toInt()    private var backgroundColor: Int = 0xFFFFFFFF.toInt()



        val habit = habits[position]    private val appWidgetId: Int = intent.getIntExtra(    private val appWidgetId: Int = intent.getIntExtra(

        val remoteViews = RemoteViews(context.packageName, R.layout.widget_compact_habit_item)

        android.appwidget.AppWidgetManager.EXTRA_APPWIDGET_ID,        android.appwidget.AppWidgetManager.EXTRA_APPWIDGET_ID,

        try {

            // Extract habit data        android.appwidget.AppWidgetManager.INVALID_APPWIDGET_ID        android.appwidget.AppWidgetManager.INVALID_APPWIDGET_ID

            val habitName = habit["name"] as? String ?: "Unknown Habit"

            val scheduledTime = habit["scheduledTime"] as? String ?: ""    )    )

            val isCompleted = habit["isCompleted"] as? Boolean ?: false

            val colorHex = habit["color"] as? String ?: "#4CAF50"

            val habitStatus = habit["status"] as? String ?: ""

    override fun onCreate() {    override fun onCreate() {

            // Parse color

            val color = try {        // Initialize the factory - this is called once when the factory is created        // Initialize the factory - this is called once when the factory is created

                android.graphics.Color.parseColor(colorHex)

            } catch (e: Exception) {        Log.d("HabitCompactService", "RemoteViewsFactory onCreate called")        Log.d("HabitCompactService", "RemoteViewsFactory onCreate called")

                android.graphics.Color.parseColor("#4CAF50")

            }        loadThemeData()        loadThemeData()



            // Set habit name        loadHabitData()        loadHabitData()

            remoteViews.setTextViewText(R.id.compact_habit_name, habitName)

            remoteViews.setTextColor(R.id.compact_habit_name, textColor)    }    }



            // Set time text 

            remoteViews.setTextViewText(R.id.compact_habit_time, scheduledTime)

            remoteViews.setTextColor(R.id.compact_habit_time, textColor)    override fun onDestroy() {    override fun onDestroy() {



            // Set color indicator        habits = emptyList()        habits = emptyList()

            remoteViews.setInt(R.id.compact_habit_color_indicator, "setBackgroundColor", color)

    }    }

            // Set completion button appearance

            if (isCompleted) {

                remoteViews.setTextViewText(R.id.compact_complete_button, "✓")

                remoteViews.setTextColor(R.id.compact_complete_button, color)    override fun getCount(): Int {    override fun getCount(): Int {

            } else {

                remoteViews.setTextViewText(R.id.compact_complete_button, "○")        val count = habits.size        val count = habits.size

                remoteViews.setTextColor(R.id.compact_complete_button, textColor)

            }        Log.d("HabitCompactService", "getCount returning: $count habits")        Log.d("HabitCompactService", "getCount returning: $count habits")



            // Set background color        return count        return count

            remoteViews.setInt(R.id.compact_habit_item_container, "setBackgroundColor", backgroundColor)

    }    }

            // Set click intent for completion toggle

            val completionIntent = Intent()

            completionIntent.putExtra("habitId", habit["id"] as? String ?: "")

            completionIntent.putExtra("action", "toggle_completion")    override fun getViewAt(position: Int): RemoteViews {    override fun getViewAt(position: Int): RemoteViews {

            completionIntent.putExtra("widgetId", appWidgetId)

                    Log.d("HabitCompactService", "getViewAt position: $position")        Log.d("HabitCompactService", "getViewAt position: $position")

            val habitDetailIntent = Intent()

            habitDetailIntent.putExtra("habitId", habit["id"] as? String ?: "")                

            remoteViews.setOnClickFillInIntent(R.id.compact_complete_button, completionIntent)

        if (position >= habits.size) {        if (position >= habits.size) {

            // Set habit name click intent for details

            val detailIntent = Intent()            Log.w("HabitCompactService", "Position $position out of bounds for ${habits.size} habits")            Log.w("HabitCompactService", "Position $position out of bounds for ${habits.size} habits")

            detailIntent.putExtra("habitId", habit["id"] as? String ?: "")

                        return getLoadingView() ?: RemoteViews(context.packageName, R.layout.widget_compact_habit_item)            return getLoadingView() ?: RemoteViews(context.packageName, R.layout.widget_compact_habit_item)

        } catch (e: Exception) {

            Log.e("HabitCompactWidget", "Error creating view for habit: $habitName", e)        }        }

        }



        Log.d("HabitCompactWidget", "Created view for habit: $habitName")

        return remoteViews        val habit = habits[position]        val habit = habits[position]

    }

        val remoteViews = RemoteViews(context.packageName, R.layout.widget_compact_habit_item)        val remoteViews = RemoteViews(context.packageName, R.layout.widget_compact_habit_item)

    override fun getLoadingView(): RemoteViews? {

        val loadingView = RemoteViews(context.packageName, R.layout.widget_compact_habit_item)

        loadingView.setTextViewText(R.id.compact_habit_name, "Loading...")

        loadingView.setTextColor(R.id.compact_habit_name, textColor)        try {        try {

        return loadingView

    }            // Set habit data            // Set habit data



    override fun getViewTypeCount(): Int = 1            val habitName = habit["name"] as? String ?: "Unknown Habit"            val habitName = habit["name"] as? String ?: "Unknown Habit"



    override fun getItemId(position: Int): Long = position.toLong()            val scheduledTime = habit["scheduledTime"] as? String ?: ""            val scheduledTime = habit["scheduledTime"] as? String ?: ""



    override fun hasStableIds(): Boolean = true            val isCompleted = habit["isCompleted"] as? Boolean ?: false            val isCompleted = habit["isCompleted"] as? Boolean ?: false



    override fun onDataSetChanged() {            val colorHex = habit["colorHex"] as? String ?: "#4CAF50"            val colorHex = habit["colorHex"] as? String ?: "#4CAF50"

        Log.d("HabitCompactWidget", "onDataSetChanged called")

        loadThemeData()            val habitStatus = habit["status"] as? String ?: "Due"            val habitStatus = habit["status"] as? String ?: "Due"

        loadHabitData()

    }                        



    override fun onDestroy() {}            // Parse color safely            // Parse color safely



    private fun loadHabitData() {            val habitColor = try {            val habitColor = try {

        try {

            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)                android.graphics.Color.parseColor(colorHex)                android.graphics.Color.parseColor(colorHex)

            val habitsJson = prefs.getString("habits", "[]")

                        } catch (e: Exception) {            } catch (e: Exception) {

            if (habitsJson != null) {

                Log.d("HabitCompactWidget", "Raw habits JSON: $habitsJson")                android.graphics.Color.parseColor("#4CAF50") // Fallback green                android.graphics.Color.parseColor("#4CAF50") // Fallback green

                

                if (habitsJson == "[]") {            }            }

                    Log.d("HabitCompactWidget", "No habits data found, JSON is empty array")

                    habits = mutableListOf()

                    return

                }            // Set habit name (compact version) with theme-aware text color            // Set habit name (compact version) with theme-aware text color



                val habitsArray = JSONArray(habitsJson)            remoteViews.setTextViewText(R.id.compact_habit_name, habitName)            remoteViews.setTextViewText(R.id.compact_habit_name, habitName)

                Log.d("HabitCompactWidget", "Parsed habits array with ${habitsArray.length()} items")

            remoteViews.setTextColor(R.id.compact_habit_name, textColor)            remoteViews.setTextColor(R.id.compact_habit_name, textColor)

                val keys = mutableSetOf<String>()

                Log.d("HabitCompactWidget", "Processing habits array of type: ${habitsArray.javaClass.simpleName}")                        

                Log.d("HabitCompactWidget", "Array toString: ${habitsArray.toString()}")

            // For compact widget, show time more condensed but informative            // For compact widget, show time more condensed but informative

                habits = mutableListOf()

                            if (scheduledTime.isNotEmpty()) {            if (scheduledTime.isNotEmpty()) {

                for (i in 0 until habitsArray.length()) {

                    try {                remoteViews.setTextViewText(R.id.compact_habit_time, scheduledTime)                remoteViews.setTextViewText(R.id.compact_habit_time, scheduledTime)

                        val habitObj = habitsArray.getJSONObject(i)

                        Log.d("HabitCompactWidget", "Processing habit $i: ${habitObj.toString()}")                remoteViews.setTextColor(R.id.compact_habit_time, textColor)                remoteViews.setTextColor(R.id.compact_habit_time, textColor)

                        

                        val habitMap = mutableMapOf<String, Any>()                remoteViews.setViewVisibility(R.id.compact_habit_time, android.view.View.VISIBLE)                remoteViews.setViewVisibility(R.id.compact_habit_time, android.view.View.VISIBLE)

                        val habitKeys = habitObj.keys()

                                    } else {            } else {

                        while (habitKeys.hasNext()) {

                            val key = habitKeys.next()                remoteViews.setViewVisibility(R.id.compact_habit_time, android.view.View.GONE)                remoteViews.setViewVisibility(R.id.compact_habit_time, android.view.View.GONE)

                            keys.add(key)

                            val value = habitObj.get(key)            }            }

                            habitMap[key] = value

                        }

                        

                        habits.add(habitMap)            // Set color indicator for compact widget            // Set color indicator for compact widget

                    } catch (e: Exception) {

                        Log.e("HabitCompactWidget", "Error processing habit at index $i", e)            remoteViews.setInt(R.id.compact_habit_color_indicator, "setBackgroundColor", habitColor)            remoteViews.setInt(R.id.compact_habit_color_indicator, "setBackgroundColor", habitColor)

                    }

                }

                

                Log.d("HabitCompactWidget", "All habit keys found: $keys")            // Set completion button state and visual indicators for compact widget            // Set completion button state and visual indicators for compact widget

                Log.d("HabitCompactWidget", "Final habits list size: ${habits.size}")

                            if (isCompleted) {            if (isCompleted) {

            } else {

                habits = mutableListOf()                // Show completed state with checkmark                // Show completed state with checkmark

            }

        } catch (e: Exception) {                remoteViews.setImageViewResource(R.id.compact_complete_button, R.drawable.ic_check)                remoteViews.setImageViewResource(R.id.compact_complete_button, R.drawable.ic_check)

            Log.e("HabitCompactWidget", "Error loading habit data", e)

            habits = mutableListOf()                remoteViews.setInt(R.id.compact_complete_button, "setColorFilter", android.graphics.Color.parseColor("#4CAF50"))                remoteViews.setInt(R.id.compact_complete_button, "setColorFilter", android.graphics.Color.parseColor("#4CAF50"))

        }

                                        

        // Load theme after habits

        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)                // Add visual completion indicators                // Add visual completion indicators

        themeMode = prefs.getString("theme_mode", "system") ?: "system"

    }                remoteViews.setFloat(R.id.compact_habit_name, "setAlpha", 0.7f)                remoteViews.setFloat(R.id.compact_habit_name, "setAlpha", 0.7f)



    private fun loadThemeData() {                remoteViews.setFloat(R.id.compact_habit_time, "setAlpha", 0.7f)                remoteViews.setFloat(R.id.compact_habit_time, "setAlpha", 0.7f)

        Log.d("HabitCompactWidget", "Loading theme data")

                                        

        try {

            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)                // Add border to indicate completion                // Add border to indicate completion

            

            themeMode = prefs.getString("theme_mode", "system") ?: "system"                remoteViews.setInt(R.id.compact_habit_item_container, "setBackgroundResource", R.drawable.widget_habit_item_completed_background)                remoteViews.setInt(R.id.compact_habit_item_container, "setBackgroundResource", R.drawable.widget_habit_item_completed_background)

            

            if (themeMode == "system") {            } else {                

                val systemNightMode = context.resources.configuration.uiMode and 

                    android.content.res.Configuration.UI_MODE_NIGHT_MASK                // Show pending state with outline            // Remove status-related logic since compact widget doesn't have habit_status

                

                when (systemNightMode) {                remoteViews.setImageViewResource(R.id.compact_complete_button, R.drawable.ic_check_circle_outline)            // Compact widget focuses on name, time, and completion button only

                    android.content.res.Configuration.UI_MODE_NIGHT_YES -> themeMode = "dark"

                    android.content.res.Configuration.UI_MODE_NIGHT_NO -> themeMode = "light"                remoteViews.setInt(R.id.compact_complete_button, "setColorFilter", habitColor)            } else {

                    else -> themeMode = "light"

                }                                // Show pending state with outline

            }

                            // Normal opacity for pending habits                remoteViews.setImageViewResource(R.id.compact_complete_button, R.drawable.ic_check_circle_outline)

            Log.d("HabitCompactWidget", "Resolved theme mode: $themeMode")

                            remoteViews.setFloat(R.id.compact_habit_name, "setAlpha", 1.0f)                remoteViews.setInt(R.id.compact_complete_button, "setColorFilter", habitColor)

        } catch (e: Exception) {

            themeMode = "light"                remoteViews.setFloat(R.id.compact_habit_time, "setAlpha", 1.0f)                

        }

                                        // Normal opacity for pending habits

        Log.d("HabitCompactWidget", "Using theme mode: $themeMode")

                        // Normal background                remoteViews.setFloat(R.id.compact_habit_name, "setAlpha", 1.0f)

        primaryColor = when (isDarkMode) {

            true -> {                remoteViews.setInt(R.id.compact_habit_item_container, "setBackgroundResource", R.drawable.widget_habit_item_background)                remoteViews.setFloat(R.id.compact_habit_time, "setAlpha", 1.0f)

                val primaryHex = prefs.getString("primary_color_dark", "#BB86FC") ?: "#BB86FC"

                android.graphics.Color.parseColor(primaryHex)            }                

            }

            false -> {                // Normal background

                val primaryHex = prefs.getString("primary_color_light", "#6200EE") ?: "#6200EE"

                android.graphics.Color.parseColor(primaryHex)            // Set up click intent for completion toggle                remoteViews.setInt(R.id.compact_habit_item_container, "setBackgroundResource", R.drawable.widget_habit_item_background)

            }

        }            val fillInIntent = Intent().apply {            }

        

        } catch (e: Exception) {                putExtra("habit_id", habit["id"] as? String ?: "")            

            Log.e("HabitCompactWidget", "Error loading primary color", e)

            primaryColor = if (isDarkMode) {                putExtra("action", "toggle_completion")                // Remove status-related logic since compact widget doesn't have habit_status

                android.graphics.Color.parseColor("#BB86FC")

            } else {                putExtra("position", position)                // Compact widget focuses on name, time, and completion button only

                android.graphics.Color.parseColor("#6200EE")

            }            }            }

        }

                    remoteViews.setOnClickFillInIntent(R.id.compact_complete_button, fillInIntent)

        isDarkMode = themeMode == "dark"

        textColor = if (isDarkMode) {            // Set up click intent for completion toggle

            android.graphics.Color.parseColor("#FFFFFF")

        } else {            // Set up click intent for opening habit details            val fillInIntent = Intent().apply {

            android.graphics.Color.parseColor("#000000")

        }            val habitDetailIntent = Intent().apply {                putExtra("habit_id", habit["id"] as? String ?: "")

        backgroundColor = if (isDarkMode) {

            android.graphics.Color.parseColor("#121212")                putExtra("habit_id", habit["id"] as? String ?: "")                putExtra("action", "toggle_completion")

        } else {

            android.graphics.Color.parseColor("#FFFFFF")                putExtra("action", "open_habit")                putExtra("position", position)

        }

                        putExtra("position", position)            }

        Log.d("HabitCompactWidget", "Theme loaded - isDark: $isDarkMode, textColor: $textColor, primaryColor: $primaryColor")

                    }            remoteViews.setOnClickFillInIntent(R.id.compact_complete_button, fillInIntent)

        try {

            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)            remoteViews.setOnClickFillInIntent(R.id.compact_habit_name, habitDetailIntent)

        } catch (e: Exception) {

            Log.e("HabitCompactWidget", "Error loading theme data", e)            // Set up click intent for opening habit details

            isDarkMode = false

            textColor = android.graphics.Color.parseColor("#000000")            Log.d("HabitCompactService", "Created compact view for habit: $habitName at position $position")            val habitDetailIntent = Intent().apply {

            backgroundColor = android.graphics.Color.parseColor("#FFFFFF") 

            primaryColor = android.graphics.Color.parseColor("#6200EE")                putExtra("habit_id", habit["id"] as? String ?: "")

        }

    }        } catch (e: Exception) {                putExtra("action", "open_habit")

}
            Log.e("HabitCompactService", "Error creating view for position $position", e)                putExtra("position", position)

            // Return a basic view on error            }

            remoteViews.setTextViewText(R.id.compact_habit_name, "Error loading habit")            remoteViews.setOnClickFillInIntent(R.id.compact_habit_name, habitDetailIntent)

        }

            // Remove edit button logic since compact widget doesn't have edit_button

        return remoteViews            // Compact widget focuses on essential functionality only

    }

            Log.d("HabitCompactService", "Created compact view for habit: $habitName at position $position")

    override fun getLoadingView(): RemoteViews? {

        // Return a loading view or null to use default        } catch (e: Exception) {

        val remoteViews = RemoteViews(context.packageName, R.layout.widget_compact_habit_item)            Log.e("HabitCompactService", "Error creating view for position $position", e)

        remoteViews.setTextViewText(R.id.compact_habit_name, "Loading...")            // Return a basic view on error

        remoteViews.setViewVisibility(R.id.compact_habit_time, android.view.View.GONE)            remoteViews.setTextViewText(R.id.compact_habit_name, "Error loading habit")

        remoteViews.setViewVisibility(R.id.compact_complete_button, android.view.View.GONE)        }

        return remoteViews

    }        return remoteViews

    }

    override fun getViewTypeCount(): Int {

        // We only have one type of view    override fun getLoadingView(): RemoteViews? {

        return 1        // Return a loading view or null to use default

    }        val remoteViews = RemoteViews(context.packageName, R.layout.widget_compact_habit_item)

        remoteViews.setTextViewText(R.id.compact_habit_name, "Loading...")

    override fun getItemId(position: Int): Long {        remoteViews.setViewVisibility(R.id.compact_habit_time, android.view.View.GONE)

        // Return a unique ID for the item at the given position        remoteViews.setViewVisibility(R.id.compact_complete_button, android.view.View.GONE)

        return position.toLong()        return remoteViews

    }    }



    override fun hasStableIds(): Boolean {    override fun getViewTypeCount(): Int {

        return true        // We only have one type of view

    }        return 1

    }

    override fun onDataSetChanged() {

        // Called when notifyAppWidgetViewDataChanged is triggered    override fun getItemId(position: Int): Long {

        Log.d("HabitCompactService", "onDataSetChanged called - reloading habit data")        // Return a unique ID for the item at the given position

        loadThemeData()        return position.toLong()

        loadHabitData()    }

    }

    override fun hasStableIds(): Boolean {

    private fun loadHabitData() {        return true

        try {    }

            // Load habit data from the SAME SharedPreferences that the widget provider uses

            // The widget provider gets data from home_widget plugin, not FlutterSharedPreferences    override fun onDataSetChanged() {

            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)        // Called when notifyAppWidgetViewDataChanged is triggered

            val habitsJson = prefs.getString("habits", null)        Log.d("HabitCompactService", "onDataSetChanged called - reloading habit data")

                    loadThemeData()

            Log.d("HabitCompactService", "Looking for habits data with key: habits in HomeWidgetPreferences")        loadHabitData()

                }

            if (habitsJson != null) {

                Log.d("HabitCompactService", "Found habits JSON: ${habitsJson.take(200)}...")    private fun loadHabitData() {

                Log.d("HabitCompactService", "Full JSON length: ${habitsJson.length}")        try {

                            // Load habit data from the SAME SharedPreferences that the widget provider uses

                // Parse JSON data using reflection            // The widget provider gets data from home_widget plugin, not FlutterSharedPreferences

                val gson = com.google.gson.Gson()            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)

                val type = com.google.gson.reflect.TypeToken.getParameterized(            val habitsJson = prefs.getString("habits", null)

                    java.util.List::class.java,            

                    Map::class.java            Log.d("HabitCompactService", "Looking for habits data with key: habits in HomeWidgetPreferences")

                ).type            

                habits = gson.fromJson(habitsJson, type) ?: emptyList()            if (habitsJson != null) {

                Log.d("HabitCompactService", "Loaded ${habits.size} habits from HomeWidgetPreferences")                Log.d("HabitCompactService", "Found habits JSON: ${habitsJson.take(200)}...")

                                Log.d("HabitCompactService", "Full JSON length: ${habitsJson.length}")

                // Debug first habit if available                

                if (habits.isNotEmpty()) {                // Parse JSON data using reflection

                    val firstHabit = habits[0]                val gson = com.google.gson.Gson()

                    Log.d("HabitCompactService", "First habit keys: ${firstHabit.keys}")                val type = com.google.gson.reflect.TypeToken.getParameterized(

                    Log.d("HabitCompactService", "First habit name: ${firstHabit["name"]}")                    java.util.List::class.java,

                    Log.d("HabitCompactService", "First habit isCompleted: ${firstHabit["isCompleted"]}")                    Map::class.java

                }                ).type

            } else {                habits = gson.fromJson(habitsJson, type) ?: emptyList()

                // Debug: Let's see what keys are actually available                Log.d("HabitCompactService", "Loaded ${habits.size} habits from HomeWidgetPreferences")

                val allKeys = prefs.all.keys                

                Log.d("HabitCompactService", "No habit data found in HomeWidgetPreferences. Available keys: $allKeys")                // Debug first habit if available

                                if (habits.isNotEmpty()) {

                // Also check the theme data in the correct store                    val firstHabit = habits[0]

                val themeMode = prefs.getString("themeMode", null)                    Log.d("HabitCompactService", "First habit keys: ${firstHabit.keys}")

                val primaryColor = prefs.getInt("primaryColor", -1)                    Log.d("HabitCompactService", "First habit name: ${firstHabit["name"]}")

                Log.d("HabitCompactService", "HomeWidget theme mode: $themeMode, Primary color: $primaryColor")                    Log.d("HabitCompactService", "First habit isCompleted: ${firstHabit["isCompleted"]}")

                                }

                habits = emptyList()            } else {

            }                // Debug: Let's see what keys are actually available

        } catch (e: Exception) {                val allKeys = prefs.all.keys

            Log.e("HabitCompactService", "Error loading habit data", e)                Log.d("HabitCompactService", "No habit data found in HomeWidgetPreferences. Available keys: $allKeys")

            habits = emptyList()                

        }                // Also check the theme data in the correct store

    }                val themeMode = prefs.getString("themeMode", null)

                val primaryColor = prefs.getInt("primaryColor", -1)

    private fun loadThemeData() {                Log.d("HabitCompactService", "HomeWidget theme mode: $themeMode, Primary color: $primaryColor")

        try {                

            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)                habits = emptyList()

                        }

            // Load theme mode with fallbacks        } catch (e: Exception) {

            var themeMode = prefs.getString("themeMode", null)             Log.e("HabitCompactService", "Error loading habit data", e)

                ?: prefs.getString("home_widget.double.themeMode", null)            habits = emptyList()

                ?: prefs.getString("flutter.themeMode", null)        }

                }

            // If no explicit theme mode is found, check system theme

            if (themeMode == null) {    private fun loadThemeData() {

                val systemNightMode = context.resources.configuration.uiMode and         try {

                    android.content.res.Configuration.UI_MODE_NIGHT_MASK            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)

                themeMode = when (systemNightMode) {            

                    android.content.res.Configuration.UI_MODE_NIGHT_YES -> "dark"            // Load theme mode with fallbacks

                    android.content.res.Configuration.UI_MODE_NIGHT_NO -> "light"            var themeMode = prefs.getString("themeMode", null) 

                    else -> "light"                ?: prefs.getString("home_widget.double.themeMode", null)

                }                ?: prefs.getString("flutter.themeMode", null)

                Log.d("HabitCompactService", "No saved theme found, using system theme: $themeMode")            

            }            // If no explicit theme mode is found, check system theme

                        if (themeMode == null) {

            Log.d("HabitCompactService", "Detected theme mode: '$themeMode'")                val systemNightMode = context.resources.configuration.uiMode and 

                                android.content.res.Configuration.UI_MODE_NIGHT_MASK

            // Load primary color with fallbacks                themeMode = when (systemNightMode) {

            primaryColor = when {                    android.content.res.Configuration.UI_MODE_NIGHT_YES -> "dark"

                prefs.contains("primaryColor") -> prefs.getInt("primaryColor", 0xFF6200EE.toInt())                    android.content.res.Configuration.UI_MODE_NIGHT_NO -> "light"

                prefs.contains("home_widget.double.primaryColor") -> {                    else -> "light"

                    try {                }

                        prefs.getFloat("home_widget.double.primaryColor", 0xFF6200EE.toFloat()).toInt()                Log.d("HabitCompactService", "No saved theme found, using system theme: $themeMode")

                    } catch (e: Exception) {            }

                        0xFF6200EE.toInt()            

                    }            Log.d("HabitCompactService", "Detected theme mode: '$themeMode'")

                }            

                prefs.contains("flutter.primaryColor") -> prefs.getInt("flutter.primaryColor", 0xFF6200EE.toInt())            // Load primary color with fallbacks

                else -> 0xFF6200EE.toInt()            primaryColor = when {

            }                prefs.contains("primaryColor") -> prefs.getInt("primaryColor", 0xFF6200EE.toInt())

                            prefs.contains("home_widget.double.primaryColor") -> {

            // Set theme-based colors                    try {

            isDarkMode = themeMode.equals("dark", ignoreCase = true)                        prefs.getFloat("home_widget.double.primaryColor", 0xFF6200EE.toFloat()).toInt()

            textColor = if (isDarkMode) 0xFFFFFFFF.toInt() else 0xFF000000.toInt()                    } catch (e: Exception) {

            backgroundColor = if (isDarkMode) 0xFF121212.toInt() else 0xFFFFFFFF.toInt()                        0xFF6200EE.toInt()

                                }

            Log.d("HabitCompactService", "Theme applied - isDark: $isDarkMode, textColor: ${Integer.toHexString(textColor)}, primary: ${Integer.toHexString(primaryColor)}")                }

                            prefs.contains("flutter.primaryColor") -> prefs.getInt("flutter.primaryColor", 0xFF6200EE.toInt())

        } catch (e: Exception) {                else -> 0xFF6200EE.toInt()

            Log.e("HabitCompactService", "Error loading theme data, using defaults", e)            }

            // Fallback to light theme            

            isDarkMode = false            // Set theme-based colors

            textColor = 0xFF000000.toInt()            isDarkMode = themeMode.equals("dark", ignoreCase = true)

            backgroundColor = 0xFFFFFFFF.toInt()            textColor = if (isDarkMode) 0xFFFFFFFF.toInt() else 0xFF000000.toInt()

            primaryColor = 0xFF6200EE.toInt()            backgroundColor = if (isDarkMode) 0xFF121212.toInt() else 0xFFFFFFFF.toInt()

        }            

    }            Log.d("HabitCompactService", "Theme applied - isDark: $isDarkMode, textColor: ${Integer.toHexString(textColor)}, primary: ${Integer.toHexString(primaryColor)}")

}            
        } catch (e: Exception) {
            Log.e("HabitCompactService", "Error loading theme data, using defaults", e)
            // Fallback to light theme
            isDarkMode = false
            textColor = 0xFF000000.toInt()
            backgroundColor = 0xFFFFFFFF.toInt()
            primaryColor = 0xFF6200EE.toInt()
        }
    }
}
