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

.field private static final DYNAMIC_PALETTE_REVISION:I = 0x5

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
    const/16 v4, 0x18

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

    const-string v10, "color_access_points_menu_background"

    aput-object v10, v8, v3

    aput-object v13, v8, v5

    aput-object v8, v4, v7

    new-array v7, v6, [Ljava/lang/String;

    const-string v8, "color_access_point_panel_item_background"

    aput-object v8, v7, v3

    aput-object v13, v7, v5

    aput-object v7, v4, v9

    new-array v7, v6, [Ljava/lang/String;

    const-string v8, "color_label"

    aput-object v8, v7, v3

    aput-object v15, v7, v5

    aput-object v7, v4, v11

    new-array v7, v6, [Ljava/lang/String;

    const-string v8, "color_label_header_active"

    aput-object v8, v7, v3

    aput-object v15, v7, v5

    aput-object v7, v4, v12

    new-array v7, v6, [Ljava/lang/String;

    const-string v8, "color_popup_label"

    aput-object v8, v7, v3

    aput-object v15, v7, v5

    aput-object v7, v4, v14

    new-array v7, v6, [Ljava/lang/String;

    const-string v8, "color_icon"

    aput-object v8, v7, v3

    aput-object v15, v7, v5

    aput-object v7, v4, v1

    new-array v1, v6, [Ljava/lang/String;

    const-string v7, "color_label_function_key"

    aput-object v7, v1, v3

    aput-object v15, v1, v5

    const/16 v7, 0x9

    aput-object v1, v4, v7

    new-array v1, v6, [Ljava/lang/String;

    const-string v7, "color_label_space_key"

    aput-object v7, v1, v3

    aput-object v15, v1, v5

    aput-object v1, v4, v0

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_icon_action"

    aput-object v1, v0, v3

    const-string v1, "on_function"

    aput-object v1, v0, v5

    aput-object v0, v4, v2

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_state_action"

    aput-object v1, v0, v3

    aput-object v16, v0, v5

    const/16 v1, 0xc

    aput-object v0, v4, v1

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_action_default"

    aput-object v1, v0, v3

    aput-object v17, v0, v5

    const/16 v1, 0xd

    aput-object v0, v4, v1

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_label_dynamic"

    aput-object v1, v0, v3

    aput-object v17, v0, v5

    const/16 v1, 0xe

    aput-object v0, v4, v1

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_keyboard_editing_button"

    aput-object v1, v0, v3

    aput-object v17, v0, v5

    const/16 v1, 0xf

    aput-object v0, v4, v1

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_keyboard_editing_button_background"

    aput-object v1, v0, v3

    aput-object v18, v0, v5

    const/16 v1, 0x10

    aput-object v0, v4, v1

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_key_paging_scrollbar"

    aput-object v1, v0, v3

    aput-object v17, v0, v5

    const/16 v1, 0x11

    aput-object v0, v4, v1

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_notice_text"

    aput-object v1, v0, v3

    aput-object v17, v0, v5

    const/16 v1, 0x12

    aput-object v0, v4, v1

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_state_popup_item_pressed"

    aput-object v1, v0, v3

    aput-object v18, v0, v5

    const/16 v1, 0x13

    aput-object v0, v4, v1

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_generic_extension_background_activated"

    aput-object v1, v0, v3

    aput-object v16, v0, v5

    const/16 v1, 0x14

    aput-object v0, v4, v1

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_keyboard_separator"

    aput-object v1, v0, v3

    const-string v1, "outline"

    aput-object v1, v0, v5

    const/16 v1, 0x15

    aput-object v0, v4, v1

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_state_border_key_action"

    aput-object v1, v0, v3

    aput-object v16, v0, v5

    const/16 v1, 0x16

    aput-object v0, v4, v1

    new-array v0, v6, [Ljava/lang/String;

    const-string v1, "color_state_space_bar"

    aput-object v1, v0, v3

    const-string v1, "letter"

    aput-object v1, v0, v5

    const/16 v1, 0x17

    aput-object v0, v4, v1

    sput-object v4, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_STYLE_ROLES:[[Ljava/lang/String;

    .line 219
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

    .line 221
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static additionalKey(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 1269
    const-string v0, "light"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string p0, "compat_theme_light_additional"

    return-object p0

    .line 1270
    :cond_0
    const-string v0, "dark"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    const-string p0, "compat_theme_dark_additional"

    return-object p0

    .line 1271
    :cond_1
    const-string v0, "fixed"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    const-string p0, "compat_theme_fixed_additional"

    return-object p0

    .line 1272
    :cond_2
    const-string v0, "dynamic"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_3

    const-string p0, "compat_theme_dynamic_additional"

    return-object p0

    .line 1273
    :cond_3
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "Unknown theme slot"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z
    .locals 2

    .line 594
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDynamicEnabled(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_4

    .line 595
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDark(Landroid/content/res/Configuration;)Z

    move-result v0

    .line 596
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->syncDynamicTheme(Landroid/content/Context;Z)I

    move-result v1

    .line 597
    if-eqz v1, :cond_3

    .line 598
    nop

    .line 601
    if-eqz v0, :cond_0

    const-string p1, "resolved target=dynamic-dark"

    goto :goto_0

    :cond_0
    const-string p1, "resolved target=dynamic-light"

    .line 598
    :goto_0
    const-string v0, "dynamic"

    invoke-static {p0, v0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeSlot(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    .line 605
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

    .line 612
    :cond_3
    const-string v0, "dynamic package unavailable, resolving the legacy pair"

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 614
    :cond_4
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isEnabled(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_7

    .line 615
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDark(Landroid/content/res/Configuration;)Z

    move-result p1

    .line 616
    nop

    .line 618
    if-eqz p1, :cond_5

    const-string v0, "dark"

    goto :goto_3

    :cond_5
    const-string v0, "light"

    .line 619
    :goto_3
    if-eqz p1, :cond_6

    const-string p1, "resolved target=dark"

    goto :goto_4

    :cond_6
    const-string p1, "resolved target=light"

    .line 616
    :goto_4
    invoke-static {p0, v0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeSlot(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0

    .line 621
    :cond_7
    const-string p1, "fixed"

    const-string v0, "resolved target=fixed"

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeSlot(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public static applyCustomThemeEditResult(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 3

    .line 459
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 460
    if-eqz p1, :cond_5

    invoke-virtual {p1}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;

    move-result-object v0

    if-nez v0, :cond_0

    goto :goto_3

    .line 463
    :cond_0
    invoke-virtual {p1}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;

    move-result-object v0

    const-string v1, "intent_extra_key_deleted_theme_file_name"

    invoke-virtual {v0, v1}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 464
    if-eqz v0, :cond_4

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-nez v1, :cond_1

    goto :goto_2

    .line 467
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

    .line 468
    invoke-virtual {p1}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;

    move-result-object p1

    const-string v1, "intent_extra_key_new_theme_file_name"

    invoke-virtual {p1, v1}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 469
    nop

    .line 472
    if-eqz p1, :cond_3

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v1

    if-nez v1, :cond_2

    goto :goto_0

    .line 474
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

    .line 473
    :cond_3
    :goto_0
    const/4 p1, 0x0

    .line 469
    :goto_1
    invoke-static {p0, v0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->repointSlots(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 475
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z

    .line 476
    return-void

    .line 465
    :cond_4
    :goto_2
    return-void

    .line 461
    :cond_5
    :goto_3
    return-void
.end method

.method public static declared-synchronized applyDynamicFunctionIcon(Landroid/content/Context;ILandroid/widget/ImageView;)V
    .locals 12

    const-class v1, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;

    monitor-enter v1

    .line 693
    :try_start_0
    invoke-virtual {p2}, Landroid/widget/ImageView;->getId()I

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const v2, 0x7f0f0057

    if-eq v0, v2, :cond_0

    monitor-exit v1

    return-void

    .line 694
    :cond_0
    nop

    .line 695
    :try_start_1
    sget-object v0, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_FUNCTION_KEYS:[I

    array-length v2, v0

    const/4 v3, 0x0

    const/4 v4, 0x0

    :goto_0
    if-ge v4, v2, :cond_2

    aget v5, v0, v4

    .line 696
    if-ne p1, v5, :cond_1

    const/4 p1, 0x1

    goto :goto_1

    .line 695
    :cond_1
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    :cond_2
    const/4 p1, 0x0

    .line 698
    :goto_1
    if-eqz p1, :cond_a

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDynamicEnabled(Landroid/content/Context;)Z

    move-result p1

    if-nez p1, :cond_3

    goto/16 :goto_4

    .line 699
    :cond_3
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p1

    const v0, 0x7f11023a

    invoke-virtual {p0, v0}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p0

    const/4 v0, 0x0

    invoke-interface {p1, p0, v0}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 700
    const-string p1, "files:dynamic_theme.zip"

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    if-nez p0, :cond_4

    monitor-exit v1

    return-void

    .line 701
    :cond_4
    :try_start_2
    invoke-virtual {p2}, Landroid/widget/ImageView;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object p0

    .line 702
    instance-of p1, p0, Landroid/graphics/drawable/BitmapDrawable;
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    if-nez p1, :cond_5

    monitor-exit v1

    return-void

    .line 703
    :cond_5
    :try_start_3
    move-object p1, p0

    check-cast p1, Landroid/graphics/drawable/BitmapDrawable;

    invoke-virtual {p1}, Landroid/graphics/drawable/BitmapDrawable;->getBitmap()Landroid/graphics/Bitmap;

    move-result-object v4

    .line 704
    sget-object p1, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_ICON_MASKS:Ljava/util/Map;

    invoke-interface {p1, v4}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/graphics/Bitmap;

    .line 705
    if-nez p1, :cond_9

    .line 706
    invoke-virtual {v4}, Landroid/graphics/Bitmap;->getWidth()I

    move-result v7

    .line 707
    invoke-virtual {v4}, Landroid/graphics/Bitmap;->getHeight()I

    move-result v11

    .line 708
    mul-int p1, v7, v11

    new-array v5, p1, [I

    .line 709
    const/4 v8, 0x0

    const/4 v9, 0x0

    const/4 v6, 0x0

    move v10, v7

    invoke-virtual/range {v4 .. v11}, Landroid/graphics/Bitmap;->getPixels([IIIIIII)V

    .line 710
    nop

    .line 711
    const/4 v0, 0x0

    const/4 v2, 0x0

    :goto_2
    if-ge v0, p1, :cond_6

    aget v6, v5, v0

    ushr-int/lit8 v6, v6, 0x18

    invoke-static {v2, v6}, Ljava/lang/Math;->max(II)I

    move-result v2
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    add-int/lit8 v0, v0, 0x1

    goto :goto_2

    .line 712
    :cond_6
    const/16 v0, 0x99

    if-eq v2, v0, :cond_7

    monitor-exit v1

    return-void

    .line 713
    :cond_7
    nop

    :goto_3
    if-ge v3, p1, :cond_8

    .line 714
    :try_start_4
    aget v2, v5, v3

    ushr-int/lit8 v2, v2, 0x18

    mul-int/lit16 v2, v2, 0xff

    div-int/2addr v2, v0

    .line 715
    aget v6, v5, v3

    const v8, 0xffffff

    and-int/2addr v6, v8

    shl-int/lit8 v2, v2, 0x18

    or-int/2addr v2, v6

    aput v2, v5, v3

    .line 713
    add-int/lit8 v3, v3, 0x1

    goto :goto_3

    .line 717
    :cond_8
    sget-object p1, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v5, v7, v11, p1}, Landroid/graphics/Bitmap;->createBitmap([IIILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object p1

    .line 718
    invoke-virtual {v4}, Landroid/graphics/Bitmap;->getDensity()I

    move-result v0

    invoke-virtual {p1, v0}, Landroid/graphics/Bitmap;->setDensity(I)V

    .line 719
    sget-object v0, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_ICON_MASKS:Ljava/util/Map;

    invoke-interface {v0, v4, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 721
    :cond_9
    invoke-virtual {p2, p1}, Landroid/widget/ImageView;->setImageBitmap(Landroid/graphics/Bitmap;)V

    .line 722
    invoke-virtual {p2}, Landroid/widget/ImageView;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object p1

    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getColorFilter()Landroid/graphics/ColorFilter;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/graphics/drawable/Drawable;->setColorFilter(Landroid/graphics/ColorFilter;)V

    .line 723
    invoke-virtual {p2}, Landroid/widget/ImageView;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object p1

    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getAlpha()I

    move-result p0

    invoke-virtual {p1, p0}, Landroid/graphics/drawable/Drawable;->setAlpha(I)V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    .line 724
    monitor-exit v1

    return-void

    .line 698
    :cond_a
    :goto_4
    monitor-exit v1

    return-void

    .line 692
    :catchall_0
    move-exception v0

    move-object p0, v0

    :try_start_5
    monitor-exit v1
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_0

    goto :goto_6

    :goto_5
    throw p0

    :goto_6
    goto :goto_5
.end method

.method public static applyIfEnabled(Landroid/content/Context;Landroid/content/res/Configuration;)Z
    .locals 2

    .line 553
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

    .line 554
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 559
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDynamicEnabled(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 560
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z

    move-result p0

    return p0

    .line 562
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isEnabled(Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :cond_1

    .line 563
    const/4 p0, 0x0

    return p0

    .line 565
    :cond_1
    nop

    .line 567
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDark(Landroid/content/res/Configuration;)Z

    move-result v0

    if-eqz v0, :cond_2

    const-string v0, "dark"

    goto :goto_0

    :cond_2
    const-string v0, "light"

    .line 568
    :goto_0
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDark(Landroid/content/res/Configuration;)Z

    move-result p1

    if-eqz p1, :cond_3

    const-string p1, "resolved target=dark"

    goto :goto_1

    :cond_3
    const-string p1, "resolved target=light"

    .line 565
    :goto_1
    invoke-static {p0, v0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeSlot(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public static applyOnCreate(Landroid/content/Context;)Z
    .locals 1

    .line 548
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 549
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

    .line 581
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDynamicEnabled(Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 582
    const/4 p0, 0x0

    return p0

    .line 584
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 585
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

    .line 329
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 330
    if-eqz p1, :cond_0

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    if-eqz v0, :cond_0

    .line 333
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->disable(Landroid/content/Context;)V

    .line 334
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 335
    const v1, 0x7f11023a

    invoke-virtual {p0, v1}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v1

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 336
    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 337
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->captureFixedTheme(Landroid/content/Context;)V

    .line 338
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z

    .line 339
    return-void

    .line 331
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Empty theme value"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public static assignSlot(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    .line 353
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 354
    if-eqz p2, :cond_2

    invoke-virtual {p2}, Ljava/lang/String;->length()I

    move-result v0

    if-eqz v0, :cond_2

    .line 357
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isEnabled(Landroid/content/Context;)Z

    move-result v0

    .line 358
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isSelectableSlot(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 359
    const-string v1, "fixed"

    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    if-nez v0, :cond_1

    goto :goto_0

    :cond_0
    if-eqz v0, :cond_1

    .line 362
    :goto_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 363
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->additionalKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-interface {v0, p1, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 364
    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 365
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z

    .line 366
    return-void

    .line 360
    :cond_1
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string p1, "Theme slot is disabled"

    invoke-direct {p0, p1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 355
    :cond_2
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Empty theme value"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static baseKey(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 1261
    const-string v0, "light"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string p0, "compat_theme_light_keyboard"

    return-object p0

    .line 1262
    :cond_0
    const-string v0, "dark"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    const-string p0, "compat_theme_dark_keyboard"

    return-object p0

    .line 1263
    :cond_1
    const-string v0, "fixed"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    const-string p0, "compat_theme_fixed_keyboard"

    return-object p0

    .line 1264
    :cond_2
    const-string v0, "dynamic"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_3

    const-string p0, "compat_theme_dynamic_keyboard"

    return-object p0

    .line 1265
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

    .line 820
    if-eqz p1, :cond_0

    const-string v0, "dark"

    goto :goto_0

    :cond_0
    const-string v0, "light"

    .line 821
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

    .line 822
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

    .line 823
    const/4 v4, 0x0

    invoke-static {p2, p1, v4}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->dynamicStyleColors(Ljava/util/Map;ZZ)Ljava/util/Map;

    move-result-object v5

    .line 824
    const/4 v6, 0x1

    invoke-static {p2, p1, v6}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->dynamicStyleColors(Ljava/util/Map;ZZ)Ljava/util/Map;

    move-result-object p2

    .line 825
    if-eqz p1, :cond_1

    sget-object p1, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_ENTRIES_DARK:[Ljava/lang/String;

    goto :goto_1

    :cond_1
    sget-object p1, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_ENTRIES_LIGHT:[Ljava/lang/String;

    .line 826
    :goto_1
    array-length v7, p1

    new-array v7, v7, [[B

    .line 827
    const/4 v8, 0x0

    :goto_2
    array-length v9, p1

    if-ge v8, v9, :cond_6

    .line 828
    aget-object v9, p1, v8

    .line 829
    invoke-static {p0, v9}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->templateBytes(Landroid/content/Context;Ljava/lang/String;)[B

    move-result-object v10

    .line 830
    if-nez v10, :cond_2

    .line 831
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

    .line 832
    return v4

    .line 834
    :cond_2
    invoke-virtual {v1, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v11

    if-eqz v11, :cond_3

    .line 835
    invoke-static {v10, v5}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->rewriteStyleSheetColors([BLjava/util/Map;)[B

    move-result-object v10

    goto :goto_3

    .line 836
    :cond_3
    invoke-virtual {v2, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v11

    if-eqz v11, :cond_4

    .line 837
    invoke-static {v10, p2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->rewriteStyleSheetColors([BLjava/util/Map;)[B

    move-result-object v10

    .line 839
    :cond_4
    :goto_3
    if-nez v10, :cond_5

    .line 840
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

    .line 841
    return v4

    .line 843
    :cond_5
    aput-object v10, v7, v8

    .line 827
    add-int/lit8 v8, v8, 0x1

    goto :goto_2

    .line 845
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

    .line 846
    if-nez p2, :cond_7

    .line 847
    const-string p1, "dynamic template missing: metadata"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 848
    return v4

    .line 850
    :cond_7
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    array-length v1, p2

    add-int/lit8 v1, v1, 0x2

    invoke-direct {v0, v1}, Ljava/io/ByteArrayOutputStream;-><init>(I)V

    .line 851
    const/16 v1, 0x8

    invoke-virtual {v0, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 852
    const/4 v1, 0x3

    invoke-virtual {v0, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 853
    array-length v1, p2

    invoke-virtual {v0, p2, v4, v1}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    .line 854
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p2

    .line 856
    new-instance v0, Ljava/io/File;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v1

    const-string v2, "dynamic_theme.zip"

    invoke-direct {v0, v1, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 857
    new-instance v1, Ljava/io/File;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v2

    const-string v3, "dynamic_theme.tmp"

    invoke-direct {v1, v2, v3}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 858
    nop

    .line 860
    const/4 v2, 0x0

    :try_start_0
    new-instance v3, Ljava/util/zip/ZipOutputStream;

    new-instance v5, Ljava/io/FileOutputStream;

    invoke-direct {v5, v1}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    invoke-direct {v3, v5}, Ljava/util/zip/ZipOutputStream;-><init>(Ljava/io/OutputStream;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1

    .line 861
    :try_start_1
    const-string v2, "metadata.binarypb"

    invoke-static {v3, v2, p2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putStoredEntry(Ljava/util/zip/ZipOutputStream;Ljava/lang/String;[B)V

    .line 862
    const/4 p2, 0x0

    :goto_4
    array-length v2, p1

    if-ge p2, v2, :cond_8

    .line 863
    aget-object v2, p1, p2

    aget-object v5, v7, p2

    invoke-static {v3, v2, v5}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putStoredEntry(Ljava/util/zip/ZipOutputStream;Ljava/lang/String;[B)V

    .line 862
    add-int/lit8 p2, p2, 0x1

    goto :goto_4

    .line 867
    :cond_8
    invoke-virtual {v3}, Ljava/util/zip/ZipOutputStream;->close()V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0

    .line 873
    nop

    .line 875
    invoke-virtual {v1, v0}, Ljava/io/File;->renameTo(Ljava/io/File;)Z

    move-result p1

    if-nez p1, :cond_9

    .line 878
    invoke-virtual {v1}, Ljava/io/File;->delete()Z

    .line 879
    const-string p1, "dynamic theme package replace failed"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 880
    return v4

    .line 882
    :cond_9
    return v6

    .line 868
    :catch_0
    move-exception p1

    move-object v2, v3

    goto :goto_5

    :catch_1
    move-exception p1

    .line 869
    :goto_5
    const-string p1, "dynamic theme package write failed"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 870
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->closeQuietly(Ljava/io/Closeable;)V

    .line 871
    invoke-virtual {v1}, Ljava/io/File;->delete()Z

    .line 872
    return v4
.end method

.method public static captureFixedTheme(Landroid/content/Context;)V
    .locals 3

    .line 306
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 307
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->resolveCurrentTheme(Landroid/content/Context;)[Ljava/lang/String;

    move-result-object v0

    .line 308
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const/4 v1, 0x0

    aget-object v1, v0, v1

    .line 309
    const-string v2, "compat_theme_fixed_keyboard"

    invoke-interface {p0, v2, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const/4 v1, 0x1

    aget-object v0, v0, v1

    .line 310
    const-string v1, "compat_theme_fixed_additional"

    invoke-interface {p0, v1, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 311
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 312
    return-void
.end method

.method private static closeQuietly(Ljava/io/Closeable;)V
    .locals 0

    .line 1160
    if-nez p0, :cond_0

    .line 1161
    return-void

    .line 1164
    :cond_0
    :try_start_0
    invoke-interface {p0}, Ljava/io/Closeable;->close()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 1167
    goto :goto_0

    .line 1165
    :catch_0
    move-exception p0

    .line 1168
    :goto_0
    return-void
.end method

.method private static customThemeName(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    .line 535
    nop

    .line 536
    const/4 v0, 0x0

    if-eqz p0, :cond_3

    const-string v1, "files:user_theme_"

    invoke-virtual {p0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_0

    goto :goto_1

    .line 539
    :cond_0
    const-string v1, "files:"

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v1

    invoke-virtual {p0, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    .line 540
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

    .line 543
    :cond_1
    return-object p0

    .line 541
    :cond_2
    :goto_0
    return-object v0

    .line 537
    :cond_3
    :goto_1
    return-object v0
.end method

.method private static debugLog(Landroid/content/Context;Ljava/lang/String;)V
    .locals 0

    .line 1282
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object p0

    iget p0, p0, Landroid/content/pm/ApplicationInfo;->flags:I

    and-int/lit8 p0, p0, 0x2

    if-eqz p0, :cond_0

    .line 1283
    const-string p0, "SystemAutoTheme"

    invoke-static {p0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 1285
    :cond_0
    return-void
.end method

.method private static defaultAdditional(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 527
    const-string v0, "dark"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    .line 528
    const p1, 0x7f110224

    invoke-virtual {p0, p1}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 530
    :cond_0
    const p1, 0x7f110225

    invoke-virtual {p0, p1}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static deleteUserTheme(Landroid/content/Context;Ljava/lang/String;)Z
    .locals 4

    .line 429
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 430
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->customThemeName(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 431
    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 432
    return v1

    .line 434
    :cond_0
    new-instance v2, Ljava/io/File;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v3

    invoke-direct {v2, v3, v0}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 435
    invoke-virtual {v2}, Ljava/io/File;->isFile()Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-virtual {v2}, Ljava/io/File;->delete()Z

    move-result v0

    if-nez v0, :cond_1

    .line 436
    const-string p1, "custom theme delete failed"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 437
    return v1

    .line 439
    :cond_1
    const/4 v0, 0x0

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->repointSlots(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    .line 440
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z

    .line 441
    const/4 p0, 0x1

    return p0
.end method

.method public static disable(Landroid/content/Context;)V
    .locals 1

    .line 297
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 298
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 299
    const-string v0, "compat_system_auto_keyboard_theme"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 300
    const-string v0, "compat_system_dynamic_color_theme"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 301
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 302
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

    .line 802
    new-instance v0, Ljava/lang/StringBuilder;

    if-eqz p0, :cond_0

    const-string p0, "dark"

    goto :goto_0

    :cond_0
    const-string p0, "light"

    :goto_0
    invoke-direct {v0, p0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 803
    const-string p0, "@v"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const/4 v1, 0x3

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 804
    const-string p0, "@r"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const/4 v1, 0x5

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 805
    sget-object p0, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_COLOR_ROLES:[[Ljava/lang/String;

    array-length v1, p0

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_1
    if-ge v3, v1, :cond_1

    aget-object v4, p0, v3

    .line 806
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

    .line 805
    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    .line 808
    :cond_1
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static dynamicStyleColors(Ljava/util/Map;ZZ)Ljava/util/Map;
    .locals 8
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

    .line 772
    new-instance v0, Ljava/util/TreeMap;

    invoke-direct {v0}, Ljava/util/TreeMap;-><init>()V

    .line 773
    sget-object v1, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_STYLE_ROLES:[[Ljava/lang/String;

    array-length v2, v1

    const/4 v3, 0x0

    const/4 v4, 0x0

    :goto_0
    if-ge v4, v2, :cond_0

    aget-object v5, v1, v4

    .line 774
    aget-object v6, v5, v3

    const/4 v7, 0x1

    aget-object v5, v5, v7

    invoke-interface {p0, v5}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    invoke-interface {v0, v6, v5}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 773
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 776
    :cond_0
    const-string v1, "function"

    invoke-interface {p0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    .line 777
    const-string v2, "on_function"

    invoke-interface {p0, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    .line 778
    const-string v3, "on_surface"

    invoke-interface {p0, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/Integer;

    invoke-virtual {v3}, Ljava/lang/Integer;->intValue()I

    move-result v3

    .line 779
    const-string v4, "letter"

    invoke-interface {p0, v4}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/Integer;

    invoke-virtual {v4}, Ljava/lang/Integer;->intValue()I

    move-result v4

    .line 780
    invoke-static {v1, v2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->pressedColor(II)I

    move-result v5

    .line 781
    if-eqz p1, :cond_1

    invoke-static {v4, v3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->pressedColor(II)I

    move-result p1

    goto :goto_1

    .line 782
    :cond_1
    const-string p1, "highest"

    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Integer;

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p1

    .line 783
    :goto_1
    const-string v6, "color_state_action_pressed"

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    invoke-interface {v0, v6, v7}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 784
    const-string v6, "color_state_border_key_action_pressed"

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    invoke-interface {v0, v6, v7}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 785
    const-string v6, "color_state_space_bar_pressed"

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    invoke-interface {v0, v6, v7}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 786
    const-string v6, "color_state_key_dark_pressed"

    const-string v7, "color_state_key_pressed"

    if-eqz p2, :cond_2

    .line 787
    const-string p0, "color_state_key"

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    invoke-interface {v0, p0, p2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 788
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-interface {v0, v7, p0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 789
    const-string p0, "color_state_key_dark"

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {v0, p0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 790
    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-interface {v0, v6, p0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 791
    const-string p0, "color_icon"

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {v0, p0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 792
    const-string p0, "color_label_function_key"

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {v0, p0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_2

    .line 794
    :cond_2
    const-string p1, "base"

    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    .line 795
    invoke-static {p0, v3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->pressedColor(II)I

    move-result p1

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {v0, v7, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 796
    invoke-static {p0, v3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->pressedColor(II)I

    move-result p0

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-interface {v0, v6, p0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 798
    :goto_2
    return-object v0
.end method

.method private static declared-synchronized ensureInitialized(Landroid/content/Context;)V
    .locals 6

    const-class v0, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;

    monitor-enter v0

    .line 1185
    :try_start_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v1

    .line 1186
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->hasEverySlotKey(Landroid/content/SharedPreferences;)Z

    move-result v2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v2, :cond_0

    .line 1187
    monitor-exit v0

    return-void

    .line 1189
    :cond_0
    :try_start_1
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    .line 1190
    const-string v3, "compat_theme_fixed_keyboard"

    invoke-interface {v1, v3}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_1

    const-string v3, "compat_theme_fixed_additional"

    invoke-interface {v1, v3}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_2

    .line 1194
    :cond_1
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->resolveCurrentTheme(Landroid/content/Context;)[Ljava/lang/String;

    move-result-object v3

    .line 1195
    const-string v4, "compat_theme_fixed_keyboard"

    const/4 v5, 0x0

    aget-object v5, v3, v5

    invoke-static {v2, v1, v4, v5}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1196
    const-string v4, "compat_theme_fixed_additional"

    const/4 v5, 0x1

    aget-object v3, v3, v5

    invoke-static {v2, v1, v4, v3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1198
    :cond_2
    const v3, 0x7f110226

    invoke-virtual {p0, v3}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v3

    .line 1199
    const-string v4, "compat_theme_light_keyboard"

    invoke-static {v2, v1, v4, v3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1200
    const-string v4, "compat_theme_light_additional"

    const v5, 0x7f110225

    invoke-virtual {p0, v5}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v5

    invoke-static {v2, v1, v4, v5}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1201
    const-string v4, "compat_theme_dark_keyboard"

    invoke-static {v2, v1, v4, v3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1202
    const-string v4, "compat_theme_dark_additional"

    const v5, 0x7f110224

    invoke-virtual {p0, v5}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p0

    invoke-static {v2, v1, v4, p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1203
    const-string p0, "compat_theme_dynamic_keyboard"

    invoke-static {v2, v1, p0, v3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1204
    const-string p0, "compat_theme_dynamic_additional"

    const-string v3, "files:dynamic_theme.zip"

    invoke-static {v2, v1, p0, v3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V

    .line 1209
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->commit()Z
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 1210
    monitor-exit v0

    return-void

    .line 1184
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

    .line 1221
    const-string v0, "compat_theme_fixed_keyboard"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1222
    const-string v0, "compat_theme_fixed_additional"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1223
    const-string v0, "compat_theme_light_keyboard"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1224
    const-string v0, "compat_theme_light_additional"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1225
    const-string v0, "compat_theme_dark_keyboard"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1226
    const-string v0, "compat_theme_dark_additional"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1227
    const-string v0, "compat_theme_dynamic_keyboard"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1228
    const-string v0, "compat_theme_dynamic_additional"

    invoke-interface {p0, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    .line 1221
    :goto_0
    return p0
.end method

.method private static invalidatePreviewSnapshots(Landroid/content/Context;)V
    .locals 8

    .line 907
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->transientCacheDirectories(Landroid/content/Context;)[Ljava/io/File;

    move-result-object v0

    .line 908
    nop

    .line 909
    const/4 v1, 0x0

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_0
    array-length v4, v0

    if-ge v2, v4, :cond_3

    .line 910
    aget-object v4, v0, v2

    invoke-virtual {v4}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v4

    .line 911
    if-nez v4, :cond_0

    .line 912
    goto :goto_2

    .line 914
    :cond_0
    const/4 v5, 0x0

    :goto_1
    array-length v6, v4

    if-ge v5, v6, :cond_2

    .line 915
    aget-object v6, v4, v5

    invoke-virtual {v6}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v6

    .line 916
    const-string v7, "keyboardsnapshotcache_"

    invoke-virtual {v6, v7}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_1

    .line 917
    const-string v7, ".png"

    invoke-virtual {v6, v7}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_1

    aget-object v6, v4, v5

    .line 918
    invoke-virtual {v6}, Ljava/io/File;->delete()Z

    move-result v6

    if-eqz v6, :cond_1

    .line 919
    add-int/lit8 v3, v3, 0x1

    .line 914
    :cond_1
    add-int/lit8 v5, v5, 0x1

    goto :goto_1

    .line 909
    :cond_2
    :goto_2
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 923
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

    .line 924
    return-void
.end method

.method private static isDark(Landroid/content/res/Configuration;)Z
    .locals 1

    .line 1277
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

    .line 246
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->supportsDynamicColor()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 247
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

    .line 246
    :goto_0
    return v1
.end method

.method public static isEnabled(Landroid/content/Context;)Z
    .locals 2

    .line 224
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

    .line 1257
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

    .line 590
    const-string v0, "rebuilding InputView after automatic theme resolution"

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 591
    return-void
.end method

.method private static modeStem(Ljava/lang/String;Z)Ljava/lang/String;
    .locals 1

    .line 727
    const/16 v0, 0x7c

    invoke-virtual {p0, v0}, Ljava/lang/String;->indexOf(I)I

    move-result v0

    .line 728
    if-gez v0, :cond_0

    return-object p0

    .line 729
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

    .line 1288
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 1289
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "_preferences"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1288
    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method public static prepareDynamicTheme(Landroid/content/Context;)Ljava/lang/String;
    .locals 2

    .line 284
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->supportsDynamicColor()Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 285
    return-object v1

    .line 287
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 288
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->isDark(Landroid/content/res/Configuration;)Z

    move-result v0

    .line 289
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->syncDynamicTheme(Landroid/content/Context;Z)I

    move-result p0

    if-nez p0, :cond_1

    .line 290
    return-object v1

    .line 292
    :cond_1
    const-string p0, "files:dynamic_theme.zip"

    return-object p0
.end method

.method private static pressedColor(II)I
    .locals 4

    .line 761
    nop

    .line 762
    const/high16 v0, -0x1000000

    const/4 v1, 0x0

    :goto_0
    const/16 v2, 0x10

    if-gt v1, v2, :cond_0

    .line 763
    ushr-int v2, p0, v1

    and-int/lit16 v2, v2, 0xff

    .line 764
    ushr-int v3, p1, v1

    and-int/lit16 v3, v3, 0xff

    .line 765
    mul-int/lit8 v2, v2, 0x9

    add-int/2addr v2, v3

    div-int/lit8 v2, v2, 0xa

    shl-int/2addr v2, v1

    or-int/2addr v0, v2

    .line 762
    add-int/lit8 v1, v1, 0x8

    goto :goto_0

    .line 767
    :cond_0
    return v0
.end method

.method private static putIfAbsent(Landroid/content/SharedPreferences$Editor;Landroid/content/SharedPreferences;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    .line 1214
    invoke-interface {p1, p2}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result p1

    if-nez p1, :cond_0

    .line 1215
    invoke-interface {p0, p2, p3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 1217
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

    .line 1114
    new-instance v0, Ljava/util/zip/CRC32;

    invoke-direct {v0}, Ljava/util/zip/CRC32;-><init>()V

    .line 1115
    invoke-virtual {v0, p2}, Ljava/util/zip/CRC32;->update([B)V

    .line 1116
    new-instance v1, Ljava/util/zip/ZipEntry;

    invoke-direct {v1, p1}, Ljava/util/zip/ZipEntry;-><init>(Ljava/lang/String;)V

    .line 1117
    const/4 p1, 0x0

    invoke-virtual {v1, p1}, Ljava/util/zip/ZipEntry;->setMethod(I)V

    .line 1118
    array-length p1, p2

    int-to-long v2, p1

    invoke-virtual {v1, v2, v3}, Ljava/util/zip/ZipEntry;->setSize(J)V

    .line 1119
    array-length p1, p2

    int-to-long v2, p1

    invoke-virtual {v1, v2, v3}, Ljava/util/zip/ZipEntry;->setCompressedSize(J)V

    .line 1120
    invoke-virtual {v0}, Ljava/util/zip/CRC32;->getValue()J

    move-result-wide v2

    invoke-virtual {v1, v2, v3}, Ljava/util/zip/ZipEntry;->setCrc(J)V

    .line 1121
    invoke-virtual {p0, v1}, Ljava/util/zip/ZipOutputStream;->putNextEntry(Ljava/util/zip/ZipEntry;)V

    .line 1122
    invoke-virtual {p0, p2}, Ljava/util/zip/ZipOutputStream;->write([B)V

    .line 1123
    invoke-virtual {p0}, Ljava/util/zip/ZipOutputStream;->closeEntry()V

    .line 1124
    return-void
.end method

.method private static readVarint([BI[J)I
    .locals 7

    .line 1128
    nop

    .line 1129
    const-wide/16 v0, 0x0

    const/4 v2, 0x0

    const/4 v3, 0x0

    .line 1131
    :goto_0
    array-length v4, p0

    if-ge p1, v4, :cond_2

    const/16 v4, 0x3f

    if-le v3, v4, :cond_0

    goto :goto_1

    .line 1134
    :cond_0
    aget-byte v4, p0, p1

    and-int/lit16 v4, v4, 0xff

    .line 1135
    add-int/lit8 p1, p1, 0x1

    .line 1136
    and-int/lit8 v5, v4, 0x7f

    int-to-long v5, v5

    shl-long/2addr v5, v3

    or-long/2addr v0, v5

    .line 1137
    and-int/lit16 v4, v4, 0x80

    if-nez v4, :cond_1

    .line 1138
    nop

    .line 1142
    aput-wide v0, p2, v2

    .line 1143
    return p1

    .line 1140
    :cond_1
    add-int/lit8 v3, v3, 0x7

    .line 1141
    goto :goto_0

    .line 1132
    :cond_2
    :goto_1
    const/4 p0, -0x1

    return p0
.end method

.method public static reconcileCustomThemeEdit(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 11

    .line 382
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 383
    if-eqz p1, :cond_6

    invoke-virtual {p1}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;

    move-result-object v0

    if-nez v0, :cond_0

    goto :goto_2

    .line 386
    :cond_0
    invoke-virtual {p1}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;

    move-result-object p1

    const-string v0, "intent_extra_key_deleted_theme_file_name"

    invoke-virtual {p1, v0}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 387
    if-eqz p1, :cond_5

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    if-nez v0, :cond_1

    goto :goto_1

    .line 390
    :cond_1
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->resolveCurrentTheme(Landroid/content/Context;)[Ljava/lang/String;

    move-result-object v0

    .line 391
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    .line 392
    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 393
    nop

    .line 394
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

    .line 395
    const/4 v4, 0x0

    const/4 v7, 0x0

    :goto_0
    if-ge v4, v2, :cond_3

    .line 396
    aget-object v8, v3, v4

    .line 397
    invoke-static {v8}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->additionalKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    const-string v10, ""

    invoke-interface {p0, v9, v10}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    .line 398
    const-string v10, "files:user_theme_"

    invoke-virtual {v9, v10}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v10

    if-eqz v10, :cond_2

    invoke-virtual {v9, p1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v9

    if-eqz v9, :cond_2

    .line 399
    invoke-static {v8}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->baseKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    aget-object v9, v0, v5

    invoke-interface {v1, v7, v9}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 400
    invoke-static {v8}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->additionalKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    aget-object v8, v0, v6

    invoke-interface {v1, v7, v8}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 401
    const/4 v7, 0x1

    .line 395
    :cond_2
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 404
    :cond_3
    if-eqz v7, :cond_4

    .line 405
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 407
    :cond_4
    return-void

    .line 388
    :cond_5
    :goto_1
    return-void

    .line 384
    :cond_6
    :goto_2
    return-void
.end method

.method private static repointSlots(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V
    .locals 12

    .line 488
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 489
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 490
    nop

    .line 491
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

    .line 492
    const/4 v6, 0x0

    :goto_0
    const v8, 0x7f110226

    const-string v9, ""

    if-ge v5, v2, :cond_2

    .line 493
    aget-object v10, v3, v5

    .line 494
    invoke-static {v10}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->additionalKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    invoke-interface {v0, v11, v9}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {p1, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-nez v9, :cond_0

    .line 495
    goto :goto_2

    .line 497
    :cond_0
    invoke-static {v10}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->baseKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {p0, v8}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v8

    invoke-interface {v1, v6, v8}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 498
    nop

    .line 499
    invoke-static {v10}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->additionalKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    .line 500
    if-eqz p2, :cond_1

    move-object v8, p2

    goto :goto_1

    :cond_1
    invoke-static {p0, v10}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->defaultAdditional(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    .line 498
    :goto_1
    invoke-interface {v1, v6, v8}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 501
    const/4 v6, 0x1

    .line 492
    :goto_2
    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    .line 503
    :cond_2
    const v2, 0x7f11023a

    invoke-virtual {p0, v2}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v2

    .line 504
    invoke-interface {v0, v2, v9}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_4

    .line 505
    const p1, 0x7f110282

    invoke-virtual {p0, p1}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p1

    .line 506
    invoke-virtual {p0, v8}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v0

    .line 505
    invoke-interface {v1, p1, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 507
    nop

    .line 509
    if-eqz p2, :cond_3

    .line 510
    goto :goto_3

    .line 511
    :cond_3
    invoke-static {p0, v7}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->defaultAdditional(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    .line 507
    :goto_3
    invoke-interface {v1, v2, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 512
    goto :goto_4

    .line 504
    :cond_4
    move v4, v6

    .line 514
    :goto_4
    if-eqz v4, :cond_5

    .line 515
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 517
    :cond_5
    return-void
.end method

.method private static resolveCurrentTheme(Landroid/content/Context;)[Ljava/lang/String;
    .locals 8

    .line 1233
    const-string v0, "a"

    const/4 v1, 0x2

    const/4 v2, 0x1

    const/4 v3, 0x0

    :try_start_0
    const-string v4, "baq"

    invoke-static {v4}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v4

    .line 1234
    new-array v5, v2, [Ljava/lang/Class;

    const-class v6, Landroid/content/Context;

    aput-object v6, v5, v3

    invoke-virtual {v4, v0, v5}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v5

    .line 1235
    new-array v6, v2, [Ljava/lang/Object;

    aput-object p0, v6, v3

    const/4 v7, 0x0

    invoke-virtual {v5, v7, v6}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    .line 1236
    invoke-virtual {v4, v0}, Ljava/lang/Class;->getField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v0

    .line 1237
    const-string v6, "b"

    invoke-virtual {v4, v6}, Ljava/lang/Class;->getField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v4

    .line 1238
    nop

    .line 1239
    invoke-virtual {v0, v5}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 1240
    invoke-virtual {v4, v5}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    new-array v5, v1, [Ljava/lang/String;

    aput-object v0, v5, v3

    aput-object v4, v5, v2
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 1238
    return-object v5

    .line 1242
    :catch_0
    move-exception v0

    .line 1243
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 1244
    nop

    .line 1246
    const v4, 0x7f110282

    invoke-virtual {p0, v4}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v4

    .line 1247
    const v5, 0x7f110226

    invoke-virtual {p0, v5}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v5

    .line 1245
    invoke-interface {v0, v4, v5}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 1249
    const v5, 0x7f11023a

    invoke-virtual {p0, v5}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p0

    .line 1248
    const-string v5, ""

    invoke-interface {v0, p0, v5}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    new-array v0, v1, [Ljava/lang/String;

    aput-object v4, v0, v3

    aput-object p0, v0, v2

    .line 1244
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

    .line 734
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    .line 735
    sget-object v1, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->DYNAMIC_COLOR_ROLES:[[Ljava/lang/String;

    array-length v2, v1

    const/4 v3, 0x0

    const/4 v4, 0x0

    :goto_0
    if-ge v4, v2, :cond_3

    aget-object v5, v1, v4

    .line 736
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

    .line 737
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

    .line 738
    invoke-static {p0, v6}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->systemColor(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v6

    .line 739
    if-nez v6, :cond_1

    .line 740
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

    .line 742
    :cond_1
    if-nez v6, :cond_2

    const/4 p0, 0x0

    return-object p0

    .line 743
    :cond_2
    aget-object v5, v5, v3

    invoke-interface {v0, v5, v6}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 735
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 745
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

    .line 972
    move-object/from16 v0, p0

    move-object/from16 v1, p1

    const/4 v2, 0x0

    if-eqz v0, :cond_16

    if-nez v1, :cond_0

    move-object/from16 v16, v2

    goto/16 :goto_8

    .line 975
    :cond_0
    new-instance v3, Ljava/io/ByteArrayOutputStream;

    array-length v4, v0

    invoke-direct {v3, v4}, Ljava/io/ByteArrayOutputStream;-><init>(I)V

    .line 976
    new-instance v4, Ljava/util/HashSet;

    invoke-direct {v4}, Ljava/util/HashSet;-><init>()V

    .line 977
    array-length v5, v0

    .line 978
    const/4 v6, 0x0

    const/4 v7, 0x0

    .line 979
    :goto_0
    if-ge v7, v5, :cond_13

    .line 980
    aget-byte v8, v0, v7

    and-int/lit16 v8, v8, 0xff

    const/16 v9, 0x12

    if-eq v8, v9, :cond_1

    .line 981
    const/16 v17, 0x0

    goto/16 :goto_6

    .line 983
    :cond_1
    add-int/lit8 v7, v7, 0x1

    .line 984
    const/4 v8, 0x1

    new-array v10, v8, [J

    .line 985
    invoke-static {v0, v7, v10}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->readVarint([BI[J)I

    move-result v7

    .line 986
    if-gez v7, :cond_2

    .line 987
    return-object v2

    .line 989
    :cond_2
    nop

    .line 990
    aget-wide v11, v10, v6

    long-to-int v10, v11

    add-int/2addr v10, v7

    .line 991
    if-gt v10, v5, :cond_12

    if-ge v10, v7, :cond_3

    move-object/from16 v16, v2

    goto/16 :goto_5

    .line 995
    :cond_3
    nop

    .line 996
    nop

    .line 997
    nop

    .line 998
    nop

    .line 1000
    move-object v12, v2

    move v11, v7

    const/4 v13, 0x0

    const/4 v14, 0x0

    const/4 v15, 0x0

    .line 1001
    :goto_1
    if-ge v11, v10, :cond_e

    .line 1002
    move-object/from16 v16, v2

    aget-byte v2, v0, v11

    and-int/lit16 v2, v2, 0xff

    .line 1003
    add-int/lit8 v11, v11, 0x1

    .line 1004
    const/16 v17, 0x0

    const/16 v6, 0xa

    if-ne v2, v6, :cond_6

    .line 1005
    new-array v2, v8, [J

    .line 1006
    invoke-static {v0, v11, v2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->readVarint([BI[J)I

    move-result v6

    .line 1007
    if-gez v6, :cond_4

    .line 1008
    return-object v16

    .line 1010
    :cond_4
    aget-wide v11, v2, v17

    long-to-int v12, v11

    add-int/2addr v12, v6

    .line 1011
    if-le v12, v10, :cond_5

    .line 1012
    return-object v16

    .line 1014
    :cond_5
    new-instance v11, Ljava/lang/String;

    aget-wide v8, v2, v17

    long-to-int v2, v8

    sget-object v8, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->UTF_8:Ljava/nio/charset/Charset;

    invoke-direct {v11, v0, v6, v2, v8}, Ljava/lang/String;-><init>([BIILjava/nio/charset/Charset;)V

    .line 1015
    nop

    .line 1016
    move v2, v12

    move-object v12, v11

    move v11, v2

    const/4 v2, 0x1

    goto :goto_2

    :cond_6
    const/16 v6, 0x12

    if-ne v2, v6, :cond_b

    .line 1017
    const/4 v2, 0x1

    new-array v6, v2, [J

    .line 1018
    invoke-static {v0, v11, v6}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->readVarint([BI[J)I

    move-result v2

    .line 1019
    if-gez v2, :cond_7

    .line 1020
    return-object v16

    .line 1022
    :cond_7
    aget-wide v8, v6, v17

    long-to-int v6, v8

    add-int/2addr v6, v2

    .line 1023
    if-le v6, v10, :cond_8

    .line 1024
    return-object v16

    .line 1026
    :cond_8
    if-ge v2, v6, :cond_a

    aget-byte v8, v0, v2

    and-int/lit16 v8, v8, 0xff

    const/16 v9, 0x8

    if-ne v8, v9, :cond_a

    .line 1027
    const/4 v8, 0x1

    new-array v9, v8, [J

    .line 1028
    add-int/lit8 v2, v2, 0x1

    invoke-static {v0, v2, v9}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->readVarint([BI[J)I

    move-result v2

    if-gez v2, :cond_9

    .line 1029
    return-object v16

    .line 1031
    :cond_9
    const/4 v13, 0x1

    .line 1033
    :cond_a
    nop

    .line 1034
    move v11, v6

    const/4 v2, 0x1

    goto :goto_2

    :cond_b
    const/16 v6, 0x1a

    if-ne v2, v6, :cond_d

    .line 1035
    const/4 v2, 0x1

    new-array v6, v2, [J

    .line 1036
    invoke-static {v0, v11, v6}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->readVarint([BI[J)I

    move-result v8

    .line 1037
    if-gez v8, :cond_c

    .line 1038
    return-object v16

    .line 1040
    :cond_c
    aget-wide v14, v6, v17

    long-to-int v15, v14

    .line 1041
    nop

    .line 1042
    move v11, v8

    const/4 v14, 0x1

    goto :goto_2

    .line 1043
    :cond_d
    const/4 v2, 0x1

    move v11, v10

    .line 1045
    :goto_2
    move-object/from16 v2, v16

    const/4 v6, 0x0

    const/4 v8, 0x1

    const/16 v9, 0x12

    goto :goto_1

    .line 1047
    :cond_e
    move-object/from16 v16, v2

    const/16 v17, 0x0

    if-eqz v12, :cond_f

    invoke-interface {v4, v12}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 1048
    :cond_f
    if-nez v12, :cond_10

    move-object/from16 v2, v16

    goto :goto_3

    :cond_10
    invoke-interface {v1, v12}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Integer;

    .line 1049
    :goto_3
    if-eqz v2, :cond_11

    if-eqz v13, :cond_11

    .line 1050
    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    invoke-static {v3, v12, v2, v14, v15}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeColorRule(Ljava/io/ByteArrayOutputStream;Ljava/lang/String;IZI)V

    goto :goto_4

    .line 1052
    :cond_11
    sub-int v2, v10, v7

    .line 1053
    const/16 v6, 0x12

    invoke-virtual {v3, v6}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 1054
    int-to-long v8, v2

    invoke-static {v3, v8, v9}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeVarint(Ljava/io/ByteArrayOutputStream;J)V

    .line 1055
    invoke-virtual {v3, v0, v7, v2}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    .line 1057
    :goto_4
    nop

    .line 1058
    move v7, v10

    move-object/from16 v2, v16

    const/4 v6, 0x0

    goto/16 :goto_0

    .line 991
    :cond_12
    move-object/from16 v16, v2

    .line 992
    :goto_5
    return-object v16

    .line 979
    :cond_13
    const/16 v17, 0x0

    .line 1062
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

    .line 1063
    invoke-interface {v1}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v2

    invoke-interface {v4, v2}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_14

    goto :goto_7

    .line 1064
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

    .line 1065
    const/16 v17, 0x0

    goto :goto_7

    .line 1066
    :cond_15
    invoke-virtual {v3}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v0

    return-object v0

    .line 972
    :cond_16
    move-object/from16 v16, v2

    .line 973
    :goto_8
    return-object v16
.end method

.method public static setDynamicEnabled(Landroid/content/Context;Z)V
    .locals 2

    .line 259
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 260
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 261
    const-string v1, "compat_system_dynamic_color_theme"

    if-eqz p1, :cond_0

    .line 262
    const/4 p1, 0x1

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    const-string v1, "compat_system_auto_keyboard_theme"

    invoke-interface {p1, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    goto :goto_0

    .line 264
    :cond_0
    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 266
    :goto_0
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 267
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z

    .line 268
    return-void
.end method

.method public static setEnabled(Landroid/content/Context;Z)V
    .locals 2

    .line 228
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->ensureInitialized(Landroid/content/Context;)V

    .line 229
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 230
    const-string v1, "compat_system_auto_keyboard_theme"

    if-eqz p1, :cond_0

    .line 232
    const/4 p1, 0x1

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    const-string v1, "compat_system_dynamic_color_theme"

    invoke-interface {p1, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    goto :goto_0

    .line 234
    :cond_0
    invoke-interface {v0, v1}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 236
    :goto_0
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 237
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->applyConfiguredTheme(Landroid/content/Context;Landroid/content/res/Configuration;)Z

    .line 238
    return-void
.end method

.method public static supportsDynamicColor()Z
    .locals 2

    .line 242
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

    .line 663
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->resolveDynamicColors(Landroid/content/Context;Z)Ljava/util/Map;

    move-result-object v0

    .line 664
    if-nez v0, :cond_0

    .line 665
    const-string p1, "system palette unavailable, retaining the ordinary theme"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 666
    const/4 p0, 0x0

    return p0

    .line 668
    :cond_0
    invoke-static {p1, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->dynamicSignature(ZLjava/util/Map;)Ljava/lang/String;

    move-result-object v1

    .line 669
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v2

    .line 670
    new-instance v3, Ljava/io/File;

    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v4

    const-string v5, "dynamic_theme.zip"

    invoke-direct {v3, v4, v5}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 671
    invoke-virtual {v3}, Ljava/io/File;->isFile()Z

    move-result v4

    const-string v5, "compat_theme_dynamic_signature"

    if-eqz v4, :cond_1

    .line 672
    const/4 v4, 0x0

    invoke-interface {v2, v5, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v1, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1

    .line 673
    const-string p1, "dynamic palette unchanged"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 674
    const/4 p0, 0x1

    return p0

    .line 676
    :cond_1
    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->buildDynamicThemePackage(Landroid/content/Context;ZLjava/util/Map;)Z

    move-result p1

    if-nez p1, :cond_2

    .line 677
    const-string p1, "dynamic theme package build failed"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 678
    invoke-virtual {v3}, Ljava/io/File;->isFile()Z

    move-result p0

    return p0

    .line 680
    :cond_2
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1, v5, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    .line 686
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->invalidatePreviewSnapshots(Landroid/content/Context;)V

    .line 687
    const-string p1, "dynamic theme package rebuilt"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 688
    const/4 p0, 0x2

    return p0
.end method

.method private static systemColor(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/Integer;
    .locals 3

    .line 749
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    .line 750
    const-string v1, "color"

    const-string v2, "android"

    invoke-virtual {v0, p1, v1, v2}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result p1

    .line 751
    const/4 v1, 0x0

    if-nez p1, :cond_0

    return-object v1

    .line 753
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

    .line 754
    :catch_0
    move-exception p0

    .line 755
    return-object v1
.end method

.method private static templateBytes(Landroid/content/Context;Ljava/lang/String;)[B
    .locals 4

    .line 1094
    nop

    .line 1096
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

    .line 1097
    :try_start_1
    new-instance p1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {p1}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 1098
    const/16 v1, 0x1000

    new-array v1, v1, [B

    .line 1100
    :goto_0
    invoke-virtual {p0, v1}, Ljava/io/InputStream;->read([B)I

    move-result v2

    if-lez v2, :cond_0

    .line 1101
    const/4 v3, 0x0

    invoke-virtual {p1, v1, v3, v2}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_0

    .line 1103
    :cond_0
    invoke-virtual {p1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p1
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 1107
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->closeQuietly(Ljava/io/Closeable;)V

    .line 1103
    return-object p1

    .line 1107
    :catchall_0
    move-exception p1

    move-object v0, p0

    goto :goto_1

    .line 1104
    :catch_0
    move-exception p1

    goto :goto_2

    .line 1107
    :catchall_1
    move-exception p1

    :goto_1
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->closeQuietly(Ljava/io/Closeable;)V

    .line 1108
    throw p1

    .line 1104
    :catch_1
    move-exception p0

    move-object p0, v0

    .line 1105
    :goto_2
    nop

    .line 1107
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->closeQuietly(Ljava/io/Closeable;)V

    .line 1105
    return-object v0
.end method

.method private static transientCacheDirectories(Landroid/content/Context;)[Ljava/io/File;
    .locals 4

    .line 940
    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object p0

    .line 941
    if-nez p0, :cond_0

    .line 942
    const/4 p0, 0x0

    new-array p0, p0, [Ljava/io/File;

    return-object p0

    .line 944
    :cond_0
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 945
    invoke-interface {v0, p0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 946
    invoke-virtual {p0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object p0

    .line 947
    const-string v1, "/user/"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 948
    new-instance v2, Ljava/io/File;

    const-string v3, "/user_de/"

    invoke-virtual {p0, v1, v3}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    invoke-direct {v2, p0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-interface {v0, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 950
    :cond_1
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result p0

    new-array p0, p0, [Ljava/io/File;

    invoke-interface {v0, p0}, Ljava/util/List;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object p0

    check-cast p0, [Ljava/io/File;

    return-object p0
.end method

.method private static writeColorRule(Ljava/io/ByteArrayOutputStream;Ljava/lang/String;IZI)V
    .locals 7

    .line 1071
    sget-object v0, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p1, v0}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p1

    .line 1072
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 1073
    const/16 v1, 0x8

    invoke-virtual {v0, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 1074
    int-to-long v1, p2

    const-wide v3, 0xffffffffL

    and-long/2addr v1, v3

    invoke-static {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeVarint(Ljava/io/ByteArrayOutputStream;J)V

    .line 1075
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p2

    .line 1076
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 1077
    const/16 v1, 0xa

    invoke-virtual {v0, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 1078
    array-length v1, p1

    int-to-long v1, v1

    invoke-static {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeVarint(Ljava/io/ByteArrayOutputStream;J)V

    .line 1079
    array-length v1, p1

    const/4 v2, 0x0

    invoke-virtual {v0, p1, v2, v1}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    .line 1080
    const/16 p1, 0x12

    invoke-virtual {v0, p1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 1081
    array-length v1, p2

    int-to-long v5, v1

    invoke-static {v0, v5, v6}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeVarint(Ljava/io/ByteArrayOutputStream;J)V

    .line 1082
    array-length v1, p2

    invoke-virtual {v0, p2, v2, v1}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    .line 1083
    if-eqz p3, :cond_0

    .line 1084
    const/16 p2, 0x1a

    invoke-virtual {v0, p2}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 1085
    int-to-long p2, p4

    and-long/2addr p2, v3

    invoke-static {v0, p2, p3}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeVarint(Ljava/io/ByteArrayOutputStream;J)V

    .line 1087
    :cond_0
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p2

    .line 1088
    invoke-virtual {p0, p1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 1089
    array-length p1, p2

    int-to-long p3, p1

    invoke-static {p0, p3, p4}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->writeVarint(Ljava/io/ByteArrayOutputStream;J)V

    .line 1090
    array-length p1, p2

    invoke-virtual {p0, p2, v2, p1}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    .line 1091
    return-void
.end method

.method private static writeSlot(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 6

    .line 625
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 626
    const v1, 0x7f110282

    invoke-virtual {p0, v1}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v1

    .line 627
    const v2, 0x7f11023a

    invoke-virtual {p0, v2}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v2

    .line 628
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->baseKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    const-string v4, ""

    invoke-interface {v0, v3, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 629
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->additionalKey(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-interface {v0, p1, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 630
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 631
    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z

    move-result p2

    const/4 v4, 0x0

    if-nez p2, :cond_3

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result p2

    if-eqz p2, :cond_0

    goto :goto_1

    .line 639
    :cond_0
    const/4 p2, 0x0

    invoke-interface {v0, v1, p2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v3, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_1

    .line 640
    invoke-interface {v0, v2, p2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_1

    .line 641
    const-string p1, "legacy theme pair already resolved"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 642
    return v4

    .line 644
    :cond_1
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 645
    invoke-interface {p2, v1, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 646
    invoke-interface {p2, v2, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 647
    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->commit()Z

    move-result p1

    .line 648
    if-eqz p1, :cond_2

    const-string p2, "legacy theme pair committed"

    goto :goto_0

    :cond_2
    const-string p2, "theme commit failed"

    :goto_0
    invoke-static {p0, p2}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 649
    return p1

    .line 636
    :cond_3
    :goto_1
    const-string p1, "theme slot is empty, keeping the current theme"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/SystemAutoThemeCompat;->debugLog(Landroid/content/Context;Ljava/lang/String;)V

    .line 637
    return v4
.end method

.method private static writeVarint(Ljava/io/ByteArrayOutputStream;J)V
    .locals 4

    .line 1148
    nop

    :goto_0
    const-wide/16 v0, 0x7f

    and-long/2addr v0, p1

    long-to-int v1, v0

    .line 1149
    const/4 v0, 0x7

    ushr-long/2addr p1, v0

    .line 1150
    const-wide/16 v2, 0x0

    cmp-long v0, p1, v2

    if-eqz v0, :cond_0

    .line 1151
    or-int/lit16 v0, v1, 0x80

    invoke-virtual {p0, v0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 1156
    goto :goto_0

    .line 1153
    :cond_0
    invoke-virtual {p0, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 1154
    return-void
.end method
