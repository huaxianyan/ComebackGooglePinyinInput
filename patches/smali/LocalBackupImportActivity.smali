.class public final Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;
.super Landroid/app/Activity;
.source "LocalBackupImportActivity.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupListCallback;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 19
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    return-void
.end method

.method static synthetic access$000(Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;Landroid/net/Uri;Ljava/lang/String;)V
    .locals 0

    .line 19
    invoke-direct {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;->confirm(Landroid/net/Uri;Ljava/lang/String;)V

    return-void
.end method

.method static synthetic access$100(Landroid/content/Context;Landroid/net/Uri;)[B
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 19
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;->readAll(Landroid/content/Context;Landroid/net/Uri;)[B

    move-result-object p0

    return-object p0
.end method

.method private confirm(Landroid/net/Uri;Ljava/lang/String;)V
    .locals 3

    .line 71
    new-instance v0, Landroid/app/AlertDialog$Builder;

    invoke-direct {v0, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v1, "\u5bfc\u5165\u7528\u6237\u8bcd\u5178\u5907\u4efd"

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "\u5c06\u300c"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string v1, "\u300d\u5408\u5e76\u5230\u5f53\u524d\u7528\u6237\u8bcd\u5178\uff1f"

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 72
    invoke-virtual {v0, p2}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p2

    new-instance v0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$8;

    invoke-direct {v0, p0, p1}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$8;-><init>(Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;Landroid/net/Uri;)V

    .line 73
    const p1, 0x104000a

    invoke-virtual {p2, p1, v0}, Landroid/app/AlertDialog$Builder;->setPositiveButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    new-instance p2, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$7;

    invoke-direct {p2, p0}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$7;-><init>(Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;)V

    .line 77
    const/high16 v0, 0x1040000

    invoke-virtual {p1, v0, p2}, Landroid/app/AlertDialog$Builder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    new-instance p2, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$6;

    invoke-direct {p2, p0}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$6;-><init>(Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;)V

    .line 79
    invoke-virtual {p1, p2}, Landroid/app/AlertDialog$Builder;->setOnCancelListener(Landroid/content/DialogInterface$OnCancelListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 81
    invoke-virtual {p1}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 82
    return-void
.end method

.method private incomingUri(Landroid/content/Intent;)Landroid/net/Uri;
    .locals 3

    .line 29
    const/4 v0, 0x0

    if-nez p1, :cond_0

    return-object v0

    .line 30
    :cond_0
    const-string v1, "android.intent.action.VIEW"

    invoke-virtual {p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-virtual {p1}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object p1

    return-object p1

    .line 31
    :cond_1
    const-string v1, "android.intent.action.SEND"

    invoke-virtual {p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_3

    .line 32
    const-string v1, "android.intent.extra.STREAM"

    invoke-virtual {p1, v1}, Landroid/content/Intent;->getParcelableExtra(Ljava/lang/String;)Landroid/os/Parcelable;

    move-result-object p1

    .line 33
    instance-of v1, p1, Landroid/net/Uri;

    if-eqz v1, :cond_2

    move-object v0, p1

    check-cast v0, Landroid/net/Uri;

    :cond_2
    return-object v0

    .line 35
    :cond_3
    return-object v0
.end method

.method private static readAll(Landroid/content/Context;Landroid/net/Uri;)[B
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 116
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object p0

    .line 117
    if-eqz p0, :cond_1

    .line 119
    :try_start_0
    new-instance p1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {p1}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 120
    const/16 v0, 0x2000

    new-array v0, v0, [B

    .line 122
    :goto_0
    invoke-virtual {p0, v0}, Ljava/io/InputStream;->read([B)I

    move-result v1

    const/4 v2, -0x1

    if-eq v1, v2, :cond_0

    const/4 v2, 0x0

    invoke-virtual {p1, v0, v2, v1}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_0

    .line 123
    :cond_0
    invoke-virtual {p1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 125
    invoke-virtual {p0}, Ljava/io/InputStream;->close()V

    .line 123
    return-object p1

    .line 125
    :catchall_0
    move-exception p1

    invoke-virtual {p0}, Ljava/io/InputStream;->close()V

    .line 126
    throw p1

    .line 117
    :cond_1
    new-instance p0, Ljava/io/IOException;

    const-string p1, "backup cannot be opened"

    invoke-direct {p0, p1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    goto :goto_2

    :goto_1
    throw p0

    :goto_2
    goto :goto_1
.end method

.method private showBackups()V
    .locals 2

    .line 39
    const-string v0, "\u6b63\u5728\u8bfb\u53d6\u5907\u4efd\u76ee\u5f55\u2026\u2026"

    const/4 v1, 0x0

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    .line 40
    invoke-static {p0, p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->listBackupsAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupListCallback;)V

    .line 41
    return-void
.end method

.method public static startNativeImport(Landroid/content/Context;Landroid/net/Uri;)Z
    .locals 2

    .line 85
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    .line 86
    const-string v0, "\u6b63\u5728\u5bfc\u5165\u7528\u6237\u8bcd\u5178\u5907\u4efd"

    const/4 v1, 0x0

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    .line 87
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9;

    invoke-direct {v1, p0, p1}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$9;-><init>(Landroid/content/Context;Landroid/net/Uri;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 111
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    .line 112
    const/4 p0, 0x1

    return p0
.end method


# virtual methods
.method public onBackupListLoaded(Ljava/util/List;)V
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;",
            ">;)V"
        }
    .end annotation

    .line 45
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;->isFinishing()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 46
    :cond_0
    invoke-interface {p1}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 47
    new-instance p1, Landroid/app/AlertDialog$Builder;

    invoke-direct {p1, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v0, "\u6ca1\u6709\u53ef\u8bbf\u95ee\u7684\u7528\u6237\u8bcd\u5178\u5907\u4efd"

    invoke-virtual {p1, v0}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 48
    const-string v0, "\u5c1a\u672a\u8bbe\u7f6e\u5907\u4efd\u548c\u5bfc\u5165\u76ee\u5f55\uff0c\u6216\u6240\u9009\u76ee\u5f55\u4e2d\u6ca1\u6709 Google \u62fc\u97f3\u7528\u6237\u8bcd\u5178\u5907\u4efd\u3002\u8bf7\u5728\u5b57\u5178\u8bbe\u7f6e\u4e2d\u9009\u62e9\u5df2\u6709\u5907\u4efd\u76ee\u5f55\uff0c\u4e5f\u53ef\u4ee5\u4ece\u6587\u4ef6\u7ba1\u7406\u5668\u6253\u5f00\u6216\u5206\u4eab\u5907\u4efd .txt\u3002"

    invoke-virtual {p1, v0}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    new-instance v0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$2;

    invoke-direct {v0, p0}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$2;-><init>(Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;)V

    .line 49
    const v1, 0x104000a

    invoke-virtual {p1, v1, v0}, Landroid/app/AlertDialog$Builder;->setPositiveButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    new-instance v0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$1;

    invoke-direct {v0, p0}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$1;-><init>(Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;)V

    .line 51
    invoke-virtual {p1, v0}, Landroid/app/AlertDialog$Builder;->setOnCancelListener(Landroid/content/DialogInterface$OnCancelListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 53
    invoke-virtual {p1}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 54
    return-void

    .line 56
    :cond_1
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v0

    new-array v1, v0, [Ljava/lang/String;

    .line 57
    const/4 v2, 0x0

    :goto_0
    if-ge v2, v0, :cond_2

    invoke-interface {p1, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;

    iget-object v3, v3, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;->name:Ljava/lang/String;

    aput-object v3, v1, v2

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 58
    :cond_2
    new-instance v0, Landroid/app/AlertDialog$Builder;

    invoke-direct {v0, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v2, "\u5bfc\u5165\u7528\u6237\u8bcd\u5178\u5907\u4efd"

    invoke-virtual {v0, v2}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    new-instance v2, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$5;

    invoke-direct {v2, p0, p1}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$5;-><init>(Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;Ljava/util/List;)V

    .line 59
    invoke-virtual {v0, v1, v2}, Landroid/app/AlertDialog$Builder;->setItems([Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    new-instance v0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$4;

    invoke-direct {v0, p0}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$4;-><init>(Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;)V

    .line 63
    const/high16 v1, 0x1040000

    invoke-virtual {p1, v1, v0}, Landroid/app/AlertDialog$Builder;->setNegativeButton(ILandroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    new-instance v0, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$3;

    invoke-direct {v0, p0}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$3;-><init>(Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;)V

    .line 65
    invoke-virtual {p1, v0}, Landroid/app/AlertDialog$Builder;->setOnCancelListener(Landroid/content/DialogInterface$OnCancelListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 67
    invoke-virtual {p1}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 68
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 1

    .line 22
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    .line 23
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;->getIntent()Landroid/content/Intent;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;->incomingUri(Landroid/content/Intent;)Landroid/net/Uri;

    move-result-object p1

    .line 24
    if-eqz p1, :cond_0

    const-string v0, "\u6240\u9009\u7528\u6237\u8bcd\u5178\u5907\u4efd"

    invoke-direct {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;->confirm(Landroid/net/Uri;Ljava/lang/String;)V

    goto :goto_0

    .line 25
    :cond_0
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;->showBackups()V

    .line 26
    :goto_0
    return-void
.end method
