.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$DeletionConfirmationException;
.super Ljava/io/IOException;
.source "RimeSyncCoordinator.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "DeletionConfirmationException"
.end annotation


# instance fields
.field public final googleDeletionCount:I

.field public final rimeDeletionCount:I


# direct methods
.method constructor <init>(II)V
    .locals 1

    .line 470
    const-string v0, "Rime synchronization deletion confirmation is required"

    invoke-direct {p0, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    .line 471
    iput p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$DeletionConfirmationException;->googleDeletionCount:I

    .line 472
    iput p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$DeletionConfirmationException;->rimeDeletionCount:I

    .line 473
    return-void
.end method
