package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.app.Application
import android.content.Context
import android.net.Uri
import android.os.Handler
import android.os.Looper
import androidx.annotation.StringRes
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.AndroidViewModel
import java.io.File
import java.util.concurrent.Executors

data class SettingsTransferState(
    val busy: Boolean = false,
    val confirmImport: Boolean = false,
    val recoveryRequested: Boolean = false,
    @param:StringRes val message: Int? = null,
)

/** Activity-independent owner of SAF I/O; rotation neither repeats imports nor loses results. */
internal class SettingsTransferViewModel(application: Application) : AndroidViewModel(application) {
    private val context = application.applicationContext
    private val worker = Executors.newSingleThreadExecutor()
    private val main = Handler(Looper.getMainLooper())
    private val recovery = context.getSharedPreferences("settings_transfer_recovery", Context.MODE_PRIVATE)
    private val preferences = context.getSharedPreferences("${context.packageName}_preferences", Context.MODE_PRIVATE)
    private val backup = context.getSharedPreferences(DictionarySettingContracts.preferencesName, Context.MODE_PRIVATE)
    private val stagingDirectory = File(context.cacheDir, "settings-transfer")
    var state by mutableStateOf(SettingsTransferState())
        private set
    var pendingImport: SettingsTransferData? = null
        private set
    val contactsRequested: Boolean get() = recovery.getBoolean(CONTACTS_REQUESTED, false)

    fun export(uri: Uri, dictionary: DictionarySettingsSnapshot, rime: RimeSyncSettingsSnapshot) {
        execute(R.string.modern_settings_transfer_export_error) {
            val themeFiles = context.filesDir.listFiles().orEmpty()
                .filter { it.isFile && it.name.startsWith(ThemeCatalogRules.USER_THEME_DIRECTORY_PREFIX) }
            require(themeFiles.sumOf { it.length() } <= SettingsTransferArchive.MAX_BYTES)
            val themes = themeFiles.associate { file -> file.name to file.readBytes() }
            val data = SettingsTransferData(
                preferences.all.filterKeys { it in SettingsTransferSchema.keys }.mapValues { requireNotNull(it.value) },
                if (backup.contains(DictionarySettingContracts.intervalKey))
                    DictionarySettingContracts.intervalValues[dictionary.intervalIndex] else 0,
                if (backup.contains(DictionarySettingContracts.retentionKey))
                    DictionarySettingContracts.retentionValues[dictionary.retentionIndex] else 0,
                dictionary.contactSuggestionsEnabled || contactsRequested,
                rime.deviceDirectory, rime.snapshotFile, requireNotNull(rime.automatic).intervalHours,
                dictionary.shortcutsEnabled.takeIf { it.isExplicit }?.value,
                themes,
            )
            requireNotNull(context.contentResolver.openOutputStream(uri, "wt")).use {
                SettingsTransferArchive.write(data, it)
            }
            SettingsTransferState(message = R.string.modern_settings_transfer_export_success)
        }
    }

    fun readImport(uri: Uri) {
        execute(R.string.modern_settings_transfer_read_error) {
            val data = requireNotNull(context.contentResolver.openInputStream(uri)).use(SettingsTransferArchive::read)
            validateRestoredThemes(data)
            val staged = stagingDirectory.also { it.mkdirs() }
            try {
                data.themes.forEach { (name, bytes) ->
                    val file = File(staged, name)
                    file.writeBytes(bytes)
                    requireNotNull(ThemeBuilderBridge.openPackage(file))
                }
            } finally {
                staged.deleteRecursively()
            }
            Class.forName("com.google.android.inputmethod.pinyin.rimesync.RimeAutoSyncPolicy")
                .getMethod("intervalMillis", Int::class.javaPrimitiveType)
                .invoke(null, data.rimeIntervalHours)
            if (data.rimeDevice.isNotEmpty()) {
                Class.forName("com.google.android.inputmethod.pinyin.rimesync.RimeSyncConfiguration")
                    .getConstructor(String::class.java, String::class.java)
                    .newInstance(data.rimeDevice, data.rimeFile)
            }
            pendingImport = data
            SettingsTransferState(confirmImport = true)
        }
    }

    fun dismissImport() {
        pendingImport = null
        state = SettingsTransferState()
    }

    fun beginImport() { state = SettingsTransferState(busy = true) }

    fun importSettings() {
        val data = requireNotNull(pendingImport)
        execute(R.string.modern_settings_transfer_import_error, alreadyBusy = true) {
            val staged = stagingDirectory.also { it.mkdirs() }
            try {
                data.themes.forEach { (name, bytes) ->
                    val file = File(staged, name)
                    file.writeBytes(bytes)
                }
                // Archive data and packages were checked before the import confirmation.
                val previousFiles = data.themes.keys.associateWith { name ->
                    File(context.filesDir, name).takeIf { it.exists() }?.readBytes()
                }
                try {
                    data.themes.keys.forEach { name ->
                        File(staged, name).copyTo(File(context.filesDir, name), overwrite = true)
                    }
                    val editor = preferences.edit()
                    SettingsTransferSchema.keys.forEach(editor::remove)
                    data.preferences.forEach { (key, value) ->
                        when (value) {
                            is Boolean -> editor.putBoolean(key, value)
                            is String -> editor.putString(key, value)
                            is Float -> editor.putFloat(key, value)
                        }
                    }
                    check(editor.commit())
                } catch (failure: Exception) {
                    previousFiles.forEach { (name, bytes) ->
                        val file = File(context.filesDir, name)
                        if (bytes == null) file.delete() else file.writeBytes(bytes)
                    }
                    throw failure
                }
                val backupEditor = backup.edit().putBoolean(DictionarySettingContracts.enabledKey, false)
                if (data.backupIntervalDays == 0) backupEditor.remove(DictionarySettingContracts.intervalKey)
                else backupEditor.putInt(DictionarySettingContracts.intervalKey, data.backupIntervalDays)
                if (data.backupRetention == 0) backupEditor.remove(DictionarySettingContracts.retentionKey)
                else backupEditor.putInt(DictionarySettingContracts.retentionKey, data.backupRetention)
                check(backupEditor.commit())
                Class.forName("com.google.android.inputmethod.pinyin.SystemAutoThemeCompat")
                    .getMethod("applyOnCreate", Context::class.java).invoke(null, context)
                check(recovery.edit().putBoolean(CONTACTS_REQUESTED, data.contactsRequested).commit())
                pendingImport = null
                SettingsTransferState(recoveryRequested = true,
                    message = R.string.modern_settings_transfer_import_success)
            } finally {
                staged.deleteRecursively()
            }
        }
    }

    fun failImport(@StringRes message: Int = R.string.modern_settings_transfer_rime_error) {
        state = SettingsTransferState(message = message)
    }

    fun rememberContactsChoice(enabled: Boolean) {
        recovery.edit().putBoolean(CONTACTS_REQUESTED, enabled).apply()
    }

    private fun validateRestoredThemes(data: SettingsTransferData) {
        val builtins = LegacySettingsRepository(context).readSnapshot().themeCatalog.builtin.map { it.value }.toSet()
        val validAdditional = builtins + data.themes.keys.map { ThemeSource.User.valuePrefix + it } +
            DynamicColorSetting.generatedPackageValue + ""
        val additionalKeys = ThemeSlotKey.entries.map { it.additionalKey } + SettingsPreferenceKeys.ACTIVE_THEME
        additionalKeys.forEach { key ->
            data.preferences[key]?.let { require(it is String && it in validAdditional) }
        }
        val baseKeys = ThemeSlotKey.entries.map { it.baseKey } + SettingsPreferenceKeys.BASE_THEME
        baseKeys.forEach { key ->
            data.preferences[key]?.let { value ->
                require(value is String && value.length <= 128 &&
                    value.all { it.isLetterOrDigit() || it in "_.-" })
            }
        }
    }

    fun acknowledgeRecovery() { state = state.copy(recoveryRequested = false) }

    private fun execute(@StringRes error: Int, alreadyBusy: Boolean = false, operation: () -> SettingsTransferState) {
        if (state.busy && !alreadyBusy) return
        state = SettingsTransferState(busy = true)
        worker.execute {
            val result = try { operation() }
            catch (_: Exception) { SettingsTransferState(message = error) }
            main.post { state = result }
        }
    }

    override fun onCleared() {
        worker.shutdown()
    }

    private companion object {
        const val CONTACTS_REQUESTED = "contacts_requested"
    }
}
