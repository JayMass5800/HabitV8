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
    }

    companion object {
        private const val HEALTH_CONNECT_REQUEST_CODE = 1001
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "minimal_health_service")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        
        // Initialize Health Connect client if available
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            try {
                healthConnectClient = HealthConnectClient.getOrCreate(context)
                Log.i("MinimalHealthPlugin", "Health Connect client initialized")
            } catch (e: Exception) {
                Log.w("MinimalHealthPlugin", "Health Connect not available", e)
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
                result.success(healthConnectClient != null)
            }
            else -> {
                result.notImplemented()
            }
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
                val allGranted = HEALTH_PERMISSIONS.all { it in grantedPermissions }
                
                Log.i("MinimalHealthPlugin", "Permissions check result: $allGranted (${grantedPermissions.size}/${HEALTH_PERMISSIONS.size})")
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
            pendingResult = result
            val permissionContract = PermissionController.createRequestPermissionResultContract()
            val intent = permissionContract.createIntent(context, HEALTH_PERMISSIONS)
            
            activityBinding?.activity?.startActivityForResult(intent, HEALTH_CONNECT_REQUEST_CODE)
            Log.i("MinimalHealthPlugin", "Permission request started for ${HEALTH_PERMISSIONS.size} permissions")
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
                map["timestamp"] = record.startTime.toEpochMilli()
                map["value"] = (record.endTime.toEpochMilli() - record.startTime.toEpochMilli()) / (1000.0 * 60.0) // minutes
                map["unit"] = "minutes"
                map["endTime"] = record.endTime.toEpochMilli()
            }
            is HydrationRecord -> {
                // HydrationRecord is an InstantRecord, so it should have a 'time' property
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
                // WeightRecord is an InstantRecord, so it should have a 'time' property
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
                // HeartRateRecord is an InstantRecord, so it should have a 'time' property
                try {
                    val timeMethod = record.javaClass.getMethod("getTime")
                    val time = timeMethod.invoke(record) as Instant
                    map["timestamp"] = time.toEpochMilli()
                } catch (e: Exception) {
                    Log.w("MinimalHealthPlugin", "Error getting time from HeartRateRecord", e)
                    map["timestamp"] = System.currentTimeMillis()
                }
                // HeartRateRecord has samples, we'll take the first one or average
                try {
                    val samplesMethod = record.javaClass.getMethod("getSamples")
                    val samples = samplesMethod.invoke(record) as List<*>
                    if (samples.isNotEmpty()) {
                        val firstSample = samples.first()
                        val beatsPerMinuteMethod = firstSample!!.javaClass.getMethod("getBeatsPerMinute")
                        val bpm = beatsPerMinuteMethod.invoke(firstSample) as Long
                        map["value"] = bpm.toDouble()
                    } else {
                        map["value"] = 0.0
                    }
                } catch (e: Exception) {
                    Log.w("MinimalHealthPlugin", "Error getting heart rate samples", e)
                    map["value"] = 0.0
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
            val result = pendingResult
            pendingResult = null
            
            if (result != null) {
                // Check permissions after the request
                coroutineScope.launch {
                    try {
                        val grantedPermissions = healthConnectClient?.permissionController?.getGrantedPermissions() ?: emptySet()
                        val allGranted = HEALTH_PERMISSIONS.all { it in grantedPermissions }
                        
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