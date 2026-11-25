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
.field final synthetic val$nativeBar:Landroid/view/View;


# direct methods
.method constructor <init>(Landroid/view/View;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 391
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$5;->val$nativeBar:Landroid/view/View;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 1

    .line 395
    :try_start_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$5;->val$nativeBar:Landroid/view/View;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/QuickBar;->attach(Landroid/view/View;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 398
    goto :goto_0

    .line 396
    :catchall_0
    move-exception v0

    .line 399
    :goto_0
    return-void
.end method
