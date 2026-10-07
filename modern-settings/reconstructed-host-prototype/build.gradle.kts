plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.plugin.compose")
}

val legacyHostDir = providers.gradleProperty("legacyHostDir")
val hostApplicationId = providers.gradleProperty("hostApplicationId")
    .orElse("com.google.android.inputmethod.pinyin.materialcomposehostaudit")
val hostVersionName = providers.gradleProperty("hostVersionName").orElse("2.0.0")
val hostVersionCode = providers.gradleProperty("hostVersionCode").map(String::toInt).orElse(4520385)

android {
    namespace = "com.google.android.inputmethod.pinyin.modernsettings.host"
    compileSdk = 36

    defaultConfig {
        applicationId = hostApplicationId.get()
        minSdk = 23
        targetSdk = 36
        versionCode = hostVersionCode.get()
        versionName = hostVersionName.get()
        multiDexEnabled = true
        ndk {
            abiFilters += "arm64-v8a"
        }
    }

    // AGP flips its native-library default the moment minSdk reaches 23: it
    // stops extracting at install and writes android:extractNativeLibs="false".
    // That contract only holds if every lib/*.so is stored uncompressed and page
    // aligned, and this package is not: assemble_compose_host_apk.py carries
    // five of the six libraries straight over from the original APK, which has
    // them deflated. The result was a package contradicting its own manifest,
    // which Android 6 refuses with INSTALL_FAILED_INVALID_APK out of
    // NativeLibraryHelper - before a single line of this app runs, and with no
    // crash log to point at it. Keep the legacy packaging the release pipeline
    // has always shipped until the assembler can store and align every library
    // on its own.
    packaging {
        jniLibs {
            useLegacyPackaging = true
        }
    }

    buildFeatures {
        compose = true
    }

    // Apktool reconstructs many qualifier-only and intentionally self-named
    // legacy resources that AGP lint cannot model. Release correctness is
    // enforced by the project resource-ID and API invariant verifiers instead.
    lint {
        checkReleaseBuilds = false
    }

    // EnglishIme opens its raw metadata through openRawResourceFd(), which
    // requires an uncompressed APK entry just like the original apktool
    // doNotCompress contract. AGP otherwise deflates metadata.json silently.
    androidResources.noCompress += "json"

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
