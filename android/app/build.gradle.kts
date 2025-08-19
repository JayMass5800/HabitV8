import java.util.Properties
import java.io.FileInputStream

// Load keystore properties
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.habittracker.habitv8"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
        freeCompilerArgs += listOf(
            "-opt-in=kotlin.RequiresOptIn",
            "-Xopt-in=kotlin.ExperimentalStdlibApi"
        )
    }

    defaultConfig {
        applicationId = "com.habittracker.habitv8"
        minSdk = 26
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Add these for better Play Store compatibility
        multiDexEnabled = true
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        
        // Fix for 16 KB native library alignment
        ndk {
            // Ensure native libraries are aligned for 16 KB page sizes
            abiFilters += listOf("arm64-v8a", "armeabi-v7a", "x86_64", "x86")
        }
        
        // Manifest placeholders for health permissions control
        manifestPlaceholders["healthPermissionsOnly"] = "true"
        manifestPlaceholders["healthPermissionsRestricted"] = "true"
        manifestPlaceholders["healthDataTypesMinimal"] = "true"
    }

    // Configure packaging options for native library alignment
    packaging {
        jniLibs {
            // Modern approach for 16 KB alignment - let AGP handle it automatically
            useLegacyPackaging = false
        }
        // Ensure proper alignment for all native libraries
        resources {
            excludes += listOf(
                "META-INF/DEPENDENCIES",
                "META-INF/LICENSE",
                "META-INF/LICENSE.txt",
                "META-INF/license.txt",
                "META-INF/NOTICE",
                "META-INF/NOTICE.txt",
                "META-INF/notice.txt",
                "META-INF/ASL2.0"
            )
        }
    }

    // Additional configuration for 16 KB page size support
    bundle {
        language {
            // Disable language splits to ensure proper native library packaging
            enableSplit = false
        }
        density {
            // Disable density splits to ensure proper native library packaging
            enableSplit = false
        }
        abi {
            // Enable ABI splits but ensure proper alignment
            enableSplit = true
        }
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        debug {
            applicationIdSuffix = ".debug"
            isDebuggable = true
        }
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            signingConfig = signingConfigs.getByName("release")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            
            // Additional resource shrinking for health permissions
            // resourceConfigurations += listOf("en") // Commented out - not available in this context
            
            // Ensure unused health permissions are stripped
            manifestPlaceholders["stripUnusedHealthPermissions"] = "true"
            
            // Configure manifest merger to remove unwanted permissions
            androidResources {
                additionalParameters += listOf("--extra-packages", "com.habittracker.habitv8.health")
            }
        }
    }
}

flutter {
    source = "../.."
}



dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    
    // Health Connect dependencies - try newer alpha with mindfulness support
    implementation("androidx.health.connect:connect-client:1.1.0-alpha07")
    
    // Coroutines for async operations
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.8.1")
}

// Apply custom health permissions scripts
apply(from = "remove_health_permissions.gradle")
apply(from = "add_health_permissions.gradle")

// Add Health Connect dependencies with explicit versions
dependencies {
    // Health Connect for heart rate and background monitoring
    implementation("androidx.health.connect:connect-client:1.1.0-alpha07")
    
    // Activity recognition
    implementation("com.google.android.gms:play-services-location:21.2.0")
}
