.class public final Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;
.super Ljava/lang/Object;
.source "SystemAutoThemeCompat.java"


# static fields
.field private static final ASSET_DIRECTORY:Ljava/lang/String; = "theme/"

.field public static final AUTO_THEME_KEY:Ljava/lang/String; = "compat_system_auto_keyboard_theme"

.field private static final BASE_MATERIAL_THEME:I = 0x7f110226

.field private static final DARK_ADDITIONAL_KEY:Ljava/lang/String; = "compat_theme_dark_additional"

.field private static final DARK_BASE_KEY:Ljava/lang/String; = "compat_theme_dark_keyboard"

.field private static final DIAGNOSTIC_TAG:Ljava/lang/String; = "SystemAutoTheme"

.field private static final DYNAMIC_ADDITIONAL_KEY:Ljava/lang/String; = "compat_theme_dynamic_additional"

.field private static final DYNAMIC_ADDITIONAL_PREFIX:Ljava/lang/String; = "files:"

.field private static final DYNAMIC_BASE_KEY:Ljava/lang/String; = "compat_theme_dynamic_keyboard"

.field private static final DYNAMIC_COLOR_ROLES:[[Ljava/lang/String;

.field private static final DYNAMIC_ENTRIES_DARK:[Ljava/lang/String;

.field private static final DYNAMIC_ENTRIES_LIGHT:[Ljava/lang/String;

.field private static final DYNAMIC_FUNCTION_KEYS:[I

.field private static final DYNAMIC_ICON_MASKS:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Landroid/graphics/Bitmap;",
            "Landroid/graphics/Bitmap;",
            ">;"
        }
    .end annotation
.end field

.field private static final DYNAMIC_MIN_SDK:I = 0x1f

.field private static final DYNAMIC_PACKAGE_NAME:Ljava/lang/String; = "dynamic_theme.zip"

.field private static final DYNAMIC_PACKAGE_TEMP_NAME:Ljava/lang/String; = "dynamic_theme.tmp"

.field private static final DYNAMIC_PALETTE_REVISION:I = 0x7

.field private static final DYNAMIC_SIGNATURE_KEY:Ljava/lang/String; = "compat_theme_dynamic_signature"

.field private static final DYNAMIC_STYLE_ROLES:[[Ljava/lang/String;

.field public static final DYNAMIC_THEME_KEY:Ljava/lang/String; = "compat_system_dynamic_color_theme"

.field private static final FIXED_ADDITIONAL_KEY:Ljava/lang/String; = "compat_theme_fixed_additional"

.field private static final FIXED_BASE_KEY:Ljava/lang/String; = "compat_theme_fixed_keyboard"

.field private static final LEGACY_FUNCTION_ICON_ALPHA:I = 0x99

.field private static final LIGHT_ADDITIONAL_KEY:Ljava/lang/String; = "compat_theme_light_additional"

.field private static final LIGHT_BASE_KEY:Ljava/lang/String; = "compat_theme_light_keyboard"

.field private static final MATERIAL_DARK_THEME:I = 0x7f110224

.field private static final MATERIAL_LIGHT_THEME:I = 0x7f110225

.field private static final MATERIAL_TEMPLATE_PREFIX:Ljava/lang/String; = "style_sheet_material_"

.field private static final METADATA_ENTRY:Ljava/lang/String; = "metadata.binarypb"

.field private static final METADATA_TEMPLATE_PREFIX:Ljava/lang/String; = "theme_package_metadata_material_"

.field private static final MODE_DARK:Ljava/lang/String; = "dark"

.field private static final MODE_LIGHT:Ljava/lang/String; = "light"

.field private static final PREF_KEY_ADDITIONAL_THEME:I = 0x7f11023a

.field private static final PREF_KEY_KEYBOARD_THEME:I = 0x7f110282

.field private static final PRIMARY_ICON_ID:I = 0x7f0f0057

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

.field private static final USER_THEME_NAME_PREFIX:Ljava/lang/String; = "user_theme_"

.field private static final USER_THEME_VALUE_PREFIX:Ljava/lang/String; = "files:"

.field private static final UTF_8:Ljava/nio/charset/Charset;


# direct methods
.method static constructor <clinit>()V
    .locals 20

    .line 121
    const/16 v0, 0xa

    new-array v1, v0, [I

    fill-array-data v1, :array_0

    sput-object v1, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_FUNCTION_KEYS:[I

    .line 133
    new-instance v1, Ljava/util/WeakHashMap;

    invoke-direct {v1}, Ljava/util/WeakHashMap;-><init>()V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_ICON_MASKS:Ljava/util/Map;

    .line 151
    const/16 v1, 0x8

    new-array v2, v1, [Ljava/lang/String;

    const/4 v3, 0x0

    const-string v4, "style_sheet_color_common.binarypb"

    aput-object v4, v2, v3

    const/4 v5, 0x1

    const-string v6, "style_sheet_material_light.binarypb"

    aput-object v6, v2, v5

    const/4 v6, 0x2

    const-string v7, "style_sheet_color_gif_light.binarypb"

    aput-object v7, v2, v6

    const/4 v7, 0x3

    const-string v8, "style_sheet_color_rules.binarypb"

    aput-object v8, v2, v7

    const/4 v9, 0x4

    const-string v10, "style_sheet_material_rules.binarypb"

    aput-object v10, v2, v9

    const/4 v11, 0x5

    const-string v12, "style_sheet_material_light_border.binarypb"

    aput-object v12, v2, v11

    const/4 v12, 0x6

    const-string v13, "style_sheet_color_rules_border.binarypb"

    aput-object v13, v2, v12

    const/4 v14, 0x7

    const-string v15, "style_sheet_material_rules_border.binarypb"

    aput-object v15, v2, v14

    sput-object v2, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_ENTRIES_LIGHT:[Ljava/lang/String;

    .line 161
    new-array v2, v1, [Ljava/lang/String;

    aput-object v4, v2, v3

    const-string v4, "style_sheet_material_dark.binarypb"

    aput-object v4, v2, v5

    const-string v4, "style_sheet_color_gif_dark.binarypb"

    aput-object v4, v2, v6

    aput-object v8, v2, v7

    aput-object v10, v2, v9

    const-string v4, "style_sheet_material_dark_border.binarypb"

    aput-object v4, v2, v11

    aput-object v13, v2, v12

    aput-object v15, v2, v14

    sput-object v2, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_ENTRIES_DARK:[Ljava/lang/String;

    .line 177
    const/16 v2, 0xb

    new-array v4, v2, [[Ljava/lang/String;

    new-array v8, v7, [Ljava/lang/String;

    const-string v10, "base"

    aput-object v10, v8, v3

    const-string v13, "surface_container"

    aput-object v13, v8, v5

    const-string v13, "neutral1_100|neutral1_900"

    aput-object v13, v8, v6

    aput-object v8, v4, v3

    new-array v8, v7, [Ljava/lang/String;

    const-string v13, "surface"

    aput-object v13, v8, v3

    aput-object v13, v8, v5

    const-string v15, "neutral1_10|neutral1_900"

    aput-object v15, v8, v6

    aput-object v8, v4, v5

    new-array v8, v7, [Ljava/lang/String;

    const-string v15, "letter"

    aput-object v15, v8, v3

    const-string v15, "surface_container_lowest|surface_bright"

    aput-object v15, v8, v5

    const-string v15, "neutral1_0|neutral1_800"

    aput-object v15, v8, v6

    aput-object v8, v4, v6

    new-array v8, v7, [Ljava/lang/String;

    const-string v15, "high"

    aput-object v15, v8, v3

    const-string v15, "surface_container_high"

    aput-object v15, v8, v5

    const-string v15, "neutral1_100|neutral1_800"

    aput-object v15, v8, v6

    aput-object v8, v4, v7

    new-array v8, v7, [Ljava/lang/String;

    const-string v15, "highest"

    aput-object v15, v8, v3

    const-string v15, "surface_container_highest"

    aput-object v15, v8, v5

    const-string v15, "neutral1_200|neutral1_800"

    aput-object v15, v8, v6

    aput-object v8, v4, v9

    new-array v8, v7, [Ljava/lang/String;

    const-string v15, "on_surface"

    aput-object v15, v8, v3

    aput-object v15, v8, v5

    const-string v16, "neutral1_900|neutral1_100"

    aput-object v16, v8, v6

    aput-object v8, v4, v11

    new-array v8, v7, [Ljava/lang/String;

    const-string v16, "function"

    aput-object v16, v8, v3

    const-string v17, "secondary_container"

    aput-object v17, v8, v5

    const-string v17, "accent2_100|accent2_700"

    aput-object v17, v8, v6

    aput-object v8, v4, v12

    new-array v8, v7, [Ljava/lang/String;

    const-string v17, "on_function"

    aput-object v17, v8, v3

    const-string v17, "on_secondary_container"

    aput-object v17, v8, v5

    const-string v17, "accent2_900|accent2_100"

    aput-object v17, v8, v6

    aput-object v8, v4, v14

    new-array v8, v7, [Ljava/lang/String;

    const-string v17, "primary"

    aput-object v17, v8, v3

    aput-object v17, v8, v5

    const-string v18, "accent1_600|accent1_200"

    aput-object v18, v8, v6

    aput-object v8, v4, v1

    new-array v8, v7, [Ljava/lang/String;

    const-string v18, "primary_container"

    aput-object v18, v8, v3

    aput-object v18, v8, v5

    const-string v19, "accent1_100|accent1_700"

    aput-object v19, v8, v6

    const/16 v19, 0x9

    aput-object v8, v4, v19

    new-array v8, v7, [Ljava/lang/String;

    const-string v19, "outline"

    aput-object v19, v8, v3

    const-string v19, "outline_variant"

    aput-object v19, v8, v5

    const-string v19, "neutral2_200|neutral2_700"

    aput-object v19, v8, v6

    aput-object v8, v4, v0

    sput-object v4, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_COLOR_ROLES:[[Ljava/lang/String;

    .line 192
    const/16 v4, 0x17

    new-array v4, v4, [[Ljava/lang/String;

    new-array v8, v6, [Ljava/lang/String;

    const-string v19, "color_base"

    aput-object v19, v8, v3

    aput-object v10, v8, v5

    aput-object v8, v4, v3

    new-array v8, v6, [Ljava/lang/String;

    const-string v10, "color_header"

    aput-object v10, v8, v3

    aput-object v13, v8, v5

    aput-object v8, v4, v5

    new-array v8, v6, [Ljava/lang/String;

    const-string v10, "color_popup_background"

    aput-object v10, v8, v3

    const-string v10, "high"

    aput-object v10, v8, v5

    aput-object v8, v4, v6

    new-array v8, v6, [Ljava/lang/String;

    const-string v10, "color_access_point_panel_item_background"

    aput-object v10, v8, v3

    aput-object v13, v8, v5

    aput-object v8, v4, v7

    new-array v7, v6, [Ljava/lang/String;

    const-string v8, "color_label"

    aput-object v8, v7, v3

    aput-object v15, v7, v5

    aput-object v7, v4, v9

    new-array v7, v6, [Ljava/lang/String;

    const-string v8, "color_label_header_active"

    aput-object v8, v7, v3

    aput-object v15, v7, v5

    aput-object v7, v4, v11

    new-array v7, v6, [Ljava/lang/String;

    const-string v8, "color_popup_label"

    aput-object v8, v7, v3

    aput-object v15, v7, v5

    aput-object v7, v4, v12

    new-array v7, v6, [Ljava/lang/String;

    const-string v8, "color_icon"

    aput-object v8, v7, v3

    aput-object v15, v7, v5

    aput-object v7, v4, v14

    new-array v7, v6, [Ljava/lang/String;

    const-string v8, "color_label_function_key"

    aput-object v8, v7, v3

    aput-object v15, v7, v5

    aput-object v7, v4, v1

    new-array v1, v6, [Ljava/lang/String;

    const-string v7, "color_label_space_key"

    aput-object v7, v1, v3

    aput-object v15, v1, v5

    const/16 v7, 0x9

    aput-object v1, v4, v7

    new-array v1, v6, [Ljava/lang/String;

    const-string v7, "color_icon_action"

    aput-object v7, v1, v3

    const-string v7, "on_function"

    aput-object v7, v1, v5

    aput-object v1, v4, v0

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_state_action"

    aput-object v1, v0, v3

    aput-object v16, v0, v5

    aput-object v0, v4, v2

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_action_default"

    aput-object v1, v0, v3

    aput-object v17, v0, v5

    const/16 v1, 0xc

    aput-object v0, v4, v1

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_label_dynamic"

    aput-object v1, v0, v3

    aput-object v17, v0, v5

    const/16 v1, 0xd

    aput-object v0, v4, v1

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_keyboard_editing_button"

    aput-object v1, v0, v3

    aput-object v17, v0, v5

    const/16 v1, 0xe

    aput-object v0, v4, v1

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_keyboard_editing_button_background"

    aput-object v1, v0, v3

    aput-object v18, v0, v5

    const/16 v1, 0xf

    aput-object v0, v4, v1

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_key_paging_scrollbar"

    aput-object v1, v0, v3

    aput-object v17, v0, v5

    const/16 v1, 0x10

    aput-object v0, v4, v1

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_notice_text"

    aput-object v1, v0, v3

    aput-object v17, v0, v5

    const/16 v1, 0x11

    aput-object v0, v4, v1

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_state_popup_item_pressed"

    aput-object v1, v0, v3

    aput-object v18, v0, v5

    const/16 v1, 0x12

    aput-object v0, v4, v1

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_generic_extension_background_activated"

    aput-object v1, v0, v3

    aput-object v16, v0, v5

    const/16 v1, 0x13

    aput-object v0, v4, v1

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_keyboard_separator"

    aput-object v1, v0, v3

    const-string v1, "outline"

    aput-object v1, v0, v5

    const/16 v1, 0x14

    aput-object v0, v4, v1

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_state_border_key_action"

    aput-object v1, v0, v3

    aput-object v16, v0, v5

    const/16 v1, 0x15

    aput-object v0, v4, v1

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_state_space_bar"

    aput-object v1, v0, v3

    const-string v1, "letter"

    aput-object v1, v0, v5

    const/16 v1, 0x16

    aput-object v0, v4, v1

    sput-object v4, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_STYLE_ROLES:[[Ljava/lang/String;

    .line 218
    const-string v0, "UTF-8"

    invoke-static {v0}, Ljava/nio/charset/Charset;->forName(Ljava/lang/String;)Ljava/nio/charset/Charset;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->UTF_8:Ljava/nio/charset/Charset;

    return-void

    nop

    :array_0
    .array-data 4
        0x7f0f0221
        0x7f0f0222
        0x7f0f020e
        0x7f0f020f
        0x7f0f036e
        0x7f0f0371
        0x7f0f0373
        0x7f0f0374
        0x7f0f0375
        0x7f0f0376
    .end array-data
.end method

.method private constructor <init>()V
    .locals 0

    .line 220
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static additionalKey(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 1275
    const-string v0, "light"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string p0, "compat_theme_light_additional"

    return-object p0

    .line 1276
    :cond_0
    const-string v0, "dark"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    const-string p0, "compat_theme_dark_additional"

    return-object p0

    .line 1277
    :cond_1
    const-string v0, "fixed"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    const-string p0, "compat_theme_fixed_additional"

    return-object p0

    .line 1278
    :cond_2
    const-string v0, "dynamic"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_3

    const-string p0, "compat_theme_dynamic_additional"

    return-object p0

    .line 1279
    :cond_3
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "Unknown theme slot"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z
    .locals 2

    .line 593
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDynamicEnabled(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_4

    .line 594
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDark(Landroid/content/res/Configuration;)Z

    move-result v0

    .line 595
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->syncDynamicTheme(Landroid/content/Context;Z)I

    move-result v1

    .line 596
    if-eqz v1, :cond_3

    .line 597
    nop

    .line 600
    if-eqz v0, :cond_0

    const-string p1, "resolved target=dynamic-dark"

    goto :goto_0

    :cond_0
    const-string p1, "resolved target=dynamic-light"

    .line 597
    :goto_0
    const-string v0, "dynamic"

    invoke-static {p0, v0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeSlot(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    .line 604
    const/4 p1, 0x2

    if-eq v1, p1, :cond_2

    if-eqz p0, :cond_1

    goto :goto_1

    :cond_1
    const/4 p0, 0x0

    goto :goto_2

    :cond_2
    :goto_1
    const/4 p0, 0x1

    :goto_2
    return p0

    .line 611
    :cond_3
    const-string v0, "dynamic package unavailable, resolving the legacy pair"

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 613
    :cond_4
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isEnabled(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_7

    .line 614
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDark(Landroid/content/res/Configuration;)Z

    move-result p1

    .line 615
    nop

    .line 617
    if-eqz p1, :cond_5

    const-string v0, "dark"

    goto :goto_3

    :cond_5
    const-string v0, "light"

    .line 618
    :goto_3
    if-eqz p1, :cond_6

    const-string p1, "resolved target=dark"

    goto :goto_4

    :cond_6
    const-string p1, "resolved target=light"

    .line 615
    :goto_4
    invoke-static {p0, v0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeSlot(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0

    .line 620
    :cond_7
    const-string p1, "fixed"

    const-string v0, "resolved target=fixed"

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeSlot(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public static applyCustomThemeEditResult(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 3

    .line 458
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 459
    if-eqz p1, :cond_5

    invoke-virtual {p1}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;

    move-result-object v0

    if-nez v0, :cond_0

    goto :goto_3

    .line 462
    :cond_0
    invoke-virtual {p1}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;

    move-result-object v0

    const-string v1, "intent_extra_key_deleted_theme_file_name"

    invoke-virtual {v0, v1}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 463
    if-eqz v0, :cond_4

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-nez v1, :cond_1

    goto :goto_2

    .line 466
    :cond_1
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "files:"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 467
    invoke-virtual {p1}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;

    move-result-object p1

    const-string v1, "intent_extra_key_new_theme_file_name"

    invoke-virtual {p1, v1}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 468
    nop

    .line 471
    if-eqz p1, :cond_3

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v1

    if-nez v1, :cond_2

    goto :goto_0

    .line 473
    :cond_2
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    goto :goto_1

    .line 472
    :cond_3
    :goto_0
    const/4 p1, 0x0

    .line 468
    :goto_1
    invoke-static {p0, v0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->repointSlots(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 474
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z

    .line 475
    return-void

    .line 464
    :cond_4
    :goto_2
    return-void

    .line 460
    :cond_5
    :goto_3
    return-void
.end method

.method public static declared-synchronized applyDynamicFunctionIcon(Landroid/content/Context;ILandroid/widget/ImageView;)V
    .locals 12

    const-class v1, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;

    monitor-enter v1

    .line 692
    :try_start_0
    invoke-virtual {p2}, Landroid/widget/ImageView;->getId()I

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const v2, 0x7f0f0057

    if-eq v0, v2, :cond_0

    monitor-exit v1

    return-void

    .line 693
    :cond_0
    nop

    .line 694
    :try_start_1
    sget-object v0, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_FUNCTION_KEYS:[I

    array-length v2, v0

    const/4 v3, 0x0

    const/4 v4, 0x0

    :goto_0
    if-ge v4, v2, :cond_2

    aget v5, v0, v4

    .line 695
    if-ne p1, v5, :cond_1

    const/4 p1, 0x1

    goto :goto_1

    .line 694
    :cond_1
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    :cond_2
    const/4 p1, 0x0

    .line 697
    :goto_1
    if-eqz p1, :cond_9

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->usesDynamicThemePackage(Landroid/content/Context;)Z

    move-result p0

    if-nez p0, :cond_3

    goto/16 :goto_4

    .line 698
    :cond_3
    invoke-virtual {p2}, Landroid/widget/ImageView;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object p0

    .line 699
    instance-of p1, p0, Landroid/graphics/drawable/BitmapDrawable;
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    if-nez p1, :cond_4

    monitor-exit v1

    return-void

    .line 700
    :cond_4
    :try_start_2
    move-object p1, p0

    check-cast p1, Landroid/graphics/drawable/BitmapDrawable;

    invoke-virtual {p1}, Landroid/graphics/drawable/BitmapDrawable;->getBitmap()Landroid/graphics/Bitmap;

    move-result-object v4

    .line 701
    sget-object p1, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_ICON_MASKS:Ljava/util/Map;

    invoke-interface {p1, v4}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/graphics/Bitmap;

    .line 702
    if-nez p1, :cond_8

    .line 703
    invoke-virtual {v4}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v7

    .line 704
    invoke-virtual {v4}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v11

    .line 705
    mul-int p1, v7, v11

    new-array v5, p1, [I

    .line 706
    const/4 v8, 0x0

    const/4 v9, 0x0

    const/4 v6, 0x0

    move v10, v7

    invoke-virtual/range {v4 .. v11}, Landroid/graphics/Bitmap;->getPixels([IIIIIII)V

    .line 707
    nop

    .line 708
    const/4 v0, 0x0

    const/4 v2, 0x0

    :goto_2
    if-ge v0, p1, :cond_5

    aget v6, v5, v0

    ushr-int/lit8 v6, v6, 0x18

    invoke-static {v2, v6}, Ljava/lang/Math;->max(II)I

    move-result v2
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    add-int/lit8 v0, v0, 0x1

    goto :goto_2

    .line 709
    :cond_5
    const/16 v0, 0x99

    if-eq v2, v0, :cond_6

    monitor-exit v1

    return-void

    .line 710
    :cond_6
    nop

    :goto_3
    if-ge v3, p1, :cond_7

    .line 711
    :try_start_3
    aget v2, v5, v3

    ushr-int/lit8 v2, v2, 0x18

    mul-int/lit16 v2, v2, 0xff

    div-int/2addr v2, v0

    .line 712
    aget v6, v5, v3

    const v8, 0xffffff

    and-int/2addr v6, v8

    shl-int/lit8 v2, v2, 0x18

    or-int/2addr v2, v6

    aput v2, v5, v3

    .line 710
    add-int/lit8 v3, v3, 0x1

    goto :goto_3

    .line 714
    :cond_7
    sget-object p1, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v5, v7, v11, p1}, Landroid/graphics/Bitmap;->createBitmap([IIILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object p1

    .line 715
    invoke-virtual {v4}, Landroid/graphics/Bitmap;->getDensity()I

    move-result v0

    invoke-virtual {p1, v0}, Landroid/graphics/Bitmap;->setDensity(I)V

    .line 716
    sget-object v0, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_ICON_MASKS:Ljava/util/Map;

    invoke-interface {v0, v4, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 718
    :cond_8
    invoke-virtual {p2, p1}, Landroid/widget/ImageView;->setImageBitmap(Landroid/graphics/Bitmap;)V

    .line 719
    invoke-virtual {p2}, Landroid/widget/ImageView;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object p1

    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getColorFilter()Landroid/graphics/ColorFilter;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/graphics/drawable/Drawable;->setColorFilter(Landroid/graphics/ColorFilter;)V

    .line 720
    invoke-virtual {p2}, Landroid/widget/ImageView;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object p1

    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getAlpha()I

    move-result p0

    invoke-virtual {p1, p0}, Landroid/graphics/drawable/Drawable;->setAlpha(I)V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 721
    monitor-exit v1

    return-void

    .line 697
    :cond_9
    :goto_4
    monitor-exit v1

    return-void

    .line 691
    :catchall_0
    move-exception v0

    move-object p0, v0

    :try_start_4
    monitor-exit v1
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    goto :goto_6

    :goto_5
    throw p0

    :goto_6
    goto :goto_5
.end method

.method public static applyIfEnabled(Landroid/content/Context;Landroid/content/res/Configuration;)Z
    .locals 2

    .line 552
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

    .line 553
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 558
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDynamicEnabled(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 559
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z

    move-result p0

    return p0

    .line 561
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isEnabled(Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :cond_1

    .line 562
    const/4 p0, 0x0

    return p0

    .line 564
    :cond_1
    nop

    .line 566
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDark(Landroid/content/res/Configuration;)Z

    move-result v0

    if-eqz v0, :cond_2

    const-string v0, "dark"

    goto :goto_0

    :cond_2
    const-string v0, "light"

    .line 567
    :goto_0
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDark(Landroid/content/res/Configuration;)Z

    move-result p1

    if-eqz p1, :cond_3

    const-string p1, "resolved target=dark"

    goto :goto_1

    :cond_3
    const-string p1, "resolved target=light"

    .line 564
    :goto_1
    invoke-static {p0, v0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeSlot(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public static applyOnCreate(Landroid/content/Context;)Z
    .locals 1

    .line 547
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 548
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

    .line 580
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDynamicEnabled(Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 581
    const/4 p0, 0x0

    return p0

    .line 583
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 584
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z

    move-result p0

    return p0
.end method

.method public static applyTheme(Landroid/content/Context;Ljava/lang/String;)V
    .locals 2

    .line 328
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 329
    if-eqz p1, :cond_0

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    if-eqz v0, :cond_0

    .line 332
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->disable(Landroid/content/Context;)V

    .line 333
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 334
    const v1, 0x7f11023a

    invoke-virtual {p0, v1}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 335
    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 336
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->captureFixedTheme(Landroid/content/Context;)V

    .line 337
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z

    .line 338
    return-void

    .line 330
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Empty theme value"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public static assignSlot(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    .line 352
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 353
    if-eqz p2, :cond_2

    invoke-virtual {p2}, Ljava/lang/String;->length()I

    move-result v0

    if-eqz v0, :cond_2

    .line 356
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isEnabled(Landroid/content/Context;)Z

    move-result v0

    .line 357
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isSelectableSlot(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 358
    const-string v1, "fixed"

    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    if-nez v0, :cond_1

    goto :goto_0

    :cond_0
    if-eqz v0, :cond_1

    .line 361
    :goto_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 362
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->additionalKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-interface {v0, p1, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 363
    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 364
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z

    .line 365
    return-void

    .line 359
    :cond_1
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "Theme slot is disabled"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 354
    :cond_2
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Empty theme value"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static baseKey(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 1267
    const-string v0, "light"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string p0, "compat_theme_light_keyboard"

    return-object p0

    .line 1268
    :cond_0
    const-string v0, "dark"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    const-string p0, "compat_theme_dark_keyboard"

    return-object p0

    .line 1269
    :cond_1
    const-string v0, "fixed"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    const-string p0, "compat_theme_fixed_keyboard"

    return-object p0

    .line 1270
    :cond_2
    const-string v0, "dynamic"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_3

    const-string p0, "compat_theme_dynamic_keyboard"

    return-object p0

    .line 1271
    :cond_3
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "Unknown theme slot"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static buildDynamicThemePackage(Landroid/content/Context;ZLjava/util/Map;)Z
    .locals 12
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

    .line 826
    if-eqz p1, :cond_0

    const-string v0, "dark"

    goto :goto_0

    :cond_0
    const-string v0, "light"

    .line 827
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

    .line 828
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

    .line 829
    const/4 v4, 0x0

    invoke-static {p2, p1, v4}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->dynamicStyleColors(Ljava/util/Map;ZZ)Ljava/util/Map;

    move-result-object v5

    .line 830
    const/4 v6, 0x1

    invoke-static {p2, p1, v6}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->dynamicStyleColors(Ljava/util/Map;ZZ)Ljava/util/Map;

    move-result-object p2

    .line 831
    if-eqz p1, :cond_1

    sget-object p1, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_ENTRIES_DARK:[Ljava/lang/String;

    goto :goto_1

    :cond_1
    sget-object p1, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_ENTRIES_LIGHT:[Ljava/lang/String;

    .line 832
    :goto_1
    array-length v7, p1

    new-array v7, v7, [[B

    .line 833
    const/4 v8, 0x0

    :goto_2
    array-length v9, p1

    if-ge v8, v9, :cond_6

    .line 834
    aget-object v9, p1, v8

    .line 835
    invoke-static {p0, v9}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->templateBytes(Landroid/content/Context;Ljava/lang/String;)[B

    move-result-object v10

    .line 836
    if-nez v10, :cond_2

    .line 837
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "dynamic template missing: "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 838
    return v4

    .line 840
    :cond_2
    invoke-virtual {v1, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v11

    if-eqz v11, :cond_3

    .line 841
    invoke-static {v10, v5}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->rewriteStyleSheetColors([BLjava/util/Map;)[B

    move-result-object v10

    goto :goto_3

    .line 842
    :cond_3
    invoke-virtual {v2, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v11

    if-eqz v11, :cond_4

    .line 843
    invoke-static {v10, p2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->rewriteStyleSheetColors([BLjava/util/Map;)[B

    move-result-object v10

    .line 845
    :cond_4
    :goto_3
    if-nez v10, :cond_5

    .line 846
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "dynamic style sheet rewrite failed: "

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 847
    return v4

    .line 849
    :cond_5
    aput-object v10, v7, v8

    .line 833
    add-int/lit8 v8, v8, 0x1

    goto :goto_2

    .line 851
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

    .line 852
    if-nez p2, :cond_7

    .line 853
    const-string p1, "dynamic template missing: metadata"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 854
    return v4

    .line 856
    :cond_7
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    array-length v1, p2

    add-int/lit8 v1, v1, 0x2

    invoke-direct {v0, v1}, Ljava/io/ByteArrayOutputStream;-><init>(I)V

    .line 857
    const/16 v1, 0x8

    invoke-virtual {v0, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 858
    const/4 v1, 0x3

    invoke-virtual {v0, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 859
    array-length v1, p2

    invoke-virtual {v0, p2, v4, v1}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    .line 860
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p2

    .line 862
    new-instance v0, Ljava/io/File;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v1

    const-string v2, "dynamic_theme.zip"

    invoke-direct {v0, v1, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 863
    new-instance v1, Ljava/io/File;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v2

    const-string v3, "dynamic_theme.tmp"

    invoke-direct {v1, v2, v3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 864
    nop

    .line 866
    const/4 v2, 0x0

    :try_start_0
    new-instance v3, Ljava/util/zip/ZipOutputStream;

    new-instance v5, Ljava/io/FileOutputStream;

    invoke-direct {v5, v1}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    invoke-direct {v3, v5}, Ljava/util/zip/ZipOutputStream;-><init>(Ljava/io/OutputStream;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1

    .line 867
    :try_start_1
    const-string v2, "metadata.binarypb"

    invoke-static {v3, v2, p2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putStoredEntry(Ljava/util/zip/ZipOutputStream;Ljava/lang/String;[B)V

    .line 868
    const/4 p2, 0x0

    :goto_4
    array-length v2, p1

    if-ge p2, v2, :cond_8

    .line 869
    aget-object v2, p1, p2

    aget-object v5, v7, p2

    invoke-static {v3, v2, v5}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putStoredEntry(Ljava/util/zip/ZipOutputStream;Ljava/lang/String;[B)V

    .line 868
    add-int/lit8 p2, p2, 0x1

    goto :goto_4

    .line 873
    :cond_8
    invoke-virtual {v3}, Ljava/util/zip/ZipOutputStream;->close()V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0

    .line 879
    nop

    .line 881
    invoke-virtual {v1, v0}, Ljava/io/File;->renameTo(Ljava/io/File;)Z

    move-result p1

    if-nez p1, :cond_9

    .line 884
    invoke-virtual {v1}, Ljava/io/File;->delete()Z

    .line 885
    const-string p1, "dynamic theme package replace failed"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 886
    return v4

    .line 888
    :cond_9
    return v6

    .line 874
    :catch_0
    move-exception p1

    move-object v2, v3

    goto :goto_5

    :catch_1
    move-exception p1

    .line 875
    :goto_5
    const-string p1, "dynamic theme package write failed"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 876
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->closeQuietly(Ljava/io/Closeable;)V

    .line 877
    invoke-virtual {v1}, Ljava/io/File;->delete()Z

    .line 878
    return v4
.end method

.method public static captureFixedTheme(Landroid/content/Context;)V
    .locals 3

    .line 305
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 306
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->resolveCurrentTheme(Landroid/content/Context;)[Ljava/lang/String;

    move-result-object v0

    .line 307
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const/4 v1, 0x0

    aget-object v1, v0, v1

    .line 308
    const-string v2, "compat_theme_fixed_keyboard"

    invoke-interface {p0, v2, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const/4 v1, 0x1

    aget-object v0, v0, v1

    .line 309
    const-string v1, "compat_theme_fixed_additional"

    invoke-interface {p0, v1, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 310
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 311
    return-void
.end method

.method private static closeQuietly(Ljava/io/Closeable;)V
    .locals 0

    .line 1166
    if-nez p0, :cond_0

    .line 1167
    return-void

    .line 1170
    :cond_0
    :try_start_0
    invoke-interface {p0}, Ljava/io/Closeable;->close()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 1173
    goto :goto_0

    .line 1171
    :catch_0
    move-exception p0

    .line 1174
    :goto_0
    return-void
.end method

.method private static customThemeName(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    .line 534
    nop

    .line 535
    const/4 v0, 0x0

    if-eqz p0, :cond_3

    const-string v1, "files:user_theme_"

    invoke-virtual {p0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_0

    goto :goto_1

    .line 538
    :cond_0
    const-string v1, "files:"

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v1

    invoke-virtual {p0, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    .line 539
    const/16 v1, 0x2f

    invoke-virtual {p0, v1}, Ljava/lang/String;->indexOf(I)I

    move-result v1

    if-gez v1, :cond_2

    const/16 v1, 0x5c

    invoke-virtual {p0, v1}, Ljava/lang/String;->indexOf(I)I

    move-result v1

    if-gez v1, :cond_2

    const-string v1, ".."

    invoke-virtual {p0, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    if-ltz v1, :cond_1

    goto :goto_0

    .line 542
    :cond_1
    return-object p0

    .line 540
    :cond_2
    :goto_0
    return-object v0

    .line 536
    :cond_3
    :goto_1
    return-object v0
.end method

.method private static debugLog(Landroid/content/Context;Ljava/lang/String;)V
    .locals 0

    .line 1288
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object p0

    iget p0, p0, Landroid/content/pm/ApplicationInfo;->flags:I

    and-int/lit8 p0, p0, 0x2

    if-eqz p0, :cond_0

    .line 1289
    const-string p0, "SystemAutoTheme"

    invoke-static {p0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 1291
    :cond_0
    return-void
.end method

.method private static defaultAdditional(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 526
    const-string v0, "dark"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 527
    const p1, 0x7f110224

    invoke-virtual {p0, p1}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 529
    :cond_0
    const p1, 0x7f110225

    invoke-virtual {p0, p1}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static deleteUserTheme(Landroid/content/Context;Ljava/lang/String;)Z
    .locals 4

    .line 428
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 429
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->customThemeName(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 430
    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 431
    return v1

    .line 433
    :cond_0
    new-instance v2, Ljava/io/File;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v3

    invoke-direct {v2, v3, v0}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 434
    invoke-virtual {v2}, Ljava/io/File;->isFile()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-virtual {v2}, Ljava/io/File;->delete()Z

    move-result v0

    if-nez v0, :cond_1

    .line 435
    const-string p1, "custom theme delete failed"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 436
    return v1

    .line 438
    :cond_1
    const/4 v0, 0x0

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->repointSlots(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 439
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z

    .line 440
    const/4 p0, 0x1

    return p0
.end method

.method public static disable(Landroid/content/Context;)V
    .locals 1

    .line 296
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 297
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 298
    const-string v0, "compat_system_auto_keyboard_theme"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 299
    const-string v0, "compat_system_dynamic_color_theme"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 300
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 301
    return-void
.end method

.method private static dynamicSignature(ZLjava/util/Map;)Ljava/lang/String;
    .locals 6
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

    .line 808
    new-instance v0, Ljava/lang/StringBuilder;

    if-eqz p0, :cond_0

    const-string p0, "dark"

    goto :goto_0

    :cond_0
    const-string p0, "light"

    :goto_0
    invoke-direct {v0, p0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 809
    const-string p0, "@v"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const/4 v1, 0x3

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 810
    const-string p0, "@r"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const/4 v1, 0x7

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 811
    sget-object p0, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_COLOR_ROLES:[[Ljava/lang/String;

    array-length v1, p0

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_1
    if-ge v3, v1, :cond_1

    aget-object v4, p0, v3

    .line 812
    const/16 v5, 0x3a

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    move-result-object v5

    aget-object v4, v4, v2

    invoke-interface {p1, v4}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/Integer;

    invoke-virtual {v4}, Ljava/lang/Integer;->intValue()I

    move-result v4

    invoke-static {v4}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 811
    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    .line 814
    :cond_1
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static dynamicStyleColors(Ljava/util/Map;ZZ)Ljava/util/Map;
    .locals 9
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Integer;",
            ">;ZZ)",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Integer;",
            ">;"
        }
    .end annotation

    .line 776
    new-instance v0, Ljava/util/TreeMap;

    invoke-direct {v0}, Ljava/util/TreeMap;-><init>()V

    .line 777
    sget-object v1, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_STYLE_ROLES:[[Ljava/lang/String;

    array-length v2, v1

    const/4 v3, 0x0

    const/4 v4, 0x0

    :goto_0
    if-ge v4, v2, :cond_0

    aget-object v5, v1, v4

    .line 778
    aget-object v6, v5, v3

    const/4 v7, 0x1

    aget-object v5, v5, v7

    invoke-interface {p0, v5}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    invoke-interface {v0, v6, v5}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 777
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 780
    :cond_0
    const-string v1, "function"

    invoke-interface {p0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    .line 781
    const-string v2, "on_function"

    invoke-interface {p0, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    .line 782
    const-string v3, "on_surface"

    invoke-interface {p0, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/Integer;

    invoke-virtual {v3}, Ljava/lang/Integer;->intValue()I

    move-result v3

    .line 783
    const-string v4, "letter"

    invoke-interface {p0, v4}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/Integer;

    invoke-virtual {v4}, Ljava/lang/Integer;->intValue()I

    move-result v4

    .line 784
    invoke-static {v1, v2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->pressedColor(II)I

    move-result v5

    .line 785
    if-eqz p1, :cond_1

    invoke-static {v4, v3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->pressedColor(II)I

    move-result p1

    goto :goto_1

    .line 786
    :cond_1
    const-string p1, "highest"

    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    .line 787
    :goto_1
    const-string v6, "color_state_action_pressed"

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    invoke-interface {v0, v6, v7}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 788
    const-string v6, "color_state_border_key_action_pressed"

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    invoke-interface {v0, v6, v7}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 789
    const-string v6, "color_state_space_bar_pressed"

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    invoke-interface {v0, v6, v7}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 791
    const-string v6, "base"

    if-eqz p2, :cond_2

    move-object v7, v6

    goto :goto_2

    :cond_2
    const-string v7, "surface"

    :goto_2
    invoke-interface {p0, v7}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    const-string v8, "color_access_points_menu_background"

    invoke-interface {v0, v8, v7}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 792
    const-string v7, "color_state_key_dark_pressed"

    const-string v8, "color_state_key_pressed"

    if-eqz p2, :cond_3

    .line 793
    const-string p0, "color_state_key"

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    invoke-interface {v0, p0, p2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 794
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-interface {v0, v8, p0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 795
    const-string p0, "color_state_key_dark"

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {v0, p0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 796
    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-interface {v0, v7, p0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 797
    const-string p0, "color_icon"

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {v0, p0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 798
    const-string p0, "color_label_function_key"

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {v0, p0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_3

    .line 800
    :cond_3
    invoke-interface {p0, v6}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    .line 801
    invoke-static {p0, v3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->pressedColor(II)I

    move-result p1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {v0, v8, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 802
    invoke-static {p0, v3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->pressedColor(II)I

    move-result p0

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-interface {v0, v7, p0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 804
    :goto_3
    return-object v0
.end method

.method private static declared-synchronized ensureInitialized(Landroid/content/Context;)V
    .locals 6

    const-class v0, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;

    monitor-enter v0

    .line 1191
    :try_start_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v1

    .line 1192
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->hasEverySlotKey(Landroid/content/SharedPreferences;)Z

    move-result v2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v2, :cond_0

    .line 1193
    monitor-exit v0

    return-void

    .line 1195
    :cond_0
    :try_start_1
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    .line 1196
    const-string v3, "compat_theme_fixed_keyboard"

    invoke-interface {v1, v3}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_1

    const-string v3, "compat_theme_fixed_additional"

    invoke-interface {v1, v3}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_2

    .line 1200
    :cond_1
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->resolveCurrentTheme(Landroid/content/Context;)[Ljava/lang/String;

    move-result-object v3

    .line 1201
    const-string v4, "compat_theme_fixed_keyboard"

    const/4 v5, 0x0

    aget-object v5, v3, v5

    invoke-static {v2, v1, v4, v5}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1202
    const-string v4, "compat_theme_fixed_additional"

    const/4 v5, 0x1

    aget-object v3, v3, v5

    invoke-static {v2, v1, v4, v3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1204
    :cond_2
    const v3, 0x7f110226

    invoke-virtual {p0, v3}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v3

    .line 1205
    const-string v4, "compat_theme_light_keyboard"

    invoke-static {v2, v1, v4, v3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1206
    const-string v4, "compat_theme_light_additional"

    const v5, 0x7f110225

    invoke-virtual {p0, v5}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v5

    invoke-static {v2, v1, v4, v5}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1207
    const-string v4, "compat_theme_dark_keyboard"

    invoke-static {v2, v1, v4, v3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1208
    const-string v4, "compat_theme_dark_additional"

    const v5, 0x7f110224

    invoke-virtual {p0, v5}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p0

    invoke-static {v2, v1, v4, p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1209
    const-string p0, "compat_theme_dynamic_keyboard"

    invoke-static {v2, v1, p0, v3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1210
    const-string p0, "compat_theme_dynamic_additional"

    const-string v3, "files:dynamic_theme.zip"

    invoke-static {v2, v1, p0, v3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1215
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->commit()Z
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 1216
    monitor-exit v0

    return-void

    .line 1190
    :catchall_0
    move-exception p0

    :try_start_2
    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw p0
.end method

.method private static hasEverySlotKey(Landroid/content/SharedPreferences;)Z
    .locals 1

    .line 1227
    const-string v0, "compat_theme_fixed_keyboard"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1228
    const-string v0, "compat_theme_fixed_additional"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1229
    const-string v0, "compat_theme_light_keyboard"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1230
    const-string v0, "compat_theme_light_additional"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1231
    const-string v0, "compat_theme_dark_keyboard"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1232
    const-string v0, "compat_theme_dark_additional"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1233
    const-string v0, "compat_theme_dynamic_keyboard"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1234
    const-string v0, "compat_theme_dynamic_additional"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    .line 1227
    :goto_0
    return p0
.end method

.method private static invalidatePreviewSnapshots(Landroid/content/Context;)V
    .locals 8

    .line 913
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->transientCacheDirectories(Landroid/content/Context;)[Ljava/io/File;

    move-result-object v0

    .line 914
    nop

    .line 915
    const/4 v1, 0x0

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_0
    array-length v4, v0

    if-ge v2, v4, :cond_3

    .line 916
    aget-object v4, v0, v2

    invoke-virtual {v4}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v4

    .line 917
    if-nez v4, :cond_0

    .line 918
    goto :goto_2

    .line 920
    :cond_0
    const/4 v5, 0x0

    :goto_1
    array-length v6, v4

    if-ge v5, v6, :cond_2

    .line 921
    aget-object v6, v4, v5

    invoke-virtual {v6}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v6

    .line 922
    const-string v7, "keyboardsnapshotcache_"

    invoke-virtual {v6, v7}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_1

    .line 923
    const-string v7, ".png"

    invoke-virtual {v6, v7}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_1

    aget-object v6, v4, v5

    .line 924
    invoke-virtual {v6}, Ljava/io/File;->delete()Z

    move-result v6

    if-eqz v6, :cond_1

    .line 925
    add-int/lit8 v3, v3, 0x1

    .line 920
    :cond_1
    add-int/lit8 v5, v5, 0x1

    goto :goto_1

    .line 915
    :cond_2
    :goto_2
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 929
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

    .line 930
    return-void
.end method

.method private static isDark(Landroid/content/res/Configuration;)Z
    .locals 1

    .line 1283
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

    .line 245
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->supportsDynamicColor()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 246
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

    .line 245
    :goto_0
    return v1
.end method

.method public static isEnabled(Landroid/content/Context;)Z
    .locals 2

    .line 223
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

    .line 1263
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

    .line 589
    const-string v0, "rebuilding InputView after automatic theme resolution"

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 590
    return-void
.end method

.method private static modeStem(Ljava/lang/String;Z)Ljava/lang/String;
    .locals 1

    .line 724
    const/16 v0, 0x7c

    invoke-virtual {p0, v0}, Ljava/lang/String;->indexOf(I)I

    move-result v0

    .line 725
    if-gez v0, :cond_0

    return-object p0

    .line 726
    :cond_0
    if-eqz p1, :cond_1

    add-int/lit8 v0, v0, 0x1

    invoke-virtual {p0, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_1
    const/4 p1, 0x0

    invoke-virtual {p0, p1, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    :goto_0
    return-object p0
.end method

.method private static preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .locals 2

    .line 1294
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 1295
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "_preferences"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1294
    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method public static prepareDynamicTheme(Landroid/content/Context;)Ljava/lang/String;
    .locals 2

    .line 283
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->supportsDynamicColor()Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 284
    return-object v1

    .line 286
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 287
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDark(Landroid/content/res/Configuration;)Z

    move-result v0

    .line 288
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->syncDynamicTheme(Landroid/content/Context;Z)I

    move-result p0

    if-nez p0, :cond_1

    .line 289
    return-object v1

    .line 291
    :cond_1
    const-string p0, "files:dynamic_theme.zip"

    return-object p0
.end method

.method private static pressedColor(II)I
    .locals 4

    .line 758
    nop

    .line 759
    const/high16 v0, -0x1000000

    const/4 v1, 0x0

    :goto_0
    const/16 v2, 0x10

    if-gt v1, v2, :cond_0

    .line 760
    ushr-int v2, p0, v1

    and-int/lit16 v2, v2, 0xff

    .line 761
    ushr-int v3, p1, v1

    and-int/lit16 v3, v3, 0xff

    .line 762
    mul-int/lit8 v2, v2, 0x9

    add-int/2addr v2, v3

    div-int/lit8 v2, v2, 0xa

    shl-int/2addr v2, v1

    or-int/2addr v0, v2

    .line 759
    add-int/lit8 v1, v1, 0x8

    goto :goto_0

    .line 764
    :cond_0
    return v0
.end method

.method private static putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    .line 1220
    invoke-interface {p1, p2}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result p1

    if-nez p1, :cond_0

    .line 1221
    invoke-interface {p0, p2, p3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 1223
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

    .line 1120
    new-instance v0, Ljava/util/zip/CRC32;

    invoke-direct {v0}, Ljava/util/zip/CRC32;-><init>()V

    .line 1121
    invoke-virtual {v0, p2}, Ljava/util/zip/CRC32;->update([B)V

    .line 1122
    new-instance v1, Ljava/util/zip/ZipEntry;

    invoke-direct {v1, p1}, Ljava/util/zip/ZipEntry;-><init>(Ljava/lang/String;)V

    .line 1123
    const/4 p1, 0x0

    invoke-virtual {v1, p1}, Ljava/util/zip/ZipEntry;->setMethod(I)V

    .line 1124
    array-length p1, p2

    int-to-long v2, p1

    invoke-virtual {v1, v2, v3}, Ljava/util/zip/ZipEntry;->setSize(J)V

    .line 1125
    array-length p1, p2

    int-to-long v2, p1

    invoke-virtual {v1, v2, v3}, Ljava/util/zip/ZipEntry;->setCompressedSize(J)V

    .line 1126
    invoke-virtual {v0}, Ljava/util/zip/CRC32;->getValue()J

    move-result-wide v2

    invoke-virtual {v1, v2, v3}, Ljava/util/zip/ZipEntry;->setCrc(J)V

    .line 1127
    invoke-virtual {p0, v1}, Ljava/util/zip/ZipOutputStream;->putNextEntry(Ljava/util/zip/ZipEntry;)V

    .line 1128
    invoke-virtual {p0, p2}, Ljava/util/zip/ZipOutputStream;->write([B)V

    .line 1129
    invoke-virtual {p0}, Ljava/util/zip/ZipOutputStream;->closeEntry()V

    .line 1130
    return-void
.end method

.method private static readVarint([BI[J)I
    .locals 7

    .line 1134
    nop

    .line 1135
    const-wide/16 v0, 0x0

    const/4 v2, 0x0

    const/4 v3, 0x0

    .line 1137
    :goto_0
    array-length v4, p0

    if-ge p1, v4, :cond_2

    const/16 v4, 0x3f

    if-le v3, v4, :cond_0

    goto :goto_1

    .line 1140
    :cond_0
    aget-byte v4, p0, p1

    and-int/lit16 v4, v4, 0xff

    .line 1141
    add-int/lit8 p1, p1, 0x1

    .line 1142
    and-int/lit8 v5, v4, 0x7f

    int-to-long v5, v5

    shl-long/2addr v5, v3

    or-long/2addr v0, v5

    .line 1143
    and-int/lit16 v4, v4, 0x80

    if-nez v4, :cond_1

    .line 1144
    nop

    .line 1148
    aput-wide v0, p2, v2

    .line 1149
    return p1

    .line 1146
    :cond_1
    add-int/lit8 v3, v3, 0x7

    .line 1147
    goto :goto_0

    .line 1138
    :cond_2
    :goto_1
    const/4 p0, -0x1

    return p0
.end method

.method public static reconcileCustomThemeEdit(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 11

    .line 381
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 382
    if-eqz p1, :cond_6

    invoke-virtual {p1}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;

    move-result-object v0

    if-nez v0, :cond_0

    goto :goto_2

    .line 385
    :cond_0
    invoke-virtual {p1}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;

    move-result-object p1

    const-string v0, "intent_extra_key_deleted_theme_file_name"

    invoke-virtual {p1, v0}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 386
    if-eqz p1, :cond_5

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    if-nez v0, :cond_1

    goto :goto_1

    .line 389
    :cond_1
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->resolveCurrentTheme(Landroid/content/Context;)[Ljava/lang/String;

    move-result-object v0

    .line 390
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    .line 391
    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 392
    nop

    .line 393
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

    .line 394
    const/4 v4, 0x0

    const/4 v7, 0x0

    :goto_0
    if-ge v4, v2, :cond_3

    .line 395
    aget-object v8, v3, v4

    .line 396
    invoke-static {v8}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->additionalKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    const-string v10, ""

    invoke-interface {p0, v9, v10}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    .line 397
    const-string v10, "files:user_theme_"

    invoke-virtual {v9, v10}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v10

    if-eqz v10, :cond_2

    invoke-virtual {v9, p1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v9

    if-eqz v9, :cond_2

    .line 398
    invoke-static {v8}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->baseKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    aget-object v9, v0, v5

    invoke-interface {v1, v7, v9}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 399
    invoke-static {v8}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->additionalKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    aget-object v8, v0, v6

    invoke-interface {v1, v7, v8}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 400
    const/4 v7, 0x1

    .line 394
    :cond_2
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 403
    :cond_3
    if-eqz v7, :cond_4

    .line 404
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 406
    :cond_4
    return-void

    .line 387
    :cond_5
    :goto_1
    return-void

    .line 383
    :cond_6
    :goto_2
    return-void
.end method

.method private static repointSlots(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V
    .locals 12

    .line 487
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 488
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 489
    nop

    .line 490
    const/4 v2, 0x3

    new-array v3, v2, [Ljava/lang/String;

    const-string v4, "light"

    const/4 v5, 0x0

    aput-object v4, v3, v5

    const/4 v4, 0x1

    const-string v6, "dark"

    aput-object v6, v3, v4

    const/4 v6, 0x2

    const-string v7, "fixed"

    aput-object v7, v3, v6

    .line 491
    const/4 v6, 0x0

    :goto_0
    const v8, 0x7f110226

    const-string v9, ""

    if-ge v5, v2, :cond_2

    .line 492
    aget-object v10, v3, v5

    .line 493
    invoke-static {v10}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->additionalKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    invoke-interface {v0, v11, v9}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {p1, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-nez v9, :cond_0

    .line 494
    goto :goto_2

    .line 496
    :cond_0
    invoke-static {v10}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->baseKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {p0, v8}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v8

    invoke-interface {v1, v6, v8}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 497
    nop

    .line 498
    invoke-static {v10}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->additionalKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    .line 499
    if-eqz p2, :cond_1

    move-object v8, p2

    goto :goto_1

    :cond_1
    invoke-static {p0, v10}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->defaultAdditional(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    .line 497
    :goto_1
    invoke-interface {v1, v6, v8}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 500
    const/4 v6, 0x1

    .line 491
    :goto_2
    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    .line 502
    :cond_2
    const v2, 0x7f11023a

    invoke-virtual {p0, v2}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v2

    .line 503
    invoke-interface {v0, v2, v9}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_4

    .line 504
    const p1, 0x7f110282

    invoke-virtual {p0, p1}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p1

    .line 505
    invoke-virtual {p0, v8}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v0

    .line 504
    invoke-interface {v1, p1, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 506
    nop

    .line 508
    if-eqz p2, :cond_3

    .line 509
    goto :goto_3

    .line 510
    :cond_3
    invoke-static {p0, v7}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->defaultAdditional(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    .line 506
    :goto_3
    invoke-interface {v1, v2, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 511
    goto :goto_4

    .line 503
    :cond_4
    move v4, v6

    .line 513
    :goto_4
    if-eqz v4, :cond_5

    .line 514
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 516
    :cond_5
    return-void
.end method

.method private static resolveCurrentTheme(Landroid/content/Context;)[Ljava/lang/String;
    .locals 8

    .line 1239
    const-string v0, "a"

    const/4 v1, 0x2

    const/4 v2, 0x1

    const/4 v3, 0x0

    :try_start_0
    const-string v4, "baq"

    invoke-static {v4}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v4

    .line 1240
    new-array v5, v2, [Ljava/lang/Class;

    const-class v6, Landroid/content/Context;

    aput-object v6, v5, v3

    invoke-virtual {v4, v0, v5}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v5

    .line 1241
    new-array v6, v2, [Ljava/lang/Object;

    aput-object p0, v6, v3

    const/4 v7, 0x0

    invoke-virtual {v5, v7, v6}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    .line 1242
    invoke-virtual {v4, v0}, Ljava/lang/Class;->getField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v0

    .line 1243
    const-string v6, "b"

    invoke-virtual {v4, v6}, Ljava/lang/Class;->getField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v4

    .line 1244
    nop

    .line 1245
    invoke-virtual {v0, v5}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 1246
    invoke-virtual {v4, v5}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    new-array v5, v1, [Ljava/lang/String;

    aput-object v0, v5, v3

    aput-object v4, v5, v2
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 1244
    return-object v5

    .line 1248
    :catch_0
    move-exception v0

    .line 1249
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 1250
    nop

    .line 1252
    const v4, 0x7f110282

    invoke-virtual {p0, v4}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v4

    .line 1253
    const v5, 0x7f110226

    invoke-virtual {p0, v5}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v5

    .line 1251
    invoke-interface {v0, v4, v5}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 1255
    const v5, 0x7f11023a

    invoke-virtual {p0, v5}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p0

    .line 1254
    const-string v5, ""

    invoke-interface {v0, p0, v5}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    new-array v0, v1, [Ljava/lang/String;

    aput-object v4, v0, v3

    aput-object p0, v0, v2

    .line 1250
    return-object v0
.end method

.method private static resolveDynamicColors(Landroid/content/Context;Z)Ljava/util/Map;
    .locals 9
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

    .line 731
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    .line 732
    sget-object v1, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_COLOR_ROLES:[[Ljava/lang/String;

    array-length v2, v1

    const/4 v3, 0x0

    const/4 v4, 0x0

    :goto_0
    if-ge v4, v2, :cond_3

    aget-object v5, v1, v4

    .line 733
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "system_"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    const/4 v8, 0x1

    aget-object v8, v5, v8

    invoke-static {v8, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->modeStem(Ljava/lang/String;Z)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    .line 734
    if-eqz p1, :cond_0

    const-string v8, "_dark"

    goto :goto_1

    :cond_0
    const-string v8, "_light"

    :goto_1
    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    .line 735
    invoke-static {p0, v6}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->systemColor(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v6

    .line 736
    if-nez v6, :cond_1

    .line 737
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    const/4 v7, 0x2

    aget-object v7, v5, v7

    invoke-static {v7, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->modeStem(Ljava/lang/String;Z)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {p0, v6}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->systemColor(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v6

    .line 739
    :cond_1
    if-nez v6, :cond_2

    const/4 p0, 0x0

    return-object p0

    .line 740
    :cond_2
    aget-object v5, v5, v3

    invoke-interface {v0, v5, v6}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 732
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 742
    :cond_3
    return-object v0
.end method

.method public static rewriteStyleSheetColors([BLjava/util/Map;)[B
    .locals 18
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([B",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Integer;",
            ">;)[B"
        }
    .end annotation

    .line 978
    move-object/from16 v0, p0

    move-object/from16 v1, p1

    const/4 v2, 0x0

    if-eqz v0, :cond_16

    if-nez v1, :cond_0

    move-object/from16 v16, v2

    goto/16 :goto_8

    .line 981
    :cond_0
    new-instance v3, Ljava/io/ByteArrayOutputStream;

    array-length v4, v0

    invoke-direct {v3, v4}, Ljava/io/ByteArrayOutputStream;-><init>(I)V

    .line 982
    new-instance v4, Ljava/util/HashSet;

    invoke-direct {v4}, Ljava/util/HashSet;-><init>()V

    .line 983
    array-length v5, v0

    .line 984
    const/4 v6, 0x0

    const/4 v7, 0x0

    .line 985
    :goto_0
    if-ge v7, v5, :cond_13

    .line 986
    aget-byte v8, v0, v7

    and-int/lit16 v8, v8, 0xff

    const/16 v9, 0x12

    if-eq v8, v9, :cond_1

    .line 987
    const/16 v17, 0x0

    goto/16 :goto_6

    .line 989
    :cond_1
    add-int/lit8 v7, v7, 0x1

    .line 990
    const/4 v8, 0x1

    new-array v10, v8, [J

    .line 991
    invoke-static {v0, v7, v10}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->readVarint([BI[J)I

    move-result v7

    .line 992
    if-gez v7, :cond_2

    .line 993
    return-object v2

    .line 995
    :cond_2
    nop

    .line 996
    aget-wide v11, v10, v6

    long-to-int v10, v11

    add-int/2addr v10, v7

    .line 997
    if-gt v10, v5, :cond_12

    if-ge v10, v7, :cond_3

    move-object/from16 v16, v2

    goto/16 :goto_5

    .line 1001
    :cond_3
    nop

    .line 1002
    nop

    .line 1003
    nop

    .line 1004
    nop

    .line 1006
    move-object v12, v2

    move v11, v7

    const/4 v13, 0x0

    const/4 v14, 0x0

    const/4 v15, 0x0

    .line 1007
    :goto_1
    if-ge v11, v10, :cond_e

    .line 1008
    move-object/from16 v16, v2

    aget-byte v2, v0, v11

    and-int/lit16 v2, v2, 0xff

    .line 1009
    add-int/lit8 v11, v11, 0x1

    .line 1010
    const/16 v17, 0x0

    const/16 v6, 0xa

    if-ne v2, v6, :cond_6

    .line 1011
    new-array v2, v8, [J

    .line 1012
    invoke-static {v0, v11, v2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->readVarint([BI[J)I

    move-result v6

    .line 1013
    if-gez v6, :cond_4

    .line 1014
    return-object v16

    .line 1016
    :cond_4
    aget-wide v11, v2, v17

    long-to-int v12, v11

    add-int/2addr v12, v6

    .line 1017
    if-le v12, v10, :cond_5

    .line 1018
    return-object v16

    .line 1020
    :cond_5
    new-instance v11, Ljava/lang/String;

    aget-wide v8, v2, v17

    long-to-int v2, v8

    sget-object v8, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v11, v0, v6, v2, v8}, Ljava/lang/String;-><init>([BIILjava/nio/charset/Charset;)V

    .line 1021
    nop

    .line 1022
    move v2, v12

    move-object v12, v11

    move v11, v2

    const/4 v2, 0x1

    goto :goto_2

    :cond_6
    const/16 v6, 0x12

    if-ne v2, v6, :cond_b

    .line 1023
    const/4 v2, 0x1

    new-array v6, v2, [J

    .line 1024
    invoke-static {v0, v11, v6}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->readVarint([BI[J)I

    move-result v2

    .line 1025
    if-gez v2, :cond_7

    .line 1026
    return-object v16

    .line 1028
    :cond_7
    aget-wide v8, v6, v17

    long-to-int v6, v8

    add-int/2addr v6, v2

    .line 1029
    if-le v6, v10, :cond_8

    .line 1030
    return-object v16

    .line 1032
    :cond_8
    if-ge v2, v6, :cond_a

    aget-byte v8, v0, v2

    and-int/lit16 v8, v8, 0xff

    const/16 v9, 0x8

    if-ne v8, v9, :cond_a

    .line 1033
    const/4 v8, 0x1

    new-array v9, v8, [J

    .line 1034
    add-int/lit8 v2, v2, 0x1

    invoke-static {v0, v2, v9}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->readVarint([BI[J)I

    move-result v2

    if-gez v2, :cond_9

    .line 1035
    return-object v16

    .line 1037
    :cond_9
    const/4 v13, 0x1

    .line 1039
    :cond_a
    nop

    .line 1040
    move v11, v6

    const/4 v2, 0x1

    goto :goto_2

    :cond_b
    const/16 v6, 0x1a

    if-ne v2, v6, :cond_d

    .line 1041
    const/4 v2, 0x1

    new-array v6, v2, [J

    .line 1042
    invoke-static {v0, v11, v6}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->readVarint([BI[J)I

    move-result v8

    .line 1043
    if-gez v8, :cond_c

    .line 1044
    return-object v16

    .line 1046
    :cond_c
    aget-wide v14, v6, v17

    long-to-int v15, v14

    .line 1047
    nop

    .line 1048
    move v11, v8

    const/4 v14, 0x1

    goto :goto_2

    .line 1049
    :cond_d
    const/4 v2, 0x1

    move v11, v10

    .line 1051
    :goto_2
    move-object/from16 v2, v16

    const/4 v6, 0x0

    const/4 v8, 0x1

    const/16 v9, 0x12

    goto :goto_1

    .line 1053
    :cond_e
    move-object/from16 v16, v2

    const/16 v17, 0x0

    if-eqz v12, :cond_f

    invoke-interface {v4, v12}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 1054
    :cond_f
    if-nez v12, :cond_10

    move-object/from16 v2, v16

    goto :goto_3

    :cond_10
    invoke-interface {v1, v12}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Integer;

    .line 1055
    :goto_3
    if-eqz v2, :cond_11

    if-eqz v13, :cond_11

    .line 1056
    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    invoke-static {v3, v12, v2, v14, v15}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeColorRule(Ljava/io/ByteArrayOutputStream;Ljava/lang/String;IZI)V

    goto :goto_4

    .line 1058
    :cond_11
    sub-int v2, v10, v7

    .line 1059
    const/16 v6, 0x12

    invoke-virtual {v3, v6}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 1060
    int-to-long v8, v2

    invoke-static {v3, v8, v9}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeVarint(Ljava/io/ByteArrayOutputStream;J)V

    .line 1061
    invoke-virtual {v3, v0, v7, v2}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    .line 1063
    :goto_4
    nop

    .line 1064
    move v7, v10

    move-object/from16 v2, v16

    const/4 v6, 0x0

    goto/16 :goto_0

    .line 997
    :cond_12
    move-object/from16 v16, v2

    .line 998
    :goto_5
    return-object v16

    .line 985
    :cond_13
    const/16 v17, 0x0

    .line 1068
    :goto_6
    new-instance v0, Ljava/util/TreeMap;

    invoke-direct {v0, v1}, Ljava/util/TreeMap;-><init>(Ljava/util/Map;)V

    invoke-virtual {v0}, Ljava/util/TreeMap;->entrySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_7
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_15

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map$Entry;

    .line 1069
    invoke-interface {v1}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v2

    invoke-interface {v4, v2}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_14

    goto :goto_7

    .line 1070
    :cond_14
    invoke-interface {v1}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    invoke-interface {v1}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    const/4 v5, 0x0

    invoke-static {v3, v2, v1, v5, v5}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeColorRule(Ljava/io/ByteArrayOutputStream;Ljava/lang/String;IZI)V

    .line 1071
    const/16 v17, 0x0

    goto :goto_7

    .line 1072
    :cond_15
    invoke-virtual {v3}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v0

    return-object v0

    .line 978
    :cond_16
    move-object/from16 v16, v2

    .line 979
    :goto_8
    return-object v16
.end method

.method public static setDynamicEnabled(Landroid/content/Context;Z)V
    .locals 2

    .line 258
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 259
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 260
    const-string v1, "compat_system_dynamic_color_theme"

    if-eqz p1, :cond_0

    .line 261
    const/4 p1, 0x1

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    const-string v1, "compat_system_auto_keyboard_theme"

    invoke-interface {p1, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    goto :goto_0

    .line 263
    :cond_0
    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 265
    :goto_0
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 266
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z

    .line 267
    return-void
.end method

.method public static setEnabled(Landroid/content/Context;Z)V
    .locals 2

    .line 227
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 228
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 229
    const-string v1, "compat_system_auto_keyboard_theme"

    if-eqz p1, :cond_0

    .line 231
    const/4 p1, 0x1

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    const-string v1, "compat_system_dynamic_color_theme"

    invoke-interface {p1, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    goto :goto_0

    .line 233
    :cond_0
    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 235
    :goto_0
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 236
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z

    .line 237
    return-void
.end method

.method public static supportsDynamicColor()Z
    .locals 2

    .line 241
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

    .line 662
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->resolveDynamicColors(Landroid/content/Context;Z)Ljava/util/Map;

    move-result-object v0

    .line 663
    if-nez v0, :cond_0

    .line 664
    const-string p1, "system palette unavailable, retaining the ordinary theme"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 665
    const/4 p0, 0x0

    return p0

    .line 667
    :cond_0
    invoke-static {p1, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->dynamicSignature(ZLjava/util/Map;)Ljava/lang/String;

    move-result-object v1

    .line 668
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v2

    .line 669
    new-instance v3, Ljava/io/File;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v4

    const-string v5, "dynamic_theme.zip"

    invoke-direct {v3, v4, v5}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 670
    invoke-virtual {v3}, Ljava/io/File;->isFile()Z

    move-result v4

    const-string v5, "compat_theme_dynamic_signature"

    if-eqz v4, :cond_1

    .line 671
    const/4 v4, 0x0

    invoke-interface {v2, v5, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v1, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1

    .line 672
    const-string p1, "dynamic palette unchanged"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 673
    const/4 p0, 0x1

    return p0

    .line 675
    :cond_1
    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->buildDynamicThemePackage(Landroid/content/Context;ZLjava/util/Map;)Z

    move-result p1

    if-nez p1, :cond_2

    .line 676
    const-string p1, "dynamic theme package build failed"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 677
    invoke-virtual {v3}, Ljava/io/File;->isFile()Z

    move-result p0

    return p0

    .line 679
    :cond_2
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1, v5, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 685
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->invalidatePreviewSnapshots(Landroid/content/Context;)V

    .line 686
    const-string p1, "dynamic theme package rebuilt"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 687
    const/4 p0, 0x2

    return p0
.end method

.method private static systemColor(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/Integer;
    .locals 3

    .line 746
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    .line 747
    const-string v1, "color"

    const-string v2, "android"

    invoke-virtual {v0, p1, v1, v2}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result p1

    .line 748
    const/4 v1, 0x0

    if-nez p1, :cond_0

    return-object v1

    .line 750
    :cond_0
    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getTheme()Landroid/content/res/Resources$Theme;

    move-result-object p0

    invoke-virtual {v0, p1, p0}, Landroid/content/res/Resources;->getColor(ILandroid/content/res/Resources$Theme;)I

    move-result p0

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0
    :try_end_0
    .catch Landroid/content/res/Resources$NotFoundException; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    .line 751
    :catch_0
    move-exception p0

    .line 752
    return-object v1
.end method

.method private static templateBytes(Landroid/content/Context;Ljava/lang/String;)[B
    .locals 4

    .line 1100
    nop

    .line 1102
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

    .line 1103
    :try_start_1
    new-instance p1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {p1}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 1104
    const/16 v1, 0x1000

    new-array v1, v1, [B

    .line 1106
    :goto_0
    invoke-virtual {p0, v1}, Ljava/io/InputStream;->read([B)I

    move-result v2

    if-lez v2, :cond_0

    .line 1107
    const/4 v3, 0x0

    invoke-virtual {p1, v1, v3, v2}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_0

    .line 1109
    :cond_0
    invoke-virtual {p1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p1
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 1113
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->closeQuietly(Ljava/io/Closeable;)V

    .line 1109
    return-object p1

    .line 1113
    :catchall_0
    move-exception p1

    move-object v0, p0

    goto :goto_1

    .line 1110
    :catch_0
    move-exception p1

    goto :goto_2

    .line 1113
    :catchall_1
    move-exception p1

    :goto_1
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->closeQuietly(Ljava/io/Closeable;)V

    .line 1114
    throw p1

    .line 1110
    :catch_1
    move-exception p0

    move-object p0, v0

    .line 1111
    :goto_2
    nop

    .line 1113
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->closeQuietly(Ljava/io/Closeable;)V

    .line 1111
    return-object v0
.end method

.method private static transientCacheDirectories(Landroid/content/Context;)[Ljava/io/File;
    .locals 4

    .line 946
    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object p0

    .line 947
    if-nez p0, :cond_0

    .line 948
    const/4 p0, 0x0

    new-array p0, p0, [Ljava/io/File;

    return-object p0

    .line 950
    :cond_0
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 951
    invoke-interface {v0, p0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 952
    invoke-virtual {p0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object p0

    .line 953
    const-string v1, "/user/"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 954
    new-instance v2, Ljava/io/File;

    const-string v3, "/user_de/"

    invoke-virtual {p0, v1, v3}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    invoke-direct {v2, p0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 956
    :cond_1
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result p0

    new-array p0, p0, [Ljava/io/File;

    invoke-interface {v0, p0}, Ljava/util/List;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object p0

    check-cast p0, [Ljava/io/File;

    return-object p0
.end method

.method private static usesDynamicThemePackage(Landroid/content/Context;)Z
    .locals 2

    .line 768
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDynamicEnabled(Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :cond_0

    const/4 p0, 0x0

    return p0

    .line 769
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 770
    const v1, 0x7f11023a

    invoke-virtual {p0, v1}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p0

    .line 769
    const/4 v1, 0x0

    invoke-interface {v0, p0, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 771
    const-string v0, "files:dynamic_theme.zip"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method private static writeColorRule(Ljava/io/ByteArrayOutputStream;Ljava/lang/String;IZI)V
    .locals 7

    .line 1077
    sget-object v0, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p1, v0}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p1

    .line 1078
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 1079
    const/16 v1, 0x8

    invoke-virtual {v0, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 1080
    int-to-long v1, p2

    const-wide v3, 0xffffffffL

    and-long/2addr v1, v3

    invoke-static {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeVarint(Ljava/io/ByteArrayOutputStream;J)V

    .line 1081
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p2

    .line 1082
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 1083
    const/16 v1, 0xa

    invoke-virtual {v0, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 1084
    array-length v1, p1

    int-to-long v1, v1

    invoke-static {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeVarint(Ljava/io/ByteArrayOutputStream;J)V

    .line 1085
    array-length v1, p1

    const/4 v2, 0x0

    invoke-virtual {v0, p1, v2, v1}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    .line 1086
    const/16 p1, 0x12

    invoke-virtual {v0, p1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 1087
    array-length v1, p2

    int-to-long v5, v1

    invoke-static {v0, v5, v6}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeVarint(Ljava/io/ByteArrayOutputStream;J)V

    .line 1088
    array-length v1, p2

    invoke-virtual {v0, p2, v2, v1}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    .line 1089
    if-eqz p3, :cond_0

    .line 1090
    const/16 p2, 0x1a

    invoke-virtual {v0, p2}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 1091
    int-to-long p2, p4

    and-long/2addr p2, v3

    invoke-static {v0, p2, p3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeVarint(Ljava/io/ByteArrayOutputStream;J)V

    .line 1093
    :cond_0
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p2

    .line 1094
    invoke-virtual {p0, p1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 1095
    array-length p1, p2

    int-to-long p3, p1

    invoke-static {p0, p3, p4}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeVarint(Ljava/io/ByteArrayOutputStream;J)V

    .line 1096
    array-length p1, p2

    invoke-virtual {p0, p2, v2, p1}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    .line 1097
    return-void
.end method

.method private static writeSlot(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 6

    .line 624
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 625
    const v1, 0x7f110282

    invoke-virtual {p0, v1}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v1

    .line 626
    const v2, 0x7f11023a

    invoke-virtual {p0, v2}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v2

    .line 627
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->baseKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    const-string v4, ""

    invoke-interface {v0, v3, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 628
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->additionalKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-interface {v0, p1, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 629
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 630
    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z

    move-result p2

    const/4 v4, 0x0

    if-nez p2, :cond_3

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result p2

    if-eqz p2, :cond_0

    goto :goto_1

    .line 638
    :cond_0
    const/4 p2, 0x0

    invoke-interface {v0, v1, p2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v3, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_1

    .line 639
    invoke-interface {v0, v2, p2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_1

    .line 640
    const-string p1, "legacy theme pair already resolved"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 641
    return v4

    .line 643
    :cond_1
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 644
    invoke-interface {p2, v1, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 645
    invoke-interface {p2, v2, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 646
    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    move-result p1

    .line 647
    if-eqz p1, :cond_2

    const-string p2, "legacy theme pair committed"

    goto :goto_0

    :cond_2
    const-string p2, "theme commit failed"

    :goto_0
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 648
    return p1

    .line 635
    :cond_3
    :goto_1
    const-string p1, "theme slot is empty, keeping the current theme"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 636
    return v4
.end method

.method private static writeVarint(Ljava/io/ByteArrayOutputStream;J)V
    .locals 4

    .line 1154
    nop

    :goto_0
    const-wide/16 v0, 0x7f

    and-long/2addr v0, p1

    long-to-int v1, v0

    .line 1155
    const/4 v0, 0x7

    ushr-long/2addr p1, v0

    .line 1156
    const-wide/16 v2, 0x0

    cmp-long v0, p1, v2

    if-eqz v0, :cond_0

    .line 1157
    or-int/lit16 v0, v1, 0x80

    invoke-virtual {p0, v0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 1162
    goto :goto_0

    .line 1159
    :cond_0
    invoke-virtual {p0, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 1160
    return-void
.end method
