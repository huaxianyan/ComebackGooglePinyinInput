.class Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe$1;
.super Ljava/lang/Object;
.source "FloatingKeyboardProbe.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;->showEditor(Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;Landroid/view/View;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$anchor:Landroid/view/View;

.field final synthetic val$offset:I


# direct methods
.method constructor <init>(Landroid/view/View;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 102
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe$1;->val$anchor:Landroid/view/View;

    iput p2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe$1;->val$offset:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 4

    .line 106
    const-string v0, "FloatingProbe"

    :try_start_0
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;->access$000()Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardEditingViewHelper;

    move-result-object v1

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe$1;->val$anchor:Landroid/view/View;

    iget v3, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe$1;->val$offset:I

    invoke-virtual {v1, v2, v3}, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardEditingViewHelper;->a(Landroid/view/View;I)V

    .line 107
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "helper.a(anchor="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe$1;->val$anchor:Landroid/view/View;

    invoke-virtual {v2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe$1;->val$anchor:Landroid/view/View;

    .line 108
    invoke-virtual {v2}, Landroid/view/View;->getWidth()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "x"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe$1;->val$anchor:Landroid/view/View;

    invoke-virtual {v2}, Landroid/view/View;->getHeight()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, ", offset="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe$1;->val$offset:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, ") called"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 107
    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 110
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe$1;->val$anchor:Landroid/view/View;

    invoke-virtual {v1}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v1

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;->access$100(Landroid/view/View;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 113
    goto :goto_0

    .line 111
    :catchall_0
    move-exception v1

    .line 112
    const-string v2, "stock editor failed"

    invoke-static {v0, v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 114
    :goto_0
    return-void
.end method
