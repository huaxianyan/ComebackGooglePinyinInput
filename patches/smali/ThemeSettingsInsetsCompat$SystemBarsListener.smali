.class public final Lcom/google/android/inputmethod/pinyin/ThemeSettingsInsetsCompat$SystemBarsListener;
.super Ljava/lang/Object;
.source "ThemeSettingsInsetsCompat.java"

.implements Landroid/view/View$OnApplyWindowInsetsListener;

.field private final target:Landroid/view/View;
.field private final paddingLeft:I
.field private final paddingTop:I
.field private final paddingRight:I
.field private final paddingBottom:I

.method public constructor <init>(Landroid/view/View;)V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/ThemeSettingsInsetsCompat$SystemBarsListener;->target:Landroid/view/View;

    invoke-virtual {p1}, Landroid/view/View;->getPaddingLeft()I
    move-result v0
    iput v0, p0, Lcom/google/android/inputmethod/pinyin/ThemeSettingsInsetsCompat$SystemBarsListener;->paddingLeft:I

    invoke-virtual {p1}, Landroid/view/View;->getPaddingTop()I
    move-result v0
    iput v0, p0, Lcom/google/android/inputmethod/pinyin/ThemeSettingsInsetsCompat$SystemBarsListener;->paddingTop:I

    invoke-virtual {p1}, Landroid/view/View;->getPaddingRight()I
    move-result v0
    iput v0, p0, Lcom/google/android/inputmethod/pinyin/ThemeSettingsInsetsCompat$SystemBarsListener;->paddingRight:I

    invoke-virtual {p1}, Landroid/view/View;->getPaddingBottom()I
    move-result v0
    iput v0, p0, Lcom/google/android/inputmethod/pinyin/ThemeSettingsInsetsCompat$SystemBarsListener;->paddingBottom:I

    return-void
.end method

.method public onApplyWindowInsets(Landroid/view/View;Landroid/view/WindowInsets;)Landroid/view/WindowInsets;
    .locals 8

    const/4 v0, 0x0
    const/4 v1, 0x0
    const/4 v2, 0x0
    const/4 v3, 0x0

    sget v4, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v5, 0x1e

    if-lt v4, v5, :legacy

    invoke-static {}, Landroid/view/WindowInsets$Type;->systemBars()I
    move-result v4

    invoke-virtual {p2, v4}, Landroid/view/WindowInsets;->getInsets(I)Landroid/graphics/Insets;
    move-result-object v4

    iget v0, v4, Landroid/graphics/Insets;->left:I
    iget v1, v4, Landroid/graphics/Insets;->top:I
    iget v2, v4, Landroid/graphics/Insets;->right:I
    iget v3, v4, Landroid/graphics/Insets;->bottom:I

    goto :apply

    :legacy
    invoke-virtual {p2}, Landroid/view/WindowInsets;->getSystemWindowInsetLeft()I
    move-result v0

    invoke-virtual {p2}, Landroid/view/WindowInsets;->getSystemWindowInsetTop()I
    move-result v1

    invoke-virtual {p2}, Landroid/view/WindowInsets;->getSystemWindowInsetRight()I
    move-result v2

    invoke-virtual {p2}, Landroid/view/WindowInsets;->getSystemWindowInsetBottom()I
    move-result v3

    :apply
    iget v4, p0, Lcom/google/android/inputmethod/pinyin/ThemeSettingsInsetsCompat$SystemBarsListener;->paddingLeft:I
    add-int/2addr v0, v4

    iget v4, p0, Lcom/google/android/inputmethod/pinyin/ThemeSettingsInsetsCompat$SystemBarsListener;->paddingTop:I
    add-int/2addr v1, v4

    iget v4, p0, Lcom/google/android/inputmethod/pinyin/ThemeSettingsInsetsCompat$SystemBarsListener;->paddingRight:I
    add-int/2addr v2, v4

    iget v4, p0, Lcom/google/android/inputmethod/pinyin/ThemeSettingsInsetsCompat$SystemBarsListener;->paddingBottom:I
    add-int/2addr v3, v4

    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/ThemeSettingsInsetsCompat$SystemBarsListener;->target:Landroid/view/View;
    invoke-virtual {v4, v0, v1, v2, v3}, Landroid/view/View;->setPadding(IIII)V

    return-object p2
.end method
