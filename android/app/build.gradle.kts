plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // Apply the Google Services plugin (no version here)
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.focus_shift"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.example.focus_shift"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // Use the Firebase BoM to manage versions
    implementation(platform("com.google.firebase:firebase-bom:33.13.0"))

    // And then pull in the individual Firebase libraries you need:
    implementation("com.google.firebase:firebase-analytics")
    // … any others …
}

flutter {
    source = "../.."
}
