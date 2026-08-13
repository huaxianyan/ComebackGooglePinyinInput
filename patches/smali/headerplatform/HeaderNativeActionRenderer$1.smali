.class Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer$1;
.super Ljava/lang/Object;
.source "HeaderNativeActionRenderer.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer;->prepare(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer;

.field final synthetic val$payload:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionPayload;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionPayload;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 24
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer$1;->this$0:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer$1;->val$payload:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionPayload;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 0

    .line 26
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer$1;->val$payload:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionPayload;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionPayload;->isEnabled()Z

    move-result p1

    if-eqz p1, :cond_0

    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer$1;->val$payload:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionPayload;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionPayload;->getCallback()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionCallback;

    move-result-object p1

    invoke-interface {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionCallback;->performAction()V

    .line 27
    :cond_0
    return-void
.end method
