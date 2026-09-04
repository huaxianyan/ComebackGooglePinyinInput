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

    .line 15
    const-string v0, "UTF-8"

    invoke-static {v0}, Ljava/nio/charset/Charset;->forName(Ljava/lang/String;)Ljava/nio/charset/Charset;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->UTF_8:Ljava/nio/charset/Charset;

    return-void
.end method

.method private constructor <init>(Ljava/util/List;IIIIIILjava/lang/String;)V
    .locals 1
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

    .line 30
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0, p1}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    invoke-static {v0}, Ljava/util/Collections;->unmodifiableList(Ljava/util/List;)Ljava/util/List;

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->entries:Ljava/util/List;

    .line 31
    iput p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->googleAdditionCount:I

    .line 32
    iput p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->googleDeletionCount:I

    .line 33
    iput p4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->rimeAdditionCount:I

    .line 34
    iput p5, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->rimeDeletionCount:I

    .line 35
    iput p6, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->rimeResurrectionCount:I

    .line 36
    iput p7, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->projectedGoogleEntryCount:I

    .line 37
    iput-object p8, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->confirmationToken:Ljava/lang/String;

    .line 38
    return-void
.end method

.method public static build(Ljava/util/Map;Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$BaselineLookup;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;
    .locals 24
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

    .line 44
    move-object/from16 v0, p0

    move-object/from16 v1, p1

    move-object/from16 v2, p2

    if-eqz v0, :cond_11

    if-eqz v1, :cond_11

    if-eqz v2, :cond_11

    .line 47
    new-instance v3, Ljava/util/TreeSet;

    invoke-direct {v3}, Ljava/util/TreeSet;-><init>()V

    .line 48
    invoke-interface {v0}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v4

    invoke-interface {v3, v4}, Ljava/util/Set;->addAll(Ljava/util/Collection;)Z

    .line 49
    iget-object v4, v1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->entries:Ljava/util/Map;

    invoke-interface {v4}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v4

    invoke-interface {v3, v4}, Ljava/util/Set;->addAll(Ljava/util/Collection;)Z

    .line 50
    new-instance v6, Ljava/util/ArrayList;

    invoke-interface {v3}, Ljava/util/Set;->size()I

    move-result v4

    invoke-direct {v6, v4}, Ljava/util/ArrayList;-><init>(I)V

    .line 51
    nop

    .line 52
    nop

    .line 53
    nop

    .line 54
    nop

    .line 55
    nop

    .line 56
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->sha256()Ljava/security/MessageDigest;

    move-result-object v4

    .line 57
    invoke-interface {v3}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v3

    const/4 v7, 0x0

    const/4 v8, 0x0

    const/4 v9, 0x0

    const/4 v10, 0x0

    const/4 v11, 0x0

    :goto_0
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v12

    if-eqz v12, :cond_f

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v12

    move-object v14, v12

    check-cast v14, Ljava/lang/String;

    .line 58
    invoke-interface {v0, v14}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v12

    check-cast v12, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;

    .line 59
    iget-object v13, v1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->entries:Ljava/util/Map;

    invoke-interface {v13, v14}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v13

    check-cast v13, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;

    .line 60
    invoke-interface {v2, v14}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$BaselineLookup;->get(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;

    move-result-object v15

    .line 61
    if-eqz v15, :cond_e

    iget-object v5, v15, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;->history:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    if-eqz v5, :cond_e

    iget-object v5, v15, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;->googleProjection:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    if-eqz v5, :cond_e

    iget v5, v15, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;->rimeAbsCount:I

    if-ltz v5, :cond_e

    .line 65
    if-nez v12, :cond_0

    const/4 v5, 0x0

    goto :goto_1

    :cond_0
    iget-object v5, v12, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;->source:Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;

    iget v5, v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->commits:I

    .line 66
    :goto_1
    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->checkedMagnitude(I)I

    move-result v0

    iget v2, v15, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;->rimeAbsCount:I

    invoke-static {v0, v2}, Ljava/lang/Math;->max(II)I

    move-result v0

    .line 68
    if-nez v12, :cond_1

    .line 69
    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->ABSENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    goto :goto_2

    .line 70
    :cond_1
    if-gez v5, :cond_2

    .line 71
    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->TOMBSTONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    goto :goto_2

    .line 72
    :cond_2
    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;->PRESENT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;

    .line 73
    :goto_2
    iget-object v5, v15, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;->history:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    iget-object v15, v15, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$Baseline;->googleProjection:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    if-eqz v13, :cond_3

    const/16 v16, 0x1

    move-object/from16 v23, v3

    const/4 v3, 0x1

    goto :goto_3

    :cond_3
    move-object/from16 v23, v3

    const/4 v3, 0x0

    :goto_3
    invoke-static {v5, v15, v3, v2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner;->plan(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;ZLcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeState;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;

    move-result-object v2

    .line 76
    if-eqz v12, :cond_4

    iget-object v3, v12, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;->code:Ljava/lang/String;

    goto :goto_4

    :cond_4
    iget-object v3, v13, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->code:Ljava/lang/String;

    :goto_4
    move-object v15, v3

    .line 77
    if-eqz v12, :cond_5

    iget-object v3, v12, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;->phrase:Ljava/lang/String;

    goto :goto_5

    :cond_5
    iget-object v3, v13, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->phrase:Ljava/lang/String;

    :goto_5
    move-object/from16 v16, v3

    .line 79
    iget-object v3, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->DELETE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-eq v3, v5, :cond_8

    iget-object v3, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->RESURRECT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-ne v3, v5, :cond_6

    goto :goto_6

    .line 81
    :cond_6
    iget-object v3, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->ADD:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-ne v3, v5, :cond_7

    .line 82
    const/16 v22, 0x0

    goto :goto_7

    :cond_7
    move/from16 v22, v0

    goto :goto_7

    .line 80
    :cond_8
    :goto_6
    iget v0, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->rimeCommitValue:I

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->checkedMagnitude(I)I

    move-result v0

    move/from16 v22, v0

    .line 83
    :goto_7
    new-instance v13, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;

    iget-object v0, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    iget-object v3, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    iget v5, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->rimeCommitValue:I

    iget-object v12, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->nextHistory:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    move-object/from16 v17, v0

    iget-object v0, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->nextGoogleProjection:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    move-object/from16 v21, v0

    move-object/from16 v18, v3

    move/from16 v19, v5

    move-object/from16 v20, v12

    invoke-direct/range {v13 .. v22}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;ILcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;I)V

    .line 86
    invoke-interface {v6, v13}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 87
    iget-object v0, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->ADD:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    if-ne v0, v3, :cond_9

    add-int/lit8 v7, v7, 0x1

    .line 88
    :cond_9
    iget-object v0, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->DELETE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    if-ne v0, v3, :cond_a

    add-int/lit8 v8, v8, 0x1

    .line 89
    :cond_a
    iget-object v0, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->ADD:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-ne v0, v3, :cond_b

    add-int/lit8 v9, v9, 0x1

    .line 90
    :cond_b
    iget-object v0, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->DELETE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-ne v0, v3, :cond_c

    add-int/lit8 v10, v10, 0x1

    .line 91
    :cond_c
    iget-object v0, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$Plan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->RESURRECT:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-ne v0, v2, :cond_d

    .line 92
    add-int/lit8 v11, v11, 0x1

    .line 94
    :cond_d
    invoke-static {v4, v13}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->updateDigest(Ljava/security/MessageDigest;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;)V

    .line 95
    move-object/from16 v0, p0

    move-object/from16 v2, p2

    move-object/from16 v3, v23

    goto/16 :goto_0

    .line 63
    :cond_e
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "synchronization baseline is invalid"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 96
    :cond_f
    iget v0, v1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->totalEntryCount:I

    sub-int/2addr v0, v8

    add-int v12, v0, v7

    .line 97
    const v0, 0x7a120

    if-gt v12, v0, :cond_10

    .line 101
    new-instance v5, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;

    .line 102
    invoke-virtual {v4}, Ljava/security/MessageDigest;->digest()[B

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->hex([B)Ljava/lang/String;

    move-result-object v13

    invoke-direct/range {v5 .. v13}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;-><init>(Ljava/util/List;IIIIIILjava/lang/String;)V

    .line 101
    return-object v5

    .line 98
    :cond_10
    new-instance v0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$CapacityException;

    iget v1, v1, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Snapshot;->totalEntryCount:I

    invoke-direct {v0, v1, v7, v8}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$CapacityException;-><init>(III)V

    throw v0

    .line 45
    :cond_11
    new-instance v0, Ljava/lang/IllegalArgumentException;

    const-string v1, "synchronization plan inputs are required"

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    goto :goto_9

    :goto_8
    throw v0

    :goto_9
    goto :goto_8
.end method

.method private static checkedMagnitude(I)I
    .locals 1

    .line 133
    const/high16 v0, -0x80000000

    if-eq p0, v0, :cond_0

    .line 136
    invoke-static {p0}, Ljava/lang/Math;->abs(I)I

    move-result p0

    return p0

    .line 134
    :cond_0
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string v0, "Rime commit magnitude cannot be represented"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private static hex([B)Ljava/lang/String;
    .locals 6

    .line 167
    new-instance v0, Ljava/lang/StringBuilder;

    array-length v1, p0

    mul-int/lit8 v1, v1, 0x2

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(I)V

    .line 168
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

    .line 169
    :cond_0
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static sha256()Ljava/security/MessageDigest;
    .locals 3

    .line 141
    :try_start_0
    const-string v0, "SHA-256"

    invoke-static {v0}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    .line 142
    :catch_0
    move-exception v0

    .line 143
    new-instance v1, Ljava/lang/IllegalStateException;

    const-string v2, "SHA-256 is unavailable"

    invoke-direct {v1, v2, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw v1
.end method

.method private static updateDigest(Ljava/security/MessageDigest;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;)V
    .locals 1

    .line 148
    iget-object v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->key:Ljava/lang/String;

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->updateDigest(Ljava/security/MessageDigest;Ljava/lang/String;)V

    .line 149
    iget-object v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->name()Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->updateDigest(Ljava/security/MessageDigest;Ljava/lang/String;)V

    .line 150
    iget-object v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->name()Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->updateDigest(Ljava/security/MessageDigest;Ljava/lang/String;)V

    .line 151
    iget v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->rimeCommitValue:I

    invoke-static {v0}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->updateDigest(Ljava/security/MessageDigest;Ljava/lang/String;)V

    .line 152
    iget-object v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->nextHistory:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$History;->name()Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->updateDigest(Ljava/security/MessageDigest;Ljava/lang/String;)V

    .line 153
    iget-object v0, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->nextGoogleProjection:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleProjection;->name()Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->updateDigest(Ljava/security/MessageDigest;Ljava/lang/String;)V

    .line 154
    iget p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->nextRimeAbsCount:I

    invoke-static {p1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object p1

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->updateDigest(Ljava/security/MessageDigest;Ljava/lang/String;)V

    .line 155
    return-void
.end method

.method private static updateDigest(Ljava/security/MessageDigest;Ljava/lang/String;)V
    .locals 1

    .line 158
    sget-object v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan;->UTF_8:Ljava/nio/charset/Charset;

    invoke-virtual {p1, v0}, Ljava/lang/String;->getBytes(Ljava/nio/charset/Charset;)[B

    move-result-object p1

    .line 159
    array-length v0, p1

    ushr-int/lit8 v0, v0, 0x18

    int-to-byte v0, v0

    invoke-virtual {p0, v0}, Ljava/security/MessageDigest;->update(B)V

    .line 160
    array-length v0, p1

    ushr-int/lit8 v0, v0, 0x10

    int-to-byte v0, v0

    invoke-virtual {p0, v0}, Ljava/security/MessageDigest;->update(B)V

    .line 161
    array-length v0, p1

    ushr-int/lit8 v0, v0, 0x8

    int-to-byte v0, v0

    invoke-virtual {p0, v0}, Ljava/security/MessageDigest;->update(B)V

    .line 162
    array-length v0, p1

    int-to-byte v0, v0

    invoke-virtual {p0, v0}, Ljava/security/MessageDigest;->update(B)V

    .line 163
    invoke-virtual {p0, p1}, Ljava/security/MessageDigest;->update([B)V

    .line 164
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

    .line 110
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 112
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

    .line 113
    iget-object v3, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    sget-object v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    if-eq v3, v4, :cond_0

    .line 114
    new-instance v3, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;

    iget-object v4, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->code:Ljava/lang/String;

    iget-object v5, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->phrase:Ljava/lang/String;

    iget-object v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->googleAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;

    invoke-direct {v3, v4, v5, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;-><init>(Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$GoogleAction;)V

    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 117
    :cond_0
    goto :goto_0

    .line 118
    :cond_1
    return-object v0
.end method

.method public requiresDeletionConfirmation()Z
    .locals 1

    .line 106
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

    .line 122
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 123
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

    .line 124
    iget-object v3, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    sget-object v4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;->NONE:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    if-eq v3, v4, :cond_0

    .line 125
    new-instance v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;

    iget-object v4, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->code:Ljava/lang/String;

    iget-object v5, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->phrase:Ljava/lang/String;

    iget-object v6, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->rimeAction:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;

    iget v2, v2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSessionPlan$EntryPlan;->rimeCommitValue:I

    invoke-direct {v3, v4, v5, v6, v2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$RimeChange;-><init>(Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncPlanner$RimeAction;I)V

    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 128
    :cond_0
    goto :goto_0

    .line 129
    :cond_1
    return-object v0
.end method
