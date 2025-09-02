package com.habittracker.habitv8

import android.content.Context
import android.util.Log
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.permission.HealthPermission
import androidx.health.connect.client.records.*
import androidx.health.connect.client.request.AggregateRequest
import androidx.health.connect.client.request.ReadRecordsRequest
import androidx.health.connect.client.time.TimeRangeFilter
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.time.Instant
import java.time.temporal.ChronoUnit
import kotlin.reflect.KClass

/**
 * Simple Health Connect Plugin based on latest official Android documentation
 * https://developer.android.com/health-and-fitness/guides/health-connect/develop/read-data
 */
class SimpleHealthPlugin : FlutterPlugin, MethodCallHandler {
    companion object {
        private const val TAG = "SimpleHealthPlugin"
        private const val CHANNEL = "simple_health_plugin"
    }

    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var healthConnectClient: HealthConnectClient? = null
    private val coroutineScope = CoroutineScope(Dispatchers.IO)

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        
        initializeHealthConnect()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun initializeHealthConnect() {
        try {
            val sdkStatus = HealthConnectClient.getSdkStatus(context)
            Log.i(TAG, "Health Connect SDK status: $sdkStatus")
            
            when (sdkStatus) {
                HealthConnectClient.SDK_AVAILABLE -> {
                    healthConnectClient = HealthConnectClient.getOrCreate(context)
                    Log.i(TAG, "Health Connect client initialized successfully")
                }
                HealthConnectClient.SDK_UNAVAILABLE -> {
                    Log.e(TAG, "Health Connect SDK is unavailable")
                    return
                }
                HealthConnectClient.SDK_UNAVAILABLE_PROVIDER_UPDATE_REQUIRED -> {
                    Log.w(TAG, "Health Connect provider update required")
                    return
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to initialize Health Connect", e)
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getHealthPermissions" -> {
                result.success(getHealthPermissions().toList())
            }
            "checkPermissions" -> {
                checkPermissions(result)
            }
            "getStepsData" -> {
                val startTime = call.argument<Long>("startTime") ?: return result.error("INVALID_ARGUMENT", "startTime is required", null)
                val endTime = call.argument<Long>("endTime") ?: return result.error("INVALID_ARGUMENT", "endTime is required", null)
                getStepsData(startTime, endTime, result)
            }
            "getHeartRateData" -> {
                val startTime = call.argument<Long>("startTime") ?: return result.error("INVALID_ARGUMENT", "startTime is required", null)
                val endTime = call.argument<Long>("endTime") ?: return result.error("INVALID_ARGUMENT", "endTime is required", null)
                getHeartRateData(startTime, endTime, result)
            }
            "getSleepData" -> {
                val startTime = call.argument<Long>("startTime") ?: return result.error("INVALID_ARGUMENT", "startTime is required", null)
                val endTime = call.argument<Long>("endTime") ?: return result.error("INVALID_ARGUMENT", "endTime is required", null)
                getSleepData(startTime, endTime, result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun getHealthPermissions(): Set<String> {
        val permissions = mutableSetOf<String>()
        
        try {
            // Core permissions
            permissions.add(HealthPermission.getReadPermission(StepsRecord::class))
            permissions.add(HealthPermission.getReadPermission(HeartRateRecord::class))
            permissions.add(HealthPermission.getReadPermission(SleepSessionRecord::class))
            permissions.add(HealthPermission.getReadPermission(ActiveCaloriesBurnedRecord::class))
            permissions.add(HealthPermission.getReadPermission(TotalCaloriesBurnedRecord::class))
            permissions.add(HealthPermission.getReadPermission(HydrationRecord::class))
            permissions.add(HealthPermission.getReadPermission(WeightRecord::class))
            
            // Background permission
            permissions.add("android.permission.health.READ_HEALTH_DATA_IN_BACKGROUND")
            
            // Mindfulness permission
            permissions.add("android.permission.health.READ_MINDFULNESS")
            
            Log.i(TAG, "Configured ${permissions.size} health permissions")
        } catch (e: Exception) {
            Log.e(TAG, "Error creating health permissions", e)
        }
        
        return permissions
    }

    private fun checkPermissions(result: Result) {
        if (healthConnectClient == null) {
            result.error("HEALTH_CONNECT_UNAVAILABLE", "Health Connect is not available", null)
            return
        }

        coroutineScope.launch {
            try {
                val grantedPermissions = healthConnectClient!!.permissionController.getGrantedPermissions()
                val requiredPermissions = getHealthPermissions()
                
                Log.i(TAG, "Granted permissions: ${grantedPermissions.size}")
                Log.i(TAG, "Required permissions: ${requiredPermissions.size}")
                
                val hasAllPermissions = grantedPermissions.containsAll(requiredPermissions)
                
                val permissionStatus = mapOf(
                    "hasAllPermissions" to hasAllPermissions,
                    "grantedCount" to grantedPermissions.size,
                    "requiredCount" to requiredPermissions.size,
                    "grantedPermissions" to grantedPermissions.toList(),
                    "requiredPermissions" to requiredPermissions.toList()
                )
                
                result.success(permissionStatus)
            } catch (e: Exception) {
                Log.e(TAG, "Error checking permissions", e)
                result.error("PERMISSION_CHECK_FAILED", e.message, null)
            }
        }
    }

    private fun getStepsData(startTimeMs: Long, endTimeMs: Long, result: Result) {
        if (healthConnectClient == null) {
            result.error("HEALTH_CONNECT_UNAVAILABLE", "Health Connect is not available", null)
            return
        }

        coroutineScope.launch {
            try {
                val startTime = Instant.ofEpochMilli(startTimeMs)
                val endTime = Instant.ofEpochMilli(endTimeMs)
                
                Log.i(TAG, "Reading steps data from $startTime to $endTime")
                
                // Use aggregate for cumulative data like steps (recommended by documentation)
                val response = healthConnectClient!!.aggregate(
                    AggregateRequest(
                        metrics = setOf(StepsRecord.COUNT_TOTAL),
                        timeRangeFilter = TimeRangeFilter.between(startTime, endTime)
                    )
                )
                
                val stepCount = response[StepsRecord.COUNT_TOTAL] ?: 0L
                Log.i(TAG, "Retrieved steps: $stepCount")
                
                val stepsData = mapOf(
                    "value" to stepCount,
                    "unit" to "steps",
                    "startTime" to startTimeMs,
                    "endTime" to endTimeMs
                )
                
                result.success(listOf(stepsData))
            } catch (e: Exception) {
                Log.e(TAG, "Error reading steps data", e)
                result.error("STEPS_READ_FAILED", e.message, null)
            }
        }
    }

    private fun getHeartRateData(startTimeMs: Long, endTimeMs: Long, result: Result) {
        if (healthConnectClient == null) {
            result.error("HEALTH_CONNECT_UNAVAILABLE", "Health Connect is not available", null)
            return
        }

        coroutineScope.launch {
            try {
                val startTime = Instant.ofEpochMilli(startTimeMs)
                val endTime = Instant.ofEpochMilli(endTimeMs)
                
                Log.i(TAG, "Reading heart rate data from $startTime to $endTime")
                
                // Use readRecords for individual measurements like heart rate
                val response = healthConnectClient!!.readRecords(
                    ReadRecordsRequest(
                        recordType = HeartRateRecord::class,
                        timeRangeFilter = TimeRangeFilter.between(startTime, endTime)
                    )
                )
                
                Log.i(TAG, "Retrieved ${response.records.size} heart rate records")
                
                val heartRateData = response.records.flatMap { record ->
                    record.samples.map { sample ->
                        mapOf(
                            "value" to sample.beatsPerMinute,
                            "unit" to "bpm",
                            "timestamp" to sample.time.toEpochMilli()
                        )
                    }
                }
                
                result.success(heartRateData)
            } catch (e: Exception) {
                Log.e(TAG, "Error reading heart rate data", e)
                result.error("HEART_RATE_READ_FAILED", e.message, null)
            }
        }
    }

    private fun getSleepData(startTimeMs: Long, endTimeMs: Long, result: Result) {
        if (healthConnectClient == null) {
            result.error("HEALTH_CONNECT_UNAVAILABLE", "Health Connect is not available", null)
            return
        }

        coroutineScope.launch {
            try {
                val startTime = Instant.ofEpochMilli(startTimeMs)
                val endTime = Instant.ofEpochMilli(endTimeMs)
                
                Log.i(TAG, "Reading sleep data from $startTime to $endTime")
                
                val response = healthConnectClient!!.readRecords(
                    ReadRecordsRequest(
                        recordType = SleepSessionRecord::class,
                        timeRangeFilter = TimeRangeFilter.between(startTime, endTime)
                    )
                )
                
                Log.i(TAG, "Retrieved ${response.records.size} sleep records")
                
                val sleepData = response.records.map { record ->
                    val durationMinutes = ChronoUnit.MINUTES.between(record.startTime, record.endTime)
                    mapOf(
                        "value" to durationMinutes,
                        "unit" to "minutes",
                        "startTime" to record.startTime.toEpochMilli(),
                        "endTime" to record.endTime.toEpochMilli()
                    )
                }
                
                result.success(sleepData)
            } catch (e: Exception) {
                Log.e(TAG, "Error reading sleep data", e)
                result.error("SLEEP_READ_FAILED", e.message, null)
            }
        }
    }
}