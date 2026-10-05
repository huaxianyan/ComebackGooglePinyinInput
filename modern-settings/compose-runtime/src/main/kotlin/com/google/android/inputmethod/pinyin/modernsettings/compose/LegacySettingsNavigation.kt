package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.content.Context
import android.content.Intent
import android.net.Uri
import java.io.File

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

    /**
     * The editor that rewrites or removes one custom theme.
     *
     * It is the legacy selector's own editor, reached here directly rather than
     * through that selector: the selector's grid is what this page replaces, and
     * the editor is the part of it that still owns the lifecycle - it writes the
     * new package, deletes the old one, and reports both names back.
     */
    const val themeEditorActivity =
        "com.google.android.apps.inputmethod.libs.theme.preference.ThemeEditorActivity"

    /**
     * The theme the editor is to open, as an absolute path.
     *
     * An absolute path rather than a theme value: the editor builds a `File`
     * from this extra directly, which is why the legacy edit button passes
     * `File.getAbsolutePath()`.
     */
    const val themeEditorTargetExtra = "target_user_image_theme_file_name"

    /**
     * Suppresses the editor's own delete button.
     *
     * The editor is reached from this page only to edit, because deleting is a
     * button on the sheet that opened it. Two delete affordances for one theme
     * would leave the user guessing whether they differ.
     */
    const val themeEditorNoDeleteExtra = "intent_extra_key_no_delete_button"

    /** The name the editor reports for the theme it wrote, or empty when it wrote none. */
    const val themeEditorCreatedExtra = "intent_extra_key_new_theme_file_name"

    /** The name the editor reports for the theme it removed, or empty when it removed none. */
    const val themeEditorDeletedExtra = "intent_extra_key_deleted_theme_file_name"

    /**
     * Opens the editor on one custom theme.
     *
     * [themeValue] is the value the slot and the catalog both use, so the prefix
     * is stripped here rather than at every caller: the legacy resolver maps
     * `files:` onto the app's own files directory, and the editor wants the path
     * that prefix stands for.
     */
    fun themeEditorIntent(context: Context, themeValue: String): Intent {
        val name = themeValue.removePrefix(ThemeSource.User.valuePrefix)
        require(name.isNotEmpty() && !name.contains('/') && !name.contains('\\')) {
            "Not a custom theme value: $themeValue"
        }
        return Intent()
            .setClassName(context, themeEditorActivity)
            .setAction(Intent.ACTION_MAIN)
            .putExtra(themeEditorTargetExtra, File(context.filesDir, name).absolutePath)
            .putExtra(themeEditorNoDeleteExtra, true)
    }

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
