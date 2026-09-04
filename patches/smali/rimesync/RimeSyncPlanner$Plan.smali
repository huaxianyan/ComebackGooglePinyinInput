.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;
.super Ljava/lang/Object;
.source "RimeSyncPlanner.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Plan"
.end annotation


# instance fields
.field public final googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

.field public final nextGoogleProjection:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

.field public final nextHistory:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

.field public final rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

.field public final rimeCommitValue:I


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V
    .locals 0

    .line 44
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 45
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    .line 46
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    .line 47
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->nextHistory:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    .line 48
    iput-object p4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->nextGoogleProjection:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    .line 49
    iput p5, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->rimeCommitValue:I

    .line 50
    return-void
.end method
