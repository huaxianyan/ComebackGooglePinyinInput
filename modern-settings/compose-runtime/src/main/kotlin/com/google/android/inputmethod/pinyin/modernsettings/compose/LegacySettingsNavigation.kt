package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.content.Context
import android.content.Intent
import android.net.Uri

/** Explicit entry points whose implementations remain in the legacy primary DEX. */
internal object LegacySettingsNavigation {
    const val repositoryUrl =
        "https://github.com/huaxianyan/ComebackGooglePinyinInput"

    const val themeSelectorActivity =
        "com.google.android.apps.inputmethod.libs.theme.preference.ThemeSelectorActivity"

    /**
     * The custom-theme builder, which is also where a theme is created from a
     * picture.
     *
     * It writes the theme into the app's own files directory and hands its name
     * back in the result, so the caller never sees the package itself.
     */
    const val themeBuilderActivity =
        "com.google.android.apps.inputmethod.libs.theme.preference.ThemeBuilderActivity"

    /**
     * The result extra carrying the name of the theme the builder wrote.
     *
     * A bare name, not a theme value: the legacy resolver prefixes `files:` to
     * it, which is what [ThemeSource.User] also does for the same directory.
     */
    const val newThemeFileNameExtra = "intent_extra_key_new_theme_file_name"

    fun themeSelectorIntent(context: Context): Intent =
        Intent().setClassName(context, themeSelectorActivity)

    /**
     * Opens the builder to create a theme.
     *
     * The explicit `MAIN` action is the legacy selector's, and the builder
     * reads it; the component is named explicitly rather than resolved, because
     * nothing in this module compiles against the legacy classes.
     */
    fun themeBuilderIntent(context: Context): Intent =
        Intent()
            .setClassName(context, themeBuilderActivity)
            .setAction(Intent.ACTION_MAIN)

    fun legacyWebIntent(context: Context, resourceName: String): Intent {
        val id = context.resources.getIdentifier(resourceName, "string", context.packageName)
        require(id != 0) { "Missing legacy web URL: $resourceName" }
        return Intent(Intent.ACTION_VIEW, Uri.parse(context.getString(id)))
    }

    fun repositoryIntent(): Intent = Intent(Intent.ACTION_VIEW, Uri.parse(repositoryUrl))

    fun licensesIntent(context: Context): Intent = Intent().setClassName(
        context,
        "com.google.android.libraries.social.licenses.UnquantumLicenseMenuActivity",
    )
}
