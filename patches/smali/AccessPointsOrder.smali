.class public final Lcom/google/android/inputmethod/pinyin/AccessPointsOrder;
.super Ljava/lang/Object;
.source "AccessPointsOrder.java"


# static fields
.field private static final PREFERENCES:Ljava/lang/String; = "floating_keyboard_preferences"

.field private static final SHORTCUTS_KEY:Ljava/lang/String; = "shortcuts"


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 24
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 25
    return-void
.end method

.method public static apply(Landroid/content/Context;Ljava/util/List;Ljava/util/Set;)V
    .locals 9
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 34
    if-eqz p0, :cond_f

    if-eqz p1, :cond_f

    invoke-interface {p1}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    goto/16 :goto_5

    .line 36
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/AccessPointsOrder;->readShortcuts(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    .line 37
    if-eqz p0, :cond_e

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_1

    goto/16 :goto_4

    .line 39
    :cond_1
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 40
    new-instance v1, Ljava/util/HashSet;

    invoke-direct {v1}, Ljava/util/HashSet;-><init>()V

    .line 41
    const-string v2, "\\|"

    invoke-virtual {p0, v2}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    array-length v2, p0

    const/4 v3, 0x0

    const/4 v4, 0x0

    :goto_0
    if-ge v4, v2, :cond_6

    aget-object v5, p0, v4

    .line 42
    const-string v6, ":"

    invoke-virtual {v5, v6}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v5

    .line 43
    array-length v6, v5

    const/4 v7, 0x2

    if-eq v6, v7, :cond_2

    goto :goto_1

    .line 44
    :cond_2
    aget-object v6, v5, v3

    .line 45
    invoke-virtual {v6}, Ljava/lang/String;->isEmpty()Z

    move-result v7

    if-eqz v7, :cond_3

    goto :goto_1

    .line 46
    :cond_3
    const-string v7, "1"

    const/4 v8, 0x1

    aget-object v5, v5, v8

    invoke-virtual {v7, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_4

    .line 47
    invoke-interface {v0, v6}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_5

    invoke-interface {v0, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_1

    .line 49
    :cond_4
    invoke-interface {v1, v6}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 41
    :cond_5
    :goto_1
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 52
    :cond_6
    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result p0

    if-eqz p0, :cond_7

    invoke-interface {v1}, Ljava/util/Set;->isEmpty()Z

    move-result p0

    if-eqz p0, :cond_7

    return-void

    .line 54
    :cond_7
    new-instance p0, Ljava/util/ArrayList;

    invoke-direct {p0}, Ljava/util/ArrayList;-><init>()V

    .line 55
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_2
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_9

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    .line 59
    invoke-interface {p0, v3}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_8

    invoke-interface {p0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 60
    :cond_8
    goto :goto_2

    .line 61
    :cond_9
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :cond_a
    :goto_3
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_c

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    .line 62
    invoke-interface {p0, v3}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_a

    invoke-interface {v1, v3}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_b

    goto :goto_3

    .line 63
    :cond_b
    invoke-interface {p0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 64
    goto :goto_3

    .line 66
    :cond_c
    invoke-interface {p1}, Ljava/util/List;->clear()V

    .line 67
    invoke-interface {p1, p0}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 69
    if-eqz p2, :cond_d

    .line 74
    invoke-interface {p2, v1}, Ljava/util/Set;->removeAll(Ljava/util/Collection;)Z

    .line 75
    invoke-interface {p2, v0}, Ljava/util/Set;->addAll(Ljava/util/Collection;)Z

    .line 77
    :cond_d
    return-void

    .line 37
    :cond_e
    :goto_4
    return-void

    .line 34
    :cond_f
    :goto_5
    return-void
.end method

.method private static readFromFile(Landroid/content/Context;)Ljava/lang/String;
    .locals 6

    .line 92
    nop

    .line 94
    const/4 v0, 0x0

    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object p0

    invoke-virtual {p0}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object p0

    .line 95
    new-instance v1, Ljava/io/File;

    const-string v2, "shared_prefs/floating_keyboard_preferences.xml"

    invoke-direct {v1, p0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 96
    invoke-virtual {v1}, Ljava/io/File;->isFile()Z

    move-result p0

    if-nez p0, :cond_0

    .line 111
    nop

    .line 96
    return-object v0

    .line 97
    :cond_0
    new-instance p0, Ljava/io/FileInputStream;

    invoke-direct {p0, v1}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_5

    .line 98
    :try_start_1
    invoke-virtual {v1}, Ljava/io/File;->length()J

    move-result-wide v1

    long-to-int v2, v1

    new-array v1, v2, [B

    .line 99
    invoke-virtual {p0, v1}, Ljava/io/FileInputStream;->read([B)I

    move-result v2
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_4

    .line 100
    if-gtz v2, :cond_1

    .line 111
    nop

    .line 113
    :try_start_2
    invoke-virtual {p0}, Ljava/io/FileInputStream;->close()V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 116
    goto :goto_0

    .line 114
    :catchall_0
    move-exception p0

    .line 100
    :goto_0
    return-object v0

    .line 101
    :cond_1
    :try_start_3
    new-instance v3, Ljava/lang/String;

    const-string v4, "UTF-8"

    const/4 v5, 0x0

    invoke-direct {v3, v1, v5, v2, v4}, Ljava/lang/String;-><init>([BIILjava/lang/String;)V

    .line 102
    const-string v1, "name=\"shortcuts\""

    invoke-virtual {v3, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_4

    .line 103
    if-gez v1, :cond_2

    .line 111
    nop

    .line 113
    :try_start_4
    invoke-virtual {p0}, Ljava/io/FileInputStream;->close()V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    .line 116
    goto :goto_1

    .line 114
    :catchall_1
    move-exception p0

    .line 103
    :goto_1
    return-object v0

    .line 104
    :cond_2
    const/16 v2, 0x3e

    :try_start_5
    invoke-virtual {v3, v2, v1}, Ljava/lang/String;->indexOf(II)I

    move-result v1

    .line 105
    const/16 v2, 0x3c

    invoke-virtual {v3, v2, v1}, Ljava/lang/String;->indexOf(II)I

    move-result v2

    .line 106
    if-ltz v1, :cond_4

    if-gez v2, :cond_3

    goto :goto_3

    .line 107
    :cond_3
    add-int/lit8 v1, v1, 0x1

    invoke-virtual {v3, v1, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_4

    .line 111
    nop

    .line 113
    :try_start_6
    invoke-virtual {p0}, Ljava/io/FileInputStream;->close()V
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_2

    .line 116
    goto :goto_2

    .line 114
    :catchall_2
    move-exception p0

    .line 107
    :goto_2
    return-object v0

    .line 111
    :cond_4
    :goto_3
    nop

    .line 113
    :try_start_7
    invoke-virtual {p0}, Ljava/io/FileInputStream;->close()V
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_3

    .line 116
    goto :goto_4

    .line 114
    :catchall_3
    move-exception p0

    .line 106
    :goto_4
    return-object v0

    .line 108
    :catchall_4
    move-exception v1

    goto :goto_5

    :catchall_5
    move-exception p0

    move-object p0, v0

    .line 109
    :goto_5
    nop

    .line 111
    if-eqz p0, :cond_5

    .line 113
    :try_start_8
    invoke-virtual {p0}, Ljava/io/FileInputStream;->close()V
    :try_end_8
    .catchall {:try_start_8 .. :try_end_8} :catchall_6

    .line 116
    goto :goto_6

    .line 114
    :catchall_6
    move-exception p0

    .line 109
    :cond_5
    :goto_6
    return-object v0
.end method

.method private static readShortcuts(Landroid/content/Context;)Ljava/lang/String;
    .locals 3

    .line 80
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/AccessPointsOrder;->readFromFile(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    .line 81
    if-eqz v0, :cond_0

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_0

    return-object v0

    .line 83
    :cond_0
    const/4 v0, 0x0

    :try_start_0
    const-string v1, "floating_keyboard_preferences"

    const/4 v2, 0x0

    invoke-virtual {p0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v1, "shortcuts"

    .line 84
    invoke-interface {p0, v1, v0}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 83
    return-object p0

    .line 85
    :catchall_0
    move-exception p0

    .line 86
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "shortcut preferences unreadable: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v1, "AccessPointsOrder"

    invoke-static {v1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 87
    return-object v0
.end method
