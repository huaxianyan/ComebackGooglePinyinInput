.class final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;
.super Ljava/lang/Object;
.source "RimeSyncLegacySettingsCompat.java"

# interfaces
.implements Landroid/preference/Preference$OnPreferenceClickListener;
.implements Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$StateListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "Controller"
.end annotation


# instance fields
.field private automaticPreference:Landroid/preference/TwoStatePreference;

.field private devicePreference:Landroid/preference/Preference;

.field private fragment:Landroid/preference/PreferenceFragment;

.field private intervalPreference:Landroid/preference/ListPreference;

.field private latest:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

.field private resetPreference:Landroid/preference/Preference;

.field private rootPreference:Landroid/preference/Preference;

.field private snapshotPreference:Landroid/preference/Preference;

.field private statusGeneration:I

.field private statusPreference:Landroid/preference/Preference;

.field private synchronizePreference:Landroid/preference/Preference;


# direct methods
.method constructor <init>(Landroid/preference/PreferenceFragment;)V
    .locals 0

    .line 97
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    return-void
.end method

.method static synthetic access$000(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)I
    .locals 0

    .line 83
    iget p0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusGeneration:I

    return p0
.end method

.method static synthetic access$100(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)Landroid/preference/PreferenceFragment;
    .locals 0

    .line 83
    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    return-object p0
.end method

.method static synthetic access$202(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;
    .locals 0

    .line 83
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->latest:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    return-object p1
.end method

.method private automaticText(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;)Ljava/lang/String;
    .locals 6

    .line 219
    iget-object v0, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->automatic:Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;

    .line 220
    iget-boolean v1, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->operationInProgress:Z

    const/4 v2, 0x0

    if-eqz v1, :cond_0

    const-string p2, "rime_sync_status_in_progress"

    new-array v0, v2, [Ljava/lang/Object;

    invoke-static {p1, p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$300(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 221
    :cond_0
    iget v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->lastError:I

    if-eqz v1, :cond_1

    iget-boolean v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->enabled:Z

    if-nez v1, :cond_1

    .line 222
    const-string p2, "rime_sync_status_auto_paused"

    new-array v0, v2, [Ljava/lang/Object;

    invoke-static {p1, p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$300(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 224
    :cond_1
    iget v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->lastError:I

    if-eqz v1, :cond_2

    const-string p2, "rime_sync_status_auto_retry"

    new-array v0, v2, [Ljava/lang/Object;

    invoke-static {p1, p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$300(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 225
    :cond_2
    iget-boolean v1, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->canEnableAutomatic:Z

    if-nez v1, :cond_3

    .line 226
    const-string p2, "rime_sync_auto_prerequisite"

    new-array v0, v2, [Ljava/lang/Object;

    invoke-static {p1, p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$300(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 228
    :cond_3
    iget-boolean v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->enabled:Z

    if-eqz v0, :cond_4

    iget-wide v0, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->lastSuccess:J

    const-wide/16 v3, 0x0

    cmp-long v5, v0, v3

    if-lez v5, :cond_4

    .line 229
    iget-wide v0, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->lastSuccess:J

    invoke-direct {p0, p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->lastSuccessText(Landroid/content/Context;J)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 231
    :cond_4
    const-string p2, "rime_sync_auto_summary"

    new-array v0, v2, [Ljava/lang/Object;

    invoke-static {p1, p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$300(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1
.end method

.method private context()Landroid/content/Context;
    .locals 1

    .line 133
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 134
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    goto :goto_1

    .line 133
    :cond_1
    :goto_0
    const/4 v0, 0x0

    :goto_1
    return-object v0
.end method

.method private lastSuccessText(Landroid/content/Context;J)Ljava/lang/String;
    .locals 2

    .line 235
    nop

    .line 236
    invoke-static {p1}, Landroid/text/format/DateFormat;->getDateFormat(Landroid/content/Context;)Ljava/text/DateFormat;

    move-result-object v0

    invoke-static {p2, p3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/text/DateFormat;->format(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    .line 237
    invoke-static {p1}, Landroid/text/format/DateFormat;->getTimeFormat(Landroid/content/Context;)Ljava/text/DateFormat;

    move-result-object v1

    invoke-static {p2, p3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p2

    invoke-virtual {v1, p2}, Ljava/text/DateFormat;->format(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p2

    const/4 p3, 0x2

    new-array p3, p3, [Ljava/lang/Object;

    const/4 v1, 0x0

    aput-object v0, p3, v1

    const/4 v0, 0x1

    aput-object p2, p3, v0

    .line 235
    const-string p2, "rime_sync_status_last_success"

    invoke-static {p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$300(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1
.end method

.method private statusText(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;ZZ)Ljava/lang/String;
    .locals 4

    .line 201
    iget-boolean v0, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->operationInProgress:Z

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    const-string p2, "rime_sync_status_in_progress"

    new-array p3, v1, [Ljava/lang/Object;

    invoke-static {p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$300(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 202
    :cond_0
    if-nez p3, :cond_1

    const-string p2, "rime_sync_status_unconfigured"

    new-array p3, v1, [Ljava/lang/Object;

    invoke-static {p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$300(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 203
    :cond_1
    iget-boolean p3, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->locationAccessible:Z

    if-nez p3, :cond_2

    const-string p2, "rime_sync_status_location"

    new-array p3, v1, [Ljava/lang/Object;

    invoke-static {p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$300(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 204
    :cond_2
    iget p3, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->nativeFailureKind:I

    if-eqz p3, :cond_3

    .line 205
    const-string p2, "rime_sync_status_paused"

    new-array p3, v1, [Ljava/lang/Object;

    invoke-static {p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$300(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 207
    :cond_3
    iget-object p3, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->automatic:Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;

    iget p3, p3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->lastError:I

    if-eqz p3, :cond_5

    .line 208
    iget-object p2, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->automatic:Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;

    iget-boolean p2, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->enabled:Z

    if-eqz p2, :cond_4

    .line 209
    const-string p2, "rime_sync_status_auto_retry"

    goto :goto_0

    :cond_4
    const-string p2, "rime_sync_status_auto_paused"

    :goto_0
    new-array p3, v1, [Ljava/lang/Object;

    .line 208
    invoke-static {p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$300(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 211
    :cond_5
    if-eqz p4, :cond_6

    const-string p2, "rime_sync_status_unfinished"

    new-array p3, v1, [Ljava/lang/Object;

    invoke-static {p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$300(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 212
    :cond_6
    iget-wide p3, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->lastSuccess:J

    const-wide/16 v2, 0x0

    cmp-long v0, p3, v2

    if-lez v0, :cond_7

    .line 213
    iget-wide p2, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->lastSuccess:J

    invoke-direct {p0, p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->lastSuccessText(Landroid/content/Context;J)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 215
    :cond_7
    const-string p2, "rime_sync_status_not_run"

    new-array p3, v1, [Ljava/lang/Object;

    invoke-static {p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$300(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1
.end method


# virtual methods
.method applyState()V
    .locals 14

    .line 160
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 161
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->latest:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    .line 162
    if-eqz v0, :cond_14

    if-nez v1, :cond_0

    goto/16 :goto_9

    .line 163
    :cond_0
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->automatic:Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;

    .line 164
    iget-boolean v3, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->operationInProgress:Z

    .line 165
    iget-object v4, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->rootUri:Ljava/lang/String;

    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v4

    const/4 v5, 0x0

    const/4 v6, 0x1

    if-lez v4, :cond_1

    iget-object v4, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->deviceDirectory:Ljava/lang/String;

    .line 166
    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v4

    if-lez v4, :cond_1

    iget-object v4, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->snapshotFile:Ljava/lang/String;

    .line 167
    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v4

    if-lez v4, :cond_1

    const/4 v4, 0x1

    goto :goto_0

    :cond_1
    const/4 v4, 0x0

    .line 168
    :goto_0
    iget v7, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->phase:I

    if-eqz v7, :cond_2

    const/4 v7, 0x1

    goto :goto_1

    :cond_2
    const/4 v7, 0x0

    .line 170
    :goto_1
    iget-object v8, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusPreference:Landroid/preference/Preference;

    if-eqz v8, :cond_4

    .line 171
    invoke-direct {p0, v0, v1, v4, v7}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusText(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;ZZ)Ljava/lang/String;

    move-result-object v8

    .line 172
    iget-wide v9, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->lastSuccess:J

    const-wide/16 v11, 0x0

    cmp-long v13, v9, v11

    if-lez v13, :cond_3

    iget-object v9, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->counts:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$BaselineCounts;

    if-eqz v9, :cond_3

    .line 173
    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v9, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    const-string v9, "\n"

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    iget-object v9, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->counts:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$BaselineCounts;

    iget v9, v9, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$BaselineCounts;->shared:I

    .line 174
    invoke-static {v9}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v9

    iget-object v10, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->counts:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$BaselineCounts;

    iget v10, v10, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$BaselineCounts;->rimeOnly:I

    invoke-static {v10}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v10

    const/4 v11, 0x2

    new-array v11, v11, [Ljava/lang/Object;

    aput-object v9, v11, v5

    aput-object v10, v11, v6

    .line 173
    const-string v9, "rime_sync_status_counts"

    invoke-static {v0, v9, v11}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$300(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    .line 176
    :cond_3
    iget-object v9, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusPreference:Landroid/preference/Preference;

    invoke-virtual {v9, v8}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    .line 177
    iget-object v8, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusPreference:Landroid/preference/Preference;

    invoke-virtual {v8, v6}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 179
    :cond_4
    iget-object v8, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->automaticPreference:Landroid/preference/TwoStatePreference;

    if-eqz v8, :cond_7

    if-eqz v2, :cond_7

    .line 180
    iget-object v8, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->automaticPreference:Landroid/preference/TwoStatePreference;

    iget-boolean v9, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->enabled:Z

    invoke-virtual {v8, v9}, Landroid/preference/TwoStatePreference;->setChecked(Z)V

    .line 181
    iget-object v8, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->automaticPreference:Landroid/preference/TwoStatePreference;

    invoke-direct {p0, v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->automaticText(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v8, v0}, Landroid/preference/TwoStatePreference;->setSummary(Ljava/lang/CharSequence;)V

    .line 182
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->automaticPreference:Landroid/preference/TwoStatePreference;

    iget-boolean v8, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->enabled:Z

    if-nez v8, :cond_6

    iget-boolean v8, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->canEnableAutomatic:Z

    if-eqz v8, :cond_5

    if-nez v3, :cond_5

    goto :goto_2

    :cond_5
    const/4 v8, 0x0

    goto :goto_3

    :cond_6
    :goto_2
    const/4 v8, 0x1

    :goto_3
    invoke-virtual {v0, v8}, Landroid/preference/TwoStatePreference;->setEnabled(Z)V

    .line 185
    :cond_7
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    if-eqz v0, :cond_9

    .line 186
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    if-eqz v2, :cond_8

    iget-boolean v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->enabled:Z

    if-eqz v2, :cond_8

    if-nez v3, :cond_8

    const/4 v2, 0x1

    goto :goto_4

    :cond_8
    const/4 v2, 0x0

    :goto_4
    invoke-virtual {v0, v2}, Landroid/preference/ListPreference;->setEnabled(Z)V

    .line 188
    :cond_9
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->rootPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_b

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->rootPreference:Landroid/preference/Preference;

    if-nez v3, :cond_a

    if-nez v7, :cond_a

    const/4 v2, 0x1

    goto :goto_5

    :cond_a
    const/4 v2, 0x0

    :goto_5
    invoke-virtual {v0, v2}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 189
    :cond_b
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->devicePreference:Landroid/preference/Preference;

    if-eqz v0, :cond_d

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->devicePreference:Landroid/preference/Preference;

    if-nez v3, :cond_c

    if-nez v7, :cond_c

    const/4 v2, 0x1

    goto :goto_6

    :cond_c
    const/4 v2, 0x0

    :goto_6
    invoke-virtual {v0, v2}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 190
    :cond_d
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->snapshotPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_f

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->snapshotPreference:Landroid/preference/Preference;

    if-nez v3, :cond_e

    if-nez v7, :cond_e

    const/4 v2, 0x1

    goto :goto_7

    :cond_e
    const/4 v2, 0x0

    :goto_7
    invoke-virtual {v0, v2}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 191
    :cond_f
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->synchronizePreference:Landroid/preference/Preference;

    if-eqz v0, :cond_11

    .line 192
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->synchronizePreference:Landroid/preference/Preference;

    if-eqz v4, :cond_10

    iget-boolean v1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->locationAccessible:Z

    if-eqz v1, :cond_10

    if-nez v3, :cond_10

    const/4 v1, 0x1

    goto :goto_8

    :cond_10
    const/4 v1, 0x0

    :goto_8
    invoke-virtual {v0, v1}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 194
    :cond_11
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->resetPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_13

    .line 195
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->resetPreference:Landroid/preference/Preference;

    if-eqz v4, :cond_12

    if-nez v3, :cond_12

    if-nez v7, :cond_12

    const/4 v5, 0x1

    :cond_12
    invoke-virtual {v0, v5}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 197
    :cond_13
    return-void

    .line 162
    :cond_14
    :goto_9
    return-void
.end method

.method bind()V
    .locals 2

    .line 100
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "rime_sync_current_status"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusPreference:Landroid/preference/Preference;

    .line 103
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "rime_sync_auto_enabled"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    check-cast v0, Landroid/preference/TwoStatePreference;

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->automaticPreference:Landroid/preference/TwoStatePreference;

    .line 104
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "rime_sync_auto_interval_hours"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    check-cast v0, Landroid/preference/ListPreference;

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    .line 105
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "rime_sync_root"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->rootPreference:Landroid/preference/Preference;

    .line 106
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "rime_sync_device"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->devicePreference:Landroid/preference/Preference;

    .line 107
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "rime_sync_snapshot_file"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->snapshotPreference:Landroid/preference/Preference;

    .line 108
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "rime_sync_now"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->synchronizePreference:Landroid/preference/Preference;

    .line 109
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "rime_sync_reset"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->resetPreference:Landroid/preference/Preference;

    .line 111
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusPreference:Landroid/preference/Preference;

    invoke-virtual {v0, p0}, Landroid/preference/Preference;->setOnPreferenceClickListener(Landroid/preference/Preference$OnPreferenceClickListener;)V

    .line 113
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->addStateListener(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$StateListener;)V

    .line 114
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->reload()V

    .line 115
    return-void
.end method

.method destroy()V
    .locals 1

    .line 118
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusGeneration:I

    add-int/lit8 v0, v0, 0x1

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusGeneration:I

    .line 119
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->removeStateListener(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$StateListener;)V

    .line 120
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    .line 121
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusPreference:Landroid/preference/Preference;

    .line 122
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->automaticPreference:Landroid/preference/TwoStatePreference;

    .line 123
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    .line 124
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->rootPreference:Landroid/preference/Preference;

    .line 125
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->devicePreference:Landroid/preference/Preference;

    .line 126
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->snapshotPreference:Landroid/preference/Preference;

    .line 127
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->synchronizePreference:Landroid/preference/Preference;

    .line 128
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->resetPreference:Landroid/preference/Preference;

    .line 129
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->latest:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    .line 130
    return-void
.end method

.method public onChanged(Z)V
    .locals 0

    .line 143
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz p1, :cond_0

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->reload()V

    .line 144
    :cond_0
    return-void
.end method

.method public onPreferenceClick(Landroid/preference/Preference;)Z
    .locals 1

    .line 138
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusPreference:Landroid/preference/Preference;

    if-ne p1, v0, :cond_0

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->reload()V

    .line 139
    :cond_0
    const/4 p1, 0x1

    return p1
.end method

.method reload()V
    .locals 3

    .line 147
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 148
    if-nez v0, :cond_0

    return-void

    .line 149
    :cond_0
    iget v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusGeneration:I

    add-int/lit8 v1, v1, 0x1

    iput v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusGeneration:I

    .line 150
    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$1;

    invoke-direct {v2, p0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$1;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;I)V

    invoke-static {v0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->readAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V

    .line 157
    return-void
.end method
