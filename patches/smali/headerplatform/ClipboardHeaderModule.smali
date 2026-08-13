.class public final Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;
.super Ljava/lang/Object;
.source "ClipboardHeaderModule.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;
.implements Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeCandidateStateAware;


# static fields
.field private static final CONTRIBUTION_ID:Ljava/lang/String; = "native-candidate"

.field public static final MODULE_ID:Ljava/lang/String; = "clipboard"

.field private static final PAYLOAD:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererPayload;

.field private static final PRIORITY:I = 0x64


# instance fields
.field private headerToken:J

.field private platform:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;

.field private sessionToken:J


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 9
    new-instance v0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule$1;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule$1;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->PAYLOAD:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererPayload;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 4
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private publish()V
    .locals 13

    .line 67
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->platform:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;

    if-eqz v0, :cond_1

    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->sessionToken:J

    const-wide/16 v2, 0x0

    cmp-long v4, v0, v2

    if-lez v4, :cond_1

    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->headerToken:J

    cmp-long v4, v0, v2

    if-lez v4, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->platform:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;

    .line 68
    invoke-interface {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;->getCurrentSessionToken()J

    move-result-wide v0

    iget-wide v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->sessionToken:J

    cmp-long v4, v0, v2

    if-nez v4, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->platform:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;

    .line 69
    invoke-interface {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;->getCurrentHeaderToken()J

    move-result-wide v0

    iget-wide v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->headerToken:J

    cmp-long v4, v0, v2

    if-eqz v4, :cond_0

    goto :goto_0

    .line 70
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->platform:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    iget-wide v4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->sessionToken:J

    iget-wide v6, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->headerToken:J

    sget-object v9, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;->NATIVE_CANDIDATE:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    sget-object v10, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->CENTER_CONTENT:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    const/4 v11, 0x0

    sget-object v12, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->PAYLOAD:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererPayload;

    const-string v2, "clipboard"

    const-string v3, "native-candidate"

    const/16 v8, 0x64

    invoke-direct/range {v1 .. v12}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;-><init>(Ljava/lang/String;Ljava/lang/String;JJILcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;ZLcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererPayload;)V

    invoke-interface {v0, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;->publish(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;)Z

    .line 74
    return-void

    .line 69
    :cond_1
    :goto_0
    return-void
.end method

.method private withdraw()V
    .locals 2

    .line 77
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->platform:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->platform:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;

    const-string v1, "clipboard"

    invoke-interface {v0, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;->withdrawModule(Ljava/lang/String;)V

    .line 78
    :cond_0
    return-void
.end method


# virtual methods
.method public getDefaultPriority()I
    .locals 1

    .line 16
    const/16 v0, 0x64

    return v0
.end method

.method public getModuleId()Ljava/lang/String;
    .locals 1

    .line 15
    const-string v0, "clipboard"

    return-object v0
.end method

.method public onAttach(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;)V
    .locals 0

    .line 17
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->platform:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;

    return-void
.end method

.method public onDetach()V
    .locals 2

    .line 60
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->withdraw()V

    .line 61
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->platform:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;

    .line 62
    const-wide/16 v0, 0x0

    iput-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->sessionToken:J

    .line 63
    iput-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->headerToken:J

    .line 64
    return-void
.end method

.method public onFinishInput(J)V
    .locals 3

    .line 52
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->sessionToken:J

    cmp-long v2, v0, p1

    if-nez v2, :cond_0

    .line 53
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->withdraw()V

    .line 54
    const-wide/16 p1, 0x0

    iput-wide p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->sessionToken:J

    .line 56
    :cond_0
    return-void
.end method

.method public onHeaderAvailable(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderHandle;)V
    .locals 2

    .line 27
    if-nez p1, :cond_0

    const-wide/16 v0, 0x0

    goto :goto_0

    :cond_0
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderHandle;->getToken()J

    move-result-wide v0

    :goto_0
    iput-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->headerToken:J

    .line 28
    return-void
.end method

.method public onHeaderUnavailable(J)V
    .locals 3

    .line 32
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->headerToken:J

    cmp-long v2, v0, p1

    if-nez v2, :cond_0

    .line 33
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->withdraw()V

    .line 34
    const-wide/16 p1, 0x0

    iput-wide p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->headerToken:J

    .line 36
    :cond_0
    return-void
.end method

.method public onNativeCandidateStateChanged(Z)V
    .locals 1

    .line 40
    const/4 v0, 0x0

    invoke-virtual {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->onNativeCandidateStateChanged(ZZ)V

    .line 41
    return-void
.end method

.method public onNativeCandidateStateChanged(ZZ)V
    .locals 0

    .line 44
    if-eqz p1, :cond_0

    if-eqz p2, :cond_0

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->publish()V

    goto :goto_0

    .line 45
    :cond_0
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->withdraw()V

    .line 46
    :goto_0
    return-void
.end method

.method public onStartInput(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderEditorContext;J)V
    .locals 0

    .line 21
    iput-wide p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->sessionToken:J

    .line 22
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/ClipboardHeaderModule;->withdraw()V

    .line 23
    return-void
.end method

.method public onThemeChanged(J)V
    .locals 0

    .line 48
    return-void
.end method
