plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// دالة لجلب المتغيرات من ملف local.properties
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
    // تم حل مشكلة الـ namespace مسبقاً، هذا جيد
    namespace = "com.example.debt_manager" // غيرته ليتطابق مع الأكواد السابقة

    // تم تحديث الأرقام بشكل صريح لحل مشاكل التوافق
    compileSdk = 34
    ndkVersion = "27.0.12077973" // هذا هو الحل المباشر لخطأ NDK السابق

    compileOptions {
        // استخدام Java 8 هو الأكثر توافقاً مع معظم الحزم
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
        applicationId = "com.example.debt_manager" // غيرته ليتطابق مع الأكواد السابقة
        minSdk = 21 // تحديد الرقم بشكل صريح أفضل من المتغير
        targetSdk = 34 // تحديد الرقم بشكل صريح أفضل من المتغير
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // هذه هي النقطة الأهم لبناء نسخة Release ناجحة
    signingConfigs {
        create("release") {
            // هنا سنقرأ معلومات التوقيع من المتغيرات الآمنة في Codemagic
            // أو من ملف local.properties محلياً
            keyAlias = System.getenv("CM_KEY_ALIAS") ?: getLocalProperty("keyAlias", project)
            keyPassword = System.getenv("CM_KEY_PASSWORD") ?: getLocalProperty("keyPassword", project)
            storeFile = System.getenv("CM_KEYSTORE_PATH")?.let { project.file(it) } ?: project.file(getLocalProperty("storeFile", project))
            storePassword = System.getenv("CM_KEYSTORE_PASSWORD") ?: getLocalProperty("storePassword", project)
        }
    }

    buildTypes {
        release {
            // أخبر بناء Release أن يستخدم إعدادات التوقيع التي أنشأناها
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // يمكنك إضافة أي اعتماديات خاصة بالأندرويد هنا
}
