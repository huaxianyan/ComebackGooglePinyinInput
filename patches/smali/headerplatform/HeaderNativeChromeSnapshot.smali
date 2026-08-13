.class public final Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;
.super Ljava/lang/Object;
.source "HeaderNativeChromeSnapshot.java"


# instance fields
.field private final candidateTextColor:Ljava/lang/Integer;

.field private final divider:Landroid/graphics/drawable/Drawable;

.field private final dividerAlpha:F

.field private final dividerPaddingBottom:I

.field private final dividerPaddingTop:I

.field private final dividerWidth:I

.field private final iconAlpha:F

.field private final leadingInset:I

.field private final nextDisabled:Landroid/graphics/drawable/Drawable;

.field private final nextEnabled:Landroid/graphics/drawable/Drawable;

.field private final previousDisabled:Landroid/graphics/drawable/Drawable;

.field private final previousEnabled:Landroid/graphics/drawable/Drawable;

.field private final railWidth:I

.field private final trailingInset:I


# direct methods
.method public constructor <init>(Landroid/graphics/drawable/Drawable;FLandroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;FIIIIIILjava/lang/Integer;)V
    .locals 0

    .line 27
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 28
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->divider:Landroid/graphics/drawable/Drawable;

    .line 29
    iput p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->dividerAlpha:F

    .line 30
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->previousEnabled:Landroid/graphics/drawable/Drawable;

    .line 31
    iput-object p4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->previousDisabled:Landroid/graphics/drawable/Drawable;

    .line 32
    iput-object p5, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->nextEnabled:Landroid/graphics/drawable/Drawable;

    .line 33
    iput-object p6, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->nextDisabled:Landroid/graphics/drawable/Drawable;

    .line 34
    iput p7, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->iconAlpha:F

    .line 35
    iput p8, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->railWidth:I

    .line 36
    iput p9, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->leadingInset:I

    .line 37
    iput p10, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->trailingInset:I

    .line 38
    iput p11, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->dividerWidth:I

    .line 39
    iput p12, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->dividerPaddingTop:I

    .line 40
    iput p13, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->dividerPaddingBottom:I

    .line 41
    iput-object p14, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->candidateTextColor:Ljava/lang/Integer;

    .line 42
    return-void
.end method

.method private static clone(Landroid/content/Context;Landroid/graphics/drawable/Drawable;)Landroid/graphics/drawable/Drawable;
    .locals 1

    .line 62
    if-nez p1, :cond_0

    const/4 p0, 0x0

    return-object p0

    .line 63
    :cond_0
    invoke-virtual {p1}, Landroid/graphics/drawable/Drawable;->getConstantState()Landroid/graphics/drawable/Drawable$ConstantState;

    move-result-object v0

    .line 64
    if-nez v0, :cond_1

    invoke-virtual {p1}, Landroid/graphics/drawable/Drawable;->mutate()Landroid/graphics/drawable/Drawable;

    move-result-object p0

    goto :goto_0

    .line 65
    :cond_1
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/graphics/drawable/Drawable$ConstantState;->newDrawable(Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;

    move-result-object p0

    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->mutate()Landroid/graphics/drawable/Drawable;

    move-result-object p0

    .line 68
    :goto_0
    invoke-virtual {p1}, Landroid/graphics/drawable/Drawable;->getLevel()I

    move-result v0

    invoke-virtual {p0, v0}, Landroid/graphics/drawable/Drawable;->setLevel(I)Z

    .line 69
    invoke-virtual {p1}, Landroid/graphics/drawable/Drawable;->getBounds()Landroid/graphics/Rect;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/graphics/drawable/Drawable;->setBounds(Landroid/graphics/Rect;)V

    .line 70
    return-object p0
.end method


# virtual methods
.method public getCandidateTextColor()Ljava/lang/Integer;
    .locals 1

    .line 59
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->candidateTextColor:Ljava/lang/Integer;

    return-object v0
.end method

.method public getDividerAlpha()F
    .locals 1

    .line 51
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->dividerAlpha:F

    return v0
.end method

.method public getDividerPaddingBottom()I
    .locals 1

    .line 58
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->dividerPaddingBottom:I

    return v0
.end method

.method public getDividerPaddingTop()I
    .locals 1

    .line 57
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->dividerPaddingTop:I

    return v0
.end method

.method public getDividerWidth()I
    .locals 1

    .line 56
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->dividerWidth:I

    return v0
.end method

.method public getIconAlpha()F
    .locals 1

    .line 52
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->iconAlpha:F

    return v0
.end method

.method public getLeadingInset()I
    .locals 1

    .line 54
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->leadingInset:I

    return v0
.end method

.method public getRailWidth()I
    .locals 1

    .line 53
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->railWidth:I

    return v0
.end method

.method public getTrailingInset()I
    .locals 1

    .line 55
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->trailingInset:I

    return v0
.end method

.method public newActionIcon(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;Z)Landroid/graphics/drawable/Drawable;
    .locals 1

    .line 46
    sget-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;->PREVIOUS:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

    if-ne p2, v0, :cond_1

    .line 47
    if-eqz p3, :cond_0

    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->previousEnabled:Landroid/graphics/drawable/Drawable;

    goto :goto_0

    :cond_0
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->previousDisabled:Landroid/graphics/drawable/Drawable;

    goto :goto_0

    .line 48
    :cond_1
    if-eqz p3, :cond_2

    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->nextEnabled:Landroid/graphics/drawable/Drawable;

    goto :goto_0

    :cond_2
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->nextDisabled:Landroid/graphics/drawable/Drawable;

    .line 49
    :goto_0
    invoke-static {p1, p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->clone(Landroid/content/Context;Landroid/graphics/drawable/Drawable;)Landroid/graphics/drawable/Drawable;

    move-result-object p1

    return-object p1
.end method

.method public newDivider(Landroid/content/Context;)Landroid/graphics/drawable/Drawable;
    .locals 1

    .line 44
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->divider:Landroid/graphics/drawable/Drawable;

    invoke-static {p1, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->clone(Landroid/content/Context;Landroid/graphics/drawable/Drawable;)Landroid/graphics/drawable/Drawable;

    move-result-object p1

    return-object p1
.end method
