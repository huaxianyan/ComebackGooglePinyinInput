.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;
.super Ljava/lang/Object;
.source "RimeAutoSync.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Settings"
.end annotation


# instance fields
.field public final enabled:Z

.field public final intervalHours:I

.field public final lastError:I

.field public final maxHours:I

.field public final minHours:I


# direct methods
.method constructor <init>(ZII)V
    .locals 1

    .line 31
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 27
    const/4 v0, 0x6

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->minHours:I

    .line 28
    const/16 v0, 0xa8

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->maxHours:I

    .line 32
    iput-boolean p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->enabled:Z

    .line 33
    iput p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->intervalHours:I

    .line 34
    iput p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->lastError:I

    .line 35
    return-void
.end method
