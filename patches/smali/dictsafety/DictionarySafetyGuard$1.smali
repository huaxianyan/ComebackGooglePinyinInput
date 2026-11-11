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

    .line 80
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$store:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$app:Landroid/content/Context;

    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$kind:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 7

    .line 82
    const-string v0, "worker-finished"

    const-string v1, "last_check_at"

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$store:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v2

    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    .line 83
    const-string v3, "last_debug"

    const-string v4, "worker-started"

    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    .line 84
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 86
    :try_start_0
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$app:Landroid/content/Context;

    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$store:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$kind:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    invoke-static {v2, v4, v5}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->access$000(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 90
    :goto_0
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$store:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v2

    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    .line 92
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v4

    .line 91
    invoke-interface {v2, v1, v4, v5}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 93
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 94
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$store:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 95
    invoke-interface {v1, v3, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 96
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 97
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->access$200()Ljava/util/Map;

    move-result-object v0

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$kind:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    invoke-interface {v0, v1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 98
    goto :goto_1

    .line 87
    :catchall_0
    move-exception v2

    .line 88
    :try_start_1
    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$store:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "\u68c0\u67e5\u672a\u5b8c\u6210\uff1a"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v4, v2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->access$100(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;Ljava/lang/String;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    goto :goto_0

    .line 99
    :goto_1
    return-void

    .line 90
    :catchall_1
    move-exception v2

    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$store:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    invoke-virtual {v4}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v4

    invoke-interface {v4}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    .line 92
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v5

    .line 91
    invoke-interface {v4, v1, v5, v6}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 93
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 94
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$store:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;->preferences()Landroid/content/SharedPreferences;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 95
    invoke-interface {v1, v3, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 96
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 97
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard;->access$200()Ljava/util/Map;

    move-result-object v0

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyGuard$1;->val$kind:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    invoke-interface {v0, v1}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 98
    goto :goto_3

    :goto_2
    throw v2

    :goto_3
    goto :goto_2
.end method
