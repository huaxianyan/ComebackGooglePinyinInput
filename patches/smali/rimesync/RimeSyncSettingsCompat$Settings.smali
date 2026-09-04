.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;
.super Ljava/lang/Object;
.source "RimeSyncSettingsCompat.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Settings"
.end annotation


# instance fields
.field public final deviceDirectory:Ljava/lang/String;

.field public final lastSuccess:J

.field public final locationAccessible:Z

.field public final nativeActualCount:I

.field public final nativeExpectedCount:I

.field public final nativeFailureKind:I

.field public final nativeFailureRepeated:Z

.field public final nativeMissingCount:I

.field public final operationInProgress:Z

.field public final phase:I

.field public final rootLabel:Ljava/lang/String;

.field public final rootUri:Ljava/lang/String;

.field public final snapshotFile:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZJIZIIIZI)V
    .locals 0

    .line 397
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 398
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->rootUri:Ljava/lang/String;

    .line 399
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->rootLabel:Ljava/lang/String;

    .line 400
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->deviceDirectory:Ljava/lang/String;

    .line 401
    iput-object p4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->snapshotFile:Ljava/lang/String;

    .line 402
    iput-boolean p5, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->locationAccessible:Z

    .line 403
    iput-wide p6, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->lastSuccess:J

    .line 404
    iput p8, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->phase:I

    .line 405
    iput-boolean p9, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->operationInProgress:Z

    .line 406
    iput p10, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->nativeExpectedCount:I

    .line 407
    iput p11, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->nativeActualCount:I

    .line 408
    iput p12, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->nativeMissingCount:I

    .line 409
    iput-boolean p13, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->nativeFailureRepeated:Z

    .line 410
    iput p14, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->nativeFailureKind:I

    .line 411
    return-void
.end method
