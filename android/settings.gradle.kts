pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val sdkPath = properties.getProperty("flutter.sdk")
        requireNotNull(sdkPath) { "flutter.sdk not set in local.properties" }
        sdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }

    plugins {
        id("dev.flutter.flutter-gradle-plugin") version "1.0.0" apply false
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "9.2.1" apply false
    id("org.jetbrains.kotlin.android") version "2.4.10" apply false
    id("org.gradle.toolchains.foojay-resolver-convention") version "1.0.0"
}

include(":app")
