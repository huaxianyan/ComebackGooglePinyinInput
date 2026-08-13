.class public final Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderEditorContext;
.super Ljava/lang/Object;
.source "HeaderEditorContext.java"


# instance fields
.field private final disableAutoPaste:Z

.field private final imeOptions:I

.field private final inputType:I

.field private final packageName:Ljava/lang/String;


# direct methods
.method private constructor <init>(IILjava/lang/String;Z)V
    .locals 0

    .line 13
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 14
    iput p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderEditorContext;->inputType:I

    .line 15
    iput p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderEditorContext;->imeOptions:I

    .line 16
    if-nez p3, :cond_0

    const-string p3, ""

    :cond_0
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderEditorContext;->packageName:Ljava/lang/String;

    .line 17
    iput-boolean p4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderEditorContext;->disableAutoPaste:Z

    .line 18
    return-void
.end method

.method public static from(Landroid/view/inputmethod/EditorInfo;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderEditorContext;
    .locals 4

    .line 21
    const/4 v0, 0x0

    if-nez p0, :cond_0

    new-instance p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderEditorContext;

    const-string v1, ""

    invoke-direct {p0, v0, v0, v1, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderEditorContext;-><init>(IILjava/lang/String;Z)V

    return-object p0

    .line 22
    :cond_0
    iget-object v1, p0, Landroid/view/inputmethod/EditorInfo;->privateImeOptions:Ljava/lang/String;

    if-eqz v1, :cond_1

    iget-object v1, p0, Landroid/view/inputmethod/EditorInfo;->privateImeOptions:Ljava/lang/String;

    .line 23
    const-string v2, "disableAutoPaste"

    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_1

    const/4 v0, 0x1

    goto :goto_0

    :cond_1
    nop

    .line 24
    :goto_0
    new-instance v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderEditorContext;

    iget v2, p0, Landroid/view/inputmethod/EditorInfo;->inputType:I

    iget v3, p0, Landroid/view/inputmethod/EditorInfo;->imeOptions:I

    iget-object p0, p0, Landroid/view/inputmethod/EditorInfo;->packageName:Ljava/lang/String;

    invoke-direct {v1, v2, v3, p0, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderEditorContext;-><init>(IILjava/lang/String;Z)V

    return-object v1
.end method


# virtual methods
.method public getImeOptions()I
    .locals 1

    .line 29
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderEditorContext;->imeOptions:I

    return v0
.end method

.method public getInputType()I
    .locals 1

    .line 28
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderEditorContext;->inputType:I

    return v0
.end method

.method public getPackageName()Ljava/lang/String;
    .locals 1

    .line 30
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderEditorContext;->packageName:Ljava/lang/String;

    return-object v0
.end method

.method public isAutoPasteDisabled()Z
    .locals 1

    .line 31
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderEditorContext;->disableAutoPaste:Z

    return v0
.end method
