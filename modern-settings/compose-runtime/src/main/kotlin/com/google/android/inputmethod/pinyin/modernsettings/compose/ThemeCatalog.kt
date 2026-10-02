package com.google.android.inputmethod.pinyin.modernsettings.compose

/**
 * Where a theme package lives.
 *
 * The prefixes are the ones the legacy resolver dispatches on, and each one
 * selects a different backing store: packaged assets, the app's own files
 * directory, or the directory named by the `ro.com.google.ime.themes_dir`
 * system property.
 */
enum class ThemeSource(val valuePrefix: String) {
    Builtin("assets:"),
    User("files:"),
    System("system:"),

    /**
     * The palette package the compatibility bridge generates at runtime.
     *
     * It is stored as a `files:` package like a custom theme, so it is never
     * inferred from a value prefix; it is constructed from
     * [DynamicColorSetting.generatedPackageValue] instead.
     */
    Generated("files:"),
}

/**
 * Every slot the compatibility bridge persists.
 *
 * The generated-palette slot has no picker, so it is not part of
 * [ThemeSelectionSlot]; it is still listed here because the inventory reads all
 * four slots back.
 */
enum class ThemeSlotKey(val persistedValue: String) {
    Light("light"),
    Dark("dark"),
    Fixed("fixed"),
    Dynamic("dynamic"),
    ;

    /** Mirrors `baseKey` in the primary-DEX bridge. */
    val baseKey: String get() = PREFIX + persistedValue + "_keyboard"

    /** Mirrors `additionalKey` in the primary-DEX bridge. */
    val additionalKey: String get() = PREFIX + persistedValue + "_additional"

    companion object {
        private const val PREFIX = "compat_theme_"

        fun of(slot: ThemeSelectionSlot): ThemeSlotKey = when (slot) {
            ThemeSelectionSlot.Light -> Light
            ThemeSelectionSlot.Dark -> Dark
            ThemeSelectionSlot.Fixed -> Fixed
        }
    }
}

/**
 * One theme a slot can point at.
 *
 * [value] is persisted verbatim as `additional_keyboard_theme` and is the only
 * identity the legacy runtime understands, so it is never normalized. [name] is
 * a display label with no meaning beyond the screen.
 */
data class ThemeEntry(
    val value: String,
    val name: String,
    val source: ThemeSource,
)

/** What one slot points at, whether or not the stored value resolves. */
data class ThemeSlotValue(
    val slot: ThemeSlotKey,
    val additional: String,
    val entry: ThemeEntry?,
)

/** Everything the read-only theme inventory shows. */
data class ThemeCatalog(
    val builtin: List<ThemeEntry>,
    val user: List<ThemeEntry>,
    val generated: ThemeEntry?,
    val slots: List<ThemeSlotValue>,
)

/**
 * Pure rules behind the read-only theme inventory.
 *
 * The catalog is assembled from the same resources and directory names the
 * legacy selector reads, so nothing here parses theme packages: the packaged
 * metadata blobs list style sheet file names and carry no label, which is why
 * the display names live in a resource array instead.
 */
internal object ThemeCatalogRules {
    /** The directory prefix the legacy `FilenameFilter` accepts for custom themes. */
    const val USER_THEME_DIRECTORY_PREFIX = "user_theme_"

    /**
     * Zips the legacy value/name array into a lookup.
     *
     * An odd length means the resource was edited into something the legacy
     * resolver rejects the same way.
     */
    fun builtinNames(pairs: List<String>): Map<String, String> {
        require(pairs.size % 2 == 0) { "array size should be multiple of 2." }
        return pairs.chunked(2).associate { (value, name) -> value to name }
    }

    /**
     * The built-in list in the order the legacy array declares it.
     *
     * Entries without a name are dropped: the legacy resolver falls back to an
     * empty label there, which would render as a blank row here.
     */
    fun builtinCatalog(
        values: List<String>,
        builtinNames: Map<String, String>,
    ): List<ThemeEntry> = values.mapNotNull { value ->
        val name = builtinNames[value] ?: return@mapNotNull null
        ThemeEntry(value = value, name = name, source = ThemeSource.Builtin)
    }

    /**
     * Custom themes, built from the directory names the legacy filter accepts.
     *
     * The directory name is the only label available without parsing the
     * package; the legacy selector shows a rendered preview instead of a name.
     */
    fun userCatalog(directoryNames: List<String>): List<ThemeEntry> = directoryNames
        .filter { it.startsWith(USER_THEME_DIRECTORY_PREFIX) }
        .sorted()
        .map { name ->
            ThemeEntry(
                value = ThemeSource.User.valuePrefix + name,
                name = name,
                source = ThemeSource.User,
            )
        }

    /** Resolves every slot against the catalog, keeping unresolved values visible. */
    fun resolveSlots(
        additionalBySlot: Map<ThemeSlotKey, String>,
        entries: List<ThemeEntry>,
    ): List<ThemeSlotValue> = ThemeSlotKey.entries.map { slot ->
        val additional = additionalBySlot[slot].orEmpty()
        ThemeSlotValue(
            slot = slot,
            additional = additional,
            entry = entries.firstOrNull { it.value == additional },
        )
    }
}
