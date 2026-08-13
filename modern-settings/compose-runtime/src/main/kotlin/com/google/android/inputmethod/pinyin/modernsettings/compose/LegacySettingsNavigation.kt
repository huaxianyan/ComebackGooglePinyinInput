package com.google.android.inputmethod.pinyin.modernsettings.compose

import android.content.Context
import android.content.Intent
import android.net.Uri

/** Explicit entry points whose implementations remain in the legacy primary DEX. */
internal object LegacySettingsNavigation {
    const val repositoryUrl =
        "https://github.com/huaxianyan/comeback-google-pinyin-input"

    const val themeSelectorActivity =
        "com.google.android.apps.inputmethod.libs.theme.preference.ThemeSelectorActivity"

    fun themeSelectorIntent(context: Context): Intent =
        Intent().setClassName(context, themeSelectorActivity)

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
