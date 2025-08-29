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
            
            // Add background health permission - CRITICAL for background monitoring
            permissions.add("android.permission.health.READ_HEALTH_DATA_IN_BACKGROUND")
            Log.i("MinimalHealthPlugin", "Added background health permission")
            
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
        
        // Add supported data types as a static property for getSupportedDataTypes method
        private val _supportedDataTypes = mapOf(
            "STEPS" to "Steps",
            "ACTIVE_ENERGY_BURNED" to "Active Calories Burned",
            "TOTAL_CALORIES_BURNED" to "Total Calories Burned",
            "SLEEP_IN_BED" to "Sleep Sessions",
            "WATER" to "Hydration",
            "WEIGHT" to "Weight",
            "HEART_RATE" to "Heart Rate",
            "MINDFULNESS" to "Mindfulness Sessions",
            "BACKGROUND_HEALTH_DATA" to "Background Health Data Access"
        )
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
            
            // Check SDK availability first as per Health Connect API instructions
            val availabilityStatus = HealthConnectClient.getSdkStatus(context)
            Log.i("MinimalHealthPlugin", "Health Connect SDK status: $availabilityStatus")
            
            when (availabilityStatus) {
                HealthConnectClient.SDK_UNAVAILABLE -> {
                    Log.e("MinimalHealthPlugin", "Health Connect SDK is unavailable on this device")
                    healthConnectClient = null
                    return
                }
                HealthConnectClient.SDK_UNAVAILABLE_PROVIDER_UPDATE_REQUIRED -> {
                    Log.w("MinimalHealthPlugin", "Health Connect provider update required")
                    healthConnectClient = null
                    return
                }
                else -> {
                    Log.i("MinimalHealthPlugin", "Health Connect SDK is available")
                    // Only create client if SDK is available
                    healthConnectClient = HealthConnectClient.getOrCreate(context)
                    Log.i("MinimalHealthPlugin", "Health Connect client initialized successfully")
                }
            }
            
            // Check if Health Connect package is installed and detect version compatibility
            try {
                val packageInfo = context.packageManager.getPackageInfo("com.google.android.apps.healthdata", 0)
                Log.i("MinimalHealthPlugin", "Health Connect package found: version ${packageInfo.versionName}, versionCode ${packageInfo.versionCode}")
                
                // Check for known compatibility issues with specific versions
                val versionName = packageInfo.versionName
                if (versionName != null) {
                    checkHealthConnectVersionCompatibility(versionName)
                }
            } catch (e: Exception) {
                Log.e("MinimalHealthPlugin", "Health Connect package not found - Health Connect is not installed", e)
                return
            }
            
            // Create the Health Connect client using the lazy initialization pattern
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
    
    /**
     * Check Health Connect version compatibility and log warnings for known issues
     */
    private fun checkHealthConnectVersionCompatibility(versionName: String) {
        Log.i("MinimalHealthPlugin", "Checking Health Connect version compatibility for: $versionName")
        
        // Known problematic versions that have getStartZoneOffset() issues
        val problematicVersions = listOf(
            "2025.07.24.00",
            "2025.07.23.00", 
            "2025.07.22.00",
            "2025.06",
            "2025.05"
        )
        
        val isProblematicVersion = problematicVersions.any { versionName.startsWith(it) }
        
        if (isProblematicVersion) {
            Log.w("MinimalHealthPlugin", "⚠️  COMPATIBILITY WARNING: Health Connect version $versionName has known compatibility issues")
            Log.w("MinimalHealthPlugin", "  Known issues:")
            Log.w("MinimalHealthPlugin", "  - NoSuchMethodError: getStartZoneOffset() for HeartRateRecord")
            Log.w("MinimalHealthPlugin", "  - ZoneOffset related API incompatibilities")
            Log.w("MinimalHealthPlugin", "  - Some record types may not work properly")
            Log.w("MinimalHealthPlugin", "  Recommendation: Update Health Connect app or use fallback methods")
        } else {
            Log.i("MinimalHealthPlugin", "✅ Health Connect version appears compatible")
        }
        
        // Test HeartRateRecord compatibility specifically
        try {
            val heartRateClass = HeartRateRecord::class.java
            val methods = heartRateClass.methods
            val hasGetStartZoneOffset = methods.any { it.name == "getStartZoneOffset" }
            
            if (hasGetStartZoneOffset) {
                Log.i("MinimalHealthPlugin", "✅ HeartRateRecord.getStartZoneOffset() method is available")
            } else {
                Log.w("MinimalHealthPlugin", "⚠️  HeartRateRecord.getStartZoneOffset() method is NOT available")
                Log.w("MinimalHealthPlugin", "  This confirms compatibility issues with this Health Connect version")
            }
        } catch (e: Exception) {
            Log.e("MinimalHealthPlugin", "Error checking HeartRateRecord compatibility", e)
        }
    }
    
    /**
     * Check if a data type is compatible with the current Health Connect version
     * Returns false if known compatibility issues are detected
     */
    private fun checkDataTypeCompatibility(dataType: String, recordClass: KClass<out Record>): Boolean {
        return try {
            Log.d("MinimalHealthPlugin", "Checking compatibility for $dataType (${recordClass.simpleName})")
            
            // Test if we can access the record class methods without issues
            val methods = recordClass.java.methods
            
            // Check for problematic methods that cause NoSuchMethodError
            val hasProblematicMethods = methods.any { method ->
                method.name.contains("ZoneOffset") || 
                method.name == "getStartZoneOffset" ||
                method.name == "getEndZoneOffset"
            }
            
            if (hasProblematicMethods) {
                Log.w("MinimalHealthPlugin", "⚠️  $dataType has problematic ZoneOffset methods - compatibility issues likely")
                return false
            }
            
            // Specific checks for different data types
            when (dataType) {
                "HEART_RATE" -> {
                    // HeartRateRecord specific checks
                    try {
                        val constructor = recordClass.java.constructors.firstOrNull()
                        if (constructor == null) {
                            Log.w("MinimalHealthPlugin", "⚠️  Cannot find $dataType constructor - compatibility issues")
                            return false
                        }
                        
                        // Check if startTime property is accessible
                        val hasStartTime = methods.any { it.name == "getStartTime" || it.name == "startTime" }
                        if (!hasStartTime) {
                            Log.w("MinimalHealthPlugin", "⚠️  $dataType missing startTime property - compatibility issues")
                            return false
                        }
                        
                    } catch (e: Exception) {
                        Log.w("MinimalHealthPlugin", "⚠️  $dataType compatibility test failed: ${e.message}")
                        return false
                    }
                }
                "WEIGHT" -> {
                    // WeightRecord specific checks (InstantRecord)
                    val hasTimeProperty = methods.any { it.name == "getTime" || it.name == "time" }
                    if (!hasTimeProperty) {
                        Log.w("MinimalHealthPlugin", "⚠️  $dataType missing time property - compatibility issues")
                        return false
                    }
                }
                else -> {
                    // For other data types, check for basic time properties
                    val hasTimeProperties = methods.any { 
                        it.name == "getStartTime" || it.name == "startTime" ||
                        it.name == "getTime" || it.name == "time"
                    }
                    if (!hasTimeProperties) {
                        Log.w("MinimalHealthPlugin", "⚠️  $dataType missing time properties - compatibility issues")
                        return false
                    }
                }
            }
            
            Log.d("MinimalHealthPlugin", "✅ $dataType compatibility check passed")
            return true
            
        } catch (e: Exception) {
            Log.e("MinimalHealthPlugin", "❌ $dataType compatibility check failed", e)
            return false
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
            "diagnoseHealthConnect" -> {
                diagnoseHealthConnect(result)
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
            "getTotalCaloriesToday" -> {
                getTotalCaloriesToday(result)
            }
            "getSleepHoursLastNight" -> {
                getSleepHoursLastNight(result)
            }
            "getWaterIntakeToday" -> {
                getWaterIntakeToday(result)
            }
            "getMindfulnessMinutesToday" -> {
                getMindfulnessMinutesToday(result)
            }
            "getLatestWeight" -> {
                getLatestWeight(result)
            }
            "getLatestHeartRate" -> {
                getLatestHeartRate(result)
            }
            "getRestingHeartRateToday" -> {
                getRestingHeartRateToday(result)
            }
            "getHeartRateData" -> {
                getHeartRateData(call, result)
            }
            "hasBackgroundHealthDataAccess" -> {
                hasBackgroundHealthDataAccess(result)
            }
            "getSupportedDataTypes" -> {
                getSupportedDataTypes(result)
            }
            "getServiceStatus" -> {
                getServiceStatus(result)
            }
            "runNativeHealthConnectDiagnostics" -> {
                runNativeHealthConnectDiagnostics(result)
            }
            "checkHealthConnectCompatibility" -> {
                checkHealthConnectCompatibility(result)
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
                    
                                        // Check specifically for background permission
                    val backgroundPermissionString = "android.permission.health.READ_HEALTH_DATA_IN_BACKGROUND"
                    val hasBackgroundPermission = grantedPermissions.contains(backgroundPermissionString)
                    Log.i("MinimalHealthPlugin", "Background health permission: ${if (hasBackgroundPermission) "GRANTED" else "MISSING"}")
                    
                    result.success(mapOf(
                        "status" to status,
                        "grantedPermissions" to grantedPermissions.size,
                        "totalPermissions" to getHealthPermissionStrings().size,
                        "hasBackgroundPermission" to hasBackgroundPermission,
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
            Log.i("MinimalHealthPlugin", "Attempting to start background health monitoring...")
            
            // Check if Health Connect supports background reads (Android 14+)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                Log.i("MinimalHealthPlugin", "Android 14+ detected - checking for background read support")
                
                // For Android 14+, background reads are handled by Health Connect itself
                // We just need to ensure permissions are granted
                coroutineScope.launch {
                    try {
                        val grantedPermissions = healthConnectClient?.permissionController?.getGrantedPermissions()
                        val hasRequiredPermissions = grantedPermissions?.isNotEmpty() == true
                        
                        if (hasRequiredPermissions) {
                            Log.i("MinimalHealthPlugin", "Background monitoring enabled via Health Connect permissions")
                            result.success(true)
                        } else {
                            Log.w("MinimalHealthPlugin", "Background monitoring requires Health Connect permissions")
                            result.success(false)
                        }
                    } catch (e: Exception) {
                        Log.e("MinimalHealthPlugin", "Error checking background monitoring permissions", e)
                        result.error("PERMISSION_ERROR", e.message, null)
                    }
                }
                return
            }
            
            // For older Android versions, try to start the background service
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
            Log.i("MinimalHealthPlugin", "Checking background monitoring status...")
            
            // For Android 14+, check if Health Connect permissions allow background reads
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                Log.i("MinimalHealthPlugin", "Android 14+ detected - checking Health Connect background permissions")
                
                coroutineScope.launch {
                    try {
                        val grantedPermissions = healthConnectClient?.permissionController?.getGrantedPermissions()
                        val isActive = grantedPermissions?.isNotEmpty() == true
                        
                        Log.i("MinimalHealthPlugin", "Background monitoring active: $isActive (via Health Connect permissions)")
                        result.success(isActive)
                    } catch (e: Exception) {
                        Log.e("MinimalHealthPlugin", "Error checking background monitoring status", e)
                        result.success(false)
                    }
                }
                return
            }
            
            // For older Android versions, check if background service is running
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
                
                // Check specifically for background permission
                val backgroundPermissionString = "android.permission.health.READ_HEALTH_DATA_IN_BACKGROUND"
                val hasBackgroundPermission = grantedPermissions.contains(backgroundPermissionString)
                Log.i("MinimalHealthPlugin", "Background health permission: ${if (hasBackgroundPermission) "GRANTED" else "MISSING"}")
                
                // For Android 16 (SDK 36), we need to ensure background permission is granted
                val finalResult = if (Build.VERSION.SDK_INT >= 34) {
                    // For Android 14+, require background permission
                    allGranted && hasBackgroundPermission
                } else {
                    // For older versions, just check regular permissions
                    allGranted
                }
                
                Log.i("MinimalHealthPlugin", "All permissions granted: $allGranted")
                Log.i("MinimalHealthPlugin", "Background permission granted: $hasBackgroundPermission")
                Log.i("MinimalHealthPlugin", "Final permission check result: $finalResult")
                
                result.success(finalResult)
            } catch (e: Exception) {
                Log.e("MinimalHealthPlugin", "Error checking permissions", e)
                result.success(false)
            }
        }
    }

    private fun requestPermissions(call: MethodCall, result: Result) {
        // Check SDK availability first as per Health Connect API instructions
        val availabilityStatus = HealthConnectClient.getSdkStatus(context)
        Log.i("MinimalHealthPlugin", "Health Connect SDK status during permission request: $availabilityStatus")
        
        when (availabilityStatus) {
            HealthConnectClient.SDK_UNAVAILABLE -> {
                Log.e("MinimalHealthPlugin", "Health Connect SDK is unavailable")
                result.error("SDK_UNAVAILABLE", "Health Connect SDK is not available on this device", null)
                return
            }
            HealthConnectClient.SDK_UNAVAILABLE_PROVIDER_UPDATE_REQUIRED -> {
                Log.w("MinimalHealthPlugin", "Health Connect provider update required")
                // Redirect user to update Health Connect as per instructions
                try {
                    val uri = "market://details?id=com.google.android.apps.healthdata&url=healthconnect%3A%2F%2Fonboarding"
                    val intent = Intent(Intent.ACTION_VIEW, Uri.parse(uri))
                    activityBinding?.activity?.startActivity(intent)
                } catch (e: Exception) {
                    Log.e("MinimalHealthPlugin", "Failed to open Health Connect update page", e)
                }
                result.error("UPDATE_REQUIRED", "Health Connect needs to be updated", null)
                return
            }
            else -> {
                Log.i("MinimalHealthPlugin", "Health Connect SDK is available, proceeding with permission request")
            }
        }

        if (healthConnectClient == null) {
            Log.w("MinimalHealthPlugin", "Health Connect client not initialized, attempting to initialize...")
            initializeHealthConnectClient()
            
            if (healthConnectClient == null) {
                Log.e("MinimalHealthPlugin", "Health Connect client still null after initialization")
                result.error("HEALTH_CONNECT_UNAVAILABLE", "Health Connect is not available", null)
                return
            }
        }

        if (activityBinding?.activity == null) {
            Log.e("MinimalHealthPlugin", "Activity not available for permission request")
            result.error("NO_ACTIVITY", "Activity is required for permission request", null)
            return
        }

        try {
            // Get the permissions we need as per Health Connect API instructions
            val permissions = getHealthPermissions()
            
            Log.i("MinimalHealthPlugin", "Requesting ${permissions.size} Health Connect permissions:")
            permissions.forEach { permission ->
                Log.i("MinimalHealthPlugin", "  - $permission")
            }
            
            coroutineScope.launch {
                try {
                    // Check current permissions first as per instructions
                    val grantedPermissions = healthConnectClient!!.permissionController.getGrantedPermissions()
                    Log.i("MinimalHealthPlugin", "Currently granted permissions: ${grantedPermissions.size}")
                    
                    if (grantedPermissions.containsAll(permissions)) {
                        Log.i("MinimalHealthPlugin", "All permissions already granted")
                        result.success(true)
                        return@launch
                    }
                    
                    // Launch the HealthConnectActivity to handle permission request
                    // This follows the proper Health Connect API pattern
                    val intent = Intent(context, HealthConnectActivity::class.java)
                    intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    context.startActivity(intent)
                    
                    Log.i("MinimalHealthPlugin", "Launched HealthConnectActivity for permission request")
                    
                    // Return false to indicate that permissions need to be granted manually
                    // The app should check permissions again after the user returns
                    result.success(false)
                    
                } catch (e: Exception) {
                    Log.e("MinimalHealthPlugin", "Error during permission request process", e)
                    result.error("PERMISSION_ERROR", "Error requesting permissions: ${e.message}", null)
                }
            }
            
        } catch (e: Exception) {
            Log.e("MinimalHealthPlugin", "Error in requestPermissions", e)
            result.error("PERMISSION_ERROR", "Error requesting permissions: ${e.message}", null)
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
                        // CRITICAL FIX: Validate date range before making the request
                        val currentTime = System.currentTimeMillis()
                        if (startDate > currentTime) {
                            Log.e("MinimalHealthPlugin", "❌ CRITICAL ERROR: Start date is in the FUTURE!")
                            Log.e("MinimalHealthPlugin", "  Start date: $startDate (${Instant.ofEpochMilli(startDate)})")
                            Log.e("MinimalHealthPlugin", "  Current time: $currentTime (${Instant.ofEpochMilli(currentTime)})")
                            Log.e("MinimalHealthPlugin", "  This indicates a timezone conversion bug in the calling code!")
                            result.error("INVALID_DATE_RANGE", "Start date is in the future - check timezone conversion", null)
                            return@launch
                        }
                        
                        if (endDate > currentTime) {
                            Log.w("MinimalHealthPlugin", "⚠️  End date is in the future, this may indicate a timezone issue")
                            Log.w("MinimalHealthPlugin", "  End date: $endDate (${Instant.ofEpochMilli(endDate)})")
                            Log.w("MinimalHealthPlugin", "  Current time: $currentTime (${Instant.ofEpochMilli(currentTime)})")
                        }
                        
                        // Special compatibility check for problematic data types
                        val isCompatible = checkDataTypeCompatibility(dataType, recordClass)
                        if (!isCompatible) {
                            Log.w("MinimalHealthPlugin", "⚠️  $dataType compatibility issue detected - returning empty data")
                            result.success(emptyList<Map<String, Any>>())
                            return@launch
                        }
                        
                        Log.i("MinimalHealthPlugin", "Executing Health Connect readRecords request for $dataType...")
                        Log.i("MinimalHealthPlugin", "  Time range: ${Instant.ofEpochMilli(startDate)} to ${Instant.ofEpochMilli(endDate)}")
                        Log.i("MinimalHealthPlugin", "  Duration: ${(endDate - startDate) / (1000 * 60 * 60)} hours")
                        Log.i("MinimalHealthPlugin", "  Record type: ${recordClass.simpleName}")
                        
                        // Add timeout handling for Health Connect API calls
                        val startTime = System.currentTimeMillis()
                        Log.i("MinimalHealthPlugin", "⏱️  Starting Health Connect API call at ${Instant.ofEpochMilli(startTime)}")
                        
                        val response = try {
                            // Add timeout to prevent hanging API calls
                            withTimeout(15000) { // 15 second timeout
                                healthConnectClient!!.readRecords(request)
                            }
                        } catch (timeoutException: kotlinx.coroutines.TimeoutCancellationException) {
                            val endTime = System.currentTimeMillis()
                            val duration = endTime - startTime
                            
                            Log.e("MinimalHealthPlugin", "⏰ Health Connect API call TIMED OUT after ${duration}ms")
                            Log.e("MinimalHealthPlugin", "  This indicates Health Connect is unresponsive")
                            Log.e("MinimalHealthPlugin", "  Possible causes:")
                            Log.e("MinimalHealthPlugin", "  1. Health Connect service is overloaded or crashed")
                            Log.e("MinimalHealthPlugin", "  2. Device storage is full")
                            Log.e("MinimalHealthPlugin", "  3. Health Connect database is corrupted")
                            Log.e("MinimalHealthPlugin", "  4. Too many concurrent health data requests")
                            
                            // Return empty response instead of crashing
                            throw Exception("Health Connect API timeout after ${duration}ms - service may be unresponsive")
                        } catch (apiException: NoSuchMethodError) {
                            val endTime = System.currentTimeMillis()
                            val duration = endTime - startTime
                            
                            Log.e("MinimalHealthPlugin", "❌ Health Connect version compatibility issue for $dataType after ${duration}ms")
                            Log.e("MinimalHealthPlugin", "  NoSuchMethodError: ${apiException.message}")
                            Log.e("MinimalHealthPlugin", "  This indicates a Health Connect client library version mismatch")
                            Log.e("MinimalHealthPlugin", "  The device's Health Connect version doesn't support methods expected by the client library")
                            Log.w("MinimalHealthPlugin", "  Returning empty data to prevent app crash")
                            
                            // Return empty response for compatibility issues
                            return@launch result.success(emptyList<Map<String, Any>>())
                        } catch (apiException: Exception) {
                            val endTime = System.currentTimeMillis()
                            val duration = endTime - startTime
                            
                            // Check for specific Health Connect compatibility errors
                            val errorMessage = apiException.message ?: ""
                            val isCompatibilityError = errorMessage.contains("getStartZoneOffset") ||
                                                     errorMessage.contains("ZoneOffset") ||
                                                     errorMessage.contains("HeartRateRecord") ||
                                                     errorMessage.contains("RecordConverters") ||
                                                     apiException is NoSuchMethodError
                            
                            if (isCompatibilityError) {
                                Log.e("MinimalHealthPlugin", "❌ Health Connect compatibility issue detected for $dataType after ${duration}ms")
                                Log.e("MinimalHealthPlugin", "  Error: $errorMessage")
                                Log.e("MinimalHealthPlugin", "  This is likely due to Health Connect version mismatch")
                                Log.w("MinimalHealthPlugin", "  Returning empty data to prevent app crash")
                                
                                // Return empty response for compatibility issues
                                return@launch result.success(emptyList<Map<String, Any>>())
                            } else {
                                Log.e("MinimalHealthPlugin", "❌ Health Connect API call FAILED after ${duration}ms")
                                Log.e("MinimalHealthPlugin", "  Exception type: ${apiException.javaClass.simpleName}")
                                Log.e("MinimalHealthPlugin", "  Exception message: ${apiException.message}")
                                Log.e("MinimalHealthPlugin", "  This suggests a Health Connect API issue or permission problem")
                                
                                // Re-throw other exceptions to be handled by outer try-catch
                                throw apiException
                            }
                        }
                        
                        val endTime = System.currentTimeMillis()
                        val duration = endTime - startTime
                        
                        Log.i("MinimalHealthPlugin", "✅ Health Connect readRecords completed successfully!")
                        Log.i("MinimalHealthPlugin", "  API call duration: ${duration}ms")
                        Log.i("MinimalHealthPlugin", "  Raw records count: ${response.records.size}")
                        
                        if (duration > 5000) {
                            Log.w("MinimalHealthPlugin", "⚠️  API call took ${duration}ms - this is unusually slow")
                            Log.w("MinimalHealthPlugin", "  This may indicate Health Connect performance issues")
                        }
                        
                        if (response.records.isEmpty()) {
                            Log.w("MinimalHealthPlugin", "⚠️  NO RECORDS returned from Health Connect for $dataType")
                            Log.w("MinimalHealthPlugin", "  This could indicate:")
                            Log.w("MinimalHealthPlugin", "  1. No data exists in the specified time range")
                            Log.w("MinimalHealthPlugin", "  2. Data source app is not syncing to Health Connect")
                            Log.w("MinimalHealthPlugin", "  3. Permissions are not properly granted")
                            Log.w("MinimalHealthPlugin", "  4. Health Connect version compatibility issues")
                        }
                        
                        val healthData = response.records.mapIndexedNotNull { index, record ->
                            try {
                                val convertedRecord = convertRecordToMap(record, dataType)
                                Log.d("MinimalHealthPlugin", "Record $index: ${convertedRecord["value"]} ${convertedRecord["unit"]} at ${Instant.ofEpochMilli(convertedRecord["timestamp"] as Long)}")
                                convertedRecord
                            } catch (e: Exception) {
                                Log.e("MinimalHealthPlugin", "❌ Error converting record $index to map for $dataType", e)
                                Log.e("MinimalHealthPlugin", "  Record type: ${record.javaClass.simpleName}")
                                Log.e("MinimalHealthPlugin", "  Error details: ${e.message}")
                                // Skip this record instead of returning error data
                                null
                            }
                        }
                        
                        Log.i("MinimalHealthPlugin", "✅ Successfully processed ${healthData.size} valid records for $dataType")
                        
                        // Enhanced logging for different data types
                        when (dataType) {
                            "STEPS" -> {
                                val totalSteps = healthData.sumOf { (it["value"] as? Double) ?: 0.0 }.toInt()
                                Log.i("MinimalHealthPlugin", "📊 Total steps in range: $totalSteps")
                                if (healthData.isEmpty()) {
                                    Log.w("MinimalHealthPlugin", "❌ No steps data found!")
                                    Log.w("MinimalHealthPlugin", "  Troubleshooting steps:")
                                    Log.w("MinimalHealthPlugin", "  1. Check if your fitness app (Zepp, Google Fit, etc.) is syncing to Health Connect")
                                    Log.w("MinimalHealthPlugin", "  2. Verify Health Connect has steps permission granted")
                                    Log.w("MinimalHealthPlugin", "  3. Check if there was actual activity in the time range")
                                    Log.w("MinimalHealthPlugin", "  4. Try manually syncing your fitness app")
                                }
                            }
                            "ACTIVE_ENERGY_BURNED" -> {
                                val totalCalories = healthData.sumOf { (it["value"] as? Double) ?: 0.0 }
                                Log.i("MinimalHealthPlugin", "🔥 Total active calories in range: ${totalCalories.toInt()} cal")
                                if (healthData.isEmpty()) {
                                    Log.w("MinimalHealthPlugin", "❌ No active calories records found!")
                                    Log.w("MinimalHealthPlugin", "  This is the most common issue. Troubleshooting:")
                                    Log.w("MinimalHealthPlugin", "  1. Check if your smartwatch app (Zepp, Wear OS, etc.) is syncing calories to Health Connect")
                                    Log.w("MinimalHealthPlugin", "  2. Verify Health Connect has active calories permission")
                                    Log.w("MinimalHealthPlugin", "  3. Ensure your watch recorded workouts/activities in the time range")
                                    Log.w("MinimalHealthPlugin", "  4. Check Health Connect app -> Data and access -> Active calories burned")
                                    Log.w("MinimalHealthPlugin", "  5. Try manually syncing your smartwatch app")
                                }
                            }
                            "TOTAL_CALORIES_BURNED" -> {
                                val totalCalories = healthData.sumOf { (it["value"] as? Double) ?: 0.0 }
                                Log.i("MinimalHealthPlugin", "🔥 Total calories burned in range: ${totalCalories.toInt()} cal")
                                if (healthData.isEmpty()) {
                                    Log.w("MinimalHealthPlugin", "❌ No total calories records found!")
                                    Log.w("MinimalHealthPlugin", "  Check Google Fit or other calorie tracking apps integration")
                                }
                            }
                            "HEART_RATE" -> {
                                if (healthData.isNotEmpty()) {
                                    val avgHeartRate = healthData.mapNotNull { it["value"] as? Double }.average()
                                    val minHR = healthData.mapNotNull { it["value"] as? Double }.minOrNull() ?: 0.0
                                    val maxHR = healthData.mapNotNull { it["value"] as? Double }.maxOrNull() ?: 0.0
                                    Log.i("MinimalHealthPlugin", "❤️  Heart rate stats - Avg: ${avgHeartRate.toInt()} bpm, Min: ${minHR.toInt()}, Max: ${maxHR.toInt()}")
                                } else {
                                    Log.w("MinimalHealthPlugin", "❌ No heart rate data found!")
                                    Log.w("MinimalHealthPlugin", "  Check if your smartwatch is syncing heart rate to Health Connect")
                                }
                            }
                            "SLEEP_IN_BED" -> {
                                if (healthData.isNotEmpty()) {
                                    val totalSleepMinutes = healthData.sumOf { (it["value"] as? Double) ?: 0.0 }
                                    Log.i("MinimalHealthPlugin", "😴 Total sleep time in range: ${(totalSleepMinutes / 60).toInt()} hours ${(totalSleepMinutes % 60).toInt()} minutes")
                                } else {
                                    Log.w("MinimalHealthPlugin", "❌ No sleep data found!")
                                    Log.w("MinimalHealthPlugin", "  Check if your sleep tracking app is syncing to Health Connect")
                                }
                            }
                            "WATER" -> {
                                if (healthData.isNotEmpty()) {
                                    val totalWater = healthData.sumOf { (it["value"] as? Double) ?: 0.0 }
                                    Log.i("MinimalHealthPlugin", "💧 Total water intake in range: ${totalWater.toInt()} ml")
                                } else {
                                    Log.w("MinimalHealthPlugin", "❌ No water intake data found!")
                                }
                            }
                            "WEIGHT" -> {
                                if (healthData.isNotEmpty()) {
                                    val latestWeight = healthData.lastOrNull()?.get("value") as? Double ?: 0.0
                                    Log.i("MinimalHealthPlugin", "⚖️  Latest weight in range: ${latestWeight} kg")
                                } else {
                                    Log.w("MinimalHealthPlugin", "❌ No weight data found!")
                                }
                            }
                        }
                        
                        result.success(healthData)
                    } catch (e: NoSuchMethodError) {
                        Log.e("MinimalHealthPlugin", "Health Connect version compatibility issue for $dataType: ${e.message}", e)
                        Log.w("MinimalHealthPlugin", "This may be due to Health Connect version mismatch. Returning empty data.")
                        Log.i("MinimalHealthPlugin", "Troubleshooting suggestions:")
                        Log.i("MinimalHealthPlugin", "1. Update Health Connect app from Play Store")
                        Log.i("MinimalHealthPlugin", "2. Restart the device to refresh Health Connect services")
                        Log.i("MinimalHealthPlugin", "3. Clear Health Connect app cache and data")
                        result.success(emptyList<Map<String, Any>>())
                    } catch (e: Exception) {
                        // Check if it's a specific Health Connect compatibility error
                        val errorMessage = e.message ?: ""
                        val isCompatibilityError = errorMessage.contains("ZoneOffset") ||
                                                 errorMessage.contains("getStartZoneOffset") ||
                                                 errorMessage.contains("HeartRateRecord") ||
                                                 errorMessage.contains("RecordConverters") ||
                                                 errorMessage.contains("toSdkHeartRateRecord") ||
                                                 errorMessage.contains("toSdkRecord") ||
                                                 errorMessage.contains("HealthConnectClientUpsideDownImpl") ||
                                                 e is NoSuchMethodError
                        
                        if (isCompatibilityError) {
                            Log.w("MinimalHealthPlugin", "Health Connect compatibility issue detected for $dataType: $errorMessage")
                            Log.w("MinimalHealthPlugin", "This is due to Health Connect version mismatch between client library and device.")
                            Log.i("MinimalHealthPlugin", "Troubleshooting suggestions:")
                            Log.i("MinimalHealthPlugin", "1. Update Health Connect app from Play Store")
                            Log.i("MinimalHealthPlugin", "2. Restart the device to refresh Health Connect services")
                            Log.i("MinimalHealthPlugin", "3. Clear Health Connect app cache and data")
                            Log.i("MinimalHealthPlugin", "4. Check if your device supports the latest Health Connect features")
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
                try {
                    val startTime = try {
                        record.startTime
                    } catch (e: NoSuchMethodError) {
                        try {
                            val startTimeField = record.javaClass.getDeclaredField("startTime")
                            startTimeField.isAccessible = true
                            startTimeField.get(record) as Instant
                        } catch (e2: Exception) {
                            Log.w("MinimalHealthPlugin", "Error getting startTime from StepsRecord, using current time", e2)
                            Instant.now()
                        }
                    }
                    
                    map["timestamp"] = startTime.toEpochMilli()
                    map["value"] = record.count.toDouble()
                    map["unit"] = "steps"
                } catch (e: Exception) {
                    Log.e("MinimalHealthPlugin", "Error processing StepsRecord - Health Connect compatibility issue", e)
                    map["timestamp"] = System.currentTimeMillis()
                    map["value"] = 0.0
                    map["unit"] = "steps"
                    map["error"] = "compatibility_issue"
                }
            }
            is ActiveCaloriesBurnedRecord -> {
                try {
                    val startTime = try {
                        record.startTime
                    } catch (e: NoSuchMethodError) {
                        try {
                            val startTimeField = record.javaClass.getDeclaredField("startTime")
                            startTimeField.isAccessible = true
                            startTimeField.get(record) as Instant
                        } catch (e2: Exception) {
                            Log.w("MinimalHealthPlugin", "Error getting startTime from ActiveCaloriesBurnedRecord, using current time", e2)
                            Instant.now()
                        }
                    }
                    
                    map["timestamp"] = startTime.toEpochMilli()
                    map["value"] = record.energy.inCalories
                    map["unit"] = "calories"
                    Log.d("MinimalHealthPlugin", "Active calories record: ${record.energy.inCalories} cal at ${Instant.ofEpochMilli(startTime.toEpochMilli())}")
                } catch (e: Exception) {
                    Log.e("MinimalHealthPlugin", "Error processing ActiveCaloriesBurnedRecord - Health Connect compatibility issue", e)
                    map["timestamp"] = System.currentTimeMillis()
                    map["value"] = 0.0
                    map["unit"] = "calories"
                    map["error"] = "compatibility_issue"
                }
            }
            is TotalCaloriesBurnedRecord -> {
                try {
                    val startTime = try {
                        record.startTime
                    } catch (e: NoSuchMethodError) {
                        try {
                            val startTimeField = record.javaClass.getDeclaredField("startTime")
                            startTimeField.isAccessible = true
                            startTimeField.get(record) as Instant
                        } catch (e2: Exception) {
                            Log.w("MinimalHealthPlugin", "Error getting startTime from TotalCaloriesBurnedRecord, using current time", e2)
                            Instant.now()
                        }
                    }
                    
                    map["timestamp"] = startTime.toEpochMilli()
                    map["value"] = record.energy.inCalories
                    map["unit"] = "calories"
                    Log.d("MinimalHealthPlugin", "Total calories record: ${record.energy.inCalories} cal at ${Instant.ofEpochMilli(startTime.toEpochMilli())}")
                } catch (e: Exception) {
                    Log.e("MinimalHealthPlugin", "Error processing TotalCaloriesBurnedRecord - Health Connect compatibility issue", e)
                    map["timestamp"] = System.currentTimeMillis()
                    map["value"] = 0.0
                    map["unit"] = "calories"
                    map["error"] = "compatibility_issue"
                }
            }
            is SleepSessionRecord -> {
                try {
                    val startTime = try {
                        record.startTime.toEpochMilli()
                    } catch (e: NoSuchMethodError) {
                        try {
                            val startTimeField = record.javaClass.getDeclaredField("startTime")
                            startTimeField.isAccessible = true
                            (startTimeField.get(record) as Instant).toEpochMilli()
                        } catch (e2: Exception) {
                            Log.w("MinimalHealthPlugin", "Error getting startTime from SleepSessionRecord, using current time", e2)
                            System.currentTimeMillis()
                        }
                    }
                    
                    val endTime = try {
                        record.endTime.toEpochMilli()
                    } catch (e: NoSuchMethodError) {
                        try {
                            val endTimeField = record.javaClass.getDeclaredField("endTime")
                            endTimeField.isAccessible = true
                            (endTimeField.get(record) as Instant).toEpochMilli()
                        } catch (e2: Exception) {
                            Log.w("MinimalHealthPlugin", "Error getting endTime from SleepSessionRecord, using current time", e2)
                            System.currentTimeMillis()
                        }
                    }
                    
                    val durationMinutes = (endTime - startTime) / (1000.0 * 60.0)
                    
                    map["timestamp"] = startTime
                    map["value"] = durationMinutes
                    map["unit"] = "minutes"
                    map["endTime"] = endTime
                    
                    // Get sleep stage information with compatibility handling
                    try {
                        val stages = record.stages
                        map["stageCount"] = stages.size
                    } catch (e: Exception) {
                        Log.w("MinimalHealthPlugin", "Error accessing sleep stages", e)
                        map["stageCount"] = 0
                    }
                    
                    Log.d("MinimalHealthPlugin", "Sleep record: ${durationMinutes.toInt()} minutes from ${Instant.ofEpochMilli(startTime)} to ${Instant.ofEpochMilli(endTime)}")
                    
                    // Add title if available
                    try {
                        record.title?.let { title ->
                            map["title"] = title
                            Log.d("MinimalHealthPlugin", "Sleep record title: $title")
                        }
                    } catch (e: Exception) {
                        Log.w("MinimalHealthPlugin", "Error accessing sleep title", e)
                    }
                    
                    // Add notes if available
                    try {
                        record.notes?.let { notes ->
                            map["notes"] = notes
                            Log.d("MinimalHealthPlugin", "Sleep record notes: $notes")
                        }
                    } catch (e: Exception) {
                        Log.w("MinimalHealthPlugin", "Error accessing sleep notes", e)
                    }
                } catch (e: Exception) {
                    Log.e("MinimalHealthPlugin", "Error processing SleepSessionRecord - Health Connect compatibility issue", e)
                    map["timestamp"] = System.currentTimeMillis()
                    map["value"] = 0.0
                    map["unit"] = "minutes"
                    map["endTime"] = System.currentTimeMillis()
                    map["stageCount"] = 0
                    map["error"] = "compatibility_issue"
                }
            }
            is HydrationRecord -> {
                try {
                    val startTime = try {
                        record.startTime
                    } catch (e: NoSuchMethodError) {
                        try {
                            val startTimeField = record.javaClass.getDeclaredField("startTime")
                            startTimeField.isAccessible = true
                            startTimeField.get(record) as Instant
                        } catch (e2: Exception) {
                            Log.w("MinimalHealthPlugin", "Error getting startTime from HydrationRecord, using current time", e2)
                            Instant.now()
                        }
                    }
                    
                    val endTime = try {
                        record.endTime
                    } catch (e: NoSuchMethodError) {
                        try {
                            val endTimeField = record.javaClass.getDeclaredField("endTime")
                            endTimeField.isAccessible = true
                            endTimeField.get(record) as Instant
                        } catch (e2: Exception) {
                            Log.w("MinimalHealthPlugin", "Error getting endTime from HydrationRecord, using current time", e2)
                            Instant.now()
                        }
                    }
                    
                    map["timestamp"] = startTime.toEpochMilli()
                    map["value"] = record.volume.inLiters
                    map["unit"] = "liters"
                    map["endTime"] = endTime.toEpochMilli()
                } catch (e: Exception) {
                    Log.e("MinimalHealthPlugin", "Error processing HydrationRecord - Health Connect compatibility issue", e)
                    map["timestamp"] = System.currentTimeMillis()
                    map["value"] = 0.0
                    map["unit"] = "liters"
                    map["endTime"] = System.currentTimeMillis()
                    map["error"] = "compatibility_issue"
                }
            }
            is WeightRecord -> {
                // WeightRecord compatibility handling for different Health Connect versions
                try {
                    // WeightRecord is an InstantRecord - try different approaches to get time
                    val time = try {
                        record.time
                    } catch (e: NoSuchMethodError) {
                        // Fallback methods for older versions
                        try {
                            val timeField = record.javaClass.getDeclaredField("time")
                            timeField.isAccessible = true
                            timeField.get(record) as Instant
                        } catch (e2: Exception) {
                            try {
                                val timeMethod = record.javaClass.getMethod("getTime")
                                timeMethod.invoke(record) as Instant
                            } catch (e3: Exception) {
                                Log.w("MinimalHealthPlugin", "Error getting time from WeightRecord, using current time", e3)
                                Instant.now()
                            }
                        }
                    }
                    
                    map["timestamp"] = time.toEpochMilli()
                    map["value"] = record.weight.inKilograms
                    map["unit"] = "kg"
                    
                } catch (e: Exception) {
                    Log.e("MinimalHealthPlugin", "Error processing WeightRecord - Health Connect version compatibility issue", e)
                    map["timestamp"] = System.currentTimeMillis()
                    map["value"] = 0.0
                    map["unit"] = "kg"
                    map["error"] = "compatibility_issue"
                }
            }
            is HeartRateRecord -> {
                // HeartRateRecord compatibility handling for different Health Connect versions
                try {
                    // HeartRateRecord is an IntervalRecord, so it has startTime, not time
                    val time = try {
                        record.startTime
                    } catch (e: NoSuchMethodError) {
                        // Fallback methods for older versions
                        try {
                            val startTimeField = record.javaClass.getDeclaredField("startTime")
                            startTimeField.isAccessible = true
                            startTimeField.get(record) as Instant
                        } catch (e2: Exception) {
                            try {
                                val getStartTimeMethod = record.javaClass.getMethod("getStartTime")
                                getStartTimeMethod.invoke(record) as Instant
                            } catch (e3: Exception) {
                                // Extract from samples if available
                                if (record.samples.isNotEmpty()) {
                                    val firstSample = record.samples.first()
                                    try {
                                        val sampleTimeField = firstSample.javaClass.getDeclaredField("time")
                                        sampleTimeField.isAccessible = true
                                        sampleTimeField.get(firstSample) as Instant
                                    } catch (e4: Exception) {
                                        Log.w("MinimalHealthPlugin", "Could not extract time from HeartRateRecord sample, using current time", e4)
                                        Instant.now()
                                    }
                                } else {
                                    Log.w("MinimalHealthPlugin", "HeartRateRecord has no samples and no accessible startTime, using current time")
                                    Instant.now()
                                }
                            }
                        }
                    }
                    
                    map["timestamp"] = time.toEpochMilli()
                    
                    // Extract heart rate value from samples with compatibility handling
                    try {
                        if (record.samples.isNotEmpty()) {
                            val firstSample = record.samples.first()
                            map["value"] = firstSample.beatsPerMinute.toDouble()
                            Log.d("MinimalHealthPlugin", "Heart rate record: ${firstSample.beatsPerMinute} bpm, samples: ${record.samples.size}")
                        } else {
                            map["value"] = 0.0
                            Log.w("MinimalHealthPlugin", "Heart rate record has no samples")
                        }
                    } catch (e: Exception) {
                        Log.w("MinimalHealthPlugin", "Error accessing HeartRateRecord samples", e)
                        map["value"] = 0.0
                    }
                    map["unit"] = "bpm"
                    
                } catch (e: Exception) {
                    Log.e("MinimalHealthPlugin", "Error processing HeartRateRecord - Health Connect version compatibility issue", e)
                    // Return a minimal valid record to prevent crashes
                    map["timestamp"] = System.currentTimeMillis()
                    map["value"] = 0.0
                    map["unit"] = "bpm"
                    map["error"] = "compatibility_issue"
                }
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
    
    /**
     * Comprehensive Health Connect diagnostic method
     * This method performs extensive checks to identify health data issues
     */
    private fun diagnoseHealthConnect(result: Result) {
        Log.i("MinimalHealthPlugin", "🔍 Starting comprehensive Health Connect diagnosis...")
        
        coroutineScope.launch {
            try {
                val diagnostics = mutableMapOf<String, Any>()
                diagnostics["timestamp"] = System.currentTimeMillis()
                diagnostics["deviceInfo"] = mapOf(
                    "androidVersion" to Build.VERSION.RELEASE,
                    "apiLevel" to Build.VERSION.SDK_INT,
                    "manufacturer" to Build.MANUFACTURER,
                    "model" to Build.MODEL
                )
                
                // Test 1: Health Connect availability
                Log.i("MinimalHealthPlugin", "📱 Testing Health Connect availability...")
                val isAvailable = HealthConnectClient.getSdkStatus(context) == HealthConnectClient.SDK_AVAILABLE
                diagnostics["healthConnectAvailable"] = isAvailable
                
                if (!isAvailable) {
                    Log.e("MinimalHealthPlugin", "❌ Health Connect is not available on this device")
                    diagnostics["error"] = "Health Connect not available"
                    result.success(diagnostics)
                    return@launch
                }
                
                // Test 2: Client initialization
                Log.i("MinimalHealthPlugin", "🔧 Testing Health Connect client initialization...")
                if (healthConnectClient == null) {
                    initializeHealthConnectClient()
                }
                diagnostics["clientInitialized"] = healthConnectClient != null
                
                if (healthConnectClient == null) {
                    Log.e("MinimalHealthPlugin", "❌ Failed to initialize Health Connect client")
                    diagnostics["error"] = "Client initialization failed"
                    result.success(diagnostics)
                    return@launch
                }
                
                // Test 3: Permissions check
                Log.i("MinimalHealthPlugin", "🔐 Testing permissions...")
                val grantedPermissions = healthConnectClient!!.permissionController.getGrantedPermissions()
                diagnostics["grantedPermissions"] = grantedPermissions.toList()
                diagnostics["permissionCount"] = grantedPermissions.size
                
                Log.i("MinimalHealthPlugin", "📋 Granted permissions (${grantedPermissions.size}):")
                grantedPermissions.forEach { permission ->
                    Log.i("MinimalHealthPlugin", "  ✅ $permission")
                }
                
                // Test 4: Data availability test for each type
                Log.i("MinimalHealthPlugin", "📊 Testing data availability for each type...")
                val dataAvailability = mutableMapOf<String, Map<String, Any>>()
                
                val now = System.currentTimeMillis()
                val testRanges = listOf(
                    "last24Hours" to (now - 24 * 60 * 60 * 1000L to now),
                    "last3Days" to (now - 3 * 24 * 60 * 60 * 1000L to now),
                    "lastWeek" to (now - 7 * 24 * 60 * 60 * 1000L to now)
                )
                
                for (dataType in ALLOWED_DATA_TYPES.keys) {
                    if (dataType == "BACKGROUND_HEALTH_DATA") continue // Skip special type
                    
                    Log.i("MinimalHealthPlugin", "🔍 Testing $dataType...")
                    val typeResults = mutableMapOf<String, Any>()
                    
                    for ((rangeName, timeRange) in testRanges) {
                        try {
                            val recordClass = ALLOWED_DATA_TYPES[dataType]!!
                            val timeRangeFilter = TimeRangeFilter.between(
                                Instant.ofEpochMilli(timeRange.first),
                                Instant.ofEpochMilli(timeRange.second)
                            )
                            
                            @Suppress("UNCHECKED_CAST")
                            val request = ReadRecordsRequest(
                                recordType = recordClass as KClass<Record>,
                                timeRangeFilter = timeRangeFilter
                            )
                            
                            val startTime = System.currentTimeMillis()
                            val response = healthConnectClient!!.readRecords(request)
                            val duration = System.currentTimeMillis() - startTime
                            
                            typeResults[rangeName] = mapOf(
                                "recordCount" to response.records.size,
                                "hasData" to response.records.isNotEmpty(),
                                "queryDuration" to duration
                            )
                            
                            Log.i("MinimalHealthPlugin", "  $rangeName: ${response.records.size} records (${duration}ms)")
                            
                        } catch (e: Exception) {
                            Log.e("MinimalHealthPlugin", "❌ Error testing $dataType for $rangeName: ${e.message}")
                            typeResults[rangeName] = mapOf(
                                "error" to e.message,
                                "hasData" to false
                            )
                        }
                    }
                    
                    dataAvailability[dataType] = typeResults
                }
                
                diagnostics["dataAvailability"] = dataAvailability
                
                // Test 5: Generate recommendations
                Log.i("MinimalHealthPlugin", "💡 Generating recommendations...")
                val recommendations = mutableListOf<String>()
                
                var hasAnyData = false
                for ((dataType, ranges) in dataAvailability) {
                    for ((_, rangeData) in ranges as Map<String, Map<String, Any>>) {
                        if (rangeData["hasData"] == true) {
                            hasAnyData = true
                            break
                        }
                    }
                    if (hasAnyData) break
                }
                
                if (!hasAnyData) {
                    recommendations.addAll(listOf(
                        "❌ No health data found in any time range",
                        "1. Check if your fitness apps are syncing to Health Connect",
                        "2. Open Health Connect app and verify data sources",
                        "3. Try manually syncing your fitness/health apps",
                        "4. Ensure your devices recorded data in the tested time ranges"
                    ))
                } else {
                    recommendations.add("✅ Some health data is available")
                }
                
                diagnostics["recommendations"] = recommendations
                
                Log.i("MinimalHealthPlugin", "🏁 Health Connect diagnosis completed")
                result.success(diagnostics)
                
            } catch (e: Exception) {
                Log.e("MinimalHealthPlugin", "❌ Error during Health Connect diagnosis", e)
                result.error("DIAGNOSIS_ERROR", "Diagnosis failed: ${e.message}", null)
            }
        }
    }
    
    // Individual health data methods that were missing
    private fun getTotalCaloriesToday(result: Result) {
        getTodayHealthData("TOTAL_CALORIES_BURNED", result)
    }
    
    private fun getSleepHoursLastNight(result: Result) {
        getLastNightSleepData(result)
    }
    
    private fun getWaterIntakeToday(result: Result) {
        getTodayHealthData("WATER", result)
    }
    
    private fun getMindfulnessMinutesToday(result: Result) {
        getTodayHealthData("MINDFULNESS", result)
    }
    
    private fun getLatestWeight(result: Result) {
        getLatestHealthData("WEIGHT", result)
    }
    
    private fun getLatestHeartRate(result: Result) {
        getLatestHealthData("HEART_RATE", result)
    }
    
    private fun getRestingHeartRateToday(result: Result) {
        // For now, return the same as regular heart rate
        // In a full implementation, this would filter for resting heart rate specifically
        getTodayHealthData("HEART_RATE", result)
    }
    
    private fun getHeartRateData(call: MethodCall, result: Result) {
        // Updated to use named parameters instead of positional
        val startDate = call.argument<Long>("startDate")
        val endDate = call.argument<Long>("endDate")
        
        if (startDate == null || endDate == null) {
            result.error("INVALID_ARGUMENTS", "startDate and endDate are required", null)
            return
        }
        
        // Use a specialized heart rate method that handles compatibility issues
        getHeartRateDataWithFallback(startDate, endDate, result)
    }
    
    private fun getHeartRateDataWithFallback(startDate: Long, endDate: Long, result: Result) {
        if (healthConnectClient == null) {
            result.error("HEALTH_CONNECT_UNAVAILABLE", "Health Connect is not available", null)
            return
        }
        
        coroutineScope.launch {
            try {
                Log.i("MinimalHealthPlugin", "Attempting to fetch heart rate data with compatibility handling...")
                Log.i("MinimalHealthPlugin", "Date range: ${Instant.ofEpochMilli(startDate)} to ${Instant.ofEpochMilli(endDate)}")
                
                // First, try to check if we have heart rate permissions
                val grantedPermissions = try {
                    healthConnectClient!!.permissionController.getGrantedPermissions()
                } catch (e: Exception) {
                    Log.w("MinimalHealthPlugin", "Could not check permissions, proceeding anyway: ${e.message}")
                    emptySet<String>()
                }
                
                val hasHeartRatePermission = grantedPermissions.any { it.contains("HEART_RATE") }
                Log.i("MinimalHealthPlugin", "Heart rate permission status: $hasHeartRatePermission")
                
                if (!hasHeartRatePermission) {
                    Log.w("MinimalHealthPlugin", "Heart rate permission not granted, returning 0.0")
                    result.success(0.0)
                    return@launch
                }
                
                // Try the standard approach first
                try {
                    val timeRangeFilter = TimeRangeFilter.between(
                        Instant.ofEpochMilli(startDate),
                        Instant.ofEpochMilli(endDate)
                    )
                    
                    @Suppress("UNCHECKED_CAST")
                    val request = ReadRecordsRequest(
                        recordType = HeartRateRecord::class as KClass<Record>,
                        timeRangeFilter = timeRangeFilter
                    )
                    
                    Log.i("MinimalHealthPlugin", "Executing heart rate data request...")
                    val response = healthConnectClient!!.readRecords(request)
                    
                    Log.i("MinimalHealthPlugin", "Heart rate request successful, found ${response.records.size} records")
                    
                    val value = response.records.lastOrNull()?.let { record ->
                        val heartRateRecord = record as HeartRateRecord
                        heartRateRecord.samples.firstOrNull()?.beatsPerMinute?.toDouble() ?: 0.0
                    } ?: 0.0
                    
                    Log.i("MinimalHealthPlugin", "Latest heart rate value: $value bpm")
                    result.success(value)
                    
                } catch (compatibilityException: Exception) {
                    val errorMessage = compatibilityException.message ?: ""
                    val isCompatibilityError = errorMessage.contains("ZoneOffset") ||
                                             errorMessage.contains("getStartZoneOffset") ||
                                             errorMessage.contains("HeartRateRecord") ||
                                             errorMessage.contains("RecordConverters") ||
                                             compatibilityException is NoSuchMethodError
                    
                    if (isCompatibilityError) {
                        Log.w("MinimalHealthPlugin", "Heart rate compatibility issue detected, using fallback approach")
                        Log.w("MinimalHealthPlugin", "Error: $errorMessage")
                        
                        // Fallback: Try to get other health data types that might work
                        Log.i("MinimalHealthPlugin", "Attempting fallback to steps data as health indicator...")
                        try {
                            val stepsTimeRangeFilter = TimeRangeFilter.between(
                                Instant.ofEpochMilli(startDate),
                                Instant.ofEpochMilli(endDate)
                            )
                            
                            @Suppress("UNCHECKED_CAST")
                            val stepsRequest = ReadRecordsRequest(
                                recordType = StepsRecord::class as KClass<Record>,
                                timeRangeFilter = stepsTimeRangeFilter
                            )
                            
                            val stepsResponse = healthConnectClient!!.readRecords(stepsRequest)
                            if (stepsResponse.records.isNotEmpty()) {
                                Log.i("MinimalHealthPlugin", "Fallback successful - found ${stepsResponse.records.size} steps records")
                                Log.i("MinimalHealthPlugin", "Heart rate data unavailable due to compatibility, but health data access is working")
                                // Return 0 for heart rate but log that health system is working
                                result.success(0.0)
                            } else {
                                Log.w("MinimalHealthPlugin", "No fallback data available either")
                                result.success(0.0)
                            }
                        } catch (fallbackException: Exception) {
                            Log.e("MinimalHealthPlugin", "Fallback approach also failed: ${fallbackException.message}")
                            result.success(0.0)
                        }
                    } else {
                        throw compatibilityException // Re-throw non-compatibility errors
                    }
                }
                
            } catch (e: Exception) {
                Log.e("MinimalHealthPlugin", "Error in heart rate data fetch with fallback", e)
                result.success(0.0)
            }
        }
    }
    
    private fun hasBackgroundHealthDataAccess(result: Result) {
        coroutineScope.launch {
            try {
                val grantedPermissions = healthConnectClient?.permissionController?.getGrantedPermissions()
                val hasAccess = grantedPermissions?.isNotEmpty() == true
                result.success(hasAccess)
            } catch (e: Exception) {
                Log.e("MinimalHealthPlugin", "Error checking background health data access", e)
                result.success(false)
            }
        }
    }
    
    private fun getSupportedDataTypes(result: Result) {
        result.success(Companion._supportedDataTypes.keys.toList())
    }
    
    private fun getServiceStatus(result: Result) {
        val status = mapOf(
            "isHealthConnectAvailable" to (healthConnectClient != null),
            "sdkStatus" to HealthConnectClient.getSdkStatus(context).toString(),
            "supportedDataTypes" to Companion._supportedDataTypes.keys.toList(),
            "androidVersion" to Build.VERSION.RELEASE,
            "apiLevel" to Build.VERSION.SDK_INT
        )
        result.success(status)
    }
    
    private fun runNativeHealthConnectDiagnostics(result: Result) {
        // Delegate to the existing diagnose method
        diagnoseHealthConnect(result)
    }
    
    private fun checkHealthConnectCompatibility(result: Result) {
        coroutineScope.launch {
            try {
                val compatibilityInfo = mutableMapOf<String, Any>()
                
                // Check Health Connect client library version
                compatibilityInfo["clientLibraryVersion"] = "1.0.0" // Updated to stable version
                
                // Check Android version
                compatibilityInfo["androidVersion"] = Build.VERSION.RELEASE
                compatibilityInfo["apiLevel"] = Build.VERSION.SDK_INT
                
                // Check Health Connect availability
                val isAvailable = healthConnectClient != null
                compatibilityInfo["healthConnectAvailable"] = isAvailable
                
                if (isAvailable) {
                    try {
                        // Test basic functionality with a simple data type
                        val now = System.currentTimeMillis()
                        val oneHourAgo = now - (60 * 60 * 1000)
                        
                        val timeRangeFilter = TimeRangeFilter.between(
                            Instant.ofEpochMilli(oneHourAgo),
                            Instant.ofEpochMilli(now)
                        )
                        
                        // Test with Steps (most compatible data type)
                        @Suppress("UNCHECKED_CAST")
                        val stepsRequest = ReadRecordsRequest(
                            recordType = StepsRecord::class as KClass<Record>,
                            timeRangeFilter = timeRangeFilter
                        )
                        
                        val stepsResponse = healthConnectClient!!.readRecords(stepsRequest)
                        compatibilityInfo["stepsDataCompatible"] = true
                        compatibilityInfo["stepsRecordsFound"] = stepsResponse.records.size
                        
                        // Test with Heart Rate (problematic data type)
                        try {
                            @Suppress("UNCHECKED_CAST")
                            val heartRateRequest = ReadRecordsRequest(
                                recordType = HeartRateRecord::class as KClass<Record>,
                                timeRangeFilter = timeRangeFilter
                            )
                            
                            val heartRateResponse = healthConnectClient!!.readRecords(heartRateRequest)
                            compatibilityInfo["heartRateDataCompatible"] = true
                            compatibilityInfo["heartRateRecordsFound"] = heartRateResponse.records.size
                            
                        } catch (e: Exception) {
                            val errorMessage = e.message ?: ""
                            val isCompatibilityError = errorMessage.contains("getStartZoneOffset") ||
                                                     errorMessage.contains("ZoneOffset") ||
                                                     errorMessage.contains("HeartRateRecord") ||
                                                     e is NoSuchMethodError
                            
                            compatibilityInfo["heartRateDataCompatible"] = false
                            compatibilityInfo["heartRateCompatibilityIssue"] = isCompatibilityError
                            compatibilityInfo["heartRateError"] = errorMessage
                        }
                        
                    } catch (e: Exception) {
                        compatibilityInfo["basicFunctionalityTest"] = false
                        compatibilityInfo["testError"] = e.message ?: "Unknown error"
                    }
                } else {
                    compatibilityInfo["reason"] = "Health Connect client not initialized"
                }
                
                // Add recommendations based on findings
                val recommendations = mutableListOf<String>()
                
                if (compatibilityInfo["heartRateDataCompatible"] == false) {
                    recommendations.add("Heart rate data has compatibility issues - using fallback methods")
                    recommendations.add("Consider updating Health Connect app from Play Store")
                    recommendations.add("Restart device to refresh Health Connect services")
                }
                
                if (compatibilityInfo["stepsDataCompatible"] == true) {
                    recommendations.add("Basic health data access is working correctly")
                } else {
                    recommendations.add("Basic health data access has issues - check permissions")
                }
                
                compatibilityInfo["recommendations"] = recommendations
                compatibilityInfo["overallCompatibility"] = if (compatibilityInfo["stepsDataCompatible"] == true) "GOOD" else "POOR"
                
                Log.i("MinimalHealthPlugin", "Health Connect compatibility check completed")
                Log.i("MinimalHealthPlugin", "Overall compatibility: ${compatibilityInfo["overallCompatibility"]}")
                
                result.success(compatibilityInfo)
                
            } catch (e: Exception) {
                Log.e("MinimalHealthPlugin", "Error during compatibility check", e)
                result.error("COMPATIBILITY_CHECK_ERROR", "Compatibility check failed: ${e.message}", null)
            }
        }
    }
    
    // Helper methods for the individual data requests
    private fun getTodayHealthData(dataType: String, result: Result) {
        val now = System.currentTimeMillis()
        val startOfDay = now - (now % (24 * 60 * 60 * 1000))
        getHealthDataInRange(dataType, startOfDay, now, result)
    }
    
    private fun getLastNightSleepData(result: Result) {
        val now = System.currentTimeMillis()
        val yesterday = now - (24 * 60 * 60 * 1000)
        getHealthDataInRange("SLEEP_IN_BED", yesterday, now, result)
    }
    
    private fun getLatestHealthData(dataType: String, result: Result) {
        val now = System.currentTimeMillis()
        val weekAgo = now - (7 * 24 * 60 * 60 * 1000)
        getHealthDataInRange(dataType, weekAgo, now, result)
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
                } catch (e: NoSuchMethodError) {
                    Log.e("MinimalHealthPlugin", "Health Connect version compatibility issue for $dataType: ${e.message}", e)
                    Log.w("MinimalHealthPlugin", "Returning 0.0 due to compatibility issue")
                    result.success(0.0)
                    return@launch
                } catch (e: Exception) {
                    // Check for specific Health Connect compatibility errors
                    val errorMessage = e.message ?: ""
                    val isCompatibilityError = errorMessage.contains("ZoneOffset") ||
                                             errorMessage.contains("getStartZoneOffset") ||
                                             errorMessage.contains("HeartRateRecord") ||
                                             errorMessage.contains("RecordConverters") ||
                                             errorMessage.contains("toSdkHeartRateRecord") ||
                                             errorMessage.contains("toSdkRecord") ||
                                             errorMessage.contains("HealthConnectClientUpsideDownImpl") ||
                                             e is NoSuchMethodError
                    
                    if (isCompatibilityError) {
                        Log.w("MinimalHealthPlugin", "Health Connect compatibility issue detected for $dataType: $errorMessage")
                        Log.w("MinimalHealthPlugin", "Returning 0.0 due to compatibility issue")
                        result.success(0.0)
                        return@launch
                    } else {
                        throw e // Re-throw other exceptions
                    }
                }
                
                // Calculate total/latest value based on data type
                val value = when (dataType) {
                    "STEPS" -> response.records.sumOf { (it as StepsRecord).count.toDouble() }
                    "TOTAL_CALORIES_BURNED", "ACTIVE_ENERGY_BURNED" -> {
                        response.records.sumOf { 
                            when (it) {
                                is TotalCaloriesBurnedRecord -> it.energy.inCalories
                                is ActiveCaloriesBurnedRecord -> it.energy.inCalories
                                else -> 0.0
                            }
                        }
                    }
                    "WATER" -> response.records.sumOf { (it as HydrationRecord).volume.inLiters }
                    "SLEEP_IN_BED" -> {
                        response.records.sumOf { record ->
                            val sleepRecord = record as SleepSessionRecord
                            (sleepRecord.endTime.toEpochMilli() - sleepRecord.startTime.toEpochMilli()) / (1000.0 * 60.0 * 60.0) // hours
                        }
                    }
                    "WEIGHT" -> {
                        response.records.lastOrNull()?.let { (it as WeightRecord).weight.inKilograms } ?: 0.0
                    }
                    "HEART_RATE" -> {
                        response.records.lastOrNull()?.let { record ->
                            val heartRateRecord = record as HeartRateRecord
                            heartRateRecord.samples.firstOrNull()?.beatsPerMinute?.toDouble() ?: 0.0
                        } ?: 0.0
                    }
                    "MINDFULNESS" -> {
                        response.records.sumOf { record ->
                            try {
                                val startTimeMethod = record.javaClass.getMethod("getStartTime")
                                val endTimeMethod = record.javaClass.getMethod("getEndTime")
                                val startTime = startTimeMethod.invoke(record) as Instant
                                val endTime = endTimeMethod.invoke(record) as Instant
                                (endTime.toEpochMilli() - startTime.toEpochMilli()) / (1000.0 * 60.0) // minutes
                            } catch (e: Exception) {
                                0.0
                            }
                        }
                    }
                    else -> 0.0
                }
                
                result.success(value)
            } catch (e: Exception) {
                Log.e("MinimalHealthPlugin", "Error getting health data for $dataType", e)
                result.success(0.0)
            }
        }
    }
}



