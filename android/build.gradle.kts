buildscript {
    val kotlinVersion = "1.9.10"
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.3.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }

    // Force Java 11 for all modules
    tasks.withType<JavaCompile> {
        sourceCompatibility = JavaVersion.VERSION_11.toString()
        targetCompatibility = JavaVersion.VERSION_11.toString()
    }

    // Suppress Kotlin delicate API warnings
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile> {
        kotlinOptions {
            freeCompilerArgs += listOf(
                "-opt-in=kotlin.RequiresOptIn",
                "-Xopt-in=kotlin.ExperimentalStdlibApi"
            )
        }
    }
}

rootProject.layout.buildDirectory = file("../build")
