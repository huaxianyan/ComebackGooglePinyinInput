.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PreviewChangedException;
.super Ljava/io/IOException;
.source "RimeSyncCoordinator.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "PreviewChangedException"
.end annotation


# direct methods
.method constructor <init>()V
    .locals 1

    .line 406
    const-string v0, "Rime synchronization preview changed"

    invoke-direct {p0, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    .line 407
    return-void
.end method
