.class public final Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;
.super Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;
.source "SimplifiedTraditionalToggleKeyView.java"

# interfaces
.implements Landroid/content/SharedPreferences$OnSharedPreferenceChangeListener;
.implements Landroid/view/ViewTreeObserver$OnPreDrawListener;


# static fields
.field private static final ACCESS_POINTS_OVERLAY_ID:Ljava/lang/String; = "access_points_overlay_view"

.field private static final LEFT_SLOT_IDS:[Ljava/lang/String;

.field public static final PREFERENCE_KEY:Ljava/lang/String; = "show_simplified_traditional_header_toggle"

.field private static final VOICE_SLOT_ID:Ljava/lang/String; = "key_pos_header_voice"


# instance fields
.field private geometryHidden:Z

.field private preferenceHidden:Z

.field private preferences:Landroid/content/SharedPreferences;

.field private shortcutWidth:I


# direct methods
.method static constructor <clinit>()V
    .locals 3

    .line 21
    const/4 v0, 0x3

    new-array v0, v0, [Ljava/lang/String;

    const-string v1, "key_pos_header_access_points_menu"

    const/4 v2, 0x0

    aput-object v1, v0, v2

    const-string v1, "key_pos_header_lang_1"

    const/4 v2, 0x1

    aput-object v1, v0, v2

    const-string v1, "key_pos_header_lang_2"

    const/4 v2, 0x2

    aput-object v1, v0, v2

    sput-object v0, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->LEFT_SLOT_IDS:[Ljava/lang/String;

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 0

    .line 35
    invoke-direct {p0, p1}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;-><init>(Landroid/content/Context;)V

    .line 36
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 0

    .line 39
    invoke-direct {p0, p1, p2}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 40
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V
    .locals 0

    .line 44
    invoke-direct {p0, p1, p2, p3}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    .line 45
    return-void
.end method

.method private applyVisibility()V
    .locals 1

    .line 97
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->preferenceHidden:Z

    if-nez v0, :cond_1

    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->geometryHidden:Z

    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/16 v0, 0x8

    :goto_1
    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->setVisibility(I)V

    .line 98
    return-void
.end method

.method private static descendantRect(Landroid/view/ViewGroup;Landroid/view/View;)Landroid/graphics/Rect;
    .locals 4

    .line 130
    new-instance v0, Landroid/graphics/Rect;

    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v1

    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result v2

    const/4 v3, 0x0

    invoke-direct {v0, v3, v3, v1, v2}, Landroid/graphics/Rect;-><init>(IIII)V

    .line 131
    invoke-virtual {p0, p1, v0}, Landroid/view/ViewGroup;->offsetDescendantRectToMyCoords(Landroid/view/View;Landroid/graphics/Rect;)V

    .line 132
    return-object v0
.end method

.method private findExplicitSlot(Landroid/view/ViewGroup;Ljava/lang/String;)Landroid/view/View;
    .locals 3

    .line 125
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v1

    const-string v2, "id"

    invoke-virtual {v0, p2, v2, v1}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result p2

    .line 126
    if-nez p2, :cond_0

    const/4 p1, 0x0

    goto :goto_0

    :cond_0
    invoke-virtual {p1, p2}, Landroid/view/ViewGroup;->findViewById(I)Landroid/view/View;

    move-result-object p1

    :goto_0
    return-object p1
.end method

.method private hasAvailableHeaderSpace()Z
    .locals 9

    .line 101
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->shortcutWidth:I

    const/4 v1, 0x0

    if-gtz v0, :cond_0

    return v1

    .line 102
    :cond_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-nez v0, :cond_1

    return v1

    .line 103
    :cond_1
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    .line 104
    invoke-virtual {v0}, Landroid/view/ViewGroup;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    instance-of v2, v2, Landroid/view/ViewGroup;

    if-nez v2, :cond_2

    return v1

    .line 105
    :cond_2
    invoke-virtual {v0}, Landroid/view/ViewGroup;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    check-cast v2, Landroid/view/ViewGroup;

    .line 106
    const-string v3, "access_points_overlay_view"

    invoke-direct {p0, v2, v3}, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->findExplicitSlot(Landroid/view/ViewGroup;Ljava/lang/String;)Landroid/view/View;

    move-result-object v3

    .line 107
    if-eqz v3, :cond_9

    .line 108
    invoke-virtual {v3}, Landroid/view/View;->getVisibility()I

    move-result v3

    if-eqz v3, :cond_3

    goto :goto_2

    .line 109
    :cond_3
    const-string v3, "key_pos_header_voice"

    invoke-direct {p0, v2, v3}, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->findExplicitSlot(Landroid/view/ViewGroup;Ljava/lang/String;)Landroid/view/View;

    move-result-object v3

    .line 110
    if-eqz v3, :cond_8

    invoke-virtual {v3}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v4

    if-ne v4, v0, :cond_8

    .line 111
    invoke-virtual {v3}, Landroid/view/View;->getVisibility()I

    move-result v0

    if-eqz v0, :cond_4

    goto :goto_1

    .line 113
    :cond_4
    invoke-static {v2, v3}, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->descendantRect(Landroid/view/ViewGroup;Landroid/view/View;)Landroid/graphics/Rect;

    move-result-object v0

    .line 114
    nop

    .line 115
    sget-object v3, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->LEFT_SLOT_IDS:[Ljava/lang/String;

    array-length v4, v3

    const/4 v5, 0x0

    const/4 v6, 0x0

    :goto_0
    if-ge v5, v4, :cond_6

    aget-object v7, v3, v5

    .line 116
    invoke-direct {p0, v2, v7}, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->findExplicitSlot(Landroid/view/ViewGroup;Ljava/lang/String;)Landroid/view/View;

    move-result-object v7

    .line 117
    if-eqz v7, :cond_5

    invoke-virtual {v7}, Landroid/view/View;->getVisibility()I

    move-result v8

    if-nez v8, :cond_5

    .line 118
    invoke-static {v2, v7}, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->descendantRect(Landroid/view/ViewGroup;Landroid/view/View;)Landroid/graphics/Rect;

    move-result-object v7

    iget v7, v7, Landroid/graphics/Rect;->right:I

    invoke-static {v6, v7}, Ljava/lang/Math;->max(II)I

    move-result v6

    .line 115
    :cond_5
    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    .line 121
    :cond_6
    iget v0, v0, Landroid/graphics/Rect;->left:I

    iget v2, p0, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->shortcutWidth:I

    sub-int/2addr v0, v2

    if-lt v0, v6, :cond_7

    const/4 v1, 0x1

    :cond_7
    return v1

    .line 111
    :cond_8
    :goto_1
    return v1

    .line 108
    :cond_9
    :goto_2
    return v1
.end method

.method private updatePreferenceVisibility()V
    .locals 3

    .line 91
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->preferences:Landroid/content/SharedPreferences;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->preferences:Landroid/content/SharedPreferences;

    .line 92
    const-string v1, "show_simplified_traditional_header_toggle"

    const/4 v2, 0x1

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v2, 0x0

    :goto_0
    iput-boolean v2, p0, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->preferenceHidden:Z

    .line 93
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->applyVisibility()V

    .line 94
    return-void
.end method


# virtual methods
.method protected onAttachedToWindow()V
    .locals 1

    .line 49
    invoke-super {p0}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;->onAttachedToWindow()V

    .line 50
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->preferences:Landroid/content/SharedPreferences;

    .line 51
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->preferences:Landroid/content/SharedPreferences;

    invoke-interface {v0, p0}, Landroid/content/SharedPreferences;->registerOnSharedPreferenceChangeListener(Landroid/content/SharedPreferences$OnSharedPreferenceChangeListener;)V

    .line 52
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v0

    invoke-virtual {v0, p0}, Landroid/view/ViewTreeObserver;->addOnPreDrawListener(Landroid/view/ViewTreeObserver$OnPreDrawListener;)V

    .line 53
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->updatePreferenceVisibility()V

    .line 54
    return-void
.end method

.method protected onDetachedFromWindow()V
    .locals 2

    .line 58
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v0

    .line 59
    invoke-virtual {v0}, Landroid/view/ViewTreeObserver;->isAlive()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-virtual {v0, p0}, Landroid/view/ViewTreeObserver;->removeOnPreDrawListener(Landroid/view/ViewTreeObserver$OnPreDrawListener;)V

    .line 60
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->preferences:Landroid/content/SharedPreferences;

    if-eqz v0, :cond_1

    .line 61
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->preferences:Landroid/content/SharedPreferences;

    invoke-interface {v0, p0}, Landroid/content/SharedPreferences;->unregisterOnSharedPreferenceChangeListener(Landroid/content/SharedPreferences$OnSharedPreferenceChangeListener;)V

    .line 62
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->preferences:Landroid/content/SharedPreferences;

    .line 64
    :cond_1
    invoke-super {p0}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;->onDetachedFromWindow()V

    .line 65
    return-void
.end method

.method public onPreDraw()Z
    .locals 3

    .line 74
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->preferenceHidden:Z

    const/4 v1, 0x1

    if-eqz v0, :cond_0

    return v1

    .line 75
    :cond_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->getMeasuredWidth()I

    move-result v0

    .line 76
    if-lez v0, :cond_1

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->shortcutWidth:I

    .line 77
    :cond_1
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->hasAvailableHeaderSpace()Z

    move-result v0

    .line 78
    xor-int/2addr v0, v1

    iget-boolean v2, p0, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->geometryHidden:Z

    if-ne v2, v0, :cond_2

    return v1

    .line 79
    :cond_2
    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->geometryHidden:Z

    .line 80
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->applyVisibility()V

    .line 81
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->requestLayout()V

    .line 82
    const/4 v0, 0x0

    return v0
.end method

.method public onSharedPreferenceChanged(Landroid/content/SharedPreferences;Ljava/lang/String;)V
    .locals 0

    .line 69
    const-string p1, "show_simplified_traditional_header_toggle"

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->updatePreferenceVisibility()V

    .line 70
    :cond_0
    return-void
.end method

.method public setVisibility(I)V
    .locals 1

    .line 87
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->preferenceHidden:Z

    if-nez v0, :cond_0

    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/SimplifiedTraditionalToggleKeyView;->geometryHidden:Z

    if-eqz v0, :cond_1

    :cond_0
    const/16 p1, 0x8

    :cond_1
    invoke-super {p0, p1}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;->setVisibility(I)V

    .line 88
    return-void
.end method
