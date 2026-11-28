.class Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$2;
.super Ljava/lang/Object;
.source "FloatingKeyboardEditView.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


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

    .line 68
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$2;->this$0:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 0

    .line 71
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$2;->this$0:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->access$000(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;)Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;

    move-result-object p1

    if-eqz p1, :cond_0

    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$2;->this$0:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->access$000(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;)Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;

    move-result-object p1

    invoke-interface {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;->onDone()V

    .line 72
    :cond_0
    return-void
.end method
