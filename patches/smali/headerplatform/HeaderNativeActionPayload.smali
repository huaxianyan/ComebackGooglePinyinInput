.class public final Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionPayload;
.super Ljava/lang/Object;
.source "HeaderNativeActionPayload.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererPayload;


# instance fields
.field private final callback:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionCallback;

.field private final contentDescription:Ljava/lang/CharSequence;

.field private final enabled:Z

.field private final kind:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;


# direct methods
.method public constructor <init>(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;Ljava/lang/CharSequence;ZLcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionCallback;)V
    .locals 0

    .line 11
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 12
    if-eqz p1, :cond_0

    if-eqz p2, :cond_0

    if-eqz p4, :cond_0

    .line 15
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionPayload;->kind:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

    .line 16
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionPayload;->contentDescription:Ljava/lang/CharSequence;

    .line 17
    iput-boolean p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionPayload;->enabled:Z

    .line 18
    iput-object p4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionPayload;->callback:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionCallback;

    .line 19
    return-void

    .line 13
    :cond_0
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "native action metadata must not be null"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method


# virtual methods
.method public getCallback()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionCallback;
    .locals 1

    .line 24
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionPayload;->callback:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionCallback;

    return-object v0
.end method

.method public getContentDescription()Ljava/lang/CharSequence;
    .locals 1

    .line 22
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionPayload;->contentDescription:Ljava/lang/CharSequence;

    return-object v0
.end method

.method public getKind()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;
    .locals 1

    .line 21
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionPayload;->kind:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

    return-object v0
.end method

.method public isEnabled()Z
    .locals 1

    .line 23
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionPayload;->enabled:Z

    return v0
.end method
