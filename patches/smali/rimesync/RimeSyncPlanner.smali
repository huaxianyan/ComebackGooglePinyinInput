.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner;
.super Ljava/lang/Object;
.source "RimeSyncPlanner.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;
    }
.end annotation


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 53
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static checkedMagnitude(I)I
    .locals 1

    .line 141
    const/high16 v0, -0x80000000

    if-eq p0, v0, :cond_0

    .line 144
    invoke-static {p0}, Ljava/lang/Math;->abs(I)I

    move-result p0

    return p0

    .line 142
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "Rime commit magnitude cannot be represented"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static fromDeleted(ZLcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;
    .locals 8

    .line 121
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->PRESENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    const/4 v1, 0x0

    if-ne p1, v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    .line 122
    :goto_0
    if-nez p0, :cond_1

    if-nez v0, :cond_1

    .line 123
    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->DELETED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    sget-object v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->SUPPORTED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    const/4 v7, 0x0

    invoke-direct/range {v2 .. v7}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V

    return-object v2

    .line 126
    :cond_1
    if-nez p0, :cond_2

    if-eqz v0, :cond_2

    .line 127
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->ADD:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    goto :goto_1

    :cond_2
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    :goto_1
    move-object v3, v0

    .line 128
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    .line 129
    nop

    .line 130
    if-eqz p0, :cond_3

    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->ABSENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    if-ne p1, v2, :cond_3

    .line 131
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->ADD:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    move-object v4, v0

    const/4 v7, 0x0

    goto :goto_2

    .line 132
    :cond_3
    if-eqz p0, :cond_4

    sget-object p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->TOMBSTONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    if-ne p1, p0, :cond_4

    .line 133
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->RESURRECT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    .line 134
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner;->nextMagnitude(I)I

    move-result v1

    move-object v4, v0

    move v7, v1

    goto :goto_2

    .line 136
    :cond_4
    move-object v4, v0

    const/4 v7, 0x0

    :goto_2
    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;

    sget-object v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->PRESENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    sget-object v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->SUPPORTED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    invoke-direct/range {v2 .. v7}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V

    return-object v2
.end method

.method private static fromPresent(ZLcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;
    .locals 8

    .line 105
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->PRESENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    const/4 v1, 0x0

    if-ne p1, v0, :cond_0

    const/4 p1, 0x1

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    .line 106
    :goto_0
    if-eqz p0, :cond_1

    if-eqz p1, :cond_1

    .line 107
    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->PRESENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    sget-object v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->SUPPORTED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    const/4 v7, 0x0

    invoke-direct/range {v2 .. v7}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V

    return-object v2

    .line 110
    :cond_1
    if-eqz p0, :cond_2

    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->DELETE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    goto :goto_1

    :cond_2
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    :goto_1
    move-object v3, v0

    .line 111
    if-nez p0, :cond_3

    if-eqz p1, :cond_3

    .line 112
    sget-object p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->DELETE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    goto :goto_2

    :cond_3
    sget-object p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    :goto_2
    move-object v4, p0

    .line 113
    sget-object p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->DELETE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-ne v4, p0, :cond_4

    .line 114
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner;->nextMagnitude(I)I

    move-result p0

    neg-int v1, p0

    move v7, v1

    goto :goto_3

    :cond_4
    const/4 v7, 0x0

    .line 115
    :goto_3
    new-instance v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;

    sget-object v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->DELETED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    sget-object v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->SUPPORTED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    invoke-direct/range {v2 .. v7}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V

    return-object v2
.end method

.method private static initial(ZLcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;
    .locals 7

    .line 82
    sget-object p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->TOMBSTONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    if-ne p1, p2, :cond_1

    .line 83
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;

    .line 84
    if-eqz p0, :cond_0

    sget-object p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->DELETE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    goto :goto_0

    :cond_0
    sget-object p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    :goto_0
    move-object v1, p0

    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->DELETED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    sget-object v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->SUPPORTED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    const/4 v5, 0x0

    invoke-direct/range {v0 .. v5}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V

    .line 83
    return-object v0

    .line 90
    :cond_1
    if-eqz p0, :cond_2

    sget-object p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->ABSENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    if-ne p1, p2, :cond_2

    .line 91
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->ADD:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->PRESENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    sget-object v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->SUPPORTED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    const/4 v5, 0x0

    invoke-direct/range {v0 .. v5}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V

    return-object v0

    .line 94
    :cond_2
    if-nez p0, :cond_3

    sget-object p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->PRESENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    if-ne p1, p2, :cond_3

    .line 95
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->ADD:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->PRESENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    sget-object v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->SUPPORTED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    const/4 v5, 0x0

    invoke-direct/range {v0 .. v5}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V

    return-object v0

    .line 98
    :cond_3
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    .line 99
    if-eqz p0, :cond_4

    sget-object p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->PRESENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    goto :goto_1

    :cond_4
    sget-object p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->DELETED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    :goto_1
    move-object v4, p0

    sget-object v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->SUPPORTED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    const/4 v6, 0x0

    invoke-direct/range {v1 .. v6}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V

    .line 98
    return-object v1
.end method

.method private static nextMagnitude(I)I
    .locals 1

    .line 148
    const v0, 0x7fffffff

    if-eq p0, v0, :cond_0

    .line 151
    add-int/lit8 p0, p0, 0x1

    return p0

    .line 149
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "Rime commit magnitude is exhausted"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method public static plan(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;ZLcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;
    .locals 7

    .line 61
    if-eqz p0, :cond_4

    if-eqz p1, :cond_4

    if-eqz p3, :cond_4

    .line 64
    invoke-static {p4}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner;->checkedMagnitude(I)I

    move-result p4

    .line 65
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->RIME_ONLY:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    if-ne p1, v0, :cond_1

    if-nez p2, :cond_1

    .line 66
    sget-object p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->PRESENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    if-ne p3, p0, :cond_0

    .line 67
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->PRESENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    sget-object v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->RIME_ONLY:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    const/4 v5, 0x0

    invoke-direct/range {v0 .. v5}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V

    goto :goto_0

    .line 69
    :cond_0
    new-instance v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->DELETED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    sget-object v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->SUPPORTED:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    const/4 v6, 0x0

    invoke-direct/range {v1 .. v6}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;-><init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V

    move-object v0, v1

    .line 66
    :goto_0
    return-object v0

    .line 72
    :cond_1
    sget-object p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->UNKNOWN:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    if-ne p0, p1, :cond_2

    .line 73
    invoke-static {p2, p3, p4}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner;->initial(ZLcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;

    move-result-object p0

    return-object p0

    .line 75
    :cond_2
    sget-object p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->PRESENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    if-ne p0, p1, :cond_3

    .line 76
    invoke-static {p2, p3, p4}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner;->fromPresent(ZLcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;

    move-result-object p0

    return-object p0

    .line 78
    :cond_3
    invoke-static {p2, p3, p4}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner;->fromDeleted(ZLcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;

    move-result-object p0

    return-object p0

    .line 62
    :cond_4
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "synchronization state is required"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method
