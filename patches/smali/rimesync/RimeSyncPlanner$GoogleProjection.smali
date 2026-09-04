.class public final enum Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;
.super Ljava/lang/Enum;
.source "RimeSyncPlanner.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4019
    name = "GoogleProjection"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

.field public static final enum RIME_ONLY:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

.field public static final enum SUPPORTED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;


# direct methods
.method private static synthetic $values()[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;
    .locals 3

    .line 17
    const/4 v0, 0x2

    new-array v0, v0, [Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->SUPPORTED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    const/4 v2, 0x0

    aput-object v1, v0, v2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->RIME_ONLY:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    const/4 v2, 0x1

    aput-object v1, v0, v2

    return-object v0
.end method

.method static constructor <clinit>()V
    .locals 3

    .line 18
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    const-string v1, "SUPPORTED"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->SUPPORTED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    .line 19
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    const-string v1, "RIME_ONLY"

    const/4 v2, 0x1

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->RIME_ONLY:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    .line 17
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->$values()[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->$VALUES:[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 17
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;
    .locals 1

    .line 17
    const-class v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    return-object p0
.end method

.method public static values()[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;
    .locals 1

    .line 17
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->$VALUES:[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    invoke-virtual {v0}, [Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    return-object v0
.end method
