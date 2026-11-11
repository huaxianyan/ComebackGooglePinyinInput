.class final Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupSettingsCompat.java"

# interfaces
.implements Landroid/preference/Preference$OnPreferenceClickListener;
.implements Landroid/preference/Preference$OnPreferenceChangeListener;
.implements Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ValidationCallback;
.implements Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupListCallback;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "Controller"
.end annotation


# instance fields
.field private backupNowPreference:Landroid/preference/Preference;

.field private dictionaryStatus:Landroid/preference/Preference;

.field private enabledPreference:Landroid/preference/TwoStatePreference;

.field private fragment:Landroid/preference/PreferenceFragment;

.field private importLoading:Z

.field private importPreference:Landroid/preference/Preference;

.field private intervalPreference:Landroid/preference/ListPreference;

.field private locationPreference:Landroid/preference/Preference;

.field private pendingTree:Landroid/net/Uri;

.field private pickPurpose:I

.field private retentionPreference:Landroid/preference/ListPreference;

.field private statusGeneration:I

.field private statusLoading:Z

.field private validating:Z


# direct methods
.method constructor <init>(Landroid/preference/PreferenceFragment;)V
    .locals 1

    .line 103
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 96
    const/4 v0, 0x0

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pickPurpose:I

    .line 103
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    return-void
.end method

.method static synthetic access$000(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;)V
    .locals 0

    .line 84
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->confirmImport(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;)V

    return-void
.end method

.method static synthetic access$100(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;)Landroid/preference/PreferenceFragment;
    .locals 0

    .line 84
    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    return-object p0
.end method

.method static synthetic access$200(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;)I
    .locals 0

    .line 84
    iget p0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->statusGeneration:I

    return p0
.end method

.method static synthetic access$300(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;)Landroid/preference/Preference;
    .locals 0

    .line 84
    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->dictionaryStatus:Landroid/preference/Preference;

    return-object p0
.end method

.method static synthetic access$402(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;Z)Z
    .locals 0

    .line 84
    iput-boolean p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->statusLoading:Z

    return p1
.end method

.method private static boundedInt(Ljava/lang/Object;III)I
    .locals 0

    .line 465
    :try_start_0
    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p0
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    .line 466
    if-lt p0, p1, :cond_1

    if-le p0, p2, :cond_0

    goto :goto_0

    :cond_0
    move p3, p0

    :cond_1
    :goto_0
    return p3

    .line 467
    :catch_0
    move-exception p0

    .line 468
    return p3
.end method

.method private static configuredTree(Landroid/content/SharedPreferences;)Landroid/net/Uri;
    .locals 2

    .line 457
    const-string v0, "dictionary_auto_backup_tree_uri"

    const/4 v1, 0x0

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 458
    if-eqz p0, :cond_1

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 459
    :cond_0
    :try_start_0
    invoke-static {p0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    .line 460
    :catch_0
    move-exception p0

    return-object v1

    .line 458
    :cond_1
    :goto_0
    return-object v1
.end method

.method private confirmImport(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;)V
    .locals 3

    .line 354
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 355
    :cond_0
    new-instance v0, Landroid/app/AlertDialog$Builder;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v1}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v1, "\u5bfc\u5165\u7528\u6237\u8bcd\u5178\u5907\u4efd"

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "\u5c06\u300c"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v2, p1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;->name:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "\u300d\u5408\u5e76\u5230\u5f53\u524d\u7528\u6237\u8bcd\u5178\uff1f"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 356
    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$2;

    invoke-direct {v1, p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$2;-><init>(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;)V

    .line 357
    const p1, 0x104000a

    invoke-virtual {v0, p1, v1}, Landroid/app/AlertDialog$Builder;->setPositiveButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 361
    const/high16 v0, 0x1040000

    const/4 v1, 0x0

    invoke-virtual {p1, v0, v1}, Landroid/app/AlertDialog$Builder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    invoke-virtual {p1}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 362
    return-void

    .line 354
    :cond_1
    :goto_0
    return-void
.end method

.method private context()Landroid/content/Context;
    .locals 1

    .line 144
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 145
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    goto :goto_1

    .line 144
    :cond_1
    :goto_0
    const/4 v0, 0x0

    :goto_1
    return-object v0
.end method

.method private static describeTree(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;
    .locals 5

    .line 481
    const-string v0, "com.android.externalstorage.documents"

    invoke-virtual {p1}, Landroid/net/Uri;->getAuthority()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_5

    .line 483
    :try_start_0
    invoke-static {p1}, Landroid/provider/DocumentsContract;->getTreeDocumentId(Landroid/net/Uri;)Ljava/lang/String;

    move-result-object v0

    .line 484
    const/16 v2, 0x3a

    invoke-virtual {v0, v2}, Ljava/lang/String;->indexOf(I)I

    move-result v2

    .line 485
    if-gez v2, :cond_0

    move-object v3, v0

    goto :goto_0

    :cond_0
    invoke-virtual {v0, v1, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v3

    .line 486
    :goto_0
    if-ltz v2, :cond_2

    add-int/lit8 v2, v2, 0x1

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v4

    if-lt v2, v4, :cond_1

    goto :goto_1

    .line 487
    :cond_1
    invoke-virtual {v0, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v0

    goto :goto_2

    :cond_2
    :goto_1
    const-string v0, ""

    .line 488
    :goto_2
    const-string v2, "primary"

    invoke-virtual {v2, v3}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_3

    .line 489
    const-string v2, "\u5185\u90e8\u5b58\u50a8"

    goto :goto_3

    :cond_3
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "SD \u5361\uff08"

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "\uff09"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 490
    :goto_3
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v3

    if-nez v3, :cond_4

    :goto_4
    goto :goto_5

    :cond_4
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "/"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_4

    :goto_5
    return-object v2

    .line 491
    :catch_0
    move-exception v0

    .line 493
    :cond_5
    nop

    .line 495
    const/4 v0, 0x0

    :try_start_1
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object p0

    .line 496
    invoke-virtual {p1}, Landroid/net/Uri;->getAuthority()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1, v1}, Landroid/content/pm/PackageManager;->resolveContentProvider(Ljava/lang/String;I)Landroid/content/pm/ProviderInfo;

    move-result-object p1

    .line 497
    if-eqz p1, :cond_6

    .line 498
    invoke-virtual {p1, p0}, Landroid/content/pm/ProviderInfo;->loadLabel(Landroid/content/pm/PackageManager;)Ljava/lang/CharSequence;

    move-result-object p0

    .line 499
    if-eqz p0, :cond_6

    invoke-interface {p0}, Ljava/lang/CharSequence;->length()I

    move-result p1

    if-lez p1, :cond_6

    invoke-interface {p0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_1
    .catch Ljava/lang/RuntimeException; {:try_start_1 .. :try_end_1} :catch_1

    move-object v0, p0

    goto :goto_6

    .line 501
    :catch_1
    move-exception p0

    :cond_6
    :goto_6
    nop

    .line 502
    if-eqz v0, :cond_7

    return-object v0

    .line 503
    :cond_7
    const-string p0, "\u5df2\u9009\u62e9\u5907\u4efd\u76ee\u5f55"

    return-object p0
.end method

.method private loadDictionaryStatus()V
    .locals 4

    .line 424
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 425
    if-eqz v0, :cond_1

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->dictionaryStatus:Landroid/preference/Preference;

    if-eqz v1, :cond_1

    iget-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->statusLoading:Z

    if-eqz v1, :cond_0

    goto :goto_0

    .line 426
    :cond_0
    const/4 v1, 0x1

    iput-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->statusLoading:Z

    .line 427
    iget v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->statusGeneration:I

    add-int/2addr v2, v1

    iput v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->statusGeneration:I

    .line 428
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->dictionaryStatus:Landroid/preference/Preference;

    const-string v3, "\u6b63\u5728\u8bfb\u53d6\u5f53\u524d\u7528\u6237\u8bcd\u5e93\u2026\u2026"

    invoke-virtual {v1, v3}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    .line 429
    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$3;

    invoke-direct {v1, p0, v2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$3;-><init>(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;I)V

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->load(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Callback;)V

    .line 437
    return-void

    .line 425
    :cond_1
    :goto_0
    return-void
.end method

.method private openImportList()V
    .locals 3

    .line 324
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_1

    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importLoading:Z

    if-eqz v0, :cond_0

    goto :goto_0

    .line 325
    :cond_0
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importLoading:Z

    .line 326
    const/4 v0, 0x0

    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->setControlsEnabled(Z)V

    .line 327
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v1}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v1

    const-string v2, "\u6b63\u5728\u8bfb\u53d6\u5907\u4efd\u76ee\u5f55\u2026\u2026"

    invoke-static {v1, v2, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    .line 328
    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    .line 329
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    invoke-static {v0, p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->listBackupsAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupListCallback;)V

    .line 330
    return-void

    .line 324
    :cond_1
    :goto_0
    return-void
.end method

.method private openTreePicker(I)V
    .locals 3

    .line 206
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_5

    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->validating:Z

    if-nez v0, :cond_5

    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importLoading:Z

    if-eqz v0, :cond_0

    goto :goto_2

    .line 207
    :cond_0
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    const/4 v2, 0x0

    if-ge v0, v1, :cond_1

    .line 208
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {p1}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object p1

    const-string v0, "\u81ea\u5b9a\u4e49\u5907\u4efd\u76ee\u5f55\u9700\u8981 Android 5.0 \u6216\u66f4\u9ad8\u7248\u672c"

    invoke-static {p1, v0, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    .line 209
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 210
    return-void

    .line 212
    :cond_1
    iput p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pickPurpose:I

    .line 213
    new-instance p1, Landroid/content/Intent;

    const-string v0, "android.intent.action.OPEN_DOCUMENT_TREE"

    invoke-direct {p1, v0}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 214
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1a

    if-lt v0, v1, :cond_4

    .line 215
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    .line 216
    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    .line 215
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->configuredTree(Landroid/content/SharedPreferences;)Landroid/net/Uri;

    move-result-object v0

    .line 217
    if-eqz v0, :cond_2

    .line 219
    nop

    .line 220
    :try_start_0
    invoke-static {v0}, Landroid/provider/DocumentsContract;->getTreeDocumentId(Landroid/net/Uri;)Ljava/lang/String;

    move-result-object v1

    .line 219
    invoke-static {v0, v1}, Landroid/provider/DocumentsContract;->buildDocumentUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    .line 223
    goto :goto_0

    .line 221
    :catch_0
    move-exception v0

    .line 222
    const/4 v0, 0x0

    .line 225
    :cond_2
    :goto_0
    if-nez v0, :cond_3

    const-string v0, "com.android.externalstorage.documents"

    const-string v1, "primary:Documents"

    invoke-static {v0, v1}, Landroid/provider/DocumentsContract;->buildDocumentUri(Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    .line 228
    :cond_3
    const-string v1, "android.provider.extra.INITIAL_URI"

    invoke-virtual {p1, v1, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;

    .line 230
    :cond_4
    const/16 v0, 0xc3

    invoke-virtual {p1, v0}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 235
    :try_start_1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const/16 v1, 0x6b01

    invoke-virtual {v0, p1, v1}, Landroid/preference/PreferenceFragment;->startActivityForResult(Landroid/content/Intent;I)V
    :try_end_1
    .catch Ljava/lang/RuntimeException; {:try_start_1 .. :try_end_1} :catch_1

    .line 239
    goto :goto_1

    .line 236
    :catch_1
    move-exception p1

    .line 237
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {p1}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object p1

    const-string v0, "\u65e0\u6cd5\u6253\u5f00\u76ee\u5f55\u9009\u62e9\u5668"

    invoke-static {p1, v0, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    .line 238
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 240
    :goto_1
    return-void

    .line 206
    :cond_5
    :goto_2
    return-void
.end method

.method private refreshSoon()V
    .locals 2

    .line 449
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 450
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$4;

    invoke-direct {v1, p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$4;-><init>(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;)V

    invoke-virtual {v0, v1}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    .line 454
    :cond_0
    return-void
.end method

.method private static releaseGrant(Landroid/content/Context;Landroid/net/Uri;)V
    .locals 1

    .line 474
    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    const/4 v0, 0x3

    invoke-virtual {p0, p1, v0}, Landroid/content/ContentResolver;->releasePersistableUriPermission(Landroid/net/Uri;I)V
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 477
    :catch_0
    move-exception p0

    :goto_0
    nop

    .line 478
    return-void
.end method

.method private setControlsEnabled(Z)V
    .locals 1

    .line 440
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    invoke-virtual {v0, p1}, Landroid/preference/TwoStatePreference;->setEnabled(Z)V

    .line 441
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    invoke-virtual {v0, p1}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 442
    :cond_1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    invoke-virtual {v0, p1}, Landroid/preference/ListPreference;->setEnabled(Z)V

    .line 443
    :cond_2
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    if-eqz v0, :cond_3

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    invoke-virtual {v0, p1}, Landroid/preference/ListPreference;->setEnabled(Z)V

    .line 444
    :cond_3
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_4

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    invoke-virtual {v0, p1}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 445
    :cond_4
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_5

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importPreference:Landroid/preference/Preference;

    invoke-virtual {v0, p1}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 446
    :cond_5
    return-void
.end method


# virtual methods
.method bind()V
    .locals 2

    .line 106
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_current_status"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->dictionaryStatus:Landroid/preference/Preference;

    .line 107
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_auto_backup_enabled"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    check-cast v0, Landroid/preference/TwoStatePreference;

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    .line 109
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_auto_backup_location"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    .line 110
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_auto_backup_interval_days"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    check-cast v0, Landroid/preference/ListPreference;

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    .line 112
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_auto_backup_retention_count"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    check-cast v0, Landroid/preference/ListPreference;

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    .line 114
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_auto_backup_now"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    .line 115
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_auto_backup_import"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importPreference:Landroid/preference/Preference;

    .line 117
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->dictionaryStatus:Landroid/preference/Preference;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->dictionaryStatus:Landroid/preference/Preference;

    invoke-virtual {v0, p0}, Landroid/preference/Preference;->setOnPreferenceClickListener(Landroid/preference/Preference$OnPreferenceClickListener;)V

    .line 118
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    invoke-virtual {v0, p0}, Landroid/preference/TwoStatePreference;->setOnPreferenceChangeListener(Landroid/preference/Preference$OnPreferenceChangeListener;)V

    .line 119
    :cond_1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    invoke-virtual {v0, p0}, Landroid/preference/Preference;->setOnPreferenceClickListener(Landroid/preference/Preference$OnPreferenceClickListener;)V

    .line 120
    :cond_2
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    if-eqz v0, :cond_3

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    invoke-virtual {v0, p0}, Landroid/preference/ListPreference;->setOnPreferenceChangeListener(Landroid/preference/Preference$OnPreferenceChangeListener;)V

    .line 121
    :cond_3
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    if-eqz v0, :cond_4

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    invoke-virtual {v0, p0}, Landroid/preference/ListPreference;->setOnPreferenceChangeListener(Landroid/preference/Preference$OnPreferenceChangeListener;)V

    .line 122
    :cond_4
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_5

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    invoke-virtual {v0, p0}, Landroid/preference/Preference;->setOnPreferenceClickListener(Landroid/preference/Preference$OnPreferenceClickListener;)V

    .line 123
    :cond_5
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_6

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importPreference:Landroid/preference/Preference;

    invoke-virtual {v0, p0}, Landroid/preference/Preference;->setOnPreferenceClickListener(Landroid/preference/Preference$OnPreferenceClickListener;)V

    .line 124
    :cond_6
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 125
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->loadDictionaryStatus()V

    .line 126
    return-void
.end method

.method destroy()V
    .locals 1

    .line 129
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->statusGeneration:I

    add-int/lit8 v0, v0, 0x1

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->statusGeneration:I

    .line 130
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->statusLoading:Z

    .line 131
    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importLoading:Z

    .line 132
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    .line 133
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->dictionaryStatus:Landroid/preference/Preference;

    .line 134
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    .line 135
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    .line 136
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    .line 137
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    .line 138
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    .line 139
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importPreference:Landroid/preference/Preference;

    .line 140
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pendingTree:Landroid/net/Uri;

    .line 141
    return-void
.end method

.method public onBackupListLoaded(Ljava/util/List;)V
    .locals 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;",
            ">;)V"
        }
    .end annotation

    .line 334
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_3

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-nez v0, :cond_0

    goto :goto_1

    .line 335
    :cond_0
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importLoading:Z

    .line 336
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 337
    invoke-interface {p1}, Ljava/util/List;->isEmpty()Z

    move-result v1

    const/4 v2, 0x0

    if-eqz v1, :cond_1

    .line 338
    new-instance p1, Landroid/app/AlertDialog$Builder;

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    invoke-direct {p1, v0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v0, "\u6ca1\u6709\u53ef\u7528\u5907\u4efd"

    invoke-virtual {p1, v0}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 339
    const-string v0, "\u6240\u9009\u5907\u4efd\u548c\u5bfc\u5165\u76ee\u5f55\u4e2d\u6ca1\u6709 Google \u62fc\u97f3\u7528\u6237\u8bcd\u5178\u5907\u4efd\u3002"

    invoke-virtual {p1, v0}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 340
    const v0, 0x104000a

    invoke-virtual {p1, v0, v2}, Landroid/app/AlertDialog$Builder;->setPositiveButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    invoke-virtual {p1}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 341
    return-void

    .line 343
    :cond_1
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v1

    new-array v3, v1, [Ljava/lang/String;

    .line 344
    nop

    :goto_0
    if-ge v0, v1, :cond_2

    invoke-interface {p1, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;

    iget-object v4, v4, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;->name:Ljava/lang/String;

    aput-object v4, v3, v0

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 345
    :cond_2
    new-instance v0, Landroid/app/AlertDialog$Builder;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v1}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v1, "\u5bfc\u5165\u7528\u6237\u8bcd\u5178\u5907\u4efd"

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$1;

    invoke-direct {v1, p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$1;-><init>(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;Ljava/util/List;)V

    .line 346
    invoke-virtual {v0, v3, v1}, Landroid/app/AlertDialog$Builder;->setItems([Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 350
    const/high16 v0, 0x1040000

    invoke-virtual {p1, v0, v2}, Landroid/app/AlertDialog$Builder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    invoke-virtual {p1}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 351
    return-void

    .line 334
    :cond_3
    :goto_1
    return-void
.end method

.method public onPreferenceChange(Landroid/preference/Preference;Ljava/lang/Object;)Z
    .locals 5

    .line 170
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 171
    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 172
    :cond_0
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v2

    .line 173
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    const/4 v4, 0x1

    if-ne p1, v3, :cond_4

    .line 174
    sget-object p1, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {p1, p2}, Ljava/lang/Boolean;->equals(Ljava/lang/Object;)Z

    move-result p1

    .line 175
    const-string p2, "dictionary_auto_backup_enabled"

    if-nez p1, :cond_1

    .line 176
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1, p2, v1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 177
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refreshSoon()V

    .line 178
    return v4

    .line 180
    :cond_1
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->configuredTree(Landroid/content/SharedPreferences;)Landroid/net/Uri;

    move-result-object p1

    .line 181
    if-eqz p1, :cond_3

    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->hasPersistedAccess(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result p1

    if-nez p1, :cond_2

    goto :goto_0

    .line 185
    :cond_2
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1, p2, v4}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 186
    invoke-static {v0, v4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->request(Landroid/content/Context;Z)V

    .line 187
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refreshSoon()V

    .line 188
    return v4

    .line 182
    :cond_3
    :goto_0
    invoke-direct {p0, v4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->openTreePicker(I)V

    .line 183
    return v1

    .line 190
    :cond_4
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    if-ne p1, v0, :cond_5

    .line 191
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 192
    const/16 v0, 0x16d

    const/4 v1, 0x7

    invoke-static {p2, v4, v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->boundedInt(Ljava/lang/Object;III)I

    move-result p2

    .line 191
    const-string v0, "dictionary_auto_backup_interval_days"

    invoke-interface {p1, v0, p2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 192
    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 193
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refreshSoon()V

    .line 194
    return v4

    .line 196
    :cond_5
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    if-ne p1, v0, :cond_6

    .line 197
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 198
    const/16 v0, 0x64

    const/16 v1, 0xa

    invoke-static {p2, v4, v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->boundedInt(Ljava/lang/Object;III)I

    move-result p2

    .line 197
    const-string v0, "dictionary_auto_backup_retention_count"

    invoke-interface {p1, v0, p2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 198
    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 199
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refreshSoon()V

    .line 200
    return v4

    .line 202
    :cond_6
    return v1
.end method

.method public onPreferenceClick(Landroid/preference/Preference;)Z
    .locals 3

    .line 149
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 150
    const/4 v1, 0x1

    if-nez v0, :cond_0

    return v1

    .line 151
    :cond_0
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->dictionaryStatus:Landroid/preference/Preference;

    if-ne p1, v2, :cond_1

    .line 152
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->loadDictionaryStatus()V

    goto :goto_1

    .line 153
    :cond_1
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    if-ne p1, v2, :cond_2

    .line 154
    const/4 p1, 0x0

    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->openTreePicker(I)V

    goto :goto_1

    .line 155
    :cond_2
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    if-ne p1, v2, :cond_3

    .line 156
    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->request(Landroid/content/Context;Z)V

    goto :goto_1

    .line 157
    :cond_3
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importPreference:Landroid/preference/Preference;

    if-ne p1, v2, :cond_6

    .line 158
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p1

    .line 159
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->configuredTree(Landroid/content/SharedPreferences;)Landroid/net/Uri;

    move-result-object p1

    .line 160
    if-eqz p1, :cond_5

    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->hasPersistedAccess(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result p1

    if-nez p1, :cond_4

    goto :goto_0

    .line 163
    :cond_4
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->openImportList()V

    goto :goto_1

    .line 161
    :cond_5
    :goto_0
    const/4 p1, 0x2

    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->openTreePicker(I)V

    .line 166
    :cond_6
    :goto_1
    return v1
.end method

.method onTreeResult(ILandroid/content/Intent;)V
    .locals 4

    .line 243
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-nez v0, :cond_0

    return-void

    .line 244
    :cond_0
    const/4 v0, -0x1

    const/4 v1, 0x0

    if-ne p1, v0, :cond_5

    if-eqz p2, :cond_5

    invoke-virtual {p2}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object p1

    if-nez p1, :cond_1

    goto :goto_0

    .line 249
    :cond_1
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object p1

    .line 250
    if-nez p1, :cond_2

    return-void

    .line 251
    :cond_2
    invoke-virtual {p2}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object v0

    .line 252
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->isSupportedTree(Landroid/net/Uri;)Z

    move-result v2

    const/4 v3, 0x1

    if-nez v2, :cond_3

    .line 253
    const-string p2, "\u6240\u9009\u4f4d\u7f6e\u4e0d\u662f\u53ef\u6301\u4e45\u6388\u6743\u7684\u7cfb\u7edf\u6587\u6863\u76ee\u5f55"

    invoke-static {p1, p2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    .line 254
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 255
    iput v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pickPurpose:I

    .line 256
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 257
    return-void

    .line 259
    :cond_3
    invoke-virtual {p2}, Landroid/content/Intent;->getFlags()I

    move-result p2

    const/4 v2, 0x3

    and-int/2addr p2, v2

    .line 262
    if-eq p2, v2, :cond_4

    .line 264
    const-string p2, "\u6240\u9009\u76ee\u5f55\u6ca1\u6709\u6388\u4e88\u5b8c\u6574\u8bfb\u5199\u6743\u9650"

    invoke-static {p1, p2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 265
    iput v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pickPurpose:I

    .line 266
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 267
    return-void

    .line 270
    :cond_4
    :try_start_0
    invoke-virtual {p1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    invoke-virtual {v2, v0, p2}, Landroid/content/ContentResolver;->takePersistableUriPermission(Landroid/net/Uri;I)V
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    .line 276
    nop

    .line 277
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pendingTree:Landroid/net/Uri;

    .line 278
    iput-boolean v3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->validating:Z

    .line 279
    invoke-direct {p0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->setControlsEnabled(Z)V

    .line 280
    const-string p2, "\u6b63\u5728\u9a8c\u8bc1\u5907\u4efd\u76ee\u5f55\u2026\u2026"

    invoke-static {p1, p2, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p2

    invoke-virtual {p2}, Landroid/widget/Toast;->show()V

    .line 281
    invoke-static {p1, v0, p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->validateTreeAsync(Landroid/content/Context;Landroid/net/Uri;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ValidationCallback;)V

    .line 282
    return-void

    .line 271
    :catch_0
    move-exception p2

    .line 272
    const-string p2, "\u65e0\u6cd5\u4fdd\u5b58\u6240\u9009\u76ee\u5f55\u7684\u8bbf\u95ee\u6743\u9650"

    invoke-static {p1, p2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 273
    iput v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pickPurpose:I

    .line 274
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 275
    return-void

    .line 245
    :cond_5
    :goto_0
    iput v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pickPurpose:I

    .line 246
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 247
    return-void
.end method

.method public onValidationFinished(Landroid/net/Uri;Ljava/lang/String;)V
    .locals 10

    .line 285
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 286
    if-nez v0, :cond_0

    return-void

    .line 287
    :cond_0
    const/4 v1, 0x0

    iput-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->validating:Z

    .line 288
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pendingTree:Landroid/net/Uri;

    if-eqz v2, :cond_8

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pendingTree:Landroid/net/Uri;

    invoke-virtual {v2, p1}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_1

    goto/16 :goto_3

    .line 292
    :cond_1
    const/4 v2, 0x0

    iput-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pendingTree:Landroid/net/Uri;

    .line 293
    iget v3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pickPurpose:I

    .line 294
    iput v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pickPurpose:I

    .line 295
    const/4 v4, 0x1

    if-eqz p2, :cond_2

    .line 296
    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->releaseGrant(Landroid/content/Context;Landroid/net/Uri;)V

    .line 297
    invoke-static {v0, p2, v4}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 298
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 299
    return-void

    .line 302
    :cond_2
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p2

    .line 303
    const-string v5, "dictionary_auto_backup_tree_uri"

    invoke-interface {p2, v5, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 304
    const-string v6, "dictionary_auto_backup_enabled"

    if-eq v3, v4, :cond_4

    .line 305
    invoke-interface {p2, v6, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v7

    if-eqz v7, :cond_3

    goto :goto_0

    :cond_3
    const/4 v7, 0x0

    goto :goto_1

    :cond_4
    :goto_0
    const/4 v7, 0x1

    .line 306
    :goto_1
    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->describeTree(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;

    move-result-object v8

    .line 307
    invoke-interface {p2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    invoke-virtual {p1}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-interface {p2, v5, v9}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 308
    const-string v5, "dictionary_auto_backup_tree_label"

    invoke-interface {p2, v5, v8}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 309
    invoke-interface {p2, v6, v7}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 310
    const-string v5, "dictionary_auto_backup_last_status"

    const-string v6, "\u5907\u4efd\u76ee\u5f55\u9a8c\u8bc1\u6210\u529f"

    invoke-interface {p2, v5, v6}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 311
    invoke-interface {p2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 313
    if-eqz v2, :cond_5

    invoke-virtual {p1}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_5

    .line 314
    :try_start_0
    invoke-static {v2}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->releaseGrant(Landroid/content/Context;Landroid/net/Uri;)V
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_2

    .line 315
    :catch_0
    move-exception p1

    :goto_2
    nop

    .line 317
    :cond_5
    const-string p1, "\u5907\u4efd\u548c\u5bfc\u5165\u76ee\u5f55\u5df2\u8bbe\u7f6e"

    invoke-static {v0, p1, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 318
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 319
    const/4 p1, 0x2

    if-ne v3, p1, :cond_6

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->openImportList()V

    .line 320
    :cond_6
    if-eqz v7, :cond_7

    invoke-static {v0, v4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->request(Landroid/content/Context;Z)V

    .line 321
    :cond_7
    return-void

    .line 289
    :cond_8
    :goto_3
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 290
    return-void
.end method

.method refresh()V
    .locals 17

    .line 365
    move-object/from16 v0, p0

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v1

    .line 366
    if-nez v1, :cond_0

    return-void

    .line 367
    :cond_0
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v2

    .line 368
    sget v3, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v4, 0x15

    const/4 v5, 0x1

    const/4 v6, 0x0

    if-lt v3, v4, :cond_1

    const/4 v3, 0x1

    goto :goto_0

    :cond_1
    const/4 v3, 0x0

    .line 369
    :goto_0
    const-string v4, "dictionary_auto_backup_enabled"

    invoke-interface {v2, v4, v6}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v4

    .line 370
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->configuredTree(Landroid/content/SharedPreferences;)Landroid/net/Uri;

    move-result-object v7

    .line 371
    if-eqz v7, :cond_2

    .line 372
    invoke-static {v1, v7}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->hasPersistedAccess(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result v8

    if-eqz v8, :cond_2

    const/4 v8, 0x1

    goto :goto_1

    :cond_2
    const/4 v8, 0x0

    .line 373
    :goto_1
    iget-boolean v9, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->validating:Z

    if-nez v9, :cond_4

    iget-boolean v9, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importLoading:Z

    if-eqz v9, :cond_3

    goto :goto_2

    :cond_3
    const/4 v9, 0x0

    goto :goto_3

    :cond_4
    :goto_2
    const/4 v9, 0x1

    .line 375
    :goto_3
    iget-object v10, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    const/4 v11, 0x0

    if-eqz v10, :cond_9

    .line 376
    iget-object v10, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    invoke-virtual {v10, v4}, Landroid/preference/TwoStatePreference;->setChecked(Z)V

    .line 377
    const-string v10, "dictionary_auto_backup_last_status"

    invoke-interface {v2, v10, v11}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    .line 378
    const-string v12, "dictionary_auto_backup_last_success_time"

    const-wide/16 v13, 0x0

    invoke-interface {v2, v12, v13, v14}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v15

    .line 379
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->isInProgress()Z

    move-result v12

    if-eqz v12, :cond_5

    .line 380
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    const-string v10, "\u6b63\u5728\u751f\u6210\u7528\u6237\u8bcd\u5178\u5907\u4efd\u2026\u2026"

    invoke-virtual {v1, v10}, Landroid/preference/TwoStatePreference;->setSummary(Ljava/lang/CharSequence;)V

    goto :goto_4

    .line 381
    :cond_5
    if-eqz v10, :cond_6

    invoke-virtual {v10}, Ljava/lang/String;->length()I

    move-result v12

    if-lez v12, :cond_6

    const-string v12, "\u5907\u4efd\u6210\u529f"

    invoke-virtual {v12, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v12

    if-nez v12, :cond_6

    .line 382
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    invoke-virtual {v1, v10}, Landroid/preference/TwoStatePreference;->setSummary(Ljava/lang/CharSequence;)V

    goto :goto_4

    .line 383
    :cond_6
    cmp-long v10, v15, v13

    if-lez v10, :cond_7

    .line 384
    iget-object v10, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    new-instance v12, Ljava/lang/StringBuilder;

    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V

    const-string v13, "\u4e0a\u6b21\u5907\u4efd\uff1a"

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v12

    .line 385
    invoke-static {v1}, Landroid/text/format/DateFormat;->getDateFormat(Landroid/content/Context;)Ljava/text/DateFormat;

    move-result-object v13

    invoke-static/range {v15 .. v16}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v14

    invoke-virtual {v13, v14}, Ljava/text/DateFormat;->format(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v13

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v12

    const-string v13, " "

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v12

    .line 386
    invoke-static {v1}, Landroid/text/format/DateFormat;->getTimeFormat(Landroid/content/Context;)Ljava/text/DateFormat;

    move-result-object v1

    invoke-static/range {v15 .. v16}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v13

    invoke-virtual {v1, v13}, Ljava/text/DateFormat;->format(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v12, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 384
    invoke-virtual {v10, v1}, Landroid/preference/TwoStatePreference;->setSummary(Ljava/lang/CharSequence;)V

    goto :goto_4

    .line 388
    :cond_7
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    const-string v10, "\u5907\u4efd\u6587\u4ef6\u5728\u6e05\u9664\u6570\u636e\u6216\u5378\u8f7d\u540e\u4ecd\u4f1a\u4fdd\u7559"

    invoke-virtual {v1, v10}, Landroid/preference/TwoStatePreference;->setSummary(Ljava/lang/CharSequence;)V

    .line 390
    :goto_4
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    if-eqz v3, :cond_8

    if-nez v9, :cond_8

    const/4 v10, 0x1

    goto :goto_5

    :cond_8
    const/4 v10, 0x0

    :goto_5
    invoke-virtual {v1, v10}, Landroid/preference/TwoStatePreference;->setEnabled(Z)V

    .line 392
    :cond_9
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    if-eqz v1, :cond_f

    .line 393
    const-string v1, "dictionary_auto_backup_tree_label"

    invoke-interface {v2, v1, v11}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 394
    if-nez v7, :cond_a

    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    const-string v7, "\u672a\u9009\u62e9\uff08\u5907\u4efd\u548c\u5bfc\u5165\u5171\u7528\uff09"

    invoke-virtual {v1, v7}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    goto :goto_8

    .line 395
    :cond_a
    if-nez v8, :cond_b

    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    const-string v7, "\u4f4d\u7f6e\u4e0d\u53ef\u8bbf\u95ee\uff0c\u8bf7\u91cd\u65b0\u9009\u62e9"

    invoke-virtual {v1, v7}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    goto :goto_8

    .line 396
    :cond_b
    iget-object v7, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    if-eqz v1, :cond_d

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v10

    if-nez v10, :cond_c

    goto :goto_6

    .line 397
    :cond_c
    goto :goto_7

    :cond_d
    :goto_6
    const-string v1, "\u5df2\u9009\u62e9\u5907\u4efd\u76ee\u5f55"

    .line 396
    :goto_7
    invoke-virtual {v7, v1}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    .line 398
    :goto_8
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    if-eqz v3, :cond_e

    if-nez v9, :cond_e

    const/4 v7, 0x1

    goto :goto_9

    :cond_e
    const/4 v7, 0x0

    :goto_9
    invoke-virtual {v1, v7}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 400
    :cond_f
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    if-eqz v1, :cond_11

    .line 401
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    const-string v7, "dictionary_auto_backup_interval_days"

    const/4 v10, 0x7

    invoke-interface {v2, v7, v10}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v7

    invoke-static {v7}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v1, v7}, Landroid/preference/ListPreference;->setValue(Ljava/lang/String;)V

    .line 403
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    if-eqz v4, :cond_10

    if-eqz v8, :cond_10

    if-nez v9, :cond_10

    const/4 v7, 0x1

    goto :goto_a

    :cond_10
    const/4 v7, 0x0

    :goto_a
    invoke-virtual {v1, v7}, Landroid/preference/ListPreference;->setEnabled(Z)V

    .line 405
    :cond_11
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    if-eqz v1, :cond_13

    .line 406
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    const-string v7, "dictionary_auto_backup_retention_count"

    const/16 v10, 0xa

    invoke-interface {v2, v7, v10}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v2

    invoke-static {v2}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Landroid/preference/ListPreference;->setValue(Ljava/lang/String;)V

    .line 408
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    if-eqz v4, :cond_12

    if-eqz v8, :cond_12

    if-nez v9, :cond_12

    const/4 v2, 0x1

    goto :goto_b

    :cond_12
    const/4 v2, 0x0

    :goto_b
    invoke-virtual {v1, v2}, Landroid/preference/ListPreference;->setEnabled(Z)V

    .line 410
    :cond_13
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    if-eqz v1, :cond_16

    .line 411
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    if-eqz v8, :cond_14

    if-nez v9, :cond_14

    .line 412
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->isInProgress()Z

    move-result v2

    if-nez v2, :cond_14

    const/4 v2, 0x1

    goto :goto_c

    :cond_14
    const/4 v2, 0x0

    .line 411
    :goto_c
    invoke-virtual {v1, v2}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 413
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    if-eqz v8, :cond_15

    .line 414
    const-string v2, "\u7acb\u5373\u5bfc\u51fa\u5230\u6240\u9009\u76ee\u5f55"

    goto :goto_d

    :cond_15
    const-string v2, "\u8bf7\u5148\u9009\u62e9\u5907\u4efd\u548c\u5bfc\u5165\u76ee\u5f55"

    .line 413
    :goto_d
    invoke-virtual {v1, v2}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    .line 416
    :cond_16
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importPreference:Landroid/preference/Preference;

    if-eqz v1, :cond_19

    .line 417
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importPreference:Landroid/preference/Preference;

    if-eqz v3, :cond_17

    if-nez v9, :cond_17

    goto :goto_e

    :cond_17
    const/4 v5, 0x0

    :goto_e
    invoke-virtual {v1, v5}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 418
    iget-object v1, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importPreference:Landroid/preference/Preference;

    if-eqz v8, :cond_18

    .line 419
    const-string v2, "\u5217\u51fa\u6240\u9009\u76ee\u5f55\u4e2d\u7684\u7528\u6237\u8bcd\u5178\u5907\u4efd"

    goto :goto_f

    :cond_18
    const-string v2, "\u9009\u62e9\u5df2\u6709\u5907\u4efd\u76ee\u5f55\u5e76\u5bfc\u5165"

    .line 418
    :goto_f
    invoke-virtual {v1, v2}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    .line 421
    :cond_19
    return-void
.end method
