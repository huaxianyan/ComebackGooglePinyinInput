.class final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;
.super Ljava/lang/Object;
.source "RimeSyncCoordinator.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "Session"
.end annotation


# instance fields
.field final plan:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

.field final snapshot:Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;)V
    .locals 0

    .line 347
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 348
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->snapshot:Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    .line 349
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$Session;->plan:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    .line 350
    return-void
.end method
