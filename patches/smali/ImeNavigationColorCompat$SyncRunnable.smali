.class final Lcom/google/android/inputmethod/pinyin/ImeNavigationColorCompat$SyncRunnable;
.super Ljava/lang/Object;
.source "ImeNavigationColorCompat.java"

.implements Ljava/lang/Runnable;

.field private final view:Landroid/view/View;

.method constructor <init>(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/ImeNavigationColorCompat$SyncRunnable;->view:Landroid/view/View;

    return-void
.end method

.method public run()V
    .locals 1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/ImeNavigationColorCompat$SyncRunnable;->view:Landroid/view/View;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/ImeNavigationColorCompat;->syncNow(Landroid/view/View;)V

    return-void
.end method
