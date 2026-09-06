.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncPolicy;
.super Ljava/lang/Object;
.source "RimeAutoSyncPolicy.java"


# static fields
.field public static final DEFAULT_HOURS:I

.field private static final INTERVAL_HOURS:[I

.field public static final MAX_HOURS:I

.field public static final MIN_HOURS:I

.field public static final RETRY_BASE_MILLIS:J = 0x1b7740L


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 5
    const/4 v0, 0x6

    new-array v0, v0, [I

    fill-array-data v0, :array_0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncPolicy;->INTERVAL_HOURS:[I

    .line 6
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncPolicy;->INTERVAL_HOURS:[I

    const/4 v1, 0x2

    aget v0, v0, v1

    sput v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncPolicy;->DEFAULT_HOURS:I

    .line 7
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncPolicy;->INTERVAL_HOURS:[I

    const/4 v1, 0x0

    aget v0, v0, v1

    sput v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncPolicy;->MIN_HOURS:I

    .line 8
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncPolicy;->INTERVAL_HOURS:[I

    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncPolicy;->INTERVAL_HOURS:[I

    array-length v1, v1

    add-int/lit8 v1, v1, -0x1

    aget v0, v0, v1

    sput v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncPolicy;->MAX_HOURS:I

    return-void

    :array_0
    .array-data 4
        0x6
        0xc
        0x18
        0x30
        0x48
        0xa8
    .end array-data
.end method

.method private constructor <init>()V
    .locals 0

    .line 11
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static intervalMillis(I)J
    .locals 4

    .line 26
    sget v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncPolicy;->MIN_HOURS:I

    if-lt p0, v0, :cond_0

    sget v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncPolicy;->MAX_HOURS:I

    if-gt p0, v0, :cond_0

    .line 29
    int-to-long v0, p0

    const-wide/16 v2, 0x3c

    mul-long v0, v0, v2

    mul-long v0, v0, v2

    const-wide/16 v2, 0x3e8

    mul-long v0, v0, v2

    return-wide v0

    .line 27
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "automatic synchronization interval out of range"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public static intervalOptions(I)[I
    .locals 4

    .line 15
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncPolicy;->intervalMillis(I)J

    .line 16
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncPolicy;->INTERVAL_HOURS:[I

    array-length v1, v0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_1

    aget v3, v0, v2

    .line 17
    if-ne v3, p0, :cond_0

    sget-object p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncPolicy;->INTERVAL_HOURS:[I

    invoke-virtual {p0}, [I->clone()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, [I

    return-object p0

    .line 16
    :cond_0
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 19
    :cond_1
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncPolicy;->INTERVAL_HOURS:[I

    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncPolicy;->INTERVAL_HOURS:[I

    array-length v1, v1

    add-int/lit8 v1, v1, 0x1

    invoke-static {v0, v1}, Ljava/util/Arrays;->copyOf([II)[I

    move-result-object v0

    .line 20
    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncPolicy;->INTERVAL_HOURS:[I

    array-length v1, v1

    aput p0, v0, v1

    .line 21
    invoke-static {v0}, Ljava/util/Arrays;->sort([I)V

    .line 22
    return-object v0
.end method
