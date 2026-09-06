.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;
.super Ljava/lang/Object;
.source "RimeSyncSettingsCompat.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Result"
.end annotation


# instance fields
.field public final confirmationToken:Ljava/lang/String;

.field public final errorCode:I

.field public final googleAdditionCount:I

.field public final googleDeletionCount:I

.field public final preview:Z

.field public final projectedGoogleEntryCount:I

.field public final requiresDeletionConfirmation:Z

.field public final rimeAdditionCount:I

.field public final rimeDeletionCount:I

.field public final rimeResurrectionCount:I

.field public final settings:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

.field public final success:Z


# direct methods
.method private constructor <init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;ZIZLjava/lang/String;IIIIIIZ)V
    .locals 0

    .line 572
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 573
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->settings:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    .line 574
    iput-boolean p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->success:Z

    .line 575
    iput p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->errorCode:I

    .line 576
    iput-boolean p4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->preview:Z

    .line 577
    iput-object p5, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->confirmationToken:Ljava/lang/String;

    .line 578
    iput p6, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->googleAdditionCount:I

    .line 579
    iput p7, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->googleDeletionCount:I

    .line 580
    iput p8, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->rimeAdditionCount:I

    .line 581
    iput p9, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->rimeDeletionCount:I

    .line 582
    iput p10, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->rimeResurrectionCount:I

    .line 583
    iput p11, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->projectedGoogleEntryCount:I

    .line 584
    iput-boolean p12, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->requiresDeletionConfirmation:Z

    .line 585
    return-void
.end method

.method static completed(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;
    .locals 13

    .line 606
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    iget v6, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;->googleAdditionCount:I

    iget v7, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;->googleDeletionCount:I

    iget v8, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;->rimeAdditionCount:I

    iget v9, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;->rimeDeletionCount:I

    iget v10, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;->rimeResurrectionCount:I

    const/4 v11, 0x0

    const/4 v12, 0x0

    const/4 v2, 0x1

    const/4 v3, 0x0

    const/4 v4, 0x0

    const-string v5, ""

    move-object v1, p0

    invoke-direct/range {v0 .. v12}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;ZIZLjava/lang/String;IIIIIIZ)V

    return-object v0
.end method

.method static error(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;
    .locals 13

    .line 593
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    const/4 v11, 0x0

    const/4 v12, 0x0

    const/4 v2, 0x0

    const/4 v4, 0x0

    const-string v5, ""

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    const/4 v9, 0x0

    const/4 v10, 0x0

    move-object v1, p0

    move v3, p1

    invoke-direct/range {v0 .. v12}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;ZIZLjava/lang/String;IIIIIIZ)V

    return-object v0
.end method

.method static preview(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;
    .locals 13

    .line 598
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    iget-object v5, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->confirmationToken:Ljava/lang/String;

    iget v6, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->googleAdditionCount:I

    iget v7, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->googleDeletionCount:I

    iget v8, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->rimeAdditionCount:I

    iget v9, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->rimeDeletionCount:I

    iget v10, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->rimeResurrectionCount:I

    iget v11, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->projectedGoogleEntryCount:I

    iget-boolean v12, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->requiresDeletionConfirmation:Z

    const/4 v2, 0x1

    const/4 v3, 0x0

    const/4 v4, 0x1

    move-object v1, p0

    invoke-direct/range {v0 .. v12}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;ZIZLjava/lang/String;IIIIIIZ)V

    return-object v0
.end method

.method static success(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;
    .locals 13

    .line 588
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    const/4 v11, 0x0

    const/4 v12, 0x0

    const/4 v2, 0x1

    const/4 v3, 0x0

    const/4 v4, 0x0

    const-string v5, ""

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    const/4 v9, 0x0

    const/4 v10, 0x0

    move-object v1, p0

    invoke-direct/range {v0 .. v12}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;ZIZLjava/lang/String;IIIIIIZ)V

    return-object v0
.end method


# virtual methods
.method withSettings(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;
    .locals 13

    .line 613
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    iget-boolean v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->success:Z

    iget v3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->errorCode:I

    iget-boolean v4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->preview:Z

    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->confirmationToken:Ljava/lang/String;

    iget v6, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->googleAdditionCount:I

    iget v7, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->googleDeletionCount:I

    iget v8, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->rimeAdditionCount:I

    iget v9, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->rimeDeletionCount:I

    iget v10, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->rimeResurrectionCount:I

    iget v11, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->projectedGoogleEntryCount:I

    iget-boolean v12, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->requiresDeletionConfirmation:Z

    move-object v1, p1

    invoke-direct/range {v0 .. v12}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;ZIZLjava/lang/String;IIIIIIZ)V

    return-object v0
.end method
