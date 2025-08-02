buildscript {
    ext.kotlin_version = '1.9.23' // تم تحديث إصدار Kotlin
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        // تم تحديث إصدار Android Gradle Plugin ليتوافق مع Gradle 8.9
        classpath 'com.android.tools.build:gradle:8.5.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = '../build'
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
    project.evaluationDependsOn(':app')
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
}
