.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;
.super Ljava/lang/Object;
.source "RimeSyncCoordinator.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Preview"
.end annotation


# instance fields
.field public final confirmationToken:Ljava/lang/String;

.field public final googleAdditionCount:I

.field public final googleDeletionCount:I

.field public final projectedGoogleEntryCount:I

.field public final requiresDeletionConfirmation:Z

.field public final rimeAdditionCount:I

.field public final rimeDeletionCount:I

.field public final rimeResurrectionCount:I


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;)V
    .locals 1

    .line 407
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 408
    iget v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->googleAdditionCount:I

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->googleAdditionCount:I

    .line 409
    iget v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->googleDeletionCount:I

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->googleDeletionCount:I

    .line 410
    iget v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->rimeAdditionCount:I

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->rimeAdditionCount:I

    .line 411
    iget v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->rimeDeletionCount:I

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->rimeDeletionCount:I

    .line 412
    iget v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->rimeResurrectionCount:I

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->rimeResurrectionCount:I

    .line 413
    iget v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->projectedGoogleEntryCount:I

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->projectedGoogleEntryCount:I

    .line 414
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->requiresDeletionConfirmation()Z

    move-result v0

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->requiresDeletionConfirmation:Z

    .line 415
    iget-object p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->confirmationToken:Ljava/lang/String;

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->confirmationToken:Ljava/lang/String;

    .line 416
    return-void
.end method
