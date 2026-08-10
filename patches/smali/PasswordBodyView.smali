.class public final Lcom/google/android/inputmethod/pinyin/PasswordBodyView;
.super Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyboardView;
.source "PasswordBodyView.java"


# static fields
.field private static final KEYBOARD_HEADER_HEIGHT:I = 0x7f0d00a9


# instance fields
.field private expanded:Z

.field private originalHeight:I


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .registers 2

    .line 17
    invoke-direct {p0, p1}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyboardView;-><init>(Landroid/content/Context;)V

    .line 18
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .registers 3

    .line 21
    invoke-direct {p0, p1, p2}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyboardView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 22
    return-void
.end method


# virtual methods
.method protected onAttachedToWindow()V
    .registers 5

    .line 25
    invoke-super {p0}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyboardView;->onAttachedToWindow()V

    .line 26
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->expanded:Z

    if-eqz v0, :cond_8

    .line 27
    return-void

    .line 29
    :cond_8
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    .line 30
    if-eqz v0, :cond_2e

    iget v1, v0, Landroid/view/ViewGroup$LayoutParams;->height:I

    if-gtz v1, :cond_13

    goto :goto_2e

    .line 33
    :cond_13
    iget v1, v0, Landroid/view/ViewGroup$LayoutParams;->height:I

    iput v1, p0, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->originalHeight:I

    .line 34
    iget v1, p0, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->originalHeight:I

    .line 35
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->getResources()Landroid/content/res/Resources;

    move-result-object v2

    const v3, 0x7f0d00a9

    invoke-virtual {v2, v3}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result v2

    add-int/2addr v1, v2

    iput v1, v0, Landroid/view/ViewGroup$LayoutParams;->height:I

    .line 36
    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 37
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->expanded:Z

    .line 38
    return-void

    .line 31
    :cond_2e
    :goto_2e
    return-void
.end method

.method protected onDetachedFromWindow()V
    .registers 3

    .line 41
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->expanded:Z

    if-eqz v0, :cond_14

    .line 42
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    .line 43
    if-eqz v0, :cond_11

    .line 44
    iget v1, p0, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->originalHeight:I

    iput v1, v0, Landroid/view/ViewGroup$LayoutParams;->height:I

    .line 45
    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 47
    :cond_11
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->expanded:Z

    .line 49
    :cond_14
    invoke-super {p0}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyboardView;->onDetachedFromWindow()V

    .line 50
    return-void
.end method
