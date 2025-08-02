plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

fun getLocalProperty(key: String, project: org.gradle.api.Project): String {
    val properties = java.util.Properties()
    val localPropertiesFile = project.rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        properties.load(java.io.FileInputStream(localPropertiesFile))
        return properties.getProperty(key) ?: ""
    }
    return ""
}

android {
    namespace = "com.example.debt_manager"
    compileSdk = 34
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    defaultConfig {
        applicationId = "com.example.debt_manager"
        minSdk = 21
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = System.getenv("CM_KEY_ALIAS") ?: getLocalProperty("keyAlias", project)
            keyPassword = System.getenv("CM_KEY_PASSWORD") ?: getLocalProperty("keyPassword", project)
            storeFile = System.getenv("CM_KEYSTORE_PATH")?.let { project.file(it) } ?: project.file(getLocalProperty("storeFile", project))
            storePassword = System.getenv("CM_KEYSTORE_PASSWORD") ?: getLocalProperty("storePassword", project)
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
