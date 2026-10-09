package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.content.Context
import android.content.Intent
import android.net.Uri

/** Explicit entry points whose implementations remain in the legacy primary DEX. */
internal object LegacySettingsNavigation {
    const val repositoryUrl =
        "https://github.com/huaxianyan/ComebackGooglePinyinInput"

    /**
     * The page the keyboard's own theme shortcut opens, as a route path.
     *
     * The shortcut's actual entry page is its stack root. Back closes the host
     * instead of visiting settings pages the user never opened.
     * `apply_patches.py` redirects the legacy selector here on supported versions.
     */
    const val themeRoutePath = "ThemeCatalog"

    /**
     * The extra carrying [themeRoutePath].
     *
     * Read by [ModernSettingsActivity] on the way in, and written by the
     * primary DEX redirect, which cannot see this constant. The two literals
     * are therefore checked against each other rather than shared.
     */
    const val routePathExtra = "modern_settings_route_path"

    fun legacyWebIntent(context: Context, resourceName: String): Intent {
        val id = context.resources.getIdentifier(resourceName, "string", context.packageName)
        require(id != 0) { "Missing legacy web URL: $resourceName" }
        return Intent(Intent.ACTION_VIEW, Uri.parse(context.getString(id)))
    }

    fun repositoryIntent(): Intent = Intent(Intent.ACTION_VIEW, Uri.parse(repositoryUrl))
}
