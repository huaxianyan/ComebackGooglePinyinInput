.class public final Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;
.super Ljava/lang/Object;
.source "FloatingKeyboardCompat.java"


# static fields
.field private static final DEFAULT_SCALE:F = 0.72f

.field private static final KEY_ENABLED:Ljava/lang/String; = "enabled"

.field private static final KEY_SCALE:Ljava/lang/String; = "scale"

.field private static final MAX_SCALE:F = 1.0f

.field private static final MIN_SCALE:F = 0.4f

.field private static final PREFERENCES:Ljava/lang/String; = "floating_keyboard_preferences"

.field private static final TABLET_SMALLEST_WIDTH_DP:I = 0x258

.field private static final TAG:Ljava/lang/String; = "FloatingKeyboard"

.field private static appliedScale:F


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 45
    const/high16 v0, -0x40800000    # -1.0f

    sput v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 47
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static applyInsets(Landroid/inputmethodservice/InputMethodService;Landroid/inputmethodservice/InputMethodService$Insets;)V
    .locals 5

    .line 87
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->isEnabled(Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 88
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->resetScale(Landroid/inputmethodservice/InputMethodService;)V

    .line 89
    return-void

    .line 91
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->serviceWindow(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;

    move-result-object v0

    .line 92
    if-nez v0, :cond_1

    return-void

    .line 93
    :cond_1
    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    .line 94
    if-nez v0, :cond_2

    return-void

    .line 96
    :cond_2
    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v1

    .line 97
    iget v2, v1, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 98
    iget v1, v1, Landroid/util/DisplayMetrics;->heightPixels:I

    .line 99
    if-lez v2, :cond_5

    if-gtz v1, :cond_3

    goto :goto_1

    .line 101
    :cond_3
    iput v1, p1, Landroid/inputmethodservice/InputMethodService$Insets;->contentTopInsets:I

    .line 102
    iput v1, p1, Landroid/inputmethodservice/InputMethodService$Insets;->visibleTopInsets:I

    .line 103
    const/4 v3, 0x3

    iput v3, p1, Landroid/inputmethodservice/InputMethodService$Insets;->touchableInsets:I

    .line 105
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scale(Landroid/content/Context;)F

    move-result p0

    .line 106
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v0

    .line 107
    new-instance v3, Landroid/graphics/Rect;

    invoke-direct {v3}, Landroid/graphics/Rect;-><init>()V

    .line 108
    if-eqz v0, :cond_4

    invoke-static {v0, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyScale(Landroid/view/View;F)Z

    move-result v4

    if-eqz v4, :cond_4

    invoke-static {v0, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->visualRegion(Landroid/view/View;Landroid/graphics/Rect;)Z

    move-result v0

    if-eqz v0, :cond_4

    .line 109
    iget-object p1, p1, Landroid/inputmethodservice/InputMethodService$Insets;->touchableRegion:Landroid/graphics/Region;

    invoke-virtual {p1, v3}, Landroid/graphics/Region;->set(Landroid/graphics/Rect;)Z

    goto :goto_0

    .line 113
    :cond_4
    div-int/lit8 v0, v1, 0x3

    sub-int v0, v1, v0

    .line 114
    const/4 v4, 0x0

    invoke-virtual {v3, v4, v0, v2, v1}, Landroid/graphics/Rect;->set(IIII)V

    .line 115
    iget-object p1, p1, Landroid/inputmethodservice/InputMethodService$Insets;->touchableRegion:Landroid/graphics/Region;

    invoke-virtual {p1, v3}, Landroid/graphics/Region;->set(Landroid/graphics/Rect;)Z

    .line 117
    :goto_0
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "scale="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p1, " region="

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {v3}, Landroid/graphics/Rect;->toShortString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p1, " screen="

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p1, "x"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "FloatingKeyboard"

    invoke-static {p1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 119
    return-void

    .line 99
    :cond_5
    :goto_1
    return-void
.end method

.method private static applyScale(Landroid/view/View;F)Z
    .locals 4

    .line 137
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v0

    .line 138
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v1

    .line 139
    if-lez v0, :cond_2

    if-gtz v1, :cond_0

    goto :goto_0

    .line 140
    :cond_0
    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v3, 0x1

    cmpl-float v2, v2, p1

    if-nez v2, :cond_1

    return v3

    .line 141
    :cond_1
    sput p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 142
    int-to-float v0, v0

    const/high16 v2, 0x40000000    # 2.0f

    div-float/2addr v0, v2

    invoke-virtual {p0, v0}, Landroid/view/View;->setPivotX(F)V

    .line 143
    int-to-float v0, v1

    invoke-virtual {p0, v0}, Landroid/view/View;->setPivotY(F)V

    .line 144
    invoke-virtual {p0, p1}, Landroid/view/View;->setScaleX(F)V

    .line 145
    invoke-virtual {p0, p1}, Landroid/view/View;->setScaleY(F)V

    .line 146
    return v3

    .line 139
    :cond_2
    :goto_0
    const/4 p0, 0x0

    return p0
.end method

.method private static findKeyboardArea(Landroid/view/View;)Landroid/view/View;
    .locals 4

    .line 164
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v0

    .line 165
    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    const-string v2, "keyboard_area"

    const-string v3, "id"

    invoke-virtual {v1, v2, v3, v0}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v1

    .line 166
    if-nez v1, :cond_0

    .line 167
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "id keyboard_area not found in "

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "FloatingKeyboard"

    invoke-static {v0, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 168
    const/4 p0, 0x0

    return-object p0

    .line 170
    :cond_0
    invoke-virtual {p0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p0

    return-object p0
.end method

.method public static isEnabled(Landroid/content/Context;)Z
    .locals 2

    .line 54
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v0, "enabled"

    const/4 v1, 0x0

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p0

    return p0
.end method

.method static isTablet(Landroid/content/Context;)Z
    .locals 1

    .line 63
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p0

    .line 64
    iget p0, p0, Landroid/content/res/Configuration;->smallestScreenWidthDp:I

    const/16 v0, 0x258

    if-lt p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .locals 2

    .line 79
    const-string v0, "floating_keyboard_preferences"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method private static resetScale(Landroid/inputmethodservice/InputMethodService;)V
    .locals 2

    .line 123
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/high16 v1, 0x3f800000    # 1.0f

    cmpl-float v0, v0, v1

    if-nez v0, :cond_0

    return-void

    .line 124
    :cond_0
    sput v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 125
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->serviceWindow(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;

    move-result-object p0

    .line 126
    if-nez p0, :cond_1

    return-void

    .line 127
    :cond_1
    invoke-virtual {p0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object p0

    .line 128
    if-nez p0, :cond_2

    return-void

    .line 129
    :cond_2
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object p0

    .line 130
    if-nez p0, :cond_3

    return-void

    .line 131
    :cond_3
    invoke-virtual {p0, v1}, Landroid/view/View;->setScaleX(F)V

    .line 132
    invoke-virtual {p0, v1}, Landroid/view/View;->setScaleY(F)V

    .line 133
    return-void
.end method

.method public static scale(Landroid/content/Context;)F
    .locals 2

    .line 68
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v0, "scale"

    const v1, 0x3f3851ec    # 0.72f

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F

    move-result p0

    .line 69
    const/high16 v0, 0x3f800000    # 1.0f

    invoke-static {v0, p0}, Ljava/lang/Math;->min(FF)F

    move-result p0

    const v0, 0x3ecccccd    # 0.4f

    invoke-static {v0, p0}, Ljava/lang/Math;->max(FF)F

    move-result p0

    return p0
.end method

.method private static serviceWindow(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;
    .locals 0

    .line 159
    invoke-virtual {p0}, Landroid/inputmethodservice/InputMethodService;->getWindow()Landroid/app/Dialog;

    move-result-object p0

    .line 160
    if-nez p0, :cond_0

    const/4 p0, 0x0

    goto :goto_0

    :cond_0
    invoke-virtual {p0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object p0

    :goto_0
    return-object p0
.end method

.method public static setEnabled(Landroid/content/Context;Z)V
    .locals 1

    .line 58
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string v0, "enabled"

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 59
    const/high16 p0, -0x40800000    # -1.0f

    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 60
    return-void
.end method

.method public static setScale(Landroid/content/Context;F)V
    .locals 1

    .line 73
    const/high16 v0, 0x3f800000    # 1.0f

    invoke-static {v0, p1}, Ljava/lang/Math;->min(FF)F

    move-result p1

    const v0, 0x3ecccccd    # 0.4f

    invoke-static {v0, p1}, Ljava/lang/Math;->max(FF)F

    move-result p1

    .line 74
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string v0, "scale"

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 75
    const/high16 p0, -0x40800000    # -1.0f

    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 76
    return-void
.end method

.method private static visualRegion(Landroid/view/View;Landroid/graphics/Rect;)Z
    .locals 2

    .line 150
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v0

    const/4 v1, 0x0

    if-lez v0, :cond_2

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v0

    if-gtz v0, :cond_0

    goto :goto_0

    .line 154
    :cond_0
    invoke-virtual {p0, p1}, Landroid/view/View;->getGlobalVisibleRect(Landroid/graphics/Rect;)Z

    move-result p0

    if-nez p0, :cond_1

    return v1

    .line 155
    :cond_1
    invoke-virtual {p1}, Landroid/graphics/Rect;->isEmpty()Z

    move-result p0

    xor-int/lit8 p0, p0, 0x1

    return p0

    .line 150
    :cond_2
    :goto_0
    return v1
.end method
