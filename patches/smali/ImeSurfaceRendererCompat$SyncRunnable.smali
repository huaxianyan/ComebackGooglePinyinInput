.class final Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat$SyncRunnable;
.super Ljava/lang/Object;
.source "ImeSurfaceRendererCompat.java"

.implements Ljava/lang/Runnable;

.field private final view:Landroid/view/View;

.method constructor <init>(Landroid/view/View;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat$SyncRunnable;->view:Landroid/view/View;
    return-void
.end method

.method public run()V
    .locals 1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat$SyncRunnable;->view:Landroid/view/View;
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->syncNow(Landroid/view/View;)V
    return-void
.end method
