.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Baseline;
.super Ljava/lang/Object;
.source "RimeSyncStateStore.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;
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
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V
    .locals 0

    .line 681
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 682
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Baseline;->history:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    .line 683
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Baseline;->googleProjection:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    .line 684
    iput p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Baseline;->rimeAbsCount:I

    .line 685
    return-void
.end method
