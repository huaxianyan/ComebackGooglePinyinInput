.class Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;
.super Ljava/lang/Object;
.source "DictionarySafetyGuard.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->request(Landroid/content/Context;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$app:Landroid/content/Context;

.field final synthetic val$kind:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

.field final synthetic val$store:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 127
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$store:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$app:Landroid/content/Context;

    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$kind:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 10

    .line 129
    const-string v0, "worker-finished"

    const-string v1, "count-collapsed"

    const-string v2, "file-collapsed"

    const-string v3, ""

    const-string v4, "last_check_at"

    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$store:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    invoke-virtual {v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v5

    invoke-interface {v5}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v5

    .line 130
    const-string v6, "last_debug"

    const-string v7, "worker-started"

    invoke-interface {v5, v6, v7}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v5

    .line 131
    invoke-interface {v5}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 133
    :try_start_0
    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$app:Landroid/content/Context;

    iget-object v7, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$store:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    iget-object v8, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$kind:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    invoke-static {v5, v7, v8}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->access$000(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 137
    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$store:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    invoke-virtual {v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v5

    invoke-interface {v5}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v5

    .line 139
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v7

    .line 138
    invoke-interface {v5, v4, v7, v8}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    .line 140
    invoke-interface {v4}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 143
    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$store:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    invoke-virtual {v4}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v4

    invoke-interface {v4, v6, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 145
    invoke-virtual {v3, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_0

    .line 146
    invoke-virtual {v3, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_0

    .line 147
    :goto_0
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$store:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 148
    invoke-interface {v1, v6, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 149
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 151
    :cond_0
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->access$200()Ljava/util/Map;

    move-result-object v0

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$kind:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    invoke-interface {v0, v1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 152
    goto :goto_1

    .line 134
    :catchall_0
    move-exception v5

    .line 135
    :try_start_1
    iget-object v7, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$store:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    const-string v9, "\u68c0\u67e5\u672a\u5b8c\u6210\uff1a"

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v8

    invoke-virtual {v5}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v8, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v7, v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->access$100(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 137
    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$store:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    invoke-virtual {v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v5

    invoke-interface {v5}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v5

    .line 139
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v7

    .line 138
    invoke-interface {v5, v4, v7, v8}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    .line 140
    invoke-interface {v4}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 143
    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$store:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    invoke-virtual {v4}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v4

    invoke-interface {v4, v6, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 145
    invoke-virtual {v3, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_0

    .line 146
    invoke-virtual {v3, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_0

    .line 147
    goto :goto_0

    .line 153
    :goto_1
    return-void

    .line 137
    :catchall_1
    move-exception v5

    iget-object v7, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$store:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    invoke-virtual {v7}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v7

    invoke-interface {v7}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v7

    .line 139
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v8

    .line 138
    invoke-interface {v7, v4, v8, v9}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    .line 140
    invoke-interface {v4}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 143
    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$store:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    invoke-virtual {v4}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v4

    invoke-interface {v4, v6, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 145
    invoke-virtual {v3, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_1

    .line 146
    invoke-virtual {v3, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_1

    .line 147
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$store:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 148
    invoke-interface {v1, v6, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 149
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 151
    :cond_1
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->access$200()Ljava/util/Map;

    move-result-object v0

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$kind:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    invoke-interface {v0, v1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 152
    goto :goto_3

    :goto_2
    throw v5

    :goto_3
    goto :goto_2
.end method
