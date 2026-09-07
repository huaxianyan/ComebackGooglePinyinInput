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

.field final synthetic val$count:I

.field final synthetic val$hashes:[B

.field final synthetic val$histories:[B

.field final synthetic val$historyValues:[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

.field final synthetic val$projectionValues:[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

.field final synthetic val$projections:[B

.field final synthetic val$rimeAbsCounts:[I

.field final synthetic val$salt:[B

.field final synthetic val$unknown:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;[BI[BLcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;[B[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;[B[I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 223
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->val$hashes:[B

    iput p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->val$count:I

    iput-object p4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->val$salt:[B

    iput-object p5, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->val$unknown:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;

    iput-object p6, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->val$historyValues:[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    iput-object p7, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->val$histories:[B

    iput-object p8, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->val$projectionValues:[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    iput-object p9, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->val$projections:[B

    iput-object p10, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->val$rimeAbsCounts:[I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public get(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;
    .locals 4

    .line 225
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->val$hashes:[B

    iget v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->val$count:I

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->val$salt:[B

    invoke-static {v2, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->access$100([BLjava/lang/String;)[B

    move-result-object p1

    invoke-static {v0, v1, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;->access$200([BI[B)I

    move-result p1

    .line 226
    if-gez p1, :cond_0

    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->val$unknown:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;

    goto :goto_0

    :cond_0
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->val$historyValues:[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->val$histories:[B

    aget-byte v2, v2, p1

    aget-object v1, v1, v2

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->val$projectionValues:[Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->val$projections:[B

    aget-byte v3, v3, p1

    aget-object v2, v2, v3

    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$1;->val$rimeAbsCounts:[I

    aget p1, v3, p1

    invoke-direct {v0, v1, v2, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V

    move-object p1, v0

    :goto_0
    return-object p1
.end method
