plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.plugin.compose")
}

val legacyDecodedDir = providers.gradleProperty("legacyDecodedDir")

android {
    namespace = "com.google.android.inputmethod.pinyin.modernsettings.compose.prototype"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.google.android.inputmethod.pinyin.materialcomposeaudit"
        minSdk = 23
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"
    }

    buildFeatures {
        compose = true
    }

    if (legacyDecodedDir.isPresent) {
        val decoded = file(legacyDecodedDir.get())
        sourceSets.named("main") {
            res.directories.add(decoded.resolve("res").absolutePath)
        }
        androidResources.additionalParameters += listOf(
            "--stable-ids",
            decoded.resolve("stable-ids-compose.txt").absolutePath,
        )
    }
}

dependencies {
    implementation(project(":compose-runtime"))
}
