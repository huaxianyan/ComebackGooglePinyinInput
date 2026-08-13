.class Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer$2;
.super Ljava/lang/Object;
.source "HeaderNativeActionRenderer.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer;->prepare(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field private released:Z

.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer;

.field final synthetic val$root:Landroid/view/View;

.field final synthetic val$slot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer;Landroid/view/View;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 30
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer$2;->this$0:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer$2;->val$root:Landroid/view/View;

    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer$2;->val$slot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public getView()Landroid/view/View;
    .locals 1

    .line 32
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer$2;->val$root:Landroid/view/View;

    return-object v0
.end method

.method public release()V
    .locals 1

    .line 34
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer$2;->released:Z

    if-eqz v0, :cond_0

    return-void

    .line 35
    :cond_0
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer$2;->released:Z

    .line 36
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer$2;->val$slot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->clear()V

    .line 37
    return-void
.end method
