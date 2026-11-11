.class public final Lcom/google/android/inputmethod/pinyin/NativeProbeActivity;
.super Landroid/app/Activity;
.source "NativeProbeActivity.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 14
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    return-void
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 4

    .line 17
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    .line 18
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/NativeProbeActivity;->getIntent()Landroid/content/Intent;

    move-result-object p1

    if-nez p1, :cond_0

    const/4 p1, 0x0

    goto :goto_0

    :cond_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/NativeProbeActivity;->getIntent()Landroid/content/Intent;

    move-result-object p1

    invoke-virtual {p1}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object p1

    .line 19
    :goto_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/NativeProbeActivity;->getIntent()Landroid/content/Intent;

    move-result-object v0

    if-eqz v0, :cond_1

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/NativeProbeActivity;->getIntent()Landroid/content/Intent;

    move-result-object v0

    const-string v1, "damage_keep"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->hasExtra(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 20
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/NativeProbeActivity;->getIntent()Landroid/content/Intent;

    move-result-object v0

    const-wide/16 v2, 0x0

    invoke-virtual {v0, v1, v2, v3}, Landroid/content/Intent;->getLongExtra(Ljava/lang/String;J)J

    move-result-wide v0

    invoke-static {p0, p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/NativeImportProbe;->runDamage(Landroid/content/Context;Landroid/net/Uri;J)V

    goto :goto_1

    .line 21
    :cond_1
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/NativeProbeActivity;->getIntent()Landroid/content/Intent;

    move-result-object v0

    const/4 v1, 0x0

    if-eqz v0, :cond_2

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/NativeProbeActivity;->getIntent()Landroid/content/Intent;

    move-result-object v0

    const-string v2, "task_probe"

    invoke-virtual {v0, v2, v1}, Landroid/content/Intent;->getBooleanExtra(Ljava/lang/String;Z)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 22
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/NativeImportProbe;->runTask(Landroid/content/Context;Landroid/net/Uri;)V

    goto :goto_1

    .line 23
    :cond_2
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/NativeProbeActivity;->getIntent()Landroid/content/Intent;

    move-result-object v0

    if-eqz v0, :cond_3

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/NativeProbeActivity;->getIntent()Landroid/content/Intent;

    move-result-object v0

    const-string v2, "refresh_probe"

    invoke-virtual {v0, v2, v1}, Landroid/content/Intent;->getBooleanExtra(Ljava/lang/String;Z)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 24
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/NativeImportProbe;->runRefresh(Landroid/content/Context;Landroid/net/Uri;)V

    goto :goto_1

    .line 26
    :cond_3
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/NativeImportProbe;->run(Landroid/content/Context;Landroid/net/Uri;)V

    .line 28
    :goto_1
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/NativeProbeActivity;->finish()V

    .line 29
    return-void
.end method
