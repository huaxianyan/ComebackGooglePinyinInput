.class public final Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererRegistry;
.super Ljava/lang/Object;
.source "HeaderRendererRegistry.java"


# instance fields
.field private final renderers:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;",
            "Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderer;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public constructor <init>()V
    .locals 2

    .line 9
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 10
    new-instance v0, Ljava/util/EnumMap;

    const-class v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    invoke-direct {v0, v1}, Ljava/util/EnumMap;-><init>(Ljava/lang/Class;)V

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererRegistry;->renderers:Ljava/util/Map;

    return-void
.end method


# virtual methods
.method public prepare(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;
    .locals 2

    .line 26
    if-nez p2, :cond_0

    const/4 p1, 0x0

    return-object p1

    .line 27
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererRegistry;->renderers:Ljava/util/Map;

    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getPresentationKind()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    move-result-object v1

    invoke-interface {v0, v1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderer;

    .line 28
    if-eqz v0, :cond_4

    .line 32
    invoke-interface {v0, p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderer;->prepare(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;

    move-result-object p1

    .line 33
    if-eqz p1, :cond_2

    invoke-interface {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;->getView()Landroid/view/View;

    move-result-object p2

    if-nez p2, :cond_1

    goto :goto_0

    .line 37
    :cond_1
    return-object p1

    .line 34
    :cond_2
    :goto_0
    if-eqz p1, :cond_3

    invoke-interface {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;->release()V

    .line 35
    :cond_3
    new-instance p1, Ljava/lang/IllegalStateException;

    const-string p2, "Header renderer returned no View"

    invoke-direct {p1, p2}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 29
    :cond_4
    new-instance p1, Ljava/lang/IllegalStateException;

    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "No Header renderer for "

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    .line 30
    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getPresentationKind()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    move-result-object p2

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-direct {p1, p2}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method public register(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderer;)V
    .locals 3

    .line 14
    if-eqz p1, :cond_1

    invoke-interface {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderer;->getPresentationKind()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    move-result-object v0

    if-eqz v0, :cond_1

    .line 17
    invoke-interface {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderer;->getPresentationKind()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    move-result-object v0

    .line 18
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererRegistry;->renderers:Ljava/util/Map;

    invoke-interface {v1, v0}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_0

    .line 21
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererRegistry;->renderers:Ljava/util/Map;

    invoke-interface {v1, v0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 22
    return-void

    .line 19
    :cond_0
    new-instance p1, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "duplicate Header renderer: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 15
    :cond_1
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string v0, "renderer and kind must not be null"

    invoke-direct {p1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method
