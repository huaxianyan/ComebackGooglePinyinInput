.class Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$4;
.super Ljava/lang/Object;
.source "FloatingKeyboardEditView.java"

# interfaces
.implements Landroid/view/View$OnTouchListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;-><init>(Landroid/content/Context;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

.field final synthetic val$corner:I


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 90
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$4;->this$0:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    iput p2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$4;->val$corner:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 1

    .line 93
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$4;->this$0:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$4;->val$corner:I

    invoke-static {p1, v0, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->access$200(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;ILandroid/view/MotionEvent;)Z

    move-result p1

    return p1
.end method
