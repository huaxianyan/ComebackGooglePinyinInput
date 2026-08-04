.class final Lcom/google/android/inputmethod/pinyin/ImeDecorDiagnosticsCompat$LayoutListener;
.super Ljava/lang/Object;
.source "ImeDecorDiagnosticsCompat.java"

.implements Landroid/view/View$OnLayoutChangeListener;

.field private final view:Landroid/view/View;

.method constructor <init>(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/ImeDecorDiagnosticsCompat$LayoutListener;->view:Landroid/view/View;

    return-void
.end method

.method public onLayoutChange(Landroid/view/View;IIIIIIII)V
    .locals 1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/ImeDecorDiagnosticsCompat$LayoutListener;->view:Landroid/view/View;

    new-instance p0, Lcom/google/android/inputmethod/pinyin/ImeDecorDiagnosticsCompat$DumpRunnable;

    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/ImeDecorDiagnosticsCompat$DumpRunnable;-><init>(Landroid/view/View;)V

    invoke-virtual {v0, p0}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    return-void
.end method
