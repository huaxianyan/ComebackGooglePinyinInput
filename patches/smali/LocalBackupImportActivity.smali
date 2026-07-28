.class public final Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;
.super Landroid/app/Activity;
.source "LocalBackupImportActivity.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupListCallback;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$ImportListener;
    }
.end annotation


# direct methods
.method public constructor <init>()V
    .registers 1

    .line 19
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    return-void
.end method

.method static synthetic access$000(Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;Landroid/net/Uri;Ljava/lang/String;)V
    .registers 3

    .line 19
    invoke-direct {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;->confirm(Landroid/net/Uri;Ljava/lang/String;)V

    return-void
.end method

.method private confirm(Landroid/net/Uri;Ljava/lang/String;)V
    .registers 6

    .line 71
    new-instance v0, Landroid/app/AlertDialog$Builder;

    invoke-direct {v0, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v1, "\u5bfc\u5165\u7528\u6237\u8bcd\u5178\u5907\u4efd"

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "\u5c06\u201c"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string v1, "\u201d\u5408\u5e76\u5230\u5f53\u524d\u7528\u6237\u8bcd\u5178\uff1f"

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
    .registers 5

    .line 29
    const/4 v0, 0x0

    if-nez p1, :cond_4

    return-object v0

    .line 30
    :cond_4
    const-string v1, "android.intent.action.VIEW"

    invoke-virtual {p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_15

    invoke-virtual {p1}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object p1

    return-object p1

    .line 31
    :cond_15
    const-string v1, "android.intent.action.SEND"

    invoke-virtual {p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2f

    .line 32
    const-string v1, "android.intent.extra.STREAM"

    invoke-virtual {p1, v1}, Landroid/content/Intent;->getParcelableExtra(Ljava/lang/String;)Landroid/os/Parcelable;

    move-result-object p1

    .line 33
    instance-of v1, p1, Landroid/net/Uri;

    if-eqz v1, :cond_2e

    move-object v0, p1

    check-cast v0, Landroid/net/Uri;

    :cond_2e
    return-object v0

    .line 35
    :cond_2f
    return-object v0
.end method

.method private showBackups()V
    .registers 3

    .line 39
    const-string v0, "\u6b63\u5728\u8bfb\u53d6\u5907\u4efd\u76ee\u5f55\u2026"

    const/4 v1, 0x0

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    .line 40
    invoke-static {p0, p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;->listBackupsAsync(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupListCallback;)V

    .line 41
    return-void
.end method

.method static startNativeImport(Landroid/content/Context;Landroid/net/Uri;)Z
    .registers 13

    .line 85
    const-string v0, "a"

    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    .line 87
    const/4 v1, 0x1

    const/4 v2, 0x0

    :try_start_8
    const-string v3, "aib"

    invoke-static {v3}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v3

    .line 88
    new-array v4, v2, [Ljava/lang/Class;

    invoke-virtual {v3, v0, v4}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v4

    new-array v5, v2, [Ljava/lang/Object;

    const/4 v6, 0x0

    invoke-virtual {v4, v6, v5}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    .line 89
    const-string v5, "com.google.android.apps.inputmethod.libs.framework.core.TaskFactory"

    invoke-static {v5}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v5

    .line 91
    const-string v6, "beh"

    invoke-static {v6}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v6

    const/4 v7, 0x3

    new-array v8, v7, [Ljava/lang/Class;

    const-class v9, Landroid/content/Context;

    aput-object v9, v8, v2

    const-class v9, Lcom/google/android/apps/inputmethod/libs/framework/core/TaskListener;

    aput-object v9, v8, v1

    const-class v9, Landroid/net/Uri;

    const/4 v10, 0x2

    aput-object v9, v8, v10

    invoke-virtual {v6, v8}, Ljava/lang/Class;->getConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object v6

    .line 93
    new-instance v8, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$ImportListener;

    invoke-direct {v8, p0}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity$ImportListener;-><init>(Landroid/content/Context;)V

    new-array v9, v7, [Ljava/lang/Object;

    aput-object p0, v9, v2

    aput-object v8, v9, v1

    aput-object p1, v9, v10

    invoke-virtual {v6, v9}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    .line 94
    new-array v6, v7, [Ljava/lang/Class;

    const-class v8, Ljava/lang/String;

    aput-object v8, v6, v2

    aput-object v5, v6, v1

    sget-object v5, Ljava/lang/Long;->TYPE:Ljava/lang/Class;

    aput-object v5, v6, v10

    invoke-virtual {v3, v0, v6}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    .line 95
    const-wide/16 v5, 0x0

    invoke-static {v5, v6}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v3

    new-array v5, v7, [Ljava/lang/Object;

    const-string v6, "user_dict_import"

    aput-object v6, v5, v2

    aput-object p1, v5, v1

    aput-object v3, v5, v10

    invoke-virtual {v0, v4, v5}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 96
    const-string p1, "\u6b63\u5728\u5bfc\u5165\u7528\u6237\u8bcd\u5178\u5907\u4efd"

    invoke-static {p0, p1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V
    :try_end_78
    .catchall {:try_start_8 .. :try_end_78} :catchall_79

    .line 97
    return v1

    .line 98
    :catchall_79
    move-exception p1

    .line 99
    const-string p1, "\u65e0\u6cd5\u542f\u52a8\u539f\u751f\u7528\u6237\u8bcd\u5178\u5bfc\u5165"

    invoke-static {p0, p1, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    .line 100
    return v2
.end method


# virtual methods
.method public onBackupListLoaded(Ljava/util/List;)V
    .registers 6
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

    if-eqz v0, :cond_7

    return-void

    .line 46
    :cond_7
    invoke-interface {p1}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_37

    .line 47
    new-instance p1, Landroid/app/AlertDialog$Builder;

    invoke-direct {p1, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v0, "\u6ca1\u6709\u53ef\u8bbf\u95ee\u7684\u7528\u6237\u8bcd\u5178\u5907\u4efd"

    invoke-virtual {p1, v0}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 48
    const-string v0, "\u5c1a\u672a\u8bbe\u7f6e\u5907\u4efd\u548c\u5bfc\u5165\u76ee\u5f55\uff0c\u6216\u6240\u9009\u76ee\u5f55\u4e2d\u6ca1\u6709 Google \u62fc\u97f3\u7528\u6237\u8bcd\u5178\u5907\u4efd\u3002\u8bf7\u5728\u5b57\u5178\u8bbe\u7f6e\u4e2d\u9009\u62e9\u5df2\u6709\u5907\u4efd\u76ee\u5f55\uff1b\u4e5f\u53ef\u4ee5\u4ece\u6587\u4ef6\u7ba1\u7406\u5668\u6253\u5f00\u6216\u5206\u4eab\u5907\u4efd .txt\u3002"

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
    :cond_37
    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result v0

    new-array v1, v0, [Ljava/lang/String;

    .line 57
    const/4 v2, 0x0

    :goto_3e
    if-ge v2, v0, :cond_4d

    invoke-interface {p1, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;

    iget-object v3, v3, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$BackupEntry;->name:Ljava/lang/String;

    aput-object v3, v1, v2

    add-int/lit8 v2, v2, 0x1

    goto :goto_3e

    .line 58
    :cond_4d
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
    .registers 3

    .line 22
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    .line 23
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;->getIntent()Landroid/content/Intent;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;->incomingUri(Landroid/content/Intent;)Landroid/net/Uri;

    move-result-object p1

    .line 24
    if-eqz p1, :cond_13

    const-string v0, "\u6240\u9009\u7528\u6237\u8bcd\u5178\u5907\u4efd"

    invoke-direct {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;->confirm(Landroid/net/Uri;Ljava/lang/String;)V

    goto :goto_16

    .line 25
    :cond_13
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/LocalBackupImportActivity;->showBackups()V

    .line 26
    :goto_16
    return-void
.end method
