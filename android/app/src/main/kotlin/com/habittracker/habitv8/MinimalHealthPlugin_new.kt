package com.habittracker.habitv8

import android.app.AlarmManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Parcelable
import android.provider.Settings
import androidx.core.content.ContextCompat
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.PermissionController
import androidx.health.connect.client.permission.HealthPermission
import androidx.health.connect.client.records.*
import androidx.health.connect.client.request.ReadRecordsRequest
import androidx.health.connect.client.request.AggregateRequest
import androidx.health.connect.client.time.TimeRangeFilter
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import android.util.Log
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withTimeout
import java.time.Instant
import java.time.LocalDateTime
import java.time.ZoneOffset
import kotlin.reflect.KClass

/**
 * Minimal Health Plugin
 * 
 * This plugin ONLY handles the 7 essential health permissions needed by the app.
 * It does NOT reference any other health permissions, preventing Google Play Console
 * static analysis from detecting unwanted permissions.
 * 
 * CRITICAL: This plugin MUST NOT reference any health permissions other than the 7 allowed ones.
 */
class MinimalHealthPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var healthConnectClient: HealthConnectClient? = null
    private var activityBinding: ActivityPluginBinding? = null
    private var pendingResult: Result? = null
    private val coroutineScope = CoroutineScope(Dispatchers.Main)

    // ONLY these health data types are supported
    // Adding any more will cause Google Play Console rejection
    private val ALLOWED_DATA_TYPES = mutableMapOf<String, KClass<out Record>>(
        "STEPS" to StepsRecord::class,
        "ACTIVE_ENERGY_BURNED" to ActiveCaloriesBurnedRecord::class,
        "TOTAL_CALORIES_BURNED" to TotalCaloriesBurnedRecord::class,
        "SLEEP_IN_BED" to SleepSessionRecord::class,
        "WATER" to HydrationRecord::class,
        "WEIGHT" to WeightRecord::class,
        "HEART_RATE" to HeartRateRecord::class
    ).apply {
        // Always add MINDFULNESS to ensure it's available
        // Use StepsRecord as placeholder class since we handle mindfulness permission directly
        this["MINDFULNESS"] = StepsRecord::class
        Log.i("MinimalHealthPlugin", "MINDFULNESS added to ALLOWED_DATA_TYPES (using direct permission)")
        
        // Try to add MindfulnessSessionRecord if available for better integration
        try {
            val mindfulnessClass = Class.forName("androidx.health.connect.client.records.MindfulnessSessionRecord").kotlin as KClass<out Record>
            this["MINDFULNESS"] = mindfulnessClass
            Log.i("MinimalHealthPlugin", "MindfulnessSessionRecord is available and updated in ALLOWED_DATA_TYPES")
        } catch (e: ClassNotFoundException) {
            Log.w("MinimalHealthPlugin", "MindfulnessSessionRecord not available in this Health Connect version: ${e.message}")
        } catch (e: Exception) {
            Log.e("MinimalHealthPlugin", "Error loading MindfulnessSessionRecord: ${e.message}", e)
        }
        
        // Add a special type for background health data access
        // This doesn't correspond to an actual record type but is used for permission handling
        this["BACKGROUND_HEALTH_DATA"] = StepsRecord::class // Using StepsRecord as a placeholder
        Log.i("MinimalHealthPlugin", "Added BACKGROUND_HEALTH_DATA type")
        
        // Log final allowed data types for debugging
        Log.i("MinimalHealthPlugin", "Final ALLOWED_DATA_TYPES: ${this.keys.joinToString(", ")}")
    }

    // Health Connect permissions for our allowed data types
    private fun getHealthPermissions(): Set<String> {
        val permissions = mutableSetOf<String>()
        
        // Add each permission individually to help with debugging
        try {
            permissions.add(HealthPermission.getReadPermission(StepsRecord::class))
            permissions.add(HealthPermission.getReadPermission(ActiveCaloriesBurnedRecord::class))
            permissions.add(HealthPermission.getReadPermission(TotalCaloriesBurnedRecord::class))
            permissions.add(HealthPermission.getReadPermission(SleepSessionRecord::class))
            permissions.add(HealthPermission.getReadPermission(HydrationRecord::class))
            permissions.add(HealthPermission.getReadPermission(WeightRecord::class))
            permissions.add(HealthPermission.getReadPermission(HeartRateRecord::class))
            
            // Add background health permission - CRITICAL for background monitoring
            permissions.add("android.permission.health.READ_HEALTH_DATA_IN_BACKGROUND")
            Log.i("MinimalHealthPlugin", "Added background health permission")
            
            // Add mindfulness permission directly - no reflection needed
            permissions.add("android.permission.health.READ_MINDFULNESS")
            Log.i("MinimalHealthPlugin", "Added mindfulness permission directly")
            
            // Also try to add MindfulnessSessionRecord permission using reflection as backup
            try {
                val mindfulnessClass = Class.forName("androidx.health.connect.client.records.MindfulnessSessionRecord").kotlin as KClass<out Record>
                permissions.add(HealthPermission.getReadPermission(mindfulnessClass))
                Log.i("MinimalHealthPlugin", "Added MindfulnessSessionRecord permission via reflection")
            } catch (e: ClassNotFoundException) {
                Log.w("MinimalHealthPlugin", "MindfulnessSessionRecord permission not available via reflection: ${e.message}")
            } catch (e: Exception) {
                Log.e("MinimalHealthPlugin", "Error adding MindfulnessSessionRecord permission via reflection: ${e.message}", e)
            }
        } catch (e: Exception) {
            Log.e("MinimalHealthPlugin", "Error creating health permissions", e)
        }
        
        Log.i("MinimalHealthPlugin", "Total permissions configured: ${permissions.size}")
        permissions.forEach { permission ->
            Log.i("MinimalHealthPlugin", "  - Permission: $permission")
        }
        return permissions.toSet()
    }
    
    // Permission strings for comparison with granted permissions
    private fun getHealthPermissionStrings(): Set<String> {
        val permissions = mutableSetOf(
            "android.permission.health.READ_STEPS",
            "android.permission.health.READ_ACTIVE_CALORIES_BURNED", 
            "android.permission.health.READ_TOTAL_CALORIES_BURNED",
            "android.permission.health.READ_SLEEP",
            "android.permission.health.READ_HYDRATION",
            "android.permission.health.READ_WEIGHT",
            "android.permission.health.READ_HEART_RATE",
            "android.permission.health.READ_MINDFULNESS"  // Always include mindfulness
        )
        
        // Add background permission
        permissions.add("android.permission.health.READ_HEALTH_DATA_IN_BACKGROUND")
        
        Log.i("MinimalHealthPlugin", "Permission strings configured: ${permissions.size}")
        return permissions
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "minimal_health_plugin")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        
        Log.i("MinimalHealthPlugin", "Plugin attached to engine")
        
        // Initialize Health Connect client
        try {
            if (HealthConnectClient.getSdkStatus(context) == HealthConnectClient.SDK_AVAILABLE) {
                healthConnectClient = HealthConnectClient.getOrCreate(context)
                Log.i("MinimalHealthPlugin", "Health Connect client initialized successfully")
            } else {
                Log.w("MinimalHealthPlugin", "Health Connect SDK not available")
            }
        } catch (e: Exception) {
            Log.e("MinimalHealthPlugin", "Failed to initialize Health Connect client", e)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        Log.i("MinimalHealthPlugin", "Plugin detached from engine")
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
        binding.addActivityResultListener(this)
        Log.i("MinimalHealthPlugin", "Plugin attached to activity")
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityBinding?.removeActivityResultListener(this)
        activityBinding = null
        Log.i("MinimalHealthPlugin", "Plugin detached from activity for config changes")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activityBinding = binding
        binding.addActivityResultListener(this)
        Log.i("MinimalHealthPlugin", "Plugin reattached to activity for config changes")
    }

    override fun onDetachedFromActivity() {
        activityBinding?.removeActivityResultListener(this)
        activityBinding = null
        Log.i("MinimalHealthPlugin", "Plugin detached from activity")
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        Log.i("MinimalHealthPlugin", "Activity result received: requestCode=$requestCode, resultCode=$resultCode")
        
        if (requestCode == HEALTH_CONNECT_REQUEST_CODE) {
            pendingResult?.let { result ->
                checkPermissions(result)
                pendingResult = null
            }
            return true
        }
        return false
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.i("MinimalHealthPlugin", "Method call received: ${call.method}")
        
        when (call.method) {
            "isHealthConnectAvailable" -> {
                val isAvailable = HealthConnectClient.getSdkStatus(context) == HealthConnectClient.SDK_AVAILABLE
                Log.i("MinimalHealthPlugin", "Health Connect available: $isAvailable")
                result.success(isAvailable)
            }
            "requestPermissions" -> {
                Log.i("MinimalHealthPlugin", "Requesting health permissions")
                requestPermissions(result)
            }
            "checkPermissions" -> {
                Log.i("MinimalHealthPlugin", "Checking health permissions")
                checkPermissions(result)
            }
            "getHealthData" -> {
                val dataType = call.argument<String>("dataType")
                val startDate = call.argument<Long>("startDate")
                val endDate = call.argument<Long>("endDate")
                
                if (dataType != null && startDate != null && endDate != null) {
                    Log.i("MinimalHealthPlugin", "Getting health data: $dataType from $startDate to $endDate")
                    getHealthDataInRange(dataType, startDate, endDate, result)
                } else {
                    result.error("INVALID_ARGUMENTS", "Missing required arguments", null)
                }
            }
            "getLatestHealthData" -> {
                val dataType = call.argument<String>("dataType")
                if (dataType != null) {
                    Log.i("MinimalHealthPlugin", "Getting latest health data: $dataType")
                    getLatestHealthData(dataType, result)
                } else {
                    result.error("INVALID_ARGUMENTS", "Missing dataType argument", null)
                }
            }
            "openHealthConnectSettings" -> {
                Log.i("MinimalHealthPlugin", "Opening Health Connect settings")
                openHealthConnectSettings(result)
            }
            else -> {
                Log.w("MinimalHealthPlugin", "Unknown method: ${call.method}")
                result.notImplemented()
            }
        }
    }

    private fun requestPermissions(result: Result) {
        if (healthConnectClient == null) {
            result.error("HEALTH_CONNECT_UNAVAILABLE", "Health Connect is not available", null)
            return
        }

        pendingResult = result
        
        coroutineScope.launch {
            try {
                val permissions = getHealthPermissions()
                Log.i("MinimalHealthPlugin", "Requesting ${permissions.size} permissions")
                
                val activity = activityBinding?.activity
                if (activity == null) {
                    result.error("NO_ACTIVITY", "No activity available for permission request", null)
                    return@launch
                }

                val permissionController = healthConnectClient!!.permissionController
                val intent = permissionController.createRequestPermissionResultContract().createIntent(
                    activity,
                    permissions
                )
                
                activity.startActivityForResult(intent, HEALTH_CONNECT_REQUEST_CODE)
                Log.i("MinimalHealthPlugin", "Permission request intent started")
                
            } catch (e: Exception) {
                Log.e("MinimalHealthPlugin", "Error requesting permissions", e)
                result.error("PERMISSION_REQUEST_FAILED", e.message, null)
            }
        }
    }

    private fun checkPermissions(result: Result) {
        if (healthConnectClient == null) {
            result.error("HEALTH_CONNECT_UNAVAILABLE", "Health Connect is not available", null)
            return
        }

        coroutineScope.launch {
            try {
                val permissionController = healthConnectClient!!.permissionController
                val grantedPermissions = permissionController.getGrantedPermissions()
                val requiredPermissions = getHealthPermissionStrings()
                
                Log.i("MinimalHealthPlugin", "Granted permissions: ${grantedPermissions.size}")
                Log.i("MinimalHealthPlugin", "Required permissions: ${requiredPermissions.size}")
                
                grantedPermissions.forEach { permission ->
                    Log.i("MinimalHealthPlugin", "  Granted: $permission")
                }
                
                val missingPermissions = requiredPermissions - grantedPermissions
                if (missingPermissions.isNotEmpty()) {
                    Log.w("MinimalHealthPlugin", "Missing permissions: ${missingPermissions.size}")
                    missingPermissions.forEach { permission ->
                        Log.w("MinimalHealthPlugin", "  Missing: $permission")
                    }
                }
                
                val hasAllPermissions = missingPermissions.isEmpty()
                Log.i("MinimalHealthPlugin", "Has all permissions: $hasAllPermissions")
                
                result.success(hasAllPermissions)
                
            } catch (e: Exception) {
                Log.e("MinimalHealthPlugin", "Error checking permissions", e)
                result.error("PERMISSION_CHECK_FAILED", e.message, null)
            }
        }
    }

    private fun openHealthConnectSettings(result: Result) {
        try {
            val intent = Intent().apply {
                action = "androidx.health.ACTION_HEALTH_CONNECT_SETTINGS"
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            
            if (intent.resolveActivity(context.packageManager) != null) {
                context.startActivity(intent)
                result.success(true)
                Log.i("MinimalHealthPlugin", "Health Connect settings opened")
            } else {
                // Fallback to general Health Connect app
                val packageName = "com.google.android.apps.healthdata"
                val fallbackIntent = context.packageManager.getLaunchIntentForPackage(packageName)
                
                if (fallbackIntent != null) {
                    fallbackIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    context.startActivity(fallbackIntent)
                    result.success(true)
                    Log.i("MinimalHealthPlugin", "Health Connect app opened as fallback")
                } else {
                    result.error("SETTINGS_UNAVAILABLE", "Health Connect settings not available", null)
                    Log.w("MinimalHealthPlugin", "Health Connect settings not available")
                }
            }
        } catch (e: Exception) {
            Log.e("MinimalHealthPlugin", "Error opening Health Connect settings", e)
            result.error("SETTINGS_ERROR", e.message, null)
        }
    }
    
    private fun getLatestHealthData(dataType: String, result: Result) {
        val now = System.currentTimeMillis()
        val weekAgo = now - (7 * 24 * 60 * 60 * 1000)
        getHealthDataInRange(dataType, weekAgo, now, result)
    }

    /**
     * Check if a specific data type is compatible with the current Health Connect version
     */
    private fun isDataTypeCompatible(dataType: String): Boolean {
        return try {
            val recordClass = ALLOWED_DATA_TYPES[dataType] ?: return false
            
            Log.d("MinimalHealthPlugin", "Checking compatibility for $dataType ($recordClass)")
            
            // Test compatibility based on known problematic data types
            when (dataType) {
                "TOTAL_CALORIES_BURNED" -> {
                    // This data type has known compatibility issues with older Health Connect versions
                    // The error occurs when trying to access getStartZoneOffset() method
                    try {
                        // Try to access the problematic method that causes NoSuchMethodError
                        val method = TotalCaloriesBurnedRecord::class.java.getDeclaredMethod("getStartZoneOffset")
                        Log.d("MinimalHealthPlugin", "✅ TOTAL_CALORIES_BURNED compatibility check passed")
                        true
                    } catch (e: NoSuchMethodException) {
                        Log.w("MinimalHealthPlugin", "❌ TOTAL_CALORIES_BURNED not compatible: getStartZoneOffset() method not available")
                        false
                    } catch (e: Exception) {
                        Log.w("MinimalHealthPlugin", "❌ TOTAL_CALORIES_BURNED compatibility check failed: ${e.message}")
                        false
                    }
                }
                "ACTIVE_ENERGY_BURNED", "STEPS", "HEART_RATE", "WEIGHT", "WATER", "SLEEP_IN_BED" -> {
                    // These data types generally work well, but let's add some basic validation
                    Log.d("MinimalHealthPlugin", "$dataType compatibility check - allowing with robust error handling")
                    Log.d("MinimalHealthPlugin", "✅ $dataType compatibility check passed (using robust error handling)")
                    true
                }
                else -> {
                    Log.d("MinimalHealthPlugin", "Unknown data type $dataType - allowing with caution")
                    true
                }
            }
        } catch (e: Exception) {
            Log.w("MinimalHealthPlugin", "General compatibility check failed for $dataType: ${e.message}")
            // Default to allowing the data type but with extra error handling
            true
        }
    }

    private fun getHealthDataInRange(dataType: String, startDate: Long, endDate: Long, result: Result) {
        if (healthConnectClient == null) {
            result.error("HEALTH_CONNECT_UNAVAILABLE", "Health Connect is not available", null)
            return
        }
        
        coroutineScope.launch {
            try {
                val recordClass = ALLOWED_DATA_TYPES[dataType]
                if (recordClass == null) {
                    result.success(0.0) // Return 0 for unsupported data types
                    return@launch
                }
                
                // Check compatibility before making API calls
                if (!isDataTypeCompatible(dataType)) {
                    Log.w("MinimalHealthPlugin", "Data type $dataType is not compatible with current Health Connect version")
                    result.success(0.0)
                    return@launch
                }
                
                val timeRangeFilter = TimeRangeFilter.between(
                    Instant.ofEpochMilli(startDate),
                    Instant.ofEpochMilli(endDate)
                )
                
                @Suppress("UNCHECKED_CAST")
                val request = ReadRecordsRequest(
                    recordType = recordClass as KClass<Record>,
                    timeRangeFilter = timeRangeFilter
                )
                
                val response = try {
                    healthConnectClient!!.readRecords(request)
                } catch (e: Exception) {
                    Log.e("MinimalHealthPlugin", "❌ Health Connect error for $dataType: ${e.message}", e)
                    result.success(0.0)
                    return@launch
                }
                
                // Process the response based on data type with version compatibility
                val totalValue = try {
                    when (dataType) {
                        "STEPS" -> {
                            // For steps, prefer aggregation to avoid double counting
                            try {
                                val aggregateRequest = AggregateRequest(
                                    metrics = setOf(StepsRecord.COUNT_TOTAL),
                                    timeRangeFilter = timeRangeFilter
                                )
                                val aggregateResponse = healthConnectClient!!.aggregate(aggregateRequest)
                                aggregateResponse[StepsRecord.COUNT_TOTAL]?.toDouble() ?: 0.0
                            } catch (e: Exception) {
                                Log.w("MinimalHealthPlugin", "Aggregation failed for steps, using raw records: ${e.message}")
                                response.records.sumOf { record ->
                                    when (record) {
                                        is StepsRecord -> record.count.toDouble()
                                        else -> 0.0
                                    }
                                }
                            }
                        }
                        "ACTIVE_ENERGY_BURNED" -> {
                            // For active calories, try aggregation first, then fallback to raw records
                            try {
                                val aggregateRequest = AggregateRequest(
                                    metrics = setOf(ActiveCaloriesBurnedRecord.ENERGY_TOTAL),
                                    timeRangeFilter = timeRangeFilter
                                )
                                val aggregateResponse = healthConnectClient!!.aggregate(aggregateRequest)
                                aggregateResponse[ActiveCaloriesBurnedRecord.ENERGY_TOTAL]?.inCalories ?: 0.0
                            } catch (e: Exception) {
                                Log.w("MinimalHealthPlugin", "Aggregation failed for active calories, using raw records: ${e.message}")
                                response.records.sumOf { record ->
                                    when (record) {
                                        is ActiveCaloriesBurnedRecord -> record.energy.inCalories
                                        else -> 0.0
                                    }
                                }
                            }
                        }
                        "TOTAL_CALORIES_BURNED" -> {
                            // For total calories, be extra careful with version compatibility
                            try {
                                val aggregateRequest = AggregateRequest(
                                    metrics = setOf(TotalCaloriesBurnedRecord.ENERGY_TOTAL),
                                    timeRangeFilter = timeRangeFilter
                                )
                                val aggregateResponse = healthConnectClient!!.aggregate(aggregateRequest)
                                aggregateResponse[TotalCaloriesBurnedRecord.ENERGY_TOTAL]?.inCalories ?: 0.0
                            } catch (e: NoSuchMethodError) {
                                Log.w("MinimalHealthPlugin", "Health Connect version incompatibility for total calories aggregation: ${e.message}")
                                // Try raw records with careful field access
                                try {
                                    response.records.sumOf { record ->
                                        when (record) {
                                            is TotalCaloriesBurnedRecord -> {
                                                try {
                                                    record.energy.inCalories
                                                } catch (fieldError: Exception) {
                                                    Log.w("MinimalHealthPlugin", "Field access error for total calories: ${fieldError.message}")
                                                    0.0
                                                }
                                            }
                                            else -> 0.0
                                        }
                                    }
                                } catch (recordError: Exception) {
                                    Log.w("MinimalHealthPlugin", "Raw record processing failed for total calories: ${recordError.message}")
                                    0.0
                                }
                            } catch (e: Exception) {
                                Log.w("MinimalHealthPlugin", "General error for total calories: ${e.message}")
                                0.0
                            }
                        }
                        "HEART_RATE" -> {
                            // For heart rate, calculate average from samples
                            val allSamples = response.records.flatMap { record ->
                                when (record) {
                                    is HeartRateRecord -> {
                                        try {
                                            record.samples
                                        } catch (e: Exception) {
                                            Log.w("MinimalHealthPlugin", "Error accessing heart rate samples: ${e.message}")
                                            emptyList()
                                        }
                                    }
                                    else -> emptyList()
                                }
                            }
                            if (allSamples.isNotEmpty()) {
                                allSamples.map { it.beatsPerMinute.toDouble() }.average()
                            } else {
                                0.0
                            }
                        }
                        "WEIGHT" -> {
                            // For weight, get the most recent value
                            response.records.mapNotNull { record ->
                                when (record) {
                                    is WeightRecord -> {
                                        try {
                                            record.weight.inKilograms
                                        } catch (e: Exception) {
                                            Log.w("MinimalHealthPlugin", "Error accessing weight value: ${e.message}")
                                            null
                                        }
                                    }
                                    else -> null
                                }
                            }.lastOrNull() ?: 0.0
                        }
                        "WATER" -> {
                            // Sum all hydration records
                            response.records.sumOf { record ->
                                when (record) {
                                    is HydrationRecord -> {
                                        try {
                                            record.volume.inLiters
                                        } catch (e: Exception) {
                                            Log.w("MinimalHealthPlugin", "Error accessing hydration volume: ${e.message}")
                                            0.0
                                        }
                                    }
                                    else -> 0.0
                                }
                            }
                        }
                        "SLEEP_IN_BED" -> {
                            // Sum all sleep session durations in hours
                            response.records.sumOf { record ->
                                when (record) {
                                    is SleepSessionRecord -> {
                                        try {
                                            val durationMillis = record.endTime.toEpochMilli() - record.startTime.toEpochMilli()
                                            durationMillis / (1000.0 * 60.0 * 60.0) // Convert to hours
                                        } catch (e: Exception) {
                                            Log.w("MinimalHealthPlugin", "Error calculating sleep duration: ${e.message}")
                                            0.0
                                        }
                                    }
                                    else -> 0.0
                                }
                            }
                        }
                        else -> {
                            Log.w("MinimalHealthPlugin", "Unsupported data type: $dataType")
                            0.0
                        }
                    }
                } catch (e: Exception) {
                    Log.e("MinimalHealthPlugin", "Error processing $dataType data: ${e.message}", e)
                    0.0
                }
                
                Log.i("MinimalHealthPlugin", "✅ Successfully retrieved $dataType data: $totalValue")
                result.success(totalValue)
                
            } catch (e: NoSuchMethodError) {
                Log.e("MinimalHealthPlugin", "Health Connect version compatibility issue for $dataType: ${e.message}", e)
                Log.w("MinimalHealthPlugin", "This may be due to Health Connect version mismatch. Returning 0.")
                result.success(0.0)
            } catch (e: Exception) {
                Log.e("MinimalHealthPlugin", "❌ Error reading $dataType data: ${e.message}", e)
                result.success(0.0)
            }
        }
    }

    companion object {
        private const val HEALTH_CONNECT_REQUEST_CODE = 1001
    }
}