.class public final Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;
.super Ljava/lang/Object;
.source "HeaderActionSlot.java"


# static fields
.field private static final ATTR_ICON_ALPHA:I = 0x7f010087

.field private static final ATTR_ICON_LEFT:I = 0x7f01008a

.field private static final ATTR_ICON_RIGHT:I = 0x7f01008b

.field private static final DIVIDER_TAG:Ljava/lang/String; = ".divider.vertical.for-candidate-key"

.field private static final ID_SHOW_MORE_CANDIDATES:I = 0x7f0f0149

.field private static final RAIL_WIDTH_RES_ID:I = 0x7f0d0206


# instance fields
.field private final chrome:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;

.field private final icon:Landroid/widget/ImageView;

.field private final kind:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

.field private final visualSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;


# direct methods
.method public constructor <init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;)V
    .locals 5

    .line 34
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 35
    if-eqz p1, :cond_1

    if-eqz p2, :cond_1

    if-eqz p3, :cond_1

    if-eqz p4, :cond_1

    .line 38
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->visualSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;

    .line 39
    iput-object p4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->chrome:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;

    .line 40
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->kind:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

    .line 41
    new-instance p2, Landroid/widget/ImageView;

    invoke-direct {p2, p1}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->icon:Landroid/widget/ImageView;

    .line 42
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->icon:Landroid/widget/ImageView;

    sget-object v0, Landroid/widget/ImageView$ScaleType;->CENTER_INSIDE:Landroid/widget/ImageView$ScaleType;

    invoke-virtual {p2, v0}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    .line 43
    nop

    .line 44
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p2

    invoke-virtual {p2}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p2

    iget p2, p2, Landroid/util/DisplayMetrics;->density:F

    const/high16 v0, 0x41c00000    # 24.0f

    mul-float p2, p2, v0

    invoke-static {p2}, Ljava/lang/Math;->round(F)I

    move-result p2

    .line 43
    const/4 v0, 0x1

    invoke-static {v0, p2}, Ljava/lang/Math;->max(II)I

    move-result p2

    .line 45
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->visualSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->getContentHost()Landroid/widget/FrameLayout;

    move-result-object v1

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->icon:Landroid/widget/ImageView;

    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;

    const/16 v4, 0x11

    invoke-direct {v3, p2, p2, v4}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    invoke-virtual {v1, v2, v3}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 47
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->visualSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;

    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->getSeparator()Landroid/view/View;

    move-result-object p2

    const/16 v1, 0x8

    invoke-virtual {p2, v1}, Landroid/view/View;->setVisibility(I)V

    .line 48
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->visualSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;

    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->getRailSeparator()Landroid/view/View;

    move-result-object p2

    invoke-virtual {p2, v1}, Landroid/view/View;->setVisibility(I)V

    .line 49
    new-instance p2, Landroid/widget/ImageView;

    invoke-direct {p2, p1}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    .line 50
    sget-object v1, Landroid/widget/ImageView$ScaleType;->FIT_XY:Landroid/widget/ImageView$ScaleType;

    invoke-virtual {p2, v1}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    .line 51
    invoke-virtual {p4, p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->newDivider(Landroid/content/Context;)Landroid/graphics/drawable/Drawable;

    move-result-object p1

    invoke-virtual {p2, p1}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 52
    invoke-virtual {p4}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->getDividerAlpha()F

    move-result p1

    invoke-virtual {p2, p1}, Landroid/widget/ImageView;->setAlpha(F)V

    .line 53
    invoke-virtual {p4}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->getDividerPaddingTop()I

    move-result p1

    .line 54
    invoke-virtual {p4}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->getDividerPaddingBottom()I

    move-result v1

    .line 53
    const/4 v2, 0x0

    invoke-virtual {p2, v2, p1, v2, v1}, Landroid/widget/ImageView;->setPadding(IIII)V

    .line 55
    new-instance p1, Landroid/widget/FrameLayout$LayoutParams;

    .line 56
    invoke-virtual {p4}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->getDividerWidth()I

    move-result p4

    invoke-static {v0, p4}, Ljava/lang/Math;->max(II)I

    move-result p4

    .line 58
    sget-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;->NEXT:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

    if-ne p3, v0, :cond_0

    const p3, 0x800003

    goto :goto_0

    :cond_0
    const p3, 0x800005

    :goto_0
    or-int/lit8 p3, p3, 0x10

    const/4 v0, -0x1

    invoke-direct {p1, p4, v0, p3}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    .line 60
    iget-object p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->visualSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;

    invoke-virtual {p3}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->getRoot()Landroid/view/View;

    move-result-object p3

    check-cast p3, Landroid/widget/FrameLayout;

    invoke-virtual {p3, p2, p1}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 61
    return-void

    .line 36
    :cond_1
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "action chrome metadata must not be null"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method static synthetic access$000(Landroid/view/View;Landroid/view/View;Landroid/view/View;Z)V
    .locals 0

    .line 20
    invoke-static {p0, p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->syncClipboardDividers(Landroid/view/View;Landroid/view/View;Landroid/view/View;Z)V

    return-void
.end method

.method public static captureNativeChrome(Landroid/view/View;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;
    .locals 20

    .line 99
    if-eqz p0, :cond_e

    .line 100
    invoke-virtual/range {p0 .. p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 101
    invoke-virtual/range {p0 .. p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    .line 102
    instance-of v2, v1, Landroid/view/ViewGroup;

    const/4 v3, 0x0

    if-eqz v2, :cond_0

    check-cast v1, Landroid/view/ViewGroup;

    goto :goto_0

    :cond_0
    move-object v1, v3

    .line 103
    :goto_0
    const/4 v2, 0x0

    if-nez v1, :cond_1

    const/4 v14, 0x0

    goto :goto_1

    :cond_1
    invoke-virtual {v1}, Landroid/view/ViewGroup;->getPaddingLeft()I

    move-result v4

    move v14, v4

    .line 104
    :goto_1
    if-nez v1, :cond_2

    const/4 v15, 0x0

    goto :goto_2

    :cond_2
    invoke-virtual {v1}, Landroid/view/ViewGroup;->getPaddingRight()I

    move-result v4

    move v15, v4

    .line 105
    :goto_2
    if-nez v1, :cond_3

    move-object v1, v3

    goto :goto_3

    :cond_3
    const v4, 0x7f0f0149

    invoke-virtual {v1, v4}, Landroid/view/ViewGroup;->findViewById(I)Landroid/view/View;

    move-result-object v1

    .line 106
    :goto_3
    if-nez v1, :cond_4

    const/4 v4, 0x0

    goto :goto_4

    .line 107
    :cond_4
    invoke-virtual {v1}, Landroid/view/View;->getWidth()I

    move-result v4

    invoke-virtual {v1}, Landroid/view/View;->getMeasuredWidth()I

    move-result v5

    invoke-static {v4, v5}, Ljava/lang/Math;->max(II)I

    move-result v4

    .line 108
    :goto_4
    if-gtz v4, :cond_5

    if-eqz v1, :cond_5

    invoke-virtual {v1}, Landroid/view/View;->getMinimumWidth()I

    move-result v4

    .line 109
    :cond_5
    if-gtz v4, :cond_6

    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v4

    const v5, 0x7f0d0206

    invoke-virtual {v4, v5}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result v4

    :cond_6
    move v13, v4

    .line 111
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->findDivider(Landroid/view/View;)Landroid/view/View;

    move-result-object v1

    .line 112
    instance-of v4, v1, Landroid/widget/ImageView;

    if-eqz v4, :cond_7

    move-object v4, v1

    check-cast v4, Landroid/widget/ImageView;

    goto :goto_5

    :cond_7
    move-object v4, v3

    .line 113
    :goto_5
    if-nez v4, :cond_8

    move-object v6, v3

    goto :goto_6

    .line 114
    :cond_8
    invoke-static {v4}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->freezeDrawable(Landroid/widget/ImageView;)Landroid/graphics/drawable/Drawable;

    move-result-object v5

    move-object v6, v5

    .line 115
    :goto_6
    if-nez v1, :cond_9

    goto :goto_7

    :cond_9
    invoke-virtual {v1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    .line 116
    :goto_7
    if-eqz v3, :cond_a

    iget v5, v3, Landroid/view/ViewGroup$LayoutParams;->width:I

    if-lez v5, :cond_a

    .line 117
    iget v3, v3, Landroid/view/ViewGroup$LayoutParams;->width:I

    move/from16 v16, v3

    goto :goto_8

    :cond_a
    const/4 v3, 0x1

    const/16 v16, 0x1

    .line 119
    :goto_8
    const v3, 0x7f01008a

    invoke-static {v0, v3}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->resolveDrawable(Landroid/content/Context;I)Landroid/graphics/drawable/Drawable;

    move-result-object v8

    .line 120
    const v3, 0x7f01008b

    invoke-static {v0, v3}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->resolveDrawable(Landroid/content/Context;I)Landroid/graphics/drawable/Drawable;

    move-result-object v10

    .line 125
    const v3, 0x7f010087

    invoke-static {v0, v3}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->resolveAlpha(Landroid/content/Context;I)F

    move-result v12

    .line 126
    move-object/from16 v0, p0

    check-cast v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;

    .line 127
    invoke-interface {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;->createCandidateChromeSlot()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;

    move-result-object v0

    .line 128
    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->getCandidateLabelCurrentColor()Ljava/lang/Integer;

    move-result-object v19

    .line 129
    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->clear()V

    .line 130
    new-instance v5, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;

    .line 131
    if-nez v4, :cond_b

    const/high16 v0, 0x3f800000    # 1.0f

    const/high16 v7, 0x3f800000    # 1.0f

    goto :goto_9

    :cond_b
    invoke-static {v4}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->effectiveImageAlpha(Landroid/widget/ImageView;)F

    move-result v0

    move v7, v0

    .line 135
    :goto_9
    if-nez v1, :cond_c

    const/16 v17, 0x0

    goto :goto_a

    :cond_c
    invoke-virtual {v1}, Landroid/view/View;->getPaddingTop()I

    move-result v0

    move/from16 v17, v0

    .line 136
    :goto_a
    if-nez v1, :cond_d

    const/16 v18, 0x0

    goto :goto_b

    :cond_d
    invoke-virtual {v1}, Landroid/view/View;->getPaddingBottom()I

    move-result v2

    move/from16 v18, v2

    :goto_b
    move-object v9, v8

    move-object v11, v10

    invoke-direct/range {v5 .. v19}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;-><init>(Landroid/graphics/drawable/Drawable;FLandroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;FIIIIIILjava/lang/Integer;)V

    .line 130
    return-object v5

    .line 99
    :cond_e
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "holder is missing"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method private static effectiveAlpha(Landroid/view/View;)F
    .locals 2

    .line 237
    nop

    .line 238
    const/high16 v0, 0x3f800000    # 1.0f

    .line 239
    :goto_0
    if-eqz p0, :cond_1

    .line 240
    invoke-virtual {p0}, Landroid/view/View;->getAlpha()F

    move-result v1

    mul-float v0, v0, v1

    .line 241
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object p0

    .line 242
    instance-of v1, p0, Landroid/view/View;

    if-eqz v1, :cond_0

    check-cast p0, Landroid/view/View;

    goto :goto_1

    :cond_0
    const/4 p0, 0x0

    .line 243
    :goto_1
    goto :goto_0

    .line 244
    :cond_1
    return v0
.end method

.method private static effectiveAncestorAlpha(Landroid/view/View;)F
    .locals 2

    .line 226
    nop

    .line 227
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object p0

    const/high16 v0, 0x3f800000    # 1.0f

    .line 228
    :goto_0
    instance-of v1, p0, Landroid/view/View;

    if-eqz v1, :cond_0

    .line 229
    check-cast p0, Landroid/view/View;

    .line 230
    invoke-virtual {p0}, Landroid/view/View;->getAlpha()F

    move-result v1

    mul-float v0, v0, v1

    .line 231
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object p0

    .line 232
    goto :goto_0

    .line 233
    :cond_0
    return v0
.end method

.method private static effectiveImageAlpha(Landroid/widget/ImageView;)F
    .locals 1

    .line 222
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->effectiveAlpha(Landroid/view/View;)F

    move-result v0

    invoke-virtual {p0}, Landroid/widget/ImageView;->getImageAlpha()I

    move-result p0

    int-to-float p0, p0

    mul-float v0, v0, p0

    const/high16 p0, 0x437f0000    # 255.0f

    div-float/2addr v0, p0

    return v0
.end method

.method private static findDivider(Landroid/view/View;)Landroid/view/View;
    .locals 3

    .line 248
    const/4 v0, 0x0

    if-nez p0, :cond_0

    return-object v0

    .line 249
    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getTag()Ljava/lang/Object;

    move-result-object v1

    .line 250
    if-eqz v1, :cond_1

    const-string v2, ".divider.vertical.for-candidate-key"

    invoke-virtual {v1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    return-object p0

    .line 251
    :cond_1
    instance-of v1, p0, Landroid/view/ViewGroup;

    if-nez v1, :cond_2

    return-object v0

    .line 252
    :cond_2
    check-cast p0, Landroid/view/ViewGroup;

    .line 253
    const/4 v1, 0x0

    :goto_0
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v2

    if-ge v1, v2, :cond_4

    .line 254
    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->findDivider(Landroid/view/View;)Landroid/view/View;

    move-result-object v2

    .line 255
    if-eqz v2, :cond_3

    return-object v2

    .line 253
    :cond_3
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 257
    :cond_4
    return-object v0
.end method

.method private static freezeDrawable(Landroid/widget/ImageView;)Landroid/graphics/drawable/Drawable;
    .locals 7

    .line 140
    invoke-virtual {p0}, Landroid/widget/ImageView;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v0

    .line 141
    if-nez v0, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 142
    :cond_0
    invoke-virtual {p0}, Landroid/widget/ImageView;->getWidth()I

    move-result v1

    invoke-virtual {p0}, Landroid/widget/ImageView;->getPaddingLeft()I

    move-result v2

    sub-int/2addr v1, v2

    .line 143
    invoke-virtual {p0}, Landroid/widget/ImageView;->getPaddingRight()I

    move-result v2

    sub-int/2addr v1, v2

    .line 142
    const/4 v2, 0x1

    invoke-static {v2, v1}, Ljava/lang/Math;->max(II)I

    move-result v1

    .line 144
    invoke-virtual {p0}, Landroid/widget/ImageView;->getHeight()I

    move-result v3

    invoke-virtual {p0}, Landroid/widget/ImageView;->getPaddingTop()I

    move-result v4

    sub-int/2addr v3, v4

    .line 145
    invoke-virtual {p0}, Landroid/widget/ImageView;->getPaddingBottom()I

    move-result v4

    sub-int/2addr v3, v4

    .line 144
    invoke-static {v2, v3}, Ljava/lang/Math;->max(II)I

    move-result v3

    .line 146
    if-gt v1, v2, :cond_1

    invoke-virtual {v0}, Landroid/graphics/drawable/Drawable;->getIntrinsicWidth()I

    move-result v1

    invoke-static {v2, v1}, Ljava/lang/Math;->max(II)I

    move-result v1

    .line 147
    :cond_1
    if-gt v3, v2, :cond_2

    invoke-virtual {v0}, Landroid/graphics/drawable/Drawable;->getIntrinsicHeight()I

    move-result v3

    invoke-static {v2, v3}, Ljava/lang/Math;->max(II)I

    move-result v3

    .line 148
    :cond_2
    sget-object v2, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v1, v3, v2}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v2

    .line 149
    new-instance v4, Landroid/graphics/Canvas;

    invoke-direct {v4, v2}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    .line 150
    invoke-virtual {v0}, Landroid/graphics/drawable/Drawable;->copyBounds()Landroid/graphics/Rect;

    move-result-object v5

    .line 151
    const/4 v6, 0x0

    invoke-virtual {v0, v6, v6, v1, v3}, Landroid/graphics/drawable/Drawable;->setBounds(IIII)V

    .line 152
    invoke-virtual {v0, v4}, Landroid/graphics/drawable/Drawable;->draw(Landroid/graphics/Canvas;)V

    .line 153
    invoke-virtual {v0, v5}, Landroid/graphics/drawable/Drawable;->setBounds(Landroid/graphics/Rect;)V

    .line 154
    new-instance v0, Landroid/graphics/drawable/BitmapDrawable;

    invoke-virtual {p0}, Landroid/widget/ImageView;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-direct {v0, p0, v2}, Landroid/graphics/drawable/BitmapDrawable;-><init>(Landroid/content/res/Resources;Landroid/graphics/Bitmap;)V

    .line 155
    invoke-virtual {v0, v6}, Landroid/graphics/drawable/BitmapDrawable;->setFilterBitmap(Z)V

    .line 156
    return-object v0
.end method

.method private static resolveAlpha(Landroid/content/Context;I)F
    .locals 2

    .line 261
    filled-new-array {p1}, [I

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/content/Context;->obtainStyledAttributes([I)Landroid/content/res/TypedArray;

    move-result-object p0

    .line 263
    const/16 p1, 0xff

    const/4 v0, 0x0

    :try_start_0
    invoke-virtual {p0, v0, p1}, Landroid/content/res/TypedArray;->getInt(II)I

    move-result v1

    .line 264
    invoke-static {p1, v1}, Ljava/lang/Math;->min(II)I

    move-result p1

    invoke-static {v0, p1}, Ljava/lang/Math;->max(II)I

    move-result p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    int-to-float p1, p1

    const/high16 v0, 0x437f0000    # 255.0f

    div-float/2addr p1, v0

    .line 266
    invoke-virtual {p0}, Landroid/content/res/TypedArray;->recycle()V

    .line 264
    return p1

    .line 266
    :catchall_0
    move-exception p1

    invoke-virtual {p0}, Landroid/content/res/TypedArray;->recycle()V

    .line 267
    throw p1
.end method

.method private static resolveDrawable(Landroid/content/Context;I)Landroid/graphics/drawable/Drawable;
    .locals 1

    .line 271
    filled-new-array {p1}, [I

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/content/Context;->obtainStyledAttributes([I)Landroid/content/res/TypedArray;

    move-result-object p0

    .line 273
    const/4 p1, 0x0

    :try_start_0
    invoke-virtual {p0, p1}, Landroid/content/res/TypedArray;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 274
    if-eqz p1, :cond_0

    .line 275
    nop

    .line 277
    invoke-virtual {p0}, Landroid/content/res/TypedArray;->recycle()V

    .line 275
    return-object p1

    .line 274
    :cond_0
    :try_start_1
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string v0, "native action icon is missing"

    invoke-direct {p1, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 277
    :catchall_0
    move-exception p1

    invoke-virtual {p0}, Landroid/content/res/TypedArray;->recycle()V

    .line 278
    throw p1
.end method

.method public static syncClipboardDividers(Landroid/view/View;Landroid/view/View;Landroid/view/View;)V
    .locals 1

    .line 162
    const/4 v0, 0x1

    invoke-static {p0, p1, p2, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->syncClipboardDividers(Landroid/view/View;Landroid/view/View;Landroid/view/View;Z)V

    .line 163
    return-void
.end method

.method private static syncClipboardDividers(Landroid/view/View;Landroid/view/View;Landroid/view/View;Z)V
    .locals 4

    .line 167
    if-nez p0, :cond_0

    return-void

    .line 168
    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v0

    .line 169
    if-nez v0, :cond_1

    const/4 v0, 0x0

    goto :goto_0

    :cond_1
    const v1, 0x7f0f0149

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    .line 170
    :goto_0
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->findDivider(Landroid/view/View;)Landroid/view/View;

    move-result-object v0

    .line 171
    instance-of v1, v0, Landroid/widget/ImageView;

    if-nez v1, :cond_2

    return-void

    .line 172
    :cond_2
    check-cast v0, Landroid/widget/ImageView;

    .line 173
    invoke-virtual {v0}, Landroid/widget/ImageView;->getWidth()I

    move-result v1

    invoke-virtual {v0}, Landroid/widget/ImageView;->getPaddingLeft()I

    move-result v2

    sub-int/2addr v1, v2

    .line 174
    invoke-virtual {v0}, Landroid/widget/ImageView;->getPaddingRight()I

    move-result v2

    sub-int/2addr v1, v2

    .line 175
    invoke-virtual {v0}, Landroid/widget/ImageView;->getHeight()I

    move-result v2

    invoke-virtual {v0}, Landroid/widget/ImageView;->getPaddingTop()I

    move-result v3

    sub-int/2addr v2, v3

    .line 176
    invoke-virtual {v0}, Landroid/widget/ImageView;->getPaddingBottom()I

    move-result v3

    sub-int/2addr v2, v3

    .line 177
    if-eqz p3, :cond_6

    if-lez v1, :cond_3

    if-gtz v2, :cond_6

    .line 178
    :cond_3
    const/4 p3, 0x4

    if-eqz p1, :cond_4

    invoke-virtual {p1, p3}, Landroid/view/View;->setVisibility(I)V

    .line 179
    :cond_4
    if-eqz p2, :cond_5

    invoke-virtual {p2, p3}, Landroid/view/View;->setVisibility(I)V

    .line 180
    :cond_5
    invoke-virtual {p0}, Landroid/view/View;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object p3

    .line 181
    new-instance v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot$1;

    invoke-direct {v1, p0, v0, p1, p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot$1;-><init>(Landroid/view/View;Landroid/widget/ImageView;Landroid/view/View;Landroid/view/View;)V

    invoke-virtual {p3, v1}, Landroid/view/ViewTreeObserver;->addOnPreDrawListener(Landroid/view/ViewTreeObserver$OnPreDrawListener;)V

    .line 197
    invoke-virtual {p0}, Landroid/view/View;->invalidate()V

    .line 198
    return-void

    .line 200
    :cond_6
    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->syncDividerTarget(Landroid/widget/ImageView;Landroid/view/View;)V

    .line 201
    invoke-static {v0, p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->syncDividerTarget(Landroid/widget/ImageView;Landroid/view/View;)V

    .line 202
    return-void
.end method

.method private static syncDividerTarget(Landroid/widget/ImageView;Landroid/view/View;)V
    .locals 4

    .line 205
    instance-of v0, p1, Landroid/widget/ImageView;

    if-nez v0, :cond_0

    return-void

    .line 206
    :cond_0
    check-cast p1, Landroid/widget/ImageView;

    .line 207
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->freezeDrawable(Landroid/widget/ImageView;)Landroid/graphics/drawable/Drawable;

    move-result-object v0

    .line 208
    const/4 v1, 0x0

    invoke-virtual {p1, v1}, Landroid/widget/ImageView;->setImageTintList(Landroid/content/res/ColorStateList;)V

    .line 209
    invoke-virtual {p1}, Landroid/widget/ImageView;->clearColorFilter()V

    .line 210
    invoke-virtual {p1, v0}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 211
    invoke-virtual {p0}, Landroid/widget/ImageView;->getScaleType()Landroid/widget/ImageView$ScaleType;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    .line 212
    const/16 v0, 0xff

    invoke-virtual {p1, v0}, Landroid/widget/ImageView;->setImageAlpha(I)V

    .line 213
    invoke-virtual {p0}, Landroid/widget/ImageView;->getPaddingLeft()I

    move-result v0

    invoke-virtual {p0}, Landroid/widget/ImageView;->getPaddingTop()I

    move-result v1

    .line 214
    invoke-virtual {p0}, Landroid/widget/ImageView;->getPaddingRight()I

    move-result v2

    invoke-virtual {p0}, Landroid/widget/ImageView;->getPaddingBottom()I

    move-result v3

    .line 213
    invoke-virtual {p1, v0, v1, v2, v3}, Landroid/widget/ImageView;->setPadding(IIII)V

    .line 215
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->effectiveAncestorAlpha(Landroid/view/View;)F

    move-result v0

    .line 216
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->effectiveImageAlpha(Landroid/widget/ImageView;)F

    move-result p0

    .line 217
    const/4 v1, 0x0

    cmpg-float v2, v0, v1

    if-gtz v2, :cond_1

    goto :goto_0

    .line 218
    :cond_1
    const/high16 v2, 0x3f800000    # 1.0f

    div-float/2addr p0, v0

    invoke-static {v2, p0}, Ljava/lang/Math;->min(FF)F

    move-result p0

    invoke-static {v1, p0}, Ljava/lang/Math;->max(FF)F

    move-result p0

    .line 217
    :goto_0
    invoke-virtual {p1, p0}, Landroid/widget/ImageView;->setAlpha(F)V

    .line 219
    return-void
.end method


# virtual methods
.method public clear()V
    .locals 2

    .line 92
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->visualSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->clear()V

    .line 93
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->visualSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->getRoot()Landroid/view/View;

    move-result-object v0

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 94
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->visualSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->getRoot()Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/view/View;->setContentDescription(Ljava/lang/CharSequence;)V

    .line 95
    return-void
.end method

.method public getLeadingInset()I
    .locals 1

    .line 65
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->chrome:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->getLeadingInset()I

    move-result v0

    return v0
.end method

.method public getRailWidth()I
    .locals 1

    .line 64
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->chrome:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->getRailWidth()I

    move-result v0

    return v0
.end method

.method public getRoot()Landroid/view/View;
    .locals 1

    .line 63
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->visualSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->getRoot()Landroid/view/View;

    move-result-object v0

    return-object v0
.end method

.method public getTrailingInset()I
    .locals 1

    .line 66
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->chrome:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->getTrailingInset()I

    move-result v0

    return v0
.end method

.method public setEnabled(Z)V
    .locals 4

    .line 69
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->visualSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->getRoot()Landroid/view/View;

    move-result-object v0

    .line 70
    invoke-virtual {v0, p1}, Landroid/view/View;->setEnabled(Z)V

    .line 71
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->icon:Landroid/widget/ImageView;

    invoke-virtual {v1, p1}, Landroid/widget/ImageView;->setEnabled(Z)V

    .line 72
    invoke-virtual {v0, p1}, Landroid/view/View;->setClickable(Z)V

    .line 73
    invoke-virtual {v0, p1}, Landroid/view/View;->setFocusable(Z)V

    .line 74
    if-eqz p1, :cond_0

    .line 75
    const/4 v1, 0x1

    goto :goto_0

    .line 76
    :cond_0
    const/4 v1, 0x2

    .line 74
    :goto_0
    invoke-virtual {v0, v1}, Landroid/view/View;->setImportantForAccessibility(I)V

    .line 77
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->icon:Landroid/widget/ImageView;

    const/high16 v2, 0x3f800000    # 1.0f

    invoke-virtual {v1, v2}, Landroid/widget/ImageView;->setAlpha(F)V

    .line 78
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->icon:Landroid/widget/ImageView;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->chrome:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->getIconAlpha()F

    move-result v2

    const/high16 v3, 0x437f0000    # 255.0f

    mul-float v2, v2, v3

    invoke-static {v2}, Ljava/lang/Math;->round(F)I

    move-result v2

    invoke-virtual {v1, v2}, Landroid/widget/ImageView;->setImageAlpha(I)V

    .line 79
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->chrome:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;

    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->kind:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

    invoke-virtual {v1, v0, v2, p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->newActionIcon(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;Z)Landroid/graphics/drawable/Drawable;

    move-result-object p1

    .line 80
    if-eqz p1, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->visualSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->getCandidateLabelColors()Landroid/content/res/ColorStateList;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 81
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->visualSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->getCandidateLabelColors()Landroid/content/res/ColorStateList;

    move-result-object v0

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->icon:Landroid/widget/ImageView;

    .line 82
    invoke-virtual {v1}, Landroid/widget/ImageView;->getDrawableState()[I

    move-result-object v1

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->visualSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;

    .line 83
    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderVisualSlot;->getCandidateLabelColors()Landroid/content/res/ColorStateList;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/res/ColorStateList;->getDefaultColor()I

    move-result v2

    .line 81
    invoke-virtual {v0, v1, v2}, Landroid/content/res/ColorStateList;->getColorForState([II)I

    move-result v0

    .line 84
    invoke-static {v0}, Landroid/graphics/Color;->red(I)I

    move-result v1

    invoke-static {v0}, Landroid/graphics/Color;->green(I)I

    move-result v2

    .line 85
    invoke-static {v0}, Landroid/graphics/Color;->blue(I)I

    move-result v0

    .line 84
    invoke-static {v1, v2, v0}, Landroid/graphics/Color;->rgb(III)I

    move-result v0

    sget-object v1, Landroid/graphics/PorterDuff$Mode;->SRC_IN:Landroid/graphics/PorterDuff$Mode;

    invoke-virtual {p1, v0, v1}, Landroid/graphics/drawable/Drawable;->setColorFilter(ILandroid/graphics/PorterDuff$Mode;)V

    .line 87
    :cond_1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->icon:Landroid/widget/ImageView;

    invoke-virtual {v0, p1}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 88
    if-eqz p1, :cond_2

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->icon:Landroid/widget/ImageView;

    invoke-virtual {v0}, Landroid/widget/ImageView;->getDrawableState()[I

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/graphics/drawable/Drawable;->setState([I)Z

    .line 89
    :cond_2
    return-void
.end method
