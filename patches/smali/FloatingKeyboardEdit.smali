.class public final Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;
.super Landroid/view/View;
.source "FloatingKeyboardEdit.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;
    }
.end annotation


# static fields
.field private static final ACTION_DP:F = 36.0f

.field private static final CORNER_HIT_DP:F = 34.0f

.field private static final CORNER_LEN_DP:F = 13.0f

.field private static final CORNER_STROKE_DP:F = 3.5f

.field private static final DISC_HIT_DP:F = 26.0f

.field private static final MOVE_DP:F = 42.0f

.field private static final STROKE_DP:F = 2.0f

.field private static final ZONE_DP:F = 48.0f


# instance fields
.field private final accent:I

.field private final accentSoft:I

.field private active:I

.field private final density:F

.field private final doneIcon:Landroid/graphics/drawable/Drawable;

.field private final fill:Landroid/graphics/Paint;

.field private final glyph:Landroid/graphics/Paint;

.field private final line:Landroid/graphics/Paint;

.field private listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;

.field private final moveIcon:Landroid/graphics/drawable/Drawable;

.field private movePressed:Z

.field private final path:Landroid/graphics/Path;

.field private final rect:Landroid/graphics/RectF;

.field private final resetIcon:Landroid/graphics/drawable/Drawable;


# direct methods
.method public constructor <init>(Landroid/content/Context;I)V
    .locals 5

    .line 66
    invoke-direct {p0, p1}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 48
    new-instance v0, Landroid/graphics/Paint;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Landroid/graphics/Paint;-><init>(I)V

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    .line 49
    new-instance v0, Landroid/graphics/Paint;

    invoke-direct {v0, v1}, Landroid/graphics/Paint;-><init>(I)V

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    .line 50
    new-instance v0, Landroid/graphics/Paint;

    invoke-direct {v0, v1}, Landroid/graphics/Paint;-><init>(I)V

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->glyph:Landroid/graphics/Paint;

    .line 54
    new-instance v0, Landroid/graphics/Path;

    invoke-direct {v0}, Landroid/graphics/Path;-><init>()V

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    .line 55
    new-instance v0, Landroid/graphics/RectF;

    invoke-direct {v0}, Landroid/graphics/RectF;-><init>()V

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->rect:Landroid/graphics/RectF;

    .line 62
    const/4 v0, -0x1

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    .line 67
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v2

    iget v2, v2, Landroid/util/DisplayMetrics;->density:F

    iput v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    .line 68
    iput p2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->accent:I

    .line 69
    const v2, 0xffffff

    and-int/2addr v2, p2

    const/high16 v3, 0x21000000

    or-int/2addr v2, v3

    iput v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->accentSoft:I

    .line 71
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    sget-object v3, Landroid/graphics/Paint$Style;->STROKE:Landroid/graphics/Paint$Style;

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 72
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    iget v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    const/high16 v4, 0x40000000    # 2.0f

    mul-float v3, v3, v4

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setStrokeWidth(F)V

    .line 73
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    invoke-virtual {v2, p2}, Landroid/graphics/Paint;->setColor(I)V

    .line 75
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->glyph:Landroid/graphics/Paint;

    sget-object v3, Landroid/graphics/Paint$Style;->STROKE:Landroid/graphics/Paint$Style;

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 76
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->glyph:Landroid/graphics/Paint;

    iget v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v3, v3, v4

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setStrokeWidth(F)V

    .line 77
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->glyph:Landroid/graphics/Paint;

    sget-object v3, Landroid/graphics/Paint$Cap;->ROUND:Landroid/graphics/Paint$Cap;

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setStrokeCap(Landroid/graphics/Paint$Cap;)V

    .line 78
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->glyph:Landroid/graphics/Paint;

    sget-object v3, Landroid/graphics/Paint$Join;->ROUND:Landroid/graphics/Paint$Join;

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setStrokeJoin(Landroid/graphics/Paint$Join;)V

    .line 79
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->glyph:Landroid/graphics/Paint;

    invoke-virtual {v2, p2}, Landroid/graphics/Paint;->setColor(I)V

    .line 83
    const-string v2, "ic_floating_edit_reset"

    invoke-static {p1, v2, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->loadIcon(Landroid/content/Context;Ljava/lang/String;I)Landroid/graphics/drawable/Drawable;

    move-result-object v2

    iput-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->resetIcon:Landroid/graphics/drawable/Drawable;

    .line 84
    const-string v2, "ic_floating_edit_done"

    invoke-static {p1, v2, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->loadIcon(Landroid/content/Context;Ljava/lang/String;I)Landroid/graphics/drawable/Drawable;

    move-result-object p2

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->doneIcon:Landroid/graphics/drawable/Drawable;

    .line 85
    const-string p2, "ic_floating_edit_move"

    invoke-static {p1, p2, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->loadIcon(Landroid/content/Context;Ljava/lang/String;I)Landroid/graphics/drawable/Drawable;

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->moveIcon:Landroid/graphics/drawable/Drawable;

    .line 87
    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->setClickable(Z)V

    .line 88
    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->setFocusable(Z)V

    .line 89
    return-void
.end method

.method private cornerCenters()[[F
    .locals 9

    .line 142
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getWidth()I

    move-result v0

    int-to-float v0, v0

    .line 143
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getHeight()I

    move-result v1

    int-to-float v1, v1

    .line 144
    const/4 v2, 0x2

    new-array v3, v2, [F

    fill-array-data v3, :array_0

    new-array v4, v2, [F

    const/4 v5, 0x0

    aput v0, v4, v5

    const/4 v6, 0x1

    const/4 v7, 0x0

    aput v7, v4, v6

    new-array v8, v2, [F

    aput v0, v8, v5

    aput v1, v8, v6

    new-array v0, v2, [F

    aput v7, v0, v5

    aput v1, v0, v6

    const/4 v1, 0x4

    new-array v1, v1, [[F

    aput-object v3, v1, v5

    aput-object v4, v1, v6

    aput-object v8, v1, v2

    const/4 v2, 0x3

    aput-object v0, v1, v2

    return-object v1

    :array_0
    .array-data 4
        0x0
        0x0
    .end array-data
.end method

.method private static darken(I)I
    .locals 3

    .line 195
    shr-int/lit8 v0, p0, 0x10

    and-int/lit16 v0, v0, 0xff

    int-to-float v0, v0

    const v1, 0x3f51eb85    # 0.82f

    mul-float v0, v0, v1

    float-to-int v0, v0

    .line 196
    shr-int/lit8 v2, p0, 0x8

    and-int/lit16 v2, v2, 0xff

    int-to-float v2, v2

    mul-float v2, v2, v1

    float-to-int v2, v2

    .line 197
    and-int/lit16 p0, p0, 0xff

    int-to-float p0, p0

    mul-float p0, p0, v1

    float-to-int p0, p0

    .line 198
    const/high16 v1, -0x1000000

    shl-int/lit8 v0, v0, 0x10

    or-int/2addr v0, v1

    shl-int/lit8 v1, v2, 0x8

    or-int/2addr v0, v1

    or-int/2addr p0, v0

    return p0
.end method

.method private static distance(FFFF)F
    .locals 0

    .line 292
    sub-float/2addr p0, p2

    .line 293
    sub-float/2addr p1, p3

    .line 294
    mul-float p0, p0, p0

    mul-float p1, p1, p1

    add-float/2addr p0, p1

    float-to-double p0, p0

    invoke-static {p0, p1}, Ljava/lang/Math;->sqrt(D)D

    move-result-wide p0

    double-to-float p0, p0

    return p0
.end method

.method private drawCorners(Landroid/graphics/Canvas;)V
    .locals 10

    .line 148
    const/high16 v0, 0x41500000    # 13.0f

    iget v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v3, v1, v0

    .line 149
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getWidth()I

    move-result v0

    int-to-float v0, v0

    .line 150
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getHeight()I

    move-result v1

    int-to-float v1, v1

    .line 151
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    const/high16 v4, 0x40600000    # 3.5f

    iget v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v5, v5, v4

    invoke-virtual {v2, v5}, Landroid/graphics/Paint;->setStrokeWidth(F)V

    .line 152
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    sget-object v4, Landroid/graphics/Paint$Cap;->BUTT:Landroid/graphics/Paint$Cap;

    invoke-virtual {v2, v4}, Landroid/graphics/Paint;->setStrokeCap(Landroid/graphics/Paint$Cap;)V

    .line 154
    const/4 v6, 0x0

    iget-object v7, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    move v4, v3

    const/4 v3, 0x0

    const/4 v5, 0x0

    move-object v2, p1

    invoke-virtual/range {v2 .. v7}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 155
    iget-object v7, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    move v5, v4

    const/4 v4, 0x0

    invoke-virtual/range {v2 .. v7}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 157
    move v3, v5

    sub-float v5, v0, v3

    const/4 v8, 0x0

    iget-object v9, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    move v7, v0

    move-object v4, v2

    invoke-virtual/range {v4 .. v9}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 158
    move v0, v5

    move v5, v7

    const/4 v4, 0x0

    iget-object v7, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    move v6, v3

    move v3, v5

    invoke-virtual/range {v2 .. v7}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 160
    move v3, v6

    sub-float v6, v1, v3

    iget-object v9, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    move v7, v5

    move v8, v1

    move-object v4, v2

    invoke-virtual/range {v4 .. v9}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 161
    move v1, v6

    move v6, v8

    iget-object v9, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    move v7, v0

    invoke-virtual/range {v4 .. v9}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 163
    const/4 v5, 0x0

    iget-object v7, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    move v4, v6

    invoke-virtual/range {v2 .. v7}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 164
    const/4 v7, 0x0

    iget-object v9, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    move v8, v1

    move-object v4, v2

    invoke-virtual/range {v4 .. v9}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 165
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    const/high16 v0, 0x40000000    # 2.0f

    iget v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v1, v1, v0

    invoke-virtual {p1, v1}, Landroid/graphics/Paint;->setStrokeWidth(F)V

    .line 166
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    sget-object v0, Landroid/graphics/Paint$Cap;->ROUND:Landroid/graphics/Paint$Cap;

    invoke-virtual {p1, v0}, Landroid/graphics/Paint;->setStrokeCap(Landroid/graphics/Paint$Cap;)V

    .line 167
    return-void
.end method

.method private drawIcon(Landroid/graphics/Canvas;Landroid/graphics/drawable/Drawable;FFF)V
    .locals 2

    .line 171
    if-nez p2, :cond_0

    return-void

    .line 172
    :cond_0
    const/high16 v0, 0x40000000    # 2.0f

    div-float/2addr p5, v0

    invoke-static {p5}, Ljava/lang/Math;->round(F)I

    move-result p5

    const/4 v0, 0x1

    invoke-static {v0, p5}, Ljava/lang/Math;->max(II)I

    move-result p5

    .line 173
    invoke-static {p3}, Ljava/lang/Math;->round(F)I

    move-result p3

    .line 174
    invoke-static {p4}, Ljava/lang/Math;->round(F)I

    move-result p4

    .line 175
    sub-int v0, p3, p5

    sub-int v1, p4, p5

    add-int/2addr p3, p5

    add-int/2addr p4, p5

    invoke-virtual {p2, v0, v1, p3, p4}, Landroid/graphics/drawable/Drawable;->setBounds(IIII)V

    .line 176
    invoke-virtual {p2, p1}, Landroid/graphics/drawable/Drawable;->draw(Landroid/graphics/Canvas;)V

    .line 177
    return-void
.end method

.method private static loadIcon(Landroid/content/Context;Ljava/lang/String;I)Landroid/graphics/drawable/Drawable;
    .locals 4

    .line 182
    const/4 v0, 0x0

    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    const-string v2, "drawable"

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, p1, v2, v3}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result p1

    .line 183
    if-nez p1, :cond_0

    return-object v0

    .line 184
    :cond_0
    invoke-virtual {p0, p1}, Landroid/content/Context;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object p0

    .line 185
    if-nez p0, :cond_1

    return-object v0

    .line 186
    :cond_1
    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->mutate()Landroid/graphics/drawable/Drawable;

    move-result-object p0

    .line 187
    invoke-virtual {p0, p2}, Landroid/graphics/drawable/Drawable;->setTint(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 188
    return-object p0

    .line 189
    :catchall_0
    move-exception p0

    .line 190
    return-object v0
.end method

.method private regionAt(FF)I
    .locals 12

    .line 254
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getWidth()I

    move-result v0

    int-to-float v0, v0

    .line 255
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getHeight()I

    move-result v1

    int-to-float v1, v1

    .line 256
    const/high16 v2, 0x42080000    # 34.0f

    iget v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v3, v3, v2

    .line 257
    const/4 v2, 0x2

    new-array v4, v2, [F

    fill-array-data v4, :array_0

    new-array v5, v2, [F

    const/4 v6, 0x0

    aput v0, v5, v6

    const/4 v7, 0x1

    const/4 v8, 0x0

    aput v8, v5, v7

    new-array v9, v2, [F

    aput v0, v9, v6

    aput v1, v9, v7

    new-array v10, v2, [F

    aput v8, v10, v6

    aput v1, v10, v7

    const/4 v8, 0x4

    new-array v11, v8, [[F

    aput-object v4, v11, v6

    aput-object v5, v11, v7

    aput-object v9, v11, v2

    const/4 v2, 0x3

    aput-object v10, v11, v2

    .line 258
    const/4 v2, 0x0

    :goto_0
    if-ge v2, v8, :cond_1

    .line 259
    aget-object v4, v11, v2

    aget v4, v4, v6

    sub-float v4, p1, v4

    invoke-static {v4}, Ljava/lang/Math;->abs(F)F

    move-result v4

    cmpg-float v4, v4, v3

    if-gtz v4, :cond_0

    aget-object v4, v11, v2

    aget v4, v4, v7

    sub-float v4, p2, v4

    invoke-static {v4}, Ljava/lang/Math;->abs(F)F

    move-result v4

    cmpg-float v4, v4, v3

    if-gtz v4, :cond_0

    .line 260
    return v2

    .line 258
    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 263
    :cond_1
    const/high16 v2, 0x40000000    # 2.0f

    div-float/2addr v0, v2

    .line 264
    div-float/2addr v1, v2

    .line 265
    const/high16 v3, 0x41d00000    # 26.0f

    iget v4, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v4, v4, v3

    .line 266
    invoke-static {p1, p2, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->distance(FFFF)F

    move-result v3

    cmpg-float v3, v3, v4

    if-gtz v3, :cond_2

    return v8

    .line 268
    :cond_2
    const/high16 v3, 0x42280000    # 42.0f

    iget v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v5, v5, v3

    div-float/2addr v5, v2

    .line 269
    const/high16 v3, 0x41a00000    # 20.0f

    iget v6, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v6, v6, v3

    add-float/2addr v5, v6

    const/high16 v3, 0x42100000    # 36.0f

    iget v6, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v6, v6, v3

    div-float/2addr v6, v2

    add-float/2addr v5, v6

    .line 270
    sub-float v2, v0, v5

    iget v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    const/high16 v6, 0x40c00000    # 6.0f

    mul-float v3, v3, v6

    add-float/2addr v3, v1

    invoke-static {p1, p2, v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->distance(FFFF)F

    move-result v2

    cmpg-float v2, v2, v4

    if-gtz v2, :cond_3

    const/4 p1, 0x5

    return p1

    .line 271
    :cond_3
    add-float/2addr v0, v5

    iget v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v2, v2, v6

    add-float/2addr v1, v2

    invoke-static {p1, p2, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->distance(FFFF)F

    move-result p1

    cmpg-float p1, p1, v4

    if-gtz p1, :cond_4

    const/4 p1, 0x6

    return p1

    .line 274
    :cond_4
    return v8

    nop

    :array_0
    .array-data 4
        0x0
        0x0
    .end array-data
.end method

.method private reportDrag([FZ)V
    .locals 3

    .line 284
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;

    const/4 v1, 0x0

    aget v1, p1, v1

    const/4 v2, 0x1

    aget p1, p1, v2

    invoke-interface {v0, v1, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;->onEditDrag(FFZ)V

    .line 285
    :cond_0
    return-void
.end method

.method private reportScale(I[FZ)V
    .locals 3

    .line 288
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;

    const/4 v1, 0x0

    aget v1, p2, v1

    const/4 v2, 0x1

    aget p2, p2, v2

    invoke-interface {v0, p1, v1, p2, p3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;->onEditScale(IFFZ)V

    .line 289
    :cond_0
    return-void
.end method

.method private screenOf(Landroid/view/MotionEvent;)[F
    .locals 5

    .line 278
    const/4 v0, 0x2

    new-array v1, v0, [I

    .line 279
    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getLocationOnScreen([I)V

    .line 280
    const/4 v2, 0x0

    aget v3, v1, v2

    int-to-float v3, v3

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F

    move-result v4

    add-float/2addr v3, v4

    const/4 v4, 0x1

    aget v1, v1, v4

    int-to-float v1, v1

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    move-result p1

    add-float/2addr v1, p1

    new-array p1, v0, [F

    aput v3, p1, v2

    aput v1, p1, v4

    return-object p1
.end method


# virtual methods
.method protected onDraw(Landroid/graphics/Canvas;)V
    .locals 13

    .line 99
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getWidth()I

    move-result v2

    int-to-float v2, v2

    .line 100
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getHeight()I

    move-result v3

    int-to-float v3, v3

    .line 101
    const/4 v4, 0x0

    cmpg-float v5, v2, v4

    if-lez v5, :cond_3

    cmpg-float v5, v3, v4

    if-gtz v5, :cond_0

    goto/16 :goto_2

    .line 104
    :cond_0
    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    sget-object v6, Landroid/graphics/Paint$Style;->FILL:Landroid/graphics/Paint$Style;

    invoke-virtual {v5, v6}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 105
    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    const v6, 0x73ffffff

    invoke-virtual {v5, v6}, Landroid/graphics/Paint;->setColor(I)V

    .line 106
    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->rect:Landroid/graphics/RectF;

    invoke-virtual {v5, v4, v4, v2, v3}, Landroid/graphics/RectF;->set(FFFF)V

    .line 107
    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->rect:Landroid/graphics/RectF;

    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    invoke-virtual {p1, v4, v5}, Landroid/graphics/Canvas;->drawRect(Landroid/graphics/RectF;Landroid/graphics/Paint;)V

    .line 110
    const/high16 v4, 0x42400000    # 48.0f

    iget v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v5, v5, v4

    .line 111
    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    iget v6, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->accentSoft:I

    invoke-virtual {v4, v6}, Landroid/graphics/Paint;->setColor(I)V

    .line 112
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->cornerCenters()[[F

    move-result-object v4

    array-length v6, v4

    const/4 v7, 0x0

    const/4 v8, 0x0

    :goto_0
    const/high16 v9, 0x40000000    # 2.0f

    if-ge v8, v6, :cond_1

    aget-object v10, v4, v8

    .line 113
    aget v11, v10, v7

    const/4 v12, 0x1

    aget v10, v10, v12

    div-float v9, v5, v9

    iget-object v12, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    invoke-virtual {p1, v11, v10, v9, v12}, Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V

    .line 112
    add-int/lit8 v8, v8, 0x1

    goto :goto_0

    .line 117
    :cond_1
    iget v4, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v4, v4, v9

    div-float/2addr v4, v9

    .line 118
    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->rect:Landroid/graphics/RectF;

    sub-float v6, v2, v4

    sub-float v7, v3, v4

    invoke-virtual {v5, v4, v4, v6, v7}, Landroid/graphics/RectF;->set(FFFF)V

    .line 119
    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->rect:Landroid/graphics/RectF;

    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    invoke-virtual {p1, v4, v5}, Landroid/graphics/Canvas;->drawRect(Landroid/graphics/RectF;Landroid/graphics/Paint;)V

    .line 121
    invoke-direct/range {p0 .. p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->drawCorners(Landroid/graphics/Canvas;)V

    .line 124
    div-float/2addr v2, v9

    .line 125
    div-float v4, v3, v9

    .line 126
    const/high16 v3, 0x42280000    # 42.0f

    iget v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v5, v5, v3

    div-float v6, v5, v9

    .line 127
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    iget-boolean v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->movePressed:Z

    if-eqz v5, :cond_2

    iget v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->accent:I

    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->darken(I)I

    move-result v5

    goto :goto_1

    :cond_2
    iget v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->accent:I

    :goto_1
    invoke-virtual {v3, v5}, Landroid/graphics/Paint;->setColor(I)V

    .line 128
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    invoke-virtual {p1, v2, v4, v6, v3}, Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V

    .line 129
    move v3, v2

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->moveIcon:Landroid/graphics/drawable/Drawable;

    const v7, 0x3fa66666    # 1.3f

    mul-float v5, v6, v7

    move-object v0, p0

    move-object v1, p1

    invoke-direct/range {v0 .. v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->drawIcon(Landroid/graphics/Canvas;Landroid/graphics/drawable/Drawable;FFF)V

    .line 132
    move v8, v4

    const/high16 v2, 0x42100000    # 36.0f

    iget v4, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v4, v4, v2

    div-float/2addr v4, v9

    .line 133
    const/high16 v2, 0x41a00000    # 20.0f

    iget v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v5, v5, v2

    add-float/2addr v6, v5

    add-float/2addr v6, v4

    .line 134
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    iget v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->accentSoft:I

    invoke-virtual {v2, v5}, Landroid/graphics/Paint;->setColor(I)V

    .line 135
    sub-float v2, v3, v6

    iget v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    const/high16 v9, 0x40c00000    # 6.0f

    mul-float v5, v5, v9

    add-float/2addr v5, v8

    iget-object v10, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    invoke-virtual {p1, v2, v5, v4, v10}, Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V

    .line 136
    add-float/2addr v6, v3

    iget v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v3, v3, v9

    add-float/2addr v3, v8

    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    invoke-virtual {p1, v6, v3, v4, v5}, Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V

    .line 137
    move v3, v2

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->resetIcon:Landroid/graphics/drawable/Drawable;

    iget v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v5, v5, v9

    add-float/2addr v5, v8

    mul-float v4, v4, v7

    move v0, v5

    move v5, v4

    move v4, v0

    move-object v0, p0

    invoke-direct/range {v0 .. v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->drawIcon(Landroid/graphics/Canvas;Landroid/graphics/drawable/Drawable;FFF)V

    .line 138
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->doneIcon:Landroid/graphics/drawable/Drawable;

    iget v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v1, v1, v9

    add-float v4, v8, v1

    move-object v1, p1

    move v3, v6

    invoke-direct/range {v0 .. v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->drawIcon(Landroid/graphics/Canvas;Landroid/graphics/drawable/Drawable;FFF)V

    .line 139
    return-void

    .line 101
    :cond_3
    :goto_2
    return-void
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 6

    .line 205
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    const/4 v1, 0x3

    const/4 v2, 0x4

    const/4 v3, 0x0

    const/4 v4, 0x1

    packed-switch v0, :pswitch_data_0

    .line 248
    return v4

    .line 220
    :pswitch_0
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    if-gez v0, :cond_0

    return v4

    .line 221
    :cond_0
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->screenOf(Landroid/view/MotionEvent;)[F

    move-result-object p1

    .line 222
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    if-gt v0, v1, :cond_1

    .line 223
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    invoke-direct {p0, v0, p1, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->reportScale(I[FZ)V

    goto :goto_0

    .line 224
    :cond_1
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    if-ne v0, v2, :cond_2

    .line 225
    invoke-direct {p0, p1, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->reportDrag([FZ)V

    .line 227
    :cond_2
    :goto_0
    return v4

    .line 231
    :pswitch_1
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    .line 232
    const/4 v5, -0x1

    iput v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    .line 233
    iput-boolean v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->movePressed:Z

    .line 234
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->invalidate()V

    .line 235
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->screenOf(Landroid/view/MotionEvent;)[F

    move-result-object p1

    .line 236
    if-ltz v0, :cond_3

    if-gt v0, v1, :cond_3

    .line 237
    invoke-direct {p0, v0, p1, v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->reportScale(I[FZ)V

    goto :goto_1

    .line 238
    :cond_3
    if-ne v0, v2, :cond_4

    .line 239
    invoke-direct {p0, p1, v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->reportDrag([FZ)V

    goto :goto_1

    .line 240
    :cond_4
    const/4 p1, 0x5

    if-ne v0, p1, :cond_5

    .line 241
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;

    if-eqz p1, :cond_6

    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;

    invoke-interface {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;->onEditReset()V

    goto :goto_1

    .line 242
    :cond_5
    const/4 p1, 0x6

    if-ne v0, p1, :cond_6

    .line 243
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;

    if-eqz p1, :cond_6

    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;

    invoke-interface {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;->onEditDone()V

    .line 245
    :cond_6
    :goto_1
    return v4

    .line 207
    :pswitch_2
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F

    move-result v0

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    move-result v5

    invoke-direct {p0, v0, v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->regionAt(FF)I

    move-result v0

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    .line 208
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    if-ne v0, v2, :cond_7

    iput-boolean v4, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->movePressed:Z

    .line 209
    :cond_7
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    if-eqz v0, :cond_8

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    invoke-interface {v0, v4}, Landroid/view/ViewParent;->requestDisallowInterceptTouchEvent(Z)V

    .line 210
    :cond_8
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->screenOf(Landroid/view/MotionEvent;)[F

    move-result-object p1

    .line 211
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    if-ltz v0, :cond_9

    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    if-gt v0, v1, :cond_9

    .line 212
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    invoke-direct {p0, v0, p1, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->reportScale(I[FZ)V

    goto :goto_2

    .line 213
    :cond_9
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    if-ne v0, v2, :cond_a

    .line 214
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->invalidate()V

    .line 215
    invoke-direct {p0, p1, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->reportDrag([FZ)V

    .line 217
    :cond_a
    :goto_2
    return v4

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_2
        :pswitch_1
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method

.method setListener(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;)V
    .locals 0

    .line 92
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;

    .line 93
    return-void
.end method
