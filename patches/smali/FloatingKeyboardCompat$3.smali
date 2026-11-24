.class Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;
.super Ljava/lang/Object;
.source "FloatingKeyboardCompat.java"

# interfaces
.implements Landroid/view/View$OnTouchListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->attachIdleProbe(Landroid/view/ViewGroup;Landroid/view/View;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$area:Landroid/view/View;


# direct methods
.method constructor <init>(Landroid/view/View;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 314
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;->val$area:Landroid/view/View;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 0

    .line 317
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result p1

    packed-switch p1, :pswitch_data_0

    :pswitch_0
    goto :goto_0

    .line 323
    :pswitch_1
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;->val$area:Landroid/view/View;

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$800(Landroid/view/View;)V

    .line 324
    goto :goto_0

    .line 319
    :pswitch_2
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->access$700()V

    .line 320
    nop

    .line 329
    :goto_0
    const/4 p1, 0x0

    return p1

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_2
        :pswitch_1
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method
