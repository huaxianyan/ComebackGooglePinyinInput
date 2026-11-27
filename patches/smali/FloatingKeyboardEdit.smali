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

.field private static final RESET_ICON:I = 0x7f020182

.field private static final STROKE_DP:F = 2.0f

.field private static final ZONE_DP:F = 48.0f


# instance fields
.field private final accent:I

.field private final accentSoft:I

.field private active:I

.field private final density:F

.field private final fill:Landroid/graphics/Paint;

.field private final glyph:Landroid/graphics/Paint;

.field private final line:Landroid/graphics/Paint;

.field private listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;

.field private movePressed:Z

.field private final path:Landroid/graphics/Path;

.field private final rect:Landroid/graphics/RectF;

.field private final resetIcon:Landroid/graphics/drawable/Drawable;


# direct methods
.method public constructor <init>(Landroid/content/Context;I)V
    .locals 3

    .line 68
    invoke-direct {p0, p1}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 51
    new-instance v0, Landroid/graphics/Paint;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Landroid/graphics/Paint;-><init>(I)V

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    .line 52
    new-instance v0, Landroid/graphics/Paint;

    invoke-direct {v0, v1}, Landroid/graphics/Paint;-><init>(I)V

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    .line 53
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

    .line 64
    const/4 v0, -0x1

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    .line 69
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    iget v0, v0, Landroid/util/DisplayMetrics;->density:F

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    .line 70
    iput p2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->accent:I

    .line 71
    const v0, 0xffffff

    and-int/2addr v0, p2

    const/high16 v2, 0x21000000

    or-int/2addr v0, v2

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->accentSoft:I

    .line 72
    const v0, 0x7f020182

    invoke-static {p1, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->stockIcon(Landroid/content/Context;I)Landroid/graphics/drawable/Drawable;

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->resetIcon:Landroid/graphics/drawable/Drawable;

    .line 73
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->resetIcon:Landroid/graphics/drawable/Drawable;

    if-eqz p1, :cond_0

    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->resetIcon:Landroid/graphics/drawable/Drawable;

    invoke-virtual {p1, p2}, Landroid/graphics/drawable/Drawable;->setTint(I)V

    .line 75
    :cond_0
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    sget-object v0, Landroid/graphics/Paint$Style;->STROKE:Landroid/graphics/Paint$Style;

    invoke-virtual {p1, v0}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 76
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    const/high16 v2, 0x40000000    # 2.0f

    mul-float v0, v0, v2

    invoke-virtual {p1, v0}, Landroid/graphics/Paint;->setStrokeWidth(F)V

    .line 77
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    invoke-virtual {p1, p2}, Landroid/graphics/Paint;->setColor(I)V

    .line 79
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->glyph:Landroid/graphics/Paint;

    sget-object v0, Landroid/graphics/Paint$Style;->STROKE:Landroid/graphics/Paint$Style;

    invoke-virtual {p1, v0}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 80
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->glyph:Landroid/graphics/Paint;

    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v0, v0, v2

    invoke-virtual {p1, v0}, Landroid/graphics/Paint;->setStrokeWidth(F)V

    .line 81
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->glyph:Landroid/graphics/Paint;

    sget-object v0, Landroid/graphics/Paint$Cap;->ROUND:Landroid/graphics/Paint$Cap;

    invoke-virtual {p1, v0}, Landroid/graphics/Paint;->setStrokeCap(Landroid/graphics/Paint$Cap;)V

    .line 82
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->glyph:Landroid/graphics/Paint;

    sget-object v0, Landroid/graphics/Paint$Join;->ROUND:Landroid/graphics/Paint$Join;

    invoke-virtual {p1, v0}, Landroid/graphics/Paint;->setStrokeJoin(Landroid/graphics/Paint$Join;)V

    .line 83
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->glyph:Landroid/graphics/Paint;

    invoke-virtual {p1, p2}, Landroid/graphics/Paint;->setColor(I)V

    .line 85
    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->setClickable(Z)V

    .line 86
    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->setFocusable(Z)V

    .line 87
    return-void
.end method

.method private cornerCenters()[[F
    .locals 9

    .line 140
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getWidth()I

    move-result v0

    int-to-float v0, v0

    .line 141
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getHeight()I

    move-result v1

    int-to-float v1, v1

    .line 142
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

    .line 265
    shr-int/lit8 v0, p0, 0x10

    and-int/lit16 v0, v0, 0xff

    int-to-float v0, v0

    const v1, 0x3f51eb85    # 0.82f

    mul-float v0, v0, v1

    float-to-int v0, v0

    .line 266
    shr-int/lit8 v2, p0, 0x8

    and-int/lit16 v2, v2, 0xff

    int-to-float v2, v2

    mul-float v2, v2, v1

    float-to-int v2, v2

    .line 267
    and-int/lit16 p0, p0, 0xff

    int-to-float p0, p0

    mul-float p0, p0, v1

    float-to-int p0, p0

    .line 268
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

    .line 362
    sub-float/2addr p0, p2

    .line 363
    sub-float/2addr p1, p3

    .line 364
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

    .line 146
    const/high16 v0, 0x41500000    # 13.0f

    iget v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v3, v1, v0

    .line 147
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getWidth()I

    move-result v0

    int-to-float v0, v0

    .line 148
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getHeight()I

    move-result v1

    int-to-float v1, v1

    .line 149
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    const/high16 v4, 0x40600000    # 3.5f

    iget v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v5, v5, v4

    invoke-virtual {v2, v5}, Landroid/graphics/Paint;->setStrokeWidth(F)V

    .line 150
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    sget-object v4, Landroid/graphics/Paint$Cap;->BUTT:Landroid/graphics/Paint$Cap;

    invoke-virtual {v2, v4}, Landroid/graphics/Paint;->setStrokeCap(Landroid/graphics/Paint$Cap;)V

    .line 152
    const/4 v6, 0x0

    iget-object v7, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    move v4, v3

    const/4 v3, 0x0

    const/4 v5, 0x0

    move-object v2, p1

    invoke-virtual/range {v2 .. v7}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 153
    iget-object v7, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    move v5, v4

    const/4 v4, 0x0

    invoke-virtual/range {v2 .. v7}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 155
    move v3, v5

    sub-float v5, v0, v3

    const/4 v8, 0x0

    iget-object v9, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    move v7, v0

    move-object v4, v2

    invoke-virtual/range {v4 .. v9}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 156
    move v0, v5

    move v5, v7

    const/4 v4, 0x0

    iget-object v7, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    move v6, v3

    move v3, v5

    invoke-virtual/range {v2 .. v7}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 158
    move v3, v6

    sub-float v6, v1, v3

    iget-object v9, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    move v7, v5

    move v8, v1

    move-object v4, v2

    invoke-virtual/range {v4 .. v9}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 159
    move v1, v6

    move v6, v8

    iget-object v9, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    move v7, v0

    invoke-virtual/range {v4 .. v9}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 161
    const/4 v5, 0x0

    iget-object v7, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    move v4, v6

    invoke-virtual/range {v2 .. v7}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 162
    const/4 v7, 0x0

    iget-object v9, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    move v8, v1

    move-object v4, v2

    invoke-virtual/range {v4 .. v9}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 163
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    const/high16 v0, 0x40000000    # 2.0f

    iget v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v1, v1, v0

    invoke-virtual {p1, v1}, Landroid/graphics/Paint;->setStrokeWidth(F)V

    .line 164
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    sget-object v0, Landroid/graphics/Paint$Cap;->ROUND:Landroid/graphics/Paint$Cap;

    invoke-virtual {p1, v0}, Landroid/graphics/Paint;->setStrokeCap(Landroid/graphics/Paint$Cap;)V

    .line 165
    return-void
.end method

.method private drawDone(Landroid/graphics/Canvas;FFF)V
    .locals 4

    .line 253
    const v0, 0x3eeb851f    # 0.46f

    mul-float p4, p4, v0

    .line 254
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    invoke-virtual {v0}, Landroid/graphics/Path;->reset()V

    .line 255
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    const v1, 0x3f666666    # 0.9f

    mul-float v1, v1, p4

    sub-float v1, p2, v1

    const v2, 0x3d4ccccd    # 0.05f

    mul-float v2, v2, p4

    add-float/2addr v2, p3

    invoke-virtual {v0, v1, v2}, Landroid/graphics/Path;->moveTo(FF)V

    .line 256
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    const v1, 0x3e4ccccd    # 0.2f

    mul-float v1, v1, p4

    sub-float v1, p2, v1

    const v2, 0x3f333333    # 0.7f

    mul-float v2, v2, p4

    add-float v3, p3, v2

    invoke-virtual {v0, v1, v3}, Landroid/graphics/Path;->lineTo(FF)V

    .line 257
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    add-float/2addr p2, p4

    sub-float/2addr p3, v2

    invoke-virtual {v0, p2, p3}, Landroid/graphics/Path;->lineTo(FF)V

    .line 258
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->glyph:Landroid/graphics/Paint;

    iget p3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->accent:I

    invoke-virtual {p2, p3}, Landroid/graphics/Paint;->setColor(I)V

    .line 259
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->glyph:Landroid/graphics/Paint;

    const p3, 0x4019999a    # 2.4f

    iget p4, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float p4, p4, p3

    invoke-virtual {p2, p4}, Landroid/graphics/Paint;->setStrokeWidth(F)V

    .line 260
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    iget-object p3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->glyph:Landroid/graphics/Paint;

    invoke-virtual {p1, p2, p3}, Landroid/graphics/Canvas;->drawPath(Landroid/graphics/Path;Landroid/graphics/Paint;)V

    .line 261
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->glyph:Landroid/graphics/Paint;

    const/high16 p2, 0x40000000    # 2.0f

    iget p3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float p3, p3, p2

    invoke-virtual {p1, p3}, Landroid/graphics/Paint;->setStrokeWidth(F)V

    .line 262
    return-void
.end method

.method private drawMoveArrow(Landroid/graphics/Canvas;FFF)V
    .locals 7

    .line 168
    const v0, 0x3f051eb8    # 0.52f

    mul-float v0, v0, p4

    .line 169
    const v1, 0x3e4ccccd    # 0.2f

    mul-float v1, v1, p4

    .line 170
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->glyph:Landroid/graphics/Paint;

    const/4 v3, -0x1

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setColor(I)V

    .line 171
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->glyph:Landroid/graphics/Paint;

    const/high16 v4, 0x40000000    # 2.0f

    iget v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v5, v5, v4

    invoke-virtual {v2, v5}, Landroid/graphics/Paint;->setStrokeWidth(F)V

    .line 172
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    invoke-virtual {v2}, Landroid/graphics/Path;->reset()V

    .line 173
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    sub-float v4, p3, v0

    invoke-virtual {v2, p2, v4}, Landroid/graphics/Path;->moveTo(FF)V

    .line 174
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    add-float v4, p3, v0

    invoke-virtual {v2, p2, v4}, Landroid/graphics/Path;->lineTo(FF)V

    .line 175
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    sub-float v4, p2, v0

    invoke-virtual {v2, v4, p3}, Landroid/graphics/Path;->moveTo(FF)V

    .line 176
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    add-float/2addr v0, p2

    invoke-virtual {v2, v0, p3}, Landroid/graphics/Path;->lineTo(FF)V

    .line 177
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->glyph:Landroid/graphics/Paint;

    invoke-virtual {p1, v0, v2}, Landroid/graphics/Canvas;->drawPath(Landroid/graphics/Path;Landroid/graphics/Paint;)V

    .line 180
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    invoke-virtual {v0, v3}, Landroid/graphics/Paint;->setColor(I)V

    .line 181
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    sget-object v2, Landroid/graphics/Paint$Style;->FILL:Landroid/graphics/Paint$Style;

    invoke-virtual {v0, v2}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 182
    const v0, 0x3f28f5c3    # 0.66f

    mul-float p4, p4, v0

    sub-float v0, p3, p4

    .line 183
    add-float v2, p2, p4

    .line 184
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    invoke-virtual {v3}, Landroid/graphics/Path;->reset()V

    .line 185
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    invoke-virtual {v3, p2, v0}, Landroid/graphics/Path;->moveTo(FF)V

    .line 186
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    sub-float v4, p2, v1

    const/high16 v5, 0x3fc00000    # 1.5f

    mul-float v5, v5, v1

    add-float/2addr v0, v5

    invoke-virtual {v3, v4, v0}, Landroid/graphics/Path;->lineTo(FF)V

    .line 187
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    add-float v6, p2, v1

    invoke-virtual {v3, v6, v0}, Landroid/graphics/Path;->lineTo(FF)V

    .line 188
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    invoke-virtual {v0}, Landroid/graphics/Path;->close()V

    .line 189
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    invoke-virtual {p1, v0, v3}, Landroid/graphics/Canvas;->drawPath(Landroid/graphics/Path;Landroid/graphics/Paint;)V

    .line 191
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    invoke-virtual {v0}, Landroid/graphics/Path;->reset()V

    .line 192
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    add-float v3, p3, p4

    invoke-virtual {v0, p2, v3}, Landroid/graphics/Path;->moveTo(FF)V

    .line 193
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    sub-float/2addr v3, v5

    invoke-virtual {v0, v4, v3}, Landroid/graphics/Path;->lineTo(FF)V

    .line 194
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    invoke-virtual {v0, v6, v3}, Landroid/graphics/Path;->lineTo(FF)V

    .line 195
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    invoke-virtual {v0}, Landroid/graphics/Path;->close()V

    .line 196
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    invoke-virtual {p1, v0, v3}, Landroid/graphics/Canvas;->drawPath(Landroid/graphics/Path;Landroid/graphics/Paint;)V

    .line 198
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    invoke-virtual {v0}, Landroid/graphics/Path;->reset()V

    .line 199
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    invoke-virtual {v0, v2, p3}, Landroid/graphics/Path;->moveTo(FF)V

    .line 200
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    sub-float/2addr v2, v5

    sub-float v3, p3, v1

    invoke-virtual {v0, v2, v3}, Landroid/graphics/Path;->lineTo(FF)V

    .line 201
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    add-float/2addr v1, p3

    invoke-virtual {v0, v2, v1}, Landroid/graphics/Path;->lineTo(FF)V

    .line 202
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    invoke-virtual {v0}, Landroid/graphics/Path;->close()V

    .line 203
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    invoke-virtual {p1, v0, v2}, Landroid/graphics/Canvas;->drawPath(Landroid/graphics/Path;Landroid/graphics/Paint;)V

    .line 205
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    invoke-virtual {v0}, Landroid/graphics/Path;->reset()V

    .line 206
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    sub-float/2addr p2, p4

    invoke-virtual {v0, p2, p3}, Landroid/graphics/Path;->moveTo(FF)V

    .line 207
    iget-object p3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    add-float/2addr p2, v5

    invoke-virtual {p3, p2, v3}, Landroid/graphics/Path;->lineTo(FF)V

    .line 208
    iget-object p3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    invoke-virtual {p3, p2, v1}, Landroid/graphics/Path;->lineTo(FF)V

    .line 209
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    invoke-virtual {p2}, Landroid/graphics/Path;->close()V

    .line 210
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    iget-object p3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    invoke-virtual {p1, p2, p3}, Landroid/graphics/Canvas;->drawPath(Landroid/graphics/Path;Landroid/graphics/Paint;)V

    .line 211
    return-void
.end method

.method private drawReset(Landroid/graphics/Canvas;FFF)V
    .locals 5

    .line 230
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->resetIcon:Landroid/graphics/drawable/Drawable;

    if-eqz v0, :cond_0

    .line 231
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->resetIcon:Landroid/graphics/drawable/Drawable;

    sub-float v1, p2, p4

    invoke-static {v1}, Ljava/lang/Math;->round(F)I

    move-result v1

    sub-float v2, p3, p4

    invoke-static {v2}, Ljava/lang/Math;->round(F)I

    move-result v2

    add-float/2addr p2, p4

    .line 232
    invoke-static {p2}, Ljava/lang/Math;->round(F)I

    move-result p2

    add-float/2addr p3, p4

    invoke-static {p3}, Ljava/lang/Math;->round(F)I

    move-result p3

    .line 231
    invoke-virtual {v0, v1, v2, p2, p3}, Landroid/graphics/drawable/Drawable;->setBounds(IIII)V

    .line 233
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->resetIcon:Landroid/graphics/drawable/Drawable;

    invoke-virtual {p2, p1}, Landroid/graphics/drawable/Drawable;->draw(Landroid/graphics/Canvas;)V

    .line 234
    return-void

    .line 236
    :cond_0
    const v0, 0x3ed70a3d    # 0.42f

    mul-float p4, p4, v0

    .line 237
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->rect:Landroid/graphics/RectF;

    sub-float v1, p2, p4

    sub-float v2, p3, p4

    add-float v3, p2, p4

    add-float v4, p3, p4

    invoke-virtual {v0, v1, v2, v3, v4}, Landroid/graphics/RectF;->set(FFFF)V

    .line 238
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    invoke-virtual {v0}, Landroid/graphics/Path;->reset()V

    .line 239
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->rect:Landroid/graphics/RectF;

    const/high16 v2, -0x3d900000    # -60.0f

    const/high16 v3, 0x438c0000    # 280.0f

    invoke-virtual {v0, v1, v2, v3}, Landroid/graphics/Path;->addArc(Landroid/graphics/RectF;FF)V

    .line 240
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->glyph:Landroid/graphics/Paint;

    iget v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->accent:I

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setColor(I)V

    .line 241
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->glyph:Landroid/graphics/Paint;

    invoke-virtual {p1, v0, v1}, Landroid/graphics/Canvas;->drawPath(Landroid/graphics/Path;Landroid/graphics/Paint;)V

    .line 243
    const-wide/high16 v0, -0x3fb2000000000000L    # -60.0

    invoke-static {v0, v1}, Ljava/lang/Math;->toRadians(D)D

    move-result-wide v2

    invoke-static {v2, v3}, Ljava/lang/Math;->cos(D)D

    move-result-wide v2

    double-to-float v2, v2

    mul-float v2, v2, p4

    add-float/2addr p2, v2

    .line 244
    invoke-static {v0, v1}, Ljava/lang/Math;->toRadians(D)D

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/Math;->sin(D)D

    move-result-wide v0

    double-to-float v0, v0

    mul-float v0, v0, p4

    add-float/2addr p3, v0

    .line 245
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    invoke-virtual {v0}, Landroid/graphics/Path;->reset()V

    .line 246
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    const/high16 v1, 0x3f000000    # 0.5f

    mul-float v1, v1, p4

    sub-float v1, p2, v1

    const v2, 0x3dcccccd    # 0.1f

    mul-float v2, v2, p4

    sub-float v2, p3, v2

    invoke-virtual {v0, v1, v2}, Landroid/graphics/Path;->moveTo(FF)V

    .line 247
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    invoke-virtual {v0, p2, p3}, Landroid/graphics/Path;->lineTo(FF)V

    .line 248
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    const v1, 0x3e19999a    # 0.15f

    mul-float v1, v1, p4

    sub-float/2addr p2, v1

    const v1, 0x3f0ccccd    # 0.55f

    mul-float p4, p4, v1

    add-float/2addr p3, p4

    invoke-virtual {v0, p2, p3}, Landroid/graphics/Path;->lineTo(FF)V

    .line 249
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->path:Landroid/graphics/Path;

    iget-object p3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->glyph:Landroid/graphics/Paint;

    invoke-virtual {p1, p2, p3}, Landroid/graphics/Canvas;->drawPath(Landroid/graphics/Path;Landroid/graphics/Paint;)V

    .line 250
    return-void
.end method

.method private regionAt(FF)I
    .locals 12

    .line 324
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getWidth()I

    move-result v0

    int-to-float v0, v0

    .line 325
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getHeight()I

    move-result v1

    int-to-float v1, v1

    .line 326
    const/high16 v2, 0x42080000    # 34.0f

    iget v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v3, v3, v2

    .line 327
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

    .line 328
    const/4 v2, 0x0

    :goto_0
    if-ge v2, v8, :cond_1

    .line 329
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

    .line 330
    return v2

    .line 328
    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 333
    :cond_1
    const/high16 v2, 0x40000000    # 2.0f

    div-float/2addr v0, v2

    .line 334
    div-float/2addr v1, v2

    .line 335
    const/high16 v3, 0x41d00000    # 26.0f

    iget v4, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v4, v4, v3

    .line 336
    invoke-static {p1, p2, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->distance(FFFF)F

    move-result v3

    cmpg-float v3, v3, v4

    if-gtz v3, :cond_2

    return v8

    .line 338
    :cond_2
    const/high16 v3, 0x42280000    # 42.0f

    iget v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v5, v5, v3

    div-float/2addr v5, v2

    .line 339
    const/high16 v3, 0x41a00000    # 20.0f

    iget v6, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v6, v6, v3

    add-float/2addr v5, v6

    const/high16 v3, 0x42100000    # 36.0f

    iget v6, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v6, v6, v3

    div-float/2addr v6, v2

    add-float/2addr v5, v6

    .line 340
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

    .line 341
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

    .line 344
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

    .line 354
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;

    const/4 v1, 0x0

    aget v1, p1, v1

    const/4 v2, 0x1

    aget p1, p1, v2

    invoke-interface {v0, v1, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;->onEditDrag(FFZ)V

    .line 355
    :cond_0
    return-void
.end method

.method private reportScale(I[FZ)V
    .locals 3

    .line 358
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;

    const/4 v1, 0x0

    aget v1, p2, v1

    const/4 v2, 0x1

    aget p2, p2, v2

    invoke-interface {v0, p1, v1, p2, p3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;->onEditScale(IFFZ)V

    .line 359
    :cond_0
    return-void
.end method

.method private screenOf(Landroid/view/MotionEvent;)[F
    .locals 5

    .line 348
    const/4 v0, 0x2

    new-array v1, v0, [I

    .line 349
    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getLocationOnScreen([I)V

    .line 350
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

.method private static stockIcon(Landroid/content/Context;I)Landroid/graphics/drawable/Drawable;
    .locals 1

    .line 222
    const/4 v0, 0x0

    :try_start_0
    invoke-virtual {p0, p1}, Landroid/content/Context;->getDrawable(I)Landroid/graphics/drawable/Drawable;

    move-result-object p0

    .line 223
    if-nez p0, :cond_0

    goto :goto_0

    :cond_0
    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->mutate()Landroid/graphics/drawable/Drawable;

    move-result-object v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :goto_0
    return-object v0

    .line 224
    :catchall_0
    move-exception p0

    .line 225
    return-object v0
.end method


# virtual methods
.method protected onDraw(Landroid/graphics/Canvas;)V
    .locals 11

    .line 97
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getWidth()I

    move-result v0

    int-to-float v0, v0

    .line 98
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getHeight()I

    move-result v1

    int-to-float v1, v1

    .line 99
    const/4 v2, 0x0

    cmpg-float v3, v0, v2

    if-lez v3, :cond_3

    cmpg-float v3, v1, v2

    if-gtz v3, :cond_0

    goto/16 :goto_2

    .line 102
    :cond_0
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    sget-object v4, Landroid/graphics/Paint$Style;->FILL:Landroid/graphics/Paint$Style;

    invoke-virtual {v3, v4}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 103
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    const v4, 0x73ffffff

    invoke-virtual {v3, v4}, Landroid/graphics/Paint;->setColor(I)V

    .line 104
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->rect:Landroid/graphics/RectF;

    invoke-virtual {v3, v2, v2, v0, v1}, Landroid/graphics/RectF;->set(FFFF)V

    .line 105
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->rect:Landroid/graphics/RectF;

    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    invoke-virtual {p1, v2, v3}, Landroid/graphics/Canvas;->drawRect(Landroid/graphics/RectF;Landroid/graphics/Paint;)V

    .line 108
    const/high16 v2, 0x42400000    # 48.0f

    iget v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v3, v3, v2

    .line 109
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    iget v4, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->accentSoft:I

    invoke-virtual {v2, v4}, Landroid/graphics/Paint;->setColor(I)V

    .line 110
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->cornerCenters()[[F

    move-result-object v2

    array-length v4, v2

    const/4 v5, 0x0

    const/4 v6, 0x0

    :goto_0
    const/high16 v7, 0x40000000    # 2.0f

    if-ge v6, v4, :cond_1

    aget-object v8, v2, v6

    .line 111
    aget v9, v8, v5

    const/4 v10, 0x1

    aget v8, v8, v10

    div-float v7, v3, v7

    iget-object v10, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    invoke-virtual {p1, v9, v8, v7, v10}, Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V

    .line 110
    add-int/lit8 v6, v6, 0x1

    goto :goto_0

    .line 115
    :cond_1
    iget v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v2, v2, v7

    div-float/2addr v2, v7

    .line 116
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->rect:Landroid/graphics/RectF;

    sub-float v4, v0, v2

    sub-float v5, v1, v2

    invoke-virtual {v3, v2, v2, v4, v5}, Landroid/graphics/RectF;->set(FFFF)V

    .line 117
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->rect:Landroid/graphics/RectF;

    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->line:Landroid/graphics/Paint;

    invoke-virtual {p1, v2, v3}, Landroid/graphics/Canvas;->drawRect(Landroid/graphics/RectF;Landroid/graphics/Paint;)V

    .line 119
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->drawCorners(Landroid/graphics/Canvas;)V

    .line 122
    div-float/2addr v0, v7

    .line 123
    div-float/2addr v1, v7

    .line 124
    const/high16 v2, 0x42280000    # 42.0f

    iget v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v3, v3, v2

    div-float/2addr v3, v7

    .line 125
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    iget-boolean v4, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->movePressed:Z

    if-eqz v4, :cond_2

    iget v4, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->accent:I

    invoke-static {v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->darken(I)I

    move-result v4

    goto :goto_1

    :cond_2
    iget v4, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->accent:I

    :goto_1
    invoke-virtual {v2, v4}, Landroid/graphics/Paint;->setColor(I)V

    .line 126
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    invoke-virtual {p1, v0, v1, v3, v2}, Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V

    .line 127
    invoke-direct {p0, p1, v0, v1, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->drawMoveArrow(Landroid/graphics/Canvas;FFF)V

    .line 130
    const/high16 v2, 0x42100000    # 36.0f

    iget v4, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v4, v4, v2

    div-float/2addr v4, v7

    .line 131
    const/high16 v2, 0x41a00000    # 20.0f

    iget v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v5, v5, v2

    add-float/2addr v3, v5

    add-float/2addr v3, v4

    .line 132
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    iget v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->accentSoft:I

    invoke-virtual {v2, v5}, Landroid/graphics/Paint;->setColor(I)V

    .line 133
    sub-float v2, v0, v3

    iget v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    const/high16 v6, 0x40c00000    # 6.0f

    mul-float v5, v5, v6

    add-float/2addr v5, v1

    iget-object v7, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    invoke-virtual {p1, v2, v5, v4, v7}, Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V

    .line 134
    add-float/2addr v0, v3

    iget v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v3, v3, v6

    add-float/2addr v3, v1

    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->fill:Landroid/graphics/Paint;

    invoke-virtual {p1, v0, v3, v4, v5}, Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V

    .line 135
    iget v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v3, v3, v6

    add-float/2addr v3, v1

    invoke-direct {p0, p1, v2, v3, v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->drawReset(Landroid/graphics/Canvas;FFF)V

    .line 136
    iget v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->density:F

    mul-float v2, v2, v6

    add-float/2addr v1, v2

    invoke-direct {p0, p1, v0, v1, v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->drawDone(Landroid/graphics/Canvas;FFF)V

    .line 137
    return-void

    .line 99
    :cond_3
    :goto_2
    return-void
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 6

    .line 275
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    const/4 v1, 0x3

    const/4 v2, 0x4

    const/4 v3, 0x0

    const/4 v4, 0x1

    packed-switch v0, :pswitch_data_0

    .line 318
    return v4

    .line 290
    :pswitch_0
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    if-gez v0, :cond_0

    return v4

    .line 291
    :cond_0
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->screenOf(Landroid/view/MotionEvent;)[F

    move-result-object p1

    .line 292
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    if-gt v0, v1, :cond_1

    .line 293
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    invoke-direct {p0, v0, p1, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->reportScale(I[FZ)V

    goto :goto_0

    .line 294
    :cond_1
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    if-ne v0, v2, :cond_2

    .line 295
    invoke-direct {p0, p1, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->reportDrag([FZ)V

    .line 297
    :cond_2
    :goto_0
    return v4

    .line 301
    :pswitch_1
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    .line 302
    const/4 v5, -0x1

    iput v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    .line 303
    iput-boolean v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->movePressed:Z

    .line 304
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->invalidate()V

    .line 305
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->screenOf(Landroid/view/MotionEvent;)[F

    move-result-object p1

    .line 306
    if-ltz v0, :cond_3

    if-gt v0, v1, :cond_3

    .line 307
    invoke-direct {p0, v0, p1, v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->reportScale(I[FZ)V

    goto :goto_1

    .line 308
    :cond_3
    if-ne v0, v2, :cond_4

    .line 309
    invoke-direct {p0, p1, v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->reportDrag([FZ)V

    goto :goto_1

    .line 310
    :cond_4
    const/4 p1, 0x5

    if-ne v0, p1, :cond_5

    .line 311
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;

    if-eqz p1, :cond_6

    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;

    invoke-interface {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;->onEditReset()V

    goto :goto_1

    .line 312
    :cond_5
    const/4 p1, 0x6

    if-ne v0, p1, :cond_6

    .line 313
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;

    if-eqz p1, :cond_6

    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;

    invoke-interface {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;->onEditDone()V

    .line 315
    :cond_6
    :goto_1
    return v4

    .line 277
    :pswitch_2
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F

    move-result v0

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    move-result v5

    invoke-direct {p0, v0, v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->regionAt(FF)I

    move-result v0

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    .line 278
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    if-ne v0, v2, :cond_7

    iput-boolean v4, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->movePressed:Z

    .line 279
    :cond_7
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    if-eqz v0, :cond_8

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    invoke-interface {v0, v4}, Landroid/view/ViewParent;->requestDisallowInterceptTouchEvent(Z)V

    .line 280
    :cond_8
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->screenOf(Landroid/view/MotionEvent;)[F

    move-result-object p1

    .line 281
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    if-ltz v0, :cond_9

    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    if-gt v0, v1, :cond_9

    .line 282
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    invoke-direct {p0, v0, p1, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->reportScale(I[FZ)V

    goto :goto_2

    .line 283
    :cond_9
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->active:I

    if-ne v0, v2, :cond_a

    .line 284
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->invalidate()V

    .line 285
    invoke-direct {p0, p1, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->reportDrag([FZ)V

    .line 287
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

    .line 90
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;

    .line 91
    return-void
.end method
