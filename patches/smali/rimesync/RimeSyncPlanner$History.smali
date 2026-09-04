.class public final enum Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;
.super Ljava/lang/Enum;
.source "RimeSyncPlanner.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4019
    name = "History"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

.field public static final enum DELETED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

.field public static final enum PRESENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

.field public static final enum UNKNOWN:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;


# direct methods
.method private static synthetic $values()[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;
    .locals 3

    .line 5
    const/4 v0, 0x3

    new-array v0, v0, [Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->UNKNOWN:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    const/4 v2, 0x0

    aput-object v1, v0, v2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->PRESENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    const/4 v2, 0x1

    aput-object v1, v0, v2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->DELETED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    const/4 v2, 0x2

    aput-object v1, v0, v2

    return-object v0
.end method

.method static constructor <clinit>()V
    .locals 3

    .line 6
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    const-string v1, "UNKNOWN"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->UNKNOWN:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    .line 7
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    const-string v1, "PRESENT"

    const/4 v2, 0x1

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->PRESENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    .line 8
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    const-string v1, "DELETED"

    const/4 v2, 0x2

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->DELETED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    .line 5
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->$values()[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->$VALUES:[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 5
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;
    .locals 1

    .line 5
    const-class v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    return-object p0
.end method

.method public static values()[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;
    .locals 1

    .line 5
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->$VALUES:[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    invoke-virtual {v0}, [Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    return-object v0
.end method
