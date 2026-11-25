.class Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$5;
.super Ljava/lang/Object;
.source "FloatingKeyboardCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->syncFloatingToolbar(Landroid/view/View;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$hide:Z

.field final synthetic val$nativeBar:Landroid/view/View;


# direct methods
.method constructor <init>(Landroid/view/View;Z)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 401
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$5;->val$nativeBar:Landroid/view/View;

    iput-boolean p2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$5;->val$hide:Z

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .line 405
    :try_start_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$5;->val$nativeBar:Landroid/view/View;

    iget-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$5;->val$hide:Z

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/QuickBar;->attach(Landroid/view/View;Z)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 408
    goto :goto_0

    .line 406
    :catchall_0
    move-exception v0

    .line 409
    :goto_0
    return-void
.end method
