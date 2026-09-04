.class public final enum Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;
.super Ljava/lang/Enum;
.source "RimeSyncPlanner.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4019
    name = "RimeState"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

.field public static final enum ABSENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

.field public static final enum PRESENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

.field public static final enum TOMBSTONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;


# direct methods
.method private static synthetic $values()[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;
    .locals 3

    .line 11
    const/4 v0, 0x3

    new-array v0, v0, [Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->ABSENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    const/4 v2, 0x0

    aput-object v1, v0, v2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->PRESENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    const/4 v2, 0x1

    aput-object v1, v0, v2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->TOMBSTONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    const/4 v2, 0x2

    aput-object v1, v0, v2

    return-object v0
.end method

.method static constructor <clinit>()V
    .locals 3

    .line 12
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    const-string v1, "ABSENT"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->ABSENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    .line 13
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    const-string v1, "PRESENT"

    const/4 v2, 0x1

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->PRESENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    .line 14
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    const-string v1, "TOMBSTONE"

    const/4 v2, 0x2

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->TOMBSTONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    .line 11
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->$values()[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->$VALUES:[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 11
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;
    .locals 1

    .line 11
    const-class v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    return-object p0
.end method

.method public static values()[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;
    .locals 1

    .line 11
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->$VALUES:[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    invoke-virtual {v0}, [Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    return-object v0
.end method
