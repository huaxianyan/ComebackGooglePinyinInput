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

.field private static final PREFERENCES:Ljava/lang/String; = "floating_keyboard_preferences"

.field private static final SHORTCUTS_KEY:Ljava/lang/String; = "shortcuts"

.field private static final TAG_VIEW:Ljava/lang/String; = "quickbar.self"

.field private static lastSignature:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 6

    .line 60
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

    .line 71
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 72
    return-void
.end method

.method static synthetic access$000(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;Landroid/view/View;)V
    .locals 0

    .line 27
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/QuickBar;->run(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;Landroid/view/View;)V

    return-void
.end method

.method private static activeEntries(Landroid/content/Context;)Ljava/util/List;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            ")",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;",
            ">;"
        }
    .end annotation

    .line 89
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/QuickBar;->readShortcuts(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    .line 90
    if-eqz p0, :cond_5

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    goto :goto_2

    .line 91
    :cond_0
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 92
    const-string v1, "\\|"

    invoke-virtual {p0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    array-length v1, p0

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v1, :cond_3

    aget-object v4, p0, v3

    .line 93
    const-string v5, ":"

    invoke-virtual {v4, v5}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v4

    .line 94
    array-length v5, v4

    const/4 v6, 0x2

    if-ne v5, v6, :cond_2

    const-string v5, "1"

    const/4 v6, 0x1

    aget-object v6, v4, v6

    invoke-virtual {v5, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_1

    goto :goto_1

    .line 95
    :cond_1
    aget-object v4, v4, v2

    invoke-static {v4}, Lcom/google/android/inputmethod/pinyin/QuickBar;->byId(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    move-result-object v4

    .line 96
    if-eqz v4, :cond_2

    invoke-interface {v0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 92
    :cond_2
    :goto_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 98
    :cond_3
    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result p0

    if-eqz p0, :cond_4

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/QuickBar;->defaultEntries()Ljava/util/List;

    move-result-object v0

    :cond_4
    return-object v0

    .line 90
    :cond_5
    :goto_2
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/QuickBar;->defaultEntries()Ljava/util/List;

    move-result-object p0

    return-object p0
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

    .line 75
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 76
    sget-object v1, Lcom/google/android/inputmethod/pinyin/QuickBar;->ALL:[Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    array-length v2, v1

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v2, :cond_0

    aget-object v4, v1, v3

    .line 77
    invoke-interface {v0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 76
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 79
    :cond_0
    return-object v0
.end method

.method public static attach(Landroid/view/View;Z)V
    .locals 3

    .line 178
    if-eqz p0, :cond_6

    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-nez v0, :cond_0

    goto :goto_0

    .line 181
    :cond_0
    if-eqz p1, :cond_1

    invoke-virtual {p0}, Landroid/view/View;->isShown()Z

    move-result v0

    if-nez v0, :cond_1

    return-void

    .line 182
    :cond_1
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    .line 184
    if-nez p1, :cond_2

    .line 185
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/QuickBar;->detach(Landroid/view/ViewGroup;)V

    .line 186
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/QuickBar;->showNativeEntries(Landroid/view/View;)V

    .line 187
    return-void

    .line 190
    :cond_2
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/QuickBar;->hideNativeEntries(Landroid/view/View;)V

    .line 193
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/QuickBar;->readShortcuts(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    .line 194
    const-string v1, "quickbar.self"

    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v1

    .line 195
    if-eqz v1, :cond_4

    .line 196
    sget-object v2, Lcom/google/android/inputmethod/pinyin/QuickBar;->lastSignature:Ljava/lang/String;

    invoke-virtual {p1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_3

    return-void

    .line 197
    :cond_3
    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 199
    :cond_4
    sput-object p1, Lcom/google/android/inputmethod/pinyin/QuickBar;->lastSignature:Ljava/lang/String;

    .line 200
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1, p0}, Lcom/google/android/inputmethod/pinyin/QuickBar;->create(Landroid/content/Context;Landroid/view/View;)Landroid/view/View;

    move-result-object p0

    .line 201
    invoke-virtual {v0, p0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 202
    invoke-virtual {p0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p1

    .line 203
    if-eqz p1, :cond_5

    .line 204
    const/4 v0, -0x1

    iput v0, p1, Landroid/view/ViewGroup$LayoutParams;->width:I

    .line 205
    iput v0, p1, Landroid/view/ViewGroup$LayoutParams;->height:I

    .line 206
    invoke-virtual {p0, p1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 208
    :cond_5
    return-void

    .line 178
    :cond_6
    :goto_0
    return-void
.end method

.method private static buttonParams(Landroid/content/Context;)Landroid/widget/LinearLayout$LayoutParams;
    .locals 4

    .line 257
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F

    .line 258
    const/high16 v0, 0x42600000    # 56.0f

    mul-float v0, v0, p0

    invoke-static {v0}, Ljava/lang/Math;->round(F)I

    move-result v0

    .line 259
    const/high16 v1, 0x40800000    # 4.0f

    mul-float p0, p0, v1

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result p0

    .line 260
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v2, 0x3f800000    # 1.0f

    const/4 v3, 0x0

    invoke-direct {v1, v3, v0, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    .line 261
    const/16 v0, 0x10

    iput v0, v1, Landroid/widget/LinearLayout$LayoutParams;->gravity:I

    .line 262
    invoke-virtual {v1, p0, v3, p0, v3}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V

    .line 263
    return-object v1
.end method

.method private static byId(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;
    .locals 5

    .line 164
    sget-object v0, Lcom/google/android/inputmethod/pinyin/QuickBar;->ALL:[Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    array-length v1, v0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_1

    aget-object v3, v0, v2

    .line 165
    iget-object v4, v3, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;->id:Ljava/lang/String;

    invoke-virtual {v4, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_0

    return-object v3

    .line 164
    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 167
    :cond_1
    const/4 p0, 0x0

    return-object p0
.end method

.method private static clickNative(Landroid/view/View;Ljava/lang/String;)Z
    .locals 2

    .line 313
    instance-of v0, p0, Landroid/view/ViewGroup;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 314
    :cond_0
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/QuickBar;->indexOf(Ljava/lang/String;)I

    move-result p1

    .line 315
    if-gez p1, :cond_1

    return v1

    .line 316
    :cond_1
    check-cast p0, Landroid/view/ViewGroup;

    .line 317
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v0

    if-gt v0, p1, :cond_2

    return v1

    .line 318
    :cond_2
    invoke-virtual {p0, p1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object p0

    .line 319
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object p1

    const-string v0, "SoftKeyView"

    invoke-virtual {p1, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result p1

    if-nez p1, :cond_3

    return v1

    .line 321
    :cond_3
    :try_start_0
    invoke-virtual {p0}, Landroid/view/View;->performClick()Z

    move-result p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return p0

    .line 322
    :catchall_0
    move-exception p0

    .line 323
    return v1
.end method

.method private static create(Landroid/content/Context;Landroid/view/View;)Landroid/view/View;
    .locals 4

    .line 245
    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 246
    const-string v1, "quickbar.self"

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setTag(Ljava/lang/Object;)V

    .line 247
    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 248
    const/16 v1, 0x10

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 250
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/QuickBar;->activeEntries(Landroid/content/Context;)Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    .line 251
    invoke-static {p0, v2, p1}, Lcom/google/android/inputmethod/pinyin/QuickBar;->createButton(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;Landroid/view/View;)Landroid/view/View;

    move-result-object v2

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/QuickBar;->buttonParams(Landroid/content/Context;)Landroid/widget/LinearLayout$LayoutParams;

    move-result-object v3

    invoke-virtual {v0, v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 252
    goto :goto_0

    .line 253
    :cond_0
    return-object v0
.end method

.method private static createButton(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;Landroid/view/View;)Landroid/view/View;
    .locals 2

    .line 268
    new-instance v0, Landroid/widget/ImageView;

    invoke-direct {v0, p0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    .line 269
    sget-object v1, Landroid/widget/ImageView$ScaleType;->CENTER_INSIDE:Landroid/widget/ImageView$ScaleType;

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    .line 270
    iget-object v1, p1, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;->label:Ljava/lang/String;

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setContentDescription(Ljava/lang/CharSequence;)V

    .line 271
    iget-object v1, p1, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;->iconName:Ljava/lang/String;

    invoke-static {p0, v1}, Lcom/google/android/inputmethod/pinyin/QuickBar;->drawable(Landroid/content/Context;Ljava/lang/String;)Landroid/graphics/drawable/Drawable;

    move-result-object v1

    .line 272
    if-eqz v1, :cond_0

    .line 273
    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 276
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/QuickBar;->keyboardIconColor(Landroid/content/Context;)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setColorFilter(I)V

    .line 278
    :cond_0
    new-instance v1, Lcom/google/android/inputmethod/pinyin/QuickBar$1;

    invoke-direct {v1, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/QuickBar$1;-><init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;Landroid/view/View;)V

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 284
    return-object v0
.end method

.method private static defaultEntries()Ljava/util/List;
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;",
            ">;"
        }
    .end annotation

    .line 156
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 157
    sget-object v1, Lcom/google/android/inputmethod/pinyin/QuickBar;->ALL:[Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    array-length v2, v1

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v2, :cond_0

    aget-object v4, v1, v3

    .line 158
    invoke-interface {v0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 157
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 160
    :cond_0
    return-object v0
.end method

.method private static detach(Landroid/view/ViewGroup;)V
    .locals 1

    .line 240
    const-string v0, "quickbar.self"

    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v0

    .line 241
    if-eqz v0, :cond_0

    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 242
    :cond_0
    return-void
.end method

.method private static drawable(Landroid/content/Context;Ljava/lang/String;)Landroid/graphics/drawable/Drawable;
    .locals 3

    .line 296
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const-string v1, "drawable"

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, p1, v1, v2}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result p1

    .line 297
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

    .line 217
    instance-of v0, p0, Landroid/view/ViewGroup;

    if-nez v0, :cond_0

    return-void

    .line 218
    :cond_0
    check-cast p0, Landroid/view/ViewGroup;

    .line 219
    const/4 v0, 0x0

    :goto_0
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    const/4 v2, 0x0

    if-ge v0, v1, :cond_2

    .line 220
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    .line 221
    invoke-virtual {v1}, Landroid/view/View;->getVisibility()I

    move-result v3

    const/16 v4, 0x8

    if-eq v3, v4, :cond_1

    .line 222
    invoke-virtual {v1, v4}, Landroid/view/View;->setVisibility(I)V

    .line 223
    invoke-virtual {v1, v2}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 219
    :cond_1
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 226
    :cond_2
    invoke-virtual {p0, v2}, Landroid/view/ViewGroup;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 227
    return-void
.end method

.method private static indexOf(Ljava/lang/String;)I
    .locals 2

    .line 328
    const/4 v0, 0x0

    :goto_0
    sget-object v1, Lcom/google/android/inputmethod/pinyin/QuickBar;->ALL:[Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    array-length v1, v1

    if-ge v0, v1, :cond_1

    .line 329
    sget-object v1, Lcom/google/android/inputmethod/pinyin/QuickBar;->ALL:[Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    aget-object v1, v1, v0

    iget-object v1, v1, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;->id:Ljava/lang/String;

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    return v0

    .line 328
    :cond_0
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 331
    :cond_1
    const/4 p0, -0x1

    return p0
.end method

.method private static keyboardIconColor(Landroid/content/Context;)I
    .locals 4

    .line 288
    new-instance v0, Landroid/util/TypedValue;

    invoke-direct {v0}, Landroid/util/TypedValue;-><init>()V

    .line 289
    invoke-virtual {p0}, Landroid/content/Context;->getTheme()Landroid/content/res/Resources$Theme;

    move-result-object v1

    const v2, 0x1010036

    const/4 v3, 0x1

    invoke-virtual {v1, v2, v0, v3}, Landroid/content/res/Resources$Theme;->resolveAttribute(ILandroid/util/TypedValue;Z)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 290
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    iget v0, v0, Landroid/util/TypedValue;->resourceId:I

    invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getColor(I)I

    move-result p0

    return p0

    .line 292
    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method private static launch(Landroid/content/Context;Ljava/lang/String;)V
    .locals 2

    .line 336
    nop

    .line 337
    const-string v0, "access_point_theme_setting"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 338
    const-string p1, "com.google.android.apps.inputmethod.libs.theme.preference.ThemeSelectorActivity"

    goto :goto_0

    .line 340
    :cond_0
    const-string v0, "access_point_settings"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1

    .line 341
    const-string p1, "com.google.android.apps.inputmethod.pinyin.preference.SettingsActivity"

    goto :goto_0

    .line 340
    :cond_1
    const/4 p1, 0x0

    .line 343
    :goto_0
    if-nez p1, :cond_2

    return-void

    .line 345
    :cond_2
    :try_start_0
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.intent.action.MAIN"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 346
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1, p1}, Landroid/content/Intent;->setClassName(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 347
    const/high16 p1, 0x10000000

    invoke-virtual {v0, p1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 348
    invoke-virtual {p0, v0}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 351
    goto :goto_1

    .line 349
    :catchall_0
    move-exception p0

    .line 352
    :goto_1
    return-void
.end method

.method private static readShortcuts(Landroid/content/Context;)Ljava/lang/String;
    .locals 3

    .line 110
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/QuickBar;->readShortcutsFromFile(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    .line 111
    if-eqz v0, :cond_0

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_0

    return-object v0

    .line 113
    :cond_0
    const/4 v0, 0x0

    :try_start_0
    const-string v1, "floating_keyboard_preferences"

    const/4 v2, 0x0

    invoke-virtual {p0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v1, "shortcuts"

    .line 114
    invoke-interface {p0, v1, v0}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 113
    return-object p0

    .line 115
    :catchall_0
    move-exception p0

    .line 116
    return-object v0
.end method

.method private static readShortcutsFromFile(Landroid/content/Context;)Ljava/lang/String;
    .locals 6

    .line 121
    nop

    .line 123
    const/4 v0, 0x0

    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object p0

    invoke-virtual {p0}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object p0

    .line 124
    new-instance v1, Ljava/io/File;

    const-string v2, "shared_prefs/floating_keyboard_preferences.xml"

    invoke-direct {v1, p0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 125
    invoke-virtual {v1}, Ljava/io/File;->isFile()Z

    move-result p0

    if-nez p0, :cond_0

    .line 145
    nop

    .line 125
    return-object v0

    .line 126
    :cond_0
    new-instance p0, Ljava/io/FileInputStream;

    invoke-direct {p0, v1}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_4

    .line 127
    :try_start_1
    invoke-virtual {v1}, Ljava/io/File;->length()J

    move-result-wide v1

    long-to-int v2, v1

    new-array v1, v2, [B

    .line 128
    const/4 v3, 0x0

    const/4 v4, 0x0

    .line 129
    :goto_0
    if-ge v4, v2, :cond_2

    .line 130
    sub-int v5, v2, v4

    invoke-virtual {p0, v1, v4, v5}, Ljava/io/FileInputStream;->read([BII)I

    move-result v5

    .line 131
    if-gtz v5, :cond_1

    goto :goto_1

    .line 132
    :cond_1
    add-int/2addr v4, v5

    .line 133
    goto :goto_0

    .line 134
    :cond_2
    :goto_1
    new-instance v2, Ljava/lang/String;

    const-string v5, "UTF-8"

    invoke-direct {v2, v1, v3, v4, v5}, Ljava/lang/String;-><init>([BIILjava/lang/String;)V

    .line 135
    const-string v1, "<string name=\"shortcuts\">"

    .line 136
    invoke-virtual {v2, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v3
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_3

    .line 137
    if-gez v3, :cond_3

    .line 145
    nop

    .line 147
    :try_start_2
    invoke-virtual {p0}, Ljava/io/FileInputStream;->close()V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 150
    goto :goto_2

    .line 148
    :catchall_0
    move-exception p0

    .line 137
    :goto_2
    return-object v0

    .line 138
    :cond_3
    :try_start_3
    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v1

    add-int/2addr v3, v1

    .line 139
    const-string v1, "</string>"

    invoke-virtual {v2, v1, v3}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v1
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_3

    .line 140
    if-gez v1, :cond_4

    .line 145
    nop

    .line 147
    :try_start_4
    invoke-virtual {p0}, Ljava/io/FileInputStream;->close()V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    .line 150
    goto :goto_3

    .line 148
    :catchall_1
    move-exception p0

    .line 140
    :goto_3
    return-object v0

    .line 141
    :cond_4
    :try_start_5
    invoke-virtual {v2, v3, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_3

    .line 145
    nop

    .line 147
    :try_start_6
    invoke-virtual {p0}, Ljava/io/FileInputStream;->close()V
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_2

    .line 150
    goto :goto_4

    .line 148
    :catchall_2
    move-exception p0

    .line 141
    :goto_4
    return-object v0

    .line 142
    :catchall_3
    move-exception v1

    goto :goto_5

    :catchall_4
    move-exception p0

    move-object p0, v0

    .line 143
    :goto_5
    nop

    .line 145
    if-eqz p0, :cond_5

    .line 147
    :try_start_7
    invoke-virtual {p0}, Ljava/io/FileInputStream;->close()V
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_5

    .line 150
    goto :goto_6

    .line 148
    :catchall_5
    move-exception p0

    .line 143
    :cond_5
    :goto_6
    return-object v0
.end method

.method private static run(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;Landroid/view/View;)V
    .locals 1

    .line 301
    iget v0, p1, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;->action:I

    if-nez v0, :cond_0

    iget-object v0, p1, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;->id:Ljava/lang/String;

    invoke-static {p2, v0}, Lcom/google/android/inputmethod/pinyin/QuickBar;->clickNative(Landroid/view/View;Ljava/lang/String;)Z

    move-result p2

    if-eqz p2, :cond_0

    return-void

    .line 302
    :cond_0
    iget-object p1, p1, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;->id:Ljava/lang/String;

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/QuickBar;->launch(Landroid/content/Context;Ljava/lang/String;)V

    .line 303
    return-void
.end method

.method private static showNativeEntries(Landroid/view/View;)V
    .locals 5

    .line 231
    instance-of v0, p0, Landroid/view/ViewGroup;

    if-nez v0, :cond_0

    return-void

    .line 232
    :cond_0
    check-cast p0, Landroid/view/ViewGroup;

    .line 233
    const/4 v0, 0x0

    const/4 v1, 0x0

    :goto_0
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v2

    if-ge v1, v2, :cond_2

    .line 234
    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    .line 235
    invoke-virtual {v2}, Landroid/view/View;->getVisibility()I

    move-result v3

    const/16 v4, 0x8

    if-ne v3, v4, :cond_1

    invoke-virtual {v2, v0}, Landroid/view/View;->setVisibility(I)V

    .line 233
    :cond_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 237
    :cond_2
    return-void
.end method
