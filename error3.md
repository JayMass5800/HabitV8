onnecting a Flutter app to native system sounds for an alarm requires using a Platform Channel to communicate with native Android code. You'll trigger a native Android UI to let the user pick a sound, save their choice, and then use native code again to play that sound when the alarm fires.

Here's a step-by-step guide with code examples.

## 1. Project Setup and Permissions
First, you need to add dependencies and declare the necessary permissions in your Android project.

Dependencies
Add the following to your pubspec.yaml file to manage preferences and scheduling:

YAML

dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.3 # To save the chosen sound
  android_alarm_manager_plus: ^3.0.4 # For scheduling the alarm
Android Permissions
In android/app/src/main/AndroidManifest.xml, add the following permissions. Exact alarm permissions are critical for modern Android versions.

XML

<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
    <uses-permission android:name="android.permission.USE_EXACT_ALARM" />

    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>

    <application ...>
        <activity ...>
            ...
        </activity>

        <service
            android:name="dev.fluttercommunity.plus.androidalarmmanager.AlarmService"
            android:permission="android.permission.BIND_JOB_SERVICE"
            android:exported="false"/>
        <receiver
            android:name="dev.fluttercommunity.plus.androidalarmmanager.AlarmBroadcastReceiver"
            android:exported="false"/>
        <receiver
            android:name="dev.fluttercommunity.plus.androidalarmmanager.RebootBroadcastReceiver"
            android:enabled="false"
            android:exported="false">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED" />
            </intent-filter>
        </receiver>

    </application>
</manifest>
## 2. Flutter (Dart) Code
The Dart code will have three main functions:

Invoking the sound picker: Call native code to open the Android ringtone picker.

Scheduling the alarm: Use android_alarm_manager_plus to set the alarm.

Playing the sound: The alarm callback will invoke native code to play the saved sound.

Dart

// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

// This function needs to be a top-level or static function for the alarm manager
@pragma('vm:entry-point')
void playAlarmSound() async {
  // This is the callback that will be executed when the alarm fires.
  const platform = MethodChannel('com.yourapp.alarm/system_sound');
  try {
    final prefs = await SharedPreferences.getInstance();
    // Retrieve the saved sound URI
    final soundUri = prefs.getString('selected_alarm_sound');
    if (soundUri != null) {
      // Tell the native code to play the sound
      await platform.invokeMethod('playSystemSound', {'soundUri': soundUri});
    } else {
      // Play default sound if none is selected
      await platform.invokeMethod('playSystemSound');
    }
  } on PlatformException catch (e) {
    debugPrint("Failed to play sound: '${e.message}'.");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the alarm manager
  await AndroidAlarmManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Define the platform channel
  static const _platform = MethodChannel('com.yourapp.alarm/system_sound');
  String _selectedSoundName = 'Default';
  String? _selectedSoundUri;

  @override
  void initState() {
    super.initState();
    _loadSelectedSound();
  }

  // Load the saved sound preference
  Future<void> _loadSelectedSound() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedSoundUri = prefs.getString('selected_alarm_sound');
      _selectedSoundName = prefs.getString('selected_alarm_name') ?? 'Default';
    });
  }

  // Method to open the native sound picker
  Future<void> _pickSound() async {
    try {
      // Invoke the native method and wait for the result
      final Map<dynamic, dynamic>? result = await _platform.invokeMethod('pickSystemSound');
      if (result != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('selected_alarm_sound', result['uri']);
        await prefs.setString('selected_alarm_name', result['name']);
        setState(() {
          _selectedSoundUri = result['uri'];
          _selectedSoundName = result['name'];
        });
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to pick sound: '${e.message}'.");
    }
  }

  // Method to schedule the alarm
  Future<void> _scheduleAlarm() async {
    const int alarmId = 0; // A unique ID for the alarm
    await AndroidAlarmManager.oneShot(
      const Duration(seconds: 10), // For demonstration, fires in 10 seconds
      alarmId,
      playAlarmSound,
      exact: true,
      wakeup: true,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alarm set for 10 seconds from now!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('System Sound Alarm')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Selected Sound: $_selectedSoundName', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickSound,
                child: const Text('Pick Alarm Sound'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _scheduleAlarm,
                child: const Text('Set a 10-Second Alarm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
## 3. Android Native (Kotlin) Code
This is where the magic happens. You'll implement the methods to open the sound picker and play the sound.

Modify android/app/src/main/kotlin/com/your-domain/your_app_name/MainActivity.kt.

Kotlin

package com.yourapp.alarm // Make sure this matches your package name

import android.app.Activity
import android.content.Intent
import android.media.Ringtone
import android.media.RingtoneManager
import android.net.Uri
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.yourapp.alarm/system_sound"
    private val RINGTONE_PICKER_REQUEST_CODE = 1
    private var methodChannelResult: MethodChannel.Result? = null
    // Keep a static reference to the ringtone to control it
    companion object {
        private var ringtone: Ringtone? = null
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "pickSystemSound" -> {
                    this.methodChannelResult = result
                    openRingtonePicker()
                }
                "playSystemSound" -> {
                    val uriString: String? = call.argument("soundUri")
                    playRingtone(uriString)
                    result.success(null) // Acknowledge the call
                }
                "stopSystemSound" -> {
                    stopRingtone()
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun openRingtonePicker() {
        val intent = Intent(RingtoneManager.ACTION_RINGTONE_PICKER).apply {
            putExtra(RingtoneManager.EXTRA_RINGTONE_TYPE, RingtoneManager.TYPE_ALARM)
            putExtra(RingtoneManager.EXTRA_RINGTONE_TITLE, "Select Alarm Sound")
            // Show existing URI if one is already selected
            // val existingUri = ... get from shared preferences if needed ...
            // putExtra(RingtoneManager.EXTRA_RINGTONE_EXISTING_URI, existingUri)
        }
        startActivityForResult(intent, RINGTONE_PICKER_REQUEST_CODE)
    }

    private fun playRingtone(uriString: String?) {
        try {
            // Stop any currently playing ringtone
            stopRingtone()
            val soundUri = if (uriString != null) Uri.parse(uriString) else RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            
            ringtone = RingtoneManager.getRingtone(applicationContext, soundUri)
            ringtone?.isLooping = true // Alarms should loop
            ringtone?.play()

        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun stopRingtone() {
        ringtone?.takeIf { it.isPlaying }?.stop()
    }

    // Handle the result from the ringtone picker
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == RINGTONE_PICKER_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
            val uri: Uri? = data?.getParcelableExtra(RingtoneManager.EXTRA_RINGTONE_PICKED_URI)
            if (uri != null) {
                val ringtone = RingtoneManager.getRingtone(this, uri)
                val name = ringtone.getTitle(this)
                val resultData = mapOf("uri" to uri.toString(), "name" to name)
                methodChannelResult?.success(resultData)
            } else {
                methodChannelResult?.success(null) // No ringtone was selected
            }
        } else {
             methodChannelResult?.error("PICKER_ERROR", "Ringtone picker was cancelled or failed.", null)
        }
    }
}
How It Works ⚙️
Pick Sound: The Flutter app calls _pickSound(). This invokes the pickSystemSound method on the platform channel. The Kotlin code in MainActivity.kt catches this, creates an Intent for the RINGTONE_PICKER, and launches it using startActivityForResult.

Get Result: When the user selects a sound and closes the picker, onActivityResult is called in MainActivity.kt. It extracts the sound's URI and name, packages them in a Map, and sends them back to Flutter via methodChannelResult.success().

Save Choice: The Flutter app receives this map and saves the URI and name to SharedPreferences for future use.

Schedule Alarm: android_alarm_manager_plus registers a task with Android's AlarmManager service. This is a robust way to ensure your code runs at a specific time, even if the app is closed.

Alarm Fires: When the alarm time is reached, Android executes the playAlarmSound() callback function in the background.

Play Sound: This Dart callback function retrieves the saved URI from SharedPreferences and makes one final platform channel call to playSystemSound. The native Kotlin code receives the URI, creates a Ringtone object, and plays it. Using a companion object (static in Java terms) for the ringtone instance ensures you can control it (e.g., stop it) across method calls.


Sources
