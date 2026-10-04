.class public final Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;
.super Ljava/lang/Object;
.source "SystemAutoThemeCompat.java"


# static fields
.field private static final ASSET_DIRECTORY:Ljava/lang/String; = "theme/"

.field public static final AUTO_THEME_KEY:Ljava/lang/String; = "compat_system_auto_keyboard_theme"

.field private static final BASE_MATERIAL_THEME:I = 0x7f110226

.field private static final BORDER_SHEET_NAMES:[Ljava/lang/String;

.field private static final BORDER_SHEET_SOURCES:[Ljava/lang/String;

.field private static final DARK_ADDITIONAL_KEY:Ljava/lang/String; = "compat_theme_dark_additional"

.field private static final DARK_BASE_KEY:Ljava/lang/String; = "compat_theme_dark_keyboard"

.field private static final DIAGNOSTIC_TAG:Ljava/lang/String; = "SystemAutoTheme"

.field private static final DYNAMIC_ADDITIONAL_KEY:Ljava/lang/String; = "compat_theme_dynamic_additional"

.field private static final DYNAMIC_ADDITIONAL_PREFIX:Ljava/lang/String; = "files:"

.field private static final DYNAMIC_BASE_KEY:Ljava/lang/String; = "compat_theme_dynamic_keyboard"

.field private static final DYNAMIC_ENTRIES_DARK:[Ljava/lang/String;

.field private static final DYNAMIC_ENTRIES_LIGHT:[Ljava/lang/String;

.field private static final DYNAMIC_MIN_SDK:I = 0x1f

.field private static final DYNAMIC_PACKAGE_NAME:Ljava/lang/String; = "dynamic_theme.zip"

.field private static final DYNAMIC_PACKAGE_TEMP_NAME:Ljava/lang/String; = "dynamic_theme.tmp"

.field private static final DYNAMIC_PALETTE_REVISION:I = 0x3

.field private static final DYNAMIC_SIGNATURE_KEY:Ljava/lang/String; = "compat_theme_dynamic_signature"

.field private static final DYNAMIC_SLOT_NAMES:[Ljava/lang/String;

.field private static final DYNAMIC_SLOT_RESOURCES:[Ljava/lang/String;

.field public static final DYNAMIC_THEME_KEY:Ljava/lang/String; = "compat_system_dynamic_color_theme"

.field private static final FIXED_ADDITIONAL_KEY:Ljava/lang/String; = "compat_theme_fixed_additional"

.field private static final FIXED_BASE_KEY:Ljava/lang/String; = "compat_theme_fixed_keyboard"

.field private static final LIGHT_ADDITIONAL_KEY:Ljava/lang/String; = "compat_theme_light_additional"

.field private static final LIGHT_BASE_KEY:Ljava/lang/String; = "compat_theme_light_keyboard"

.field private static final MATERIAL_DARK_THEME:I = 0x7f110224

.field private static final MATERIAL_LIGHT_THEME:I = 0x7f110225

.field private static final MATERIAL_TEMPLATE_PREFIX:Ljava/lang/String; = "style_sheet_material_"

.field private static final METADATA_ENTRY:Ljava/lang/String; = "metadata.binarypb"

.field private static final METADATA_TEMPLATE_PREFIX:Ljava/lang/String; = "theme_package_metadata_material_"

.field private static final METADATA_VERSION_TAG:I = 0x8

.field private static final MODE_DARK:Ljava/lang/String; = "dark"

.field private static final MODE_LIGHT:Ljava/lang/String; = "light"

.field private static final PREF_KEY_ADDITIONAL_THEME:I = 0x7f11023a

.field private static final PREF_KEY_KEYBOARD_THEME:I = 0x7f110282

.field private static final SELECTION_SLOT_KEY:Ljava/lang/String; = "compat_theme_selection_slot"

.field public static final SLOT_DARK:Ljava/lang/String; = "dark"

.field public static final SLOT_DYNAMIC:Ljava/lang/String; = "dynamic"

.field public static final SLOT_FIXED:Ljava/lang/String; = "fixed"

.field public static final SLOT_LIGHT:Ljava/lang/String; = "light"

.field private static final SNAPSHOT_CACHE_PREFIX:Ljava/lang/String; = "keyboardsnapshotcache_"

.field private static final SNAPSHOT_CACHE_SUFFIX:Ljava/lang/String; = ".png"

.field private static final SYNC_REBUILT:I = 0x2

.field private static final SYNC_UNAVAILABLE:I = 0x0

.field private static final SYNC_UNCHANGED:I = 0x1

.field private static final THEME_PACKAGE_FORMAT_VERSION:I = 0x3

.field private static final UTF_8:Ljava/nio/charset/Charset;


# direct methods
.method static constructor <clinit>()V
    .locals 20

    .line 151
    const/16 v0, 0x8

    new-array v1, v0, [Ljava/lang/String;

    const/4 v2, 0x0

    const-string v3, "style_sheet_color_common.binarypb"

    aput-object v3, v1, v2

    const/4 v4, 0x1

    const-string v5, "style_sheet_material_light.binarypb"

    aput-object v5, v1, v4

    const/4 v5, 0x2

    const-string v6, "style_sheet_color_gif_light.binarypb"

    aput-object v6, v1, v5

    const/4 v6, 0x3

    const-string v7, "style_sheet_color_rules.binarypb"

    aput-object v7, v1, v6

    const/4 v8, 0x4

    const-string v9, "style_sheet_material_rules.binarypb"

    aput-object v9, v1, v8

    const/4 v10, 0x5

    const-string v11, "style_sheet_material_light_border.binarypb"

    aput-object v11, v1, v10

    const/4 v11, 0x6

    const-string v12, "style_sheet_color_rules_border.binarypb"

    aput-object v12, v1, v11

    const/4 v13, 0x7

    const-string v14, "style_sheet_material_rules_border.binarypb"

    aput-object v14, v1, v13

    sput-object v1, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_ENTRIES_LIGHT:[Ljava/lang/String;

    .line 161
    new-array v1, v0, [Ljava/lang/String;

    aput-object v3, v1, v2

    const-string v3, "style_sheet_material_dark.binarypb"

    aput-object v3, v1, v4

    const-string v3, "style_sheet_color_gif_dark.binarypb"

    aput-object v3, v1, v5

    aput-object v7, v1, v6

    aput-object v9, v1, v8

    const-string v3, "style_sheet_material_dark_border.binarypb"

    aput-object v3, v1, v10

    aput-object v12, v1, v11

    aput-object v14, v1, v13

    sput-object v1, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_ENTRIES_DARK:[Ljava/lang/String;

    .line 177
    const/16 v1, 0x14

    new-array v3, v1, [Ljava/lang/String;

    const-string v7, "color_base"

    aput-object v7, v3, v2

    const-string v7, "color_header"

    aput-object v7, v3, v4

    const-string v9, "color_popup_background"

    aput-object v9, v3, v5

    const-string v12, "color_access_points_menu_background"

    aput-object v12, v3, v6

    const-string v12, "color_access_point_panel_item_background"

    aput-object v12, v3, v8

    const-string v12, "color_label"

    aput-object v12, v3, v10

    const-string v12, "color_label_header_active"

    aput-object v12, v3, v11

    const-string v12, "color_popup_label"

    aput-object v12, v3, v13

    const-string v12, "color_icon"

    aput-object v12, v3, v0

    const/16 v14, 0x9

    const-string v15, "color_state_action"

    aput-object v15, v3, v14

    const/16 v15, 0xa

    const-string v16, "color_state_action_pressed"

    aput-object v16, v3, v15

    const/16 v17, 0xb

    const-string v18, "color_action_default"

    aput-object v18, v3, v17

    const-string v17, "color_label_dynamic"

    const/16 v19, 0xc

    aput-object v17, v3, v19

    const-string v17, "color_keyboard_editing_button"

    const/16 v19, 0xd

    aput-object v17, v3, v19

    const-string v17, "color_keyboard_editing_button_background"

    const/16 v19, 0xe

    aput-object v17, v3, v19

    const-string v17, "color_key_paging_scrollbar"

    const/16 v19, 0xf

    aput-object v17, v3, v19

    const-string v17, "color_notice_text"

    const/16 v19, 0x10

    aput-object v17, v3, v19

    const-string v17, "color_state_popup_item_pressed"

    const/16 v19, 0x11

    aput-object v17, v3, v19

    const-string v17, "color_generic_extension_background_activated"

    const/16 v19, 0x12

    aput-object v17, v3, v19

    const-string v17, "color_keyboard_separator"

    const/16 v19, 0x13

    aput-object v17, v3, v19

    sput-object v3, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_SLOT_NAMES:[Ljava/lang/String;

    .line 199
    new-array v1, v1, [Ljava/lang/String;

    const-string v3, "system_surface"

    aput-object v3, v1, v2

    const-string v17, "system_surface_container"

    aput-object v17, v1, v4

    const-string v17, "system_surface_container_high"

    aput-object v17, v1, v5

    aput-object v3, v1, v6

    aput-object v3, v1, v8

    const-string v3, "system_on_surface"

    aput-object v3, v1, v10

    aput-object v3, v1, v11

    aput-object v3, v1, v13

    const-string v3, "system_on_surface_variant"

    aput-object v3, v1, v0

    const-string v0, "system_primary"

    aput-object v0, v1, v14

    const-string v3, "system_primary_container"

    aput-object v3, v1, v15

    const/16 v14, 0xb

    aput-object v0, v1, v14

    const/16 v14, 0xc

    aput-object v0, v1, v14

    const/16 v14, 0xd

    aput-object v0, v1, v14

    const/16 v14, 0xe

    aput-object v3, v1, v14

    const/16 v14, 0xf

    aput-object v0, v1, v14

    const/16 v14, 0x10

    aput-object v0, v1, v14

    const/16 v0, 0x11

    aput-object v3, v1, v0

    const-string v0, "system_secondary_container"

    const/16 v3, 0x12

    aput-object v0, v1, v3

    const-string v0, "system_outline_variant"

    const/16 v3, 0x13

    aput-object v0, v1, v3

    sput-object v1, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_SLOT_RESOURCES:[Ljava/lang/String;

    .line 254
    new-array v0, v13, [Ljava/lang/String;

    const-string v1, "color_state_key"

    aput-object v1, v0, v2

    const-string v1, "color_state_key_dark"

    aput-object v1, v0, v4

    const-string v1, "color_state_key_pressed"

    aput-object v1, v0, v5

    const-string v1, "color_state_key_dark_pressed"

    aput-object v1, v0, v6

    const-string v1, "color_label_space_key"

    aput-object v1, v0, v8

    const-string v1, "color_state_border_key_action"

    aput-object v1, v0, v10

    const-string v1, "color_state_border_key_action_pressed"

    aput-object v1, v0, v11

    sput-object v0, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->BORDER_SHEET_NAMES:[Ljava/lang/String;

    .line 263
    new-array v0, v13, [Ljava/lang/String;

    aput-object v7, v0, v2

    aput-object v9, v0, v4

    const-string v1, "color_generic_extension_background_activated"

    aput-object v1, v0, v5

    aput-object v1, v0, v6

    aput-object v12, v0, v8

    aput-object v18, v0, v10

    aput-object v16, v0, v11

    sput-object v0, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->BORDER_SHEET_SOURCES:[Ljava/lang/String;

    .line 273
    const-string v0, "UTF-8"

    invoke-static {v0}, Ljava/nio/charset/Charset;->forName(Ljava/lang/String;)Ljava/nio/charset/Charset;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->UTF_8:Ljava/nio/charset/Charset;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 275
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static additionalKey(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 1117
    const-string v0, "light"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string p0, "compat_theme_light_additional"

    return-object p0

    .line 1118
    :cond_0
    const-string v0, "dark"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    const-string p0, "compat_theme_dark_additional"

    return-object p0

    .line 1119
    :cond_1
    const-string v0, "fixed"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    const-string p0, "compat_theme_fixed_additional"

    return-object p0

    .line 1120
    :cond_2
    const-string v0, "dynamic"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_3

    const-string p0, "compat_theme_dynamic_additional"

    return-object p0

    .line 1121
    :cond_3
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "Unknown theme slot"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z
    .locals 3

    .line 499
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->hasSelectionSession(Landroid/content/Context;)Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 500
    return v1

    .line 502
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDynamicEnabled(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_5

    .line 503
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDark(Landroid/content/res/Configuration;)Z

    move-result v0

    .line 504
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->syncDynamicTheme(Landroid/content/Context;Z)I

    move-result v2

    .line 505
    if-eqz v2, :cond_4

    .line 506
    nop

    .line 509
    if-eqz v0, :cond_1

    const-string p1, "resolved target=dynamic-dark"

    goto :goto_0

    :cond_1
    const-string p1, "resolved target=dynamic-light"

    .line 506
    :goto_0
    const-string v0, "dynamic"

    invoke-static {p0, v0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeSlot(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    .line 513
    const/4 p1, 0x2

    if-eq v2, p1, :cond_2

    if-eqz p0, :cond_3

    :cond_2
    const/4 v1, 0x1

    :cond_3
    return v1

    .line 520
    :cond_4
    const-string v0, "dynamic package unavailable, resolving the legacy pair"

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 522
    :cond_5
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isEnabled(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_8

    .line 523
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDark(Landroid/content/res/Configuration;)Z

    move-result p1

    .line 524
    nop

    .line 526
    if-eqz p1, :cond_6

    const-string v0, "dark"

    goto :goto_1

    :cond_6
    const-string v0, "light"

    .line 527
    :goto_1
    if-eqz p1, :cond_7

    const-string p1, "resolved target=dark"

    goto :goto_2

    :cond_7
    const-string p1, "resolved target=light"

    .line 524
    :goto_2
    invoke-static {p0, v0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeSlot(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0

    .line 529
    :cond_8
    const-string p1, "fixed"

    const-string v0, "resolved target=fixed"

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeSlot(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public static applyIfEnabled(Landroid/content/Context;Landroid/content/res/Configuration;)Z
    .locals 2

    .line 455
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "configuration uiMode="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget v1, p1, Landroid/content/res/Configuration;->uiMode:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 456
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 457
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->hasSelectionSession(Landroid/content/Context;)Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 458
    return v1

    .line 464
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDynamicEnabled(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 465
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z

    move-result p0

    return p0

    .line 467
    :cond_1
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isEnabled(Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :cond_2

    .line 468
    return v1

    .line 470
    :cond_2
    nop

    .line 472
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDark(Landroid/content/res/Configuration;)Z

    move-result v0

    if-eqz v0, :cond_3

    const-string v0, "dark"

    goto :goto_0

    :cond_3
    const-string v0, "light"

    .line 473
    :goto_0
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDark(Landroid/content/res/Configuration;)Z

    move-result p1

    if-eqz p1, :cond_4

    const-string p1, "resolved target=dark"

    goto :goto_1

    :cond_4
    const-string p1, "resolved target=light"

    .line 470
    :goto_1
    invoke-static {p0, v0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeSlot(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public static applyOnCreate(Landroid/content/Context;)Z
    .locals 2

    .line 449
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 450
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "compat_theme_selection_slot"

    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 451
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z

    move-result p0

    return p0
.end method

.method public static applyOnKeyboardShown(Landroid/content/Context;)Z
    .locals 1

    .line 486
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDynamicEnabled(Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 487
    const/4 p0, 0x0

    return p0

    .line 489
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 490
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z

    move-result p0

    return p0
.end method

.method private static baseKey(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 1109
    const-string v0, "light"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string p0, "compat_theme_light_keyboard"

    return-object p0

    .line 1110
    :cond_0
    const-string v0, "dark"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    const-string p0, "compat_theme_dark_keyboard"

    return-object p0

    .line 1111
    :cond_1
    const-string v0, "fixed"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    const-string p0, "compat_theme_fixed_keyboard"

    return-object p0

    .line 1112
    :cond_2
    const-string v0, "dynamic"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_3

    const-string p0, "compat_theme_dynamic_keyboard"

    return-object p0

    .line 1113
    :cond_3
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "Unknown theme slot"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public static beginSelection(Landroid/content/Context;Ljava/lang/String;)V
    .locals 4

    .line 353
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 354
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isEnabled(Landroid/content/Context;)Z

    move-result v0

    .line 355
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isSelectableSlot(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 356
    const-string v1, "fixed"

    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    if-nez v0, :cond_1

    goto :goto_0

    :cond_0
    if-eqz v0, :cond_1

    .line 359
    :goto_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 360
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->baseKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v2, ""

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 361
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->additionalKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v0, v3, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 362
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 363
    const-string v3, "compat_theme_selection_slot"

    invoke-interface {v0, v3, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 364
    const v0, 0x7f110282

    invoke-virtual {p0, v0}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v0

    invoke-interface {p1, v0, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 365
    const v0, 0x7f11023a

    invoke-virtual {p0, v0}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p0

    invoke-interface {p1, p0, v2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 366
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 367
    return-void

    .line 357
    :cond_1
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "Theme slot is disabled"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static borderSheetColors(Ljava/util/Map;)Ljava/util/Map;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Integer;",
            ">;)",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    .line 627
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    .line 628
    const/4 v1, 0x0

    :goto_0
    sget-object v2, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->BORDER_SHEET_NAMES:[Ljava/lang/String;

    array-length v2, v2

    if-ge v1, v2, :cond_1

    .line 629
    sget-object v2, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->BORDER_SHEET_SOURCES:[Ljava/lang/String;

    aget-object v2, v2, v1

    invoke-interface {p0, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Integer;

    .line 630
    if-eqz v2, :cond_0

    .line 631
    sget-object v3, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->BORDER_SHEET_NAMES:[Ljava/lang/String;

    aget-object v3, v3, v1

    invoke-interface {v0, v3, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 628
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 634
    :cond_1
    return-object v0
.end method

.method private static buildDynamicThemePackage(Landroid/content/Context;ZLjava/util/Map;)Z
    .locals 11
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Z",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Integer;",
            ">;)Z"
        }
    .end annotation

    .line 679
    if-eqz p1, :cond_0

    const-string v0, "dark"

    goto :goto_0

    :cond_0
    const-string v0, "light"

    .line 680
    :goto_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "style_sheet_material_"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v3, ".binarypb"

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 681
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v4, "_border.binarypb"

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 682
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->borderSheetColors(Ljava/util/Map;)Ljava/util/Map;

    move-result-object v4

    .line 683
    if-eqz p1, :cond_1

    sget-object p1, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_ENTRIES_DARK:[Ljava/lang/String;

    goto :goto_1

    :cond_1
    sget-object p1, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_ENTRIES_LIGHT:[Ljava/lang/String;

    .line 684
    :goto_1
    array-length v5, p1

    new-array v5, v5, [[B

    .line 685
    const/4 v6, 0x0

    const/4 v7, 0x0

    :goto_2
    array-length v8, p1

    if-ge v7, v8, :cond_6

    .line 686
    aget-object v8, p1, v7

    .line 687
    invoke-static {p0, v8}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->templateBytes(Landroid/content/Context;Ljava/lang/String;)[B

    move-result-object v9

    .line 688
    if-nez v9, :cond_2

    .line 689
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "dynamic template missing: "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 690
    return v6

    .line 692
    :cond_2
    invoke-virtual {v1, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v10

    if-eqz v10, :cond_3

    .line 693
    invoke-static {v9, p2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->rewriteStyleSheetColors([BLjava/util/Map;)[B

    move-result-object v9

    goto :goto_3

    .line 694
    :cond_3
    invoke-virtual {v2, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v10

    if-eqz v10, :cond_4

    .line 695
    invoke-static {v9, v4}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->rewriteStyleSheetColors([BLjava/util/Map;)[B

    move-result-object v9

    .line 697
    :cond_4
    :goto_3
    if-nez v9, :cond_5

    .line 698
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "dynamic style sheet rewrite failed: "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 699
    return v6

    .line 701
    :cond_5
    aput-object v9, v5, v7

    .line 685
    add-int/lit8 v7, v7, 0x1

    goto :goto_2

    .line 703
    :cond_6
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "theme_package_metadata_material_"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->templateBytes(Landroid/content/Context;Ljava/lang/String;)[B

    move-result-object p2

    .line 704
    if-nez p2, :cond_7

    .line 705
    const-string p1, "dynamic template missing: metadata"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 706
    return v6

    .line 708
    :cond_7
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->withFormatVersion([B)[B

    move-result-object p2

    .line 710
    new-instance v0, Ljava/io/File;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v1

    const-string v2, "dynamic_theme.zip"

    invoke-direct {v0, v1, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 711
    new-instance v1, Ljava/io/File;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v2

    const-string v3, "dynamic_theme.tmp"

    invoke-direct {v1, v2, v3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 712
    nop

    .line 714
    const/4 v2, 0x0

    :try_start_0
    new-instance v3, Ljava/util/zip/ZipOutputStream;

    new-instance v4, Ljava/io/FileOutputStream;

    invoke-direct {v4, v1}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    invoke-direct {v3, v4}, Ljava/util/zip/ZipOutputStream;-><init>(Ljava/io/OutputStream;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1

    .line 715
    :try_start_1
    const-string v2, "metadata.binarypb"

    invoke-static {v3, v2, p2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putStoredEntry(Ljava/util/zip/ZipOutputStream;Ljava/lang/String;[B)V

    .line 716
    const/4 p2, 0x0

    :goto_4
    array-length v2, p1

    if-ge p2, v2, :cond_8

    .line 717
    aget-object v2, p1, p2

    aget-object v4, v5, p2

    invoke-static {v3, v2, v4}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putStoredEntry(Ljava/util/zip/ZipOutputStream;Ljava/lang/String;[B)V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0

    .line 716
    add-int/lit8 p2, p2, 0x1

    goto :goto_4

    .line 724
    :cond_8
    nop

    .line 725
    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->closeQuietly(Ljava/io/Closeable;)V

    .line 727
    invoke-virtual {v1, v0}, Ljava/io/File;->renameTo(Ljava/io/File;)Z

    move-result p1

    if-nez p1, :cond_a

    .line 730
    invoke-virtual {v0}, Ljava/io/File;->delete()Z

    move-result p1

    if-eqz p1, :cond_9

    invoke-virtual {v1, v0}, Ljava/io/File;->renameTo(Ljava/io/File;)Z

    move-result p1

    if-nez p1, :cond_a

    .line 731
    :cond_9
    invoke-virtual {v1}, Ljava/io/File;->delete()Z

    .line 732
    const-string p1, "dynamic theme package replace failed"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 733
    return v6

    .line 736
    :cond_a
    const/4 p0, 0x1

    return p0

    .line 719
    :catch_0
    move-exception p1

    move-object v2, v3

    goto :goto_5

    :catch_1
    move-exception p1

    .line 720
    :goto_5
    const-string p1, "dynamic theme package write failed"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 721
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->closeQuietly(Ljava/io/Closeable;)V

    .line 722
    invoke-virtual {v1}, Ljava/io/File;->delete()Z

    .line 723
    return v6
.end method

.method public static captureFixedTheme(Landroid/content/Context;)V
    .locals 3

    .line 401
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 402
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->hasSelectionSession(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 403
    return-void

    .line 405
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->resolveCurrentTheme(Landroid/content/Context;)[Ljava/lang/String;

    move-result-object v0

    .line 406
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const/4 v1, 0x0

    aget-object v1, v0, v1

    .line 407
    const-string v2, "compat_theme_fixed_keyboard"

    invoke-interface {p0, v2, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const/4 v1, 0x1

    aget-object v0, v0, v1

    .line 408
    const-string v1, "compat_theme_fixed_additional"

    invoke-interface {p0, v1, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 409
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 410
    return-void
.end method

.method private static closeQuietly(Ljava/io/Closeable;)V
    .locals 0

    .line 1004
    if-nez p0, :cond_0

    .line 1005
    return-void

    .line 1008
    :cond_0
    :try_start_0
    invoke-interface {p0}, Ljava/io/Closeable;->close()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 1011
    goto :goto_0

    .line 1009
    :catch_0
    move-exception p0

    .line 1012
    :goto_0
    return-void
.end method

.method private static debugLog(Landroid/content/Context;Ljava/lang/String;)V
    .locals 0

    .line 1130
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object p0

    iget p0, p0, Landroid/content/pm/ApplicationInfo;->flags:I

    and-int/lit8 p0, p0, 0x2

    if-eqz p0, :cond_0

    .line 1131
    const-string p0, "SystemAutoTheme"

    invoke-static {p0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 1133
    :cond_0
    return-void
.end method

.method public static disable(Landroid/content/Context;)V
    .locals 1

    .line 389
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 390
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->hasSelectionSession(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 391
    return-void

    .line 393
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 394
    const-string v0, "compat_system_auto_keyboard_theme"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 395
    const-string v0, "compat_system_dynamic_color_theme"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 396
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 397
    return-void
.end method

.method private static dynamicSignature(ZLjava/util/Map;)Ljava/lang/String;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(Z",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Integer;",
            ">;)",
            "Ljava/lang/String;"
        }
    .end annotation

    .line 638
    new-instance v0, Ljava/lang/StringBuilder;

    if-eqz p0, :cond_0

    const-string p0, "dark"

    goto :goto_0

    :cond_0
    const-string p0, "light"

    :goto_0
    invoke-direct {v0, p0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 642
    const-string p0, "@v"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const/4 v1, 0x3

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 643
    const-string p0, "@r"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 644
    const/4 p0, 0x0

    :goto_1
    sget-object v1, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_SLOT_NAMES:[Ljava/lang/String;

    array-length v1, v1

    if-ge p0, v1, :cond_2

    .line 645
    sget-object v1, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_SLOT_NAMES:[Ljava/lang/String;

    aget-object v1, v1, p0

    invoke-interface {p1, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    .line 646
    const/16 v2, 0x3a

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 647
    if-eqz v1, :cond_1

    .line 648
    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    invoke-static {v1}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 644
    :cond_1
    add-int/lit8 p0, p0, 0x1

    goto :goto_1

    .line 651
    :cond_2
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static declared-synchronized ensureInitialized(Landroid/content/Context;)V
    .locals 6

    const-class v0, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;

    monitor-enter v0

    .line 1029
    :try_start_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v1

    .line 1030
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->hasEverySlotKey(Landroid/content/SharedPreferences;)Z

    move-result v2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v2, :cond_0

    .line 1031
    monitor-exit v0

    return-void

    .line 1033
    :cond_0
    :try_start_1
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    .line 1034
    const-string v3, "compat_theme_fixed_keyboard"

    invoke-interface {v1, v3}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_1

    const-string v3, "compat_theme_fixed_additional"

    invoke-interface {v1, v3}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_2

    .line 1038
    :cond_1
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->resolveCurrentTheme(Landroid/content/Context;)[Ljava/lang/String;

    move-result-object v3

    .line 1039
    const-string v4, "compat_theme_fixed_keyboard"

    const/4 v5, 0x0

    aget-object v5, v3, v5

    invoke-static {v2, v1, v4, v5}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1040
    const-string v4, "compat_theme_fixed_additional"

    const/4 v5, 0x1

    aget-object v3, v3, v5

    invoke-static {v2, v1, v4, v3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1042
    :cond_2
    const v3, 0x7f110226

    invoke-virtual {p0, v3}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v3

    .line 1043
    const-string v4, "compat_theme_light_keyboard"

    invoke-static {v2, v1, v4, v3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1044
    const-string v4, "compat_theme_light_additional"

    const v5, 0x7f110225

    invoke-virtual {p0, v5}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v5

    invoke-static {v2, v1, v4, v5}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1045
    const-string v4, "compat_theme_dark_keyboard"

    invoke-static {v2, v1, v4, v3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1046
    const-string v4, "compat_theme_dark_additional"

    const v5, 0x7f110224

    invoke-virtual {p0, v5}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p0

    invoke-static {v2, v1, v4, p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1047
    const-string p0, "compat_theme_dynamic_keyboard"

    invoke-static {v2, v1, p0, v3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1048
    const-string p0, "compat_theme_dynamic_additional"

    const-string v3, "files:dynamic_theme.zip"

    invoke-static {v2, v1, p0, v3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1053
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->commit()Z
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 1054
    monitor-exit v0

    return-void

    .line 1028
    :catchall_0
    move-exception p0

    :try_start_2
    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw p0
.end method

.method public static finishSelection(Landroid/content/Context;)Z
    .locals 6

    .line 371
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 372
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 373
    const/4 v1, 0x0

    const-string v2, "compat_theme_selection_slot"

    invoke-interface {v0, v2, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 374
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isSelectableSlot(Ljava/lang/String;)Z

    move-result v3

    const/4 v4, 0x0

    if-nez v3, :cond_0

    .line 375
    return v4

    .line 377
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->resolveCurrentTheme(Landroid/content/Context;)[Ljava/lang/String;

    move-result-object v3

    .line 378
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 379
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->baseKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    aget-object v4, v3, v4

    invoke-interface {v0, v5, v4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 380
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->additionalKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const/4 v4, 0x1

    aget-object v3, v3, v4

    invoke-interface {v0, v1, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 381
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 382
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 383
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z

    .line 384
    return v4
.end method

.method private static hasEverySlotKey(Landroid/content/SharedPreferences;)Z
    .locals 1

    .line 1065
    const-string v0, "compat_theme_fixed_keyboard"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1066
    const-string v0, "compat_theme_fixed_additional"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1067
    const-string v0, "compat_theme_light_keyboard"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1068
    const-string v0, "compat_theme_light_additional"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1069
    const-string v0, "compat_theme_dark_keyboard"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1070
    const-string v0, "compat_theme_dark_additional"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1071
    const-string v0, "compat_theme_dynamic_keyboard"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1072
    const-string v0, "compat_theme_dynamic_additional"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    .line 1065
    :goto_0
    return p0
.end method

.method private static hasSelectionSession(Landroid/content/Context;)Z
    .locals 2

    .line 1100
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v0, "compat_theme_selection_slot"

    const/4 v1, 0x0

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isSelectableSlot(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method private static invalidatePreviewSnapshots(Landroid/content/Context;)V
    .locals 8

    .line 761
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->transientCacheDirectories(Landroid/content/Context;)[Ljava/io/File;

    move-result-object v0

    .line 762
    nop

    .line 763
    const/4 v1, 0x0

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_0
    array-length v4, v0

    if-ge v2, v4, :cond_3

    .line 764
    aget-object v4, v0, v2

    invoke-virtual {v4}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v4

    .line 765
    if-nez v4, :cond_0

    .line 766
    goto :goto_2

    .line 768
    :cond_0
    const/4 v5, 0x0

    :goto_1
    array-length v6, v4

    if-ge v5, v6, :cond_2

    .line 769
    aget-object v6, v4, v5

    invoke-virtual {v6}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v6

    .line 770
    const-string v7, "keyboardsnapshotcache_"

    invoke-virtual {v6, v7}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_1

    .line 771
    const-string v7, ".png"

    invoke-virtual {v6, v7}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_1

    aget-object v6, v4, v5

    .line 772
    invoke-virtual {v6}, Ljava/io/File;->delete()Z

    move-result v6

    if-eqz v6, :cond_1

    .line 773
    add-int/lit8 v3, v3, 0x1

    .line 768
    :cond_1
    add-int/lit8 v5, v5, 0x1

    goto :goto_1

    .line 763
    :cond_2
    :goto_2
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 777
    :cond_3
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "preview snapshots dropped: "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 778
    return-void
.end method

.method private static isDark(Landroid/content/res/Configuration;)Z
    .locals 1

    .line 1125
    iget p0, p0, Landroid/content/res/Configuration;->uiMode:I

    and-int/lit8 p0, p0, 0x30

    const/16 v0, 0x20

    if-ne p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public static isDynamicEnabled(Landroid/content/Context;)Z
    .locals 2

    .line 301
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->supportsDynamicColor()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 302
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v0, "compat_system_dynamic_color_theme"

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 v1, 0x1

    goto :goto_0

    :cond_0
    nop

    .line 301
    :goto_0
    return v1
.end method

.method public static isEnabled(Landroid/content/Context;)Z
    .locals 2

    .line 278
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v0, "compat_system_auto_keyboard_theme"

    const/4 v1, 0x0

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p0

    return p0
.end method

.method private static isSelectableSlot(Ljava/lang/String;)Z
    .locals 1

    .line 1105
    const-string v0, "light"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "dark"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    const-string v0, "fixed"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 p0, 0x1

    :goto_1
    return p0
.end method

.method public static logInputViewRebuild(Landroid/content/Context;)V
    .locals 1

    .line 495
    const-string v0, "rebuilding InputView after automatic theme resolution"

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 496
    return-void
.end method

.method private static preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .locals 2

    .line 1136
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 1137
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "_preferences"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1136
    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method public static prepareDynamicTheme(Landroid/content/Context;)Ljava/lang/String;
    .locals 2

    .line 340
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->supportsDynamicColor()Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 341
    return-object v1

    .line 343
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 344
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDark(Landroid/content/res/Configuration;)Z

    move-result v0

    .line 345
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->syncDynamicTheme(Landroid/content/Context;Z)I

    move-result p0

    if-nez p0, :cond_1

    .line 346
    return-object v1

    .line 348
    :cond_1
    const-string p0, "files:dynamic_theme.zip"

    return-object p0
.end method

.method private static putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    .line 1058
    invoke-interface {p1, p2}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result p1

    if-nez p1, :cond_0

    .line 1059
    invoke-interface {p0, p2, p3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 1061
    :cond_0
    return-void
.end method

.method private static putStoredEntry(Ljava/util/zip/ZipOutputStream;Ljava/lang/String;[B)V
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 958
    new-instance v0, Ljava/util/zip/CRC32;

    invoke-direct {v0}, Ljava/util/zip/CRC32;-><init>()V

    .line 959
    invoke-virtual {v0, p2}, Ljava/util/zip/CRC32;->update([B)V

    .line 960
    new-instance v1, Ljava/util/zip/ZipEntry;

    invoke-direct {v1, p1}, Ljava/util/zip/ZipEntry;-><init>(Ljava/lang/String;)V

    .line 961
    const/4 p1, 0x0

    invoke-virtual {v1, p1}, Ljava/util/zip/ZipEntry;->setMethod(I)V

    .line 962
    array-length p1, p2

    int-to-long v2, p1

    invoke-virtual {v1, v2, v3}, Ljava/util/zip/ZipEntry;->setSize(J)V

    .line 963
    array-length p1, p2

    int-to-long v2, p1

    invoke-virtual {v1, v2, v3}, Ljava/util/zip/ZipEntry;->setCompressedSize(J)V

    .line 964
    invoke-virtual {v0}, Ljava/util/zip/CRC32;->getValue()J

    move-result-wide v2

    invoke-virtual {v1, v2, v3}, Ljava/util/zip/ZipEntry;->setCrc(J)V

    .line 965
    invoke-virtual {p0, v1}, Ljava/util/zip/ZipOutputStream;->putNextEntry(Ljava/util/zip/ZipEntry;)V

    .line 966
    invoke-virtual {p0, p2}, Ljava/util/zip/ZipOutputStream;->write([B)V

    .line 967
    invoke-virtual {p0}, Ljava/util/zip/ZipOutputStream;->closeEntry()V

    .line 968
    return-void
.end method

.method private static readVarint([BI[J)I
    .locals 7

    .line 972
    nop

    .line 973
    const-wide/16 v0, 0x0

    const/4 v2, 0x0

    const/4 v3, 0x0

    .line 975
    :goto_0
    array-length v4, p0

    if-ge p1, v4, :cond_2

    const/16 v4, 0x3f

    if-le v3, v4, :cond_0

    goto :goto_1

    .line 978
    :cond_0
    aget-byte v4, p0, p1

    and-int/lit16 v4, v4, 0xff

    .line 979
    add-int/lit8 p1, p1, 0x1

    .line 980
    and-int/lit8 v5, v4, 0x7f

    int-to-long v5, v5

    shl-long/2addr v5, v3

    or-long/2addr v0, v5

    .line 981
    and-int/lit16 v4, v4, 0x80

    if-nez v4, :cond_1

    .line 982
    nop

    .line 986
    aput-wide v0, p2, v2

    .line 987
    return p1

    .line 984
    :cond_1
    add-int/lit8 v3, v3, 0x7

    .line 985
    goto :goto_0

    .line 976
    :cond_2
    :goto_1
    const/4 p0, -0x1

    return p0
.end method

.method public static reconcileCustomThemeEdit(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 11

    .line 420
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 421
    if-eqz p1, :cond_6

    invoke-virtual {p1}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;

    move-result-object v0

    if-nez v0, :cond_0

    goto :goto_2

    .line 424
    :cond_0
    invoke-virtual {p1}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;

    move-result-object p1

    const-string v0, "intent_extra_key_deleted_theme_file_name"

    invoke-virtual {p1, v0}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 425
    if-eqz p1, :cond_5

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    if-nez v0, :cond_1

    goto :goto_1

    .line 428
    :cond_1
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->resolveCurrentTheme(Landroid/content/Context;)[Ljava/lang/String;

    move-result-object v0

    .line 429
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    .line 430
    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 431
    nop

    .line 432
    const/4 v2, 0x3

    new-array v3, v2, [Ljava/lang/String;

    const-string v4, "light"

    const/4 v5, 0x0

    aput-object v4, v3, v5

    const-string v4, "dark"

    const/4 v6, 0x1

    aput-object v4, v3, v6

    const-string v4, "fixed"

    const/4 v7, 0x2

    aput-object v4, v3, v7

    .line 433
    const/4 v4, 0x0

    const/4 v7, 0x0

    :goto_0
    if-ge v4, v2, :cond_3

    .line 434
    aget-object v8, v3, v4

    .line 435
    invoke-static {v8}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->additionalKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    const-string v10, ""

    invoke-interface {p0, v9, v10}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    .line 436
    const-string v10, "files:user_theme_"

    invoke-virtual {v9, v10}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v10

    if-eqz v10, :cond_2

    invoke-virtual {v9, p1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v9

    if-eqz v9, :cond_2

    .line 437
    invoke-static {v8}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->baseKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    aget-object v9, v0, v5

    invoke-interface {v1, v7, v9}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 438
    invoke-static {v8}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->additionalKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    aget-object v8, v0, v6

    invoke-interface {v1, v7, v8}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 439
    const/4 v7, 0x1

    .line 433
    :cond_2
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 442
    :cond_3
    if-eqz v7, :cond_4

    .line 443
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 445
    :cond_4
    return-void

    .line 426
    :cond_5
    :goto_1
    return-void

    .line 422
    :cond_6
    :goto_2
    return-void
.end method

.method private static resolveCurrentTheme(Landroid/content/Context;)[Ljava/lang/String;
    .locals 8

    .line 1077
    const-string v0, "a"

    const/4 v1, 0x2

    const/4 v2, 0x1

    const/4 v3, 0x0

    :try_start_0
    const-string v4, "baq"

    invoke-static {v4}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v4

    .line 1078
    new-array v5, v2, [Ljava/lang/Class;

    const-class v6, Landroid/content/Context;

    aput-object v6, v5, v3

    invoke-virtual {v4, v0, v5}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v5

    .line 1079
    new-array v6, v2, [Ljava/lang/Object;

    aput-object p0, v6, v3

    const/4 v7, 0x0

    invoke-virtual {v5, v7, v6}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    .line 1080
    invoke-virtual {v4, v0}, Ljava/lang/Class;->getField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v0

    .line 1081
    const-string v6, "b"

    invoke-virtual {v4, v6}, Ljava/lang/Class;->getField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v4

    .line 1082
    nop

    .line 1083
    invoke-virtual {v0, v5}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 1084
    invoke-virtual {v4, v5}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    new-array v5, v1, [Ljava/lang/String;

    aput-object v0, v5, v3

    aput-object v4, v5, v2
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 1082
    return-object v5

    .line 1086
    :catch_0
    move-exception v0

    .line 1087
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 1088
    nop

    .line 1090
    const v4, 0x7f110282

    invoke-virtual {p0, v4}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v4

    .line 1091
    const v5, 0x7f110226

    invoke-virtual {p0, v5}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v5

    .line 1089
    invoke-interface {v0, v4, v5}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 1093
    const v5, 0x7f11023a

    invoke-virtual {p0, v5}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p0

    .line 1092
    const-string v5, ""

    invoke-interface {v0, p0, v5}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    new-array v0, v1, [Ljava/lang/String;

    aput-object v4, v0, v3

    aput-object p0, v0, v2

    .line 1088
    return-object v0
.end method

.method private static resolveDynamicColors(Landroid/content/Context;Z)Ljava/util/Map;
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Z)",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    .line 597
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    .line 598
    invoke-virtual {p0}, Landroid/content/Context;->getTheme()Landroid/content/res/Resources$Theme;

    move-result-object p0

    .line 599
    if-eqz p1, :cond_0

    const-string p1, "_dark"

    goto :goto_0

    :cond_0
    const-string p1, "_light"

    .line 600
    :goto_0
    new-instance v1, Ljava/util/HashMap;

    invoke-direct {v1}, Ljava/util/HashMap;-><init>()V

    .line 601
    const/4 v2, 0x0

    :goto_1
    sget-object v3, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_SLOT_NAMES:[Ljava/lang/String;

    array-length v3, v3

    if-ge v2, v3, :cond_2

    .line 602
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    sget-object v4, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_SLOT_RESOURCES:[Ljava/lang/String;

    aget-object v4, v4, v2

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 603
    const-string v4, "color"

    const-string v5, "android"

    invoke-virtual {v0, v3, v4, v5}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v3

    .line 604
    if-nez v3, :cond_1

    .line 605
    goto :goto_2

    .line 608
    :cond_1
    :try_start_0
    sget-object v4, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_SLOT_NAMES:[Ljava/lang/String;

    aget-object v4, v4, v2

    .line 610
    invoke-virtual {v0, v3, p0}, Landroid/content/res/Resources;->getColor(ILandroid/content/res/Resources$Theme;)I

    move-result v3

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    .line 608
    invoke-interface {v1, v4, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    .line 614
    goto :goto_2

    .line 611
    :catch_0
    move-exception v3

    .line 601
    :goto_2
    add-int/lit8 v2, v2, 0x1

    goto :goto_1

    .line 616
    :cond_2
    return-object v1
.end method

.method public static rewriteStyleSheetColors([BLjava/util/Map;)[B
    .locals 20
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([B",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Integer;",
            ">;)[B"
        }
    .end annotation

    .line 826
    move-object/from16 v0, p0

    move-object/from16 v1, p1

    const/4 v2, 0x0

    if-eqz v0, :cond_14

    if-nez v1, :cond_0

    move-object/from16 v16, v2

    goto/16 :goto_7

    .line 829
    :cond_0
    new-instance v3, Ljava/io/ByteArrayOutputStream;

    array-length v4, v0

    invoke-direct {v3, v4}, Ljava/io/ByteArrayOutputStream;-><init>(I)V

    .line 830
    array-length v4, v0

    .line 831
    const/4 v5, 0x0

    const/4 v6, 0x0

    .line 832
    :goto_0
    if-ge v6, v4, :cond_13

    .line 833
    aget-byte v7, v0, v6

    and-int/lit16 v7, v7, 0xff

    const/16 v8, 0x12

    if-eq v7, v8, :cond_1

    .line 834
    goto/16 :goto_6

    .line 836
    :cond_1
    add-int/lit8 v6, v6, 0x1

    .line 837
    const/4 v7, 0x1

    new-array v9, v7, [J

    .line 838
    invoke-static {v0, v6, v9}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->readVarint([BI[J)I

    move-result v6

    .line 839
    if-gez v6, :cond_2

    .line 840
    return-object v2

    .line 842
    :cond_2
    nop

    .line 843
    aget-wide v10, v9, v5

    long-to-int v9, v10

    add-int/2addr v9, v6

    .line 844
    if-gt v9, v4, :cond_12

    if-ge v9, v6, :cond_3

    move-object/from16 v16, v2

    goto/16 :goto_5

    .line 848
    :cond_3
    nop

    .line 849
    nop

    .line 850
    nop

    .line 851
    nop

    .line 852
    nop

    .line 854
    move-object v11, v2

    move v10, v6

    const/4 v12, 0x0

    const/4 v13, 0x0

    const/4 v14, 0x0

    .line 855
    :goto_1
    const/16 v15, 0x8

    move-object/from16 v16, v2

    const/16 v17, 0x0

    const/16 v5, 0xa

    if-ge v10, v9, :cond_e

    .line 856
    aget-byte v2, v0, v10

    and-int/lit16 v2, v2, 0xff

    .line 857
    add-int/lit8 v10, v10, 0x1

    .line 858
    if-ne v2, v5, :cond_6

    .line 859
    new-array v2, v7, [J

    .line 860
    invoke-static {v0, v10, v2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->readVarint([BI[J)I

    move-result v5

    .line 861
    if-gez v5, :cond_4

    .line 862
    return-object v16

    .line 864
    :cond_4
    aget-wide v10, v2, v17

    long-to-int v11, v10

    add-int/2addr v11, v5

    .line 865
    if-le v11, v9, :cond_5

    .line 866
    return-object v16

    .line 868
    :cond_5
    new-instance v10, Ljava/lang/String;

    aget-wide v7, v2, v17

    long-to-int v2, v7

    sget-object v7, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v10, v0, v5, v2, v7}, Ljava/lang/String;-><init>([BIILjava/nio/charset/Charset;)V

    .line 869
    nop

    .line 870
    move v2, v11

    move-object v11, v10

    move v10, v2

    const/4 v2, 0x1

    goto :goto_2

    :cond_6
    const/16 v5, 0x12

    if-ne v2, v5, :cond_b

    .line 871
    const/4 v2, 0x1

    new-array v5, v2, [J

    .line 872
    invoke-static {v0, v10, v5}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->readVarint([BI[J)I

    move-result v2

    .line 873
    if-gez v2, :cond_7

    .line 874
    return-object v16

    .line 876
    :cond_7
    aget-wide v7, v5, v17

    long-to-int v5, v7

    add-int/2addr v5, v2

    .line 877
    if-le v5, v9, :cond_8

    .line 878
    return-object v16

    .line 880
    :cond_8
    if-ge v2, v5, :cond_a

    aget-byte v7, v0, v2

    and-int/lit16 v7, v7, 0xff

    if-ne v7, v15, :cond_a

    .line 881
    const/4 v7, 0x1

    new-array v8, v7, [J

    .line 882
    add-int/lit8 v2, v2, 0x1

    invoke-static {v0, v2, v8}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->readVarint([BI[J)I

    move-result v2

    if-gez v2, :cond_9

    .line 883
    return-object v16

    .line 885
    :cond_9
    aget-wide v7, v8, v17

    .line 886
    const/4 v12, 0x1

    .line 888
    :cond_a
    nop

    .line 889
    move v10, v5

    const/4 v2, 0x1

    goto :goto_2

    :cond_b
    const/16 v5, 0x1a

    if-ne v2, v5, :cond_d

    .line 890
    const/4 v2, 0x1

    new-array v5, v2, [J

    .line 891
    invoke-static {v0, v10, v5}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->readVarint([BI[J)I

    move-result v7

    .line 892
    if-gez v7, :cond_c

    .line 893
    return-object v16

    .line 895
    :cond_c
    aget-wide v13, v5, v17

    long-to-int v14, v13

    .line 896
    nop

    .line 897
    move v10, v7

    const/4 v13, 0x1

    goto :goto_2

    .line 898
    :cond_d
    const/4 v2, 0x1

    move v10, v9

    .line 900
    :goto_2
    move-object/from16 v2, v16

    const/4 v5, 0x0

    const/4 v7, 0x1

    const/16 v8, 0x12

    goto :goto_1

    .line 902
    :cond_e
    if-nez v11, :cond_f

    move-object/from16 v2, v16

    goto :goto_3

    :cond_f
    invoke-interface {v1, v11}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Integer;

    .line 903
    :goto_3
    if-eqz v2, :cond_11

    if-eqz v12, :cond_11

    .line 904
    sget-object v6, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {v11, v6}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object v6

    .line 905
    new-instance v7, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v7}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 906
    invoke-virtual {v7, v15}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 907
    invoke-virtual {v2}, Ljava/lang/Integer;->longValue()J

    move-result-wide v10

    const-wide v18, 0xffffffffL

    and-long v10, v10, v18

    invoke-static {v7, v10, v11}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeVarint(Ljava/io/ByteArrayOutputStream;J)V

    .line 908
    invoke-virtual {v7}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v2

    .line 910
    new-instance v7, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v7}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 911
    invoke-virtual {v7, v5}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 912
    array-length v5, v6

    int-to-long v10, v5

    invoke-static {v7, v10, v11}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeVarint(Ljava/io/ByteArrayOutputStream;J)V

    .line 913
    array-length v5, v6

    const/4 v8, 0x0

    invoke-virtual {v7, v6, v8, v5}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    .line 914
    const/16 v5, 0x12

    invoke-virtual {v7, v5}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 915
    array-length v5, v2

    int-to-long v5, v5

    invoke-static {v7, v5, v6}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeVarint(Ljava/io/ByteArrayOutputStream;J)V

    .line 916
    array-length v5, v2

    invoke-virtual {v7, v2, v8, v5}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    .line 917
    if-eqz v13, :cond_10

    .line 918
    const/16 v5, 0x1a

    invoke-virtual {v7, v5}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 919
    int-to-long v5, v14

    and-long v5, v5, v18

    invoke-static {v7, v5, v6}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeVarint(Ljava/io/ByteArrayOutputStream;J)V

    .line 921
    :cond_10
    invoke-virtual {v7}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v2

    .line 923
    const/16 v5, 0x12

    invoke-virtual {v3, v5}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 924
    array-length v5, v2

    int-to-long v5, v5

    invoke-static {v3, v5, v6}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeVarint(Ljava/io/ByteArrayOutputStream;J)V

    .line 925
    array-length v5, v2

    const/4 v8, 0x0

    invoke-virtual {v3, v2, v8, v5}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    .line 926
    goto :goto_4

    .line 903
    :cond_11
    const/4 v8, 0x0

    .line 927
    sub-int v2, v9, v6

    .line 928
    const/16 v5, 0x12

    invoke-virtual {v3, v5}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 929
    int-to-long v10, v2

    invoke-static {v3, v10, v11}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeVarint(Ljava/io/ByteArrayOutputStream;J)V

    .line 930
    invoke-virtual {v3, v0, v6, v2}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    .line 932
    :goto_4
    nop

    .line 933
    move v6, v9

    move-object/from16 v2, v16

    const/4 v5, 0x0

    goto/16 :goto_0

    .line 844
    :cond_12
    move-object/from16 v16, v2

    .line 845
    :goto_5
    return-object v16

    .line 934
    :cond_13
    :goto_6
    invoke-virtual {v3}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v0

    return-object v0

    .line 826
    :cond_14
    move-object/from16 v16, v2

    .line 827
    :goto_7
    return-object v16
.end method

.method public static setDynamicEnabled(Landroid/content/Context;Z)V
    .locals 2

    .line 314
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 315
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 316
    const-string v1, "compat_theme_selection_slot"

    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 317
    const-string v1, "compat_system_dynamic_color_theme"

    if-eqz p1, :cond_0

    .line 318
    const/4 p1, 0x1

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    const-string v1, "compat_system_auto_keyboard_theme"

    invoke-interface {p1, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    goto :goto_0

    .line 320
    :cond_0
    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 322
    :goto_0
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 323
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z

    .line 324
    return-void
.end method

.method public static setEnabled(Landroid/content/Context;Z)V
    .locals 2

    .line 282
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 283
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 284
    const-string v1, "compat_theme_selection_slot"

    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 285
    const-string v1, "compat_system_auto_keyboard_theme"

    if-eqz p1, :cond_0

    .line 287
    const/4 p1, 0x1

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    const-string v1, "compat_system_dynamic_color_theme"

    invoke-interface {p1, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    goto :goto_0

    .line 289
    :cond_0
    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 291
    :goto_0
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 292
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z

    .line 293
    return-void
.end method

.method public static supportsDynamicColor()Z
    .locals 2

    .line 297
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1f

    if-lt v0, v1, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method private static syncDynamicTheme(Landroid/content/Context;Z)I
    .locals 6

    .line 571
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->resolveDynamicColors(Landroid/content/Context;Z)Ljava/util/Map;

    move-result-object v0

    .line 572
    invoke-static {p1, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->dynamicSignature(ZLjava/util/Map;)Ljava/lang/String;

    move-result-object v1

    .line 573
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v2

    .line 574
    new-instance v3, Ljava/io/File;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v4

    const-string v5, "dynamic_theme.zip"

    invoke-direct {v3, v4, v5}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 575
    invoke-virtual {v3}, Ljava/io/File;->isFile()Z

    move-result v4

    const-string v5, "compat_theme_dynamic_signature"

    if-eqz v4, :cond_0

    .line 576
    const/4 v4, 0x0

    invoke-interface {v2, v5, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v1, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_0

    .line 577
    const-string p1, "dynamic palette unchanged"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 578
    const/4 p0, 0x1

    return p0

    .line 580
    :cond_0
    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->buildDynamicThemePackage(Landroid/content/Context;ZLjava/util/Map;)Z

    move-result p1

    if-nez p1, :cond_1

    .line 581
    const-string p1, "dynamic theme package build failed"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 582
    invoke-virtual {v3}, Ljava/io/File;->isFile()Z

    move-result p0

    return p0

    .line 584
    :cond_1
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1, v5, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 590
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->invalidatePreviewSnapshots(Landroid/content/Context;)V

    .line 591
    const-string p1, "dynamic theme package rebuilt"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 592
    const/4 p0, 0x2

    return p0
.end method

.method private static templateBytes(Landroid/content/Context;Ljava/lang/String;)[B
    .locals 4

    .line 938
    nop

    .line 940
    const/4 v0, 0x0

    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getAssets()Landroid/content/res/AssetManager;

    move-result-object p0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "theme/"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object p0
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 941
    :try_start_1
    new-instance p1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {p1}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 942
    const/16 v1, 0x1000

    new-array v1, v1, [B

    .line 944
    :goto_0
    invoke-virtual {p0, v1}, Ljava/io/InputStream;->read([B)I

    move-result v2

    if-lez v2, :cond_0

    .line 945
    const/4 v3, 0x0

    invoke-virtual {p1, v1, v3, v2}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_0

    .line 947
    :cond_0
    invoke-virtual {p1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p1
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 951
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->closeQuietly(Ljava/io/Closeable;)V

    .line 947
    return-object p1

    .line 951
    :catchall_0
    move-exception p1

    move-object v0, p0

    goto :goto_1

    .line 948
    :catch_0
    move-exception p1

    goto :goto_2

    .line 951
    :catchall_1
    move-exception p1

    :goto_1
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->closeQuietly(Ljava/io/Closeable;)V

    .line 952
    throw p1

    .line 948
    :catch_1
    move-exception p0

    move-object p0, v0

    .line 949
    :goto_2
    nop

    .line 951
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->closeQuietly(Ljava/io/Closeable;)V

    .line 949
    return-object v0
.end method

.method private static transientCacheDirectories(Landroid/content/Context;)[Ljava/io/File;
    .locals 4

    .line 794
    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object p0

    .line 795
    if-nez p0, :cond_0

    .line 796
    const/4 p0, 0x0

    new-array p0, p0, [Ljava/io/File;

    return-object p0

    .line 798
    :cond_0
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 799
    invoke-interface {v0, p0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 800
    invoke-virtual {p0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object p0

    .line 801
    const-string v1, "/user/"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 802
    new-instance v2, Ljava/io/File;

    const-string v3, "/user_de/"

    invoke-virtual {p0, v1, v3}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    invoke-direct {v2, p0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 804
    :cond_1
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result p0

    new-array p0, p0, [Ljava/io/File;

    invoke-interface {v0, p0}, Ljava/util/List;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object p0

    check-cast p0, [Ljava/io/File;

    return-object p0
.end method

.method private static withFormatVersion([B)[B
    .locals 3

    .line 663
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    array-length v1, p0

    add-int/lit8 v1, v1, 0x2

    invoke-direct {v0, v1}, Ljava/io/ByteArrayOutputStream;-><init>(I)V

    .line 664
    const/16 v1, 0x8

    invoke-virtual {v0, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 665
    const/4 v1, 0x3

    invoke-virtual {v0, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 666
    const/4 v1, 0x0

    array-length v2, p0

    invoke-virtual {v0, p0, v1, v2}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    .line 667
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p0

    return-object p0
.end method

.method private static writeSlot(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 6

    .line 533
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 534
    const v1, 0x7f110282

    invoke-virtual {p0, v1}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v1

    .line 535
    const v2, 0x7f11023a

    invoke-virtual {p0, v2}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v2

    .line 536
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->baseKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    const-string v4, ""

    invoke-interface {v0, v3, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 537
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->additionalKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-interface {v0, p1, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 538
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 539
    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z

    move-result p2

    const/4 v4, 0x0

    if-nez p2, :cond_3

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result p2

    if-eqz p2, :cond_0

    goto :goto_1

    .line 547
    :cond_0
    const/4 p2, 0x0

    invoke-interface {v0, v1, p2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v3, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_1

    .line 548
    invoke-interface {v0, v2, p2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_1

    .line 549
    const-string p1, "legacy theme pair already resolved"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 550
    return v4

    .line 552
    :cond_1
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 553
    invoke-interface {p2, v1, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 554
    invoke-interface {p2, v2, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 555
    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    move-result p1

    .line 556
    if-eqz p1, :cond_2

    const-string p2, "legacy theme pair committed"

    goto :goto_0

    :cond_2
    const-string p2, "theme commit failed"

    :goto_0
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 557
    return p1

    .line 544
    :cond_3
    :goto_1
    const-string p1, "theme slot is empty, keeping the current theme"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 545
    return v4
.end method

.method private static writeVarint(Ljava/io/ByteArrayOutputStream;J)V
    .locals 4

    .line 992
    nop

    :goto_0
    const-wide/16 v0, 0x7f

    and-long/2addr v0, p1

    long-to-int v1, v0

    .line 993
    const/4 v0, 0x7

    ushr-long/2addr p1, v0

    .line 994
    const-wide/16 v2, 0x0

    cmp-long v0, p1, v2

    if-eqz v0, :cond_0

    .line 995
    or-int/lit16 v0, v1, 0x80

    invoke-virtual {p0, v0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 1000
    goto :goto_0

    .line 997
    :cond_0
    invoke-virtual {p0, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 998
    return-void
.end method
