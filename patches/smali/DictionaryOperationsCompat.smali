.class public final Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;
.super Ljava/lang/Object;

.field private static clearCallback:Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat$ClearCallback;
.field private static clearController:Lbdz;
.field private static clearInProgress:Z
.field private static pendingClearResult:Ljava/lang/Boolean;

.method private constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method private static preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .locals 3

    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;
    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;
    move-result-object v1

    const-string v2, "_preferences"
    invoke-virtual {v1, v2}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1

    const/4 v2, 0x0
    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v0
    return-object v0
.end method

.method public static hasContactsPermission(Landroid/content/Context;)Z
    .locals 2

    const-string v0, "android.permission.READ_CONTACTS"
    invoke-virtual {p0, v0}, Landroid/content/Context;->checkCallingOrSelfPermission(Ljava/lang/String;)I
    move-result v0

    if-nez v0, :denied
    const/4 v1, 0x1
    return v1

    :denied
    const/4 v1, 0x0
    return v1
.end method

.method public static isContactSuggestionsEnabled(Landroid/content/Context;)Z
    .locals 3

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->hasContactsPermission(Landroid/content/Context;)Z
    move-result v0
    if-eqz v0, :disabled

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;
    move-result-object v0

    const-string v1, "import_user_contacts"
    const/4 v2, 0x0
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v0
    return v0

    :disabled
    const/4 v0, 0x0
    return v0
.end method

.method public static setContactSuggestionsEnabled(Landroid/content/Context;Z)Z
    .locals 3

    if-eqz p1, :write
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->hasContactsPermission(Landroid/content/Context;)Z
    move-result v0
    if-nez v0, :write

    const/4 v0, 0x0
    return v0

    :write
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v0

    const-string v1, "import_user_contacts"
    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    move-result-object v0
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    const/4 v2, 0x1
    return v2
.end method

.method public static declared-synchronized isClearInProgress()Z
    .locals 1

    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->clearInProgress:Z
    return v0
.end method

.method public static declared-synchronized setClearCallback(Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat$ClearCallback;)V
    .locals 2

    sput-object p0, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->clearCallback:Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat$ClearCallback;
    if-eqz p0, :done

    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->pendingClearResult:Ljava/lang/Boolean;
    if-eqz v0, :check_running
    const/4 v1, 0x0
    sput-object v1, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->pendingClearResult:Ljava/lang/Boolean;
    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z
    move-result v0
    invoke-interface {p0, v0}, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat$ClearCallback;->onClearFinished(Z)V
    goto :done

    :check_running
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->clearInProgress:Z
    if-eqz v0, :done
    invoke-interface {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat$ClearCallback;->onClearStarted()V

    :done
    return-void
.end method

.method public static declared-synchronized clearClearCallback(Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat$ClearCallback;)V
    .locals 1

    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->clearCallback:Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat$ClearCallback;
    if-ne v0, p0, :done

    const/4 v0, 0x0
    sput-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->clearCallback:Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat$ClearCallback;

    :done
    return-void
.end method

.method public static declared-synchronized startClear(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat$ClearCallback;)Z
    .locals 4

    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->clearInProgress:Z
    if-nez v0, :already_running

    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;
    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;
    move-result-object v1
    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v1
    const-string v2, "sync"
    const/4 v3, 0x0
    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;
    move-result-object v1
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    new-instance v1, Lbdz;
    invoke-direct {v1, v0}, Lbdz;-><init>(Landroid/content/Context;)V

    new-instance v2, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat$ControllerDelegate;
    invoke-direct {v2, v1}, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat$ControllerDelegate;-><init>(Lbdz;)V

    :try_start
    invoke-virtual {v1, v2}, Lbdz;->onCreate(Lcom/google/android/apps/inputmethod/libs/dataservice/preference/IDictionarySyncControllerDelegate;)V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->clearController:Lbdz;
    sput-object p1, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->clearCallback:Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat$ClearCallback;
    const/4 v3, 0x0
    sput-object v3, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->pendingClearResult:Ljava/lang/Boolean;
    const/4 v3, 0x1
    sput-boolean v3, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->clearInProgress:Z

    invoke-virtual {v1}, Lbdz;->startClearUserDict()V
    return v3
    :try_end
    .catch Ljava/lang/RuntimeException; {:try_start .. :try_end} :failed

    :failed
    invoke-virtual {v1}, Lbdz;->onDestroy()V
    const/4 v0, 0x0
    sput-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->clearController:Lbdz;
    sput-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->clearCallback:Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat$ClearCallback;
    const/4 v0, 0x0
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->clearInProgress:Z
    return v0

    :already_running
    const/4 v0, 0x0
    return v0
.end method

.method static declared-synchronized notifyClearStarted()V
    .locals 1

    const/4 v0, 0x1
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->clearInProgress:Z

    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->clearCallback:Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat$ClearCallback;
    if-eqz v0, :done
    invoke-interface {v0}, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat$ClearCallback;->onClearStarted()V

    :done
    return-void
.end method

.method static declared-synchronized notifyClearFinished(Lbdz;Z)V
    .locals 2

    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->clearController:Lbdz;
    if-ne v0, p0, :done

    const/4 v1, 0x0
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->clearInProgress:Z
    const/4 v1, 0x0
    sput-object v1, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->clearController:Lbdz;

    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->clearCallback:Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat$ClearCallback;
    if-nez v0, :deliver
    invoke-static {p1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;
    move-result-object v1
    sput-object v1, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->pendingClearResult:Ljava/lang/Boolean;
    goto :done

    :deliver
    invoke-interface {v0, p1}, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat$ClearCallback;->onClearFinished(Z)V

    :done
    return-void
.end method
