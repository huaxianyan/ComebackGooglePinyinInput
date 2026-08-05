.class public final Lcom/google/android/inputmethod/pinyin/ImeThemeDiagnosticsCompat$DumpRunnable;
.super Ljava/lang/Object;
.source "ImeThemeDiagnosticsCompat.java"

# Debug-only bounded post-layout diagnostic. Stores no input or candidate data.
.implements Ljava/lang/Runnable;

.field private final root:Landroid/view/View;
.field private final label:Ljava/lang/String;

.method public constructor <init>(Landroid/view/View;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/ImeThemeDiagnosticsCompat$DumpRunnable;->root:Landroid/view/View;
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/ImeThemeDiagnosticsCompat$DumpRunnable;->label:Ljava/lang/String;
    return-void
.end method

.method public run()V
    .locals 2

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/ImeThemeDiagnosticsCompat$DumpRunnable;->root:Landroid/view/View;
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/ImeThemeDiagnosticsCompat$DumpRunnable;->label:Ljava/lang/String;
    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/ImeThemeDiagnosticsCompat;->dump(Landroid/view/View;Ljava/lang/String;)V
    return-void
.end method
