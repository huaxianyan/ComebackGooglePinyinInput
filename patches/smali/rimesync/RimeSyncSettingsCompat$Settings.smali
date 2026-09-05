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
.field public final automatic:Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;

.field public final canEnableAutomatic:Z

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
.method constructor <init>(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZJIZIIIZI)V
    .locals 2

    .line 511
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 512
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->automatic:Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;

    .line 513
    if-eqz p6, :cond_0

    const-wide/16 v0, 0x0

    cmp-long p1, p7, v0

    if-lez p1, :cond_0

    if-nez p9, :cond_0

    const/4 p1, 0x1

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    :goto_0
    iput-boolean p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->canEnableAutomatic:Z

    .line 515
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->rootUri:Ljava/lang/String;

    .line 516
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->rootLabel:Ljava/lang/String;

    .line 517
    iput-object p4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->deviceDirectory:Ljava/lang/String;

    .line 518
    iput-object p5, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->snapshotFile:Ljava/lang/String;

    .line 519
    iput-boolean p6, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->locationAccessible:Z

    .line 520
    iput-wide p7, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->lastSuccess:J

    .line 521
    iput p9, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->phase:I

    .line 522
    iput-boolean p10, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->operationInProgress:Z

    .line 523
    iput p11, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->nativeExpectedCount:I

    .line 524
    iput p12, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->nativeActualCount:I

    .line 525
    move p1, p13

    iput p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->nativeMissingCount:I

    .line 526
    move/from16 p1, p14

    iput-boolean p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->nativeFailureRepeated:Z

    .line 527
    move/from16 p1, p15

    iput p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->nativeFailureKind:I

    .line 528
    return-void
.end method
