import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keyStoreProperties = Properties()
val keyStoreFile = rootProject.file("key.properties")
if (keyStoreFile.exists()) {
    keyStoreProperties.load(FileInputStream(keyStoreFile))
}

android {
    namespace = "app.babycareai"
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
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "app.babycareai"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val storeFilePath = keyStoreProperties["storeFile"] as String?
            val storePasswordValue = keyStoreProperties["storePassword"] as String?
            val keyAliasValue = keyStoreProperties["keyAlias"] as String?
            val keyPasswordValue = keyStoreProperties["keyPassword"] as String?

            if (storeFilePath != null) {
                storeFile = file(storeFilePath)
            }
            if (storePasswordValue != null) {
                storePassword = storePasswordValue
            }
            if (keyAliasValue != null) {
                keyAlias = keyAliasValue
            }
            if (keyPasswordValue != null) {
                keyPassword = keyPasswordValue
            }
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
