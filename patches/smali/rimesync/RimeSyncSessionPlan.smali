.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;
.super Ljava/lang/Object;
.source "RimeSyncSessionPlan.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$BaselineLookup;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;,
        Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;
    }
.end annotation


# static fields
.field private static final SNAPSHOT_TRUST_FLOOR:I = 0x3e8

.field private static final UTF_8:Ljava/nio/charset/Charset;


# instance fields
.field public final confirmationToken:Ljava/lang/String;

.field public final entries:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;",
            ">;"
        }
    .end annotation
.end field

.field public final googleAdditionCount:I

.field public final googleDeletionCount:I

.field public final projectedGoogleEntryCount:I

.field public final rimeAdditionCount:I

.field public final rimeDeletionCount:I

.field public final rimeResurrectionCount:I


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 13
    const-string v0, "UTF-8"

    invoke-static {v0}, Ljava/nio/charset/Charset;->forName(Ljava/lang/String;)Ljava/nio/charset/Charset;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->UTF_8:Ljava/nio/charset/Charset;

    return-void
.end method

.method private constructor <init>(Ljava/util/List;IIIIIILjava/lang/String;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;",
            ">;IIIIII",
            "Ljava/lang/String;",
            ")V"
        }
    .end annotation

    .line 29
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 31
    invoke-static {p1}, Ljava/util/Collections;->unmodifiableList(Ljava/util/List;)Ljava/util/List;

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->entries:Ljava/util/List;

    .line 32
    iput p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->googleAdditionCount:I

    .line 33
    iput p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->googleDeletionCount:I

    .line 34
    iput p4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->rimeAdditionCount:I

    .line 35
    iput p5, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->rimeDeletionCount:I

    .line 36
    iput p6, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->rimeResurrectionCount:I

    .line 37
    iput p7, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->projectedGoogleEntryCount:I

    .line 38
    iput-object p8, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->confirmationToken:Ljava/lang/String;

    .line 39
    return-void
.end method

.method public static build(Ljava/util/Map;Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$BaselineLookup;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;",
            ">;",
            "Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$BaselineLookup;",
            ")",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 45
    const/4 v0, 0x1

    invoke-static {p0, p1, p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->buildInternal(Ljava/util/Map;Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$BaselineLookup;Z)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    move-result-object p0

    return-object p0
.end method

.method private static buildInternal(Ljava/util/Map;Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$BaselineLookup;Z)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;
    .locals 29
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;",
            ">;",
            "Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$BaselineLookup;",
            "Z)",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 60
    move-object/from16 v0, p0

    move-object/from16 v1, p1

    move-object/from16 v2, p2

    if-eqz v0, :cond_1a

    if-eqz v1, :cond_1a

    if-eqz v2, :cond_1a

    .line 64
    new-instance v3, Ljava/util/ArrayList;

    invoke-interface {v0}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v4

    invoke-direct {v3, v4}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 65
    new-instance v4, Ljava/util/ArrayList;

    iget-object v5, v1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->entries:Ljava/util/Map;

    invoke-interface {v5}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v5

    invoke-direct {v4, v5}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 66
    invoke-static {v3}, Ljava/util/Collections;->sort(Ljava/util/List;)V

    .line 67
    invoke-static {v4}, Ljava/util/Collections;->sort(Ljava/util/List;)V

    .line 68
    if-eqz p3, :cond_0

    .line 69
    new-instance v5, Ljava/util/ArrayList;

    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v6

    invoke-interface {v4}, Ljava/util/List;->size()I

    move-result v7

    add-int/2addr v6, v7

    invoke-direct {v5, v6}, Ljava/util/ArrayList;-><init>(I)V

    move-object v7, v5

    goto :goto_0

    .line 70
    :cond_0
    invoke-static {}, Ljava/util/Collections;->emptyList()Ljava/util/List;

    move-result-object v5

    move-object v7, v5

    .line 71
    :goto_0
    nop

    .line 72
    nop

    .line 73
    nop

    .line 74
    nop

    .line 75
    nop

    .line 76
    nop

    .line 77
    nop

    .line 78
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->sha256()Ljava/security/MessageDigest;

    move-result-object v5

    const/4 v8, 0x0

    const/4 v9, 0x0

    const/4 v10, 0x0

    const/4 v11, 0x0

    const/4 v12, 0x0

    const/4 v13, 0x0

    const/4 v14, 0x0

    .line 79
    :goto_1
    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v15

    if-lt v8, v15, :cond_3

    invoke-interface {v4}, Ljava/util/List;->size()I

    move-result v15

    if-ge v9, v15, :cond_1

    goto :goto_2

    .line 134
    :cond_1
    iget v0, v1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->totalEntryCount:I

    sub-int/2addr v0, v10

    add-int/2addr v0, v11

    .line 135
    const v2, 0x7a120

    if-gt v0, v2, :cond_2

    .line 139
    new-instance v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    .line 140
    invoke-virtual {v5}, Ljava/security/MessageDigest;->digest()[B

    move-result-object v1

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->hex([B)Ljava/lang/String;

    move-result-object v1

    move v9, v10

    move v8, v11

    move v10, v12

    move v11, v13

    move v12, v14

    move v13, v0

    move-object v14, v1

    invoke-direct/range {v6 .. v14}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;-><init>(Ljava/util/List;IIIIIILjava/lang/String;)V

    .line 139
    return-object v6

    .line 136
    :cond_2
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$CapacityException;

    iget v1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->totalEntryCount:I

    invoke-direct {v0, v1, v11, v10}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$CapacityException;-><init>(III)V

    throw v0

    .line 80
    :cond_3
    :goto_2
    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v15

    const/16 v16, 0x0

    if-ge v8, v15, :cond_4

    invoke-interface {v3, v8}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v15

    check-cast v15, Ljava/lang/String;

    goto :goto_3

    :cond_4
    move-object/from16 v15, v16

    .line 81
    :goto_3
    invoke-interface {v4}, Ljava/util/List;->size()I

    move-result v6

    if-ge v9, v6, :cond_5

    .line 82
    invoke-interface {v4, v9}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v6

    move-object/from16 v16, v6

    check-cast v16, Ljava/lang/String;

    goto :goto_4

    :cond_5
    nop

    :goto_4
    move-object/from16 v6, v16

    .line 84
    if-eqz v6, :cond_9

    if-eqz v15, :cond_6

    invoke-virtual {v15, v6}, Ljava/lang/String;->compareTo(Ljava/lang/String;)I

    move-result v16

    if-gez v16, :cond_6

    goto :goto_6

    .line 87
    :cond_6
    if-eqz v15, :cond_8

    invoke-virtual {v6, v15}, Ljava/lang/String;->compareTo(Ljava/lang/String;)I

    move-result v16

    if-gez v16, :cond_7

    goto :goto_5

    .line 91
    :cond_7
    nop

    .line 92
    add-int/lit8 v8, v8, 0x1

    .line 93
    add-int/lit8 v9, v9, 0x1

    goto :goto_7

    .line 88
    :cond_8
    :goto_5
    nop

    .line 89
    add-int/lit8 v9, v9, 0x1

    move-object v15, v6

    goto :goto_7

    .line 85
    :cond_9
    :goto_6
    nop

    .line 86
    add-int/lit8 v8, v8, 0x1

    .line 95
    :goto_7
    invoke-interface {v0, v15}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;

    .line 96
    iget-object v0, v1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->entries:Ljava/util/Map;

    invoke-interface {v0, v15}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;

    .line 97
    invoke-interface {v2, v15}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$BaselineLookup;->get(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;

    move-result-object v1

    .line 98
    if-eqz v1, :cond_19

    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;->history:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    if-eqz v2, :cond_19

    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;->googleProjection:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    if-eqz v2, :cond_19

    iget v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;->rimeAbsCount:I

    if-ltz v2, :cond_19

    .line 102
    if-nez v6, :cond_a

    const/4 v2, 0x0

    goto :goto_8

    :cond_a
    iget v2, v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;->commits:I

    .line 103
    :goto_8
    move/from16 v16, v2

    invoke-static/range {v16 .. v16}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->checkedMagnitude(I)I

    move-result v2

    move-object/from16 v27, v3

    iget v3, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;->rimeAbsCount:I

    invoke-static {v2, v3}, Ljava/lang/Math;->max(II)I

    move-result v2

    .line 105
    if-nez v6, :cond_b

    .line 106
    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->ABSENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    goto :goto_9

    .line 107
    :cond_b
    if-gez v16, :cond_c

    .line 108
    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->TOMBSTONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    goto :goto_9

    .line 109
    :cond_c
    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->PRESENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    .line 110
    :goto_9
    move-object/from16 v16, v4

    iget-object v4, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;->history:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    iget-object v1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;->googleProjection:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    if-eqz v0, :cond_d

    const/16 v17, 0x1

    move/from16 v28, v8

    const/4 v8, 0x1

    goto :goto_a

    :cond_d
    move/from16 v28, v8

    const/4 v8, 0x0

    :goto_a
    invoke-static {v4, v1, v8, v3, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner;->plan(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;ZLcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;

    move-result-object v1

    .line 114
    iget-object v3, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->DELETE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-eq v3, v4, :cond_10

    iget-object v3, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->RESURRECT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-ne v3, v4, :cond_e

    goto :goto_b

    .line 116
    :cond_e
    iget-object v3, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->ADD:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-ne v3, v4, :cond_f

    .line 117
    const/16 v26, 0x0

    goto :goto_c

    :cond_f
    move/from16 v26, v2

    goto :goto_c

    .line 115
    :cond_10
    :goto_b
    iget v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->rimeCommitValue:I

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->checkedMagnitude(I)I

    move-result v2

    move/from16 v26, v2

    .line 118
    :goto_c
    if-eqz p3, :cond_13

    .line 119
    if-eqz v6, :cond_11

    iget-object v2, v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;->code:Ljava/lang/String;

    goto :goto_d

    :cond_11
    iget-object v2, v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->code:Ljava/lang/String;

    :goto_d
    move-object/from16 v19, v2

    .line 120
    if-eqz v6, :cond_12

    iget-object v0, v6, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;->phrase:Ljava/lang/String;

    goto :goto_e

    :cond_12
    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->phrase:Ljava/lang/String;

    :goto_e
    move-object/from16 v20, v0

    .line 121
    new-instance v17, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;

    iget-object v0, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    iget-object v2, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    iget v3, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->rimeCommitValue:I

    iget-object v4, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->nextHistory:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    iget-object v6, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->nextGoogleProjection:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    move-object/from16 v21, v0

    move-object/from16 v22, v2

    move/from16 v23, v3

    move-object/from16 v24, v4

    move-object/from16 v25, v6

    move-object/from16 v18, v15

    invoke-direct/range {v17 .. v26}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;ILcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V

    move-object/from16 v0, v17

    move/from16 v2, v26

    invoke-interface {v7, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_f

    .line 118
    :cond_13
    move/from16 v2, v26

    .line 125
    :goto_f
    iget-object v0, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->ADD:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    if-ne v0, v3, :cond_14

    add-int/lit8 v11, v11, 0x1

    .line 126
    :cond_14
    iget-object v0, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->DELETE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    if-ne v0, v3, :cond_15

    add-int/lit8 v10, v10, 0x1

    .line 127
    :cond_15
    iget-object v0, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->ADD:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-ne v0, v3, :cond_16

    add-int/lit8 v12, v12, 0x1

    .line 128
    :cond_16
    iget-object v0, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->DELETE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-ne v0, v3, :cond_17

    add-int/lit8 v13, v13, 0x1

    .line 129
    :cond_17
    iget-object v0, v1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->RESURRECT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-ne v0, v3, :cond_18

    .line 130
    add-int/lit8 v14, v14, 0x1

    .line 132
    :cond_18
    invoke-static {v5, v15, v1, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->updateDigest(Ljava/security/MessageDigest;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;I)V

    .line 133
    move-object/from16 v0, p0

    move-object/from16 v1, p1

    move-object/from16 v2, p2

    move-object/from16 v4, v16

    move-object/from16 v3, v27

    move/from16 v8, v28

    goto/16 :goto_1

    .line 100
    :cond_19
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "synchronization baseline is invalid"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 61
    :cond_1a
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "synchronization plan inputs are required"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    goto :goto_11

    :goto_10
    throw v0

    :goto_11
    goto :goto_10
.end method

.method public static buildPreview(Ljava/util/Map;Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$BaselineLookup;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;",
            ">;",
            "Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$BaselineLookup;",
            ")",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 53
    const/4 v0, 0x0

    invoke-static {p0, p1, p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->buildInternal(Ljava/util/Map;Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$BaselineLookup;Z)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    move-result-object p0

    return-object p0
.end method

.method private static checkedMagnitude(I)I
    .locals 1

    .line 180
    const/high16 v0, -0x80000000

    if-eq p0, v0, :cond_0

    .line 183
    invoke-static {p0}, Ljava/lang/Math;->abs(I)I

    move-result p0

    return p0

    .line 181
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "Rime commit magnitude cannot be represented"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static hex([B)Ljava/lang/String;
    .locals 6

    .line 215
    new-instance v0, Ljava/lang/StringBuilder;

    array-length v1, p0

    mul-int/lit8 v1, v1, 0x2

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(I)V

    .line 216
    array-length v1, p0

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v1, :cond_0

    aget-byte v4, p0, v3

    and-int/lit16 v4, v4, 0xff

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    const/4 v5, 0x1

    new-array v5, v5, [Ljava/lang/Object;

    aput-object v4, v5, v2

    const-string v4, "%02x"

    invoke-static {v4, v5}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 217
    :cond_0
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static isCollapsed(II)Z
    .locals 1

    .line 149
    const/16 v0, 0x3e8

    if-lt p0, v0, :cond_0

    div-int/lit8 p0, p0, 0x2

    if-ge p1, p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static sha256()Ljava/security/MessageDigest;
    .locals 3

    .line 188
    :try_start_0
    const-string v0, "SHA-256"

    invoke-static {v0}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    .line 189
    :catch_0
    move-exception v0

    .line 190
    new-instance v1, Ljava/lang/IllegalStateException;

    const-string v2, "SHA-256 is unavailable"

    invoke-direct {v1, v2, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw v1
.end method

.method private static updateDigest(Ljava/security/MessageDigest;Ljava/lang/String;)V
    .locals 1

    .line 206
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p1, v0}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p1

    .line 207
    array-length v0, p1

    ushr-int/lit8 v0, v0, 0x18

    int-to-byte v0, v0

    invoke-virtual {p0, v0}, Ljava/security/MessageDigest;->update(B)V

    .line 208
    array-length v0, p1

    ushr-int/lit8 v0, v0, 0x10

    int-to-byte v0, v0

    invoke-virtual {p0, v0}, Ljava/security/MessageDigest;->update(B)V

    .line 209
    array-length v0, p1

    ushr-int/lit8 v0, v0, 0x8

    int-to-byte v0, v0

    invoke-virtual {p0, v0}, Ljava/security/MessageDigest;->update(B)V

    .line 210
    array-length v0, p1

    int-to-byte v0, v0

    invoke-virtual {p0, v0}, Ljava/security/MessageDigest;->update(B)V

    .line 211
    invoke-virtual {p0, p1}, Ljava/security/MessageDigest;->update([B)V

    .line 212
    return-void
.end method

.method private static updateDigest(Ljava/security/MessageDigest;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;I)V
    .locals 0

    .line 196
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->updateDigest(Ljava/security/MessageDigest;Ljava/lang/String;)V

    .line 197
    iget-object p1, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->name()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->updateDigest(Ljava/security/MessageDigest;Ljava/lang/String;)V

    .line 198
    iget-object p1, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->name()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->updateDigest(Ljava/security/MessageDigest;Ljava/lang/String;)V

    .line 199
    iget p1, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->rimeCommitValue:I

    invoke-static {p1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->updateDigest(Ljava/security/MessageDigest;Ljava/lang/String;)V

    .line 200
    iget-object p1, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->nextHistory:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->name()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->updateDigest(Ljava/security/MessageDigest;Ljava/lang/String;)V

    .line 201
    iget-object p1, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->nextGoogleProjection:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->name()Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->updateDigest(Ljava/security/MessageDigest;Ljava/lang/String;)V

    .line 202
    invoke-static {p3}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->updateDigest(Ljava/security/MessageDigest;Ljava/lang/String;)V

    .line 203
    return-void
.end method


# virtual methods
.method public googleChanges()Ljava/util/List;
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;",
            ">;"
        }
    .end annotation

    .line 157
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 159
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->entries:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;

    .line 160
    iget-object v3, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    if-eq v3, v4, :cond_0

    .line 161
    new-instance v3, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;

    iget-object v4, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->code:Ljava/lang/String;

    iget-object v5, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->phrase:Ljava/lang/String;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    invoke-direct {v3, v4, v5, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;-><init>(Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;)V

    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 164
    :cond_0
    goto :goto_0

    .line 165
    :cond_1
    return-object v0
.end method

.method public requiresDeletionConfirmation()Z
    .locals 1

    .line 153
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->googleDeletionCount:I

    if-gtz v0, :cond_1

    iget v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->rimeDeletionCount:I

    if-lez v0, :cond_0

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 v0, 0x1

    :goto_1
    return v0
.end method

.method public rimeChanges()Ljava/util/List;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;",
            ">;"
        }
    .end annotation

    .line 169
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 170
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->entries:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;

    .line 171
    iget-object v3, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-eq v3, v4, :cond_0

    .line 172
    new-instance v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;

    iget-object v4, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->code:Ljava/lang/String;

    iget-object v5, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->phrase:Ljava/lang/String;

    iget-object v6, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    iget v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->rimeCommitValue:I

    invoke-direct {v3, v4, v5, v6, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;-><init>(Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;I)V

    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 175
    :cond_0
    goto :goto_0

    .line 176
    :cond_1
    return-object v0
.end method
