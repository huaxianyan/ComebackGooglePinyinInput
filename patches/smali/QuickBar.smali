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
.field private static final ACTION_SETTINGS:I = 0x2

.field private static final ACTION_THEME:I = 0x1

.field private static final ALL:[Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

.field private static final TAG_VIEW:Ljava/lang/String; = "quickbar.self"


# direct methods
.method static constructor <clinit>()V
    .locals 7

    .line 49
    const/4 v0, 0x2

    new-array v1, v0, [Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    new-instance v2, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    const-string v3, "theme"

    const-string v4, "ic_access_point_theme_setting_dark_theme"

    const-string v5, "\u4e3b\u9898"

    const/4 v6, 0x1

    invoke-direct {v2, v3, v4, v5, v6}, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V

    const/4 v3, 0x0

    aput-object v2, v1, v3

    new-instance v2, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    const-string v3, "ic_access_point_setting_dark_theme"

    const-string v4, "\u8bbe\u7f6e"

    const-string v5, "settings"

    invoke-direct {v2, v5, v3, v4, v0}, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V

    aput-object v2, v1, v6

    sput-object v1, Lcom/google/android/inputmethod/pinyin/QuickBar;->ALL:[Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 56
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 57
    return-void
.end method

.method static synthetic access$000(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;)V
    .locals 0

    .line 26
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/QuickBar;->run(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;)V

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

    .line 60
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 61
    sget-object v1, Lcom/google/android/inputmethod/pinyin/QuickBar;->ALL:[Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    array-length v2, v1

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v2, :cond_0

    aget-object v4, v1, v3

    .line 62
    invoke-interface {v0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 61
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 64
    :cond_0
    return-object v0
.end method

.method public static attach(Landroid/view/View;Z)V
    .locals 1

    .line 75
    if-eqz p0, :cond_4

    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-nez v0, :cond_0

    goto :goto_0

    .line 76
    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    .line 78
    if-nez p1, :cond_1

    .line 79
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/QuickBar;->detach(Landroid/view/ViewGroup;)V

    .line 80
    return-void

    .line 83
    :cond_1
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/QuickBar;->hideNativeEntries(Landroid/view/View;)V

    .line 84
    const-string p1, "quickbar.self"

    invoke-virtual {v0, p1}, Landroid/view/ViewGroup;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object p1

    if-eqz p1, :cond_2

    return-void

    .line 85
    :cond_2
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/QuickBar;->create(Landroid/content/Context;)Landroid/view/View;

    move-result-object p1

    .line 87
    invoke-static {v0, p0}, Lcom/google/android/inputmethod/pinyin/QuickBar;->insertionIndex(Landroid/view/ViewGroup;Landroid/view/View;)I

    move-result p0

    invoke-virtual {v0, p1, p0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;I)V

    .line 88
    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p0

    .line 89
    if-eqz p0, :cond_3

    .line 90
    const/4 v0, -0x1

    iput v0, p0, Landroid/view/ViewGroup$LayoutParams;->width:I

    .line 91
    iput v0, p0, Landroid/view/ViewGroup$LayoutParams;->height:I

    .line 92
    invoke-virtual {p1, p0}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 94
    :cond_3
    return-void

    .line 75
    :cond_4
    :goto_0
    return-void
.end method

.method private static buttonParams(Landroid/content/Context;Z)Landroid/widget/LinearLayout$LayoutParams;
    .locals 2

    .line 140
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F

    const/high16 v0, 0x42400000    # 48.0f

    mul-float p0, p0, v0

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result p0

    .line 141
    if-eqz p1, :cond_0

    .line 142
    new-instance p1, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v0, 0x0

    const/high16 v1, 0x3f800000    # 1.0f

    invoke-direct {p1, v0, p0, v1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    goto :goto_0

    .line 143
    :cond_0
    new-instance p1, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {p1, p0, p0}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 144
    :goto_0
    const/16 p0, 0x10

    iput p0, p1, Landroid/widget/LinearLayout$LayoutParams;->gravity:I

    .line 145
    return-object p1
.end method

.method private static create(Landroid/content/Context;)Landroid/view/View;
    .locals 6

    .line 127
    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 128
    const-string v1, "quickbar.self"

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setTag(Ljava/lang/Object;)V

    .line 129
    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 130
    const/16 v2, 0x10

    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 132
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/QuickBar;->allEntries()Ljava/util/List;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    .line 133
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/QuickBar;->allEntries()Ljava/util/List;

    move-result-object v3

    invoke-interface {v3}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_0
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_1

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    .line 134
    invoke-static {p0, v4}, Lcom/google/android/inputmethod/pinyin/QuickBar;->createButton(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;)Landroid/view/View;

    move-result-object v4

    if-lez v2, :cond_0

    const/4 v5, 0x1

    goto :goto_1

    :cond_0
    const/4 v5, 0x0

    :goto_1
    invoke-static {p0, v5}, Lcom/google/android/inputmethod/pinyin/QuickBar;->buttonParams(Landroid/content/Context;Z)Landroid/widget/LinearLayout$LayoutParams;

    move-result-object v5

    invoke-virtual {v0, v4, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 135
    goto :goto_0

    .line 136
    :cond_1
    return-object v0
.end method

.method private static createButton(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;)Landroid/view/View;
    .locals 2

    .line 149
    new-instance v0, Landroid/widget/ImageView;

    invoke-direct {v0, p0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    .line 150
    sget-object v1, Landroid/widget/ImageView$ScaleType;->CENTER_INSIDE:Landroid/widget/ImageView$ScaleType;

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    .line 151
    iget-object v1, p1, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;->label:Ljava/lang/String;

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setContentDescription(Ljava/lang/CharSequence;)V

    .line 152
    iget-object v1, p1, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;->iconName:Ljava/lang/String;

    invoke-static {p0, v1}, Lcom/google/android/inputmethod/pinyin/QuickBar;->drawable(Landroid/content/Context;Ljava/lang/String;)Landroid/graphics/drawable/Drawable;

    move-result-object v1

    .line 153
    if-eqz v1, :cond_0

    .line 154
    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 157
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/QuickBar;->keyboardIconColor(Landroid/content/Context;)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setColorFilter(I)V

    .line 159
    :cond_0
    new-instance v1, Lcom/google/android/inputmethod/pinyin/QuickBar$1;

    invoke-direct {v1, p0, p1}, Lcom/google/android/inputmethod/pinyin/QuickBar$1;-><init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;)V

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 165
    return-object v0
.end method

.method private static detach(Landroid/view/ViewGroup;)V
    .locals 1

    .line 122
    const-string v0, "quickbar.self"

    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v0

    .line 123
    if-eqz v0, :cond_0

    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 124
    :cond_0
    return-void
.end method

.method private static drawable(Landroid/content/Context;Ljava/lang/String;)Landroid/graphics/drawable/Drawable;
    .locals 3

    .line 177
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const-string v1, "drawable"

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, p1, v1, v2}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result p1

    .line 178
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

    .line 104
    instance-of v0, p0, Landroid/view/ViewGroup;

    if-nez v0, :cond_0

    return-void

    .line 105
    :cond_0
    check-cast p0, Landroid/view/ViewGroup;

    .line 106
    const/4 v0, 0x0

    :goto_0
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    const/4 v2, 0x0

    if-ge v0, v1, :cond_2

    .line 107
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    .line 108
    invoke-virtual {v1}, Landroid/view/View;->getVisibility()I

    move-result v3

    const/16 v4, 0x8

    if-eq v3, v4, :cond_1

    .line 109
    invoke-virtual {v1, v4}, Landroid/view/View;->setVisibility(I)V

    .line 110
    invoke-virtual {v1, v2}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 106
    :cond_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 113
    :cond_2
    invoke-virtual {p0, v2}, Landroid/view/ViewGroup;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 114
    return-void
.end method

.method private static insertionIndex(Landroid/view/ViewGroup;Landroid/view/View;)I
    .locals 0

    .line 117
    invoke-virtual {p0, p1}, Landroid/view/ViewGroup;->indexOfChild(Landroid/view/View;)I

    move-result p1

    .line 118
    if-gez p1, :cond_0

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result p0

    goto :goto_0

    :cond_0
    add-int/lit8 p0, p1, 0x1

    :goto_0
    return p0
.end method

.method private static keyboardIconColor(Landroid/content/Context;)I
    .locals 4

    .line 169
    new-instance v0, Landroid/util/TypedValue;

    invoke-direct {v0}, Landroid/util/TypedValue;-><init>()V

    .line 170
    invoke-virtual {p0}, Landroid/content/Context;->getTheme()Landroid/content/res/Resources$Theme;

    move-result-object v1

    const v2, 0x1010036

    const/4 v3, 0x1

    invoke-virtual {v1, v2, v0, v3}, Landroid/content/res/Resources$Theme;->resolveAttribute(ILandroid/util/TypedValue;Z)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 171
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    iget v0, v0, Landroid/util/TypedValue;->resourceId:I

    invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getColor(I)I

    move-result p0

    return p0

    .line 173
    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method private static launch(Landroid/content/Context;Ljava/lang/String;)V
    .locals 2

    .line 198
    :try_start_0
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.intent.action.MAIN"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 199
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1, p1}, Landroid/content/Intent;->setClassName(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 200
    const/high16 p1, 0x10000000

    invoke-virtual {v0, p1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 201
    invoke-virtual {p0, v0}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 204
    goto :goto_0

    .line 202
    :catchall_0
    move-exception p0

    .line 205
    :goto_0
    return-void
.end method

.method private static run(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;)V
    .locals 0

    .line 182
    iget p1, p1, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;->action:I

    packed-switch p1, :pswitch_data_0

    goto :goto_0

    .line 188
    :pswitch_0
    const-string p1, "com.google.android.apps.inputmethod.pinyin.preference.SettingsActivity"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/QuickBar;->launch(Landroid/content/Context;Ljava/lang/String;)V

    .line 190
    goto :goto_0

    .line 184
    :pswitch_1
    const-string p1, "com.google.android.apps.inputmethod.libs.theme.preference.ThemeSelectorActivity"

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/QuickBar;->launch(Landroid/content/Context;Ljava/lang/String;)V

    .line 186
    nop

    .line 194
    :goto_0
    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method
