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

    .line 352
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 353
    iget v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->googleAdditionCount:I

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->googleAdditionCount:I

    .line 354
    iget v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->googleDeletionCount:I

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->googleDeletionCount:I

    .line 355
    iget v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->rimeAdditionCount:I

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->rimeAdditionCount:I

    .line 356
    iget v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->rimeDeletionCount:I

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->rimeDeletionCount:I

    .line 357
    iget v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->rimeResurrectionCount:I

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->rimeResurrectionCount:I

    .line 358
    iget v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->projectedGoogleEntryCount:I

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->projectedGoogleEntryCount:I

    .line 359
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->requiresDeletionConfirmation()Z

    move-result v0

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->requiresDeletionConfirmation:Z

    .line 360
    iget-object p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->confirmationToken:Ljava/lang/String;

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Preview;->confirmationToken:Ljava/lang/String;

    .line 361
    return-void
.end method
