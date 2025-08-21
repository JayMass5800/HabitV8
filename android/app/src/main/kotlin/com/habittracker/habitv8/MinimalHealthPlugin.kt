package com.habittracker.habitv8

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import androidx.core.content.ContextCompat
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.PermissionController
import androidx.health.connect.client.permission.HealthPermission
import androidx.health.connect.client.records.*
import androidx.health.connect.client.request.ReadRecordsRequest
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
        "SLEEP_IN_BED" to SleepSessionRecord::class,
        "WATER" to HydrationRecord::class,
        "WEIGHT" to WeightRecord::class,
        "HEART_RATE" to HeartRateRecord::class
    ).apply {
        // Try to add MindfulnessSessionRecord if available
        try {
            val mindfulnessClass = Class.forName("androidx.health.connect.client.records.MindfulnessSessionRecord").kotlin as KClass<out Record>
            this["MINDFULNESS"] = mindfulnessClass
            Log.i("MinimalHealthPlugin", "MindfulnessSessionRecord is available")
        } catch (e: ClassNotFoundException) {
            Log.w("MinimalHealthPlugin", "MindfulnessSessionRecord not available in this Health Connect version")
        }
        
        // Add a special type for background health data access
        // This doesn't correspond to an actual record type but is used for permission handling
        this["BACKGROUND_HEALTH_DATA"] = StepsRecord::class // Using StepsRecord as a placeholder
        Log.i("MinimalHealthPlugin", "Added BACKGROUND_HEALTH_DATA type")
    }

    // Health Connect permissions for our allowed data types
    private val HEALTH_PERMISSIONS = mutableSetOf(
        HealthPermission.getReadPermission(StepsRecord::class),
        HealthPermission.getReadPermission(ActiveCaloriesBurnedRecord::class),
        HealthPermission.getReadPermission(SleepSessionRecord::class),
        HealthPermission.getReadPermission(HydrationRecord::class),
        HealthPermission.getReadPermission(WeightRecord::class),
        HealthPermission.getReadPermission(HeartRateRecord::class)
    ).apply {
        // Try to add MindfulnessSessionRecord permission if available
        try {
            val mindfulnessClass = Class.forName("androidx.health.connect.client.records.MindfulnessSessionRecord").kotlin as KClass<out Record>
            this.add(HealthPermission.getReadPermission(mindfulnessClass))
            Log.i("MinimalHealthPlugin", "MindfulnessSessionRecord permission added")
        } catch (e: ClassNotFoundException) {
            Log.w("MinimalHealthPlugin", "MindfulnessSessionRecord permission not available")
        }
        
        // Add background health data access permission directly
        try {
            // Use direct string reference for the background permission
            // This is more reliable than reflection
            this.add("android.permission.health.READ_HEALTH_DATA_IN_BACKGROUND")
            Log.i("MinimalHealthPlugin", "Background health data access permission added directly")
        } catch (e: Exception) {
            Log.w("MinimalHealthPlugin", "Error adding background health data access permission", e)
        }
    }

    companion object {
        private const val HEALTH_CONNECT_REQUEST_CODE = 1001
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "minimal_health_service")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        
        // Initialize Health Connect client - removed SDK version check to ensure it works on all Android versions
        try {
            healthConnectClient = HealthConnectClient.getOrCreate(context)
            Log.i("MinimalHealthPlugin", "Health Connect client initialized successfully")
            
            // Log the Health Connect client details
            val packageInfo = context.packageManager.getPackageInfo("com.google.android.apps.healthdata", 0)
            Log.i("MinimalHealthPlugin", "Health Connect package info: ${packageInfo.versionName}")
        } catch (e: Exception) {
            Log.w("MinimalHealthPlugin", "Health Connect not available or not installed", e)
            
            // Try to check if Health Connect is installed
            try {
                context.packageManager.getPackageInfo("com.google.android.apps.healthdata", 0)
                Log.i("MinimalHealthPlugin", "Health Connect is installed but client initialization failed")
            } catch (e: Exception) {
                Log.w("MinimalHealthPlugin", "Health Connect is not installed", e)
            }
        }
        
        Log.i("MinimalHealthPlugin", "Plugin attached - supporting ${ALLOWED_DATA_TYPES.size} health data types")
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initialize" -> {
                initialize(call, result)
            }
            "hasPermissions" -> {
                checkPermissions(result)
            }
            "requestPermissions" -> {
                requestPermissions(call, result)
            }
            "getHealthData" -> {
                getHealthData(call, result)
            }
            "isHealthConnectAvailable" -> {
                checkHealthConnectAvailability(result)
            }
            "getHealthConnectStatus" -> {
                getHealthConnectStatus(result)
            }
            "startBackgroundMonitoring" -> {
                startBackgroundMonitoring(result)
            }
            "stopBackgroundMonitoring" -> {
                stopBackgroundMonitoring(result)
            }
            "isBackgroundMonitoringActive" -> {
                isBackgroundMonitoringActive(result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
    
    // Check Health Connect availability with detailed status
    private fun checkHealthConnectAvailability(result: Result) {
        try {
            if (healthConnectClient == null) {
                Log.w("MinimalHealthPlugin", "Health Connect client is null")
                result.success(false)
                return
            }
            
            // Try to check if Health Connect is actually functional
            coroutineScope.launch {
                try {
                    // Try to get granted permissions as a test
                    val grantedPermissions = healthConnectClient!!.permissionController.getGrantedPermissions()
                    Log.i("MinimalHealthPlugin", "Health Connect is available and functional")
                    result.success(true)
                } catch (e: Exception) {
                    Log.w("MinimalHealthPlugin", "Health Connect client exists but not functional", e)
                    result.success(false)
                }
            }
        } catch (e: Exception) {
            Log.e("MinimalHealthPlugin", "Error checking Health Connect availability", e)
            result.success(false)
        }
    }
    
    // Get detailed Health Connect status
    private fun getHealthConnectStatus(result: Result) {
        try {
            if (healthConnectClient == null) {
                Log.w("MinimalHealthPlugin", "Health Connect not available")
                result.success(mapOf(
                    "status" to "NOT_INSTALLED",
                    "message" to "Health Connect is not installed or not available"
                ))
                return
            }
            
            coroutineScope.launch {
                try {
                    val grantedPermissions = healthConnectClient!!.permissionController.getGrantedPermissions()
                    
                    // Check if all required permissions are granted
                    val allGranted = HEALTH_PERMISSIONS.all { it in grantedPermissions }
                    
                    val status = if (allGranted) {
                        "PERMISSIONS_GRANTED"
                    } else {
                        "INSTALLED"
                    }
                    
                    Log.i("MinimalHealthPlugin", "Health Connect status: $status")
                    Log.i("MinimalHealthPlugin", "Granted permissions: ${grantedPermissions.size}/${HEALTH_PERMISSIONS.size}")
                    
                    result.success(mapOf(
                        "status" to status,
                        "grantedPermissions" to grantedPermissions.size,
                        "totalPermissions" to HEALTH_PERMISSIONS.size,
                        "message" to when (status) {
                            "PERMISSIONS_GRANTED" -> "All health permissions are granted"
                            "INSTALLED" -> "Health Connect is installed but permissions need to be enabled"
                            else -> "Unknown status"
                        }
                    ))
                } catch (e: Exception) {
                    Log.e("MinimalHealthPlugin", "Error getting Health Connect status", e)
                    result.success(mapOf(
                        "status" to "ERROR",
                        "message" to "Error checking Health Connect status: ${e.message}"
                    ))
                }
            }
        } catch (e: Exception) {
            Log.e("MinimalHealthPlugin", "Error in getHealthConnectStatus", e)
            result.success(mapOf(
                "status" to "ERROR",
                "message" to "Error checking status: ${e.message}"
            ))
        }
    }
    
    // Start background health monitoring service
    private fun startBackgroundMonitoring(result: Result) {
        try {
            if (activityBinding?.activity == null) {
                Log.e("MinimalHealthPlugin", "Activity not available for starting background service")
                result.error("NO_ACTIVITY", "Activity is required to start background monitoring", null)
                return
            }
            
            val activity = activityBinding!!.activity
            val intent = Intent(activity, HealthMonitoringService::class.java)
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                activity.startForegroundService(intent)
            } else {
                activity.startService(intent)
            }
            
            Log.i("MinimalHealthPlugin", "Background health monitoring service started")
            result.success(true)
        } catch (e: Exception) {
            Log.e("MinimalHealthPlugin", "Error starting background monitoring", e)
            result.error("SERVICE_ERROR", e.message, null)
        }
    }
    
    // Stop background health monitoring service
    private fun stopBackgroundMonitoring(result: Result) {
        try {
            if (activityBinding?.activity == null) {
                Log.e("MinimalHealthPlugin", "Activity not available for stopping background service")
                result.error("NO_ACTIVITY", "Activity is required to stop background monitoring", null)
                return
            }
            
            val activity = activityBinding!!.activity
            val intent = Intent(activity, HealthMonitoringService::class.java)
            activity.stopService(intent)
            
            Log.i("MinimalHealthPlugin", "Background health monitoring service stopped")
            result.success(true)
        } catch (e: Exception) {
            Log.e("MinimalHealthPlugin", "Error stopping background monitoring", e)
            result.error("SERVICE_ERROR", e.message, null)
        }
    }
    
    // Check if background monitoring is active
    private fun isBackgroundMonitoringActive(result: Result) {
        try {
            if (activityBinding?.activity == null) {
                result.success(false)
                return
            }
            
            val activity = activityBinding!!.activity
            val sharedPreferences = activity.getSharedPreferences(
                "com.habittracker.habitv8.health", 
                Context.MODE_PRIVATE
            )
            val isActive = sharedPreferences.getBoolean("health_monitoring_enabled", false)
            
            Log.i("MinimalHealthPlugin", "Background monitoring status: $isActive")
            result.success(isActive)
        } catch (e: Exception) {
            Log.e("MinimalHealthPlugin", "Error checking background monitoring status", e)
            result.success(false)
        }
    }

    private fun initialize(call: MethodCall, result: Result) {
        try {
            val supportedTypes = call.argument<List<String>>("supportedTypes") ?: emptyList()
            
            // Validate that only allowed data types are being requested
            for (dataType in supportedTypes) {
                if (!ALLOWED_DATA_TYPES.containsKey(dataType)) {
                    Log.e("MinimalHealthPlugin", "FORBIDDEN DATA TYPE DETECTED: $dataType")
                    result.error("FORBIDDEN_DATA_TYPE", "Data type $dataType is not allowed", null)
                    return
                }
            }
            
            Log.i("MinimalHealthPlugin", "Initialized with ${supportedTypes.size} data types")
            result.success(healthConnectClient != null)
        } catch (e: Exception) {
            Log.e("MinimalHealthPlugin", "Error during initialization", e)
            result.error("INIT_ERROR", e.message, null)
        }
    }

    private fun checkPermissions(result: Result) {
        if (healthConnectClient == null) {
            Log.w("MinimalHealthPlugin", "Health Connect not available")
            result.success(false)
            return
        }

        coroutineScope.launch {
            try {
                val grantedPermissions = healthConnectClient!!.permissionController.getGrantedPermissions()
                
                // Log all granted permissions for debugging
                Log.i("MinimalHealthPlugin", "Granted permissions (${grantedPermissions.size}):")
                grantedPermissions.forEach { permission ->
                    Log.i("MinimalHealthPlugin", "  - $permission")
                }
                
                // Log all required permissions
                Log.i("MinimalHealthPlugin", "Required permissions (${HEALTH_PERMISSIONS.size}):")
                HEALTH_PERMISSIONS.forEach { permission ->
                    val isGranted = permission in grantedPermissions
                    Log.i("MinimalHealthPlugin", "  - $permission: ${if (isGranted) "GRANTED" else "MISSING"}")
                }
                
                // Check for heart rate permission specifically
                val heartRatePermission = "android.permission.health.READ_HEART_RATE"
                val hasHeartRatePermission = heartRatePermission in grantedPermissions
                Log.i("MinimalHealthPlugin", "Heart rate permission: ${if (hasHeartRatePermission) "GRANTED" else "MISSING"}")
                
                // Check for background permission specifically
                val backgroundPermission = "android.permission.health.READ_HEALTH_DATA_IN_BACKGROUND"
                val hasBackgroundPermission = backgroundPermission in grantedPermissions
                Log.i("MinimalHealthPlugin", "Background permission: ${if (hasBackgroundPermission) "GRANTED" else "MISSING"}")
                
                // Check if all required permissions are granted
                val allGranted = HEALTH_PERMISSIONS.all { it in grantedPermissions }
                
                Log.i("MinimalHealthPlugin", "All permissions granted: $allGranted")
                result.success(allGranted)
            } catch (e: Exception) {
                Log.e("MinimalHealthPlugin", "Error checking permissions", e)
                result.success(false)
            }
        }
    }

    private fun requestPermissions(call: MethodCall, result: Result) {
        if (healthConnectClient == null) {
            Log.w("MinimalHealthPlugin", "Health Connect not available")
            result.error("HEALTH_CONNECT_UNAVAILABLE", "Health Connect is not available", null)
            return
        }

        if (activityBinding?.activity == null) {
            Log.e("MinimalHealthPlugin", "Activity not available for permission request")
            result.error("NO_ACTIVITY", "Activity is required for permission request", null)
            return
        }

        try {
            // Log all permissions being requested for debugging
            Log.i("MinimalHealthPlugin", "Requesting permissions:")
            HEALTH_PERMISSIONS.forEach { permission ->
                Log.i("MinimalHealthPlugin", "  - $permission")
            }
            
            // Ensure background permission is included
            val allPermissions = HEALTH_PERMISSIONS.toMutableSet()
            if (!allPermissions.contains("android.permission.health.READ_HEALTH_DATA_IN_BACKGROUND")) {
                allPermissions.add("android.permission.health.READ_HEALTH_DATA_IN_BACKGROUND")
                Log.i("MinimalHealthPlugin", "Added missing background permission")
            }
            
            pendingResult = result
            val permissionContract = PermissionController.createRequestPermissionResultContract()
            val intent = permissionContract.createIntent(context, allPermissions)
            
            activityBinding?.activity?.startActivityForResult(intent, HEALTH_CONNECT_REQUEST_CODE)
            Log.i("MinimalHealthPlugin", "Permission request started for ${allPermissions.size} permissions")
        } catch (e: Exception) {
            Log.e("MinimalHealthPlugin", "Error requesting permissions", e)
            result.error("PERMISSION_ERROR", e.message, null)
            pendingResult = null
        }
    }

    private fun getHealthData(call: MethodCall, result: Result) {
        if (healthConnectClient == null) {
            Log.w("MinimalHealthPlugin", "Health Connect not available")
            result.error("HEALTH_CONNECT_UNAVAILABLE", "Health Connect is not available", null)
            return
        }

        try {
            val dataType = call.argument<String>("dataType") ?: ""
            val startDate = call.argument<Long>("startDate") ?: 0L
            val endDate = call.argument<Long>("endDate") ?: 0L
            
            // Special handling for BACKGROUND_HEALTH_DATA
            if (dataType == "BACKGROUND_HEALTH_DATA") {
                Log.i("MinimalHealthPlugin", "Checking background health data access permission")
                
                coroutineScope.launch {
                    try {
                        val grantedPermissions = healthConnectClient!!.permissionController.getGrantedPermissions()
                        val hasBackgroundPermission = "android.permission.health.READ_HEALTH_DATA_IN_BACKGROUND" in grantedPermissions
                        
                        Log.i("MinimalHealthPlugin", "Background health data access permission: ${if (hasBackgroundPermission) "GRANTED" else "MISSING"}")
                        
                        // Return a dummy record to indicate permission status
                        val dummyData = listOf(
                            mapOf(
                                "type" to "BACKGROUND_HEALTH_DATA",
                                "timestamp" to System.currentTimeMillis(),
                                "value" to if (hasBackgroundPermission) 1.0 else 0.0,
                                "unit" to "permission",
                                "isGranted" to hasBackgroundPermission
                            )
                        )
                        
                        result.success(dummyData)
                    } catch (e: Exception) {
                        Log.e("MinimalHealthPlugin", "Error checking background health data access", e)
                        result.error("DATA_ERROR", e.message, null)
                    }
                }
                return
            }
            
            // Validate data type
            if (!ALLOWED_DATA_TYPES.containsKey(dataType)) {
                Log.e("MinimalHealthPlugin", "FORBIDDEN DATA TYPE: $dataType")
                result.error("FORBIDDEN_DATA_TYPE", "Data type $dataType is not allowed", null)
                return
            }
            
            coroutineScope.launch {
                try {
                    val recordClass = ALLOWED_DATA_TYPES[dataType]!!
                    val timeRangeFilter = TimeRangeFilter.between(
                        Instant.ofEpochMilli(startDate),
                        Instant.ofEpochMilli(endDate)
                    )
                    
                    val request = ReadRecordsRequest(
                        recordType = recordClass,
                        timeRangeFilter = timeRangeFilter
                    )
                    
                    val response = healthConnectClient!!.readRecords(request)
                    val healthData = response.records.map { record ->
                        convertRecordToMap(record, dataType)
                    }
                    
                    Log.i("MinimalHealthPlugin", "Retrieved ${healthData.size} records for $dataType")
                    result.success(healthData)
                } catch (e: Exception) {
                    Log.e("MinimalHealthPlugin", "Error reading health data", e)
                    result.error("DATA_ERROR", e.message, null)
                }
            }
        } catch (e: Exception) {
            Log.e("MinimalHealthPlugin", "Error getting health data", e)
            result.error("DATA_ERROR", e.message, null)
        }
    }

    private fun convertRecordToMap(record: Record, dataType: String): Map<String, Any> {
        val map = mutableMapOf<String, Any>()
        map["type"] = dataType
        
        when (record) {
            is StepsRecord -> {
                map["timestamp"] = record.startTime.toEpochMilli()
                map["value"] = record.count.toDouble()
                map["unit"] = "steps"
            }
            is ActiveCaloriesBurnedRecord -> {
                map["timestamp"] = record.startTime.toEpochMilli()
                map["value"] = record.energy.inCalories
                map["unit"] = "calories"
            }
            is SleepSessionRecord -> {
                val startTime = record.startTime.toEpochMilli()
                val endTime = record.endTime.toEpochMilli()
                val durationMinutes = (endTime - startTime) / (1000.0 * 60.0)
                
                map["timestamp"] = startTime
                map["value"] = durationMinutes
                map["unit"] = "minutes"
                map["endTime"] = endTime
                
                // Get sleep stage information using direct property access
                val stages = record.stages
                map["stageCount"] = stages.size
                
                Log.d("MinimalHealthPlugin", "Sleep record: ${durationMinutes.toInt()} minutes from ${Instant.ofEpochMilli(startTime)} to ${Instant.ofEpochMilli(endTime)}, stages: ${stages.size}")
                
                // Add title if available
                record.title?.let { title ->
                    map["title"] = title
                    Log.d("MinimalHealthPlugin", "Sleep record title: $title")
                }
                
                // Add notes if available
                record.notes?.let { notes ->
                    map["notes"] = notes
                    Log.d("MinimalHealthPlugin", "Sleep record notes: $notes")
                }
            }
            is HydrationRecord -> {
                // HydrationRecord is an InstantRecord, use reflection for time
                try {
                    val timeMethod = record.javaClass.getMethod("getTime")
                    val time = timeMethod.invoke(record) as Instant
                    map["timestamp"] = time.toEpochMilli()
                } catch (e: Exception) {
                    Log.w("MinimalHealthPlugin", "Error getting time from HydrationRecord", e)
                    map["timestamp"] = System.currentTimeMillis()
                }
                map["value"] = record.volume.inLiters
                map["unit"] = "liters"
            }
            is WeightRecord -> {
                // WeightRecord is an InstantRecord, use reflection for time
                try {
                    val timeMethod = record.javaClass.getMethod("getTime")
                    val time = timeMethod.invoke(record) as Instant
                    map["timestamp"] = time.toEpochMilli()
                } catch (e: Exception) {
                    Log.w("MinimalHealthPlugin", "Error getting time from WeightRecord", e)
                    map["timestamp"] = System.currentTimeMillis()
                }
                map["value"] = record.weight.inKilograms
                map["unit"] = "kg"
            }
            is HeartRateRecord -> {
                // HeartRateRecord is an InstantRecord, use reflection for time
                try {
                    val timeMethod = record.javaClass.getMethod("getTime")
                    val time = timeMethod.invoke(record) as Instant
                    map["timestamp"] = time.toEpochMilli()
                } catch (e: Exception) {
                    Log.w("MinimalHealthPlugin", "Error getting time from HeartRateRecord", e)
                    map["timestamp"] = System.currentTimeMillis()
                }
                
                // HeartRateRecord has samples - use direct property access instead of reflection
                if (record.samples.isNotEmpty()) {
                    // Take the first sample's BPM value
                    val firstSample = record.samples.first()
                    map["value"] = firstSample.beatsPerMinute.toDouble()
                    
                    try {
                        val timeMethod = record.javaClass.getMethod("getTime")
                        val time = timeMethod.invoke(record) as Instant
                        Log.d("MinimalHealthPlugin", "Heart rate record: ${firstSample.beatsPerMinute} bpm at ${time}, samples: ${record.samples.size}")
                    } catch (e: Exception) {
                        Log.d("MinimalHealthPlugin", "Heart rate record: ${firstSample.beatsPerMinute} bpm, samples: ${record.samples.size}")
                    }
                } else {
                    map["value"] = 0.0
                    Log.w("MinimalHealthPlugin", "Heart rate record has no samples")
                }
                map["unit"] = "bpm"
            }
            else -> {
                // Handle MindfulnessSessionRecord dynamically if available
                if (record.javaClass.simpleName == "MindfulnessSessionRecord") {
                    try {
                        val startTimeMethod = record.javaClass.getMethod("getStartTime")
                        val endTimeMethod = record.javaClass.getMethod("getEndTime")
                        val startTime = startTimeMethod.invoke(record) as Instant
                        val endTime = endTimeMethod.invoke(record) as Instant
                        
                        map["timestamp"] = startTime.toEpochMilli()
                        map["value"] = (endTime.toEpochMilli() - startTime.toEpochMilli()) / (1000.0 * 60.0) // minutes
                        map["unit"] = "minutes"
                        map["endTime"] = endTime.toEpochMilli()
                    } catch (e: Exception) {
                        Log.w("MinimalHealthPlugin", "Error processing MindfulnessSessionRecord", e)
                        map["timestamp"] = System.currentTimeMillis()
                        map["value"] = 0.0
                        map["unit"] = "minutes"
                    }
                }
            }
        }
        
        return map
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        Log.i("MinimalHealthPlugin", "Plugin detached")
    }

    // ActivityAware implementation
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
        binding.addActivityResultListener(this)
        Log.i("MinimalHealthPlugin", "Attached to activity")
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityBinding?.removeActivityResultListener(this)
        activityBinding = null
        Log.i("MinimalHealthPlugin", "Detached from activity for config changes")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activityBinding = binding
        binding.addActivityResultListener(this)
        Log.i("MinimalHealthPlugin", "Reattached to activity after config changes")
    }

    override fun onDetachedFromActivity() {
        activityBinding?.removeActivityResultListener(this)
        activityBinding = null
        Log.i("MinimalHealthPlugin", "Detached from activity")
    }

    // ActivityResultListener implementation
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == HEALTH_CONNECT_REQUEST_CODE) {
            Log.i("MinimalHealthPlugin", "Received activity result with code: $resultCode")
            val result = pendingResult
            pendingResult = null
            
            if (result != null) {
                // Check permissions after the request
                coroutineScope.launch {
                    try {
                        val grantedPermissions = healthConnectClient?.permissionController?.getGrantedPermissions() ?: emptySet()
                        
                        // Log all granted permissions for debugging
                        Log.i("MinimalHealthPlugin", "Granted permissions after request (${grantedPermissions.size}):")
                        grantedPermissions.forEach { permission ->
                            Log.i("MinimalHealthPlugin", "  - $permission")
                        }
                        
                        // Check for heart rate permission specifically
                        val heartRatePermission = "android.permission.health.READ_HEART_RATE"
                        val hasHeartRatePermission = heartRatePermission in grantedPermissions
                        Log.i("MinimalHealthPlugin", "Heart rate permission after request: ${if (hasHeartRatePermission) "GRANTED" else "MISSING"}")
                        
                        // Check for background permission specifically
                        val backgroundPermission = "android.permission.health.READ_HEALTH_DATA_IN_BACKGROUND"
                        val hasBackgroundPermission = backgroundPermission in grantedPermissions
                        Log.i("MinimalHealthPlugin", "Background permission after request: ${if (hasBackgroundPermission) "GRANTED" else "MISSING"}")
                        
                        // Check if all required permissions are granted
                        val allGranted = HEALTH_PERMISSIONS.all { it in grantedPermissions }
                        
                        // Log missing permissions if any
                        if (!allGranted) {
                            val missingPermissions = HEALTH_PERMISSIONS.filter { it !in grantedPermissions }
                            Log.w("MinimalHealthPlugin", "Missing permissions after request (${missingPermissions.size}):")
                            missingPermissions.forEach { permission ->
                                Log.w("MinimalHealthPlugin", "  - $permission")
                            }
                        }
                        
                        Log.i("MinimalHealthPlugin", "Permission request result: $allGranted")
                        result.success(allGranted)
                    } catch (e: Exception) {
                        Log.e("MinimalHealthPlugin", "Error checking permissions after request", e)
                        result.success(false)
                    }
                }
            }
            return true
        }
        return false
    }
}