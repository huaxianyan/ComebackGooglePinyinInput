.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;
.super Ljava/lang/Object;
.source "RimeSyncStateStore.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "PendingOperation"
.end annotation


# instance fields
.field public final code:Ljava/lang/String;

.field public final googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

.field public final phrase:Ljava/lang/String;

.field public final rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

.field public final rimeCommitValue:I


# direct methods
.method public constructor <init>(Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;I)V
    .locals 0

    .line 646
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 647
    if-eqz p1, :cond_0

    if-eqz p2, :cond_0

    if-eqz p3, :cond_0

    if-eqz p4, :cond_0

    .line 650
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->code:Ljava/lang/String;

    .line 651
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->phrase:Ljava/lang/String;

    .line 652
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    .line 653
    iput-object p4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    .line 654
    iput p5, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$PendingOperation;->rimeCommitValue:I

    .line 655
    return-void

    .line 648
    :cond_0
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "pending operation is invalid"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method
