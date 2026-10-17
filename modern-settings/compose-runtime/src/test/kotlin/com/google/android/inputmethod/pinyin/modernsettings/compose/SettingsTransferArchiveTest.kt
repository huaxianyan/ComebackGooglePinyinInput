package com.google.android.inputmethod.pinyin.modernsettings.compose

import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.io.DataOutputStream
import java.util.zip.ZipEntry
import java.util.zip.ZipInputStream
import java.util.zip.ZipOutputStream
import org.junit.Assert.*
import org.junit.Test

class SettingsTransferArchiveTest {
    @Test fun exportedSettingsRestoreExplicitValuesAndKeepAbsentDefaults() {
        // Independently encoded v1 fixture: frozen wire types, not the production writer.
        val metadata = ByteArrayOutputStream().also { buffer ->
            DataOutputStream(buffer).use { out ->
                out.writeUTF("ComebackGooglePinyinInput settings")
                out.writeInt(1)
                out.writeInt(3)
                out.writeUTF("enable_sound_on_keypress"); out.writeByte(1); out.writeBoolean(true)
                out.writeUTF("pinyin_scheme"); out.writeByte(2); out.writeUTF("shuangpin_flypy")
                out.writeUTF("sound_volume"); out.writeByte(3); out.writeFloat(0.35f)
                out.writeInt(0); out.writeInt(10); out.writeBoolean(true)
                out.writeUTF("pixel_10"); out.writeUTF("pinyin_simp.userdb.txt"); out.writeInt(24)
                out.writeByte(-1)
            }
        }.toByteArray()
        val fixture = ByteArrayOutputStream().also { buffer ->
            ZipOutputStream(buffer).use { zip ->
                zip.putNextEntry(ZipEntry("settings.bin")); zip.write(metadata); zip.closeEntry()
                zip.putNextEntry(ZipEntry("themes/user_theme_one"))
                zip.write(byteArrayOf(1, 2, 3)); zip.closeEntry()
            }
        }.toByteArray()
        val restored = SettingsTransferArchive.read(ByteArrayInputStream(fixture))
        assertEquals(mapOf("enable_sound_on_keypress" to true,
            "pinyin_scheme" to "shuangpin_flypy", "sound_volume" to 0.35f), restored.preferences)
        assertEquals(0, restored.backupIntervalDays)
        assertEquals(10, restored.backupRetention)
        assertTrue(restored.contactsRequested)
        assertNull(restored.shortcuts)
        assertEquals("pixel_10", restored.rimeDevice)
        assertEquals("pinyin_simp.userdb.txt", restored.rimeFile)
        assertEquals(24, restored.rimeIntervalHours)
        assertArrayEquals(byteArrayOf(1, 2, 3), restored.themes["user_theme_one"])
        val exported = ByteArrayOutputStream()
        SettingsTransferArchive.write(restored, exported)
        ZipInputStream(ByteArrayInputStream(exported.toByteArray())).use { zip ->
            assertEquals("settings.bin", zip.nextEntry.name)
            assertArrayEquals(metadata, zip.readBytes())
        }
    }

    @Test fun choosingAnArchiveWithAThemeOutsideItsFolderReportsInvalidBackup() {
        // Importing user-selected SAF files is a filesystem security boundary.
        val fixture = ByteArrayOutputStream().also { buffer ->
            ZipOutputStream(buffer).use { zip ->
                zip.putNextEntry(ZipEntry("themes/user_theme_../../shared_prefs/settings.xml"))
                zip.write(byteArrayOf(1)); zip.closeEntry()
            }
        }.toByteArray()
        assertThrows(IllegalArgumentException::class.java) {
            SettingsTransferArchive.read(ByteArrayInputStream(fixture))
        }
    }
}
