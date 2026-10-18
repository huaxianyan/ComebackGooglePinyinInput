package com.google.android.inputmethod.pinyin.modernsettings.compose

import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.io.DataInputStream
import java.io.DataOutputStream
import java.io.InputStream
import java.io.OutputStream
import java.util.zip.ZipEntry
import java.util.zip.ZipInputStream
import java.util.zip.ZipOutputStream

internal data class SettingsTransferData(
    val preferences: Map<String, Any>,
    val backupIntervalDays: Int,
    val backupRetention: Int,
    val contactsRequested: Boolean,
    val rimeDevice: String,
    val rimeFile: String,
    val rimeIntervalHours: Int,
    val shortcuts: Boolean? = null,
    val themes: Map<String, ByteArray> = emptyMap(),
)

/** Only user settings cross installations; permissions, task state and sync history do not. */
internal object SettingsTransferSchema {
    private val booleans = (BooleanSettingContracts.writable +
        BooleanSettingContracts.gestureInput + BooleanSettingContracts.gestureInputPersistent)
        .map { it.key }.toSet() + setOf(
        SliderSettingContracts.SOUND_ENABLED_KEY,
        SliderSettingContracts.VIBRATION_ENABLED_KEY,
        SettingsPreferenceKeys.LAUNCHER_ICON,
        SettingsPreferenceKeys.KEY_BORDER,
        SystemAutoThemeSetting.preferenceKey,
        DynamicColorSetting.preferenceKey,
    )
    private val lists = listOf(
        ListSettingContracts.oneHandedMode,
        ListSettingContracts.pinyinScheme,
        ListSettingContracts.englishT9MultitapInterval,
    ).associate { it.key to it.values } + listOf(
        SliderSettingContracts.keyboardHeight,
        SliderSettingContracts.slideSensitivity,
        SliderSettingContracts.handwritingTimeout,
        SliderSettingContracts.handwritingStrokeWidth,
    ).associate { it.key to it.values }
    private val themeKeys = ThemeSlotKey.entries.flatMap { listOf(it.baseKey, it.additionalKey) }
        .toSet() + setOf(SettingsPreferenceKeys.ACTIVE_THEME, SettingsPreferenceKeys.BASE_THEME)
    val keys: Set<String> = booleans + lists.keys + themeKeys + setOf(
        SliderSettingContracts.SOUND_VOLUME_KEY,
        SliderSettingContracts.VIBRATION_DURATION_KEY,
        SliderSettingContracts.LONG_PRESS_DELAY_KEY,
    )

    fun validate(values: Map<String, Any>) {
        require(values.keys.all { it in keys })
        values.forEach { (key, value) ->
            require(when {
                key in booleans -> value is Boolean
                key in lists -> value is String && value in lists.getValue(key)
                key in themeKeys -> value is String
                key == SliderSettingContracts.SOUND_VOLUME_KEY ->
                    value is Float && value.isFinite() && value in -1f..1f
                key == SliderSettingContracts.VIBRATION_DURATION_KEY ->
                    value is String && value.toIntOrNull()?.let { it in 0..101 } == true
                key == SliderSettingContracts.LONG_PRESS_DELAY_KEY ->
                    value is String && runCatching {
                        SliderSettingContracts.resolveLongPress(true, value)
                    }.isSuccess
                else -> false
            })
        }
    }
}

/** Versioned, typed archive. Theme packages stay opaque and are never unpacked into filesDir. */
internal object SettingsTransferArchive {
    private const val VERSION = 1
    private const val MAGIC = "ComebackGooglePinyinInput settings"
    private const val METADATA = "settings.bin"
    // SAF files are untrusted input. Bound decompressed allocation, including nested theme packages.
    const val MAX_BYTES = 64 * 1024 * 1024
    private const val MAX_METADATA_BYTES = 1024 * 1024

    fun write(data: SettingsTransferData, output: OutputStream) {
        validate(data)
        val metadata = ByteArrayOutputStream().also { buffer ->
            DataOutputStream(buffer).use { stream ->
                stream.writeUTF(MAGIC)
                stream.writeInt(VERSION)
                stream.writeInt(data.preferences.size)
                data.preferences.toSortedMap().forEach { (key, value) ->
                    stream.writeUTF(key)
                    when (value) {
                        is Boolean -> { stream.writeByte(1); stream.writeBoolean(value) }
                        is String -> { stream.writeByte(2); stream.writeUTF(value) }
                        is Float -> { stream.writeByte(3); stream.writeFloat(value) }
                        else -> error("Unsupported preference type")
                    }
                }
                stream.writeInt(data.backupIntervalDays)
                stream.writeInt(data.backupRetention)
                stream.writeBoolean(data.contactsRequested)
                stream.writeUTF(data.rimeDevice)
                stream.writeUTF(data.rimeFile)
                stream.writeInt(data.rimeIntervalHours)
                stream.writeByte(when (data.shortcuts) { null -> -1; false -> 0; true -> 1 })
            }
        }.toByteArray()
        require(metadata.size <= MAX_METADATA_BYTES)
        require(metadata.size.toLong() + data.themes.values.sumOf { it.size.toLong() } <= MAX_BYTES)
        ZipOutputStream(output).use { zip ->
            zip.putNextEntry(ZipEntry(METADATA))
            zip.write(metadata)
            zip.closeEntry()
            data.themes.toSortedMap().forEach { (name, bytes) ->
                zip.putNextEntry(ZipEntry("themes/$name"))
                zip.write(bytes)
                zip.closeEntry()
            }
        }
    }

    fun read(input: InputStream): SettingsTransferData {
        var metadata: ByteArray? = null
        val themes = linkedMapOf<String, ByteArray>()
        var remaining = MAX_BYTES
        ZipInputStream(input).use { zip ->
            while (true) {
                val entry = zip.nextEntry ?: break
                require(!entry.isDirectory)
                val name = entry.name
                require(name == METADATA || (name.startsWith("themes/") &&
                    validThemeName(name.removePrefix("themes/"))))
                require(if (name == METADATA) metadata == null
                    else !themes.containsKey(name.removePrefix("themes/")))
                val bytes = readBounded(zip, minOf(remaining,
                    if (name == METADATA) MAX_METADATA_BYTES else MAX_BYTES))
                remaining -= bytes.size
                if (name == METADATA) metadata = bytes
                else themes[name.removePrefix("themes/")] = bytes
                zip.closeEntry()
            }
        }
        return DataInputStream(ByteArrayInputStream(requireNotNull(metadata))).use { stream ->
            require(stream.readUTF() == MAGIC)
            require(stream.readInt() == VERSION)
            val count = stream.readInt()
            require(count in 0..SettingsTransferSchema.keys.size)
            val preferences = linkedMapOf<String, Any>()
            repeat(count) {
                val key = stream.readUTF()
                require(!preferences.containsKey(key))
                preferences[key] = when (stream.readByte().toInt()) {
                    1 -> stream.readBoolean()
                    2 -> stream.readUTF()
                    3 -> stream.readFloat()
                    else -> error("Unsupported preference type")
                }
            }
            val interval = stream.readInt()
            val retention = stream.readInt()
            val contacts = stream.readBoolean()
            val device = stream.readUTF()
            val file = stream.readUTF()
            val hours = stream.readInt()
            val shortcuts = when (stream.readByte().toInt()) {
                -1 -> null; 0 -> false; 1 -> true; else -> error("Invalid Boolean")
            }
            val data = SettingsTransferData(preferences, interval, retention,
                contacts, device, file, hours, shortcuts, themes)
            require(stream.read() == -1)
            validate(data)
            data
        }
    }

    private fun validate(data: SettingsTransferData) {
        SettingsTransferSchema.validate(data.preferences)
        require(data.backupIntervalDays == 0 || data.backupIntervalDays in DictionarySettingContracts.intervalValues)
        require(data.backupRetention == 0 || data.backupRetention in DictionarySettingContracts.retentionValues)
        require(data.rimeIntervalHours > 0)
        require(data.themes.keys.all(::validThemeName))
    }

    private fun validThemeName(name: String): Boolean =
        name.startsWith(ThemeCatalogRules.USER_THEME_DIRECTORY_PREFIX) &&
            name.none { it == '/' || it == '\\' || it.code < 32 } && name.length <= 255

    private fun readBounded(input: InputStream, limit: Int): ByteArray {
        val bytes = ByteArrayOutputStream()
        val buffer = ByteArray(8192)
        while (true) {
            val count = input.read(buffer)
            if (count < 0) break
            require(bytes.size().toLong() + count <= limit)
            bytes.write(buffer, 0, count)
        }
        return bytes.toByteArray()
    }
}
