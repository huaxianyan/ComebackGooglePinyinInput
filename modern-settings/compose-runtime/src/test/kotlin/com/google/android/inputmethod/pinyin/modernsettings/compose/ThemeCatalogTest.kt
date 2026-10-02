package com.google.android.inputmethod.pinyin.modernsettings.compose

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Assert.assertThrows
import org.junit.Assert.assertTrue
import org.junit.Test

class ThemeCatalogTest {
    /**
     * The packaged built-in themes, in declaration order.
     *
     * Pinned here because the inventory is the first consumer that needs the
     * value/name pairing rather than the stored value alone, and because the
     * names exist in no other form: the metadata blobs under `assets/theme/`
     * list style sheet file names and carry no label.
     */
    private val builtinValues = listOf(
        "assets:theme_package_metadata_material_light",
        "assets:theme_package_metadata_material_dark",
        "assets:theme_package_metadata_google_blue_light",
        "assets:theme_package_metadata_google_blue_dark",
        "assets:theme_package_metadata_color_red",
        "assets:theme_package_metadata_color_green",
        "assets:theme_package_metadata_color_teal",
        "assets:theme_package_metadata_color_blue",
        "assets:theme_package_metadata_color_cyan",
        "assets:theme_package_metadata_color_deep_purple",
        "assets:theme_package_metadata_color_pink",
        "assets:theme_package_metadata_color_light_pink",
        "assets:theme_package_metadata_color_brown",
        "assets:theme_package_metadata_color_blue_grey",
        "assets:theme_package_metadata_color_black",
        "assets:theme_package_metadata_holo_blue",
        "assets:theme_package_metadata_holo_white",
    )

    private val builtinNamePairs = listOf(
        builtinValues[0], "Material Light Theme",
        builtinValues[1], "Material Dark Theme",
        builtinValues[2], "Google Light Theme",
        builtinValues[3], "Google Dark Theme",
        builtinValues[4], "Red Theme",
        builtinValues[5], "Green Theme",
        builtinValues[6], "Teal Theme",
        builtinValues[7], "Blue Theme",
        builtinValues[8], "Cyan Theme",
        builtinValues[9], "Deep Purple Theme",
        builtinValues[10], "Pink Theme",
        builtinValues[11], "Light Pink Theme",
        builtinValues[12], "Brown Theme",
        builtinValues[13], "Blue Grey Theme",
        builtinValues[14], "Black Theme",
        builtinValues[15], "Holo Blue Theme",
        builtinValues[16], "Holo White Theme",
    )

    @Test
    fun builtinCatalogKeepsDeclarationOrder() {
        val catalog = ThemeCatalogRules.builtinCatalog(
            builtinValues,
            ThemeCatalogRules.builtinNames(builtinNamePairs),
        )
        assertEquals(builtinValues, catalog.map { it.value })
        assertEquals("Material Light Theme", catalog.first().name)
        assertEquals("Holo White Theme", catalog.last().name)
        assertTrue(catalog.all { it.source == ThemeSource.Builtin })
    }

    /**
     * A value with no name is dropped rather than rendered blank. The legacy
     * resolver falls back to an empty label in the same situation, which is
     * invisible in a grid of previews but not in a list of names.
     */
    @Test
    fun builtinCatalogDropsValuesWithoutAName() {
        val catalog = ThemeCatalogRules.builtinCatalog(
            builtinValues,
            ThemeCatalogRules.builtinNames(listOf(builtinValues.first(), "Material Light Theme")),
        )
        assertEquals(listOf(builtinValues.first()), catalog.map { it.value })
    }

    @Test
    fun builtinNamesRejectsAnOddArray() {
        assertThrows(IllegalArgumentException::class.java) {
            ThemeCatalogRules.builtinNames(listOf("value"))
        }
    }

    @Test
    fun userCatalogFiltersSortsAndBuildsFilesValues() {
        val catalog = ThemeCatalogRules.userCatalog(
            listOf("user_theme_b", "cache", "user_theme_a", "user_theme_10"),
        )
        assertEquals(
            listOf("files:user_theme_10", "files:user_theme_a", "files:user_theme_b"),
            catalog.map { it.value },
        )
        assertEquals(
            listOf("user_theme_10", "user_theme_a", "user_theme_b"),
            catalog.map { it.name },
        )
        assertTrue(catalog.all { it.source == ThemeSource.User })
    }

    /**
     * The generated palette is stored as a `files:` package but is not a custom
     * theme, so it is never picked up by the directory scan; the repository
     * constructs it explicitly from the bridge's own value.
     */
    @Test
    fun generatedPaletteIsNotAScannedUserTheme() {
        assertTrue(
            ThemeCatalogRules.userCatalog(listOf("dynamic_theme.zip")).isEmpty(),
        )
        assertEquals("files:", ThemeSource.Generated.valuePrefix)
    }

    @Test
    fun resolveSlotsNamesEverySlotAndKeepsUnresolvedValues() {
        val generated = ThemeEntry(
            value = DynamicColorSetting.generatedPackageValue,
            name = "Dynamic color",
            source = ThemeSource.Generated,
        )
        val entries = ThemeCatalogRules.builtinCatalog(
            builtinValues,
            ThemeCatalogRules.builtinNames(builtinNamePairs),
        ) + generated
        val slots = ThemeCatalogRules.resolveSlots(
            mapOf(
                ThemeSlotKey.Light to builtinValues[0],
                ThemeSlotKey.Dark to builtinValues[1],
                ThemeSlotKey.Fixed to builtinValues[1],
                ThemeSlotKey.Dynamic to DynamicColorSetting.generatedPackageValue,
            ),
            entries,
        )
        assertEquals(ThemeSlotKey.entries, slots.map { it.slot })
        assertEquals(
            listOf(builtinValues[0], builtinValues[1], builtinValues[1]),
            slots.take(3).map { it.entry?.value },
        )
        assertEquals(generated, slots.last().entry)
    }

    @Test
    fun resolveSlotsLeavesAnUnknownValueUnresolved() {
        val slots = ThemeCatalogRules.resolveSlots(
            mapOf(ThemeSlotKey.Fixed to "assets:theme_package_metadata_removed"),
            ThemeCatalogRules.builtinCatalog(
                builtinValues,
                ThemeCatalogRules.builtinNames(builtinNamePairs),
            ),
        )
        assertEquals("assets:theme_package_metadata_removed", slots[2].additional)
        assertNull(slots[2].entry)
    }

    @Test
    fun resolveSlotsTreatsAMissingSlotAsEmpty() {
        val slots = ThemeCatalogRules.resolveSlots(emptyMap(), emptyList())
        assertTrue(slots.all { it.additional.isEmpty() && it.entry == null })
    }

    /**
     * The slot keys are derived rather than written out, so this is the shape
     * the primary-DEX bridge has to agree with. `scripts/verify_theme_slot_initialization.py`
     * checks the same literals against the bridge source.
     */
    @Test
    fun slotKeysMatchTheBridgeNaming() {
        assertEquals(
            listOf(
                "compat_theme_light_keyboard",
                "compat_theme_dark_keyboard",
                "compat_theme_fixed_keyboard",
                "compat_theme_dynamic_keyboard",
            ),
            ThemeSlotKey.entries.map { it.baseKey },
        )
        assertEquals(
            listOf(
                "compat_theme_light_additional",
                "compat_theme_dark_additional",
                "compat_theme_fixed_additional",
                "compat_theme_dynamic_additional",
            ),
            ThemeSlotKey.entries.map { it.additionalKey },
        )
    }

    /**
     * The generated slot has no picker, so it must not become selectable by
     * accident: `canSelect` and the bridge's own guard both reject it.
     */
    @Test
    fun generatedSlotIsNotASelectionTarget() {
        assertEquals(
            listOf(ThemeSlotKey.Light, ThemeSlotKey.Dark, ThemeSlotKey.Fixed),
            ThemeSelectionSlot.entries.map(ThemeSlotKey::of),
        )
    }
}
