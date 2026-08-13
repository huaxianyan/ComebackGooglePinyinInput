.class public final Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;
.super Ljava/lang/Object;
.source "InlineAutofillRemotePayload.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererPayload;


# instance fields
.field private final clipper:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;

.field private final requestCandidateTextColor:Ljava/lang/Integer;

.field private final views:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>(Ljava/util/List;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;Ljava/lang/Integer;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "+",
            "Landroid/view/View;",
            ">;",
            "Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;",
            "Ljava/lang/Integer;",
            ")V"
        }
    .end annotation

    .line 16
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 17
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 18
    if-eqz p1, :cond_1

    .line 19
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_0
    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/View;

    if-eqz v1, :cond_0

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_0

    .line 21
    :cond_1
    invoke-virtual {v0}, Ljava/util/ArrayList;->isEmpty()Z

    move-result p1

    if-nez p1, :cond_2

    if-eqz p2, :cond_2

    .line 24
    invoke-static {v0}, Ljava/util/Collections;->unmodifiableList(Ljava/util/List;)Ljava/util/List;

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;->views:Ljava/util/List;

    .line 25
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;->clipper:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;

    .line 26
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;->requestCandidateTextColor:Ljava/lang/Integer;

    .line 27
    return-void

    .line 22
    :cond_2
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "remote views and clipper must not be empty"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    goto :goto_2

    :goto_1
    throw p1

    :goto_2
    goto :goto_1
.end method


# virtual methods
.method public getClipper()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;
    .locals 1

    .line 30
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;->clipper:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;

    return-object v0
.end method

.method public getRequestCandidateTextColor()Ljava/lang/Integer;
    .locals 1

    .line 31
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;->requestCandidateTextColor:Ljava/lang/Integer;

    return-object v0
.end method

.method public getViews()Ljava/util/List;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation

    .line 29
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;->views:Ljava/util/List;

    return-object v0
.end method
