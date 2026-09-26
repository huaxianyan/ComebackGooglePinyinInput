.class final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;
.super Ljava/lang/Object;
.source "RimeSyncLegacySettingsCompat.java"

# interfaces
.implements Landroid/preference/Preference$OnPreferenceClickListener;
.implements Landroid/preference/Preference$OnPreferenceChangeListener;
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
.field private applyingInterval:Z

.field private automaticPreference:Landroid/preference/TwoStatePreference;

.field private devicePreference:Landroid/preference/Preference;

.field private editing:Z

.field private fragment:Landroid/preference/PreferenceFragment;

.field private intervalPreference:Landroid/preference/ListPreference;

.field private latest:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

.field private picking:Z

.field private populatedOptions:[I

.field private resetPreference:Landroid/preference/Preference;

.field private rootPreference:Landroid/preference/Preference;

.field private snapshotPreference:Landroid/preference/Preference;

.field private statusGeneration:I

.field private statusPreference:Landroid/preference/Preference;

.field private synchronizePreference:Landroid/preference/Preference;


# direct methods
.method constructor <init>(Landroid/preference/PreferenceFragment;)V
    .locals 0

    .line 204
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    return-void
.end method

.method private acceptCompatibility()V
    .locals 2

    .line 552
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 553
    if-nez v0, :cond_0

    return-void

    .line 554
    :cond_0
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$9;

    invoke-direct {v1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$9;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)V

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->acceptCompatibilityAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V

    .line 568
    return-void
.end method

.method static synthetic access$100(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)I
    .locals 0

    .line 186
    iget p0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusGeneration:I

    return p0
.end method

.method static synthetic access$1000(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    .line 186
    invoke-direct {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->saveConfiguration(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method static synthetic access$1102(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;Z)Z
    .locals 0

    .line 186
    iput-boolean p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->editing:Z

    return p1
.end method

.method static synthetic access$1200(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)V
    .locals 0

    .line 186
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->showKeepRejectedDialog()V

    return-void
.end method

.method static synthetic access$1300(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V
    .locals 0

    .line 186
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->showPreviewDialog(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V

    return-void
.end method

.method static synthetic access$1400(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)V
    .locals 0

    .line 186
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->acceptCompatibility()V

    return-void
.end method

.method static synthetic access$1500(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)V
    .locals 0

    .line 186
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->synchronize()V

    return-void
.end method

.method static synthetic access$1600(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;Ljava/lang/String;Z)V
    .locals 0

    .line 186
    invoke-direct {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->execute(Ljava/lang/String;Z)V

    return-void
.end method

.method static synthetic access$1700(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)V
    .locals 0

    .line 186
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->reset()V

    return-void
.end method

.method static synthetic access$1800(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;ZI)V
    .locals 0

    .line 186
    invoke-direct {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->configureAutomatic(ZI)V

    return-void
.end method

.method static synthetic access$200(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)Landroid/preference/PreferenceFragment;
    .locals 0

    .line 186
    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    return-object p0
.end method

.method static synthetic access$302(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;
    .locals 0

    .line 186
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->latest:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    return-object p1
.end method

.method static synthetic access$500(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)Landroid/content/Context;
    .locals 0

    .line 186
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$600(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    .line 186
    invoke-direct {p0, p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->releaseRoot(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method private automaticText(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;)Ljava/lang/String;
    .locals 6

    .line 823
    iget-object v0, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->automatic:Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;

    .line 824
    iget-boolean v1, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->operationInProgress:Z

    const/4 v2, 0x0

    if-eqz v1, :cond_0

    const-string p2, "rime_sync_status_in_progress"

    new-array v0, v2, [Ljava/lang/Object;

    invoke-static {p1, p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 825
    :cond_0
    iget v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->lastError:I

    if-eqz v1, :cond_1

    iget-boolean v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->enabled:Z

    if-nez v1, :cond_1

    .line 826
    const-string p2, "rime_sync_status_auto_paused"

    new-array v0, v2, [Ljava/lang/Object;

    invoke-static {p1, p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 828
    :cond_1
    iget v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->lastError:I

    if-eqz v1, :cond_2

    const-string p2, "rime_sync_status_auto_retry"

    new-array v0, v2, [Ljava/lang/Object;

    invoke-static {p1, p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 829
    :cond_2
    iget-boolean v1, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->canEnableAutomatic:Z

    if-nez v1, :cond_3

    .line 830
    const-string p2, "rime_sync_auto_prerequisite"

    new-array v0, v2, [Ljava/lang/Object;

    invoke-static {p1, p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 832
    :cond_3
    iget-boolean v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->enabled:Z

    if-eqz v0, :cond_4

    iget-wide v0, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->lastSuccess:J

    const-wide/16 v3, 0x0

    cmp-long v5, v0, v3

    if-lez v5, :cond_4

    .line 833
    iget-wide v0, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->lastSuccess:J

    invoke-direct {p0, p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->lastSuccessText(Landroid/content/Context;J)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 835
    :cond_4
    const-string p2, "rime_sync_auto_summary"

    new-array v0, v2, [Ljava/lang/Object;

    invoke-static {p1, p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1
.end method

.method private configureAutomatic(ZI)V
    .locals 2

    .line 694
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 695
    if-nez v0, :cond_0

    return-void

    .line 696
    :cond_0
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$18;

    invoke-direct {v1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$18;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)V

    invoke-static {v0, p1, p2, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->configureAutomaticAsync(Landroid/content/Context;ZILcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V

    .line 706
    return-void
.end method

.method private context()Landroid/content/Context;
    .locals 1

    .line 259
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 260
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    goto :goto_1

    .line 259
    :cond_1
    :goto_0
    const/4 v0, 0x0

    :goto_1
    return-object v0
.end method

.method private execute(Ljava/lang/String;Z)V
    .locals 2

    .line 601
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 602
    if-nez v0, :cond_0

    return-void

    .line 603
    :cond_0
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$12;

    invoke-direct {v1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$12;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)V

    invoke-static {v0, p1, p2, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->executeAsync(Landroid/content/Context;Ljava/lang/String;ZLcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V

    .line 617
    return-void
.end method

.method private initialTree()Landroid/net/Uri;
    .locals 2

    .line 348
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->latest:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    if-nez v0, :cond_0

    const-string v0, ""

    goto :goto_0

    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->latest:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->rootUri:Ljava/lang/String;

    .line 349
    :goto_0
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-lez v1, :cond_1

    .line 351
    :try_start_0
    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    .line 352
    nop

    .line 353
    invoke-static {v0}, Landroid/provider/DocumentsContract;->getTreeDocumentId(Landroid/net/Uri;)Ljava/lang/String;

    move-result-object v1

    .line 352
    invoke-static {v0, v1}, Landroid/provider/DocumentsContract;->buildDocumentUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    .line 354
    :catch_0
    move-exception v0

    .line 357
    :cond_1
    const-string v0, "com.android.externalstorage.documents"

    const-string v1, "primary:Documents"

    invoke-static {v0, v1}, Landroid/provider/DocumentsContract;->buildDocumentUri(Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    return-object v0
.end method

.method private intervalLabel(Landroid/content/Context;I)Ljava/lang/String;
    .locals 4

    .line 730
    const/4 v0, 0x0

    const/4 v1, 0x1

    const/16 v2, 0x18

    if-le p2, v2, :cond_0

    rem-int/lit8 v3, p2, 0x18

    if-nez v3, :cond_0

    .line 731
    div-int/2addr p2, v2

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    new-array v1, v1, [Ljava/lang/Object;

    aput-object p2, v1, v0

    const-string p2, "rime_sync_auto_days"

    invoke-static {p1, p2, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 733
    :cond_0
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    new-array v1, v1, [Ljava/lang/Object;

    aput-object p2, v1, v0

    const-string p2, "rime_sync_auto_hours"

    invoke-static {p1, p2, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1
.end method

.method private lastSuccessText(Landroid/content/Context;J)Ljava/lang/String;
    .locals 2

    .line 839
    nop

    .line 840
    invoke-static {p1}, Landroid/text/format/DateFormat;->getDateFormat(Landroid/content/Context;)Ljava/text/DateFormat;

    move-result-object v0

    invoke-static {p2, p3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/text/DateFormat;->format(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    .line 841
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

    .line 839
    const-string p2, "rime_sync_status_last_success"

    invoke-static {p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1
.end method

.method private openTreePicker()V
    .locals 3

    .line 329
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_2

    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->picking:Z

    if-nez v0, :cond_2

    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->editing:Z

    if-eqz v0, :cond_0

    goto :goto_1

    .line 330
    :cond_0
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->picking:Z

    .line 331
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.intent.action.OPEN_DOCUMENT_TREE"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 332
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x1a

    if-lt v1, v2, :cond_1

    .line 333
    const-string v1, "android.provider.extra.INITIAL_URI"

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->initialTree()Landroid/net/Uri;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;

    .line 335
    :cond_1
    const/16 v1, 0xc3

    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 340
    :try_start_0
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const/16 v2, 0x6b02

    invoke-virtual {v1, v0, v2}, Landroid/preference/PreferenceFragment;->startActivityForResult(Landroid/content/Intent;I)V
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    .line 344
    goto :goto_0

    .line 341
    :catch_0
    move-exception v0

    .line 342
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->picking:Z

    .line 343
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    const-string v1, "rime_sync_picker_unavailable"

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$000(Landroid/content/Context;Ljava/lang/String;)V

    .line 345
    :goto_0
    return-void

    .line 329
    :cond_2
    :goto_1
    return-void
.end method

.method private populateIntervalOptions(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;)V
    .locals 4

    .line 713
    if-eqz p1, :cond_3

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    if-nez v0, :cond_0

    goto :goto_1

    .line 714
    :cond_0
    iget-object p2, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->intervalOptions:[I

    .line 715
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->populatedOptions:[I

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->populatedOptions:[I

    invoke-static {v0, p2}, Ljava/util/Arrays;->equals([I[I)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 716
    return-void

    .line 718
    :cond_1
    array-length v0, p2

    new-array v0, v0, [Ljava/lang/CharSequence;

    .line 719
    array-length v1, p2

    new-array v1, v1, [Ljava/lang/CharSequence;

    .line 720
    const/4 v2, 0x0

    :goto_0
    array-length v3, p2

    if-ge v2, v3, :cond_2

    .line 721
    aget v3, p2, v2

    invoke-direct {p0, p1, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->intervalLabel(Landroid/content/Context;I)Ljava/lang/String;

    move-result-object v3

    aput-object v3, v0, v2

    .line 722
    aget v3, p2, v2

    invoke-static {v3}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v2

    .line 720
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 724
    :cond_2
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    invoke-virtual {p1, v0}, Landroid/preference/ListPreference;->setEntries([Ljava/lang/CharSequence;)V

    .line 725
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    invoke-virtual {p1, v1}, Landroid/preference/ListPreference;->setEntryValues([Ljava/lang/CharSequence;)V

    .line 726
    invoke-virtual {p2}, [I->clone()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [I

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->populatedOptions:[I

    .line 727
    return-void

    .line 713
    :cond_3
    :goto_1
    return-void
.end method

.method private releaseRoot(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V
    .locals 1

    .line 408
    if-eqz p2, :cond_1

    invoke-virtual {p2}, Ljava/lang/String;->length()I

    move-result v0

    if-eqz v0, :cond_1

    invoke-virtual {p2, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p3

    if-eqz p3, :cond_0

    goto :goto_1

    .line 410
    :cond_0
    :try_start_0
    invoke-virtual {p1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p1

    invoke-static {p2}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p2

    const/4 p3, 0x3

    invoke-virtual {p1, p2, p3}, Landroid/content/ContentResolver;->releasePersistableUriPermission(Landroid/net/Uri;I)V
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    .line 414
    goto :goto_0

    .line 413
    :catch_0
    move-exception p1

    .line 415
    :goto_0
    return-void

    .line 408
    :cond_1
    :goto_1
    return-void
.end method

.method private requestSynchronization()V
    .locals 2

    .line 485
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->latest:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    .line 486
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v1, :cond_2

    if-eqz v0, :cond_2

    iget-boolean v1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->operationInProgress:Z

    if-eqz v1, :cond_0

    goto :goto_0

    .line 487
    :cond_0
    iget-boolean v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->compatibilityAccepted:Z

    if-nez v0, :cond_1

    .line 488
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->showKeepRejectedDialog()V

    .line 489
    return-void

    .line 491
    :cond_1
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->synchronize()V

    .line 492
    return-void

    .line 486
    :cond_2
    :goto_0
    return-void
.end method

.method private reset()V
    .locals 2

    .line 651
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 652
    if-nez v0, :cond_0

    return-void

    .line 653
    :cond_0
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$15;

    invoke-direct {v1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$15;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)V

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->resetBaselineAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V

    .line 667
    return-void
.end method

.method private rootText(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;)Ljava/lang/String;
    .locals 2

    .line 795
    iget-object v0, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->rootUri:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    const-string p2, "rime_sync_root_unset"

    new-array v0, v1, [Ljava/lang/Object;

    invoke-static {p1, p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 796
    :cond_0
    iget-boolean v0, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->locationAccessible:Z

    if-nez v0, :cond_1

    .line 797
    const-string p2, "rime_sync_root_inaccessible"

    new-array v0, v1, [Ljava/lang/Object;

    invoke-static {p1, p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 799
    :cond_1
    iget-object v0, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->rootLabel:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    if-lez v0, :cond_2

    iget-object p1, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->rootLabel:Ljava/lang/String;

    return-object p1

    .line 800
    :cond_2
    const-string p2, "rime_sync_root_selected"

    new-array v0, v1, [Ljava/lang/Object;

    invoke-static {p1, p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1
.end method

.method private saveConfiguration(Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    .line 463
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 464
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->latest:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    .line 465
    if-eqz v0, :cond_3

    if-nez v1, :cond_0

    goto :goto_2

    .line 466
    :cond_0
    if-eqz p1, :cond_1

    goto :goto_0

    :cond_1
    iget-object p1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->deviceDirectory:Ljava/lang/String;

    .line 467
    :goto_0
    if-eqz p2, :cond_2

    goto :goto_1

    :cond_2
    iget-object p2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->snapshotFile:Ljava/lang/String;

    .line 468
    :goto_1
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$5;

    invoke-direct {v1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$5;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)V

    invoke-static {v0, p1, p2, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->saveConfigurationAsync(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V

    .line 478
    return-void

    .line 465
    :cond_3
    :goto_2
    return-void
.end method

.method private showAutomaticConsentDialog(I)V
    .locals 5

    .line 671
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_1

    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->editing:Z

    if-eqz v0, :cond_0

    goto :goto_0

    .line 672
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    .line 673
    const/4 v1, 0x1

    iput-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->editing:Z

    .line 674
    new-instance v1, Landroid/app/AlertDialog$Builder;

    invoke-direct {v1, v0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const/4 v2, 0x0

    new-array v3, v2, [Ljava/lang/Object;

    .line 675
    const-string v4, "rime_sync_auto_title"

    invoke-static {v0, v4, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    new-array v3, v2, [Ljava/lang/Object;

    .line 676
    const-string v4, "rime_sync_auto_consent"

    invoke-static {v0, v4, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    new-array v2, v2, [Ljava/lang/Object;

    .line 677
    const-string v3, "rime_sync_auto_enable"

    invoke-static {v0, v3, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$17;

    invoke-direct {v2, p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$17;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;I)V

    invoke-virtual {v1, v0, v2}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 683
    const/high16 v0, 0x1040000

    const/4 v1, 0x0

    invoke-virtual {p1, v0, v1}, Landroid/app/AlertDialog$Builder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$16;

    invoke-direct {v0, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$16;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)V

    .line 684
    invoke-virtual {p1, v0}, Landroid/app/AlertDialog$Builder;->setOnDismissListener(Landroid/content/DialogInterface$OnDismissListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 690
    invoke-virtual {p1}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 691
    return-void

    .line 671
    :cond_1
    :goto_0
    return-void
.end method

.method private showEditDialog(Z)V
    .locals 6

    .line 418
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_4

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_4

    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->picking:Z

    if-nez v0, :cond_4

    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->editing:Z

    if-eqz v0, :cond_0

    goto :goto_2

    .line 419
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    .line 420
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->latest:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    .line 421
    if-nez v1, :cond_1

    return-void

    .line 422
    :cond_1
    new-instance v2, Landroid/widget/EditText;

    invoke-direct {v2, v0}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    .line 423
    const/4 v3, 0x1

    invoke-virtual {v2, v3}, Landroid/widget/EditText;->setSingleLine(Z)V

    .line 424
    if-eqz p1, :cond_2

    iget-object v1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->deviceDirectory:Ljava/lang/String;

    goto :goto_0

    :cond_2
    iget-object v1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->snapshotFile:Ljava/lang/String;

    :goto_0
    invoke-virtual {v2, v1}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 425
    invoke-virtual {v2}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v1

    invoke-interface {v1}, Landroid/text/Editable;->length()I

    move-result v1

    invoke-virtual {v2, v1}, Landroid/widget/EditText;->setSelection(I)V

    .line 426
    new-instance v1, Landroid/app/AlertDialog$Builder;

    invoke-direct {v1, v0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    .line 427
    if-eqz p1, :cond_3

    const-string v4, "rime_sync_device_title"

    goto :goto_1

    .line 428
    :cond_3
    const-string v4, "rime_sync_snapshot_title"

    :goto_1
    const/4 v5, 0x0

    new-array v5, v5, [Ljava/lang/Object;

    .line 427
    invoke-static {v0, v4, v5}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    .line 429
    invoke-virtual {v0, v2}, Landroid/app/AlertDialog$Builder;->setView(Landroid/view/View;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    .line 430
    const v1, 0x104000a

    const/4 v4, 0x0

    invoke-virtual {v0, v1, v4}, Landroid/app/AlertDialog$Builder;->setPositiveButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    .line 431
    const/high16 v1, 0x1040000

    invoke-virtual {v0, v1, v4}, Landroid/app/AlertDialog$Builder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    .line 432
    invoke-virtual {v0}, Landroid/app/AlertDialog$Builder;->create()Landroid/app/AlertDialog;

    move-result-object v0

    .line 433
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$3;

    invoke-direct {v1, p0, v0, v2, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$3;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;Landroid/app/AlertDialog;Landroid/widget/EditText;Z)V

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog;->setOnShowListener(Landroid/content/DialogInterface$OnShowListener;)V

    .line 455
    new-instance p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$4;

    invoke-direct {p1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$4;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)V

    invoke-virtual {v0, p1}, Landroid/app/AlertDialog;->setOnDismissListener(Landroid/content/DialogInterface$OnDismissListener;)V

    .line 458
    iput-boolean v3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->editing:Z

    .line 459
    invoke-virtual {v0}, Landroid/app/AlertDialog;->show()V

    .line 460
    return-void

    .line 418
    :cond_4
    :goto_2
    return-void
.end method

.method private showKeepRejectedDialog()V
    .locals 5

    .line 526
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_1

    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->editing:Z

    if-eqz v0, :cond_0

    goto :goto_0

    .line 527
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    .line 528
    const/4 v1, 0x1

    iput-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->editing:Z

    .line 529
    new-instance v1, Landroid/app/AlertDialog$Builder;

    invoke-direct {v1, v0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const/4 v2, 0x0

    new-array v3, v2, [Ljava/lang/Object;

    .line 530
    const-string v4, "rime_sync_keep_rejected_title"

    invoke-static {v0, v4, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    new-array v3, v2, [Ljava/lang/Object;

    .line 531
    const-string v4, "rime_sync_keep_rejected_message"

    invoke-static {v0, v4, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    new-array v2, v2, [Ljava/lang/Object;

    .line 532
    const-string v3, "rime_sync_keep_rejected_action"

    invoke-static {v0, v3, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$8;

    invoke-direct {v2, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$8;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)V

    invoke-virtual {v1, v0, v2}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    .line 541
    const/high16 v1, 0x1040000

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/app/AlertDialog$Builder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$7;

    invoke-direct {v1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$7;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)V

    .line 542
    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setOnDismissListener(Landroid/content/DialogInterface$OnDismissListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    .line 548
    invoke-virtual {v0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 549
    return-void

    .line 526
    :cond_1
    :goto_0
    return-void
.end method

.method private showPreviewDialog(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V
    .locals 10

    .line 572
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-nez v0, :cond_0

    goto/16 :goto_1

    .line 573
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    .line 574
    const/4 v1, 0x1

    iput-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->editing:Z

    .line 575
    new-instance v2, Landroid/app/AlertDialog$Builder;

    invoke-direct {v2, v0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x0

    new-array v4, v3, [Ljava/lang/Object;

    .line 576
    const-string v5, "rime_sync_preview_title"

    invoke-static {v0, v5, v4}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v4}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v2

    iget v4, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->googleAdditionCount:I

    .line 578
    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    iget v5, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->googleDeletionCount:I

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v5

    iget v6, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->rimeAdditionCount:I

    .line 579
    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    iget v7, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->rimeDeletionCount:I

    invoke-static {v7}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    iget v8, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->rimeResurrectionCount:I

    .line 580
    invoke-static {v8}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v8

    const/4 v9, 0x5

    new-array v9, v9, [Ljava/lang/Object;

    aput-object v4, v9, v3

    aput-object v5, v9, v1

    const/4 v1, 0x2

    aput-object v6, v9, v1

    const/4 v1, 0x3

    aput-object v7, v9, v1

    const/4 v1, 0x4

    aput-object v8, v9, v1

    .line 577
    const-string v1, "rime_sync_preview_message"

    invoke-static {v0, v1, v9}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    .line 581
    iget-boolean v2, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->requiresDeletionConfirmation:Z

    if-eqz v2, :cond_1

    .line 582
    const-string v2, "rime_sync_confirm_deletions"

    goto :goto_0

    :cond_1
    const-string v2, "rime_sync_confirm"

    :goto_0
    new-array v3, v3, [Ljava/lang/Object;

    .line 581
    invoke-static {v0, v2, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$11;

    invoke-direct {v2, p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$11;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V

    invoke-virtual {v1, v0, v2}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 590
    const/high16 v0, 0x1040000

    const/4 v1, 0x0

    invoke-virtual {p1, v0, v1}, Landroid/app/AlertDialog$Builder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$10;

    invoke-direct {v0, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$10;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)V

    .line 591
    invoke-virtual {p1, v0}, Landroid/app/AlertDialog$Builder;->setOnDismissListener(Landroid/content/DialogInterface$OnDismissListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 597
    invoke-virtual {p1}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 598
    return-void

    .line 572
    :cond_2
    :goto_1
    return-void
.end method

.method private showResetDialog()V
    .locals 5

    .line 625
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->latest:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    .line 626
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v1, :cond_3

    if-eqz v0, :cond_3

    iget-boolean v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->operationInProgress:Z

    if-eqz v0, :cond_0

    goto :goto_1

    .line 627
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    .line 628
    if-eqz v0, :cond_2

    iget-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->editing:Z

    if-eqz v1, :cond_1

    goto :goto_0

    .line 629
    :cond_1
    const/4 v1, 0x1

    iput-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->editing:Z

    .line 630
    new-instance v1, Landroid/app/AlertDialog$Builder;

    invoke-direct {v1, v0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const/4 v2, 0x0

    new-array v3, v2, [Ljava/lang/Object;

    .line 631
    const-string v4, "rime_sync_reset_confirm_title"

    invoke-static {v0, v4, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    new-array v3, v2, [Ljava/lang/Object;

    .line 632
    const-string v4, "rime_sync_reset_confirm_message"

    invoke-static {v0, v4, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    new-array v2, v2, [Ljava/lang/Object;

    .line 633
    const-string v3, "rime_sync_reset_action"

    invoke-static {v0, v3, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$14;

    invoke-direct {v2, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$14;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)V

    invoke-virtual {v1, v0, v2}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    .line 640
    const/high16 v1, 0x1040000

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/app/AlertDialog$Builder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$13;

    invoke-direct {v1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$13;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)V

    .line 641
    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setOnDismissListener(Landroid/content/DialogInterface$OnDismissListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    .line 647
    invoke-virtual {v0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 648
    return-void

    .line 628
    :cond_2
    :goto_0
    return-void

    .line 626
    :cond_3
    :goto_1
    return-void
.end method

.method private statusText(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;ZZ)Ljava/lang/String;
    .locals 4

    .line 805
    iget-boolean v0, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->operationInProgress:Z

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    const-string p2, "rime_sync_status_in_progress"

    new-array p3, v1, [Ljava/lang/Object;

    invoke-static {p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 806
    :cond_0
    if-nez p3, :cond_1

    const-string p2, "rime_sync_status_unconfigured"

    new-array p3, v1, [Ljava/lang/Object;

    invoke-static {p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 807
    :cond_1
    iget-boolean p3, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->locationAccessible:Z

    if-nez p3, :cond_2

    const-string p2, "rime_sync_status_location"

    new-array p3, v1, [Ljava/lang/Object;

    invoke-static {p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 808
    :cond_2
    iget p3, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->nativeFailureKind:I

    if-eqz p3, :cond_3

    .line 809
    const-string p2, "rime_sync_status_paused"

    new-array p3, v1, [Ljava/lang/Object;

    invoke-static {p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 811
    :cond_3
    iget-object p3, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->automatic:Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;

    iget p3, p3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->lastError:I

    if-eqz p3, :cond_5

    .line 812
    iget-object p2, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->automatic:Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;

    iget-boolean p2, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->enabled:Z

    if-eqz p2, :cond_4

    .line 813
    const-string p2, "rime_sync_status_auto_retry"

    goto :goto_0

    :cond_4
    const-string p2, "rime_sync_status_auto_paused"

    :goto_0
    new-array p3, v1, [Ljava/lang/Object;

    .line 812
    invoke-static {p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 815
    :cond_5
    if-eqz p4, :cond_6

    const-string p2, "rime_sync_status_unfinished"

    new-array p3, v1, [Ljava/lang/Object;

    invoke-static {p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 816
    :cond_6
    iget-wide p3, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->lastSuccess:J

    const-wide/16 v2, 0x0

    cmp-long v0, p3, v2

    if-lez v0, :cond_7

    .line 817
    iget-wide p2, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->lastSuccess:J

    invoke-direct {p0, p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->lastSuccessText(Landroid/content/Context;J)Ljava/lang/String;

    move-result-object p1

    return-object p1

    .line 819
    :cond_7
    const-string p2, "rime_sync_status_not_run"

    new-array p3, v1, [Ljava/lang/Object;

    invoke-static {p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    return-object p1
.end method

.method private synchronize()V
    .locals 2

    .line 495
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 496
    if-nez v0, :cond_0

    return-void

    .line 497
    :cond_0
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$6;

    invoke-direct {v1, p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$6;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;)V

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->synchronizeAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V

    .line 523
    return-void
.end method


# virtual methods
.method applyState()V
    .locals 14

    .line 737
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 738
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->latest:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    .line 739
    if-eqz v0, :cond_16

    if-nez v1, :cond_0

    goto/16 :goto_b

    .line 740
    :cond_0
    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->automatic:Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;

    .line 741
    iget-boolean v3, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->operationInProgress:Z

    .line 742
    iget-object v4, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->rootUri:Ljava/lang/String;

    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v4

    const/4 v5, 0x1

    const/4 v6, 0x0

    if-lez v4, :cond_1

    iget-object v4, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->deviceDirectory:Ljava/lang/String;

    .line 743
    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v4

    if-lez v4, :cond_1

    iget-object v4, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->snapshotFile:Ljava/lang/String;

    .line 744
    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v4

    if-lez v4, :cond_1

    const/4 v4, 0x1

    goto :goto_0

    :cond_1
    const/4 v4, 0x0

    .line 745
    :goto_0
    iget v7, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->phase:I

    if-eqz v7, :cond_2

    const/4 v7, 0x1

    goto :goto_1

    :cond_2
    const/4 v7, 0x0

    .line 747
    :goto_1
    iget-object v8, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusPreference:Landroid/preference/Preference;

    if-eqz v8, :cond_4

    .line 748
    invoke-direct {p0, v0, v1, v4, v7}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusText(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;ZZ)Ljava/lang/String;

    move-result-object v8

    .line 749
    iget-wide v9, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->lastSuccess:J

    const-wide/16 v11, 0x0

    cmp-long v13, v9, v11

    if-lez v13, :cond_3

    iget-object v9, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->counts:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$BaselineCounts;

    if-eqz v9, :cond_3

    .line 750
    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v9, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    const-string v9, "\n"

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    iget-object v9, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->counts:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$BaselineCounts;

    iget v9, v9, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$BaselineCounts;->shared:I

    .line 751
    invoke-static {v9}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v9

    iget-object v10, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->counts:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$BaselineCounts;

    iget v10, v10, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$BaselineCounts;->rimeOnly:I

    invoke-static {v10}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v10

    const/4 v11, 0x2

    new-array v11, v11, [Ljava/lang/Object;

    aput-object v9, v11, v6

    aput-object v10, v11, v5

    .line 750
    const-string v9, "rime_sync_status_counts"

    invoke-static {v0, v9, v11}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    .line 753
    :cond_3
    iget-object v9, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusPreference:Landroid/preference/Preference;

    invoke-virtual {v9, v8}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    .line 754
    iget-object v8, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusPreference:Landroid/preference/Preference;

    invoke-virtual {v8, v5}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 756
    :cond_4
    iget-object v8, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->automaticPreference:Landroid/preference/TwoStatePreference;

    if-eqz v8, :cond_7

    if-eqz v2, :cond_7

    .line 757
    iget-object v8, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->automaticPreference:Landroid/preference/TwoStatePreference;

    iget-boolean v9, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->enabled:Z

    invoke-virtual {v8, v9}, Landroid/preference/TwoStatePreference;->setChecked(Z)V

    .line 758
    iget-object v8, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->automaticPreference:Landroid/preference/TwoStatePreference;

    invoke-direct {p0, v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->automaticText(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Landroid/preference/TwoStatePreference;->setSummary(Ljava/lang/CharSequence;)V

    .line 759
    iget-object v8, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->automaticPreference:Landroid/preference/TwoStatePreference;

    iget-boolean v9, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->enabled:Z

    if-nez v9, :cond_6

    iget-boolean v9, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->canEnableAutomatic:Z

    if-eqz v9, :cond_5

    if-nez v3, :cond_5

    goto :goto_2

    :cond_5
    const/4 v9, 0x0

    goto :goto_3

    :cond_6
    :goto_2
    const/4 v9, 0x1

    :goto_3
    invoke-virtual {v8, v9}, Landroid/preference/TwoStatePreference;->setEnabled(Z)V

    .line 762
    :cond_7
    iget-object v8, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    if-eqz v8, :cond_a

    if-eqz v2, :cond_a

    .line 763
    invoke-direct {p0, v0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->populateIntervalOptions(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;)V

    .line 764
    iget v8, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->intervalHours:I

    invoke-static {v8}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v8

    .line 765
    iget-object v9, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    invoke-virtual {v9}, Landroid/preference/ListPreference;->getValue()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-nez v9, :cond_8

    .line 766
    iput-boolean v5, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->applyingInterval:Z

    .line 767
    iget-object v9, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    invoke-virtual {v9, v8}, Landroid/preference/ListPreference;->setValue(Ljava/lang/String;)V

    .line 768
    iput-boolean v6, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->applyingInterval:Z

    .line 770
    :cond_8
    iget-object v8, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    iget v9, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->intervalHours:I

    invoke-direct {p0, v0, v9}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->intervalLabel(Landroid/content/Context;I)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Landroid/preference/ListPreference;->setSummary(Ljava/lang/CharSequence;)V

    .line 771
    iget-object v8, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    iget-boolean v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->enabled:Z

    if-eqz v2, :cond_9

    if-nez v3, :cond_9

    const/4 v2, 0x1

    goto :goto_4

    :cond_9
    const/4 v2, 0x0

    :goto_4
    invoke-virtual {v8, v2}, Landroid/preference/ListPreference;->setEnabled(Z)V

    .line 773
    :cond_a
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->rootPreference:Landroid/preference/Preference;

    if-eqz v2, :cond_c

    .line 774
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->rootPreference:Landroid/preference/Preference;

    invoke-direct {p0, v0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->rootText(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v2, v8}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    .line 775
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->rootPreference:Landroid/preference/Preference;

    if-nez v3, :cond_b

    if-nez v7, :cond_b

    const/4 v8, 0x1

    goto :goto_5

    :cond_b
    const/4 v8, 0x0

    :goto_5
    invoke-virtual {v2, v8}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 777
    :cond_c
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->devicePreference:Landroid/preference/Preference;

    if-eqz v2, :cond_f

    .line 778
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->devicePreference:Landroid/preference/Preference;

    iget-object v8, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->deviceDirectory:Ljava/lang/String;

    invoke-virtual {v8}, Ljava/lang/String;->length()I

    move-result v8

    if-nez v8, :cond_d

    .line 779
    const-string v8, "rime_sync_device_unset"

    new-array v9, v6, [Ljava/lang/Object;

    invoke-static {v0, v8, v9}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$800(Landroid/content/Context;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    goto :goto_6

    :cond_d
    iget-object v0, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->deviceDirectory:Ljava/lang/String;

    .line 778
    :goto_6
    invoke-virtual {v2, v0}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    .line 780
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->devicePreference:Landroid/preference/Preference;

    if-nez v3, :cond_e

    if-nez v7, :cond_e

    const/4 v2, 0x1

    goto :goto_7

    :cond_e
    const/4 v2, 0x0

    :goto_7
    invoke-virtual {v0, v2}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 782
    :cond_f
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->snapshotPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_11

    .line 783
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->snapshotPreference:Landroid/preference/Preference;

    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->snapshotFile:Ljava/lang/String;

    invoke-virtual {v0, v2}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    .line 784
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->snapshotPreference:Landroid/preference/Preference;

    if-nez v3, :cond_10

    if-nez v7, :cond_10

    const/4 v2, 0x1

    goto :goto_8

    :cond_10
    const/4 v2, 0x0

    :goto_8
    invoke-virtual {v0, v2}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 786
    :cond_11
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->synchronizePreference:Landroid/preference/Preference;

    if-eqz v0, :cond_13

    .line 787
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->synchronizePreference:Landroid/preference/Preference;

    if-eqz v4, :cond_12

    iget-boolean v1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->locationAccessible:Z

    if-eqz v1, :cond_12

    if-nez v3, :cond_12

    const/4 v1, 0x1

    goto :goto_9

    :cond_12
    const/4 v1, 0x0

    :goto_9
    invoke-virtual {v0, v1}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 789
    :cond_13
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->resetPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_15

    .line 790
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->resetPreference:Landroid/preference/Preference;

    if-eqz v4, :cond_14

    if-nez v3, :cond_14

    if-nez v7, :cond_14

    goto :goto_a

    :cond_14
    const/4 v5, 0x0

    :goto_a
    invoke-virtual {v0, v5}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 792
    :cond_15
    return-void

    .line 739
    :cond_16
    :goto_b
    return-void
.end method

.method bind()V
    .locals 2

    .line 207
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "rime_sync_current_status"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusPreference:Landroid/preference/Preference;

    .line 210
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "rime_sync_auto_enabled"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    check-cast v0, Landroid/preference/TwoStatePreference;

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->automaticPreference:Landroid/preference/TwoStatePreference;

    .line 211
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "rime_sync_auto_interval_hours"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    check-cast v0, Landroid/preference/ListPreference;

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    .line 212
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "rime_sync_root"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->rootPreference:Landroid/preference/Preference;

    .line 213
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "rime_sync_device"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->devicePreference:Landroid/preference/Preference;

    .line 214
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "rime_sync_snapshot_file"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->snapshotPreference:Landroid/preference/Preference;

    .line 215
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "rime_sync_now"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->synchronizePreference:Landroid/preference/Preference;

    .line 216
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "rime_sync_reset"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->resetPreference:Landroid/preference/Preference;

    .line 218
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusPreference:Landroid/preference/Preference;

    invoke-virtual {v0, p0}, Landroid/preference/Preference;->setOnPreferenceClickListener(Landroid/preference/Preference$OnPreferenceClickListener;)V

    .line 219
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->rootPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->rootPreference:Landroid/preference/Preference;

    invoke-virtual {v0, p0}, Landroid/preference/Preference;->setOnPreferenceClickListener(Landroid/preference/Preference$OnPreferenceClickListener;)V

    .line 220
    :cond_1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->devicePreference:Landroid/preference/Preference;

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->devicePreference:Landroid/preference/Preference;

    invoke-virtual {v0, p0}, Landroid/preference/Preference;->setOnPreferenceClickListener(Landroid/preference/Preference$OnPreferenceClickListener;)V

    .line 221
    :cond_2
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->snapshotPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_3

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->snapshotPreference:Landroid/preference/Preference;

    invoke-virtual {v0, p0}, Landroid/preference/Preference;->setOnPreferenceClickListener(Landroid/preference/Preference$OnPreferenceClickListener;)V

    .line 222
    :cond_3
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->synchronizePreference:Landroid/preference/Preference;

    if-eqz v0, :cond_4

    .line 223
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->synchronizePreference:Landroid/preference/Preference;

    invoke-virtual {v0, p0}, Landroid/preference/Preference;->setOnPreferenceClickListener(Landroid/preference/Preference$OnPreferenceClickListener;)V

    .line 225
    :cond_4
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->resetPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_5

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->resetPreference:Landroid/preference/Preference;

    invoke-virtual {v0, p0}, Landroid/preference/Preference;->setOnPreferenceClickListener(Landroid/preference/Preference$OnPreferenceClickListener;)V

    .line 228
    :cond_5
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->automaticPreference:Landroid/preference/TwoStatePreference;

    if-eqz v0, :cond_6

    .line 229
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->automaticPreference:Landroid/preference/TwoStatePreference;

    invoke-virtual {v0, p0}, Landroid/preference/TwoStatePreference;->setOnPreferenceChangeListener(Landroid/preference/Preference$OnPreferenceChangeListener;)V

    .line 231
    :cond_6
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    if-eqz v0, :cond_7

    .line 232
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    invoke-virtual {v0, p0}, Landroid/preference/ListPreference;->setOnPreferenceChangeListener(Landroid/preference/Preference$OnPreferenceChangeListener;)V

    .line 235
    :cond_7
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->addStateListener(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$StateListener;)V

    .line 236
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->reload()V

    .line 237
    return-void
.end method

.method destroy()V
    .locals 1

    .line 240
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusGeneration:I

    add-int/lit8 v0, v0, 0x1

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusGeneration:I

    .line 241
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->picking:Z

    .line 242
    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->editing:Z

    .line 243
    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->applyingInterval:Z

    .line 244
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->populatedOptions:[I

    .line 245
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->removeStateListener(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$StateListener;)V

    .line 246
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    .line 247
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusPreference:Landroid/preference/Preference;

    .line 248
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->automaticPreference:Landroid/preference/TwoStatePreference;

    .line 249
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    .line 250
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->rootPreference:Landroid/preference/Preference;

    .line 251
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->devicePreference:Landroid/preference/Preference;

    .line 252
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->snapshotPreference:Landroid/preference/Preference;

    .line 253
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->synchronizePreference:Landroid/preference/Preference;

    .line 254
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->resetPreference:Landroid/preference/Preference;

    .line 255
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->latest:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    .line 256
    return-void
.end method

.method public onChanged(Z)V
    .locals 0

    .line 312
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz p1, :cond_0

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->reload()V

    .line 313
    :cond_0
    return-void
.end method

.method public onPreferenceChange(Landroid/preference/Preference;Ljava/lang/Object;)Z
    .locals 4

    .line 281
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->latest:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    .line 282
    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 283
    :cond_0
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->automaticPreference:Landroid/preference/TwoStatePreference;

    const/4 v3, 0x1

    if-ne p1, v2, :cond_3

    .line 284
    sget-object p1, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {p1, p2}, Ljava/lang/Boolean;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_1

    .line 285
    iget-object p1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->automatic:Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;

    iget p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->intervalHours:I

    invoke-direct {p0, v1, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->configureAutomatic(ZI)V

    .line 286
    return v3

    .line 288
    :cond_1
    iget-boolean p1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->canEnableAutomatic:Z

    if-nez p1, :cond_2

    .line 289
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object p1

    const-string p2, "rime_sync_auto_prerequisite"

    invoke-static {p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$000(Landroid/content/Context;Ljava/lang/String;)V

    .line 290
    return v1

    .line 293
    :cond_2
    iget-object p1, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->automatic:Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;

    iget p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->intervalHours:I

    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->showAutomaticConsentDialog(I)V

    .line 294
    return v1

    .line 296
    :cond_3
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    if-ne p1, v2, :cond_6

    .line 297
    iget-boolean p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->applyingInterval:Z

    if-eqz p1, :cond_4

    return v3

    .line 300
    :cond_4
    :try_start_0
    invoke-static {p2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p1
    :try_end_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_0

    .line 303
    nop

    .line 304
    iget-object p2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->automatic:Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;

    iget p2, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->intervalHours:I

    if-ne p1, p2, :cond_5

    return v3

    .line 305
    :cond_5
    iget-object p2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->automatic:Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;

    iget-boolean p2, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeAutoSync$Settings;->enabled:Z

    invoke-direct {p0, p2, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->configureAutomatic(ZI)V

    .line 306
    return v3

    .line 301
    :catch_0
    move-exception p1

    .line 302
    return v1

    .line 308
    :cond_6
    return v3
.end method

.method public onPreferenceClick(Landroid/preference/Preference;)Z
    .locals 2

    .line 264
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusPreference:Landroid/preference/Preference;

    const/4 v1, 0x1

    if-ne p1, v0, :cond_0

    .line 265
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->reload()V

    goto :goto_0

    .line 266
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->rootPreference:Landroid/preference/Preference;

    if-ne p1, v0, :cond_1

    .line 267
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->openTreePicker()V

    goto :goto_0

    .line 268
    :cond_1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->devicePreference:Landroid/preference/Preference;

    if-ne p1, v0, :cond_2

    .line 269
    invoke-direct {p0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->showEditDialog(Z)V

    goto :goto_0

    .line 270
    :cond_2
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->snapshotPreference:Landroid/preference/Preference;

    if-ne p1, v0, :cond_3

    .line 271
    const/4 p1, 0x0

    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->showEditDialog(Z)V

    goto :goto_0

    .line 272
    :cond_3
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->synchronizePreference:Landroid/preference/Preference;

    if-ne p1, v0, :cond_4

    .line 273
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->requestSynchronization()V

    goto :goto_0

    .line 274
    :cond_4
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->resetPreference:Landroid/preference/Preference;

    if-ne p1, v0, :cond_5

    .line 275
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->showResetDialog()V

    .line 277
    :cond_5
    :goto_0
    return v1
.end method

.method onTreeResult(ILandroid/content/Intent;)V
    .locals 4

    .line 362
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->picking:Z

    .line 363
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 364
    if-eqz v0, :cond_5

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-nez v1, :cond_0

    goto :goto_2

    .line 365
    :cond_0
    const/4 v1, -0x1

    if-ne p1, v1, :cond_4

    if-eqz p2, :cond_4

    invoke-virtual {p2}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object p1

    if-nez p1, :cond_1

    goto :goto_1

    .line 369
    :cond_1
    invoke-virtual {p2}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object p1

    .line 370
    invoke-virtual {p2}, Landroid/content/Intent;->getFlags()I

    move-result p2

    const/4 v1, 0x3

    and-int/2addr p2, v1

    .line 372
    const-string v2, "rime_sync_error_location"

    if-eq p2, v1, :cond_2

    .line 374
    invoke-static {v0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$000(Landroid/content/Context;Ljava/lang/String;)V

    .line 375
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->reload()V

    .line 376
    return-void

    .line 379
    :cond_2
    :try_start_0
    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v1

    invoke-virtual {v1, p1, p2}, Landroid/content/ContentResolver;->takePersistableUriPermission(Landroid/net/Uri;I)V
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    .line 384
    nop

    .line 385
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->latest:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    if-nez p2, :cond_3

    const-string p2, ""

    goto :goto_0

    :cond_3
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->latest:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;

    iget-object p2, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Settings;->rootUri:Ljava/lang/String;

    .line 386
    :goto_0
    invoke-virtual {p1}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v1

    .line 387
    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$400(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;

    move-result-object v2

    .line 388
    new-instance v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$2;

    invoke-direct {v3, p0, p2, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$2;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {v0, p1, v2, v3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->acceptRootAsync(Landroid/content/Context;Landroid/net/Uri;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V

    .line 404
    return-void

    .line 380
    :catch_0
    move-exception p1

    .line 381
    invoke-static {v0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat;->access$000(Landroid/content/Context;Ljava/lang/String;)V

    .line 382
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->reload()V

    .line 383
    return-void

    .line 366
    :cond_4
    :goto_1
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->reload()V

    .line 367
    return-void

    .line 364
    :cond_5
    :goto_2
    return-void
.end method

.method reload()V
    .locals 3

    .line 316
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 317
    if-nez v0, :cond_0

    return-void

    .line 318
    :cond_0
    iget v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusGeneration:I

    add-int/lit8 v1, v1, 0x1

    iput v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->statusGeneration:I

    .line 319
    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$1;

    invoke-direct {v2, p0, v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$1;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;I)V

    invoke-static {v0, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat;->readAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Callback;)V

    .line 326
    return-void
.end method
