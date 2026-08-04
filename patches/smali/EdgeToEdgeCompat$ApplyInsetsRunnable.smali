.class final Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$ApplyInsetsRunnable;
.super Ljava/lang/Object;
.source "EdgeToEdgeCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field private final view:Landroid/view/View;


# direct methods
.method constructor <init>(Landroid/view/View;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$ApplyInsetsRunnable;->view:Landroid/view/View;

    return-void
.end method


# virtual methods
.method public run()V
    .locals 1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat$ApplyInsetsRunnable;->view:Landroid/view/View;

    if-eqz v0, :done

    invoke-virtual {v0}, Landroid/view/View;->isAttachedToWindow()Z

    move-result p0

    if-eqz p0, :done

    invoke-virtual {v0}, Landroid/view/View;->requestApplyInsets()V

    invoke-virtual {v0}, Landroid/view/View;->requestLayout()V

    :done
    return-void
.end method
