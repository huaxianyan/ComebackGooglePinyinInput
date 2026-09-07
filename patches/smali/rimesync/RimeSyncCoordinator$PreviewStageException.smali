.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewStageException;
.super Ljava/io/IOException;
.source "RimeSyncCoordinator.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "PreviewStageException"
.end annotation


# instance fields
.field public final stage:I


# direct methods
.method public constructor <init>(ILjava/io/IOException;)V
    .locals 1

    .line 412
    const-string v0, "Rime synchronization preview failed"

    invoke-direct {p0, v0, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 413
    iput p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewStageException;->stage:I

    .line 414
    return-void
.end method
