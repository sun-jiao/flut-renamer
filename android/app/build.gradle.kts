import java.util.Properties
import com.android.build.api.dsl.ApplicationExtension
import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("com.android.application")
    kotlin("android")
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use { 
        localProperties.load(it) 
    }
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { 
        keystoreProperties.load(it) 
    }
}

val _storeFile: String? = System.getenv("KEYSTORE") ?: keystoreProperties.getProperty("storeFile")
val _storePassword: String? = System.getenv("KEYSTORE_PASSWORD") ?: keystoreProperties.getProperty("storePassword")
val _keyAlias: String? = System.getenv("KEY_ALIAS") ?: keystoreProperties.getProperty("keyAlias")
val _keyPassword: String? = System.getenv("KEY_PASSWORD") ?: keystoreProperties.getProperty("keyPassword")

tasks.withType<KotlinCompile>().configureEach {
    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_17)
    }
}

configure<ApplicationExtension> {
    namespace = "net.sunjiao.renamer"
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    sourceSets {
        getByName("main") {
            java.directories.add("src/main/kotlin")
        }
    }

    defaultConfig {
        applicationId = "net.sunjiao.renamer"
        minSdk = flutter.minSdkVersion
        targetSdk = 37
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
    }

    signingConfigs {
        named("debug") {
            if (_storeFile != null && _storePassword != null && _keyAlias != null && _keyPassword != null) {
                keyAlias = _keyAlias
                keyPassword = _keyPassword
                storeFile = file(_storeFile)
                storePassword = _storePassword
            }
        }

        create("release") {
            if (_storeFile != null && _storePassword != null && _keyAlias != null && _keyPassword != null) {
                keyAlias = _keyAlias
                keyPassword = _keyPassword
                storeFile = file(_storeFile)
                storePassword = _storePassword
            }
        }
    }

    buildTypes {
        named("debug") {
            signingConfig = signingConfigs.getByName("debug")
        }

        named("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }

    buildFeatures {
        buildConfig = true
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(kotlin("stdlib-jdk7"))
}
