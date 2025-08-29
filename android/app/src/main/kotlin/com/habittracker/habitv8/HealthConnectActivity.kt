package com.habittracker.habitv8

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.result.contract.ActivityResultContracts
import androidx.lifecycle.lifecycleScope
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.permission.HealthPermission
import androidx.health.connect.client.records.*
import kotlinx.coroutines.launch
import kotlin.reflect.KClass

/**
 * Health Connect Activity for handling permission rationale and requests
 * 
 * This activity is launched when the system needs to show permission rationale
 * or when the app needs to request Health Connect permissions.
 */
class HealthConnectActivity : ComponentActivity() {
    
    companion object {
        private const val TAG = "HealthConnectActivity"
        const val EXTRA_PERMISSIONS_REQUESTED = "permissions_requested"
        const val EXTRA_RESULT_CODE = "result_code"
    }
    
    // Health Connect client
    private lateinit var healthConnectClient: HealthConnectClient
    
    // Permissions we need
    private val PERMISSIONS = setOf(
        HealthPermission.getReadPermission(StepsRecord::class),
        HealthPermission.getReadPermission(ActiveCaloriesBurnedRecord::class),
        HealthPermission.getReadPermission(TotalCaloriesBurnedRecord::class),
        HealthPermission.getReadPermission(SleepSessionRecord::class),
        HealthPermission.getReadPermission(HydrationRecord::class),
        HealthPermission.getReadPermission(WeightRecord::class),
        HealthPermission.getReadPermission(HeartRateRecord::class)
    ).apply {
        // Try to add MindfulnessSessionRecord permission if available
        try {
            val mindfulnessClass = Class.forName("androidx.health.connect.client.records.MindfulnessSessionRecord").kotlin as KClass<out Record>
            this.plus(HealthPermission.getReadPermission(mindfulnessClass))
            Log.i(TAG, "Added MindfulnessSessionRecord permission")
        } catch (e: ClassNotFoundException) {
            Log.w(TAG, "MindfulnessSessionRecord not available: ${e.message}")
        } catch (e: Exception) {
            Log.e(TAG, "Error adding MindfulnessSessionRecord permission: ${e.message}", e)
        }
    }
    
    // Activity result launcher for permission requests
    private val requestPermissionActivityContract = ActivityResultContracts.RequestMultiplePermissions()
    
    private val requestPermissions = registerForActivityResult(requestPermissionActivityContract) { granted ->
        Log.i(TAG, "Permission request result received")
        
        if (granted.all { it.value }) {
            Log.d(TAG, "All permissions granted!")
            setResult(Activity.RESULT_OK, Intent().apply {
                putExtra(EXTRA_PERMISSIONS_REQUESTED, true)
                putExtra(EXTRA_RESULT_CODE, Activity.RESULT_OK)
            })
        } else {
            Log.e(TAG, "Some permissions were denied")
            val deniedPermissions = granted.filter { !it.value }.keys
            Log.e(TAG, "Denied permissions: ${deniedPermissions.joinToString(", ")}")
            
            setResult(Activity.RESULT_CANCELED, Intent().apply {
                putExtra(EXTRA_PERMISSIONS_REQUESTED, true)
                putExtra(EXTRA_RESULT_CODE, Activity.RESULT_CANCELED)
            })
        }
        
        finish()
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        Log.i(TAG, "HealthConnectActivity created")
        Log.i(TAG, "Intent action: ${intent.action}")
        
        // Initialize Health Connect client
        healthConnectClient = HealthConnectClient.getOrCreate(this)
        
        when (intent.action) {
            "androidx.health.ACTION_SHOW_PERMISSIONS_RATIONALE" -> {
                showPermissionRationale()
            }
            "android.intent.action.VIEW_PERMISSION_USAGE" -> {
                showPermissionUsage()
            }
            else -> {
                // Default action - request permissions
                requestHealthConnectPermissions()
            }
        }
    }
    
    private fun showPermissionRationale() {
        Log.i(TAG, "Showing permission rationale")
        
        // For now, just proceed to request permissions
        // In a real app, you might want to show a dialog explaining why you need the permissions
        requestHealthConnectPermissions()
    }
    
    private fun showPermissionUsage() {
        Log.i(TAG, "Showing permission usage")
        
        // Open Health Connect app to show permission usage
        try {
            val intent = Intent().apply {
                action = Intent.ACTION_VIEW
                data = Uri.parse("package:com.google.android.apps.healthdata")
            }
            startActivity(intent)
        } catch (e: Exception) {
            Log.e(TAG, "Failed to open Health Connect app", e)
            
            // Fallback to Play Store
            try {
                val playStoreIntent = Intent().apply {
                    action = Intent.ACTION_VIEW
                    data = Uri.parse("market://details?id=com.google.android.apps.healthdata")
                }
                startActivity(playStoreIntent)
            } catch (playStoreError: Exception) {
                Log.e(TAG, "Failed to open Play Store", playStoreError)
            }
        }
        
        finish()
    }
    
    private fun requestHealthConnectPermissions() {
        Log.i(TAG, "Requesting Health Connect permissions")
        
        // Check availability first
        val availabilityStatus = HealthConnectClient.getSdkStatus(this)
        Log.i(TAG, "Health Connect SDK status: $availabilityStatus")
        
        when (availabilityStatus) {
            HealthConnectClient.SDK_UNAVAILABLE -> {
                Log.e(TAG, "Health Connect SDK is unavailable")
                setResult(Activity.RESULT_CANCELED, Intent().apply {
                    putExtra("error", "Health Connect SDK is unavailable")
                })
                finish()
                return
            }
            HealthConnectClient.SDK_UNAVAILABLE_PROVIDER_UPDATE_REQUIRED -> {
                Log.w(TAG, "Health Connect provider update required")
                // Redirect user to update Health Connect
                val uri = "market://details?id=com.google.android.apps.healthdata&url=healthconnect%3A%2F%2Fonboarding"
                try {
                    startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(uri)))
                } catch (e: Exception) {
                    Log.e(TAG, "Failed to open Health Connect update page", e)
                }
                setResult(Activity.RESULT_CANCELED, Intent().apply {
                    putExtra("error", "Health Connect update required")
                })
                finish()
                return
            }
            else -> {
                Log.i(TAG, "Health Connect is available, proceeding with permission request")
            }
        }
        
        // Check current permissions
        lifecycleScope.launch {
            try {
                val grantedPermissions = healthConnectClient.permissionController.getGrantedPermissions()
                Log.i(TAG, "Currently granted permissions: ${grantedPermissions.size}")
                
                if (grantedPermissions.containsAll(PERMISSIONS)) {
                    Log.i(TAG, "All permissions already granted")
                    setResult(Activity.RESULT_OK, Intent().apply {
                        putExtra(EXTRA_PERMISSIONS_REQUESTED, false)
                        putExtra(EXTRA_RESULT_CODE, Activity.RESULT_OK)
                    })
                    finish()
                } else {
                    Log.i(TAG, "Launching permission request for ${PERMISSIONS.size} permissions")
                    requestPermissions.launch(PERMISSIONS.toTypedArray())
                }
            } catch (e: Exception) {
                Log.e(TAG, "Error checking permissions", e)
                setResult(Activity.RESULT_CANCELED, Intent().apply {
                    putExtra("error", "Error checking permissions: ${e.message}")
                })
                finish()
            }
        }
    }
}