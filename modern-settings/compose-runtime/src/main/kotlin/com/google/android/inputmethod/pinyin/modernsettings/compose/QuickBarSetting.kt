package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.content.Context
import android.content.SharedPreferences

/**
 * Shortcuts shown on the project-owned toolbar.
 *
 * The patch side reads the same file and the same encoding, so the two must stay in step;
 * changing the format in one place without the other silently empties the toolbar.
 *
 * The order of [Entry] in the stored value is the order on screen.
 */
object QuickBarSetting {
    const val PREFERENCES = "floating_keyboard_preferences"
    const val SHORTCUTS_KEY = "shortcuts"

    /** One shortcut. [id] is the access point id the patch side matches against. */
    data class Entry(val id: String, val labelRes: Int, val enabled: Boolean)

    /** Every shortcut the toolbar knows about, in its default order, all enabled. */
    val catalog: List<Entry> = listOf(
        Entry("access_point_theme_setting", R.string.modern_settings_quick_bar_theme, true),
        Entry("access_point_one_handed", R.string.modern_settings_quick_bar_one_handed, true),
        Entry("access_point_settings", R.string.modern_settings_quick_bar_settings, true),
        Entry("access_point_textediting", R.string.modern_settings_quick_bar_text_editing, true),
        Entry("access_point_search", R.string.modern_settings_quick_bar_search, true),
        Entry("access_point_sticker", R.string.modern_settings_quick_bar_sticker, true),
    )

    fun preferences(context: Context): SharedPreferences =
        context.getSharedPreferences(PREFERENCES, Context.MODE_PRIVATE)

    /**
     * Reads the stored list, falling back to [catalog] when nothing usable is saved.
     *
     * Unknown ids are dropped and missing ones are appended in their catalog order, so an entry
     * added in a later build shows up without the user having to reset anything.
     */
    fun entries(context: Context): List<Entry> {
        val raw = preferences(context).getString(SHORTCUTS_KEY, null)
        if (raw.isNullOrEmpty()) return catalog
        val stored = raw.split("|").mapNotNull { item ->
            val parts = item.split(":")
            if (parts.size != 2) return@mapNotNull null
            val known = catalog.firstOrNull { it.id == parts[0] } ?: return@mapNotNull null
            known.copy(enabled = parts[1] == "1")
        }
        if (stored.isEmpty()) return catalog
        val missing = catalog.filter { known -> stored.none { it.id == known.id } }
        return stored + missing
    }

    fun setEntries(context: Context, entries: List<Entry>) {
        val encoded = entries.joinToString("|") { "${it.id}:${if (it.enabled) 1 else 0}" }
        preferences(context).edit().putString(SHORTCUTS_KEY, encoded).apply()
    }

    /** Moves one shortcut one place up or down, leaving the rest untouched. */
    fun move(context: Context, id: String, up: Boolean): List<Entry> {
        val entries = entries(context).toMutableList()
        val from = entries.indexOfFirst { it.id == id }
        if (from < 0) return entries
        val to = if (up) from - 1 else from + 1
        if (to !in entries.indices) return entries
        val moved = entries.removeAt(from)
        entries.add(to, moved)
        setEntries(context, entries)
        return entries
    }

    fun setEnabled(context: Context, id: String, enabled: Boolean): List<Entry> {
        val entries = entries(context).map { if (it.id == id) it.copy(enabled = enabled) else it }
        setEntries(context, entries)
        return entries
    }
}
