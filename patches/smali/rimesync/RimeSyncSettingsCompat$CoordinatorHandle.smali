.class final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;
.super Ljava/lang/Object;
.source "RimeSyncSettingsCompat.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "CoordinatorHandle"
.end annotation


# instance fields
.field final coordinator:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;

.field final stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;)V
    .locals 0

    .line 504
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 505
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    .line 506
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;->coordinator:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;

    .line 507
    return-void
.end method


# virtual methods
.method close()V
    .locals 1

    .line 510
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$CoordinatorHandle;->stateStore:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->close()V

    .line 511
    return-void
.end method
