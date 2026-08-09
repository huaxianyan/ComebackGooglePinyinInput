package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.DocumentsContract
import android.text.format.DateFormat
import java.lang.reflect.Proxy

/** Typed state bridge for the compatibility backup store; native I/O remains in primary DEX. */
internal class LegacyDictionarySettingsRepository(private val activity: Activity) {
    private val context = activity.applicationContext
    private val preferences = context.getSharedPreferences(
        DictionarySettingContracts.preferencesName,
        Context.MODE_PRIVATE,
    )
    private val legacyPreferences = context.getSharedPreferences(
        "${context.packageName}_preferences",
        Context.MODE_PRIVATE,
    )

    fun read(): DictionarySettingsSnapshot {
        val tree = configuredTree()
        val accessible = tree != null && hasPersistedAccess(tree)
        val enabled = preferences.getBoolean(DictionarySettingContracts.enabledKey, false)
        val inProgress = legacyBoolean("isInProgress")
        val status = preferences.getString(DictionarySettingContracts.lastStatusKey, null)
        val lastSuccess = preferences.getLong(DictionarySettingContracts.lastSuccessKey, 0L)
        val backupSummary = when {
            inProgress -> activity.getString(R.string.modern_settings_dictionary_backup_in_progress)
            !status.isNullOrEmpty() && status != activity.getString(
                R.string.modern_settings_dictionary_legacy_success_status,
            ) -> status
            lastSuccess > 0L -> activity.getString(
                R.string.modern_settings_dictionary_last_backup,
                DateFormat.getDateFormat(context).format(lastSuccess),
                DateFormat.getTimeFormat(context).format(lastSuccess),
            )
            else -> activity.getString(R.string.modern_settings_dictionary_backup_retained)
        }
        val label = preferences.getString(DictionarySettingContracts.treeLabelKey, null)
        val locationSummary = when {
            tree == null -> activity.getString(R.string.modern_settings_dictionary_location_unset)
            !accessible -> activity.getString(R.string.modern_settings_dictionary_location_inaccessible)
            label.isNullOrEmpty() -> activity.getString(R.string.modern_settings_dictionary_location_selected)
            else -> label
        }
        return DictionarySettingsSnapshot(
            automaticBackupEnabled = enabled,
            locationAccessible = accessible,
            locationSummary = locationSummary,
            intervalIndex = DictionarySettingContracts.intervalIndex(
                preferences.getInt(DictionarySettingContracts.intervalKey, 7),
            ),
            intervalLabels = legacyArray("dictionary_auto_backup_interval_entries"),
            retentionIndex = DictionarySettingContracts.retentionIndex(
                preferences.getInt(DictionarySettingContracts.retentionKey, 10),
            ),
            retentionLabels = legacyArray("dictionary_auto_backup_retention_entries"),
            backupInProgress = inProgress,
            automaticBackupSummary = backupSummary,
            shortcutsEnabled = BooleanSettingState(
                value = legacyPreferences.getBoolean(shortcutsKey, true),
                isExplicit = legacyPreferences.contains(shortcutsKey),
            ),
        )
    }

    fun setShortcutsEnabled(enabled: Boolean) {
        legacyPreferences.edit().putBoolean(shortcutsKey, enabled).apply()
    }

    fun disableAutomaticBackup() {
        preferences.edit().putBoolean(DictionarySettingContracts.enabledKey, false).apply()
    }

    fun enableAutomaticBackup() {
        require(read().locationAccessible) { "Backup location is unavailable" }
        preferences.edit().putBoolean(DictionarySettingContracts.enabledKey, true).apply()
        requestBackup()
    }

    fun setInterval(index: Int) {
        require(read().automaticBackupEnabled && read().locationAccessible)
        preferences.edit().putInt(
            DictionarySettingContracts.intervalKey,
            DictionarySettingContracts.intervalValues[index],
        ).apply()
    }

    fun setRetention(index: Int) {
        require(read().automaticBackupEnabled && read().locationAccessible)
        preferences.edit().putInt(
            DictionarySettingContracts.retentionKey,
            DictionarySettingContracts.retentionValues[index],
        ).apply()
    }

    fun requestBackup() {
        require(read().locationAccessible && !read().backupInProgress)
        val type = Class.forName("com.google.android.inputmethod.pinyin.DictionaryAutoBackupCompat")
        type.getMethod("request", Context::class.java, Boolean::class.javaPrimitiveType)
            .invoke(null, context, true)
    }

    fun openImport() {
        require(read().locationAccessible)
        activity.startActivity(
            Intent().setClassName(
                context.packageName,
                "com.google.android.inputmethod.pinyin.LocalBackupImportActivity",
            ),
        )
    }

    fun openShortcutEditor() {
        activity.startActivity(Intent("android.settings.USER_DICTIONARY_SETTINGS"))
    }

    fun openLegacyDictionaryOperations() {
        activity.startActivity(
            Intent().setClassName(
                context.packageName,
                "com.google.android.apps.inputmethod.pinyin.preference.SettingsActivity",
            ).putExtra(
                ":android:show_fragment",
                "com.google.android.apps.inputmethod.pinyin.preference.DictionarySettingsFragment",
            ).putExtra(
                "PREFERENCE_FRAGMENT",
                "setting_dictionary",
            ),
        )
    }

    fun loadHealth(onLoaded: (String) -> Unit) {
        val type = Class.forName("com.google.android.inputmethod.pinyin.DictionaryHealthStatusCompat")
        val callbackType = Class.forName(
            "com.google.android.inputmethod.pinyin.DictionaryHealthStatusCompat\$Callback",
        )
        val callback = Proxy.newProxyInstance(
            callbackType.classLoader,
            arrayOf(callbackType),
        ) { proxy, method, arguments ->
            when (method.name) {
                "onLoaded" -> {
                    onLoaded(arguments?.firstOrNull() as? String ?: "")
                    null
                }
                "toString" -> "ModernDictionaryHealthCallback"
                "hashCode" -> System.identityHashCode(proxy)
                "equals" -> proxy === arguments?.firstOrNull()
                else -> null
            }
        }
        type.getMethod("load", Context::class.java, callbackType).invoke(null, context, callback)
    }

    /** Persist the grant only after the primary-DEX validator has exercised create/read/rename/delete. */
    fun acceptTreeAsync(uri: Uri, enableAfterSelection: Boolean, onFinished: (String?) -> Unit) {
        try {
            activity.contentResolver.takePersistableUriPermission(
                uri,
                Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION,
            )
        } catch (_: RuntimeException) {
            onFinished(activity.getString(R.string.modern_settings_dictionary_grant_failed))
            return
        }
        if (!hasPersistedAccess(uri)) {
            releaseGrant(uri)
            onFinished(activity.getString(R.string.modern_settings_dictionary_grant_failed))
            return
        }
        val type = Class.forName("com.google.android.inputmethod.pinyin.DictionaryAutoBackupCompat")
        val callbackType = Class.forName(
            "com.google.android.inputmethod.pinyin.DictionaryAutoBackupCompat\$ValidationCallback",
        )
        val callback = Proxy.newProxyInstance(callbackType.classLoader, arrayOf(callbackType)) {
                proxy, method, arguments ->
            when (method.name) {
                "onValidationFinished" -> {
                    val error = arguments?.getOrNull(1) as? String
                    if (error == null) commitTree(uri, enableAfterSelection) else releaseGrant(uri)
                    onFinished(error)
                    null
                }
                "toString" -> "ModernDictionaryTreeValidationCallback"
                "hashCode" -> System.identityHashCode(proxy)
                "equals" -> proxy === arguments?.firstOrNull()
                else -> null
            }
        }
        val method = type.getDeclaredMethod("validateTreeAsync", Context::class.java, Uri::class.java, callbackType)
        method.isAccessible = true
        method.invoke(null, context, uri, callback)
    }

    private fun commitTree(uri: Uri, enableAfterSelection: Boolean) {
        val old = configuredTree()
        val shouldEnable = enableAfterSelection || preferences.getBoolean(
            DictionarySettingContracts.enabledKey,
            false,
        )
        preferences.edit()
            .putString(DictionarySettingContracts.treeUriKey, uri.toString())
            .putString(DictionarySettingContracts.treeLabelKey, describeTree(uri))
            .putBoolean(DictionarySettingContracts.enabledKey, shouldEnable)
            .putString(
                DictionarySettingContracts.lastStatusKey,
                activity.getString(R.string.modern_settings_dictionary_legacy_location_validated),
            )
            .apply()
        if (old != null && old != uri) releaseGrant(old)
        if (shouldEnable) requestBackup()
    }

    private fun configuredTree(): Uri? = preferences
        .getString(DictionarySettingContracts.treeUriKey, null)
        ?.takeIf(String::isNotEmpty)
        ?.let { runCatching { Uri.parse(it) }.getOrNull() }

    private fun hasPersistedAccess(uri: Uri): Boolean {
        if (uri.scheme != "content" || !runCatching { DocumentsContract.isTreeUri(uri) }.getOrDefault(false)) {
            return false
        }
        return runCatching {
            activity.contentResolver.persistedUriPermissions.any {
                it.uri == uri && it.isReadPermission && it.isWritePermission
            }
        }.getOrDefault(false)
    }

    private fun releaseGrant(uri: Uri) {
        runCatching {
            activity.contentResolver.releasePersistableUriPermission(
                uri,
                Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION,
            )
        }
    }

    private fun describeTree(uri: Uri): String {
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
        val providerLabel = runCatching {
            activity.packageManager.resolveContentProvider(uri.authority.orEmpty(), 0)
                ?.loadLabel(activity.packageManager)?.toString()
        }.getOrNull()
        return providerLabel?.takeIf(String::isNotEmpty)
            ?: activity.getString(R.string.modern_settings_dictionary_location_selected)
    }

    private fun legacyArray(name: String): List<String> {
        val id = activity.resources.getIdentifier(name, "array", context.packageName)
        require(id != 0) { "Missing legacy dictionary array: $name" }
        return activity.resources.getStringArray(id).toList()
    }

    private val shortcutsKey: String
        get() {
            val id = activity.resources.getIdentifier(
                "pref_key_enable_shortcuts_dictionary",
                "string",
                context.packageName,
            )
            require(id != 0) { "Missing shortcuts dictionary key" }
            return activity.getString(id)
        }

    private fun legacyBoolean(method: String): Boolean = runCatching {
        Class.forName("com.google.android.inputmethod.pinyin.DictionaryAutoBackupCompat")
            .getMethod(method).invoke(null) as Boolean
    }.getOrDefault(false)
}
