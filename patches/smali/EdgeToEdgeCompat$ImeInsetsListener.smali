.class final Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$ImeInsetsListener;
.super Ljava/lang/Object;
.source "EdgeToEdgeCompat.java"

# interfaces
.implements Landroid/view/View$OnApplyWindowInsetsListener;


# instance fields
.field private bottomFrame:Landroid/view/View;

.field private final root:Landroid/view/View;


# direct methods
.method constructor <init>(Landroid/view/View;)V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$ImeInsetsListener;->root:Landroid/view/View;

    return-void
.end method


# virtual methods
.method public onApplyWindowInsets(Landroid/view/View;Landroid/view/WindowInsets;)Landroid/view/WindowInsets;
    .locals 7

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat;->getNavigationBarBottomInset(Landroid/view/View;)I

    move-result v0

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$ImeInsetsListener;->root:Landroid/view/View;

    invoke-virtual {v1}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v3

    instance-of v2, v3, Landroid/view/ViewGroup;

    if-eqz v2, :no_stable_frame_parent

    check-cast v3, Landroid/view/ViewGroup;

    invoke-virtual {v3}, Landroid/view/View;->isLayoutRequested()Z

    move-result v2

    if-nez v2, :no_stable_frame_parent

    invoke-virtual {v3}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v2

    if-lez v2, :no_stable_frame_parent

    add-int/lit8 v2, v2, -0x1

    invoke-virtual {v3, v2}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v4

    instance-of v2, v4, Landroid/view/ViewGroup;

    if-eqz v2, :no_stable_frame_parent

    invoke-virtual {v4}, Landroid/view/View;->isLayoutRequested()Z

    move-result v2

    if-nez v2, :no_stable_frame_parent

    invoke-virtual {v4}, Landroid/view/View;->isLaidOut()Z

    move-result v2

    if-eqz v2, :no_stable_frame_parent

    invoke-virtual {v4}, Landroid/view/View;->getHeight()I

    move-result v2

    if-lez v2, :no_stable_frame_parent

    if-ne v2, v0, :no_stable_frame_parent

    invoke-virtual {v4}, Landroid/view/View;->getBottom()I

    move-result v5

    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v6

    if-ne v5, v6, :no_stable_frame_parent

    invoke-virtual {v4}, Landroid/view/View;->getWidth()I

    move-result v5

    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v6

    if-ne v5, v6, :no_stable_frame_parent

    move-object v3, v4

    goto :apply_margin

    :no_stable_frame_parent
    const/4 v3, 0x0

    :apply_margin
    invoke-virtual {v1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v2

    instance-of v4, v2, Landroid/view/ViewGroup$MarginLayoutParams;

    if-eqz v4, :frame_parent

    check-cast v2, Landroid/view/ViewGroup$MarginLayoutParams;

    iget v4, v2, Landroid/view/ViewGroup$MarginLayoutParams;->bottomMargin:I

    if-eq v4, v0, :frame_parent

    iput v0, v2, Landroid/view/ViewGroup$MarginLayoutParams;->bottomMargin:I

    invoke-virtual {v1, v2}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    :frame_parent
    instance-of v2, v3, Landroid/view/ViewGroup;

    if-eqz v2, :done

    check-cast v3, Landroid/view/ViewGroup;

    const-string v5, "ime-navigation-frame"

    invoke-virtual {v3, v5}, Landroid/view/ViewGroup;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v4

    if-nez v4, :reuse_frame

    invoke-virtual {v1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v2

    new-instance v4, Landroid/view/View;

    invoke-direct {v4, v2}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    invoke-virtual {v4, v5}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    const/4 v2, 0x2

    invoke-virtual {v4, v2}, Landroid/view/View;->setImportantForAccessibility(I)V

    new-instance v2, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v5, -0x1

    const/16 v6, 0x50

    invoke-direct {v2, v5, v0, v6}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    const/4 v5, 0x0

    invoke-virtual {v3, v4, v5, v2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;ILandroid/view/ViewGroup$LayoutParams;)V

    :reuse_frame
    iput-object v4, p0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$ImeInsetsListener;->bottomFrame:Landroid/view/View;

    :update_frame
    invoke-virtual {v4}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v2

    if-eqz v2, :background

    iget v3, v2, Landroid/view/ViewGroup$LayoutParams;->height:I

    if-eq v3, v0, :background

    iput v0, v2, Landroid/view/ViewGroup$LayoutParams;->height:I

    invoke-virtual {v4, v2}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    :background
    const-string v2, ".keyboard-body-area"

    invoke-virtual {v1, v2}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v2

    if-nez v2, :theme_source

    const v2, 0x7f0f0153

    invoke-virtual {v1, v2}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v2

    :theme_source
    if-eqz v2, :done

    invoke-virtual {v2}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;

    move-result-object v2

    if-eqz v2, :done

    invoke-virtual {v2}, Landroid/graphics/drawable/Drawable;->getConstantState()Landroid/graphics/drawable/Drawable$ConstantState;

    move-result-object v3

    if-eqz v3, :shared_background

    invoke-virtual {v1}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    invoke-virtual {v3, v1}, Landroid/graphics/drawable/Drawable$ConstantState;->newDrawable(Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;

    move-result-object v2

    invoke-virtual {v2}, Landroid/graphics/drawable/Drawable;->mutate()Landroid/graphics/drawable/Drawable;

    move-result-object v2

    :shared_background
    invoke-virtual {v4, v2}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    :done
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat;->refreshNavigationBarTheme()V

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat;->suppressNavigationBarContrast(Landroid/view/View;)V

    return-object p2
.end method
