.class Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$3;
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


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;)V
    .locals 0

    .line 76
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$3;->this$0:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 0

    .line 79
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$3;->this$0:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-static {p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->access$100(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;Landroid/view/MotionEvent;)Z

    move-result p1

    return p1
.end method
