.class public final Lcom/google/android/inputmethod/pinyin/AccessPointsOrder;
.super Ljava/lang/Object;
.source "AccessPointsOrder.java"


# static fields
.field private static final MORE:Ljava/lang/String; = "more_access_points"

.field private static final ONE_HANDED:Ljava/lang/String; = "access_point_one_handed"

.field private static final PREFERENCES:Ljava/lang/String; = "floating_keyboard_preferences"

.field private static final SHORTCUTS_KEY:Ljava/lang/String; = "shortcuts"


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 39
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 40
    return-void
.end method

.method public static apply(Landroid/content/Context;Ljava/util/List;Ljava/util/Set;)V
    .locals 10
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

    .line 49
    if-eqz p0, :cond_12

    if-eqz p1, :cond_12

    invoke-interface {p1}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    goto/16 :goto_6

    .line 51
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->isEnabled(Landroid/content/Context;)Z

    move-result v0

    .line 53
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/AccessPointsOrder;->readShortcuts(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    .line 54
    if-eqz p0, :cond_10

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_1

    goto/16 :goto_5

    .line 59
    :cond_1
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 60
    new-instance v2, Ljava/util/HashSet;

    invoke-direct {v2}, Ljava/util/HashSet;-><init>()V

    .line 61
    const-string v3, "\\|"

    invoke-virtual {p0, v3}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p0

    array-length v3, p0

    const/4 v4, 0x0

    const/4 v5, 0x0

    :goto_0
    if-ge v5, v3, :cond_6

    aget-object v6, p0, v5

    .line 62
    const-string v7, ":"

    invoke-virtual {v6, v7}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v6

    .line 63
    array-length v7, v6

    const/4 v8, 0x2

    if-eq v7, v8, :cond_2

    goto :goto_1

    .line 64
    :cond_2
    aget-object v7, v6, v4

    .line 65
    invoke-virtual {v7}, Ljava/lang/String;->isEmpty()Z

    move-result v8

    if-eqz v8, :cond_3

    goto :goto_1

    .line 66
    :cond_3
    const-string v8, "1"

    const/4 v9, 0x1

    aget-object v6, v6, v9

    invoke-virtual {v8, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_4

    .line 67
    invoke-interface {v1, v7}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v6

    if-nez v6, :cond_5

    invoke-interface {v1, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_1

    .line 69
    :cond_4
    invoke-interface {v2, v7}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 61
    :cond_5
    :goto_1
    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    .line 72
    :cond_6
    invoke-interface {v1}, Ljava/util/List;->isEmpty()Z

    move-result p0

    if-eqz p0, :cond_7

    invoke-interface {v2}, Ljava/util/Set;->isEmpty()Z

    move-result p0

    if-eqz p0, :cond_7

    return-void

    .line 74
    :cond_7
    new-instance p0, Ljava/util/ArrayList;

    invoke-direct {p0}, Ljava/util/ArrayList;-><init>()V

    .line 75
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_2
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_9

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    .line 79
    invoke-interface {p0, v4}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_8

    invoke-interface {p0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 80
    :cond_8
    goto :goto_2

    .line 81
    :cond_9
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_a
    :goto_3
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_c

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    .line 82
    invoke-interface {p0, v4}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_a

    invoke-interface {v2, v4}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_b

    goto :goto_3

    .line 83
    :cond_b
    invoke-interface {p0, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 84
    goto :goto_3

    .line 86
    :cond_c
    invoke-interface {p1}, Ljava/util/List;->clear()V

    .line 87
    invoke-interface {p1, p0}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 89
    if-eqz v0, :cond_d

    .line 90
    invoke-static {p1, p2}, Lcom/google/android/inputmethod/pinyin/AccessPointsOrder;->dropOneHanded(Ljava/util/List;Ljava/util/Set;)V

    .line 91
    invoke-static {p1, p2, v2}, Lcom/google/android/inputmethod/pinyin/AccessPointsOrder;->ensureMoreEntry(Ljava/util/List;Ljava/util/Set;Ljava/util/Set;)V

    goto :goto_4

    .line 92
    :cond_d
    const-string p0, "more_access_points"

    invoke-interface {v1, p0}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_e

    .line 95
    invoke-interface {p1, p0}, Ljava/util/List;->remove(Ljava/lang/Object;)Z

    .line 96
    if-eqz p2, :cond_e

    invoke-interface {p2, p0}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    .line 99
    :cond_e
    :goto_4
    if-eqz p2, :cond_f

    .line 104
    invoke-interface {p2, v2}, Ljava/util/Set;->removeAll(Ljava/util/Collection;)Z

    .line 105
    invoke-interface {p2, v1}, Ljava/util/Set;->addAll(Ljava/util/Collection;)Z

    .line 107
    :cond_f
    return-void

    .line 55
    :cond_10
    :goto_5
    if-eqz v0, :cond_11

    invoke-static {p1, p2}, Lcom/google/android/inputmethod/pinyin/AccessPointsOrder;->dropOneHanded(Ljava/util/List;Ljava/util/Set;)V

    .line 56
    :cond_11
    return-void

    .line 49
    :cond_12
    :goto_6
    return-void
.end method

.method private static dropOneHanded(Ljava/util/List;Ljava/util/Set;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 125
    const-string v0, "access_point_one_handed"

    invoke-interface {p0, v0}, Ljava/util/List;->remove(Ljava/lang/Object;)Z

    .line 126
    if-eqz p1, :cond_0

    invoke-interface {p1, v0}, Ljava/util/Set;->remove(Ljava/lang/Object;)Z

    .line 127
    :cond_0
    return-void
.end method

.method private static ensureMoreEntry(Ljava/util/List;Ljava/util/Set;Ljava/util/Set;)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 118
    const-string v0, "more_access_points"

    invoke-interface {p0, v0}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_2

    invoke-interface {p2, v0}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_0

    goto :goto_0

    .line 119
    :cond_0
    invoke-interface {p0, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 120
    if-eqz p1, :cond_1

    invoke-interface {p1, v0}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 121
    :cond_1
    return-void

    .line 118
    :cond_2
    :goto_0
    return-void
.end method

.method private static readFromFile(Landroid/content/Context;)Ljava/lang/String;
    .locals 6

    .line 142
    nop

    .line 144
    const/4 v0, 0x0

    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object p0

    invoke-virtual {p0}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object p0

    .line 145
    new-instance v1, Ljava/io/File;

    const-string v2, "shared_prefs/floating_keyboard_preferences.xml"

    invoke-direct {v1, p0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    .line 146
    invoke-virtual {v1}, Ljava/io/File;->isFile()Z

    move-result p0

    if-nez p0, :cond_0

    .line 161
    nop

    .line 146
    return-object v0

    .line 147
    :cond_0
    new-instance p0, Ljava/io/FileInputStream;

    invoke-direct {p0, v1}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_5

    .line 148
    :try_start_1
    invoke-virtual {v1}, Ljava/io/File;->length()J

    move-result-wide v1

    long-to-int v2, v1

    new-array v1, v2, [B

    .line 149
    invoke-virtual {p0, v1}, Ljava/io/FileInputStream;->read([B)I

    move-result v2
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_4

    .line 150
    if-gtz v2, :cond_1

    .line 161
    nop

    .line 163
    :try_start_2
    invoke-virtual {p0}, Ljava/io/FileInputStream;->close()V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 166
    goto :goto_0

    .line 164
    :catchall_0
    move-exception p0

    .line 150
    :goto_0
    return-object v0

    .line 151
    :cond_1
    :try_start_3
    new-instance v3, Ljava/lang/String;

    const-string v4, "UTF-8"

    const/4 v5, 0x0

    invoke-direct {v3, v1, v5, v2, v4}, Ljava/lang/String;-><init>([BIILjava/lang/String;)V

    .line 152
    const-string v1, "name=\"shortcuts\""

    invoke-virtual {v3, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_4

    .line 153
    if-gez v1, :cond_2

    .line 161
    nop

    .line 163
    :try_start_4
    invoke-virtual {p0}, Ljava/io/FileInputStream;->close()V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    .line 166
    goto :goto_1

    .line 164
    :catchall_1
    move-exception p0

    .line 153
    :goto_1
    return-object v0

    .line 154
    :cond_2
    const/16 v2, 0x3e

    :try_start_5
    invoke-virtual {v3, v2, v1}, Ljava/lang/String;->indexOf(II)I

    move-result v1

    .line 155
    const/16 v2, 0x3c

    invoke-virtual {v3, v2, v1}, Ljava/lang/String;->indexOf(II)I

    move-result v2

    .line 156
    if-ltz v1, :cond_4

    if-gez v2, :cond_3

    goto :goto_3

    .line 157
    :cond_3
    add-int/lit8 v1, v1, 0x1

    invoke-virtual {v3, v1, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_4

    .line 161
    nop

    .line 163
    :try_start_6
    invoke-virtual {p0}, Ljava/io/FileInputStream;->close()V
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_2

    .line 166
    goto :goto_2

    .line 164
    :catchall_2
    move-exception p0

    .line 157
    :goto_2
    return-object v0

    .line 161
    :cond_4
    :goto_3
    nop

    .line 163
    :try_start_7
    invoke-virtual {p0}, Ljava/io/FileInputStream;->close()V
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_3

    .line 166
    goto :goto_4

    .line 164
    :catchall_3
    move-exception p0

    .line 156
    :goto_4
    return-object v0

    .line 158
    :catchall_4
    move-exception v1

    goto :goto_5

    :catchall_5
    move-exception p0

    move-object p0, v0

    .line 159
    :goto_5
    nop

    .line 161
    if-eqz p0, :cond_5

    .line 163
    :try_start_8
    invoke-virtual {p0}, Ljava/io/FileInputStream;->close()V
    :try_end_8
    .catchall {:try_start_8 .. :try_end_8} :catchall_6

    .line 166
    goto :goto_6

    .line 164
    :catchall_6
    move-exception p0

    .line 159
    :cond_5
    :goto_6
    return-object v0
.end method

.method private static readShortcuts(Landroid/content/Context;)Ljava/lang/String;
    .locals 3

    .line 130
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/AccessPointsOrder;->readFromFile(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    .line 131
    if-eqz v0, :cond_0

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_0

    return-object v0

    .line 133
    :cond_0
    const/4 v0, 0x0

    :try_start_0
    const-string v1, "floating_keyboard_preferences"

    const/4 v2, 0x0

    invoke-virtual {p0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v1, "shortcuts"

    .line 134
    invoke-interface {p0, v1, v0}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 133
    return-object p0

    .line 135
    :catchall_0
    move-exception p0

    .line 136
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

    .line 137
    return-object v0
.end method
