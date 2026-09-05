.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService;
.super Landroid/app/job/JobService;
.source "RimeAutoSyncJobService.java"


# instance fields
.field private active:Landroid/app/job/JobParameters;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 7
    invoke-direct {p0}, Landroid/app/job/JobService;-><init>()V

    return-void
.end method

.method static synthetic access$000(Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService;)Landroid/app/job/JobParameters;
    .locals 0

    .line 7
    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService;->active:Landroid/app/job/JobParameters;

    return-object p0
.end method

.method static synthetic access$002(Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService;Landroid/app/job/JobParameters;)Landroid/app/job/JobParameters;
    .locals 0

    .line 7
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService;->active:Landroid/app/job/JobParameters;

    return-object p1
.end method


# virtual methods
.method public onStartJob(Landroid/app/job/JobParameters;)Z
    .locals 1

    .line 11
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;

    move-result-object v0

    iget-boolean v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->enabled:Z

    if-nez v0, :cond_0

    const/4 p1, 0x0

    return p1

    .line 12
    :cond_0
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService;->active:Landroid/app/job/JobParameters;

    .line 13
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService$1;

    invoke-direct {v0, p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService$1;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService;Landroid/app/job/JobParameters;)V

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->runAutomaticAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V

    .line 22
    const/4 p1, 0x1

    return p1
.end method

.method public onStopJob(Landroid/app/job/JobParameters;)Z
    .locals 1

    .line 26
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService;->active:Landroid/app/job/JobParameters;

    if-ne v0, p1, :cond_0

    const/4 p1, 0x0

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService;->active:Landroid/app/job/JobParameters;

    .line 28
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;

    move-result-object p1

    iget-boolean p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->enabled:Z

    return p1
.end method
