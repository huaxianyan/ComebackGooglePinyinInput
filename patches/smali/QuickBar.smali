.class public final Lcom/google/android/inputmethod/pinyin/QuickBar;
.super Ljava/lang/Object;
.source "QuickBar.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;
    }
.end annotation


# static fields
.field private static final ACTION_NATIVE:I = 0x0

.field private static final ALL:[Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

.field private static final TAG_VIEW:Ljava/lang/String; = "quickbar.self"


# direct methods
.method static constructor <clinit>()V
    .locals 6

    .line 53
    const/4 v0, 0x4

    new-array v0, v0, [Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    const-string v2, "ic_access_point_theme_setting_dark_theme"

    const-string v3, "\u4e3b\u9898"

    const-string v4, "access_point_theme_setting"

    const/4 v5, 0x0

    invoke-direct {v1, v4, v2, v3, v5}, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V

    aput-object v1, v0, v5

    new-instance v1, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    const-string v2, "ic_access_point_one_handed_dark_theme"

    const-string v3, "\u5355\u624b\u6a21\u5f0f"

    const-string v4, "access_point_one_handed"

    invoke-direct {v1, v4, v2, v3, v5}, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V

    const/4 v2, 0x1

    aput-object v1, v0, v2

    new-instance v1, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    const-string v2, "ic_access_point_setting_dark_theme"

    const-string v3, "\u8bbe\u7f6e"

    const-string v4, "access_point_settings"

    invoke-direct {v1, v4, v2, v3, v5}, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V

    const/4 v2, 0x2

    aput-object v1, v0, v2

    new-instance v1, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    const-string v2, "ic_access_point_text_editing_dark_theme"

    const-string v3, "\u6587\u672c\u7f16\u8f91"

    const-string v4, "access_point_textediting"

    invoke-direct {v1, v4, v2, v3, v5}, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V

    const/4 v2, 0x3

    aput-object v1, v0, v2

    sput-object v0, Lcom/google/android/inputmethod/pinyin/QuickBar;->ALL:[Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 64
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 65
    return-void
.end method

.method static synthetic access$000(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;Landroid/view/View;)V
    .locals 0

    .line 27
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/QuickBar;->run(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;Landroid/view/View;)V

    return-void
.end method

.method public static allEntries()Ljava/util/List;
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;",
            ">;"
        }
    .end annotation

    .line 68
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 69
    sget-object v1, Lcom/google/android/inputmethod/pinyin/QuickBar;->ALL:[Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    array-length v2, v1

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v2, :cond_0

    aget-object v4, v1, v3

    .line 70
    invoke-interface {v0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 69
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 72
    :cond_0
    return-object v0
.end method

.method public static attach(Landroid/view/View;Z)V
    .locals 1

    .line 83
    if-eqz p0, :cond_5

    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-nez v0, :cond_0

    goto :goto_0

    .line 86
    :cond_0
    if-eqz p1, :cond_1

    invoke-virtual {p0}, Landroid/view/View;->isShown()Z

    move-result v0

    if-nez v0, :cond_1

    return-void

    .line 87
    :cond_1
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    .line 89
    if-nez p1, :cond_2

    .line 90
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/QuickBar;->detach(Landroid/view/ViewGroup;)V

    .line 91
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/QuickBar;->showNativeEntries(Landroid/view/View;)V

    .line 92
    return-void

    .line 95
    :cond_2
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/QuickBar;->hideNativeEntries(Landroid/view/View;)V

    .line 96
    const-string p1, "quickbar.self"

    invoke-virtual {v0, p1}, Landroid/view/ViewGroup;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object p1

    if-eqz p1, :cond_3

    return-void

    .line 97
    :cond_3
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1, p0}, Lcom/google/android/inputmethod/pinyin/QuickBar;->create(Landroid/content/Context;Landroid/view/View;)Landroid/view/View;

    move-result-object p0

    .line 98
    invoke-virtual {v0, p0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 99
    invoke-virtual {p0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p1

    .line 100
    if-eqz p1, :cond_4

    .line 101
    const/4 v0, -0x1

    iput v0, p1, Landroid/view/ViewGroup$LayoutParams;->width:I

    .line 102
    iput v0, p1, Landroid/view/ViewGroup$LayoutParams;->height:I

    .line 103
    invoke-virtual {p0, p1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 105
    :cond_4
    return-void

    .line 83
    :cond_5
    :goto_0
    return-void
.end method

.method private static buttonParams(Landroid/content/Context;)Landroid/widget/LinearLayout$LayoutParams;
    .locals 4

    .line 154
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F

    .line 155
    const/high16 v0, 0x42600000    # 56.0f

    mul-float v0, v0, p0

    invoke-static {v0}, Ljava/lang/Math;->round(F)I

    move-result v0

    .line 156
    const/high16 v1, 0x40800000    # 4.0f

    mul-float p0, p0, v1

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result p0

    .line 157
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v2, 0x3f800000    # 1.0f

    const/4 v3, 0x0

    invoke-direct {v1, v3, v0, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    .line 158
    const/16 v0, 0x10

    iput v0, v1, Landroid/widget/LinearLayout$LayoutParams;->gravity:I

    .line 159
    invoke-virtual {v1, p0, v3, p0, v3}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V

    .line 160
    return-object v1
.end method

.method private static clickNative(Landroid/view/View;Ljava/lang/String;)Z
    .locals 2

    .line 210
    instance-of v0, p0, Landroid/view/ViewGroup;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 211
    :cond_0
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/QuickBar;->indexOf(Ljava/lang/String;)I

    move-result p1

    .line 212
    if-gez p1, :cond_1

    return v1

    .line 213
    :cond_1
    check-cast p0, Landroid/view/ViewGroup;

    .line 214
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v0

    if-gt v0, p1, :cond_2

    return v1

    .line 215
    :cond_2
    invoke-virtual {p0, p1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object p0

    .line 216
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object p1

    const-string v0, "SoftKeyView"

    invoke-virtual {p1, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result p1

    if-nez p1, :cond_3

    return v1

    .line 218
    :cond_3
    :try_start_0
    invoke-virtual {p0}, Landroid/view/View;->performClick()Z

    move-result p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return p0

    .line 219
    :catchall_0
    move-exception p0

    .line 220
    return v1
.end method

.method private static create(Landroid/content/Context;Landroid/view/View;)Landroid/view/View;
    .locals 6

    .line 142
    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 143
    const-string v1, "quickbar.self"

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setTag(Ljava/lang/Object;)V

    .line 144
    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 145
    const/16 v2, 0x10

    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 147
    sget-object v2, Lcom/google/android/inputmethod/pinyin/QuickBar;->ALL:[Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    array-length v3, v2

    :goto_0
    if-ge v1, v3, :cond_0

    aget-object v4, v2, v1

    .line 148
    invoke-static {p0, v4, p1}, Lcom/google/android/inputmethod/pinyin/QuickBar;->createButton(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;Landroid/view/View;)Landroid/view/View;

    move-result-object v4

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/QuickBar;->buttonParams(Landroid/content/Context;)Landroid/widget/LinearLayout$LayoutParams;

    move-result-object v5

    invoke-virtual {v0, v4, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 147
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 150
    :cond_0
    return-object v0
.end method

.method private static createButton(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;Landroid/view/View;)Landroid/view/View;
    .locals 2

    .line 165
    new-instance v0, Landroid/widget/ImageView;

    invoke-direct {v0, p0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    .line 166
    sget-object v1, Landroid/widget/ImageView$ScaleType;->CENTER_INSIDE:Landroid/widget/ImageView$ScaleType;

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    .line 167
    iget-object v1, p1, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;->label:Ljava/lang/String;

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setContentDescription(Ljava/lang/CharSequence;)V

    .line 168
    iget-object v1, p1, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;->iconName:Ljava/lang/String;

    invoke-static {p0, v1}, Lcom/google/android/inputmethod/pinyin/QuickBar;->drawable(Landroid/content/Context;Ljava/lang/String;)Landroid/graphics/drawable/Drawable;

    move-result-object v1

    .line 169
    if-eqz v1, :cond_0

    .line 170
    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 173
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/QuickBar;->keyboardIconColor(Landroid/content/Context;)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setColorFilter(I)V

    .line 175
    :cond_0
    new-instance v1, Lcom/google/android/inputmethod/pinyin/QuickBar$1;

    invoke-direct {v1, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/QuickBar$1;-><init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;Landroid/view/View;)V

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 181
    return-object v0
.end method

.method private static detach(Landroid/view/ViewGroup;)V
    .locals 1

    .line 137
    const-string v0, "quickbar.self"

    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v0

    .line 138
    if-eqz v0, :cond_0

    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 139
    :cond_0
    return-void
.end method

.method private static drawable(Landroid/content/Context;Ljava/lang/String;)Landroid/graphics/drawable/Drawable;
    .locals 3

    .line 193
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const-string v1, "drawable"

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, p1, v1, v2}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result p1

    .line 194
    if-nez p1, :cond_0

    const/4 p0, 0x0

    goto :goto_0

    :cond_0
    invoke-virtual {p0, p1}, Landroid/content/Context;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object p0

    :goto_0
    return-object p0
.end method

.method private static hideNativeEntries(Landroid/view/View;)V
    .locals 5

    .line 114
    instance-of v0, p0, Landroid/view/ViewGroup;

    if-nez v0, :cond_0

    return-void

    .line 115
    :cond_0
    check-cast p0, Landroid/view/ViewGroup;

    .line 116
    const/4 v0, 0x0

    :goto_0
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    const/4 v2, 0x0

    if-ge v0, v1, :cond_2

    .line 117
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    .line 118
    invoke-virtual {v1}, Landroid/view/View;->getVisibility()I

    move-result v3

    const/16 v4, 0x8

    if-eq v3, v4, :cond_1

    .line 119
    invoke-virtual {v1, v4}, Landroid/view/View;->setVisibility(I)V

    .line 120
    invoke-virtual {v1, v2}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 116
    :cond_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 123
    :cond_2
    invoke-virtual {p0, v2}, Landroid/view/ViewGroup;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 124
    return-void
.end method

.method private static indexOf(Ljava/lang/String;)I
    .locals 2

    .line 225
    const/4 v0, 0x0

    :goto_0
    sget-object v1, Lcom/google/android/inputmethod/pinyin/QuickBar;->ALL:[Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    array-length v1, v1

    if-ge v0, v1, :cond_1

    .line 226
    sget-object v1, Lcom/google/android/inputmethod/pinyin/QuickBar;->ALL:[Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    aget-object v1, v1, v0

    iget-object v1, v1, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;->id:Ljava/lang/String;

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    return v0

    .line 225
    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 228
    :cond_1
    const/4 p0, -0x1

    return p0
.end method

.method private static keyboardIconColor(Landroid/content/Context;)I
    .locals 4

    .line 185
    new-instance v0, Landroid/util/TypedValue;

    invoke-direct {v0}, Landroid/util/TypedValue;-><init>()V

    .line 186
    invoke-virtual {p0}, Landroid/content/Context;->getTheme()Landroid/content/res/Resources$Theme;

    move-result-object v1

    const v2, 0x1010036

    const/4 v3, 0x1

    invoke-virtual {v1, v2, v0, v3}, Landroid/content/res/Resources$Theme;->resolveAttribute(ILandroid/util/TypedValue;Z)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 187
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    iget v0, v0, Landroid/util/TypedValue;->resourceId:I

    invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getColor(I)I

    move-result p0

    return p0

    .line 189
    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method private static launch(Landroid/content/Context;Ljava/lang/String;)V
    .locals 2

    .line 233
    nop

    .line 234
    const-string v0, "access_point_theme_setting"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 235
    const-string p1, "com.google.android.apps.inputmethod.libs.theme.preference.ThemeSelectorActivity"

    goto :goto_0

    .line 237
    :cond_0
    const-string v0, "access_point_settings"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1

    .line 238
    const-string p1, "com.google.android.apps.inputmethod.pinyin.preference.SettingsActivity"

    goto :goto_0

    .line 237
    :cond_1
    const/4 p1, 0x0

    .line 240
    :goto_0
    if-nez p1, :cond_2

    return-void

    .line 242
    :cond_2
    :try_start_0
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.intent.action.MAIN"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 243
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1, p1}, Landroid/content/Intent;->setClassName(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 244
    const/high16 p1, 0x10000000

    invoke-virtual {v0, p1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 245
    invoke-virtual {p0, v0}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 248
    goto :goto_1

    .line 246
    :catchall_0
    move-exception p0

    .line 249
    :goto_1
    return-void
.end method

.method private static run(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;Landroid/view/View;)V
    .locals 1

    .line 198
    iget v0, p1, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;->action:I

    if-nez v0, :cond_0

    iget-object v0, p1, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;->id:Ljava/lang/String;

    invoke-static {p2, v0}, Lcom/google/android/inputmethod/pinyin/QuickBar;->clickNative(Landroid/view/View;Ljava/lang/String;)Z

    move-result p2

    if-eqz p2, :cond_0

    return-void

    .line 199
    :cond_0
    iget-object p1, p1, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;->id:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/QuickBar;->launch(Landroid/content/Context;Ljava/lang/String;)V

    .line 200
    return-void
.end method

.method private static showNativeEntries(Landroid/view/View;)V
    .locals 5

    .line 128
    instance-of v0, p0, Landroid/view/ViewGroup;

    if-nez v0, :cond_0

    return-void

    .line 129
    :cond_0
    check-cast p0, Landroid/view/ViewGroup;

    .line 130
    const/4 v0, 0x0

    const/4 v1, 0x0

    :goto_0
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v2

    if-ge v1, v2, :cond_2

    .line 131
    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    .line 132
    invoke-virtual {v2}, Landroid/view/View;->getVisibility()I

    move-result v3

    const/16 v4, 0x8

    if-ne v3, v4, :cond_1

    invoke-virtual {v2, v0}, Landroid/view/View;->setVisibility(I)V

    .line 130
    :cond_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 134
    :cond_2
    return-void
.end method
