.class public final Lcom/google/android/inputmethod/pinyin/ClipboardDismissAlign;
.super Ljava/lang/Object;
.source "ClipboardDismissAlign.java"


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 21
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static accumulatedScaleX(Landroid/view/View;)F
    .locals 4

    .line 58
    nop

    .line 59
    const/high16 v0, 0x3f800000    # 1.0f

    const/high16 v1, 0x3f800000    # 1.0f

    .line 60
    :goto_0
    const/4 v2, 0x0

    if-eqz p0, :cond_2

    .line 61
    invoke-virtual {p0}, Landroid/view/View;->getScaleX()F

    move-result v3

    .line 62
    cmpl-float v2, v3, v2

    if-lez v2, :cond_0

    mul-float v1, v1, v3

    .line 63
    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    instance-of v2, v2, Landroid/view/View;

    if-eqz v2, :cond_1

    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object p0

    check-cast p0, Landroid/view/View;

    goto :goto_1

    :cond_1
    const/4 p0, 0x0

    .line 64
    :goto_1
    goto :goto_0

    .line 65
    :cond_2
    cmpl-float p0, v1, v2

    if-lez p0, :cond_3

    move v0, v1

    :cond_3
    return v0
.end method

.method public static align(Landroid/view/View;Landroid/view/View;Landroid/view/View;)V
    .locals 7

    .line 28
    if-eqz p0, :cond_5

    if-eqz p1, :cond_5

    if-nez p2, :cond_0

    goto :goto_1

    .line 29
    :cond_0
    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    .line 30
    instance-of v1, v0, Landroid/widget/FrameLayout$LayoutParams;

    if-nez v1, :cond_1

    return-void

    .line 32
    :cond_1
    iget v1, v0, Landroid/view/ViewGroup$LayoutParams;->width:I

    if-lez v1, :cond_2

    iget v1, v0, Landroid/view/ViewGroup$LayoutParams;->width:I

    goto :goto_0

    :cond_2
    invoke-virtual {p1}, Landroid/view/View;->getMeasuredWidth()I

    move-result v1

    .line 33
    :goto_0
    if-gtz v1, :cond_3

    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v1

    .line 34
    :cond_3
    if-gtz v1, :cond_4

    return-void

    .line 36
    :cond_4
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/ClipboardDismissAlign;->accumulatedScaleX(Landroid/view/View;)F

    move-result v2

    .line 37
    const/4 v3, 0x2

    new-array v4, v3, [I

    .line 38
    new-array v5, v3, [I

    .line 39
    invoke-virtual {p2, v4}, Landroid/view/View;->getLocationInWindow([I)V

    .line 40
    invoke-virtual {p0, v5}, Landroid/view/View;->getLocationInWindow([I)V

    .line 44
    invoke-virtual {p2}, Landroid/view/View;->getWidth()I

    move-result p2

    int-to-float p2, p2

    mul-float p2, p2, v2

    invoke-static {p2}, Ljava/lang/Math;->round(F)I

    move-result p2

    .line 45
    const/4 v6, 0x0

    aget v4, v4, v6

    div-int/2addr p2, v3

    add-int/2addr v4, p2

    .line 46
    aget p2, v5, v6

    sub-int/2addr v4, p2

    int-to-float p2, v4

    div-float/2addr p2, v2

    .line 47
    int-to-float v1, v1

    const/high16 v2, 0x40000000    # 2.0f

    div-float/2addr v1, v2

    sub-float/2addr p2, v1

    invoke-virtual {p0}, Landroid/view/View;->getPaddingLeft()I

    move-result p0

    int-to-float p0, p0

    sub-float/2addr p2, p0

    invoke-static {p2}, Ljava/lang/Math;->round(F)I

    move-result p0

    .line 49
    check-cast v0, Landroid/widget/FrameLayout$LayoutParams;

    .line 50
    const/4 p2, 0x3

    iput p2, v0, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    .line 51
    iput p0, v0, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    .line 52
    iput v6, v0, Landroid/widget/FrameLayout$LayoutParams;->rightMargin:I

    .line 53
    invoke-virtual {p1, v0}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 54
    return-void

    .line 28
    :cond_5
    :goto_1
    return-void
.end method
