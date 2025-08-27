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
        "TOTAL_CALORIES_BURNED" to TotalCaloriesBurnedRecord::class,
        "SLEEP_IN_BED" to SleepSessionRecord::class,
        "WATER" to HydrationRecord::class,
        "WEIGHT" to WeightRecord::class,
        "HEART_RATE" to HeartRateRecord::class
    ).apply {
        // Try to add MindfulnessSessionRecord if available
        try {
            val mindfulnessClass = Class.forName("androidx.health.connect.client.records.MindfulnessSessionRecord").kotlin as KClass<out Record>
            this["MINDFULNESS"] = mindfulnessClass
            Log.i("MinimalHealthPlugin", "MindfulnessSessionRecord is available and added to ALLOWED_DATA_TYPES")
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
            
            // Try to add MindfulnessSessionRecord permission if available
            try {
                val mindfulnessClass = Class.forName("androidx.health.connect.client.records.MindfulnessSessionRecord").kotlin as KClass<out Record>
                permissions.add(HealthPermission.getReadPermission(mindfulnessClass))
                Log.i("MinimalHealthPlugin", "Added MindfulnessSessionRecord permission")
            } catch (e: ClassNotFoundException) {
                Log.w("MinimalHealthPlugin", "MindfulnessSessionRecord permission not available: ${e.message}")
            } catch (e: Exception) {
                Log.e("MinimalHealthPlugin", "Error adding MindfulnessSessionRecord permission: ${e.message}", e)
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
            "android.permission.health.READ_HEART_RATE"
        )
        
        // Add MINDFULNESS permission if available
        if (ALLOWED_DATA_TYPES.containsKey("MINDFULNESS")) {
            permissions.add("android.permission.health.READ_MINDFULNESS")
        }
        
        return permissions
    }
    
    // Helper function to get heart rate permission for comparison
    private val HEART_RATE_PERMISSION = HealthPermission.getReadPermission(HeartRateRecord::class)
    
    // Helper function to convert HealthPermission to permission string
    private fun getPermissionString(permission: HealthPermission): String {
        // Use the permission's toString() method and extract the permission string
        val permissionStr = permission.toString()
        return if (permissionStr.contains("permission=")) {
            permissionStr.substringAfter("permission=").substringBefore(")")
        } else {
            // Fallback: just return the string representation
            permissionStr
        }
    }

    companion object {
        private const val HEALTH_CONNECT_REQUEST_CODE = 1001
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "minimal_health_service")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        
        // Initialize Health Connect client with enhanced error handling and retry logic
        initializeHealthConnectClient()
        
        Log.i("MinimalHealthPlugin", "Plugin attached - supporting ${ALLOWED_DATA_TYPES.size} health data types")
    }
    
    private fun initializeHealthConnectClient() {
        try {
            Log.i("MinimalHealthPlugin", "Initializing Health Connect client...")
            
            // Check if Health Connect is installed first
            try {
                val packageInfo = context.packageManager.getPackageInfo("com.google.android.apps.healthdata", 0)
                Log.i("MinimalHealthPlugin", "Health Connect package found: version ${packageInfo.versionName}, versionCode ${packageInfo.versionCode}")
            } catch (e: Exception) {
                Log.e("MinimalHealthPlugin", "Health Connect package not found - Health Connect is not installed", e)
                return
            }
            
            // Try to create the Health Connect client
            healthConnectClient = HealthConnectClient.getOrCreate(context)
            Log.i("MinimalHealthPlugin", "Health Connect client created successfully")
            
            // Test the client by trying to get granted permissions
            coroutineScope.launch {
                try {
                    val grantedPermissions = healthConnectClient!!.permissionController.getGrantedPermissions()
                    Log.i("MinimalHealthPlugin", "Health Connect client test successful - ${grantedPermissions.size} permissions currently granted")
                } catch (e: Exception) {
                    Log.w("MinimalHealthPlugin", "Health Connect client test failed - client may not be fully functional", e)
                    
                    // Try to reinitialize the client
                    try {
                        Log.i("MinimalHealthPlugin", "Attempting to reinitialize Health Connect client...")
                        healthConnectClient = HealthConnectClient.getOrCreate(context)
                        Log.i("MinimalHealthPlugin", "Health Connect client reinitialized successfully")
                    } catch (reinitError: Exception) {
                        Log.e("MinimalHealthPlugin", "Failed to reinitialize Health Connect client", reinitError)
                        healthConnectClient = null
                    }
                }
            }
            
        } catch (e: Exception) {
            Log.e("MinimalHealthPlugin", "Failed to initialize Health Connect client", e)
            healthConnectClient = null
            
            // Log detailed error information
            Log.e("MinimalHealthPlugin", "Error details: ${e.javaClass.simpleName}: ${e.message}")
            e.printStackTrace()
        }
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
            "requestExactAlarmPermission" -> {
                requestExactAlarmPermission(result)
            }
            "hasExactAlarmPermission" -> {
                hasExactAlarmPermission(result)
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
                    val allGranted = getHealthPermissionStrings().all { permissionString -> grantedPermissions.contains(permissionString) }
                    
                    val status = if (allGranted) {
                        "PERMISSIONS_GRANTED"
                    } else {
                        "INSTALLED"
                    }
                    
                    Log.i("MinimalHealthPlugin", "Health Connect status: $status")
                    Log.i("MinimalHealthPlugin", "Granted permissions: ${grantedPermissions.size}/${getHealthPermissionStrings().size}")
                    
                    result.success(mapOf(
                        "status" to status,
                        "grantedPermissions" to grantedPermissions.size,
                        "totalPermissions" to getHealthPermissionStrings().size,
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
            
            // Log current allowed data types for debugging
            Log.i("MinimalHealthPlugin", "Initialize called with types: ${supportedTypes.joinToString(", ")}")
            Log.i("MinimalHealthPlugin", "Current allowed data types: ${ALLOWED_DATA_TYPES.keys.joinToString(", ")}")
            
            // Validate that only allowed data types are being requested
            val validTypes = mutableListOf<String>()
            for (dataType in supportedTypes) {
                if (!ALLOWED_DATA_TYPES.containsKey(dataType)) {
                    // Special handling for MINDFULNESS - it might not be available on this device/version
                    if (dataType == "MINDFULNESS") {
                        Log.w("MinimalHealthPlugin", "MINDFULNESS was requested but not available on this device/version")
                        Log.w("MinimalHealthPlugin", "This is normal if the Health Connect version doesn't support MindfulnessSessionRecord")
                        // Skip MINDFULNESS but continue with other types
                        continue
                    }
                    
                    Log.e("MinimalHealthPlugin", "FORBIDDEN DATA TYPE DETECTED: $dataType")
                    Log.e("MinimalHealthPlugin", "Available types: ${ALLOWED_DATA_TYPES.keys.joinToString(", ")}")
                    Log.e("MinimalHealthPlugin", "Requested types: ${supportedTypes.joinToString(", ")}")
                    
                    result.error("FORBIDDEN_DATA_TYPE", "Data type $dataType is not allowed", null)
                    return
                } else {
                    validTypes.add(dataType)
                }
            }
            
            Log.i("MinimalHealthPlugin", "Valid types after filtering: ${validTypes.joinToString(", ")}")
            
            Log.i("MinimalHealthPlugin", "Initialized successfully with ${supportedTypes.size} data types: ${supportedTypes.joinToString(", ")}")
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
                val healthPermissionStrings = getHealthPermissionStrings()
                Log.i("MinimalHealthPlugin", "Required permissions (${healthPermissionStrings.size}):")
                healthPermissionStrings.forEach { permissionString ->
                    val isGranted = grantedPermissions.contains(permissionString)
                    Log.i("MinimalHealthPlugin", "  - $permissionString: ${if (isGranted) "GRANTED" else "MISSING"}")
                }
                
                // Check for heart rate permission specifically
                val heartRatePermissionString = "android.permission.health.READ_HEART_RATE"
                val hasHeartRatePermission = grantedPermissions.contains(heartRatePermissionString)
                Log.i("MinimalHealthPlugin", "Heart rate permission: ${if (hasHeartRatePermission) "GRANTED" else "MISSING"}")
                
                // Check for background permission by looking for any permission string containing "BACKGROUND"
                val hasBackgroundPermission = grantedPermissions.any { it.contains("BACKGROUND") }
                Log.i("MinimalHealthPlugin", "Background permission: ${if (hasBackgroundPermission) "GRANTED" else "MISSING"}")
                
                // Check if all required permissions are granted
                val allGranted = healthPermissionStrings.all { permissionString -> grantedPermissions.contains(permissionString) }
                
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
            getHealthPermissions().forEach { permission ->
                Log.i("MinimalHealthPlugin", "  - $permission")
            }
            
            // Create a proper set of HealthPermission objects
            val allPermissions = getHealthPermissions().toMutableSet()
            
            // Add background health data access permission using proper HealthPermission API
            try {
                // Try to get the background permission using the proper API
                val backgroundPermissionString = "android.permission.health.READ_HEALTH_DATA_IN_BACKGROUND"
                
                // Check if we can create a HealthPermission for background access
                // Note: This might not be available in all Health Connect versions
                Log.i("MinimalHealthPlugin", "Attempting to add background health data permission")
                
                // For now, we'll rely on the permissions declared in the manifest
                // The background permission should be automatically included by Health Connect
                // if it's declared in the AndroidManifest.xml
                
            } catch (e: Exception) {
                Log.w("MinimalHealthPlugin", "Could not add background permission via API: ${e.message}")
            }
            
            Log.i("MinimalHealthPlugin", "Final permission set size: ${allPermissions.size}")
            allPermissions.forEach { permission ->
                Log.i("MinimalHealthPlugin", "  - Final permission: $permission")
            }
            
            pendingResult = result
            
            // Launch Health Connect settings to request permissions
            try {
                // Try to open Health Connect settings directly since the permission request intent might not work
                val settingsIntent = Intent().apply {
                    action = "android.settings.HEALTH_CONNECT_SETTINGS"
                }
                activityBinding?.activity?.startActivity(settingsIntent)
                Log.i("MinimalHealthPlugin", "Opened Health Connect settings for ${allPermissions.size} permissions")
                
                // Since we can't directly handle the result, return false to indicate manual setup needed
                result.success(false)
                pendingResult = null
            } catch (e: Exception) {
                Log.e("MinimalHealthPlugin", "Error opening Health Connect settings", e)
                result.error("PERMISSION_ERROR", "Could not open Health Connect settings: ${e.message}", null)
                pendingResult = null
            }
        } catch (e: Exception) {
            Log.e("MinimalHealthPlugin", "Error requesting permissions", e)
            result.error("PERMISSION_ERROR", e.message, null)
            pendingResult = null
        }
    }

    private fun getHealthData(call: MethodCall, result: Result) {
        if (healthConnectClient == null) {
            Log.w("MinimalHealthPlugin", "Health Connect client is null - attempting to reinitialize...")
            initializeHealthConnectClient()
            
            if (healthConnectClient == null) {
                Log.e("MinimalHealthPlugin", "Health Connect client still null after reinitialization")
                result.error("HEALTH_CONNECT_UNAVAILABLE", "Health Connect is not available", null)
                return
            }
        }

        try {
            val dataType = call.argument<String>("dataType") ?: ""
            val startDate = call.argument<Long>("startDate") ?: 0L
            val endDate = call.argument<Long>("endDate") ?: 0L
            
            Log.i("MinimalHealthPlugin", "getHealthData called with:")
            Log.i("MinimalHealthPlugin", "  - dataType: $dataType")
            Log.i("MinimalHealthPlugin", "  - startDate: $startDate (${Instant.ofEpochMilli(startDate)})")
            Log.i("MinimalHealthPlugin", "  - endDate: $endDate (${Instant.ofEpochMilli(endDate)})")
            
            // Special handling for BACKGROUND_HEALTH_DATA
            if (dataType == "BACKGROUND_HEALTH_DATA") {
                Log.i("MinimalHealthPlugin", "Checking background health data access permission")
                
                coroutineScope.launch {
                    try {
                        val grantedPermissions = healthConnectClient!!.permissionController.getGrantedPermissions()
                        val hasBackgroundPermission = grantedPermissions.any { it.contains("BACKGROUND") }
                        
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
                // Special handling for MINDFULNESS - return empty data if not supported
                if (dataType == "MINDFULNESS") {
                    Log.w("MinimalHealthPlugin", "MINDFULNESS data requested but not supported on this device/version")
                    result.success(emptyList<Map<String, Any>>())
                    return
                }
                
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
                    
                    // Create the request with proper type casting to handle generics
                    @Suppress("UNCHECKED_CAST")
                    val request = ReadRecordsRequest(
                        recordType = recordClass as KClass<Record>,
                        timeRangeFilter = timeRangeFilter
                    )
                    
                    try {
                        Log.i("MinimalHealthPlugin", "Executing Health Connect readRecords request for $dataType...")
                        val response = healthConnectClient!!.readRecords(request)
                        Log.i("MinimalHealthPlugin", "Health Connect readRecords completed, processing ${response.records.size} records...")
                        
                        val healthData = response.records.map { record ->
                            try {
                                convertRecordToMap(record, dataType)
                            } catch (e: Exception) {
                                Log.e("MinimalHealthPlugin", "Error converting record to map for $dataType", e)
                                // Return a basic map with error info
                                mapOf(
                                    "type" to dataType,
                                    "timestamp" to System.currentTimeMillis(),
                                    "value" to 0.0,
                                    "unit" to "error",
                                    "error" to e.message
                                )
                            }
                        }
                        
                        Log.i("MinimalHealthPlugin", "Successfully processed ${healthData.size} records for $dataType from ${Instant.ofEpochMilli(startDate)} to ${Instant.ofEpochMilli(endDate)}")
                        
                        // Enhanced logging for different data types
                        when (dataType) {
                            "STEPS" -> {
                                val totalSteps = healthData.sumOf { (it["value"] as? Double) ?: 0.0 }.toInt()
                                Log.i("MinimalHealthPlugin", "Total steps in range: $totalSteps")
                                if (healthData.isEmpty()) {
                                    Log.w("MinimalHealthPlugin", "No steps data found - check if Zepp app is syncing step data to Health Connect")
                                }
                            }
                            "ACTIVE_ENERGY_BURNED" -> {
                                val totalCalories = healthData.sumOf { (it["value"] as? Double) ?: 0.0 }
                                Log.i("MinimalHealthPlugin", "Total active calories in range: ${totalCalories.toInt()} cal")
                                if (healthData.isEmpty()) {
                                    Log.w("MinimalHealthPlugin", "No active calories records found! Troubleshooting:")
                                    Log.w("MinimalHealthPlugin", "1. Check if Zepp app is syncing calories to Health Connect")
                                    Log.w("MinimalHealthPlugin", "2. Verify Health Connect has active calories permission")
                                    Log.w("MinimalHealthPlugin", "3. Ensure your watch is recording physical activities")
                                }
                            }
                            "TOTAL_CALORIES_BURNED" -> {
                                val totalCalories = healthData.sumOf { (it["value"] as? Double) ?: 0.0 }
                                Log.i("MinimalHealthPlugin", "Total calories burned in range: ${totalCalories.toInt()} cal")
                                if (healthData.isEmpty()) {
                                    Log.w("MinimalHealthPlugin", "No total calories records found! Check Google Fit integration")
                                }
                            }
                            "HEART_RATE" -> {
                                if (healthData.isNotEmpty()) {
                                    val avgHeartRate = healthData.mapNotNull { it["value"] as? Double }.average()
                                    Log.i("MinimalHealthPlugin", "Average heart rate in range: ${avgHeartRate.toInt()} bpm")
                                } else {
                                    Log.w("MinimalHealthPlugin", "No heart rate data found - check if Zepp app is syncing heart rate to Health Connect")
                                }
                            }
                            "SLEEP_IN_BED" -> {
                                if (healthData.isNotEmpty()) {
                                    val totalSleepMinutes = healthData.sumOf { (it["value"] as? Double) ?: 0.0 }
                                    Log.i("MinimalHealthPlugin", "Total sleep time in range: ${(totalSleepMinutes / 60).toInt()} hours")
                                } else {
                                    Log.w("MinimalHealthPlugin", "No sleep data found - check if Zepp app is syncing sleep data to Health Connect")
                                }
                            }
                        }
                        
                        result.success(healthData)
                    } catch (e: NoSuchMethodError) {
                        Log.e("MinimalHealthPlugin", "Health Connect version compatibility issue for $dataType: ${e.message}", e)
                        Log.w("MinimalHealthPlugin", "This may be due to Health Connect version mismatch. Returning empty data.")
                        result.success(emptyList<Map<String, Any>>())
                    } catch (e: Exception) {
                        // Check if it's a specific Health Connect compatibility error
                        if (e.message?.contains("ZoneOffset") == true || e.message?.contains("getStartZoneOffset") == true) {
                            Log.w("MinimalHealthPlugin", "Health Connect compatibility issue detected for $dataType. This may be due to version mismatch.")
                            result.success(emptyList<Map<String, Any>>())
                        } else {
                            throw e // Re-throw other exceptions to be handled by outer catch
                        }
                    }
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
                Log.d("MinimalHealthPlugin", "Active calories record: ${record.energy.inCalories} cal at ${Instant.ofEpochMilli(record.startTime.toEpochMilli())}")
            }
            is TotalCaloriesBurnedRecord -> {
                map["timestamp"] = record.startTime.toEpochMilli()
                map["value"] = record.energy.inCalories
                map["unit"] = "calories"
                Log.d("MinimalHealthPlugin", "Total calories record: ${record.energy.inCalories} cal at ${Instant.ofEpochMilli(record.startTime.toEpochMilli())}")
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
                // HydrationRecord has startTime and endTime, not a single time property
                map["timestamp"] = record.startTime.toEpochMilli()
                map["value"] = record.volume.inLiters
                map["unit"] = "liters"
                map["endTime"] = record.endTime.toEpochMilli()
            }
            is WeightRecord -> {
                // WeightRecord is an InstantRecord - try different approaches to get time
                try {
                    // Try direct property access first
                    val timeField = record.javaClass.getDeclaredField("time")
                    timeField.isAccessible = true
                    val time = timeField.get(record) as Instant
                    map["timestamp"] = time.toEpochMilli()
                } catch (e: Exception) {
                    try {
                        // Fallback: try getTime() method
                        val timeMethod = record.javaClass.getMethod("getTime")
                        val time = timeMethod.invoke(record) as Instant
                        map["timestamp"] = time.toEpochMilli()
                    } catch (e2: Exception) {
                        Log.w("MinimalHealthPlugin", "Error getting time from WeightRecord, using current time", e2)
                        map["timestamp"] = System.currentTimeMillis()
                    }
                }
                map["value"] = record.weight.inKilograms
                map["unit"] = "kg"
            }
            is HeartRateRecord -> {
                // HeartRateRecord is an InstantRecord - try different approaches to get time
                try {
                    // Try direct property access first
                    val timeField = record.javaClass.getDeclaredField("time")
                    timeField.isAccessible = true
                    val time = timeField.get(record) as Instant
                    map["timestamp"] = time.toEpochMilli()
                } catch (e: Exception) {
                    try {
                        // Fallback: try getTime() method
                        val timeMethod = record.javaClass.getMethod("getTime")
                        val time = timeMethod.invoke(record) as Instant
                        map["timestamp"] = time.toEpochMilli()
                    } catch (e2: Exception) {
                        Log.w("MinimalHealthPlugin", "Error getting time from HeartRateRecord, using current time", e2)
                        map["timestamp"] = System.currentTimeMillis()
                    }
                }
                
                // HeartRateRecord has samples - use direct property access
                if (record.samples.isNotEmpty()) {
                    // Take the first sample's BPM value
                    val firstSample = record.samples.first()
                    map["value"] = firstSample.beatsPerMinute.toDouble()
                    
                    Log.d("MinimalHealthPlugin", "Heart rate record: ${firstSample.beatsPerMinute} bpm, samples: ${record.samples.size}")
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
                        
                        // Try to get title if available
                        try {
                            val titleMethod = record.javaClass.getMethod("getTitle")
                            val title = titleMethod.invoke(record) as String?
                            title?.let { map["title"] = it }
                        } catch (e: Exception) {
                            // Title method not available, ignore
                        }
                        
                        // Try to get notes if available
                        try {
                            val notesMethod = record.javaClass.getMethod("getNotes")
                            val notes = notesMethod.invoke(record) as String?
                            notes?.let { map["notes"] = it }
                        } catch (e: Exception) {
                            // Notes method not available, ignore
                        }
                        
                        Log.d("MinimalHealthPlugin", "Mindfulness record: ${map["value"]} minutes from ${Instant.ofEpochMilli(startTime.toEpochMilli())} to ${Instant.ofEpochMilli(endTime.toEpochMilli())}")
                    } catch (e: Exception) {
                        Log.w("MinimalHealthPlugin", "Error processing MindfulnessSessionRecord", e)
                        map["timestamp"] = System.currentTimeMillis()
                        map["value"] = 0.0
                        map["unit"] = "minutes"
                    }
                } else {
                    Log.w("MinimalHealthPlugin", "Unknown record type: ${record.javaClass.simpleName}")
                    map["timestamp"] = System.currentTimeMillis()
                    map["value"] = 0.0
                    map["unit"] = "unknown"
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
                        val heartRatePermissionString = "android.permission.health.READ_HEART_RATE"
                        val hasHeartRatePermission = grantedPermissions.contains(heartRatePermissionString)
                        Log.i("MinimalHealthPlugin", "Heart rate permission after request: ${if (hasHeartRatePermission) "GRANTED" else "MISSING"}")
                        
                        // Check for background permission specifically
                        val hasBackgroundPermission = grantedPermissions.any { it.contains("BACKGROUND") }
                        Log.i("MinimalHealthPlugin", "Background permission after request: ${if (hasBackgroundPermission) "GRANTED" else "MISSING"}")
                        
                        // Check if all required permissions are granted
                        val healthPermissionStrings = getHealthPermissionStrings()
                        val allGranted = healthPermissionStrings.all { permissionString -> grantedPermissions.contains(permissionString) }
                        
                        // Log missing permissions if any
                        if (!allGranted) {
                            val missingPermissions = healthPermissionStrings.filter { permissionString -> !grantedPermissions.contains(permissionString) }
                            Log.w("MinimalHealthPlugin", "Missing permissions after request (${missingPermissions.size}):")
                            missingPermissions.forEach { permissionString ->
                                Log.w("MinimalHealthPlugin", "  - $permissionString")
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

    /**
     * Request exact alarm permission for scheduling precise notifications
     * For Android 13+ with USE_EXACT_ALARM: Permission is automatically granted
     * For Android 12: Still requires SCHEDULE_EXACT_ALARM with manual request
     */
    private fun requestExactAlarmPermission(result: Result) {
        try {
            Log.i("MinimalHealthPlugin", "Requesting exact alarm permission...")
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                // Android 13+ (API 33+) with USE_EXACT_ALARM permission
                // This permission is automatically granted upon app installation
                val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
                val hasPermission = alarmManager.canScheduleExactAlarms()
                
                if (hasPermission) {
                    Log.i("MinimalHealthPlugin", "USE_EXACT_ALARM permission automatically granted on Android 13+")
                    result.success(true)
                } else {
                    // This should not happen with USE_EXACT_ALARM, but handle gracefully
                    Log.w("MinimalHealthPlugin", "USE_EXACT_ALARM permission not granted - this is unexpected")
                    result.success(false)
                }
                return
            }
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                // Android 12 (API 31-32) still requires manual SCHEDULE_EXACT_ALARM request
                val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
                
                // Check if we already have the permission
                if (alarmManager.canScheduleExactAlarms()) {
                    Log.i("MinimalHealthPlugin", "SCHEDULE_EXACT_ALARM permission already granted")
                    result.success(true)
                    return
                }
                
                // Request the permission by opening the system settings
                try {
                    val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
                        data = Uri.parse("package:${context.packageName}")
                        flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    }
                    context.startActivity(intent)
                    
                    Log.i("MinimalHealthPlugin", "Opened SCHEDULE_EXACT_ALARM permission settings for Android 12")
                    
                    // Note: We can't directly get the result of this permission request
                    // The app will need to check the permission status when it resumes
                    result.success(true)
                } catch (e: Exception) {
                    Log.e("MinimalHealthPlugin", "Failed to open exact alarm permission settings", e)
                    result.error("PERMISSION_ERROR", "Failed to request exact alarm permission: ${e.message}", null)
                }
            } else {
                // For Android < 12, exact alarms don't require special permission
                Log.i("MinimalHealthPlugin", "Exact alarm permission not required for Android < 12")
                result.success(true)
            }
        } catch (e: Exception) {
            Log.e("MinimalHealthPlugin", "Error requesting exact alarm permission", e)
            result.error("PERMISSION_ERROR", "Failed to request exact alarm permission: ${e.message}", null)
        }
    }

    /**
     * Check if exact alarm permission is granted
     * For Android 13+ with USE_EXACT_ALARM: Should be automatically granted
     * For Android 12: Requires SCHEDULE_EXACT_ALARM with manual grant
     * For Android < 12: No special permission required
     */
    private fun hasExactAlarmPermission(result: Result) {
        try {
            Log.i("MinimalHealthPlugin", "Checking exact alarm permission...")
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                // Android 13+ (API 33+) with USE_EXACT_ALARM permission
                // This should be automatically granted upon app installation
                val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
                val hasPermission = alarmManager.canScheduleExactAlarms()
                
                Log.i("MinimalHealthPlugin", "USE_EXACT_ALARM permission status on Android 13+: $hasPermission")
                result.success(hasPermission)
                return
            }
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                // Android 12 (API 31-32) with SCHEDULE_EXACT_ALARM permission
                val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
                val hasPermission = alarmManager.canScheduleExactAlarms()
                
                Log.i("MinimalHealthPlugin", "SCHEDULE_EXACT_ALARM permission status on Android 12: $hasPermission")
                result.success(hasPermission)
            } else {
                // For Android < 12, exact alarms don't require special permission
                Log.i("MinimalHealthPlugin", "Exact alarm permission not required for Android < 12")
                result.success(true)
            }
        } catch (e: Exception) {
            Log.e("MinimalHealthPlugin", "Error checking exact alarm permission", e)
            result.error("PERMISSION_ERROR", "Failed to check exact alarm permission: ${e.message}", null)
        }
    }
}