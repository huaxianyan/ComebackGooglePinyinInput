.class public final Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer;
.super Ljava/lang/Object;
.source "HeaderNativeActionRenderer.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderer;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 7
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public getPresentationKind()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;
    .locals 1

    .line 10
    sget-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;->NATIVE_ACTION:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    return-object v0
.end method

.method public prepare(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;
    .locals 1

    .line 16
    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getPayload()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererPayload;

    move-result-object p1

    instance-of p1, p1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionPayload;

    if-eqz p1, :cond_0

    .line 19
    nop

    .line 20
    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getPayload()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererPayload;

    move-result-object p1

    check-cast p1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionPayload;

    .line 21
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionPayload;->getKind()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

    move-result-object p2

    invoke-interface {p3, p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;->createActionChromeSlot(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;

    move-result-object p2

    .line 22
    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->getRoot()Landroid/view/View;

    move-result-object p3

    .line 23
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionPayload;->getContentDescription()Ljava/lang/CharSequence;

    move-result-object v0

    invoke-virtual {p3, v0}, Landroid/view/View;->setContentDescription(Ljava/lang/CharSequence;)V

    .line 24
    new-instance v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer$1;

    invoke-direct {v0, p0, p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer$1;-><init>(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionPayload;)V

    invoke-virtual {p3, v0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 29
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionPayload;->isEnabled()Z

    move-result p1

    invoke-virtual {p2, p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;->setEnabled(Z)V

    .line 30
    new-instance p1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer$2;

    invoke-direct {p1, p0, p3, p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer$2;-><init>(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer;Landroid/view/View;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionSlot;)V

    return-object p1

    .line 17
    :cond_0
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "native action payload is required"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method
