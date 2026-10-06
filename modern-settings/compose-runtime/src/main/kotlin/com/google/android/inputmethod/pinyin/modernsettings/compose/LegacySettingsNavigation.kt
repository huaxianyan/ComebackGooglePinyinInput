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
     * A path rather than a route because the hierarchy is a stack: the shortcut
     * drops the user into the theme page, and back walks up through the pages
     * that would normally have led there. The legacy theme selector is what
     * this shortcut used to open, and `apply_patches.py` redirects that
     * Activity here on the API levels this page serves.
     */
    const val themeRoutePath = "Home/Keyboard/KeyboardAppearance/ThemeCatalog"

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
