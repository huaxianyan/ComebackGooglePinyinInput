.class public final Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderArbiter;
.super Ljava/lang/Object;
.source "HeaderArbiter.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 6
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private higher(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;
    .locals 2

    .line 58
    if-nez p1, :cond_0

    return-object p2

    .line 59
    :cond_0
    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getPriority()I

    move-result v0

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getPriority()I

    move-result v1

    if-le v0, v1, :cond_1

    return-object p2

    .line 60
    :cond_1
    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getPriority()I

    move-result v0

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getPriority()I

    move-result v1

    if-ge v0, v1, :cond_2

    return-object p1

    .line 61
    :cond_2
    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getModuleId()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getModuleId()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->compareTo(Ljava/lang/String;)I

    move-result v0

    .line 62
    if-gez v0, :cond_3

    return-object p2

    .line 63
    :cond_3
    if-lez v0, :cond_4

    return-object p1

    .line 64
    :cond_4
    invoke-virtual {p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getStableId()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getStableId()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->compareTo(Ljava/lang/String;)I

    move-result v0

    if-gez v0, :cond_5

    .line 65
    move-object p1, p2

    goto :goto_0

    :cond_5
    nop

    .line 64
    :goto_0
    return-object p1
.end method


# virtual methods
.method public resolve(Ljava/util/Collection;JJZJ)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;
    .locals 12
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Collection<",
            "Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;",
            ">;JJZJ)",
            "Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;"
        }
    .end annotation

    .line 10
    if-eqz p1, :cond_f

    invoke-interface {p1}, Ljava/util/Collection;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_f

    const-wide/16 v0, 0x0

    cmp-long v2, p2, v0

    if-lez v2, :cond_f

    cmp-long v2, p4, v0

    if-gtz v2, :cond_0

    goto/16 :goto_4

    .line 18
    :cond_0
    nop

    .line 19
    nop

    .line 20
    nop

    .line 21
    invoke-interface {p1}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object p1

    const/4 v0, 0x0

    move-object v1, v0

    move-object v2, v1

    move-object v3, v2

    :cond_1
    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_a

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    .line 22
    if-eqz v4, :cond_1

    invoke-virtual {v4}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getSessionToken()J

    move-result-wide v5

    cmp-long v7, v5, p2

    if-nez v7, :cond_1

    .line 23
    invoke-virtual {v4}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getHeaderToken()J

    move-result-wide v5

    cmp-long v7, v5, p4

    if-eqz v7, :cond_2

    goto :goto_0

    .line 24
    :cond_2
    invoke-virtual {v4}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getPresentationKind()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    move-result-object v5

    sget-object v6, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;->NATIVE_CANDIDATE:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    if-ne v5, v6, :cond_3

    .line 25
    goto :goto_0

    .line 26
    :cond_3
    invoke-virtual {v4}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getPlacement()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    move-result-object v5

    .line 27
    sget-object v6, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->CENTER_CONTENT:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    if-eq v5, v6, :cond_8

    sget-object v6, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->EXCLUSIVE_CONTENT:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    if-ne v5, v6, :cond_4

    goto :goto_1

    .line 30
    :cond_4
    sget-object v6, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->LEADING_ACTION:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    if-ne v5, v6, :cond_5

    .line 31
    invoke-direct {p0, v1, v4}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderArbiter;->higher(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    move-result-object v1

    goto :goto_2

    .line 32
    :cond_5
    sget-object v6, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->TRAILING_ACTION:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    if-ne v5, v6, :cond_6

    .line 33
    invoke-direct {p0, v2, v4}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderArbiter;->higher(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    move-result-object v2

    goto :goto_2

    .line 34
    :cond_6
    sget-object v6, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->PERSISTENT_ACTION:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    if-ne v5, v6, :cond_9

    .line 35
    if-nez v2, :cond_7

    move-object v2, v4

    goto :goto_2

    .line 36
    :cond_7
    invoke-direct {p0, v2, v4}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderArbiter;->higher(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    move-result-object v2

    goto :goto_2

    .line 29
    :cond_8
    :goto_1
    invoke-direct {p0, v3, v4}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderArbiter;->higher(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    move-result-object v3

    .line 38
    :cond_9
    :goto_2
    goto :goto_0

    .line 42
    :cond_a
    if-eqz p6, :cond_b

    .line 43
    new-instance v4, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    const/4 v7, 0x0

    const/4 v8, 0x0

    const/4 v5, 0x1

    const/4 v6, 0x0

    move-wide/from16 v9, p7

    invoke-direct/range {v4 .. v10}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;-><init>(ZLcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;J)V

    return-object v4

    .line 45
    :cond_b
    if-eqz v3, :cond_d

    invoke-virtual {v3}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getPlacement()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    move-result-object p1

    sget-object v4, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->EXCLUSIVE_CONTENT:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    if-eq p1, v4, :cond_c

    .line 46
    invoke-virtual {v3}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->allowsActions()Z

    move-result p1

    if-nez p1, :cond_d

    .line 47
    :cond_c
    nop

    .line 48
    move-object v4, v0

    move-object v5, v4

    goto :goto_3

    .line 50
    :cond_d
    move-object v4, v1

    move-object v5, v2

    :goto_3
    if-nez v3, :cond_e

    if-nez v4, :cond_e

    if-nez v5, :cond_e

    .line 51
    new-instance v5, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    const/4 v8, 0x0

    const/4 v9, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    move-wide/from16 v10, p7

    invoke-direct/range {v5 .. v11}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;-><init>(ZLcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;J)V

    return-object v5

    .line 53
    :cond_e
    new-instance v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    const/4 v2, 0x0

    move-wide/from16 v6, p7

    invoke-direct/range {v1 .. v7}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;-><init>(ZLcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;J)V

    return-object v1

    .line 12
    :cond_f
    :goto_4
    if-eqz p6, :cond_10

    .line 13
    new-instance v5, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    const/4 v8, 0x0

    const/4 v9, 0x0

    const/4 v6, 0x1

    const/4 v7, 0x0

    move-wide/from16 v10, p7

    invoke-direct/range {v5 .. v11}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;-><init>(ZLcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;J)V

    return-object v5

    .line 15
    :cond_10
    new-instance v5, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    const/4 v8, 0x0

    const/4 v9, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    move-wide/from16 v10, p7

    invoke-direct/range {v5 .. v11}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;-><init>(ZLcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;J)V

    return-object v5
.end method
