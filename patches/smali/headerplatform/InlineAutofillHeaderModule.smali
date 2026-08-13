.class public final Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;
.super Ljava/lang/Object;
.source "InlineAutofillHeaderModule.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;


# static fields
.field private static final CONTRIBUTION_ID:Ljava/lang/String; = "suggestions"

.field public static final MODULE_ID:Ljava/lang/String; = "inline-autofill"

.field private static final PRIORITY:I = 0xc8


# instance fields
.field private headerToken:J

.field private payload:Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;

.field private platform:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;

.field private sessionToken:J


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 9
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private publishIfReady()Z
    .locals 14

    .line 119
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->payload:Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;

    const-string v1, "HeaderPlatformAudit"

    if-eqz v0, :cond_1

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->isAvailable()Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 124
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->platform:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;

    new-instance v2, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    iget-wide v5, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->sessionToken:J

    iget-wide v7, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->headerToken:J

    sget-object v10, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;->REMOTE_SURFACE:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    sget-object v11, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->CENTER_CONTENT:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    const/4 v12, 0x0

    iget-object v13, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->payload:Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;

    const-string v3, "inline-autofill"

    const-string v4, "suggestions"

    const/16 v9, 0xc8

    invoke-direct/range {v2 .. v13}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;-><init>(Ljava/lang/String;Ljava/lang/String;JJILcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;ZLcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererPayload;)V

    invoke-interface {v0, v2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;->publish(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;)Z

    move-result v0

    .line 128
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "module contribution accepted="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 129
    return v0

    .line 120
    :cond_1
    :goto_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "module publish not ready payload="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->payload:Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;

    const/4 v3, 0x1

    const/4 v4, 0x0

    if-eqz v2, :cond_2

    const/4 v2, 0x1

    goto :goto_1

    :cond_2
    const/4 v2, 0x0

    :goto_1
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, " session="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    .line 121
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->isSessionAvailable()Z

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, " header="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-wide v5, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->headerToken:J

    const-wide/16 v7, 0x0

    cmp-long v2, v5, v7

    if-lez v2, :cond_3

    goto :goto_2

    :cond_3
    const/4 v3, 0x0

    :goto_2
    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 120
    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 122
    return v4
.end method

.method private withdraw()V
    .locals 2

    .line 133
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->platform:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->platform:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;

    const-string v1, "inline-autofill"

    invoke-interface {v0, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;->withdrawModule(Ljava/lang/String;)V

    .line 134
    :cond_0
    return-void
.end method


# virtual methods
.method public clearRemoteViews()V
    .locals 1

    .line 114
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->withdraw()V

    .line 115
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->payload:Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;

    .line 116
    return-void
.end method

.method public getCurrentCandidateTextColor()Ljava/lang/Integer;
    .locals 1

    .line 96
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->platform:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;

    if-nez v0, :cond_0

    const/4 v0, 0x0

    goto :goto_0

    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->platform:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;

    invoke-interface {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;->getCurrentCandidateTextColor()Ljava/lang/Integer;

    move-result-object v0

    :goto_0
    return-object v0
.end method

.method public getDefaultPriority()I
    .locals 1

    .line 20
    const/16 v0, 0xc8

    return v0
.end method

.method public getHeaderToken()J
    .locals 2

    .line 94
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->headerToken:J

    return-wide v0
.end method

.method public getModuleId()Ljava/lang/String;
    .locals 1

    .line 19
    const-string v0, "inline-autofill"

    return-object v0
.end method

.method public getSessionToken()J
    .locals 2

    .line 93
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->sessionToken:J

    return-wide v0
.end method

.method public isAvailable()Z
    .locals 4

    .line 73
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->sessionToken:J

    iget-wide v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->headerToken:J

    invoke-virtual {p0, v0, v1, v2, v3}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->isAvailableFor(JJ)Z

    move-result v0

    return v0
.end method

.method public isAvailableFor(JJ)Z
    .locals 1

    .line 87
    invoke-virtual {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->isSessionAvailableFor(J)Z

    move-result p1

    if-eqz p1, :cond_0

    const-wide/16 p1, 0x0

    cmp-long v0, p3, p1

    if-lez v0, :cond_0

    iget-wide p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->headerToken:J

    cmp-long v0, p1, p3

    if-nez v0, :cond_0

    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->platform:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;

    .line 90
    invoke-interface {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;->getCurrentHeaderToken()J

    move-result-wide p1

    cmp-long v0, p1, p3

    if-nez v0, :cond_0

    const/4 p1, 0x1

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    .line 87
    :goto_0
    return p1
.end method

.method public isSessionAvailable()Z
    .locals 2

    .line 77
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->sessionToken:J

    invoke-virtual {p0, v0, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->isSessionAvailableFor(J)Z

    move-result v0

    return v0
.end method

.method public isSessionAvailableFor(J)Z
    .locals 3

    .line 81
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->platform:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;

    if-eqz v0, :cond_0

    const-wide/16 v0, 0x0

    cmp-long v2, p1, v0

    if-lez v2, :cond_0

    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->sessionToken:J

    cmp-long v2, v0, p1

    if-nez v2, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->platform:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;

    .line 83
    invoke-interface {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;->getCurrentSessionToken()J

    move-result-wide v0

    cmp-long v2, v0, p1

    if-nez v2, :cond_0

    const/4 p1, 0x1

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    .line 81
    :goto_0
    return p1
.end method

.method public onAttach(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;)V
    .locals 1

    .line 24
    if-eqz p1, :cond_0

    .line 25
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->platform:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;

    .line 26
    return-void

    .line 24
    :cond_0
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string v0, "platform must not be null"

    invoke-direct {p1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method public onDetach()V
    .locals 3

    .line 65
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->withdraw()V

    .line 66
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->payload:Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;

    .line 67
    const-wide/16 v1, 0x0

    iput-wide v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->sessionToken:J

    .line 68
    iput-wide v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->headerToken:J

    .line 69
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->platform:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;

    .line 70
    return-void
.end method

.method public onFinishInput(J)V
    .locals 3

    .line 56
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->sessionToken:J

    cmp-long v2, v0, p1

    if-nez v2, :cond_0

    .line 57
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->withdraw()V

    .line 58
    const/4 p1, 0x0

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->payload:Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;

    .line 59
    const-wide/16 p1, 0x0

    iput-wide p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->sessionToken:J

    .line 61
    :cond_0
    return-void
.end method

.method public onHeaderAvailable(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderHandle;)V
    .locals 2

    .line 37
    if-nez p1, :cond_0

    const-wide/16 v0, 0x0

    goto :goto_0

    :cond_0
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderHandle;->getToken()J

    move-result-wide v0

    :goto_0
    iput-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->headerToken:J

    .line 38
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "module header available token="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->headerToken:J

    invoke-virtual {p1, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, " payload="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->payload:Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;

    if-eqz v0, :cond_1

    const/4 v0, 0x1

    goto :goto_1

    :cond_1
    const/4 v0, 0x0

    :goto_1
    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "HeaderPlatformAudit"

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 40
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->publishIfReady()Z

    .line 41
    return-void
.end method

.method public onHeaderUnavailable(J)V
    .locals 3

    .line 45
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->headerToken:J

    cmp-long v2, v0, p1

    if-nez v2, :cond_0

    .line 46
    const-wide/16 p1, 0x0

    iput-wide p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->headerToken:J

    .line 47
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->withdraw()V

    .line 49
    :cond_0
    return-void
.end method

.method public onNativeCandidateStateChanged(Z)V
    .locals 0

    .line 51
    return-void
.end method

.method public onStartInput(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderEditorContext;J)V
    .locals 0

    .line 30
    iput-wide p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->sessionToken:J

    .line 31
    const/4 p1, 0x0

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->payload:Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;

    .line 32
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->withdraw()V

    .line 33
    return-void
.end method

.method public onThemeChanged(J)V
    .locals 0

    .line 52
    return-void
.end method

.method public setRemoteViews(Ljava/util/List;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;Ljava/lang/Integer;)Z
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
            ")Z"
        }
    .end annotation

    .line 102
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->isSessionAvailable()Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 103
    :cond_0
    if-eqz p1, :cond_2

    invoke-interface {p1}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_1

    goto :goto_0

    .line 107
    :cond_1
    new-instance v0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;

    invoke-direct {v0, p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;-><init>(Ljava/util/List;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRemoteSurfaceClipper;Ljava/lang/Integer;)V

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->payload:Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemotePayload;

    .line 109
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->publishIfReady()Z

    .line 110
    const/4 p1, 0x1

    return p1

    .line 104
    :cond_2
    :goto_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillHeaderModule;->clearRemoteViews()V

    .line 105
    return v1
.end method
