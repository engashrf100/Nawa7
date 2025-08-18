plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.nawah"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.nawah"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Enable multidex for large apps
        multiDexEnabled = true
        
        // Enable vector drawables
        vectorDrawables.useSupportLibrary = true
    }

    buildTypes {
        release {
            // Enable code shrinking and obfuscation for security
            isMinifyEnabled = true
            isShrinkResources = true
            
            // ProGuard rules for code obfuscation
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            
            // Signing configuration for release
            signingConfig = signingConfigs.getByName("debug")
            
            // Enable R8 full mode for better optimization
            isCrunchPngs = true
            
            // Build config fields for release
            buildConfigField("boolean", "DEBUG", "false")
            buildConfigField("boolean", "ENABLE_LOGGING", "false")
        }
        
        debug {
            // Debug configuration
            isMinifyEnabled = false
            isShrinkResources = false
            buildConfigField("boolean", "DEBUG", "true")
            buildConfigField("boolean", "ENABLE_LOGGING", "true")
        }
    }
    
    // Enable build features
    buildFeatures {
        buildConfig = true
    }
    
    // Bundle configuration for AAB
    bundle {
        language {
            enableSplit = true
        }
        density {
            enableSplit = true
        }
        abi {
            enableSplit = true
        }
    }
}

flutter {
    source = "../.."
}
