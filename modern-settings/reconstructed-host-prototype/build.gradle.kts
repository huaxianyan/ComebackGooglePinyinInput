plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.plugin.compose")
}

val legacyHostDir = providers.gradleProperty("legacyHostDir")
val hostApplicationId = providers.gradleProperty("hostApplicationId")
    .orElse("com.google.android.inputmethod.pinyin.materialcomposehostaudit")

android {
    namespace = "com.google.android.inputmethod.pinyin.modernsettings.host"
    compileSdk = 36

    defaultConfig {
        applicationId = hostApplicationId.get()
        minSdk = 17
        targetSdk = 36
        versionCode = 4520385
        versionName = "2.0.0"
        multiDexEnabled = true
        ndk {
            abiFilters += "arm64-v8a"
        }
    }

    buildFeatures {
        compose = true
    }

    if (legacyHostDir.isPresent) {
        val host = file(legacyHostDir.get())
        sourceSets.named("main") {
            manifest.srcFile(host.resolve("AndroidManifest.xml"))
            res.directories.add(host.resolve("res").absolutePath)
        }
        androidResources.additionalParameters += listOf(
            "--stable-ids",
            host.resolve("stable-ids.txt").absolutePath,
        )
    }
}

dependencies {
    implementation(project(":compose-runtime"))
}
