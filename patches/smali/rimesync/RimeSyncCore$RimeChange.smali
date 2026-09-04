.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;
.super Ljava/lang/Object;
.source "RimeSyncCore.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "RimeChange"
.end annotation


# instance fields
.field public final action:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

.field public final code:Ljava/lang/String;

.field public final commitValue:I

.field public final phrase:Ljava/lang/String;


# direct methods
.method public constructor <init>(Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;I)V
    .locals 0

    .line 189
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 190
    if-eqz p1, :cond_0

    if-eqz p2, :cond_0

    if-eqz p3, :cond_0

    .line 193
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;->code:Ljava/lang/String;

    .line 194
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;->phrase:Ljava/lang/String;

    .line 195
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;->action:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    .line 196
    iput p4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;->commitValue:I

    .line 197
    return-void

    .line 191
    :cond_0
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "Rime change is invalid"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method
