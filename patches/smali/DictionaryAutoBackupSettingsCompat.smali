.class public final Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupSettingsCompat.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;
    }
.end annotation


# static fields
.field private static final CONTROLLERS:Ljava/util/Map;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Map<",
            "Landroid/preference/PreferenceFragment;",
            "Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;",
            ">;"
        }
    .end annotation
.end field

.field private static final KEY_LOCATION:Ljava/lang/String; = "dictionary_auto_backup_location"

.field private static final PICK_ENABLE:I = 0x1

.field private static final PICK_IMPORT:I = 0x2

.field private static final PICK_LOCATION:I = 0x0

.field private static final REQUEST_TREE:I = 0x6b01


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 33
    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 36
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static bind(Landroid/preference/PreferenceFragment;)V
    .locals 3

    .line 39
    if-eqz p0, :cond_2

    invoke-virtual {p0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 40
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    monitor-enter v0

    .line 41
    :try_start_0
    sget-object v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    invoke-interface {v1, p0}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

    .line 42
    if-eqz v1, :cond_1

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->destroy()V

    .line 43
    :cond_1
    new-instance v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

    invoke-direct {v1, p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;-><init>(Landroid/preference/PreferenceFragment;)V

    .line 44
    sget-object v2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    invoke-interface {v2, p0, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 45
    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->bind()V

    .line 46
    monitor-exit v0

    .line 47
    return-void

    .line 46
    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0

    .line 39
    :cond_2
    :goto_0
    return-void
.end method

.method public static handleActivityResult(Landroid/preference/PreferenceFragment;IILandroid/content/Intent;)Z
    .locals 1

    .line 51
    const/16 v0, 0x6b01

    if-eq p1, v0, :cond_0

    const/4 p0, 0x0

    return p0

    .line 53
    :cond_0
    sget-object p1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    monitor-enter p1

    :try_start_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    invoke-interface {v0, p0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

    monitor-exit p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 54
    if-eqz p0, :cond_1

    invoke-virtual {p0, p2, p3}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->onTreeResult(ILandroid/content/Intent;)V

    .line 55
    :cond_1
    const/4 p0, 0x1

    return p0

    .line 53
    :catchall_0
    move-exception p0

    :try_start_1
    monitor-exit p1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method public static handleRequestPermissionsResult(Landroid/preference/PreferenceFragment;I[Ljava/lang/String;[I)Z
    .locals 0

    .line 60
    const/4 p0, 0x0

    return p0
.end method

.method public static refresh(Landroid/preference/PreferenceFragment;)V
    .locals 2

    .line 65
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    monitor-enter v0

    :try_start_0
    sget-object v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    invoke-interface {v1, p0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 66
    if-eqz p0, :cond_0

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    .line 67
    :cond_0
    return-void

    .line 65
    :catchall_0
    move-exception p0

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method static refreshAll()V
    .locals 3

    .line 78
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    monitor-enter v0

    .line 79
    :try_start_0
    new-instance v1, Ljava/util/ArrayList;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    invoke-interface {v2}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 80
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 81
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->refresh()V

    goto :goto_0

    .line 82
    :cond_0
    return-void

    .line 80
    :catchall_0
    move-exception v1

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_2

    :goto_1
    throw v1

    :goto_2
    goto :goto_1
.end method

.method public static unbind(Landroid/preference/PreferenceFragment;)V
    .locals 2

    .line 70
    sget-object v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    monitor-enter v0

    .line 71
    :try_start_0
    sget-object v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat;->CONTROLLERS:Ljava/util/Map;

    invoke-interface {v1, p0}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

    .line 72
    if-eqz p0, :cond_0

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->destroy()V

    .line 73
    :cond_0
    monitor-exit v0

    .line 74
    return-void

    .line 73
    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method
