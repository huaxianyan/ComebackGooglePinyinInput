.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$BaselineCounts;
.super Ljava/lang/Object;
.source "RimeSyncStateStore.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "BaselineCounts"
.end annotation


# instance fields
.field public final rimeOnly:I

.field public final shared:I


# direct methods
.method constructor <init>(II)V
    .locals 0

    .line 161
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 162
    iput p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$BaselineCounts;->shared:I

    iput p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$BaselineCounts;->rimeOnly:I

    .line 163
    return-void
.end method
