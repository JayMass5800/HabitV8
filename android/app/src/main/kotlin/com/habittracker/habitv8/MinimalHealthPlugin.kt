package com.habittracker.habitv8

import android.content.Context
import android.content.pm.PackageManager
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.util.Log

/**
 * Minimal Health Plugin
 * 
 * This plugin ONLY handles the 6 essential health permissions needed by the app.
 * It does NOT reference any other health permissions, preventing Google Play Console
 * static analysis from detecting unwanted permissions.
 * 
 * CRITICAL: This plugin MUST NOT reference any health permissions other than the 6 allowed ones.
 */
class MinimalHealthPlugin: FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    // ONLY these 6 health permissions are supported
    // Adding any more will cause Google Play Console rejection
    private val ALLOWED_PERMISSIONS = mapOf(
        "STEPS" to "android.permission.health.READ_STEPS",
        "ACTIVE_ENERGY_BURNED" to "android.permission.health.READ_ACTIVE_CALORIES_BURNED",
        "SLEEP_IN_BED" to "android.permission.health.READ_SLEEP",
        "WATER" to "android.permission.health.READ_HYDRATION",
        "MINDFULNESS" to "android.permission.health.READ_MINDFULNESS",
        "WEIGHT" to "android.permission.health.READ_WEIGHT"
    )

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "minimal_health_service")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
        
        Log.i("MinimalHealthPlugin", "Plugin attached - supporting ${ALLOWED_PERMISSIONS.size} health data types")
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
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun initialize(call: MethodCall, result: Result) {
        try {
            val supportedTypes = call.argument<List<String>>("supportedTypes") ?: emptyList()
            val permissions = call.argument<List<String>>("permissions") ?: emptyList()
            
            // Validate that only allowed permissions are being requested
            for (permission in permissions) {
                if (!ALLOWED_PERMISSIONS.values.contains(permission)) {
                    Log.e("MinimalHealthPlugin", "FORBIDDEN PERMISSION DETECTED: $permission")
                    result.error("FORBIDDEN_PERMISSION", "Permission $permission is not allowed", null)
                    return
                }
            }
            
            Log.i("MinimalHealthPlugin", "Initialized with ${supportedTypes.size} data types")
            result.success(true)
        } catch (e: Exception) {
            Log.e("MinimalHealthPlugin", "Error during initialization", e)
            result.error("INIT_ERROR", e.message, null)
        }
    }

    private fun checkPermissions(result: Result) {
        try {
            // Check if all required permissions are granted
            var allGranted = true
            for (permission in ALLOWED_PERMISSIONS.values) {
                if (ContextCompat.checkSelfPermission(context, permission) != PackageManager.PERMISSION_GRANTED) {
                    allGranted = false
                    break
                }
            }
            
            Log.i("MinimalHealthPlugin", "Permissions check result: $allGranted")
            result.success(allGranted)
        } catch (e: Exception) {
            Log.e("MinimalHealthPlugin", "Error checking permissions", e)
            result.success(false)
        }
    }

    private fun requestPermissions(call: MethodCall, result: Result) {
        try {
            val permissions = call.argument<List<String>>("permissions") ?: emptyList()
            
            // Validate permissions
            for (permission in permissions) {
                if (!ALLOWED_PERMISSIONS.values.contains(permission)) {
                    Log.e("MinimalHealthPlugin", "FORBIDDEN PERMISSION REQUEST: $permission")
                    result.error("FORBIDDEN_PERMISSION", "Permission $permission is not allowed", null)
                    return
                }
            }
            
            // For now, just return true - actual permission request would need activity context
            // In a real implementation, you'd use Health Connect APIs here
            Log.i("MinimalHealthPlugin", "Permission request for ${permissions.size} permissions")
            result.success(true)
        } catch (e: Exception) {
            Log.e("MinimalHealthPlugin", "Error requesting permissions", e)
            result.error("PERMISSION_ERROR", e.message, null)
        }
    }

    private fun getHealthData(call: MethodCall, result: Result) {
        try {
            val dataType = call.argument<String>("dataType") ?: ""
            val startDate = call.argument<Long>("startDate") ?: 0L
            val endDate = call.argument<Long>("endDate") ?: 0L
            
            // Validate data type
            if (!ALLOWED_PERMISSIONS.containsKey(dataType)) {
                Log.e("MinimalHealthPlugin", "FORBIDDEN DATA TYPE: $dataType")
                result.error("FORBIDDEN_DATA_TYPE", "Data type $dataType is not allowed", null)
                return
            }
            
            // For now, return empty data - actual implementation would query Health Connect
            // In a real implementation, you'd use Health Connect APIs to fetch data
            Log.i("MinimalHealthPlugin", "Health data request for $dataType from $startDate to $endDate")
            result.success(emptyList<Map<String, Any>>())
        } catch (e: Exception) {
            Log.e("MinimalHealthPlugin", "Error getting health data", e)
            result.error("DATA_ERROR", e.message, null)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        Log.i("MinimalHealthPlugin", "Plugin detached")
    }
}