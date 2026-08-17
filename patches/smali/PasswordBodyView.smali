.class public final Lcom/google/android/inputmethod/pinyin/PasswordBodyView;
.super Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyboardView;
.source "PasswordBodyView.java"


# static fields
.field private static final KEYBOARD_HEADER_HEIGHT:I = 0x7f0d00a9

.field private static attachedView:Lcom/google/android/inputmethod/pinyin/PasswordBodyView;

.field private static passwordEditor:Z


# instance fields
.field private expanded:Z

.field private originalHeight:I


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .registers 2

    invoke-direct {p0, p1}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyboardView;-><init>(Landroid/content/Context;)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .registers 3

    invoke-direct {p0, p1, p2}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyboardView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    return-void
.end method

.method private collapse()V
    .registers 3

    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->expanded:Z

    if-eqz v0, :done

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    if-eqz v0, :reset

    iget v1, p0, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->originalHeight:I

    iput v1, v0, Landroid/view/ViewGroup$LayoutParams;->height:I

    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    :reset
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->expanded:Z

    :done
    return-void
.end method

.method private static isPasswordEditor(Landroid/view/inputmethod/EditorInfo;)Z
    .registers 5

    const/4 v0, 0x0

    if-eqz p0, :done

    iget v1, p0, Landroid/view/inputmethod/EditorInfo;->inputType:I

    and-int/lit8 v2, v1, 0xf

    and-int/lit16 v1, v1, 0xff0

    const/4 v3, 0x1

    if-ne v2, v3, :number

    const/16 v2, 0x80

    if-eq v1, v2, :password

    const/16 v2, 0x90

    if-eq v1, v2, :password

    const/16 v2, 0xe0

    if-ne v1, v2, :done

    :password
    const/4 v0, 0x1

    return v0

    :number
    const/4 v3, 0x2

    if-ne v2, v3, :done

    const/16 v2, 0x10

    if-ne v1, v2, :done

    const/4 v0, 0x1

    :done
    return v0
.end method

.method private updateHeight()V
    .registers 4

    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->passwordEditor:Z

    if-eqz v0, :collapse

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->isShown()Z

    move-result v0

    if-eqz v0, :collapse

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->getWindowVisibility()I

    move-result v0

    if-nez v0, :collapse

    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->expanded:Z

    if-nez v0, :done

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    if-eqz v0, :done

    iget v1, v0, Landroid/view/ViewGroup$LayoutParams;->height:I

    if-lez v1, :done

    iput v1, p0, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->originalHeight:I

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    const v2, 0x7f0d00a9

    invoke-virtual {v1, v2}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result v1

    iget v2, p0, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->originalHeight:I

    add-int/2addr v1, v2

    iput v1, v0, Landroid/view/ViewGroup$LayoutParams;->height:I

    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->expanded:Z

    return-void

    :collapse
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->collapse()V

    :done
    return-void
.end method

.method public static setEditorInfo(Landroid/view/inputmethod/EditorInfo;)V
    .registers 2

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->isPasswordEditor(Landroid/view/inputmethod/EditorInfo;)Z

    move-result v0

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->passwordEditor:Z

    sget-object v0, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->attachedView:Lcom/google/android/inputmethod/pinyin/PasswordBodyView;

    if-eqz v0, :done

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->updateHeight()V

    :done
    return-void
.end method


# virtual methods
.method protected onAttachedToWindow()V
    .registers 1

    invoke-super {p0}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyboardView;->onAttachedToWindow()V

    sput-object p0, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->attachedView:Lcom/google/android/inputmethod/pinyin/PasswordBodyView;

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->updateHeight()V

    return-void
.end method

.method protected onDetachedFromWindow()V
    .registers 2

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->collapse()V

    sget-object v0, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->attachedView:Lcom/google/android/inputmethod/pinyin/PasswordBodyView;

    if-ne v0, p0, :detached

    const/4 v0, 0x0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->attachedView:Lcom/google/android/inputmethod/pinyin/PasswordBodyView;

    :detached
    invoke-super {p0}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyboardView;->onDetachedFromWindow()V

    return-void
.end method

.method protected onVisibilityChanged(Landroid/view/View;I)V
    .registers 3

    invoke-super {p0, p1, p2}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyboardView;->onVisibilityChanged(Landroid/view/View;I)V

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->updateHeight()V

    return-void
.end method

.method protected onWindowVisibilityChanged(I)V
    .registers 2

    invoke-super {p0, p1}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyboardView;->onWindowVisibilityChanged(I)V

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/PasswordBodyView;->updateHeight()V

    return-void
.end method
