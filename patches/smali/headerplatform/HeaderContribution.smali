.class public final Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;
.super Ljava/lang/Object;
.source "HeaderContribution.java"


# instance fields
.field private final allowsActions:Z

.field private final headerToken:J

.field private final moduleId:Ljava/lang/String;

.field private final payload:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererPayload;

.field private final placement:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

.field private final presentationKind:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

.field private final priority:I

.field private final sessionToken:J

.field private final stableId:Ljava/lang/String;


# direct methods
.method public constructor <init>(Ljava/lang/String;Ljava/lang/String;JJILcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;ZLcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererPayload;)V
    .locals 3

    .line 18
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 19
    if-eqz p1, :cond_7

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    if-eqz v0, :cond_7

    .line 22
    if-eqz p2, :cond_6

    invoke-virtual {p2}, Ljava/lang/String;->length()I

    move-result v0

    if-eqz v0, :cond_6

    .line 25
    const-wide/16 v0, 0x0

    cmp-long v2, p3, v0

    if-lez v2, :cond_5

    cmp-long v2, p5, v0

    if-lez v2, :cond_5

    .line 28
    if-eqz p8, :cond_4

    if-eqz p9, :cond_4

    if-eqz p11, :cond_4

    .line 31
    sget-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;->NATIVE_ACTION:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    if-ne p8, v0, :cond_1

    sget-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->LEADING_ACTION:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    if-eq p9, v0, :cond_1

    sget-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->TRAILING_ACTION:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    if-eq p9, v0, :cond_1

    sget-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->PERSISTENT_ACTION:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    if-ne p9, v0, :cond_0

    goto :goto_0

    .line 35
    :cond_0
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "native actions require action placement"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 37
    :cond_1
    :goto_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;->NATIVE_ACTION:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    if-eq p8, v0, :cond_3

    sget-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->CENTER_CONTENT:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    if-eq p9, v0, :cond_3

    sget-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->EXCLUSIVE_CONTENT:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    if-ne p9, v0, :cond_2

    goto :goto_1

    .line 40
    :cond_2
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "content renderers require content placement"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 42
    :cond_3
    :goto_1
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->moduleId:Ljava/lang/String;

    .line 43
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->stableId:Ljava/lang/String;

    .line 44
    iput-wide p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->sessionToken:J

    .line 45
    iput-wide p5, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->headerToken:J

    .line 46
    iput p7, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->priority:I

    .line 47
    iput-object p8, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->presentationKind:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    .line 48
    iput-object p9, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->placement:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    .line 49
    iput-boolean p10, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->allowsActions:Z

    .line 50
    iput-object p11, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->payload:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererPayload;

    .line 51
    return-void

    .line 29
    :cond_4
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "presentation metadata must not be null"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 26
    :cond_5
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "session and Header tokens must be positive"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 23
    :cond_6
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "stableId must not be empty"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1

    .line 20
    :cond_7
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "moduleId must not be empty"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method


# virtual methods
.method public allowsActions()Z
    .locals 1

    .line 60
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->allowsActions:Z

    return v0
.end method

.method public getHeaderToken()J
    .locals 2

    .line 56
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->headerToken:J

    return-wide v0
.end method

.method public getModuleId()Ljava/lang/String;
    .locals 1

    .line 53
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->moduleId:Ljava/lang/String;

    return-object v0
.end method

.method public getPayload()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererPayload;
    .locals 1

    .line 61
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->payload:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererPayload;

    return-object v0
.end method

.method public getPlacement()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;
    .locals 1

    .line 59
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->placement:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    return-object v0
.end method

.method public getPresentationKind()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;
    .locals 1

    .line 58
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->presentationKind:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    return-object v0
.end method

.method public getPriority()I
    .locals 1

    .line 57
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->priority:I

    return v0
.end method

.method public getSessionToken()J
    .locals 2

    .line 55
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->sessionToken:J

    return-wide v0
.end method

.method public getStableId()Ljava/lang/String;
    .locals 1

    .line 54
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->stableId:Ljava/lang/String;

    return-object v0
.end method
