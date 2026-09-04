.class Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;
.super Ljava/lang/Object;
.source "RimeSyncStateStore.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$BaselineLookup;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->baselineLookup()Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$BaselineLookup;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

.field final synthetic val$baselines:Ljava/util/Map;

.field final synthetic val$salt:[B


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;Ljava/util/Map;[B)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 191
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->val$baselines:Ljava/util/Map;

    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->val$salt:[B

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public get(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;
    .locals 3

    .line 193
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->val$baselines:Ljava/util/Map;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->val$salt:[B

    .line 194
    invoke-static {v1, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->access$100([BLjava/lang/String;)[B

    move-result-object p1

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->access$200([B)Ljava/lang/String;

    move-result-object p1

    invoke-interface {v0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;

    .line 195
    if-nez p1, :cond_0

    .line 196
    new-instance p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;

    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->UNKNOWN:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->SUPPORTED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    const/4 v2, 0x0

    invoke-direct {p1, v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V

    goto :goto_0

    .line 199
    :cond_0
    nop

    .line 195
    :goto_0
    return-object p1
.end method
