.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncPolicy;
.super Ljava/lang/Object;
.source "RimeAutoSyncPolicy.java"


# static fields
.field public static final DEFAULT_HOURS:I = 0x18

.field public static final MAX_HOURS:I = 0xa8

.field public static final MIN_HOURS:I = 0x6

.field public static final RETRY_BASE_MILLIS:J = 0x1b7740L


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 10
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static intervalMillis(I)J
    .locals 4

    .line 13
    const/4 v0, 0x6

    if-lt p0, v0, :cond_0

    const/16 v0, 0xa8

    if-gt p0, v0, :cond_0

    .line 16
    int-to-long v0, p0

    const-wide/16 v2, 0x3c

    mul-long v0, v0, v2

    mul-long v0, v0, v2

    const-wide/16 v2, 0x3e8

    mul-long v0, v0, v2

    return-wide v0

    .line 14
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "automatic synchronization interval out of range"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method
