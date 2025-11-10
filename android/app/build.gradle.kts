plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter plugin must come after Android & Kotlin plugins
    id("dev.flutter.flutter-gradle-plugin")
    // ✅ Add this Firebase plugin
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.shop"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.shop"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// ✅ Add this line at the end for Firebase
apply plugin: "com.google.gms.google-services"
