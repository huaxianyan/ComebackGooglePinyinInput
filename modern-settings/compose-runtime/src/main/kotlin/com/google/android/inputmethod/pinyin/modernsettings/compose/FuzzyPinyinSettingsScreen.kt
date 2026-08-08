package com.google.android.inputmethod.pinyin.modernsettings.compose

import androidx.activity.compose.BackHandler
import androidx.annotation.StringRes
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.WindowInsetsSides
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.only
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeGestures
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.automirrored.filled.KeyboardArrowRight
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ListItem
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Slider
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import kotlin.math.roundToInt

private data class FuzzyPinyinOptionUi(
    val contract: BooleanSettingContract,
    val legacyTitle: String,
    @param:StringRes val fallbackTitle: Int,
    val legacyDescription: String,
    @param:StringRes val fallbackDescription: Int,
)

private val fuzzyPinyinOptions = listOf(
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinZZh, "setting_fuzzy_pinyin_option_z_zh", R.string.modern_settings_fuzzy_z_zh, "setting_desc_fuzzy_pinyin_option_z_zh", R.string.modern_settings_fuzzy_z_zh_description),
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinCCh, "setting_fuzzy_pinyin_option_c_ch", R.string.modern_settings_fuzzy_c_ch, "setting_desc_fuzzy_pinyin_option_c_ch", R.string.modern_settings_fuzzy_c_ch_description),
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinSSh, "setting_fuzzy_pinyin_option_s_sh", R.string.modern_settings_fuzzy_s_sh, "setting_desc_fuzzy_pinyin_option_s_sh", R.string.modern_settings_fuzzy_s_sh_description),
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinAnAng, "setting_fuzzy_pinyin_option_an_ang", R.string.modern_settings_fuzzy_an_ang, "setting_desc_fuzzy_pinyin_option_an_ang", R.string.modern_settings_fuzzy_an_ang_description),
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinEnEng, "setting_fuzzy_pinyin_option_en_eng", R.string.modern_settings_fuzzy_en_eng, "setting_desc_fuzzy_pinyin_option_en_eng", R.string.modern_settings_fuzzy_en_eng_description),
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinInIng, "setting_fuzzy_pinyin_option_in_ing", R.string.modern_settings_fuzzy_in_ing, "setting_desc_fuzzy_pinyin_option_in_ing", R.string.modern_settings_fuzzy_in_ing_description),
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinLN, "setting_fuzzy_pinyin_option_l_n", R.string.modern_settings_fuzzy_l_n, "setting_desc_fuzzy_pinyin_option_l_n", R.string.modern_settings_fuzzy_l_n_description),
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinFH, "setting_fuzzy_pinyin_option_f_h", R.string.modern_settings_fuzzy_f_h, "setting_desc_fuzzy_pinyin_option_f_h", R.string.modern_settings_fuzzy_f_h_description),
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinRL, "setting_fuzzy_pinyin_option_r_l", R.string.modern_settings_fuzzy_r_l, "setting_desc_fuzzy_pinyin_option_r_l", R.string.modern_settings_fuzzy_r_l_description),
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinKG, "setting_fuzzy_pinyin_option_k_g", R.string.modern_settings_fuzzy_k_g, "setting_desc_fuzzy_pinyin_option_k_g", R.string.modern_settings_fuzzy_k_g_description),
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinIanIang, "setting_fuzzy_pinyin_option_ian_iang", R.string.modern_settings_fuzzy_ian_iang, "setting_desc_fuzzy_pinyin_option_ian_iang", R.string.modern_settings_fuzzy_ian_iang_description),
    FuzzyPinyinOptionUi(BooleanSettingContracts.fuzzyPinyinUanUang, "setting_fuzzy_pinyin_option_uan_uang", R.string.modern_settings_fuzzy_uan_uang, "setting_desc_fuzzy_pinyin_option_uan_uang", R.string.modern_settings_fuzzy_uan_uang_description),
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
internal fun FuzzyPinyinDetailScreen(
    snapshot: SettingsSnapshot,
    actions: SettingsActions,
    onNavigateBack: () -> Unit,
) {
    require(snapshot.fuzzyPinyinOptions.size == fuzzyPinyinOptions.size)
    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        legacyString(
                            "setting_fuzzy_pinyin_detail_title",
                            R.string.modern_settings_fuzzy_pinyin_detail_title,
                        )
                    )
                },
                navigationIcon = {
                    IconButton(onClick = onNavigateBack) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = stringResource(
                                R.string.modern_settings_navigate_back,
                            ),
                        )
                    }
                },
            )
        },
        modifier = Modifier.fillMaxSize(),
    ) { innerPadding ->
        LazyColumn(modifier = Modifier.padding(innerPadding)) {
            fuzzyPinyinOptions.forEachIndexed { index, option ->
                item(option.contract.key) {
                    SettingsSwitchRow(
                        title = legacyString(option.legacyTitle, option.fallbackTitle),
                        checked = snapshot.fuzzyPinyinOptions[index].value,
                        enabled = snapshot.fuzzyPinyin.value,
                        accessibilityDescription = legacyString(
                            option.legacyDescription,
                            option.fallbackDescription,
                        ),
                        onCheckedChange = {
                            actions.onBooleanChange(option.contract, it)
                        },
                    )
                }
            }
        }
    }
}

