.class Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$4;
.super Ljava/lang/Object;
.source "FloatingKeyboardCompat.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->requestAccessPointVisibility(Landroid/view/View;Z)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$decor:Landroid/view/View;

.field final synthetic val$hidden:Z


# direct methods
.method constructor <init>(Landroid/view/View;Z)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 346
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$4;->val$decor:Landroid/view/View;

    iput-boolean p2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$4;->val$hidden:Z

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .line 350
    :try_start_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$4;->val$decor:Landroid/view/View;

    iget-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$4;->val$hidden:Z

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$1000(Landroid/view/View;Z)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 353
    goto :goto_0

    .line 351
    :catchall_0
    move-exception v0

    .line 354
    :goto_0
    return-void
.end method
