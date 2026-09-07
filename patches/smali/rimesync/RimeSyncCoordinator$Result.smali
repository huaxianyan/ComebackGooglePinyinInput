.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;
.super Ljava/lang/Object;
.source "RimeSyncCoordinator.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Result"
.end annotation


# instance fields
.field public final generation:J

.field public final googleAdditionCount:I

.field public final googleDeletionCount:I

.field public final recovered:Z

.field public final rimeAdditionCount:I

.field public final rimeDeletionCount:I

.field public final rimeResurrectionCount:I


# direct methods
.method constructor <init>(JIIIIIZ)V
    .locals 0

    .line 430
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 431
    iput-wide p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;->generation:J

    .line 432
    iput p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;->googleAdditionCount:I

    .line 433
    iput p4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;->googleDeletionCount:I

    .line 434
    iput p5, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;->rimeAdditionCount:I

    .line 435
    iput p6, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;->rimeDeletionCount:I

    .line 436
    iput p7, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;->rimeResurrectionCount:I

    .line 437
    iput-boolean p8, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Result;->recovered:Z

    .line 438
    return-void
.end method
