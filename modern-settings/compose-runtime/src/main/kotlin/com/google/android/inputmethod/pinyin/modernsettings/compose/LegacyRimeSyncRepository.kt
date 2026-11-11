package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.DocumentsContract
import java.lang.reflect.Proxy

data class RimeAutomaticSettings(
    val enabled: Boolean,
    val intervalHours: Int,
    val intervalOptions: List<Int>,
    val lastError: Int,
)

data class RimeSyncSettingsSnapshot(
    val automatic: RimeAutomaticSettings? = null,
    val canEnableAutomatic: Boolean = false,
    val rootUri: String = "",
    val rootLabel: String = "",
    val deviceDirectory: String = "",
    val snapshotFile: String = "pinyin_simp.userdb.txt",
    val locationAccessible: Boolean = false,
    val compatibilityAccepted: Boolean = false,
    val lastSuccess: Long = 0L,
    val sharedEntryCount: Int = 0,
    val rimeOnlyCount: Int = 0,
    val phase: Int = 0,
    val operationInProgress: Boolean = false,
    val nativeExpectedCount: Int = 0,
    val nativeActualCount: Int = 0,
    val nativeMissingCount: Int = 0,
    val nativeFailureRepeated: Boolean = false,
    val nativeFailureKind: NativeFailureKind = NativeFailureKind.None,
) {
    val configurationComplete: Boolean
        get() = rootUri.isNotEmpty() && deviceDirectory.isNotEmpty() && snapshotFile.isNotEmpty()

    val recoveryRequired: Boolean
        get() = phase != 0

    val hasNativePersistenceDiagnostics: Boolean
        get() = nativeExpectedCount > 0 || nativeActualCount > 0

    val nativeRejectedCount: Int
        get() = if (nativeFailureKind == NativeFailureKind.Insert) nativeMissingCount else 0
}

enum class NativeFailureKind {
    None,
    Persistence,
    Io,
    Memory,
    Runtime,
    Duplicate,
    Insert,
    Persist,
    Rebuild,
    Export,
    Data,
    Stale,
}

data class RimeSyncPreview(
    val confirmationToken: String,
    val googleAdditionCount: Int,
    val googleDeletionCount: Int,
    val rimeAdditionCount: Int,
    val rimeDeletionCount: Int,
    val rimeResurrectionCount: Int,
    val projectedGoogleEntryCount: Int,
    val requiresDeletionConfirmation: Boolean,
)

internal enum class RimeSyncError {
    ConfigurationRequired,
    LocationUnavailable,
    OperationInProgress,
    PreviewChanged,
    DeletionConfirmationRequired,
    CapacityExceeded,
    NativePersistence,
    CompatibilityConsent,
    PreviewSourceList,
    PreviewSourceOpen,
    PreviewSourceParse,
    PreviewSourceDatabase,
    PreviewSourceClose,
    PreviewRimeMerge,
    PreviewGoogleExport,
    PreviewSessionPlan,
    DirectoryIdentity,
    BridgeSnapshotMissing,
    OperationFailed,
}

internal data class RimeSyncResponse(
    val settings: RimeSyncSettingsSnapshot,
    val success: Boolean,
    val preview: RimeSyncPreview? = null,
    val error: RimeSyncError? = null,
)

/** Reflection bridge into the Primary DEX manual Rime synchronization boundary. */
internal class LegacyRimeSyncRepository(private val activity: Activity) {
    private val context = activity.applicationContext
    private var lastSettings = RimeSyncSettingsSnapshot()

    fun load(done: (RimeSyncResponse) -> Unit) {
        invokeAsync("readAsync", arrayOf(Context::class.java, callbackType),
            arrayOf(context, callback(done)), done)
    }

    fun persistRootPermission(uri: Uri): Boolean = runCatching {
        activity.contentResolver.takePersistableUriPermission(
            uri,
            Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION,
        )
        activity.contentResolver.persistedUriPermissions.any {
            it.uri == uri && it.isReadPermission && it.isWritePermission
        }
    }.getOrDefault(false)

    fun releaseRootPermission(uri: Uri) {
        runCatching {
            activity.contentResolver.releasePersistableUriPermission(
                uri,
                Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION,
            )
        }
    }

    fun describeRoot(uri: Uri): String {
        if (uri.authority == "com.android.externalstorage.documents") {
            runCatching {
                val id = DocumentsContract.getTreeDocumentId(uri)
                val volume = id.substringBefore(':')
                val path = id.substringAfter(':', "")
                val root = if (volume.equals("primary", true)) {
                    activity.getString(R.string.modern_settings_dictionary_internal_storage)
                } else {
                    activity.getString(R.string.modern_settings_dictionary_sd_card, volume)
                }
                return if (path.isEmpty()) root else "$root/$path"
            }
        }
        return runCatching {
            activity.packageManager.resolveContentProvider(uri.authority.orEmpty(), 0)
                ?.loadLabel(activity.packageManager)?.toString()
        }.getOrNull()?.takeIf(String::isNotEmpty)
            ?: activity.getString(R.string.modern_settings_rime_sync_root_selected)
    }

    fun isDeviceNameValid(value: String): Boolean = runCatching {
        configurationType.getMethod("isValidDeviceName", String::class.java)
            .invoke(null, value) as Boolean
    }.getOrDefault(false)

    fun saveConfiguration(deviceDirectory: String, snapshotFile: String, done: (RimeSyncResponse) -> Unit) {
        invokeAsync("saveConfigurationAsync", arrayOf(
            Context::class.java,
            String::class.java,
            String::class.java,
            callbackType,
        ), arrayOf(context, deviceDirectory, snapshotFile, callback(done)), done)
    }

    fun acceptRoot(uri: Uri, label: String, done: (RimeSyncResponse) -> Unit) {
        invokeAsync("acceptRootAsync", arrayOf(
            Context::class.java,
            Uri::class.java,
            String::class.java,
            callbackType,
        ), arrayOf(context, uri, label, callback(done)), done)
    }

    fun observeChanges(changed: (Boolean) -> Unit): () -> Unit {
        val listenerType = Class.forName(type.name + "\$StateListener")
        val listener = Proxy.newProxyInstance(listenerType.classLoader, arrayOf(listenerType)) { proxy, method, args ->
            when (method.name) {
                "onChanged" -> { changed(args?.firstOrNull() as? Boolean == true); null }
                "hashCode" -> System.identityHashCode(proxy)
                "equals" -> proxy === args?.firstOrNull()
                "toString" -> "RimeSettingsStateListener"
                else -> null
            }
        }
        type.getMethod("addStateListener", listenerType).invoke(null, listener)
        return { type.getMethod("removeStateListener", listenerType).invoke(null, listener); Unit }
    }

    fun configureAutomatic(enabled: Boolean, hours: Int, done: (RimeSyncResponse) -> Unit) {
        invokeAsync("configureAutomaticAsync", arrayOf(
            Context::class.java, Boolean::class.javaPrimitiveType!!,
            Int::class.javaPrimitiveType!!, callbackType,
        ), arrayOf(context, enabled, hours, callback(done)), done)
    }

    fun acceptCompatibility(done: (RimeSyncResponse) -> Unit) {
        invokeAsync("acceptCompatibilityAsync", arrayOf(Context::class.java, callbackType),
            arrayOf(context, callback(done)), done)
    }

    fun synchronize(done: (RimeSyncResponse) -> Unit) {
        invokeAsync("synchronizeAsync", arrayOf(Context::class.java, callbackType),
            arrayOf(context, callback(done)), done)
    }

    fun execute(token: String, deletionConfirmed: Boolean, done: (RimeSyncResponse) -> Unit) {
        invokeAsync("executeAsync", arrayOf(
            Context::class.java,
            String::class.java,
            Boolean::class.javaPrimitiveType!!,
            callbackType,
        ), arrayOf(context, token, deletionConfirmed, callback(done)), done)
    }

    fun resetBaseline(done: (RimeSyncResponse) -> Unit) {
        invokeAsync("resetBaselineAsync", arrayOf(Context::class.java, callbackType),
            arrayOf(context, callback(done)), done)
    }

    private fun invokeAsync(
        name: String,
        parameters: Array<Class<*>>,
        arguments: Array<Any>,
        done: (RimeSyncResponse) -> Unit,
    ) {
        runCatching { type.getMethod(name, *parameters).invoke(null, *arguments) }
            .onFailure {
                done(RimeSyncResponse(lastSettings, success = false,
                    error = RimeSyncError.OperationFailed))
            }
    }

    private fun callback(done: (RimeSyncResponse) -> Unit): Any = Proxy.newProxyInstance(
        callbackType.classLoader,
        arrayOf(callbackType),
    ) { proxy, method, arguments ->
        when (method.name) {
            "onFinished" -> {
                val value = arguments?.firstOrNull()
                done(if (value == null) {
                    RimeSyncResponse(lastSettings, success = false,
                        error = RimeSyncError.OperationFailed)
                } else {
                    response(value)
                })
                null
            }
            "toString" -> "ModernRimeSyncCallback"
            "hashCode" -> System.identityHashCode(proxy)
            "equals" -> proxy === arguments?.firstOrNull()
            else -> null
        }
    }

    private fun response(value: Any): RimeSyncResponse {
        val valueType = value.javaClass
        val success = valueType.getField("success").getBoolean(value)
        val settings = settings(requireNotNull(valueType.getField("settings").get(value)))
        val isPreview = valueType.getField("preview").getBoolean(value)
        val preview = if (success && isPreview) RimeSyncPreview(
            confirmationToken = valueType.getField("confirmationToken").get(value) as String,
            googleAdditionCount = valueType.getField("googleAdditionCount").getInt(value),
            googleDeletionCount = valueType.getField("googleDeletionCount").getInt(value),
            rimeAdditionCount = valueType.getField("rimeAdditionCount").getInt(value),
            rimeDeletionCount = valueType.getField("rimeDeletionCount").getInt(value),
            rimeResurrectionCount = valueType.getField("rimeResurrectionCount").getInt(value),
            projectedGoogleEntryCount = valueType.getField("projectedGoogleEntryCount").getInt(value),
            requiresDeletionConfirmation = valueType.getField(
                "requiresDeletionConfirmation",
            ).getBoolean(value),
        ) else null
        val errorCode = valueType.getField("errorCode").getInt(value)
        return RimeSyncResponse(settings, success, preview, error(errorCode))
    }

    private fun settings(value: Any): RimeSyncSettingsSnapshot {
        val valueType = value.javaClass
        val auto = requireNotNull(valueType.getField("automatic").get(value))
        val autoType = auto.javaClass
        val counts = requireNotNull(valueType.getField("counts").get(value))
        val snapshot = RimeSyncSettingsSnapshot(
            canEnableAutomatic = valueType.getField("canEnableAutomatic").getBoolean(value),
            compatibilityAccepted = valueType.getField("compatibilityAccepted").getBoolean(value),
            automatic = RimeAutomaticSettings(
                enabled = autoType.getField("enabled").getBoolean(auto),
                intervalHours = autoType.getField("intervalHours").getInt(auto),
                intervalOptions = (autoType.getField("intervalOptions").get(auto) as IntArray).toList(),
                lastError = autoType.getField("lastError").getInt(auto),
            ),            rootUri = valueType.getField("rootUri").get(value) as String,
            rootLabel = valueType.getField("rootLabel").get(value) as String,
            deviceDirectory = valueType.getField("deviceDirectory").get(value) as String,
            snapshotFile = valueType.getField("snapshotFile").get(value) as String,
            locationAccessible = valueType.getField("locationAccessible").getBoolean(value),
            lastSuccess = valueType.getField("lastSuccess").getLong(value),
            sharedEntryCount = counts.javaClass.getField("shared").getInt(counts),
            rimeOnlyCount = counts.javaClass.getField("rimeOnly").getInt(counts),
            phase = valueType.getField("phase").getInt(value),
            operationInProgress = valueType.getField("operationInProgress").getBoolean(value),
            nativeExpectedCount = valueType.getField("nativeExpectedCount").getInt(value),
            nativeActualCount = valueType.getField("nativeActualCount").getInt(value),
            nativeMissingCount = valueType.getField("nativeMissingCount").getInt(value),
            nativeFailureRepeated = valueType.getField(
                "nativeFailureRepeated",
            ).getBoolean(value),
            nativeFailureKind = nativeFailureKind(
                valueType.getField("nativeFailureKind").getInt(value),
            ),
        )
        lastSettings = snapshot
        return snapshot
    }

    private fun nativeFailureKind(value: Int): NativeFailureKind = when (value) {
        staticInt("NATIVE_FAILURE_PERSISTENCE") -> NativeFailureKind.Persistence
        staticInt("NATIVE_FAILURE_IO") -> NativeFailureKind.Io
        staticInt("NATIVE_FAILURE_MEMORY") -> NativeFailureKind.Memory
        staticInt("NATIVE_FAILURE_RUNTIME") -> NativeFailureKind.Runtime
        staticInt("NATIVE_FAILURE_DUPLICATE") -> NativeFailureKind.Duplicate
        staticInt("NATIVE_FAILURE_INSERT") -> NativeFailureKind.Insert
        staticInt("NATIVE_FAILURE_PERSIST") -> NativeFailureKind.Persist
        staticInt("NATIVE_FAILURE_REBUILD") -> NativeFailureKind.Rebuild
        staticInt("NATIVE_FAILURE_EXPORT") -> NativeFailureKind.Export
        staticInt("NATIVE_FAILURE_DATA") -> NativeFailureKind.Data
        staticInt("NATIVE_FAILURE_STALE") -> NativeFailureKind.Stale
        else -> NativeFailureKind.None
    }

    private fun error(code: Int): RimeSyncError? = when (code) {
        staticInt("ERROR_NONE") -> null
        staticInt("ERROR_CONFIGURATION_REQUIRED") -> RimeSyncError.ConfigurationRequired
        staticInt("ERROR_LOCATION_UNAVAILABLE") -> RimeSyncError.LocationUnavailable
        staticInt("ERROR_OPERATION_IN_PROGRESS") -> RimeSyncError.OperationInProgress
        staticInt("ERROR_PREVIEW_CHANGED") -> RimeSyncError.PreviewChanged
        staticInt("ERROR_DELETION_CONFIRMATION_REQUIRED") ->
            RimeSyncError.DeletionConfirmationRequired
        staticInt("ERROR_CAPACITY_EXCEEDED") -> RimeSyncError.CapacityExceeded
        staticInt("ERROR_NATIVE_PERSISTENCE") -> RimeSyncError.NativePersistence
        staticInt("ERROR_COMPATIBILITY_CONSENT") -> RimeSyncError.CompatibilityConsent
        staticInt("ERROR_PREVIEW_SOURCE_LIST") -> RimeSyncError.PreviewSourceList
        staticInt("ERROR_PREVIEW_SOURCE_OPEN") -> RimeSyncError.PreviewSourceOpen
        staticInt("ERROR_PREVIEW_SOURCE_PARSE") -> RimeSyncError.PreviewSourceParse
        staticInt("ERROR_PREVIEW_SOURCE_DATABASE") -> RimeSyncError.PreviewSourceDatabase
        staticInt("ERROR_PREVIEW_SOURCE_CLOSE") -> RimeSyncError.PreviewSourceClose
        staticInt("ERROR_PREVIEW_RIME_MERGE") -> RimeSyncError.PreviewRimeMerge
        staticInt("ERROR_PREVIEW_GOOGLE_EXPORT") -> RimeSyncError.PreviewGoogleExport
        staticInt("ERROR_PREVIEW_SESSION_PLAN") -> RimeSyncError.PreviewSessionPlan
        staticInt("ERROR_DIRECTORY_IDENTITY") -> RimeSyncError.DirectoryIdentity
        staticInt("ERROR_BRIDGE_SNAPSHOT_MISSING") -> RimeSyncError.BridgeSnapshotMissing
        else -> RimeSyncError.OperationFailed
    }

    private fun staticInt(name: String): Int = type.getField(name).getInt(null)

    private val configurationType: Class<*>
        get() = Class.forName(
            "com.google.android.inputmethod.pinyin.rimesync.RimeSyncConfiguration",
        )

    private val type: Class<*>
        get() = Class.forName(
            "com.google.android.inputmethod.pinyin.rimesync.RimeSyncSettingsCompat",
        )

    private val callbackType: Class<*>
        get() = Class.forName(
            "com.google.android.inputmethod.pinyin.rimesync.RimeSyncSettingsCompat\$Callback",
        )

}
