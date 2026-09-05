.class Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService$1;
.super Ljava/lang/Object;
.source "RimeAutoSyncJobService.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService;->onStartJob(Landroid/app/job/JobParameters;)Z
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService;

.field final synthetic val$parameters:Landroid/app/job/JobParameters;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService;Landroid/app/job/JobParameters;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 13
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService$1;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService$1;->val$parameters:Landroid/app/job/JobParameters;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onFinished(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V
    .locals 2

    .line 15
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService$1;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService;

    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync;->completed(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)Z

    move-result p1

    .line 16
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService$1;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService;->access$000(Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService;)Landroid/app/job/JobParameters;

    move-result-object v0

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService$1;->val$parameters:Landroid/app/job/JobParameters;

    if-ne v0, v1, :cond_0

    .line 17
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService$1;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService;

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService;->access$002(Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService;Landroid/app/job/JobParameters;)Landroid/app/job/JobParameters;

    .line 18
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService$1;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService$1;->val$parameters:Landroid/app/job/JobParameters;

    invoke-virtual {v0, v1, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService;->jobFinished(Landroid/app/job/JobParameters;Z)V

    .line 20
    :cond_0
    return-void
.end method
