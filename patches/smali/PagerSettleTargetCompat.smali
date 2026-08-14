.class public final Lcom/google/android/inputmethod/pinyin/PagerSettleTargetCompat;
.super Ljava/lang/Object;

.method private constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static choose(Landroid/view/View;IF)I
    .locals 3

    check-cast p0, Llk;

    iget v0, p0, Llk;->a:I

    int-to-float v1, p1

    add-float/2addr v1, p2

    int-to-float v2, v0

    sub-float/2addr v1, v2

    const/high16 v2, 0x3e000000    # 0.125f

    cmpl-float p1, v1, v2

    if-ltz p1, :check_previous

    add-int/lit8 v0, v0, 0x1

    return v0

    :check_previous
    neg-float v2, v2

    cmpl-float p1, v1, v2

    if-gtz p1, :current

    add-int/lit8 v0, v0, -0x1

    :current
    return v0
.end method
