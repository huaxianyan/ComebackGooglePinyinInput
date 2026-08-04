.class public final Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat;
.super Ljava/lang/Object;
.source "EdgeToEdgeCompat.java"


# direct methods
.method private constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static attach(Landroid/view/View;Z)V
    .locals 1

    if-eqz p0, :cond_0

    new-instance v0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$BottomInsetsListener;

    invoke-direct {v0, p0, p1}, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$BottomInsetsListener;-><init>(Landroid/view/View;Z)V

    invoke-virtual {p0, v0}, Landroid/view/View;->setOnApplyWindowInsetsListener(Landroid/view/View$OnApplyWindowInsetsListener;)V

    invoke-virtual {p0}, Landroid/view/View;->requestApplyInsets()V

    :cond_0
    return-void
.end method

.method public static attachFirstRun(Landroid/app/Activity;)V
    .locals 3

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x23

    if-lt v0, v1, :cond_0

    const v0, 0x7f0f003f

    invoke-virtual {p0, v0}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    const/4 v1, 0x1

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat;->attach(Landroid/view/View;Z)V

    const v0, 0x7f0f0047

    invoke-virtual {p0, v0}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    const/4 v2, 0x0

    invoke-static {v0, v2}, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat;->attach(Landroid/view/View;Z)V

    :cond_0
    return-void
.end method

.method public static attachInputView(Landroid/view/View;)V
    .locals 2

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x23

    if-lt v0, v1, :done

    if-eqz p0, :done

    new-instance v0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$ImeInsetsListener;

    invoke-direct {v0, p0}, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$ImeInsetsListener;-><init>(Landroid/view/View;)V

    invoke-virtual {p0, v0}, Landroid/view/View;->setOnApplyWindowInsetsListener(Landroid/view/View$OnApplyWindowInsetsListener;)V

    invoke-virtual {p0}, Landroid/view/View;->requestApplyInsets()V

    :done
    return-void
.end method

.method public static configureImeWindow(Landroid/inputmethodservice/InputMethodService;)V
    .locals 3

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1e

    if-lt v0, v1, :done

    invoke-virtual {p0}, Landroid/inputmethodservice/InputMethodService;->getWindow()Landroid/app/Dialog;

    move-result-object v0

    if-eqz v0, :done

    invoke-virtual {v0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object v0

    if-eqz v0, :done

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/view/Window;->setDecorFitsSystemWindows(Z)V

    invoke-virtual {v0}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v1

    const/4 v2, 0x7

    invoke-virtual {v1, v2}, Landroid/view/WindowManager$LayoutParams;->setFitInsetsSides(I)V

    invoke-virtual {v0, v1}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    :done
    return-void
.end method
