.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync;
.super Ljava/lang/Object;
.source "RimeAutoSync.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;
    }
.end annotation


# static fields
.field private static final ENABLED:Ljava/lang/String; = "enabled"

.field private static final INTERVAL:Ljava/lang/String; = "interval_hours"

.field public static final JOB_ID:I = 0x52494d45

.field private static final LAST_ERROR:Ljava/lang/String; = "last_error"

.field private static final PREFERENCES:Ljava/lang/String; = "rime_auto_sync_preferences"


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 18
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static completed(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)Z
    .locals 5

    .line 81
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;

    move-result-object v0

    iget-boolean v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->enabled:Z

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 82
    :cond_0
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync;->requiresAttention(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)Z

    move-result v0

    .line 83
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v2

    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    iget v3, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->errorCode:I

    .line 84
    const-string v4, "last_error"

    invoke-interface {v2, v4, v3}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    .line 85
    if-eqz v0, :cond_1

    const-string v3, "enabled"

    invoke-interface {v2, v3, v1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    .line 86
    :cond_1
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 87
    if-eqz v0, :cond_2

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync;->reconcile(Landroid/content/Context;)Z

    .line 88
    :cond_2
    iget-boolean p0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->success:Z

    if-nez p0, :cond_3

    if-nez v0, :cond_3

    const/4 v1, 0x1

    :cond_3
    return v1
.end method

.method static configure(Landroid/content/Context;ZI)Z
    .locals 2

    .line 46
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncPolicy;->intervalMillis(I)J

    .line 47
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "interval_hours"

    invoke-interface {v0, v1, p2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    const-string v0, "enabled"

    invoke-interface {p2, v0, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 48
    const-string p2, "last_error"

    const/4 v0, 0x0

    invoke-interface {p1, p2, v0}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 49
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync;->reconcile(Landroid/content/Context;)Z

    move-result p0

    return p0
.end method

.method private static preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .locals 2

    .line 21
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    const-string v0, "rime_auto_sync_preferences"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method public static read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;
    .locals 5

    .line 39
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    .line 40
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;

    const-string v1, "enabled"

    const/4 v2, 0x0

    invoke-interface {p0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v1

    .line 41
    const-string v3, "interval_hours"

    const/16 v4, 0x18

    invoke-interface {p0, v3, v4}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v3

    const-string v4, "last_error"

    invoke-interface {p0, v4, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result p0

    invoke-direct {v0, v1, v3, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;-><init>(ZII)V

    .line 40
    return-object v0
.end method

.method public static reconcile(Landroid/content/Context;)Z
    .locals 12

    .line 53
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    const/4 v2, 0x0

    if-ge v0, v1, :cond_0

    return v2

    .line 54
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync;->read(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;

    move-result-object v0

    .line 55
    const-string v1, "jobscheduler"

    invoke-virtual {p0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/app/job/JobScheduler;

    .line 56
    iget-boolean v3, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->enabled:Z

    const v4, 0x52494d45

    const/4 v5, 0x1

    if-nez v3, :cond_1

    .line 57
    invoke-virtual {v1, v4}, Landroid/app/job/JobScheduler;->cancel(I)V

    .line 58
    return v5

    .line 60
    :cond_1
    iget v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->intervalHours:I

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncPolicy;->intervalMillis(I)J

    move-result-wide v6

    .line 61
    new-instance v0, Landroid/content/ComponentName;

    const-class v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSyncJobService;

    invoke-direct {v0, p0, v3}, Landroid/content/ComponentName;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 62
    invoke-virtual {v1}, Landroid/app/job/JobScheduler;->getAllPendingJobs()Ljava/util/List;

    move-result-object v3

    invoke-interface {v3}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_0
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v8

    if-eqz v8, :cond_3

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Landroid/app/job/JobInfo;

    .line 63
    invoke-virtual {v8}, Landroid/app/job/JobInfo;->getId()I

    move-result v9

    if-ne v9, v4, :cond_2

    invoke-virtual {v8}, Landroid/app/job/JobInfo;->getIntervalMillis()J

    move-result-wide v9

    cmp-long v11, v9, v6

    if-nez v11, :cond_2

    .line 64
    invoke-virtual {v8}, Landroid/app/job/JobInfo;->getService()Landroid/content/ComponentName;

    move-result-object v8

    invoke-virtual {v0, v8}, Landroid/content/ComponentName;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-eqz v8, :cond_2

    return v5

    .line 65
    :cond_2
    goto :goto_0

    .line 66
    :cond_3
    new-instance v3, Landroid/app/job/JobInfo$Builder;

    invoke-direct {v3, v4, v0}, Landroid/app/job/JobInfo$Builder;-><init>(ILandroid/content/ComponentName;)V

    invoke-virtual {v3, v5}, Landroid/app/job/JobInfo$Builder;->setPersisted(Z)Landroid/app/job/JobInfo$Builder;

    move-result-object v0

    .line 67
    invoke-virtual {v0, v6, v7}, Landroid/app/job/JobInfo$Builder;->setPeriodic(J)Landroid/app/job/JobInfo$Builder;

    move-result-object v0

    .line 68
    const-wide/32 v3, 0x1b7740

    invoke-virtual {v0, v3, v4, v5}, Landroid/app/job/JobInfo$Builder;->setBackoffCriteria(JI)Landroid/app/job/JobInfo$Builder;

    move-result-object v0

    .line 70
    invoke-virtual {v0}, Landroid/app/job/JobInfo$Builder;->build()Landroid/app/job/JobInfo;

    move-result-object v0

    .line 71
    invoke-virtual {v1, v0}, Landroid/app/job/JobScheduler;->schedule(Landroid/app/job/JobInfo;)I

    move-result v0

    if-eq v0, v5, :cond_4

    .line 72
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string v0, "enabled"

    invoke-interface {p0, v0, v2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 73
    const-string v0, "last_error"

    const/4 v1, 0x7

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 74
    return v2

    .line 76
    :cond_4
    return v5
.end method

.method static requiresAttention(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)Z
    .locals 2

    .line 92
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->errorCode:I

    const/4 v1, 0x1

    sparse-switch v0, :sswitch_data_0

    .line 101
    const/4 p0, 0x0

    return p0

    .line 99
    :sswitch_0
    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->settings:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    iget-boolean p0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->locationAccessible:Z

    xor-int/2addr p0, v1

    return p0

    .line 97
    :sswitch_1
    return v1

    nop

    :sswitch_data_0
    .sparse-switch
        0x1 -> :sswitch_1
        0x2 -> :sswitch_0
        0x5 -> :sswitch_1
        0x8 -> :sswitch_1
        0xc -> :sswitch_1
    .end sparse-switch
.end method
