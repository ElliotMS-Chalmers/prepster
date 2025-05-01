plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.prepster"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    /*

    !!!!!!!! IMPORTANT !!!!!!!!

    In order to fix this error:
    "'flutter_local_notifications' requires core library desugaring to be enabled for app"

    Added lines FIX 1 and FIX 2. Removing them crashes the app due to incompatibility
    with flutter_local_notifications plugin! DO NOT REMOVE UNLESS THAT PLUGIN IS REMOVED!

     */



    compileOptions {
        isCoreLibraryDesugaringEnabled = true                                  // FIX 1
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    dependencies {
        coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")       // FIX 2
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.prepster"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
