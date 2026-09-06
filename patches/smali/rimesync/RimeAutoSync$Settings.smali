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

.field public final intervalOptions:[I

.field public final lastError:I


# direct methods
.method constructor <init>(ZII)V
    .locals 0

    .line 30
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 31
    iput-boolean p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->enabled:Z

    .line 32
    iput p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->intervalHours:I

    .line 33
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncPolicy;->intervalOptions(I)[I

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->intervalOptions:[I

    .line 34
    iput p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->lastError:I

    .line 35
    return-void
.end method
