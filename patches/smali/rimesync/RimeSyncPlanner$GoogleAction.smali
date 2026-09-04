.class public final enum Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;
.super Ljava/lang/Enum;
.source "RimeSyncPlanner.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4019
    name = "GoogleAction"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

.field public static final enum ADD:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

.field public static final enum DELETE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

.field public static final enum NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;


# direct methods
.method private static synthetic $values()[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;
    .locals 3

    .line 22
    const/4 v0, 0x3

    new-array v0, v0, [Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    const/4 v2, 0x0

    aput-object v1, v0, v2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->ADD:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    const/4 v2, 0x1

    aput-object v1, v0, v2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->DELETE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    const/4 v2, 0x2

    aput-object v1, v0, v2

    return-object v0
.end method

.method static constructor <clinit>()V
    .locals 3

    .line 23
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    const-string v1, "NONE"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    .line 24
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    const-string v1, "ADD"

    const/4 v2, 0x1

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->ADD:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    .line 25
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    const-string v1, "DELETE"

    const/4 v2, 0x2

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->DELETE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    .line 22
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->$values()[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->$VALUES:[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 22
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;
    .locals 1

    .line 22
    const-class v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    return-object p0
.end method

.method public static values()[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;
    .locals 1

    .line 22
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->$VALUES:[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    invoke-virtual {v0}, [Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    return-object v0
.end method
