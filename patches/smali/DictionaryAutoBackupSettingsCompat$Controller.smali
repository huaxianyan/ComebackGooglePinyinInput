.class final Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupSettingsCompat.java"

# interfaces
.implements Landroid/preference/Preference$OnPreferenceClickListener;
.implements Landroid/preference/Preference$OnPreferenceChangeListener;
.implements Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ValidationCallback;


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
    .registers 3

    .line 102
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 96
    const/4 v0, 0x0

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pickPurpose:I

    .line 102
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    return-void
.end method

.method static synthetic access$000(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;)V
    .registers 2

    .line 85
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->confirmImport(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;)V

    return-void
.end method

.method static synthetic access$100(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;)Landroid/preference/PreferenceFragment;
    .registers 1

    .line 85
    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    return-object p0
.end method

.method static synthetic access$200(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;)I
    .registers 1

    .line 85
    iget p0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->statusGeneration:I

    return p0
.end method

.method static synthetic access$300(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;)Landroid/preference/Preference;
    .registers 1

    .line 85
    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->dictionaryStatus:Landroid/preference/Preference;

    return-object p0
.end method

.method static synthetic access$402(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;Z)Z
    .registers 2

    .line 85
    iput-boolean p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->statusLoading:Z

    return p1
.end method

.method private static boundedInt(Ljava/lang/Object;III)I
    .registers 4

    .line 452
    :try_start_0
    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p0
    :try_end_8
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_8} :catch_f

    .line 453
    if-lt p0, p1, :cond_e

    if-le p0, p2, :cond_d

    goto :goto_e

    :cond_d
    move p3, p0

    :cond_e
    :goto_e
    return p3

    .line 454
    :catch_f
    move-exception p0

    .line 455
    return p3
.end method

.method private static configuredTree(Landroid/content/SharedPreferences;)Landroid/net/Uri;
    .registers 3

    .line 444
    const-string v0, "dictionary_auto_backup_tree_uri"

    const/4 v1, 0x0

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 445
    if-eqz p0, :cond_17

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    if-nez v0, :cond_10

    goto :goto_17

    .line 446
    :cond_10
    :try_start_10
    invoke-static {p0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p0
    :try_end_14
    .catch Ljava/lang/RuntimeException; {:try_start_10 .. :try_end_14} :catch_15

    return-object p0

    .line 447
    :catch_15
    move-exception p0

    return-object v1

    .line 445
    :cond_17
    :goto_17
    return-object v1
.end method

.method private confirmImport(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;)V
    .registers 5

    .line 342
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_54

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-nez v0, :cond_d

    goto :goto_54

    .line 343
    :cond_d
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

    const-string v2, "\u5c06\u201c"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v2, p1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;->name:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "\u201d\u5408\u5e76\u5230\u5f53\u524d\u7528\u6237\u8bcd\u5178\uff1f"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 344
    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$2;

    invoke-direct {v1, p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$2;-><init>(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;)V

    .line 345
    const p1, 0x104000a

    invoke-virtual {v0, p1, v1}, Landroid/app/AlertDialog$Builder;->setPositiveButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 349
    const/high16 v0, 0x1040000

    const/4 v1, 0x0

    invoke-virtual {p1, v0, v1}, Landroid/app/AlertDialog$Builder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    invoke-virtual {p1}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 350
    return-void

    .line 342
    :cond_54
    :goto_54
    return-void
.end method

.method private context()Landroid/content/Context;
    .registers 2

    .line 142
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_18

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-nez v0, :cond_d

    goto :goto_18

    .line 143
    :cond_d
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    goto :goto_19

    .line 142
    :cond_18
    :goto_18
    const/4 v0, 0x0

    :goto_19
    return-object v0
.end method

.method private static describeTree(Landroid/content/ContentResolver;Landroid/net/Uri;)Ljava/lang/String;
    .registers 12

    .line 469
    const/4 v1, 0x1

    const/4 v2, 0x0

    :try_start_2
    invoke-static {p1}, Landroid/provider/DocumentsContract;->getTreeDocumentId(Landroid/net/Uri;)Ljava/lang/String;

    move-result-object v0

    .line 470
    const/16 v3, 0x3a

    invoke-virtual {v0, v3}, Ljava/lang/String;->indexOf(I)I

    move-result v3

    .line 471
    if-gez v3, :cond_10

    move-object v4, v0

    goto :goto_14

    :cond_10
    invoke-virtual {v0, v2, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v4

    .line 472
    :goto_14
    if-ltz v3, :cond_23

    add-int/2addr v3, v1

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v5

    if-lt v3, v5, :cond_1e

    goto :goto_23

    :cond_1e
    invoke-virtual {v0, v3}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v0

    goto :goto_25

    :cond_23
    :goto_23
    const-string v0, ""

    .line 473
    :goto_25
    const-string v3, "primary"

    invoke-virtual {v3, v4}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_30

    .line 474
    const-string v3, "\u5185\u90e8\u5b58\u50a8"

    goto :goto_49

    :cond_30
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "SD \u5361\uff08"

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, "\uff09"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 475
    :goto_49
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v4

    if-nez v4, :cond_50

    :goto_4f
    goto :goto_68

    :cond_50
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, "/"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3
    :try_end_67
    .catch Ljava/lang/RuntimeException; {:try_start_2 .. :try_end_67} :catch_69

    goto :goto_4f

    :goto_68
    return-object v3

    .line 476
    :catch_69
    move-exception v0

    .line 477
    nop

    .line 479
    const/4 v3, 0x0

    :try_start_6c
    new-array v6, v1, [Ljava/lang/String;

    const-string v0, "_display_name"

    aput-object v0, v6, v2

    const/4 v8, 0x0

    const/4 v9, 0x0

    const/4 v7, 0x0

    move-object v4, p0

    move-object v5, p1

    invoke-virtual/range {v4 .. v9}, Landroid/content/ContentResolver;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v3

    .line 481
    if-eqz v3, :cond_95

    invoke-interface {v3}, Landroid/database/Cursor;->moveToFirst()Z

    move-result p0

    if-eqz p0, :cond_95

    .line 482
    invoke-interface {v3, v2}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object p0

    .line 483
    if-eqz p0, :cond_95

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p1
    :try_end_8d
    .catch Ljava/lang/RuntimeException; {:try_start_6c .. :try_end_8d} :catch_9b
    .catchall {:try_start_6c .. :try_end_8d} :catchall_98

    if-lez p1, :cond_95

    .line 487
    if-eqz v3, :cond_94

    invoke-interface {v3}, Landroid/database/Cursor;->close()V

    .line 483
    :cond_94
    return-object p0

    .line 487
    :cond_95
    if-eqz v3, :cond_a8

    goto :goto_a5

    :catchall_98
    move-exception v0

    move-object p0, v0

    goto :goto_9d

    .line 485
    :catch_9b
    move-exception v0

    goto :goto_a3

    .line 487
    :goto_9d
    if-eqz v3, :cond_a2

    invoke-interface {v3}, Landroid/database/Cursor;->close()V

    .line 488
    :cond_a2
    throw p0

    .line 487
    :goto_a3
    if-eqz v3, :cond_a8

    :goto_a5
    invoke-interface {v3}, Landroid/database/Cursor;->close()V

    .line 489
    :cond_a8
    const-string p0, "\u8bbe\u5907\u672c\u5730\u5907\u4efd\u76ee\u5f55"

    return-object p0
.end method

.method private loadDictionaryStatus()V
    .registers 5

    .line 411
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 412
    if-eqz v0, :cond_27

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->dictionaryStatus:Landroid/preference/Preference;

    if-eqz v1, :cond_27

    iget-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->statusLoading:Z

    if-eqz v1, :cond_f

    goto :goto_27

    .line 413
    :cond_f
    const/4 v1, 0x1

    iput-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->statusLoading:Z

    .line 414
    iget v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->statusGeneration:I

    add-int/2addr v2, v1

    iput v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->statusGeneration:I

    .line 415
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->dictionaryStatus:Landroid/preference/Preference;

    const-string v3, "\u6b63\u5728\u8bfb\u53d6\u5f53\u524d\u7528\u6237\u8bcd\u5e93\u2026"

    invoke-virtual {v1, v3}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    .line 416
    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$3;

    invoke-direct {v1, p0, v2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$3;-><init>(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;I)V

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;->load(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Callback;)V

    .line 424
    return-void

    .line 412
    :cond_27
    :goto_27
    return-void
.end method

.method private openImportList()V
    .registers 7

    .line 322
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_7a

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-nez v0, :cond_d

    goto :goto_7a

    .line 323
    :cond_d
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    .line 324
    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->listBackups(Landroid/content/Context;)Ljava/util/List;

    move-result-object v0

    .line 325
    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v1

    const/4 v2, 0x0

    if-eqz v1, :cond_40

    .line 326
    new-instance v0, Landroid/app/AlertDialog$Builder;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v1}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v1, "\u6ca1\u6709\u672c\u5730\u5907\u4efd"

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    .line 327
    const-string v1, "\u6240\u9009\u5907\u4efd\u548c\u5bfc\u5165\u76ee\u5f55\u4e2d\u6ca1\u6709 Google \u62fc\u97f3\u7528\u6237\u8bcd\u5178\u5907\u4efd\u3002"

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    .line 328
    const v1, 0x104000a

    invoke-virtual {v0, v1, v2}, Landroid/app/AlertDialog$Builder;->setPositiveButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 329
    return-void

    .line 331
    :cond_40
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v1

    new-array v3, v1, [Ljava/lang/String;

    .line 332
    const/4 v4, 0x0

    :goto_47
    if-ge v4, v1, :cond_56

    invoke-interface {v0, v4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;

    iget-object v5, v5, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;->name:Ljava/lang/String;

    aput-object v5, v3, v4

    add-int/lit8 v4, v4, 0x1

    goto :goto_47

    .line 333
    :cond_56
    new-instance v1, Landroid/app/AlertDialog$Builder;

    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v4}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v4

    invoke-direct {v1, v4}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v4, "\u5bfc\u5165\u672c\u5730\u5907\u4efd"

    invoke-virtual {v1, v4}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v1

    new-instance v4, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$1;

    invoke-direct {v4, p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$1;-><init>(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;Ljava/util/List;)V

    .line 334
    invoke-virtual {v1, v3, v4}, Landroid/app/AlertDialog$Builder;->setItems([Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    .line 338
    const/high16 v1, 0x1040000

    invoke-virtual {v0, v1, v2}, Landroid/app/AlertDialog$Builder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 339
    return-void

    .line 322
    :cond_7a
    :goto_7a
    return-void
.end method

.method private openTreePicker(I)V
    .registers 5

    .line 204
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_7c

    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->validating:Z

    if-eqz v0, :cond_9

    goto :goto_7c

    .line 205
    :cond_9
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    const/4 v2, 0x0

    if-ge v0, v1, :cond_20

    .line 206
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {p1}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object p1

    const-string v0, "\u81ea\u5b9a\u4e49\u5907\u4efd\u76ee\u5f55\u9700\u8981 Android 5.0 \u6216\u66f4\u9ad8\u7248\u672c"

    invoke-static {p1, v0, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    .line 207
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 208
    return-void

    .line 210
    :cond_20
    iput p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pickPurpose:I

    .line 211
    new-instance p1, Landroid/content/Intent;

    const-string v0, "android.intent.action.OPEN_DOCUMENT_TREE"

    invoke-direct {p1, v0}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 212
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1a

    if-lt v0, v1, :cond_5e

    .line 213
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    .line 214
    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/Activity;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    .line 213
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->configuredTree(Landroid/content/SharedPreferences;)Landroid/net/Uri;

    move-result-object v0

    .line 215
    if-eqz v0, :cond_4f

    .line 217
    nop

    .line 218
    :try_start_44
    invoke-static {v0}, Landroid/provider/DocumentsContract;->getTreeDocumentId(Landroid/net/Uri;)Ljava/lang/String;

    move-result-object v1

    .line 217
    invoke-static {v0, v1}, Landroid/provider/DocumentsContract;->buildDocumentUriUsingTree(Landroid/net/Uri;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0
    :try_end_4c
    .catch Ljava/lang/RuntimeException; {:try_start_44 .. :try_end_4c} :catch_4d

    .line 221
    goto :goto_4f

    .line 219
    :catch_4d
    move-exception v0

    .line 220
    const/4 v0, 0x0

    .line 223
    :cond_4f
    :goto_4f
    if-nez v0, :cond_59

    const-string v0, "com.android.externalstorage.documents"

    const-string v1, "primary:Documents"

    invoke-static {v0, v1}, Landroid/provider/DocumentsContract;->buildDocumentUri(Ljava/lang/String;Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    .line 226
    :cond_59
    const-string v1, "android.provider.extra.INITIAL_URI"

    invoke-virtual {p1, v1, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Landroid/os/Parcelable;)Landroid/content/Intent;

    .line 228
    :cond_5e
    const/16 v0, 0xc3

    invoke-virtual {p1, v0}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 233
    :try_start_63
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const/16 v1, 0x6b01

    invoke-virtual {v0, p1, v1}, Landroid/preference/PreferenceFragment;->startActivityForResult(Landroid/content/Intent;I)V
    :try_end_6a
    .catch Ljava/lang/RuntimeException; {:try_start_63 .. :try_end_6a} :catch_6b

    .line 237
    goto :goto_7b

    .line 234
    :catch_6b
    move-exception p1

    .line 235
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {p1}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object p1

    const-string v0, "\u65e0\u6cd5\u6253\u5f00\u672c\u5730\u76ee\u5f55\u9009\u62e9\u5668"

    invoke-static {p1, v0, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    .line 236
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 238
    :goto_7b
    return-void

    .line 204
    :cond_7c
    :goto_7c
    return-void
.end method

.method private refreshSoon()V
    .registers 3

    .line 436
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_22

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    invoke-virtual {v0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :cond_22

    .line 437
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

    .line 441
    :cond_22
    return-void
.end method

.method private static releaseGrant(Landroid/content/Context;Landroid/net/Uri;)V
    .registers 3

    .line 461
    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    const/4 v0, 0x3

    invoke-virtual {p0, p1, v0}, Landroid/content/ContentResolver;->releasePersistableUriPermission(Landroid/net/Uri;I)V
    :try_end_8
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_8} :catch_9

    goto :goto_a

    .line 464
    :catch_9
    move-exception p0

    :goto_a
    nop

    .line 465
    return-void
.end method

.method private setControlsEnabled(Z)V
    .registers 3

    .line 427
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    if-eqz v0, :cond_9

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    invoke-virtual {v0, p1}, Landroid/preference/TwoStatePreference;->setEnabled(Z)V

    .line 428
    :cond_9
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_12

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    invoke-virtual {v0, p1}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 429
    :cond_12
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    if-eqz v0, :cond_1b

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    invoke-virtual {v0, p1}, Landroid/preference/ListPreference;->setEnabled(Z)V

    .line 430
    :cond_1b
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    if-eqz v0, :cond_24

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    invoke-virtual {v0, p1}, Landroid/preference/ListPreference;->setEnabled(Z)V

    .line 431
    :cond_24
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_2d

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    invoke-virtual {v0, p1}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 432
    :cond_2d
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_36

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importPreference:Landroid/preference/Preference;

    invoke-virtual {v0, p1}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 433
    :cond_36
    return-void
.end method


# virtual methods
.method bind()V
    .registers 3

    .line 105
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_current_status"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->dictionaryStatus:Landroid/preference/Preference;

    .line 106
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_auto_backup_enabled"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    check-cast v0, Landroid/preference/TwoStatePreference;

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    .line 108
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_auto_backup_location"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    .line 109
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_auto_backup_interval_days"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    check-cast v0, Landroid/preference/ListPreference;

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    .line 111
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_auto_backup_retention_count"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    check-cast v0, Landroid/preference/ListPreference;

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    .line 113
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_auto_backup_now"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    .line 114
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    const-string v1, "dictionary_auto_backup_import"

    invoke-virtual {v0, v1}, Landroid/preference/PreferenceFragment;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importPreference:Landroid/preference/Preference;

    .line 116
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->dictionaryStatus:Landroid/preference/Preference;

    if-eqz v0, :cond_55

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->dictionaryStatus:Landroid/preference/Preference;

    invoke-virtual {v0, p0}, Landroid/preference/Preference;->setOnPreferenceClickListener(Landroid/preference/Preference$OnPreferenceClickListener;)V

    .line 117
    :cond_55
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    if-eqz v0, :cond_5e

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    invoke-virtual {v0, p0}, Landroid/preference/TwoStatePreference;->setOnPreferenceChangeListener(Landroid/preference/Preference$OnPreferenceChangeListener;)V

    .line 118
    :cond_5e
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_67

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    invoke-virtual {v0, p0}, Landroid/preference/Preference;->setOnPreferenceClickListener(Landroid/preference/Preference$OnPreferenceClickListener;)V

    .line 119
    :cond_67
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    if-eqz v0, :cond_70

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    invoke-virtual {v0, p0}, Landroid/preference/ListPreference;->setOnPreferenceChangeListener(Landroid/preference/Preference$OnPreferenceChangeListener;)V

    .line 120
    :cond_70
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    if-eqz v0, :cond_79

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    invoke-virtual {v0, p0}, Landroid/preference/ListPreference;->setOnPreferenceChangeListener(Landroid/preference/Preference$OnPreferenceChangeListener;)V

    .line 121
    :cond_79
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_82

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    invoke-virtual {v0, p0}, Landroid/preference/Preference;->setOnPreferenceClickListener(Landroid/preference/Preference$OnPreferenceClickListener;)V

    .line 122
    :cond_82
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_8b

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importPreference:Landroid/preference/Preference;

    invoke-virtual {v0, p0}, Landroid/preference/Preference;->setOnPreferenceClickListener(Landroid/preference/Preference$OnPreferenceClickListener;)V

    .line 123
    :cond_8b
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 124
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->loadDictionaryStatus()V

    .line 125
    return-void
.end method

.method destroy()V
    .registers 2

    .line 128
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->statusGeneration:I

    add-int/lit8 v0, v0, 0x1

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->statusGeneration:I

    .line 129
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->statusLoading:Z

    .line 130
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    .line 131
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->dictionaryStatus:Landroid/preference/Preference;

    .line 132
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    .line 133
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    .line 134
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    .line 135
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    .line 136
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    .line 137
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importPreference:Landroid/preference/Preference;

    .line 138
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pendingTree:Landroid/net/Uri;

    .line 139
    return-void
.end method

.method public onPreferenceChange(Landroid/preference/Preference;Ljava/lang/Object;)Z
    .registers 8

    .line 168
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 169
    const/4 v1, 0x0

    if-nez v0, :cond_8

    return v1

    .line 170
    :cond_8
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v2

    .line 171
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    const/4 v4, 0x1

    if-ne p1, v3, :cond_4d

    .line 172
    sget-object p1, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {p1, p2}, Ljava/lang/Boolean;->equals(Ljava/lang/Object;)Z

    move-result p1

    .line 173
    const-string p2, "dictionary_auto_backup_enabled"

    if-nez p1, :cond_2a

    .line 174
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1, p2, v1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 175
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refreshSoon()V

    .line 176
    return v4

    .line 178
    :cond_2a
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->configuredTree(Landroid/content/SharedPreferences;)Landroid/net/Uri;

    move-result-object p1

    .line 179
    if-eqz p1, :cond_49

    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->hasPersistedAccess(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result p1

    if-nez p1, :cond_37

    goto :goto_49

    .line 183
    :cond_37
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1, p2, v4}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 184
    invoke-static {v0, v4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->request(Landroid/content/Context;Z)V

    .line 185
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refreshSoon()V

    .line 186
    return v4

    .line 180
    :cond_49
    :goto_49
    invoke-direct {p0, v4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->openTreePicker(I)V

    .line 181
    return v1

    .line 188
    :cond_4d
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    if-ne p1, v0, :cond_69

    .line 189
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 190
    const/16 v0, 0x16d

    const/4 v1, 0x7

    invoke-static {p2, v4, v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->boundedInt(Ljava/lang/Object;III)I

    move-result p2

    .line 189
    const-string v0, "dictionary_auto_backup_interval_days"

    invoke-interface {p1, v0, p2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 190
    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 191
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refreshSoon()V

    .line 192
    return v4

    .line 194
    :cond_69
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    if-ne p1, v0, :cond_86

    .line 195
    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 196
    const/16 v0, 0x64

    const/16 v1, 0xa

    invoke-static {p2, v4, v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->boundedInt(Ljava/lang/Object;III)I

    move-result p2

    .line 195
    const-string v0, "dictionary_auto_backup_retention_count"

    invoke-interface {p1, v0, p2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    .line 196
    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 197
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refreshSoon()V

    .line 198
    return v4

    .line 200
    :cond_86
    return v1
.end method

.method public onPreferenceClick(Landroid/preference/Preference;)Z
    .registers 5

    .line 147
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 148
    const/4 v1, 0x1

    if-nez v0, :cond_8

    return v1

    .line 149
    :cond_8
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->dictionaryStatus:Landroid/preference/Preference;

    if-ne p1, v2, :cond_10

    .line 150
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->loadDictionaryStatus()V

    goto :goto_3e

    .line 151
    :cond_10
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    if-ne p1, v2, :cond_19

    .line 152
    const/4 p1, 0x0

    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->openTreePicker(I)V

    goto :goto_3e

    .line 153
    :cond_19
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    if-ne p1, v2, :cond_21

    .line 154
    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->request(Landroid/content/Context;Z)V

    goto :goto_3e

    .line 155
    :cond_21
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importPreference:Landroid/preference/Preference;

    if-ne p1, v2, :cond_3e

    .line 156
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p1

    .line 157
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->configuredTree(Landroid/content/SharedPreferences;)Landroid/net/Uri;

    move-result-object p1

    .line 158
    if-eqz p1, :cond_3a

    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->hasPersistedAccess(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result p1

    if-nez p1, :cond_36

    goto :goto_3a

    .line 161
    :cond_36
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->openImportList()V

    goto :goto_3e

    .line 159
    :cond_3a
    :goto_3a
    const/4 p1, 0x2

    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->openTreePicker(I)V

    .line 164
    :cond_3e
    :goto_3e
    return v1
.end method

.method onTreeResult(ILandroid/content/Intent;)V
    .registers 7

    .line 241
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-nez v0, :cond_5

    return-void

    .line 242
    :cond_5
    const/4 v0, -0x1

    const/4 v1, 0x0

    if-ne p1, v0, :cond_76

    if-eqz p2, :cond_76

    invoke-virtual {p2}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object p1

    if-nez p1, :cond_12

    goto :goto_76

    .line 247
    :cond_12
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object p1

    .line 248
    if-nez p1, :cond_19

    return-void

    .line 249
    :cond_19
    invoke-virtual {p2}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object v0

    .line 250
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->isLocalTree(Landroid/net/Uri;)Z

    move-result v2

    const/4 v3, 0x1

    if-nez v2, :cond_33

    .line 251
    const-string p2, "\u8bf7\u9009\u62e9\u8bbe\u5907\u5185\u90e8\u5b58\u50a8\u6216\u672c\u673a SD \u5361\u76ee\u5f55\uff0c\u4e0d\u652f\u6301\u4e91\u7aef\u4f4d\u7f6e"

    invoke-static {p1, p2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    .line 252
    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 253
    iput v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pickPurpose:I

    .line 254
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 255
    return-void

    .line 257
    :cond_33
    invoke-virtual {p2}, Landroid/content/Intent;->getFlags()I

    move-result p2

    const/4 v2, 0x3

    and-int/2addr p2, v2

    .line 260
    if-eq p2, v2, :cond_4a

    .line 262
    const-string p2, "\u6240\u9009\u76ee\u5f55\u6ca1\u6709\u6388\u4e88\u5b8c\u6574\u8bfb\u5199\u6743\u9650"

    invoke-static {p1, p2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 263
    iput v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pickPurpose:I

    .line 264
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 265
    return-void

    .line 268
    :cond_4a
    :try_start_4a
    invoke-virtual {p1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v2

    invoke-virtual {v2, v0, p2}, Landroid/content/ContentResolver;->takePersistableUriPermission(Landroid/net/Uri;I)V
    :try_end_51
    .catch Ljava/lang/RuntimeException; {:try_start_4a .. :try_end_51} :catch_66

    .line 274
    nop

    .line 275
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pendingTree:Landroid/net/Uri;

    .line 276
    iput-boolean v3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->validating:Z

    .line 277
    invoke-direct {p0, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->setControlsEnabled(Z)V

    .line 278
    const-string p2, "\u6b63\u5728\u9a8c\u8bc1\u672c\u5730\u5907\u4efd\u76ee\u5f55\u2026"

    invoke-static {p1, p2, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p2

    invoke-virtual {p2}, Landroid/widget/Toast;->show()V

    .line 279
    invoke-static {p1, v0, p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->validateTreeAsync(Landroid/content/Context;Landroid/net/Uri;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ValidationCallback;)V

    .line 280
    return-void

    .line 269
    :catch_66
    move-exception p2

    .line 270
    const-string p2, "\u65e0\u6cd5\u4fdd\u5b58\u672c\u5730\u76ee\u5f55\u8bbf\u95ee\u6743\u9650"

    invoke-static {p1, p2, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 271
    iput v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pickPurpose:I

    .line 272
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 273
    return-void

    .line 243
    :cond_76
    :goto_76
    iput v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pickPurpose:I

    .line 244
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 245
    return-void
.end method

.method public onValidationFinished(Landroid/net/Uri;Ljava/lang/String;)V
    .registers 13

    .line 283
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 284
    if-nez v0, :cond_7

    return-void

    .line 285
    :cond_7
    const/4 v1, 0x0

    iput-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->validating:Z

    .line 286
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pendingTree:Landroid/net/Uri;

    if-eqz v2, :cond_9f

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pendingTree:Landroid/net/Uri;

    invoke-virtual {v2, p1}, Landroid/net/Uri;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_18

    goto/16 :goto_9f

    .line 290
    :cond_18
    const/4 v2, 0x0

    iput-object v2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pendingTree:Landroid/net/Uri;

    .line 291
    iget v3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pickPurpose:I

    .line 292
    iput v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->pickPurpose:I

    .line 293
    const/4 v4, 0x1

    if-eqz p2, :cond_30

    .line 294
    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->releaseGrant(Landroid/content/Context;Landroid/net/Uri;)V

    .line 295
    invoke-static {v0, p2, v4}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 296
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 297
    return-void

    .line 300
    :cond_30
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p2

    .line 301
    const-string v5, "dictionary_auto_backup_tree_uri"

    invoke-interface {p2, v5, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 302
    const-string v6, "dictionary_auto_backup_enabled"

    if-eq v3, v4, :cond_47

    .line 303
    invoke-interface {p2, v6, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v7

    if-eqz v7, :cond_45

    goto :goto_47

    :cond_45
    const/4 v7, 0x0

    goto :goto_48

    :cond_47
    :goto_47
    const/4 v7, 0x1

    .line 304
    :goto_48
    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v8

    invoke-static {v8, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->describeTree(Landroid/content/ContentResolver;Landroid/net/Uri;)Ljava/lang/String;

    move-result-object v8

    .line 305
    invoke-interface {p2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    invoke-virtual {p1}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-interface {p2, v5, v9}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 306
    const-string v5, "dictionary_auto_backup_tree_label"

    invoke-interface {p2, v5, v8}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 307
    invoke-interface {p2, v6, v7}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 308
    const-string v5, "dictionary_auto_backup_last_status"

    const-string v6, "\u672c\u5730\u76ee\u5f55\u9a8c\u8bc1\u6210\u529f"

    invoke-interface {p2, v5, v6}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 309
    invoke-interface {p2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 311
    if-eqz v2, :cond_87

    invoke-virtual {p1}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_87

    .line 312
    :try_start_7d
    invoke-static {v2}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p1

    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->releaseGrant(Landroid/content/Context;Landroid/net/Uri;)V
    :try_end_84
    .catch Ljava/lang/RuntimeException; {:try_start_7d .. :try_end_84} :catch_85

    goto :goto_86

    .line 313
    :catch_85
    move-exception p1

    :goto_86
    nop

    .line 315
    :cond_87
    const-string p1, "\u5907\u4efd\u548c\u5bfc\u5165\u76ee\u5f55\u5df2\u8bbe\u7f6e"

    invoke-static {v0, p1, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 316
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 317
    const/4 p1, 0x2

    if-ne v3, p1, :cond_99

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->openImportList()V

    .line 318
    :cond_99
    if-eqz v7, :cond_9e

    invoke-static {v0, v4}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->request(Landroid/content/Context;Z)V

    .line 319
    :cond_9e
    return-void

    .line 287
    :cond_9f
    :goto_9f
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 288
    return-void
.end method

.method refresh()V
    .registers 16

    .line 353
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->context()Landroid/content/Context;

    move-result-object v0

    .line 354
    if-nez v0, :cond_7

    return-void

    .line 355
    :cond_7
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->prefs(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v1

    .line 356
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x15

    const/4 v4, 0x1

    const/4 v5, 0x0

    if-lt v2, v3, :cond_15

    const/4 v2, 0x1

    goto :goto_16

    :cond_15
    const/4 v2, 0x0

    .line 357
    :goto_16
    const-string v3, "dictionary_auto_backup_enabled"

    invoke-interface {v1, v3, v5}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v3

    .line 358
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->configuredTree(Landroid/content/SharedPreferences;)Landroid/net/Uri;

    move-result-object v6

    .line 359
    if-eqz v6, :cond_2a

    .line 360
    invoke-static {v0, v6}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->hasPersistedAccess(Landroid/content/Context;Landroid/net/Uri;)Z

    move-result v7

    if-eqz v7, :cond_2a

    const/4 v7, 0x1

    goto :goto_2b

    :cond_2a
    const/4 v7, 0x0

    .line 362
    :goto_2b
    iget-object v8, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    const/4 v9, 0x0

    if-eqz v8, :cond_bb

    .line 363
    iget-object v8, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    invoke-virtual {v8, v3}, Landroid/preference/TwoStatePreference;->setChecked(Z)V

    .line 364
    const-string v8, "dictionary_auto_backup_last_status"

    invoke-interface {v1, v8, v9}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    .line 365
    const-string v10, "dictionary_auto_backup_last_success_time"

    const-wide/16 v11, 0x0

    invoke-interface {v1, v10, v11, v12}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v13

    .line 366
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->isInProgress()Z

    move-result v10

    if-eqz v10, :cond_51

    .line 367
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    const-string v8, "\u6b63\u5728\u751f\u6210\u672c\u5730\u5907\u4efd\u2026"

    invoke-virtual {v0, v8}, Landroid/preference/TwoStatePreference;->setSummary(Ljava/lang/CharSequence;)V

    goto :goto_ad

    .line 368
    :cond_51
    if-eqz v8, :cond_67

    invoke-virtual {v8}, Ljava/lang/String;->length()I

    move-result v10

    if-lez v10, :cond_67

    const-string v10, "\u5907\u4efd\u6210\u529f"

    invoke-virtual {v10, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v10

    if-nez v10, :cond_67

    .line 369
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    invoke-virtual {v0, v8}, Landroid/preference/TwoStatePreference;->setSummary(Ljava/lang/CharSequence;)V

    goto :goto_ad

    .line 370
    :cond_67
    cmp-long v8, v13, v11

    if-lez v8, :cond_a6

    .line 371
    iget-object v8, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    const-string v11, "\u4e0a\u6b21\u5907\u4efd\uff1a"

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    .line 372
    invoke-static {v0}, Landroid/text/format/DateFormat;->getDateFormat(Landroid/content/Context;)Ljava/text/DateFormat;

    move-result-object v11

    invoke-static {v13, v14}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v12

    invoke-virtual {v11, v12}, Ljava/text/DateFormat;->format(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    const-string v11, " "

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    .line 373
    invoke-static {v0}, Landroid/text/format/DateFormat;->getTimeFormat(Landroid/content/Context;)Ljava/text/DateFormat;

    move-result-object v0

    invoke-static {v13, v14}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v11

    invoke-virtual {v0, v11}, Ljava/text/DateFormat;->format(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v10, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 371
    invoke-virtual {v8, v0}, Landroid/preference/TwoStatePreference;->setSummary(Ljava/lang/CharSequence;)V

    goto :goto_ad

    .line 375
    :cond_a6
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    const-string v8, "\u5907\u4efd\u6587\u4ef6\u5728\u6e05\u9664\u6570\u636e\u6216\u5378\u8f7d\u540e\u4ecd\u4f1a\u4fdd\u7559"

    invoke-virtual {v0, v8}, Landroid/preference/TwoStatePreference;->setSummary(Ljava/lang/CharSequence;)V

    .line 377
    :goto_ad
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->enabledPreference:Landroid/preference/TwoStatePreference;

    if-eqz v2, :cond_b7

    iget-boolean v8, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->validating:Z

    if-nez v8, :cond_b7

    const/4 v8, 0x1

    goto :goto_b8

    :cond_b7
    const/4 v8, 0x0

    :goto_b8
    invoke-virtual {v0, v8}, Landroid/preference/TwoStatePreference;->setEnabled(Z)V

    .line 379
    :cond_bb
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_f8

    .line 380
    const-string v0, "dictionary_auto_backup_tree_label"

    invoke-interface {v1, v0, v9}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 381
    if-nez v6, :cond_cf

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    const-string v6, "\u672a\u9009\u62e9\uff08\u5907\u4efd\u548c\u5bfc\u5165\u5171\u7528\uff09"

    invoke-virtual {v0, v6}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    goto :goto_ea

    .line 382
    :cond_cf
    if-nez v7, :cond_d9

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    const-string v6, "\u4f4d\u7f6e\u4e0d\u53ef\u8bbf\u95ee\uff0c\u8bf7\u91cd\u65b0\u9009\u62e9"

    invoke-virtual {v0, v6}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    goto :goto_ea

    .line 383
    :cond_d9
    iget-object v6, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_e5

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v8

    if-nez v8, :cond_e4

    goto :goto_e5

    .line 384
    :cond_e4
    goto :goto_e7

    :cond_e5
    :goto_e5
    const-string v0, "\u5df2\u9009\u62e9\u8bbe\u5907\u672c\u5730\u76ee\u5f55"

    .line 383
    :goto_e7
    invoke-virtual {v6, v0}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    .line 385
    :goto_ea
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->locationPreference:Landroid/preference/Preference;

    if-eqz v2, :cond_f4

    iget-boolean v6, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->validating:Z

    if-nez v6, :cond_f4

    const/4 v6, 0x1

    goto :goto_f5

    :cond_f4
    const/4 v6, 0x0

    :goto_f5
    invoke-virtual {v0, v6}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 387
    :cond_f8
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    if-eqz v0, :cond_11c

    .line 388
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    const-string v6, "dictionary_auto_backup_interval_days"

    const/4 v8, 0x7

    invoke-interface {v1, v6, v8}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v6

    invoke-static {v6}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v0, v6}, Landroid/preference/ListPreference;->setValue(Ljava/lang/String;)V

    .line 390
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->intervalPreference:Landroid/preference/ListPreference;

    if-eqz v3, :cond_118

    if-eqz v7, :cond_118

    iget-boolean v6, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->validating:Z

    if-nez v6, :cond_118

    const/4 v6, 0x1

    goto :goto_119

    :cond_118
    const/4 v6, 0x0

    :goto_119
    invoke-virtual {v0, v6}, Landroid/preference/ListPreference;->setEnabled(Z)V

    .line 392
    :cond_11c
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    if-eqz v0, :cond_141

    .line 393
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    const-string v6, "dictionary_auto_backup_retention_count"

    const/16 v8, 0xa

    invoke-interface {v1, v6, v8}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v1

    invoke-static {v1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/preference/ListPreference;->setValue(Ljava/lang/String;)V

    .line 395
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->retentionPreference:Landroid/preference/ListPreference;

    if-eqz v3, :cond_13d

    if-eqz v7, :cond_13d

    iget-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->validating:Z

    if-nez v1, :cond_13d

    const/4 v1, 0x1

    goto :goto_13e

    :cond_13d
    const/4 v1, 0x0

    :goto_13e
    invoke-virtual {v0, v1}, Landroid/preference/ListPreference;->setEnabled(Z)V

    .line 397
    :cond_141
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_165

    .line 398
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    if-eqz v7, :cond_155

    iget-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->validating:Z

    if-nez v1, :cond_155

    .line 399
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->isInProgress()Z

    move-result v1

    if-nez v1, :cond_155

    const/4 v1, 0x1

    goto :goto_156

    :cond_155
    const/4 v1, 0x0

    .line 398
    :goto_156
    invoke-virtual {v0, v1}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 400
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->backupNowPreference:Landroid/preference/Preference;

    if-eqz v7, :cond_160

    .line 401
    const-string v1, "\u7acb\u5373\u5bfc\u51fa\u5230\u6240\u9009\u672c\u5730\u76ee\u5f55"

    goto :goto_162

    :cond_160
    const-string v1, "\u8bf7\u5148\u9009\u62e9\u5907\u4efd\u548c\u5bfc\u5165\u76ee\u5f55"

    .line 400
    :goto_162
    invoke-virtual {v0, v1}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    .line 403
    :cond_165
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importPreference:Landroid/preference/Preference;

    if-eqz v0, :cond_182

    .line 404
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importPreference:Landroid/preference/Preference;

    if-eqz v2, :cond_172

    iget-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->validating:Z

    if-nez v1, :cond_172

    goto :goto_173

    :cond_172
    const/4 v4, 0x0

    :goto_173
    invoke-virtual {v0, v4}, Landroid/preference/Preference;->setEnabled(Z)V

    .line 405
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->importPreference:Landroid/preference/Preference;

    if-eqz v7, :cond_17d

    .line 406
    const-string v1, "\u5217\u51fa\u6240\u9009\u76ee\u5f55\u4e2d\u7684\u672c\u5730\u5907\u4efd"

    goto :goto_17f

    :cond_17d
    const-string v1, "\u9009\u62e9\u5df2\u6709\u5907\u4efd\u76ee\u5f55\u5e76\u5bfc\u5165"

    .line 405
    :goto_17f
    invoke-virtual {v0, v1}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    .line 408
    :cond_182
    return-void
.end method
