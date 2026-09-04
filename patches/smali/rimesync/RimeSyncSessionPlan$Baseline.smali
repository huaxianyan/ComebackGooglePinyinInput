.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;
.super Ljava/lang/Object;
.source "RimeSyncSessionPlan.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Baseline"
.end annotation


# instance fields
.field public final googleProjection:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

.field public final history:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

.field public final rimeAbsCount:I


# direct methods
.method public constructor <init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V
    .locals 0

    .line 182
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 183
    if-eqz p1, :cond_0

    if-eqz p2, :cond_0

    if-ltz p3, :cond_0

    .line 186
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;->history:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    .line 187
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;->googleProjection:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    .line 188
    iput p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;->rimeAbsCount:I

    .line 189
    return-void

    .line 184
    :cond_0
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "synchronization baseline is invalid"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method
