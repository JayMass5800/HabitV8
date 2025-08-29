package com.habittracker.habitv8

import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import android.widget.Button
import android.content.Intent
import android.net.Uri

/**
 * PermissionsRationaleActivity
 * 
 * This activity is shown when the user clicks on the privacy policy link
 * in the Health Connect permissions screen. It explains how the app uses
 * health data and provides a link to the full privacy policy.
 * 
 * Required for proper Health Connect integration on Android 14+.
 */
class PermissionsRationaleActivity : ComponentActivity() {
    companion object {
        private const val TAG = "PermissionsRationale"
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        Log.i(TAG, "PermissionsRationaleActivity created")
        
        // Set the layout
        setContentView(R.layout.activity_permissions_rationale)
        
        // Set up privacy policy button
        findViewById<Button>(R.id.btn_view_privacy_policy).setOnClickListener {
            try {
                val intent = Intent(Intent.ACTION_VIEW)
                intent.data = Uri.parse("https://habitv8.com/privacy-policy")
                startActivity(intent)
                Log.i(TAG, "Opening privacy policy website")
            } catch (e: Exception) {
                Log.e(TAG, "Error opening privacy policy", e)
            }
        }
        
        // Set up close button
        findViewById<Button>(R.id.btn_close).setOnClickListener {
            Log.i(TAG, "Closing PermissionsRationaleActivity")
            finish()
        }
    }
}
