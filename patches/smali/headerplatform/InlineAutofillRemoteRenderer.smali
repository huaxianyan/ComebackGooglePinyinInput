.class public final Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteRenderer;
.super Ljava/lang/Object;
.source "InlineAutofillRemoteRenderer.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderer;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 6
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public getPresentationKind()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;
    .locals 1

    .line 9
    sget-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;->REMOTE_SURFACE:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    return-object v0
.end method

.method public prepare(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;
    .locals 1

    .line 15
    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getPayload()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererPayload;

    move-result-object v0

    instance-of v0, v0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;

    if-eqz v0, :cond_0

    .line 18
    new-instance v0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;

    .line 19
    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getPayload()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererPayload;

    move-result-object p2

    check-cast p2, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;

    invoke-direct {v0, p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteContent;-><init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;)V

    .line 18
    return-object v0

    .line 16
    :cond_0
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "Inline Autofill requires remote payload"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method
