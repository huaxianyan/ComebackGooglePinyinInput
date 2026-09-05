.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotReadException;
.super Ljava/io/IOException;
.source "RimeSyncSafStore.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "SnapshotReadException"
.end annotation


# instance fields
.field public final kind:I


# direct methods
.method constructor <init>(ILjava/lang/Throwable;)V
    .locals 1

    .line 386
    const-string v0, "Rime snapshot could not be read"

    invoke-direct {p0, v0, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 387
    iput p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotReadException;->kind:I

    .line 388
    return-void
.end method
