.class final Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;
.super Landroid/view/View;
.source "FloatingCardShadow.java"


# static fields
.field static final INSET_DP:F = 9.0f


# instance fields
.field private final card:Landroid/graphics/RectF;

.field private final inset:F

.field private final paint:Landroid/graphics/Paint;

.field private final ring:Landroid/graphics/Path;


# direct methods
.method constructor <init>(Landroid/content/Context;F)V
    .locals 4

    .line 36
    invoke-direct {p0, p1}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 30
    new-instance p1, Landroid/graphics/Paint;

    const/4 v0, 0x1

    invoke-direct {p1, v0}, Landroid/graphics/Paint;-><init>(I)V

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->paint:Landroid/graphics/Paint;

    .line 31
    new-instance p1, Landroid/graphics/Path;

    invoke-direct {p1}, Landroid/graphics/Path;-><init>()V

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->ring:Landroid/graphics/Path;

    .line 32
    new-instance p1, Landroid/graphics/RectF;

    invoke-direct {p1}, Landroid/graphics/RectF;-><init>()V

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->card:Landroid/graphics/RectF;

    .line 37
    const/high16 p1, 0x41100000    # 9.0f

    mul-float p1, p1, p2

    iput p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inset:F

    .line 38
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->paint:Landroid/graphics/Paint;

    sget-object v1, Landroid/graphics/Paint$Style;->FILL:Landroid/graphics/Paint$Style;

    invoke-virtual {p1, v1}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 41
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->paint:Landroid/graphics/Paint;

    const/high16 v1, 0x1000000

    invoke-virtual {p1, v1}, Landroid/graphics/Paint;->setColor(I)V

    .line 42
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->ring:Landroid/graphics/Path;

    sget-object v1, Landroid/graphics/Path$FillType;->EVEN_ODD:Landroid/graphics/Path$FillType;

    invoke-virtual {p1, v1}, Landroid/graphics/Path;->setFillType(Landroid/graphics/Path$FillType;)V

    .line 43
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->paint:Landroid/graphics/Paint;

    const/high16 v1, 0x40c00000    # 6.0f

    mul-float v1, v1, p2

    const/high16 v2, 0x40000000    # 2.0f

    mul-float p2, p2, v2

    const/high16 v2, 0x26000000

    const/4 v3, 0x0

    invoke-virtual {p1, v1, v3, p2, v2}, Landroid/graphics/Paint;->setShadowLayer(FFFI)V

    .line 44
    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setWillNotDraw(Z)V

    .line 45
    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setClickable(Z)V

    .line 46
    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setFocusable(Z)V

    .line 47
    const/4 p1, 0x2

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setImportantForAccessibility(I)V

    .line 49
    const/4 p1, 0x0

    invoke-virtual {p0, v0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setLayerType(ILandroid/graphics/Paint;)V

    .line 50
    return-void
.end method


# virtual methods
.method protected onDraw(Landroid/graphics/Canvas;)V
    .locals 13

    .line 64
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->card:Landroid/graphics/RectF;

    invoke-virtual {v0}, Landroid/graphics/RectF;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 65
    :cond_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getWidth()I

    move-result v0

    .line 66
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getHeight()I

    move-result v1

    .line 67
    if-lez v0, :cond_2

    if-gtz v1, :cond_1

    goto :goto_0

    .line 71
    :cond_1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->ring:Landroid/graphics/Path;

    invoke-virtual {v0}, Landroid/graphics/Path;->reset()V

    .line 72
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->ring:Landroid/graphics/Path;

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->card:Landroid/graphics/RectF;

    iget v0, v0, Landroid/graphics/RectF;->left:F

    iget v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inset:F

    sub-float v2, v0, v2

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->card:Landroid/graphics/RectF;

    iget v0, v0, Landroid/graphics/RectF;->top:F

    iget v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inset:F

    sub-float v3, v0, v3

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->card:Landroid/graphics/RectF;

    iget v0, v0, Landroid/graphics/RectF;->right:F

    iget v4, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inset:F

    add-float/2addr v4, v0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->card:Landroid/graphics/RectF;

    iget v0, v0, Landroid/graphics/RectF;->bottom:F

    iget v5, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->inset:F

    add-float/2addr v5, v0

    sget-object v6, Landroid/graphics/Path$Direction;->CW:Landroid/graphics/Path$Direction;

    invoke-virtual/range {v1 .. v6}, Landroid/graphics/Path;->addRect(FFFFLandroid/graphics/Path$Direction;)V

    .line 74
    iget-object v7, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->ring:Landroid/graphics/Path;

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->card:Landroid/graphics/RectF;

    iget v8, v0, Landroid/graphics/RectF;->left:F

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->card:Landroid/graphics/RectF;

    iget v9, v0, Landroid/graphics/RectF;->top:F

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->card:Landroid/graphics/RectF;

    iget v10, v0, Landroid/graphics/RectF;->right:F

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->card:Landroid/graphics/RectF;

    iget v11, v0, Landroid/graphics/RectF;->bottom:F

    sget-object v12, Landroid/graphics/Path$Direction;->CW:Landroid/graphics/Path$Direction;

    invoke-virtual/range {v7 .. v12}, Landroid/graphics/Path;->addRect(FFFFLandroid/graphics/Path$Direction;)V

    .line 75
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->ring:Landroid/graphics/Path;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->paint:Landroid/graphics/Paint;

    invoke-virtual {p1, v0, v1}, Landroid/graphics/Canvas;->drawPath(Landroid/graphics/Path;Landroid/graphics/Paint;)V

    .line 76
    return-void

    .line 67
    :cond_2
    :goto_0
    return-void
.end method

.method setCardRect(FFFF)V
    .locals 2

    .line 54
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->card:Landroid/graphics/RectF;

    iget v0, v0, Landroid/graphics/RectF;->left:F

    cmpl-float v0, v0, p1

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->card:Landroid/graphics/RectF;

    iget v0, v0, Landroid/graphics/RectF;->top:F

    cmpl-float v0, v0, p2

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->card:Landroid/graphics/RectF;

    iget v0, v0, Landroid/graphics/RectF;->right:F

    add-float v1, p1, p3

    cmpl-float v0, v0, v1

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->card:Landroid/graphics/RectF;

    iget v0, v0, Landroid/graphics/RectF;->bottom:F

    add-float v1, p2, p4

    cmpl-float v0, v0, v1

    if-nez v0, :cond_0

    .line 56
    return-void

    .line 58
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->card:Landroid/graphics/RectF;

    add-float/2addr p3, p1

    add-float/2addr p4, p2

    invoke-virtual {v0, p1, p2, p3, p4}, Landroid/graphics/RectF;->set(FFFF)V

    .line 59
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->invalidate()V

    .line 60
    return-void
.end method
