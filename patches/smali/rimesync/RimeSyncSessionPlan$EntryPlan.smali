.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;
.super Ljava/lang/Object;
.source "RimeSyncSessionPlan.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "EntryPlan"
.end annotation


# instance fields
.field public final code:Ljava/lang/String;

.field public final googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

.field public final key:Ljava/lang/String;

.field public final nextGoogleProjection:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

.field public final nextHistory:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

.field public final nextRimeAbsCount:I

.field public final phrase:Ljava/lang/String;

.field public final rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

.field public final rimeCommitValue:I


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;ILcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V
    .locals 0

    .line 208
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 209
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->key:Ljava/lang/String;

    .line 210
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->code:Ljava/lang/String;

    .line 211
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->phrase:Ljava/lang/String;

    .line 212
    iput-object p4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    .line 213
    iput-object p5, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    .line 214
    iput p6, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->rimeCommitValue:I

    .line 215
    iput-object p7, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->nextHistory:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    .line 216
    iput-object p8, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->nextGoogleProjection:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    .line 217
    iput p9, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->nextRimeAbsCount:I

    .line 218
    return-void
.end method
