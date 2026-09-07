.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PersistenceStalledException;
.super Ljava/io/IOException;
.source "RimeSyncCoordinator.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "PersistenceStalledException"
.end annotation


# instance fields
.field public final missingCount:I


# direct methods
.method constructor <init>(I)V
    .locals 1

    .line 421
    const-string v0, "Google user dictionary persistence did not converge"

    invoke-direct {p0, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    .line 422
    iput p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$PersistenceStalledException;->missingCount:I

    .line 423
    return-void
.end method
